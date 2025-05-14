
user/_test1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fork_children>:
int parent;
int fcfs_pids[NUM_THREAD];
int fcfs_count[100] = {0};

int fork_children()
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	4491                	li	s1,4
  int i, p;
  for (i = 0; i < NUM_THREAD; i++) {
    if ((p = fork()) == 0) {
   c:	45a000ef          	jal	466 <fork>
  10:	cd01                	beqz	a0,28 <fork_children+0x28>
  for (i = 0; i < NUM_THREAD; i++) {
  12:	34fd                	addiw	s1,s1,-1
  14:	fce5                	bnez	s1,c <fork_children+0xc>
      return getpid();
    } 
  }
  return parent;
  16:	00002517          	auipc	a0,0x2
  1a:	fea52503          	lw	a0,-22(a0) # 2000 <parent>
}
  1e:	60e2                	ld	ra,24(sp)
  20:	6442                	ld	s0,16(sp)
  22:	64a2                	ld	s1,8(sp)
  24:	6105                	addi	sp,sp,32
  26:	8082                	ret
      return getpid();
  28:	4c6000ef          	jal	4ee <getpid>
  2c:	bfcd                	j	1e <fork_children+0x1e>

000000000000002e <exit_children>:

void exit_children()
{
  2e:	7179                	addi	sp,sp,-48
  30:	f406                	sd	ra,40(sp)
  32:	f022                	sd	s0,32(sp)
  34:	ec26                	sd	s1,24(sp)
  36:	1800                	addi	s0,sp,48
  if (getpid() != parent)
  38:	4b6000ef          	jal	4ee <getpid>
  3c:	00002797          	auipc	a5,0x2
  40:	fc47a783          	lw	a5,-60(a5) # 2000 <parent>
    exit(0);
  int status;
  while (wait(&status) != -1);
  44:	54fd                	li	s1,-1
  if (getpid() != parent)
  46:	00a79d63          	bne	a5,a0,60 <exit_children+0x32>
  while (wait(&status) != -1);
  4a:	fdc40513          	addi	a0,s0,-36
  4e:	428000ef          	jal	476 <wait>
  52:	fe951ce3          	bne	a0,s1,4a <exit_children+0x1c>
}
  56:	70a2                	ld	ra,40(sp)
  58:	7402                	ld	s0,32(sp)
  5a:	64e2                	ld	s1,24(sp)
  5c:	6145                	addi	sp,sp,48
  5e:	8082                	ret
    exit(0);
  60:	4501                	li	a0,0
  62:	40c000ef          	jal	46e <exit>

0000000000000066 <main>:

