
user/_thread_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <thread_basic>:
int expected[NUM_THREAD]; // for test#2

// test#1
void
thread_basic(void *arg1, void *arg2)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
    uint64 num = (uint64)arg1;
    printf("Thread %lu start\n", num);
   c:	85aa                	mv	a1,a0
   e:	00001517          	auipc	a0,0x1
  12:	f9250513          	addi	a0,a0,-110 # fa0 <thread_join+0x3c>
  16:	553000ef          	jal	d68 <printf>
    if (num == 0) {
  1a:	c899                	beqz	s1,30 <thread_basic+0x30>
        sleep(20);
        status = 1;
    }
    printf("Thread %lu end\n", num);
  1c:	85a6                	mv	a1,s1
  1e:	00001517          	auipc	a0,0x1
  22:	f9a50513          	addi	a0,a0,-102 # fb8 <thread_join+0x54>
  26:	543000ef          	jal	d68 <printf>
    exit(0);
  2a:	4501                	li	a0,0
  2c:	115000ef          	jal	940 <exit>
        sleep(20);
  30:	4551                	li	a0,20
  32:	19f000ef          	jal	9d0 <sleep>
        status = 1;
  36:	4785                	li	a5,1
  38:	00002717          	auipc	a4,0x2
  3c:	fcf72823          	sw	a5,-48(a4) # 2008 <status>
  40:	bff1                	j	1c <thread_basic+0x1c>

0000000000000042 <thread_inc>:
}

// test#2
void
thread_inc(void *arg1, void *arg2)
{
  42:	1101                	addi	sp,sp,-32
  44:	ec06                	sd	ra,24(sp)
  46:	e822                	sd	s0,16(sp)
  48:	e426                	sd	s1,8(sp)
  4a:	e04a                	sd	s2,0(sp)
  4c:	1000                	addi	s0,sp,32
  4e:	892a                	mv	s2,a0
  50:	84ae                	mv	s1,a1
    int i;
    uint64 num = (uint64)arg1;
    uint64 iter = (uint64)arg2;
    printf("Thread %lu start, iter=%lu\n", num, iter);
  52:	862e                	mv	a2,a1
  54:	85aa                	mv	a1,a0
  56:	00001517          	auipc	a0,0x1
  5a:	f7250513          	addi	a0,a0,-142 # fc8 <thread_join+0x64>
  5e:	50b000ef          	jal	d68 <printf>
    for (i = 0; i < iter; i++) {
  62:	c89d                	beqz	s1,98 <thread_inc+0x56>
  64:	00291713          	slli	a4,s2,0x2
  68:	00002797          	auipc	a5,0x2
  6c:	fb878793          	addi	a5,a5,-72 # 2020 <expected>
  70:	97ba                	add	a5,a5,a4
  72:	4394                	lw	a3,0(a5)
  74:	0016879b          	addiw	a5,a3,1
  78:	0014871b          	addiw	a4,s1,1
  7c:	9f35                	addw	a4,a4,a3
  7e:	0007869b          	sext.w	a3,a5
  82:	2785                	addiw	a5,a5,1
  84:	fee79de3          	bne	a5,a4,7e <thread_inc+0x3c>
  88:	00291713          	slli	a4,s2,0x2
  8c:	00002797          	auipc	a5,0x2
  90:	f9478793          	addi	a5,a5,-108 # 2020 <expected>
  94:	97ba                	add	a5,a5,a4
  96:	c394                	sw	a3,0(a5)
        expected[num]++;
    }
    printf("Thread %lu end\n", num);
  98:	85ca                	mv	a1,s2
  9a:	00001517          	auipc	a0,0x1
  9e:	f1e50513          	addi	a0,a0,-226 # fb8 <thread_join+0x54>
  a2:	4c7000ef          	jal	d68 <printf>
    exit(0);
  a6:	4501                	li	a0,0
  a8:	099000ef          	jal	940 <exit>

00000000000000ac <thread_fork>:
}

