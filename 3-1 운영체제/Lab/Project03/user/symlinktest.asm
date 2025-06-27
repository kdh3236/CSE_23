
user/_symlinktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <stat_slink>:
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84ae                	mv	s1,a1
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
   c:	6585                	lui	a1,0x1
   e:	067000ef          	jal	874 <open>
  if(fd < 0)
  12:	00054e63          	bltz	a0,2e <stat_slink+0x2e>
    return -1;
  if(fstat(fd, st) != 0)
  16:	85a6                	mv	a1,s1
  18:	075000ef          	jal	88c <fstat>
  1c:	00a03533          	snez	a0,a0
  20:	40a00533          	neg	a0,a0
    return -1;
  return 0;
}
  24:	60e2                	ld	ra,24(sp)
  26:	6442                	ld	s0,16(sp)
  28:	64a2                	ld	s1,8(sp)
  2a:	6105                	addi	sp,sp,32
  2c:	8082                	ret
    return -1;
  2e:	557d                	li	a0,-1
  30:	bfd5                	j	24 <stat_slink+0x24>

0000000000000032 <main>:
{
  32:	7119                	addi	sp,sp,-128
  34:	fc86                	sd	ra,120(sp)
  36:	f8a2                	sd	s0,112(sp)
  38:	f4a6                	sd	s1,104(sp)
  3a:	f0ca                	sd	s2,96(sp)
  3c:	0100                	addi	s0,sp,128
  unlink("/testsymlink/a");
  3e:	00001517          	auipc	a0,0x1
  42:	dc250513          	addi	a0,a0,-574 # e00 <malloc+0xf8>
  46:	03f000ef          	jal	884 <unlink>
  unlink("/testsymlink/b");
  4a:	00001517          	auipc	a0,0x1
  4e:	dce50513          	addi	a0,a0,-562 # e18 <malloc+0x110>
  52:	033000ef          	jal	884 <unlink>
  unlink("/testsymlink/c");
  56:	00001517          	auipc	a0,0x1
  5a:	dd250513          	addi	a0,a0,-558 # e28 <malloc+0x120>
  5e:	027000ef          	jal	884 <unlink>
  unlink("/testsymlink/1");
  62:	00001517          	auipc	a0,0x1
  66:	dd650513          	addi	a0,a0,-554 # e38 <malloc+0x130>
  6a:	01b000ef          	jal	884 <unlink>
  unlink("/testsymlink/2");
  6e:	00001517          	auipc	a0,0x1
  72:	dda50513          	addi	a0,a0,-550 # e48 <malloc+0x140>
  76:	00f000ef          	jal	884 <unlink>
  unlink("/testsymlink/3");
  7a:	00001517          	auipc	a0,0x1
  7e:	dde50513          	addi	a0,a0,-546 # e58 <malloc+0x150>
  82:	003000ef          	jal	884 <unlink>
  unlink("/testsymlink/4");
  86:	00001517          	auipc	a0,0x1
  8a:	de250513          	addi	a0,a0,-542 # e68 <malloc+0x160>
  8e:	7f6000ef          	jal	884 <unlink>
  unlink("/testsymlink/z");
  92:	00001517          	auipc	a0,0x1
  96:	de650513          	addi	a0,a0,-538 # e78 <malloc+0x170>
  9a:	7ea000ef          	jal	884 <unlink>
  unlink("/testsymlink/y");
  9e:	00001517          	auipc	a0,0x1
  a2:	dea50513          	addi	a0,a0,-534 # e88 <malloc+0x180>
  a6:	7de000ef          	jal	884 <unlink>
  unlink("/testsymlink");
  aa:	00001517          	auipc	a0,0x1
  ae:	dee50513          	addi	a0,a0,-530 # e98 <malloc+0x190>
  b2:	7d2000ef          	jal	884 <unlink>

static void
testsymlink(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
  b6:	646367b7          	lui	a5,0x64636
  ba:	26178793          	addi	a5,a5,609 # 64636261 <base+0x64634251>
  be:	f8f42823          	sw	a5,-112(s0)
  char c = 0, c2 = 0;
  c2:	f8040723          	sb	zero,-114(s0)
  c6:	f80407a3          	sb	zero,-113(s0)
  struct stat st;
    
  printf("Start: test symlinks\n");
  ca:	00001517          	auipc	a0,0x1
  ce:	dde50513          	addi	a0,a0,-546 # ea8 <malloc+0x1a0>
  d2:	383000ef          	jal	c54 <printf>

  mkdir("/testsymlink");
  d6:	00001517          	auipc	a0,0x1
  da:	dc250513          	addi	a0,a0,-574 # e98 <malloc+0x190>
  de:	7be000ef          	jal	89c <mkdir>

  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
  e2:	20200593          	li	a1,514
  e6:	00001517          	auipc	a0,0x1
  ea:	d1a50513          	addi	a0,a0,-742 # e00 <malloc+0xf8>
  ee:	786000ef          	jal	874 <open>
  f2:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open a");
  f4:	0c054963          	bltz	a0,1c6 <main+0x194>

  r = symlink("/testsymlink/a", "/testsymlink/b");
  f8:	00001597          	auipc	a1,0x1
  fc:	d2058593          	addi	a1,a1,-736 # e18 <malloc+0x110>
 100:	00001517          	auipc	a0,0x1
 104:	d0050513          	addi	a0,a0,-768 # e00 <malloc+0xf8>
 108:	7cc000ef          	jal	8d4 <symlink>
  if(r < 0)
 10c:	0c054a63          	bltz	a0,1e0 <main+0x1ae>
    fail("symlink b -> a failed");

  if(write(fd1, buf, sizeof(buf)) != 4)
 110:	4611                	li	a2,4
 112:	f9040593          	addi	a1,s0,-112
 116:	8526                	mv	a0,s1
 118:	73c000ef          	jal	854 <write>
 11c:	4791                	li	a5,4
 11e:	0cf50e63          	beq	a0,a5,1fa <main+0x1c8>
    fail("failed to write to a");
 122:	00001517          	auipc	a0,0x1
 126:	dde50513          	addi	a0,a0,-546 # f00 <malloc+0x1f8>
 12a:	32b000ef          	jal	c54 <printf>
 12e:	4785                	li	a5,1
 130:	00002717          	auipc	a4,0x2
 134:	ecf72823          	sw	a5,-304(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 138:	597d                	li	s2,-1
  if(c!=c2)
    fail("Value read from 4 differed from value written to 1\n");

  printf("test symlinks: ok\n");
done:
  close(fd1);
 13a:	8526                	mv	a0,s1
 13c:	720000ef          	jal	85c <close>
  close(fd2);
 140:	854a                	mv	a0,s2
 142:	71a000ef          	jal	85c <close>
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf("Start: test concurrent symlinks\n");
 146:	00001517          	auipc	a0,0x1
 14a:	09a50513          	addi	a0,a0,154 # 11e0 <malloc+0x4d8>
 14e:	307000ef          	jal	c54 <printf>
    
  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
 152:	20200593          	li	a1,514
 156:	00001517          	auipc	a0,0x1
 15a:	d2250513          	addi	a0,a0,-734 # e78 <malloc+0x170>
 15e:	716000ef          	jal	874 <open>
  if(fd < 0) {
 162:	38054263          	bltz	a0,4e6 <main+0x4b4>
    printf("FAILED: open failed");
    exit(1);
  }
  close(fd);
 166:	6f6000ef          	jal	85c <close>

  for(int j = 0; j < nchild; j++) {
    pid = fork();
 16a:	6c2000ef          	jal	82c <fork>
    if(pid < 0){
 16e:	38054b63          	bltz	a0,504 <main+0x4d2>
      printf("FAILED: fork failed\n");
      exit(1);
    }
    if(pid == 0) {
 172:	3a050863          	beqz	a0,522 <main+0x4f0>
    pid = fork();
 176:	6b6000ef          	jal	82c <fork>
    if(pid < 0){
 17a:	38054563          	bltz	a0,504 <main+0x4d2>
    if(pid == 0) {
 17e:	3a050263          	beqz	a0,522 <main+0x4f0>
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    wait(&r);
 182:	f9840513          	addi	a0,s0,-104
 186:	6b6000ef          	jal	83c <wait>
    if(r != 0) {
 18a:	f9842783          	lw	a5,-104(s0)
 18e:	40079f63          	bnez	a5,5ac <main+0x57a>
 192:	ecce                	sd	s3,88(sp)
 194:	e8d2                	sd	s4,80(sp)
 196:	e4d6                	sd	s5,72(sp)
 198:	e0da                	sd	s6,64(sp)
 19a:	fc5e                	sd	s7,56(sp)
 19c:	f862                	sd	s8,48(sp)
    wait(&r);
 19e:	f9840513          	addi	a0,s0,-104
 1a2:	69a000ef          	jal	83c <wait>
    if(r != 0) {
 1a6:	f9842783          	lw	a5,-104(s0)
 1aa:	40079763          	bnez	a5,5b8 <main+0x586>
      printf("test concurrent symlinks: failed\n");
      exit(1);
    }
  }
  printf("test concurrent symlinks: ok\n");
 1ae:	00001517          	auipc	a0,0x1
 1b2:	0d250513          	addi	a0,a0,210 # 1280 <malloc+0x578>
 1b6:	29f000ef          	jal	c54 <printf>
  exit(failed);
 1ba:	00002517          	auipc	a0,0x2
 1be:	e4652503          	lw	a0,-442(a0) # 2000 <failed>
 1c2:	672000ef          	jal	834 <exit>
  if(fd1 < 0) fail("failed to open a");
 1c6:	00001517          	auipc	a0,0x1
 1ca:	cfa50513          	addi	a0,a0,-774 # ec0 <malloc+0x1b8>
 1ce:	287000ef          	jal	c54 <printf>
 1d2:	4785                	li	a5,1
 1d4:	00002717          	auipc	a4,0x2
 1d8:	e2f72623          	sw	a5,-468(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 1dc:	597d                	li	s2,-1
  if(fd1 < 0) fail("failed to open a");
 1de:	bfb1                	j	13a <main+0x108>
    fail("symlink b -> a failed");
 1e0:	00001517          	auipc	a0,0x1
 1e4:	d0050513          	addi	a0,a0,-768 # ee0 <malloc+0x1d8>
 1e8:	26d000ef          	jal	c54 <printf>
 1ec:	4785                	li	a5,1
 1ee:	00002717          	auipc	a4,0x2
 1f2:	e0f72923          	sw	a5,-494(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 1f6:	597d                	li	s2,-1
    fail("symlink b -> a failed");
 1f8:	b789                	j	13a <main+0x108>
  if (stat_slink("/testsymlink/b", &st) != 0)
 1fa:	f9840593          	addi	a1,s0,-104
 1fe:	00001517          	auipc	a0,0x1
 202:	c1a50513          	addi	a0,a0,-998 # e18 <malloc+0x110>
 206:	dfbff0ef          	jal	0 <stat_slink>
 20a:	e11d                	bnez	a0,230 <main+0x1fe>
  if(st.type != T_SYMLINK)
 20c:	fa041703          	lh	a4,-96(s0)
 210:	4791                	li	a5,4
 212:	02f70c63          	beq	a4,a5,24a <main+0x218>
    fail("b isn't a symlink");
 216:	00001517          	auipc	a0,0x1
 21a:	d2a50513          	addi	a0,a0,-726 # f40 <malloc+0x238>
 21e:	237000ef          	jal	c54 <printf>
 222:	4785                	li	a5,1
 224:	00002717          	auipc	a4,0x2
 228:	dcf72e23          	sw	a5,-548(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 22c:	597d                	li	s2,-1
    fail("b isn't a symlink");
 22e:	b731                	j	13a <main+0x108>
    fail("failed to stat b");
 230:	00001517          	auipc	a0,0x1
 234:	cf050513          	addi	a0,a0,-784 # f20 <malloc+0x218>
 238:	21d000ef          	jal	c54 <printf>
 23c:	4785                	li	a5,1
 23e:	00002717          	auipc	a4,0x2
 242:	dcf72123          	sw	a5,-574(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
 246:	597d                	li	s2,-1
    fail("failed to stat b");
 248:	bdcd                	j	13a <main+0x108>
  fd2 = open("/testsymlink/b", O_RDWR);
 24a:	4589                	li	a1,2
 24c:	00001517          	auipc	a0,0x1
 250:	bcc50513          	addi	a0,a0,-1076 # e18 <malloc+0x110>
 254:	620000ef          	jal	874 <open>
 258:	892a                	mv	s2,a0
  if(fd2 < 0)
 25a:	02054963          	bltz	a0,28c <main+0x25a>
  read(fd2, &c, 1);
 25e:	4605                	li	a2,1
 260:	f8e40593          	addi	a1,s0,-114
 264:	5e8000ef          	jal	84c <read>
  if (c != 'a')
 268:	f8e44703          	lbu	a4,-114(s0)
 26c:	06100793          	li	a5,97
 270:	02f70a63          	beq	a4,a5,2a4 <main+0x272>
    fail("failed to read bytes from b");
 274:	00001517          	auipc	a0,0x1
 278:	d0c50513          	addi	a0,a0,-756 # f80 <malloc+0x278>
 27c:	1d9000ef          	jal	c54 <printf>
 280:	4785                	li	a5,1
 282:	00002717          	auipc	a4,0x2
 286:	d6f72f23          	sw	a5,-642(a4) # 2000 <failed>
 28a:	bd45                	j	13a <main+0x108>
    fail("failed to open b");
 28c:	00001517          	auipc	a0,0x1
 290:	cd450513          	addi	a0,a0,-812 # f60 <malloc+0x258>
 294:	1c1000ef          	jal	c54 <printf>
 298:	4785                	li	a5,1
 29a:	00002717          	auipc	a4,0x2
 29e:	d6f72323          	sw	a5,-666(a4) # 2000 <failed>
 2a2:	bd61                	j	13a <main+0x108>
  unlink("/testsymlink/a");
 2a4:	00001517          	auipc	a0,0x1
 2a8:	b5c50513          	addi	a0,a0,-1188 # e00 <malloc+0xf8>
 2ac:	5d8000ef          	jal	884 <unlink>
  if(open("/testsymlink/b", O_RDWR) >= 0)
 2b0:	4589                	li	a1,2
 2b2:	00001517          	auipc	a0,0x1
 2b6:	b6650513          	addi	a0,a0,-1178 # e18 <malloc+0x110>
 2ba:	5ba000ef          	jal	874 <open>
 2be:	0e055a63          	bgez	a0,3b2 <main+0x380>
  r = symlink("/testsymlink/b", "/testsymlink/a");
 2c2:	00001597          	auipc	a1,0x1
 2c6:	b3e58593          	addi	a1,a1,-1218 # e00 <malloc+0xf8>
 2ca:	00001517          	auipc	a0,0x1
 2ce:	b4e50513          	addi	a0,a0,-1202 # e18 <malloc+0x110>
 2d2:	602000ef          	jal	8d4 <symlink>
  if(r < 0)
 2d6:	0e054a63          	bltz	a0,3ca <main+0x398>
  r = open("/testsymlink/b", O_RDWR);
 2da:	4589                	li	a1,2
 2dc:	00001517          	auipc	a0,0x1
 2e0:	b3c50513          	addi	a0,a0,-1220 # e18 <malloc+0x110>
 2e4:	590000ef          	jal	874 <open>
  if(r >= 0)
 2e8:	0e055d63          	bgez	a0,3e2 <main+0x3b0>
  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
 2ec:	00001597          	auipc	a1,0x1
 2f0:	b3c58593          	addi	a1,a1,-1220 # e28 <malloc+0x120>
 2f4:	00001517          	auipc	a0,0x1
 2f8:	d4c50513          	addi	a0,a0,-692 # 1040 <malloc+0x338>
 2fc:	5d8000ef          	jal	8d4 <symlink>
  if(r != 0)
 300:	0e051d63          	bnez	a0,3fa <main+0x3c8>
  r = symlink("/testsymlink/2", "/testsymlink/1");
 304:	00001597          	auipc	a1,0x1
 308:	b3458593          	addi	a1,a1,-1228 # e38 <malloc+0x130>
 30c:	00001517          	auipc	a0,0x1
 310:	b3c50513          	addi	a0,a0,-1220 # e48 <malloc+0x140>
 314:	5c0000ef          	jal	8d4 <symlink>
  if(r) fail("Failed to link 1->2");
 318:	0e051d63          	bnez	a0,412 <main+0x3e0>
  r = symlink("/testsymlink/3", "/testsymlink/2");
 31c:	00001597          	auipc	a1,0x1
 320:	b2c58593          	addi	a1,a1,-1236 # e48 <malloc+0x140>
 324:	00001517          	auipc	a0,0x1
 328:	b3450513          	addi	a0,a0,-1228 # e58 <malloc+0x150>
 32c:	5a8000ef          	jal	8d4 <symlink>
  if(r) fail("Failed to link 2->3");
 330:	0e051d63          	bnez	a0,42a <main+0x3f8>
  r = symlink("/testsymlink/4", "/testsymlink/3");
 334:	00001597          	auipc	a1,0x1
 338:	b2458593          	addi	a1,a1,-1244 # e58 <malloc+0x150>
 33c:	00001517          	auipc	a0,0x1
 340:	b2c50513          	addi	a0,a0,-1236 # e68 <malloc+0x160>
 344:	590000ef          	jal	8d4 <symlink>
  if(r) fail("Failed to link 3->4");
 348:	0e051d63          	bnez	a0,442 <main+0x410>
  close(fd1);
 34c:	8526                	mv	a0,s1
 34e:	50e000ef          	jal	85c <close>
  close(fd2);
 352:	854a                	mv	a0,s2
 354:	508000ef          	jal	85c <close>
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
 358:	20200593          	li	a1,514
 35c:	00001517          	auipc	a0,0x1
 360:	b0c50513          	addi	a0,a0,-1268 # e68 <malloc+0x160>
 364:	510000ef          	jal	874 <open>
 368:	84aa                	mv	s1,a0
  if(fd1<0) fail("Failed to create 4\n");
 36a:	0e054863          	bltz	a0,45a <main+0x428>
  fd2 = open("/testsymlink/1", O_RDWR);
 36e:	4589                	li	a1,2
 370:	00001517          	auipc	a0,0x1
 374:	ac850513          	addi	a0,a0,-1336 # e38 <malloc+0x130>
 378:	4fc000ef          	jal	874 <open>
 37c:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open 1\n");
 37e:	0e054a63          	bltz	a0,472 <main+0x440>
  c = '#';
 382:	02300793          	li	a5,35
 386:	f8f40723          	sb	a5,-114(s0)
  r = write(fd2, &c, 1);
 38a:	4605                	li	a2,1
 38c:	f8e40593          	addi	a1,s0,-114
 390:	4c4000ef          	jal	854 <write>
  if(r!=1) fail("Failed to write to 1\n");
 394:	4785                	li	a5,1
 396:	0ef50a63          	beq	a0,a5,48a <main+0x458>
 39a:	00001517          	auipc	a0,0x1
 39e:	da650513          	addi	a0,a0,-602 # 1140 <malloc+0x438>
 3a2:	0b3000ef          	jal	c54 <printf>
 3a6:	4785                	li	a5,1
 3a8:	00002717          	auipc	a4,0x2
 3ac:	c4f72c23          	sw	a5,-936(a4) # 2000 <failed>
 3b0:	b369                	j	13a <main+0x108>
    fail("Should not be able to open b after deleting a");
 3b2:	00001517          	auipc	a0,0x1
 3b6:	bf650513          	addi	a0,a0,-1034 # fa8 <malloc+0x2a0>
 3ba:	09b000ef          	jal	c54 <printf>
 3be:	4785                	li	a5,1
 3c0:	00002717          	auipc	a4,0x2
 3c4:	c4f72023          	sw	a5,-960(a4) # 2000 <failed>
 3c8:	bb8d                	j	13a <main+0x108>
    fail("symlink a -> b failed");
 3ca:	00001517          	auipc	a0,0x1
 3ce:	c1650513          	addi	a0,a0,-1002 # fe0 <malloc+0x2d8>
 3d2:	083000ef          	jal	c54 <printf>
 3d6:	4785                	li	a5,1
 3d8:	00002717          	auipc	a4,0x2
 3dc:	c2f72423          	sw	a5,-984(a4) # 2000 <failed>
 3e0:	bba9                	j	13a <main+0x108>
    fail("Should not be able to open b (cycle b->a->b->..)\n");
 3e2:	00001517          	auipc	a0,0x1
 3e6:	c1e50513          	addi	a0,a0,-994 # 1000 <malloc+0x2f8>
 3ea:	06b000ef          	jal	c54 <printf>
 3ee:	4785                	li	a5,1
 3f0:	00002717          	auipc	a4,0x2
 3f4:	c0f72823          	sw	a5,-1008(a4) # 2000 <failed>
 3f8:	b389                	j	13a <main+0x108>
    fail("Symlinking to nonexistent file should succeed\n");
 3fa:	00001517          	auipc	a0,0x1
 3fe:	c6650513          	addi	a0,a0,-922 # 1060 <malloc+0x358>
 402:	053000ef          	jal	c54 <printf>
 406:	4785                	li	a5,1
 408:	00002717          	auipc	a4,0x2
 40c:	bef72c23          	sw	a5,-1032(a4) # 2000 <failed>
 410:	b32d                	j	13a <main+0x108>
  if(r) fail("Failed to link 1->2");
 412:	00001517          	auipc	a0,0x1
 416:	c8e50513          	addi	a0,a0,-882 # 10a0 <malloc+0x398>
 41a:	03b000ef          	jal	c54 <printf>
 41e:	4785                	li	a5,1
 420:	00002717          	auipc	a4,0x2
 424:	bef72023          	sw	a5,-1056(a4) # 2000 <failed>
 428:	bb09                	j	13a <main+0x108>
  if(r) fail("Failed to link 2->3");
 42a:	00001517          	auipc	a0,0x1
 42e:	c9650513          	addi	a0,a0,-874 # 10c0 <malloc+0x3b8>
 432:	023000ef          	jal	c54 <printf>
 436:	4785                	li	a5,1
 438:	00002717          	auipc	a4,0x2
 43c:	bcf72423          	sw	a5,-1080(a4) # 2000 <failed>
 440:	b9ed                	j	13a <main+0x108>
  if(r) fail("Failed to link 3->4");
 442:	00001517          	auipc	a0,0x1
 446:	c9e50513          	addi	a0,a0,-866 # 10e0 <malloc+0x3d8>
 44a:	00b000ef          	jal	c54 <printf>
 44e:	4785                	li	a5,1
 450:	00002717          	auipc	a4,0x2
 454:	baf72823          	sw	a5,-1104(a4) # 2000 <failed>
 458:	b1cd                	j	13a <main+0x108>
  if(fd1<0) fail("Failed to create 4\n");
 45a:	00001517          	auipc	a0,0x1
 45e:	ca650513          	addi	a0,a0,-858 # 1100 <malloc+0x3f8>
 462:	7f2000ef          	jal	c54 <printf>
 466:	4785                	li	a5,1
 468:	00002717          	auipc	a4,0x2
 46c:	b8f72c23          	sw	a5,-1128(a4) # 2000 <failed>
 470:	b1e9                	j	13a <main+0x108>
  if(fd2<0) fail("Failed to open 1\n");
 472:	00001517          	auipc	a0,0x1
 476:	cae50513          	addi	a0,a0,-850 # 1120 <malloc+0x418>
 47a:	7da000ef          	jal	c54 <printf>
 47e:	4785                	li	a5,1
 480:	00002717          	auipc	a4,0x2
 484:	b8f72023          	sw	a5,-1152(a4) # 2000 <failed>
 488:	b94d                	j	13a <main+0x108>
  r = read(fd1, &c2, 1);
 48a:	4605                	li	a2,1
 48c:	f8f40593          	addi	a1,s0,-113
 490:	8526                	mv	a0,s1
 492:	3ba000ef          	jal	84c <read>
  if(r!=1) fail("Failed to read from 4\n");
 496:	4785                	li	a5,1
 498:	02f51463          	bne	a0,a5,4c0 <main+0x48e>
  if(c!=c2)
 49c:	f8e44703          	lbu	a4,-114(s0)
 4a0:	f8f44783          	lbu	a5,-113(s0)
 4a4:	02f70a63          	beq	a4,a5,4d8 <main+0x4a6>
    fail("Value read from 4 differed from value written to 1\n");
 4a8:	00001517          	auipc	a0,0x1
 4ac:	ce050513          	addi	a0,a0,-800 # 1188 <malloc+0x480>
 4b0:	7a4000ef          	jal	c54 <printf>
 4b4:	4785                	li	a5,1
 4b6:	00002717          	auipc	a4,0x2
 4ba:	b4f72523          	sw	a5,-1206(a4) # 2000 <failed>
 4be:	b9b5                	j	13a <main+0x108>
  if(r!=1) fail("Failed to read from 4\n");
 4c0:	00001517          	auipc	a0,0x1
 4c4:	ca050513          	addi	a0,a0,-864 # 1160 <malloc+0x458>
 4c8:	78c000ef          	jal	c54 <printf>
 4cc:	4785                	li	a5,1
 4ce:	00002717          	auipc	a4,0x2
 4d2:	b2f72923          	sw	a5,-1230(a4) # 2000 <failed>
 4d6:	b195                	j	13a <main+0x108>
  printf("test symlinks: ok\n");
 4d8:	00001517          	auipc	a0,0x1
 4dc:	cf050513          	addi	a0,a0,-784 # 11c8 <malloc+0x4c0>
 4e0:	774000ef          	jal	c54 <printf>
 4e4:	b999                	j	13a <main+0x108>
 4e6:	ecce                	sd	s3,88(sp)
 4e8:	e8d2                	sd	s4,80(sp)
 4ea:	e4d6                	sd	s5,72(sp)
 4ec:	e0da                	sd	s6,64(sp)
 4ee:	fc5e                	sd	s7,56(sp)
 4f0:	f862                	sd	s8,48(sp)
    printf("FAILED: open failed");
 4f2:	00001517          	auipc	a0,0x1
 4f6:	d1650513          	addi	a0,a0,-746 # 1208 <malloc+0x500>
 4fa:	75a000ef          	jal	c54 <printf>
    exit(1);
 4fe:	4505                	li	a0,1
 500:	334000ef          	jal	834 <exit>
 504:	ecce                	sd	s3,88(sp)
 506:	e8d2                	sd	s4,80(sp)
 508:	e4d6                	sd	s5,72(sp)
 50a:	e0da                	sd	s6,64(sp)
 50c:	fc5e                	sd	s7,56(sp)
 50e:	f862                	sd	s8,48(sp)
      printf("FAILED: fork failed\n");
 510:	00001517          	auipc	a0,0x1
 514:	d1050513          	addi	a0,a0,-752 # 1220 <malloc+0x518>
 518:	73c000ef          	jal	c54 <printf>
      exit(1);
 51c:	4505                	li	a0,1
 51e:	316000ef          	jal	834 <exit>
 522:	ecce                	sd	s3,88(sp)
 524:	e8d2                	sd	s4,80(sp)
 526:	e4d6                	sd	s5,72(sp)
 528:	e0da                	sd	s6,64(sp)
 52a:	fc5e                	sd	s7,56(sp)
 52c:	f862                	sd	s8,48(sp)
  int r, fd1 = -1, fd2 = -1;
 52e:	06400493          	li	s1,100
      unsigned int x = (pid ? 1 : 97);
 532:	06100c13          	li	s8,97
        x = x * 1103515245 + 12345;
 536:	41c65a37          	lui	s4,0x41c65
 53a:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c62e5d>
 53e:	698d                	lui	s3,0x3
 540:	0399899b          	addiw	s3,s3,57 # 3039 <base+0x1029>
        if((x % 3) == 0) {
 544:	4a8d                	li	s5,3
          unlink("/testsymlink/y");
 546:	00001917          	auipc	s2,0x1
 54a:	94290913          	addi	s2,s2,-1726 # e88 <malloc+0x180>
          symlink("/testsymlink/z", "/testsymlink/y");
 54e:	00001b17          	auipc	s6,0x1
 552:	92ab0b13          	addi	s6,s6,-1750 # e78 <malloc+0x170>
            if(st.type != T_SYMLINK) {
 556:	4b91                	li	s7,4
 558:	a031                	j	564 <main+0x532>
          unlink("/testsymlink/y");
 55a:	854a                	mv	a0,s2
 55c:	328000ef          	jal	884 <unlink>
      for(i = 0; i < 100; i++){
 560:	34fd                	addiw	s1,s1,-1
 562:	c0b1                	beqz	s1,5a6 <main+0x574>
        x = x * 1103515245 + 12345;
 564:	034c07bb          	mulw	a5,s8,s4
 568:	013787bb          	addw	a5,a5,s3
 56c:	00078c1b          	sext.w	s8,a5
        if((x % 3) == 0) {
 570:	0357f7bb          	remuw	a5,a5,s5
 574:	2781                	sext.w	a5,a5
 576:	f3f5                	bnez	a5,55a <main+0x528>
          symlink("/testsymlink/z", "/testsymlink/y");
 578:	85ca                	mv	a1,s2
 57a:	855a                	mv	a0,s6
 57c:	358000ef          	jal	8d4 <symlink>
          if (stat_slink("/testsymlink/y", &st) == 0) {
 580:	f9840593          	addi	a1,s0,-104
 584:	854a                	mv	a0,s2
 586:	a7bff0ef          	jal	0 <stat_slink>
 58a:	f979                	bnez	a0,560 <main+0x52e>
            if(st.type != T_SYMLINK) {
 58c:	fa041583          	lh	a1,-96(s0)
 590:	fd7588e3          	beq	a1,s7,560 <main+0x52e>
              printf("FAILED: not a symbolic link %d\n", st.type);
 594:	00001517          	auipc	a0,0x1
 598:	ca450513          	addi	a0,a0,-860 # 1238 <malloc+0x530>
 59c:	6b8000ef          	jal	c54 <printf>
              exit(1);
 5a0:	4505                	li	a0,1
 5a2:	292000ef          	jal	834 <exit>
      exit(0);
 5a6:	4501                	li	a0,0
 5a8:	28c000ef          	jal	834 <exit>
 5ac:	ecce                	sd	s3,88(sp)
 5ae:	e8d2                	sd	s4,80(sp)
 5b0:	e4d6                	sd	s5,72(sp)
 5b2:	e0da                	sd	s6,64(sp)
 5b4:	fc5e                	sd	s7,56(sp)
 5b6:	f862                	sd	s8,48(sp)
      printf("test concurrent symlinks: failed\n");
 5b8:	00001517          	auipc	a0,0x1
 5bc:	ca050513          	addi	a0,a0,-864 # 1258 <malloc+0x550>
 5c0:	694000ef          	jal	c54 <printf>
      exit(1);
 5c4:	4505                	li	a0,1
 5c6:	26e000ef          	jal	834 <exit>

00000000000005ca <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 5ca:	1141                	addi	sp,sp,-16
 5cc:	e406                	sd	ra,8(sp)
 5ce:	e022                	sd	s0,0(sp)
 5d0:	0800                	addi	s0,sp,16
  extern int main();
  main();
 5d2:	a61ff0ef          	jal	32 <main>
  exit(0);
 5d6:	4501                	li	a0,0
 5d8:	25c000ef          	jal	834 <exit>

00000000000005dc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 5dc:	1141                	addi	sp,sp,-16
 5de:	e422                	sd	s0,8(sp)
 5e0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 5e2:	87aa                	mv	a5,a0
 5e4:	0585                	addi	a1,a1,1
 5e6:	0785                	addi	a5,a5,1
 5e8:	fff5c703          	lbu	a4,-1(a1)
 5ec:	fee78fa3          	sb	a4,-1(a5)
 5f0:	fb75                	bnez	a4,5e4 <strcpy+0x8>
    ;
  return os;
}
 5f2:	6422                	ld	s0,8(sp)
 5f4:	0141                	addi	sp,sp,16
 5f6:	8082                	ret

00000000000005f8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 5f8:	1141                	addi	sp,sp,-16
 5fa:	e422                	sd	s0,8(sp)
 5fc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 5fe:	00054783          	lbu	a5,0(a0)
 602:	cb91                	beqz	a5,616 <strcmp+0x1e>
 604:	0005c703          	lbu	a4,0(a1)
 608:	00f71763          	bne	a4,a5,616 <strcmp+0x1e>
    p++, q++;
 60c:	0505                	addi	a0,a0,1
 60e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 610:	00054783          	lbu	a5,0(a0)
 614:	fbe5                	bnez	a5,604 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 616:	0005c503          	lbu	a0,0(a1)
}
 61a:	40a7853b          	subw	a0,a5,a0
 61e:	6422                	ld	s0,8(sp)
 620:	0141                	addi	sp,sp,16
 622:	8082                	ret

0000000000000624 <strlen>:

uint
strlen(const char *s)
{
 624:	1141                	addi	sp,sp,-16
 626:	e422                	sd	s0,8(sp)
 628:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 62a:	00054783          	lbu	a5,0(a0)
 62e:	cf91                	beqz	a5,64a <strlen+0x26>
 630:	0505                	addi	a0,a0,1
 632:	87aa                	mv	a5,a0
 634:	86be                	mv	a3,a5
 636:	0785                	addi	a5,a5,1
 638:	fff7c703          	lbu	a4,-1(a5)
 63c:	ff65                	bnez	a4,634 <strlen+0x10>
 63e:	40a6853b          	subw	a0,a3,a0
 642:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 644:	6422                	ld	s0,8(sp)
 646:	0141                	addi	sp,sp,16
 648:	8082                	ret
  for(n = 0; s[n]; n++)
 64a:	4501                	li	a0,0
 64c:	bfe5                	j	644 <strlen+0x20>

000000000000064e <memset>:

void*
memset(void *dst, int c, uint n)
{
 64e:	1141                	addi	sp,sp,-16
 650:	e422                	sd	s0,8(sp)
 652:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 654:	ca19                	beqz	a2,66a <memset+0x1c>
 656:	87aa                	mv	a5,a0
 658:	1602                	slli	a2,a2,0x20
 65a:	9201                	srli	a2,a2,0x20
 65c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 660:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 664:	0785                	addi	a5,a5,1
 666:	fee79de3          	bne	a5,a4,660 <memset+0x12>
  }
  return dst;
}
 66a:	6422                	ld	s0,8(sp)
 66c:	0141                	addi	sp,sp,16
 66e:	8082                	ret

0000000000000670 <strchr>:

char*
strchr(const char *s, char c)
{
 670:	1141                	addi	sp,sp,-16
 672:	e422                	sd	s0,8(sp)
 674:	0800                	addi	s0,sp,16
  for(; *s; s++)
 676:	00054783          	lbu	a5,0(a0)
 67a:	cb99                	beqz	a5,690 <strchr+0x20>
    if(*s == c)
 67c:	00f58763          	beq	a1,a5,68a <strchr+0x1a>
  for(; *s; s++)
 680:	0505                	addi	a0,a0,1
 682:	00054783          	lbu	a5,0(a0)
 686:	fbfd                	bnez	a5,67c <strchr+0xc>
      return (char*)s;
  return 0;
 688:	4501                	li	a0,0
}
 68a:	6422                	ld	s0,8(sp)
 68c:	0141                	addi	sp,sp,16
 68e:	8082                	ret
  return 0;
 690:	4501                	li	a0,0
 692:	bfe5                	j	68a <strchr+0x1a>

0000000000000694 <gets>:

char*
gets(char *buf, int max)
{
 694:	711d                	addi	sp,sp,-96
 696:	ec86                	sd	ra,88(sp)
 698:	e8a2                	sd	s0,80(sp)
 69a:	e4a6                	sd	s1,72(sp)
 69c:	e0ca                	sd	s2,64(sp)
 69e:	fc4e                	sd	s3,56(sp)
 6a0:	f852                	sd	s4,48(sp)
 6a2:	f456                	sd	s5,40(sp)
 6a4:	f05a                	sd	s6,32(sp)
 6a6:	ec5e                	sd	s7,24(sp)
 6a8:	1080                	addi	s0,sp,96
 6aa:	8baa                	mv	s7,a0
 6ac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6ae:	892a                	mv	s2,a0
 6b0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 6b2:	4aa9                	li	s5,10
 6b4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 6b6:	89a6                	mv	s3,s1
 6b8:	2485                	addiw	s1,s1,1
 6ba:	0344d663          	bge	s1,s4,6e6 <gets+0x52>
    cc = read(0, &c, 1);
 6be:	4605                	li	a2,1
 6c0:	faf40593          	addi	a1,s0,-81
 6c4:	4501                	li	a0,0
 6c6:	186000ef          	jal	84c <read>
    if(cc < 1)
 6ca:	00a05e63          	blez	a0,6e6 <gets+0x52>
    buf[i++] = c;
 6ce:	faf44783          	lbu	a5,-81(s0)
 6d2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 6d6:	01578763          	beq	a5,s5,6e4 <gets+0x50>
 6da:	0905                	addi	s2,s2,1
 6dc:	fd679de3          	bne	a5,s6,6b6 <gets+0x22>
    buf[i++] = c;
 6e0:	89a6                	mv	s3,s1
 6e2:	a011                	j	6e6 <gets+0x52>
 6e4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 6e6:	99de                	add	s3,s3,s7
 6e8:	00098023          	sb	zero,0(s3)
  return buf;
}
 6ec:	855e                	mv	a0,s7
 6ee:	60e6                	ld	ra,88(sp)
 6f0:	6446                	ld	s0,80(sp)
 6f2:	64a6                	ld	s1,72(sp)
 6f4:	6906                	ld	s2,64(sp)
 6f6:	79e2                	ld	s3,56(sp)
 6f8:	7a42                	ld	s4,48(sp)
 6fa:	7aa2                	ld	s5,40(sp)
 6fc:	7b02                	ld	s6,32(sp)
 6fe:	6be2                	ld	s7,24(sp)
 700:	6125                	addi	sp,sp,96
 702:	8082                	ret

0000000000000704 <stat>:

int
stat(const char *n, struct stat *st)
{
 704:	1101                	addi	sp,sp,-32
 706:	ec06                	sd	ra,24(sp)
 708:	e822                	sd	s0,16(sp)
 70a:	e04a                	sd	s2,0(sp)
 70c:	1000                	addi	s0,sp,32
 70e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 710:	4581                	li	a1,0
 712:	162000ef          	jal	874 <open>
  if(fd < 0)
 716:	02054263          	bltz	a0,73a <stat+0x36>
 71a:	e426                	sd	s1,8(sp)
 71c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 71e:	85ca                	mv	a1,s2
 720:	16c000ef          	jal	88c <fstat>
 724:	892a                	mv	s2,a0
  close(fd);
 726:	8526                	mv	a0,s1
 728:	134000ef          	jal	85c <close>
  return r;
 72c:	64a2                	ld	s1,8(sp)
}
 72e:	854a                	mv	a0,s2
 730:	60e2                	ld	ra,24(sp)
 732:	6442                	ld	s0,16(sp)
 734:	6902                	ld	s2,0(sp)
 736:	6105                	addi	sp,sp,32
 738:	8082                	ret
    return -1;
 73a:	597d                	li	s2,-1
 73c:	bfcd                	j	72e <stat+0x2a>

000000000000073e <atoi>:

int
atoi(const char *s)
{
 73e:	1141                	addi	sp,sp,-16
 740:	e422                	sd	s0,8(sp)
 742:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 744:	00054683          	lbu	a3,0(a0)
 748:	fd06879b          	addiw	a5,a3,-48
 74c:	0ff7f793          	zext.b	a5,a5
 750:	4625                	li	a2,9
 752:	02f66863          	bltu	a2,a5,782 <atoi+0x44>
 756:	872a                	mv	a4,a0
  n = 0;
 758:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 75a:	0705                	addi	a4,a4,1
 75c:	0025179b          	slliw	a5,a0,0x2
 760:	9fa9                	addw	a5,a5,a0
 762:	0017979b          	slliw	a5,a5,0x1
 766:	9fb5                	addw	a5,a5,a3
 768:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 76c:	00074683          	lbu	a3,0(a4)
 770:	fd06879b          	addiw	a5,a3,-48
 774:	0ff7f793          	zext.b	a5,a5
 778:	fef671e3          	bgeu	a2,a5,75a <atoi+0x1c>
  return n;
}
 77c:	6422                	ld	s0,8(sp)
 77e:	0141                	addi	sp,sp,16
 780:	8082                	ret
  n = 0;
 782:	4501                	li	a0,0
 784:	bfe5                	j	77c <atoi+0x3e>

0000000000000786 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 786:	1141                	addi	sp,sp,-16
 788:	e422                	sd	s0,8(sp)
 78a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 78c:	02b57463          	bgeu	a0,a1,7b4 <memmove+0x2e>
    while(n-- > 0)
 790:	00c05f63          	blez	a2,7ae <memmove+0x28>
 794:	1602                	slli	a2,a2,0x20
 796:	9201                	srli	a2,a2,0x20
 798:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 79c:	872a                	mv	a4,a0
      *dst++ = *src++;
 79e:	0585                	addi	a1,a1,1
 7a0:	0705                	addi	a4,a4,1
 7a2:	fff5c683          	lbu	a3,-1(a1)
 7a6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 7aa:	fef71ae3          	bne	a4,a5,79e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 7ae:	6422                	ld	s0,8(sp)
 7b0:	0141                	addi	sp,sp,16
 7b2:	8082                	ret
    dst += n;
 7b4:	00c50733          	add	a4,a0,a2
    src += n;
 7b8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 7ba:	fec05ae3          	blez	a2,7ae <memmove+0x28>
 7be:	fff6079b          	addiw	a5,a2,-1
 7c2:	1782                	slli	a5,a5,0x20
 7c4:	9381                	srli	a5,a5,0x20
 7c6:	fff7c793          	not	a5,a5
 7ca:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 7cc:	15fd                	addi	a1,a1,-1
 7ce:	177d                	addi	a4,a4,-1
 7d0:	0005c683          	lbu	a3,0(a1)
 7d4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 7d8:	fee79ae3          	bne	a5,a4,7cc <memmove+0x46>
 7dc:	bfc9                	j	7ae <memmove+0x28>

00000000000007de <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 7de:	1141                	addi	sp,sp,-16
 7e0:	e422                	sd	s0,8(sp)
 7e2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 7e4:	ca05                	beqz	a2,814 <memcmp+0x36>
 7e6:	fff6069b          	addiw	a3,a2,-1
 7ea:	1682                	slli	a3,a3,0x20
 7ec:	9281                	srli	a3,a3,0x20
 7ee:	0685                	addi	a3,a3,1
 7f0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 7f2:	00054783          	lbu	a5,0(a0)
 7f6:	0005c703          	lbu	a4,0(a1)
 7fa:	00e79863          	bne	a5,a4,80a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 7fe:	0505                	addi	a0,a0,1
    p2++;
 800:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 802:	fed518e3          	bne	a0,a3,7f2 <memcmp+0x14>
  }
  return 0;
 806:	4501                	li	a0,0
 808:	a019                	j	80e <memcmp+0x30>
      return *p1 - *p2;
 80a:	40e7853b          	subw	a0,a5,a4
}
 80e:	6422                	ld	s0,8(sp)
 810:	0141                	addi	sp,sp,16
 812:	8082                	ret
  return 0;
 814:	4501                	li	a0,0
 816:	bfe5                	j	80e <memcmp+0x30>

0000000000000818 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 818:	1141                	addi	sp,sp,-16
 81a:	e406                	sd	ra,8(sp)
 81c:	e022                	sd	s0,0(sp)
 81e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 820:	f67ff0ef          	jal	786 <memmove>
}
 824:	60a2                	ld	ra,8(sp)
 826:	6402                	ld	s0,0(sp)
 828:	0141                	addi	sp,sp,16
 82a:	8082                	ret

000000000000082c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 82c:	4885                	li	a7,1
 ecall
 82e:	00000073          	ecall
 ret
 832:	8082                	ret

0000000000000834 <exit>:
.global exit
exit:
 li a7, SYS_exit
 834:	4889                	li	a7,2
 ecall
 836:	00000073          	ecall
 ret
 83a:	8082                	ret

000000000000083c <wait>:
.global wait
wait:
 li a7, SYS_wait
 83c:	488d                	li	a7,3
 ecall
 83e:	00000073          	ecall
 ret
 842:	8082                	ret

0000000000000844 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 844:	4891                	li	a7,4
 ecall
 846:	00000073          	ecall
 ret
 84a:	8082                	ret

000000000000084c <read>:
.global read
read:
 li a7, SYS_read
 84c:	4895                	li	a7,5
 ecall
 84e:	00000073          	ecall
 ret
 852:	8082                	ret

0000000000000854 <write>:
.global write
write:
 li a7, SYS_write
 854:	48c1                	li	a7,16
 ecall
 856:	00000073          	ecall
 ret
 85a:	8082                	ret

000000000000085c <close>:
.global close
close:
 li a7, SYS_close
 85c:	48d5                	li	a7,21
 ecall
 85e:	00000073          	ecall
 ret
 862:	8082                	ret

0000000000000864 <kill>:
.global kill
kill:
 li a7, SYS_kill
 864:	4899                	li	a7,6
 ecall
 866:	00000073          	ecall
 ret
 86a:	8082                	ret

000000000000086c <exec>:
.global exec
exec:
 li a7, SYS_exec
 86c:	489d                	li	a7,7
 ecall
 86e:	00000073          	ecall
 ret
 872:	8082                	ret

0000000000000874 <open>:
.global open
open:
 li a7, SYS_open
 874:	48bd                	li	a7,15
 ecall
 876:	00000073          	ecall
 ret
 87a:	8082                	ret

000000000000087c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 87c:	48c5                	li	a7,17
 ecall
 87e:	00000073          	ecall
 ret
 882:	8082                	ret

0000000000000884 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 884:	48c9                	li	a7,18
 ecall
 886:	00000073          	ecall
 ret
 88a:	8082                	ret

000000000000088c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 88c:	48a1                	li	a7,8
 ecall
 88e:	00000073          	ecall
 ret
 892:	8082                	ret

0000000000000894 <link>:
.global link
link:
 li a7, SYS_link
 894:	48cd                	li	a7,19
 ecall
 896:	00000073          	ecall
 ret
 89a:	8082                	ret

000000000000089c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 89c:	48d1                	li	a7,20
 ecall
 89e:	00000073          	ecall
 ret
 8a2:	8082                	ret

00000000000008a4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 8a4:	48a5                	li	a7,9
 ecall
 8a6:	00000073          	ecall
 ret
 8aa:	8082                	ret

00000000000008ac <dup>:
.global dup
dup:
 li a7, SYS_dup
 8ac:	48a9                	li	a7,10
 ecall
 8ae:	00000073          	ecall
 ret
 8b2:	8082                	ret

00000000000008b4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 8b4:	48ad                	li	a7,11
 ecall
 8b6:	00000073          	ecall
 ret
 8ba:	8082                	ret

00000000000008bc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 8bc:	48b1                	li	a7,12
 ecall
 8be:	00000073          	ecall
 ret
 8c2:	8082                	ret

00000000000008c4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 8c4:	48b5                	li	a7,13
 ecall
 8c6:	00000073          	ecall
 ret
 8ca:	8082                	ret

00000000000008cc <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 8cc:	48b9                	li	a7,14
 ecall
 8ce:	00000073          	ecall
 ret
 8d2:	8082                	ret

00000000000008d4 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 8d4:	48d9                	li	a7,22
 ecall
 8d6:	00000073          	ecall
 ret
 8da:	8082                	ret

00000000000008dc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 8dc:	1101                	addi	sp,sp,-32
 8de:	ec06                	sd	ra,24(sp)
 8e0:	e822                	sd	s0,16(sp)
 8e2:	1000                	addi	s0,sp,32
 8e4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 8e8:	4605                	li	a2,1
 8ea:	fef40593          	addi	a1,s0,-17
 8ee:	f67ff0ef          	jal	854 <write>
}
 8f2:	60e2                	ld	ra,24(sp)
 8f4:	6442                	ld	s0,16(sp)
 8f6:	6105                	addi	sp,sp,32
 8f8:	8082                	ret

00000000000008fa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8fa:	7139                	addi	sp,sp,-64
 8fc:	fc06                	sd	ra,56(sp)
 8fe:	f822                	sd	s0,48(sp)
 900:	f426                	sd	s1,40(sp)
 902:	0080                	addi	s0,sp,64
 904:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 906:	c299                	beqz	a3,90c <printint+0x12>
 908:	0805c963          	bltz	a1,99a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 90c:	2581                	sext.w	a1,a1
  neg = 0;
 90e:	4881                	li	a7,0
 910:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 914:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 916:	2601                	sext.w	a2,a2
 918:	00001517          	auipc	a0,0x1
 91c:	99050513          	addi	a0,a0,-1648 # 12a8 <digits>
 920:	883a                	mv	a6,a4
 922:	2705                	addiw	a4,a4,1
 924:	02c5f7bb          	remuw	a5,a1,a2
 928:	1782                	slli	a5,a5,0x20
 92a:	9381                	srli	a5,a5,0x20
 92c:	97aa                	add	a5,a5,a0
 92e:	0007c783          	lbu	a5,0(a5)
 932:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 936:	0005879b          	sext.w	a5,a1
 93a:	02c5d5bb          	divuw	a1,a1,a2
 93e:	0685                	addi	a3,a3,1
 940:	fec7f0e3          	bgeu	a5,a2,920 <printint+0x26>
  if(neg)
 944:	00088c63          	beqz	a7,95c <printint+0x62>
    buf[i++] = '-';
 948:	fd070793          	addi	a5,a4,-48
 94c:	00878733          	add	a4,a5,s0
 950:	02d00793          	li	a5,45
 954:	fef70823          	sb	a5,-16(a4)
 958:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 95c:	02e05a63          	blez	a4,990 <printint+0x96>
 960:	f04a                	sd	s2,32(sp)
 962:	ec4e                	sd	s3,24(sp)
 964:	fc040793          	addi	a5,s0,-64
 968:	00e78933          	add	s2,a5,a4
 96c:	fff78993          	addi	s3,a5,-1
 970:	99ba                	add	s3,s3,a4
 972:	377d                	addiw	a4,a4,-1
 974:	1702                	slli	a4,a4,0x20
 976:	9301                	srli	a4,a4,0x20
 978:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 97c:	fff94583          	lbu	a1,-1(s2)
 980:	8526                	mv	a0,s1
 982:	f5bff0ef          	jal	8dc <putc>
  while(--i >= 0)
 986:	197d                	addi	s2,s2,-1
 988:	ff391ae3          	bne	s2,s3,97c <printint+0x82>
 98c:	7902                	ld	s2,32(sp)
 98e:	69e2                	ld	s3,24(sp)
}
 990:	70e2                	ld	ra,56(sp)
 992:	7442                	ld	s0,48(sp)
 994:	74a2                	ld	s1,40(sp)
 996:	6121                	addi	sp,sp,64
 998:	8082                	ret
    x = -xx;
 99a:	40b005bb          	negw	a1,a1
    neg = 1;
 99e:	4885                	li	a7,1
    x = -xx;
 9a0:	bf85                	j	910 <printint+0x16>

00000000000009a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 9a2:	711d                	addi	sp,sp,-96
 9a4:	ec86                	sd	ra,88(sp)
 9a6:	e8a2                	sd	s0,80(sp)
 9a8:	e0ca                	sd	s2,64(sp)
 9aa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 9ac:	0005c903          	lbu	s2,0(a1)
 9b0:	26090863          	beqz	s2,c20 <vprintf+0x27e>
 9b4:	e4a6                	sd	s1,72(sp)
 9b6:	fc4e                	sd	s3,56(sp)
 9b8:	f852                	sd	s4,48(sp)
 9ba:	f456                	sd	s5,40(sp)
 9bc:	f05a                	sd	s6,32(sp)
 9be:	ec5e                	sd	s7,24(sp)
 9c0:	e862                	sd	s8,16(sp)
 9c2:	e466                	sd	s9,8(sp)
 9c4:	8b2a                	mv	s6,a0
 9c6:	8a2e                	mv	s4,a1
 9c8:	8bb2                	mv	s7,a2
  state = 0;
 9ca:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 9cc:	4481                	li	s1,0
 9ce:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 9d0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 9d4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 9d8:	06c00c93          	li	s9,108
 9dc:	a005                	j	9fc <vprintf+0x5a>
        putc(fd, c0);
 9de:	85ca                	mv	a1,s2
 9e0:	855a                	mv	a0,s6
 9e2:	efbff0ef          	jal	8dc <putc>
 9e6:	a019                	j	9ec <vprintf+0x4a>
    } else if(state == '%'){
 9e8:	03598263          	beq	s3,s5,a0c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 9ec:	2485                	addiw	s1,s1,1
 9ee:	8726                	mv	a4,s1
 9f0:	009a07b3          	add	a5,s4,s1
 9f4:	0007c903          	lbu	s2,0(a5)
 9f8:	20090c63          	beqz	s2,c10 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 9fc:	0009079b          	sext.w	a5,s2
    if(state == 0){
 a00:	fe0994e3          	bnez	s3,9e8 <vprintf+0x46>
      if(c0 == '%'){
 a04:	fd579de3          	bne	a5,s5,9de <vprintf+0x3c>
        state = '%';
 a08:	89be                	mv	s3,a5
 a0a:	b7cd                	j	9ec <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 a0c:	00ea06b3          	add	a3,s4,a4
 a10:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 a14:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 a16:	c681                	beqz	a3,a1e <vprintf+0x7c>
 a18:	9752                	add	a4,a4,s4
 a1a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 a1e:	03878f63          	beq	a5,s8,a5c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 a22:	05978963          	beq	a5,s9,a74 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 a26:	07500713          	li	a4,117
 a2a:	0ee78363          	beq	a5,a4,b10 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 a2e:	07800713          	li	a4,120
 a32:	12e78563          	beq	a5,a4,b5c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 a36:	07000713          	li	a4,112
 a3a:	14e78a63          	beq	a5,a4,b8e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 a3e:	07300713          	li	a4,115
 a42:	18e78a63          	beq	a5,a4,bd6 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 a46:	02500713          	li	a4,37
 a4a:	04e79563          	bne	a5,a4,a94 <vprintf+0xf2>
        putc(fd, '%');
 a4e:	02500593          	li	a1,37
 a52:	855a                	mv	a0,s6
 a54:	e89ff0ef          	jal	8dc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 a58:	4981                	li	s3,0
 a5a:	bf49                	j	9ec <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 a5c:	008b8913          	addi	s2,s7,8
 a60:	4685                	li	a3,1
 a62:	4629                	li	a2,10
 a64:	000ba583          	lw	a1,0(s7)
 a68:	855a                	mv	a0,s6
 a6a:	e91ff0ef          	jal	8fa <printint>
 a6e:	8bca                	mv	s7,s2
      state = 0;
 a70:	4981                	li	s3,0
 a72:	bfad                	j	9ec <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 a74:	06400793          	li	a5,100
 a78:	02f68963          	beq	a3,a5,aaa <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a7c:	06c00793          	li	a5,108
 a80:	04f68263          	beq	a3,a5,ac4 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 a84:	07500793          	li	a5,117
 a88:	0af68063          	beq	a3,a5,b28 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 a8c:	07800793          	li	a5,120
 a90:	0ef68263          	beq	a3,a5,b74 <vprintf+0x1d2>
        putc(fd, '%');
 a94:	02500593          	li	a1,37
 a98:	855a                	mv	a0,s6
 a9a:	e43ff0ef          	jal	8dc <putc>
        putc(fd, c0);
 a9e:	85ca                	mv	a1,s2
 aa0:	855a                	mv	a0,s6
 aa2:	e3bff0ef          	jal	8dc <putc>
      state = 0;
 aa6:	4981                	li	s3,0
 aa8:	b791                	j	9ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 aaa:	008b8913          	addi	s2,s7,8
 aae:	4685                	li	a3,1
 ab0:	4629                	li	a2,10
 ab2:	000ba583          	lw	a1,0(s7)
 ab6:	855a                	mv	a0,s6
 ab8:	e43ff0ef          	jal	8fa <printint>
        i += 1;
 abc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 abe:	8bca                	mv	s7,s2
      state = 0;
 ac0:	4981                	li	s3,0
        i += 1;
 ac2:	b72d                	j	9ec <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 ac4:	06400793          	li	a5,100
 ac8:	02f60763          	beq	a2,a5,af6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 acc:	07500793          	li	a5,117
 ad0:	06f60963          	beq	a2,a5,b42 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 ad4:	07800793          	li	a5,120
 ad8:	faf61ee3          	bne	a2,a5,a94 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 adc:	008b8913          	addi	s2,s7,8
 ae0:	4681                	li	a3,0
 ae2:	4641                	li	a2,16
 ae4:	000ba583          	lw	a1,0(s7)
 ae8:	855a                	mv	a0,s6
 aea:	e11ff0ef          	jal	8fa <printint>
        i += 2;
 aee:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 af0:	8bca                	mv	s7,s2
      state = 0;
 af2:	4981                	li	s3,0
        i += 2;
 af4:	bde5                	j	9ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 af6:	008b8913          	addi	s2,s7,8
 afa:	4685                	li	a3,1
 afc:	4629                	li	a2,10
 afe:	000ba583          	lw	a1,0(s7)
 b02:	855a                	mv	a0,s6
 b04:	df7ff0ef          	jal	8fa <printint>
        i += 2;
 b08:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 b0a:	8bca                	mv	s7,s2
      state = 0;
 b0c:	4981                	li	s3,0
        i += 2;
 b0e:	bdf9                	j	9ec <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 b10:	008b8913          	addi	s2,s7,8
 b14:	4681                	li	a3,0
 b16:	4629                	li	a2,10
 b18:	000ba583          	lw	a1,0(s7)
 b1c:	855a                	mv	a0,s6
 b1e:	dddff0ef          	jal	8fa <printint>
 b22:	8bca                	mv	s7,s2
      state = 0;
 b24:	4981                	li	s3,0
 b26:	b5d9                	j	9ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b28:	008b8913          	addi	s2,s7,8
 b2c:	4681                	li	a3,0
 b2e:	4629                	li	a2,10
 b30:	000ba583          	lw	a1,0(s7)
 b34:	855a                	mv	a0,s6
 b36:	dc5ff0ef          	jal	8fa <printint>
        i += 1;
 b3a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 b3c:	8bca                	mv	s7,s2
      state = 0;
 b3e:	4981                	li	s3,0
        i += 1;
 b40:	b575                	j	9ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b42:	008b8913          	addi	s2,s7,8
 b46:	4681                	li	a3,0
 b48:	4629                	li	a2,10
 b4a:	000ba583          	lw	a1,0(s7)
 b4e:	855a                	mv	a0,s6
 b50:	dabff0ef          	jal	8fa <printint>
        i += 2;
 b54:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 b56:	8bca                	mv	s7,s2
      state = 0;
 b58:	4981                	li	s3,0
        i += 2;
 b5a:	bd49                	j	9ec <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 b5c:	008b8913          	addi	s2,s7,8
 b60:	4681                	li	a3,0
 b62:	4641                	li	a2,16
 b64:	000ba583          	lw	a1,0(s7)
 b68:	855a                	mv	a0,s6
 b6a:	d91ff0ef          	jal	8fa <printint>
 b6e:	8bca                	mv	s7,s2
      state = 0;
 b70:	4981                	li	s3,0
 b72:	bdad                	j	9ec <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 b74:	008b8913          	addi	s2,s7,8
 b78:	4681                	li	a3,0
 b7a:	4641                	li	a2,16
 b7c:	000ba583          	lw	a1,0(s7)
 b80:	855a                	mv	a0,s6
 b82:	d79ff0ef          	jal	8fa <printint>
        i += 1;
 b86:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 b88:	8bca                	mv	s7,s2
      state = 0;
 b8a:	4981                	li	s3,0
        i += 1;
 b8c:	b585                	j	9ec <vprintf+0x4a>
 b8e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 b90:	008b8d13          	addi	s10,s7,8
 b94:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b98:	03000593          	li	a1,48
 b9c:	855a                	mv	a0,s6
 b9e:	d3fff0ef          	jal	8dc <putc>
  putc(fd, 'x');
 ba2:	07800593          	li	a1,120
 ba6:	855a                	mv	a0,s6
 ba8:	d35ff0ef          	jal	8dc <putc>
 bac:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bae:	00000b97          	auipc	s7,0x0
 bb2:	6fab8b93          	addi	s7,s7,1786 # 12a8 <digits>
 bb6:	03c9d793          	srli	a5,s3,0x3c
 bba:	97de                	add	a5,a5,s7
 bbc:	0007c583          	lbu	a1,0(a5)
 bc0:	855a                	mv	a0,s6
 bc2:	d1bff0ef          	jal	8dc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 bc6:	0992                	slli	s3,s3,0x4
 bc8:	397d                	addiw	s2,s2,-1
 bca:	fe0916e3          	bnez	s2,bb6 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 bce:	8bea                	mv	s7,s10
      state = 0;
 bd0:	4981                	li	s3,0
 bd2:	6d02                	ld	s10,0(sp)
 bd4:	bd21                	j	9ec <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 bd6:	008b8993          	addi	s3,s7,8
 bda:	000bb903          	ld	s2,0(s7)
 bde:	00090f63          	beqz	s2,bfc <vprintf+0x25a>
        for(; *s; s++)
 be2:	00094583          	lbu	a1,0(s2)
 be6:	c195                	beqz	a1,c0a <vprintf+0x268>
          putc(fd, *s);
 be8:	855a                	mv	a0,s6
 bea:	cf3ff0ef          	jal	8dc <putc>
        for(; *s; s++)
 bee:	0905                	addi	s2,s2,1
 bf0:	00094583          	lbu	a1,0(s2)
 bf4:	f9f5                	bnez	a1,be8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 bf6:	8bce                	mv	s7,s3
      state = 0;
 bf8:	4981                	li	s3,0
 bfa:	bbcd                	j	9ec <vprintf+0x4a>
          s = "(null)";
 bfc:	00000917          	auipc	s2,0x0
 c00:	6a490913          	addi	s2,s2,1700 # 12a0 <malloc+0x598>
        for(; *s; s++)
 c04:	02800593          	li	a1,40
 c08:	b7c5                	j	be8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 c0a:	8bce                	mv	s7,s3
      state = 0;
 c0c:	4981                	li	s3,0
 c0e:	bbf9                	j	9ec <vprintf+0x4a>
 c10:	64a6                	ld	s1,72(sp)
 c12:	79e2                	ld	s3,56(sp)
 c14:	7a42                	ld	s4,48(sp)
 c16:	7aa2                	ld	s5,40(sp)
 c18:	7b02                	ld	s6,32(sp)
 c1a:	6be2                	ld	s7,24(sp)
 c1c:	6c42                	ld	s8,16(sp)
 c1e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 c20:	60e6                	ld	ra,88(sp)
 c22:	6446                	ld	s0,80(sp)
 c24:	6906                	ld	s2,64(sp)
 c26:	6125                	addi	sp,sp,96
 c28:	8082                	ret

0000000000000c2a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c2a:	715d                	addi	sp,sp,-80
 c2c:	ec06                	sd	ra,24(sp)
 c2e:	e822                	sd	s0,16(sp)
 c30:	1000                	addi	s0,sp,32
 c32:	e010                	sd	a2,0(s0)
 c34:	e414                	sd	a3,8(s0)
 c36:	e818                	sd	a4,16(s0)
 c38:	ec1c                	sd	a5,24(s0)
 c3a:	03043023          	sd	a6,32(s0)
 c3e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c42:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c46:	8622                	mv	a2,s0
 c48:	d5bff0ef          	jal	9a2 <vprintf>
}
 c4c:	60e2                	ld	ra,24(sp)
 c4e:	6442                	ld	s0,16(sp)
 c50:	6161                	addi	sp,sp,80
 c52:	8082                	ret

0000000000000c54 <printf>:

void
printf(const char *fmt, ...)
{
 c54:	711d                	addi	sp,sp,-96
 c56:	ec06                	sd	ra,24(sp)
 c58:	e822                	sd	s0,16(sp)
 c5a:	1000                	addi	s0,sp,32
 c5c:	e40c                	sd	a1,8(s0)
 c5e:	e810                	sd	a2,16(s0)
 c60:	ec14                	sd	a3,24(s0)
 c62:	f018                	sd	a4,32(s0)
 c64:	f41c                	sd	a5,40(s0)
 c66:	03043823          	sd	a6,48(s0)
 c6a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c6e:	00840613          	addi	a2,s0,8
 c72:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c76:	85aa                	mv	a1,a0
 c78:	4505                	li	a0,1
 c7a:	d29ff0ef          	jal	9a2 <vprintf>
}
 c7e:	60e2                	ld	ra,24(sp)
 c80:	6442                	ld	s0,16(sp)
 c82:	6125                	addi	sp,sp,96
 c84:	8082                	ret

0000000000000c86 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c86:	1141                	addi	sp,sp,-16
 c88:	e422                	sd	s0,8(sp)
 c8a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c8c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c90:	00001797          	auipc	a5,0x1
 c94:	3787b783          	ld	a5,888(a5) # 2008 <freep>
 c98:	a02d                	j	cc2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 c9a:	4618                	lw	a4,8(a2)
 c9c:	9f2d                	addw	a4,a4,a1
 c9e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ca2:	6398                	ld	a4,0(a5)
 ca4:	6310                	ld	a2,0(a4)
 ca6:	a83d                	j	ce4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 ca8:	ff852703          	lw	a4,-8(a0)
 cac:	9f31                	addw	a4,a4,a2
 cae:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 cb0:	ff053683          	ld	a3,-16(a0)
 cb4:	a091                	j	cf8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cb6:	6398                	ld	a4,0(a5)
 cb8:	00e7e463          	bltu	a5,a4,cc0 <free+0x3a>
 cbc:	00e6ea63          	bltu	a3,a4,cd0 <free+0x4a>
{
 cc0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cc2:	fed7fae3          	bgeu	a5,a3,cb6 <free+0x30>
 cc6:	6398                	ld	a4,0(a5)
 cc8:	00e6e463          	bltu	a3,a4,cd0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ccc:	fee7eae3          	bltu	a5,a4,cc0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 cd0:	ff852583          	lw	a1,-8(a0)
 cd4:	6390                	ld	a2,0(a5)
 cd6:	02059813          	slli	a6,a1,0x20
 cda:	01c85713          	srli	a4,a6,0x1c
 cde:	9736                	add	a4,a4,a3
 ce0:	fae60de3          	beq	a2,a4,c9a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 ce4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 ce8:	4790                	lw	a2,8(a5)
 cea:	02061593          	slli	a1,a2,0x20
 cee:	01c5d713          	srli	a4,a1,0x1c
 cf2:	973e                	add	a4,a4,a5
 cf4:	fae68ae3          	beq	a3,a4,ca8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 cf8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 cfa:	00001717          	auipc	a4,0x1
 cfe:	30f73723          	sd	a5,782(a4) # 2008 <freep>
}
 d02:	6422                	ld	s0,8(sp)
 d04:	0141                	addi	sp,sp,16
 d06:	8082                	ret

0000000000000d08 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d08:	7139                	addi	sp,sp,-64
 d0a:	fc06                	sd	ra,56(sp)
 d0c:	f822                	sd	s0,48(sp)
 d0e:	f426                	sd	s1,40(sp)
 d10:	ec4e                	sd	s3,24(sp)
 d12:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d14:	02051493          	slli	s1,a0,0x20
 d18:	9081                	srli	s1,s1,0x20
 d1a:	04bd                	addi	s1,s1,15
 d1c:	8091                	srli	s1,s1,0x4
 d1e:	0014899b          	addiw	s3,s1,1
 d22:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 d24:	00001517          	auipc	a0,0x1
 d28:	2e453503          	ld	a0,740(a0) # 2008 <freep>
 d2c:	c915                	beqz	a0,d60 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d2e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d30:	4798                	lw	a4,8(a5)
 d32:	08977a63          	bgeu	a4,s1,dc6 <malloc+0xbe>
 d36:	f04a                	sd	s2,32(sp)
 d38:	e852                	sd	s4,16(sp)
 d3a:	e456                	sd	s5,8(sp)
 d3c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 d3e:	8a4e                	mv	s4,s3
 d40:	0009871b          	sext.w	a4,s3
 d44:	6685                	lui	a3,0x1
 d46:	00d77363          	bgeu	a4,a3,d4c <malloc+0x44>
 d4a:	6a05                	lui	s4,0x1
 d4c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d50:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d54:	00001917          	auipc	s2,0x1
 d58:	2b490913          	addi	s2,s2,692 # 2008 <freep>
  if(p == (char*)-1)
 d5c:	5afd                	li	s5,-1
 d5e:	a081                	j	d9e <malloc+0x96>
 d60:	f04a                	sd	s2,32(sp)
 d62:	e852                	sd	s4,16(sp)
 d64:	e456                	sd	s5,8(sp)
 d66:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 d68:	00001797          	auipc	a5,0x1
 d6c:	2a878793          	addi	a5,a5,680 # 2010 <base>
 d70:	00001717          	auipc	a4,0x1
 d74:	28f73c23          	sd	a5,664(a4) # 2008 <freep>
 d78:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 d7a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 d7e:	b7c1                	j	d3e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 d80:	6398                	ld	a4,0(a5)
 d82:	e118                	sd	a4,0(a0)
 d84:	a8a9                	j	dde <malloc+0xd6>
  hp->s.size = nu;
 d86:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d8a:	0541                	addi	a0,a0,16
 d8c:	efbff0ef          	jal	c86 <free>
  return freep;
 d90:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 d94:	c12d                	beqz	a0,df6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d96:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d98:	4798                	lw	a4,8(a5)
 d9a:	02977263          	bgeu	a4,s1,dbe <malloc+0xb6>
    if(p == freep)
 d9e:	00093703          	ld	a4,0(s2)
 da2:	853e                	mv	a0,a5
 da4:	fef719e3          	bne	a4,a5,d96 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 da8:	8552                	mv	a0,s4
 daa:	b13ff0ef          	jal	8bc <sbrk>
  if(p == (char*)-1)
 dae:	fd551ce3          	bne	a0,s5,d86 <malloc+0x7e>
        return 0;
 db2:	4501                	li	a0,0
 db4:	7902                	ld	s2,32(sp)
 db6:	6a42                	ld	s4,16(sp)
 db8:	6aa2                	ld	s5,8(sp)
 dba:	6b02                	ld	s6,0(sp)
 dbc:	a03d                	j	dea <malloc+0xe2>
 dbe:	7902                	ld	s2,32(sp)
 dc0:	6a42                	ld	s4,16(sp)
 dc2:	6aa2                	ld	s5,8(sp)
 dc4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 dc6:	fae48de3          	beq	s1,a4,d80 <malloc+0x78>
        p->s.size -= nunits;
 dca:	4137073b          	subw	a4,a4,s3
 dce:	c798                	sw	a4,8(a5)
        p += p->s.size;
 dd0:	02071693          	slli	a3,a4,0x20
 dd4:	01c6d713          	srli	a4,a3,0x1c
 dd8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 dda:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 dde:	00001717          	auipc	a4,0x1
 de2:	22a73523          	sd	a0,554(a4) # 2008 <freep>
      return (void*)(p + 1);
 de6:	01078513          	addi	a0,a5,16
  }
}
 dea:	70e2                	ld	ra,56(sp)
 dec:	7442                	ld	s0,48(sp)
 dee:	74a2                	ld	s1,40(sp)
 df0:	69e2                	ld	s3,24(sp)
 df2:	6121                	addi	sp,sp,64
 df4:	8082                	ret
 df6:	7902                	ld	s2,32(sp)
 df8:	6a42                	ld	s4,16(sp)
 dfa:	6aa2                	ld	s5,8(sp)
 dfc:	6b02                	ld	s6,0(sp)
 dfe:	b7f5                	j	dea <malloc+0xe2>