int main(int argc, char *argv[])
{
  66:	7139                	addi	sp,sp,-64
  68:	fc06                	sd	ra,56(sp)
  6a:	f822                	sd	s0,48(sp)
  6c:	f426                	sd	s1,40(sp)
  6e:	f04a                	sd	s2,32(sp)
  70:	ec4e                	sd	s3,24(sp)
  72:	e852                	sd	s4,16(sp)
  74:	0080                	addi	s0,sp,64
  int i, pid;
  int count[MAX_LEVEL] = {0};
  76:	fc043023          	sd	zero,-64(s0)
  7a:	fc042423          	sw	zero,-56(s0)

  parent = getpid();
  7e:	470000ef          	jal	4ee <getpid>
  82:	00002497          	auipc	s1,0x2
  86:	f7e48493          	addi	s1,s1,-130 # 2000 <parent>
  8a:	c088                	sw	a0,0(s1)

  printf("FCFS & MLFQ test start\n\n");
  8c:	00001517          	auipc	a0,0x1
  90:	9e450513          	addi	a0,a0,-1564 # a70 <malloc+0xfe>
  94:	02b000ef          	jal	8be <printf>

  // [Test 1] FCFS test
  printf("[Test 1] FCFS Queue Execution Order\n");
  98:	00001517          	auipc	a0,0x1
  9c:	9f850513          	addi	a0,a0,-1544 # a90 <malloc+0x11e>
  a0:	01f000ef          	jal	8be <printf>
  pid = fork_children();
  a4:	f5dff0ef          	jal	0 <fork_children>

  if (pid != parent)
  a8:	409c                	lw	a5,0(s1)
  aa:	04a78763          	beq	a5,a0,f8 <main+0x92>
  ae:	85aa                	mv	a1,a0
  {
    while(fcfs_count[pid] < NUM_LOOP)
  b0:	00251713          	slli	a4,a0,0x2
  b4:	00002797          	auipc	a5,0x2
  b8:	f5c78793          	addi	a5,a5,-164 # 2010 <fcfs_count>
  bc:	97ba                	add	a5,a5,a4
  be:	4390                	lw	a2,0(a5)
  c0:	67e1                	lui	a5,0x18
  c2:	69f78793          	addi	a5,a5,1695 # 1869f <base+0x164ef>
  c6:	02c7c363          	blt	a5,a2,ec <main+0x86>
  ca:	67e1                	lui	a5,0x18
  cc:	6a078793          	addi	a5,a5,1696 # 186a0 <base+0x164f0>
    {
      fcfs_count[pid]++;
  d0:	2605                	addiw	a2,a2,1
    while(fcfs_count[pid] < NUM_LOOP)
  d2:	fef61fe3          	bne	a2,a5,d0 <main+0x6a>
  d6:	00259713          	slli	a4,a1,0x2
  da:	00002797          	auipc	a5,0x2
  de:	f3678793          	addi	a5,a5,-202 # 2010 <fcfs_count>
  e2:	97ba                	add	a5,a5,a4
  e4:	6761                	lui	a4,0x18
  e6:	6a070713          	addi	a4,a4,1696 # 186a0 <base+0x164f0>
  ea:	c398                	sw	a4,0(a5)
    }

    printf("Process %d executed %d times\n", pid, fcfs_count[pid]);
  ec:	00001517          	auipc	a0,0x1
  f0:	9cc50513          	addi	a0,a0,-1588 # ab8 <malloc+0x146>
  f4:	7ca000ef          	jal	8be <printf>
  }
  exit_children();
  f8:	f37ff0ef          	jal	2e <exit_children>
  printf("[Test 1] FCFS Test Finished\n\n");
  fc:	00001517          	auipc	a0,0x1
 100:	9dc50513          	addi	a0,a0,-1572 # ad8 <malloc+0x166>
 104:	7ba000ef          	jal	8be <printf>

  // Switch to FCFS mode - should not be changed
  if(fcfsmode() == 0) printf("successfully changed to FCFS mode!\n");
 108:	426000ef          	jal	52e <fcfsmode>
 10c:	e561                	bnez	a0,1d4 <main+0x16e>
 10e:	00001517          	auipc	a0,0x1
 112:	9ea50513          	addi	a0,a0,-1558 # af8 <malloc+0x186>
 116:	7a8000ef          	jal	8be <printf>
  else printf("nothing has been changed\n");

  // Switch to MLFQ mode
  if(mlfqmode() == 0) printf("successfully changed to MLFQ mode!\n");
 11a:	40c000ef          	jal	526 <mlfqmode>
 11e:	e171                	bnez	a0,1e2 <main+0x17c>
 120:	00001517          	auipc	a0,0x1
 124:	a2050513          	addi	a0,a0,-1504 # b40 <malloc+0x1ce>
 128:	796000ef          	jal	8be <printf>
  else printf("nothing has been changed\n");

  // [Test 2] MLFQ test
  printf("\n[Test 2] MLFQ Scheduling\n");
 12c:	00001517          	auipc	a0,0x1
 130:	a3c50513          	addi	a0,a0,-1476 # b68 <malloc+0x1f6>
 134:	78a000ef          	jal	8be <printf>
  pid = fork_children();
 138:	ec9ff0ef          	jal	0 <fork_children>
 13c:	89aa                	mv	s3,a0

  if (pid != parent)
 13e:	00002797          	auipc	a5,0x2
 142:	ec27a783          	lw	a5,-318(a5) # 2000 <parent>
 146:	06a78663          	beq	a5,a0,1b2 <main+0x14c>
 14a:	64e1                	lui	s1,0x18
 14c:	6a048493          	addi	s1,s1,1696 # 186a0 <base+0x164f0>
  {
    for (i = 0; i < NUM_LOOP; i++)
    {
      int x = getlev();
      if (x < 0 || x >= MAX_LEVEL)
 150:	4909                	li	s2,2
      int x = getlev();
 152:	3c4000ef          	jal	516 <getlev>
      if (x < 0 || x >= MAX_LEVEL)
 156:	0005079b          	sext.w	a5,a0
 15a:	08f96b63          	bltu	s2,a5,1f0 <main+0x18a>
      {
        printf("Wrong level: %d\n", x);
        exit(1);
      }
      count[x]++;
 15e:	050a                	slli	a0,a0,0x2
 160:	fd050793          	addi	a5,a0,-48
 164:	00878533          	add	a0,a5,s0
 168:	ff052783          	lw	a5,-16(a0)
 16c:	2785                	addiw	a5,a5,1
 16e:	fef52823          	sw	a5,-16(a0)
    for (i = 0; i < NUM_LOOP; i++)
 172:	34fd                	addiw	s1,s1,-1
 174:	fcf9                	bnez	s1,152 <main+0xec>
    }
    printf("Checking level's hit count...\n");
 176:	00001517          	auipc	a0,0x1
 17a:	a2a50513          	addi	a0,a0,-1494 # ba0 <malloc+0x22e>
 17e:	740000ef          	jal	8be <printf>

    printf("Process %d (MLFQ L0-L2 hit count):\n", pid);
 182:	85ce                	mv	a1,s3
 184:	00001517          	auipc	a0,0x1
 188:	a3c50513          	addi	a0,a0,-1476 # bc0 <malloc+0x24e>
 18c:	732000ef          	jal	8be <printf>
    for (i = 0; i < MAX_LEVEL; i++)
 190:	fc040913          	addi	s2,s0,-64
      printf("L%d: %d\n", i, count[i]);
 194:	00001a17          	auipc	s4,0x1
 198:	a54a0a13          	addi	s4,s4,-1452 # be8 <malloc+0x276>
    for (i = 0; i < MAX_LEVEL; i++)
 19c:	498d                	li	s3,3
      printf("L%d: %d\n", i, count[i]);
 19e:	00092603          	lw	a2,0(s2)
 1a2:	85a6                	mv	a1,s1
 1a4:	8552                	mv	a0,s4
 1a6:	718000ef          	jal	8be <printf>
    for (i = 0; i < MAX_LEVEL; i++)
 1aa:	2485                	addiw	s1,s1,1
 1ac:	0911                	addi	s2,s2,4
 1ae:	ff3498e3          	bne	s1,s3,19e <main+0x138>
  }
  exit_children();
 1b2:	e7dff0ef          	jal	2e <exit_children>

  printf("[Test 2] MLFQ Test Finished\n");
 1b6:	00001517          	auipc	a0,0x1
 1ba:	a4250513          	addi	a0,a0,-1470 # bf8 <malloc+0x286>
 1be:	700000ef          	jal	8be <printf>
  printf("\nFCFS & MLFQ test completed!\n");
 1c2:	00001517          	auipc	a0,0x1
 1c6:	a5650513          	addi	a0,a0,-1450 # c18 <malloc+0x2a6>
 1ca:	6f4000ef          	jal	8be <printf>
  exit(0);
 1ce:	4501                	li	a0,0
 1d0:	29e000ef          	jal	46e <exit>
  else printf("nothing has been changed\n");
 1d4:	00001517          	auipc	a0,0x1
 1d8:	94c50513          	addi	a0,a0,-1716 # b20 <malloc+0x1ae>
 1dc:	6e2000ef          	jal	8be <printf>
 1e0:	bf2d                	j	11a <main+0xb4>
  else printf("nothing has been changed\n");
 1e2:	00001517          	auipc	a0,0x1
 1e6:	93e50513          	addi	a0,a0,-1730 # b20 <malloc+0x1ae>
 1ea:	6d4000ef          	jal	8be <printf>
 1ee:	bf3d                	j	12c <main+0xc6>
        printf("Wrong level: %d\n", x);
 1f0:	85aa                	mv	a1,a0
 1f2:	00001517          	auipc	a0,0x1
 1f6:	99650513          	addi	a0,a0,-1642 # b88 <malloc+0x216>
 1fa:	6c4000ef          	jal	8be <printf>
        exit(1);
 1fe:	4505                	li	a0,1
 200:	26e000ef          	jal	46e <exit>

0000000000000204 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 204:	1141                	addi	sp,sp,-16
 206:	e406                	sd	ra,8(sp)
 208:	e022                	sd	s0,0(sp)
 20a:	0800                	addi	s0,sp,16
  extern int main();
  main();
 20c:	e5bff0ef          	jal	66 <main>
  exit(0);
 210:	4501                	li	a0,0
 212:	25c000ef          	jal	46e <exit>

0000000000000216 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 216:	1141                	addi	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 21c:	87aa                	mv	a5,a0
 21e:	0585                	addi	a1,a1,1
 220:	0785                	addi	a5,a5,1
 222:	fff5c703          	lbu	a4,-1(a1)
 226:	fee78fa3          	sb	a4,-1(a5)
 22a:	fb75                	bnez	a4,21e <strcpy+0x8>
    ;
  return os;
}
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret

