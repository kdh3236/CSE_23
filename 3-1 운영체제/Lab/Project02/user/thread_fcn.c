#include "kernel/types.h"
#include "user/user.h"
#include "user/thread.h"

int
main(int argc, char *argv[])
{
    printf("Thread exec test %s\n", argv[1]);
    return 0;
}