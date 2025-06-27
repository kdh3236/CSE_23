
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:
// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.
void
simpletest()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;

  printf("simple: ");
   e:	00001517          	auipc	a0,0x1
  12:	be250513          	addi	a0,a0,-1054 # bf0 <malloc+0xfa>
  16:	22d000ef          	jal	a42 <printf>
  
  char *p = sbrk(sz);
  1a:	05555537          	lui	a0,0x5555
  1e:	55450513          	addi	a0,a0,1364 # 5555554 <base+0x554f544>
  22:	688000ef          	jal	6aa <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  26:	57fd                	li	a5,-1
  28:	04f50b63          	beq	a0,a5,7e <simpletest+0x7e>
  2c:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  for(char *q = p; q < p + sz; q += 4096){
  2e:	05556937          	lui	s2,0x5556
  32:	992a                	add	s2,s2,a0
  34:	6985                	lui	s3,0x1
    *(int*)q = getpid();
  36:	66c000ef          	jal	6a2 <getpid>
  3a:	c088                	sw	a0,0(s1)
  for(char *q = p; q < p + sz; q += 4096){
  3c:	94ce                	add	s1,s1,s3
  3e:	ff249ce3          	bne	s1,s2,36 <simpletest+0x36>
  }

  int pid = fork();
  42:	5d8000ef          	jal	61a <fork>
  if(pid < 0){
  46:	04054963          	bltz	a0,98 <simpletest+0x98>
    printf("fork() failed\n");
    exit(-1);
  }

  if(pid == 0)
  4a:	c125                	beqz	a0,aa <simpletest+0xaa>
    exit(0);

  wait(0);
  4c:	4501                	li	a0,0
  4e:	5dc000ef          	jal	62a <wait>

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
  52:	faaab537          	lui	a0,0xfaaab
  56:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <base+0xfffffffffaaa4a9c>
  5a:	650000ef          	jal	6aa <sbrk>
  5e:	57fd                	li	a5,-1
  60:	04f50763          	beq	a0,a5,ae <simpletest+0xae>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
  64:	00001517          	auipc	a0,0x1
  68:	bdc50513          	addi	a0,a0,-1060 # c40 <malloc+0x14a>
  6c:	1d7000ef          	jal	a42 <printf>
}
  70:	70a2                	ld	ra,40(sp)
  72:	7402                	ld	s0,32(sp)
  74:	64e2                	ld	s1,24(sp)
  76:	6942                	ld	s2,16(sp)
  78:	69a2                	ld	s3,8(sp)
  7a:	6145                	addi	sp,sp,48
  7c:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  7e:	055555b7          	lui	a1,0x5555
  82:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x554f544>
  86:	00001517          	auipc	a0,0x1
  8a:	b7a50513          	addi	a0,a0,-1158 # c00 <malloc+0x10a>
  8e:	1b5000ef          	jal	a42 <printf>
    exit(-1);
  92:	557d                	li	a0,-1
  94:	58e000ef          	jal	622 <exit>
    printf("fork() failed\n");
  98:	00001517          	auipc	a0,0x1
  9c:	b8050513          	addi	a0,a0,-1152 # c18 <malloc+0x122>
  a0:	1a3000ef          	jal	a42 <printf>
    exit(-1);
  a4:	557d                	li	a0,-1
  a6:	57c000ef          	jal	622 <exit>
    exit(0);
  aa:	578000ef          	jal	622 <exit>
    printf("sbrk(-%d) failed\n", sz);
  ae:	055555b7          	lui	a1,0x5555
  b2:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x554f544>
  b6:	00001517          	auipc	a0,0x1
  ba:	b7250513          	addi	a0,a0,-1166 # c28 <malloc+0x132>
  be:	185000ef          	jal	a42 <printf>
    exit(-1);
  c2:	557d                	li	a0,-1
  c4:	55e000ef          	jal	622 <exit>