0000000000000232 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 238:	00054783          	lbu	a5,0(a0)
 23c:	cb91                	beqz	a5,250 <strcmp+0x1e>
 23e:	0005c703          	lbu	a4,0(a1)
 242:	00f71763          	bne	a4,a5,250 <strcmp+0x1e>
    p++, q++;
 246:	0505                	addi	a0,a0,1
 248:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 24a:	00054783          	lbu	a5,0(a0)
 24e:	fbe5                	bnez	a5,23e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 250:	0005c503          	lbu	a0,0(a1)
}
 254:	40a7853b          	subw	a0,a5,a0
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	addi	sp,sp,16
 25c:	8082                	ret

000000000000025e <strlen>:

uint
strlen(const char *s)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e422                	sd	s0,8(sp)
 262:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 264:	00054783          	lbu	a5,0(a0)
 268:	cf91                	beqz	a5,284 <strlen+0x26>
 26a:	0505                	addi	a0,a0,1
 26c:	87aa                	mv	a5,a0
 26e:	86be                	mv	a3,a5
 270:	0785                	addi	a5,a5,1
 272:	fff7c703          	lbu	a4,-1(a5)
 276:	ff65                	bnez	a4,26e <strlen+0x10>
 278:	40a6853b          	subw	a0,a3,a0
 27c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 27e:	6422                	ld	s0,8(sp)
 280:	0141                	addi	sp,sp,16
 282:	8082                	ret
  for(n = 0; s[n]; n++)
 284:	4501                	li	a0,0
 286:	bfe5                	j	27e <strlen+0x20>

0000000000000288 <memset>:

void*
memset(void *dst, int c, uint n)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e422                	sd	s0,8(sp)
 28c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 28e:	ca19                	beqz	a2,2a4 <memset+0x1c>
 290:	87aa                	mv	a5,a0
 292:	1602                	slli	a2,a2,0x20
 294:	9201                	srli	a2,a2,0x20
 296:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 29a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 29e:	0785                	addi	a5,a5,1
 2a0:	fee79de3          	bne	a5,a4,29a <memset+0x12>
  }
  return dst;
}
 2a4:	6422                	ld	s0,8(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret

00000000000002aa <strchr>:

char*
strchr(const char *s, char c)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e422                	sd	s0,8(sp)
 2ae:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2b0:	00054783          	lbu	a5,0(a0)
 2b4:	cb99                	beqz	a5,2ca <strchr+0x20>
    if(*s == c)
 2b6:	00f58763          	beq	a1,a5,2c4 <strchr+0x1a>
  for(; *s; s++)
 2ba:	0505                	addi	a0,a0,1
 2bc:	00054783          	lbu	a5,0(a0)
 2c0:	fbfd                	bnez	a5,2b6 <strchr+0xc>
      return (char*)s;
  return 0;
 2c2:	4501                	li	a0,0
}
 2c4:	6422                	ld	s0,8(sp)
 2c6:	0141                	addi	sp,sp,16
 2c8:	8082                	ret
  return 0;
 2ca:	4501                	li	a0,0
 2cc:	bfe5                	j	2c4 <strchr+0x1a>

00000000000002ce <gets>:

char*
gets(char *buf, int max)
{
 2ce:	711d                	addi	sp,sp,-96
 2d0:	ec86                	sd	ra,88(sp)
 2d2:	e8a2                	sd	s0,80(sp)
 2d4:	e4a6                	sd	s1,72(sp)
 2d6:	e0ca                	sd	s2,64(sp)
 2d8:	fc4e                	sd	s3,56(sp)
 2da:	f852                	sd	s4,48(sp)
 2dc:	f456                	sd	s5,40(sp)
 2de:	f05a                	sd	s6,32(sp)
 2e0:	ec5e                	sd	s7,24(sp)
 2e2:	1080                	addi	s0,sp,96
 2e4:	8baa                	mv	s7,a0
 2e6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2e8:	892a                	mv	s2,a0
 2ea:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2ec:	4aa9                	li	s5,10
 2ee:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2f0:	89a6                	mv	s3,s1
 2f2:	2485                	addiw	s1,s1,1
 2f4:	0344d663          	bge	s1,s4,320 <gets+0x52>
    cc = read(0, &c, 1);
 2f8:	4605                	li	a2,1
 2fa:	faf40593          	addi	a1,s0,-81
 2fe:	4501                	li	a0,0
 300:	186000ef          	jal	486 <read>
    if(cc < 1)
 304:	00a05e63          	blez	a0,320 <gets+0x52>
    buf[i++] = c;
 308:	faf44783          	lbu	a5,-81(s0)
 30c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 310:	01578763          	beq	a5,s5,31e <gets+0x50>
 314:	0905                	addi	s2,s2,1
 316:	fd679de3          	bne	a5,s6,2f0 <gets+0x22>
    buf[i++] = c;
 31a:	89a6                	mv	s3,s1
 31c:	a011                	j	320 <gets+0x52>
 31e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 320:	99de                	add	s3,s3,s7
 322:	00098023          	sb	zero,0(s3)
  return buf;
}
 326:	855e                	mv	a0,s7
 328:	60e6                	ld	ra,88(sp)
 32a:	6446                	ld	s0,80(sp)
 32c:	64a6                	ld	s1,72(sp)
 32e:	6906                	ld	s2,64(sp)
 330:	79e2                	ld	s3,56(sp)
 332:	7a42                	ld	s4,48(sp)
 334:	7aa2                	ld	s5,40(sp)
 336:	7b02                	ld	s6,32(sp)
 338:	6be2                	ld	s7,24(sp)
 33a:	6125                	addi	sp,sp,96
 33c:	8082                	ret

000000000000033e <stat>:

int
stat(const char *n, struct stat *st)
{
 33e:	1101                	addi	sp,sp,-32
 340:	ec06                	sd	ra,24(sp)
 342:	e822                	sd	s0,16(sp)
 344:	e04a                	sd	s2,0(sp)
 346:	1000                	addi	s0,sp,32
 348:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 34a:	4581                	li	a1,0
 34c:	162000ef          	jal	4ae <open>
  if(fd < 0)
 350:	02054263          	bltz	a0,374 <stat+0x36>
 354:	e426                	sd	s1,8(sp)
 356:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 358:	85ca                	mv	a1,s2
 35a:	16c000ef          	jal	4c6 <fstat>
 35e:	892a                	mv	s2,a0
  close(fd);
 360:	8526                	mv	a0,s1
 362:	134000ef          	jal	496 <close>
  return r;
 366:	64a2                	ld	s1,8(sp)
}
 368:	854a                	mv	a0,s2
 36a:	60e2                	ld	ra,24(sp)
 36c:	6442                	ld	s0,16(sp)
 36e:	6902                	ld	s2,0(sp)
 370:	6105                	addi	sp,sp,32
 372:	8082                	ret
    return -1;
 374:	597d                	li	s2,-1
 376:	bfcd                	j	368 <stat+0x2a>

0000000000000378 <atoi>:

int
atoi(const char *s)
{
 378:	1141                	addi	sp,sp,-16
 37a:	e422                	sd	s0,8(sp)
 37c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 37e:	00054683          	lbu	a3,0(a0)
 382:	fd06879b          	addiw	a5,a3,-48
 386:	0ff7f793          	zext.b	a5,a5
 38a:	4625                	li	a2,9
 38c:	02f66863          	bltu	a2,a5,3bc <atoi+0x44>
 390:	872a                	mv	a4,a0
  n = 0;
 392:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 394:	0705                	addi	a4,a4,1
 396:	0025179b          	slliw	a5,a0,0x2
 39a:	9fa9                	addw	a5,a5,a0
 39c:	0017979b          	slliw	a5,a5,0x1
 3a0:	9fb5                	addw	a5,a5,a3
 3a2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3a6:	00074683          	lbu	a3,0(a4)
 3aa:	fd06879b          	addiw	a5,a3,-48
 3ae:	0ff7f793          	zext.b	a5,a5
 3b2:	fef671e3          	bgeu	a2,a5,394 <atoi+0x1c>
  return n;
}
 3b6:	6422                	ld	s0,8(sp)
 3b8:	0141                	addi	sp,sp,16
 3ba:	8082                	ret
  n = 0;
 3bc:	4501                	li	a0,0
 3be:	bfe5                	j	3b6 <atoi+0x3e>

00000000000003c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3c0:	1141                	addi	sp,sp,-16
 3c2:	e422                	sd	s0,8(sp)
 3c4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c6:	02b57463          	bgeu	a0,a1,3ee <memmove+0x2e>
    while(n-- > 0)
 3ca:	00c05f63          	blez	a2,3e8 <memmove+0x28>
 3ce:	1602                	slli	a2,a2,0x20
 3d0:	9201                	srli	a2,a2,0x20
 3d2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d6:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d8:	0585                	addi	a1,a1,1
 3da:	0705                	addi	a4,a4,1
 3dc:	fff5c683          	lbu	a3,-1(a1)
 3e0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3e4:	fef71ae3          	bne	a4,a5,3d8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e8:	6422                	ld	s0,8(sp)
 3ea:	0141                	addi	sp,sp,16
 3ec:	8082                	ret
    dst += n;
 3ee:	00c50733          	add	a4,a0,a2
    src += n;
 3f2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3f4:	fec05ae3          	blez	a2,3e8 <memmove+0x28>
 3f8:	fff6079b          	addiw	a5,a2,-1
 3fc:	1782                	slli	a5,a5,0x20
 3fe:	9381                	srli	a5,a5,0x20
 400:	fff7c793          	not	a5,a5
 404:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 406:	15fd                	addi	a1,a1,-1
 408:	177d                	addi	a4,a4,-1
 40a:	0005c683          	lbu	a3,0(a1)
 40e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 412:	fee79ae3          	bne	a5,a4,406 <memmove+0x46>
 416:	bfc9                	j	3e8 <memmove+0x28>

0000000000000418 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 418:	1141                	addi	sp,sp,-16
 41a:	e422                	sd	s0,8(sp)
 41c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 41e:	ca05                	beqz	a2,44e <memcmp+0x36>
 420:	fff6069b          	addiw	a3,a2,-1
 424:	1682                	slli	a3,a3,0x20
 426:	9281                	srli	a3,a3,0x20
 428:	0685                	addi	a3,a3,1
 42a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 42c:	00054783          	lbu	a5,0(a0)
 430:	0005c703          	lbu	a4,0(a1)
 434:	00e79863          	bne	a5,a4,444 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 438:	0505                	addi	a0,a0,1
    p2++;
 43a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 43c:	fed518e3          	bne	a0,a3,42c <memcmp+0x14>
  }
  return 0;
 440:	4501                	li	a0,0
 442:	a019                	j	448 <memcmp+0x30>
      return *p1 - *p2;
 444:	40e7853b          	subw	a0,a5,a4
}
 448:	6422                	ld	s0,8(sp)
 44a:	0141                	addi	sp,sp,16
 44c:	8082                	ret
  return 0;
 44e:	4501                	li	a0,0
 450:	bfe5                	j	448 <memcmp+0x30>

0000000000000452 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 452:	1141                	addi	sp,sp,-16
 454:	e406                	sd	ra,8(sp)
 456:	e022                	sd	s0,0(sp)
 458:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 45a:	f67ff0ef          	jal	3c0 <memmove>
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret

