
user/_schedtest_full:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fork_children>:
int parent;

// 1) 단순 fork/exit 헬퍼: 자식 NUM_THREAD개 생성
int
fork_children(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	4491                	li	s1,4
  int i, pid;
  for (i = 0; i < NUM_THREAD; i++) {
    if ((pid = fork()) == 0)
   c:	62a000ef          	jal	636 <fork>
  10:	cd01                	beqz	a0,28 <fork_children+0x28>
  for (i = 0; i < NUM_THREAD; i++) {
  12:	34fd                	addiw	s1,s1,-1
  14:	fce5                	bnez	s1,c <fork_children+0xc>
      return getpid();    // 자식: 자신 PID 반환
  }
  return parent;          // 부모: parent 반환
  16:	00002517          	auipc	a0,0x2
  1a:	fea52503          	lw	a0,-22(a0) # 2000 <parent>
}
  1e:	60e2                	ld	ra,24(sp)
  20:	6442                	ld	s0,16(sp)
  22:	64a2                	ld	s1,8(sp)
  24:	6105                	addi	sp,sp,32
  26:	8082                	ret
      return getpid();    // 자식: 자신 PID 반환
  28:	696000ef          	jal	6be <getpid>
  2c:	bfcd                	j	1e <fork_children+0x1e>

000000000000002e <exit_children>:

// 2) 자식 회수 헬퍼
void
exit_children(void)
{
  2e:	7179                	addi	sp,sp,-48
  30:	f406                	sd	ra,40(sp)
  32:	f022                	sd	s0,32(sp)
  34:	ec26                	sd	s1,24(sp)
  36:	1800                	addi	s0,sp,48
  if (getpid() != parent)
  38:	686000ef          	jal	6be <getpid>
  3c:	00002797          	auipc	a5,0x2
  40:	fc47a783          	lw	a5,-60(a5) # 2000 <parent>
    exit(0);              // 자식은 즉시 종료
  int status;
  while (wait(&status) != -1)
  44:	54fd                	li	s1,-1
  if (getpid() != parent)
  46:	00a79d63          	bne	a5,a0,60 <exit_children+0x32>
  while (wait(&status) != -1)
  4a:	fdc40513          	addi	a0,s0,-36
  4e:	5f8000ef          	jal	646 <wait>
  52:	fe951ce3          	bne	a0,s1,4a <exit_children+0x1c>
    ;                     // 부모는 모든 자식 회수
}
  56:	70a2                	ld	ra,40(sp)
  58:	7402                	ld	s0,32(sp)
  5a:	64e2                	ld	s1,24(sp)
  5c:	6145                	addi	sp,sp,48
  5e:	8082                	ret
    exit(0);              // 자식은 즉시 종료
  60:	4501                	li	a0,0
  62:	5dc000ef          	jal	63e <exit>

0000000000000066 <main>:

int
main(int argc, char *argv[])
{
  66:	715d                	addi	sp,sp,-80
  68:	e486                	sd	ra,72(sp)
  6a:	e0a2                	sd	s0,64(sp)
  6c:	fc26                	sd	s1,56(sp)
  6e:	f84a                	sd	s2,48(sp)
  70:	f44e                	sd	s3,40(sp)
  72:	f052                	sd	s4,32(sp)
  74:	ec56                	sd	s5,24(sp)
  76:	e85a                	sd	s6,16(sp)
  78:	0880                	addi	s0,sp,80
  int pid, i;
  int hits[MAX_LEVEL];

  parent = getpid();
  7a:	644000ef          	jal	6be <getpid>
  7e:	00002497          	auipc	s1,0x2
  82:	f8248493          	addi	s1,s1,-126 # 2000 <parent>
  86:	c088                	sw	a0,0(s1)
  printf("=== FCFS & MLFQ extended test start ===\n\n");
  88:	00001517          	auipc	a0,0x1
  8c:	ba850513          	addi	a0,a0,-1112 # c30 <malloc+0xfe>
  90:	1ef000ef          	jal	a7e <printf>

  // ---------------------------------------------------------
  // [Test 1] 기본 FCFS 동작 검증
  //   - non-preemptive: fork된 순서대로 각 자식이 NUM_LOOP회 실행
  // ---------------------------------------------------------
  printf("[1] FCFS 기본 동작\n");
  94:	00001517          	auipc	a0,0x1
  98:	bcc50513          	addi	a0,a0,-1076 # c60 <malloc+0x12e>
  9c:	1e3000ef          	jal	a7e <printf>
  pid = fork_children();
  a0:	f61ff0ef          	jal	0 <fork_children>
  if (pid != parent) {
  a4:	409c                	lw	a5,0(s1)
  a6:	00a78e63          	beq	a5,a0,c2 <main+0x5c>
  aa:	85aa                	mv	a1,a0
  ac:	67e1                	lui	a5,0x18
  ae:	6a178793          	addi	a5,a5,1697 # 186a1 <base+0x16691>
    // 자식: NUM_LOOP 회 루프
    int ctr = 0;
    while (ctr++ < NUM_LOOP) ;
  b2:	37fd                	addiw	a5,a5,-1
  b4:	fffd                	bnez	a5,b2 <main+0x4c>
    printf(" Child %d done busy loop\n", pid);
  b6:	00001517          	auipc	a0,0x1
  ba:	bc250513          	addi	a0,a0,-1086 # c78 <malloc+0x146>
  be:	1c1000ef          	jal	a7e <printf>
  }
  exit_children();
  c2:	f6dff0ef          	jal	2e <exit_children>
  printf(" => [1] FCFS 확인 완료\n\n");
  c6:	00001517          	auipc	a0,0x1
  ca:	bd250513          	addi	a0,a0,-1070 # c98 <malloc+0x166>
  ce:	1b1000ef          	jal	a7e <printf>
  // ---------------------------------------------------------
  // [Test 2] mode-switch 직후 getlev 검증
  //   - fcfsmode() 후 getlev() == -99
  //   - mlfqmode() 후 getlev() == 0
  // ---------------------------------------------------------
  printf("[2] 모드 전환 직후 필드 초기화 확인\n");
  d2:	00001517          	auipc	a0,0x1
  d6:	be650513          	addi	a0,a0,-1050 # cb8 <malloc+0x186>
  da:	1a5000ef          	jal	a7e <printf>
  if (fcfsmode() != 0) printf("  fcfsmode: 이미 FCFS 모드\n");
  de:	620000ef          	jal	6fe <fcfsmode>
  e2:	14051c63          	bnez	a0,23a <main+0x1d4>
  printf("   getlev() after fcfsmode() == %d  (기대: 99)\n", getlev());
  e6:	600000ef          	jal	6e6 <getlev>
  ea:	85aa                	mv	a1,a0
  ec:	00001517          	auipc	a0,0x1
  f0:	c2450513          	addi	a0,a0,-988 # d10 <malloc+0x1de>
  f4:	18b000ef          	jal	a7e <printf>

  if (mlfqmode() != 0) printf("  mlfqmode: 이미 MLFQ 모드\n");
  f8:	5fe000ef          	jal	6f6 <mlfqmode>
  fc:	14051663          	bnez	a0,248 <main+0x1e2>
  printf("   getlev() after mlfqmode() == %d  (기대: 0)\n\n", getlev());
 100:	5e6000ef          	jal	6e6 <getlev>
 104:	85aa                	mv	a1,a0
 106:	00001517          	auipc	a0,0x1
 10a:	c6250513          	addi	a0,a0,-926 # d68 <malloc+0x236>
 10e:	171000ef          	jal	a7e <printf>

  // ---------------------------------------------------------
  // [Test 3] 기본 MLFQ 동작 검증
  //   - 각 레벨별 실행 횟수 누적
  // ---------------------------------------------------------
  printf("[3] MLFQ 기본 스케줄링 분포\n");
 112:	00001517          	auipc	a0,0x1
 116:	c8e50513          	addi	a0,a0,-882 # da0 <malloc+0x26e>
 11a:	165000ef          	jal	a7e <printf>
  pid = fork_children();
 11e:	ee3ff0ef          	jal	0 <fork_children>
 122:	89aa                	mv	s3,a0
  if (pid != parent) {
 124:	00002797          	auipc	a5,0x2
 128:	edc7a783          	lw	a5,-292(a5) # 2000 <parent>
 12c:	06a78c63          	beq	a5,a0,1a4 <main+0x13e>
    for (i = 0; i < MAX_LEVEL; i++) hits[i] = 0;
 130:	fa042823          	sw	zero,-80(s0)
 134:	fa042a23          	sw	zero,-76(s0)
 138:	fa042c23          	sw	zero,-72(s0)
 13c:	64e1                	lui	s1,0x18
 13e:	6a048493          	addi	s1,s1,1696 # 186a0 <base+0x16690>
    for (i = 0; i < NUM_LOOP; i++) {
      int lvl = getlev();
      if (lvl < 0 || lvl >= MAX_LEVEL) {
 142:	4909                	li	s2,2
      int lvl = getlev();
 144:	5a2000ef          	jal	6e6 <getlev>
      if (lvl < 0 || lvl >= MAX_LEVEL) {
 148:	0005079b          	sext.w	a5,a0
 14c:	10f96563          	bltu	s2,a5,256 <main+0x1f0>
        printf(" Wrong level: %d\n", lvl);
        exit(1);
      }
      hits[lvl]++;
 150:	050a                	slli	a0,a0,0x2
 152:	fc050793          	addi	a5,a0,-64
 156:	00878533          	add	a0,a5,s0
 15a:	ff052783          	lw	a5,-16(a0)
 15e:	2785                	addiw	a5,a5,1
 160:	fef52823          	sw	a5,-16(a0)
    for (i = 0; i < NUM_LOOP; i++) {
 164:	34fd                	addiw	s1,s1,-1
 166:	fcf9                	bnez	s1,144 <main+0xde>
    }
    printf(" Child %d level hits: ", pid);
 168:	85ce                	mv	a1,s3
 16a:	00001517          	auipc	a0,0x1
 16e:	c7650513          	addi	a0,a0,-906 # de0 <malloc+0x2ae>
 172:	10d000ef          	jal	a7e <printf>
    for (i = 0; i < MAX_LEVEL; i++)
 176:	fb040913          	addi	s2,s0,-80
      printf("L%d=%d ", i, hits[i]);
 17a:	00001a17          	auipc	s4,0x1
 17e:	c7ea0a13          	addi	s4,s4,-898 # df8 <malloc+0x2c6>
    for (i = 0; i < MAX_LEVEL; i++)
 182:	498d                	li	s3,3
      printf("L%d=%d ", i, hits[i]);
 184:	00092603          	lw	a2,0(s2)
 188:	85a6                	mv	a1,s1
 18a:	8552                	mv	a0,s4
 18c:	0f3000ef          	jal	a7e <printf>
    for (i = 0; i < MAX_LEVEL; i++)
 190:	2485                	addiw	s1,s1,1
 192:	0911                	addi	s2,s2,4
 194:	ff3498e3          	bne	s1,s3,184 <main+0x11e>
    printf("\n");
 198:	00001517          	auipc	a0,0x1
 19c:	c0050513          	addi	a0,a0,-1024 # d98 <malloc+0x266>
 1a0:	0df000ef          	jal	a7e <printf>
  }
  exit_children();
 1a4:	e8bff0ef          	jal	2e <exit_children>
  printf(" => [3] MLFQ 분포 확인 완료\n\n");
 1a8:	00001517          	auipc	a0,0x1
 1ac:	c5850513          	addi	a0,a0,-936 # e00 <malloc+0x2ce>
 1b0:	0cf000ef          	jal	a7e <printf>
  // ---------------------------------------------------------
  // [Test 4] 자발적 yield 테스트
  //   - FCFS 모드: yield() 호출해도 아무 변화 없음을 확인
  //   - MLFQ 모드: yield() 호출 시 즉시 재스케줄링 됨을 확인
  // ---------------------------------------------------------
  printf("[4] 자발적 yield 테스트\n");
 1b4:	00001517          	auipc	a0,0x1
 1b8:	c7450513          	addi	a0,a0,-908 # e28 <malloc+0x2f6>
 1bc:	0c3000ef          	jal	a7e <printf>

  // -- FCFS 모드에서 yield --
  fcfsmode();
 1c0:	53e000ef          	jal	6fe <fcfsmode>
  pid = fork_children();
 1c4:	e3dff0ef          	jal	0 <fork_children>
 1c8:	84aa                	mv	s1,a0
  if (pid != parent) {
 1ca:	00002797          	auipc	a5,0x2
 1ce:	e367a783          	lw	a5,-458(a5) # 2000 <parent>
 1d2:	08a79c63          	bne	a5,a0,26a <main+0x204>
    printf("  [FCFS] child %d calling yield() twice...\n", pid);
    yield();
    yield();
    printf("  [FCFS] still here after yield(), pid=%d\n", pid);
  }
  exit_children();
 1d6:	e59ff0ef          	jal	2e <exit_children>

  // -- MLFQ 모드에서 yield, 이 경우 사이에 timer interrupt로 인한 yield가 발생하고 demotion이 일어날 수도 있다는 점.. --
  mlfqmode();
 1da:	51c000ef          	jal	6f6 <mlfqmode>
  pid = fork_children();
 1de:	e23ff0ef          	jal	0 <fork_children>
 1e2:	84aa                	mv	s1,a0
  if (pid != parent) {
 1e4:	00002797          	auipc	a5,0x2
 1e8:	e1c7a783          	lw	a5,-484(a5) # 2000 <parent>
 1ec:	0aa79263          	bne	a5,a0,290 <main+0x22a>
    yield();
    printf("    after 1st yield getlev()=%d, pid=%d\n", getlev(), pid);
    yield();
    printf("    after 2nd yield getlev()=%d, pid=%d\n", getlev(), pid);
  }
  exit_children();
 1f0:	e3fff0ef          	jal	2e <exit_children>
  printf(" => [4] yield 동작 확인 완료\n\n");
 1f4:	00001517          	auipc	a0,0x1
 1f8:	d6450513          	addi	a0,a0,-668 # f58 <malloc+0x426>
 1fc:	083000ef          	jal	a7e <printf>

  // ---------------------------------------------------------
  // [Test 5] setpriority 테스트
  //   - 정상 호출, 범위 벗어난 호출, 잘못된 PID 호출 검증
  // ---------------------------------------------------------
  printf("[5] setpriority 테스트\n");
 200:	00001517          	auipc	a0,0x1
 204:	d8050513          	addi	a0,a0,-640 # f80 <malloc+0x44e>
 208:	077000ef          	jal	a7e <printf>

  pid = fork();
 20c:	42a000ef          	jal	636 <fork>
 210:	84aa                	mv	s1,a0
  if (pid == 0) {
 212:	0c051963          	bnez	a0,2e4 <main+0x27e>
 216:	000f47b7          	lui	a5,0xf4
 21a:	24078793          	addi	a5,a5,576 # f4240 <base+0xf2230>
    // 자식은 잠깐 대기
    for (i = 0; i < 1000000; i++) ;
 21e:	37fd                	addiw	a5,a5,-1
 220:	fffd                	bnez	a5,21e <main+0x1b8>
    printf("  child %d exiting\n", getpid());
 222:	49c000ef          	jal	6be <getpid>
 226:	85aa                	mv	a1,a0
 228:	00001517          	auipc	a0,0x1
 22c:	d7850513          	addi	a0,a0,-648 # fa0 <malloc+0x46e>
 230:	04f000ef          	jal	a7e <printf>
    exit(0);
 234:	4501                	li	a0,0
 236:	408000ef          	jal	63e <exit>
  if (fcfsmode() != 0) printf("  fcfsmode: 이미 FCFS 모드\n");
 23a:	00001517          	auipc	a0,0x1
 23e:	ab650513          	addi	a0,a0,-1354 # cf0 <malloc+0x1be>
 242:	03d000ef          	jal	a7e <printf>
 246:	b545                	j	e6 <main+0x80>
  if (mlfqmode() != 0) printf("  mlfqmode: 이미 MLFQ 모드\n");
 248:	00001517          	auipc	a0,0x1
 24c:	b0050513          	addi	a0,a0,-1280 # d48 <malloc+0x216>
 250:	02f000ef          	jal	a7e <printf>
 254:	b575                	j	100 <main+0x9a>
        printf(" Wrong level: %d\n", lvl);
 256:	85aa                	mv	a1,a0
 258:	00001517          	auipc	a0,0x1
 25c:	b7050513          	addi	a0,a0,-1168 # dc8 <malloc+0x296>
 260:	01f000ef          	jal	a7e <printf>
        exit(1);
 264:	4505                	li	a0,1
 266:	3d8000ef          	jal	63e <exit>
    printf("  [FCFS] child %d calling yield() twice...\n", pid);
 26a:	85aa                	mv	a1,a0
 26c:	00001517          	auipc	a0,0x1
 270:	bdc50513          	addi	a0,a0,-1060 # e48 <malloc+0x316>
 274:	00b000ef          	jal	a7e <printf>
    yield();
 278:	466000ef          	jal	6de <yield>
    yield();
 27c:	462000ef          	jal	6de <yield>
    printf("  [FCFS] still here after yield(), pid=%d\n", pid);
 280:	85a6                	mv	a1,s1
 282:	00001517          	auipc	a0,0x1
 286:	bf650513          	addi	a0,a0,-1034 # e78 <malloc+0x346>
 28a:	7f4000ef          	jal	a7e <printf>
 28e:	b7a1                	j	1d6 <main+0x170>
    printf("  [MLFQ] child %d calling yield() twice...\n", pid);
 290:	85aa                	mv	a1,a0
 292:	00001517          	auipc	a0,0x1
 296:	c1650513          	addi	a0,a0,-1002 # ea8 <malloc+0x376>
 29a:	7e4000ef          	jal	a7e <printf>
    printf("    before getlev()=%d, pid=%d\n", getlev(), pid);
 29e:	448000ef          	jal	6e6 <getlev>
 2a2:	85aa                	mv	a1,a0
 2a4:	8626                	mv	a2,s1
 2a6:	00001517          	auipc	a0,0x1
 2aa:	c3250513          	addi	a0,a0,-974 # ed8 <malloc+0x3a6>
 2ae:	7d0000ef          	jal	a7e <printf>
    yield();
 2b2:	42c000ef          	jal	6de <yield>
    printf("    after 1st yield getlev()=%d, pid=%d\n", getlev(), pid);
 2b6:	430000ef          	jal	6e6 <getlev>
 2ba:	85aa                	mv	a1,a0
 2bc:	8626                	mv	a2,s1
 2be:	00001517          	auipc	a0,0x1
 2c2:	c3a50513          	addi	a0,a0,-966 # ef8 <malloc+0x3c6>
 2c6:	7b8000ef          	jal	a7e <printf>
    yield();
 2ca:	414000ef          	jal	6de <yield>
    printf("    after 2nd yield getlev()=%d, pid=%d\n", getlev(), pid);
 2ce:	418000ef          	jal	6e6 <getlev>
 2d2:	85aa                	mv	a1,a0
 2d4:	8626                	mv	a2,s1
 2d6:	00001517          	auipc	a0,0x1
 2da:	c5250513          	addi	a0,a0,-942 # f28 <malloc+0x3f6>
 2de:	7a0000ef          	jal	a7e <printf>
 2e2:	b739                	j	1f0 <main+0x18a>
  }
  // 부모: 정상범위 설정
  if (setpriority(pid, 2) == 0)
 2e4:	4589                	li	a1,2
 2e6:	408000ef          	jal	6ee <setpriority>
 2ea:	e559                	bnez	a0,378 <main+0x312>
    printf("  setpriority(%d,2) 성공\n", pid);
 2ec:	85a6                	mv	a1,s1
 2ee:	00001517          	auipc	a0,0x1
 2f2:	cca50513          	addi	a0,a0,-822 # fb8 <malloc+0x486>
 2f6:	788000ef          	jal	a7e <printf>
  else
    printf("  setpriority(%d,2) 실패\n", pid);
  // 범위 벗어난 priority
  printf("  setpriority(%d,-1) => %d (기대: -2)\n", pid, setpriority(pid, -1));
 2fa:	55fd                	li	a1,-1
 2fc:	8526                	mv	a0,s1
 2fe:	3f0000ef          	jal	6ee <setpriority>
 302:	862a                	mv	a2,a0
 304:	85a6                	mv	a1,s1
 306:	00001517          	auipc	a0,0x1
 30a:	cf250513          	addi	a0,a0,-782 # ff8 <malloc+0x4c6>
 30e:	770000ef          	jal	a7e <printf>
  // 잘못된 PID
  printf("  setpriority(9999,2) => %d (기대: -1)\n", setpriority(9999,2));
 312:	4589                	li	a1,2
 314:	6509                	lui	a0,0x2
 316:	70f50513          	addi	a0,a0,1807 # 270f <base+0x6ff>
 31a:	3d4000ef          	jal	6ee <setpriority>
 31e:	85aa                	mv	a1,a0
 320:	00001517          	auipc	a0,0x1
 324:	d0850513          	addi	a0,a0,-760 # 1028 <malloc+0x4f6>
 328:	756000ef          	jal	a7e <printf>
  wait(0);
 32c:	4501                	li	a0,0
 32e:	318000ef          	jal	646 <wait>
  printf(" => [5] setpriority 확인 완료\n\n");
 332:	00001517          	auipc	a0,0x1
 336:	d2650513          	addi	a0,a0,-730 # 1058 <malloc+0x526>
 33a:	744000ef          	jal	a7e <printf>

  // ---------------------------------------------------------
  // [6] priority boost 동작 확인
  //   - MLFQ 모드에서 일정 시간(틱) 경과 후 레벨이 다시 0으로 부스트 되는지 확인
  // ---------------------------------------------------------
  printf("[6] priority boost 테스트\n");
 33e:	00001517          	auipc	a0,0x1
 342:	d4250513          	addi	a0,a0,-702 # 1080 <malloc+0x54e>
 346:	738000ef          	jal	a7e <printf>
  mlfqmode();
 34a:	3ac000ef          	jal	6f6 <mlfqmode>
  pid = fork_children();
 34e:	cb3ff0ef          	jal	0 <fork_children>
  if (pid != parent) {
 352:	00002797          	auipc	a5,0x2
 356:	cae7a783          	lw	a5,-850(a5) # 2000 <parent>
    // 짧은 busy loop를 반복하면서 priority boost가 발생하는지 확인
    for (i = 0; i < 200; i++) {
 35a:	4481                	li	s1,0
  if (pid != parent) {
 35c:	04a78b63          	beq	a5,a0,3b2 <main+0x34c>
 360:	1dcd6937          	lui	s2,0x1dcd6
 364:	50090913          	addi	s2,s2,1280 # 1dcd6500 <base+0x1dcd44f0>
      for (int j = 0; j < 500000000; j++) ;  
      if (i % 10 == 0)
 368:	4aa9                	li	s5,10
        printf("  child %d at iteration %d, level=%d\n",
 36a:	00001b17          	auipc	s6,0x1
 36e:	d36b0b13          	addi	s6,s6,-714 # 10a0 <malloc+0x56e>
    for (i = 0; i < 200; i++) {
 372:	0c800a13          	li	s4,200
 376:	a821                	j	38e <main+0x328>
    printf("  setpriority(%d,2) 실패\n", pid);
 378:	85a6                	mv	a1,s1
 37a:	00001517          	auipc	a0,0x1
 37e:	c5e50513          	addi	a0,a0,-930 # fd8 <malloc+0x4a6>
 382:	6fc000ef          	jal	a7e <printf>
 386:	bf95                	j	2fa <main+0x294>
    for (i = 0; i < 200; i++) {
 388:	2485                	addiw	s1,s1,1
 38a:	03448463          	beq	s1,s4,3b2 <main+0x34c>
      for (int j = 0; j < 500000000; j++) ;  
 38e:	87ca                	mv	a5,s2
 390:	37fd                	addiw	a5,a5,-1
 392:	fffd                	bnez	a5,390 <main+0x32a>
      if (i % 10 == 0)
 394:	0354e7bb          	remw	a5,s1,s5
 398:	fbe5                	bnez	a5,388 <main+0x322>
        printf("  child %d at iteration %d, level=%d\n",
 39a:	324000ef          	jal	6be <getpid>
 39e:	89aa                	mv	s3,a0
 3a0:	346000ef          	jal	6e6 <getlev>
 3a4:	86aa                	mv	a3,a0
 3a6:	8626                	mv	a2,s1
 3a8:	85ce                	mv	a1,s3
 3aa:	855a                	mv	a0,s6
 3ac:	6d2000ef          	jal	a7e <printf>
 3b0:	bfe1                	j	388 <main+0x322>
               getpid(), i, getlev());
    }
  }
  exit_children();
 3b2:	c7dff0ef          	jal	2e <exit_children>
  printf(" => [6] priority boost 확인 완료\n\n");
 3b6:	00001517          	auipc	a0,0x1
 3ba:	d1250513          	addi	a0,a0,-750 # 10c8 <malloc+0x596>
 3be:	6c0000ef          	jal	a7e <printf>

  printf("=== 모든 테스트 완료 ===\n");
 3c2:	00001517          	auipc	a0,0x1
 3c6:	d2e50513          	addi	a0,a0,-722 # 10f0 <malloc+0x5be>
 3ca:	6b4000ef          	jal	a7e <printf>
  exit(0);
 3ce:	4501                	li	a0,0
 3d0:	26e000ef          	jal	63e <exit>

00000000000003d4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 3d4:	1141                	addi	sp,sp,-16
 3d6:	e406                	sd	ra,8(sp)
 3d8:	e022                	sd	s0,0(sp)
 3da:	0800                	addi	s0,sp,16
  extern int main();
  main();
 3dc:	c8bff0ef          	jal	66 <main>
  exit(0);
 3e0:	4501                	li	a0,0
 3e2:	25c000ef          	jal	63e <exit>

00000000000003e6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3e6:	1141                	addi	sp,sp,-16
 3e8:	e422                	sd	s0,8(sp)
 3ea:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3ec:	87aa                	mv	a5,a0
 3ee:	0585                	addi	a1,a1,1
 3f0:	0785                	addi	a5,a5,1
 3f2:	fff5c703          	lbu	a4,-1(a1)
 3f6:	fee78fa3          	sb	a4,-1(a5)
 3fa:	fb75                	bnez	a4,3ee <strcpy+0x8>
    ;
  return os;
}
 3fc:	6422                	ld	s0,8(sp)
 3fe:	0141                	addi	sp,sp,16
 400:	8082                	ret

0000000000000402 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 402:	1141                	addi	sp,sp,-16
 404:	e422                	sd	s0,8(sp)
 406:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 408:	00054783          	lbu	a5,0(a0)
 40c:	cb91                	beqz	a5,420 <strcmp+0x1e>
 40e:	0005c703          	lbu	a4,0(a1)
 412:	00f71763          	bne	a4,a5,420 <strcmp+0x1e>
    p++, q++;
 416:	0505                	addi	a0,a0,1
 418:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 41a:	00054783          	lbu	a5,0(a0)
 41e:	fbe5                	bnez	a5,40e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 420:	0005c503          	lbu	a0,0(a1)
}
 424:	40a7853b          	subw	a0,a5,a0
 428:	6422                	ld	s0,8(sp)
 42a:	0141                	addi	sp,sp,16
 42c:	8082                	ret

000000000000042e <strlen>:

uint
strlen(const char *s)
{
 42e:	1141                	addi	sp,sp,-16
 430:	e422                	sd	s0,8(sp)
 432:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 434:	00054783          	lbu	a5,0(a0)
 438:	cf91                	beqz	a5,454 <strlen+0x26>
 43a:	0505                	addi	a0,a0,1
 43c:	87aa                	mv	a5,a0
 43e:	86be                	mv	a3,a5
 440:	0785                	addi	a5,a5,1
 442:	fff7c703          	lbu	a4,-1(a5)
 446:	ff65                	bnez	a4,43e <strlen+0x10>
 448:	40a6853b          	subw	a0,a3,a0
 44c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 44e:	6422                	ld	s0,8(sp)
 450:	0141                	addi	sp,sp,16
 452:	8082                	ret
  for(n = 0; s[n]; n++)
 454:	4501                	li	a0,0
 456:	bfe5                	j	44e <strlen+0x20>

0000000000000458 <memset>:

void*
memset(void *dst, int c, uint n)
{
 458:	1141                	addi	sp,sp,-16
 45a:	e422                	sd	s0,8(sp)
 45c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 45e:	ca19                	beqz	a2,474 <memset+0x1c>
 460:	87aa                	mv	a5,a0
 462:	1602                	slli	a2,a2,0x20
 464:	9201                	srli	a2,a2,0x20
 466:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 46a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 46e:	0785                	addi	a5,a5,1
 470:	fee79de3          	bne	a5,a4,46a <memset+0x12>
  }
  return dst;
}
 474:	6422                	ld	s0,8(sp)
 476:	0141                	addi	sp,sp,16
 478:	8082                	ret

000000000000047a <strchr>:

char*
strchr(const char *s, char c)
{
 47a:	1141                	addi	sp,sp,-16
 47c:	e422                	sd	s0,8(sp)
 47e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 480:	00054783          	lbu	a5,0(a0)
 484:	cb99                	beqz	a5,49a <strchr+0x20>
    if(*s == c)
 486:	00f58763          	beq	a1,a5,494 <strchr+0x1a>
  for(; *s; s++)
 48a:	0505                	addi	a0,a0,1
 48c:	00054783          	lbu	a5,0(a0)
 490:	fbfd                	bnez	a5,486 <strchr+0xc>
      return (char*)s;
  return 0;
 492:	4501                	li	a0,0
}
 494:	6422                	ld	s0,8(sp)
 496:	0141                	addi	sp,sp,16
 498:	8082                	ret
  return 0;
 49a:	4501                	li	a0,0
 49c:	bfe5                	j	494 <strchr+0x1a>

000000000000049e <gets>:

char*
gets(char *buf, int max)
{
 49e:	711d                	addi	sp,sp,-96
 4a0:	ec86                	sd	ra,88(sp)
 4a2:	e8a2                	sd	s0,80(sp)
 4a4:	e4a6                	sd	s1,72(sp)
 4a6:	e0ca                	sd	s2,64(sp)
 4a8:	fc4e                	sd	s3,56(sp)
 4aa:	f852                	sd	s4,48(sp)
 4ac:	f456                	sd	s5,40(sp)
 4ae:	f05a                	sd	s6,32(sp)
 4b0:	ec5e                	sd	s7,24(sp)
 4b2:	1080                	addi	s0,sp,96
 4b4:	8baa                	mv	s7,a0
 4b6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4b8:	892a                	mv	s2,a0
 4ba:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4bc:	4aa9                	li	s5,10
 4be:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4c0:	89a6                	mv	s3,s1
 4c2:	2485                	addiw	s1,s1,1
 4c4:	0344d663          	bge	s1,s4,4f0 <gets+0x52>
    cc = read(0, &c, 1);
 4c8:	4605                	li	a2,1
 4ca:	faf40593          	addi	a1,s0,-81
 4ce:	4501                	li	a0,0
 4d0:	186000ef          	jal	656 <read>
    if(cc < 1)
 4d4:	00a05e63          	blez	a0,4f0 <gets+0x52>
    buf[i++] = c;
 4d8:	faf44783          	lbu	a5,-81(s0)
 4dc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4e0:	01578763          	beq	a5,s5,4ee <gets+0x50>
 4e4:	0905                	addi	s2,s2,1
 4e6:	fd679de3          	bne	a5,s6,4c0 <gets+0x22>
    buf[i++] = c;
 4ea:	89a6                	mv	s3,s1
 4ec:	a011                	j	4f0 <gets+0x52>
 4ee:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4f0:	99de                	add	s3,s3,s7
 4f2:	00098023          	sb	zero,0(s3)
  return buf;
}
 4f6:	855e                	mv	a0,s7
 4f8:	60e6                	ld	ra,88(sp)
 4fa:	6446                	ld	s0,80(sp)
 4fc:	64a6                	ld	s1,72(sp)
 4fe:	6906                	ld	s2,64(sp)
 500:	79e2                	ld	s3,56(sp)
 502:	7a42                	ld	s4,48(sp)
 504:	7aa2                	ld	s5,40(sp)
 506:	7b02                	ld	s6,32(sp)
 508:	6be2                	ld	s7,24(sp)
 50a:	6125                	addi	sp,sp,96
 50c:	8082                	ret

000000000000050e <stat>:

int
stat(const char *n, struct stat *st)
{
 50e:	1101                	addi	sp,sp,-32
 510:	ec06                	sd	ra,24(sp)
 512:	e822                	sd	s0,16(sp)
 514:	e04a                	sd	s2,0(sp)
 516:	1000                	addi	s0,sp,32
 518:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 51a:	4581                	li	a1,0
 51c:	162000ef          	jal	67e <open>
  if(fd < 0)
 520:	02054263          	bltz	a0,544 <stat+0x36>
 524:	e426                	sd	s1,8(sp)
 526:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 528:	85ca                	mv	a1,s2
 52a:	16c000ef          	jal	696 <fstat>
 52e:	892a                	mv	s2,a0
  close(fd);
 530:	8526                	mv	a0,s1
 532:	134000ef          	jal	666 <close>
  return r;
 536:	64a2                	ld	s1,8(sp)
}
 538:	854a                	mv	a0,s2
 53a:	60e2                	ld	ra,24(sp)
 53c:	6442                	ld	s0,16(sp)
 53e:	6902                	ld	s2,0(sp)
 540:	6105                	addi	sp,sp,32
 542:	8082                	ret
    return -1;
 544:	597d                	li	s2,-1
 546:	bfcd                	j	538 <stat+0x2a>

0000000000000548 <atoi>:

int
atoi(const char *s)
{
 548:	1141                	addi	sp,sp,-16
 54a:	e422                	sd	s0,8(sp)
 54c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 54e:	00054683          	lbu	a3,0(a0)
 552:	fd06879b          	addiw	a5,a3,-48
 556:	0ff7f793          	zext.b	a5,a5
 55a:	4625                	li	a2,9
 55c:	02f66863          	bltu	a2,a5,58c <atoi+0x44>
 560:	872a                	mv	a4,a0
  n = 0;
 562:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 564:	0705                	addi	a4,a4,1
 566:	0025179b          	slliw	a5,a0,0x2
 56a:	9fa9                	addw	a5,a5,a0
 56c:	0017979b          	slliw	a5,a5,0x1
 570:	9fb5                	addw	a5,a5,a3
 572:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 576:	00074683          	lbu	a3,0(a4)
 57a:	fd06879b          	addiw	a5,a3,-48
 57e:	0ff7f793          	zext.b	a5,a5
 582:	fef671e3          	bgeu	a2,a5,564 <atoi+0x1c>
  return n;
}
 586:	6422                	ld	s0,8(sp)
 588:	0141                	addi	sp,sp,16
 58a:	8082                	ret
  n = 0;
 58c:	4501                	li	a0,0
 58e:	bfe5                	j	586 <atoi+0x3e>

0000000000000590 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 590:	1141                	addi	sp,sp,-16
 592:	e422                	sd	s0,8(sp)
 594:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 596:	02b57463          	bgeu	a0,a1,5be <memmove+0x2e>
    while(n-- > 0)
 59a:	00c05f63          	blez	a2,5b8 <memmove+0x28>
 59e:	1602                	slli	a2,a2,0x20
 5a0:	9201                	srli	a2,a2,0x20
 5a2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 5a6:	872a                	mv	a4,a0
      *dst++ = *src++;
 5a8:	0585                	addi	a1,a1,1
 5aa:	0705                	addi	a4,a4,1
 5ac:	fff5c683          	lbu	a3,-1(a1)
 5b0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 5b4:	fef71ae3          	bne	a4,a5,5a8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 5b8:	6422                	ld	s0,8(sp)
 5ba:	0141                	addi	sp,sp,16
 5bc:	8082                	ret
    dst += n;
 5be:	00c50733          	add	a4,a0,a2
    src += n;
 5c2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5c4:	fec05ae3          	blez	a2,5b8 <memmove+0x28>
 5c8:	fff6079b          	addiw	a5,a2,-1
 5cc:	1782                	slli	a5,a5,0x20
 5ce:	9381                	srli	a5,a5,0x20
 5d0:	fff7c793          	not	a5,a5
 5d4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5d6:	15fd                	addi	a1,a1,-1
 5d8:	177d                	addi	a4,a4,-1
 5da:	0005c683          	lbu	a3,0(a1)
 5de:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5e2:	fee79ae3          	bne	a5,a4,5d6 <memmove+0x46>
 5e6:	bfc9                	j	5b8 <memmove+0x28>

00000000000005e8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5e8:	1141                	addi	sp,sp,-16
 5ea:	e422                	sd	s0,8(sp)
 5ec:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5ee:	ca05                	beqz	a2,61e <memcmp+0x36>
 5f0:	fff6069b          	addiw	a3,a2,-1
 5f4:	1682                	slli	a3,a3,0x20
 5f6:	9281                	srli	a3,a3,0x20
 5f8:	0685                	addi	a3,a3,1
 5fa:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5fc:	00054783          	lbu	a5,0(a0)
 600:	0005c703          	lbu	a4,0(a1)
 604:	00e79863          	bne	a5,a4,614 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 608:	0505                	addi	a0,a0,1
    p2++;
 60a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 60c:	fed518e3          	bne	a0,a3,5fc <memcmp+0x14>
  }
  return 0;
 610:	4501                	li	a0,0
 612:	a019                	j	618 <memcmp+0x30>
      return *p1 - *p2;
 614:	40e7853b          	subw	a0,a5,a4
}
 618:	6422                	ld	s0,8(sp)
 61a:	0141                	addi	sp,sp,16
 61c:	8082                	ret
  return 0;
 61e:	4501                	li	a0,0
 620:	bfe5                	j	618 <memcmp+0x30>

0000000000000622 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 622:	1141                	addi	sp,sp,-16
 624:	e406                	sd	ra,8(sp)
 626:	e022                	sd	s0,0(sp)
 628:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 62a:	f67ff0ef          	jal	590 <memmove>
}
 62e:	60a2                	ld	ra,8(sp)
 630:	6402                	ld	s0,0(sp)
 632:	0141                	addi	sp,sp,16
 634:	8082                	ret

0000000000000636 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 636:	4885                	li	a7,1
 ecall
 638:	00000073          	ecall
 ret
 63c:	8082                	ret

000000000000063e <exit>:
.global exit
exit:
 li a7, SYS_exit
 63e:	4889                	li	a7,2
 ecall
 640:	00000073          	ecall
 ret
 644:	8082                	ret

0000000000000646 <wait>:
.global wait
wait:
 li a7, SYS_wait
 646:	488d                	li	a7,3
 ecall
 648:	00000073          	ecall
 ret
 64c:	8082                	ret

000000000000064e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 64e:	4891                	li	a7,4
 ecall
 650:	00000073          	ecall
 ret
 654:	8082                	ret

0000000000000656 <read>:
.global read
read:
 li a7, SYS_read
 656:	4895                	li	a7,5
 ecall
 658:	00000073          	ecall
 ret
 65c:	8082                	ret

000000000000065e <write>:
.global write
write:
 li a7, SYS_write
 65e:	48c1                	li	a7,16
 ecall
 660:	00000073          	ecall
 ret
 664:	8082                	ret

0000000000000666 <close>:
.global close
close:
 li a7, SYS_close
 666:	48d5                	li	a7,21
 ecall
 668:	00000073          	ecall
 ret
 66c:	8082                	ret

000000000000066e <kill>:
.global kill
kill:
 li a7, SYS_kill
 66e:	4899                	li	a7,6
 ecall
 670:	00000073          	ecall
 ret
 674:	8082                	ret

0000000000000676 <exec>:
.global exec
exec:
 li a7, SYS_exec
 676:	489d                	li	a7,7
 ecall
 678:	00000073          	ecall
 ret
 67c:	8082                	ret

000000000000067e <open>:
.global open
open:
 li a7, SYS_open
 67e:	48bd                	li	a7,15
 ecall
 680:	00000073          	ecall
 ret
 684:	8082                	ret

0000000000000686 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 686:	48c5                	li	a7,17
 ecall
 688:	00000073          	ecall
 ret
 68c:	8082                	ret

000000000000068e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 68e:	48c9                	li	a7,18
 ecall
 690:	00000073          	ecall
 ret
 694:	8082                	ret

0000000000000696 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 696:	48a1                	li	a7,8
 ecall
 698:	00000073          	ecall
 ret
 69c:	8082                	ret

000000000000069e <link>:
.global link
link:
 li a7, SYS_link
 69e:	48cd                	li	a7,19
 ecall
 6a0:	00000073          	ecall
 ret
 6a4:	8082                	ret

00000000000006a6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 6a6:	48d1                	li	a7,20
 ecall
 6a8:	00000073          	ecall
 ret
 6ac:	8082                	ret

00000000000006ae <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 6ae:	48a5                	li	a7,9
 ecall
 6b0:	00000073          	ecall
 ret
 6b4:	8082                	ret

00000000000006b6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 6b6:	48a9                	li	a7,10
 ecall
 6b8:	00000073          	ecall
 ret
 6bc:	8082                	ret

00000000000006be <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6be:	48ad                	li	a7,11
 ecall
 6c0:	00000073          	ecall
 ret
 6c4:	8082                	ret

00000000000006c6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6c6:	48b1                	li	a7,12
 ecall
 6c8:	00000073          	ecall
 ret
 6cc:	8082                	ret

00000000000006ce <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6ce:	48b5                	li	a7,13
 ecall
 6d0:	00000073          	ecall
 ret
 6d4:	8082                	ret

00000000000006d6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6d6:	48b9                	li	a7,14
 ecall
 6d8:	00000073          	ecall
 ret
 6dc:	8082                	ret

00000000000006de <yield>:
.global yield
yield:
 li a7, SYS_yield
 6de:	48d9                	li	a7,22
 ecall
 6e0:	00000073          	ecall
 ret
 6e4:	8082                	ret

00000000000006e6 <getlev>:
.global getlev
getlev:
 li a7, SYS_getlev
 6e6:	48dd                	li	a7,23
 ecall
 6e8:	00000073          	ecall
 ret
 6ec:	8082                	ret

00000000000006ee <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 6ee:	48e1                	li	a7,24
 ecall
 6f0:	00000073          	ecall
 ret
 6f4:	8082                	ret

00000000000006f6 <mlfqmode>:
.global mlfqmode
mlfqmode:
 li a7, SYS_mlfqmode
 6f6:	48e5                	li	a7,25
 ecall
 6f8:	00000073          	ecall
 ret
 6fc:	8082                	ret

00000000000006fe <fcfsmode>:
.global fcfsmode
fcfsmode:
 li a7, SYS_fcfsmode
 6fe:	48e9                	li	a7,26
 ecall
 700:	00000073          	ecall
 ret
 704:	8082                	ret

0000000000000706 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 706:	1101                	addi	sp,sp,-32
 708:	ec06                	sd	ra,24(sp)
 70a:	e822                	sd	s0,16(sp)
 70c:	1000                	addi	s0,sp,32
 70e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 712:	4605                	li	a2,1
 714:	fef40593          	addi	a1,s0,-17
 718:	f47ff0ef          	jal	65e <write>
}
 71c:	60e2                	ld	ra,24(sp)
 71e:	6442                	ld	s0,16(sp)
 720:	6105                	addi	sp,sp,32
 722:	8082                	ret

0000000000000724 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 724:	7139                	addi	sp,sp,-64
 726:	fc06                	sd	ra,56(sp)
 728:	f822                	sd	s0,48(sp)
 72a:	f426                	sd	s1,40(sp)
 72c:	0080                	addi	s0,sp,64
 72e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 730:	c299                	beqz	a3,736 <printint+0x12>
 732:	0805c963          	bltz	a1,7c4 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 736:	2581                	sext.w	a1,a1
  neg = 0;
 738:	4881                	li	a7,0
 73a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 73e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 740:	2601                	sext.w	a2,a2
 742:	00001517          	auipc	a0,0x1
 746:	9de50513          	addi	a0,a0,-1570 # 1120 <digits>
 74a:	883a                	mv	a6,a4
 74c:	2705                	addiw	a4,a4,1
 74e:	02c5f7bb          	remuw	a5,a1,a2
 752:	1782                	slli	a5,a5,0x20
 754:	9381                	srli	a5,a5,0x20
 756:	97aa                	add	a5,a5,a0
 758:	0007c783          	lbu	a5,0(a5)
 75c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 760:	0005879b          	sext.w	a5,a1
 764:	02c5d5bb          	divuw	a1,a1,a2
 768:	0685                	addi	a3,a3,1
 76a:	fec7f0e3          	bgeu	a5,a2,74a <printint+0x26>
  if(neg)
 76e:	00088c63          	beqz	a7,786 <printint+0x62>
    buf[i++] = '-';
 772:	fd070793          	addi	a5,a4,-48
 776:	00878733          	add	a4,a5,s0
 77a:	02d00793          	li	a5,45
 77e:	fef70823          	sb	a5,-16(a4)
 782:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 786:	02e05a63          	blez	a4,7ba <printint+0x96>
 78a:	f04a                	sd	s2,32(sp)
 78c:	ec4e                	sd	s3,24(sp)
 78e:	fc040793          	addi	a5,s0,-64
 792:	00e78933          	add	s2,a5,a4
 796:	fff78993          	addi	s3,a5,-1
 79a:	99ba                	add	s3,s3,a4
 79c:	377d                	addiw	a4,a4,-1
 79e:	1702                	slli	a4,a4,0x20
 7a0:	9301                	srli	a4,a4,0x20
 7a2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 7a6:	fff94583          	lbu	a1,-1(s2)
 7aa:	8526                	mv	a0,s1
 7ac:	f5bff0ef          	jal	706 <putc>
  while(--i >= 0)
 7b0:	197d                	addi	s2,s2,-1
 7b2:	ff391ae3          	bne	s2,s3,7a6 <printint+0x82>
 7b6:	7902                	ld	s2,32(sp)
 7b8:	69e2                	ld	s3,24(sp)
}
 7ba:	70e2                	ld	ra,56(sp)
 7bc:	7442                	ld	s0,48(sp)
 7be:	74a2                	ld	s1,40(sp)
 7c0:	6121                	addi	sp,sp,64
 7c2:	8082                	ret
    x = -xx;
 7c4:	40b005bb          	negw	a1,a1
    neg = 1;
 7c8:	4885                	li	a7,1
    x = -xx;
 7ca:	bf85                	j	73a <printint+0x16>

00000000000007cc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 7cc:	711d                	addi	sp,sp,-96
 7ce:	ec86                	sd	ra,88(sp)
 7d0:	e8a2                	sd	s0,80(sp)
 7d2:	e0ca                	sd	s2,64(sp)
 7d4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 7d6:	0005c903          	lbu	s2,0(a1)
 7da:	26090863          	beqz	s2,a4a <vprintf+0x27e>
 7de:	e4a6                	sd	s1,72(sp)
 7e0:	fc4e                	sd	s3,56(sp)
 7e2:	f852                	sd	s4,48(sp)
 7e4:	f456                	sd	s5,40(sp)
 7e6:	f05a                	sd	s6,32(sp)
 7e8:	ec5e                	sd	s7,24(sp)
 7ea:	e862                	sd	s8,16(sp)
 7ec:	e466                	sd	s9,8(sp)
 7ee:	8b2a                	mv	s6,a0
 7f0:	8a2e                	mv	s4,a1
 7f2:	8bb2                	mv	s7,a2
  state = 0;
 7f4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7f6:	4481                	li	s1,0
 7f8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7fa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7fe:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 802:	06c00c93          	li	s9,108
 806:	a005                	j	826 <vprintf+0x5a>
        putc(fd, c0);
 808:	85ca                	mv	a1,s2
 80a:	855a                	mv	a0,s6
 80c:	efbff0ef          	jal	706 <putc>
 810:	a019                	j	816 <vprintf+0x4a>
    } else if(state == '%'){
 812:	03598263          	beq	s3,s5,836 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 816:	2485                	addiw	s1,s1,1
 818:	8726                	mv	a4,s1
 81a:	009a07b3          	add	a5,s4,s1
 81e:	0007c903          	lbu	s2,0(a5)
 822:	20090c63          	beqz	s2,a3a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 826:	0009079b          	sext.w	a5,s2
    if(state == 0){
 82a:	fe0994e3          	bnez	s3,812 <vprintf+0x46>
      if(c0 == '%'){
 82e:	fd579de3          	bne	a5,s5,808 <vprintf+0x3c>
        state = '%';
 832:	89be                	mv	s3,a5
 834:	b7cd                	j	816 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 836:	00ea06b3          	add	a3,s4,a4
 83a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 83e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 840:	c681                	beqz	a3,848 <vprintf+0x7c>
 842:	9752                	add	a4,a4,s4
 844:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 848:	03878f63          	beq	a5,s8,886 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 84c:	05978963          	beq	a5,s9,89e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 850:	07500713          	li	a4,117
 854:	0ee78363          	beq	a5,a4,93a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 858:	07800713          	li	a4,120
 85c:	12e78563          	beq	a5,a4,986 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 860:	07000713          	li	a4,112
 864:	14e78a63          	beq	a5,a4,9b8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 868:	07300713          	li	a4,115
 86c:	18e78a63          	beq	a5,a4,a00 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 870:	02500713          	li	a4,37
 874:	04e79563          	bne	a5,a4,8be <vprintf+0xf2>
        putc(fd, '%');
 878:	02500593          	li	a1,37
 87c:	855a                	mv	a0,s6
 87e:	e89ff0ef          	jal	706 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 882:	4981                	li	s3,0
 884:	bf49                	j	816 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 886:	008b8913          	addi	s2,s7,8
 88a:	4685                	li	a3,1
 88c:	4629                	li	a2,10
 88e:	000ba583          	lw	a1,0(s7)
 892:	855a                	mv	a0,s6
 894:	e91ff0ef          	jal	724 <printint>
 898:	8bca                	mv	s7,s2
      state = 0;
 89a:	4981                	li	s3,0
 89c:	bfad                	j	816 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 89e:	06400793          	li	a5,100
 8a2:	02f68963          	beq	a3,a5,8d4 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8a6:	06c00793          	li	a5,108
 8aa:	04f68263          	beq	a3,a5,8ee <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 8ae:	07500793          	li	a5,117
 8b2:	0af68063          	beq	a3,a5,952 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 8b6:	07800793          	li	a5,120
 8ba:	0ef68263          	beq	a3,a5,99e <vprintf+0x1d2>
        putc(fd, '%');
 8be:	02500593          	li	a1,37
 8c2:	855a                	mv	a0,s6
 8c4:	e43ff0ef          	jal	706 <putc>
        putc(fd, c0);
 8c8:	85ca                	mv	a1,s2
 8ca:	855a                	mv	a0,s6
 8cc:	e3bff0ef          	jal	706 <putc>
      state = 0;
 8d0:	4981                	li	s3,0
 8d2:	b791                	j	816 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8d4:	008b8913          	addi	s2,s7,8
 8d8:	4685                	li	a3,1
 8da:	4629                	li	a2,10
 8dc:	000ba583          	lw	a1,0(s7)
 8e0:	855a                	mv	a0,s6
 8e2:	e43ff0ef          	jal	724 <printint>
        i += 1;
 8e6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8e8:	8bca                	mv	s7,s2
      state = 0;
 8ea:	4981                	li	s3,0
        i += 1;
 8ec:	b72d                	j	816 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8ee:	06400793          	li	a5,100
 8f2:	02f60763          	beq	a2,a5,920 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8f6:	07500793          	li	a5,117
 8fa:	06f60963          	beq	a2,a5,96c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8fe:	07800793          	li	a5,120
 902:	faf61ee3          	bne	a2,a5,8be <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 906:	008b8913          	addi	s2,s7,8
 90a:	4681                	li	a3,0
 90c:	4641                	li	a2,16
 90e:	000ba583          	lw	a1,0(s7)
 912:	855a                	mv	a0,s6
 914:	e11ff0ef          	jal	724 <printint>
        i += 2;
 918:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 91a:	8bca                	mv	s7,s2
      state = 0;
 91c:	4981                	li	s3,0
        i += 2;
 91e:	bde5                	j	816 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 920:	008b8913          	addi	s2,s7,8
 924:	4685                	li	a3,1
 926:	4629                	li	a2,10
 928:	000ba583          	lw	a1,0(s7)
 92c:	855a                	mv	a0,s6
 92e:	df7ff0ef          	jal	724 <printint>
        i += 2;
 932:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 934:	8bca                	mv	s7,s2
      state = 0;
 936:	4981                	li	s3,0
        i += 2;
 938:	bdf9                	j	816 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 93a:	008b8913          	addi	s2,s7,8
 93e:	4681                	li	a3,0
 940:	4629                	li	a2,10
 942:	000ba583          	lw	a1,0(s7)
 946:	855a                	mv	a0,s6
 948:	dddff0ef          	jal	724 <printint>
 94c:	8bca                	mv	s7,s2
      state = 0;
 94e:	4981                	li	s3,0
 950:	b5d9                	j	816 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 952:	008b8913          	addi	s2,s7,8
 956:	4681                	li	a3,0
 958:	4629                	li	a2,10
 95a:	000ba583          	lw	a1,0(s7)
 95e:	855a                	mv	a0,s6
 960:	dc5ff0ef          	jal	724 <printint>
        i += 1;
 964:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 966:	8bca                	mv	s7,s2
      state = 0;
 968:	4981                	li	s3,0
        i += 1;
 96a:	b575                	j	816 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 96c:	008b8913          	addi	s2,s7,8
 970:	4681                	li	a3,0
 972:	4629                	li	a2,10
 974:	000ba583          	lw	a1,0(s7)
 978:	855a                	mv	a0,s6
 97a:	dabff0ef          	jal	724 <printint>
        i += 2;
 97e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 980:	8bca                	mv	s7,s2
      state = 0;
 982:	4981                	li	s3,0
        i += 2;
 984:	bd49                	j	816 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 986:	008b8913          	addi	s2,s7,8
 98a:	4681                	li	a3,0
 98c:	4641                	li	a2,16
 98e:	000ba583          	lw	a1,0(s7)
 992:	855a                	mv	a0,s6
 994:	d91ff0ef          	jal	724 <printint>
 998:	8bca                	mv	s7,s2
      state = 0;
 99a:	4981                	li	s3,0
 99c:	bdad                	j	816 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 99e:	008b8913          	addi	s2,s7,8
 9a2:	4681                	li	a3,0
 9a4:	4641                	li	a2,16
 9a6:	000ba583          	lw	a1,0(s7)
 9aa:	855a                	mv	a0,s6
 9ac:	d79ff0ef          	jal	724 <printint>
        i += 1;
 9b0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 9b2:	8bca                	mv	s7,s2
      state = 0;
 9b4:	4981                	li	s3,0
        i += 1;
 9b6:	b585                	j	816 <vprintf+0x4a>
 9b8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 9ba:	008b8d13          	addi	s10,s7,8
 9be:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 9c2:	03000593          	li	a1,48
 9c6:	855a                	mv	a0,s6
 9c8:	d3fff0ef          	jal	706 <putc>
  putc(fd, 'x');
 9cc:	07800593          	li	a1,120
 9d0:	855a                	mv	a0,s6
 9d2:	d35ff0ef          	jal	706 <putc>
 9d6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 9d8:	00000b97          	auipc	s7,0x0
 9dc:	748b8b93          	addi	s7,s7,1864 # 1120 <digits>
 9e0:	03c9d793          	srli	a5,s3,0x3c
 9e4:	97de                	add	a5,a5,s7
 9e6:	0007c583          	lbu	a1,0(a5)
 9ea:	855a                	mv	a0,s6
 9ec:	d1bff0ef          	jal	706 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9f0:	0992                	slli	s3,s3,0x4
 9f2:	397d                	addiw	s2,s2,-1
 9f4:	fe0916e3          	bnez	s2,9e0 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 9f8:	8bea                	mv	s7,s10
      state = 0;
 9fa:	4981                	li	s3,0
 9fc:	6d02                	ld	s10,0(sp)
 9fe:	bd21                	j	816 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 a00:	008b8993          	addi	s3,s7,8
 a04:	000bb903          	ld	s2,0(s7)
 a08:	00090f63          	beqz	s2,a26 <vprintf+0x25a>
        for(; *s; s++)
 a0c:	00094583          	lbu	a1,0(s2)
 a10:	c195                	beqz	a1,a34 <vprintf+0x268>
          putc(fd, *s);
 a12:	855a                	mv	a0,s6
 a14:	cf3ff0ef          	jal	706 <putc>
        for(; *s; s++)
 a18:	0905                	addi	s2,s2,1
 a1a:	00094583          	lbu	a1,0(s2)
 a1e:	f9f5                	bnez	a1,a12 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a20:	8bce                	mv	s7,s3
      state = 0;
 a22:	4981                	li	s3,0
 a24:	bbcd                	j	816 <vprintf+0x4a>
          s = "(null)";
 a26:	00000917          	auipc	s2,0x0
 a2a:	6f290913          	addi	s2,s2,1778 # 1118 <malloc+0x5e6>
        for(; *s; s++)
 a2e:	02800593          	li	a1,40
 a32:	b7c5                	j	a12 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 a34:	8bce                	mv	s7,s3
      state = 0;
 a36:	4981                	li	s3,0
 a38:	bbf9                	j	816 <vprintf+0x4a>
 a3a:	64a6                	ld	s1,72(sp)
 a3c:	79e2                	ld	s3,56(sp)
 a3e:	7a42                	ld	s4,48(sp)
 a40:	7aa2                	ld	s5,40(sp)
 a42:	7b02                	ld	s6,32(sp)
 a44:	6be2                	ld	s7,24(sp)
 a46:	6c42                	ld	s8,16(sp)
 a48:	6ca2                	ld	s9,8(sp)
    }
  }
}
 a4a:	60e6                	ld	ra,88(sp)
 a4c:	6446                	ld	s0,80(sp)
 a4e:	6906                	ld	s2,64(sp)
 a50:	6125                	addi	sp,sp,96
 a52:	8082                	ret