00000000000000c8 <threetest>:
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
  c8:	7179                	addi	sp,sp,-48
  ca:	f406                	sd	ra,40(sp)
  cc:	f022                	sd	s0,32(sp)
  ce:	ec26                	sd	s1,24(sp)
  d0:	e84a                	sd	s2,16(sp)
  d2:	e44e                	sd	s3,8(sp)
  d4:	e052                	sd	s4,0(sp)
  d6:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
  d8:	00001517          	auipc	a0,0x1
  dc:	b7050513          	addi	a0,a0,-1168 # c48 <malloc+0x152>
  e0:	163000ef          	jal	a42 <printf>
  
  char *p = sbrk(sz);
  e4:	02000537          	lui	a0,0x2000
  e8:	5c2000ef          	jal	6aa <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  ec:	57fd                	li	a5,-1
  ee:	06f50963          	beq	a0,a5,160 <threetest+0x98>
  f2:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
  f4:	526000ef          	jal	61a <fork>
  if(pid1 < 0){
  f8:	06054f63          	bltz	a0,176 <threetest+0xae>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid1 == 0){
  fc:	c551                	beqz	a0,188 <threetest+0xc0>
      *(int*)q = 9999;
    }
    exit(0);
  }

  for(char *q = p; q < p + sz; q += 4096){
  fe:	020009b7          	lui	s3,0x2000
 102:	99a6                	add	s3,s3,s1
 104:	8926                	mv	s2,s1
 106:	6a05                	lui	s4,0x1
    *(int*)q = getpid();
 108:	59a000ef          	jal	6a2 <getpid>
 10c:	00a92023          	sw	a0,0(s2) # 5556000 <base+0x554fff0>
  for(char *q = p; q < p + sz; q += 4096){
 110:	9952                	add	s2,s2,s4
 112:	ff391be3          	bne	s2,s3,108 <threetest+0x40>
  }

  wait(0);
 116:	4501                	li	a0,0
 118:	512000ef          	jal	62a <wait>

  sleep(1);
 11c:	4505                	li	a0,1
 11e:	594000ef          	jal	6b2 <sleep>

  for(char *q = p; q < p + sz; q += 4096){
 122:	6a05                	lui	s4,0x1
    if(*(int*)q != getpid()){
 124:	0004a903          	lw	s2,0(s1)
 128:	57a000ef          	jal	6a2 <getpid>
 12c:	0ca91c63          	bne	s2,a0,204 <threetest+0x13c>
  for(char *q = p; q < p + sz; q += 4096){
 130:	94d2                	add	s1,s1,s4
 132:	ff3499e3          	bne	s1,s3,124 <threetest+0x5c>
      printf("wrong content\n");
      exit(-1);
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
 136:	fe000537          	lui	a0,0xfe000
 13a:	570000ef          	jal	6aa <sbrk>
 13e:	57fd                	li	a5,-1
 140:	0cf50b63          	beq	a0,a5,216 <threetest+0x14e>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
 144:	00001517          	auipc	a0,0x1
 148:	afc50513          	addi	a0,a0,-1284 # c40 <malloc+0x14a>
 14c:	0f7000ef          	jal	a42 <printf>
}
 150:	70a2                	ld	ra,40(sp)
 152:	7402                	ld	s0,32(sp)
 154:	64e2                	ld	s1,24(sp)
 156:	6942                	ld	s2,16(sp)
 158:	69a2                	ld	s3,8(sp)
 15a:	6a02                	ld	s4,0(sp)
 15c:	6145                	addi	sp,sp,48
 15e:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 160:	020005b7          	lui	a1,0x2000
 164:	00001517          	auipc	a0,0x1
 168:	a9c50513          	addi	a0,a0,-1380 # c00 <malloc+0x10a>
 16c:	0d7000ef          	jal	a42 <printf>
    exit(-1);
 170:	557d                	li	a0,-1
 172:	4b0000ef          	jal	622 <exit>
    printf("fork failed\n");
 176:	00001517          	auipc	a0,0x1
 17a:	ada50513          	addi	a0,a0,-1318 # c50 <malloc+0x15a>
 17e:	0c5000ef          	jal	a42 <printf>
    exit(-1);
 182:	557d                	li	a0,-1
 184:	49e000ef          	jal	622 <exit>
    pid2 = fork();
 188:	492000ef          	jal	61a <fork>
    if(pid2 < 0){
 18c:	02054c63          	bltz	a0,1c4 <threetest+0xfc>
    if(pid2 == 0){
 190:	e139                	bnez	a0,1d6 <threetest+0x10e>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 192:	0199a9b7          	lui	s3,0x199a
 196:	99a6                	add	s3,s3,s1
 198:	8926                	mv	s2,s1
 19a:	6a05                	lui	s4,0x1
        *(int*)q = getpid();
 19c:	506000ef          	jal	6a2 <getpid>
 1a0:	00a92023          	sw	a0,0(s2)
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 1a4:	9952                	add	s2,s2,s4
 1a6:	ff391be3          	bne	s2,s3,19c <threetest+0xd4>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 1aa:	6a05                	lui	s4,0x1
        if(*(int*)q != getpid()){
 1ac:	0004a903          	lw	s2,0(s1)
 1b0:	4f2000ef          	jal	6a2 <getpid>
 1b4:	02a91f63          	bne	s2,a0,1f2 <threetest+0x12a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 1b8:	94d2                	add	s1,s1,s4
 1ba:	ff3499e3          	bne	s1,s3,1ac <threetest+0xe4>
      exit(-1);
 1be:	557d                	li	a0,-1
 1c0:	462000ef          	jal	622 <exit>
      printf("fork failed");
 1c4:	00001517          	auipc	a0,0x1
 1c8:	a9c50513          	addi	a0,a0,-1380 # c60 <malloc+0x16a>
 1cc:	077000ef          	jal	a42 <printf>
      exit(-1);
 1d0:	557d                	li	a0,-1
 1d2:	450000ef          	jal	622 <exit>
    for(char *q = p; q < p + (sz/2); q += 4096){
 1d6:	01000737          	lui	a4,0x1000
 1da:	9726                	add	a4,a4,s1
      *(int*)q = 9999;
 1dc:	6789                	lui	a5,0x2
 1de:	70f78793          	addi	a5,a5,1807 # 270f <junk3+0x6ff>
    for(char *q = p; q < p + (sz/2); q += 4096){
 1e2:	6685                	lui	a3,0x1
      *(int*)q = 9999;
 1e4:	c09c                	sw	a5,0(s1)
    for(char *q = p; q < p + (sz/2); q += 4096){
 1e6:	94b6                	add	s1,s1,a3
 1e8:	fee49ee3          	bne	s1,a4,1e4 <threetest+0x11c>
    exit(0);
 1ec:	4501                	li	a0,0
 1ee:	434000ef          	jal	622 <exit>
          printf("wrong content\n");
 1f2:	00001517          	auipc	a0,0x1
 1f6:	a7e50513          	addi	a0,a0,-1410 # c70 <malloc+0x17a>
 1fa:	049000ef          	jal	a42 <printf>
          exit(-1);
 1fe:	557d                	li	a0,-1
 200:	422000ef          	jal	622 <exit>
      printf("wrong content\n");
 204:	00001517          	auipc	a0,0x1
 208:	a6c50513          	addi	a0,a0,-1428 # c70 <malloc+0x17a>
 20c:	037000ef          	jal	a42 <printf>
      exit(-1);
 210:	557d                	li	a0,-1
 212:	410000ef          	jal	622 <exit>
    printf("sbrk(-%d) failed\n", sz);
 216:	020005b7          	lui	a1,0x2000
 21a:	00001517          	auipc	a0,0x1
 21e:	a0e50513          	addi	a0,a0,-1522 # c28 <malloc+0x132>
 222:	021000ef          	jal	a42 <printf>
    exit(-1);
 226:	557d                	li	a0,-1
 228:	3fa000ef          	jal	622 <exit>

000000000000022c <filetest>:
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
 22c:	7179                	addi	sp,sp,-48
 22e:	f406                	sd	ra,40(sp)
 230:	f022                	sd	s0,32(sp)
 232:	ec26                	sd	s1,24(sp)
 234:	e84a                	sd	s2,16(sp)
 236:	1800                	addi	s0,sp,48
  printf("file: ");
 238:	00001517          	auipc	a0,0x1
 23c:	a4850513          	addi	a0,a0,-1464 # c80 <malloc+0x18a>
 240:	003000ef          	jal	a42 <printf>
  
  buf[0] = 99;
 244:	06300793          	li	a5,99
 248:	00003717          	auipc	a4,0x3
 24c:	dcf70423          	sb	a5,-568(a4) # 3010 <buf>

  for(int i = 0; i < 4; i++){
 250:	fc042c23          	sw	zero,-40(s0)
    if(pipe(fds) != 0){
 254:	00002497          	auipc	s1,0x2
 258:	dac48493          	addi	s1,s1,-596 # 2000 <fds>
  for(int i = 0; i < 4; i++){
 25c:	490d                	li	s2,3
    if(pipe(fds) != 0){
 25e:	8526                	mv	a0,s1
 260:	3d2000ef          	jal	632 <pipe>
 264:	e92d                	bnez	a0,2d6 <filetest+0xaa>
      printf("pipe() failed\n");
      exit(-1);
    }
    int pid = fork();
 266:	3b4000ef          	jal	61a <fork>
    if(pid < 0){
 26a:	06054f63          	bltz	a0,2e8 <filetest+0xbc>
      printf("fork failed\n");
      exit(-1);
    }
    if(pid == 0){
 26e:	c551                	beqz	a0,2fa <filetest+0xce>
        printf("error: read the wrong value\n");
        exit(1);
      }
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 270:	4611                	li	a2,4
 272:	fd840593          	addi	a1,s0,-40
 276:	40c8                	lw	a0,4(s1)
 278:	3ca000ef          	jal	642 <write>
 27c:	4791                	li	a5,4
 27e:	0cf51f63          	bne	a0,a5,35c <filetest+0x130>
  for(int i = 0; i < 4; i++){
 282:	fd842783          	lw	a5,-40(s0)
 286:	2785                	addiw	a5,a5,1
 288:	0007871b          	sext.w	a4,a5
 28c:	fcf42c23          	sw	a5,-40(s0)
 290:	fce957e3          	bge	s2,a4,25e <filetest+0x32>
      printf("error: write failed\n");
      exit(-1);
    }
  }

  int xstatus = 0;
 294:	fc042e23          	sw	zero,-36(s0)
 298:	4491                	li	s1,4
  for(int i = 0; i < 4; i++) {
    wait(&xstatus);
 29a:	fdc40513          	addi	a0,s0,-36
 29e:	38c000ef          	jal	62a <wait>
    if(xstatus != 0) {
 2a2:	fdc42783          	lw	a5,-36(s0)
 2a6:	0c079463          	bnez	a5,36e <filetest+0x142>
  for(int i = 0; i < 4; i++) {
 2aa:	34fd                	addiw	s1,s1,-1
 2ac:	f4fd                	bnez	s1,29a <filetest+0x6e>
      exit(1);
    }
  }

  if(buf[0] != 99){
 2ae:	00003717          	auipc	a4,0x3
 2b2:	d6274703          	lbu	a4,-670(a4) # 3010 <buf>
 2b6:	06300793          	li	a5,99
 2ba:	0af71d63          	bne	a4,a5,374 <filetest+0x148>
    printf("error: child overwrote parent\n");
    exit(1);
  }

  printf("ok\n");
 2be:	00001517          	auipc	a0,0x1
 2c2:	98250513          	addi	a0,a0,-1662 # c40 <malloc+0x14a>
 2c6:	77c000ef          	jal	a42 <printf>
}
 2ca:	70a2                	ld	ra,40(sp)
 2cc:	7402                	ld	s0,32(sp)
 2ce:	64e2                	ld	s1,24(sp)
 2d0:	6942                	ld	s2,16(sp)
 2d2:	6145                	addi	sp,sp,48
 2d4:	8082                	ret
      printf("pipe() failed\n");
 2d6:	00001517          	auipc	a0,0x1
 2da:	9b250513          	addi	a0,a0,-1614 # c88 <malloc+0x192>
 2de:	764000ef          	jal	a42 <printf>
      exit(-1);
 2e2:	557d                	li	a0,-1
 2e4:	33e000ef          	jal	622 <exit>
      printf("fork failed\n");
 2e8:	00001517          	auipc	a0,0x1
 2ec:	96850513          	addi	a0,a0,-1688 # c50 <malloc+0x15a>
 2f0:	752000ef          	jal	a42 <printf>
      exit(-1);
 2f4:	557d                	li	a0,-1
 2f6:	32c000ef          	jal	622 <exit>
      sleep(1);
 2fa:	4505                	li	a0,1
 2fc:	3b6000ef          	jal	6b2 <sleep>
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
 300:	4611                	li	a2,4
 302:	00003597          	auipc	a1,0x3
 306:	d0e58593          	addi	a1,a1,-754 # 3010 <buf>
 30a:	00002517          	auipc	a0,0x2
 30e:	cf652503          	lw	a0,-778(a0) # 2000 <fds>
 312:	328000ef          	jal	63a <read>
 316:	4791                	li	a5,4
 318:	02f51663          	bne	a0,a5,344 <filetest+0x118>
      sleep(1);
 31c:	4505                	li	a0,1
 31e:	394000ef          	jal	6b2 <sleep>
      if(j != i){
 322:	fd842703          	lw	a4,-40(s0)
 326:	00003797          	auipc	a5,0x3
 32a:	cea7a783          	lw	a5,-790(a5) # 3010 <buf>
 32e:	02f70463          	beq	a4,a5,356 <filetest+0x12a>
        printf("error: read the wrong value\n");
 332:	00001517          	auipc	a0,0x1
 336:	97e50513          	addi	a0,a0,-1666 # cb0 <malloc+0x1ba>
 33a:	708000ef          	jal	a42 <printf>
        exit(1);
 33e:	4505                	li	a0,1
 340:	2e2000ef          	jal	622 <exit>
        printf("error: read failed\n");
 344:	00001517          	auipc	a0,0x1
 348:	95450513          	addi	a0,a0,-1708 # c98 <malloc+0x1a2>
 34c:	6f6000ef          	jal	a42 <printf>
        exit(1);
 350:	4505                	li	a0,1
 352:	2d0000ef          	jal	622 <exit>
      exit(0);
 356:	4501                	li	a0,0
 358:	2ca000ef          	jal	622 <exit>
      printf("error: write failed\n");
 35c:	00001517          	auipc	a0,0x1
 360:	97450513          	addi	a0,a0,-1676 # cd0 <malloc+0x1da>
 364:	6de000ef          	jal	a42 <printf>
      exit(-1);
 368:	557d                	li	a0,-1
 36a:	2b8000ef          	jal	622 <exit>
      exit(1);
 36e:	4505                	li	a0,1
 370:	2b2000ef          	jal	622 <exit>
    printf("error: child overwrote parent\n");
 374:	00001517          	auipc	a0,0x1
 378:	97450513          	addi	a0,a0,-1676 # ce8 <malloc+0x1f2>
 37c:	6c6000ef          	jal	a42 <printf>
    exit(1);
 380:	4505                	li	a0,1
 382:	2a0000ef          	jal	622 <exit>

0000000000000386 <main>:

int
main(int argc, char *argv[])
{
 386:	1141                	addi	sp,sp,-16
 388:	e406                	sd	ra,8(sp)
 38a:	e022                	sd	s0,0(sp)
 38c:	0800                	addi	s0,sp,16
  simpletest();
 38e:	c73ff0ef          	jal	0 <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 392:	c6fff0ef          	jal	0 <simpletest>

  threetest();
 396:	d33ff0ef          	jal	c8 <threetest>
  threetest();
 39a:	d2fff0ef          	jal	c8 <threetest>
  threetest();
 39e:	d2bff0ef          	jal	c8 <threetest>

  filetest();
 3a2:	e8bff0ef          	jal	22c <filetest>

  printf("ALL COW TESTS PASSED\n");
 3a6:	00001517          	auipc	a0,0x1
 3aa:	96250513          	addi	a0,a0,-1694 # d08 <malloc+0x212>
 3ae:	694000ef          	jal	a42 <printf>

  exit(0);
 3b2:	4501                	li	a0,0
 3b4:	26e000ef          	jal	622 <exit>

00000000000003b8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e406                	sd	ra,8(sp)
 3bc:	e022                	sd	s0,0(sp)
 3be:	0800                	addi	s0,sp,16
  extern int main();
  main();
 3c0:	fc7ff0ef          	jal	386 <main>
  exit(0);
 3c4:	4501                	li	a0,0
 3c6:	25c000ef          	jal	622 <exit>

00000000000003ca <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 3ca:	1141                	addi	sp,sp,-16
 3cc:	e422                	sd	s0,8(sp)
 3ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 3d0:	87aa                	mv	a5,a0
 3d2:	0585                	addi	a1,a1,1
 3d4:	0785                	addi	a5,a5,1
 3d6:	fff5c703          	lbu	a4,-1(a1)
 3da:	fee78fa3          	sb	a4,-1(a5)
 3de:	fb75                	bnez	a4,3d2 <strcpy+0x8>
    ;
  return os;
}
 3e0:	6422                	ld	s0,8(sp)
 3e2:	0141                	addi	sp,sp,16
 3e4:	8082                	ret

00000000000003e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3e6:	1141                	addi	sp,sp,-16
 3e8:	e422                	sd	s0,8(sp)
 3ea:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 3ec:	00054783          	lbu	a5,0(a0)
 3f0:	cb91                	beqz	a5,404 <strcmp+0x1e>
 3f2:	0005c703          	lbu	a4,0(a1)
 3f6:	00f71763          	bne	a4,a5,404 <strcmp+0x1e>
    p++, q++;
 3fa:	0505                	addi	a0,a0,1
 3fc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 3fe:	00054783          	lbu	a5,0(a0)
 402:	fbe5                	bnez	a5,3f2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 404:	0005c503          	lbu	a0,0(a1)
}
 408:	40a7853b          	subw	a0,a5,a0
 40c:	6422                	ld	s0,8(sp)
 40e:	0141                	addi	sp,sp,16
 410:	8082                	ret

0000000000000412 <strlen>:

uint
strlen(const char *s)
{
 412:	1141                	addi	sp,sp,-16
 414:	e422                	sd	s0,8(sp)
 416:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 418:	00054783          	lbu	a5,0(a0)
 41c:	cf91                	beqz	a5,438 <strlen+0x26>
 41e:	0505                	addi	a0,a0,1
 420:	87aa                	mv	a5,a0
 422:	86be                	mv	a3,a5
 424:	0785                	addi	a5,a5,1
 426:	fff7c703          	lbu	a4,-1(a5)
 42a:	ff65                	bnez	a4,422 <strlen+0x10>
 42c:	40a6853b          	subw	a0,a3,a0
 430:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 432:	6422                	ld	s0,8(sp)
 434:	0141                	addi	sp,sp,16
 436:	8082                	ret
  for(n = 0; s[n]; n++)
 438:	4501                	li	a0,0
 43a:	bfe5                	j	432 <strlen+0x20>

000000000000043c <memset>:

void*
memset(void *dst, int c, uint n)
{
 43c:	1141                	addi	sp,sp,-16
 43e:	e422                	sd	s0,8(sp)
 440:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 442:	ca19                	beqz	a2,458 <memset+0x1c>
 444:	87aa                	mv	a5,a0
 446:	1602                	slli	a2,a2,0x20
 448:	9201                	srli	a2,a2,0x20
 44a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 44e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 452:	0785                	addi	a5,a5,1
 454:	fee79de3          	bne	a5,a4,44e <memset+0x12>
  }
  return dst;
}
 458:	6422                	ld	s0,8(sp)
 45a:	0141                	addi	sp,sp,16
 45c:	8082                	ret

000000000000045e <strchr>:

char*
strchr(const char *s, char c)
{
 45e:	1141                	addi	sp,sp,-16
 460:	e422                	sd	s0,8(sp)
 462:	0800                	addi	s0,sp,16
  for(; *s; s++)
 464:	00054783          	lbu	a5,0(a0)
 468:	cb99                	beqz	a5,47e <strchr+0x20>
    if(*s == c)
 46a:	00f58763          	beq	a1,a5,478 <strchr+0x1a>
  for(; *s; s++)
 46e:	0505                	addi	a0,a0,1
 470:	00054783          	lbu	a5,0(a0)
 474:	fbfd                	bnez	a5,46a <strchr+0xc>
      return (char*)s;
  return 0;
 476:	4501                	li	a0,0
}
 478:	6422                	ld	s0,8(sp)
 47a:	0141                	addi	sp,sp,16
 47c:	8082                	ret
  return 0;
 47e:	4501                	li	a0,0
 480:	bfe5                	j	478 <strchr+0x1a>

0000000000000482 <gets>:

char*
gets(char *buf, int max)
{
 482:	711d                	addi	sp,sp,-96
 484:	ec86                	sd	ra,88(sp)
 486:	e8a2                	sd	s0,80(sp)
 488:	e4a6                	sd	s1,72(sp)
 48a:	e0ca                	sd	s2,64(sp)
 48c:	fc4e                	sd	s3,56(sp)
 48e:	f852                	sd	s4,48(sp)
 490:	f456                	sd	s5,40(sp)
 492:	f05a                	sd	s6,32(sp)
 494:	ec5e                	sd	s7,24(sp)
 496:	1080                	addi	s0,sp,96
 498:	8baa                	mv	s7,a0
 49a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 49c:	892a                	mv	s2,a0
 49e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 4a0:	4aa9                	li	s5,10
 4a2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 4a4:	89a6                	mv	s3,s1
 4a6:	2485                	addiw	s1,s1,1
 4a8:	0344d663          	bge	s1,s4,4d4 <gets+0x52>
    cc = read(0, &c, 1);
 4ac:	4605                	li	a2,1
 4ae:	faf40593          	addi	a1,s0,-81
 4b2:	4501                	li	a0,0
 4b4:	186000ef          	jal	63a <read>
    if(cc < 1)
 4b8:	00a05e63          	blez	a0,4d4 <gets+0x52>
    buf[i++] = c;
 4bc:	faf44783          	lbu	a5,-81(s0)
 4c0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 4c4:	01578763          	beq	a5,s5,4d2 <gets+0x50>
 4c8:	0905                	addi	s2,s2,1
 4ca:	fd679de3          	bne	a5,s6,4a4 <gets+0x22>
    buf[i++] = c;
 4ce:	89a6                	mv	s3,s1
 4d0:	a011                	j	4d4 <gets+0x52>
 4d2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 4d4:	99de                	add	s3,s3,s7
 4d6:	00098023          	sb	zero,0(s3) # 199a000 <base+0x1993ff0>
  return buf;
}
 4da:	855e                	mv	a0,s7
 4dc:	60e6                	ld	ra,88(sp)
 4de:	6446                	ld	s0,80(sp)
 4e0:	64a6                	ld	s1,72(sp)
 4e2:	6906                	ld	s2,64(sp)
 4e4:	79e2                	ld	s3,56(sp)
 4e6:	7a42                	ld	s4,48(sp)
 4e8:	7aa2                	ld	s5,40(sp)
 4ea:	7b02                	ld	s6,32(sp)
 4ec:	6be2                	ld	s7,24(sp)
 4ee:	6125                	addi	sp,sp,96
 4f0:	8082                	ret

00000000000004f2 <stat>:

int
stat(const char *n, struct stat *st)
{
 4f2:	1101                	addi	sp,sp,-32
 4f4:	ec06                	sd	ra,24(sp)
 4f6:	e822                	sd	s0,16(sp)
 4f8:	e04a                	sd	s2,0(sp)
 4fa:	1000                	addi	s0,sp,32
 4fc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4fe:	4581                	li	a1,0
 500:	162000ef          	jal	662 <open>
  if(fd < 0)
 504:	02054263          	bltz	a0,528 <stat+0x36>
 508:	e426                	sd	s1,8(sp)
 50a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 50c:	85ca                	mv	a1,s2
 50e:	16c000ef          	jal	67a <fstat>
 512:	892a                	mv	s2,a0
  close(fd);
 514:	8526                	mv	a0,s1
 516:	134000ef          	jal	64a <close>
  return r;
 51a:	64a2                	ld	s1,8(sp)
}
 51c:	854a                	mv	a0,s2
 51e:	60e2                	ld	ra,24(sp)
 520:	6442                	ld	s0,16(sp)
 522:	6902                	ld	s2,0(sp)
 524:	6105                	addi	sp,sp,32
 526:	8082                	ret
    return -1;
 528:	597d                	li	s2,-1
 52a:	bfcd                	j	51c <stat+0x2a>

000000000000052c <atoi>:

int
atoi(const char *s)
{
 52c:	1141                	addi	sp,sp,-16
 52e:	e422                	sd	s0,8(sp)
 530:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 532:	00054683          	lbu	a3,0(a0)
 536:	fd06879b          	addiw	a5,a3,-48 # fd0 <digits+0x2a8>
 53a:	0ff7f793          	zext.b	a5,a5
 53e:	4625                	li	a2,9
 540:	02f66863          	bltu	a2,a5,570 <atoi+0x44>
 544:	872a                	mv	a4,a0
  n = 0;
 546:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 548:	0705                	addi	a4,a4,1
 54a:	0025179b          	slliw	a5,a0,0x2
 54e:	9fa9                	addw	a5,a5,a0
 550:	0017979b          	slliw	a5,a5,0x1
 554:	9fb5                	addw	a5,a5,a3
 556:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 55a:	00074683          	lbu	a3,0(a4)
 55e:	fd06879b          	addiw	a5,a3,-48
 562:	0ff7f793          	zext.b	a5,a5
 566:	fef671e3          	bgeu	a2,a5,548 <atoi+0x1c>
  return n;
}
 56a:	6422                	ld	s0,8(sp)
 56c:	0141                	addi	sp,sp,16
 56e:	8082                	ret
  n = 0;
 570:	4501                	li	a0,0
 572:	bfe5                	j	56a <atoi+0x3e>

0000000000000574 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 574:	1141                	addi	sp,sp,-16
 576:	e422                	sd	s0,8(sp)
 578:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 57a:	02b57463          	bgeu	a0,a1,5a2 <memmove+0x2e>
    while(n-- > 0)
 57e:	00c05f63          	blez	a2,59c <memmove+0x28>
 582:	1602                	slli	a2,a2,0x20
 584:	9201                	srli	a2,a2,0x20
 586:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 58a:	872a                	mv	a4,a0
      *dst++ = *src++;
 58c:	0585                	addi	a1,a1,1
 58e:	0705                	addi	a4,a4,1
 590:	fff5c683          	lbu	a3,-1(a1)
 594:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 598:	fef71ae3          	bne	a4,a5,58c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 59c:	6422                	ld	s0,8(sp)
 59e:	0141                	addi	sp,sp,16
 5a0:	8082                	ret
    dst += n;
 5a2:	00c50733          	add	a4,a0,a2
    src += n;
 5a6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 5a8:	fec05ae3          	blez	a2,59c <memmove+0x28>
 5ac:	fff6079b          	addiw	a5,a2,-1
 5b0:	1782                	slli	a5,a5,0x20
 5b2:	9381                	srli	a5,a5,0x20
 5b4:	fff7c793          	not	a5,a5
 5b8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 5ba:	15fd                	addi	a1,a1,-1
 5bc:	177d                	addi	a4,a4,-1
 5be:	0005c683          	lbu	a3,0(a1)
 5c2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 5c6:	fee79ae3          	bne	a5,a4,5ba <memmove+0x46>
 5ca:	bfc9                	j	59c <memmove+0x28>

00000000000005cc <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 5cc:	1141                	addi	sp,sp,-16
 5ce:	e422                	sd	s0,8(sp)
 5d0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 5d2:	ca05                	beqz	a2,602 <memcmp+0x36>
 5d4:	fff6069b          	addiw	a3,a2,-1
 5d8:	1682                	slli	a3,a3,0x20
 5da:	9281                	srli	a3,a3,0x20
 5dc:	0685                	addi	a3,a3,1
 5de:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5e0:	00054783          	lbu	a5,0(a0)
 5e4:	0005c703          	lbu	a4,0(a1)
 5e8:	00e79863          	bne	a5,a4,5f8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5ec:	0505                	addi	a0,a0,1
    p2++;
 5ee:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 5f0:	fed518e3          	bne	a0,a3,5e0 <memcmp+0x14>
  }
  return 0;
 5f4:	4501                	li	a0,0
 5f6:	a019                	j	5fc <memcmp+0x30>
      return *p1 - *p2;
 5f8:	40e7853b          	subw	a0,a5,a4
}
 5fc:	6422                	ld	s0,8(sp)
 5fe:	0141                	addi	sp,sp,16
 600:	8082                	ret
  return 0;
 602:	4501                	li	a0,0
 604:	bfe5                	j	5fc <memcmp+0x30>

0000000000000606 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 606:	1141                	addi	sp,sp,-16
 608:	e406                	sd	ra,8(sp)
 60a:	e022                	sd	s0,0(sp)
 60c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 60e:	f67ff0ef          	jal	574 <memmove>
}
 612:	60a2                	ld	ra,8(sp)
 614:	6402                	ld	s0,0(sp)
 616:	0141                	addi	sp,sp,16
 618:	8082                	ret

000000000000061a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 61a:	4885                	li	a7,1
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <exit>:
.global exit
exit:
 li a7, SYS_exit
 622:	4889                	li	a7,2
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <wait>:
.global wait
wait:
 li a7, SYS_wait
 62a:	488d                	li	a7,3
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 632:	4891                	li	a7,4
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <read>:
.global read
read:
 li a7, SYS_read
 63a:	4895                	li	a7,5
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <write>:
.global write
write:
 li a7, SYS_write
 642:	48c1                	li	a7,16
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <close>:
.global close
close:
 li a7, SYS_close
 64a:	48d5                	li	a7,21
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <kill>:
.global kill
kill:
 li a7, SYS_kill
 652:	4899                	li	a7,6
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <exec>:
.global exec
exec:
 li a7, SYS_exec
 65a:	489d                	li	a7,7
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <open>:
.global open
open:
 li a7, SYS_open
 662:	48bd                	li	a7,15
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 66a:	48c5                	li	a7,17
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 672:	48c9                	li	a7,18
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 67a:	48a1                	li	a7,8
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <link>:
.global link
link:
 li a7, SYS_link
 682:	48cd                	li	a7,19
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 68a:	48d1                	li	a7,20
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 692:	48a5                	li	a7,9
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <dup>:
.global dup
dup:
 li a7, SYS_dup
 69a:	48a9                	li	a7,10
 ecall
 69c:	00000073          	ecall
 ret
 6a0:	8082                	ret

00000000000006a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 6a2:	48ad                	li	a7,11
 ecall
 6a4:	00000073          	ecall
 ret
 6a8:	8082                	ret

00000000000006aa <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 6aa:	48b1                	li	a7,12
 ecall
 6ac:	00000073          	ecall
 ret
 6b0:	8082                	ret

00000000000006b2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 6b2:	48b5                	li	a7,13
 ecall
 6b4:	00000073          	ecall
 ret
 6b8:	8082                	ret

00000000000006ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 6ba:	48b9                	li	a7,14
 ecall
 6bc:	00000073          	ecall
 ret
 6c0:	8082                	ret

00000000000006c2 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 6c2:	48d9                	li	a7,22
 ecall
 6c4:	00000073          	ecall
 ret
 6c8:	8082                	ret

00000000000006ca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6ca:	1101                	addi	sp,sp,-32
 6cc:	ec06                	sd	ra,24(sp)
 6ce:	e822                	sd	s0,16(sp)
 6d0:	1000                	addi	s0,sp,32
 6d2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6d6:	4605                	li	a2,1
 6d8:	fef40593          	addi	a1,s0,-17
 6dc:	f67ff0ef          	jal	642 <write>
}
 6e0:	60e2                	ld	ra,24(sp)
 6e2:	6442                	ld	s0,16(sp)
 6e4:	6105                	addi	sp,sp,32
 6e6:	8082                	ret

00000000000006e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6e8:	7139                	addi	sp,sp,-64
 6ea:	fc06                	sd	ra,56(sp)
 6ec:	f822                	sd	s0,48(sp)
 6ee:	f426                	sd	s1,40(sp)
 6f0:	0080                	addi	s0,sp,64
 6f2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6f4:	c299                	beqz	a3,6fa <printint+0x12>
 6f6:	0805c963          	bltz	a1,788 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6fa:	2581                	sext.w	a1,a1
  neg = 0;
 6fc:	4881                	li	a7,0
 6fe:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 702:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 704:	2601                	sext.w	a2,a2
 706:	00000517          	auipc	a0,0x0
 70a:	62250513          	addi	a0,a0,1570 # d28 <digits>
 70e:	883a                	mv	a6,a4
 710:	2705                	addiw	a4,a4,1
 712:	02c5f7bb          	remuw	a5,a1,a2
 716:	1782                	slli	a5,a5,0x20
 718:	9381                	srli	a5,a5,0x20
 71a:	97aa                	add	a5,a5,a0
 71c:	0007c783          	lbu	a5,0(a5)
 720:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 724:	0005879b          	sext.w	a5,a1
 728:	02c5d5bb          	divuw	a1,a1,a2
 72c:	0685                	addi	a3,a3,1
 72e:	fec7f0e3          	bgeu	a5,a2,70e <printint+0x26>
  if(neg)
 732:	00088c63          	beqz	a7,74a <printint+0x62>
    buf[i++] = '-';
 736:	fd070793          	addi	a5,a4,-48
 73a:	00878733          	add	a4,a5,s0
 73e:	02d00793          	li	a5,45
 742:	fef70823          	sb	a5,-16(a4)
 746:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 74a:	02e05a63          	blez	a4,77e <printint+0x96>
 74e:	f04a                	sd	s2,32(sp)
 750:	ec4e                	sd	s3,24(sp)
 752:	fc040793          	addi	a5,s0,-64
 756:	00e78933          	add	s2,a5,a4
 75a:	fff78993          	addi	s3,a5,-1
 75e:	99ba                	add	s3,s3,a4
 760:	377d                	addiw	a4,a4,-1
 762:	1702                	slli	a4,a4,0x20
 764:	9301                	srli	a4,a4,0x20
 766:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 76a:	fff94583          	lbu	a1,-1(s2)
 76e:	8526                	mv	a0,s1
 770:	f5bff0ef          	jal	6ca <putc>
  while(--i >= 0)
 774:	197d                	addi	s2,s2,-1
 776:	ff391ae3          	bne	s2,s3,76a <printint+0x82>
 77a:	7902                	ld	s2,32(sp)
 77c:	69e2                	ld	s3,24(sp)
}
 77e:	70e2                	ld	ra,56(sp)
 780:	7442                	ld	s0,48(sp)
 782:	74a2                	ld	s1,40(sp)
 784:	6121                	addi	sp,sp,64
 786:	8082                	ret
    x = -xx;
 788:	40b005bb          	negw	a1,a1
    neg = 1;
 78c:	4885                	li	a7,1
    x = -xx;
 78e:	bf85                	j	6fe <printint+0x16>

0000000000000790 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 790:	711d                	addi	sp,sp,-96
 792:	ec86                	sd	ra,88(sp)
 794:	e8a2                	sd	s0,80(sp)
 796:	e0ca                	sd	s2,64(sp)
 798:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 79a:	0005c903          	lbu	s2,0(a1)
 79e:	26090863          	beqz	s2,a0e <vprintf+0x27e>
 7a2:	e4a6                	sd	s1,72(sp)
 7a4:	fc4e                	sd	s3,56(sp)
 7a6:	f852                	sd	s4,48(sp)
 7a8:	f456                	sd	s5,40(sp)
 7aa:	f05a                	sd	s6,32(sp)
 7ac:	ec5e                	sd	s7,24(sp)
 7ae:	e862                	sd	s8,16(sp)
 7b0:	e466                	sd	s9,8(sp)
 7b2:	8b2a                	mv	s6,a0
 7b4:	8a2e                	mv	s4,a1
 7b6:	8bb2                	mv	s7,a2
  state = 0;
 7b8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 7ba:	4481                	li	s1,0
 7bc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 7be:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 7c2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 7c6:	06c00c93          	li	s9,108
 7ca:	a005                	j	7ea <vprintf+0x5a>
        putc(fd, c0);
 7cc:	85ca                	mv	a1,s2
 7ce:	855a                	mv	a0,s6
 7d0:	efbff0ef          	jal	6ca <putc>
 7d4:	a019                	j	7da <vprintf+0x4a>
    } else if(state == '%'){
 7d6:	03598263          	beq	s3,s5,7fa <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 7da:	2485                	addiw	s1,s1,1
 7dc:	8726                	mv	a4,s1
 7de:	009a07b3          	add	a5,s4,s1
 7e2:	0007c903          	lbu	s2,0(a5)
 7e6:	20090c63          	beqz	s2,9fe <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 7ea:	0009079b          	sext.w	a5,s2
    if(state == 0){
 7ee:	fe0994e3          	bnez	s3,7d6 <vprintf+0x46>
      if(c0 == '%'){
 7f2:	fd579de3          	bne	a5,s5,7cc <vprintf+0x3c>
        state = '%';
 7f6:	89be                	mv	s3,a5
 7f8:	b7cd                	j	7da <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 7fa:	00ea06b3          	add	a3,s4,a4
 7fe:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 802:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 804:	c681                	beqz	a3,80c <vprintf+0x7c>
 806:	9752                	add	a4,a4,s4
 808:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 80c:	03878f63          	beq	a5,s8,84a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 810:	05978963          	beq	a5,s9,862 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 814:	07500713          	li	a4,117
 818:	0ee78363          	beq	a5,a4,8fe <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 81c:	07800713          	li	a4,120
 820:	12e78563          	beq	a5,a4,94a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 824:	07000713          	li	a4,112
 828:	14e78a63          	beq	a5,a4,97c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 82c:	07300713          	li	a4,115
 830:	18e78a63          	beq	a5,a4,9c4 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 834:	02500713          	li	a4,37
 838:	04e79563          	bne	a5,a4,882 <vprintf+0xf2>
        putc(fd, '%');
 83c:	02500593          	li	a1,37
 840:	855a                	mv	a0,s6
 842:	e89ff0ef          	jal	6ca <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 846:	4981                	li	s3,0
 848:	bf49                	j	7da <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 84a:	008b8913          	addi	s2,s7,8
 84e:	4685                	li	a3,1
 850:	4629                	li	a2,10
 852:	000ba583          	lw	a1,0(s7)
 856:	855a                	mv	a0,s6
 858:	e91ff0ef          	jal	6e8 <printint>
 85c:	8bca                	mv	s7,s2
      state = 0;
 85e:	4981                	li	s3,0
 860:	bfad                	j	7da <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 862:	06400793          	li	a5,100
 866:	02f68963          	beq	a3,a5,898 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 86a:	06c00793          	li	a5,108
 86e:	04f68263          	beq	a3,a5,8b2 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 872:	07500793          	li	a5,117
 876:	0af68063          	beq	a3,a5,916 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 87a:	07800793          	li	a5,120
 87e:	0ef68263          	beq	a3,a5,962 <vprintf+0x1d2>
        putc(fd, '%');
 882:	02500593          	li	a1,37
 886:	855a                	mv	a0,s6
 888:	e43ff0ef          	jal	6ca <putc>
        putc(fd, c0);
 88c:	85ca                	mv	a1,s2
 88e:	855a                	mv	a0,s6
 890:	e3bff0ef          	jal	6ca <putc>
      state = 0;
 894:	4981                	li	s3,0
 896:	b791                	j	7da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 898:	008b8913          	addi	s2,s7,8
 89c:	4685                	li	a3,1
 89e:	4629                	li	a2,10
 8a0:	000ba583          	lw	a1,0(s7)
 8a4:	855a                	mv	a0,s6
 8a6:	e43ff0ef          	jal	6e8 <printint>
        i += 1;
 8aa:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8ac:	8bca                	mv	s7,s2
      state = 0;
 8ae:	4981                	li	s3,0
        i += 1;
 8b0:	b72d                	j	7da <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8b2:	06400793          	li	a5,100
 8b6:	02f60763          	beq	a2,a5,8e4 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 8ba:	07500793          	li	a5,117
 8be:	06f60963          	beq	a2,a5,930 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8c2:	07800793          	li	a5,120
 8c6:	faf61ee3          	bne	a2,a5,882 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 8ca:	008b8913          	addi	s2,s7,8
 8ce:	4681                	li	a3,0
 8d0:	4641                	li	a2,16
 8d2:	000ba583          	lw	a1,0(s7)
 8d6:	855a                	mv	a0,s6
 8d8:	e11ff0ef          	jal	6e8 <printint>
        i += 2;
 8dc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 8de:	8bca                	mv	s7,s2
      state = 0;
 8e0:	4981                	li	s3,0
        i += 2;
 8e2:	bde5                	j	7da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8e4:	008b8913          	addi	s2,s7,8
 8e8:	4685                	li	a3,1
 8ea:	4629                	li	a2,10
 8ec:	000ba583          	lw	a1,0(s7)
 8f0:	855a                	mv	a0,s6
 8f2:	df7ff0ef          	jal	6e8 <printint>
        i += 2;
 8f6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8f8:	8bca                	mv	s7,s2
      state = 0;
 8fa:	4981                	li	s3,0
        i += 2;
 8fc:	bdf9                	j	7da <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 8fe:	008b8913          	addi	s2,s7,8
 902:	4681                	li	a3,0
 904:	4629                	li	a2,10
 906:	000ba583          	lw	a1,0(s7)
 90a:	855a                	mv	a0,s6
 90c:	dddff0ef          	jal	6e8 <printint>
 910:	8bca                	mv	s7,s2
      state = 0;
 912:	4981                	li	s3,0
 914:	b5d9                	j	7da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 916:	008b8913          	addi	s2,s7,8
 91a:	4681                	li	a3,0
 91c:	4629                	li	a2,10
 91e:	000ba583          	lw	a1,0(s7)
 922:	855a                	mv	a0,s6
 924:	dc5ff0ef          	jal	6e8 <printint>
        i += 1;
 928:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 92a:	8bca                	mv	s7,s2
      state = 0;
 92c:	4981                	li	s3,0
        i += 1;
 92e:	b575                	j	7da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 930:	008b8913          	addi	s2,s7,8
 934:	4681                	li	a3,0
 936:	4629                	li	a2,10
 938:	000ba583          	lw	a1,0(s7)
 93c:	855a                	mv	a0,s6
 93e:	dabff0ef          	jal	6e8 <printint>
        i += 2;
 942:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 944:	8bca                	mv	s7,s2
      state = 0;
 946:	4981                	li	s3,0
        i += 2;
 948:	bd49                	j	7da <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 94a:	008b8913          	addi	s2,s7,8
 94e:	4681                	li	a3,0
 950:	4641                	li	a2,16
 952:	000ba583          	lw	a1,0(s7)
 956:	855a                	mv	a0,s6
 958:	d91ff0ef          	jal	6e8 <printint>
 95c:	8bca                	mv	s7,s2
      state = 0;
 95e:	4981                	li	s3,0
 960:	bdad                	j	7da <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 962:	008b8913          	addi	s2,s7,8
 966:	4681                	li	a3,0
 968:	4641                	li	a2,16
 96a:	000ba583          	lw	a1,0(s7)
 96e:	855a                	mv	a0,s6
 970:	d79ff0ef          	jal	6e8 <printint>
        i += 1;
 974:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 976:	8bca                	mv	s7,s2
      state = 0;
 978:	4981                	li	s3,0
        i += 1;
 97a:	b585                	j	7da <vprintf+0x4a>
 97c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 97e:	008b8d13          	addi	s10,s7,8
 982:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 986:	03000593          	li	a1,48
 98a:	855a                	mv	a0,s6
 98c:	d3fff0ef          	jal	6ca <putc>
  putc(fd, 'x');
 990:	07800593          	li	a1,120
 994:	855a                	mv	a0,s6
 996:	d35ff0ef          	jal	6ca <putc>
 99a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 99c:	00000b97          	auipc	s7,0x0
 9a0:	38cb8b93          	addi	s7,s7,908 # d28 <digits>
 9a4:	03c9d793          	srli	a5,s3,0x3c
 9a8:	97de                	add	a5,a5,s7
 9aa:	0007c583          	lbu	a1,0(a5)
 9ae:	855a                	mv	a0,s6
 9b0:	d1bff0ef          	jal	6ca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 9b4:	0992                	slli	s3,s3,0x4
 9b6:	397d                	addiw	s2,s2,-1
 9b8:	fe0916e3          	bnez	s2,9a4 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 9bc:	8bea                	mv	s7,s10
      state = 0;
 9be:	4981                	li	s3,0
 9c0:	6d02                	ld	s10,0(sp)
 9c2:	bd21                	j	7da <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 9c4:	008b8993          	addi	s3,s7,8
 9c8:	000bb903          	ld	s2,0(s7)
 9cc:	00090f63          	beqz	s2,9ea <vprintf+0x25a>
        for(; *s; s++)
 9d0:	00094583          	lbu	a1,0(s2)
 9d4:	c195                	beqz	a1,9f8 <vprintf+0x268>
          putc(fd, *s);
 9d6:	855a                	mv	a0,s6
 9d8:	cf3ff0ef          	jal	6ca <putc>
        for(; *s; s++)
 9dc:	0905                	addi	s2,s2,1
 9de:	00094583          	lbu	a1,0(s2)
 9e2:	f9f5                	bnez	a1,9d6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 9e4:	8bce                	mv	s7,s3
      state = 0;
 9e6:	4981                	li	s3,0
 9e8:	bbcd                	j	7da <vprintf+0x4a>
          s = "(null)";
 9ea:	00000917          	auipc	s2,0x0
 9ee:	33690913          	addi	s2,s2,822 # d20 <malloc+0x22a>
        for(; *s; s++)
 9f2:	02800593          	li	a1,40
 9f6:	b7c5                	j	9d6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 9f8:	8bce                	mv	s7,s3
      state = 0;
 9fa:	4981                	li	s3,0
 9fc:	bbf9                	j	7da <vprintf+0x4a>
 9fe:	64a6                	ld	s1,72(sp)
 a00:	79e2                	ld	s3,56(sp)
 a02:	7a42                	ld	s4,48(sp)
 a04:	7aa2                	ld	s5,40(sp)
 a06:	7b02                	ld	s6,32(sp)
 a08:	6be2                	ld	s7,24(sp)
 a0a:	6c42                	ld	s8,16(sp)
 a0c:	6ca2                	ld	s9,8(sp)
    }
  }
}
 a0e:	60e6                	ld	ra,88(sp)
 a10:	6446                	ld	s0,80(sp)
 a12:	6906                	ld	s2,64(sp)
 a14:	6125                	addi	sp,sp,96
 a16:	8082                	ret

0000000000000a18 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a18:	715d                	addi	sp,sp,-80
 a1a:	ec06                	sd	ra,24(sp)
 a1c:	e822                	sd	s0,16(sp)
 a1e:	1000                	addi	s0,sp,32
 a20:	e010                	sd	a2,0(s0)
 a22:	e414                	sd	a3,8(s0)
 a24:	e818                	sd	a4,16(s0)
 a26:	ec1c                	sd	a5,24(s0)
 a28:	03043023          	sd	a6,32(s0)
 a2c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a30:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a34:	8622                	mv	a2,s0
 a36:	d5bff0ef          	jal	790 <vprintf>
}
 a3a:	60e2                	ld	ra,24(sp)
 a3c:	6442                	ld	s0,16(sp)
 a3e:	6161                	addi	sp,sp,80
 a40:	8082                	ret

0000000000000a42 <printf>:

void
printf(const char *fmt, ...)
{
 a42:	711d                	addi	sp,sp,-96
 a44:	ec06                	sd	ra,24(sp)
 a46:	e822                	sd	s0,16(sp)
 a48:	1000                	addi	s0,sp,32
 a4a:	e40c                	sd	a1,8(s0)
 a4c:	e810                	sd	a2,16(s0)
 a4e:	ec14                	sd	a3,24(s0)
 a50:	f018                	sd	a4,32(s0)
 a52:	f41c                	sd	a5,40(s0)
 a54:	03043823          	sd	a6,48(s0)
 a58:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a5c:	00840613          	addi	a2,s0,8
 a60:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a64:	85aa                	mv	a1,a0
 a66:	4505                	li	a0,1
 a68:	d29ff0ef          	jal	790 <vprintf>
}
 a6c:	60e2                	ld	ra,24(sp)
 a6e:	6442                	ld	s0,16(sp)
 a70:	6125                	addi	sp,sp,96
 a72:	8082                	ret

0000000000000a74 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a74:	1141                	addi	sp,sp,-16
 a76:	e422                	sd	s0,8(sp)
 a78:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a7a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a7e:	00001797          	auipc	a5,0x1
 a82:	58a7b783          	ld	a5,1418(a5) # 2008 <freep>
 a86:	a02d                	j	ab0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 a88:	4618                	lw	a4,8(a2)
 a8a:	9f2d                	addw	a4,a4,a1
 a8c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a90:	6398                	ld	a4,0(a5)
 a92:	6310                	ld	a2,0(a4)
 a94:	a83d                	j	ad2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 a96:	ff852703          	lw	a4,-8(a0)
 a9a:	9f31                	addw	a4,a4,a2
 a9c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a9e:	ff053683          	ld	a3,-16(a0)
 aa2:	a091                	j	ae6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aa4:	6398                	ld	a4,0(a5)
 aa6:	00e7e463          	bltu	a5,a4,aae <free+0x3a>
 aaa:	00e6ea63          	bltu	a3,a4,abe <free+0x4a>
{
 aae:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab0:	fed7fae3          	bgeu	a5,a3,aa4 <free+0x30>
 ab4:	6398                	ld	a4,0(a5)
 ab6:	00e6e463          	bltu	a3,a4,abe <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aba:	fee7eae3          	bltu	a5,a4,aae <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 abe:	ff852583          	lw	a1,-8(a0)
 ac2:	6390                	ld	a2,0(a5)
 ac4:	02059813          	slli	a6,a1,0x20
 ac8:	01c85713          	srli	a4,a6,0x1c
 acc:	9736                	add	a4,a4,a3
 ace:	fae60de3          	beq	a2,a4,a88 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ad2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ad6:	4790                	lw	a2,8(a5)
 ad8:	02061593          	slli	a1,a2,0x20
 adc:	01c5d713          	srli	a4,a1,0x1c
 ae0:	973e                	add	a4,a4,a5
 ae2:	fae68ae3          	beq	a3,a4,a96 <free+0x22>
    p->s.ptr = bp->s.ptr;
 ae6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ae8:	00001717          	auipc	a4,0x1
 aec:	52f73023          	sd	a5,1312(a4) # 2008 <freep>
}
 af0:	6422                	ld	s0,8(sp)
 af2:	0141                	addi	sp,sp,16
 af4:	8082                	ret

0000000000000af6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 af6:	7139                	addi	sp,sp,-64
 af8:	fc06                	sd	ra,56(sp)
 afa:	f822                	sd	s0,48(sp)
 afc:	f426                	sd	s1,40(sp)
 afe:	ec4e                	sd	s3,24(sp)
 b00:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b02:	02051493          	slli	s1,a0,0x20
 b06:	9081                	srli	s1,s1,0x20
 b08:	04bd                	addi	s1,s1,15
 b0a:	8091                	srli	s1,s1,0x4
 b0c:	0014899b          	addiw	s3,s1,1
 b10:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 b12:	00001517          	auipc	a0,0x1
 b16:	4f653503          	ld	a0,1270(a0) # 2008 <freep>
 b1a:	c915                	beqz	a0,b4e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b1c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b1e:	4798                	lw	a4,8(a5)
 b20:	08977a63          	bgeu	a4,s1,bb4 <malloc+0xbe>
 b24:	f04a                	sd	s2,32(sp)
 b26:	e852                	sd	s4,16(sp)
 b28:	e456                	sd	s5,8(sp)
 b2a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 b2c:	8a4e                	mv	s4,s3
 b2e:	0009871b          	sext.w	a4,s3
 b32:	6685                	lui	a3,0x1
 b34:	00d77363          	bgeu	a4,a3,b3a <malloc+0x44>
 b38:	6a05                	lui	s4,0x1
 b3a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b3e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 b42:	00001917          	auipc	s2,0x1
 b46:	4c690913          	addi	s2,s2,1222 # 2008 <freep>
  if(p == (char*)-1)
 b4a:	5afd                	li	s5,-1
 b4c:	a081                	j	b8c <malloc+0x96>
 b4e:	f04a                	sd	s2,32(sp)
 b50:	e852                	sd	s4,16(sp)
 b52:	e456                	sd	s5,8(sp)
 b54:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b56:	00005797          	auipc	a5,0x5
 b5a:	4ba78793          	addi	a5,a5,1210 # 6010 <base>
 b5e:	00001717          	auipc	a4,0x1
 b62:	4af73523          	sd	a5,1194(a4) # 2008 <freep>
 b66:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b68:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 b6c:	b7c1                	j	b2c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 b6e:	6398                	ld	a4,0(a5)
 b70:	e118                	sd	a4,0(a0)
 b72:	a8a9                	j	bcc <malloc+0xd6>
  hp->s.size = nu;
 b74:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 b78:	0541                	addi	a0,a0,16
 b7a:	efbff0ef          	jal	a74 <free>
  return freep;
 b7e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 b82:	c12d                	beqz	a0,be4 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b84:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 b86:	4798                	lw	a4,8(a5)
 b88:	02977263          	bgeu	a4,s1,bac <malloc+0xb6>
    if(p == freep)
 b8c:	00093703          	ld	a4,0(s2)
 b90:	853e                	mv	a0,a5
 b92:	fef719e3          	bne	a4,a5,b84 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 b96:	8552                	mv	a0,s4
 b98:	b13ff0ef          	jal	6aa <sbrk>
  if(p == (char*)-1)
 b9c:	fd551ce3          	bne	a0,s5,b74 <malloc+0x7e>
        return 0;
 ba0:	4501                	li	a0,0
 ba2:	7902                	ld	s2,32(sp)
 ba4:	6a42                	ld	s4,16(sp)
 ba6:	6aa2                	ld	s5,8(sp)
 ba8:	6b02                	ld	s6,0(sp)
 baa:	a03d                	j	bd8 <malloc+0xe2>
 bac:	7902                	ld	s2,32(sp)
 bae:	6a42                	ld	s4,16(sp)
 bb0:	6aa2                	ld	s5,8(sp)
 bb2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 bb4:	fae48de3          	beq	s1,a4,b6e <malloc+0x78>
        p->s.size -= nunits;
 bb8:	4137073b          	subw	a4,a4,s3
 bbc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bbe:	02071693          	slli	a3,a4,0x20
 bc2:	01c6d713          	srli	a4,a3,0x1c
 bc6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bc8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bcc:	00001717          	auipc	a4,0x1
 bd0:	42a73e23          	sd	a0,1084(a4) # 2008 <freep>
      return (void*)(p + 1);
 bd4:	01078513          	addi	a0,a5,16
  }
}
 bd8:	70e2                	ld	ra,56(sp)
 bda:	7442                	ld	s0,48(sp)
 bdc:	74a2                	ld	s1,40(sp)
 bde:	69e2                	ld	s3,24(sp)
 be0:	6121                	addi	sp,sp,64
 be2:	8082                	ret
 be4:	7902                	ld	s2,32(sp)
 be6:	6a42                	ld	s4,16(sp)
 be8:	6aa2                	ld	s5,8(sp)
 bea:	6b02                	ld	s6,0(sp)
 bec:	b7f5                	j	bd8 <malloc+0xe2>