0000000000000466 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 466:	4885                	li	a7,1
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <exit>:
.global exit
exit:
 li a7, SYS_exit
 46e:	4889                	li	a7,2
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <wait>:
.global wait
wait:
 li a7, SYS_wait
 476:	488d                	li	a7,3
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 47e:	4891                	li	a7,4
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <read>:
.global read
read:
 li a7, SYS_read
 486:	4895                	li	a7,5
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <write>:
.global write
write:
 li a7, SYS_write
 48e:	48c1                	li	a7,16
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <close>:
.global close
close:
 li a7, SYS_close
 496:	48d5                	li	a7,21
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <kill>:
.global kill
kill:
 li a7, SYS_kill
 49e:	4899                	li	a7,6
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a6:	489d                	li	a7,7
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <open>:
.global open
open:
 li a7, SYS_open
 4ae:	48bd                	li	a7,15
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b6:	48c5                	li	a7,17
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4be:	48c9                	li	a7,18
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c6:	48a1                	li	a7,8
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <link>:
.global link
link:
 li a7, SYS_link
 4ce:	48cd                	li	a7,19
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d6:	48d1                	li	a7,20
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4de:	48a5                	li	a7,9
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e6:	48a9                	li	a7,10
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ee:	48ad                	li	a7,11
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f6:	48b1                	li	a7,12
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4fe:	48b5                	li	a7,13
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 506:	48b9                	li	a7,14
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <yield>:
.global yield
yield:
 li a7, SYS_yield
 50e:	48d9                	li	a7,22
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <getlev>:
.global getlev
getlev:
 li a7, SYS_getlev
 516:	48dd                	li	a7,23
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 51e:	48e1                	li	a7,24
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <mlfqmode>:
.global mlfqmode
mlfqmode:
 li a7, SYS_mlfqmode
 526:	48e5                	li	a7,25
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <fcfsmode>:
.global fcfsmode
fcfsmode:
 li a7, SYS_fcfsmode
 52e:	48e9                	li	a7,26
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <showfcfs>:
.global showfcfs
showfcfs:
 li a7, SYS_showfcfs
 536:	48ed                	li	a7,27
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <showmlfq>:
.global showmlfq
showmlfq:
 li a7, SYS_showmlfq
 53e:	48f1                	li	a7,28
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 546:	1101                	addi	sp,sp,-32
 548:	ec06                	sd	ra,24(sp)
 54a:	e822                	sd	s0,16(sp)
 54c:	1000                	addi	s0,sp,32
 54e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 552:	4605                	li	a2,1
 554:	fef40593          	addi	a1,s0,-17
 558:	f37ff0ef          	jal	48e <write>
}
 55c:	60e2                	ld	ra,24(sp)
 55e:	6442                	ld	s0,16(sp)
 560:	6105                	addi	sp,sp,32
 562:	8082                	ret

0000000000000564 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 564:	7139                	addi	sp,sp,-64
 566:	fc06                	sd	ra,56(sp)
 568:	f822                	sd	s0,48(sp)
 56a:	f426                	sd	s1,40(sp)
 56c:	0080                	addi	s0,sp,64
 56e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 570:	c299                	beqz	a3,576 <printint+0x12>
 572:	0805c963          	bltz	a1,604 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 576:	2581                	sext.w	a1,a1
  neg = 0;
 578:	4881                	li	a7,0
 57a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 57e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 580:	2601                	sext.w	a2,a2
 582:	00000517          	auipc	a0,0x0
 586:	6be50513          	addi	a0,a0,1726 # c40 <digits>
 58a:	883a                	mv	a6,a4
 58c:	2705                	addiw	a4,a4,1
 58e:	02c5f7bb          	remuw	a5,a1,a2
 592:	1782                	slli	a5,a5,0x20
 594:	9381                	srli	a5,a5,0x20
 596:	97aa                	add	a5,a5,a0
 598:	0007c783          	lbu	a5,0(a5)
 59c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5a0:	0005879b          	sext.w	a5,a1
 5a4:	02c5d5bb          	divuw	a1,a1,a2
 5a8:	0685                	addi	a3,a3,1
 5aa:	fec7f0e3          	bgeu	a5,a2,58a <printint+0x26>
  if(neg)
 5ae:	00088c63          	beqz	a7,5c6 <printint+0x62>
    buf[i++] = '-';
 5b2:	fd070793          	addi	a5,a4,-48
 5b6:	00878733          	add	a4,a5,s0
 5ba:	02d00793          	li	a5,45
 5be:	fef70823          	sb	a5,-16(a4)
 5c2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 5c6:	02e05a63          	blez	a4,5fa <printint+0x96>
 5ca:	f04a                	sd	s2,32(sp)
 5cc:	ec4e                	sd	s3,24(sp)
 5ce:	fc040793          	addi	a5,s0,-64
 5d2:	00e78933          	add	s2,a5,a4
 5d6:	fff78993          	addi	s3,a5,-1
 5da:	99ba                	add	s3,s3,a4
 5dc:	377d                	addiw	a4,a4,-1
 5de:	1702                	slli	a4,a4,0x20
 5e0:	9301                	srli	a4,a4,0x20
 5e2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5e6:	fff94583          	lbu	a1,-1(s2)
 5ea:	8526                	mv	a0,s1
 5ec:	f5bff0ef          	jal	546 <putc>
  while(--i >= 0)
 5f0:	197d                	addi	s2,s2,-1
 5f2:	ff391ae3          	bne	s2,s3,5e6 <printint+0x82>
 5f6:	7902                	ld	s2,32(sp)
 5f8:	69e2                	ld	s3,24(sp)
}
 5fa:	70e2                	ld	ra,56(sp)
 5fc:	7442                	ld	s0,48(sp)
 5fe:	74a2                	ld	s1,40(sp)
 600:	6121                	addi	sp,sp,64
 602:	8082                	ret
    x = -xx;
 604:	40b005bb          	negw	a1,a1
    neg = 1;
 608:	4885                	li	a7,1
    x = -xx;
 60a:	bf85                	j	57a <printint+0x16>