0000000000000a54 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a54:	715d                	addi	sp,sp,-80
 a56:	ec06                	sd	ra,24(sp)
 a58:	e822                	sd	s0,16(sp)
 a5a:	1000                	addi	s0,sp,32
 a5c:	e010                	sd	a2,0(s0)
 a5e:	e414                	sd	a3,8(s0)
 a60:	e818                	sd	a4,16(s0)
 a62:	ec1c                	sd	a5,24(s0)
 a64:	03043023          	sd	a6,32(s0)
 a68:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a6c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a70:	8622                	mv	a2,s0
 a72:	d5bff0ef          	jal	7cc <vprintf>
}
 a76:	60e2                	ld	ra,24(sp)
 a78:	6442                	ld	s0,16(sp)
 a7a:	6161                	addi	sp,sp,80
 a7c:	8082                	ret

0000000000000a7e <printf>:

void
printf(const char *fmt, ...)
{
 a7e:	711d                	addi	sp,sp,-96
 a80:	ec06                	sd	ra,24(sp)
 a82:	e822                	sd	s0,16(sp)
 a84:	1000                	addi	s0,sp,32
 a86:	e40c                	sd	a1,8(s0)
 a88:	e810                	sd	a2,16(s0)
 a8a:	ec14                	sd	a3,24(s0)
 a8c:	f018                	sd	a4,32(s0)
 a8e:	f41c                	sd	a5,40(s0)
 a90:	03043823          	sd	a6,48(s0)
 a94:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a98:	00840613          	addi	a2,s0,8
 a9c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 aa0:	85aa                	mv	a1,a0
 aa2:	4505                	li	a0,1
 aa4:	d29ff0ef          	jal	7cc <vprintf>
}
 aa8:	60e2                	ld	ra,24(sp)
 aaa:	6442                	ld	s0,16(sp)
 aac:	6125                	addi	sp,sp,96
 aae:	8082                	ret

