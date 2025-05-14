#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define NUM_LOOP 100000
#define NUM_THREAD 4
#define MAX_LEVEL 3

int parent;
int fcfs_pids[NUM_THREAD];
int fcfs_count[100] = {0};

int fork_children()
{
  int i, p;
  for (i = 0; i < NUM_THREAD; i++) {
    if ((p = fork()) == 0) {
      return getpid();
    } 
  }
  return parent;
}

void exit_children()
{
  if (getpid() != parent)
    exit(0);
  int status;
  while (wait(&status) != -1);
}

int main(int argc, char *argv[])
{
  int i, pid;
  int count[MAX_LEVEL] = {0};

  parent = getpid();

  printf("FCFS & MLFQ test start\n\n");

  // [Test 1] FCFS test
  printf("[Test 1] FCFS Queue Execution Order\n");
  pid = fork_children();

  if (pid != parent)
  {
    while(fcfs_count[pid] < NUM_LOOP)
    {
      fcfs_count[pid]++;
    }

    printf("Process %d executed %d times\n", pid, fcfs_count[pid]);
  }
  exit_children();
  printf("[Test 1] FCFS Test Finished\n\n");

  // Switch to FCFS mode - should not be changed
  if(fcfsmode() == 0) printf("successfully changed to FCFS mode!\n");
  else printf("nothing has been changed\n");

  // Switch to MLFQ mode
  if(mlfqmode() == 0) printf("successfully changed to MLFQ mode!\n");
  else printf("nothing has been changed\n");

  // [Test 2] MLFQ test
  printf("\n[Test 2] MLFQ Scheduling\n");
  pid = fork_children();

  if (pid != parent)
  {
    for (i = 0; i < NUM_LOOP; i++)
    {
      int x = getlev();
      if (x < 0 || x >= MAX_LEVEL)
      {
        printf("Wrong level: %d\n", x);
        exit(1);
      }
      count[x]++;
    }
    printf("Checking level's hit count...\n");

    printf("Process %d (MLFQ L0-L2 hit count):\n", pid);
    for (i = 0; i < MAX_LEVEL; i++)
      printf("L%d: %d\n", i, count[i]);
  }
  exit_children();

  printf("[Test 2] MLFQ Test Finished\n");
  printf("\nFCFS & MLFQ test completed!\n");
  exit(0);
}