000000000000060c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 60c:	711d                	addi	sp,sp,-96
 60e:	ec86                	sd	ra,88(sp)
 610:	e8a2                	sd	s0,80(sp)
 612:	e0ca                	sd	s2,64(sp)
 614:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 616:	0005c903          	lbu	s2,0(a1)
 61a:	26090863          	beqz	s2,88a <vprintf+0x27e>
 61e:	e4a6                	sd	s1,72(sp)
 620:	fc4e                	sd	s3,56(sp)
 622:	f852                	sd	s4,48(sp)
 624:	f456                	sd	s5,40(sp)
 626:	f05a                	sd	s6,32(sp)
 628:	ec5e                	sd	s7,24(sp)
 62a:	e862                	sd	s8,16(sp)
 62c:	e466                	sd	s9,8(sp)
 62e:	8b2a                	mv	s6,a0
 630:	8a2e                	mv	s4,a1
 632:	8bb2                	mv	s7,a2
  state = 0;
 634:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 636:	4481                	li	s1,0
 638:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 63a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 63e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 642:	06c00c93          	li	s9,108
 646:	a005                	j	666 <vprintf+0x5a>
        putc(fd, c0);
 648:	85ca                	mv	a1,s2
 64a:	855a                	mv	a0,s6
 64c:	efbff0ef          	jal	546 <putc>
 650:	a019                	j	656 <vprintf+0x4a>
    } else if(state == '%'){
 652:	03598263          	beq	s3,s5,676 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 656:	2485                	addiw	s1,s1,1
 658:	8726                	mv	a4,s1
 65a:	009a07b3          	add	a5,s4,s1
 65e:	0007c903          	lbu	s2,0(a5)
 662:	20090c63          	beqz	s2,87a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 666:	0009079b          	sext.w	a5,s2
    if(state == 0){
 66a:	fe0994e3          	bnez	s3,652 <vprintf+0x46>
      if(c0 == '%'){
 66e:	fd579de3          	bne	a5,s5,648 <vprintf+0x3c>
        state = '%';
 672:	89be                	mv	s3,a5
 674:	b7cd                	j	656 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 676:	00ea06b3          	add	a3,s4,a4
 67a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 67e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 680:	c681                	beqz	a3,688 <vprintf+0x7c>
 682:	9752                	add	a4,a4,s4
 684:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 688:	03878f63          	beq	a5,s8,6c6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 68c:	05978963          	beq	a5,s9,6de <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 690:	07500713          	li	a4,117
 694:	0ee78363          	beq	a5,a4,77a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 698:	07800713          	li	a4,120
 69c:	12e78563          	beq	a5,a4,7c6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6a0:	07000713          	li	a4,112
 6a4:	14e78a63          	beq	a5,a4,7f8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6a8:	07300713          	li	a4,115
 6ac:	18e78a63          	beq	a5,a4,840 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6b0:	02500713          	li	a4,37
 6b4:	04e79563          	bne	a5,a4,6fe <vprintf+0xf2>
        putc(fd, '%');
 6b8:	02500593          	li	a1,37
 6bc:	855a                	mv	a0,s6
 6be:	e89ff0ef          	jal	546 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6c2:	4981                	li	s3,0
 6c4:	bf49                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 6c6:	008b8913          	addi	s2,s7,8
 6ca:	4685                	li	a3,1
 6cc:	4629                	li	a2,10
 6ce:	000ba583          	lw	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	e91ff0ef          	jal	564 <printint>
 6d8:	8bca                	mv	s7,s2
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bfad                	j	656 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 6de:	06400793          	li	a5,100
 6e2:	02f68963          	beq	a3,a5,714 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e6:	06c00793          	li	a5,108
 6ea:	04f68263          	beq	a3,a5,72e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6ee:	07500793          	li	a5,117
 6f2:	0af68063          	beq	a3,a5,792 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6f6:	07800793          	li	a5,120
 6fa:	0ef68263          	beq	a3,a5,7de <vprintf+0x1d2>
        putc(fd, '%');
 6fe:	02500593          	li	a1,37
 702:	855a                	mv	a0,s6
 704:	e43ff0ef          	jal	546 <putc>
        putc(fd, c0);
 708:	85ca                	mv	a1,s2
 70a:	855a                	mv	a0,s6
 70c:	e3bff0ef          	jal	546 <putc>
      state = 0;
 710:	4981                	li	s3,0
 712:	b791                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 714:	008b8913          	addi	s2,s7,8
 718:	4685                	li	a3,1
 71a:	4629                	li	a2,10
 71c:	000ba583          	lw	a1,0(s7)
 720:	855a                	mv	a0,s6
 722:	e43ff0ef          	jal	564 <printint>
        i += 1;
 726:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 728:	8bca                	mv	s7,s2
      state = 0;
 72a:	4981                	li	s3,0
        i += 1;
 72c:	b72d                	j	656 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 72e:	06400793          	li	a5,100
 732:	02f60763          	beq	a2,a5,760 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 736:	07500793          	li	a5,117
 73a:	06f60963          	beq	a2,a5,7ac <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 73e:	07800793          	li	a5,120
 742:	faf61ee3          	bne	a2,a5,6fe <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 746:	008b8913          	addi	s2,s7,8
 74a:	4681                	li	a3,0
 74c:	4641                	li	a2,16
 74e:	000ba583          	lw	a1,0(s7)
 752:	855a                	mv	a0,s6
 754:	e11ff0ef          	jal	564 <printint>
        i += 2;
 758:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 75a:	8bca                	mv	s7,s2
      state = 0;
 75c:	4981                	li	s3,0
        i += 2;
 75e:	bde5                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 760:	008b8913          	addi	s2,s7,8
 764:	4685                	li	a3,1
 766:	4629                	li	a2,10
 768:	000ba583          	lw	a1,0(s7)
 76c:	855a                	mv	a0,s6
 76e:	df7ff0ef          	jal	564 <printint>
        i += 2;
 772:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 774:	8bca                	mv	s7,s2
      state = 0;
 776:	4981                	li	s3,0
        i += 2;
 778:	bdf9                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 77a:	008b8913          	addi	s2,s7,8
 77e:	4681                	li	a3,0
 780:	4629                	li	a2,10
 782:	000ba583          	lw	a1,0(s7)
 786:	855a                	mv	a0,s6
 788:	dddff0ef          	jal	564 <printint>
 78c:	8bca                	mv	s7,s2
      state = 0;
 78e:	4981                	li	s3,0
 790:	b5d9                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 792:	008b8913          	addi	s2,s7,8
 796:	4681                	li	a3,0
 798:	4629                	li	a2,10
 79a:	000ba583          	lw	a1,0(s7)
 79e:	855a                	mv	a0,s6
 7a0:	dc5ff0ef          	jal	564 <printint>
        i += 1;
 7a4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7a6:	8bca                	mv	s7,s2
      state = 0;
 7a8:	4981                	li	s3,0
        i += 1;
 7aa:	b575                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ac:	008b8913          	addi	s2,s7,8
 7b0:	4681                	li	a3,0
 7b2:	4629                	li	a2,10
 7b4:	000ba583          	lw	a1,0(s7)
 7b8:	855a                	mv	a0,s6
 7ba:	dabff0ef          	jal	564 <printint>
        i += 2;
 7be:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c0:	8bca                	mv	s7,s2
      state = 0;
 7c2:	4981                	li	s3,0
        i += 2;
 7c4:	bd49                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 7c6:	008b8913          	addi	s2,s7,8
 7ca:	4681                	li	a3,0
 7cc:	4641                	li	a2,16
 7ce:	000ba583          	lw	a1,0(s7)
 7d2:	855a                	mv	a0,s6
 7d4:	d91ff0ef          	jal	564 <printint>
 7d8:	8bca                	mv	s7,s2
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	bdad                	j	656 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7de:	008b8913          	addi	s2,s7,8
 7e2:	4681                	li	a3,0
 7e4:	4641                	li	a2,16
 7e6:	000ba583          	lw	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	d79ff0ef          	jal	564 <printint>
        i += 1;
 7f0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7f2:	8bca                	mv	s7,s2
      state = 0;
 7f4:	4981                	li	s3,0
        i += 1;
 7f6:	b585                	j	656 <vprintf+0x4a>
 7f8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7fa:	008b8d13          	addi	s10,s7,8
 7fe:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 802:	03000593          	li	a1,48
 806:	855a                	mv	a0,s6
 808:	d3fff0ef          	jal	546 <putc>
  putc(fd, 'x');
 80c:	07800593          	li	a1,120
 810:	855a                	mv	a0,s6
 812:	d35ff0ef          	jal	546 <putc>
 816:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 818:	00000b97          	auipc	s7,0x0
 81c:	428b8b93          	addi	s7,s7,1064 # c40 <digits>
 820:	03c9d793          	srli	a5,s3,0x3c
 824:	97de                	add	a5,a5,s7
 826:	0007c583          	lbu	a1,0(a5)
 82a:	855a                	mv	a0,s6
 82c:	d1bff0ef          	jal	546 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 830:	0992                	slli	s3,s3,0x4
 832:	397d                	addiw	s2,s2,-1
 834:	fe0916e3          	bnez	s2,820 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 838:	8bea                	mv	s7,s10
      state = 0;
 83a:	4981                	li	s3,0
 83c:	6d02                	ld	s10,0(sp)
 83e:	bd21                	j	656 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 840:	008b8993          	addi	s3,s7,8
 844:	000bb903          	ld	s2,0(s7)
 848:	00090f63          	beqz	s2,866 <vprintf+0x25a>
        for(; *s; s++)
 84c:	00094583          	lbu	a1,0(s2)
 850:	c195                	beqz	a1,874 <vprintf+0x268>
          putc(fd, *s);
 852:	855a                	mv	a0,s6
 854:	cf3ff0ef          	jal	546 <putc>
        for(; *s; s++)
 858:	0905                	addi	s2,s2,1
 85a:	00094583          	lbu	a1,0(s2)
 85e:	f9f5                	bnez	a1,852 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 860:	8bce                	mv	s7,s3
      state = 0;
 862:	4981                	li	s3,0
 864:	bbcd                	j	656 <vprintf+0x4a>
          s = "(null)";
 866:	00000917          	auipc	s2,0x0
 86a:	3d290913          	addi	s2,s2,978 # c38 <malloc+0x2c6>
        for(; *s; s++)
 86e:	02800593          	li	a1,40
 872:	b7c5                	j	852 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 874:	8bce                	mv	s7,s3
      state = 0;
 876:	4981                	li	s3,0
 878:	bbf9                	j	656 <vprintf+0x4a>
 87a:	64a6                	ld	s1,72(sp)
 87c:	79e2                	ld	s3,56(sp)
 87e:	7a42                	ld	s4,48(sp)
 880:	7aa2                	ld	s5,40(sp)
 882:	7b02                	ld	s6,32(sp)
 884:	6be2                	ld	s7,24(sp)
 886:	6c42                	ld	s8,16(sp)
 888:	6ca2                	ld	s9,8(sp)
    }
  }
}
 88a:	60e6                	ld	ra,88(sp)
 88c:	6446                	ld	s0,80(sp)
 88e:	6906                	ld	s2,64(sp)
 890:	6125                	addi	sp,sp,96
 892:	8082                	ret

