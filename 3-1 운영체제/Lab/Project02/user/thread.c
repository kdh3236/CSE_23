#include "thread.h"
#include "user/user.h"
#include "kernel/types.h"
#include "kernel/riscv.h"

int 
thread_create(void (*start_routine)(void*, void*), void *arg1, void* arg2)
{
    int tid;

    void *stack = malloc(2 * PGSIZE);
    if (stack == 0) return -1;
    
    if ((tid = clone(start_routine, arg1, arg2, stack)) < 0) {
        free(stack);
        return -1;
    }
    
    return tid;
}

int 
thread_join()
{   
    int tid;
    void *stack;
    
    if ((tid = join(&stack)) < 0) {
        return -1;
    }

    free(stack);
    return tid;
}

