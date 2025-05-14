#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

struct cpu cpus[NCPU];

struct proc proc[NPROC];
struct fcfs fcfs;
struct mlfq mlfq; 
struct spinlock queuelock; // queue에 동시 접근하지 못 하도록 막아야 한다.
struct spinlock modelock;


struct proc *initproc;

int nextpid = 1;
struct spinlock pid_lock;

int checkmode = 0; // 0 for FCFS, 1 for MLFQ
int global_tick_count = 0;

extern void forkret(void);
static void freeproc(struct proc *p);

extern char trampoline[]; // trampoline.S

// helps ensure that wakeups of wait()ing
// parents are not lost. helps obey the
// memory model when using p->parent.
// must be acquired before any p->lock.
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void queue_init(struct queue* q) {
  acquire(&queuelock);
  q->front = 0;
  q->rear = 0;
  q->num = 0;

  for (int i = 0; i < NPROC; i++) { // queue 초기화
    q->q[i] = 0;  
  }
  release(&queuelock);
}

int queue_full(struct queue* q) {
  int result = 0;
  acquire(&queuelock);
  if (q->num == NPROC) result = 1;
  release(&queuelock);
  return result;
}

int queue_empty(struct queue* q) {
  int result = 0;
  acquire(&queuelock);
  if (q->num == 0) result = 1;
  release(&queuelock);
  return result;
}

struct proc* queue_pop(struct queue* q) {
  acquire(&queuelock);
  int temp = q->front;
  q->front = (q->front + 1) % NPROC;
  q->num--;
  release(&queuelock);

  return q->q[temp];  
}

void queue_push(struct queue* q, struct proc* p) {
  acquire(&queuelock);
  q->q[q->rear] = p;
  q->num++;
  q->rear = (q->rear + 1) % NPROC;
  release(&queuelock);
} 

void fcfs_init(void) {
  queue_init(&fcfs.entry);
}

int fcfs_full(void) {
  return queue_full(&fcfs.entry);
}

int fcfs_empty(void) {
  return queue_empty(&fcfs.entry);
}

struct proc* fcfs_pop(void) {
  return queue_pop(&fcfs.entry);
}

void fcfs_push(struct proc* p) {
  if (p->state == RUNNABLE) queue_push(&fcfs.entry, p);
}

void mlfq_init(void) {
  for (int i = 0; i < 3; i++) {
    queue_init(&mlfq.entry[i]);
  }
}

int mlfq_full(int level) {
  return queue_full(&mlfq.entry[level]);
}

int mlfq_empty(int level) {
  return queue_empty(&mlfq.entry[level]);
}

struct proc* mlfq_pop(int level) {
  return queue_pop(&mlfq.entry[level]);
}

void mlfq_push(int level, struct proc* p) {
  if (p->state == RUNNABLE) queue_push(&mlfq.entry[level], p);
}

void
proc_mapstacks(pagetable_t kpgtbl)
{
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
  }
}

// initialize the proc table.
void
procinit(void)
{
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
  initlock(&wait_lock, "wait_lock");
  initlock(&queuelock, "queue_lock"); // 처음에 한번만 호출되도록
  initlock(&modelock, "modelock");

  for(p = proc; p < &proc[NPROC]; p++) {
      initlock(&p->lock, "proc");
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
  }
}

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
  int id = r_tp();
  return id;
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
  int id = cpuid();
  struct cpu *c = &cpus[id];
  return c;
}

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
  push_off();
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
  pop_off();
  return p;
}

int
allocpid()
{
  int pid;
  
  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == UNUSED) {
      goto found;
    } else {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->state = USED;

   // 새 프로세스의 필드를 현재 모드에 맞게 초기화
   // userinit, fork에서 초기화 했지만 혹시 모르니 추가로 초기화
  if (checkmode == 0) { // FCFS
    p->priority = -1;     
    p->level = -1;
    p->time_quantum = -1;
  } 
  else { // MLFQ
    p->level = 0; // L0
    p->priority = 3; // 3 - Highest value
    p->time_quantum = 0;
    p->limits = 1; // L0의 time quantum은 1
  }

  // Allocate a trapframe page.
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
  if(p->pagetable == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;

  return p;
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if(p->trapframe)
    kfree((void*)p->trapframe);
  p->trapframe = 0;
  if(p->pagetable)
    proc_freepagetable(p->pagetable, p->sz);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
}

// Create a user page table for a given process, with no user memory,
// but with trampoline and trapframe pages.
pagetable_t
proc_pagetable(struct proc *p)
{
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
  if(pagetable == 0)
    return 0;

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
              (uint64)trampoline, PTE_R | PTE_X) < 0){
    uvmfree(pagetable, 0);
    return 0;
  }

  // map the trapframe page just below the trampoline page, for
  // trampoline.S.
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
              (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }

  return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void
proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
  uvmfree(pagetable, sz);
}

// a user program that calls exec("/init")
// assembled from ../user/initcode.S
// od -t xC ../user/initcode
uchar initcode[] = {
  0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x45, 0x02,
  0x97, 0x05, 0x00, 0x00, 0x93, 0x85, 0x35, 0x02,
  0x93, 0x08, 0x70, 0x00, 0x73, 0x00, 0x00, 0x00,
  0x93, 0x08, 0x20, 0x00, 0x73, 0x00, 0x00, 0x00,
  0xef, 0xf0, 0x9f, 0xff, 0x2f, 0x69, 0x6e, 0x69,
  0x74, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00
};

// Set up first user process.
void
userinit(void)
{
  struct proc *p;

  p = allocproc();
  initproc = p;
  
  // allocate one user page and copy initcode's instructions
  // and data into it.
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
  p->sz = PGSIZE;

  // prepare for the very first "return" from kernel to user.
  p->trapframe->epc = 0;      // user program counter
  p->trapframe->sp = PGSIZE;  // user stack pointer

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;
  if (checkmode == 0) fcfs_push(p);
  else mlfq_push(0, p);

  if (checkmode == 0) { // FCFS
    p->priority = -1;     
    p->level = -1;
    p->time_quantum = -1;
  } 
  else { // MLFQ
    p->level = 0; // L0
    p->priority = 3; // 3 - Highest value
    p->time_quantum = 0;
    p->limits = 1; // L0의 time quantum은 1
  }

  release(&p->lock);
}

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint64 sz;
  struct proc *p = myproc();

  sz = p->sz;
  if(n > 0){
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
      return -1;
    }
  } else if(n < 0){
    sz = uvmdealloc(p->pagetable, sz, sz + n);
  }
  p->sz = sz;
  return 0;
}

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  release(&np->lock);

  acquire(&np->lock);

  // parent 설정 
  np->parent = p;

  //  state 변경 및 push
  np->state = RUNNABLE;
  if (checkmode == 0)
    fcfs_push(np);
  else
    mlfq_push(0, np);

  // 초기화
  if (checkmode == 0) {
    np->level = -1;
    np->priority = -1;
    np->time_quantum = -1;
    np->limits = -1;
  } else {
    np->level = 0;
    np->priority = 3;
    np->time_quantum = 0;
    np->limits = 1;
  }

  release(&np->lock);

  return pid;
}

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void
reparent(struct proc *p)
{
  struct proc *pp;

  for(pp = proc; pp < &proc[NPROC]; pp++){
    if(pp->parent == p){
      pp->parent = initproc;
      wakeup(initproc);
    }
  }
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void
exit(int status)
{
  struct proc *p = myproc();

  if(p == initproc)
    panic("init exiting");

  // Close all open files.
  for(int fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd]){
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;

  acquire(&wait_lock);

  // Give any children to init.
  reparent(p);

  // Parent might be sleeping in wait().
  wakeup(p->parent);
  
  acquire(&p->lock);

  p->xstate = status;
  p->state = ZOMBIE;

  release(&wait_lock);

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(uint64 addr)
{
  struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(pp = proc; pp < &proc[NPROC]; pp++){
      if(pp->parent == p){
        // make sure the child isn't still in exit() or swtch().
        acquire(&pp->lock);

        havekids = 1;
        if(pp->state == ZOMBIE){
          // Found one.
          pid = pp->pid;
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
                                  sizeof(pp->xstate)) < 0) {
            release(&pp->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(pp);
          release(&pp->lock);
          release(&wait_lock);
          return pid;
        }
        release(&pp->lock);
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || killed(p)){
      release(&wait_lock);
      return -1;
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
  }
}

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p = 0; //가져올 process가 없다면 NULL을 유지
  struct proc *temp; // MLFQ 임시 저장용
  struct cpu *c = mycpu();

  c->proc = 0;
  for(;;){
    // The most recent process to run may have had interrupts
    // turned off; enable them to avoid a deadlock if all
    // processes are waiting.
    intr_on();

    int found = 0;

    if (checkmode == 0 && !fcfs_empty()) { // FCFS 경우 + FCFS가 비어있지 않으면
      p = fcfs_pop();
      
      acquire(&p->lock);
      if(p->state == RUNNABLE) { // 더블 체크
        // Switch to chosen process.  It is the process's job
        // to release its lock and then reacquire it
        // before jumping back to us.
        p->state = RUNNING;
        c->proc = p;
        swtch(&c->context, &p->context);

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
        found = 1;
      }
      else { // RUNNABLE이 아닌 경우 
        fcfs_push(p);
      }
      release(&p->lock);
    }
    else if (checkmode == 1) { // MLFQ
      if (!mlfq_empty(0)) {
        p = mlfq_pop(0);
        found = 1;
      }
      else if (!mlfq_empty(1)) {
        p = mlfq_pop(1);
        found = 1;
      }
      else if (!mlfq_empty(2)) {
        int max = -1; // Max priority를 찾기 위함
        int index = -1;

        for (int i = 0; i < mlfq.entry[2].num; i++) {
          temp = mlfq.entry[2].q[(mlfq.entry[2].front + i) % NPROC];
          acquire(&temp->lock);
          if (temp->priority > max) {
            max = temp->priority;
            index = i;
          }
          release(&temp->lock);
        }

        if (index != -1) { // index == -1 이면 없는 것
          acquire(&queuelock);
          p = mlfq.entry[2].q[(mlfq.entry[2].front + index) % NPROC];

          // mlfq_pop이 level0, level1 기준이라 강제로 빼고 한 칸씩 앞으로 이동
          for (int i = index; i < mlfq.entry[2].num; i++) {
            int past = (mlfq.entry[2].front + i + 1) % NPROC; // 이전 위치
            int new = (mlfq.entry[2].front + i) % NPROC; // 새로운 위치
            mlfq.entry[2].q[new] = mlfq.entry[2].q[past];
          }
          mlfq.entry[2].rear = (mlfq.entry[2].rear + NPROC - 1) % NPROC; // 음수가 되는 것을 방지해 NPROC를 더함
          mlfq.entry[2].num--;
          release(&queuelock);

          found = 1;
        }
      }

      if (p != 0 && found == 1) { // p를 확실히 가져올 수 있는 상황이라면 p를 가져온다.
        acquire(&p->lock);
        if (p->state == RUNNABLE) {
          p->state = RUNNING;
          c->proc = p;
          swtch(&c->context, &p->context);
          c->proc = 0;
        }
        release(&p->lock);
      }
    }

    if(found == 0) {
      // nothing to run; stop running on this core until an interrupt.
      intr_on();
      asm volatile("wfi");
    }
  }
}

// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&p->lock))
    panic("sched p->lock");
  if(mycpu()->noff != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&p->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  if (checkmode == 1) { // MLFQ 일때만 yield
    struct proc *p = myproc();

    acquire(&p->lock);        
    p->state = RUNNABLE;
    mlfq_push(p->level, p); // level에 맞는 queue 뒤에 넣는다.
    sched();
    release(&p->lock);
  }
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);

  if (first) {
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);

    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
  release(lk);

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  release(&p->lock);
  acquire(lk);
}

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
        p->state = RUNNABLE;
        if (checkmode == 0) fcfs_push(p);
        else mlfq_push(0, p);
        // 초기화
        if (checkmode == 0) { // FCFS
          p->priority = -1;     
          p->level = -1;
          p->time_quantum = -1;
        } 
        else { // MLFQ
          p->level = 0; // L0
          p->priority = 3; // 3 - Highest value
          p->time_quantum = 0;
          p->limits = 1; // L0의 time quantum은 1
  }
      }
      release(&p->lock);
    }
  }
}

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->pid == pid){
      p->killed = 1;
      if(p->state == SLEEPING){
        // Wake process from sleep().
        p->state = RUNNABLE;
        if (checkmode == 0) fcfs_push(p);
        else mlfq_push(0, p);

        if (checkmode == 0) { // FCFS
          p->priority = -1;     
          p->level = -1;
          p->time_quantum = -1;
        } 
        else { // MLFQ
          p->level = 0; // L0
          p->priority = 3; // 3 - Highest value
          p->time_quantum = 0;
          p->limits = 1; // L0의 time quantum은 1
        }
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  return -1;
}

void
setkilled(struct proc *p)
{
  acquire(&p->lock);
  p->killed = 1;
  release(&p->lock);
}

int
killed(struct proc *p)
{
  int k;
  
  acquire(&p->lock);
  k = p->killed;
  release(&p->lock);
  return k;
}

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  struct proc *p = myproc();
  if(user_dst){
    return copyout(p->pagetable, dst, src, len);
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  struct proc *p = myproc();
  if(user_src){
    return copyin(p->pagetable, dst, src, len);
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [USED]      "used",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    printf("%d %s %s", p->pid, state, p->name);
    printf("\n");
  }
}

int 
getlev(void)
{
  if (checkmode == 0) return 99;
  else {
    struct proc *p = myproc();
    // process에 대한 접근을 atomic 하게 만든다.
    acquire(&p->lock);
    int l = p->level;
    release(&p->lock);
    return l;
  }
} 

int 
setpriority(int pid, int priority) 
{
  if (priority < 0 || priority > 3) return -2;

  for (struct proc *p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if (p->pid == pid) {
      p->priority = priority;
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  
  return -1;  
}

int 
mlfqmode (void)
{
  if (checkmode == 1) { // 이미 MLFQ mode인지 확인
    //printf("no changes are made\n"); - testcase에서 출력
    return -1;
  }

  acquire(&modelock);

  checkmode = 1;
  global_tick_count = 0;

  // FCFS 큐에 있던 프로세스를 모두 L0으로 이동
  while (!fcfs_empty()) {
    struct proc *p = fcfs_pop();

    acquire(&p->lock);
    if (p->state == RUNNABLE) {
      p->level = 0;
      p->priority = 3;
      p->time_quantum = 0;
      p->limits = 1;
      mlfq_push(0, p);
    }
    release(&p->lock);
  }

  // 현재 실행 중인 프로세스를 L0으로 초기화
  // 계속 실행은 되도록 한다.
  struct proc *now = myproc();
  acquire(&now->lock);
  if (now->state == RUNNING) {
    now->level = 0;
    now->priority = 3;
    now->time_quantum = 0;
    now->limits = 1;
  }
  release(&now->lock);
  
  fcfs_init();
  release(&modelock);
  return 0;
}

int 
fcfsmode (void)
{ 
  if (checkmode == 0) { // 이미 FCFS인지 확인
    // printf("no changes are made\n"); - testcase에서 출력 
    return -1;
  } 

  acquire(&modelock);

  checkmode = 0;
  global_tick_count = 0;
 
  int index = 0;
  struct proc* temp; // 임시 저장 용
  struct proc* runnable_proc[NPROC];

  for (int i = 0; i < 3; i++) {
    while (!mlfq_empty(i)) {
      temp = mlfq_pop(i);

      acquire(&temp->lock);
      if (temp->state == RUNNABLE) {
        temp->level = -1;
        temp->priority = -1;
        temp->time_quantum = -1;
        temp->limits = -1;
        runnable_proc[index++] = temp;
      }
      release(&temp->lock);
    }
  }

  // 현재 실행 중인 프로세스를를 FCFS으로 초기화
  // 계속 실행은 되도록 한다.
  struct proc *now = myproc();
  acquire(&now->lock);
  if (now->state == RUNNING) {
    now->level = -1;
    now->priority = -1;
    now->time_quantum = -1;
    now->limits = -1;
  }
  release(&now->lock);

  // Bubble sort로 pid 작은 순대로 정렬
  for (int i = 0; i < index - 1; i++) {
    for (int j = i + 1; j < index; j++) {
      if (runnable_proc[i]->pid > runnable_proc[j]->pid) {
        temp = runnable_proc[i];
        runnable_proc[i] = runnable_proc[j];
        runnable_proc[j] = temp;
      }
    }
  }

  for (int i = 0; i < index; i++) {
    fcfs_push(runnable_proc[i]);
  }

  mlfq_init(); // queue를 초기화

  release(&modelock);
  return 0;
}

// Debuggiingng용으로 FCFS queue와 MLFQ를 출력
int 
showfcfs(void)
{
  acquire(&queuelock);
  printf(">>> FCFS queue [%d procs]: ", fcfs.entry.num);
  for(int i = 0; i < fcfs.entry.num; i++){
    int index = (fcfs.entry.front + i) % NPROC;
    struct proc *p = fcfs.entry.q[index];
    if(p) printf("%d ", p->pid);
  }
  printf("\n");
  release(&queuelock);

  return 0;
}

// 각 MLFQ queue에 들어있는 process를 level 0부터 출력
int
showmlfq(void)
{
  acquire(&queuelock);
  for(int l = 0; l < 3; l++){
    struct queue *q = &mlfq.entry[l];
    printf(">>> MLFQ L%d queue [%d procs]: ", l, q->num);
    for(int i = 0; i < q->num; i++){
      int index = (q->front + i) % NPROC;
      struct proc *p = q->q[index];
      if(p) printf("%d ", p->pid);
    }
    printf("\n");
  }
  release(&queuelock);
  return 0;
}