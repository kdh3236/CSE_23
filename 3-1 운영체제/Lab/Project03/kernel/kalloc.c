// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"
#include "kalloc.h"

uint64 refCount[PHYSTOP / PGSIZE];
struct spinlock ref_lock;

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

uint64 getRefCount(void *pa) {
  int c;

  acquire(&ref_lock);
  c = refCount[(uint64)pa / PGSIZE];
  release(&ref_lock);

  return c;
}

void incRefCount(void *pa) {
  acquire(&ref_lock);
  refCount[(uint64)pa / PGSIZE]++;
  release(&ref_lock);
} 

void decRefCount(void *pa) {
  acquire(&ref_lock);
  refCount[(uint64)pa / PGSIZE]--;
  release(&ref_lock);
}

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

void
kinit()
{
  initlock(&ref_lock, "refLock");
  initlock(&kmem.lock, "kmem");
  memset(refCount, 0, sizeof(refCount));
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
      panic("kfree");
  
  if (getRefCount(pa) >= 1) decRefCount(pa);

  if (getRefCount(pa) == 0) {
    struct run *r;

    // Fill with junk to catch dangling refs.
    // 0x1로 memory를 채움
    memset(pa, 1, PGSIZE);

    r = (struct run*)pa;

    // pa에 해당하는 page를 freelist에 올림
    acquire(&kmem.lock);
    r->next = kmem.freelist;
    kmem.freelist = r;
    release(&kmem.lock);
  }
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  // free page가 linked list로 관리됨
  // run은 linked list의 Node
  struct run *r;

  acquire(&kmem.lock);
  // freelist의 가장 첫 번째 page를 가져옴
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r) {
    acquire(&ref_lock);
    refCount[(uint64)r / PGSIZE] = 1;
    release(&ref_lock);
    // page 전체를 0x5로 채움
    memset((char*)r, 5, PGSIZE); // fill with junk
  }
  return (void*)r;
}