0000000000000ab0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ab0:	1141                	addi	sp,sp,-16
 ab2:	e422                	sd	s0,8(sp)
 ab4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ab6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aba:	00001797          	auipc	a5,0x1
 abe:	54e7b783          	ld	a5,1358(a5) # 2008 <freep>
 ac2:	a02d                	j	aec <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 ac4:	4618                	lw	a4,8(a2)
 ac6:	9f2d                	addw	a4,a4,a1
 ac8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 acc:	6398                	ld	a4,0(a5)
 ace:	6310                	ld	a2,0(a4)
 ad0:	a83d                	j	b0e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ad2:	ff852703          	lw	a4,-8(a0)
 ad6:	9f31                	addw	a4,a4,a2
 ad8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ada:	ff053683          	ld	a3,-16(a0)
 ade:	a091                	j	b22 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae0:	6398                	ld	a4,0(a5)
 ae2:	00e7e463          	bltu	a5,a4,aea <free+0x3a>
 ae6:	00e6ea63          	bltu	a3,a4,afa <free+0x4a>
{
 aea:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aec:	fed7fae3          	bgeu	a5,a3,ae0 <free+0x30>
 af0:	6398                	ld	a4,0(a5)
 af2:	00e6e463          	bltu	a3,a4,afa <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af6:	fee7eae3          	bltu	a5,a4,aea <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 afa:	ff852583          	lw	a1,-8(a0)
 afe:	6390                	ld	a2,0(a5)
 b00:	02059813          	slli	a6,a1,0x20
 b04:	01c85713          	srli	a4,a6,0x1c
 b08:	9736                	add	a4,a4,a3
 b0a:	fae60de3          	beq	a2,a4,ac4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 b0e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 b12:	4790                	lw	a2,8(a5)
 b14:	02061593          	slli	a1,a2,0x20
 b18:	01c5d713          	srli	a4,a1,0x1c
 b1c:	973e                	add	a4,a4,a5
 b1e:	fae68ae3          	beq	a3,a4,ad2 <free+0x22>
    p->s.ptr = bp->s.ptr;
 b22:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 b24:	00001717          	auipc	a4,0x1
 b28:	4ef73223          	sd	a5,1252(a4) # 2008 <freep>
}
 b2c:	6422                	ld	s0,8(sp)
 b2e:	0141                	addi	sp,sp,16
 b30:	8082                	ret

