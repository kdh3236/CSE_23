/* 
    (c)splab. ELE3021(OS) Project02 Testcode
*/

#include "kernel/types.h"
#include "user/user.h"
#include "user/thread.h"

#define NUM_THREAD 5
int threads[NUM_THREAD];

int status; // for test#1, test#3
int expected[NUM_THREAD]; // for test#2

// test#1
void
thread_basic(void *arg1, void *arg2)
{
    uint64 num = (uint64)arg1;
    printf("Thread %lu start\n", num);
    if (num == 0) {
        sleep(20);
        status = 1;
    }
    printf("Thread %lu end\n", num);
    exit(0);
}

// test#2
void
thread_inc(void *arg1, void *arg2)
{
    int i;
    uint64 num = (uint64)arg1;
    uint64 iter = (uint64)arg2;
    printf("Thread %lu start, iter=%lu\n", num, iter);
    for (i = 0; i < iter; i++) {
        expected[num]++;
    }
    printf("Thread %lu end\n", num);
    exit(0);
}

// test#3
void
thread_fork(void *arg1, void *arg2)
{
    uint64 num = (uint64)arg1;
    int pid;

    printf("Thread %lu start\n", num);
    pid = fork();
    if (pid < 0) {
        printf("Fork error on thread %lu\n", num);
        exit(1);
    }

    if (pid == 0) {
        printf("Child of thread %lu start\n", num);
        sleep(10);
        status = 3;
        printf("Child of thread %lu end\n", num);
        exit(0);
    }
    else {
        sleep(3);
        status = 2;
        if (wait(0) == -1) {
            printf("Thread %lu lost their child\n", num);
            exit(1);
        }
    }
    printf("Thread %lu end\n", num);
    exit(0);
}

// test#4
int *ptr;

void
thread_sbrk(void *arg1, void *arg2)
{
    uint64 num = (uint64)arg1;
    char *old_break = sbrk(0);

    // Global memory allocation
    if (num == 0) {
        printf("Thread %lu sbrk: old break = %p\n", num, old_break);
        ptr = (int *)malloc(4096 * 4 * NUM_THREAD);
        printf("Thread %lu sbrk: increased break by %x\nnew break = %p\n", num, 4096 * 4 * NUM_THREAD, sbrk(0));
        sleep(50);
        printf("Thread %lu sbrk: free memory\n", num);
        free(ptr);
        ptr = 0;
    }
    else {
        while (ptr == 0) {
            sleep(1);
        }
        printf("Thread %lu size = %p\n", num, sbrk(0));
        for (int i = 0; i < 4096; i++) {
            ptr[num*4096 + i] = num;
        }
    }

    while (ptr != 0) {
        sleep(1);
    }

    // Local memory allocation
    for (int i = 0; i < 1000; i++) {
        int *p = (int *)malloc(4096);
        if (p == 0) {
            printf("Thread %lu malloc failed\n", num);
            exit(1);
        }
        for (int j = 0; j < 4096 / sizeof(int); j++) {
            p[j] = num;
        }
        for (int j = 0; j < 4096 / sizeof(int); j++) {
            if (p[j] != num) {
                printf("Thread %lu found %d\n", num, p[j]);
                exit(1);
            }
        }
        free(p);
    }
    printf("Thread %lu end\n", num);
    exit(0);
}

// test#5
void
thread_kill(void *arg1, void *arg2)
{
    uint64 num = (uint64)arg1;
    uint64 pid = (uint64)arg2;
    printf("Thread %lu start, pid %lu\n", num, pid);
    if (num == 0) {
        sleep(1);
        kill(pid);
    }
    else {
        while(1);
    }
    printf("Thread %lu end\n", num);
    exit(0);
}

// test#6
void
thread_exec(void *arg1, void *arg2)
{
    uint64 num = (uint64)arg1;
    printf("Thread %lu start\n", num);
    if (num == 0) {
        sleep(1);
        char *pname = "/thread_fcn";
        char *args[3] = {pname, "0", 0};
        printf("Executing...\n");
        exec(pname, args);
    }
    else {
        sleep(20);
    }
    printf("Thread %lu end\n", num);
    exit(0);
}

