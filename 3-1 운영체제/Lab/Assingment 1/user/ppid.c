#include "kernel/types.h"
#include "user/user.h"

int main() {
	int pid = getpid();
	int ppid = getppid();
	printf("My student ID is 2023065350\n");
	printf("My pid is %d\n", pid);
	printf("My ppid is %d\n", ppid);
}
