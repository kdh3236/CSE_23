
user/_test2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#define BOOST_TICKS  60     // priority boost를 위한 tick 수
#define STEP_TICKS   3

int
main(void)
{
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	0880                	addi	s0,sp,80
  int p_fcfs[NPROCS], p_mlfq[NPROCS], p_final[NPROCS];
  int i, elapsed;

  printf("=== FCFS <-> MLFQ Full Queue Test ===\n\n");
   c:	00001517          	auipc	a0,0x1
  10:	a3450513          	addi	a0,a0,-1484 # a40 <malloc+0xf8>
  14:	081000ef          	jal	894 <printf>
  // [1] FCFS 모드: 초기 FCFS 큐 확인 (자식 유지)
  printf("[1] FCFS initial queue (keep children)\n");
  18:	00001517          	auipc	a0,0x1
  1c:	a5050513          	addi	a0,a0,-1456 # a68 <malloc+0x120>
  20:	075000ef          	jal	894 <printf>
  fcfsmode();
  24:	4e0000ef          	jal	504 <fcfsmode>
  for (i = 0; i < NPROCS; i++) {
  28:	fc040493          	addi	s1,s0,-64
  2c:	fcc40913          	addi	s2,s0,-52
    if ((p_fcfs[i] = fork()) == 0) {
  30:	40c000ef          	jal	43c <fork>
  34:	c088                	sw	a0,0(s1)
  36:	18050463          	beqz	a0,1be <main+0x1be>
  for (i = 0; i < NPROCS; i++) {
  3a:	0491                	addi	s1,s1,4
  3c:	ff249ae3          	bne	s1,s2,30 <main+0x30>
      sleep(1);
      // wakeup → fcfs_push() 후 exit()
      exit(0);
    }
  }
  sleep(1);
  40:	4505                	li	a0,1
  42:	492000ef          	jal	4d4 <sleep>
  printf(" FCFS queue contents:\n");
  46:	00001517          	auipc	a0,0x1
  4a:	a4a50513          	addi	a0,a0,-1462 # a90 <malloc+0x148>
  4e:	047000ef          	jal	894 <printf>
  showfcfs();
  52:	4ba000ef          	jal	50c <showfcfs>
  printf("[1] 테스트 완료\n\n");
  56:	00001517          	auipc	a0,0x1
  5a:	a5a50513          	addi	a0,a0,-1446 # ab0 <malloc+0x168>
  5e:	037000ef          	jal	894 <printf>

  // [2] FCFS -> MLFQ 모드 전환 직후 큐 확인
  printf("[2] Switch FCFS -> MLFQ (children still alive)\n");
  62:	00001517          	auipc	a0,0x1
  66:	a6650513          	addi	a0,a0,-1434 # ac8 <malloc+0x180>
  6a:	02b000ef          	jal	894 <printf>
  mlfqmode();
  6e:	48e000ef          	jal	4fc <mlfqmode>
  printf(" MLFQ queues immediately after switch:\n");
  72:	00001517          	auipc	a0,0x1
  76:	a8650513          	addi	a0,a0,-1402 # af8 <malloc+0x1b0>
  7a:	01b000ef          	jal	894 <printf>
  showmlfq();
  7e:	496000ef          	jal	514 <showmlfq>
  // Stage1 자식 정리
  for (i = 0; i < NPROCS; i++) kill(p_fcfs[i]);
  82:	fc042503          	lw	a0,-64(s0)
  86:	3ee000ef          	jal	474 <kill>
  8a:	fc442503          	lw	a0,-60(s0)
  8e:	3e6000ef          	jal	474 <kill>
  92:	fc842503          	lw	a0,-56(s0)
  96:	3de000ef          	jal	474 <kill>
  for (i = 0; i < NPROCS; i++) wait(0);
  9a:	4501                	li	a0,0
  9c:	3b0000ef          	jal	44c <wait>
  a0:	4501                	li	a0,0
  a2:	3aa000ef          	jal	44c <wait>
  a6:	4501                	li	a0,0
  a8:	3a4000ef          	jal	44c <wait>
  printf("[2] 테스트 완료\n\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	a7450513          	addi	a0,a0,-1420 # b20 <malloc+0x1d8>
  b4:	7e0000ef          	jal	894 <printf>

  // [3] MLFQ 모드: 데모션 & Priority-Boost 확인 
  printf("[3] MLFQ demotion & priority-boost (3 ticks step)\n");
  b8:	00001517          	auipc	a0,0x1
  bc:	a8050513          	addi	a0,a0,-1408 # b38 <malloc+0x1f0>
  c0:	7d4000ef          	jal	894 <printf>
  for(i = 0; i < NPROCS; i++){
  c4:	fb040493          	addi	s1,s0,-80
  c8:	fbc40913          	addi	s2,s0,-68
    if ((p_mlfq[i] = fork()) == 0) {
  cc:	370000ef          	jal	43c <fork>
  d0:	c088                	sw	a0,0(s1)
  d2:	0e050d63          	beqz	a0,1cc <main+0x1cc>
  for(i = 0; i < NPROCS; i++){
  d6:	0491                	addi	s1,s1,4
  d8:	ff249ae3          	bne	s1,s2,cc <main+0xcc>
  dc:	f44e                	sd	s3,40(sp)
      while (1) ;
    }
  }

  elapsed = 0;
  de:	4481                	li	s1,0
  while(elapsed < BOOST_TICKS){
    sleep(STEP_TICKS);
    elapsed += STEP_TICKS;
    printf(" after %d sleeps:\n", elapsed);
  e0:	00001997          	auipc	s3,0x1
  e4:	a9098993          	addi	s3,s3,-1392 # b70 <malloc+0x228>
  while(elapsed < BOOST_TICKS){
  e8:	03c00913          	li	s2,60
    sleep(STEP_TICKS);
  ec:	450d                	li	a0,3
  ee:	3e6000ef          	jal	4d4 <sleep>
    elapsed += STEP_TICKS;
  f2:	248d                	addiw	s1,s1,3
    printf(" after %d sleeps:\n", elapsed);
  f4:	85a6                	mv	a1,s1
  f6:	854e                	mv	a0,s3
  f8:	79c000ef          	jal	894 <printf>
    showmlfq();
  fc:	418000ef          	jal	514 <showmlfq>
  while(elapsed < BOOST_TICKS){
 100:	ff2496e3          	bne	s1,s2,ec <main+0xec>
  }
  printf("[3] 테스트 완료\n\n");
 104:	00001517          	auipc	a0,0x1
 108:	a8450513          	addi	a0,a0,-1404 # b88 <malloc+0x240>
 10c:	788000ef          	jal	894 <printf>

  // [4] MLFQ -> FCFS 모드 전환 직후 큐 확인
  printf("[4] Switch MLFQ -> FCFS (children still alive)\n");
 110:	00001517          	auipc	a0,0x1
 114:	a9050513          	addi	a0,a0,-1392 # ba0 <malloc+0x258>
 118:	77c000ef          	jal	894 <printf>
  fcfsmode();
 11c:	3e8000ef          	jal	504 <fcfsmode>
  printf(" FCFS queue after switch:\n");
 120:	00001517          	auipc	a0,0x1
 124:	ab050513          	addi	a0,a0,-1360 # bd0 <malloc+0x288>
 128:	76c000ef          	jal	894 <printf>
  showfcfs();
 12c:	3e0000ef          	jal	50c <showfcfs>
  // Stage3 자식 정리
  for (i = 0; i < NPROCS; i++) kill(p_mlfq[i]);
 130:	fb042503          	lw	a0,-80(s0)
 134:	340000ef          	jal	474 <kill>
 138:	fb442503          	lw	a0,-76(s0)
 13c:	338000ef          	jal	474 <kill>
 140:	fb842503          	lw	a0,-72(s0)
 144:	330000ef          	jal	474 <kill>
  for (i = 0; i < NPROCS; i++) wait(0);
 148:	4501                	li	a0,0
 14a:	302000ef          	jal	44c <wait>
 14e:	4501                	li	a0,0
 150:	2fc000ef          	jal	44c <wait>
 154:	4501                	li	a0,0
 156:	2f6000ef          	jal	44c <wait>
  printf("[4] 테스트 완료\n\n");
 15a:	00001517          	auipc	a0,0x1
 15e:	a9650513          	addi	a0,a0,-1386 # bf0 <malloc+0x2a8>
 162:	732000ef          	jal	894 <printf>

  // [5] FCFS 모드 재검증: 새 자식 fork 후 큐 확인
  printf("[5] FCFS final queue (new children)\n");
 166:	00001517          	auipc	a0,0x1
 16a:	aa250513          	addi	a0,a0,-1374 # c08 <malloc+0x2c0>
 16e:	726000ef          	jal	894 <printf>
  for (i = 0; i < NPROCS; i++) {
    if ((p_final[i] = fork()) == 0) {
 172:	2ca000ef          	jal	43c <fork>
 176:	cd21                	beqz	a0,1ce <main+0x1ce>
 178:	2c4000ef          	jal	43c <fork>
 17c:	c929                	beqz	a0,1ce <main+0x1ce>
 17e:	2be000ef          	jal	43c <fork>
 182:	c531                	beqz	a0,1ce <main+0x1ce>
      sleep(1);
      exit(0);
    }
  }
  sleep(1);
 184:	4505                	li	a0,1
 186:	34e000ef          	jal	4d4 <sleep>
  showfcfs();
 18a:	382000ef          	jal	50c <showfcfs>
  for (i = 0; i < NPROCS; i++) wait(0);
 18e:	4501                	li	a0,0
 190:	2bc000ef          	jal	44c <wait>
 194:	4501                	li	a0,0
 196:	2b6000ef          	jal	44c <wait>
 19a:	4501                	li	a0,0
 19c:	2b0000ef          	jal	44c <wait>
  printf("[5] 테스트 완료\n\n");
 1a0:	00001517          	auipc	a0,0x1
 1a4:	a9050513          	addi	a0,a0,-1392 # c30 <malloc+0x2e8>
 1a8:	6ec000ef          	jal	894 <printf>

  printf("=== 모든 테스트 완료 ===\n");
 1ac:	00001517          	auipc	a0,0x1
 1b0:	a9c50513          	addi	a0,a0,-1380 # c48 <malloc+0x300>
 1b4:	6e0000ef          	jal	894 <printf>
  exit(0);
 1b8:	4501                	li	a0,0
 1ba:	28a000ef          	jal	444 <exit>
 1be:	f44e                	sd	s3,40(sp)
      sleep(1);
 1c0:	4505                	li	a0,1
 1c2:	312000ef          	jal	4d4 <sleep>
      exit(0);
 1c6:	4501                	li	a0,0
 1c8:	27c000ef          	jal	444 <exit>
      while (1) ;
 1cc:	a001                	j	1cc <main+0x1cc>
      sleep(1);
 1ce:	4505                	li	a0,1
 1d0:	304000ef          	jal	4d4 <sleep>
      exit(0);
 1d4:	4501                	li	a0,0
 1d6:	26e000ef          	jal	444 <exit>

00000000000001da <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e406                	sd	ra,8(sp)
 1de:	e022                	sd	s0,0(sp)
 1e0:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1e2:	e1fff0ef          	jal	0 <main>
  exit(0);
 1e6:	4501                	li	a0,0
 1e8:	25c000ef          	jal	444 <exit>

00000000000001ec <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1ec:	1141                	addi	sp,sp,-16
 1ee:	e422                	sd	s0,8(sp)
 1f0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1f2:	87aa                	mv	a5,a0
 1f4:	0585                	addi	a1,a1,1
 1f6:	0785                	addi	a5,a5,1
 1f8:	fff5c703          	lbu	a4,-1(a1)
 1fc:	fee78fa3          	sb	a4,-1(a5)
 200:	fb75                	bnez	a4,1f4 <strcpy+0x8>
    ;
  return os;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret

0000000000000208 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 208:	1141                	addi	sp,sp,-16
 20a:	e422                	sd	s0,8(sp)
 20c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 20e:	00054783          	lbu	a5,0(a0)
 212:	cb91                	beqz	a5,226 <strcmp+0x1e>
 214:	0005c703          	lbu	a4,0(a1)
 218:	00f71763          	bne	a4,a5,226 <strcmp+0x1e>
    p++, q++;
 21c:	0505                	addi	a0,a0,1
 21e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 220:	00054783          	lbu	a5,0(a0)
 224:	fbe5                	bnez	a5,214 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 226:	0005c503          	lbu	a0,0(a1)
}
 22a:	40a7853b          	subw	a0,a5,a0
 22e:	6422                	ld	s0,8(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret

0000000000000234 <strlen>:

uint
strlen(const char *s)
{
 234:	1141                	addi	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 23a:	00054783          	lbu	a5,0(a0)
 23e:	cf91                	beqz	a5,25a <strlen+0x26>
 240:	0505                	addi	a0,a0,1
 242:	87aa                	mv	a5,a0
 244:	86be                	mv	a3,a5
 246:	0785                	addi	a5,a5,1
 248:	fff7c703          	lbu	a4,-1(a5)
 24c:	ff65                	bnez	a4,244 <strlen+0x10>
 24e:	40a6853b          	subw	a0,a3,a0
 252:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 254:	6422                	ld	s0,8(sp)
 256:	0141                	addi	sp,sp,16
 258:	8082                	ret
  for(n = 0; s[n]; n++)
 25a:	4501                	li	a0,0
 25c:	bfe5                	j	254 <strlen+0x20>

000000000000025e <memset>:

void*
memset(void *dst, int c, uint n)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 264:	ca19                	beqz	a2,27a <memset+0x1c>
 266:	87aa                	mv	a5,a0
 268:	1602                	slli	a2,a2,0x20
 26a:	9201                	srli	a2,a2,0x20
 26c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 270:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 274:	0785                	addi	a5,a5,1
 276:	fee79de3          	bne	a5,a4,270 <memset+0x12>
  }
  return dst;
}
 27a:	6422                	ld	s0,8(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret

0000000000000280 <strchr>:

char*
strchr(const char *s, char c)
{
 280:	1141                	addi	sp,sp,-16
 282:	e422                	sd	s0,8(sp)
 284:	0800                	addi	s0,sp,16
  for(; *s; s++)
 286:	00054783          	lbu	a5,0(a0)
 28a:	cb99                	beqz	a5,2a0 <strchr+0x20>
    if(*s == c)
 28c:	00f58763          	beq	a1,a5,29a <strchr+0x1a>
  for(; *s; s++)
 290:	0505                	addi	a0,a0,1
 292:	00054783          	lbu	a5,0(a0)
 296:	fbfd                	bnez	a5,28c <strchr+0xc>
      return (char*)s;
  return 0;
 298:	4501                	li	a0,0
}
 29a:	6422                	ld	s0,8(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret
  return 0;
 2a0:	4501                	li	a0,0
 2a2:	bfe5                	j	29a <strchr+0x1a>

00000000000002a4 <gets>:

char*
gets(char *buf, int max)
{
 2a4:	711d                	addi	sp,sp,-96
 2a6:	ec86                	sd	ra,88(sp)
 2a8:	e8a2                	sd	s0,80(sp)
 2aa:	e4a6                	sd	s1,72(sp)
 2ac:	e0ca                	sd	s2,64(sp)
 2ae:	fc4e                	sd	s3,56(sp)
 2b0:	f852                	sd	s4,48(sp)
 2b2:	f456                	sd	s5,40(sp)
 2b4:	f05a                	sd	s6,32(sp)
 2b6:	ec5e                	sd	s7,24(sp)
 2b8:	1080                	addi	s0,sp,96
 2ba:	8baa                	mv	s7,a0
 2bc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2be:	892a                	mv	s2,a0
 2c0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2c2:	4aa9                	li	s5,10
 2c4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2c6:	89a6                	mv	s3,s1
 2c8:	2485                	addiw	s1,s1,1
 2ca:	0344d663          	bge	s1,s4,2f6 <gets+0x52>
    cc = read(0, &c, 1);
 2ce:	4605                	li	a2,1
 2d0:	faf40593          	addi	a1,s0,-81
 2d4:	4501                	li	a0,0
 2d6:	186000ef          	jal	45c <read>
    if(cc < 1)
 2da:	00a05e63          	blez	a0,2f6 <gets+0x52>
    buf[i++] = c;
 2de:	faf44783          	lbu	a5,-81(s0)
 2e2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2e6:	01578763          	beq	a5,s5,2f4 <gets+0x50>
 2ea:	0905                	addi	s2,s2,1
 2ec:	fd679de3          	bne	a5,s6,2c6 <gets+0x22>
    buf[i++] = c;
 2f0:	89a6                	mv	s3,s1
 2f2:	a011                	j	2f6 <gets+0x52>
 2f4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2f6:	99de                	add	s3,s3,s7
 2f8:	00098023          	sb	zero,0(s3)
  return buf;
}
 2fc:	855e                	mv	a0,s7
 2fe:	60e6                	ld	ra,88(sp)
 300:	6446                	ld	s0,80(sp)
 302:	64a6                	ld	s1,72(sp)
 304:	6906                	ld	s2,64(sp)
 306:	79e2                	ld	s3,56(sp)
 308:	7a42                	ld	s4,48(sp)
 30a:	7aa2                	ld	s5,40(sp)
 30c:	7b02                	ld	s6,32(sp)
 30e:	6be2                	ld	s7,24(sp)
 310:	6125                	addi	sp,sp,96
 312:	8082                	ret

0000000000000314 <stat>:

int
stat(const char *n, struct stat *st)
{
 314:	1101                	addi	sp,sp,-32
 316:	ec06                	sd	ra,24(sp)
 318:	e822                	sd	s0,16(sp)
 31a:	e04a                	sd	s2,0(sp)
 31c:	1000                	addi	s0,sp,32
 31e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 320:	4581                	li	a1,0
 322:	162000ef          	jal	484 <open>
  if(fd < 0)
 326:	02054263          	bltz	a0,34a <stat+0x36>
 32a:	e426                	sd	s1,8(sp)
 32c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 32e:	85ca                	mv	a1,s2
 330:	16c000ef          	jal	49c <fstat>
 334:	892a                	mv	s2,a0
  close(fd);
 336:	8526                	mv	a0,s1
 338:	134000ef          	jal	46c <close>
  return r;
 33c:	64a2                	ld	s1,8(sp)
}
 33e:	854a                	mv	a0,s2
 340:	60e2                	ld	ra,24(sp)
 342:	6442                	ld	s0,16(sp)
 344:	6902                	ld	s2,0(sp)
 346:	6105                	addi	sp,sp,32
 348:	8082                	ret
    return -1;
 34a:	597d                	li	s2,-1
 34c:	bfcd                	j	33e <stat+0x2a>

000000000000034e <atoi>:

int
atoi(const char *s)
{
 34e:	1141                	addi	sp,sp,-16
 350:	e422                	sd	s0,8(sp)
 352:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 354:	00054683          	lbu	a3,0(a0)
 358:	fd06879b          	addiw	a5,a3,-48
 35c:	0ff7f793          	zext.b	a5,a5
 360:	4625                	li	a2,9
 362:	02f66863          	bltu	a2,a5,392 <atoi+0x44>
 366:	872a                	mv	a4,a0
  n = 0;
 368:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 36a:	0705                	addi	a4,a4,1
 36c:	0025179b          	slliw	a5,a0,0x2
 370:	9fa9                	addw	a5,a5,a0
 372:	0017979b          	slliw	a5,a5,0x1
 376:	9fb5                	addw	a5,a5,a3
 378:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 37c:	00074683          	lbu	a3,0(a4)
 380:	fd06879b          	addiw	a5,a3,-48
 384:	0ff7f793          	zext.b	a5,a5
 388:	fef671e3          	bgeu	a2,a5,36a <atoi+0x1c>
  return n;
}
 38c:	6422                	ld	s0,8(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret
  n = 0;
 392:	4501                	li	a0,0
 394:	bfe5                	j	38c <atoi+0x3e>

0000000000000396 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 396:	1141                	addi	sp,sp,-16
 398:	e422                	sd	s0,8(sp)
 39a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 39c:	02b57463          	bgeu	a0,a1,3c4 <memmove+0x2e>
    while(n-- > 0)
 3a0:	00c05f63          	blez	a2,3be <memmove+0x28>
 3a4:	1602                	slli	a2,a2,0x20
 3a6:	9201                	srli	a2,a2,0x20
 3a8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ac:	872a                	mv	a4,a0
      *dst++ = *src++;
 3ae:	0585                	addi	a1,a1,1
 3b0:	0705                	addi	a4,a4,1
 3b2:	fff5c683          	lbu	a3,-1(a1)
 3b6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3ba:	fef71ae3          	bne	a4,a5,3ae <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3be:	6422                	ld	s0,8(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret
    dst += n;
 3c4:	00c50733          	add	a4,a0,a2
    src += n;
 3c8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3ca:	fec05ae3          	blez	a2,3be <memmove+0x28>
 3ce:	fff6079b          	addiw	a5,a2,-1
 3d2:	1782                	slli	a5,a5,0x20
 3d4:	9381                	srli	a5,a5,0x20
 3d6:	fff7c793          	not	a5,a5
 3da:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3dc:	15fd                	addi	a1,a1,-1
 3de:	177d                	addi	a4,a4,-1
 3e0:	0005c683          	lbu	a3,0(a1)
 3e4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3e8:	fee79ae3          	bne	a5,a4,3dc <memmove+0x46>
 3ec:	bfc9                	j	3be <memmove+0x28>

00000000000003ee <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3ee:	1141                	addi	sp,sp,-16
 3f0:	e422                	sd	s0,8(sp)
 3f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3f4:	ca05                	beqz	a2,424 <memcmp+0x36>
 3f6:	fff6069b          	addiw	a3,a2,-1
 3fa:	1682                	slli	a3,a3,0x20
 3fc:	9281                	srli	a3,a3,0x20
 3fe:	0685                	addi	a3,a3,1
 400:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 402:	00054783          	lbu	a5,0(a0)
 406:	0005c703          	lbu	a4,0(a1)
 40a:	00e79863          	bne	a5,a4,41a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 40e:	0505                	addi	a0,a0,1
    p2++;
 410:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 412:	fed518e3          	bne	a0,a3,402 <memcmp+0x14>
  }
  return 0;
 416:	4501                	li	a0,0
 418:	a019                	j	41e <memcmp+0x30>
      return *p1 - *p2;
 41a:	40e7853b          	subw	a0,a5,a4
}
 41e:	6422                	ld	s0,8(sp)
 420:	0141                	addi	sp,sp,16
 422:	8082                	ret
  return 0;
 424:	4501                	li	a0,0
 426:	bfe5                	j	41e <memcmp+0x30>

0000000000000428 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 428:	1141                	addi	sp,sp,-16
 42a:	e406                	sd	ra,8(sp)
 42c:	e022                	sd	s0,0(sp)
 42e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 430:	f67ff0ef          	jal	396 <memmove>
}
 434:	60a2                	ld	ra,8(sp)
 436:	6402                	ld	s0,0(sp)
 438:	0141                	addi	sp,sp,16
 43a:	8082                	ret

000000000000043c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 43c:	4885                	li	a7,1
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <exit>:
.global exit
exit:
 li a7, SYS_exit
 444:	4889                	li	a7,2
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <wait>:
.global wait
wait:
 li a7, SYS_wait
 44c:	488d                	li	a7,3
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 454:	4891                	li	a7,4
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <read>:
.global read
read:
 li a7, SYS_read
 45c:	4895                	li	a7,5
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <write>:
.global write
write:
 li a7, SYS_write
 464:	48c1                	li	a7,16
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <close>:
.global close
close:
 li a7, SYS_close
 46c:	48d5                	li	a7,21
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <kill>:
.global kill
kill:
 li a7, SYS_kill
 474:	4899                	li	a7,6
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <exec>:
.global exec
exec:
 li a7, SYS_exec
 47c:	489d                	li	a7,7
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <open>:
.global open
open:
 li a7, SYS_open
 484:	48bd                	li	a7,15
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 48c:	48c5                	li	a7,17
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 494:	48c9                	li	a7,18
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 49c:	48a1                	li	a7,8
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <link>:
.global link
link:
 li a7, SYS_link
 4a4:	48cd                	li	a7,19
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ac:	48d1                	li	a7,20
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4b4:	48a5                	li	a7,9
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <dup>:
.global dup
dup:
 li a7, SYS_dup
 4bc:	48a9                	li	a7,10
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4c4:	48ad                	li	a7,11
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4cc:	48b1                	li	a7,12
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4d4:	48b5                	li	a7,13
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4dc:	48b9                	li	a7,14
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <yield>:
.global yield
yield:
 li a7, SYS_yield
 4e4:	48d9                	li	a7,22
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <getlev>:
.global getlev
getlev:
 li a7, SYS_getlev
 4ec:	48dd                	li	a7,23
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 4f4:	48e1                	li	a7,24
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <mlfqmode>:
.global mlfqmode
mlfqmode:
 li a7, SYS_mlfqmode
 4fc:	48e5                	li	a7,25
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <fcfsmode>:
.global fcfsmode
fcfsmode:
 li a7, SYS_fcfsmode
 504:	48e9                	li	a7,26
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <showfcfs>:
.global showfcfs
showfcfs:
 li a7, SYS_showfcfs
 50c:	48ed                	li	a7,27
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <showmlfq>:
.global showmlfq
showmlfq:
 li a7, SYS_showmlfq
 514:	48f1                	li	a7,28
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 51c:	1101                	addi	sp,sp,-32
 51e:	ec06                	sd	ra,24(sp)
 520:	e822                	sd	s0,16(sp)
 522:	1000                	addi	s0,sp,32
 524:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 528:	4605                	li	a2,1
 52a:	fef40593          	addi	a1,s0,-17
 52e:	f37ff0ef          	jal	464 <write>
}
 532:	60e2                	ld	ra,24(sp)
 534:	6442                	ld	s0,16(sp)
 536:	6105                	addi	sp,sp,32
 538:	8082                	ret

000000000000053a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 53a:	7139                	addi	sp,sp,-64
 53c:	fc06                	sd	ra,56(sp)
 53e:	f822                	sd	s0,48(sp)
 540:	f426                	sd	s1,40(sp)
 542:	0080                	addi	s0,sp,64
 544:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 546:	c299                	beqz	a3,54c <printint+0x12>
 548:	0805c963          	bltz	a1,5da <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 54c:	2581                	sext.w	a1,a1
  neg = 0;
 54e:	4881                	li	a7,0
 550:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 554:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 556:	2601                	sext.w	a2,a2
 558:	00000517          	auipc	a0,0x0
 55c:	72050513          	addi	a0,a0,1824 # c78 <digits>
 560:	883a                	mv	a6,a4
 562:	2705                	addiw	a4,a4,1
 564:	02c5f7bb          	remuw	a5,a1,a2
 568:	1782                	slli	a5,a5,0x20
 56a:	9381                	srli	a5,a5,0x20
 56c:	97aa                	add	a5,a5,a0
 56e:	0007c783          	lbu	a5,0(a5)
 572:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 576:	0005879b          	sext.w	a5,a1
 57a:	02c5d5bb          	divuw	a1,a1,a2
 57e:	0685                	addi	a3,a3,1
 580:	fec7f0e3          	bgeu	a5,a2,560 <printint+0x26>
  if(neg)
 584:	00088c63          	beqz	a7,59c <printint+0x62>
    buf[i++] = '-';
 588:	fd070793          	addi	a5,a4,-48
 58c:	00878733          	add	a4,a5,s0
 590:	02d00793          	li	a5,45
 594:	fef70823          	sb	a5,-16(a4)
 598:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 59c:	02e05a63          	blez	a4,5d0 <printint+0x96>
 5a0:	f04a                	sd	s2,32(sp)
 5a2:	ec4e                	sd	s3,24(sp)
 5a4:	fc040793          	addi	a5,s0,-64
 5a8:	00e78933          	add	s2,a5,a4
 5ac:	fff78993          	addi	s3,a5,-1
 5b0:	99ba                	add	s3,s3,a4
 5b2:	377d                	addiw	a4,a4,-1
 5b4:	1702                	slli	a4,a4,0x20
 5b6:	9301                	srli	a4,a4,0x20
 5b8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5bc:	fff94583          	lbu	a1,-1(s2)
 5c0:	8526                	mv	a0,s1
 5c2:	f5bff0ef          	jal	51c <putc>
  while(--i >= 0)
 5c6:	197d                	addi	s2,s2,-1
 5c8:	ff391ae3          	bne	s2,s3,5bc <printint+0x82>
 5cc:	7902                	ld	s2,32(sp)
 5ce:	69e2                	ld	s3,24(sp)
}
 5d0:	70e2                	ld	ra,56(sp)
 5d2:	7442                	ld	s0,48(sp)
 5d4:	74a2                	ld	s1,40(sp)
 5d6:	6121                	addi	sp,sp,64
 5d8:	8082                	ret
    x = -xx;
 5da:	40b005bb          	negw	a1,a1
    neg = 1;
 5de:	4885                	li	a7,1
    x = -xx;
 5e0:	bf85                	j	550 <printint+0x16>

00000000000005e2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5e2:	711d                	addi	sp,sp,-96
 5e4:	ec86                	sd	ra,88(sp)
 5e6:	e8a2                	sd	s0,80(sp)
 5e8:	e0ca                	sd	s2,64(sp)
 5ea:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ec:	0005c903          	lbu	s2,0(a1)
 5f0:	26090863          	beqz	s2,860 <vprintf+0x27e>
 5f4:	e4a6                	sd	s1,72(sp)
 5f6:	fc4e                	sd	s3,56(sp)
 5f8:	f852                	sd	s4,48(sp)
 5fa:	f456                	sd	s5,40(sp)
 5fc:	f05a                	sd	s6,32(sp)
 5fe:	ec5e                	sd	s7,24(sp)
 600:	e862                	sd	s8,16(sp)
 602:	e466                	sd	s9,8(sp)
 604:	8b2a                	mv	s6,a0
 606:	8a2e                	mv	s4,a1
 608:	8bb2                	mv	s7,a2
  state = 0;
 60a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 60c:	4481                	li	s1,0
 60e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 610:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 614:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 618:	06c00c93          	li	s9,108
 61c:	a005                	j	63c <vprintf+0x5a>
        putc(fd, c0);
 61e:	85ca                	mv	a1,s2
 620:	855a                	mv	a0,s6
 622:	efbff0ef          	jal	51c <putc>
 626:	a019                	j	62c <vprintf+0x4a>
    } else if(state == '%'){
 628:	03598263          	beq	s3,s5,64c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 62c:	2485                	addiw	s1,s1,1
 62e:	8726                	mv	a4,s1
 630:	009a07b3          	add	a5,s4,s1
 634:	0007c903          	lbu	s2,0(a5)
 638:	20090c63          	beqz	s2,850 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 63c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 640:	fe0994e3          	bnez	s3,628 <vprintf+0x46>
      if(c0 == '%'){
 644:	fd579de3          	bne	a5,s5,61e <vprintf+0x3c>
        state = '%';
 648:	89be                	mv	s3,a5
 64a:	b7cd                	j	62c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 64c:	00ea06b3          	add	a3,s4,a4
 650:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 654:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 656:	c681                	beqz	a3,65e <vprintf+0x7c>
 658:	9752                	add	a4,a4,s4
 65a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 65e:	03878f63          	beq	a5,s8,69c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 662:	05978963          	beq	a5,s9,6b4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 666:	07500713          	li	a4,117
 66a:	0ee78363          	beq	a5,a4,750 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 66e:	07800713          	li	a4,120
 672:	12e78563          	beq	a5,a4,79c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 676:	07000713          	li	a4,112
 67a:	14e78a63          	beq	a5,a4,7ce <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 67e:	07300713          	li	a4,115
 682:	18e78a63          	beq	a5,a4,816 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 686:	02500713          	li	a4,37
 68a:	04e79563          	bne	a5,a4,6d4 <vprintf+0xf2>
        putc(fd, '%');
 68e:	02500593          	li	a1,37
 692:	855a                	mv	a0,s6
 694:	e89ff0ef          	jal	51c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 698:	4981                	li	s3,0
 69a:	bf49                	j	62c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 69c:	008b8913          	addi	s2,s7,8
 6a0:	4685                	li	a3,1
 6a2:	4629                	li	a2,10
 6a4:	000ba583          	lw	a1,0(s7)
 6a8:	855a                	mv	a0,s6
 6aa:	e91ff0ef          	jal	53a <printint>
 6ae:	8bca                	mv	s7,s2
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	bfad                	j	62c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6b4:	06400793          	li	a5,100
 6b8:	02f68963          	beq	a3,a5,6ea <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6bc:	06c00793          	li	a5,108
 6c0:	04f68263          	beq	a3,a5,704 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6c4:	07500793          	li	a5,117
 6c8:	0af68063          	beq	a3,a5,768 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6cc:	07800793          	li	a5,120
 6d0:	0ef68263          	beq	a3,a5,7b4 <vprintf+0x1d2>
        putc(fd, '%');
 6d4:	02500593          	li	a1,37
 6d8:	855a                	mv	a0,s6
 6da:	e43ff0ef          	jal	51c <putc>
        putc(fd, c0);
 6de:	85ca                	mv	a1,s2
 6e0:	855a                	mv	a0,s6
 6e2:	e3bff0ef          	jal	51c <putc>
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	b791                	j	62c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ea:	008b8913          	addi	s2,s7,8
 6ee:	4685                	li	a3,1
 6f0:	4629                	li	a2,10
 6f2:	000ba583          	lw	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	e43ff0ef          	jal	53a <printint>
        i += 1;
 6fc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6fe:	8bca                	mv	s7,s2
      state = 0;
 700:	4981                	li	s3,0
        i += 1;
 702:	b72d                	j	62c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 704:	06400793          	li	a5,100
 708:	02f60763          	beq	a2,a5,736 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 70c:	07500793          	li	a5,117
 710:	06f60963          	beq	a2,a5,782 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 714:	07800793          	li	a5,120
 718:	faf61ee3          	bne	a2,a5,6d4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 71c:	008b8913          	addi	s2,s7,8
 720:	4681                	li	a3,0
 722:	4641                	li	a2,16
 724:	000ba583          	lw	a1,0(s7)
 728:	855a                	mv	a0,s6
 72a:	e11ff0ef          	jal	53a <printint>
        i += 2;
 72e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 730:	8bca                	mv	s7,s2
      state = 0;
 732:	4981                	li	s3,0
        i += 2;
 734:	bde5                	j	62c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 736:	008b8913          	addi	s2,s7,8
 73a:	4685                	li	a3,1
 73c:	4629                	li	a2,10
 73e:	000ba583          	lw	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	df7ff0ef          	jal	53a <printint>
        i += 2;
 748:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 74a:	8bca                	mv	s7,s2
      state = 0;
 74c:	4981                	li	s3,0
        i += 2;
 74e:	bdf9                	j	62c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 750:	008b8913          	addi	s2,s7,8
 754:	4681                	li	a3,0
 756:	4629                	li	a2,10
 758:	000ba583          	lw	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	dddff0ef          	jal	53a <printint>
 762:	8bca                	mv	s7,s2
      state = 0;
 764:	4981                	li	s3,0
 766:	b5d9                	j	62c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 768:	008b8913          	addi	s2,s7,8
 76c:	4681                	li	a3,0
 76e:	4629                	li	a2,10
 770:	000ba583          	lw	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	dc5ff0ef          	jal	53a <printint>
        i += 1;
 77a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 77c:	8bca                	mv	s7,s2
      state = 0;
 77e:	4981                	li	s3,0
        i += 1;
 780:	b575                	j	62c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 782:	008b8913          	addi	s2,s7,8
 786:	4681                	li	a3,0
 788:	4629                	li	a2,10
 78a:	000ba583          	lw	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	dabff0ef          	jal	53a <printint>
        i += 2;
 794:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 796:	8bca                	mv	s7,s2
      state = 0;
 798:	4981                	li	s3,0
        i += 2;
 79a:	bd49                	j	62c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 79c:	008b8913          	addi	s2,s7,8
 7a0:	4681                	li	a3,0
 7a2:	4641                	li	a2,16
 7a4:	000ba583          	lw	a1,0(s7)
 7a8:	855a                	mv	a0,s6
 7aa:	d91ff0ef          	jal	53a <printint>
 7ae:	8bca                	mv	s7,s2
      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	bdad                	j	62c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b4:	008b8913          	addi	s2,s7,8
 7b8:	4681                	li	a3,0
 7ba:	4641                	li	a2,16
 7bc:	000ba583          	lw	a1,0(s7)
 7c0:	855a                	mv	a0,s6
 7c2:	d79ff0ef          	jal	53a <printint>
        i += 1;
 7c6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7c8:	8bca                	mv	s7,s2
      state = 0;
 7ca:	4981                	li	s3,0
        i += 1;
 7cc:	b585                	j	62c <vprintf+0x4a>
 7ce:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7d0:	008b8d13          	addi	s10,s7,8
 7d4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7d8:	03000593          	li	a1,48
 7dc:	855a                	mv	a0,s6
 7de:	d3fff0ef          	jal	51c <putc>
  putc(fd, 'x');
 7e2:	07800593          	li	a1,120
 7e6:	855a                	mv	a0,s6
 7e8:	d35ff0ef          	jal	51c <putc>
 7ec:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7ee:	00000b97          	auipc	s7,0x0
 7f2:	48ab8b93          	addi	s7,s7,1162 # c78 <digits>
 7f6:	03c9d793          	srli	a5,s3,0x3c
 7fa:	97de                	add	a5,a5,s7
 7fc:	0007c583          	lbu	a1,0(a5)
 800:	855a                	mv	a0,s6
 802:	d1bff0ef          	jal	51c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 806:	0992                	slli	s3,s3,0x4
 808:	397d                	addiw	s2,s2,-1
 80a:	fe0916e3          	bnez	s2,7f6 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 80e:	8bea                	mv	s7,s10
      state = 0;
 810:	4981                	li	s3,0
 812:	6d02                	ld	s10,0(sp)
 814:	bd21                	j	62c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 816:	008b8993          	addi	s3,s7,8
 81a:	000bb903          	ld	s2,0(s7)
 81e:	00090f63          	beqz	s2,83c <vprintf+0x25a>
        for(; *s; s++)
 822:	00094583          	lbu	a1,0(s2)
 826:	c195                	beqz	a1,84a <vprintf+0x268>
          putc(fd, *s);
 828:	855a                	mv	a0,s6
 82a:	cf3ff0ef          	jal	51c <putc>
        for(; *s; s++)
 82e:	0905                	addi	s2,s2,1
 830:	00094583          	lbu	a1,0(s2)
 834:	f9f5                	bnez	a1,828 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 836:	8bce                	mv	s7,s3
      state = 0;
 838:	4981                	li	s3,0
 83a:	bbcd                	j	62c <vprintf+0x4a>
          s = "(null)";
 83c:	00000917          	auipc	s2,0x0
 840:	43490913          	addi	s2,s2,1076 # c70 <malloc+0x328>
        for(; *s; s++)
 844:	02800593          	li	a1,40
 848:	b7c5                	j	828 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 84a:	8bce                	mv	s7,s3
      state = 0;
 84c:	4981                	li	s3,0
 84e:	bbf9                	j	62c <vprintf+0x4a>
 850:	64a6                	ld	s1,72(sp)
 852:	79e2                	ld	s3,56(sp)
 854:	7a42                	ld	s4,48(sp)
 856:	7aa2                	ld	s5,40(sp)
 858:	7b02                	ld	s6,32(sp)
 85a:	6be2                	ld	s7,24(sp)
 85c:	6c42                	ld	s8,16(sp)
 85e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 860:	60e6                	ld	ra,88(sp)
 862:	6446                	ld	s0,80(sp)
 864:	6906                	ld	s2,64(sp)
 866:	6125                	addi	sp,sp,96
 868:	8082                	ret

000000000000086a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 86a:	715d                	addi	sp,sp,-80
 86c:	ec06                	sd	ra,24(sp)
 86e:	e822                	sd	s0,16(sp)
 870:	1000                	addi	s0,sp,32
 872:	e010                	sd	a2,0(s0)
 874:	e414                	sd	a3,8(s0)
 876:	e818                	sd	a4,16(s0)
 878:	ec1c                	sd	a5,24(s0)
 87a:	03043023          	sd	a6,32(s0)
 87e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 882:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 886:	8622                	mv	a2,s0
 888:	d5bff0ef          	jal	5e2 <vprintf>
}
 88c:	60e2                	ld	ra,24(sp)
 88e:	6442                	ld	s0,16(sp)
 890:	6161                	addi	sp,sp,80
 892:	8082                	ret

0000000000000894 <printf>:

void
printf(const char *fmt, ...)
{
 894:	711d                	addi	sp,sp,-96
 896:	ec06                	sd	ra,24(sp)
 898:	e822                	sd	s0,16(sp)
 89a:	1000                	addi	s0,sp,32
 89c:	e40c                	sd	a1,8(s0)
 89e:	e810                	sd	a2,16(s0)
 8a0:	ec14                	sd	a3,24(s0)
 8a2:	f018                	sd	a4,32(s0)
 8a4:	f41c                	sd	a5,40(s0)
 8a6:	03043823          	sd	a6,48(s0)
 8aa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ae:	00840613          	addi	a2,s0,8
 8b2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8b6:	85aa                	mv	a1,a0
 8b8:	4505                	li	a0,1
 8ba:	d29ff0ef          	jal	5e2 <vprintf>
}
 8be:	60e2                	ld	ra,24(sp)
 8c0:	6442                	ld	s0,16(sp)
 8c2:	6125                	addi	sp,sp,96
 8c4:	8082                	ret

00000000000008c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c6:	1141                	addi	sp,sp,-16
 8c8:	e422                	sd	s0,8(sp)
 8ca:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8cc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d0:	00001797          	auipc	a5,0x1
 8d4:	7307b783          	ld	a5,1840(a5) # 2000 <freep>
 8d8:	a02d                	j	902 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8da:	4618                	lw	a4,8(a2)
 8dc:	9f2d                	addw	a4,a4,a1
 8de:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8e2:	6398                	ld	a4,0(a5)
 8e4:	6310                	ld	a2,0(a4)
 8e6:	a83d                	j	924 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8e8:	ff852703          	lw	a4,-8(a0)
 8ec:	9f31                	addw	a4,a4,a2
 8ee:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8f0:	ff053683          	ld	a3,-16(a0)
 8f4:	a091                	j	938 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f6:	6398                	ld	a4,0(a5)
 8f8:	00e7e463          	bltu	a5,a4,900 <free+0x3a>
 8fc:	00e6ea63          	bltu	a3,a4,910 <free+0x4a>
{
 900:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 902:	fed7fae3          	bgeu	a5,a3,8f6 <free+0x30>
 906:	6398                	ld	a4,0(a5)
 908:	00e6e463          	bltu	a3,a4,910 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90c:	fee7eae3          	bltu	a5,a4,900 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 910:	ff852583          	lw	a1,-8(a0)
 914:	6390                	ld	a2,0(a5)
 916:	02059813          	slli	a6,a1,0x20
 91a:	01c85713          	srli	a4,a6,0x1c
 91e:	9736                	add	a4,a4,a3
 920:	fae60de3          	beq	a2,a4,8da <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 924:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 928:	4790                	lw	a2,8(a5)
 92a:	02061593          	slli	a1,a2,0x20
 92e:	01c5d713          	srli	a4,a1,0x1c
 932:	973e                	add	a4,a4,a5
 934:	fae68ae3          	beq	a3,a4,8e8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 938:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 93a:	00001717          	auipc	a4,0x1
 93e:	6cf73323          	sd	a5,1734(a4) # 2000 <freep>
}
 942:	6422                	ld	s0,8(sp)
 944:	0141                	addi	sp,sp,16
 946:	8082                	ret

0000000000000948 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 948:	7139                	addi	sp,sp,-64
 94a:	fc06                	sd	ra,56(sp)
 94c:	f822                	sd	s0,48(sp)
 94e:	f426                	sd	s1,40(sp)
 950:	ec4e                	sd	s3,24(sp)
 952:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 954:	02051493          	slli	s1,a0,0x20
 958:	9081                	srli	s1,s1,0x20
 95a:	04bd                	addi	s1,s1,15
 95c:	8091                	srli	s1,s1,0x4
 95e:	0014899b          	addiw	s3,s1,1
 962:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 964:	00001517          	auipc	a0,0x1
 968:	69c53503          	ld	a0,1692(a0) # 2000 <freep>
 96c:	c915                	beqz	a0,9a0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 970:	4798                	lw	a4,8(a5)
 972:	08977a63          	bgeu	a4,s1,a06 <malloc+0xbe>
 976:	f04a                	sd	s2,32(sp)
 978:	e852                	sd	s4,16(sp)
 97a:	e456                	sd	s5,8(sp)
 97c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 97e:	8a4e                	mv	s4,s3
 980:	0009871b          	sext.w	a4,s3
 984:	6685                	lui	a3,0x1
 986:	00d77363          	bgeu	a4,a3,98c <malloc+0x44>
 98a:	6a05                	lui	s4,0x1
 98c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 990:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 994:	00001917          	auipc	s2,0x1
 998:	66c90913          	addi	s2,s2,1644 # 2000 <freep>
  if(p == (char*)-1)
 99c:	5afd                	li	s5,-1
 99e:	a081                	j	9de <malloc+0x96>
 9a0:	f04a                	sd	s2,32(sp)
 9a2:	e852                	sd	s4,16(sp)
 9a4:	e456                	sd	s5,8(sp)
 9a6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9a8:	00001797          	auipc	a5,0x1
 9ac:	66878793          	addi	a5,a5,1640 # 2010 <base>
 9b0:	00001717          	auipc	a4,0x1
 9b4:	64f73823          	sd	a5,1616(a4) # 2000 <freep>
 9b8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ba:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9be:	b7c1                	j	97e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9c0:	6398                	ld	a4,0(a5)
 9c2:	e118                	sd	a4,0(a0)
 9c4:	a8a9                	j	a1e <malloc+0xd6>
  hp->s.size = nu;
 9c6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9ca:	0541                	addi	a0,a0,16
 9cc:	efbff0ef          	jal	8c6 <free>
  return freep;
 9d0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9d4:	c12d                	beqz	a0,a36 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d8:	4798                	lw	a4,8(a5)
 9da:	02977263          	bgeu	a4,s1,9fe <malloc+0xb6>
    if(p == freep)
 9de:	00093703          	ld	a4,0(s2)
 9e2:	853e                	mv	a0,a5
 9e4:	fef719e3          	bne	a4,a5,9d6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 9e8:	8552                	mv	a0,s4
 9ea:	ae3ff0ef          	jal	4cc <sbrk>
  if(p == (char*)-1)
 9ee:	fd551ce3          	bne	a0,s5,9c6 <malloc+0x7e>
        return 0;
 9f2:	4501                	li	a0,0
 9f4:	7902                	ld	s2,32(sp)
 9f6:	6a42                	ld	s4,16(sp)
 9f8:	6aa2                	ld	s5,8(sp)
 9fa:	6b02                	ld	s6,0(sp)
 9fc:	a03d                	j	a2a <malloc+0xe2>
 9fe:	7902                	ld	s2,32(sp)
 a00:	6a42                	ld	s4,16(sp)
 a02:	6aa2                	ld	s5,8(sp)
 a04:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a06:	fae48de3          	beq	s1,a4,9c0 <malloc+0x78>
        p->s.size -= nunits;
 a0a:	4137073b          	subw	a4,a4,s3
 a0e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a10:	02071693          	slli	a3,a4,0x20
 a14:	01c6d713          	srli	a4,a3,0x1c
 a18:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a1a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a1e:	00001717          	auipc	a4,0x1
 a22:	5ea73123          	sd	a0,1506(a4) # 2000 <freep>
      return (void*)(p + 1);
 a26:	01078513          	addi	a0,a5,16
  }
}
 a2a:	70e2                	ld	ra,56(sp)
 a2c:	7442                	ld	s0,48(sp)
 a2e:	74a2                	ld	s1,40(sp)
 a30:	69e2                	ld	s3,24(sp)
 a32:	6121                	addi	sp,sp,64
 a34:	8082                	ret
 a36:	7902                	ld	s2,32(sp)
 a38:	6a42                	ld	s4,16(sp)
 a3a:	6aa2                	ld	s5,8(sp)
 a3c:	6b02                	ld	s6,0(sp)
 a3e:	b7f5                	j	a2a <malloc+0xe2>
