#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

#define NPROCS       3      // 단계별로 fork할 자식 수
#define BOOST_TICKS  60     // priority boost를 위한 tick 수
#define STEP_TICKS   3

int
main(void)
{
  int p_fcfs[NPROCS], p_mlfq[NPROCS], p_final[NPROCS];
  int i, elapsed;

  printf("=== FCFS <-> MLFQ Full Queue Test ===\n\n");
  // [1] FCFS 모드: 초기 FCFS 큐 확인 (자식 유지)
  printf("[1] FCFS initial queue (keep children)\n");
  fcfsmode();
  for (i = 0; i < NPROCS; i++) {
    if ((p_fcfs[i] = fork()) == 0) {
      // FCFS 모드에선 선점이 없으므로,
      // 큐에 계속 머무르려면 잠시라도 실행을 yield 해 줘야 합니다.
      sleep(1);
      // wakeup → fcfs_push() 후 exit()
      exit(0);
    }
  }
  sleep(1);
  printf(" FCFS queue contents:\n");
  showfcfs();
  printf("[1] 테스트 완료\n\n");

  // [2] FCFS -> MLFQ 모드 전환 직후 큐 확인
  printf("[2] Switch FCFS -> MLFQ (children still alive)\n");
  mlfqmode();
  printf(" MLFQ queues immediately after switch:\n");
  showmlfq();
  // Stage1 자식 정리
  for (i = 0; i < NPROCS; i++) kill(p_fcfs[i]);
  for (i = 0; i < NPROCS; i++) wait(0);
  printf("[2] 테스트 완료\n\n");

  // [3] MLFQ 모드: 데모션 & Priority-Boost 확인 
  printf("[3] MLFQ demotion & priority-boost (3 ticks step)\n");
  for(i = 0; i < NPROCS; i++){
    if ((p_mlfq[i] = fork()) == 0) {
      while (1) ;
    }
  }

  elapsed = 0;
  while(elapsed < BOOST_TICKS){
    sleep(STEP_TICKS);
    elapsed += STEP_TICKS;
    printf(" after %d sleeps:\n", elapsed);
    showmlfq();
  }
  printf("[3] 테스트 완료\n\n");

  // [4] MLFQ -> FCFS 모드 전환 직후 큐 확인
  printf("[4] Switch MLFQ -> FCFS (children still alive)\n");
  fcfsmode();
  printf(" FCFS queue after switch:\n");
  showfcfs();
  // Stage3 자식 정리
  for (i = 0; i < NPROCS; i++) kill(p_mlfq[i]);
  for (i = 0; i < NPROCS; i++) wait(0);
  printf("[4] 테스트 완료\n\n");

  // [5] FCFS 모드 재검증: 새 자식 fork 후 큐 확인
  printf("[5] FCFS final queue (new children)\n");
  for (i = 0; i < NPROCS; i++) {
    if ((p_final[i] = fork()) == 0) {
      sleep(1);
      exit(0);
    }
  }
  sleep(1);
  showfcfs();
  for (i = 0; i < NPROCS; i++) wait(0);
  printf("[5] 테스트 완료\n\n");

  printf("=== 모든 테스트 완료 ===\n");
  exit(0);
}