// test#3
void
thread_fork(void *arg1, void *arg2)
{
  ac:	1101                	addi	sp,sp,-32
  ae:	ec06                	sd	ra,24(sp)
  b0:	e822                	sd	s0,16(sp)
  b2:	e426                	sd	s1,8(sp)
  b4:	1000                	addi	s0,sp,32
  b6:	84aa                	mv	s1,a0
    uint64 num = (uint64)arg1;
    int pid;

    printf("Thread %lu start\n", num);
  b8:	85aa                	mv	a1,a0
  ba:	00001517          	auipc	a0,0x1
  be:	ee650513          	addi	a0,a0,-282 # fa0 <thread_join+0x3c>
  c2:	4a7000ef          	jal	d68 <printf>
    pid = fork();
  c6:	073000ef          	jal	938 <fork>
    if (pid < 0) {
  ca:	02054c63          	bltz	a0,102 <thread_fork+0x56>
        printf("Fork error on thread %lu\n", num);
        exit(1);
    }

    if (pid == 0) {
  ce:	e521                	bnez	a0,116 <thread_fork+0x6a>
        printf("Child of thread %lu start\n", num);
  d0:	85a6                	mv	a1,s1
  d2:	00001517          	auipc	a0,0x1
  d6:	f3650513          	addi	a0,a0,-202 # 1008 <thread_join+0xa4>
  da:	48f000ef          	jal	d68 <printf>
        sleep(10);
  de:	4529                	li	a0,10
  e0:	0f1000ef          	jal	9d0 <sleep>
        status = 3;
  e4:	478d                	li	a5,3
  e6:	00002717          	auipc	a4,0x2
  ea:	f2f72123          	sw	a5,-222(a4) # 2008 <status>
        printf("Child of thread %lu end\n", num);
  ee:	85a6                	mv	a1,s1
  f0:	00001517          	auipc	a0,0x1
  f4:	f3850513          	addi	a0,a0,-200 # 1028 <thread_join+0xc4>
  f8:	471000ef          	jal	d68 <printf>
        exit(0);
  fc:	4501                	li	a0,0
  fe:	043000ef          	jal	940 <exit>
        printf("Fork error on thread %lu\n", num);
 102:	85a6                	mv	a1,s1
 104:	00001517          	auipc	a0,0x1
 108:	ee450513          	addi	a0,a0,-284 # fe8 <thread_join+0x84>
 10c:	45d000ef          	jal	d68 <printf>
        exit(1);
 110:	4505                	li	a0,1
 112:	02f000ef          	jal	940 <exit>
    }
    else {
        sleep(3);
 116:	450d                	li	a0,3
 118:	0b9000ef          	jal	9d0 <sleep>
        status = 2;
 11c:	4789                	li	a5,2
 11e:	00002717          	auipc	a4,0x2
 122:	eef72523          	sw	a5,-278(a4) # 2008 <status>
        if (wait(0) == -1) {
 126:	4501                	li	a0,0
 128:	021000ef          	jal	948 <wait>
 12c:	57fd                	li	a5,-1
 12e:	00f50c63          	beq	a0,a5,146 <thread_fork+0x9a>
            printf("Thread %lu lost their child\n", num);
            exit(1);
        }
    }
    printf("Thread %lu end\n", num);
 132:	85a6                	mv	a1,s1
 134:	00001517          	auipc	a0,0x1
 138:	e8450513          	addi	a0,a0,-380 # fb8 <thread_join+0x54>
 13c:	42d000ef          	jal	d68 <printf>
    exit(0);
 140:	4501                	li	a0,0
 142:	7fe000ef          	jal	940 <exit>
            printf("Thread %lu lost their child\n", num);
 146:	85a6                	mv	a1,s1
 148:	00001517          	auipc	a0,0x1
 14c:	f0050513          	addi	a0,a0,-256 # 1048 <thread_join+0xe4>
 150:	419000ef          	jal	d68 <printf>
            exit(1);
 154:	4505                	li	a0,1
 156:	7ea000ef          	jal	940 <exit>

000000000000015a <thread_sbrk>:
// test#4
int *ptr;

void
thread_sbrk(void *arg1, void *arg2)
{
 15a:	1101                	addi	sp,sp,-32
 15c:	ec06                	sd	ra,24(sp)
 15e:	e822                	sd	s0,16(sp)
 160:	e426                	sd	s1,8(sp)
 162:	e04a                	sd	s2,0(sp)
 164:	1000                	addi	s0,sp,32
 166:	84aa                	mv	s1,a0
    uint64 num = (uint64)arg1;
    char *old_break = sbrk(0);
 168:	4501                	li	a0,0
 16a:	05f000ef          	jal	9c8 <sbrk>

    // Global memory allocation
    if (num == 0) {
 16e:	c8dd                	beqz	s1,224 <thread_sbrk+0xca>
        printf("Thread %lu sbrk: free memory\n", num);
        free(ptr);
        ptr = 0;
    }
    else {
        while (ptr == 0) {
 170:	00002797          	auipc	a5,0x2
 174:	e907b783          	ld	a5,-368(a5) # 2000 <ptr>
 178:	00002917          	auipc	s2,0x2
 17c:	e8890913          	addi	s2,s2,-376 # 2000 <ptr>
 180:	e799                	bnez	a5,18e <thread_sbrk+0x34>
            sleep(1);
 182:	4505                	li	a0,1
 184:	04d000ef          	jal	9d0 <sleep>
        while (ptr == 0) {
 188:	00093783          	ld	a5,0(s2)
 18c:	dbfd                	beqz	a5,182 <thread_sbrk+0x28>
        }
        printf("Thread %lu size = %p\n", num, sbrk(0));
 18e:	4501                	li	a0,0
 190:	039000ef          	jal	9c8 <sbrk>
 194:	862a                	mv	a2,a0
 196:	85a6                	mv	a1,s1
 198:	00001517          	auipc	a0,0x1
 19c:	f5050513          	addi	a0,a0,-176 # 10e8 <thread_join+0x184>
 1a0:	3c9000ef          	jal	d68 <printf>
        for (int i = 0; i < 4096; i++) {
 1a4:	00e49793          	slli	a5,s1,0xe
 1a8:	6691                	lui	a3,0x4
 1aa:	96be                	add	a3,a3,a5
            ptr[num*4096 + i] = num;
 1ac:	00002617          	auipc	a2,0x2
 1b0:	e5460613          	addi	a2,a2,-428 # 2000 <ptr>
 1b4:	6218                	ld	a4,0(a2)
 1b6:	973e                	add	a4,a4,a5
 1b8:	c304                	sw	s1,0(a4)
        for (int i = 0; i < 4096; i++) {
 1ba:	0791                	addi	a5,a5,4
 1bc:	fed79ce3          	bne	a5,a3,1b4 <thread_sbrk+0x5a>
        }
    }

    while (ptr != 0) {
 1c0:	00002797          	auipc	a5,0x2
 1c4:	e407b783          	ld	a5,-448(a5) # 2000 <ptr>
 1c8:	00002917          	auipc	s2,0x2
 1cc:	e3890913          	addi	s2,s2,-456 # 2000 <ptr>
 1d0:	c799                	beqz	a5,1de <thread_sbrk+0x84>
        sleep(1);
 1d2:	4505                	li	a0,1
 1d4:	7fc000ef          	jal	9d0 <sleep>
    while (ptr != 0) {
 1d8:	00093783          	ld	a5,0(s2)
 1dc:	fbfd                	bnez	a5,1d2 <thread_sbrk+0x78>
{
 1de:	3e800913          	li	s2,1000
    }

    // Local memory allocation
    for (int i = 0; i < 1000; i++) {
        int *p = (int *)malloc(4096);
 1e2:	6505                	lui	a0,0x1
 1e4:	439000ef          	jal	e1c <malloc>
        if (p == 0) {
 1e8:	cd49                	beqz	a0,282 <thread_sbrk+0x128>
 1ea:	86aa                	mv	a3,a0
 1ec:	6705                	lui	a4,0x1
 1ee:	972a                	add	a4,a4,a0
 1f0:	87aa                	mv	a5,a0
            printf("Thread %lu malloc failed\n", num);
            exit(1);
        }
        for (int j = 0; j < 4096 / sizeof(int); j++) {
            p[j] = num;
 1f2:	c384                	sw	s1,0(a5)
        for (int j = 0; j < 4096 / sizeof(int); j++) {
 1f4:	0791                	addi	a5,a5,4
 1f6:	fee79ee3          	bne	a5,a4,1f2 <thread_sbrk+0x98>
        }
        for (int j = 0; j < 4096 / sizeof(int); j++) {
            if (p[j] != num) {
 1fa:	4290                	lw	a2,0(a3)
 1fc:	08961d63          	bne	a2,s1,296 <thread_sbrk+0x13c>
        for (int j = 0; j < 4096 / sizeof(int); j++) {
 200:	0691                	addi	a3,a3,4 # 4004 <base+0x1fb4>
 202:	fee69ce3          	bne	a3,a4,1fa <thread_sbrk+0xa0>
                printf("Thread %lu found %d\n", num, p[j]);
                exit(1);
            }
        }
        free(p);
 206:	395000ef          	jal	d9a <free>
    for (int i = 0; i < 1000; i++) {
 20a:	397d                	addiw	s2,s2,-1
 20c:	fc091be3          	bnez	s2,1e2 <thread_sbrk+0x88>
    }
    printf("Thread %lu end\n", num);
 210:	85a6                	mv	a1,s1
 212:	00001517          	auipc	a0,0x1
 216:	da650513          	addi	a0,a0,-602 # fb8 <thread_join+0x54>
 21a:	34f000ef          	jal	d68 <printf>
    exit(0);
 21e:	4501                	li	a0,0
 220:	720000ef          	jal	940 <exit>
        printf("Thread %lu sbrk: old break = %p\n", num, old_break);
 224:	862a                	mv	a2,a0
 226:	4581                	li	a1,0
 228:	00001517          	auipc	a0,0x1
 22c:	e4050513          	addi	a0,a0,-448 # 1068 <thread_join+0x104>
 230:	339000ef          	jal	d68 <printf>
        ptr = (int *)malloc(4096 * 4 * NUM_THREAD);
 234:	6551                	lui	a0,0x14
 236:	3e7000ef          	jal	e1c <malloc>
 23a:	00002917          	auipc	s2,0x2
 23e:	dc690913          	addi	s2,s2,-570 # 2000 <ptr>
 242:	00a93023          	sd	a0,0(s2)
        printf("Thread %lu sbrk: increased break by %x\nnew break = %p\n", num, 4096 * 4 * NUM_THREAD, sbrk(0));
 246:	4501                	li	a0,0
 248:	780000ef          	jal	9c8 <sbrk>
 24c:	86aa                	mv	a3,a0
 24e:	6651                	lui	a2,0x14
 250:	4581                	li	a1,0
 252:	00001517          	auipc	a0,0x1
 256:	e3e50513          	addi	a0,a0,-450 # 1090 <thread_join+0x12c>
 25a:	30f000ef          	jal	d68 <printf>
        sleep(50);
 25e:	03200513          	li	a0,50
 262:	76e000ef          	jal	9d0 <sleep>
        printf("Thread %lu sbrk: free memory\n", num);
 266:	4581                	li	a1,0
 268:	00001517          	auipc	a0,0x1
 26c:	e6050513          	addi	a0,a0,-416 # 10c8 <thread_join+0x164>
 270:	2f9000ef          	jal	d68 <printf>
        free(ptr);
 274:	00093503          	ld	a0,0(s2)
 278:	323000ef          	jal	d9a <free>
        ptr = 0;
 27c:	00093023          	sd	zero,0(s2)
    while (ptr != 0) {
 280:	bfb9                	j	1de <thread_sbrk+0x84>
            printf("Thread %lu malloc failed\n", num);
 282:	85a6                	mv	a1,s1
 284:	00001517          	auipc	a0,0x1
 288:	e7c50513          	addi	a0,a0,-388 # 1100 <thread_join+0x19c>
 28c:	2dd000ef          	jal	d68 <printf>
            exit(1);
 290:	4505                	li	a0,1
 292:	6ae000ef          	jal	940 <exit>
                printf("Thread %lu found %d\n", num, p[j]);
 296:	85a6                	mv	a1,s1
 298:	00001517          	auipc	a0,0x1
 29c:	e8850513          	addi	a0,a0,-376 # 1120 <thread_join+0x1bc>
 2a0:	2c9000ef          	jal	d68 <printf>
                exit(1);
 2a4:	4505                	li	a0,1
 2a6:	69a000ef          	jal	940 <exit>

00000000000002aa <thread_kill>:
}

// test#5
void
thread_kill(void *arg1, void *arg2)
{
 2aa:	1101                	addi	sp,sp,-32
 2ac:	ec06                	sd	ra,24(sp)
 2ae:	e822                	sd	s0,16(sp)
 2b0:	e426                	sd	s1,8(sp)
 2b2:	e04a                	sd	s2,0(sp)
 2b4:	1000                	addi	s0,sp,32
 2b6:	84aa                	mv	s1,a0
 2b8:	892e                	mv	s2,a1
    uint64 num = (uint64)arg1;
    uint64 pid = (uint64)arg2;
    printf("Thread %lu start, pid %lu\n", num, pid);
 2ba:	862e                	mv	a2,a1
 2bc:	85aa                	mv	a1,a0
 2be:	00001517          	auipc	a0,0x1
 2c2:	e7a50513          	addi	a0,a0,-390 # 1138 <thread_join+0x1d4>
 2c6:	2a3000ef          	jal	d68 <printf>
    if (num == 0) {
 2ca:	c091                	beqz	s1,2ce <thread_kill+0x24>
        sleep(1);
        kill(pid);
    }
    else {
        while(1);
 2cc:	a001                	j	2cc <thread_kill+0x22>
        sleep(1);
 2ce:	4505                	li	a0,1
 2d0:	700000ef          	jal	9d0 <sleep>
        kill(pid);
 2d4:	0009051b          	sext.w	a0,s2
 2d8:	698000ef          	jal	970 <kill>
    }
    printf("Thread %lu end\n", num);
 2dc:	4581                	li	a1,0
 2de:	00001517          	auipc	a0,0x1
 2e2:	cda50513          	addi	a0,a0,-806 # fb8 <thread_join+0x54>
 2e6:	283000ef          	jal	d68 <printf>
    exit(0);
 2ea:	4501                	li	a0,0
 2ec:	654000ef          	jal	940 <exit>

00000000000002f0 <thread_exec>:
}

// test#6
void
thread_exec(void *arg1, void *arg2)
{
 2f0:	7139                	addi	sp,sp,-64
 2f2:	fc06                	sd	ra,56(sp)
 2f4:	f822                	sd	s0,48(sp)
 2f6:	f426                	sd	s1,40(sp)
 2f8:	f04a                	sd	s2,32(sp)
 2fa:	0080                	addi	s0,sp,64
 2fc:	84aa                	mv	s1,a0
    uint64 num = (uint64)arg1;
    printf("Thread %lu start\n", num);
 2fe:	85aa                	mv	a1,a0
 300:	00001517          	auipc	a0,0x1
 304:	ca050513          	addi	a0,a0,-864 # fa0 <thread_join+0x3c>
 308:	261000ef          	jal	d68 <printf>
    if (num == 0) {
 30c:	cc91                	beqz	s1,328 <thread_exec+0x38>
        char *args[3] = {pname, "0", 0};
        printf("Executing...\n");
        exec(pname, args);
    }
    else {
        sleep(20);
 30e:	4551                	li	a0,20
 310:	6c0000ef          	jal	9d0 <sleep>
    }
    printf("Thread %lu end\n", num);
 314:	85a6                	mv	a1,s1
 316:	00001517          	auipc	a0,0x1
 31a:	ca250513          	addi	a0,a0,-862 # fb8 <thread_join+0x54>
 31e:	24b000ef          	jal	d68 <printf>
    exit(0);
 322:	4501                	li	a0,0
 324:	61c000ef          	jal	940 <exit>
        sleep(1);
 328:	4505                	li	a0,1
 32a:	6a6000ef          	jal	9d0 <sleep>
        char *args[3] = {pname, "0", 0};
 32e:	00001917          	auipc	s2,0x1
 332:	e2a90913          	addi	s2,s2,-470 # 1158 <thread_join+0x1f4>
 336:	fd243423          	sd	s2,-56(s0)
 33a:	00001797          	auipc	a5,0x1
 33e:	e2e78793          	addi	a5,a5,-466 # 1168 <thread_join+0x204>
 342:	fcf43823          	sd	a5,-48(s0)
 346:	fc043c23          	sd	zero,-40(s0)
        printf("Executing...\n");
 34a:	00001517          	auipc	a0,0x1
 34e:	e2650513          	addi	a0,a0,-474 # 1170 <thread_join+0x20c>
 352:	217000ef          	jal	d68 <printf>
        exec(pname, args);
 356:	fc840593          	addi	a1,s0,-56
 35a:	854a                	mv	a0,s2
 35c:	61c000ef          	jal	978 <exec>
 360:	bf55                	j	314 <thread_exec+0x24>

0000000000000362 <main>:
}

int
main(int argc, char *argv[])
{
 362:	7139                	addi	sp,sp,-64
 364:	fc06                	sd	ra,56(sp)
 366:	f822                	sd	s0,48(sp)
 368:	f426                	sd	s1,40(sp)
 36a:	f04a                	sd	s2,32(sp)
 36c:	ec4e                	sd	s3,24(sp)
 36e:	e852                	sd	s4,16(sp)
 370:	e456                	sd	s5,8(sp)
 372:	e05a                	sd	s6,0(sp)
 374:	0080                	addi	s0,sp,64
    int i;
    int pid;
    
    printf("\n[TEST#1]\n");
 376:	00001517          	auipc	a0,0x1
 37a:	e0a50513          	addi	a0,a0,-502 # 1180 <thread_join+0x21c>
 37e:	1eb000ef          	jal	d68 <printf>
    for (i = 0; i < NUM_THREAD; i++) {
 382:	00002a17          	auipc	s4,0x2
 386:	cb6a0a13          	addi	s4,s4,-842 # 2038 <threads>
    printf("\n[TEST#1]\n");
 38a:	8952                	mv	s2,s4
 38c:	4481                	li	s1,0
        threads[i] = thread_create(thread_basic, (void *)(uint64)i, 0);
 38e:	00000a97          	auipc	s5,0x0
 392:	c72a8a93          	addi	s5,s5,-910 # 0 <thread_basic>
    for (i = 0; i < NUM_THREAD; i++) {
 396:	4995                	li	s3,5
        threads[i] = thread_create(thread_basic, (void *)(uint64)i, 0);
 398:	4601                	li	a2,0
 39a:	85a6                	mv	a1,s1
 39c:	8556                	mv	a0,s5
 39e:	377000ef          	jal	f14 <thread_create>
 3a2:	00a92023          	sw	a0,0(s2)
    for (i = 0; i < NUM_THREAD; i++) {
 3a6:	0485                	addi	s1,s1,1
 3a8:	0911                	addi	s2,s2,4
 3aa:	ff3497e3          	bne	s1,s3,398 <main+0x36>
    }

    for (i = 0; i < NUM_THREAD; i++) {
 3ae:	4481                	li	s1,0
 3b0:	4915                	li	s2,5
        int ret = thread_join();
 3b2:	3b3000ef          	jal	f64 <thread_join>
        if (ret < 0) {
 3b6:	20054f63          	bltz	a0,5d4 <main+0x272>
    for (i = 0; i < NUM_THREAD; i++) {
 3ba:	2485                	addiw	s1,s1,1
 3bc:	ff249be3          	bne	s1,s2,3b2 <main+0x50>
            printf("Thread %d join failed\n", i);
            exit(1);
        }
    }

    if (status != 1) {
 3c0:	00002717          	auipc	a4,0x2
 3c4:	c4872703          	lw	a4,-952(a4) # 2008 <status>
 3c8:	4785                	li	a5,1
 3ca:	20f71f63          	bne	a4,a5,5e8 <main+0x286>
        printf("TEST#1 Failed\n");
        exit(1);
    }
    printf("TEST#1 Passed\n");
 3ce:	00001517          	auipc	a0,0x1
 3d2:	dea50513          	addi	a0,a0,-534 # 11b8 <thread_join+0x254>
 3d6:	193000ef          	jal	d68 <printf>
    
    printf("\n[TEST#2]\n");
 3da:	00001517          	auipc	a0,0x1
 3de:	dee50513          	addi	a0,a0,-530 # 11c8 <thread_join+0x264>
 3e2:	187000ef          	jal	d68 <printf>
 3e6:	89d2                	mv	s3,s4
 3e8:	4901                	li	s2,0
 3ea:	4481                	li	s1,0
    for (i = 0; i < NUM_THREAD; i++) {
        threads[i] = thread_create(thread_inc, (void *)(uint64)i, (void *)(uint64)(i * 1000));
 3ec:	00000b17          	auipc	s6,0x0
 3f0:	c56b0b13          	addi	s6,s6,-938 # 42 <thread_inc>
    for (i = 0; i < NUM_THREAD; i++) {
 3f4:	4a95                	li	s5,5
        threads[i] = thread_create(thread_inc, (void *)(uint64)i, (void *)(uint64)(i * 1000));
 3f6:	864a                	mv	a2,s2
 3f8:	85a6                	mv	a1,s1
 3fa:	855a                	mv	a0,s6
 3fc:	319000ef          	jal	f14 <thread_create>
 400:	00a9a023          	sw	a0,0(s3)
    for (i = 0; i < NUM_THREAD; i++) {
 404:	0485                	addi	s1,s1,1
 406:	3e890913          	addi	s2,s2,1000
 40a:	0991                	addi	s3,s3,4
 40c:	ff5495e3          	bne	s1,s5,3f6 <main+0x94>
    }

    for (i = 0; i < NUM_THREAD; i++) {
 410:	4481                	li	s1,0
 412:	4915                	li	s2,5
        int ret = thread_join();
 414:	351000ef          	jal	f64 <thread_join>
        if (ret < 0) {
 418:	1e054163          	bltz	a0,5fa <main+0x298>
    for (i = 0; i < NUM_THREAD; i++) {
 41c:	2485                	addiw	s1,s1,1
 41e:	ff249be3          	bne	s1,s2,414 <main+0xb2>
 422:	00002717          	auipc	a4,0x2
 426:	bfe70713          	addi	a4,a4,-1026 # 2020 <expected>
 42a:	4781                	li	a5,0
            printf("Thread %d join failed\n", i);
            exit(1);
        }
    }

    for (i = 0; i < NUM_THREAD; i++) {
 42c:	4581                	li	a1,0
 42e:	4515                	li	a0,5
        if (expected[i] != i * 1000) {
 430:	4314                	lw	a3,0(a4)
 432:	0007861b          	sext.w	a2,a5
 436:	1cc69c63          	bne	a3,a2,60e <main+0x2ac>
    for (i = 0; i < NUM_THREAD; i++) {
 43a:	2585                	addiw	a1,a1,1
 43c:	3e87879b          	addiw	a5,a5,1000
 440:	0711                	addi	a4,a4,4
 442:	fea597e3          	bne	a1,a0,430 <main+0xce>
            printf("Thread %d expected %d, but got %d\n", i, i * 1000, expected[i]);
            exit(1);
        }
    }
    printf("TEST#2 Passed\n");
 446:	00001517          	auipc	a0,0x1
 44a:	dba50513          	addi	a0,a0,-582 # 1200 <thread_join+0x29c>
 44e:	11b000ef          	jal	d68 <printf>
    
    printf("\n[TEST#3]\n");
 452:	00001517          	auipc	a0,0x1
 456:	dbe50513          	addi	a0,a0,-578 # 1210 <thread_join+0x2ac>
 45a:	10f000ef          	jal	d68 <printf>
 45e:	8952                	mv	s2,s4
 460:	4481                	li	s1,0
    for (i = 0; i < NUM_THREAD; i++) {
        threads[i] = thread_create(thread_fork, (void *)(uint64)i, 0);
 462:	00000a97          	auipc	s5,0x0
 466:	c4aa8a93          	addi	s5,s5,-950 # ac <thread_fork>
    for (i = 0; i < NUM_THREAD; i++) {
 46a:	4995                	li	s3,5
        threads[i] = thread_create(thread_fork, (void *)(uint64)i, 0);
 46c:	4601                	li	a2,0
 46e:	85a6                	mv	a1,s1
 470:	8556                	mv	a0,s5
 472:	2a3000ef          	jal	f14 <thread_create>
 476:	00a92023          	sw	a0,0(s2)
    for (i = 0; i < NUM_THREAD; i++) {
 47a:	0485                	addi	s1,s1,1
 47c:	0911                	addi	s2,s2,4
 47e:	ff3497e3          	bne	s1,s3,46c <main+0x10a>
    }
    for (i = 0; i < NUM_THREAD; i++) {
 482:	4481                	li	s1,0
 484:	4915                	li	s2,5
        int ret = thread_join();
 486:	2df000ef          	jal	f64 <thread_join>
        if (ret < 0) {
 48a:	18054b63          	bltz	a0,620 <main+0x2be>
    for (i = 0; i < NUM_THREAD; i++) {
 48e:	2485                	addiw	s1,s1,1
 490:	ff249be3          	bne	s1,s2,486 <main+0x124>
            printf("Thread %d join failed\n", i);
            exit(1);
        }
    }
    if (status != 2) {
 494:	00002597          	auipc	a1,0x2
 498:	b745a583          	lw	a1,-1164(a1) # 2008 <status>
 49c:	4789                	li	a5,2
 49e:	18f59b63          	bne	a1,a5,634 <main+0x2d2>
        else {
            printf("TEST#3 Failed: Unexpected status %d\n", status);
        }
        exit(1);
    }
    printf("TEST#3 Passed\n");
 4a2:	00001517          	auipc	a0,0x1
 4a6:	de650513          	addi	a0,a0,-538 # 1288 <thread_join+0x324>
 4aa:	0bf000ef          	jal	d68 <printf>
    
    printf("\n[TEST#4]\n");
 4ae:	00001517          	auipc	a0,0x1
 4b2:	dea50513          	addi	a0,a0,-534 # 1298 <thread_join+0x334>
 4b6:	0b3000ef          	jal	d68 <printf>
 4ba:	8952                	mv	s2,s4
 4bc:	4481                	li	s1,0
    for (i = 0; i < NUM_THREAD; i++) {
        threads[i] = thread_create(thread_sbrk, (void *)(uint64)i, (void *)(uint64)0);
 4be:	00000a97          	auipc	s5,0x0
 4c2:	c9ca8a93          	addi	s5,s5,-868 # 15a <thread_sbrk>
    for (i = 0; i < NUM_THREAD; i++) {
 4c6:	4995                	li	s3,5
        threads[i] = thread_create(thread_sbrk, (void *)(uint64)i, (void *)(uint64)0);
 4c8:	4601                	li	a2,0
 4ca:	85a6                	mv	a1,s1
 4cc:	8556                	mv	a0,s5
 4ce:	247000ef          	jal	f14 <thread_create>
 4d2:	00a92023          	sw	a0,0(s2)
    for (i = 0; i < NUM_THREAD; i++) {
 4d6:	0485                	addi	s1,s1,1
 4d8:	0911                	addi	s2,s2,4
 4da:	ff3497e3          	bne	s1,s3,4c8 <main+0x166>
    }
    for (i = 0; i < NUM_THREAD; i++) {
 4de:	4481                	li	s1,0
 4e0:	4915                	li	s2,5
        int ret = thread_join();
 4e2:	283000ef          	jal	f64 <thread_join>
        if (ret < 0) {
 4e6:	16054a63          	bltz	a0,65a <main+0x2f8>
    for (i = 0; i < NUM_THREAD; i++) {
 4ea:	2485                	addiw	s1,s1,1
 4ec:	ff249be3          	bne	s1,s2,4e2 <main+0x180>
            printf("Thread %d join failed\n", i);
            exit(1);
        }
    }

    printf("TEST#4 Passed\n");
 4f0:	00001517          	auipc	a0,0x1
 4f4:	db850513          	addi	a0,a0,-584 # 12a8 <thread_join+0x344>
 4f8:	071000ef          	jal	d68 <printf>
    
    printf("\n[TEST#5]\n");
 4fc:	00001517          	auipc	a0,0x1
 500:	dbc50513          	addi	a0,a0,-580 # 12b8 <thread_join+0x354>
 504:	065000ef          	jal	d68 <printf>

    pid = fork();
 508:	430000ef          	jal	938 <fork>
 50c:	84aa                	mv	s1,a0
    if (pid < 0) {
 50e:	16054063          	bltz	a0,66e <main+0x30c>
        printf("Fork error\n");
        exit(1);
    } else if (pid == 0) {
 512:	18051163          	bnez	a0,694 <main+0x332>
 516:	89d2                	mv	s3,s4
 518:	4901                	li	s2,0
        for (i = 0; i < NUM_THREAD; i++) {
            threads[i] = thread_create(thread_kill, (void *)(uint64)i, (void *)(uint64)getpid());
 51a:	00000b17          	auipc	s6,0x0
 51e:	d90b0b13          	addi	s6,s6,-624 # 2aa <thread_kill>
        for (i = 0; i < NUM_THREAD; i++) {
 522:	4a95                	li	s5,5
            threads[i] = thread_create(thread_kill, (void *)(uint64)i, (void *)(uint64)getpid());
 524:	49c000ef          	jal	9c0 <getpid>
 528:	862a                	mv	a2,a0
 52a:	85ca                	mv	a1,s2
 52c:	855a                	mv	a0,s6
 52e:	1e7000ef          	jal	f14 <thread_create>
 532:	00a9a023          	sw	a0,0(s3)
        for (i = 0; i < NUM_THREAD; i++) {
 536:	0905                	addi	s2,s2,1
 538:	0991                	addi	s3,s3,4
 53a:	ff5915e3          	bne	s2,s5,524 <main+0x1c2>
        }
        for (i = 0; i < NUM_THREAD; i++) {
 53e:	4915                	li	s2,5
            int ret = thread_join();
 540:	225000ef          	jal	f64 <thread_join>
            if (ret < 0) {
 544:	12054e63          	bltz	a0,680 <main+0x31e>
        for (i = 0; i < NUM_THREAD; i++) {
 548:	2485                	addiw	s1,s1,1
 54a:	ff249be3          	bne	s1,s2,540 <main+0x1de>
    } else {
        sleep(30);
        wait(0);
    }

    printf("TEST#5 Passed\n");
 54e:	00001517          	auipc	a0,0x1
 552:	d8a50513          	addi	a0,a0,-630 # 12d8 <thread_join+0x374>
 556:	013000ef          	jal	d68 <printf>
    
    printf("\n[TEST#6]\n");
 55a:	00001517          	auipc	a0,0x1
 55e:	d8e50513          	addi	a0,a0,-626 # 12e8 <thread_join+0x384>
 562:	007000ef          	jal	d68 <printf>
    pid = fork();
 566:	3d2000ef          	jal	938 <fork>
 56a:	84aa                	mv	s1,a0

    if (pid < 0) {
 56c:	12054b63          	bltz	a0,6a2 <main+0x340>
        printf("Fork error\n");
        exit(1);
    } else if (pid == 0) {
 570:	14051c63          	bnez	a0,6c8 <main+0x366>
 574:	4901                	li	s2,0
        for (i = 0; i < NUM_THREAD; i++) {
            threads[i] = thread_create(thread_exec, (void *)(uint64)i, (void *)(uint64)0);
 576:	00000a97          	auipc	s5,0x0
 57a:	d7aa8a93          	addi	s5,s5,-646 # 2f0 <thread_exec>
        for (i = 0; i < NUM_THREAD; i++) {
 57e:	4995                	li	s3,5
            threads[i] = thread_create(thread_exec, (void *)(uint64)i, (void *)(uint64)0);
 580:	4601                	li	a2,0
 582:	85ca                	mv	a1,s2
 584:	8556                	mv	a0,s5
 586:	18f000ef          	jal	f14 <thread_create>
 58a:	00aa2023          	sw	a0,0(s4)
        for (i = 0; i < NUM_THREAD; i++) {
 58e:	0905                	addi	s2,s2,1
 590:	0a11                	addi	s4,s4,4
 592:	ff3917e3          	bne	s2,s3,580 <main+0x21e>
        }
        for (i = 0; i < NUM_THREAD; i++) {
 596:	4915                	li	s2,5
            int ret = thread_join();
 598:	1cd000ef          	jal	f64 <thread_join>
            if (ret < 0) {
 59c:	10054c63          	bltz	a0,6b4 <main+0x352>
        for (i = 0; i < NUM_THREAD; i++) {
 5a0:	2485                	addiw	s1,s1,1
 5a2:	ff249be3          	bne	s1,s2,598 <main+0x236>
    } else {
        sleep(30);
        wait(0);
    }

    printf("TEST#6 Passed\n");
 5a6:	00001517          	auipc	a0,0x1
 5aa:	d5250513          	addi	a0,a0,-686 # 12f8 <thread_join+0x394>
 5ae:	7ba000ef          	jal	d68 <printf>

    printf("\nAll tests passed. Great job!!\n");
 5b2:	00001517          	auipc	a0,0x1
 5b6:	d5650513          	addi	a0,a0,-682 # 1308 <thread_join+0x3a4>
 5ba:	7ae000ef          	jal	d68 <printf>
    
    return 0;
 5be:	4501                	li	a0,0
 5c0:	70e2                	ld	ra,56(sp)
 5c2:	7442                	ld	s0,48(sp)
 5c4:	74a2                	ld	s1,40(sp)
 5c6:	7902                	ld	s2,32(sp)
 5c8:	69e2                	ld	s3,24(sp)
 5ca:	6a42                	ld	s4,16(sp)
 5cc:	6aa2                	ld	s5,8(sp)
 5ce:	6b02                	ld	s6,0(sp)
 5d0:	6121                	addi	sp,sp,64
 5d2:	8082                	ret
            printf("Thread %d join failed\n", i);
 5d4:	85a6                	mv	a1,s1
 5d6:	00001517          	auipc	a0,0x1
 5da:	bba50513          	addi	a0,a0,-1094 # 1190 <thread_join+0x22c>
 5de:	78a000ef          	jal	d68 <printf>
            exit(1);
 5e2:	4505                	li	a0,1
 5e4:	35c000ef          	jal	940 <exit>
        printf("TEST#1 Failed\n");
 5e8:	00001517          	auipc	a0,0x1
 5ec:	bc050513          	addi	a0,a0,-1088 # 11a8 <thread_join+0x244>
 5f0:	778000ef          	jal	d68 <printf>
        exit(1);
 5f4:	4505                	li	a0,1
 5f6:	34a000ef          	jal	940 <exit>
            printf("Thread %d join failed\n", i);
 5fa:	85a6                	mv	a1,s1
 5fc:	00001517          	auipc	a0,0x1
 600:	b9450513          	addi	a0,a0,-1132 # 1190 <thread_join+0x22c>
 604:	764000ef          	jal	d68 <printf>
            exit(1);
 608:	4505                	li	a0,1
 60a:	336000ef          	jal	940 <exit>
            printf("Thread %d expected %d, but got %d\n", i, i * 1000, expected[i]);
 60e:	00001517          	auipc	a0,0x1
 612:	bca50513          	addi	a0,a0,-1078 # 11d8 <thread_join+0x274>
 616:	752000ef          	jal	d68 <printf>
            exit(1);
 61a:	4505                	li	a0,1
 61c:	324000ef          	jal	940 <exit>
            printf("Thread %d join failed\n", i);
 620:	85a6                	mv	a1,s1
 622:	00001517          	auipc	a0,0x1
 626:	b6e50513          	addi	a0,a0,-1170 # 1190 <thread_join+0x22c>
 62a:	73e000ef          	jal	d68 <printf>
            exit(1);
 62e:	4505                	li	a0,1
 630:	310000ef          	jal	940 <exit>
        if (status == 3) {
 634:	478d                	li	a5,3
 636:	00f58b63          	beq	a1,a5,64c <main+0x2ea>
            printf("TEST#3 Failed: Unexpected status %d\n", status);
 63a:	00001517          	auipc	a0,0x1
 63e:	c2650513          	addi	a0,a0,-986 # 1260 <thread_join+0x2fc>
 642:	726000ef          	jal	d68 <printf>
        exit(1);
 646:	4505                	li	a0,1
 648:	2f8000ef          	jal	940 <exit>
            printf("TEST#3 Failed: Child process referenced parent's memory\n");
 64c:	00001517          	auipc	a0,0x1
 650:	bd450513          	addi	a0,a0,-1068 # 1220 <thread_join+0x2bc>
 654:	714000ef          	jal	d68 <printf>
 658:	b7fd                	j	646 <main+0x2e4>
            printf("Thread %d join failed\n", i);
 65a:	85a6                	mv	a1,s1
 65c:	00001517          	auipc	a0,0x1
 660:	b3450513          	addi	a0,a0,-1228 # 1190 <thread_join+0x22c>
 664:	704000ef          	jal	d68 <printf>
            exit(1);
 668:	4505                	li	a0,1
 66a:	2d6000ef          	jal	940 <exit>
        printf("Fork error\n");
 66e:	00001517          	auipc	a0,0x1
 672:	c5a50513          	addi	a0,a0,-934 # 12c8 <thread_join+0x364>
 676:	6f2000ef          	jal	d68 <printf>
        exit(1);
 67a:	4505                	li	a0,1
 67c:	2c4000ef          	jal	940 <exit>
                printf("Thread %d join failed\n", i);
 680:	85a6                	mv	a1,s1
 682:	00001517          	auipc	a0,0x1
 686:	b0e50513          	addi	a0,a0,-1266 # 1190 <thread_join+0x22c>
 68a:	6de000ef          	jal	d68 <printf>
                exit(1);
 68e:	4505                	li	a0,1
 690:	2b0000ef          	jal	940 <exit>
        sleep(30);
 694:	4579                	li	a0,30
 696:	33a000ef          	jal	9d0 <sleep>
        wait(0);
 69a:	4501                	li	a0,0
 69c:	2ac000ef          	jal	948 <wait>
 6a0:	b57d                	j	54e <main+0x1ec>
        printf("Fork error\n");
 6a2:	00001517          	auipc	a0,0x1
 6a6:	c2650513          	addi	a0,a0,-986 # 12c8 <thread_join+0x364>
 6aa:	6be000ef          	jal	d68 <printf>
        exit(1);
 6ae:	4505                	li	a0,1
 6b0:	290000ef          	jal	940 <exit>
                printf("Thread %d join failed\n", i);
 6b4:	85a6                	mv	a1,s1
 6b6:	00001517          	auipc	a0,0x1
 6ba:	ada50513          	addi	a0,a0,-1318 # 1190 <thread_join+0x22c>
 6be:	6aa000ef          	jal	d68 <printf>
                exit(1);
 6c2:	4505                	li	a0,1
 6c4:	27c000ef          	jal	940 <exit>
        sleep(30);
 6c8:	4579                	li	a0,30
 6ca:	306000ef          	jal	9d0 <sleep>
        wait(0);
 6ce:	4501                	li	a0,0
 6d0:	278000ef          	jal	948 <wait>
 6d4:	bdc9                	j	5a6 <main+0x244>

00000000000006d6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 6d6:	1141                	addi	sp,sp,-16
 6d8:	e406                	sd	ra,8(sp)
 6da:	e022                	sd	s0,0(sp)
 6dc:	0800                	addi	s0,sp,16
  extern int main();
  main();
 6de:	c85ff0ef          	jal	362 <main>
  exit(0);
 6e2:	4501                	li	a0,0
 6e4:	25c000ef          	jal	940 <exit>

00000000000006e8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 6e8:	1141                	addi	sp,sp,-16
 6ea:	e422                	sd	s0,8(sp)
 6ec:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6ee:	87aa                	mv	a5,a0
 6f0:	0585                	addi	a1,a1,1
 6f2:	0785                	addi	a5,a5,1
 6f4:	fff5c703          	lbu	a4,-1(a1)
 6f8:	fee78fa3          	sb	a4,-1(a5)
 6fc:	fb75                	bnez	a4,6f0 <strcpy+0x8>
    ;
  return os;
}
 6fe:	6422                	ld	s0,8(sp)
 700:	0141                	addi	sp,sp,16
 702:	8082                	ret

0000000000000704 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 704:	1141                	addi	sp,sp,-16
 706:	e422                	sd	s0,8(sp)
 708:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 70a:	00054783          	lbu	a5,0(a0)
 70e:	cb91                	beqz	a5,722 <strcmp+0x1e>
 710:	0005c703          	lbu	a4,0(a1)
 714:	00f71763          	bne	a4,a5,722 <strcmp+0x1e>
    p++, q++;
 718:	0505                	addi	a0,a0,1
 71a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 71c:	00054783          	lbu	a5,0(a0)
 720:	fbe5                	bnez	a5,710 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 722:	0005c503          	lbu	a0,0(a1)
}
 726:	40a7853b          	subw	a0,a5,a0
 72a:	6422                	ld	s0,8(sp)
 72c:	0141                	addi	sp,sp,16
 72e:	8082                	ret

0000000000000730 <strlen>:

uint
strlen(const char *s)
{
 730:	1141                	addi	sp,sp,-16
 732:	e422                	sd	s0,8(sp)
 734:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 736:	00054783          	lbu	a5,0(a0)
 73a:	cf91                	beqz	a5,756 <strlen+0x26>
 73c:	0505                	addi	a0,a0,1
 73e:	87aa                	mv	a5,a0
 740:	86be                	mv	a3,a5
 742:	0785                	addi	a5,a5,1
 744:	fff7c703          	lbu	a4,-1(a5)
 748:	ff65                	bnez	a4,740 <strlen+0x10>
 74a:	40a6853b          	subw	a0,a3,a0
 74e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 750:	6422                	ld	s0,8(sp)
 752:	0141                	addi	sp,sp,16
 754:	8082                	ret
  for(n = 0; s[n]; n++)
 756:	4501                	li	a0,0
 758:	bfe5                	j	750 <strlen+0x20>

000000000000075a <memset>:

void*
memset(void *dst, int c, uint n)
{
 75a:	1141                	addi	sp,sp,-16
 75c:	e422                	sd	s0,8(sp)
 75e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 760:	ca19                	beqz	a2,776 <memset+0x1c>
 762:	87aa                	mv	a5,a0
 764:	1602                	slli	a2,a2,0x20
 766:	9201                	srli	a2,a2,0x20
 768:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 76c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 770:	0785                	addi	a5,a5,1
 772:	fee79de3          	bne	a5,a4,76c <memset+0x12>
  }
  return dst;
}
 776:	6422                	ld	s0,8(sp)
 778:	0141                	addi	sp,sp,16
 77a:	8082                	ret

000000000000077c <strchr>:

char*
strchr(const char *s, char c)
{
 77c:	1141                	addi	sp,sp,-16
 77e:	e422                	sd	s0,8(sp)
 780:	0800                	addi	s0,sp,16
  for(; *s; s++)
 782:	00054783          	lbu	a5,0(a0)
 786:	cb99                	beqz	a5,79c <strchr+0x20>
    if(*s == c)
 788:	00f58763          	beq	a1,a5,796 <strchr+0x1a>
  for(; *s; s++)
 78c:	0505                	addi	a0,a0,1
 78e:	00054783          	lbu	a5,0(a0)
 792:	fbfd                	bnez	a5,788 <strchr+0xc>
      return (char*)s;
  return 0;
 794:	4501                	li	a0,0
}
 796:	6422                	ld	s0,8(sp)
 798:	0141                	addi	sp,sp,16
 79a:	8082                	ret
  return 0;
 79c:	4501                	li	a0,0
 79e:	bfe5                	j	796 <strchr+0x1a>

00000000000007a0 <gets>:

char*
gets(char *buf, int max)
{
 7a0:	711d                	addi	sp,sp,-96
 7a2:	ec86                	sd	ra,88(sp)
 7a4:	e8a2                	sd	s0,80(sp)
 7a6:	e4a6                	sd	s1,72(sp)
 7a8:	e0ca                	sd	s2,64(sp)
 7aa:	fc4e                	sd	s3,56(sp)
 7ac:	f852                	sd	s4,48(sp)
 7ae:	f456                	sd	s5,40(sp)
 7b0:	f05a                	sd	s6,32(sp)
 7b2:	ec5e                	sd	s7,24(sp)
 7b4:	1080                	addi	s0,sp,96
 7b6:	8baa                	mv	s7,a0
 7b8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7ba:	892a                	mv	s2,a0
 7bc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 7be:	4aa9                	li	s5,10
 7c0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 7c2:	89a6                	mv	s3,s1
 7c4:	2485                	addiw	s1,s1,1
 7c6:	0344d663          	bge	s1,s4,7f2 <gets+0x52>
    cc = read(0, &c, 1);
 7ca:	4605                	li	a2,1
 7cc:	faf40593          	addi	a1,s0,-81
 7d0:	4501                	li	a0,0
 7d2:	186000ef          	jal	958 <read>
    if(cc < 1)
 7d6:	00a05e63          	blez	a0,7f2 <gets+0x52>
    buf[i++] = c;
 7da:	faf44783          	lbu	a5,-81(s0)
 7de:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 7e2:	01578763          	beq	a5,s5,7f0 <gets+0x50>
 7e6:	0905                	addi	s2,s2,1
 7e8:	fd679de3          	bne	a5,s6,7c2 <gets+0x22>
    buf[i++] = c;
 7ec:	89a6                	mv	s3,s1
 7ee:	a011                	j	7f2 <gets+0x52>
 7f0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 7f2:	99de                	add	s3,s3,s7
 7f4:	00098023          	sb	zero,0(s3)
  return buf;
}
 7f8:	855e                	mv	a0,s7
 7fa:	60e6                	ld	ra,88(sp)
 7fc:	6446                	ld	s0,80(sp)
 7fe:	64a6                	ld	s1,72(sp)
 800:	6906                	ld	s2,64(sp)
 802:	79e2                	ld	s3,56(sp)
 804:	7a42                	ld	s4,48(sp)
 806:	7aa2                	ld	s5,40(sp)
 808:	7b02                	ld	s6,32(sp)
 80a:	6be2                	ld	s7,24(sp)
 80c:	6125                	addi	sp,sp,96
 80e:	8082                	ret

0000000000000810 <stat>:

int
stat(const char *n, struct stat *st)
{
 810:	1101                	addi	sp,sp,-32
 812:	ec06                	sd	ra,24(sp)
 814:	e822                	sd	s0,16(sp)
 816:	e04a                	sd	s2,0(sp)
 818:	1000                	addi	s0,sp,32
 81a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 81c:	4581                	li	a1,0
 81e:	162000ef          	jal	980 <open>
  if(fd < 0)
 822:	02054263          	bltz	a0,846 <stat+0x36>
 826:	e426                	sd	s1,8(sp)
 828:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 82a:	85ca                	mv	a1,s2
 82c:	16c000ef          	jal	998 <fstat>
 830:	892a                	mv	s2,a0
  close(fd);
 832:	8526                	mv	a0,s1
 834:	134000ef          	jal	968 <close>
  return r;
 838:	64a2                	ld	s1,8(sp)
}
 83a:	854a                	mv	a0,s2
 83c:	60e2                	ld	ra,24(sp)
 83e:	6442                	ld	s0,16(sp)
 840:	6902                	ld	s2,0(sp)
 842:	6105                	addi	sp,sp,32
 844:	8082                	ret
    return -1;
 846:	597d                	li	s2,-1
 848:	bfcd                	j	83a <stat+0x2a>

000000000000084a <atoi>:

int
atoi(const char *s)
{
 84a:	1141                	addi	sp,sp,-16
 84c:	e422                	sd	s0,8(sp)
 84e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 850:	00054683          	lbu	a3,0(a0)
 854:	fd06879b          	addiw	a5,a3,-48
 858:	0ff7f793          	zext.b	a5,a5
 85c:	4625                	li	a2,9
 85e:	02f66863          	bltu	a2,a5,88e <atoi+0x44>
 862:	872a                	mv	a4,a0
  n = 0;
 864:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 866:	0705                	addi	a4,a4,1
 868:	0025179b          	slliw	a5,a0,0x2
 86c:	9fa9                	addw	a5,a5,a0
 86e:	0017979b          	slliw	a5,a5,0x1
 872:	9fb5                	addw	a5,a5,a3
 874:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 878:	00074683          	lbu	a3,0(a4)
 87c:	fd06879b          	addiw	a5,a3,-48
 880:	0ff7f793          	zext.b	a5,a5
 884:	fef671e3          	bgeu	a2,a5,866 <atoi+0x1c>
  return n;
}
 888:	6422                	ld	s0,8(sp)
 88a:	0141                	addi	sp,sp,16
 88c:	8082                	ret
  n = 0;
 88e:	4501                	li	a0,0
 890:	bfe5                	j	888 <atoi+0x3e>

0000000000000892 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 892:	1141                	addi	sp,sp,-16
 894:	e422                	sd	s0,8(sp)
 896:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 898:	02b57463          	bgeu	a0,a1,8c0 <memmove+0x2e>
    while(n-- > 0)
 89c:	00c05f63          	blez	a2,8ba <memmove+0x28>
 8a0:	1602                	slli	a2,a2,0x20
 8a2:	9201                	srli	a2,a2,0x20
 8a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 8a8:	872a                	mv	a4,a0
      *dst++ = *src++;
 8aa:	0585                	addi	a1,a1,1
 8ac:	0705                	addi	a4,a4,1
 8ae:	fff5c683          	lbu	a3,-1(a1)
 8b2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 8b6:	fef71ae3          	bne	a4,a5,8aa <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 8ba:	6422                	ld	s0,8(sp)
 8bc:	0141                	addi	sp,sp,16
 8be:	8082                	ret
    dst += n;
 8c0:	00c50733          	add	a4,a0,a2
    src += n;
 8c4:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 8c6:	fec05ae3          	blez	a2,8ba <memmove+0x28>
 8ca:	fff6079b          	addiw	a5,a2,-1 # 13fff <base+0x11faf>
 8ce:	1782                	slli	a5,a5,0x20
 8d0:	9381                	srli	a5,a5,0x20
 8d2:	fff7c793          	not	a5,a5
 8d6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 8d8:	15fd                	addi	a1,a1,-1
 8da:	177d                	addi	a4,a4,-1
 8dc:	0005c683          	lbu	a3,0(a1)
 8e0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 8e4:	fee79ae3          	bne	a5,a4,8d8 <memmove+0x46>
 8e8:	bfc9                	j	8ba <memmove+0x28>

00000000000008ea <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 8ea:	1141                	addi	sp,sp,-16
 8ec:	e422                	sd	s0,8(sp)
 8ee:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 8f0:	ca05                	beqz	a2,920 <memcmp+0x36>
 8f2:	fff6069b          	addiw	a3,a2,-1
 8f6:	1682                	slli	a3,a3,0x20
 8f8:	9281                	srli	a3,a3,0x20
 8fa:	0685                	addi	a3,a3,1
 8fc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 8fe:	00054783          	lbu	a5,0(a0)
 902:	0005c703          	lbu	a4,0(a1)
 906:	00e79863          	bne	a5,a4,916 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 90a:	0505                	addi	a0,a0,1
    p2++;
 90c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 90e:	fed518e3          	bne	a0,a3,8fe <memcmp+0x14>
  }
  return 0;
 912:	4501                	li	a0,0
 914:	a019                	j	91a <memcmp+0x30>
      return *p1 - *p2;
 916:	40e7853b          	subw	a0,a5,a4
}
 91a:	6422                	ld	s0,8(sp)
 91c:	0141                	addi	sp,sp,16
 91e:	8082                	ret
  return 0;
 920:	4501                	li	a0,0
 922:	bfe5                	j	91a <memcmp+0x30>

0000000000000924 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 924:	1141                	addi	sp,sp,-16
 926:	e406                	sd	ra,8(sp)
 928:	e022                	sd	s0,0(sp)
 92a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 92c:	f67ff0ef          	jal	892 <memmove>
}
 930:	60a2                	ld	ra,8(sp)
 932:	6402                	ld	s0,0(sp)
 934:	0141                	addi	sp,sp,16
 936:	8082                	ret

0000000000000938 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 938:	4885                	li	a7,1
 ecall
 93a:	00000073          	ecall
 ret
 93e:	8082                	ret

0000000000000940 <exit>:
.global exit
exit:
 li a7, SYS_exit
 940:	4889                	li	a7,2
 ecall
 942:	00000073          	ecall
 ret
 946:	8082                	ret

0000000000000948 <wait>:
.global wait
wait:
 li a7, SYS_wait
 948:	488d                	li	a7,3
 ecall
 94a:	00000073          	ecall
 ret
 94e:	8082                	ret

0000000000000950 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 950:	4891                	li	a7,4
 ecall
 952:	00000073          	ecall
 ret
 956:	8082                	ret

0000000000000958 <read>:
.global read
read:
 li a7, SYS_read
 958:	4895                	li	a7,5
 ecall
 95a:	00000073          	ecall
 ret
 95e:	8082                	ret

0000000000000960 <write>:
.global write
write:
 li a7, SYS_write
 960:	48c1                	li	a7,16
 ecall
 962:	00000073          	ecall
 ret
 966:	8082                	ret

0000000000000968 <close>:
.global close
close:
 li a7, SYS_close
 968:	48d5                	li	a7,21
 ecall
 96a:	00000073          	ecall
 ret
 96e:	8082                	ret

0000000000000970 <kill>:
.global kill
kill:
 li a7, SYS_kill
 970:	4899                	li	a7,6
 ecall
 972:	00000073          	ecall
 ret
 976:	8082                	ret

0000000000000978 <exec>:
.global exec
exec:
 li a7, SYS_exec
 978:	489d                	li	a7,7
 ecall
 97a:	00000073          	ecall
 ret
 97e:	8082                	ret

0000000000000980 <open>:
.global open
open:
 li a7, SYS_open
 980:	48bd                	li	a7,15
 ecall
 982:	00000073          	ecall
 ret
 986:	8082                	ret

0000000000000988 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 988:	48c5                	li	a7,17
 ecall
 98a:	00000073          	ecall
 ret
 98e:	8082                	ret

0000000000000990 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 990:	48c9                	li	a7,18
 ecall
 992:	00000073          	ecall
 ret
 996:	8082                	ret

0000000000000998 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 998:	48a1                	li	a7,8
 ecall
 99a:	00000073          	ecall
 ret
 99e:	8082                	ret

00000000000009a0 <link>:
.global link
link:
 li a7, SYS_link
 9a0:	48cd                	li	a7,19
 ecall
 9a2:	00000073          	ecall
 ret
 9a6:	8082                	ret

00000000000009a8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 9a8:	48d1                	li	a7,20
 ecall
 9aa:	00000073          	ecall
 ret
 9ae:	8082                	ret

00000000000009b0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 9b0:	48a5                	li	a7,9
 ecall
 9b2:	00000073          	ecall
 ret
 9b6:	8082                	ret

00000000000009b8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 9b8:	48a9                	li	a7,10
 ecall
 9ba:	00000073          	ecall
 ret
 9be:	8082                	ret

00000000000009c0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 9c0:	48ad                	li	a7,11
 ecall
 9c2:	00000073          	ecall
 ret
 9c6:	8082                	ret

00000000000009c8 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 9c8:	48b1                	li	a7,12
 ecall
 9ca:	00000073          	ecall
 ret
 9ce:	8082                	ret

00000000000009d0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 9d0:	48b5                	li	a7,13
 ecall
 9d2:	00000073          	ecall
 ret
 9d6:	8082                	ret

00000000000009d8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 9d8:	48b9                	li	a7,14
 ecall
 9da:	00000073          	ecall
 ret
 9de:	8082                	ret

00000000000009e0 <clone>:
.global clone
clone:
 li a7, SYS_clone
 9e0:	48d9                	li	a7,22
 ecall
 9e2:	00000073          	ecall
 ret
 9e6:	8082                	ret

00000000000009e8 <join>:
.global join
join:
 li a7, SYS_join
 9e8:	48dd                	li	a7,23
 ecall
 9ea:	00000073          	ecall
 ret
 9ee:	8082                	ret

00000000000009f0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 9f0:	1101                	addi	sp,sp,-32
 9f2:	ec06                	sd	ra,24(sp)
 9f4:	e822                	sd	s0,16(sp)
 9f6:	1000                	addi	s0,sp,32
 9f8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 9fc:	4605                	li	a2,1
 9fe:	fef40593          	addi	a1,s0,-17
 a02:	f5fff0ef          	jal	960 <write>
}
 a06:	60e2                	ld	ra,24(sp)
 a08:	6442                	ld	s0,16(sp)
 a0a:	6105                	addi	sp,sp,32
 a0c:	8082                	ret

0000000000000a0e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a0e:	7139                	addi	sp,sp,-64
 a10:	fc06                	sd	ra,56(sp)
 a12:	f822                	sd	s0,48(sp)
 a14:	f426                	sd	s1,40(sp)
 a16:	0080                	addi	s0,sp,64
 a18:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a1a:	c299                	beqz	a3,a20 <printint+0x12>
 a1c:	0805c963          	bltz	a1,aae <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 a20:	2581                	sext.w	a1,a1
  neg = 0;
 a22:	4881                	li	a7,0
 a24:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 a28:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 a2a:	2601                	sext.w	a2,a2
 a2c:	00001517          	auipc	a0,0x1
 a30:	90450513          	addi	a0,a0,-1788 # 1330 <digits>
 a34:	883a                	mv	a6,a4
 a36:	2705                	addiw	a4,a4,1
 a38:	02c5f7bb          	remuw	a5,a1,a2
 a3c:	1782                	slli	a5,a5,0x20
 a3e:	9381                	srli	a5,a5,0x20
 a40:	97aa                	add	a5,a5,a0
 a42:	0007c783          	lbu	a5,0(a5)
 a46:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 a4a:	0005879b          	sext.w	a5,a1
 a4e:	02c5d5bb          	divuw	a1,a1,a2
 a52:	0685                	addi	a3,a3,1
 a54:	fec7f0e3          	bgeu	a5,a2,a34 <printint+0x26>
  if(neg)
 a58:	00088c63          	beqz	a7,a70 <printint+0x62>
    buf[i++] = '-';
 a5c:	fd070793          	addi	a5,a4,-48
 a60:	00878733          	add	a4,a5,s0
 a64:	02d00793          	li	a5,45
 a68:	fef70823          	sb	a5,-16(a4)
 a6c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 a70:	02e05a63          	blez	a4,aa4 <printint+0x96>
 a74:	f04a                	sd	s2,32(sp)
 a76:	ec4e                	sd	s3,24(sp)
 a78:	fc040793          	addi	a5,s0,-64
 a7c:	00e78933          	add	s2,a5,a4
 a80:	fff78993          	addi	s3,a5,-1
 a84:	99ba                	add	s3,s3,a4
 a86:	377d                	addiw	a4,a4,-1
 a88:	1702                	slli	a4,a4,0x20
 a8a:	9301                	srli	a4,a4,0x20
 a8c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 a90:	fff94583          	lbu	a1,-1(s2)
 a94:	8526                	mv	a0,s1
 a96:	f5bff0ef          	jal	9f0 <putc>
  while(--i >= 0)
 a9a:	197d                	addi	s2,s2,-1
 a9c:	ff391ae3          	bne	s2,s3,a90 <printint+0x82>
 aa0:	7902                	ld	s2,32(sp)
 aa2:	69e2                	ld	s3,24(sp)
}
 aa4:	70e2                	ld	ra,56(sp)
 aa6:	7442                	ld	s0,48(sp)
 aa8:	74a2                	ld	s1,40(sp)
 aaa:	6121                	addi	sp,sp,64
 aac:	8082                	ret
    x = -xx;
 aae:	40b005bb          	negw	a1,a1
    neg = 1;
 ab2:	4885                	li	a7,1
    x = -xx;
 ab4:	bf85                	j	a24 <printint+0x16>

0000000000000ab6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 ab6:	711d                	addi	sp,sp,-96
 ab8:	ec86                	sd	ra,88(sp)
 aba:	e8a2                	sd	s0,80(sp)
 abc:	e0ca                	sd	s2,64(sp)
 abe:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 ac0:	0005c903          	lbu	s2,0(a1)
 ac4:	26090863          	beqz	s2,d34 <vprintf+0x27e>
 ac8:	e4a6                	sd	s1,72(sp)
 aca:	fc4e                	sd	s3,56(sp)
 acc:	f852                	sd	s4,48(sp)
 ace:	f456                	sd	s5,40(sp)
 ad0:	f05a                	sd	s6,32(sp)
 ad2:	ec5e                	sd	s7,24(sp)
 ad4:	e862                	sd	s8,16(sp)
 ad6:	e466                	sd	s9,8(sp)
 ad8:	8b2a                	mv	s6,a0
 ada:	8a2e                	mv	s4,a1
 adc:	8bb2                	mv	s7,a2
  state = 0;
 ade:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 ae0:	4481                	li	s1,0
 ae2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 ae4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 ae8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 aec:	06c00c93          	li	s9,108
 af0:	a005                	j	b10 <vprintf+0x5a>
        putc(fd, c0);
 af2:	85ca                	mv	a1,s2
 af4:	855a                	mv	a0,s6
 af6:	efbff0ef          	jal	9f0 <putc>
 afa:	a019                	j	b00 <vprintf+0x4a>
    } else if(state == '%'){
 afc:	03598263          	beq	s3,s5,b20 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 b00:	2485                	addiw	s1,s1,1
 b02:	8726                	mv	a4,s1
 b04:	009a07b3          	add	a5,s4,s1
 b08:	0007c903          	lbu	s2,0(a5)
 b0c:	20090c63          	beqz	s2,d24 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 b10:	0009079b          	sext.w	a5,s2
    if(state == 0){
 b14:	fe0994e3          	bnez	s3,afc <vprintf+0x46>
      if(c0 == '%'){
 b18:	fd579de3          	bne	a5,s5,af2 <vprintf+0x3c>
        state = '%';
 b1c:	89be                	mv	s3,a5
 b1e:	b7cd                	j	b00 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 b20:	00ea06b3          	add	a3,s4,a4
 b24:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 b28:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 b2a:	c681                	beqz	a3,b32 <vprintf+0x7c>
 b2c:	9752                	add	a4,a4,s4
 b2e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 b32:	03878f63          	beq	a5,s8,b70 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 b36:	05978963          	beq	a5,s9,b88 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 b3a:	07500713          	li	a4,117
 b3e:	0ee78363          	beq	a5,a4,c24 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 b42:	07800713          	li	a4,120
 b46:	12e78563          	beq	a5,a4,c70 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 b4a:	07000713          	li	a4,112
 b4e:	14e78a63          	beq	a5,a4,ca2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 b52:	07300713          	li	a4,115
 b56:	18e78a63          	beq	a5,a4,cea <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 b5a:	02500713          	li	a4,37
 b5e:	04e79563          	bne	a5,a4,ba8 <vprintf+0xf2>
        putc(fd, '%');
 b62:	02500593          	li	a1,37
 b66:	855a                	mv	a0,s6
 b68:	e89ff0ef          	jal	9f0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 b6c:	4981                	li	s3,0
 b6e:	bf49                	j	b00 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 b70:	008b8913          	addi	s2,s7,8
 b74:	4685                	li	a3,1
 b76:	4629                	li	a2,10
 b78:	000ba583          	lw	a1,0(s7)
 b7c:	855a                	mv	a0,s6
 b7e:	e91ff0ef          	jal	a0e <printint>
 b82:	8bca                	mv	s7,s2
      state = 0;
 b84:	4981                	li	s3,0
 b86:	bfad                	j	b00 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 b88:	06400793          	li	a5,100
 b8c:	02f68963          	beq	a3,a5,bbe <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 b90:	06c00793          	li	a5,108
 b94:	04f68263          	beq	a3,a5,bd8 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 b98:	07500793          	li	a5,117
 b9c:	0af68063          	beq	a3,a5,c3c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 ba0:	07800793          	li	a5,120
 ba4:	0ef68263          	beq	a3,a5,c88 <vprintf+0x1d2>
        putc(fd, '%');
 ba8:	02500593          	li	a1,37
 bac:	855a                	mv	a0,s6
 bae:	e43ff0ef          	jal	9f0 <putc>
        putc(fd, c0);
 bb2:	85ca                	mv	a1,s2
 bb4:	855a                	mv	a0,s6
 bb6:	e3bff0ef          	jal	9f0 <putc>
      state = 0;
 bba:	4981                	li	s3,0
 bbc:	b791                	j	b00 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 bbe:	008b8913          	addi	s2,s7,8
 bc2:	4685                	li	a3,1
 bc4:	4629                	li	a2,10
 bc6:	000ba583          	lw	a1,0(s7)
 bca:	855a                	mv	a0,s6
 bcc:	e43ff0ef          	jal	a0e <printint>
        i += 1;
 bd0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 bd2:	8bca                	mv	s7,s2
      state = 0;
 bd4:	4981                	li	s3,0
        i += 1;
 bd6:	b72d                	j	b00 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 bd8:	06400793          	li	a5,100
 bdc:	02f60763          	beq	a2,a5,c0a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 be0:	07500793          	li	a5,117
 be4:	06f60963          	beq	a2,a5,c56 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 be8:	07800793          	li	a5,120
 bec:	faf61ee3          	bne	a2,a5,ba8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 bf0:	008b8913          	addi	s2,s7,8
 bf4:	4681                	li	a3,0
 bf6:	4641                	li	a2,16
 bf8:	000ba583          	lw	a1,0(s7)
 bfc:	855a                	mv	a0,s6
 bfe:	e11ff0ef          	jal	a0e <printint>
        i += 2;
 c02:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 c04:	8bca                	mv	s7,s2
      state = 0;
 c06:	4981                	li	s3,0
        i += 2;
 c08:	bde5                	j	b00 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 c0a:	008b8913          	addi	s2,s7,8
 c0e:	4685                	li	a3,1
 c10:	4629                	li	a2,10
 c12:	000ba583          	lw	a1,0(s7)
 c16:	855a                	mv	a0,s6
 c18:	df7ff0ef          	jal	a0e <printint>
        i += 2;
 c1c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 c1e:	8bca                	mv	s7,s2
      state = 0;
 c20:	4981                	li	s3,0
        i += 2;
 c22:	bdf9                	j	b00 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 c24:	008b8913          	addi	s2,s7,8
 c28:	4681                	li	a3,0
 c2a:	4629                	li	a2,10
 c2c:	000ba583          	lw	a1,0(s7)
 c30:	855a                	mv	a0,s6
 c32:	dddff0ef          	jal	a0e <printint>
 c36:	8bca                	mv	s7,s2
      state = 0;
 c38:	4981                	li	s3,0
 c3a:	b5d9                	j	b00 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 c3c:	008b8913          	addi	s2,s7,8
 c40:	4681                	li	a3,0
 c42:	4629                	li	a2,10
 c44:	000ba583          	lw	a1,0(s7)
 c48:	855a                	mv	a0,s6
 c4a:	dc5ff0ef          	jal	a0e <printint>
        i += 1;
 c4e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 c50:	8bca                	mv	s7,s2
      state = 0;
 c52:	4981                	li	s3,0
        i += 1;
 c54:	b575                	j	b00 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 c56:	008b8913          	addi	s2,s7,8
 c5a:	4681                	li	a3,0
 c5c:	4629                	li	a2,10
 c5e:	000ba583          	lw	a1,0(s7)
 c62:	855a                	mv	a0,s6
 c64:	dabff0ef          	jal	a0e <printint>
        i += 2;
 c68:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 c6a:	8bca                	mv	s7,s2
      state = 0;
 c6c:	4981                	li	s3,0
        i += 2;
 c6e:	bd49                	j	b00 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 c70:	008b8913          	addi	s2,s7,8
 c74:	4681                	li	a3,0
 c76:	4641                	li	a2,16
 c78:	000ba583          	lw	a1,0(s7)
 c7c:	855a                	mv	a0,s6
 c7e:	d91ff0ef          	jal	a0e <printint>
 c82:	8bca                	mv	s7,s2
      state = 0;
 c84:	4981                	li	s3,0
 c86:	bdad                	j	b00 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 c88:	008b8913          	addi	s2,s7,8
 c8c:	4681                	li	a3,0
 c8e:	4641                	li	a2,16
 c90:	000ba583          	lw	a1,0(s7)
 c94:	855a                	mv	a0,s6
 c96:	d79ff0ef          	jal	a0e <printint>
        i += 1;
 c9a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 c9c:	8bca                	mv	s7,s2
      state = 0;
 c9e:	4981                	li	s3,0
        i += 1;
 ca0:	b585                	j	b00 <vprintf+0x4a>
 ca2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 ca4:	008b8d13          	addi	s10,s7,8
 ca8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 cac:	03000593          	li	a1,48
 cb0:	855a                	mv	a0,s6
 cb2:	d3fff0ef          	jal	9f0 <putc>
  putc(fd, 'x');
 cb6:	07800593          	li	a1,120
 cba:	855a                	mv	a0,s6
 cbc:	d35ff0ef          	jal	9f0 <putc>
 cc0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 cc2:	00000b97          	auipc	s7,0x0
 cc6:	66eb8b93          	addi	s7,s7,1646 # 1330 <digits>
 cca:	03c9d793          	srli	a5,s3,0x3c
 cce:	97de                	add	a5,a5,s7
 cd0:	0007c583          	lbu	a1,0(a5)
 cd4:	855a                	mv	a0,s6
 cd6:	d1bff0ef          	jal	9f0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 cda:	0992                	slli	s3,s3,0x4
 cdc:	397d                	addiw	s2,s2,-1
 cde:	fe0916e3          	bnez	s2,cca <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 ce2:	8bea                	mv	s7,s10
      state = 0;
 ce4:	4981                	li	s3,0
 ce6:	6d02                	ld	s10,0(sp)
 ce8:	bd21                	j	b00 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 cea:	008b8993          	addi	s3,s7,8
 cee:	000bb903          	ld	s2,0(s7)
 cf2:	00090f63          	beqz	s2,d10 <vprintf+0x25a>
        for(; *s; s++)
 cf6:	00094583          	lbu	a1,0(s2)
 cfa:	c195                	beqz	a1,d1e <vprintf+0x268>
          putc(fd, *s);
 cfc:	855a                	mv	a0,s6
 cfe:	cf3ff0ef          	jal	9f0 <putc>
        for(; *s; s++)
 d02:	0905                	addi	s2,s2,1
 d04:	00094583          	lbu	a1,0(s2)
 d08:	f9f5                	bnez	a1,cfc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 d0a:	8bce                	mv	s7,s3
      state = 0;
 d0c:	4981                	li	s3,0
 d0e:	bbcd                	j	b00 <vprintf+0x4a>
          s = "(null)";
 d10:	00000917          	auipc	s2,0x0
 d14:	61890913          	addi	s2,s2,1560 # 1328 <thread_join+0x3c4>
        for(; *s; s++)
 d18:	02800593          	li	a1,40
 d1c:	b7c5                	j	cfc <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 d1e:	8bce                	mv	s7,s3
      state = 0;
 d20:	4981                	li	s3,0
 d22:	bbf9                	j	b00 <vprintf+0x4a>
 d24:	64a6                	ld	s1,72(sp)
 d26:	79e2                	ld	s3,56(sp)
 d28:	7a42                	ld	s4,48(sp)
 d2a:	7aa2                	ld	s5,40(sp)
 d2c:	7b02                	ld	s6,32(sp)
 d2e:	6be2                	ld	s7,24(sp)
 d30:	6c42                	ld	s8,16(sp)
 d32:	6ca2                	ld	s9,8(sp)
    }
  }
}
 d34:	60e6                	ld	ra,88(sp)
 d36:	6446                	ld	s0,80(sp)
 d38:	6906                	ld	s2,64(sp)
 d3a:	6125                	addi	sp,sp,96
 d3c:	8082                	ret

0000000000000d3e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 d3e:	715d                	addi	sp,sp,-80
 d40:	ec06                	sd	ra,24(sp)
 d42:	e822                	sd	s0,16(sp)
 d44:	1000                	addi	s0,sp,32
 d46:	e010                	sd	a2,0(s0)
 d48:	e414                	sd	a3,8(s0)
 d4a:	e818                	sd	a4,16(s0)
 d4c:	ec1c                	sd	a5,24(s0)
 d4e:	03043023          	sd	a6,32(s0)
 d52:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 d56:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 d5a:	8622                	mv	a2,s0
 d5c:	d5bff0ef          	jal	ab6 <vprintf>
}
 d60:	60e2                	ld	ra,24(sp)
 d62:	6442                	ld	s0,16(sp)
 d64:	6161                	addi	sp,sp,80
 d66:	8082                	ret

0000000000000d68 <printf>:

void
printf(const char *fmt, ...)
{
 d68:	711d                	addi	sp,sp,-96
 d6a:	ec06                	sd	ra,24(sp)
 d6c:	e822                	sd	s0,16(sp)
 d6e:	1000                	addi	s0,sp,32
 d70:	e40c                	sd	a1,8(s0)
 d72:	e810                	sd	a2,16(s0)
 d74:	ec14                	sd	a3,24(s0)
 d76:	f018                	sd	a4,32(s0)
 d78:	f41c                	sd	a5,40(s0)
 d7a:	03043823          	sd	a6,48(s0)
 d7e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 d82:	00840613          	addi	a2,s0,8
 d86:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 d8a:	85aa                	mv	a1,a0
 d8c:	4505                	li	a0,1
 d8e:	d29ff0ef          	jal	ab6 <vprintf>
}
 d92:	60e2                	ld	ra,24(sp)
 d94:	6442                	ld	s0,16(sp)
 d96:	6125                	addi	sp,sp,96
 d98:	8082                	ret

0000000000000d9a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d9a:	1141                	addi	sp,sp,-16
 d9c:	e422                	sd	s0,8(sp)
 d9e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 da0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 da4:	00001797          	auipc	a5,0x1
 da8:	26c7b783          	ld	a5,620(a5) # 2010 <freep>
 dac:	a02d                	j	dd6 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 dae:	4618                	lw	a4,8(a2)
 db0:	9f2d                	addw	a4,a4,a1
 db2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 db6:	6398                	ld	a4,0(a5)
 db8:	6310                	ld	a2,0(a4)
 dba:	a83d                	j	df8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 dbc:	ff852703          	lw	a4,-8(a0)
 dc0:	9f31                	addw	a4,a4,a2
 dc2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 dc4:	ff053683          	ld	a3,-16(a0)
 dc8:	a091                	j	e0c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 dca:	6398                	ld	a4,0(a5)
 dcc:	00e7e463          	bltu	a5,a4,dd4 <free+0x3a>
 dd0:	00e6ea63          	bltu	a3,a4,de4 <free+0x4a>
{
 dd4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 dd6:	fed7fae3          	bgeu	a5,a3,dca <free+0x30>
 dda:	6398                	ld	a4,0(a5)
 ddc:	00e6e463          	bltu	a3,a4,de4 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 de0:	fee7eae3          	bltu	a5,a4,dd4 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 de4:	ff852583          	lw	a1,-8(a0)
 de8:	6390                	ld	a2,0(a5)
 dea:	02059813          	slli	a6,a1,0x20
 dee:	01c85713          	srli	a4,a6,0x1c
 df2:	9736                	add	a4,a4,a3
 df4:	fae60de3          	beq	a2,a4,dae <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 df8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 dfc:	4790                	lw	a2,8(a5)
 dfe:	02061593          	slli	a1,a2,0x20
 e02:	01c5d713          	srli	a4,a1,0x1c
 e06:	973e                	add	a4,a4,a5
 e08:	fae68ae3          	beq	a3,a4,dbc <free+0x22>
    p->s.ptr = bp->s.ptr;
 e0c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 e0e:	00001717          	auipc	a4,0x1
 e12:	20f73123          	sd	a5,514(a4) # 2010 <freep>
}
 e16:	6422                	ld	s0,8(sp)
 e18:	0141                	addi	sp,sp,16
 e1a:	8082                	ret

0000000000000e1c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 e1c:	7139                	addi	sp,sp,-64
 e1e:	fc06                	sd	ra,56(sp)
 e20:	f822                	sd	s0,48(sp)
 e22:	f426                	sd	s1,40(sp)
 e24:	ec4e                	sd	s3,24(sp)
 e26:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e28:	02051493          	slli	s1,a0,0x20
 e2c:	9081                	srli	s1,s1,0x20
 e2e:	04bd                	addi	s1,s1,15
 e30:	8091                	srli	s1,s1,0x4
 e32:	0014899b          	addiw	s3,s1,1
 e36:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 e38:	00001517          	auipc	a0,0x1
 e3c:	1d853503          	ld	a0,472(a0) # 2010 <freep>
 e40:	c915                	beqz	a0,e74 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e42:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e44:	4798                	lw	a4,8(a5)
 e46:	08977a63          	bgeu	a4,s1,eda <malloc+0xbe>
 e4a:	f04a                	sd	s2,32(sp)
 e4c:	e852                	sd	s4,16(sp)
 e4e:	e456                	sd	s5,8(sp)
 e50:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 e52:	8a4e                	mv	s4,s3
 e54:	0009871b          	sext.w	a4,s3
 e58:	6685                	lui	a3,0x1
 e5a:	00d77363          	bgeu	a4,a3,e60 <malloc+0x44>
 e5e:	6a05                	lui	s4,0x1
 e60:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 e64:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 e68:	00001917          	auipc	s2,0x1
 e6c:	1a890913          	addi	s2,s2,424 # 2010 <freep>
  if(p == (char*)-1)
 e70:	5afd                	li	s5,-1
 e72:	a081                	j	eb2 <malloc+0x96>
 e74:	f04a                	sd	s2,32(sp)
 e76:	e852                	sd	s4,16(sp)
 e78:	e456                	sd	s5,8(sp)
 e7a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 e7c:	00001797          	auipc	a5,0x1
 e80:	1d478793          	addi	a5,a5,468 # 2050 <base>
 e84:	00001717          	auipc	a4,0x1
 e88:	18f73623          	sd	a5,396(a4) # 2010 <freep>
 e8c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 e8e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 e92:	b7c1                	j	e52 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 e94:	6398                	ld	a4,0(a5)
 e96:	e118                	sd	a4,0(a0)
 e98:	a8a9                	j	ef2 <malloc+0xd6>
  hp->s.size = nu;
 e9a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 e9e:	0541                	addi	a0,a0,16
 ea0:	efbff0ef          	jal	d9a <free>
  return freep;
 ea4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ea8:	c12d                	beqz	a0,f0a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 eaa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 eac:	4798                	lw	a4,8(a5)
 eae:	02977263          	bgeu	a4,s1,ed2 <malloc+0xb6>
    if(p == freep)
 eb2:	00093703          	ld	a4,0(s2)
 eb6:	853e                	mv	a0,a5
 eb8:	fef719e3          	bne	a4,a5,eaa <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 ebc:	8552                	mv	a0,s4
 ebe:	b0bff0ef          	jal	9c8 <sbrk>
  if(p == (char*)-1)
 ec2:	fd551ce3          	bne	a0,s5,e9a <malloc+0x7e>
        return 0;
 ec6:	4501                	li	a0,0
 ec8:	7902                	ld	s2,32(sp)
 eca:	6a42                	ld	s4,16(sp)
 ecc:	6aa2                	ld	s5,8(sp)
 ece:	6b02                	ld	s6,0(sp)
 ed0:	a03d                	j	efe <malloc+0xe2>
 ed2:	7902                	ld	s2,32(sp)
 ed4:	6a42                	ld	s4,16(sp)
 ed6:	6aa2                	ld	s5,8(sp)
 ed8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 eda:	fae48de3          	beq	s1,a4,e94 <malloc+0x78>
        p->s.size -= nunits;
 ede:	4137073b          	subw	a4,a4,s3
 ee2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 ee4:	02071693          	slli	a3,a4,0x20
 ee8:	01c6d713          	srli	a4,a3,0x1c
 eec:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 eee:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 ef2:	00001717          	auipc	a4,0x1
 ef6:	10a73f23          	sd	a0,286(a4) # 2010 <freep>
      return (void*)(p + 1);
 efa:	01078513          	addi	a0,a5,16
  }
}
 efe:	70e2                	ld	ra,56(sp)
 f00:	7442                	ld	s0,48(sp)
 f02:	74a2                	ld	s1,40(sp)
 f04:	69e2                	ld	s3,24(sp)
 f06:	6121                	addi	sp,sp,64
 f08:	8082                	ret
 f0a:	7902                	ld	s2,32(sp)
 f0c:	6a42                	ld	s4,16(sp)
 f0e:	6aa2                	ld	s5,8(sp)
 f10:	6b02                	ld	s6,0(sp)
 f12:	b7f5                	j	efe <malloc+0xe2>

0000000000000f14 <thread_create>:
#include "kernel/types.h"
#include "kernel/riscv.h"

int 
thread_create(void (*start_routine)(void*, void*), void *arg1, void* arg2)
{
 f14:	7179                	addi	sp,sp,-48
 f16:	f406                	sd	ra,40(sp)
 f18:	f022                	sd	s0,32(sp)
 f1a:	e84a                	sd	s2,16(sp)
 f1c:	e44e                	sd	s3,8(sp)
 f1e:	e052                	sd	s4,0(sp)
 f20:	1800                	addi	s0,sp,48
 f22:	892a                	mv	s2,a0
 f24:	89ae                	mv	s3,a1
 f26:	8a32                	mv	s4,a2
    int tid;

    void *stack = malloc(2 * PGSIZE);
 f28:	6509                	lui	a0,0x2
 f2a:	ef3ff0ef          	jal	e1c <malloc>
    if (stack == 0) return -1;
 f2e:	c90d                	beqz	a0,f60 <thread_create+0x4c>
 f30:	ec26                	sd	s1,24(sp)
 f32:	84aa                	mv	s1,a0
    
    if ((tid = clone(start_routine, arg1, arg2, stack)) < 0) {
 f34:	86aa                	mv	a3,a0
 f36:	8652                	mv	a2,s4
 f38:	85ce                	mv	a1,s3
 f3a:	854a                	mv	a0,s2
 f3c:	aa5ff0ef          	jal	9e0 <clone>
 f40:	00054a63          	bltz	a0,f54 <thread_create+0x40>
 f44:	64e2                	ld	s1,24(sp)
        free(stack);
        return -1;
    }
    
    return tid;
}
 f46:	70a2                	ld	ra,40(sp)
 f48:	7402                	ld	s0,32(sp)
 f4a:	6942                	ld	s2,16(sp)
 f4c:	69a2                	ld	s3,8(sp)
 f4e:	6a02                	ld	s4,0(sp)
 f50:	6145                	addi	sp,sp,48
 f52:	8082                	ret
        free(stack);
 f54:	8526                	mv	a0,s1
 f56:	e45ff0ef          	jal	d9a <free>
        return -1;
 f5a:	557d                	li	a0,-1
 f5c:	64e2                	ld	s1,24(sp)
 f5e:	b7e5                	j	f46 <thread_create+0x32>
    if (stack == 0) return -1;
 f60:	557d                	li	a0,-1
 f62:	b7d5                	j	f46 <thread_create+0x32>

0000000000000f64 <thread_join>:

int 
thread_join()
{   
 f64:	7179                	addi	sp,sp,-48
 f66:	f406                	sd	ra,40(sp)
 f68:	f022                	sd	s0,32(sp)
 f6a:	ec26                	sd	s1,24(sp)
 f6c:	1800                	addi	s0,sp,48
    int tid;
    void *stack;
    
    if ((tid = join(&stack)) < 0) {
 f6e:	fd840513          	addi	a0,s0,-40
 f72:	a77ff0ef          	jal	9e8 <join>
 f76:	00054d63          	bltz	a0,f90 <thread_join+0x2c>
 f7a:	84aa                	mv	s1,a0
        return -1;
    }

    free(stack);
 f7c:	fd843503          	ld	a0,-40(s0)
 f80:	e1bff0ef          	jal	d9a <free>
    return tid;
}
 f84:	8526                	mv	a0,s1
 f86:	70a2                	ld	ra,40(sp)
 f88:	7402                	ld	s0,32(sp)
 f8a:	64e2                	ld	s1,24(sp)
 f8c:	6145                	addi	sp,sp,48
 f8e:	8082                	ret
        return -1;
 f90:	54fd                	li	s1,-1
 f92:	bfcd                	j	f84 <thread_join+0x20>