0000000000000894 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 894:	715d                	addi	sp,sp,-80
 896:	ec06                	sd	ra,24(sp)
 898:	e822                	sd	s0,16(sp)
 89a:	1000                	addi	s0,sp,32
 89c:	e010                	sd	a2,0(s0)
 89e:	e414                	sd	a3,8(s0)
 8a0:	e818                	sd	a4,16(s0)
 8a2:	ec1c                	sd	a5,24(s0)
 8a4:	03043023          	sd	a6,32(s0)
 8a8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ac:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b0:	8622                	mv	a2,s0
 8b2:	d5bff0ef          	jal	60c <vprintf>
}
 8b6:	60e2                	ld	ra,24(sp)
 8b8:	6442                	ld	s0,16(sp)
 8ba:	6161                	addi	sp,sp,80
 8bc:	8082                	ret

00000000000008be <printf>:

void
printf(const char *fmt, ...)
{
 8be:	711d                	addi	sp,sp,-96
 8c0:	ec06                	sd	ra,24(sp)
 8c2:	e822                	sd	s0,16(sp)
 8c4:	1000                	addi	s0,sp,32
 8c6:	e40c                	sd	a1,8(s0)
 8c8:	e810                	sd	a2,16(s0)
 8ca:	ec14                	sd	a3,24(s0)
 8cc:	f018                	sd	a4,32(s0)
 8ce:	f41c                	sd	a5,40(s0)
 8d0:	03043823          	sd	a6,48(s0)
 8d4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8d8:	00840613          	addi	a2,s0,8
 8dc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8e0:	85aa                	mv	a1,a0
 8e2:	4505                	li	a0,1
 8e4:	d29ff0ef          	jal	60c <vprintf>
}
 8e8:	60e2                	ld	ra,24(sp)
 8ea:	6442                	ld	s0,16(sp)
 8ec:	6125                	addi	sp,sp,96
 8ee:	8082                	ret

