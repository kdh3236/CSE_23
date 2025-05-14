#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

struct spinlock tickslock;
uint ticks;
extern int checkmode;
extern int global_tick_count;
extern struct mlfq mlfq;
extern char trampoline[], uservec[], userret[];

// in kernelvec.S, calls kerneltrap().
void kernelvec();

extern int devintr();

void
trapinit(void)
{
  initlock(&tickslock, "time");
}

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
  w_stvec((uint64)kernelvec);
}

//
// handle an interrupt, exception, or system call from user space.
// called from trampoline.S
//
void
usertrap(void)
{
  int which_dev = 0;

  if((r_sstatus() & SSTATUS_SPP) != 0)
    panic("usertrap: not from user mode");

  // send interrupts and exceptions to kerneltrap(),
  // since we're now in the kernel.
  w_stvec((uint64)kernelvec);

  struct proc *p = myproc();
  
  // save user program counter.
  p->trapframe->epc = r_sepc();
  
  if(r_scause() == 8){
    // system call

    if(killed(p))
      exit(-1);

    // sepc points to the ecall instruction,
    // but we want to return to the next instruction.
    p->trapframe->epc += 4;

    // an interrupt will change sepc, scause, and sstatus,
    // so enable only now that we're done with those registers.
    intr_on();

    syscall();
  } else if((which_dev = devintr()) != 0){
    // ok
  } else {
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    setkilled(p);
    printf("Process %d Forced termination\n", p->pid);
  }

  if(killed(p))
    exit(-1);

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2) {
    if (checkmode == 0) yield(); // FCFS면 그냥 yield
  }
  usertrapret(); 
}
  


//
// return to user space
//
void
usertrapret(void)
{
  struct proc *p = myproc();

  // we're about to switch the destination of traps from
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
  p->trapframe->kernel_trap = (uint64)usertrap;
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()

  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
  x |= SSTATUS_SPIE; // enable interrupts in user mode
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
  ((void (*)(uint64))trampoline_userret)(satp);
}

// interrupts and exceptions from kernel code go here via kernelvec,
// on whatever the current kernel stack is.
void 
kerneltrap()
{
  int which_dev = 0;
  uint64 sepc = r_sepc();
  uint64 sstatus = r_sstatus();
  uint64 scause = r_scause();
  
  if((sstatus & SSTATUS_SPP) == 0)
    panic("kerneltrap: not from supervisor mode");
  if(intr_get() != 0)
    panic("kerneltrap: interrupts enabled");

  if((which_dev = devintr()) == 0){
    // interrupt or trap from an unknown source
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    panic("kerneltrap");
  }

  // give up the CPU if this is a timer interrupt.
  if(which_dev == 2 && myproc() != 0) {
    if (checkmode == 0) yield(); // FCFS면 그냥 yield
  }

  // the yield() may have caused some traps to occur,
  // so restore trap registers for use by kernelvec.S's sepc instruction.
  w_sepc(sepc);
  w_sstatus(sstatus);
}

void
clockintr()
{
  if(cpuid() == 0){
    acquire(&tickslock);
    ticks++;
    wakeup(&ticks);
    release(&tickslock);

    int checkyield = 0; //yield 가능 여부
    
    if (checkmode == 1) { // MLFQ
      struct proc *p = myproc();
      global_tick_count++;

      if (p && p->state == RUNNING) {
        acquire(&p->lock);
        p->time_quantum++;

        if (p->time_quantum >= p->limits) { // 주어진 time quantum을 전부 사용했을 경우
          p->time_quantum = 0; // time quantum을 초기화

          if (p->level == 0) { // Demoted to L1
            p->level = 1;
            p->limits = 3;
          } 
          else if (p->level == 1) { // Demoted to L2
            p->level = 2;
            p->limits = 5;
          }
          else if (p->level == 2) {
            if (p->priority > 0) p->priority --;
          }

          p->state = RUNNABLE;
          release(&p->lock);
          
          checkyield = 1; // yield 가능
        } 
        else { // level이나 priority를 바꾸어야되는지 먼저 확인
          if (p->level == 1) {
            release(&p->lock);
            if (!mlfq_empty(0)) checkyield = 1; // L0, L1에서 yield 가능
          }
          else if (p->level == 2) { // priority 방식
            // level0 또는 level1에 프로세스 있으면 yield
            if (!mlfq_empty(0) || !mlfq_empty(1)) {
              release(&p->lock);
              checkyield = 1;
            }
      
            // level2 안에서 우선순위 비교
            for (int i = 0; i < mlfq.entry[2].num; i++) {
              struct proc *temp = mlfq.entry[2].q[(mlfq.entry[2].front + i) % NPROC];
              if (temp->priority > p->priority && temp->state == RUNNABLE) {
                release(&p->lock);
                checkyield = 1;
                break;
              }
            }
            if (checkyield == 0) release(&p->lock);
          }
        }
      }
    }
    if (checkyield == 1) yield(); // yield 가능하면 yield
  }

  // Starvation 방지 - Prioirty boosting
  if (global_tick_count >= 50 && checkmode == 1) {
    for (int level = 1; level <= 2; level++) {
      while (!mlfq_empty(level)) {
        struct proc *temp = mlfq_pop(level);

        acquire(&temp->lock);
        if (temp->state != UNUSED) {
          temp->level = 0;
          temp->priority = 3;
          temp->time_quantum = 0;
          temp->limits = 1;
          mlfq_push(0, temp); // L0 큐에 다시 push
        }
        release(&temp->lock);
      }
    }

    // 현재 실행 중인 프로세스도 level0으로 이동
    struct proc *me = myproc();
    if (me != 0) {
      acquire(&me->lock);
      if (me->state == RUNNING) {
        me->level = 0;
        me->priority = 3;
        me->time_quantum = 0;
        me->limits = 1;
      }
      release(&me->lock);
    }

    global_tick_count = 0;
  
  } 
  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
}

// check if it's an external interrupt or software interrupt,
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    // this is a supervisor external interrupt, via PLIC.

    // irq indicates which device interrupted.
    int irq = plic_claim();

    if(irq == UART0_IRQ){
      uartintr();
    } else if(irq == VIRTIO0_IRQ){
      virtio_disk_intr();
    } else if(irq){
      printf("unexpected interrupt irq=%d\n", irq);
    }

    // the PLIC allows each device to raise at most one
    // interrupt at a time; tell the PLIC the device is
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
  }
}