0000000000000b32 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b32:	7139                	addi	sp,sp,-64
 b34:	fc06                	sd	ra,56(sp)
 b36:	f822                	sd	s0,48(sp)
 b38:	f426                	sd	s1,40(sp)
 b3a:	ec4e                	sd	s3,24(sp)
 b3c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b3e:	02051493          	slli	s1,a0,0x20
 b42:	9081                	srli	s1,s1,0x20
 b44:	04bd                	addi	s1,s1,15
 b46:	8091                	srli	s1,s1,0x4
 b48:	0014899b          	addiw	s3,s1,1
 b4c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b4e:	00001517          	auipc	a0,0x1
 b52:	4ba53503          	ld	a0,1210(a0) # 2008 <freep>
 b56:	c915                	beqz	a0,b8a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b58:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b5a:	4798                	lw	a4,8(a5)
 b5c:	08977a63          	bgeu	a4,s1,bf0 <malloc+0xbe>
 b60:	f04a                	sd	s2,32(sp)
 b62:	e852                	sd	s4,16(sp)
 b64:	e456                	sd	s5,8(sp)
 b66:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b68:	8a4e                	mv	s4,s3
 b6a:	0009871b          	sext.w	a4,s3
 b6e:	6685                	lui	a3,0x1
 b70:	00d77363          	bgeu	a4,a3,b76 <malloc+0x44>
 b74:	6a05                	lui	s4,0x1
 b76:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b7a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b7e:	00001917          	auipc	s2,0x1
 b82:	48a90913          	addi	s2,s2,1162 # 2008 <freep>
  if(p == (char*)-1)
 b86:	5afd                	li	s5,-1
 b88:	a081                	j	bc8 <malloc+0x96>
 b8a:	f04a                	sd	s2,32(sp)
 b8c:	e852                	sd	s4,16(sp)
 b8e:	e456                	sd	s5,8(sp)
 b90:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b92:	00001797          	auipc	a5,0x1
 b96:	47e78793          	addi	a5,a5,1150 # 2010 <base>
 b9a:	00001717          	auipc	a4,0x1
 b9e:	46f73723          	sd	a5,1134(a4) # 2008 <freep>
 ba2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ba4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ba8:	b7c1                	j	b68 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 baa:	6398                	ld	a4,0(a5)
 bac:	e118                	sd	a4,0(a0)
 bae:	a8a9                	j	c08 <malloc+0xd6>
  hp->s.size = nu;
 bb0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 bb4:	0541                	addi	a0,a0,16
 bb6:	efbff0ef          	jal	ab0 <free>
  return freep;
 bba:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 bbe:	c12d                	beqz	a0,c20 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bc0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 bc2:	4798                	lw	a4,8(a5)
 bc4:	02977263          	bgeu	a4,s1,be8 <malloc+0xb6>
    if(p == freep)
 bc8:	00093703          	ld	a4,0(s2)
 bcc:	853e                	mv	a0,a5
 bce:	fef719e3          	bne	a4,a5,bc0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 bd2:	8552                	mv	a0,s4
 bd4:	af3ff0ef          	jal	6c6 <sbrk>
  if(p == (char*)-1)
 bd8:	fd551ce3          	bne	a0,s5,bb0 <malloc+0x7e>
        return 0;
 bdc:	4501                	li	a0,0
 bde:	7902                	ld	s2,32(sp)
 be0:	6a42                	ld	s4,16(sp)
 be2:	6aa2                	ld	s5,8(sp)
 be4:	6b02                	ld	s6,0(sp)
 be6:	a03d                	j	c14 <malloc+0xe2>
 be8:	7902                	ld	s2,32(sp)
 bea:	6a42                	ld	s4,16(sp)
 bec:	6aa2                	ld	s5,8(sp)
 bee:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 bf0:	fae48de3          	beq	s1,a4,baa <malloc+0x78>
        p->s.size -= nunits;
 bf4:	4137073b          	subw	a4,a4,s3
 bf8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bfa:	02071693          	slli	a3,a4,0x20
 bfe:	01c6d713          	srli	a4,a3,0x1c
 c02:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 c04:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 c08:	00001717          	auipc	a4,0x1
 c0c:	40a73023          	sd	a0,1024(a4) # 2008 <freep>
      return (void*)(p + 1);
 c10:	01078513          	addi	a0,a5,16
  }
}
 c14:	70e2                	ld	ra,56(sp)
 c16:	7442                	ld	s0,48(sp)
 c18:	74a2                	ld	s1,40(sp)
 c1a:	69e2                	ld	s3,24(sp)
 c1c:	6121                	addi	sp,sp,64
 c1e:	8082                	ret
 c20:	7902                	ld	s2,32(sp)
 c22:	6a42                	ld	s4,16(sp)
 c24:	6aa2                	ld	s5,8(sp)
 c26:	6b02                	ld	s6,0(sp)
 c28:	b7f5                	j	c14 <malloc+0xe2>