00000000000008f0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f0:	1141                	addi	sp,sp,-16
 8f2:	e422                	sd	s0,8(sp)
 8f4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8f6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8fa:	00001797          	auipc	a5,0x1
 8fe:	70e7b783          	ld	a5,1806(a5) # 2008 <freep>
 902:	a02d                	j	92c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 904:	4618                	lw	a4,8(a2)
 906:	9f2d                	addw	a4,a4,a1
 908:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 90c:	6398                	ld	a4,0(a5)
 90e:	6310                	ld	a2,0(a4)
 910:	a83d                	j	94e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 912:	ff852703          	lw	a4,-8(a0)
 916:	9f31                	addw	a4,a4,a2
 918:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 91a:	ff053683          	ld	a3,-16(a0)
 91e:	a091                	j	962 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 920:	6398                	ld	a4,0(a5)
 922:	00e7e463          	bltu	a5,a4,92a <free+0x3a>
 926:	00e6ea63          	bltu	a3,a4,93a <free+0x4a>
{
 92a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 92c:	fed7fae3          	bgeu	a5,a3,920 <free+0x30>
 930:	6398                	ld	a4,0(a5)
 932:	00e6e463          	bltu	a3,a4,93a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 936:	fee7eae3          	bltu	a5,a4,92a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 93a:	ff852583          	lw	a1,-8(a0)
 93e:	6390                	ld	a2,0(a5)
 940:	02059813          	slli	a6,a1,0x20
 944:	01c85713          	srli	a4,a6,0x1c
 948:	9736                	add	a4,a4,a3
 94a:	fae60de3          	beq	a2,a4,904 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 94e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 952:	4790                	lw	a2,8(a5)
 954:	02061593          	slli	a1,a2,0x20
 958:	01c5d713          	srli	a4,a1,0x1c
 95c:	973e                	add	a4,a4,a5
 95e:	fae68ae3          	beq	a3,a4,912 <free+0x22>
    p->s.ptr = bp->s.ptr;
 962:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 964:	00001717          	auipc	a4,0x1
 968:	6af73223          	sd	a5,1700(a4) # 2008 <freep>
}
 96c:	6422                	ld	s0,8(sp)
 96e:	0141                	addi	sp,sp,16
 970:	8082                	ret

0000000000000972 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 972:	7139                	addi	sp,sp,-64
 974:	fc06                	sd	ra,56(sp)
 976:	f822                	sd	s0,48(sp)
 978:	f426                	sd	s1,40(sp)
 97a:	ec4e                	sd	s3,24(sp)
 97c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 97e:	02051493          	slli	s1,a0,0x20
 982:	9081                	srli	s1,s1,0x20
 984:	04bd                	addi	s1,s1,15
 986:	8091                	srli	s1,s1,0x4
 988:	0014899b          	addiw	s3,s1,1
 98c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 98e:	00001517          	auipc	a0,0x1
 992:	67a53503          	ld	a0,1658(a0) # 2008 <freep>
 996:	c915                	beqz	a0,9ca <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 998:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 99a:	4798                	lw	a4,8(a5)
 99c:	08977a63          	bgeu	a4,s1,a30 <malloc+0xbe>
 9a0:	f04a                	sd	s2,32(sp)
 9a2:	e852                	sd	s4,16(sp)
 9a4:	e456                	sd	s5,8(sp)
 9a6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9a8:	8a4e                	mv	s4,s3
 9aa:	0009871b          	sext.w	a4,s3
 9ae:	6685                	lui	a3,0x1
 9b0:	00d77363          	bgeu	a4,a3,9b6 <malloc+0x44>
 9b4:	6a05                	lui	s4,0x1
 9b6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ba:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9be:	00001917          	auipc	s2,0x1
 9c2:	64a90913          	addi	s2,s2,1610 # 2008 <freep>
  if(p == (char*)-1)
 9c6:	5afd                	li	s5,-1
 9c8:	a081                	j	a08 <malloc+0x96>
 9ca:	f04a                	sd	s2,32(sp)
 9cc:	e852                	sd	s4,16(sp)
 9ce:	e456                	sd	s5,8(sp)
 9d0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9d2:	00001797          	auipc	a5,0x1
 9d6:	7de78793          	addi	a5,a5,2014 # 21b0 <base>
 9da:	00001717          	auipc	a4,0x1
 9de:	62f73723          	sd	a5,1582(a4) # 2008 <freep>
 9e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9e8:	b7c1                	j	9a8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 9ea:	6398                	ld	a4,0(a5)
 9ec:	e118                	sd	a4,0(a0)
 9ee:	a8a9                	j	a48 <malloc+0xd6>
  hp->s.size = nu;
 9f0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9f4:	0541                	addi	a0,a0,16
 9f6:	efbff0ef          	jal	8f0 <free>
  return freep;
 9fa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 9fe:	c12d                	beqz	a0,a60 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a00:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a02:	4798                	lw	a4,8(a5)
 a04:	02977263          	bgeu	a4,s1,a28 <malloc+0xb6>
    if(p == freep)
 a08:	00093703          	ld	a4,0(s2)
 a0c:	853e                	mv	a0,a5
 a0e:	fef719e3          	bne	a4,a5,a00 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a12:	8552                	mv	a0,s4
 a14:	ae3ff0ef          	jal	4f6 <sbrk>
  if(p == (char*)-1)
 a18:	fd551ce3          	bne	a0,s5,9f0 <malloc+0x7e>
        return 0;
 a1c:	4501                	li	a0,0
 a1e:	7902                	ld	s2,32(sp)
 a20:	6a42                	ld	s4,16(sp)
 a22:	6aa2                	ld	s5,8(sp)
 a24:	6b02                	ld	s6,0(sp)
 a26:	a03d                	j	a54 <malloc+0xe2>
 a28:	7902                	ld	s2,32(sp)
 a2a:	6a42                	ld	s4,16(sp)
 a2c:	6aa2                	ld	s5,8(sp)
 a2e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a30:	fae48de3          	beq	s1,a4,9ea <malloc+0x78>
        p->s.size -= nunits;
 a34:	4137073b          	subw	a4,a4,s3
 a38:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a3a:	02071693          	slli	a3,a4,0x20
 a3e:	01c6d713          	srli	a4,a3,0x1c
 a42:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a44:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a48:	00001717          	auipc	a4,0x1
 a4c:	5ca73023          	sd	a0,1472(a4) # 2008 <freep>
      return (void*)(p + 1);
 a50:	01078513          	addi	a0,a5,16
  }
}
 a54:	70e2                	ld	ra,56(sp)
 a56:	7442                	ld	s0,48(sp)
 a58:	74a2                	ld	s1,40(sp)
 a5a:	69e2                	ld	s3,24(sp)
 a5c:	6121                	addi	sp,sp,64
 a5e:	8082                	ret
 a60:	7902                	ld	s2,32(sp)
 a62:	6a42                	ld	s4,16(sp)
 a64:	6aa2                	ld	s5,8(sp)
 a66:	6b02                	ld	s6,0(sp)
 a68:	b7f5                	j	a54 <malloc+0xe2>