int
main(int argc, char *argv[])
{
    int i;
    int pid;
    
    printf("\n[TEST#1]\n");
    for (i = 0; i < NUM_THREAD; i++) {
        threads[i] = thread_create(thread_basic, (void *)(uint64)i, 0);
    }

    for (i = 0; i < NUM_THREAD; i++) {
        int ret = thread_join();
        if (ret < 0) {
            printf("Thread %d join failed\n", i);
            exit(1);
        }
    }

    if (status != 1) {
        printf("TEST#1 Failed\n");
        exit(1);
    }
    printf("TEST#1 Passed\n");
    
    printf("\n[TEST#2]\n");
    for (i = 0; i < NUM_THREAD; i++) {
        threads[i] = thread_create(thread_inc, (void *)(uint64)i, (void *)(uint64)(i * 1000));
    }

    for (i = 0; i < NUM_THREAD; i++) {
        int ret = thread_join();
        if (ret < 0) {
            printf("Thread %d join failed\n", i);
            exit(1);
        }
    }

    for (i = 0; i < NUM_THREAD; i++) {
        if (expected[i] != i * 1000) {
            printf("Thread %d expected %d, but got %d\n", i, i * 1000, expected[i]);
            exit(1);
        }
    }
    printf("TEST#2 Passed\n");
    
    printf("\n[TEST#3]\n");
    for (i = 0; i < NUM_THREAD; i++) {
        threads[i] = thread_create(thread_fork, (void *)(uint64)i, 0);
    }
    for (i = 0; i < NUM_THREAD; i++) {
        int ret = thread_join();
        if (ret < 0) {
            printf("Thread %d join failed\n", i);
            exit(1);
        }
    }
    if (status != 2) {
        if (status == 3) {
            printf("TEST#3 Failed: Child process referenced parent's memory\n");
        }
        else {
            printf("TEST#3 Failed: Unexpected status %d\n", status);
        }
        exit(1);
    }
    printf("TEST#3 Passed\n");
    
    printf("\n[TEST#4]\n");
    for (i = 0; i < NUM_THREAD; i++) {
        threads[i] = thread_create(thread_sbrk, (void *)(uint64)i, (void *)(uint64)0);
    }
    for (i = 0; i < NUM_THREAD; i++) {
        int ret = thread_join();
        if (ret < 0) {
            printf("Thread %d join failed\n", i);
            exit(1);
        }
    }

    printf("TEST#4 Passed\n");
    
    printf("\n[TEST#5]\n");

    pid = fork();
    if (pid < 0) {
        printf("Fork error\n");
        exit(1);
    } else if (pid == 0) {
        for (i = 0; i < NUM_THREAD; i++) {
            threads[i] = thread_create(thread_kill, (void *)(uint64)i, (void *)(uint64)getpid());
        }
        for (i = 0; i < NUM_THREAD; i++) {
            int ret = thread_join();
            if (ret < 0) {
                printf("Thread %d join failed\n", i);
                exit(1);
            }
        }
    } else {
        sleep(30);
        wait(0);
    }

    printf("TEST#5 Passed\n");
    
    printf("\n[TEST#6]\n");
    pid = fork();

    if (pid < 0) {
        printf("Fork error\n");
        exit(1);
    } else if (pid == 0) {
        for (i = 0; i < NUM_THREAD; i++) {
            threads[i] = thread_create(thread_exec, (void *)(uint64)i, (void *)(uint64)0);
        }
        for (i = 0; i < NUM_THREAD; i++) {
            int ret = thread_join();
            if (ret < 0) {
                printf("Thread %d join failed\n", i);
                exit(1);
            }
        }
    } else {
        sleep(30);
        wait(0);
    }

    printf("TEST#6 Passed\n");

    printf("\nAll tests passed. Great job!!\n");
    
    return 0;
}