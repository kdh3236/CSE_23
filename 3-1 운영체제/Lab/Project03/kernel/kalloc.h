#ifndef _KALLOC_H_
#define _KALLOC_H_ 

uint64 getRefCount(void* pa);
void incRefCount(void* pa);
void decRefCount(void* pa);

#endif // _KALLOC_H_