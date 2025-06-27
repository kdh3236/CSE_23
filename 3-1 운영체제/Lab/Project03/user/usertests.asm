
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
       e:	00007797          	auipc	a5,0x7
      12:	3ea78793          	addi	a5,a5,1002 # 73f8 <malloc+0x249e>
      16:	638c                	ld	a1,0(a5)
      18:	6790                	ld	a2,8(a5)
      1a:	6b94                	ld	a3,16(a5)
      1c:	6f98                	ld	a4,24(a5)
      1e:	739c                	ld	a5,32(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      34:	fa840493          	addi	s1,s0,-88
      38:	fd040993          	addi	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3c:	0004b903          	ld	s2,0(s1)
      40:	20100593          	li	a1,513
      44:	854a                	mv	a0,s2
      46:	281040ef          	jal	4ac6 <open>
    if(fd >= 0){
      4a:	00055c63          	bgez	a0,62 <copyinstr1+0x62>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      4e:	04a1                	addi	s1,s1,8
      50:	ff3496e3          	bne	s1,s3,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      54:	60e6                	ld	ra,88(sp)
      56:	6446                	ld	s0,80(sp)
      58:	64a6                	ld	s1,72(sp)
      5a:	6906                	ld	s2,64(sp)
      5c:	79e2                	ld	s3,56(sp)
      5e:	6125                	addi	sp,sp,96
      60:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      62:	862a                	mv	a2,a0
      64:	85ca                	mv	a1,s2
      66:	00005517          	auipc	a0,0x5
      6a:	ffa50513          	addi	a0,a0,-6 # 5060 <malloc+0x106>
      6e:	639040ef          	jal	4ea6 <printf>
      exit(1);
      72:	4505                	li	a0,1
      74:	213040ef          	jal	4a86 <exit>

0000000000000078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      78:	0000a797          	auipc	a5,0xa
      7c:	4f078793          	addi	a5,a5,1264 # a568 <uninit>
      80:	0000d697          	auipc	a3,0xd
      84:	bf868693          	addi	a3,a3,-1032 # cc78 <buf>
    if(uninit[i] != '\0'){
      88:	0007c703          	lbu	a4,0(a5)
      8c:	e709                	bnez	a4,96 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      8e:	0785                	addi	a5,a5,1
      90:	fed79ce3          	bne	a5,a3,88 <bsstest+0x10>
      94:	8082                	ret
{
      96:	1141                	addi	sp,sp,-16
      98:	e406                	sd	ra,8(sp)
      9a:	e022                	sd	s0,0(sp)
      9c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      9e:	85aa                	mv	a1,a0
      a0:	00005517          	auipc	a0,0x5
      a4:	fe050513          	addi	a0,a0,-32 # 5080 <malloc+0x126>
      a8:	5ff040ef          	jal	4ea6 <printf>
      exit(1);
      ac:	4505                	li	a0,1
      ae:	1d9040ef          	jal	4a86 <exit>

00000000000000b2 <opentest>:
{
      b2:	1101                	addi	sp,sp,-32
      b4:	ec06                	sd	ra,24(sp)
      b6:	e822                	sd	s0,16(sp)
      b8:	e426                	sd	s1,8(sp)
      ba:	1000                	addi	s0,sp,32
      bc:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      be:	4581                	li	a1,0
      c0:	00005517          	auipc	a0,0x5
      c4:	fd850513          	addi	a0,a0,-40 # 5098 <malloc+0x13e>
      c8:	1ff040ef          	jal	4ac6 <open>
  if(fd < 0){
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
  close(fd);
      d0:	1df040ef          	jal	4aae <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	fe250513          	addi	a0,a0,-30 # 50b8 <malloc+0x15e>
      de:	1e9040ef          	jal	4ac6 <open>
  if(fd >= 0){
      e2:	02055163          	bgez	a0,104 <opentest+0x52>
}
      e6:	60e2                	ld	ra,24(sp)
      e8:	6442                	ld	s0,16(sp)
      ea:	64a2                	ld	s1,8(sp)
      ec:	6105                	addi	sp,sp,32
      ee:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f0:	85a6                	mv	a1,s1
      f2:	00005517          	auipc	a0,0x5
      f6:	fae50513          	addi	a0,a0,-82 # 50a0 <malloc+0x146>
      fa:	5ad040ef          	jal	4ea6 <printf>
    exit(1);
      fe:	4505                	li	a0,1
     100:	187040ef          	jal	4a86 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	fc250513          	addi	a0,a0,-62 # 50c8 <malloc+0x16e>
     10e:	599040ef          	jal	4ea6 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	173040ef          	jal	4a86 <exit>

0000000000000118 <truncate2>:
{
     118:	7179                	addi	sp,sp,-48
     11a:	f406                	sd	ra,40(sp)
     11c:	f022                	sd	s0,32(sp)
     11e:	ec26                	sd	s1,24(sp)
     120:	e84a                	sd	s2,16(sp)
     122:	e44e                	sd	s3,8(sp)
     124:	1800                	addi	s0,sp,48
     126:	89aa                	mv	s3,a0
  unlink("truncfile");
     128:	00005517          	auipc	a0,0x5
     12c:	fc850513          	addi	a0,a0,-56 # 50f0 <malloc+0x196>
     130:	1a7040ef          	jal	4ad6 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	fb850513          	addi	a0,a0,-72 # 50f0 <malloc+0x196>
     140:	187040ef          	jal	4ac6 <open>
     144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	fb858593          	addi	a1,a1,-72 # 5100 <malloc+0x1a6>
     150:	157040ef          	jal	4aa6 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	f9850513          	addi	a0,a0,-104 # 50f0 <malloc+0x196>
     160:	167040ef          	jal	4ac6 <open>
     164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	fa058593          	addi	a1,a1,-96 # 5108 <malloc+0x1ae>
     170:	8526                	mv	a0,s1
     172:	135040ef          	jal	4aa6 <write>
  if(n != -1){
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
  unlink("truncfile");
     17c:	00005517          	auipc	a0,0x5
     180:	f7450513          	addi	a0,a0,-140 # 50f0 <malloc+0x196>
     184:	153040ef          	jal	4ad6 <unlink>
  close(fd1);
     188:	8526                	mv	a0,s1
     18a:	125040ef          	jal	4aae <close>
  close(fd2);
     18e:	854a                	mv	a0,s2
     190:	11f040ef          	jal	4aae <close>
}
     194:	70a2                	ld	ra,40(sp)
     196:	7402                	ld	s0,32(sp)
     198:	64e2                	ld	s1,24(sp)
     19a:	6942                	ld	s2,16(sp)
     19c:	69a2                	ld	s3,8(sp)
     19e:	6145                	addi	sp,sp,48
     1a0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a2:	862a                	mv	a2,a0
     1a4:	85ce                	mv	a1,s3
     1a6:	00005517          	auipc	a0,0x5
     1aa:	f6a50513          	addi	a0,a0,-150 # 5110 <malloc+0x1b6>
     1ae:	4f9040ef          	jal	4ea6 <printf>
    exit(1);
     1b2:	4505                	li	a0,1
     1b4:	0d3040ef          	jal	4a86 <exit>

00000000000001b8 <createtest>:
{
     1b8:	7179                	addi	sp,sp,-48
     1ba:	f406                	sd	ra,40(sp)
     1bc:	f022                	sd	s0,32(sp)
     1be:	ec26                	sd	s1,24(sp)
     1c0:	e84a                	sd	s2,16(sp)
     1c2:	1800                	addi	s0,sp,48
  name[0] = 'a';
     1c4:	06100793          	li	a5,97
     1c8:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1cc:	fc040d23          	sb	zero,-38(s0)
     1d0:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     1d4:	06400913          	li	s2,100
    name[1] = '0' + i;
     1d8:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1dc:	20200593          	li	a1,514
     1e0:	fd840513          	addi	a0,s0,-40
     1e4:	0e3040ef          	jal	4ac6 <open>
    close(fd);
     1e8:	0c7040ef          	jal	4aae <close>
  for(i = 0; i < N; i++){
     1ec:	2485                	addiw	s1,s1,1
     1ee:	0ff4f493          	zext.b	s1,s1
     1f2:	ff2493e3          	bne	s1,s2,1d8 <createtest+0x20>
  name[0] = 'a';
     1f6:	06100793          	li	a5,97
     1fa:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1fe:	fc040d23          	sb	zero,-38(s0)
     202:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     206:	06400913          	li	s2,100
    name[1] = '0' + i;
     20a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     20e:	fd840513          	addi	a0,s0,-40
     212:	0c5040ef          	jal	4ad6 <unlink>
  for(i = 0; i < N; i++){
     216:	2485                	addiw	s1,s1,1
     218:	0ff4f493          	zext.b	s1,s1
     21c:	ff2497e3          	bne	s1,s2,20a <createtest+0x52>
}
     220:	70a2                	ld	ra,40(sp)
     222:	7402                	ld	s0,32(sp)
     224:	64e2                	ld	s1,24(sp)
     226:	6942                	ld	s2,16(sp)
     228:	6145                	addi	sp,sp,48
     22a:	8082                	ret

000000000000022c <bigwrite>:
{
     22c:	715d                	addi	sp,sp,-80
     22e:	e486                	sd	ra,72(sp)
     230:	e0a2                	sd	s0,64(sp)
     232:	fc26                	sd	s1,56(sp)
     234:	f84a                	sd	s2,48(sp)
     236:	f44e                	sd	s3,40(sp)
     238:	f052                	sd	s4,32(sp)
     23a:	ec56                	sd	s5,24(sp)
     23c:	e85a                	sd	s6,16(sp)
     23e:	e45e                	sd	s7,8(sp)
     240:	0880                	addi	s0,sp,80
     242:	8baa                	mv	s7,a0
  unlink("bigwrite");
     244:	00005517          	auipc	a0,0x5
     248:	ef450513          	addi	a0,a0,-268 # 5138 <malloc+0x1de>
     24c:	08b040ef          	jal	4ad6 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     254:	00005a97          	auipc	s5,0x5
     258:	ee4a8a93          	addi	s5,s5,-284 # 5138 <malloc+0x1de>
      int cc = write(fd, buf, sz);
     25c:	0000da17          	auipc	s4,0xd
     260:	a1ca0a13          	addi	s4,s4,-1508 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x5e7>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	057040ef          	jal	4ac6 <open>
     274:	892a                	mv	s2,a0
    if(fd < 0){
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	029040ef          	jal	4aa6 <write>
     282:	89aa                	mv	s3,a0
      if(cc != sz){
     284:	04a49863          	bne	s1,a0,2d4 <bigwrite+0xa8>
      int cc = write(fd, buf, sz);
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	019040ef          	jal	4aa6 <write>
      if(cc != sz){
     292:	04951263          	bne	a0,s1,2d6 <bigwrite+0xaa>
    close(fd);
     296:	854a                	mv	a0,s2
     298:	017040ef          	jal	4aae <close>
    unlink("bigwrite");
     29c:	8556                	mv	a0,s5
     29e:	039040ef          	jal	4ad6 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a2:	1d74849b          	addiw	s1,s1,471
     2a6:	fd6492e3          	bne	s1,s6,26a <bigwrite+0x3e>
}
     2aa:	60a6                	ld	ra,72(sp)
     2ac:	6406                	ld	s0,64(sp)
     2ae:	74e2                	ld	s1,56(sp)
     2b0:	7942                	ld	s2,48(sp)
     2b2:	79a2                	ld	s3,40(sp)
     2b4:	7a02                	ld	s4,32(sp)
     2b6:	6ae2                	ld	s5,24(sp)
     2b8:	6b42                	ld	s6,16(sp)
     2ba:	6ba2                	ld	s7,8(sp)
     2bc:	6161                	addi	sp,sp,80
     2be:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2c0:	85de                	mv	a1,s7
     2c2:	00005517          	auipc	a0,0x5
     2c6:	e8650513          	addi	a0,a0,-378 # 5148 <malloc+0x1ee>
     2ca:	3dd040ef          	jal	4ea6 <printf>
      exit(1);
     2ce:	4505                	li	a0,1
     2d0:	7b6040ef          	jal	4a86 <exit>
      if(cc != sz){
     2d4:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2d6:	86aa                	mv	a3,a0
     2d8:	864e                	mv	a2,s3
     2da:	85de                	mv	a1,s7
     2dc:	00005517          	auipc	a0,0x5
     2e0:	e8c50513          	addi	a0,a0,-372 # 5168 <malloc+0x20e>
     2e4:	3c3040ef          	jal	4ea6 <printf>
        exit(1);
     2e8:	4505                	li	a0,1
     2ea:	79c040ef          	jal	4a86 <exit>

00000000000002ee <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     2ee:	7179                	addi	sp,sp,-48
     2f0:	f406                	sd	ra,40(sp)
     2f2:	f022                	sd	s0,32(sp)
     2f4:	ec26                	sd	s1,24(sp)
     2f6:	e84a                	sd	s2,16(sp)
     2f8:	e44e                	sd	s3,8(sp)
     2fa:	e052                	sd	s4,0(sp)
     2fc:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     2fe:	00005517          	auipc	a0,0x5
     302:	e8250513          	addi	a0,a0,-382 # 5180 <malloc+0x226>
     306:	7d0040ef          	jal	4ad6 <unlink>
     30a:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     30e:	00005997          	auipc	s3,0x5
     312:	e7298993          	addi	s3,s3,-398 # 5180 <malloc+0x226>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     316:	5a7d                	li	s4,-1
     318:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     31c:	20100593          	li	a1,513
     320:	854e                	mv	a0,s3
     322:	7a4040ef          	jal	4ac6 <open>
     326:	84aa                	mv	s1,a0
    if(fd < 0){
     328:	04054d63          	bltz	a0,382 <badwrite+0x94>
    write(fd, (char*)0xffffffffffL, 1);
     32c:	4605                	li	a2,1
     32e:	85d2                	mv	a1,s4
     330:	776040ef          	jal	4aa6 <write>
    close(fd);
     334:	8526                	mv	a0,s1
     336:	778040ef          	jal	4aae <close>
    unlink("junk");
     33a:	854e                	mv	a0,s3
     33c:	79a040ef          	jal	4ad6 <unlink>
  for(int i = 0; i < assumed_free; i++){
     340:	397d                	addiw	s2,s2,-1
     342:	fc091de3          	bnez	s2,31c <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     346:	20100593          	li	a1,513
     34a:	00005517          	auipc	a0,0x5
     34e:	e3650513          	addi	a0,a0,-458 # 5180 <malloc+0x226>
     352:	774040ef          	jal	4ac6 <open>
     356:	84aa                	mv	s1,a0
  if(fd < 0){
     358:	02054e63          	bltz	a0,394 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     35c:	4605                	li	a2,1
     35e:	00005597          	auipc	a1,0x5
     362:	daa58593          	addi	a1,a1,-598 # 5108 <malloc+0x1ae>
     366:	740040ef          	jal	4aa6 <write>
     36a:	4785                	li	a5,1
     36c:	02f50d63          	beq	a0,a5,3a6 <badwrite+0xb8>
    printf("write failed\n");
     370:	00005517          	auipc	a0,0x5
     374:	e3050513          	addi	a0,a0,-464 # 51a0 <malloc+0x246>
     378:	32f040ef          	jal	4ea6 <printf>
    exit(1);
     37c:	4505                	li	a0,1
     37e:	708040ef          	jal	4a86 <exit>
      printf("open junk failed\n");
     382:	00005517          	auipc	a0,0x5
     386:	e0650513          	addi	a0,a0,-506 # 5188 <malloc+0x22e>
     38a:	31d040ef          	jal	4ea6 <printf>
      exit(1);
     38e:	4505                	li	a0,1
     390:	6f6040ef          	jal	4a86 <exit>
    printf("open junk failed\n");
     394:	00005517          	auipc	a0,0x5
     398:	df450513          	addi	a0,a0,-524 # 5188 <malloc+0x22e>
     39c:	30b040ef          	jal	4ea6 <printf>
    exit(1);
     3a0:	4505                	li	a0,1
     3a2:	6e4040ef          	jal	4a86 <exit>
  }
  close(fd);
     3a6:	8526                	mv	a0,s1
     3a8:	706040ef          	jal	4aae <close>
  unlink("junk");
     3ac:	00005517          	auipc	a0,0x5
     3b0:	dd450513          	addi	a0,a0,-556 # 5180 <malloc+0x226>
     3b4:	722040ef          	jal	4ad6 <unlink>

  exit(0);
     3b8:	4501                	li	a0,0
     3ba:	6cc040ef          	jal	4a86 <exit>

00000000000003be <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3be:	715d                	addi	sp,sp,-80
     3c0:	e486                	sd	ra,72(sp)
     3c2:	e0a2                	sd	s0,64(sp)
     3c4:	fc26                	sd	s1,56(sp)
     3c6:	f84a                	sd	s2,48(sp)
     3c8:	f44e                	sd	s3,40(sp)
     3ca:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3cc:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3ce:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     3d2:	40000993          	li	s3,1024
    name[0] = 'z';
     3d6:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     3da:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     3de:	41f4d71b          	sraiw	a4,s1,0x1f
     3e2:	01b7571b          	srliw	a4,a4,0x1b
     3e6:	009707bb          	addw	a5,a4,s1
     3ea:	4057d69b          	sraiw	a3,a5,0x5
     3ee:	0306869b          	addiw	a3,a3,48
     3f2:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     3f6:	8bfd                	andi	a5,a5,31
     3f8:	9f99                	subw	a5,a5,a4
     3fa:	0307879b          	addiw	a5,a5,48
     3fe:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     402:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     406:	fb040513          	addi	a0,s0,-80
     40a:	6cc040ef          	jal	4ad6 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     40e:	60200593          	li	a1,1538
     412:	fb040513          	addi	a0,s0,-80
     416:	6b0040ef          	jal	4ac6 <open>
    if(fd < 0){
     41a:	00054763          	bltz	a0,428 <outofinodes+0x6a>
      // failure is eventually expected.
      break;
    }
    close(fd);
     41e:	690040ef          	jal	4aae <close>
  for(int i = 0; i < nzz; i++){
     422:	2485                	addiw	s1,s1,1
     424:	fb3499e3          	bne	s1,s3,3d6 <outofinodes+0x18>
     428:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     42a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     42e:	40000993          	li	s3,1024
    name[0] = 'z';
     432:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     436:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     43a:	41f4d71b          	sraiw	a4,s1,0x1f
     43e:	01b7571b          	srliw	a4,a4,0x1b
     442:	009707bb          	addw	a5,a4,s1
     446:	4057d69b          	sraiw	a3,a5,0x5
     44a:	0306869b          	addiw	a3,a3,48
     44e:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     452:	8bfd                	andi	a5,a5,31
     454:	9f99                	subw	a5,a5,a4
     456:	0307879b          	addiw	a5,a5,48
     45a:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     45e:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     462:	fb040513          	addi	a0,s0,-80
     466:	670040ef          	jal	4ad6 <unlink>
  for(int i = 0; i < nzz; i++){
     46a:	2485                	addiw	s1,s1,1
     46c:	fd3493e3          	bne	s1,s3,432 <outofinodes+0x74>
  }
}
     470:	60a6                	ld	ra,72(sp)
     472:	6406                	ld	s0,64(sp)
     474:	74e2                	ld	s1,56(sp)
     476:	7942                	ld	s2,48(sp)
     478:	79a2                	ld	s3,40(sp)
     47a:	6161                	addi	sp,sp,80
     47c:	8082                	ret

000000000000047e <copyin>:
{
     47e:	7159                	addi	sp,sp,-112
     480:	f486                	sd	ra,104(sp)
     482:	f0a2                	sd	s0,96(sp)
     484:	eca6                	sd	s1,88(sp)
     486:	e8ca                	sd	s2,80(sp)
     488:	e4ce                	sd	s3,72(sp)
     48a:	e0d2                	sd	s4,64(sp)
     48c:	fc56                	sd	s5,56(sp)
     48e:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     490:	00007797          	auipc	a5,0x7
     494:	f6878793          	addi	a5,a5,-152 # 73f8 <malloc+0x249e>
     498:	638c                	ld	a1,0(a5)
     49a:	6790                	ld	a2,8(a5)
     49c:	6b94                	ld	a3,16(a5)
     49e:	6f98                	ld	a4,24(a5)
     4a0:	739c                	ld	a5,32(a5)
     4a2:	f8b43c23          	sd	a1,-104(s0)
     4a6:	fac43023          	sd	a2,-96(s0)
     4aa:	fad43423          	sd	a3,-88(s0)
     4ae:	fae43823          	sd	a4,-80(s0)
     4b2:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4b6:	f9840913          	addi	s2,s0,-104
     4ba:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4be:	00005a17          	auipc	s4,0x5
     4c2:	cf2a0a13          	addi	s4,s4,-782 # 51b0 <malloc+0x256>
    uint64 addr = addrs[ai];
     4c6:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4ca:	20100593          	li	a1,513
     4ce:	8552                	mv	a0,s4
     4d0:	5f6040ef          	jal	4ac6 <open>
     4d4:	84aa                	mv	s1,a0
    if(fd < 0){
     4d6:	06054763          	bltz	a0,544 <copyin+0xc6>
    int n = write(fd, (void*)addr, 8192);
     4da:	6609                	lui	a2,0x2
     4dc:	85ce                	mv	a1,s3
     4de:	5c8040ef          	jal	4aa6 <write>
    if(n >= 0){
     4e2:	06055a63          	bgez	a0,556 <copyin+0xd8>
    close(fd);
     4e6:	8526                	mv	a0,s1
     4e8:	5c6040ef          	jal	4aae <close>
    unlink("copyin1");
     4ec:	8552                	mv	a0,s4
     4ee:	5e8040ef          	jal	4ad6 <unlink>
    n = write(1, (char*)addr, 8192);
     4f2:	6609                	lui	a2,0x2
     4f4:	85ce                	mv	a1,s3
     4f6:	4505                	li	a0,1
     4f8:	5ae040ef          	jal	4aa6 <write>
    if(n > 0){
     4fc:	06a04863          	bgtz	a0,56c <copyin+0xee>
    if(pipe(fds) < 0){
     500:	f9040513          	addi	a0,s0,-112
     504:	592040ef          	jal	4a96 <pipe>
     508:	06054d63          	bltz	a0,582 <copyin+0x104>
    n = write(fds[1], (char*)addr, 8192);
     50c:	6609                	lui	a2,0x2
     50e:	85ce                	mv	a1,s3
     510:	f9442503          	lw	a0,-108(s0)
     514:	592040ef          	jal	4aa6 <write>
    if(n > 0){
     518:	06a04e63          	bgtz	a0,594 <copyin+0x116>
    close(fds[0]);
     51c:	f9042503          	lw	a0,-112(s0)
     520:	58e040ef          	jal	4aae <close>
    close(fds[1]);
     524:	f9442503          	lw	a0,-108(s0)
     528:	586040ef          	jal	4aae <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     52c:	0921                	addi	s2,s2,8
     52e:	f9591ce3          	bne	s2,s5,4c6 <copyin+0x48>
}
     532:	70a6                	ld	ra,104(sp)
     534:	7406                	ld	s0,96(sp)
     536:	64e6                	ld	s1,88(sp)
     538:	6946                	ld	s2,80(sp)
     53a:	69a6                	ld	s3,72(sp)
     53c:	6a06                	ld	s4,64(sp)
     53e:	7ae2                	ld	s5,56(sp)
     540:	6165                	addi	sp,sp,112
     542:	8082                	ret
      printf("open(copyin1) failed\n");
     544:	00005517          	auipc	a0,0x5
     548:	c7450513          	addi	a0,a0,-908 # 51b8 <malloc+0x25e>
     54c:	15b040ef          	jal	4ea6 <printf>
      exit(1);
     550:	4505                	li	a0,1
     552:	534040ef          	jal	4a86 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     556:	862a                	mv	a2,a0
     558:	85ce                	mv	a1,s3
     55a:	00005517          	auipc	a0,0x5
     55e:	c7650513          	addi	a0,a0,-906 # 51d0 <malloc+0x276>
     562:	145040ef          	jal	4ea6 <printf>
      exit(1);
     566:	4505                	li	a0,1
     568:	51e040ef          	jal	4a86 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     56c:	862a                	mv	a2,a0
     56e:	85ce                	mv	a1,s3
     570:	00005517          	auipc	a0,0x5
     574:	c9050513          	addi	a0,a0,-880 # 5200 <malloc+0x2a6>
     578:	12f040ef          	jal	4ea6 <printf>
      exit(1);
     57c:	4505                	li	a0,1
     57e:	508040ef          	jal	4a86 <exit>
      printf("pipe() failed\n");
     582:	00005517          	auipc	a0,0x5
     586:	cae50513          	addi	a0,a0,-850 # 5230 <malloc+0x2d6>
     58a:	11d040ef          	jal	4ea6 <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	4f6040ef          	jal	4a86 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     594:	862a                	mv	a2,a0
     596:	85ce                	mv	a1,s3
     598:	00005517          	auipc	a0,0x5
     59c:	ca850513          	addi	a0,a0,-856 # 5240 <malloc+0x2e6>
     5a0:	107040ef          	jal	4ea6 <printf>
      exit(1);
     5a4:	4505                	li	a0,1
     5a6:	4e0040ef          	jal	4a86 <exit>

00000000000005aa <copyout>:
{
     5aa:	7119                	addi	sp,sp,-128
     5ac:	fc86                	sd	ra,120(sp)
     5ae:	f8a2                	sd	s0,112(sp)
     5b0:	f4a6                	sd	s1,104(sp)
     5b2:	f0ca                	sd	s2,96(sp)
     5b4:	ecce                	sd	s3,88(sp)
     5b6:	e8d2                	sd	s4,80(sp)
     5b8:	e4d6                	sd	s5,72(sp)
     5ba:	e0da                	sd	s6,64(sp)
     5bc:	0100                	addi	s0,sp,128
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     5be:	00007797          	auipc	a5,0x7
     5c2:	e3a78793          	addi	a5,a5,-454 # 73f8 <malloc+0x249e>
     5c6:	7788                	ld	a0,40(a5)
     5c8:	7b8c                	ld	a1,48(a5)
     5ca:	7f90                	ld	a2,56(a5)
     5cc:	63b4                	ld	a3,64(a5)
     5ce:	67b8                	ld	a4,72(a5)
     5d0:	6bbc                	ld	a5,80(a5)
     5d2:	f8a43823          	sd	a0,-112(s0)
     5d6:	f8b43c23          	sd	a1,-104(s0)
     5da:	fac43023          	sd	a2,-96(s0)
     5de:	fad43423          	sd	a3,-88(s0)
     5e2:	fae43823          	sd	a4,-80(s0)
     5e6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     5ea:	f9040913          	addi	s2,s0,-112
     5ee:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
     5f2:	00005a17          	auipc	s4,0x5
     5f6:	c7ea0a13          	addi	s4,s4,-898 # 5270 <malloc+0x316>
    n = write(fds[1], "x", 1);
     5fa:	00005a97          	auipc	s5,0x5
     5fe:	b0ea8a93          	addi	s5,s5,-1266 # 5108 <malloc+0x1ae>
    uint64 addr = addrs[ai];
     602:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     606:	4581                	li	a1,0
     608:	8552                	mv	a0,s4
     60a:	4bc040ef          	jal	4ac6 <open>
     60e:	84aa                	mv	s1,a0
    if(fd < 0){
     610:	06054763          	bltz	a0,67e <copyout+0xd4>
    int n = read(fd, (void*)addr, 8192);
     614:	6609                	lui	a2,0x2
     616:	85ce                	mv	a1,s3
     618:	486040ef          	jal	4a9e <read>
    if(n > 0){
     61c:	06a04a63          	bgtz	a0,690 <copyout+0xe6>
    close(fd);
     620:	8526                	mv	a0,s1
     622:	48c040ef          	jal	4aae <close>
    if(pipe(fds) < 0){
     626:	f8840513          	addi	a0,s0,-120
     62a:	46c040ef          	jal	4a96 <pipe>
     62e:	06054c63          	bltz	a0,6a6 <copyout+0xfc>
    n = write(fds[1], "x", 1);
     632:	4605                	li	a2,1
     634:	85d6                	mv	a1,s5
     636:	f8c42503          	lw	a0,-116(s0)
     63a:	46c040ef          	jal	4aa6 <write>
    if(n != 1){
     63e:	4785                	li	a5,1
     640:	06f51c63          	bne	a0,a5,6b8 <copyout+0x10e>
    n = read(fds[0], (void*)addr, 8192);
     644:	6609                	lui	a2,0x2
     646:	85ce                	mv	a1,s3
     648:	f8842503          	lw	a0,-120(s0)
     64c:	452040ef          	jal	4a9e <read>
    if(n > 0){
     650:	06a04d63          	bgtz	a0,6ca <copyout+0x120>
    close(fds[0]);
     654:	f8842503          	lw	a0,-120(s0)
     658:	456040ef          	jal	4aae <close>
    close(fds[1]);
     65c:	f8c42503          	lw	a0,-116(s0)
     660:	44e040ef          	jal	4aae <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     664:	0921                	addi	s2,s2,8
     666:	f9691ee3          	bne	s2,s6,602 <copyout+0x58>
}
     66a:	70e6                	ld	ra,120(sp)
     66c:	7446                	ld	s0,112(sp)
     66e:	74a6                	ld	s1,104(sp)
     670:	7906                	ld	s2,96(sp)
     672:	69e6                	ld	s3,88(sp)
     674:	6a46                	ld	s4,80(sp)
     676:	6aa6                	ld	s5,72(sp)
     678:	6b06                	ld	s6,64(sp)
     67a:	6109                	addi	sp,sp,128
     67c:	8082                	ret
      printf("open(README) failed\n");
     67e:	00005517          	auipc	a0,0x5
     682:	bfa50513          	addi	a0,a0,-1030 # 5278 <malloc+0x31e>
     686:	021040ef          	jal	4ea6 <printf>
      exit(1);
     68a:	4505                	li	a0,1
     68c:	3fa040ef          	jal	4a86 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     690:	862a                	mv	a2,a0
     692:	85ce                	mv	a1,s3
     694:	00005517          	auipc	a0,0x5
     698:	bfc50513          	addi	a0,a0,-1028 # 5290 <malloc+0x336>
     69c:	00b040ef          	jal	4ea6 <printf>
      exit(1);
     6a0:	4505                	li	a0,1
     6a2:	3e4040ef          	jal	4a86 <exit>
      printf("pipe() failed\n");
     6a6:	00005517          	auipc	a0,0x5
     6aa:	b8a50513          	addi	a0,a0,-1142 # 5230 <malloc+0x2d6>
     6ae:	7f8040ef          	jal	4ea6 <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	3d2040ef          	jal	4a86 <exit>
      printf("pipe write failed\n");
     6b8:	00005517          	auipc	a0,0x5
     6bc:	c0850513          	addi	a0,a0,-1016 # 52c0 <malloc+0x366>
     6c0:	7e6040ef          	jal	4ea6 <printf>
      exit(1);
     6c4:	4505                	li	a0,1
     6c6:	3c0040ef          	jal	4a86 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6ca:	862a                	mv	a2,a0
     6cc:	85ce                	mv	a1,s3
     6ce:	00005517          	auipc	a0,0x5
     6d2:	c0a50513          	addi	a0,a0,-1014 # 52d8 <malloc+0x37e>
     6d6:	7d0040ef          	jal	4ea6 <printf>
      exit(1);
     6da:	4505                	li	a0,1
     6dc:	3aa040ef          	jal	4a86 <exit>

00000000000006e0 <truncate1>:
{
     6e0:	711d                	addi	sp,sp,-96
     6e2:	ec86                	sd	ra,88(sp)
     6e4:	e8a2                	sd	s0,80(sp)
     6e6:	e4a6                	sd	s1,72(sp)
     6e8:	e0ca                	sd	s2,64(sp)
     6ea:	fc4e                	sd	s3,56(sp)
     6ec:	f852                	sd	s4,48(sp)
     6ee:	f456                	sd	s5,40(sp)
     6f0:	1080                	addi	s0,sp,96
     6f2:	8aaa                	mv	s5,a0
  unlink("truncfile");
     6f4:	00005517          	auipc	a0,0x5
     6f8:	9fc50513          	addi	a0,a0,-1540 # 50f0 <malloc+0x196>
     6fc:	3da040ef          	jal	4ad6 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     700:	60100593          	li	a1,1537
     704:	00005517          	auipc	a0,0x5
     708:	9ec50513          	addi	a0,a0,-1556 # 50f0 <malloc+0x196>
     70c:	3ba040ef          	jal	4ac6 <open>
     710:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     712:	4611                	li	a2,4
     714:	00005597          	auipc	a1,0x5
     718:	9ec58593          	addi	a1,a1,-1556 # 5100 <malloc+0x1a6>
     71c:	38a040ef          	jal	4aa6 <write>
  close(fd1);
     720:	8526                	mv	a0,s1
     722:	38c040ef          	jal	4aae <close>
  int fd2 = open("truncfile", O_RDONLY);
     726:	4581                	li	a1,0
     728:	00005517          	auipc	a0,0x5
     72c:	9c850513          	addi	a0,a0,-1592 # 50f0 <malloc+0x196>
     730:	396040ef          	jal	4ac6 <open>
     734:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     736:	02000613          	li	a2,32
     73a:	fa040593          	addi	a1,s0,-96
     73e:	360040ef          	jal	4a9e <read>
  if(n != 4){
     742:	4791                	li	a5,4
     744:	0af51863          	bne	a0,a5,7f4 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     748:	40100593          	li	a1,1025
     74c:	00005517          	auipc	a0,0x5
     750:	9a450513          	addi	a0,a0,-1628 # 50f0 <malloc+0x196>
     754:	372040ef          	jal	4ac6 <open>
     758:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     75a:	4581                	li	a1,0
     75c:	00005517          	auipc	a0,0x5
     760:	99450513          	addi	a0,a0,-1644 # 50f0 <malloc+0x196>
     764:	362040ef          	jal	4ac6 <open>
     768:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     76a:	02000613          	li	a2,32
     76e:	fa040593          	addi	a1,s0,-96
     772:	32c040ef          	jal	4a9e <read>
     776:	8a2a                	mv	s4,a0
  if(n != 0){
     778:	e949                	bnez	a0,80a <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     77a:	02000613          	li	a2,32
     77e:	fa040593          	addi	a1,s0,-96
     782:	8526                	mv	a0,s1
     784:	31a040ef          	jal	4a9e <read>
     788:	8a2a                	mv	s4,a0
  if(n != 0){
     78a:	e155                	bnez	a0,82e <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     78c:	4619                	li	a2,6
     78e:	00005597          	auipc	a1,0x5
     792:	bda58593          	addi	a1,a1,-1062 # 5368 <malloc+0x40e>
     796:	854e                	mv	a0,s3
     798:	30e040ef          	jal	4aa6 <write>
  n = read(fd3, buf, sizeof(buf));
     79c:	02000613          	li	a2,32
     7a0:	fa040593          	addi	a1,s0,-96
     7a4:	854a                	mv	a0,s2
     7a6:	2f8040ef          	jal	4a9e <read>
  if(n != 6){
     7aa:	4799                	li	a5,6
     7ac:	0af51363          	bne	a0,a5,852 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     7b0:	02000613          	li	a2,32
     7b4:	fa040593          	addi	a1,s0,-96
     7b8:	8526                	mv	a0,s1
     7ba:	2e4040ef          	jal	4a9e <read>
  if(n != 2){
     7be:	4789                	li	a5,2
     7c0:	0af51463          	bne	a0,a5,868 <truncate1+0x188>
  unlink("truncfile");
     7c4:	00005517          	auipc	a0,0x5
     7c8:	92c50513          	addi	a0,a0,-1748 # 50f0 <malloc+0x196>
     7cc:	30a040ef          	jal	4ad6 <unlink>
  close(fd1);
     7d0:	854e                	mv	a0,s3
     7d2:	2dc040ef          	jal	4aae <close>
  close(fd2);
     7d6:	8526                	mv	a0,s1
     7d8:	2d6040ef          	jal	4aae <close>
  close(fd3);
     7dc:	854a                	mv	a0,s2
     7de:	2d0040ef          	jal	4aae <close>
}
     7e2:	60e6                	ld	ra,88(sp)
     7e4:	6446                	ld	s0,80(sp)
     7e6:	64a6                	ld	s1,72(sp)
     7e8:	6906                	ld	s2,64(sp)
     7ea:	79e2                	ld	s3,56(sp)
     7ec:	7a42                	ld	s4,48(sp)
     7ee:	7aa2                	ld	s5,40(sp)
     7f0:	6125                	addi	sp,sp,96
     7f2:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     7f4:	862a                	mv	a2,a0
     7f6:	85d6                	mv	a1,s5
     7f8:	00005517          	auipc	a0,0x5
     7fc:	b1050513          	addi	a0,a0,-1264 # 5308 <malloc+0x3ae>
     800:	6a6040ef          	jal	4ea6 <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	280040ef          	jal	4a86 <exit>
    printf("aaa fd3=%d\n", fd3);
     80a:	85ca                	mv	a1,s2
     80c:	00005517          	auipc	a0,0x5
     810:	b1c50513          	addi	a0,a0,-1252 # 5328 <malloc+0x3ce>
     814:	692040ef          	jal	4ea6 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     818:	8652                	mv	a2,s4
     81a:	85d6                	mv	a1,s5
     81c:	00005517          	auipc	a0,0x5
     820:	b1c50513          	addi	a0,a0,-1252 # 5338 <malloc+0x3de>
     824:	682040ef          	jal	4ea6 <printf>
    exit(1);
     828:	4505                	li	a0,1
     82a:	25c040ef          	jal	4a86 <exit>
    printf("bbb fd2=%d\n", fd2);
     82e:	85a6                	mv	a1,s1
     830:	00005517          	auipc	a0,0x5
     834:	b2850513          	addi	a0,a0,-1240 # 5358 <malloc+0x3fe>
     838:	66e040ef          	jal	4ea6 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     83c:	8652                	mv	a2,s4
     83e:	85d6                	mv	a1,s5
     840:	00005517          	auipc	a0,0x5
     844:	af850513          	addi	a0,a0,-1288 # 5338 <malloc+0x3de>
     848:	65e040ef          	jal	4ea6 <printf>
    exit(1);
     84c:	4505                	li	a0,1
     84e:	238040ef          	jal	4a86 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     852:	862a                	mv	a2,a0
     854:	85d6                	mv	a1,s5
     856:	00005517          	auipc	a0,0x5
     85a:	b1a50513          	addi	a0,a0,-1254 # 5370 <malloc+0x416>
     85e:	648040ef          	jal	4ea6 <printf>
    exit(1);
     862:	4505                	li	a0,1
     864:	222040ef          	jal	4a86 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     868:	862a                	mv	a2,a0
     86a:	85d6                	mv	a1,s5
     86c:	00005517          	auipc	a0,0x5
     870:	b2450513          	addi	a0,a0,-1244 # 5390 <malloc+0x436>
     874:	632040ef          	jal	4ea6 <printf>
    exit(1);
     878:	4505                	li	a0,1
     87a:	20c040ef          	jal	4a86 <exit>

000000000000087e <writetest>:
{
     87e:	7139                	addi	sp,sp,-64
     880:	fc06                	sd	ra,56(sp)
     882:	f822                	sd	s0,48(sp)
     884:	f426                	sd	s1,40(sp)
     886:	f04a                	sd	s2,32(sp)
     888:	ec4e                	sd	s3,24(sp)
     88a:	e852                	sd	s4,16(sp)
     88c:	e456                	sd	s5,8(sp)
     88e:	e05a                	sd	s6,0(sp)
     890:	0080                	addi	s0,sp,64
     892:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     894:	20200593          	li	a1,514
     898:	00005517          	auipc	a0,0x5
     89c:	b1850513          	addi	a0,a0,-1256 # 53b0 <malloc+0x456>
     8a0:	226040ef          	jal	4ac6 <open>
  if(fd < 0){
     8a4:	08054f63          	bltz	a0,942 <writetest+0xc4>
     8a8:	892a                	mv	s2,a0
     8aa:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8ac:	00005997          	auipc	s3,0x5
     8b0:	b2c98993          	addi	s3,s3,-1236 # 53d8 <malloc+0x47e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8b4:	00005a97          	auipc	s5,0x5
     8b8:	b5ca8a93          	addi	s5,s5,-1188 # 5410 <malloc+0x4b6>
  for(i = 0; i < N; i++){
     8bc:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8c0:	4629                	li	a2,10
     8c2:	85ce                	mv	a1,s3
     8c4:	854a                	mv	a0,s2
     8c6:	1e0040ef          	jal	4aa6 <write>
     8ca:	47a9                	li	a5,10
     8cc:	08f51563          	bne	a0,a5,956 <writetest+0xd8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8d0:	4629                	li	a2,10
     8d2:	85d6                	mv	a1,s5
     8d4:	854a                	mv	a0,s2
     8d6:	1d0040ef          	jal	4aa6 <write>
     8da:	47a9                	li	a5,10
     8dc:	08f51863          	bne	a0,a5,96c <writetest+0xee>
  for(i = 0; i < N; i++){
     8e0:	2485                	addiw	s1,s1,1
     8e2:	fd449fe3          	bne	s1,s4,8c0 <writetest+0x42>
  close(fd);
     8e6:	854a                	mv	a0,s2
     8e8:	1c6040ef          	jal	4aae <close>
  fd = open("small", O_RDONLY);
     8ec:	4581                	li	a1,0
     8ee:	00005517          	auipc	a0,0x5
     8f2:	ac250513          	addi	a0,a0,-1342 # 53b0 <malloc+0x456>
     8f6:	1d0040ef          	jal	4ac6 <open>
     8fa:	84aa                	mv	s1,a0
  if(fd < 0){
     8fc:	08054363          	bltz	a0,982 <writetest+0x104>
  i = read(fd, buf, N*SZ*2);
     900:	7d000613          	li	a2,2000
     904:	0000c597          	auipc	a1,0xc
     908:	37458593          	addi	a1,a1,884 # cc78 <buf>
     90c:	192040ef          	jal	4a9e <read>
  if(i != N*SZ*2){
     910:	7d000793          	li	a5,2000
     914:	08f51163          	bne	a0,a5,996 <writetest+0x118>
  close(fd);
     918:	8526                	mv	a0,s1
     91a:	194040ef          	jal	4aae <close>
  if(unlink("small") < 0){
     91e:	00005517          	auipc	a0,0x5
     922:	a9250513          	addi	a0,a0,-1390 # 53b0 <malloc+0x456>
     926:	1b0040ef          	jal	4ad6 <unlink>
     92a:	08054063          	bltz	a0,9aa <writetest+0x12c>
}
     92e:	70e2                	ld	ra,56(sp)
     930:	7442                	ld	s0,48(sp)
     932:	74a2                	ld	s1,40(sp)
     934:	7902                	ld	s2,32(sp)
     936:	69e2                	ld	s3,24(sp)
     938:	6a42                	ld	s4,16(sp)
     93a:	6aa2                	ld	s5,8(sp)
     93c:	6b02                	ld	s6,0(sp)
     93e:	6121                	addi	sp,sp,64
     940:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     942:	85da                	mv	a1,s6
     944:	00005517          	auipc	a0,0x5
     948:	a7450513          	addi	a0,a0,-1420 # 53b8 <malloc+0x45e>
     94c:	55a040ef          	jal	4ea6 <printf>
    exit(1);
     950:	4505                	li	a0,1
     952:	134040ef          	jal	4a86 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     956:	8626                	mv	a2,s1
     958:	85da                	mv	a1,s6
     95a:	00005517          	auipc	a0,0x5
     95e:	a8e50513          	addi	a0,a0,-1394 # 53e8 <malloc+0x48e>
     962:	544040ef          	jal	4ea6 <printf>
      exit(1);
     966:	4505                	li	a0,1
     968:	11e040ef          	jal	4a86 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     96c:	8626                	mv	a2,s1
     96e:	85da                	mv	a1,s6
     970:	00005517          	auipc	a0,0x5
     974:	ab050513          	addi	a0,a0,-1360 # 5420 <malloc+0x4c6>
     978:	52e040ef          	jal	4ea6 <printf>
      exit(1);
     97c:	4505                	li	a0,1
     97e:	108040ef          	jal	4a86 <exit>
    printf("%s: error: open small failed!\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	ac450513          	addi	a0,a0,-1340 # 5448 <malloc+0x4ee>
     98c:	51a040ef          	jal	4ea6 <printf>
    exit(1);
     990:	4505                	li	a0,1
     992:	0f4040ef          	jal	4a86 <exit>
    printf("%s: read failed\n", s);
     996:	85da                	mv	a1,s6
     998:	00005517          	auipc	a0,0x5
     99c:	ad050513          	addi	a0,a0,-1328 # 5468 <malloc+0x50e>
     9a0:	506040ef          	jal	4ea6 <printf>
    exit(1);
     9a4:	4505                	li	a0,1
     9a6:	0e0040ef          	jal	4a86 <exit>
    printf("%s: unlink small failed\n", s);
     9aa:	85da                	mv	a1,s6
     9ac:	00005517          	auipc	a0,0x5
     9b0:	ad450513          	addi	a0,a0,-1324 # 5480 <malloc+0x526>
     9b4:	4f2040ef          	jal	4ea6 <printf>
    exit(1);
     9b8:	4505                	li	a0,1
     9ba:	0cc040ef          	jal	4a86 <exit>

00000000000009be <writebig>:
{
     9be:	7139                	addi	sp,sp,-64
     9c0:	fc06                	sd	ra,56(sp)
     9c2:	f822                	sd	s0,48(sp)
     9c4:	f426                	sd	s1,40(sp)
     9c6:	f04a                	sd	s2,32(sp)
     9c8:	ec4e                	sd	s3,24(sp)
     9ca:	e852                	sd	s4,16(sp)
     9cc:	e456                	sd	s5,8(sp)
     9ce:	0080                	addi	s0,sp,64
     9d0:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     9d2:	20200593          	li	a1,514
     9d6:	00005517          	auipc	a0,0x5
     9da:	aca50513          	addi	a0,a0,-1334 # 54a0 <malloc+0x546>
     9de:	0e8040ef          	jal	4ac6 <open>
     9e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e6:	0000c917          	auipc	s2,0xc
     9ea:	29290913          	addi	s2,s2,658 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ee:	6a41                	lui	s4,0x10
     9f0:	10ba0a13          	addi	s4,s4,267 # 1010b <base+0x493>
  if(fd < 0){
     9f4:	06054463          	bltz	a0,a5c <writebig+0x9e>
    ((int*)buf)[0] = i;
     9f8:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fc:	40000613          	li	a2,1024
     a00:	85ca                	mv	a1,s2
     a02:	854e                	mv	a0,s3
     a04:	0a2040ef          	jal	4aa6 <write>
     a08:	40000793          	li	a5,1024
     a0c:	06f51263          	bne	a0,a5,a70 <writebig+0xb2>
  for(i = 0; i < MAXFILE; i++){
     a10:	2485                	addiw	s1,s1,1
     a12:	ff4493e3          	bne	s1,s4,9f8 <writebig+0x3a>
  close(fd);
     a16:	854e                	mv	a0,s3
     a18:	096040ef          	jal	4aae <close>
  fd = open("big", O_RDONLY);
     a1c:	4581                	li	a1,0
     a1e:	00005517          	auipc	a0,0x5
     a22:	a8250513          	addi	a0,a0,-1406 # 54a0 <malloc+0x546>
     a26:	0a0040ef          	jal	4ac6 <open>
     a2a:	89aa                	mv	s3,a0
  n = 0;
     a2c:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2e:	0000c917          	auipc	s2,0xc
     a32:	24a90913          	addi	s2,s2,586 # cc78 <buf>
  if(fd < 0){
     a36:	04054863          	bltz	a0,a86 <writebig+0xc8>
    i = read(fd, buf, BSIZE);
     a3a:	40000613          	li	a2,1024
     a3e:	85ca                	mv	a1,s2
     a40:	854e                	mv	a0,s3
     a42:	05c040ef          	jal	4a9e <read>
    if(i == 0){
     a46:	c931                	beqz	a0,a9a <writebig+0xdc>
    } else if(i != BSIZE){
     a48:	40000793          	li	a5,1024
     a4c:	08f51b63          	bne	a0,a5,ae2 <writebig+0x124>
    if(((int*)buf)[0] != n){
     a50:	00092683          	lw	a3,0(s2)
     a54:	0a969263          	bne	a3,s1,af8 <writebig+0x13a>
    n++;
     a58:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a5a:	b7c5                	j	a3a <writebig+0x7c>
    printf("%s: error: creat big failed!\n", s);
     a5c:	85d6                	mv	a1,s5
     a5e:	00005517          	auipc	a0,0x5
     a62:	a4a50513          	addi	a0,a0,-1462 # 54a8 <malloc+0x54e>
     a66:	440040ef          	jal	4ea6 <printf>
    exit(1);
     a6a:	4505                	li	a0,1
     a6c:	01a040ef          	jal	4a86 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     a70:	8626                	mv	a2,s1
     a72:	85d6                	mv	a1,s5
     a74:	00005517          	auipc	a0,0x5
     a78:	a5450513          	addi	a0,a0,-1452 # 54c8 <malloc+0x56e>
     a7c:	42a040ef          	jal	4ea6 <printf>
      exit(1);
     a80:	4505                	li	a0,1
     a82:	004040ef          	jal	4a86 <exit>
    printf("%s: error: open big failed!\n", s);
     a86:	85d6                	mv	a1,s5
     a88:	00005517          	auipc	a0,0x5
     a8c:	a6850513          	addi	a0,a0,-1432 # 54f0 <malloc+0x596>
     a90:	416040ef          	jal	4ea6 <printf>
    exit(1);
     a94:	4505                	li	a0,1
     a96:	7f1030ef          	jal	4a86 <exit>
      if(n != MAXFILE){
     a9a:	67c1                	lui	a5,0x10
     a9c:	10b78793          	addi	a5,a5,267 # 1010b <base+0x493>
     aa0:	02f49663          	bne	s1,a5,acc <writebig+0x10e>
  close(fd);
     aa4:	854e                	mv	a0,s3
     aa6:	008040ef          	jal	4aae <close>
  if(unlink("big") < 0){
     aaa:	00005517          	auipc	a0,0x5
     aae:	9f650513          	addi	a0,a0,-1546 # 54a0 <malloc+0x546>
     ab2:	024040ef          	jal	4ad6 <unlink>
     ab6:	04054c63          	bltz	a0,b0e <writebig+0x150>
}
     aba:	70e2                	ld	ra,56(sp)
     abc:	7442                	ld	s0,48(sp)
     abe:	74a2                	ld	s1,40(sp)
     ac0:	7902                	ld	s2,32(sp)
     ac2:	69e2                	ld	s3,24(sp)
     ac4:	6a42                	ld	s4,16(sp)
     ac6:	6aa2                	ld	s5,8(sp)
     ac8:	6121                	addi	sp,sp,64
     aca:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     acc:	8626                	mv	a2,s1
     ace:	85d6                	mv	a1,s5
     ad0:	00005517          	auipc	a0,0x5
     ad4:	a4050513          	addi	a0,a0,-1472 # 5510 <malloc+0x5b6>
     ad8:	3ce040ef          	jal	4ea6 <printf>
        exit(1);
     adc:	4505                	li	a0,1
     ade:	7a9030ef          	jal	4a86 <exit>
      printf("%s: read failed %d\n", s, i);
     ae2:	862a                	mv	a2,a0
     ae4:	85d6                	mv	a1,s5
     ae6:	00005517          	auipc	a0,0x5
     aea:	a5250513          	addi	a0,a0,-1454 # 5538 <malloc+0x5de>
     aee:	3b8040ef          	jal	4ea6 <printf>
      exit(1);
     af2:	4505                	li	a0,1
     af4:	793030ef          	jal	4a86 <exit>
      printf("%s: read content of block %d is %d\n", s,
     af8:	8626                	mv	a2,s1
     afa:	85d6                	mv	a1,s5
     afc:	00005517          	auipc	a0,0x5
     b00:	a5450513          	addi	a0,a0,-1452 # 5550 <malloc+0x5f6>
     b04:	3a2040ef          	jal	4ea6 <printf>
      exit(1);
     b08:	4505                	li	a0,1
     b0a:	77d030ef          	jal	4a86 <exit>
    printf("%s: unlink big failed\n", s);
     b0e:	85d6                	mv	a1,s5
     b10:	00005517          	auipc	a0,0x5
     b14:	a6850513          	addi	a0,a0,-1432 # 5578 <malloc+0x61e>
     b18:	38e040ef          	jal	4ea6 <printf>
    exit(1);
     b1c:	4505                	li	a0,1
     b1e:	769030ef          	jal	4a86 <exit>

0000000000000b22 <unlinkread>:
{
     b22:	7179                	addi	sp,sp,-48
     b24:	f406                	sd	ra,40(sp)
     b26:	f022                	sd	s0,32(sp)
     b28:	ec26                	sd	s1,24(sp)
     b2a:	e84a                	sd	s2,16(sp)
     b2c:	e44e                	sd	s3,8(sp)
     b2e:	1800                	addi	s0,sp,48
     b30:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b32:	20200593          	li	a1,514
     b36:	00005517          	auipc	a0,0x5
     b3a:	a5a50513          	addi	a0,a0,-1446 # 5590 <malloc+0x636>
     b3e:	789030ef          	jal	4ac6 <open>
  if(fd < 0){
     b42:	0a054f63          	bltz	a0,c00 <unlinkread+0xde>
     b46:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b48:	4615                	li	a2,5
     b4a:	00005597          	auipc	a1,0x5
     b4e:	a7658593          	addi	a1,a1,-1418 # 55c0 <malloc+0x666>
     b52:	755030ef          	jal	4aa6 <write>
  close(fd);
     b56:	8526                	mv	a0,s1
     b58:	757030ef          	jal	4aae <close>
  fd = open("unlinkread", O_RDWR);
     b5c:	4589                	li	a1,2
     b5e:	00005517          	auipc	a0,0x5
     b62:	a3250513          	addi	a0,a0,-1486 # 5590 <malloc+0x636>
     b66:	761030ef          	jal	4ac6 <open>
     b6a:	84aa                	mv	s1,a0
  if(fd < 0){
     b6c:	0a054463          	bltz	a0,c14 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     b70:	00005517          	auipc	a0,0x5
     b74:	a2050513          	addi	a0,a0,-1504 # 5590 <malloc+0x636>
     b78:	75f030ef          	jal	4ad6 <unlink>
     b7c:	e555                	bnez	a0,c28 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b7e:	20200593          	li	a1,514
     b82:	00005517          	auipc	a0,0x5
     b86:	a0e50513          	addi	a0,a0,-1522 # 5590 <malloc+0x636>
     b8a:	73d030ef          	jal	4ac6 <open>
     b8e:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b90:	460d                	li	a2,3
     b92:	00005597          	auipc	a1,0x5
     b96:	a7658593          	addi	a1,a1,-1418 # 5608 <malloc+0x6ae>
     b9a:	70d030ef          	jal	4aa6 <write>
  close(fd1);
     b9e:	854a                	mv	a0,s2
     ba0:	70f030ef          	jal	4aae <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ba4:	660d                	lui	a2,0x3
     ba6:	0000c597          	auipc	a1,0xc
     baa:	0d258593          	addi	a1,a1,210 # cc78 <buf>
     bae:	8526                	mv	a0,s1
     bb0:	6ef030ef          	jal	4a9e <read>
     bb4:	4795                	li	a5,5
     bb6:	08f51363          	bne	a0,a5,c3c <unlinkread+0x11a>
  if(buf[0] != 'h'){
     bba:	0000c717          	auipc	a4,0xc
     bbe:	0be74703          	lbu	a4,190(a4) # cc78 <buf>
     bc2:	06800793          	li	a5,104
     bc6:	08f71563          	bne	a4,a5,c50 <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     bca:	4629                	li	a2,10
     bcc:	0000c597          	auipc	a1,0xc
     bd0:	0ac58593          	addi	a1,a1,172 # cc78 <buf>
     bd4:	8526                	mv	a0,s1
     bd6:	6d1030ef          	jal	4aa6 <write>
     bda:	47a9                	li	a5,10
     bdc:	08f51463          	bne	a0,a5,c64 <unlinkread+0x142>
  close(fd);
     be0:	8526                	mv	a0,s1
     be2:	6cd030ef          	jal	4aae <close>
  unlink("unlinkread");
     be6:	00005517          	auipc	a0,0x5
     bea:	9aa50513          	addi	a0,a0,-1622 # 5590 <malloc+0x636>
     bee:	6e9030ef          	jal	4ad6 <unlink>
}
     bf2:	70a2                	ld	ra,40(sp)
     bf4:	7402                	ld	s0,32(sp)
     bf6:	64e2                	ld	s1,24(sp)
     bf8:	6942                	ld	s2,16(sp)
     bfa:	69a2                	ld	s3,8(sp)
     bfc:	6145                	addi	sp,sp,48
     bfe:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c00:	85ce                	mv	a1,s3
     c02:	00005517          	auipc	a0,0x5
     c06:	99e50513          	addi	a0,a0,-1634 # 55a0 <malloc+0x646>
     c0a:	29c040ef          	jal	4ea6 <printf>
    exit(1);
     c0e:	4505                	li	a0,1
     c10:	677030ef          	jal	4a86 <exit>
    printf("%s: open unlinkread failed\n", s);
     c14:	85ce                	mv	a1,s3
     c16:	00005517          	auipc	a0,0x5
     c1a:	9b250513          	addi	a0,a0,-1614 # 55c8 <malloc+0x66e>
     c1e:	288040ef          	jal	4ea6 <printf>
    exit(1);
     c22:	4505                	li	a0,1
     c24:	663030ef          	jal	4a86 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c28:	85ce                	mv	a1,s3
     c2a:	00005517          	auipc	a0,0x5
     c2e:	9be50513          	addi	a0,a0,-1602 # 55e8 <malloc+0x68e>
     c32:	274040ef          	jal	4ea6 <printf>
    exit(1);
     c36:	4505                	li	a0,1
     c38:	64f030ef          	jal	4a86 <exit>
    printf("%s: unlinkread read failed", s);
     c3c:	85ce                	mv	a1,s3
     c3e:	00005517          	auipc	a0,0x5
     c42:	9d250513          	addi	a0,a0,-1582 # 5610 <malloc+0x6b6>
     c46:	260040ef          	jal	4ea6 <printf>
    exit(1);
     c4a:	4505                	li	a0,1
     c4c:	63b030ef          	jal	4a86 <exit>
    printf("%s: unlinkread wrong data\n", s);
     c50:	85ce                	mv	a1,s3
     c52:	00005517          	auipc	a0,0x5
     c56:	9de50513          	addi	a0,a0,-1570 # 5630 <malloc+0x6d6>
     c5a:	24c040ef          	jal	4ea6 <printf>
    exit(1);
     c5e:	4505                	li	a0,1
     c60:	627030ef          	jal	4a86 <exit>
    printf("%s: unlinkread write failed\n", s);
     c64:	85ce                	mv	a1,s3
     c66:	00005517          	auipc	a0,0x5
     c6a:	9ea50513          	addi	a0,a0,-1558 # 5650 <malloc+0x6f6>
     c6e:	238040ef          	jal	4ea6 <printf>
    exit(1);
     c72:	4505                	li	a0,1
     c74:	613030ef          	jal	4a86 <exit>

0000000000000c78 <linktest>:
{
     c78:	1101                	addi	sp,sp,-32
     c7a:	ec06                	sd	ra,24(sp)
     c7c:	e822                	sd	s0,16(sp)
     c7e:	e426                	sd	s1,8(sp)
     c80:	e04a                	sd	s2,0(sp)
     c82:	1000                	addi	s0,sp,32
     c84:	892a                	mv	s2,a0
  unlink("lf1");
     c86:	00005517          	auipc	a0,0x5
     c8a:	9ea50513          	addi	a0,a0,-1558 # 5670 <malloc+0x716>
     c8e:	649030ef          	jal	4ad6 <unlink>
  unlink("lf2");
     c92:	00005517          	auipc	a0,0x5
     c96:	9e650513          	addi	a0,a0,-1562 # 5678 <malloc+0x71e>
     c9a:	63d030ef          	jal	4ad6 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     c9e:	20200593          	li	a1,514
     ca2:	00005517          	auipc	a0,0x5
     ca6:	9ce50513          	addi	a0,a0,-1586 # 5670 <malloc+0x716>
     caa:	61d030ef          	jal	4ac6 <open>
  if(fd < 0){
     cae:	0c054f63          	bltz	a0,d8c <linktest+0x114>
     cb2:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     cb4:	4615                	li	a2,5
     cb6:	00005597          	auipc	a1,0x5
     cba:	90a58593          	addi	a1,a1,-1782 # 55c0 <malloc+0x666>
     cbe:	5e9030ef          	jal	4aa6 <write>
     cc2:	4795                	li	a5,5
     cc4:	0cf51e63          	bne	a0,a5,da0 <linktest+0x128>
  close(fd);
     cc8:	8526                	mv	a0,s1
     cca:	5e5030ef          	jal	4aae <close>
  if(link("lf1", "lf2") < 0){
     cce:	00005597          	auipc	a1,0x5
     cd2:	9aa58593          	addi	a1,a1,-1622 # 5678 <malloc+0x71e>
     cd6:	00005517          	auipc	a0,0x5
     cda:	99a50513          	addi	a0,a0,-1638 # 5670 <malloc+0x716>
     cde:	609030ef          	jal	4ae6 <link>
     ce2:	0c054963          	bltz	a0,db4 <linktest+0x13c>
  unlink("lf1");
     ce6:	00005517          	auipc	a0,0x5
     cea:	98a50513          	addi	a0,a0,-1654 # 5670 <malloc+0x716>
     cee:	5e9030ef          	jal	4ad6 <unlink>
  if(open("lf1", 0) >= 0){
     cf2:	4581                	li	a1,0
     cf4:	00005517          	auipc	a0,0x5
     cf8:	97c50513          	addi	a0,a0,-1668 # 5670 <malloc+0x716>
     cfc:	5cb030ef          	jal	4ac6 <open>
     d00:	0c055463          	bgez	a0,dc8 <linktest+0x150>
  fd = open("lf2", 0);
     d04:	4581                	li	a1,0
     d06:	00005517          	auipc	a0,0x5
     d0a:	97250513          	addi	a0,a0,-1678 # 5678 <malloc+0x71e>
     d0e:	5b9030ef          	jal	4ac6 <open>
     d12:	84aa                	mv	s1,a0
  if(fd < 0){
     d14:	0c054463          	bltz	a0,ddc <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d18:	660d                	lui	a2,0x3
     d1a:	0000c597          	auipc	a1,0xc
     d1e:	f5e58593          	addi	a1,a1,-162 # cc78 <buf>
     d22:	57d030ef          	jal	4a9e <read>
     d26:	4795                	li	a5,5
     d28:	0cf51463          	bne	a0,a5,df0 <linktest+0x178>
  close(fd);
     d2c:	8526                	mv	a0,s1
     d2e:	581030ef          	jal	4aae <close>
  if(link("lf2", "lf2") >= 0){
     d32:	00005597          	auipc	a1,0x5
     d36:	94658593          	addi	a1,a1,-1722 # 5678 <malloc+0x71e>
     d3a:	852e                	mv	a0,a1
     d3c:	5ab030ef          	jal	4ae6 <link>
     d40:	0c055263          	bgez	a0,e04 <linktest+0x18c>
  unlink("lf2");
     d44:	00005517          	auipc	a0,0x5
     d48:	93450513          	addi	a0,a0,-1740 # 5678 <malloc+0x71e>
     d4c:	58b030ef          	jal	4ad6 <unlink>
  if(link("lf2", "lf1") >= 0){
     d50:	00005597          	auipc	a1,0x5
     d54:	92058593          	addi	a1,a1,-1760 # 5670 <malloc+0x716>
     d58:	00005517          	auipc	a0,0x5
     d5c:	92050513          	addi	a0,a0,-1760 # 5678 <malloc+0x71e>
     d60:	587030ef          	jal	4ae6 <link>
     d64:	0a055a63          	bgez	a0,e18 <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     d68:	00005597          	auipc	a1,0x5
     d6c:	90858593          	addi	a1,a1,-1784 # 5670 <malloc+0x716>
     d70:	00005517          	auipc	a0,0x5
     d74:	a1050513          	addi	a0,a0,-1520 # 5780 <malloc+0x826>
     d78:	56f030ef          	jal	4ae6 <link>
     d7c:	0a055863          	bgez	a0,e2c <linktest+0x1b4>
}
     d80:	60e2                	ld	ra,24(sp)
     d82:	6442                	ld	s0,16(sp)
     d84:	64a2                	ld	s1,8(sp)
     d86:	6902                	ld	s2,0(sp)
     d88:	6105                	addi	sp,sp,32
     d8a:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     d8c:	85ca                	mv	a1,s2
     d8e:	00005517          	auipc	a0,0x5
     d92:	8f250513          	addi	a0,a0,-1806 # 5680 <malloc+0x726>
     d96:	110040ef          	jal	4ea6 <printf>
    exit(1);
     d9a:	4505                	li	a0,1
     d9c:	4eb030ef          	jal	4a86 <exit>
    printf("%s: write lf1 failed\n", s);
     da0:	85ca                	mv	a1,s2
     da2:	00005517          	auipc	a0,0x5
     da6:	8f650513          	addi	a0,a0,-1802 # 5698 <malloc+0x73e>
     daa:	0fc040ef          	jal	4ea6 <printf>
    exit(1);
     dae:	4505                	li	a0,1
     db0:	4d7030ef          	jal	4a86 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     db4:	85ca                	mv	a1,s2
     db6:	00005517          	auipc	a0,0x5
     dba:	8fa50513          	addi	a0,a0,-1798 # 56b0 <malloc+0x756>
     dbe:	0e8040ef          	jal	4ea6 <printf>
    exit(1);
     dc2:	4505                	li	a0,1
     dc4:	4c3030ef          	jal	4a86 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     dc8:	85ca                	mv	a1,s2
     dca:	00005517          	auipc	a0,0x5
     dce:	90650513          	addi	a0,a0,-1786 # 56d0 <malloc+0x776>
     dd2:	0d4040ef          	jal	4ea6 <printf>
    exit(1);
     dd6:	4505                	li	a0,1
     dd8:	4af030ef          	jal	4a86 <exit>
    printf("%s: open lf2 failed\n", s);
     ddc:	85ca                	mv	a1,s2
     dde:	00005517          	auipc	a0,0x5
     de2:	92250513          	addi	a0,a0,-1758 # 5700 <malloc+0x7a6>
     de6:	0c0040ef          	jal	4ea6 <printf>
    exit(1);
     dea:	4505                	li	a0,1
     dec:	49b030ef          	jal	4a86 <exit>
    printf("%s: read lf2 failed\n", s);
     df0:	85ca                	mv	a1,s2
     df2:	00005517          	auipc	a0,0x5
     df6:	92650513          	addi	a0,a0,-1754 # 5718 <malloc+0x7be>
     dfa:	0ac040ef          	jal	4ea6 <printf>
    exit(1);
     dfe:	4505                	li	a0,1
     e00:	487030ef          	jal	4a86 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e04:	85ca                	mv	a1,s2
     e06:	00005517          	auipc	a0,0x5
     e0a:	92a50513          	addi	a0,a0,-1750 # 5730 <malloc+0x7d6>
     e0e:	098040ef          	jal	4ea6 <printf>
    exit(1);
     e12:	4505                	li	a0,1
     e14:	473030ef          	jal	4a86 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e18:	85ca                	mv	a1,s2
     e1a:	00005517          	auipc	a0,0x5
     e1e:	93e50513          	addi	a0,a0,-1730 # 5758 <malloc+0x7fe>
     e22:	084040ef          	jal	4ea6 <printf>
    exit(1);
     e26:	4505                	li	a0,1
     e28:	45f030ef          	jal	4a86 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e2c:	85ca                	mv	a1,s2
     e2e:	00005517          	auipc	a0,0x5
     e32:	95a50513          	addi	a0,a0,-1702 # 5788 <malloc+0x82e>
     e36:	070040ef          	jal	4ea6 <printf>
    exit(1);
     e3a:	4505                	li	a0,1
     e3c:	44b030ef          	jal	4a86 <exit>

0000000000000e40 <validatetest>:
{
     e40:	7139                	addi	sp,sp,-64
     e42:	fc06                	sd	ra,56(sp)
     e44:	f822                	sd	s0,48(sp)
     e46:	f426                	sd	s1,40(sp)
     e48:	f04a                	sd	s2,32(sp)
     e4a:	ec4e                	sd	s3,24(sp)
     e4c:	e852                	sd	s4,16(sp)
     e4e:	e456                	sd	s5,8(sp)
     e50:	e05a                	sd	s6,0(sp)
     e52:	0080                	addi	s0,sp,64
     e54:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e56:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     e58:	00005997          	auipc	s3,0x5
     e5c:	95098993          	addi	s3,s3,-1712 # 57a8 <malloc+0x84e>
     e60:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e62:	6a85                	lui	s5,0x1
     e64:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     e68:	85a6                	mv	a1,s1
     e6a:	854e                	mv	a0,s3
     e6c:	47b030ef          	jal	4ae6 <link>
     e70:	01251f63          	bne	a0,s2,e8e <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e74:	94d6                	add	s1,s1,s5
     e76:	ff4499e3          	bne	s1,s4,e68 <validatetest+0x28>
}
     e7a:	70e2                	ld	ra,56(sp)
     e7c:	7442                	ld	s0,48(sp)
     e7e:	74a2                	ld	s1,40(sp)
     e80:	7902                	ld	s2,32(sp)
     e82:	69e2                	ld	s3,24(sp)
     e84:	6a42                	ld	s4,16(sp)
     e86:	6aa2                	ld	s5,8(sp)
     e88:	6b02                	ld	s6,0(sp)
     e8a:	6121                	addi	sp,sp,64
     e8c:	8082                	ret
      printf("%s: link should not succeed\n", s);
     e8e:	85da                	mv	a1,s6
     e90:	00005517          	auipc	a0,0x5
     e94:	92850513          	addi	a0,a0,-1752 # 57b8 <malloc+0x85e>
     e98:	00e040ef          	jal	4ea6 <printf>
      exit(1);
     e9c:	4505                	li	a0,1
     e9e:	3e9030ef          	jal	4a86 <exit>

0000000000000ea2 <bigdir>:
{
     ea2:	715d                	addi	sp,sp,-80
     ea4:	e486                	sd	ra,72(sp)
     ea6:	e0a2                	sd	s0,64(sp)
     ea8:	fc26                	sd	s1,56(sp)
     eaa:	f84a                	sd	s2,48(sp)
     eac:	f44e                	sd	s3,40(sp)
     eae:	f052                	sd	s4,32(sp)
     eb0:	ec56                	sd	s5,24(sp)
     eb2:	e85a                	sd	s6,16(sp)
     eb4:	0880                	addi	s0,sp,80
     eb6:	89aa                	mv	s3,a0
  unlink("bd");
     eb8:	00005517          	auipc	a0,0x5
     ebc:	92050513          	addi	a0,a0,-1760 # 57d8 <malloc+0x87e>
     ec0:	417030ef          	jal	4ad6 <unlink>
  fd = open("bd", O_CREATE);
     ec4:	20000593          	li	a1,512
     ec8:	00005517          	auipc	a0,0x5
     ecc:	91050513          	addi	a0,a0,-1776 # 57d8 <malloc+0x87e>
     ed0:	3f7030ef          	jal	4ac6 <open>
  if(fd < 0){
     ed4:	0c054163          	bltz	a0,f96 <bigdir+0xf4>
  close(fd);
     ed8:	3d7030ef          	jal	4aae <close>
  for(i = 0; i < N; i++){
     edc:	4901                	li	s2,0
    name[0] = 'x';
     ede:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     ee2:	00005a17          	auipc	s4,0x5
     ee6:	8f6a0a13          	addi	s4,s4,-1802 # 57d8 <malloc+0x87e>
  for(i = 0; i < N; i++){
     eea:	1f400b13          	li	s6,500
    name[0] = 'x';
     eee:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     ef2:	41f9571b          	sraiw	a4,s2,0x1f
     ef6:	01a7571b          	srliw	a4,a4,0x1a
     efa:	012707bb          	addw	a5,a4,s2
     efe:	4067d69b          	sraiw	a3,a5,0x6
     f02:	0306869b          	addiw	a3,a3,48
     f06:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f0a:	03f7f793          	andi	a5,a5,63
     f0e:	9f99                	subw	a5,a5,a4
     f10:	0307879b          	addiw	a5,a5,48
     f14:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f18:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     f1c:	fb040593          	addi	a1,s0,-80
     f20:	8552                	mv	a0,s4
     f22:	3c5030ef          	jal	4ae6 <link>
     f26:	84aa                	mv	s1,a0
     f28:	e149                	bnez	a0,faa <bigdir+0x108>
  for(i = 0; i < N; i++){
     f2a:	2905                	addiw	s2,s2,1
     f2c:	fd6911e3          	bne	s2,s6,eee <bigdir+0x4c>
  unlink("bd");
     f30:	00005517          	auipc	a0,0x5
     f34:	8a850513          	addi	a0,a0,-1880 # 57d8 <malloc+0x87e>
     f38:	39f030ef          	jal	4ad6 <unlink>
    name[0] = 'x';
     f3c:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
     f40:	1f400a13          	li	s4,500
    name[0] = 'x';
     f44:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f48:	41f4d71b          	sraiw	a4,s1,0x1f
     f4c:	01a7571b          	srliw	a4,a4,0x1a
     f50:	009707bb          	addw	a5,a4,s1
     f54:	4067d69b          	sraiw	a3,a5,0x6
     f58:	0306869b          	addiw	a3,a3,48
     f5c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f60:	03f7f793          	andi	a5,a5,63
     f64:	9f99                	subw	a5,a5,a4
     f66:	0307879b          	addiw	a5,a5,48
     f6a:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f6e:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
     f72:	fb040513          	addi	a0,s0,-80
     f76:	361030ef          	jal	4ad6 <unlink>
     f7a:	e529                	bnez	a0,fc4 <bigdir+0x122>
  for(i = 0; i < N; i++){
     f7c:	2485                	addiw	s1,s1,1
     f7e:	fd4493e3          	bne	s1,s4,f44 <bigdir+0xa2>
}
     f82:	60a6                	ld	ra,72(sp)
     f84:	6406                	ld	s0,64(sp)
     f86:	74e2                	ld	s1,56(sp)
     f88:	7942                	ld	s2,48(sp)
     f8a:	79a2                	ld	s3,40(sp)
     f8c:	7a02                	ld	s4,32(sp)
     f8e:	6ae2                	ld	s5,24(sp)
     f90:	6b42                	ld	s6,16(sp)
     f92:	6161                	addi	sp,sp,80
     f94:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     f96:	85ce                	mv	a1,s3
     f98:	00005517          	auipc	a0,0x5
     f9c:	84850513          	addi	a0,a0,-1976 # 57e0 <malloc+0x886>
     fa0:	707030ef          	jal	4ea6 <printf>
    exit(1);
     fa4:	4505                	li	a0,1
     fa6:	2e1030ef          	jal	4a86 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     faa:	fb040693          	addi	a3,s0,-80
     fae:	864a                	mv	a2,s2
     fb0:	85ce                	mv	a1,s3
     fb2:	00005517          	auipc	a0,0x5
     fb6:	84e50513          	addi	a0,a0,-1970 # 5800 <malloc+0x8a6>
     fba:	6ed030ef          	jal	4ea6 <printf>
      exit(1);
     fbe:	4505                	li	a0,1
     fc0:	2c7030ef          	jal	4a86 <exit>
      printf("%s: bigdir unlink failed", s);
     fc4:	85ce                	mv	a1,s3
     fc6:	00005517          	auipc	a0,0x5
     fca:	86250513          	addi	a0,a0,-1950 # 5828 <malloc+0x8ce>
     fce:	6d9030ef          	jal	4ea6 <printf>
      exit(1);
     fd2:	4505                	li	a0,1
     fd4:	2b3030ef          	jal	4a86 <exit>

0000000000000fd8 <pgbug>:
{
     fd8:	7179                	addi	sp,sp,-48
     fda:	f406                	sd	ra,40(sp)
     fdc:	f022                	sd	s0,32(sp)
     fde:	ec26                	sd	s1,24(sp)
     fe0:	1800                	addi	s0,sp,48
  argv[0] = 0;
     fe2:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     fe6:	00008497          	auipc	s1,0x8
     fea:	01a48493          	addi	s1,s1,26 # 9000 <big>
     fee:	fd840593          	addi	a1,s0,-40
     ff2:	6088                	ld	a0,0(s1)
     ff4:	2cb030ef          	jal	4abe <exec>
  pipe(big);
     ff8:	6088                	ld	a0,0(s1)
     ffa:	29d030ef          	jal	4a96 <pipe>
  exit(0);
     ffe:	4501                	li	a0,0
    1000:	287030ef          	jal	4a86 <exit>

0000000000001004 <badarg>:
{
    1004:	7139                	addi	sp,sp,-64
    1006:	fc06                	sd	ra,56(sp)
    1008:	f822                	sd	s0,48(sp)
    100a:	f426                	sd	s1,40(sp)
    100c:	f04a                	sd	s2,32(sp)
    100e:	ec4e                	sd	s3,24(sp)
    1010:	0080                	addi	s0,sp,64
    1012:	64b1                	lui	s1,0xc
    1014:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1018:	597d                	li	s2,-1
    101a:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    101e:	00004997          	auipc	s3,0x4
    1022:	07a98993          	addi	s3,s3,122 # 5098 <malloc+0x13e>
    argv[0] = (char*)0xffffffff;
    1026:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    102a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    102e:	fc040593          	addi	a1,s0,-64
    1032:	854e                	mv	a0,s3
    1034:	28b030ef          	jal	4abe <exec>
  for(int i = 0; i < 50000; i++){
    1038:	34fd                	addiw	s1,s1,-1
    103a:	f4f5                	bnez	s1,1026 <badarg+0x22>
  exit(0);
    103c:	4501                	li	a0,0
    103e:	249030ef          	jal	4a86 <exit>

0000000000001042 <copyinstr2>:
{
    1042:	7155                	addi	sp,sp,-208
    1044:	e586                	sd	ra,200(sp)
    1046:	e1a2                	sd	s0,192(sp)
    1048:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    104a:	f6840793          	addi	a5,s0,-152
    104e:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    1052:	07800713          	li	a4,120
    1056:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    105a:	0785                	addi	a5,a5,1
    105c:	fed79de3          	bne	a5,a3,1056 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    1060:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1064:	f6840513          	addi	a0,s0,-152
    1068:	26f030ef          	jal	4ad6 <unlink>
  if(ret != -1){
    106c:	57fd                	li	a5,-1
    106e:	0cf51263          	bne	a0,a5,1132 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    1072:	20100593          	li	a1,513
    1076:	f6840513          	addi	a0,s0,-152
    107a:	24d030ef          	jal	4ac6 <open>
  if(fd != -1){
    107e:	57fd                	li	a5,-1
    1080:	0cf51563          	bne	a0,a5,114a <copyinstr2+0x108>
  ret = link(b, b);
    1084:	f6840593          	addi	a1,s0,-152
    1088:	852e                	mv	a0,a1
    108a:	25d030ef          	jal	4ae6 <link>
  if(ret != -1){
    108e:	57fd                	li	a5,-1
    1090:	0cf51963          	bne	a0,a5,1162 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    1094:	00006797          	auipc	a5,0x6
    1098:	8e478793          	addi	a5,a5,-1820 # 6978 <malloc+0x1a1e>
    109c:	f4f43c23          	sd	a5,-168(s0)
    10a0:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10a4:	f5840593          	addi	a1,s0,-168
    10a8:	f6840513          	addi	a0,s0,-152
    10ac:	213030ef          	jal	4abe <exec>
  if(ret != -1){
    10b0:	57fd                	li	a5,-1
    10b2:	0cf51563          	bne	a0,a5,117c <copyinstr2+0x13a>
  int pid = fork();
    10b6:	1c9030ef          	jal	4a7e <fork>
  if(pid < 0){
    10ba:	0c054d63          	bltz	a0,1194 <copyinstr2+0x152>
  if(pid == 0){
    10be:	0e051863          	bnez	a0,11ae <copyinstr2+0x16c>
    10c2:	00008797          	auipc	a5,0x8
    10c6:	49e78793          	addi	a5,a5,1182 # 9560 <big.0>
    10ca:	00009697          	auipc	a3,0x9
    10ce:	49668693          	addi	a3,a3,1174 # a560 <big.0+0x1000>
      big[i] = 'x';
    10d2:	07800713          	li	a4,120
    10d6:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    10da:	0785                	addi	a5,a5,1
    10dc:	fed79de3          	bne	a5,a3,10d6 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    10e0:	00009797          	auipc	a5,0x9
    10e4:	48078023          	sb	zero,1152(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    10e8:	00006797          	auipc	a5,0x6
    10ec:	31078793          	addi	a5,a5,784 # 73f8 <malloc+0x249e>
    10f0:	6fb0                	ld	a2,88(a5)
    10f2:	73b4                	ld	a3,96(a5)
    10f4:	77b8                	ld	a4,104(a5)
    10f6:	7bbc                	ld	a5,112(a5)
    10f8:	f2c43823          	sd	a2,-208(s0)
    10fc:	f2d43c23          	sd	a3,-200(s0)
    1100:	f4e43023          	sd	a4,-192(s0)
    1104:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1108:	f3040593          	addi	a1,s0,-208
    110c:	00004517          	auipc	a0,0x4
    1110:	f8c50513          	addi	a0,a0,-116 # 5098 <malloc+0x13e>
    1114:	1ab030ef          	jal	4abe <exec>
    if(ret != -1){
    1118:	57fd                	li	a5,-1
    111a:	08f50663          	beq	a0,a5,11a6 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    111e:	55fd                	li	a1,-1
    1120:	00004517          	auipc	a0,0x4
    1124:	7b050513          	addi	a0,a0,1968 # 58d0 <malloc+0x976>
    1128:	57f030ef          	jal	4ea6 <printf>
      exit(1);
    112c:	4505                	li	a0,1
    112e:	159030ef          	jal	4a86 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1132:	862a                	mv	a2,a0
    1134:	f6840593          	addi	a1,s0,-152
    1138:	00004517          	auipc	a0,0x4
    113c:	71050513          	addi	a0,a0,1808 # 5848 <malloc+0x8ee>
    1140:	567030ef          	jal	4ea6 <printf>
    exit(1);
    1144:	4505                	li	a0,1
    1146:	141030ef          	jal	4a86 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    114a:	862a                	mv	a2,a0
    114c:	f6840593          	addi	a1,s0,-152
    1150:	00004517          	auipc	a0,0x4
    1154:	71850513          	addi	a0,a0,1816 # 5868 <malloc+0x90e>
    1158:	54f030ef          	jal	4ea6 <printf>
    exit(1);
    115c:	4505                	li	a0,1
    115e:	129030ef          	jal	4a86 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1162:	86aa                	mv	a3,a0
    1164:	f6840613          	addi	a2,s0,-152
    1168:	85b2                	mv	a1,a2
    116a:	00004517          	auipc	a0,0x4
    116e:	71e50513          	addi	a0,a0,1822 # 5888 <malloc+0x92e>
    1172:	535030ef          	jal	4ea6 <printf>
    exit(1);
    1176:	4505                	li	a0,1
    1178:	10f030ef          	jal	4a86 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    117c:	567d                	li	a2,-1
    117e:	f6840593          	addi	a1,s0,-152
    1182:	00004517          	auipc	a0,0x4
    1186:	72e50513          	addi	a0,a0,1838 # 58b0 <malloc+0x956>
    118a:	51d030ef          	jal	4ea6 <printf>
    exit(1);
    118e:	4505                	li	a0,1
    1190:	0f7030ef          	jal	4a86 <exit>
    printf("fork failed\n");
    1194:	00006517          	auipc	a0,0x6
    1198:	d0450513          	addi	a0,a0,-764 # 6e98 <malloc+0x1f3e>
    119c:	50b030ef          	jal	4ea6 <printf>
    exit(1);
    11a0:	4505                	li	a0,1
    11a2:	0e5030ef          	jal	4a86 <exit>
    exit(747); // OK
    11a6:	2eb00513          	li	a0,747
    11aa:	0dd030ef          	jal	4a86 <exit>
  int st = 0;
    11ae:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    11b2:	f5440513          	addi	a0,s0,-172
    11b6:	0d9030ef          	jal	4a8e <wait>
  if(st != 747){
    11ba:	f5442703          	lw	a4,-172(s0)
    11be:	2eb00793          	li	a5,747
    11c2:	00f71663          	bne	a4,a5,11ce <copyinstr2+0x18c>
}
    11c6:	60ae                	ld	ra,200(sp)
    11c8:	640e                	ld	s0,192(sp)
    11ca:	6169                	addi	sp,sp,208
    11cc:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    11ce:	00004517          	auipc	a0,0x4
    11d2:	72a50513          	addi	a0,a0,1834 # 58f8 <malloc+0x99e>
    11d6:	4d1030ef          	jal	4ea6 <printf>
    exit(1);
    11da:	4505                	li	a0,1
    11dc:	0ab030ef          	jal	4a86 <exit>

00000000000011e0 <truncate3>:
{
    11e0:	7159                	addi	sp,sp,-112
    11e2:	f486                	sd	ra,104(sp)
    11e4:	f0a2                	sd	s0,96(sp)
    11e6:	e8ca                	sd	s2,80(sp)
    11e8:	1880                	addi	s0,sp,112
    11ea:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    11ec:	60100593          	li	a1,1537
    11f0:	00004517          	auipc	a0,0x4
    11f4:	f0050513          	addi	a0,a0,-256 # 50f0 <malloc+0x196>
    11f8:	0cf030ef          	jal	4ac6 <open>
    11fc:	0b3030ef          	jal	4aae <close>
  pid = fork();
    1200:	07f030ef          	jal	4a7e <fork>
  if(pid < 0){
    1204:	06054663          	bltz	a0,1270 <truncate3+0x90>
  if(pid == 0){
    1208:	e55d                	bnez	a0,12b6 <truncate3+0xd6>
    120a:	eca6                	sd	s1,88(sp)
    120c:	e4ce                	sd	s3,72(sp)
    120e:	e0d2                	sd	s4,64(sp)
    1210:	fc56                	sd	s5,56(sp)
    1212:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1216:	00004a17          	auipc	s4,0x4
    121a:	edaa0a13          	addi	s4,s4,-294 # 50f0 <malloc+0x196>
      int n = write(fd, "1234567890", 10);
    121e:	00004a97          	auipc	s5,0x4
    1222:	73aa8a93          	addi	s5,s5,1850 # 5958 <malloc+0x9fe>
      int fd = open("truncfile", O_WRONLY);
    1226:	4585                	li	a1,1
    1228:	8552                	mv	a0,s4
    122a:	09d030ef          	jal	4ac6 <open>
    122e:	84aa                	mv	s1,a0
      if(fd < 0){
    1230:	04054e63          	bltz	a0,128c <truncate3+0xac>
      int n = write(fd, "1234567890", 10);
    1234:	4629                	li	a2,10
    1236:	85d6                	mv	a1,s5
    1238:	06f030ef          	jal	4aa6 <write>
      if(n != 10){
    123c:	47a9                	li	a5,10
    123e:	06f51163          	bne	a0,a5,12a0 <truncate3+0xc0>
      close(fd);
    1242:	8526                	mv	a0,s1
    1244:	06b030ef          	jal	4aae <close>
      fd = open("truncfile", O_RDONLY);
    1248:	4581                	li	a1,0
    124a:	8552                	mv	a0,s4
    124c:	07b030ef          	jal	4ac6 <open>
    1250:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1252:	02000613          	li	a2,32
    1256:	f9840593          	addi	a1,s0,-104
    125a:	045030ef          	jal	4a9e <read>
      close(fd);
    125e:	8526                	mv	a0,s1
    1260:	04f030ef          	jal	4aae <close>
    for(int i = 0; i < 100; i++){
    1264:	39fd                	addiw	s3,s3,-1
    1266:	fc0990e3          	bnez	s3,1226 <truncate3+0x46>
    exit(0);
    126a:	4501                	li	a0,0
    126c:	01b030ef          	jal	4a86 <exit>
    1270:	eca6                	sd	s1,88(sp)
    1272:	e4ce                	sd	s3,72(sp)
    1274:	e0d2                	sd	s4,64(sp)
    1276:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1278:	85ca                	mv	a1,s2
    127a:	00004517          	auipc	a0,0x4
    127e:	6ae50513          	addi	a0,a0,1710 # 5928 <malloc+0x9ce>
    1282:	425030ef          	jal	4ea6 <printf>
    exit(1);
    1286:	4505                	li	a0,1
    1288:	7fe030ef          	jal	4a86 <exit>
        printf("%s: open failed\n", s);
    128c:	85ca                	mv	a1,s2
    128e:	00004517          	auipc	a0,0x4
    1292:	6b250513          	addi	a0,a0,1714 # 5940 <malloc+0x9e6>
    1296:	411030ef          	jal	4ea6 <printf>
        exit(1);
    129a:	4505                	li	a0,1
    129c:	7ea030ef          	jal	4a86 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    12a0:	862a                	mv	a2,a0
    12a2:	85ca                	mv	a1,s2
    12a4:	00004517          	auipc	a0,0x4
    12a8:	6c450513          	addi	a0,a0,1732 # 5968 <malloc+0xa0e>
    12ac:	3fb030ef          	jal	4ea6 <printf>
        exit(1);
    12b0:	4505                	li	a0,1
    12b2:	7d4030ef          	jal	4a86 <exit>
    12b6:	eca6                	sd	s1,88(sp)
    12b8:	e4ce                	sd	s3,72(sp)
    12ba:	e0d2                	sd	s4,64(sp)
    12bc:	fc56                	sd	s5,56(sp)
    12be:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12c2:	00004a17          	auipc	s4,0x4
    12c6:	e2ea0a13          	addi	s4,s4,-466 # 50f0 <malloc+0x196>
    int n = write(fd, "xxx", 3);
    12ca:	00004a97          	auipc	s5,0x4
    12ce:	6bea8a93          	addi	s5,s5,1726 # 5988 <malloc+0xa2e>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12d2:	60100593          	li	a1,1537
    12d6:	8552                	mv	a0,s4
    12d8:	7ee030ef          	jal	4ac6 <open>
    12dc:	84aa                	mv	s1,a0
    if(fd < 0){
    12de:	02054d63          	bltz	a0,1318 <truncate3+0x138>
    int n = write(fd, "xxx", 3);
    12e2:	460d                	li	a2,3
    12e4:	85d6                	mv	a1,s5
    12e6:	7c0030ef          	jal	4aa6 <write>
    if(n != 3){
    12ea:	478d                	li	a5,3
    12ec:	04f51063          	bne	a0,a5,132c <truncate3+0x14c>
    close(fd);
    12f0:	8526                	mv	a0,s1
    12f2:	7bc030ef          	jal	4aae <close>
  for(int i = 0; i < 150; i++){
    12f6:	39fd                	addiw	s3,s3,-1
    12f8:	fc099de3          	bnez	s3,12d2 <truncate3+0xf2>
  wait(&xstatus);
    12fc:	fbc40513          	addi	a0,s0,-68
    1300:	78e030ef          	jal	4a8e <wait>
  unlink("truncfile");
    1304:	00004517          	auipc	a0,0x4
    1308:	dec50513          	addi	a0,a0,-532 # 50f0 <malloc+0x196>
    130c:	7ca030ef          	jal	4ad6 <unlink>
  exit(xstatus);
    1310:	fbc42503          	lw	a0,-68(s0)
    1314:	772030ef          	jal	4a86 <exit>
      printf("%s: open failed\n", s);
    1318:	85ca                	mv	a1,s2
    131a:	00004517          	auipc	a0,0x4
    131e:	62650513          	addi	a0,a0,1574 # 5940 <malloc+0x9e6>
    1322:	385030ef          	jal	4ea6 <printf>
      exit(1);
    1326:	4505                	li	a0,1
    1328:	75e030ef          	jal	4a86 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    132c:	862a                	mv	a2,a0
    132e:	85ca                	mv	a1,s2
    1330:	00004517          	auipc	a0,0x4
    1334:	66050513          	addi	a0,a0,1632 # 5990 <malloc+0xa36>
    1338:	36f030ef          	jal	4ea6 <printf>
      exit(1);
    133c:	4505                	li	a0,1
    133e:	748030ef          	jal	4a86 <exit>

0000000000001342 <exectest>:
{
    1342:	715d                	addi	sp,sp,-80
    1344:	e486                	sd	ra,72(sp)
    1346:	e0a2                	sd	s0,64(sp)
    1348:	f84a                	sd	s2,48(sp)
    134a:	0880                	addi	s0,sp,80
    134c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    134e:	00004797          	auipc	a5,0x4
    1352:	d4a78793          	addi	a5,a5,-694 # 5098 <malloc+0x13e>
    1356:	fcf43023          	sd	a5,-64(s0)
    135a:	00004797          	auipc	a5,0x4
    135e:	65678793          	addi	a5,a5,1622 # 59b0 <malloc+0xa56>
    1362:	fcf43423          	sd	a5,-56(s0)
    1366:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    136a:	00004517          	auipc	a0,0x4
    136e:	64e50513          	addi	a0,a0,1614 # 59b8 <malloc+0xa5e>
    1372:	764030ef          	jal	4ad6 <unlink>
  pid = fork();
    1376:	708030ef          	jal	4a7e <fork>
  if(pid < 0) {
    137a:	02054f63          	bltz	a0,13b8 <exectest+0x76>
    137e:	fc26                	sd	s1,56(sp)
    1380:	84aa                	mv	s1,a0
  if(pid == 0) {
    1382:	e935                	bnez	a0,13f6 <exectest+0xb4>
    close(1);
    1384:	4505                	li	a0,1
    1386:	728030ef          	jal	4aae <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    138a:	20100593          	li	a1,513
    138e:	00004517          	auipc	a0,0x4
    1392:	62a50513          	addi	a0,a0,1578 # 59b8 <malloc+0xa5e>
    1396:	730030ef          	jal	4ac6 <open>
    if(fd < 0) {
    139a:	02054a63          	bltz	a0,13ce <exectest+0x8c>
    if(fd != 1) {
    139e:	4785                	li	a5,1
    13a0:	04f50163          	beq	a0,a5,13e2 <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    13a4:	85ca                	mv	a1,s2
    13a6:	00004517          	auipc	a0,0x4
    13aa:	63250513          	addi	a0,a0,1586 # 59d8 <malloc+0xa7e>
    13ae:	2f9030ef          	jal	4ea6 <printf>
      exit(1);
    13b2:	4505                	li	a0,1
    13b4:	6d2030ef          	jal	4a86 <exit>
    13b8:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    13ba:	85ca                	mv	a1,s2
    13bc:	00004517          	auipc	a0,0x4
    13c0:	56c50513          	addi	a0,a0,1388 # 5928 <malloc+0x9ce>
    13c4:	2e3030ef          	jal	4ea6 <printf>
     exit(1);
    13c8:	4505                	li	a0,1
    13ca:	6bc030ef          	jal	4a86 <exit>
      printf("%s: create failed\n", s);
    13ce:	85ca                	mv	a1,s2
    13d0:	00004517          	auipc	a0,0x4
    13d4:	5f050513          	addi	a0,a0,1520 # 59c0 <malloc+0xa66>
    13d8:	2cf030ef          	jal	4ea6 <printf>
      exit(1);
    13dc:	4505                	li	a0,1
    13de:	6a8030ef          	jal	4a86 <exit>
    if(exec("echo", echoargv) < 0){
    13e2:	fc040593          	addi	a1,s0,-64
    13e6:	00004517          	auipc	a0,0x4
    13ea:	cb250513          	addi	a0,a0,-846 # 5098 <malloc+0x13e>
    13ee:	6d0030ef          	jal	4abe <exec>
    13f2:	00054d63          	bltz	a0,140c <exectest+0xca>
  if (wait(&xstatus) != pid) {
    13f6:	fdc40513          	addi	a0,s0,-36
    13fa:	694030ef          	jal	4a8e <wait>
    13fe:	02951163          	bne	a0,s1,1420 <exectest+0xde>
  if(xstatus != 0)
    1402:	fdc42503          	lw	a0,-36(s0)
    1406:	c50d                	beqz	a0,1430 <exectest+0xee>
    exit(xstatus);
    1408:	67e030ef          	jal	4a86 <exit>
      printf("%s: exec echo failed\n", s);
    140c:	85ca                	mv	a1,s2
    140e:	00004517          	auipc	a0,0x4
    1412:	5da50513          	addi	a0,a0,1498 # 59e8 <malloc+0xa8e>
    1416:	291030ef          	jal	4ea6 <printf>
      exit(1);
    141a:	4505                	li	a0,1
    141c:	66a030ef          	jal	4a86 <exit>
    printf("%s: wait failed!\n", s);
    1420:	85ca                	mv	a1,s2
    1422:	00004517          	auipc	a0,0x4
    1426:	5de50513          	addi	a0,a0,1502 # 5a00 <malloc+0xaa6>
    142a:	27d030ef          	jal	4ea6 <printf>
    142e:	bfd1                	j	1402 <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    1430:	4581                	li	a1,0
    1432:	00004517          	auipc	a0,0x4
    1436:	58650513          	addi	a0,a0,1414 # 59b8 <malloc+0xa5e>
    143a:	68c030ef          	jal	4ac6 <open>
  if(fd < 0) {
    143e:	02054463          	bltz	a0,1466 <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    1442:	4609                	li	a2,2
    1444:	fb840593          	addi	a1,s0,-72
    1448:	656030ef          	jal	4a9e <read>
    144c:	4789                	li	a5,2
    144e:	02f50663          	beq	a0,a5,147a <exectest+0x138>
    printf("%s: read failed\n", s);
    1452:	85ca                	mv	a1,s2
    1454:	00004517          	auipc	a0,0x4
    1458:	01450513          	addi	a0,a0,20 # 5468 <malloc+0x50e>
    145c:	24b030ef          	jal	4ea6 <printf>
    exit(1);
    1460:	4505                	li	a0,1
    1462:	624030ef          	jal	4a86 <exit>
    printf("%s: open failed\n", s);
    1466:	85ca                	mv	a1,s2
    1468:	00004517          	auipc	a0,0x4
    146c:	4d850513          	addi	a0,a0,1240 # 5940 <malloc+0x9e6>
    1470:	237030ef          	jal	4ea6 <printf>
    exit(1);
    1474:	4505                	li	a0,1
    1476:	610030ef          	jal	4a86 <exit>
  unlink("echo-ok");
    147a:	00004517          	auipc	a0,0x4
    147e:	53e50513          	addi	a0,a0,1342 # 59b8 <malloc+0xa5e>
    1482:	654030ef          	jal	4ad6 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1486:	fb844703          	lbu	a4,-72(s0)
    148a:	04f00793          	li	a5,79
    148e:	00f71863          	bne	a4,a5,149e <exectest+0x15c>
    1492:	fb944703          	lbu	a4,-71(s0)
    1496:	04b00793          	li	a5,75
    149a:	00f70c63          	beq	a4,a5,14b2 <exectest+0x170>
    printf("%s: wrong output\n", s);
    149e:	85ca                	mv	a1,s2
    14a0:	00004517          	auipc	a0,0x4
    14a4:	57850513          	addi	a0,a0,1400 # 5a18 <malloc+0xabe>
    14a8:	1ff030ef          	jal	4ea6 <printf>
    exit(1);
    14ac:	4505                	li	a0,1
    14ae:	5d8030ef          	jal	4a86 <exit>
    exit(0);
    14b2:	4501                	li	a0,0
    14b4:	5d2030ef          	jal	4a86 <exit>

00000000000014b8 <pipe1>:
{
    14b8:	711d                	addi	sp,sp,-96
    14ba:	ec86                	sd	ra,88(sp)
    14bc:	e8a2                	sd	s0,80(sp)
    14be:	fc4e                	sd	s3,56(sp)
    14c0:	1080                	addi	s0,sp,96
    14c2:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    14c4:	fa840513          	addi	a0,s0,-88
    14c8:	5ce030ef          	jal	4a96 <pipe>
    14cc:	e92d                	bnez	a0,153e <pipe1+0x86>
    14ce:	e4a6                	sd	s1,72(sp)
    14d0:	f852                	sd	s4,48(sp)
    14d2:	84aa                	mv	s1,a0
  pid = fork();
    14d4:	5aa030ef          	jal	4a7e <fork>
    14d8:	8a2a                	mv	s4,a0
  if(pid == 0){
    14da:	c151                	beqz	a0,155e <pipe1+0xa6>
  } else if(pid > 0){
    14dc:	14a05e63          	blez	a0,1638 <pipe1+0x180>
    14e0:	e0ca                	sd	s2,64(sp)
    14e2:	f456                	sd	s5,40(sp)
    close(fds[1]);
    14e4:	fac42503          	lw	a0,-84(s0)
    14e8:	5c6030ef          	jal	4aae <close>
    total = 0;
    14ec:	8a26                	mv	s4,s1
    cc = 1;
    14ee:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    14f0:	0000ba97          	auipc	s5,0xb
    14f4:	788a8a93          	addi	s5,s5,1928 # cc78 <buf>
    14f8:	864a                	mv	a2,s2
    14fa:	85d6                	mv	a1,s5
    14fc:	fa842503          	lw	a0,-88(s0)
    1500:	59e030ef          	jal	4a9e <read>
    1504:	0ea05a63          	blez	a0,15f8 <pipe1+0x140>
      for(i = 0; i < n; i++){
    1508:	0000b717          	auipc	a4,0xb
    150c:	77070713          	addi	a4,a4,1904 # cc78 <buf>
    1510:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1514:	00074683          	lbu	a3,0(a4)
    1518:	0ff4f793          	zext.b	a5,s1
    151c:	2485                	addiw	s1,s1,1
    151e:	0af69d63          	bne	a3,a5,15d8 <pipe1+0x120>
      for(i = 0; i < n; i++){
    1522:	0705                	addi	a4,a4,1
    1524:	fec498e3          	bne	s1,a2,1514 <pipe1+0x5c>
      total += n;
    1528:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    152c:	0019179b          	slliw	a5,s2,0x1
    1530:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    1534:	670d                	lui	a4,0x3
    1536:	fd2771e3          	bgeu	a4,s2,14f8 <pipe1+0x40>
        cc = sizeof(buf);
    153a:	690d                	lui	s2,0x3
    153c:	bf75                	j	14f8 <pipe1+0x40>
    153e:	e4a6                	sd	s1,72(sp)
    1540:	e0ca                	sd	s2,64(sp)
    1542:	f852                	sd	s4,48(sp)
    1544:	f456                	sd	s5,40(sp)
    1546:	f05a                	sd	s6,32(sp)
    1548:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    154a:	85ce                	mv	a1,s3
    154c:	00004517          	auipc	a0,0x4
    1550:	4e450513          	addi	a0,a0,1252 # 5a30 <malloc+0xad6>
    1554:	153030ef          	jal	4ea6 <printf>
    exit(1);
    1558:	4505                	li	a0,1
    155a:	52c030ef          	jal	4a86 <exit>
    155e:	e0ca                	sd	s2,64(sp)
    1560:	f456                	sd	s5,40(sp)
    1562:	f05a                	sd	s6,32(sp)
    1564:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1566:	fa842503          	lw	a0,-88(s0)
    156a:	544030ef          	jal	4aae <close>
    for(n = 0; n < N; n++){
    156e:	0000bb17          	auipc	s6,0xb
    1572:	70ab0b13          	addi	s6,s6,1802 # cc78 <buf>
    1576:	416004bb          	negw	s1,s6
    157a:	0ff4f493          	zext.b	s1,s1
    157e:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1582:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1584:	6a85                	lui	s5,0x1
    1586:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0xeb>
{
    158a:	87da                	mv	a5,s6
        buf[i] = seq++;
    158c:	0097873b          	addw	a4,a5,s1
    1590:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1594:	0785                	addi	a5,a5,1
    1596:	ff279be3          	bne	a5,s2,158c <pipe1+0xd4>
    159a:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    159e:	40900613          	li	a2,1033
    15a2:	85de                	mv	a1,s7
    15a4:	fac42503          	lw	a0,-84(s0)
    15a8:	4fe030ef          	jal	4aa6 <write>
    15ac:	40900793          	li	a5,1033
    15b0:	00f51a63          	bne	a0,a5,15c4 <pipe1+0x10c>
    for(n = 0; n < N; n++){
    15b4:	24a5                	addiw	s1,s1,9
    15b6:	0ff4f493          	zext.b	s1,s1
    15ba:	fd5a18e3          	bne	s4,s5,158a <pipe1+0xd2>
    exit(0);
    15be:	4501                	li	a0,0
    15c0:	4c6030ef          	jal	4a86 <exit>
        printf("%s: pipe1 oops 1\n", s);
    15c4:	85ce                	mv	a1,s3
    15c6:	00004517          	auipc	a0,0x4
    15ca:	48250513          	addi	a0,a0,1154 # 5a48 <malloc+0xaee>
    15ce:	0d9030ef          	jal	4ea6 <printf>
        exit(1);
    15d2:	4505                	li	a0,1
    15d4:	4b2030ef          	jal	4a86 <exit>
          printf("%s: pipe1 oops 2\n", s);
    15d8:	85ce                	mv	a1,s3
    15da:	00004517          	auipc	a0,0x4
    15de:	48650513          	addi	a0,a0,1158 # 5a60 <malloc+0xb06>
    15e2:	0c5030ef          	jal	4ea6 <printf>
          return;
    15e6:	64a6                	ld	s1,72(sp)
    15e8:	6906                	ld	s2,64(sp)
    15ea:	7a42                	ld	s4,48(sp)
    15ec:	7aa2                	ld	s5,40(sp)
}
    15ee:	60e6                	ld	ra,88(sp)
    15f0:	6446                	ld	s0,80(sp)
    15f2:	79e2                	ld	s3,56(sp)
    15f4:	6125                	addi	sp,sp,96
    15f6:	8082                	ret
    if(total != N * SZ){
    15f8:	6785                	lui	a5,0x1
    15fa:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0xeb>
    15fe:	00fa0f63          	beq	s4,a5,161c <pipe1+0x164>
    1602:	f05a                	sd	s6,32(sp)
    1604:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1606:	8652                	mv	a2,s4
    1608:	85ce                	mv	a1,s3
    160a:	00004517          	auipc	a0,0x4
    160e:	46e50513          	addi	a0,a0,1134 # 5a78 <malloc+0xb1e>
    1612:	095030ef          	jal	4ea6 <printf>
      exit(1);
    1616:	4505                	li	a0,1
    1618:	46e030ef          	jal	4a86 <exit>
    161c:	f05a                	sd	s6,32(sp)
    161e:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1620:	fa842503          	lw	a0,-88(s0)
    1624:	48a030ef          	jal	4aae <close>
    wait(&xstatus);
    1628:	fa440513          	addi	a0,s0,-92
    162c:	462030ef          	jal	4a8e <wait>
    exit(xstatus);
    1630:	fa442503          	lw	a0,-92(s0)
    1634:	452030ef          	jal	4a86 <exit>
    1638:	e0ca                	sd	s2,64(sp)
    163a:	f456                	sd	s5,40(sp)
    163c:	f05a                	sd	s6,32(sp)
    163e:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1640:	85ce                	mv	a1,s3
    1642:	00004517          	auipc	a0,0x4
    1646:	45650513          	addi	a0,a0,1110 # 5a98 <malloc+0xb3e>
    164a:	05d030ef          	jal	4ea6 <printf>
    exit(1);
    164e:	4505                	li	a0,1
    1650:	436030ef          	jal	4a86 <exit>

0000000000001654 <exitwait>:
{
    1654:	7139                	addi	sp,sp,-64
    1656:	fc06                	sd	ra,56(sp)
    1658:	f822                	sd	s0,48(sp)
    165a:	f426                	sd	s1,40(sp)
    165c:	f04a                	sd	s2,32(sp)
    165e:	ec4e                	sd	s3,24(sp)
    1660:	e852                	sd	s4,16(sp)
    1662:	0080                	addi	s0,sp,64
    1664:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1666:	4901                	li	s2,0
    1668:	06400993          	li	s3,100
    pid = fork();
    166c:	412030ef          	jal	4a7e <fork>
    1670:	84aa                	mv	s1,a0
    if(pid < 0){
    1672:	02054863          	bltz	a0,16a2 <exitwait+0x4e>
    if(pid){
    1676:	c525                	beqz	a0,16de <exitwait+0x8a>
      if(wait(&xstate) != pid){
    1678:	fcc40513          	addi	a0,s0,-52
    167c:	412030ef          	jal	4a8e <wait>
    1680:	02951b63          	bne	a0,s1,16b6 <exitwait+0x62>
      if(i != xstate) {
    1684:	fcc42783          	lw	a5,-52(s0)
    1688:	05279163          	bne	a5,s2,16ca <exitwait+0x76>
  for(i = 0; i < 100; i++){
    168c:	2905                	addiw	s2,s2,1 # 3001 <subdir+0x41f>
    168e:	fd391fe3          	bne	s2,s3,166c <exitwait+0x18>
}
    1692:	70e2                	ld	ra,56(sp)
    1694:	7442                	ld	s0,48(sp)
    1696:	74a2                	ld	s1,40(sp)
    1698:	7902                	ld	s2,32(sp)
    169a:	69e2                	ld	s3,24(sp)
    169c:	6a42                	ld	s4,16(sp)
    169e:	6121                	addi	sp,sp,64
    16a0:	8082                	ret
      printf("%s: fork failed\n", s);
    16a2:	85d2                	mv	a1,s4
    16a4:	00004517          	auipc	a0,0x4
    16a8:	28450513          	addi	a0,a0,644 # 5928 <malloc+0x9ce>
    16ac:	7fa030ef          	jal	4ea6 <printf>
      exit(1);
    16b0:	4505                	li	a0,1
    16b2:	3d4030ef          	jal	4a86 <exit>
        printf("%s: wait wrong pid\n", s);
    16b6:	85d2                	mv	a1,s4
    16b8:	00004517          	auipc	a0,0x4
    16bc:	3f850513          	addi	a0,a0,1016 # 5ab0 <malloc+0xb56>
    16c0:	7e6030ef          	jal	4ea6 <printf>
        exit(1);
    16c4:	4505                	li	a0,1
    16c6:	3c0030ef          	jal	4a86 <exit>
        printf("%s: wait wrong exit status\n", s);
    16ca:	85d2                	mv	a1,s4
    16cc:	00004517          	auipc	a0,0x4
    16d0:	3fc50513          	addi	a0,a0,1020 # 5ac8 <malloc+0xb6e>
    16d4:	7d2030ef          	jal	4ea6 <printf>
        exit(1);
    16d8:	4505                	li	a0,1
    16da:	3ac030ef          	jal	4a86 <exit>
      exit(i);
    16de:	854a                	mv	a0,s2
    16e0:	3a6030ef          	jal	4a86 <exit>

00000000000016e4 <twochildren>:
{
    16e4:	1101                	addi	sp,sp,-32
    16e6:	ec06                	sd	ra,24(sp)
    16e8:	e822                	sd	s0,16(sp)
    16ea:	e426                	sd	s1,8(sp)
    16ec:	e04a                	sd	s2,0(sp)
    16ee:	1000                	addi	s0,sp,32
    16f0:	892a                	mv	s2,a0
    16f2:	3e800493          	li	s1,1000
    int pid1 = fork();
    16f6:	388030ef          	jal	4a7e <fork>
    if(pid1 < 0){
    16fa:	02054663          	bltz	a0,1726 <twochildren+0x42>
    if(pid1 == 0){
    16fe:	cd15                	beqz	a0,173a <twochildren+0x56>
      int pid2 = fork();
    1700:	37e030ef          	jal	4a7e <fork>
      if(pid2 < 0){
    1704:	02054d63          	bltz	a0,173e <twochildren+0x5a>
      if(pid2 == 0){
    1708:	c529                	beqz	a0,1752 <twochildren+0x6e>
        wait(0);
    170a:	4501                	li	a0,0
    170c:	382030ef          	jal	4a8e <wait>
        wait(0);
    1710:	4501                	li	a0,0
    1712:	37c030ef          	jal	4a8e <wait>
  for(int i = 0; i < 1000; i++){
    1716:	34fd                	addiw	s1,s1,-1
    1718:	fcf9                	bnez	s1,16f6 <twochildren+0x12>
}
    171a:	60e2                	ld	ra,24(sp)
    171c:	6442                	ld	s0,16(sp)
    171e:	64a2                	ld	s1,8(sp)
    1720:	6902                	ld	s2,0(sp)
    1722:	6105                	addi	sp,sp,32
    1724:	8082                	ret
      printf("%s: fork failed\n", s);
    1726:	85ca                	mv	a1,s2
    1728:	00004517          	auipc	a0,0x4
    172c:	20050513          	addi	a0,a0,512 # 5928 <malloc+0x9ce>
    1730:	776030ef          	jal	4ea6 <printf>
      exit(1);
    1734:	4505                	li	a0,1
    1736:	350030ef          	jal	4a86 <exit>
      exit(0);
    173a:	34c030ef          	jal	4a86 <exit>
        printf("%s: fork failed\n", s);
    173e:	85ca                	mv	a1,s2
    1740:	00004517          	auipc	a0,0x4
    1744:	1e850513          	addi	a0,a0,488 # 5928 <malloc+0x9ce>
    1748:	75e030ef          	jal	4ea6 <printf>
        exit(1);
    174c:	4505                	li	a0,1
    174e:	338030ef          	jal	4a86 <exit>
        exit(0);
    1752:	334030ef          	jal	4a86 <exit>

0000000000001756 <forkfork>:
{
    1756:	7179                	addi	sp,sp,-48
    1758:	f406                	sd	ra,40(sp)
    175a:	f022                	sd	s0,32(sp)
    175c:	ec26                	sd	s1,24(sp)
    175e:	1800                	addi	s0,sp,48
    1760:	84aa                	mv	s1,a0
    int pid = fork();
    1762:	31c030ef          	jal	4a7e <fork>
    if(pid < 0){
    1766:	02054b63          	bltz	a0,179c <forkfork+0x46>
    if(pid == 0){
    176a:	c139                	beqz	a0,17b0 <forkfork+0x5a>
    int pid = fork();
    176c:	312030ef          	jal	4a7e <fork>
    if(pid < 0){
    1770:	02054663          	bltz	a0,179c <forkfork+0x46>
    if(pid == 0){
    1774:	cd15                	beqz	a0,17b0 <forkfork+0x5a>
    wait(&xstatus);
    1776:	fdc40513          	addi	a0,s0,-36
    177a:	314030ef          	jal	4a8e <wait>
    if(xstatus != 0) {
    177e:	fdc42783          	lw	a5,-36(s0)
    1782:	ebb9                	bnez	a5,17d8 <forkfork+0x82>
    wait(&xstatus);
    1784:	fdc40513          	addi	a0,s0,-36
    1788:	306030ef          	jal	4a8e <wait>
    if(xstatus != 0) {
    178c:	fdc42783          	lw	a5,-36(s0)
    1790:	e7a1                	bnez	a5,17d8 <forkfork+0x82>
}
    1792:	70a2                	ld	ra,40(sp)
    1794:	7402                	ld	s0,32(sp)
    1796:	64e2                	ld	s1,24(sp)
    1798:	6145                	addi	sp,sp,48
    179a:	8082                	ret
      printf("%s: fork failed", s);
    179c:	85a6                	mv	a1,s1
    179e:	00004517          	auipc	a0,0x4
    17a2:	34a50513          	addi	a0,a0,842 # 5ae8 <malloc+0xb8e>
    17a6:	700030ef          	jal	4ea6 <printf>
      exit(1);
    17aa:	4505                	li	a0,1
    17ac:	2da030ef          	jal	4a86 <exit>
{
    17b0:	0c800493          	li	s1,200
        int pid1 = fork();
    17b4:	2ca030ef          	jal	4a7e <fork>
        if(pid1 < 0){
    17b8:	00054b63          	bltz	a0,17ce <forkfork+0x78>
        if(pid1 == 0){
    17bc:	cd01                	beqz	a0,17d4 <forkfork+0x7e>
        wait(0);
    17be:	4501                	li	a0,0
    17c0:	2ce030ef          	jal	4a8e <wait>
      for(int j = 0; j < 200; j++){
    17c4:	34fd                	addiw	s1,s1,-1
    17c6:	f4fd                	bnez	s1,17b4 <forkfork+0x5e>
      exit(0);
    17c8:	4501                	li	a0,0
    17ca:	2bc030ef          	jal	4a86 <exit>
          exit(1);
    17ce:	4505                	li	a0,1
    17d0:	2b6030ef          	jal	4a86 <exit>
          exit(0);
    17d4:	2b2030ef          	jal	4a86 <exit>
      printf("%s: fork in child failed", s);
    17d8:	85a6                	mv	a1,s1
    17da:	00004517          	auipc	a0,0x4
    17de:	31e50513          	addi	a0,a0,798 # 5af8 <malloc+0xb9e>
    17e2:	6c4030ef          	jal	4ea6 <printf>
      exit(1);
    17e6:	4505                	li	a0,1
    17e8:	29e030ef          	jal	4a86 <exit>

00000000000017ec <reparent2>:
{
    17ec:	1101                	addi	sp,sp,-32
    17ee:	ec06                	sd	ra,24(sp)
    17f0:	e822                	sd	s0,16(sp)
    17f2:	e426                	sd	s1,8(sp)
    17f4:	1000                	addi	s0,sp,32
    17f6:	32000493          	li	s1,800
    int pid1 = fork();
    17fa:	284030ef          	jal	4a7e <fork>
    if(pid1 < 0){
    17fe:	00054b63          	bltz	a0,1814 <reparent2+0x28>
    if(pid1 == 0){
    1802:	c115                	beqz	a0,1826 <reparent2+0x3a>
    wait(0);
    1804:	4501                	li	a0,0
    1806:	288030ef          	jal	4a8e <wait>
  for(int i = 0; i < 800; i++){
    180a:	34fd                	addiw	s1,s1,-1
    180c:	f4fd                	bnez	s1,17fa <reparent2+0xe>
  exit(0);
    180e:	4501                	li	a0,0
    1810:	276030ef          	jal	4a86 <exit>
      printf("fork failed\n");
    1814:	00005517          	auipc	a0,0x5
    1818:	68450513          	addi	a0,a0,1668 # 6e98 <malloc+0x1f3e>
    181c:	68a030ef          	jal	4ea6 <printf>
      exit(1);
    1820:	4505                	li	a0,1
    1822:	264030ef          	jal	4a86 <exit>
      fork();
    1826:	258030ef          	jal	4a7e <fork>
      fork();
    182a:	254030ef          	jal	4a7e <fork>
      exit(0);
    182e:	4501                	li	a0,0
    1830:	256030ef          	jal	4a86 <exit>

0000000000001834 <createdelete>:
{
    1834:	7175                	addi	sp,sp,-144
    1836:	e506                	sd	ra,136(sp)
    1838:	e122                	sd	s0,128(sp)
    183a:	fca6                	sd	s1,120(sp)
    183c:	f8ca                	sd	s2,112(sp)
    183e:	f4ce                	sd	s3,104(sp)
    1840:	f0d2                	sd	s4,96(sp)
    1842:	ecd6                	sd	s5,88(sp)
    1844:	e8da                	sd	s6,80(sp)
    1846:	e4de                	sd	s7,72(sp)
    1848:	e0e2                	sd	s8,64(sp)
    184a:	fc66                	sd	s9,56(sp)
    184c:	0900                	addi	s0,sp,144
    184e:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1850:	4901                	li	s2,0
    1852:	4991                	li	s3,4
    pid = fork();
    1854:	22a030ef          	jal	4a7e <fork>
    1858:	84aa                	mv	s1,a0
    if(pid < 0){
    185a:	02054d63          	bltz	a0,1894 <createdelete+0x60>
    if(pid == 0){
    185e:	c529                	beqz	a0,18a8 <createdelete+0x74>
  for(pi = 0; pi < NCHILD; pi++){
    1860:	2905                	addiw	s2,s2,1
    1862:	ff3919e3          	bne	s2,s3,1854 <createdelete+0x20>
    1866:	4491                	li	s1,4
    wait(&xstatus);
    1868:	f7c40513          	addi	a0,s0,-132
    186c:	222030ef          	jal	4a8e <wait>
    if(xstatus != 0)
    1870:	f7c42903          	lw	s2,-132(s0)
    1874:	0a091e63          	bnez	s2,1930 <createdelete+0xfc>
  for(pi = 0; pi < NCHILD; pi++){
    1878:	34fd                	addiw	s1,s1,-1
    187a:	f4fd                	bnez	s1,1868 <createdelete+0x34>
  name[0] = name[1] = name[2] = 0;
    187c:	f8040123          	sb	zero,-126(s0)
    1880:	03000993          	li	s3,48
    1884:	5a7d                	li	s4,-1
    1886:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    188a:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    188c:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    188e:	07400a93          	li	s5,116
    1892:	aa39                	j	19b0 <createdelete+0x17c>
      printf("%s: fork failed\n", s);
    1894:	85e6                	mv	a1,s9
    1896:	00004517          	auipc	a0,0x4
    189a:	09250513          	addi	a0,a0,146 # 5928 <malloc+0x9ce>
    189e:	608030ef          	jal	4ea6 <printf>
      exit(1);
    18a2:	4505                	li	a0,1
    18a4:	1e2030ef          	jal	4a86 <exit>
      name[0] = 'p' + pi;
    18a8:	0709091b          	addiw	s2,s2,112
    18ac:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    18b0:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    18b4:	4951                	li	s2,20
    18b6:	a831                	j	18d2 <createdelete+0x9e>
          printf("%s: create failed\n", s);
    18b8:	85e6                	mv	a1,s9
    18ba:	00004517          	auipc	a0,0x4
    18be:	10650513          	addi	a0,a0,262 # 59c0 <malloc+0xa66>
    18c2:	5e4030ef          	jal	4ea6 <printf>
          exit(1);
    18c6:	4505                	li	a0,1
    18c8:	1be030ef          	jal	4a86 <exit>
      for(i = 0; i < N; i++){
    18cc:	2485                	addiw	s1,s1,1
    18ce:	05248e63          	beq	s1,s2,192a <createdelete+0xf6>
        name[1] = '0' + i;
    18d2:	0304879b          	addiw	a5,s1,48
    18d6:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    18da:	20200593          	li	a1,514
    18de:	f8040513          	addi	a0,s0,-128
    18e2:	1e4030ef          	jal	4ac6 <open>
        if(fd < 0){
    18e6:	fc0549e3          	bltz	a0,18b8 <createdelete+0x84>
        close(fd);
    18ea:	1c4030ef          	jal	4aae <close>
        if(i > 0 && (i % 2 ) == 0){
    18ee:	10905063          	blez	s1,19ee <createdelete+0x1ba>
    18f2:	0014f793          	andi	a5,s1,1
    18f6:	fbf9                	bnez	a5,18cc <createdelete+0x98>
          name[1] = '0' + (i / 2);
    18f8:	01f4d79b          	srliw	a5,s1,0x1f
    18fc:	9fa5                	addw	a5,a5,s1
    18fe:	4017d79b          	sraiw	a5,a5,0x1
    1902:	0307879b          	addiw	a5,a5,48
    1906:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    190a:	f8040513          	addi	a0,s0,-128
    190e:	1c8030ef          	jal	4ad6 <unlink>
    1912:	fa055de3          	bgez	a0,18cc <createdelete+0x98>
            printf("%s: unlink failed\n", s);
    1916:	85e6                	mv	a1,s9
    1918:	00004517          	auipc	a0,0x4
    191c:	20050513          	addi	a0,a0,512 # 5b18 <malloc+0xbbe>
    1920:	586030ef          	jal	4ea6 <printf>
            exit(1);
    1924:	4505                	li	a0,1
    1926:	160030ef          	jal	4a86 <exit>
      exit(0);
    192a:	4501                	li	a0,0
    192c:	15a030ef          	jal	4a86 <exit>
      exit(1);
    1930:	4505                	li	a0,1
    1932:	154030ef          	jal	4a86 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1936:	f8040613          	addi	a2,s0,-128
    193a:	85e6                	mv	a1,s9
    193c:	00004517          	auipc	a0,0x4
    1940:	1f450513          	addi	a0,a0,500 # 5b30 <malloc+0xbd6>
    1944:	562030ef          	jal	4ea6 <printf>
        exit(1);
    1948:	4505                	li	a0,1
    194a:	13c030ef          	jal	4a86 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    194e:	034bfb63          	bgeu	s7,s4,1984 <createdelete+0x150>
      if(fd >= 0)
    1952:	02055663          	bgez	a0,197e <createdelete+0x14a>
    for(pi = 0; pi < NCHILD; pi++){
    1956:	2485                	addiw	s1,s1,1
    1958:	0ff4f493          	zext.b	s1,s1
    195c:	05548263          	beq	s1,s5,19a0 <createdelete+0x16c>
      name[0] = 'p' + pi;
    1960:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1964:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1968:	4581                	li	a1,0
    196a:	f8040513          	addi	a0,s0,-128
    196e:	158030ef          	jal	4ac6 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1972:	00090463          	beqz	s2,197a <createdelete+0x146>
    1976:	fd2b5ce3          	bge	s6,s2,194e <createdelete+0x11a>
    197a:	fa054ee3          	bltz	a0,1936 <createdelete+0x102>
        close(fd);
    197e:	130030ef          	jal	4aae <close>
    1982:	bfd1                	j	1956 <createdelete+0x122>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1984:	fc0549e3          	bltz	a0,1956 <createdelete+0x122>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1988:	f8040613          	addi	a2,s0,-128
    198c:	85e6                	mv	a1,s9
    198e:	00004517          	auipc	a0,0x4
    1992:	1ca50513          	addi	a0,a0,458 # 5b58 <malloc+0xbfe>
    1996:	510030ef          	jal	4ea6 <printf>
        exit(1);
    199a:	4505                	li	a0,1
    199c:	0ea030ef          	jal	4a86 <exit>
  for(i = 0; i < N; i++){
    19a0:	2905                	addiw	s2,s2,1
    19a2:	2a05                	addiw	s4,s4,1
    19a4:	2985                	addiw	s3,s3,1
    19a6:	0ff9f993          	zext.b	s3,s3
    19aa:	47d1                	li	a5,20
    19ac:	02f90863          	beq	s2,a5,19dc <createdelete+0x1a8>
    for(pi = 0; pi < NCHILD; pi++){
    19b0:	84e2                	mv	s1,s8
    19b2:	b77d                	j	1960 <createdelete+0x12c>
  for(i = 0; i < N; i++){
    19b4:	2905                	addiw	s2,s2,1
    19b6:	0ff97913          	zext.b	s2,s2
    19ba:	03490c63          	beq	s2,s4,19f2 <createdelete+0x1be>
  name[0] = name[1] = name[2] = 0;
    19be:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    19c0:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    19c4:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    19c8:	f8040513          	addi	a0,s0,-128
    19cc:	10a030ef          	jal	4ad6 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    19d0:	2485                	addiw	s1,s1,1
    19d2:	0ff4f493          	zext.b	s1,s1
    19d6:	ff3495e3          	bne	s1,s3,19c0 <createdelete+0x18c>
    19da:	bfe9                	j	19b4 <createdelete+0x180>
    19dc:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    19e0:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    19e4:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    19e8:	04400a13          	li	s4,68
    19ec:	bfc9                	j	19be <createdelete+0x18a>
      for(i = 0; i < N; i++){
    19ee:	2485                	addiw	s1,s1,1
    19f0:	b5cd                	j	18d2 <createdelete+0x9e>
}
    19f2:	60aa                	ld	ra,136(sp)
    19f4:	640a                	ld	s0,128(sp)
    19f6:	74e6                	ld	s1,120(sp)
    19f8:	7946                	ld	s2,112(sp)
    19fa:	79a6                	ld	s3,104(sp)
    19fc:	7a06                	ld	s4,96(sp)
    19fe:	6ae6                	ld	s5,88(sp)
    1a00:	6b46                	ld	s6,80(sp)
    1a02:	6ba6                	ld	s7,72(sp)
    1a04:	6c06                	ld	s8,64(sp)
    1a06:	7ce2                	ld	s9,56(sp)
    1a08:	6149                	addi	sp,sp,144
    1a0a:	8082                	ret

0000000000001a0c <linkunlink>:
{
    1a0c:	711d                	addi	sp,sp,-96
    1a0e:	ec86                	sd	ra,88(sp)
    1a10:	e8a2                	sd	s0,80(sp)
    1a12:	e4a6                	sd	s1,72(sp)
    1a14:	e0ca                	sd	s2,64(sp)
    1a16:	fc4e                	sd	s3,56(sp)
    1a18:	f852                	sd	s4,48(sp)
    1a1a:	f456                	sd	s5,40(sp)
    1a1c:	f05a                	sd	s6,32(sp)
    1a1e:	ec5e                	sd	s7,24(sp)
    1a20:	e862                	sd	s8,16(sp)
    1a22:	e466                	sd	s9,8(sp)
    1a24:	1080                	addi	s0,sp,96
    1a26:	84aa                	mv	s1,a0
  unlink("x");
    1a28:	00003517          	auipc	a0,0x3
    1a2c:	6e050513          	addi	a0,a0,1760 # 5108 <malloc+0x1ae>
    1a30:	0a6030ef          	jal	4ad6 <unlink>
  pid = fork();
    1a34:	04a030ef          	jal	4a7e <fork>
  if(pid < 0){
    1a38:	02054b63          	bltz	a0,1a6e <linkunlink+0x62>
    1a3c:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1a3e:	06100913          	li	s2,97
    1a42:	c111                	beqz	a0,1a46 <linkunlink+0x3a>
    1a44:	4905                	li	s2,1
    1a46:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1a4a:	41c65a37          	lui	s4,0x41c65
    1a4e:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c551f5>
    1a52:	698d                	lui	s3,0x3
    1a54:	0399899b          	addiw	s3,s3,57 # 3039 <subdir+0x457>
    if((x % 3) == 0){
    1a58:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    1a5a:	4b85                	li	s7,1
      unlink("x");
    1a5c:	00003b17          	auipc	s6,0x3
    1a60:	6acb0b13          	addi	s6,s6,1708 # 5108 <malloc+0x1ae>
      link("cat", "x");
    1a64:	00004c17          	auipc	s8,0x4
    1a68:	11cc0c13          	addi	s8,s8,284 # 5b80 <malloc+0xc26>
    1a6c:	a025                	j	1a94 <linkunlink+0x88>
    printf("%s: fork failed\n", s);
    1a6e:	85a6                	mv	a1,s1
    1a70:	00004517          	auipc	a0,0x4
    1a74:	eb850513          	addi	a0,a0,-328 # 5928 <malloc+0x9ce>
    1a78:	42e030ef          	jal	4ea6 <printf>
    exit(1);
    1a7c:	4505                	li	a0,1
    1a7e:	008030ef          	jal	4a86 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1a82:	20200593          	li	a1,514
    1a86:	855a                	mv	a0,s6
    1a88:	03e030ef          	jal	4ac6 <open>
    1a8c:	022030ef          	jal	4aae <close>
  for(i = 0; i < 100; i++){
    1a90:	34fd                	addiw	s1,s1,-1
    1a92:	c495                	beqz	s1,1abe <linkunlink+0xb2>
    x = x * 1103515245 + 12345;
    1a94:	034907bb          	mulw	a5,s2,s4
    1a98:	013787bb          	addw	a5,a5,s3
    1a9c:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    1aa0:	0357f7bb          	remuw	a5,a5,s5
    1aa4:	2781                	sext.w	a5,a5
    1aa6:	dff1                	beqz	a5,1a82 <linkunlink+0x76>
    } else if((x % 3) == 1){
    1aa8:	01778663          	beq	a5,s7,1ab4 <linkunlink+0xa8>
      unlink("x");
    1aac:	855a                	mv	a0,s6
    1aae:	028030ef          	jal	4ad6 <unlink>
    1ab2:	bff9                	j	1a90 <linkunlink+0x84>
      link("cat", "x");
    1ab4:	85da                	mv	a1,s6
    1ab6:	8562                	mv	a0,s8
    1ab8:	02e030ef          	jal	4ae6 <link>
    1abc:	bfd1                	j	1a90 <linkunlink+0x84>
  if(pid)
    1abe:	020c8263          	beqz	s9,1ae2 <linkunlink+0xd6>
    wait(0);
    1ac2:	4501                	li	a0,0
    1ac4:	7cb020ef          	jal	4a8e <wait>
}
    1ac8:	60e6                	ld	ra,88(sp)
    1aca:	6446                	ld	s0,80(sp)
    1acc:	64a6                	ld	s1,72(sp)
    1ace:	6906                	ld	s2,64(sp)
    1ad0:	79e2                	ld	s3,56(sp)
    1ad2:	7a42                	ld	s4,48(sp)
    1ad4:	7aa2                	ld	s5,40(sp)
    1ad6:	7b02                	ld	s6,32(sp)
    1ad8:	6be2                	ld	s7,24(sp)
    1ada:	6c42                	ld	s8,16(sp)
    1adc:	6ca2                	ld	s9,8(sp)
    1ade:	6125                	addi	sp,sp,96
    1ae0:	8082                	ret
    exit(0);
    1ae2:	4501                	li	a0,0
    1ae4:	7a3020ef          	jal	4a86 <exit>

0000000000001ae8 <forktest>:
{
    1ae8:	7179                	addi	sp,sp,-48
    1aea:	f406                	sd	ra,40(sp)
    1aec:	f022                	sd	s0,32(sp)
    1aee:	ec26                	sd	s1,24(sp)
    1af0:	e84a                	sd	s2,16(sp)
    1af2:	e44e                	sd	s3,8(sp)
    1af4:	1800                	addi	s0,sp,48
    1af6:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1af8:	4481                	li	s1,0
    1afa:	3e800913          	li	s2,1000
    pid = fork();
    1afe:	781020ef          	jal	4a7e <fork>
    if(pid < 0)
    1b02:	06054063          	bltz	a0,1b62 <forktest+0x7a>
    if(pid == 0)
    1b06:	cd11                	beqz	a0,1b22 <forktest+0x3a>
  for(n=0; n<N; n++){
    1b08:	2485                	addiw	s1,s1,1
    1b0a:	ff249ae3          	bne	s1,s2,1afe <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1b0e:	85ce                	mv	a1,s3
    1b10:	00004517          	auipc	a0,0x4
    1b14:	0c050513          	addi	a0,a0,192 # 5bd0 <malloc+0xc76>
    1b18:	38e030ef          	jal	4ea6 <printf>
    exit(1);
    1b1c:	4505                	li	a0,1
    1b1e:	769020ef          	jal	4a86 <exit>
      exit(0);
    1b22:	765020ef          	jal	4a86 <exit>
    printf("%s: no fork at all!\n", s);
    1b26:	85ce                	mv	a1,s3
    1b28:	00004517          	auipc	a0,0x4
    1b2c:	06050513          	addi	a0,a0,96 # 5b88 <malloc+0xc2e>
    1b30:	376030ef          	jal	4ea6 <printf>
    exit(1);
    1b34:	4505                	li	a0,1
    1b36:	751020ef          	jal	4a86 <exit>
      printf("%s: wait stopped early\n", s);
    1b3a:	85ce                	mv	a1,s3
    1b3c:	00004517          	auipc	a0,0x4
    1b40:	06450513          	addi	a0,a0,100 # 5ba0 <malloc+0xc46>
    1b44:	362030ef          	jal	4ea6 <printf>
      exit(1);
    1b48:	4505                	li	a0,1
    1b4a:	73d020ef          	jal	4a86 <exit>
    printf("%s: wait got too many\n", s);
    1b4e:	85ce                	mv	a1,s3
    1b50:	00004517          	auipc	a0,0x4
    1b54:	06850513          	addi	a0,a0,104 # 5bb8 <malloc+0xc5e>
    1b58:	34e030ef          	jal	4ea6 <printf>
    exit(1);
    1b5c:	4505                	li	a0,1
    1b5e:	729020ef          	jal	4a86 <exit>
  if (n == 0) {
    1b62:	d0f1                	beqz	s1,1b26 <forktest+0x3e>
  for(; n > 0; n--){
    1b64:	00905963          	blez	s1,1b76 <forktest+0x8e>
    if(wait(0) < 0){
    1b68:	4501                	li	a0,0
    1b6a:	725020ef          	jal	4a8e <wait>
    1b6e:	fc0546e3          	bltz	a0,1b3a <forktest+0x52>
  for(; n > 0; n--){
    1b72:	34fd                	addiw	s1,s1,-1
    1b74:	f8f5                	bnez	s1,1b68 <forktest+0x80>
  if(wait(0) != -1){
    1b76:	4501                	li	a0,0
    1b78:	717020ef          	jal	4a8e <wait>
    1b7c:	57fd                	li	a5,-1
    1b7e:	fcf518e3          	bne	a0,a5,1b4e <forktest+0x66>
}
    1b82:	70a2                	ld	ra,40(sp)
    1b84:	7402                	ld	s0,32(sp)
    1b86:	64e2                	ld	s1,24(sp)
    1b88:	6942                	ld	s2,16(sp)
    1b8a:	69a2                	ld	s3,8(sp)
    1b8c:	6145                	addi	sp,sp,48
    1b8e:	8082                	ret

0000000000001b90 <kernmem>:
{
    1b90:	715d                	addi	sp,sp,-80
    1b92:	e486                	sd	ra,72(sp)
    1b94:	e0a2                	sd	s0,64(sp)
    1b96:	fc26                	sd	s1,56(sp)
    1b98:	f84a                	sd	s2,48(sp)
    1b9a:	f44e                	sd	s3,40(sp)
    1b9c:	f052                	sd	s4,32(sp)
    1b9e:	ec56                	sd	s5,24(sp)
    1ba0:	0880                	addi	s0,sp,80
    1ba2:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ba4:	4485                	li	s1,1
    1ba6:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1ba8:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1baa:	69b1                	lui	s3,0xc
    1bac:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    1bb0:	1003d937          	lui	s2,0x1003d
    1bb4:	090e                	slli	s2,s2,0x3
    1bb6:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    1bba:	6c5020ef          	jal	4a7e <fork>
    if(pid < 0){
    1bbe:	02054763          	bltz	a0,1bec <kernmem+0x5c>
    if(pid == 0){
    1bc2:	cd1d                	beqz	a0,1c00 <kernmem+0x70>
    wait(&xstatus);
    1bc4:	fbc40513          	addi	a0,s0,-68
    1bc8:	6c7020ef          	jal	4a8e <wait>
    if(xstatus != -1)  // did kernel kill child?
    1bcc:	fbc42783          	lw	a5,-68(s0)
    1bd0:	05479563          	bne	a5,s4,1c1a <kernmem+0x8a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1bd4:	94ce                	add	s1,s1,s3
    1bd6:	ff2492e3          	bne	s1,s2,1bba <kernmem+0x2a>
}
    1bda:	60a6                	ld	ra,72(sp)
    1bdc:	6406                	ld	s0,64(sp)
    1bde:	74e2                	ld	s1,56(sp)
    1be0:	7942                	ld	s2,48(sp)
    1be2:	79a2                	ld	s3,40(sp)
    1be4:	7a02                	ld	s4,32(sp)
    1be6:	6ae2                	ld	s5,24(sp)
    1be8:	6161                	addi	sp,sp,80
    1bea:	8082                	ret
      printf("%s: fork failed\n", s);
    1bec:	85d6                	mv	a1,s5
    1bee:	00004517          	auipc	a0,0x4
    1bf2:	d3a50513          	addi	a0,a0,-710 # 5928 <malloc+0x9ce>
    1bf6:	2b0030ef          	jal	4ea6 <printf>
      exit(1);
    1bfa:	4505                	li	a0,1
    1bfc:	68b020ef          	jal	4a86 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1c00:	0004c683          	lbu	a3,0(s1)
    1c04:	8626                	mv	a2,s1
    1c06:	85d6                	mv	a1,s5
    1c08:	00004517          	auipc	a0,0x4
    1c0c:	ff050513          	addi	a0,a0,-16 # 5bf8 <malloc+0xc9e>
    1c10:	296030ef          	jal	4ea6 <printf>
      exit(1);
    1c14:	4505                	li	a0,1
    1c16:	671020ef          	jal	4a86 <exit>
      exit(1);
    1c1a:	4505                	li	a0,1
    1c1c:	66b020ef          	jal	4a86 <exit>

0000000000001c20 <MAXVAplus>:
{
    1c20:	7179                	addi	sp,sp,-48
    1c22:	f406                	sd	ra,40(sp)
    1c24:	f022                	sd	s0,32(sp)
    1c26:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    1c28:	4785                	li	a5,1
    1c2a:	179a                	slli	a5,a5,0x26
    1c2c:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    1c30:	fd843783          	ld	a5,-40(s0)
    1c34:	cf85                	beqz	a5,1c6c <MAXVAplus+0x4c>
    1c36:	ec26                	sd	s1,24(sp)
    1c38:	e84a                	sd	s2,16(sp)
    1c3a:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    1c3c:	54fd                	li	s1,-1
    pid = fork();
    1c3e:	641020ef          	jal	4a7e <fork>
    if(pid < 0){
    1c42:	02054963          	bltz	a0,1c74 <MAXVAplus+0x54>
    if(pid == 0){
    1c46:	c129                	beqz	a0,1c88 <MAXVAplus+0x68>
    wait(&xstatus);
    1c48:	fd440513          	addi	a0,s0,-44
    1c4c:	643020ef          	jal	4a8e <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c50:	fd442783          	lw	a5,-44(s0)
    1c54:	04979c63          	bne	a5,s1,1cac <MAXVAplus+0x8c>
  for( ; a != 0; a <<= 1){
    1c58:	fd843783          	ld	a5,-40(s0)
    1c5c:	0786                	slli	a5,a5,0x1
    1c5e:	fcf43c23          	sd	a5,-40(s0)
    1c62:	fd843783          	ld	a5,-40(s0)
    1c66:	ffe1                	bnez	a5,1c3e <MAXVAplus+0x1e>
    1c68:	64e2                	ld	s1,24(sp)
    1c6a:	6942                	ld	s2,16(sp)
}
    1c6c:	70a2                	ld	ra,40(sp)
    1c6e:	7402                	ld	s0,32(sp)
    1c70:	6145                	addi	sp,sp,48
    1c72:	8082                	ret
      printf("%s: fork failed\n", s);
    1c74:	85ca                	mv	a1,s2
    1c76:	00004517          	auipc	a0,0x4
    1c7a:	cb250513          	addi	a0,a0,-846 # 5928 <malloc+0x9ce>
    1c7e:	228030ef          	jal	4ea6 <printf>
      exit(1);
    1c82:	4505                	li	a0,1
    1c84:	603020ef          	jal	4a86 <exit>
      *(char*)a = 99;
    1c88:	fd843783          	ld	a5,-40(s0)
    1c8c:	06300713          	li	a4,99
    1c90:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1c94:	fd843603          	ld	a2,-40(s0)
    1c98:	85ca                	mv	a1,s2
    1c9a:	00004517          	auipc	a0,0x4
    1c9e:	f7e50513          	addi	a0,a0,-130 # 5c18 <malloc+0xcbe>
    1ca2:	204030ef          	jal	4ea6 <printf>
      exit(1);
    1ca6:	4505                	li	a0,1
    1ca8:	5df020ef          	jal	4a86 <exit>
      exit(1);
    1cac:	4505                	li	a0,1
    1cae:	5d9020ef          	jal	4a86 <exit>

0000000000001cb2 <stacktest>:
{
    1cb2:	7179                	addi	sp,sp,-48
    1cb4:	f406                	sd	ra,40(sp)
    1cb6:	f022                	sd	s0,32(sp)
    1cb8:	ec26                	sd	s1,24(sp)
    1cba:	1800                	addi	s0,sp,48
    1cbc:	84aa                	mv	s1,a0
  pid = fork();
    1cbe:	5c1020ef          	jal	4a7e <fork>
  if(pid == 0) {
    1cc2:	cd11                	beqz	a0,1cde <stacktest+0x2c>
  } else if(pid < 0){
    1cc4:	02054c63          	bltz	a0,1cfc <stacktest+0x4a>
  wait(&xstatus);
    1cc8:	fdc40513          	addi	a0,s0,-36
    1ccc:	5c3020ef          	jal	4a8e <wait>
  if(xstatus == -1)  // kernel killed child?
    1cd0:	fdc42503          	lw	a0,-36(s0)
    1cd4:	57fd                	li	a5,-1
    1cd6:	02f50d63          	beq	a0,a5,1d10 <stacktest+0x5e>
    exit(xstatus);
    1cda:	5ad020ef          	jal	4a86 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1cde:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1ce0:	77fd                	lui	a5,0xfffff
    1ce2:	97ba                	add	a5,a5,a4
    1ce4:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    1ce8:	85a6                	mv	a1,s1
    1cea:	00004517          	auipc	a0,0x4
    1cee:	f4650513          	addi	a0,a0,-186 # 5c30 <malloc+0xcd6>
    1cf2:	1b4030ef          	jal	4ea6 <printf>
    exit(1);
    1cf6:	4505                	li	a0,1
    1cf8:	58f020ef          	jal	4a86 <exit>
    printf("%s: fork failed\n", s);
    1cfc:	85a6                	mv	a1,s1
    1cfe:	00004517          	auipc	a0,0x4
    1d02:	c2a50513          	addi	a0,a0,-982 # 5928 <malloc+0x9ce>
    1d06:	1a0030ef          	jal	4ea6 <printf>
    exit(1);
    1d0a:	4505                	li	a0,1
    1d0c:	57b020ef          	jal	4a86 <exit>
    exit(0);
    1d10:	4501                	li	a0,0
    1d12:	575020ef          	jal	4a86 <exit>

0000000000001d16 <nowrite>:
{
    1d16:	7159                	addi	sp,sp,-112
    1d18:	f486                	sd	ra,104(sp)
    1d1a:	f0a2                	sd	s0,96(sp)
    1d1c:	eca6                	sd	s1,88(sp)
    1d1e:	e8ca                	sd	s2,80(sp)
    1d20:	e4ce                	sd	s3,72(sp)
    1d22:	1880                	addi	s0,sp,112
    1d24:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1d26:	00005797          	auipc	a5,0x5
    1d2a:	6d278793          	addi	a5,a5,1746 # 73f8 <malloc+0x249e>
    1d2e:	7788                	ld	a0,40(a5)
    1d30:	7b8c                	ld	a1,48(a5)
    1d32:	7f90                	ld	a2,56(a5)
    1d34:	63b4                	ld	a3,64(a5)
    1d36:	67b8                	ld	a4,72(a5)
    1d38:	6bbc                	ld	a5,80(a5)
    1d3a:	f8a43c23          	sd	a0,-104(s0)
    1d3e:	fab43023          	sd	a1,-96(s0)
    1d42:	fac43423          	sd	a2,-88(s0)
    1d46:	fad43823          	sd	a3,-80(s0)
    1d4a:	fae43c23          	sd	a4,-72(s0)
    1d4e:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d52:	4481                	li	s1,0
    1d54:	4919                	li	s2,6
    pid = fork();
    1d56:	529020ef          	jal	4a7e <fork>
    if(pid == 0) {
    1d5a:	c105                	beqz	a0,1d7a <nowrite+0x64>
    } else if(pid < 0){
    1d5c:	04054263          	bltz	a0,1da0 <nowrite+0x8a>
    wait(&xstatus);
    1d60:	fcc40513          	addi	a0,s0,-52
    1d64:	52b020ef          	jal	4a8e <wait>
    if(xstatus == 0){
    1d68:	fcc42783          	lw	a5,-52(s0)
    1d6c:	c7a1                	beqz	a5,1db4 <nowrite+0x9e>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d6e:	2485                	addiw	s1,s1,1
    1d70:	ff2493e3          	bne	s1,s2,1d56 <nowrite+0x40>
  exit(0);
    1d74:	4501                	li	a0,0
    1d76:	511020ef          	jal	4a86 <exit>
      volatile int *addr = (int *) addrs[ai];
    1d7a:	048e                	slli	s1,s1,0x3
    1d7c:	fd048793          	addi	a5,s1,-48
    1d80:	008784b3          	add	s1,a5,s0
    1d84:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1d88:	47a9                	li	a5,10
    1d8a:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1d8c:	85ce                	mv	a1,s3
    1d8e:	00004517          	auipc	a0,0x4
    1d92:	eca50513          	addi	a0,a0,-310 # 5c58 <malloc+0xcfe>
    1d96:	110030ef          	jal	4ea6 <printf>
      exit(0);
    1d9a:	4501                	li	a0,0
    1d9c:	4eb020ef          	jal	4a86 <exit>
      printf("%s: fork failed\n", s);
    1da0:	85ce                	mv	a1,s3
    1da2:	00004517          	auipc	a0,0x4
    1da6:	b8650513          	addi	a0,a0,-1146 # 5928 <malloc+0x9ce>
    1daa:	0fc030ef          	jal	4ea6 <printf>
      exit(1);
    1dae:	4505                	li	a0,1
    1db0:	4d7020ef          	jal	4a86 <exit>
      exit(1);
    1db4:	4505                	li	a0,1
    1db6:	4d1020ef          	jal	4a86 <exit>

0000000000001dba <manywrites>:
{
    1dba:	711d                	addi	sp,sp,-96
    1dbc:	ec86                	sd	ra,88(sp)
    1dbe:	e8a2                	sd	s0,80(sp)
    1dc0:	e4a6                	sd	s1,72(sp)
    1dc2:	e0ca                	sd	s2,64(sp)
    1dc4:	fc4e                	sd	s3,56(sp)
    1dc6:	f456                	sd	s5,40(sp)
    1dc8:	1080                	addi	s0,sp,96
    1dca:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1dcc:	4981                	li	s3,0
    1dce:	4911                	li	s2,4
    int pid = fork();
    1dd0:	4af020ef          	jal	4a7e <fork>
    1dd4:	84aa                	mv	s1,a0
    if(pid < 0){
    1dd6:	02054963          	bltz	a0,1e08 <manywrites+0x4e>
    if(pid == 0){
    1dda:	c139                	beqz	a0,1e20 <manywrites+0x66>
  for(int ci = 0; ci < nchildren; ci++){
    1ddc:	2985                	addiw	s3,s3,1
    1dde:	ff2999e3          	bne	s3,s2,1dd0 <manywrites+0x16>
    1de2:	f852                	sd	s4,48(sp)
    1de4:	f05a                	sd	s6,32(sp)
    1de6:	ec5e                	sd	s7,24(sp)
    1de8:	4491                	li	s1,4
    int st = 0;
    1dea:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1dee:	fa840513          	addi	a0,s0,-88
    1df2:	49d020ef          	jal	4a8e <wait>
    if(st != 0)
    1df6:	fa842503          	lw	a0,-88(s0)
    1dfa:	0c051863          	bnez	a0,1eca <manywrites+0x110>
  for(int ci = 0; ci < nchildren; ci++){
    1dfe:	34fd                	addiw	s1,s1,-1
    1e00:	f4ed                	bnez	s1,1dea <manywrites+0x30>
  exit(0);
    1e02:	4501                	li	a0,0
    1e04:	483020ef          	jal	4a86 <exit>
    1e08:	f852                	sd	s4,48(sp)
    1e0a:	f05a                	sd	s6,32(sp)
    1e0c:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    1e0e:	00005517          	auipc	a0,0x5
    1e12:	08a50513          	addi	a0,a0,138 # 6e98 <malloc+0x1f3e>
    1e16:	090030ef          	jal	4ea6 <printf>
      exit(1);
    1e1a:	4505                	li	a0,1
    1e1c:	46b020ef          	jal	4a86 <exit>
    1e20:	f852                	sd	s4,48(sp)
    1e22:	f05a                	sd	s6,32(sp)
    1e24:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    1e26:	06200793          	li	a5,98
    1e2a:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1e2e:	0619879b          	addiw	a5,s3,97
    1e32:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1e36:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1e3a:	fa840513          	addi	a0,s0,-88
    1e3e:	499020ef          	jal	4ad6 <unlink>
    1e42:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1e44:	0000bb17          	auipc	s6,0xb
    1e48:	e34b0b13          	addi	s6,s6,-460 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    1e4c:	8a26                	mv	s4,s1
    1e4e:	0209c863          	bltz	s3,1e7e <manywrites+0xc4>
          int fd = open(name, O_CREATE | O_RDWR);
    1e52:	20200593          	li	a1,514
    1e56:	fa840513          	addi	a0,s0,-88
    1e5a:	46d020ef          	jal	4ac6 <open>
    1e5e:	892a                	mv	s2,a0
          if(fd < 0){
    1e60:	02054d63          	bltz	a0,1e9a <manywrites+0xe0>
          int cc = write(fd, buf, sz);
    1e64:	660d                	lui	a2,0x3
    1e66:	85da                	mv	a1,s6
    1e68:	43f020ef          	jal	4aa6 <write>
          if(cc != sz){
    1e6c:	678d                	lui	a5,0x3
    1e6e:	04f51263          	bne	a0,a5,1eb2 <manywrites+0xf8>
          close(fd);
    1e72:	854a                	mv	a0,s2
    1e74:	43b020ef          	jal	4aae <close>
        for(int i = 0; i < ci+1; i++){
    1e78:	2a05                	addiw	s4,s4,1
    1e7a:	fd49dce3          	bge	s3,s4,1e52 <manywrites+0x98>
        unlink(name);
    1e7e:	fa840513          	addi	a0,s0,-88
    1e82:	455020ef          	jal	4ad6 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1e86:	3bfd                	addiw	s7,s7,-1
    1e88:	fc0b92e3          	bnez	s7,1e4c <manywrites+0x92>
      unlink(name);
    1e8c:	fa840513          	addi	a0,s0,-88
    1e90:	447020ef          	jal	4ad6 <unlink>
      exit(0);
    1e94:	4501                	li	a0,0
    1e96:	3f1020ef          	jal	4a86 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e9a:	fa840613          	addi	a2,s0,-88
    1e9e:	85d6                	mv	a1,s5
    1ea0:	00004517          	auipc	a0,0x4
    1ea4:	dd850513          	addi	a0,a0,-552 # 5c78 <malloc+0xd1e>
    1ea8:	7ff020ef          	jal	4ea6 <printf>
            exit(1);
    1eac:	4505                	li	a0,1
    1eae:	3d9020ef          	jal	4a86 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1eb2:	86aa                	mv	a3,a0
    1eb4:	660d                	lui	a2,0x3
    1eb6:	85d6                	mv	a1,s5
    1eb8:	00003517          	auipc	a0,0x3
    1ebc:	2b050513          	addi	a0,a0,688 # 5168 <malloc+0x20e>
    1ec0:	7e7020ef          	jal	4ea6 <printf>
            exit(1);
    1ec4:	4505                	li	a0,1
    1ec6:	3c1020ef          	jal	4a86 <exit>
      exit(st);
    1eca:	3bd020ef          	jal	4a86 <exit>

0000000000001ece <copyinstr3>:
{
    1ece:	7179                	addi	sp,sp,-48
    1ed0:	f406                	sd	ra,40(sp)
    1ed2:	f022                	sd	s0,32(sp)
    1ed4:	ec26                	sd	s1,24(sp)
    1ed6:	1800                	addi	s0,sp,48
  sbrk(8192);
    1ed8:	6509                	lui	a0,0x2
    1eda:	435020ef          	jal	4b0e <sbrk>
  uint64 top = (uint64) sbrk(0);
    1ede:	4501                	li	a0,0
    1ee0:	42f020ef          	jal	4b0e <sbrk>
  if((top % PGSIZE) != 0){
    1ee4:	03451793          	slli	a5,a0,0x34
    1ee8:	e7bd                	bnez	a5,1f56 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1eea:	4501                	li	a0,0
    1eec:	423020ef          	jal	4b0e <sbrk>
  if(top % PGSIZE){
    1ef0:	03451793          	slli	a5,a0,0x34
    1ef4:	ebad                	bnez	a5,1f66 <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ef6:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0x2d>
  *b = 'x';
    1efa:	07800793          	li	a5,120
    1efe:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1f02:	8526                	mv	a0,s1
    1f04:	3d3020ef          	jal	4ad6 <unlink>
  if(ret != -1){
    1f08:	57fd                	li	a5,-1
    1f0a:	06f51763          	bne	a0,a5,1f78 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1f0e:	20100593          	li	a1,513
    1f12:	8526                	mv	a0,s1
    1f14:	3b3020ef          	jal	4ac6 <open>
  if(fd != -1){
    1f18:	57fd                	li	a5,-1
    1f1a:	06f51a63          	bne	a0,a5,1f8e <copyinstr3+0xc0>
  ret = link(b, b);
    1f1e:	85a6                	mv	a1,s1
    1f20:	8526                	mv	a0,s1
    1f22:	3c5020ef          	jal	4ae6 <link>
  if(ret != -1){
    1f26:	57fd                	li	a5,-1
    1f28:	06f51e63          	bne	a0,a5,1fa4 <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    1f2c:	00005797          	auipc	a5,0x5
    1f30:	a4c78793          	addi	a5,a5,-1460 # 6978 <malloc+0x1a1e>
    1f34:	fcf43823          	sd	a5,-48(s0)
    1f38:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1f3c:	fd040593          	addi	a1,s0,-48
    1f40:	8526                	mv	a0,s1
    1f42:	37d020ef          	jal	4abe <exec>
  if(ret != -1){
    1f46:	57fd                	li	a5,-1
    1f48:	06f51a63          	bne	a0,a5,1fbc <copyinstr3+0xee>
}
    1f4c:	70a2                	ld	ra,40(sp)
    1f4e:	7402                	ld	s0,32(sp)
    1f50:	64e2                	ld	s1,24(sp)
    1f52:	6145                	addi	sp,sp,48
    1f54:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1f56:	0347d513          	srli	a0,a5,0x34
    1f5a:	6785                	lui	a5,0x1
    1f5c:	40a7853b          	subw	a0,a5,a0
    1f60:	3af020ef          	jal	4b0e <sbrk>
    1f64:	b759                	j	1eea <copyinstr3+0x1c>
    printf("oops\n");
    1f66:	00004517          	auipc	a0,0x4
    1f6a:	d2a50513          	addi	a0,a0,-726 # 5c90 <malloc+0xd36>
    1f6e:	739020ef          	jal	4ea6 <printf>
    exit(1);
    1f72:	4505                	li	a0,1
    1f74:	313020ef          	jal	4a86 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f78:	862a                	mv	a2,a0
    1f7a:	85a6                	mv	a1,s1
    1f7c:	00004517          	auipc	a0,0x4
    1f80:	8cc50513          	addi	a0,a0,-1844 # 5848 <malloc+0x8ee>
    1f84:	723020ef          	jal	4ea6 <printf>
    exit(1);
    1f88:	4505                	li	a0,1
    1f8a:	2fd020ef          	jal	4a86 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f8e:	862a                	mv	a2,a0
    1f90:	85a6                	mv	a1,s1
    1f92:	00004517          	auipc	a0,0x4
    1f96:	8d650513          	addi	a0,a0,-1834 # 5868 <malloc+0x90e>
    1f9a:	70d020ef          	jal	4ea6 <printf>
    exit(1);
    1f9e:	4505                	li	a0,1
    1fa0:	2e7020ef          	jal	4a86 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1fa4:	86aa                	mv	a3,a0
    1fa6:	8626                	mv	a2,s1
    1fa8:	85a6                	mv	a1,s1
    1faa:	00004517          	auipc	a0,0x4
    1fae:	8de50513          	addi	a0,a0,-1826 # 5888 <malloc+0x92e>
    1fb2:	6f5020ef          	jal	4ea6 <printf>
    exit(1);
    1fb6:	4505                	li	a0,1
    1fb8:	2cf020ef          	jal	4a86 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1fbc:	567d                	li	a2,-1
    1fbe:	85a6                	mv	a1,s1
    1fc0:	00004517          	auipc	a0,0x4
    1fc4:	8f050513          	addi	a0,a0,-1808 # 58b0 <malloc+0x956>
    1fc8:	6df020ef          	jal	4ea6 <printf>
    exit(1);
    1fcc:	4505                	li	a0,1
    1fce:	2b9020ef          	jal	4a86 <exit>

0000000000001fd2 <rwsbrk>:
{
    1fd2:	1101                	addi	sp,sp,-32
    1fd4:	ec06                	sd	ra,24(sp)
    1fd6:	e822                	sd	s0,16(sp)
    1fd8:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1fda:	6509                	lui	a0,0x2
    1fdc:	333020ef          	jal	4b0e <sbrk>
  if(a == 0xffffffffffffffffLL) {
    1fe0:	57fd                	li	a5,-1
    1fe2:	04f50a63          	beq	a0,a5,2036 <rwsbrk+0x64>
    1fe6:	e426                	sd	s1,8(sp)
    1fe8:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    1fea:	7579                	lui	a0,0xffffe
    1fec:	323020ef          	jal	4b0e <sbrk>
    1ff0:	57fd                	li	a5,-1
    1ff2:	04f50d63          	beq	a0,a5,204c <rwsbrk+0x7a>
    1ff6:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1ff8:	20100593          	li	a1,513
    1ffc:	00004517          	auipc	a0,0x4
    2000:	cd450513          	addi	a0,a0,-812 # 5cd0 <malloc+0xd76>
    2004:	2c3020ef          	jal	4ac6 <open>
    2008:	892a                	mv	s2,a0
  if(fd < 0){
    200a:	04054b63          	bltz	a0,2060 <rwsbrk+0x8e>
  n = write(fd, (void*)(a+4096), 1024);
    200e:	6785                	lui	a5,0x1
    2010:	94be                	add	s1,s1,a5
    2012:	40000613          	li	a2,1024
    2016:	85a6                	mv	a1,s1
    2018:	28f020ef          	jal	4aa6 <write>
    201c:	862a                	mv	a2,a0
  if(n >= 0){
    201e:	04054a63          	bltz	a0,2072 <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    2022:	85a6                	mv	a1,s1
    2024:	00004517          	auipc	a0,0x4
    2028:	ccc50513          	addi	a0,a0,-820 # 5cf0 <malloc+0xd96>
    202c:	67b020ef          	jal	4ea6 <printf>
    exit(1);
    2030:	4505                	li	a0,1
    2032:	255020ef          	jal	4a86 <exit>
    2036:	e426                	sd	s1,8(sp)
    2038:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    203a:	00004517          	auipc	a0,0x4
    203e:	c5e50513          	addi	a0,a0,-930 # 5c98 <malloc+0xd3e>
    2042:	665020ef          	jal	4ea6 <printf>
    exit(1);
    2046:	4505                	li	a0,1
    2048:	23f020ef          	jal	4a86 <exit>
    204c:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    204e:	00004517          	auipc	a0,0x4
    2052:	c6250513          	addi	a0,a0,-926 # 5cb0 <malloc+0xd56>
    2056:	651020ef          	jal	4ea6 <printf>
    exit(1);
    205a:	4505                	li	a0,1
    205c:	22b020ef          	jal	4a86 <exit>
    printf("open(rwsbrk) failed\n");
    2060:	00004517          	auipc	a0,0x4
    2064:	c7850513          	addi	a0,a0,-904 # 5cd8 <malloc+0xd7e>
    2068:	63f020ef          	jal	4ea6 <printf>
    exit(1);
    206c:	4505                	li	a0,1
    206e:	219020ef          	jal	4a86 <exit>
  close(fd);
    2072:	854a                	mv	a0,s2
    2074:	23b020ef          	jal	4aae <close>
  unlink("rwsbrk");
    2078:	00004517          	auipc	a0,0x4
    207c:	c5850513          	addi	a0,a0,-936 # 5cd0 <malloc+0xd76>
    2080:	257020ef          	jal	4ad6 <unlink>
  fd = open("README", O_RDONLY);
    2084:	4581                	li	a1,0
    2086:	00003517          	auipc	a0,0x3
    208a:	1ea50513          	addi	a0,a0,490 # 5270 <malloc+0x316>
    208e:	239020ef          	jal	4ac6 <open>
    2092:	892a                	mv	s2,a0
  if(fd < 0){
    2094:	02054363          	bltz	a0,20ba <rwsbrk+0xe8>
  n = read(fd, (void*)(a+4096), 10);
    2098:	4629                	li	a2,10
    209a:	85a6                	mv	a1,s1
    209c:	203020ef          	jal	4a9e <read>
    20a0:	862a                	mv	a2,a0
  if(n >= 0){
    20a2:	02054563          	bltz	a0,20cc <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    20a6:	85a6                	mv	a1,s1
    20a8:	00004517          	auipc	a0,0x4
    20ac:	c7850513          	addi	a0,a0,-904 # 5d20 <malloc+0xdc6>
    20b0:	5f7020ef          	jal	4ea6 <printf>
    exit(1);
    20b4:	4505                	li	a0,1
    20b6:	1d1020ef          	jal	4a86 <exit>
    printf("open(rwsbrk) failed\n");
    20ba:	00004517          	auipc	a0,0x4
    20be:	c1e50513          	addi	a0,a0,-994 # 5cd8 <malloc+0xd7e>
    20c2:	5e5020ef          	jal	4ea6 <printf>
    exit(1);
    20c6:	4505                	li	a0,1
    20c8:	1bf020ef          	jal	4a86 <exit>
  close(fd);
    20cc:	854a                	mv	a0,s2
    20ce:	1e1020ef          	jal	4aae <close>
  exit(0);
    20d2:	4501                	li	a0,0
    20d4:	1b3020ef          	jal	4a86 <exit>

00000000000020d8 <sbrkbasic>:
{
    20d8:	7139                	addi	sp,sp,-64
    20da:	fc06                	sd	ra,56(sp)
    20dc:	f822                	sd	s0,48(sp)
    20de:	ec4e                	sd	s3,24(sp)
    20e0:	0080                	addi	s0,sp,64
    20e2:	89aa                	mv	s3,a0
  pid = fork();
    20e4:	19b020ef          	jal	4a7e <fork>
  if(pid < 0){
    20e8:	02054b63          	bltz	a0,211e <sbrkbasic+0x46>
  if(pid == 0){
    20ec:	e939                	bnez	a0,2142 <sbrkbasic+0x6a>
    a = sbrk(TOOMUCH);
    20ee:	40000537          	lui	a0,0x40000
    20f2:	21d020ef          	jal	4b0e <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    20f6:	57fd                	li	a5,-1
    20f8:	02f50f63          	beq	a0,a5,2136 <sbrkbasic+0x5e>
    20fc:	f426                	sd	s1,40(sp)
    20fe:	f04a                	sd	s2,32(sp)
    2100:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    2102:	400007b7          	lui	a5,0x40000
    2106:	97aa                	add	a5,a5,a0
      *b = 99;
    2108:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    210c:	6705                	lui	a4,0x1
      *b = 99;
    210e:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    2112:	953a                	add	a0,a0,a4
    2114:	fef51de3          	bne	a0,a5,210e <sbrkbasic+0x36>
    exit(1);
    2118:	4505                	li	a0,1
    211a:	16d020ef          	jal	4a86 <exit>
    211e:	f426                	sd	s1,40(sp)
    2120:	f04a                	sd	s2,32(sp)
    2122:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    2124:	00004517          	auipc	a0,0x4
    2128:	c2450513          	addi	a0,a0,-988 # 5d48 <malloc+0xdee>
    212c:	57b020ef          	jal	4ea6 <printf>
    exit(1);
    2130:	4505                	li	a0,1
    2132:	155020ef          	jal	4a86 <exit>
    2136:	f426                	sd	s1,40(sp)
    2138:	f04a                	sd	s2,32(sp)
    213a:	e852                	sd	s4,16(sp)
      exit(0);
    213c:	4501                	li	a0,0
    213e:	149020ef          	jal	4a86 <exit>
  wait(&xstatus);
    2142:	fcc40513          	addi	a0,s0,-52
    2146:	149020ef          	jal	4a8e <wait>
  if(xstatus == 1){
    214a:	fcc42703          	lw	a4,-52(s0)
    214e:	4785                	li	a5,1
    2150:	00f70e63          	beq	a4,a5,216c <sbrkbasic+0x94>
    2154:	f426                	sd	s1,40(sp)
    2156:	f04a                	sd	s2,32(sp)
    2158:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    215a:	4501                	li	a0,0
    215c:	1b3020ef          	jal	4b0e <sbrk>
    2160:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2162:	4901                	li	s2,0
    2164:	6a05                	lui	s4,0x1
    2166:	388a0a13          	addi	s4,s4,904 # 1388 <exectest+0x46>
    216a:	a839                	j	2188 <sbrkbasic+0xb0>
    216c:	f426                	sd	s1,40(sp)
    216e:	f04a                	sd	s2,32(sp)
    2170:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    2172:	85ce                	mv	a1,s3
    2174:	00004517          	auipc	a0,0x4
    2178:	bf450513          	addi	a0,a0,-1036 # 5d68 <malloc+0xe0e>
    217c:	52b020ef          	jal	4ea6 <printf>
    exit(1);
    2180:	4505                	li	a0,1
    2182:	105020ef          	jal	4a86 <exit>
    2186:	84be                	mv	s1,a5
    b = sbrk(1);
    2188:	4505                	li	a0,1
    218a:	185020ef          	jal	4b0e <sbrk>
    if(b != a){
    218e:	04951263          	bne	a0,s1,21d2 <sbrkbasic+0xfa>
    *b = 1;
    2192:	4785                	li	a5,1
    2194:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2198:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    219c:	2905                	addiw	s2,s2,1
    219e:	ff4914e3          	bne	s2,s4,2186 <sbrkbasic+0xae>
  pid = fork();
    21a2:	0dd020ef          	jal	4a7e <fork>
    21a6:	892a                	mv	s2,a0
  if(pid < 0){
    21a8:	04054263          	bltz	a0,21ec <sbrkbasic+0x114>
  c = sbrk(1);
    21ac:	4505                	li	a0,1
    21ae:	161020ef          	jal	4b0e <sbrk>
  c = sbrk(1);
    21b2:	4505                	li	a0,1
    21b4:	15b020ef          	jal	4b0e <sbrk>
  if(c != a + 1){
    21b8:	0489                	addi	s1,s1,2
    21ba:	04a48363          	beq	s1,a0,2200 <sbrkbasic+0x128>
    printf("%s: sbrk test failed post-fork\n", s);
    21be:	85ce                	mv	a1,s3
    21c0:	00004517          	auipc	a0,0x4
    21c4:	c0850513          	addi	a0,a0,-1016 # 5dc8 <malloc+0xe6e>
    21c8:	4df020ef          	jal	4ea6 <printf>
    exit(1);
    21cc:	4505                	li	a0,1
    21ce:	0b9020ef          	jal	4a86 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    21d2:	872a                	mv	a4,a0
    21d4:	86a6                	mv	a3,s1
    21d6:	864a                	mv	a2,s2
    21d8:	85ce                	mv	a1,s3
    21da:	00004517          	auipc	a0,0x4
    21de:	bae50513          	addi	a0,a0,-1106 # 5d88 <malloc+0xe2e>
    21e2:	4c5020ef          	jal	4ea6 <printf>
      exit(1);
    21e6:	4505                	li	a0,1
    21e8:	09f020ef          	jal	4a86 <exit>
    printf("%s: sbrk test fork failed\n", s);
    21ec:	85ce                	mv	a1,s3
    21ee:	00004517          	auipc	a0,0x4
    21f2:	bba50513          	addi	a0,a0,-1094 # 5da8 <malloc+0xe4e>
    21f6:	4b1020ef          	jal	4ea6 <printf>
    exit(1);
    21fa:	4505                	li	a0,1
    21fc:	08b020ef          	jal	4a86 <exit>
  if(pid == 0)
    2200:	00091563          	bnez	s2,220a <sbrkbasic+0x132>
    exit(0);
    2204:	4501                	li	a0,0
    2206:	081020ef          	jal	4a86 <exit>
  wait(&xstatus);
    220a:	fcc40513          	addi	a0,s0,-52
    220e:	081020ef          	jal	4a8e <wait>
  exit(xstatus);
    2212:	fcc42503          	lw	a0,-52(s0)
    2216:	071020ef          	jal	4a86 <exit>

000000000000221a <sbrkmuch>:
{
    221a:	7179                	addi	sp,sp,-48
    221c:	f406                	sd	ra,40(sp)
    221e:	f022                	sd	s0,32(sp)
    2220:	ec26                	sd	s1,24(sp)
    2222:	e84a                	sd	s2,16(sp)
    2224:	e44e                	sd	s3,8(sp)
    2226:	e052                	sd	s4,0(sp)
    2228:	1800                	addi	s0,sp,48
    222a:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    222c:	4501                	li	a0,0
    222e:	0e1020ef          	jal	4b0e <sbrk>
    2232:	892a                	mv	s2,a0
  a = sbrk(0);
    2234:	4501                	li	a0,0
    2236:	0d9020ef          	jal	4b0e <sbrk>
    223a:	84aa                	mv	s1,a0
  p = sbrk(amt);
    223c:	06400537          	lui	a0,0x6400
    2240:	9d05                	subw	a0,a0,s1
    2242:	0cd020ef          	jal	4b0e <sbrk>
  if (p != a) {
    2246:	0aa49463          	bne	s1,a0,22ee <sbrkmuch+0xd4>
  char *eee = sbrk(0);
    224a:	4501                	li	a0,0
    224c:	0c3020ef          	jal	4b0e <sbrk>
    2250:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2252:	00a4f963          	bgeu	s1,a0,2264 <sbrkmuch+0x4a>
    *pp = 1;
    2256:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2258:	6705                	lui	a4,0x1
    *pp = 1;
    225a:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    225e:	94ba                	add	s1,s1,a4
    2260:	fef4ede3          	bltu	s1,a5,225a <sbrkmuch+0x40>
  *lastaddr = 99;
    2264:	064007b7          	lui	a5,0x6400
    2268:	06300713          	li	a4,99
    226c:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2270:	4501                	li	a0,0
    2272:	09d020ef          	jal	4b0e <sbrk>
    2276:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2278:	757d                	lui	a0,0xfffff
    227a:	095020ef          	jal	4b0e <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    227e:	57fd                	li	a5,-1
    2280:	08f50163          	beq	a0,a5,2302 <sbrkmuch+0xe8>
  c = sbrk(0);
    2284:	4501                	li	a0,0
    2286:	089020ef          	jal	4b0e <sbrk>
  if(c != a - PGSIZE){
    228a:	77fd                	lui	a5,0xfffff
    228c:	97a6                	add	a5,a5,s1
    228e:	08f51463          	bne	a0,a5,2316 <sbrkmuch+0xfc>
  a = sbrk(0);
    2292:	4501                	li	a0,0
    2294:	07b020ef          	jal	4b0e <sbrk>
    2298:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    229a:	6505                	lui	a0,0x1
    229c:	073020ef          	jal	4b0e <sbrk>
    22a0:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    22a2:	08a49663          	bne	s1,a0,232e <sbrkmuch+0x114>
    22a6:	4501                	li	a0,0
    22a8:	067020ef          	jal	4b0e <sbrk>
    22ac:	6785                	lui	a5,0x1
    22ae:	97a6                	add	a5,a5,s1
    22b0:	06f51f63          	bne	a0,a5,232e <sbrkmuch+0x114>
  if(*lastaddr == 99){
    22b4:	064007b7          	lui	a5,0x6400
    22b8:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    22bc:	06300793          	li	a5,99
    22c0:	08f70363          	beq	a4,a5,2346 <sbrkmuch+0x12c>
  a = sbrk(0);
    22c4:	4501                	li	a0,0
    22c6:	049020ef          	jal	4b0e <sbrk>
    22ca:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    22cc:	4501                	li	a0,0
    22ce:	041020ef          	jal	4b0e <sbrk>
    22d2:	40a9053b          	subw	a0,s2,a0
    22d6:	039020ef          	jal	4b0e <sbrk>
  if(c != a){
    22da:	08a49063          	bne	s1,a0,235a <sbrkmuch+0x140>
}
    22de:	70a2                	ld	ra,40(sp)
    22e0:	7402                	ld	s0,32(sp)
    22e2:	64e2                	ld	s1,24(sp)
    22e4:	6942                	ld	s2,16(sp)
    22e6:	69a2                	ld	s3,8(sp)
    22e8:	6a02                	ld	s4,0(sp)
    22ea:	6145                	addi	sp,sp,48
    22ec:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    22ee:	85ce                	mv	a1,s3
    22f0:	00004517          	auipc	a0,0x4
    22f4:	af850513          	addi	a0,a0,-1288 # 5de8 <malloc+0xe8e>
    22f8:	3af020ef          	jal	4ea6 <printf>
    exit(1);
    22fc:	4505                	li	a0,1
    22fe:	788020ef          	jal	4a86 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2302:	85ce                	mv	a1,s3
    2304:	00004517          	auipc	a0,0x4
    2308:	b2c50513          	addi	a0,a0,-1236 # 5e30 <malloc+0xed6>
    230c:	39b020ef          	jal	4ea6 <printf>
    exit(1);
    2310:	4505                	li	a0,1
    2312:	774020ef          	jal	4a86 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2316:	86aa                	mv	a3,a0
    2318:	8626                	mv	a2,s1
    231a:	85ce                	mv	a1,s3
    231c:	00004517          	auipc	a0,0x4
    2320:	b3450513          	addi	a0,a0,-1228 # 5e50 <malloc+0xef6>
    2324:	383020ef          	jal	4ea6 <printf>
    exit(1);
    2328:	4505                	li	a0,1
    232a:	75c020ef          	jal	4a86 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    232e:	86d2                	mv	a3,s4
    2330:	8626                	mv	a2,s1
    2332:	85ce                	mv	a1,s3
    2334:	00004517          	auipc	a0,0x4
    2338:	b5c50513          	addi	a0,a0,-1188 # 5e90 <malloc+0xf36>
    233c:	36b020ef          	jal	4ea6 <printf>
    exit(1);
    2340:	4505                	li	a0,1
    2342:	744020ef          	jal	4a86 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2346:	85ce                	mv	a1,s3
    2348:	00004517          	auipc	a0,0x4
    234c:	b7850513          	addi	a0,a0,-1160 # 5ec0 <malloc+0xf66>
    2350:	357020ef          	jal	4ea6 <printf>
    exit(1);
    2354:	4505                	li	a0,1
    2356:	730020ef          	jal	4a86 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    235a:	86aa                	mv	a3,a0
    235c:	8626                	mv	a2,s1
    235e:	85ce                	mv	a1,s3
    2360:	00004517          	auipc	a0,0x4
    2364:	b9850513          	addi	a0,a0,-1128 # 5ef8 <malloc+0xf9e>
    2368:	33f020ef          	jal	4ea6 <printf>
    exit(1);
    236c:	4505                	li	a0,1
    236e:	718020ef          	jal	4a86 <exit>

0000000000002372 <sbrkarg>:
{
    2372:	7179                	addi	sp,sp,-48
    2374:	f406                	sd	ra,40(sp)
    2376:	f022                	sd	s0,32(sp)
    2378:	ec26                	sd	s1,24(sp)
    237a:	e84a                	sd	s2,16(sp)
    237c:	e44e                	sd	s3,8(sp)
    237e:	1800                	addi	s0,sp,48
    2380:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2382:	6505                	lui	a0,0x1
    2384:	78a020ef          	jal	4b0e <sbrk>
    2388:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    238a:	20100593          	li	a1,513
    238e:	00004517          	auipc	a0,0x4
    2392:	b9250513          	addi	a0,a0,-1134 # 5f20 <malloc+0xfc6>
    2396:	730020ef          	jal	4ac6 <open>
    239a:	84aa                	mv	s1,a0
  unlink("sbrk");
    239c:	00004517          	auipc	a0,0x4
    23a0:	b8450513          	addi	a0,a0,-1148 # 5f20 <malloc+0xfc6>
    23a4:	732020ef          	jal	4ad6 <unlink>
  if(fd < 0)  {
    23a8:	0204c963          	bltz	s1,23da <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    23ac:	6605                	lui	a2,0x1
    23ae:	85ca                	mv	a1,s2
    23b0:	8526                	mv	a0,s1
    23b2:	6f4020ef          	jal	4aa6 <write>
    23b6:	02054c63          	bltz	a0,23ee <sbrkarg+0x7c>
  close(fd);
    23ba:	8526                	mv	a0,s1
    23bc:	6f2020ef          	jal	4aae <close>
  a = sbrk(PGSIZE);
    23c0:	6505                	lui	a0,0x1
    23c2:	74c020ef          	jal	4b0e <sbrk>
  if(pipe((int *) a) != 0){
    23c6:	6d0020ef          	jal	4a96 <pipe>
    23ca:	ed05                	bnez	a0,2402 <sbrkarg+0x90>
}
    23cc:	70a2                	ld	ra,40(sp)
    23ce:	7402                	ld	s0,32(sp)
    23d0:	64e2                	ld	s1,24(sp)
    23d2:	6942                	ld	s2,16(sp)
    23d4:	69a2                	ld	s3,8(sp)
    23d6:	6145                	addi	sp,sp,48
    23d8:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    23da:	85ce                	mv	a1,s3
    23dc:	00004517          	auipc	a0,0x4
    23e0:	b4c50513          	addi	a0,a0,-1204 # 5f28 <malloc+0xfce>
    23e4:	2c3020ef          	jal	4ea6 <printf>
    exit(1);
    23e8:	4505                	li	a0,1
    23ea:	69c020ef          	jal	4a86 <exit>
    printf("%s: write sbrk failed\n", s);
    23ee:	85ce                	mv	a1,s3
    23f0:	00004517          	auipc	a0,0x4
    23f4:	b5050513          	addi	a0,a0,-1200 # 5f40 <malloc+0xfe6>
    23f8:	2af020ef          	jal	4ea6 <printf>
    exit(1);
    23fc:	4505                	li	a0,1
    23fe:	688020ef          	jal	4a86 <exit>
    printf("%s: pipe() failed\n", s);
    2402:	85ce                	mv	a1,s3
    2404:	00003517          	auipc	a0,0x3
    2408:	62c50513          	addi	a0,a0,1580 # 5a30 <malloc+0xad6>
    240c:	29b020ef          	jal	4ea6 <printf>
    exit(1);
    2410:	4505                	li	a0,1
    2412:	674020ef          	jal	4a86 <exit>

0000000000002416 <argptest>:
{
    2416:	1101                	addi	sp,sp,-32
    2418:	ec06                	sd	ra,24(sp)
    241a:	e822                	sd	s0,16(sp)
    241c:	e426                	sd	s1,8(sp)
    241e:	e04a                	sd	s2,0(sp)
    2420:	1000                	addi	s0,sp,32
    2422:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2424:	4581                	li	a1,0
    2426:	00004517          	auipc	a0,0x4
    242a:	b3250513          	addi	a0,a0,-1230 # 5f58 <malloc+0xffe>
    242e:	698020ef          	jal	4ac6 <open>
  if (fd < 0) {
    2432:	02054563          	bltz	a0,245c <argptest+0x46>
    2436:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2438:	4501                	li	a0,0
    243a:	6d4020ef          	jal	4b0e <sbrk>
    243e:	567d                	li	a2,-1
    2440:	fff50593          	addi	a1,a0,-1
    2444:	8526                	mv	a0,s1
    2446:	658020ef          	jal	4a9e <read>
  close(fd);
    244a:	8526                	mv	a0,s1
    244c:	662020ef          	jal	4aae <close>
}
    2450:	60e2                	ld	ra,24(sp)
    2452:	6442                	ld	s0,16(sp)
    2454:	64a2                	ld	s1,8(sp)
    2456:	6902                	ld	s2,0(sp)
    2458:	6105                	addi	sp,sp,32
    245a:	8082                	ret
    printf("%s: open failed\n", s);
    245c:	85ca                	mv	a1,s2
    245e:	00003517          	auipc	a0,0x3
    2462:	4e250513          	addi	a0,a0,1250 # 5940 <malloc+0x9e6>
    2466:	241020ef          	jal	4ea6 <printf>
    exit(1);
    246a:	4505                	li	a0,1
    246c:	61a020ef          	jal	4a86 <exit>

0000000000002470 <sbrkbugs>:
{
    2470:	1141                	addi	sp,sp,-16
    2472:	e406                	sd	ra,8(sp)
    2474:	e022                	sd	s0,0(sp)
    2476:	0800                	addi	s0,sp,16
  int pid = fork();
    2478:	606020ef          	jal	4a7e <fork>
  if(pid < 0){
    247c:	00054c63          	bltz	a0,2494 <sbrkbugs+0x24>
  if(pid == 0){
    2480:	e11d                	bnez	a0,24a6 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    2482:	68c020ef          	jal	4b0e <sbrk>
    sbrk(-sz);
    2486:	40a0053b          	negw	a0,a0
    248a:	684020ef          	jal	4b0e <sbrk>
    exit(0);
    248e:	4501                	li	a0,0
    2490:	5f6020ef          	jal	4a86 <exit>
    printf("fork failed\n");
    2494:	00005517          	auipc	a0,0x5
    2498:	a0450513          	addi	a0,a0,-1532 # 6e98 <malloc+0x1f3e>
    249c:	20b020ef          	jal	4ea6 <printf>
    exit(1);
    24a0:	4505                	li	a0,1
    24a2:	5e4020ef          	jal	4a86 <exit>
  wait(0);
    24a6:	4501                	li	a0,0
    24a8:	5e6020ef          	jal	4a8e <wait>
  pid = fork();
    24ac:	5d2020ef          	jal	4a7e <fork>
  if(pid < 0){
    24b0:	00054f63          	bltz	a0,24ce <sbrkbugs+0x5e>
  if(pid == 0){
    24b4:	e515                	bnez	a0,24e0 <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    24b6:	658020ef          	jal	4b0e <sbrk>
    sbrk(-(sz - 3500));
    24ba:	6785                	lui	a5,0x1
    24bc:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x134>
    24c0:	40a7853b          	subw	a0,a5,a0
    24c4:	64a020ef          	jal	4b0e <sbrk>
    exit(0);
    24c8:	4501                	li	a0,0
    24ca:	5bc020ef          	jal	4a86 <exit>
    printf("fork failed\n");
    24ce:	00005517          	auipc	a0,0x5
    24d2:	9ca50513          	addi	a0,a0,-1590 # 6e98 <malloc+0x1f3e>
    24d6:	1d1020ef          	jal	4ea6 <printf>
    exit(1);
    24da:	4505                	li	a0,1
    24dc:	5aa020ef          	jal	4a86 <exit>
  wait(0);
    24e0:	4501                	li	a0,0
    24e2:	5ac020ef          	jal	4a8e <wait>
  pid = fork();
    24e6:	598020ef          	jal	4a7e <fork>
  if(pid < 0){
    24ea:	02054263          	bltz	a0,250e <sbrkbugs+0x9e>
  if(pid == 0){
    24ee:	e90d                	bnez	a0,2520 <sbrkbugs+0xb0>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    24f0:	61e020ef          	jal	4b0e <sbrk>
    24f4:	67ad                	lui	a5,0xb
    24f6:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x298>
    24fa:	40a7853b          	subw	a0,a5,a0
    24fe:	610020ef          	jal	4b0e <sbrk>
    sbrk(-10);
    2502:	5559                	li	a0,-10
    2504:	60a020ef          	jal	4b0e <sbrk>
    exit(0);
    2508:	4501                	li	a0,0
    250a:	57c020ef          	jal	4a86 <exit>
    printf("fork failed\n");
    250e:	00005517          	auipc	a0,0x5
    2512:	98a50513          	addi	a0,a0,-1654 # 6e98 <malloc+0x1f3e>
    2516:	191020ef          	jal	4ea6 <printf>
    exit(1);
    251a:	4505                	li	a0,1
    251c:	56a020ef          	jal	4a86 <exit>
  wait(0);
    2520:	4501                	li	a0,0
    2522:	56c020ef          	jal	4a8e <wait>
  exit(0);
    2526:	4501                	li	a0,0
    2528:	55e020ef          	jal	4a86 <exit>

000000000000252c <sbrklast>:
{
    252c:	7179                	addi	sp,sp,-48
    252e:	f406                	sd	ra,40(sp)
    2530:	f022                	sd	s0,32(sp)
    2532:	ec26                	sd	s1,24(sp)
    2534:	e84a                	sd	s2,16(sp)
    2536:	e44e                	sd	s3,8(sp)
    2538:	e052                	sd	s4,0(sp)
    253a:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    253c:	4501                	li	a0,0
    253e:	5d0020ef          	jal	4b0e <sbrk>
  if((top % 4096) != 0)
    2542:	03451793          	slli	a5,a0,0x34
    2546:	ebad                	bnez	a5,25b8 <sbrklast+0x8c>
  sbrk(4096);
    2548:	6505                	lui	a0,0x1
    254a:	5c4020ef          	jal	4b0e <sbrk>
  sbrk(10);
    254e:	4529                	li	a0,10
    2550:	5be020ef          	jal	4b0e <sbrk>
  sbrk(-20);
    2554:	5531                	li	a0,-20
    2556:	5b8020ef          	jal	4b0e <sbrk>
  top = (uint64) sbrk(0);
    255a:	4501                	li	a0,0
    255c:	5b2020ef          	jal	4b0e <sbrk>
    2560:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2562:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x11e>
  p[0] = 'x';
    2566:	07800a13          	li	s4,120
    256a:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    256e:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2572:	20200593          	li	a1,514
    2576:	854a                	mv	a0,s2
    2578:	54e020ef          	jal	4ac6 <open>
    257c:	89aa                	mv	s3,a0
  write(fd, p, 1);
    257e:	4605                	li	a2,1
    2580:	85ca                	mv	a1,s2
    2582:	524020ef          	jal	4aa6 <write>
  close(fd);
    2586:	854e                	mv	a0,s3
    2588:	526020ef          	jal	4aae <close>
  fd = open(p, O_RDWR);
    258c:	4589                	li	a1,2
    258e:	854a                	mv	a0,s2
    2590:	536020ef          	jal	4ac6 <open>
  p[0] = '\0';
    2594:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2598:	4605                	li	a2,1
    259a:	85ca                	mv	a1,s2
    259c:	502020ef          	jal	4a9e <read>
  if(p[0] != 'x')
    25a0:	fc04c783          	lbu	a5,-64(s1)
    25a4:	03479263          	bne	a5,s4,25c8 <sbrklast+0x9c>
}
    25a8:	70a2                	ld	ra,40(sp)
    25aa:	7402                	ld	s0,32(sp)
    25ac:	64e2                	ld	s1,24(sp)
    25ae:	6942                	ld	s2,16(sp)
    25b0:	69a2                	ld	s3,8(sp)
    25b2:	6a02                	ld	s4,0(sp)
    25b4:	6145                	addi	sp,sp,48
    25b6:	8082                	ret
    sbrk(4096 - (top % 4096));
    25b8:	0347d513          	srli	a0,a5,0x34
    25bc:	6785                	lui	a5,0x1
    25be:	40a7853b          	subw	a0,a5,a0
    25c2:	54c020ef          	jal	4b0e <sbrk>
    25c6:	b749                	j	2548 <sbrklast+0x1c>
    exit(1);
    25c8:	4505                	li	a0,1
    25ca:	4bc020ef          	jal	4a86 <exit>

00000000000025ce <sbrk8000>:
{
    25ce:	1141                	addi	sp,sp,-16
    25d0:	e406                	sd	ra,8(sp)
    25d2:	e022                	sd	s0,0(sp)
    25d4:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    25d6:	80000537          	lui	a0,0x80000
    25da:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    25dc:	532020ef          	jal	4b0e <sbrk>
  volatile char *top = sbrk(0);
    25e0:	4501                	li	a0,0
    25e2:	52c020ef          	jal	4b0e <sbrk>
  *(top-1) = *(top-1) + 1;
    25e6:	fff54783          	lbu	a5,-1(a0)
    25ea:	2785                	addiw	a5,a5,1 # 1001 <pgbug+0x29>
    25ec:	0ff7f793          	zext.b	a5,a5
    25f0:	fef50fa3          	sb	a5,-1(a0)
}
    25f4:	60a2                	ld	ra,8(sp)
    25f6:	6402                	ld	s0,0(sp)
    25f8:	0141                	addi	sp,sp,16
    25fa:	8082                	ret

00000000000025fc <execout>:
{
    25fc:	715d                	addi	sp,sp,-80
    25fe:	e486                	sd	ra,72(sp)
    2600:	e0a2                	sd	s0,64(sp)
    2602:	fc26                	sd	s1,56(sp)
    2604:	f84a                	sd	s2,48(sp)
    2606:	f44e                	sd	s3,40(sp)
    2608:	f052                	sd	s4,32(sp)
    260a:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    260c:	4901                	li	s2,0
    260e:	49bd                	li	s3,15
    int pid = fork();
    2610:	46e020ef          	jal	4a7e <fork>
    2614:	84aa                	mv	s1,a0
    if(pid < 0){
    2616:	00054c63          	bltz	a0,262e <execout+0x32>
    } else if(pid == 0){
    261a:	c11d                	beqz	a0,2640 <execout+0x44>
      wait((int*)0);
    261c:	4501                	li	a0,0
    261e:	470020ef          	jal	4a8e <wait>
  for(int avail = 0; avail < 15; avail++){
    2622:	2905                	addiw	s2,s2,1
    2624:	ff3916e3          	bne	s2,s3,2610 <execout+0x14>
  exit(0);
    2628:	4501                	li	a0,0
    262a:	45c020ef          	jal	4a86 <exit>
      printf("fork failed\n");
    262e:	00005517          	auipc	a0,0x5
    2632:	86a50513          	addi	a0,a0,-1942 # 6e98 <malloc+0x1f3e>
    2636:	071020ef          	jal	4ea6 <printf>
      exit(1);
    263a:	4505                	li	a0,1
    263c:	44a020ef          	jal	4a86 <exit>
        if(a == 0xffffffffffffffffLL)
    2640:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    2642:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2644:	6505                	lui	a0,0x1
    2646:	4c8020ef          	jal	4b0e <sbrk>
        if(a == 0xffffffffffffffffLL)
    264a:	01350763          	beq	a0,s3,2658 <execout+0x5c>
        *(char*)(a + 4096 - 1) = 1;
    264e:	6785                	lui	a5,0x1
    2650:	97aa                	add	a5,a5,a0
    2652:	ff478fa3          	sb	s4,-1(a5) # fff <pgbug+0x27>
      while(1){
    2656:	b7fd                	j	2644 <execout+0x48>
      for(int i = 0; i < avail; i++)
    2658:	01205863          	blez	s2,2668 <execout+0x6c>
        sbrk(-4096);
    265c:	757d                	lui	a0,0xfffff
    265e:	4b0020ef          	jal	4b0e <sbrk>
      for(int i = 0; i < avail; i++)
    2662:	2485                	addiw	s1,s1,1
    2664:	ff249ce3          	bne	s1,s2,265c <execout+0x60>
      close(1);
    2668:	4505                	li	a0,1
    266a:	444020ef          	jal	4aae <close>
      char *args[] = { "echo", "x", 0 };
    266e:	00003517          	auipc	a0,0x3
    2672:	a2a50513          	addi	a0,a0,-1494 # 5098 <malloc+0x13e>
    2676:	faa43c23          	sd	a0,-72(s0)
    267a:	00003797          	auipc	a5,0x3
    267e:	a8e78793          	addi	a5,a5,-1394 # 5108 <malloc+0x1ae>
    2682:	fcf43023          	sd	a5,-64(s0)
    2686:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    268a:	fb840593          	addi	a1,s0,-72
    268e:	430020ef          	jal	4abe <exec>
      exit(0);
    2692:	4501                	li	a0,0
    2694:	3f2020ef          	jal	4a86 <exit>

0000000000002698 <fourteen>:
{
    2698:	1101                	addi	sp,sp,-32
    269a:	ec06                	sd	ra,24(sp)
    269c:	e822                	sd	s0,16(sp)
    269e:	e426                	sd	s1,8(sp)
    26a0:	1000                	addi	s0,sp,32
    26a2:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    26a4:	00004517          	auipc	a0,0x4
    26a8:	a8c50513          	addi	a0,a0,-1396 # 6130 <malloc+0x11d6>
    26ac:	442020ef          	jal	4aee <mkdir>
    26b0:	e555                	bnez	a0,275c <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    26b2:	00004517          	auipc	a0,0x4
    26b6:	8d650513          	addi	a0,a0,-1834 # 5f88 <malloc+0x102e>
    26ba:	434020ef          	jal	4aee <mkdir>
    26be:	e94d                	bnez	a0,2770 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    26c0:	20000593          	li	a1,512
    26c4:	00004517          	auipc	a0,0x4
    26c8:	91c50513          	addi	a0,a0,-1764 # 5fe0 <malloc+0x1086>
    26cc:	3fa020ef          	jal	4ac6 <open>
  if(fd < 0){
    26d0:	0a054a63          	bltz	a0,2784 <fourteen+0xec>
  close(fd);
    26d4:	3da020ef          	jal	4aae <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    26d8:	4581                	li	a1,0
    26da:	00004517          	auipc	a0,0x4
    26de:	97e50513          	addi	a0,a0,-1666 # 6058 <malloc+0x10fe>
    26e2:	3e4020ef          	jal	4ac6 <open>
  if(fd < 0){
    26e6:	0a054963          	bltz	a0,2798 <fourteen+0x100>
  close(fd);
    26ea:	3c4020ef          	jal	4aae <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    26ee:	00004517          	auipc	a0,0x4
    26f2:	9da50513          	addi	a0,a0,-1574 # 60c8 <malloc+0x116e>
    26f6:	3f8020ef          	jal	4aee <mkdir>
    26fa:	c94d                	beqz	a0,27ac <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    26fc:	00004517          	auipc	a0,0x4
    2700:	a2450513          	addi	a0,a0,-1500 # 6120 <malloc+0x11c6>
    2704:	3ea020ef          	jal	4aee <mkdir>
    2708:	cd45                	beqz	a0,27c0 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    270a:	00004517          	auipc	a0,0x4
    270e:	a1650513          	addi	a0,a0,-1514 # 6120 <malloc+0x11c6>
    2712:	3c4020ef          	jal	4ad6 <unlink>
  unlink("12345678901234/12345678901234");
    2716:	00004517          	auipc	a0,0x4
    271a:	9b250513          	addi	a0,a0,-1614 # 60c8 <malloc+0x116e>
    271e:	3b8020ef          	jal	4ad6 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2722:	00004517          	auipc	a0,0x4
    2726:	93650513          	addi	a0,a0,-1738 # 6058 <malloc+0x10fe>
    272a:	3ac020ef          	jal	4ad6 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    272e:	00004517          	auipc	a0,0x4
    2732:	8b250513          	addi	a0,a0,-1870 # 5fe0 <malloc+0x1086>
    2736:	3a0020ef          	jal	4ad6 <unlink>
  unlink("12345678901234/123456789012345");
    273a:	00004517          	auipc	a0,0x4
    273e:	84e50513          	addi	a0,a0,-1970 # 5f88 <malloc+0x102e>
    2742:	394020ef          	jal	4ad6 <unlink>
  unlink("12345678901234");
    2746:	00004517          	auipc	a0,0x4
    274a:	9ea50513          	addi	a0,a0,-1558 # 6130 <malloc+0x11d6>
    274e:	388020ef          	jal	4ad6 <unlink>
}
    2752:	60e2                	ld	ra,24(sp)
    2754:	6442                	ld	s0,16(sp)
    2756:	64a2                	ld	s1,8(sp)
    2758:	6105                	addi	sp,sp,32
    275a:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    275c:	85a6                	mv	a1,s1
    275e:	00004517          	auipc	a0,0x4
    2762:	80250513          	addi	a0,a0,-2046 # 5f60 <malloc+0x1006>
    2766:	740020ef          	jal	4ea6 <printf>
    exit(1);
    276a:	4505                	li	a0,1
    276c:	31a020ef          	jal	4a86 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2770:	85a6                	mv	a1,s1
    2772:	00004517          	auipc	a0,0x4
    2776:	83650513          	addi	a0,a0,-1994 # 5fa8 <malloc+0x104e>
    277a:	72c020ef          	jal	4ea6 <printf>
    exit(1);
    277e:	4505                	li	a0,1
    2780:	306020ef          	jal	4a86 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2784:	85a6                	mv	a1,s1
    2786:	00004517          	auipc	a0,0x4
    278a:	88a50513          	addi	a0,a0,-1910 # 6010 <malloc+0x10b6>
    278e:	718020ef          	jal	4ea6 <printf>
    exit(1);
    2792:	4505                	li	a0,1
    2794:	2f2020ef          	jal	4a86 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2798:	85a6                	mv	a1,s1
    279a:	00004517          	auipc	a0,0x4
    279e:	8ee50513          	addi	a0,a0,-1810 # 6088 <malloc+0x112e>
    27a2:	704020ef          	jal	4ea6 <printf>
    exit(1);
    27a6:	4505                	li	a0,1
    27a8:	2de020ef          	jal	4a86 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    27ac:	85a6                	mv	a1,s1
    27ae:	00004517          	auipc	a0,0x4
    27b2:	93a50513          	addi	a0,a0,-1734 # 60e8 <malloc+0x118e>
    27b6:	6f0020ef          	jal	4ea6 <printf>
    exit(1);
    27ba:	4505                	li	a0,1
    27bc:	2ca020ef          	jal	4a86 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    27c0:	85a6                	mv	a1,s1
    27c2:	00004517          	auipc	a0,0x4
    27c6:	97e50513          	addi	a0,a0,-1666 # 6140 <malloc+0x11e6>
    27ca:	6dc020ef          	jal	4ea6 <printf>
    exit(1);
    27ce:	4505                	li	a0,1
    27d0:	2b6020ef          	jal	4a86 <exit>

00000000000027d4 <diskfull>:
{
    27d4:	b8010113          	addi	sp,sp,-1152
    27d8:	46113c23          	sd	ra,1144(sp)
    27dc:	46813823          	sd	s0,1136(sp)
    27e0:	46913423          	sd	s1,1128(sp)
    27e4:	47213023          	sd	s2,1120(sp)
    27e8:	45313c23          	sd	s3,1112(sp)
    27ec:	45413823          	sd	s4,1104(sp)
    27f0:	45513423          	sd	s5,1096(sp)
    27f4:	45613023          	sd	s6,1088(sp)
    27f8:	43713c23          	sd	s7,1080(sp)
    27fc:	43813823          	sd	s8,1072(sp)
    2800:	43913423          	sd	s9,1064(sp)
    2804:	48010413          	addi	s0,sp,1152
    2808:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    280a:	00004517          	auipc	a0,0x4
    280e:	96e50513          	addi	a0,a0,-1682 # 6178 <malloc+0x121e>
    2812:	2c4020ef          	jal	4ad6 <unlink>
    2816:	03000993          	li	s3,48
    name[0] = 'b';
    281a:	06200b93          	li	s7,98
    name[1] = 'i';
    281e:	06900b13          	li	s6,105
    name[2] = 'g';
    2822:	06700a93          	li	s5,103
    2826:	6a41                	lui	s4,0x10
    2828:	10ba0a13          	addi	s4,s4,267 # 1010b <base+0x493>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    282c:	07f00c13          	li	s8,127
    2830:	aab9                	j	298e <diskfull+0x1ba>
      printf("%s: could not create file %s\n", s, name);
    2832:	b8040613          	addi	a2,s0,-1152
    2836:	85e6                	mv	a1,s9
    2838:	00004517          	auipc	a0,0x4
    283c:	95050513          	addi	a0,a0,-1712 # 6188 <malloc+0x122e>
    2840:	666020ef          	jal	4ea6 <printf>
      break;
    2844:	a039                	j	2852 <diskfull+0x7e>
        close(fd);
    2846:	854a                	mv	a0,s2
    2848:	266020ef          	jal	4aae <close>
    close(fd);
    284c:	854a                	mv	a0,s2
    284e:	260020ef          	jal	4aae <close>
  for(int i = 0; i < nzz; i++){
    2852:	4481                	li	s1,0
    name[0] = 'z';
    2854:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    2858:	08000993          	li	s3,128
    name[0] = 'z';
    285c:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    2860:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    2864:	41f4d71b          	sraiw	a4,s1,0x1f
    2868:	01b7571b          	srliw	a4,a4,0x1b
    286c:	009707bb          	addw	a5,a4,s1
    2870:	4057d69b          	sraiw	a3,a5,0x5
    2874:	0306869b          	addiw	a3,a3,48
    2878:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    287c:	8bfd                	andi	a5,a5,31
    287e:	9f99                	subw	a5,a5,a4
    2880:	0307879b          	addiw	a5,a5,48
    2884:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    2888:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    288c:	ba040513          	addi	a0,s0,-1120
    2890:	246020ef          	jal	4ad6 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2894:	60200593          	li	a1,1538
    2898:	ba040513          	addi	a0,s0,-1120
    289c:	22a020ef          	jal	4ac6 <open>
    if(fd < 0)
    28a0:	00054763          	bltz	a0,28ae <diskfull+0xda>
    close(fd);
    28a4:	20a020ef          	jal	4aae <close>
  for(int i = 0; i < nzz; i++){
    28a8:	2485                	addiw	s1,s1,1
    28aa:	fb3499e3          	bne	s1,s3,285c <diskfull+0x88>
  if(mkdir("diskfulldir") == 0)
    28ae:	00004517          	auipc	a0,0x4
    28b2:	8ca50513          	addi	a0,a0,-1846 # 6178 <malloc+0x121e>
    28b6:	238020ef          	jal	4aee <mkdir>
    28ba:	12050063          	beqz	a0,29da <diskfull+0x206>
  unlink("diskfulldir");
    28be:	00004517          	auipc	a0,0x4
    28c2:	8ba50513          	addi	a0,a0,-1862 # 6178 <malloc+0x121e>
    28c6:	210020ef          	jal	4ad6 <unlink>
  for(int i = 0; i < nzz; i++){
    28ca:	4481                	li	s1,0
    name[0] = 'z';
    28cc:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    28d0:	08000993          	li	s3,128
    name[0] = 'z';
    28d4:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    28d8:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    28dc:	41f4d71b          	sraiw	a4,s1,0x1f
    28e0:	01b7571b          	srliw	a4,a4,0x1b
    28e4:	009707bb          	addw	a5,a4,s1
    28e8:	4057d69b          	sraiw	a3,a5,0x5
    28ec:	0306869b          	addiw	a3,a3,48
    28f0:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    28f4:	8bfd                	andi	a5,a5,31
    28f6:	9f99                	subw	a5,a5,a4
    28f8:	0307879b          	addiw	a5,a5,48
    28fc:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    2900:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2904:	ba040513          	addi	a0,s0,-1120
    2908:	1ce020ef          	jal	4ad6 <unlink>
  for(int i = 0; i < nzz; i++){
    290c:	2485                	addiw	s1,s1,1
    290e:	fd3493e3          	bne	s1,s3,28d4 <diskfull+0x100>
    2912:	03000493          	li	s1,48
    name[0] = 'b';
    2916:	06200a93          	li	s5,98
    name[1] = 'i';
    291a:	06900a13          	li	s4,105
    name[2] = 'g';
    291e:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    2922:	07f00913          	li	s2,127
    name[0] = 'b';
    2926:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    292a:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    292e:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    2932:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    2936:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    293a:	ba040513          	addi	a0,s0,-1120
    293e:	198020ef          	jal	4ad6 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    2942:	2485                	addiw	s1,s1,1
    2944:	0ff4f493          	zext.b	s1,s1
    2948:	fd249fe3          	bne	s1,s2,2926 <diskfull+0x152>
}
    294c:	47813083          	ld	ra,1144(sp)
    2950:	47013403          	ld	s0,1136(sp)
    2954:	46813483          	ld	s1,1128(sp)
    2958:	46013903          	ld	s2,1120(sp)
    295c:	45813983          	ld	s3,1112(sp)
    2960:	45013a03          	ld	s4,1104(sp)
    2964:	44813a83          	ld	s5,1096(sp)
    2968:	44013b03          	ld	s6,1088(sp)
    296c:	43813b83          	ld	s7,1080(sp)
    2970:	43013c03          	ld	s8,1072(sp)
    2974:	42813c83          	ld	s9,1064(sp)
    2978:	48010113          	addi	sp,sp,1152
    297c:	8082                	ret
    close(fd);
    297e:	854a                	mv	a0,s2
    2980:	12e020ef          	jal	4aae <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2984:	2985                	addiw	s3,s3,1
    2986:	0ff9f993          	zext.b	s3,s3
    298a:	ed8984e3          	beq	s3,s8,2852 <diskfull+0x7e>
    name[0] = 'b';
    298e:	b9740023          	sb	s7,-1152(s0)
    name[1] = 'i';
    2992:	b96400a3          	sb	s6,-1151(s0)
    name[2] = 'g';
    2996:	b9540123          	sb	s5,-1150(s0)
    name[3] = '0' + fi;
    299a:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    299e:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    29a2:	b8040513          	addi	a0,s0,-1152
    29a6:	130020ef          	jal	4ad6 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    29aa:	60200593          	li	a1,1538
    29ae:	b8040513          	addi	a0,s0,-1152
    29b2:	114020ef          	jal	4ac6 <open>
    29b6:	892a                	mv	s2,a0
    if(fd < 0){
    29b8:	e6054de3          	bltz	a0,2832 <diskfull+0x5e>
    29bc:	84d2                	mv	s1,s4
      if(write(fd, buf, BSIZE) != BSIZE){
    29be:	40000613          	li	a2,1024
    29c2:	ba040593          	addi	a1,s0,-1120
    29c6:	854a                	mv	a0,s2
    29c8:	0de020ef          	jal	4aa6 <write>
    29cc:	40000793          	li	a5,1024
    29d0:	e6f51be3          	bne	a0,a5,2846 <diskfull+0x72>
    for(int i = 0; i < MAXFILE; i++){
    29d4:	34fd                	addiw	s1,s1,-1
    29d6:	f4e5                	bnez	s1,29be <diskfull+0x1ea>
    29d8:	b75d                	j	297e <diskfull+0x1aa>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    29da:	85e6                	mv	a1,s9
    29dc:	00003517          	auipc	a0,0x3
    29e0:	7cc50513          	addi	a0,a0,1996 # 61a8 <malloc+0x124e>
    29e4:	4c2020ef          	jal	4ea6 <printf>
    29e8:	bdd9                	j	28be <diskfull+0xea>

00000000000029ea <iputtest>:
{
    29ea:	1101                	addi	sp,sp,-32
    29ec:	ec06                	sd	ra,24(sp)
    29ee:	e822                	sd	s0,16(sp)
    29f0:	e426                	sd	s1,8(sp)
    29f2:	1000                	addi	s0,sp,32
    29f4:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    29f6:	00003517          	auipc	a0,0x3
    29fa:	7e250513          	addi	a0,a0,2018 # 61d8 <malloc+0x127e>
    29fe:	0f0020ef          	jal	4aee <mkdir>
    2a02:	02054f63          	bltz	a0,2a40 <iputtest+0x56>
  if(chdir("iputdir") < 0){
    2a06:	00003517          	auipc	a0,0x3
    2a0a:	7d250513          	addi	a0,a0,2002 # 61d8 <malloc+0x127e>
    2a0e:	0e8020ef          	jal	4af6 <chdir>
    2a12:	04054163          	bltz	a0,2a54 <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    2a16:	00004517          	auipc	a0,0x4
    2a1a:	80250513          	addi	a0,a0,-2046 # 6218 <malloc+0x12be>
    2a1e:	0b8020ef          	jal	4ad6 <unlink>
    2a22:	04054363          	bltz	a0,2a68 <iputtest+0x7e>
  if(chdir("/") < 0){
    2a26:	00004517          	auipc	a0,0x4
    2a2a:	82250513          	addi	a0,a0,-2014 # 6248 <malloc+0x12ee>
    2a2e:	0c8020ef          	jal	4af6 <chdir>
    2a32:	04054563          	bltz	a0,2a7c <iputtest+0x92>
}
    2a36:	60e2                	ld	ra,24(sp)
    2a38:	6442                	ld	s0,16(sp)
    2a3a:	64a2                	ld	s1,8(sp)
    2a3c:	6105                	addi	sp,sp,32
    2a3e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2a40:	85a6                	mv	a1,s1
    2a42:	00003517          	auipc	a0,0x3
    2a46:	79e50513          	addi	a0,a0,1950 # 61e0 <malloc+0x1286>
    2a4a:	45c020ef          	jal	4ea6 <printf>
    exit(1);
    2a4e:	4505                	li	a0,1
    2a50:	036020ef          	jal	4a86 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2a54:	85a6                	mv	a1,s1
    2a56:	00003517          	auipc	a0,0x3
    2a5a:	7a250513          	addi	a0,a0,1954 # 61f8 <malloc+0x129e>
    2a5e:	448020ef          	jal	4ea6 <printf>
    exit(1);
    2a62:	4505                	li	a0,1
    2a64:	022020ef          	jal	4a86 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a68:	85a6                	mv	a1,s1
    2a6a:	00003517          	auipc	a0,0x3
    2a6e:	7be50513          	addi	a0,a0,1982 # 6228 <malloc+0x12ce>
    2a72:	434020ef          	jal	4ea6 <printf>
    exit(1);
    2a76:	4505                	li	a0,1
    2a78:	00e020ef          	jal	4a86 <exit>
    printf("%s: chdir / failed\n", s);
    2a7c:	85a6                	mv	a1,s1
    2a7e:	00003517          	auipc	a0,0x3
    2a82:	7d250513          	addi	a0,a0,2002 # 6250 <malloc+0x12f6>
    2a86:	420020ef          	jal	4ea6 <printf>
    exit(1);
    2a8a:	4505                	li	a0,1
    2a8c:	7fb010ef          	jal	4a86 <exit>

0000000000002a90 <exitiputtest>:
{
    2a90:	7179                	addi	sp,sp,-48
    2a92:	f406                	sd	ra,40(sp)
    2a94:	f022                	sd	s0,32(sp)
    2a96:	ec26                	sd	s1,24(sp)
    2a98:	1800                	addi	s0,sp,48
    2a9a:	84aa                	mv	s1,a0
  pid = fork();
    2a9c:	7e3010ef          	jal	4a7e <fork>
  if(pid < 0){
    2aa0:	02054e63          	bltz	a0,2adc <exitiputtest+0x4c>
  if(pid == 0){
    2aa4:	e541                	bnez	a0,2b2c <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2aa6:	00003517          	auipc	a0,0x3
    2aaa:	73250513          	addi	a0,a0,1842 # 61d8 <malloc+0x127e>
    2aae:	040020ef          	jal	4aee <mkdir>
    2ab2:	02054f63          	bltz	a0,2af0 <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2ab6:	00003517          	auipc	a0,0x3
    2aba:	72250513          	addi	a0,a0,1826 # 61d8 <malloc+0x127e>
    2abe:	038020ef          	jal	4af6 <chdir>
    2ac2:	04054163          	bltz	a0,2b04 <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2ac6:	00003517          	auipc	a0,0x3
    2aca:	75250513          	addi	a0,a0,1874 # 6218 <malloc+0x12be>
    2ace:	008020ef          	jal	4ad6 <unlink>
    2ad2:	04054363          	bltz	a0,2b18 <exitiputtest+0x88>
    exit(0);
    2ad6:	4501                	li	a0,0
    2ad8:	7af010ef          	jal	4a86 <exit>
    printf("%s: fork failed\n", s);
    2adc:	85a6                	mv	a1,s1
    2ade:	00003517          	auipc	a0,0x3
    2ae2:	e4a50513          	addi	a0,a0,-438 # 5928 <malloc+0x9ce>
    2ae6:	3c0020ef          	jal	4ea6 <printf>
    exit(1);
    2aea:	4505                	li	a0,1
    2aec:	79b010ef          	jal	4a86 <exit>
      printf("%s: mkdir failed\n", s);
    2af0:	85a6                	mv	a1,s1
    2af2:	00003517          	auipc	a0,0x3
    2af6:	6ee50513          	addi	a0,a0,1774 # 61e0 <malloc+0x1286>
    2afa:	3ac020ef          	jal	4ea6 <printf>
      exit(1);
    2afe:	4505                	li	a0,1
    2b00:	787010ef          	jal	4a86 <exit>
      printf("%s: child chdir failed\n", s);
    2b04:	85a6                	mv	a1,s1
    2b06:	00003517          	auipc	a0,0x3
    2b0a:	76250513          	addi	a0,a0,1890 # 6268 <malloc+0x130e>
    2b0e:	398020ef          	jal	4ea6 <printf>
      exit(1);
    2b12:	4505                	li	a0,1
    2b14:	773010ef          	jal	4a86 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2b18:	85a6                	mv	a1,s1
    2b1a:	00003517          	auipc	a0,0x3
    2b1e:	70e50513          	addi	a0,a0,1806 # 6228 <malloc+0x12ce>
    2b22:	384020ef          	jal	4ea6 <printf>
      exit(1);
    2b26:	4505                	li	a0,1
    2b28:	75f010ef          	jal	4a86 <exit>
  wait(&xstatus);
    2b2c:	fdc40513          	addi	a0,s0,-36
    2b30:	75f010ef          	jal	4a8e <wait>
  exit(xstatus);
    2b34:	fdc42503          	lw	a0,-36(s0)
    2b38:	74f010ef          	jal	4a86 <exit>

0000000000002b3c <dirtest>:
{
    2b3c:	1101                	addi	sp,sp,-32
    2b3e:	ec06                	sd	ra,24(sp)
    2b40:	e822                	sd	s0,16(sp)
    2b42:	e426                	sd	s1,8(sp)
    2b44:	1000                	addi	s0,sp,32
    2b46:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2b48:	00003517          	auipc	a0,0x3
    2b4c:	73850513          	addi	a0,a0,1848 # 6280 <malloc+0x1326>
    2b50:	79f010ef          	jal	4aee <mkdir>
    2b54:	02054f63          	bltz	a0,2b92 <dirtest+0x56>
  if(chdir("dir0") < 0){
    2b58:	00003517          	auipc	a0,0x3
    2b5c:	72850513          	addi	a0,a0,1832 # 6280 <malloc+0x1326>
    2b60:	797010ef          	jal	4af6 <chdir>
    2b64:	04054163          	bltz	a0,2ba6 <dirtest+0x6a>
  if(chdir("..") < 0){
    2b68:	00003517          	auipc	a0,0x3
    2b6c:	73850513          	addi	a0,a0,1848 # 62a0 <malloc+0x1346>
    2b70:	787010ef          	jal	4af6 <chdir>
    2b74:	04054363          	bltz	a0,2bba <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2b78:	00003517          	auipc	a0,0x3
    2b7c:	70850513          	addi	a0,a0,1800 # 6280 <malloc+0x1326>
    2b80:	757010ef          	jal	4ad6 <unlink>
    2b84:	04054563          	bltz	a0,2bce <dirtest+0x92>
}
    2b88:	60e2                	ld	ra,24(sp)
    2b8a:	6442                	ld	s0,16(sp)
    2b8c:	64a2                	ld	s1,8(sp)
    2b8e:	6105                	addi	sp,sp,32
    2b90:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b92:	85a6                	mv	a1,s1
    2b94:	00003517          	auipc	a0,0x3
    2b98:	64c50513          	addi	a0,a0,1612 # 61e0 <malloc+0x1286>
    2b9c:	30a020ef          	jal	4ea6 <printf>
    exit(1);
    2ba0:	4505                	li	a0,1
    2ba2:	6e5010ef          	jal	4a86 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2ba6:	85a6                	mv	a1,s1
    2ba8:	00003517          	auipc	a0,0x3
    2bac:	6e050513          	addi	a0,a0,1760 # 6288 <malloc+0x132e>
    2bb0:	2f6020ef          	jal	4ea6 <printf>
    exit(1);
    2bb4:	4505                	li	a0,1
    2bb6:	6d1010ef          	jal	4a86 <exit>
    printf("%s: chdir .. failed\n", s);
    2bba:	85a6                	mv	a1,s1
    2bbc:	00003517          	auipc	a0,0x3
    2bc0:	6ec50513          	addi	a0,a0,1772 # 62a8 <malloc+0x134e>
    2bc4:	2e2020ef          	jal	4ea6 <printf>
    exit(1);
    2bc8:	4505                	li	a0,1
    2bca:	6bd010ef          	jal	4a86 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2bce:	85a6                	mv	a1,s1
    2bd0:	00003517          	auipc	a0,0x3
    2bd4:	6f050513          	addi	a0,a0,1776 # 62c0 <malloc+0x1366>
    2bd8:	2ce020ef          	jal	4ea6 <printf>
    exit(1);
    2bdc:	4505                	li	a0,1
    2bde:	6a9010ef          	jal	4a86 <exit>

0000000000002be2 <subdir>:
{
    2be2:	1101                	addi	sp,sp,-32
    2be4:	ec06                	sd	ra,24(sp)
    2be6:	e822                	sd	s0,16(sp)
    2be8:	e426                	sd	s1,8(sp)
    2bea:	e04a                	sd	s2,0(sp)
    2bec:	1000                	addi	s0,sp,32
    2bee:	892a                	mv	s2,a0
  unlink("ff");
    2bf0:	00004517          	auipc	a0,0x4
    2bf4:	81850513          	addi	a0,a0,-2024 # 6408 <malloc+0x14ae>
    2bf8:	6df010ef          	jal	4ad6 <unlink>
  if(mkdir("dd") != 0){
    2bfc:	00003517          	auipc	a0,0x3
    2c00:	6dc50513          	addi	a0,a0,1756 # 62d8 <malloc+0x137e>
    2c04:	6eb010ef          	jal	4aee <mkdir>
    2c08:	2e051263          	bnez	a0,2eec <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2c0c:	20200593          	li	a1,514
    2c10:	00003517          	auipc	a0,0x3
    2c14:	6e850513          	addi	a0,a0,1768 # 62f8 <malloc+0x139e>
    2c18:	6af010ef          	jal	4ac6 <open>
    2c1c:	84aa                	mv	s1,a0
  if(fd < 0){
    2c1e:	2e054163          	bltz	a0,2f00 <subdir+0x31e>
  write(fd, "ff", 2);
    2c22:	4609                	li	a2,2
    2c24:	00003597          	auipc	a1,0x3
    2c28:	7e458593          	addi	a1,a1,2020 # 6408 <malloc+0x14ae>
    2c2c:	67b010ef          	jal	4aa6 <write>
  close(fd);
    2c30:	8526                	mv	a0,s1
    2c32:	67d010ef          	jal	4aae <close>
  if(unlink("dd") >= 0){
    2c36:	00003517          	auipc	a0,0x3
    2c3a:	6a250513          	addi	a0,a0,1698 # 62d8 <malloc+0x137e>
    2c3e:	699010ef          	jal	4ad6 <unlink>
    2c42:	2c055963          	bgez	a0,2f14 <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2c46:	00003517          	auipc	a0,0x3
    2c4a:	70a50513          	addi	a0,a0,1802 # 6350 <malloc+0x13f6>
    2c4e:	6a1010ef          	jal	4aee <mkdir>
    2c52:	2c051b63          	bnez	a0,2f28 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2c56:	20200593          	li	a1,514
    2c5a:	00003517          	auipc	a0,0x3
    2c5e:	71e50513          	addi	a0,a0,1822 # 6378 <malloc+0x141e>
    2c62:	665010ef          	jal	4ac6 <open>
    2c66:	84aa                	mv	s1,a0
  if(fd < 0){
    2c68:	2c054a63          	bltz	a0,2f3c <subdir+0x35a>
  write(fd, "FF", 2);
    2c6c:	4609                	li	a2,2
    2c6e:	00003597          	auipc	a1,0x3
    2c72:	73a58593          	addi	a1,a1,1850 # 63a8 <malloc+0x144e>
    2c76:	631010ef          	jal	4aa6 <write>
  close(fd);
    2c7a:	8526                	mv	a0,s1
    2c7c:	633010ef          	jal	4aae <close>
  fd = open("dd/dd/../ff", 0);
    2c80:	4581                	li	a1,0
    2c82:	00003517          	auipc	a0,0x3
    2c86:	72e50513          	addi	a0,a0,1838 # 63b0 <malloc+0x1456>
    2c8a:	63d010ef          	jal	4ac6 <open>
    2c8e:	84aa                	mv	s1,a0
  if(fd < 0){
    2c90:	2c054063          	bltz	a0,2f50 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c94:	660d                	lui	a2,0x3
    2c96:	0000a597          	auipc	a1,0xa
    2c9a:	fe258593          	addi	a1,a1,-30 # cc78 <buf>
    2c9e:	601010ef          	jal	4a9e <read>
  if(cc != 2 || buf[0] != 'f'){
    2ca2:	4789                	li	a5,2
    2ca4:	2cf51063          	bne	a0,a5,2f64 <subdir+0x382>
    2ca8:	0000a717          	auipc	a4,0xa
    2cac:	fd074703          	lbu	a4,-48(a4) # cc78 <buf>
    2cb0:	06600793          	li	a5,102
    2cb4:	2af71863          	bne	a4,a5,2f64 <subdir+0x382>
  close(fd);
    2cb8:	8526                	mv	a0,s1
    2cba:	5f5010ef          	jal	4aae <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2cbe:	00003597          	auipc	a1,0x3
    2cc2:	74258593          	addi	a1,a1,1858 # 6400 <malloc+0x14a6>
    2cc6:	00003517          	auipc	a0,0x3
    2cca:	6b250513          	addi	a0,a0,1714 # 6378 <malloc+0x141e>
    2cce:	619010ef          	jal	4ae6 <link>
    2cd2:	2a051363          	bnez	a0,2f78 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2cd6:	00003517          	auipc	a0,0x3
    2cda:	6a250513          	addi	a0,a0,1698 # 6378 <malloc+0x141e>
    2cde:	5f9010ef          	jal	4ad6 <unlink>
    2ce2:	2a051563          	bnez	a0,2f8c <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2ce6:	4581                	li	a1,0
    2ce8:	00003517          	auipc	a0,0x3
    2cec:	69050513          	addi	a0,a0,1680 # 6378 <malloc+0x141e>
    2cf0:	5d7010ef          	jal	4ac6 <open>
    2cf4:	2a055663          	bgez	a0,2fa0 <subdir+0x3be>
  if(chdir("dd") != 0){
    2cf8:	00003517          	auipc	a0,0x3
    2cfc:	5e050513          	addi	a0,a0,1504 # 62d8 <malloc+0x137e>
    2d00:	5f7010ef          	jal	4af6 <chdir>
    2d04:	2a051863          	bnez	a0,2fb4 <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2d08:	00003517          	auipc	a0,0x3
    2d0c:	79050513          	addi	a0,a0,1936 # 6498 <malloc+0x153e>
    2d10:	5e7010ef          	jal	4af6 <chdir>
    2d14:	2a051a63          	bnez	a0,2fc8 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2d18:	00003517          	auipc	a0,0x3
    2d1c:	7b050513          	addi	a0,a0,1968 # 64c8 <malloc+0x156e>
    2d20:	5d7010ef          	jal	4af6 <chdir>
    2d24:	2a051c63          	bnez	a0,2fdc <subdir+0x3fa>
  if(chdir("./..") != 0){
    2d28:	00003517          	auipc	a0,0x3
    2d2c:	7d850513          	addi	a0,a0,2008 # 6500 <malloc+0x15a6>
    2d30:	5c7010ef          	jal	4af6 <chdir>
    2d34:	2a051e63          	bnez	a0,2ff0 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2d38:	4581                	li	a1,0
    2d3a:	00003517          	auipc	a0,0x3
    2d3e:	6c650513          	addi	a0,a0,1734 # 6400 <malloc+0x14a6>
    2d42:	585010ef          	jal	4ac6 <open>
    2d46:	84aa                	mv	s1,a0
  if(fd < 0){
    2d48:	2a054e63          	bltz	a0,3004 <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2d4c:	660d                	lui	a2,0x3
    2d4e:	0000a597          	auipc	a1,0xa
    2d52:	f2a58593          	addi	a1,a1,-214 # cc78 <buf>
    2d56:	549010ef          	jal	4a9e <read>
    2d5a:	4789                	li	a5,2
    2d5c:	2af51e63          	bne	a0,a5,3018 <subdir+0x436>
  close(fd);
    2d60:	8526                	mv	a0,s1
    2d62:	54d010ef          	jal	4aae <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d66:	4581                	li	a1,0
    2d68:	00003517          	auipc	a0,0x3
    2d6c:	61050513          	addi	a0,a0,1552 # 6378 <malloc+0x141e>
    2d70:	557010ef          	jal	4ac6 <open>
    2d74:	2a055c63          	bgez	a0,302c <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2d78:	20200593          	li	a1,514
    2d7c:	00004517          	auipc	a0,0x4
    2d80:	81450513          	addi	a0,a0,-2028 # 6590 <malloc+0x1636>
    2d84:	543010ef          	jal	4ac6 <open>
    2d88:	2a055c63          	bgez	a0,3040 <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2d8c:	20200593          	li	a1,514
    2d90:	00004517          	auipc	a0,0x4
    2d94:	83050513          	addi	a0,a0,-2000 # 65c0 <malloc+0x1666>
    2d98:	52f010ef          	jal	4ac6 <open>
    2d9c:	2a055c63          	bgez	a0,3054 <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2da0:	20000593          	li	a1,512
    2da4:	00003517          	auipc	a0,0x3
    2da8:	53450513          	addi	a0,a0,1332 # 62d8 <malloc+0x137e>
    2dac:	51b010ef          	jal	4ac6 <open>
    2db0:	2a055c63          	bgez	a0,3068 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2db4:	4589                	li	a1,2
    2db6:	00003517          	auipc	a0,0x3
    2dba:	52250513          	addi	a0,a0,1314 # 62d8 <malloc+0x137e>
    2dbe:	509010ef          	jal	4ac6 <open>
    2dc2:	2a055d63          	bgez	a0,307c <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2dc6:	4585                	li	a1,1
    2dc8:	00003517          	auipc	a0,0x3
    2dcc:	51050513          	addi	a0,a0,1296 # 62d8 <malloc+0x137e>
    2dd0:	4f7010ef          	jal	4ac6 <open>
    2dd4:	2a055e63          	bgez	a0,3090 <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2dd8:	00004597          	auipc	a1,0x4
    2ddc:	87858593          	addi	a1,a1,-1928 # 6650 <malloc+0x16f6>
    2de0:	00003517          	auipc	a0,0x3
    2de4:	7b050513          	addi	a0,a0,1968 # 6590 <malloc+0x1636>
    2de8:	4ff010ef          	jal	4ae6 <link>
    2dec:	2a050c63          	beqz	a0,30a4 <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2df0:	00004597          	auipc	a1,0x4
    2df4:	86058593          	addi	a1,a1,-1952 # 6650 <malloc+0x16f6>
    2df8:	00003517          	auipc	a0,0x3
    2dfc:	7c850513          	addi	a0,a0,1992 # 65c0 <malloc+0x1666>
    2e00:	4e7010ef          	jal	4ae6 <link>
    2e04:	2a050a63          	beqz	a0,30b8 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2e08:	00003597          	auipc	a1,0x3
    2e0c:	5f858593          	addi	a1,a1,1528 # 6400 <malloc+0x14a6>
    2e10:	00003517          	auipc	a0,0x3
    2e14:	4e850513          	addi	a0,a0,1256 # 62f8 <malloc+0x139e>
    2e18:	4cf010ef          	jal	4ae6 <link>
    2e1c:	2a050863          	beqz	a0,30cc <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2e20:	00003517          	auipc	a0,0x3
    2e24:	77050513          	addi	a0,a0,1904 # 6590 <malloc+0x1636>
    2e28:	4c7010ef          	jal	4aee <mkdir>
    2e2c:	2a050a63          	beqz	a0,30e0 <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2e30:	00003517          	auipc	a0,0x3
    2e34:	79050513          	addi	a0,a0,1936 # 65c0 <malloc+0x1666>
    2e38:	4b7010ef          	jal	4aee <mkdir>
    2e3c:	2a050c63          	beqz	a0,30f4 <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2e40:	00003517          	auipc	a0,0x3
    2e44:	5c050513          	addi	a0,a0,1472 # 6400 <malloc+0x14a6>
    2e48:	4a7010ef          	jal	4aee <mkdir>
    2e4c:	2a050e63          	beqz	a0,3108 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2e50:	00003517          	auipc	a0,0x3
    2e54:	77050513          	addi	a0,a0,1904 # 65c0 <malloc+0x1666>
    2e58:	47f010ef          	jal	4ad6 <unlink>
    2e5c:	2c050063          	beqz	a0,311c <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2e60:	00003517          	auipc	a0,0x3
    2e64:	73050513          	addi	a0,a0,1840 # 6590 <malloc+0x1636>
    2e68:	46f010ef          	jal	4ad6 <unlink>
    2e6c:	2c050263          	beqz	a0,3130 <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2e70:	00003517          	auipc	a0,0x3
    2e74:	48850513          	addi	a0,a0,1160 # 62f8 <malloc+0x139e>
    2e78:	47f010ef          	jal	4af6 <chdir>
    2e7c:	2c050463          	beqz	a0,3144 <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2e80:	00004517          	auipc	a0,0x4
    2e84:	92050513          	addi	a0,a0,-1760 # 67a0 <malloc+0x1846>
    2e88:	46f010ef          	jal	4af6 <chdir>
    2e8c:	2c050663          	beqz	a0,3158 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2e90:	00003517          	auipc	a0,0x3
    2e94:	57050513          	addi	a0,a0,1392 # 6400 <malloc+0x14a6>
    2e98:	43f010ef          	jal	4ad6 <unlink>
    2e9c:	2c051863          	bnez	a0,316c <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2ea0:	00003517          	auipc	a0,0x3
    2ea4:	45850513          	addi	a0,a0,1112 # 62f8 <malloc+0x139e>
    2ea8:	42f010ef          	jal	4ad6 <unlink>
    2eac:	2c051a63          	bnez	a0,3180 <subdir+0x59e>
  if(unlink("dd") == 0){
    2eb0:	00003517          	auipc	a0,0x3
    2eb4:	42850513          	addi	a0,a0,1064 # 62d8 <malloc+0x137e>
    2eb8:	41f010ef          	jal	4ad6 <unlink>
    2ebc:	2c050c63          	beqz	a0,3194 <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2ec0:	00004517          	auipc	a0,0x4
    2ec4:	95050513          	addi	a0,a0,-1712 # 6810 <malloc+0x18b6>
    2ec8:	40f010ef          	jal	4ad6 <unlink>
    2ecc:	2c054e63          	bltz	a0,31a8 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2ed0:	00003517          	auipc	a0,0x3
    2ed4:	40850513          	addi	a0,a0,1032 # 62d8 <malloc+0x137e>
    2ed8:	3ff010ef          	jal	4ad6 <unlink>
    2edc:	2e054063          	bltz	a0,31bc <subdir+0x5da>
}
    2ee0:	60e2                	ld	ra,24(sp)
    2ee2:	6442                	ld	s0,16(sp)
    2ee4:	64a2                	ld	s1,8(sp)
    2ee6:	6902                	ld	s2,0(sp)
    2ee8:	6105                	addi	sp,sp,32
    2eea:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2eec:	85ca                	mv	a1,s2
    2eee:	00003517          	auipc	a0,0x3
    2ef2:	3f250513          	addi	a0,a0,1010 # 62e0 <malloc+0x1386>
    2ef6:	7b1010ef          	jal	4ea6 <printf>
    exit(1);
    2efa:	4505                	li	a0,1
    2efc:	38b010ef          	jal	4a86 <exit>
    printf("%s: create dd/ff failed\n", s);
    2f00:	85ca                	mv	a1,s2
    2f02:	00003517          	auipc	a0,0x3
    2f06:	3fe50513          	addi	a0,a0,1022 # 6300 <malloc+0x13a6>
    2f0a:	79d010ef          	jal	4ea6 <printf>
    exit(1);
    2f0e:	4505                	li	a0,1
    2f10:	377010ef          	jal	4a86 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2f14:	85ca                	mv	a1,s2
    2f16:	00003517          	auipc	a0,0x3
    2f1a:	40a50513          	addi	a0,a0,1034 # 6320 <malloc+0x13c6>
    2f1e:	789010ef          	jal	4ea6 <printf>
    exit(1);
    2f22:	4505                	li	a0,1
    2f24:	363010ef          	jal	4a86 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2f28:	85ca                	mv	a1,s2
    2f2a:	00003517          	auipc	a0,0x3
    2f2e:	42e50513          	addi	a0,a0,1070 # 6358 <malloc+0x13fe>
    2f32:	775010ef          	jal	4ea6 <printf>
    exit(1);
    2f36:	4505                	li	a0,1
    2f38:	34f010ef          	jal	4a86 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2f3c:	85ca                	mv	a1,s2
    2f3e:	00003517          	auipc	a0,0x3
    2f42:	44a50513          	addi	a0,a0,1098 # 6388 <malloc+0x142e>
    2f46:	761010ef          	jal	4ea6 <printf>
    exit(1);
    2f4a:	4505                	li	a0,1
    2f4c:	33b010ef          	jal	4a86 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2f50:	85ca                	mv	a1,s2
    2f52:	00003517          	auipc	a0,0x3
    2f56:	46e50513          	addi	a0,a0,1134 # 63c0 <malloc+0x1466>
    2f5a:	74d010ef          	jal	4ea6 <printf>
    exit(1);
    2f5e:	4505                	li	a0,1
    2f60:	327010ef          	jal	4a86 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f64:	85ca                	mv	a1,s2
    2f66:	00003517          	auipc	a0,0x3
    2f6a:	47a50513          	addi	a0,a0,1146 # 63e0 <malloc+0x1486>
    2f6e:	739010ef          	jal	4ea6 <printf>
    exit(1);
    2f72:	4505                	li	a0,1
    2f74:	313010ef          	jal	4a86 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f78:	85ca                	mv	a1,s2
    2f7a:	00003517          	auipc	a0,0x3
    2f7e:	49650513          	addi	a0,a0,1174 # 6410 <malloc+0x14b6>
    2f82:	725010ef          	jal	4ea6 <printf>
    exit(1);
    2f86:	4505                	li	a0,1
    2f88:	2ff010ef          	jal	4a86 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f8c:	85ca                	mv	a1,s2
    2f8e:	00003517          	auipc	a0,0x3
    2f92:	4aa50513          	addi	a0,a0,1194 # 6438 <malloc+0x14de>
    2f96:	711010ef          	jal	4ea6 <printf>
    exit(1);
    2f9a:	4505                	li	a0,1
    2f9c:	2eb010ef          	jal	4a86 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2fa0:	85ca                	mv	a1,s2
    2fa2:	00003517          	auipc	a0,0x3
    2fa6:	4b650513          	addi	a0,a0,1206 # 6458 <malloc+0x14fe>
    2faa:	6fd010ef          	jal	4ea6 <printf>
    exit(1);
    2fae:	4505                	li	a0,1
    2fb0:	2d7010ef          	jal	4a86 <exit>
    printf("%s: chdir dd failed\n", s);
    2fb4:	85ca                	mv	a1,s2
    2fb6:	00003517          	auipc	a0,0x3
    2fba:	4ca50513          	addi	a0,a0,1226 # 6480 <malloc+0x1526>
    2fbe:	6e9010ef          	jal	4ea6 <printf>
    exit(1);
    2fc2:	4505                	li	a0,1
    2fc4:	2c3010ef          	jal	4a86 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2fc8:	85ca                	mv	a1,s2
    2fca:	00003517          	auipc	a0,0x3
    2fce:	4de50513          	addi	a0,a0,1246 # 64a8 <malloc+0x154e>
    2fd2:	6d5010ef          	jal	4ea6 <printf>
    exit(1);
    2fd6:	4505                	li	a0,1
    2fd8:	2af010ef          	jal	4a86 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2fdc:	85ca                	mv	a1,s2
    2fde:	00003517          	auipc	a0,0x3
    2fe2:	4fa50513          	addi	a0,a0,1274 # 64d8 <malloc+0x157e>
    2fe6:	6c1010ef          	jal	4ea6 <printf>
    exit(1);
    2fea:	4505                	li	a0,1
    2fec:	29b010ef          	jal	4a86 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2ff0:	85ca                	mv	a1,s2
    2ff2:	00003517          	auipc	a0,0x3
    2ff6:	51650513          	addi	a0,a0,1302 # 6508 <malloc+0x15ae>
    2ffa:	6ad010ef          	jal	4ea6 <printf>
    exit(1);
    2ffe:	4505                	li	a0,1
    3000:	287010ef          	jal	4a86 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3004:	85ca                	mv	a1,s2
    3006:	00003517          	auipc	a0,0x3
    300a:	51a50513          	addi	a0,a0,1306 # 6520 <malloc+0x15c6>
    300e:	699010ef          	jal	4ea6 <printf>
    exit(1);
    3012:	4505                	li	a0,1
    3014:	273010ef          	jal	4a86 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3018:	85ca                	mv	a1,s2
    301a:	00003517          	auipc	a0,0x3
    301e:	52650513          	addi	a0,a0,1318 # 6540 <malloc+0x15e6>
    3022:	685010ef          	jal	4ea6 <printf>
    exit(1);
    3026:	4505                	li	a0,1
    3028:	25f010ef          	jal	4a86 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    302c:	85ca                	mv	a1,s2
    302e:	00003517          	auipc	a0,0x3
    3032:	53250513          	addi	a0,a0,1330 # 6560 <malloc+0x1606>
    3036:	671010ef          	jal	4ea6 <printf>
    exit(1);
    303a:	4505                	li	a0,1
    303c:	24b010ef          	jal	4a86 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3040:	85ca                	mv	a1,s2
    3042:	00003517          	auipc	a0,0x3
    3046:	55e50513          	addi	a0,a0,1374 # 65a0 <malloc+0x1646>
    304a:	65d010ef          	jal	4ea6 <printf>
    exit(1);
    304e:	4505                	li	a0,1
    3050:	237010ef          	jal	4a86 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3054:	85ca                	mv	a1,s2
    3056:	00003517          	auipc	a0,0x3
    305a:	57a50513          	addi	a0,a0,1402 # 65d0 <malloc+0x1676>
    305e:	649010ef          	jal	4ea6 <printf>
    exit(1);
    3062:	4505                	li	a0,1
    3064:	223010ef          	jal	4a86 <exit>
    printf("%s: create dd succeeded!\n", s);
    3068:	85ca                	mv	a1,s2
    306a:	00003517          	auipc	a0,0x3
    306e:	58650513          	addi	a0,a0,1414 # 65f0 <malloc+0x1696>
    3072:	635010ef          	jal	4ea6 <printf>
    exit(1);
    3076:	4505                	li	a0,1
    3078:	20f010ef          	jal	4a86 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    307c:	85ca                	mv	a1,s2
    307e:	00003517          	auipc	a0,0x3
    3082:	59250513          	addi	a0,a0,1426 # 6610 <malloc+0x16b6>
    3086:	621010ef          	jal	4ea6 <printf>
    exit(1);
    308a:	4505                	li	a0,1
    308c:	1fb010ef          	jal	4a86 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3090:	85ca                	mv	a1,s2
    3092:	00003517          	auipc	a0,0x3
    3096:	59e50513          	addi	a0,a0,1438 # 6630 <malloc+0x16d6>
    309a:	60d010ef          	jal	4ea6 <printf>
    exit(1);
    309e:	4505                	li	a0,1
    30a0:	1e7010ef          	jal	4a86 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    30a4:	85ca                	mv	a1,s2
    30a6:	00003517          	auipc	a0,0x3
    30aa:	5ba50513          	addi	a0,a0,1466 # 6660 <malloc+0x1706>
    30ae:	5f9010ef          	jal	4ea6 <printf>
    exit(1);
    30b2:	4505                	li	a0,1
    30b4:	1d3010ef          	jal	4a86 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    30b8:	85ca                	mv	a1,s2
    30ba:	00003517          	auipc	a0,0x3
    30be:	5ce50513          	addi	a0,a0,1486 # 6688 <malloc+0x172e>
    30c2:	5e5010ef          	jal	4ea6 <printf>
    exit(1);
    30c6:	4505                	li	a0,1
    30c8:	1bf010ef          	jal	4a86 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    30cc:	85ca                	mv	a1,s2
    30ce:	00003517          	auipc	a0,0x3
    30d2:	5e250513          	addi	a0,a0,1506 # 66b0 <malloc+0x1756>
    30d6:	5d1010ef          	jal	4ea6 <printf>
    exit(1);
    30da:	4505                	li	a0,1
    30dc:	1ab010ef          	jal	4a86 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    30e0:	85ca                	mv	a1,s2
    30e2:	00003517          	auipc	a0,0x3
    30e6:	5f650513          	addi	a0,a0,1526 # 66d8 <malloc+0x177e>
    30ea:	5bd010ef          	jal	4ea6 <printf>
    exit(1);
    30ee:	4505                	li	a0,1
    30f0:	197010ef          	jal	4a86 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    30f4:	85ca                	mv	a1,s2
    30f6:	00003517          	auipc	a0,0x3
    30fa:	60250513          	addi	a0,a0,1538 # 66f8 <malloc+0x179e>
    30fe:	5a9010ef          	jal	4ea6 <printf>
    exit(1);
    3102:	4505                	li	a0,1
    3104:	183010ef          	jal	4a86 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3108:	85ca                	mv	a1,s2
    310a:	00003517          	auipc	a0,0x3
    310e:	60e50513          	addi	a0,a0,1550 # 6718 <malloc+0x17be>
    3112:	595010ef          	jal	4ea6 <printf>
    exit(1);
    3116:	4505                	li	a0,1
    3118:	16f010ef          	jal	4a86 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    311c:	85ca                	mv	a1,s2
    311e:	00003517          	auipc	a0,0x3
    3122:	62250513          	addi	a0,a0,1570 # 6740 <malloc+0x17e6>
    3126:	581010ef          	jal	4ea6 <printf>
    exit(1);
    312a:	4505                	li	a0,1
    312c:	15b010ef          	jal	4a86 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3130:	85ca                	mv	a1,s2
    3132:	00003517          	auipc	a0,0x3
    3136:	62e50513          	addi	a0,a0,1582 # 6760 <malloc+0x1806>
    313a:	56d010ef          	jal	4ea6 <printf>
    exit(1);
    313e:	4505                	li	a0,1
    3140:	147010ef          	jal	4a86 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3144:	85ca                	mv	a1,s2
    3146:	00003517          	auipc	a0,0x3
    314a:	63a50513          	addi	a0,a0,1594 # 6780 <malloc+0x1826>
    314e:	559010ef          	jal	4ea6 <printf>
    exit(1);
    3152:	4505                	li	a0,1
    3154:	133010ef          	jal	4a86 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3158:	85ca                	mv	a1,s2
    315a:	00003517          	auipc	a0,0x3
    315e:	64e50513          	addi	a0,a0,1614 # 67a8 <malloc+0x184e>
    3162:	545010ef          	jal	4ea6 <printf>
    exit(1);
    3166:	4505                	li	a0,1
    3168:	11f010ef          	jal	4a86 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    316c:	85ca                	mv	a1,s2
    316e:	00003517          	auipc	a0,0x3
    3172:	2ca50513          	addi	a0,a0,714 # 6438 <malloc+0x14de>
    3176:	531010ef          	jal	4ea6 <printf>
    exit(1);
    317a:	4505                	li	a0,1
    317c:	10b010ef          	jal	4a86 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3180:	85ca                	mv	a1,s2
    3182:	00003517          	auipc	a0,0x3
    3186:	64650513          	addi	a0,a0,1606 # 67c8 <malloc+0x186e>
    318a:	51d010ef          	jal	4ea6 <printf>
    exit(1);
    318e:	4505                	li	a0,1
    3190:	0f7010ef          	jal	4a86 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3194:	85ca                	mv	a1,s2
    3196:	00003517          	auipc	a0,0x3
    319a:	65250513          	addi	a0,a0,1618 # 67e8 <malloc+0x188e>
    319e:	509010ef          	jal	4ea6 <printf>
    exit(1);
    31a2:	4505                	li	a0,1
    31a4:	0e3010ef          	jal	4a86 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    31a8:	85ca                	mv	a1,s2
    31aa:	00003517          	auipc	a0,0x3
    31ae:	66e50513          	addi	a0,a0,1646 # 6818 <malloc+0x18be>
    31b2:	4f5010ef          	jal	4ea6 <printf>
    exit(1);
    31b6:	4505                	li	a0,1
    31b8:	0cf010ef          	jal	4a86 <exit>
    printf("%s: unlink dd failed\n", s);
    31bc:	85ca                	mv	a1,s2
    31be:	00003517          	auipc	a0,0x3
    31c2:	67a50513          	addi	a0,a0,1658 # 6838 <malloc+0x18de>
    31c6:	4e1010ef          	jal	4ea6 <printf>
    exit(1);
    31ca:	4505                	li	a0,1
    31cc:	0bb010ef          	jal	4a86 <exit>

00000000000031d0 <rmdot>:
{
    31d0:	1101                	addi	sp,sp,-32
    31d2:	ec06                	sd	ra,24(sp)
    31d4:	e822                	sd	s0,16(sp)
    31d6:	e426                	sd	s1,8(sp)
    31d8:	1000                	addi	s0,sp,32
    31da:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    31dc:	00003517          	auipc	a0,0x3
    31e0:	67450513          	addi	a0,a0,1652 # 6850 <malloc+0x18f6>
    31e4:	10b010ef          	jal	4aee <mkdir>
    31e8:	e53d                	bnez	a0,3256 <rmdot+0x86>
  if(chdir("dots") != 0){
    31ea:	00003517          	auipc	a0,0x3
    31ee:	66650513          	addi	a0,a0,1638 # 6850 <malloc+0x18f6>
    31f2:	105010ef          	jal	4af6 <chdir>
    31f6:	e935                	bnez	a0,326a <rmdot+0x9a>
  if(unlink(".") == 0){
    31f8:	00002517          	auipc	a0,0x2
    31fc:	58850513          	addi	a0,a0,1416 # 5780 <malloc+0x826>
    3200:	0d7010ef          	jal	4ad6 <unlink>
    3204:	cd2d                	beqz	a0,327e <rmdot+0xae>
  if(unlink("..") == 0){
    3206:	00003517          	auipc	a0,0x3
    320a:	09a50513          	addi	a0,a0,154 # 62a0 <malloc+0x1346>
    320e:	0c9010ef          	jal	4ad6 <unlink>
    3212:	c141                	beqz	a0,3292 <rmdot+0xc2>
  if(chdir("/") != 0){
    3214:	00003517          	auipc	a0,0x3
    3218:	03450513          	addi	a0,a0,52 # 6248 <malloc+0x12ee>
    321c:	0db010ef          	jal	4af6 <chdir>
    3220:	e159                	bnez	a0,32a6 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    3222:	00003517          	auipc	a0,0x3
    3226:	69650513          	addi	a0,a0,1686 # 68b8 <malloc+0x195e>
    322a:	0ad010ef          	jal	4ad6 <unlink>
    322e:	c551                	beqz	a0,32ba <rmdot+0xea>
  if(unlink("dots/..") == 0){
    3230:	00003517          	auipc	a0,0x3
    3234:	6b050513          	addi	a0,a0,1712 # 68e0 <malloc+0x1986>
    3238:	09f010ef          	jal	4ad6 <unlink>
    323c:	c949                	beqz	a0,32ce <rmdot+0xfe>
  if(unlink("dots") != 0){
    323e:	00003517          	auipc	a0,0x3
    3242:	61250513          	addi	a0,a0,1554 # 6850 <malloc+0x18f6>
    3246:	091010ef          	jal	4ad6 <unlink>
    324a:	ed41                	bnez	a0,32e2 <rmdot+0x112>
}
    324c:	60e2                	ld	ra,24(sp)
    324e:	6442                	ld	s0,16(sp)
    3250:	64a2                	ld	s1,8(sp)
    3252:	6105                	addi	sp,sp,32
    3254:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3256:	85a6                	mv	a1,s1
    3258:	00003517          	auipc	a0,0x3
    325c:	60050513          	addi	a0,a0,1536 # 6858 <malloc+0x18fe>
    3260:	447010ef          	jal	4ea6 <printf>
    exit(1);
    3264:	4505                	li	a0,1
    3266:	021010ef          	jal	4a86 <exit>
    printf("%s: chdir dots failed\n", s);
    326a:	85a6                	mv	a1,s1
    326c:	00003517          	auipc	a0,0x3
    3270:	60450513          	addi	a0,a0,1540 # 6870 <malloc+0x1916>
    3274:	433010ef          	jal	4ea6 <printf>
    exit(1);
    3278:	4505                	li	a0,1
    327a:	00d010ef          	jal	4a86 <exit>
    printf("%s: rm . worked!\n", s);
    327e:	85a6                	mv	a1,s1
    3280:	00003517          	auipc	a0,0x3
    3284:	60850513          	addi	a0,a0,1544 # 6888 <malloc+0x192e>
    3288:	41f010ef          	jal	4ea6 <printf>
    exit(1);
    328c:	4505                	li	a0,1
    328e:	7f8010ef          	jal	4a86 <exit>
    printf("%s: rm .. worked!\n", s);
    3292:	85a6                	mv	a1,s1
    3294:	00003517          	auipc	a0,0x3
    3298:	60c50513          	addi	a0,a0,1548 # 68a0 <malloc+0x1946>
    329c:	40b010ef          	jal	4ea6 <printf>
    exit(1);
    32a0:	4505                	li	a0,1
    32a2:	7e4010ef          	jal	4a86 <exit>
    printf("%s: chdir / failed\n", s);
    32a6:	85a6                	mv	a1,s1
    32a8:	00003517          	auipc	a0,0x3
    32ac:	fa850513          	addi	a0,a0,-88 # 6250 <malloc+0x12f6>
    32b0:	3f7010ef          	jal	4ea6 <printf>
    exit(1);
    32b4:	4505                	li	a0,1
    32b6:	7d0010ef          	jal	4a86 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    32ba:	85a6                	mv	a1,s1
    32bc:	00003517          	auipc	a0,0x3
    32c0:	60450513          	addi	a0,a0,1540 # 68c0 <malloc+0x1966>
    32c4:	3e3010ef          	jal	4ea6 <printf>
    exit(1);
    32c8:	4505                	li	a0,1
    32ca:	7bc010ef          	jal	4a86 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    32ce:	85a6                	mv	a1,s1
    32d0:	00003517          	auipc	a0,0x3
    32d4:	61850513          	addi	a0,a0,1560 # 68e8 <malloc+0x198e>
    32d8:	3cf010ef          	jal	4ea6 <printf>
    exit(1);
    32dc:	4505                	li	a0,1
    32de:	7a8010ef          	jal	4a86 <exit>
    printf("%s: unlink dots failed!\n", s);
    32e2:	85a6                	mv	a1,s1
    32e4:	00003517          	auipc	a0,0x3
    32e8:	62450513          	addi	a0,a0,1572 # 6908 <malloc+0x19ae>
    32ec:	3bb010ef          	jal	4ea6 <printf>
    exit(1);
    32f0:	4505                	li	a0,1
    32f2:	794010ef          	jal	4a86 <exit>

00000000000032f6 <dirfile>:
{
    32f6:	1101                	addi	sp,sp,-32
    32f8:	ec06                	sd	ra,24(sp)
    32fa:	e822                	sd	s0,16(sp)
    32fc:	e426                	sd	s1,8(sp)
    32fe:	e04a                	sd	s2,0(sp)
    3300:	1000                	addi	s0,sp,32
    3302:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3304:	20000593          	li	a1,512
    3308:	00003517          	auipc	a0,0x3
    330c:	62050513          	addi	a0,a0,1568 # 6928 <malloc+0x19ce>
    3310:	7b6010ef          	jal	4ac6 <open>
  if(fd < 0){
    3314:	0c054563          	bltz	a0,33de <dirfile+0xe8>
  close(fd);
    3318:	796010ef          	jal	4aae <close>
  if(chdir("dirfile") == 0){
    331c:	00003517          	auipc	a0,0x3
    3320:	60c50513          	addi	a0,a0,1548 # 6928 <malloc+0x19ce>
    3324:	7d2010ef          	jal	4af6 <chdir>
    3328:	c569                	beqz	a0,33f2 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    332a:	4581                	li	a1,0
    332c:	00003517          	auipc	a0,0x3
    3330:	64450513          	addi	a0,a0,1604 # 6970 <malloc+0x1a16>
    3334:	792010ef          	jal	4ac6 <open>
  if(fd >= 0){
    3338:	0c055763          	bgez	a0,3406 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    333c:	20000593          	li	a1,512
    3340:	00003517          	auipc	a0,0x3
    3344:	63050513          	addi	a0,a0,1584 # 6970 <malloc+0x1a16>
    3348:	77e010ef          	jal	4ac6 <open>
  if(fd >= 0){
    334c:	0c055763          	bgez	a0,341a <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    3350:	00003517          	auipc	a0,0x3
    3354:	62050513          	addi	a0,a0,1568 # 6970 <malloc+0x1a16>
    3358:	796010ef          	jal	4aee <mkdir>
    335c:	0c050963          	beqz	a0,342e <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    3360:	00003517          	auipc	a0,0x3
    3364:	61050513          	addi	a0,a0,1552 # 6970 <malloc+0x1a16>
    3368:	76e010ef          	jal	4ad6 <unlink>
    336c:	0c050b63          	beqz	a0,3442 <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    3370:	00003597          	auipc	a1,0x3
    3374:	60058593          	addi	a1,a1,1536 # 6970 <malloc+0x1a16>
    3378:	00002517          	auipc	a0,0x2
    337c:	ef850513          	addi	a0,a0,-264 # 5270 <malloc+0x316>
    3380:	766010ef          	jal	4ae6 <link>
    3384:	0c050963          	beqz	a0,3456 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    3388:	00003517          	auipc	a0,0x3
    338c:	5a050513          	addi	a0,a0,1440 # 6928 <malloc+0x19ce>
    3390:	746010ef          	jal	4ad6 <unlink>
    3394:	0c051b63          	bnez	a0,346a <dirfile+0x174>
  fd = open(".", O_RDWR);
    3398:	4589                	li	a1,2
    339a:	00002517          	auipc	a0,0x2
    339e:	3e650513          	addi	a0,a0,998 # 5780 <malloc+0x826>
    33a2:	724010ef          	jal	4ac6 <open>
  if(fd >= 0){
    33a6:	0c055c63          	bgez	a0,347e <dirfile+0x188>
  fd = open(".", 0);
    33aa:	4581                	li	a1,0
    33ac:	00002517          	auipc	a0,0x2
    33b0:	3d450513          	addi	a0,a0,980 # 5780 <malloc+0x826>
    33b4:	712010ef          	jal	4ac6 <open>
    33b8:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    33ba:	4605                	li	a2,1
    33bc:	00002597          	auipc	a1,0x2
    33c0:	d4c58593          	addi	a1,a1,-692 # 5108 <malloc+0x1ae>
    33c4:	6e2010ef          	jal	4aa6 <write>
    33c8:	0ca04563          	bgtz	a0,3492 <dirfile+0x19c>
  close(fd);
    33cc:	8526                	mv	a0,s1
    33ce:	6e0010ef          	jal	4aae <close>
}
    33d2:	60e2                	ld	ra,24(sp)
    33d4:	6442                	ld	s0,16(sp)
    33d6:	64a2                	ld	s1,8(sp)
    33d8:	6902                	ld	s2,0(sp)
    33da:	6105                	addi	sp,sp,32
    33dc:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    33de:	85ca                	mv	a1,s2
    33e0:	00003517          	auipc	a0,0x3
    33e4:	55050513          	addi	a0,a0,1360 # 6930 <malloc+0x19d6>
    33e8:	2bf010ef          	jal	4ea6 <printf>
    exit(1);
    33ec:	4505                	li	a0,1
    33ee:	698010ef          	jal	4a86 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    33f2:	85ca                	mv	a1,s2
    33f4:	00003517          	auipc	a0,0x3
    33f8:	55c50513          	addi	a0,a0,1372 # 6950 <malloc+0x19f6>
    33fc:	2ab010ef          	jal	4ea6 <printf>
    exit(1);
    3400:	4505                	li	a0,1
    3402:	684010ef          	jal	4a86 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3406:	85ca                	mv	a1,s2
    3408:	00003517          	auipc	a0,0x3
    340c:	57850513          	addi	a0,a0,1400 # 6980 <malloc+0x1a26>
    3410:	297010ef          	jal	4ea6 <printf>
    exit(1);
    3414:	4505                	li	a0,1
    3416:	670010ef          	jal	4a86 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    341a:	85ca                	mv	a1,s2
    341c:	00003517          	auipc	a0,0x3
    3420:	56450513          	addi	a0,a0,1380 # 6980 <malloc+0x1a26>
    3424:	283010ef          	jal	4ea6 <printf>
    exit(1);
    3428:	4505                	li	a0,1
    342a:	65c010ef          	jal	4a86 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    342e:	85ca                	mv	a1,s2
    3430:	00003517          	auipc	a0,0x3
    3434:	57850513          	addi	a0,a0,1400 # 69a8 <malloc+0x1a4e>
    3438:	26f010ef          	jal	4ea6 <printf>
    exit(1);
    343c:	4505                	li	a0,1
    343e:	648010ef          	jal	4a86 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3442:	85ca                	mv	a1,s2
    3444:	00003517          	auipc	a0,0x3
    3448:	58c50513          	addi	a0,a0,1420 # 69d0 <malloc+0x1a76>
    344c:	25b010ef          	jal	4ea6 <printf>
    exit(1);
    3450:	4505                	li	a0,1
    3452:	634010ef          	jal	4a86 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3456:	85ca                	mv	a1,s2
    3458:	00003517          	auipc	a0,0x3
    345c:	5a050513          	addi	a0,a0,1440 # 69f8 <malloc+0x1a9e>
    3460:	247010ef          	jal	4ea6 <printf>
    exit(1);
    3464:	4505                	li	a0,1
    3466:	620010ef          	jal	4a86 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    346a:	85ca                	mv	a1,s2
    346c:	00003517          	auipc	a0,0x3
    3470:	5b450513          	addi	a0,a0,1460 # 6a20 <malloc+0x1ac6>
    3474:	233010ef          	jal	4ea6 <printf>
    exit(1);
    3478:	4505                	li	a0,1
    347a:	60c010ef          	jal	4a86 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    347e:	85ca                	mv	a1,s2
    3480:	00003517          	auipc	a0,0x3
    3484:	5c050513          	addi	a0,a0,1472 # 6a40 <malloc+0x1ae6>
    3488:	21f010ef          	jal	4ea6 <printf>
    exit(1);
    348c:	4505                	li	a0,1
    348e:	5f8010ef          	jal	4a86 <exit>
    printf("%s: write . succeeded!\n", s);
    3492:	85ca                	mv	a1,s2
    3494:	00003517          	auipc	a0,0x3
    3498:	5d450513          	addi	a0,a0,1492 # 6a68 <malloc+0x1b0e>
    349c:	20b010ef          	jal	4ea6 <printf>
    exit(1);
    34a0:	4505                	li	a0,1
    34a2:	5e4010ef          	jal	4a86 <exit>

00000000000034a6 <iref>:
{
    34a6:	7139                	addi	sp,sp,-64
    34a8:	fc06                	sd	ra,56(sp)
    34aa:	f822                	sd	s0,48(sp)
    34ac:	f426                	sd	s1,40(sp)
    34ae:	f04a                	sd	s2,32(sp)
    34b0:	ec4e                	sd	s3,24(sp)
    34b2:	e852                	sd	s4,16(sp)
    34b4:	e456                	sd	s5,8(sp)
    34b6:	e05a                	sd	s6,0(sp)
    34b8:	0080                	addi	s0,sp,64
    34ba:	8b2a                	mv	s6,a0
    34bc:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    34c0:	00003a17          	auipc	s4,0x3
    34c4:	5c0a0a13          	addi	s4,s4,1472 # 6a80 <malloc+0x1b26>
    mkdir("");
    34c8:	00003497          	auipc	s1,0x3
    34cc:	0c048493          	addi	s1,s1,192 # 6588 <malloc+0x162e>
    link("README", "");
    34d0:	00002a97          	auipc	s5,0x2
    34d4:	da0a8a93          	addi	s5,s5,-608 # 5270 <malloc+0x316>
    fd = open("xx", O_CREATE);
    34d8:	00003997          	auipc	s3,0x3
    34dc:	4a098993          	addi	s3,s3,1184 # 6978 <malloc+0x1a1e>
    34e0:	a835                	j	351c <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    34e2:	85da                	mv	a1,s6
    34e4:	00003517          	auipc	a0,0x3
    34e8:	5a450513          	addi	a0,a0,1444 # 6a88 <malloc+0x1b2e>
    34ec:	1bb010ef          	jal	4ea6 <printf>
      exit(1);
    34f0:	4505                	li	a0,1
    34f2:	594010ef          	jal	4a86 <exit>
      printf("%s: chdir irefd failed\n", s);
    34f6:	85da                	mv	a1,s6
    34f8:	00003517          	auipc	a0,0x3
    34fc:	5a850513          	addi	a0,a0,1448 # 6aa0 <malloc+0x1b46>
    3500:	1a7010ef          	jal	4ea6 <printf>
      exit(1);
    3504:	4505                	li	a0,1
    3506:	580010ef          	jal	4a86 <exit>
      close(fd);
    350a:	5a4010ef          	jal	4aae <close>
    350e:	a82d                	j	3548 <iref+0xa2>
    unlink("xx");
    3510:	854e                	mv	a0,s3
    3512:	5c4010ef          	jal	4ad6 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3516:	397d                	addiw	s2,s2,-1
    3518:	04090263          	beqz	s2,355c <iref+0xb6>
    if(mkdir("irefd") != 0){
    351c:	8552                	mv	a0,s4
    351e:	5d0010ef          	jal	4aee <mkdir>
    3522:	f161                	bnez	a0,34e2 <iref+0x3c>
    if(chdir("irefd") != 0){
    3524:	8552                	mv	a0,s4
    3526:	5d0010ef          	jal	4af6 <chdir>
    352a:	f571                	bnez	a0,34f6 <iref+0x50>
    mkdir("");
    352c:	8526                	mv	a0,s1
    352e:	5c0010ef          	jal	4aee <mkdir>
    link("README", "");
    3532:	85a6                	mv	a1,s1
    3534:	8556                	mv	a0,s5
    3536:	5b0010ef          	jal	4ae6 <link>
    fd = open("", O_CREATE);
    353a:	20000593          	li	a1,512
    353e:	8526                	mv	a0,s1
    3540:	586010ef          	jal	4ac6 <open>
    if(fd >= 0)
    3544:	fc0553e3          	bgez	a0,350a <iref+0x64>
    fd = open("xx", O_CREATE);
    3548:	20000593          	li	a1,512
    354c:	854e                	mv	a0,s3
    354e:	578010ef          	jal	4ac6 <open>
    if(fd >= 0)
    3552:	fa054fe3          	bltz	a0,3510 <iref+0x6a>
      close(fd);
    3556:	558010ef          	jal	4aae <close>
    355a:	bf5d                	j	3510 <iref+0x6a>
    355c:	03300493          	li	s1,51
    chdir("..");
    3560:	00003997          	auipc	s3,0x3
    3564:	d4098993          	addi	s3,s3,-704 # 62a0 <malloc+0x1346>
    unlink("irefd");
    3568:	00003917          	auipc	s2,0x3
    356c:	51890913          	addi	s2,s2,1304 # 6a80 <malloc+0x1b26>
    chdir("..");
    3570:	854e                	mv	a0,s3
    3572:	584010ef          	jal	4af6 <chdir>
    unlink("irefd");
    3576:	854a                	mv	a0,s2
    3578:	55e010ef          	jal	4ad6 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    357c:	34fd                	addiw	s1,s1,-1
    357e:	f8ed                	bnez	s1,3570 <iref+0xca>
  chdir("/");
    3580:	00003517          	auipc	a0,0x3
    3584:	cc850513          	addi	a0,a0,-824 # 6248 <malloc+0x12ee>
    3588:	56e010ef          	jal	4af6 <chdir>
}
    358c:	70e2                	ld	ra,56(sp)
    358e:	7442                	ld	s0,48(sp)
    3590:	74a2                	ld	s1,40(sp)
    3592:	7902                	ld	s2,32(sp)
    3594:	69e2                	ld	s3,24(sp)
    3596:	6a42                	ld	s4,16(sp)
    3598:	6aa2                	ld	s5,8(sp)
    359a:	6b02                	ld	s6,0(sp)
    359c:	6121                	addi	sp,sp,64
    359e:	8082                	ret

00000000000035a0 <openiputtest>:
{
    35a0:	7179                	addi	sp,sp,-48
    35a2:	f406                	sd	ra,40(sp)
    35a4:	f022                	sd	s0,32(sp)
    35a6:	ec26                	sd	s1,24(sp)
    35a8:	1800                	addi	s0,sp,48
    35aa:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    35ac:	00003517          	auipc	a0,0x3
    35b0:	50c50513          	addi	a0,a0,1292 # 6ab8 <malloc+0x1b5e>
    35b4:	53a010ef          	jal	4aee <mkdir>
    35b8:	02054a63          	bltz	a0,35ec <openiputtest+0x4c>
  pid = fork();
    35bc:	4c2010ef          	jal	4a7e <fork>
  if(pid < 0){
    35c0:	04054063          	bltz	a0,3600 <openiputtest+0x60>
  if(pid == 0){
    35c4:	e939                	bnez	a0,361a <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    35c6:	4589                	li	a1,2
    35c8:	00003517          	auipc	a0,0x3
    35cc:	4f050513          	addi	a0,a0,1264 # 6ab8 <malloc+0x1b5e>
    35d0:	4f6010ef          	jal	4ac6 <open>
    if(fd >= 0){
    35d4:	04054063          	bltz	a0,3614 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    35d8:	85a6                	mv	a1,s1
    35da:	00003517          	auipc	a0,0x3
    35de:	4fe50513          	addi	a0,a0,1278 # 6ad8 <malloc+0x1b7e>
    35e2:	0c5010ef          	jal	4ea6 <printf>
      exit(1);
    35e6:	4505                	li	a0,1
    35e8:	49e010ef          	jal	4a86 <exit>
    printf("%s: mkdir oidir failed\n", s);
    35ec:	85a6                	mv	a1,s1
    35ee:	00003517          	auipc	a0,0x3
    35f2:	4d250513          	addi	a0,a0,1234 # 6ac0 <malloc+0x1b66>
    35f6:	0b1010ef          	jal	4ea6 <printf>
    exit(1);
    35fa:	4505                	li	a0,1
    35fc:	48a010ef          	jal	4a86 <exit>
    printf("%s: fork failed\n", s);
    3600:	85a6                	mv	a1,s1
    3602:	00002517          	auipc	a0,0x2
    3606:	32650513          	addi	a0,a0,806 # 5928 <malloc+0x9ce>
    360a:	09d010ef          	jal	4ea6 <printf>
    exit(1);
    360e:	4505                	li	a0,1
    3610:	476010ef          	jal	4a86 <exit>
    exit(0);
    3614:	4501                	li	a0,0
    3616:	470010ef          	jal	4a86 <exit>
  sleep(1);
    361a:	4505                	li	a0,1
    361c:	4fa010ef          	jal	4b16 <sleep>
  if(unlink("oidir") != 0){
    3620:	00003517          	auipc	a0,0x3
    3624:	49850513          	addi	a0,a0,1176 # 6ab8 <malloc+0x1b5e>
    3628:	4ae010ef          	jal	4ad6 <unlink>
    362c:	c919                	beqz	a0,3642 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    362e:	85a6                	mv	a1,s1
    3630:	00002517          	auipc	a0,0x2
    3634:	4e850513          	addi	a0,a0,1256 # 5b18 <malloc+0xbbe>
    3638:	06f010ef          	jal	4ea6 <printf>
    exit(1);
    363c:	4505                	li	a0,1
    363e:	448010ef          	jal	4a86 <exit>
  wait(&xstatus);
    3642:	fdc40513          	addi	a0,s0,-36
    3646:	448010ef          	jal	4a8e <wait>
  exit(xstatus);
    364a:	fdc42503          	lw	a0,-36(s0)
    364e:	438010ef          	jal	4a86 <exit>

0000000000003652 <forkforkfork>:
{
    3652:	1101                	addi	sp,sp,-32
    3654:	ec06                	sd	ra,24(sp)
    3656:	e822                	sd	s0,16(sp)
    3658:	e426                	sd	s1,8(sp)
    365a:	1000                	addi	s0,sp,32
    365c:	84aa                	mv	s1,a0
  unlink("stopforking");
    365e:	00003517          	auipc	a0,0x3
    3662:	4a250513          	addi	a0,a0,1186 # 6b00 <malloc+0x1ba6>
    3666:	470010ef          	jal	4ad6 <unlink>
  int pid = fork();
    366a:	414010ef          	jal	4a7e <fork>
  if(pid < 0){
    366e:	02054b63          	bltz	a0,36a4 <forkforkfork+0x52>
  if(pid == 0){
    3672:	c139                	beqz	a0,36b8 <forkforkfork+0x66>
  sleep(20); // two seconds
    3674:	4551                	li	a0,20
    3676:	4a0010ef          	jal	4b16 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    367a:	20200593          	li	a1,514
    367e:	00003517          	auipc	a0,0x3
    3682:	48250513          	addi	a0,a0,1154 # 6b00 <malloc+0x1ba6>
    3686:	440010ef          	jal	4ac6 <open>
    368a:	424010ef          	jal	4aae <close>
  wait(0);
    368e:	4501                	li	a0,0
    3690:	3fe010ef          	jal	4a8e <wait>
  sleep(10); // one second
    3694:	4529                	li	a0,10
    3696:	480010ef          	jal	4b16 <sleep>
}
    369a:	60e2                	ld	ra,24(sp)
    369c:	6442                	ld	s0,16(sp)
    369e:	64a2                	ld	s1,8(sp)
    36a0:	6105                	addi	sp,sp,32
    36a2:	8082                	ret
    printf("%s: fork failed", s);
    36a4:	85a6                	mv	a1,s1
    36a6:	00002517          	auipc	a0,0x2
    36aa:	44250513          	addi	a0,a0,1090 # 5ae8 <malloc+0xb8e>
    36ae:	7f8010ef          	jal	4ea6 <printf>
    exit(1);
    36b2:	4505                	li	a0,1
    36b4:	3d2010ef          	jal	4a86 <exit>
      int fd = open("stopforking", 0);
    36b8:	00003497          	auipc	s1,0x3
    36bc:	44848493          	addi	s1,s1,1096 # 6b00 <malloc+0x1ba6>
    36c0:	4581                	li	a1,0
    36c2:	8526                	mv	a0,s1
    36c4:	402010ef          	jal	4ac6 <open>
      if(fd >= 0){
    36c8:	02055163          	bgez	a0,36ea <forkforkfork+0x98>
      if(fork() < 0){
    36cc:	3b2010ef          	jal	4a7e <fork>
    36d0:	fe0558e3          	bgez	a0,36c0 <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    36d4:	20200593          	li	a1,514
    36d8:	00003517          	auipc	a0,0x3
    36dc:	42850513          	addi	a0,a0,1064 # 6b00 <malloc+0x1ba6>
    36e0:	3e6010ef          	jal	4ac6 <open>
    36e4:	3ca010ef          	jal	4aae <close>
    36e8:	bfe1                	j	36c0 <forkforkfork+0x6e>
        exit(0);
    36ea:	4501                	li	a0,0
    36ec:	39a010ef          	jal	4a86 <exit>

00000000000036f0 <killstatus>:
{
    36f0:	7139                	addi	sp,sp,-64
    36f2:	fc06                	sd	ra,56(sp)
    36f4:	f822                	sd	s0,48(sp)
    36f6:	f426                	sd	s1,40(sp)
    36f8:	f04a                	sd	s2,32(sp)
    36fa:	ec4e                	sd	s3,24(sp)
    36fc:	e852                	sd	s4,16(sp)
    36fe:	0080                	addi	s0,sp,64
    3700:	8a2a                	mv	s4,a0
    3702:	06400913          	li	s2,100
    if(xst != -1) {
    3706:	59fd                	li	s3,-1
    int pid1 = fork();
    3708:	376010ef          	jal	4a7e <fork>
    370c:	84aa                	mv	s1,a0
    if(pid1 < 0){
    370e:	02054763          	bltz	a0,373c <killstatus+0x4c>
    if(pid1 == 0){
    3712:	cd1d                	beqz	a0,3750 <killstatus+0x60>
    sleep(1);
    3714:	4505                	li	a0,1
    3716:	400010ef          	jal	4b16 <sleep>
    kill(pid1);
    371a:	8526                	mv	a0,s1
    371c:	39a010ef          	jal	4ab6 <kill>
    wait(&xst);
    3720:	fcc40513          	addi	a0,s0,-52
    3724:	36a010ef          	jal	4a8e <wait>
    if(xst != -1) {
    3728:	fcc42783          	lw	a5,-52(s0)
    372c:	03379563          	bne	a5,s3,3756 <killstatus+0x66>
  for(int i = 0; i < 100; i++){
    3730:	397d                	addiw	s2,s2,-1
    3732:	fc091be3          	bnez	s2,3708 <killstatus+0x18>
  exit(0);
    3736:	4501                	li	a0,0
    3738:	34e010ef          	jal	4a86 <exit>
      printf("%s: fork failed\n", s);
    373c:	85d2                	mv	a1,s4
    373e:	00002517          	auipc	a0,0x2
    3742:	1ea50513          	addi	a0,a0,490 # 5928 <malloc+0x9ce>
    3746:	760010ef          	jal	4ea6 <printf>
      exit(1);
    374a:	4505                	li	a0,1
    374c:	33a010ef          	jal	4a86 <exit>
        getpid();
    3750:	3b6010ef          	jal	4b06 <getpid>
      while(1) {
    3754:	bff5                	j	3750 <killstatus+0x60>
       printf("%s: status should be -1\n", s);
    3756:	85d2                	mv	a1,s4
    3758:	00003517          	auipc	a0,0x3
    375c:	3b850513          	addi	a0,a0,952 # 6b10 <malloc+0x1bb6>
    3760:	746010ef          	jal	4ea6 <printf>
       exit(1);
    3764:	4505                	li	a0,1
    3766:	320010ef          	jal	4a86 <exit>

000000000000376a <preempt>:
{
    376a:	7139                	addi	sp,sp,-64
    376c:	fc06                	sd	ra,56(sp)
    376e:	f822                	sd	s0,48(sp)
    3770:	f426                	sd	s1,40(sp)
    3772:	f04a                	sd	s2,32(sp)
    3774:	ec4e                	sd	s3,24(sp)
    3776:	e852                	sd	s4,16(sp)
    3778:	0080                	addi	s0,sp,64
    377a:	892a                	mv	s2,a0
  pid1 = fork();
    377c:	302010ef          	jal	4a7e <fork>
  if(pid1 < 0) {
    3780:	00054563          	bltz	a0,378a <preempt+0x20>
    3784:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3786:	ed01                	bnez	a0,379e <preempt+0x34>
    for(;;)
    3788:	a001                	j	3788 <preempt+0x1e>
    printf("%s: fork failed", s);
    378a:	85ca                	mv	a1,s2
    378c:	00002517          	auipc	a0,0x2
    3790:	35c50513          	addi	a0,a0,860 # 5ae8 <malloc+0xb8e>
    3794:	712010ef          	jal	4ea6 <printf>
    exit(1);
    3798:	4505                	li	a0,1
    379a:	2ec010ef          	jal	4a86 <exit>
  pid2 = fork();
    379e:	2e0010ef          	jal	4a7e <fork>
    37a2:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    37a4:	00054463          	bltz	a0,37ac <preempt+0x42>
  if(pid2 == 0)
    37a8:	ed01                	bnez	a0,37c0 <preempt+0x56>
    for(;;)
    37aa:	a001                	j	37aa <preempt+0x40>
    printf("%s: fork failed\n", s);
    37ac:	85ca                	mv	a1,s2
    37ae:	00002517          	auipc	a0,0x2
    37b2:	17a50513          	addi	a0,a0,378 # 5928 <malloc+0x9ce>
    37b6:	6f0010ef          	jal	4ea6 <printf>
    exit(1);
    37ba:	4505                	li	a0,1
    37bc:	2ca010ef          	jal	4a86 <exit>
  pipe(pfds);
    37c0:	fc840513          	addi	a0,s0,-56
    37c4:	2d2010ef          	jal	4a96 <pipe>
  pid3 = fork();
    37c8:	2b6010ef          	jal	4a7e <fork>
    37cc:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    37ce:	02054863          	bltz	a0,37fe <preempt+0x94>
  if(pid3 == 0){
    37d2:	e921                	bnez	a0,3822 <preempt+0xb8>
    close(pfds[0]);
    37d4:	fc842503          	lw	a0,-56(s0)
    37d8:	2d6010ef          	jal	4aae <close>
    if(write(pfds[1], "x", 1) != 1)
    37dc:	4605                	li	a2,1
    37de:	00002597          	auipc	a1,0x2
    37e2:	92a58593          	addi	a1,a1,-1750 # 5108 <malloc+0x1ae>
    37e6:	fcc42503          	lw	a0,-52(s0)
    37ea:	2bc010ef          	jal	4aa6 <write>
    37ee:	4785                	li	a5,1
    37f0:	02f51163          	bne	a0,a5,3812 <preempt+0xa8>
    close(pfds[1]);
    37f4:	fcc42503          	lw	a0,-52(s0)
    37f8:	2b6010ef          	jal	4aae <close>
    for(;;)
    37fc:	a001                	j	37fc <preempt+0x92>
     printf("%s: fork failed\n", s);
    37fe:	85ca                	mv	a1,s2
    3800:	00002517          	auipc	a0,0x2
    3804:	12850513          	addi	a0,a0,296 # 5928 <malloc+0x9ce>
    3808:	69e010ef          	jal	4ea6 <printf>
     exit(1);
    380c:	4505                	li	a0,1
    380e:	278010ef          	jal	4a86 <exit>
      printf("%s: preempt write error", s);
    3812:	85ca                	mv	a1,s2
    3814:	00003517          	auipc	a0,0x3
    3818:	31c50513          	addi	a0,a0,796 # 6b30 <malloc+0x1bd6>
    381c:	68a010ef          	jal	4ea6 <printf>
    3820:	bfd1                	j	37f4 <preempt+0x8a>
  close(pfds[1]);
    3822:	fcc42503          	lw	a0,-52(s0)
    3826:	288010ef          	jal	4aae <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    382a:	660d                	lui	a2,0x3
    382c:	00009597          	auipc	a1,0x9
    3830:	44c58593          	addi	a1,a1,1100 # cc78 <buf>
    3834:	fc842503          	lw	a0,-56(s0)
    3838:	266010ef          	jal	4a9e <read>
    383c:	4785                	li	a5,1
    383e:	02f50163          	beq	a0,a5,3860 <preempt+0xf6>
    printf("%s: preempt read error", s);
    3842:	85ca                	mv	a1,s2
    3844:	00003517          	auipc	a0,0x3
    3848:	30450513          	addi	a0,a0,772 # 6b48 <malloc+0x1bee>
    384c:	65a010ef          	jal	4ea6 <printf>
}
    3850:	70e2                	ld	ra,56(sp)
    3852:	7442                	ld	s0,48(sp)
    3854:	74a2                	ld	s1,40(sp)
    3856:	7902                	ld	s2,32(sp)
    3858:	69e2                	ld	s3,24(sp)
    385a:	6a42                	ld	s4,16(sp)
    385c:	6121                	addi	sp,sp,64
    385e:	8082                	ret
  close(pfds[0]);
    3860:	fc842503          	lw	a0,-56(s0)
    3864:	24a010ef          	jal	4aae <close>
  printf("kill... ");
    3868:	00003517          	auipc	a0,0x3
    386c:	2f850513          	addi	a0,a0,760 # 6b60 <malloc+0x1c06>
    3870:	636010ef          	jal	4ea6 <printf>
  kill(pid1);
    3874:	8526                	mv	a0,s1
    3876:	240010ef          	jal	4ab6 <kill>
  kill(pid2);
    387a:	854e                	mv	a0,s3
    387c:	23a010ef          	jal	4ab6 <kill>
  kill(pid3);
    3880:	8552                	mv	a0,s4
    3882:	234010ef          	jal	4ab6 <kill>
  printf("wait... ");
    3886:	00003517          	auipc	a0,0x3
    388a:	2ea50513          	addi	a0,a0,746 # 6b70 <malloc+0x1c16>
    388e:	618010ef          	jal	4ea6 <printf>
  wait(0);
    3892:	4501                	li	a0,0
    3894:	1fa010ef          	jal	4a8e <wait>
  wait(0);
    3898:	4501                	li	a0,0
    389a:	1f4010ef          	jal	4a8e <wait>
  wait(0);
    389e:	4501                	li	a0,0
    38a0:	1ee010ef          	jal	4a8e <wait>
    38a4:	b775                	j	3850 <preempt+0xe6>

00000000000038a6 <reparent>:
{
    38a6:	7179                	addi	sp,sp,-48
    38a8:	f406                	sd	ra,40(sp)
    38aa:	f022                	sd	s0,32(sp)
    38ac:	ec26                	sd	s1,24(sp)
    38ae:	e84a                	sd	s2,16(sp)
    38b0:	e44e                	sd	s3,8(sp)
    38b2:	e052                	sd	s4,0(sp)
    38b4:	1800                	addi	s0,sp,48
    38b6:	89aa                	mv	s3,a0
  int master_pid = getpid();
    38b8:	24e010ef          	jal	4b06 <getpid>
    38bc:	8a2a                	mv	s4,a0
    38be:	0c800913          	li	s2,200
    int pid = fork();
    38c2:	1bc010ef          	jal	4a7e <fork>
    38c6:	84aa                	mv	s1,a0
    if(pid < 0){
    38c8:	00054e63          	bltz	a0,38e4 <reparent+0x3e>
    if(pid){
    38cc:	c121                	beqz	a0,390c <reparent+0x66>
      if(wait(0) != pid){
    38ce:	4501                	li	a0,0
    38d0:	1be010ef          	jal	4a8e <wait>
    38d4:	02951263          	bne	a0,s1,38f8 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    38d8:	397d                	addiw	s2,s2,-1
    38da:	fe0914e3          	bnez	s2,38c2 <reparent+0x1c>
  exit(0);
    38de:	4501                	li	a0,0
    38e0:	1a6010ef          	jal	4a86 <exit>
      printf("%s: fork failed\n", s);
    38e4:	85ce                	mv	a1,s3
    38e6:	00002517          	auipc	a0,0x2
    38ea:	04250513          	addi	a0,a0,66 # 5928 <malloc+0x9ce>
    38ee:	5b8010ef          	jal	4ea6 <printf>
      exit(1);
    38f2:	4505                	li	a0,1
    38f4:	192010ef          	jal	4a86 <exit>
        printf("%s: wait wrong pid\n", s);
    38f8:	85ce                	mv	a1,s3
    38fa:	00002517          	auipc	a0,0x2
    38fe:	1b650513          	addi	a0,a0,438 # 5ab0 <malloc+0xb56>
    3902:	5a4010ef          	jal	4ea6 <printf>
        exit(1);
    3906:	4505                	li	a0,1
    3908:	17e010ef          	jal	4a86 <exit>
      int pid2 = fork();
    390c:	172010ef          	jal	4a7e <fork>
      if(pid2 < 0){
    3910:	00054563          	bltz	a0,391a <reparent+0x74>
      exit(0);
    3914:	4501                	li	a0,0
    3916:	170010ef          	jal	4a86 <exit>
        kill(master_pid);
    391a:	8552                	mv	a0,s4
    391c:	19a010ef          	jal	4ab6 <kill>
        exit(1);
    3920:	4505                	li	a0,1
    3922:	164010ef          	jal	4a86 <exit>

0000000000003926 <sbrkfail>:
{
    3926:	7119                	addi	sp,sp,-128
    3928:	fc86                	sd	ra,120(sp)
    392a:	f8a2                	sd	s0,112(sp)
    392c:	f4a6                	sd	s1,104(sp)
    392e:	f0ca                	sd	s2,96(sp)
    3930:	ecce                	sd	s3,88(sp)
    3932:	e8d2                	sd	s4,80(sp)
    3934:	e4d6                	sd	s5,72(sp)
    3936:	0100                	addi	s0,sp,128
    3938:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    393a:	fb040513          	addi	a0,s0,-80
    393e:	158010ef          	jal	4a96 <pipe>
    3942:	e901                	bnez	a0,3952 <sbrkfail+0x2c>
    3944:	f8040493          	addi	s1,s0,-128
    3948:	fa840993          	addi	s3,s0,-88
    394c:	8926                	mv	s2,s1
    if(pids[i] != -1)
    394e:	5a7d                	li	s4,-1
    3950:	a0a1                	j	3998 <sbrkfail+0x72>
    printf("%s: pipe() failed\n", s);
    3952:	85d6                	mv	a1,s5
    3954:	00002517          	auipc	a0,0x2
    3958:	0dc50513          	addi	a0,a0,220 # 5a30 <malloc+0xad6>
    395c:	54a010ef          	jal	4ea6 <printf>
    exit(1);
    3960:	4505                	li	a0,1
    3962:	124010ef          	jal	4a86 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3966:	1a8010ef          	jal	4b0e <sbrk>
    396a:	064007b7          	lui	a5,0x6400
    396e:	40a7853b          	subw	a0,a5,a0
    3972:	19c010ef          	jal	4b0e <sbrk>
      write(fds[1], "x", 1);
    3976:	4605                	li	a2,1
    3978:	00001597          	auipc	a1,0x1
    397c:	79058593          	addi	a1,a1,1936 # 5108 <malloc+0x1ae>
    3980:	fb442503          	lw	a0,-76(s0)
    3984:	122010ef          	jal	4aa6 <write>
      for(;;) sleep(1000);
    3988:	3e800513          	li	a0,1000
    398c:	18a010ef          	jal	4b16 <sleep>
    3990:	bfe5                	j	3988 <sbrkfail+0x62>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3992:	0911                	addi	s2,s2,4
    3994:	03390163          	beq	s2,s3,39b6 <sbrkfail+0x90>
    if((pids[i] = fork()) == 0){
    3998:	0e6010ef          	jal	4a7e <fork>
    399c:	00a92023          	sw	a0,0(s2)
    39a0:	d179                	beqz	a0,3966 <sbrkfail+0x40>
    if(pids[i] != -1)
    39a2:	ff4508e3          	beq	a0,s4,3992 <sbrkfail+0x6c>
      read(fds[0], &scratch, 1);
    39a6:	4605                	li	a2,1
    39a8:	faf40593          	addi	a1,s0,-81
    39ac:	fb042503          	lw	a0,-80(s0)
    39b0:	0ee010ef          	jal	4a9e <read>
    39b4:	bff9                	j	3992 <sbrkfail+0x6c>
  c = sbrk(PGSIZE);
    39b6:	6505                	lui	a0,0x1
    39b8:	156010ef          	jal	4b0e <sbrk>
    39bc:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    39be:	597d                	li	s2,-1
    39c0:	a021                	j	39c8 <sbrkfail+0xa2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    39c2:	0491                	addi	s1,s1,4
    39c4:	01348b63          	beq	s1,s3,39da <sbrkfail+0xb4>
    if(pids[i] == -1)
    39c8:	4088                	lw	a0,0(s1)
    39ca:	ff250ce3          	beq	a0,s2,39c2 <sbrkfail+0x9c>
    kill(pids[i]);
    39ce:	0e8010ef          	jal	4ab6 <kill>
    wait(0);
    39d2:	4501                	li	a0,0
    39d4:	0ba010ef          	jal	4a8e <wait>
    39d8:	b7ed                	j	39c2 <sbrkfail+0x9c>
  if(c == (char*)0xffffffffffffffffL){
    39da:	57fd                	li	a5,-1
    39dc:	02fa0d63          	beq	s4,a5,3a16 <sbrkfail+0xf0>
  pid = fork();
    39e0:	09e010ef          	jal	4a7e <fork>
    39e4:	84aa                	mv	s1,a0
  if(pid < 0){
    39e6:	04054263          	bltz	a0,3a2a <sbrkfail+0x104>
  if(pid == 0){
    39ea:	c931                	beqz	a0,3a3e <sbrkfail+0x118>
  wait(&xstatus);
    39ec:	fbc40513          	addi	a0,s0,-68
    39f0:	09e010ef          	jal	4a8e <wait>
  if(xstatus != -1 && xstatus != 2)
    39f4:	fbc42783          	lw	a5,-68(s0)
    39f8:	577d                	li	a4,-1
    39fa:	00e78563          	beq	a5,a4,3a04 <sbrkfail+0xde>
    39fe:	4709                	li	a4,2
    3a00:	06e79d63          	bne	a5,a4,3a7a <sbrkfail+0x154>
}
    3a04:	70e6                	ld	ra,120(sp)
    3a06:	7446                	ld	s0,112(sp)
    3a08:	74a6                	ld	s1,104(sp)
    3a0a:	7906                	ld	s2,96(sp)
    3a0c:	69e6                	ld	s3,88(sp)
    3a0e:	6a46                	ld	s4,80(sp)
    3a10:	6aa6                	ld	s5,72(sp)
    3a12:	6109                	addi	sp,sp,128
    3a14:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3a16:	85d6                	mv	a1,s5
    3a18:	00003517          	auipc	a0,0x3
    3a1c:	16850513          	addi	a0,a0,360 # 6b80 <malloc+0x1c26>
    3a20:	486010ef          	jal	4ea6 <printf>
    exit(1);
    3a24:	4505                	li	a0,1
    3a26:	060010ef          	jal	4a86 <exit>
    printf("%s: fork failed\n", s);
    3a2a:	85d6                	mv	a1,s5
    3a2c:	00002517          	auipc	a0,0x2
    3a30:	efc50513          	addi	a0,a0,-260 # 5928 <malloc+0x9ce>
    3a34:	472010ef          	jal	4ea6 <printf>
    exit(1);
    3a38:	4505                	li	a0,1
    3a3a:	04c010ef          	jal	4a86 <exit>
    a = sbrk(0);
    3a3e:	4501                	li	a0,0
    3a40:	0ce010ef          	jal	4b0e <sbrk>
    3a44:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3a46:	3e800537          	lui	a0,0x3e800
    3a4a:	0c4010ef          	jal	4b0e <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3a4e:	87ca                	mv	a5,s2
    3a50:	3e800737          	lui	a4,0x3e800
    3a54:	993a                	add	s2,s2,a4
    3a56:	6705                	lui	a4,0x1
      n += *(a+i);
    3a58:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    3a5c:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3a5e:	97ba                	add	a5,a5,a4
    3a60:	fef91ce3          	bne	s2,a5,3a58 <sbrkfail+0x132>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    3a64:	8626                	mv	a2,s1
    3a66:	85d6                	mv	a1,s5
    3a68:	00003517          	auipc	a0,0x3
    3a6c:	13850513          	addi	a0,a0,312 # 6ba0 <malloc+0x1c46>
    3a70:	436010ef          	jal	4ea6 <printf>
    exit(1);
    3a74:	4505                	li	a0,1
    3a76:	010010ef          	jal	4a86 <exit>
    exit(1);
    3a7a:	4505                	li	a0,1
    3a7c:	00a010ef          	jal	4a86 <exit>

0000000000003a80 <mem>:
{
    3a80:	7139                	addi	sp,sp,-64
    3a82:	fc06                	sd	ra,56(sp)
    3a84:	f822                	sd	s0,48(sp)
    3a86:	f426                	sd	s1,40(sp)
    3a88:	f04a                	sd	s2,32(sp)
    3a8a:	ec4e                	sd	s3,24(sp)
    3a8c:	0080                	addi	s0,sp,64
    3a8e:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3a90:	7ef000ef          	jal	4a7e <fork>
    m1 = 0;
    3a94:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3a96:	6909                	lui	s2,0x2
    3a98:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0x79>
  if((pid = fork()) == 0){
    3a9c:	cd11                	beqz	a0,3ab8 <mem+0x38>
    wait(&xstatus);
    3a9e:	fcc40513          	addi	a0,s0,-52
    3aa2:	7ed000ef          	jal	4a8e <wait>
    if(xstatus == -1){
    3aa6:	fcc42503          	lw	a0,-52(s0)
    3aaa:	57fd                	li	a5,-1
    3aac:	04f50363          	beq	a0,a5,3af2 <mem+0x72>
    exit(xstatus);
    3ab0:	7d7000ef          	jal	4a86 <exit>
      *(char**)m2 = m1;
    3ab4:	e104                	sd	s1,0(a0)
      m1 = m2;
    3ab6:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3ab8:	854a                	mv	a0,s2
    3aba:	4a0010ef          	jal	4f5a <malloc>
    3abe:	f97d                	bnez	a0,3ab4 <mem+0x34>
    while(m1){
    3ac0:	c491                	beqz	s1,3acc <mem+0x4c>
      m2 = *(char**)m1;
    3ac2:	8526                	mv	a0,s1
    3ac4:	6084                	ld	s1,0(s1)
      free(m1);
    3ac6:	412010ef          	jal	4ed8 <free>
    while(m1){
    3aca:	fce5                	bnez	s1,3ac2 <mem+0x42>
    m1 = malloc(1024*20);
    3acc:	6515                	lui	a0,0x5
    3ace:	48c010ef          	jal	4f5a <malloc>
    if(m1 == 0){
    3ad2:	c511                	beqz	a0,3ade <mem+0x5e>
    free(m1);
    3ad4:	404010ef          	jal	4ed8 <free>
    exit(0);
    3ad8:	4501                	li	a0,0
    3ada:	7ad000ef          	jal	4a86 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3ade:	85ce                	mv	a1,s3
    3ae0:	00003517          	auipc	a0,0x3
    3ae4:	0f050513          	addi	a0,a0,240 # 6bd0 <malloc+0x1c76>
    3ae8:	3be010ef          	jal	4ea6 <printf>
      exit(1);
    3aec:	4505                	li	a0,1
    3aee:	799000ef          	jal	4a86 <exit>
      exit(0);
    3af2:	4501                	li	a0,0
    3af4:	793000ef          	jal	4a86 <exit>

0000000000003af8 <sharedfd>:
{
    3af8:	7159                	addi	sp,sp,-112
    3afa:	f486                	sd	ra,104(sp)
    3afc:	f0a2                	sd	s0,96(sp)
    3afe:	e0d2                	sd	s4,64(sp)
    3b00:	1880                	addi	s0,sp,112
    3b02:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3b04:	00003517          	auipc	a0,0x3
    3b08:	0ec50513          	addi	a0,a0,236 # 6bf0 <malloc+0x1c96>
    3b0c:	7cb000ef          	jal	4ad6 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3b10:	20200593          	li	a1,514
    3b14:	00003517          	auipc	a0,0x3
    3b18:	0dc50513          	addi	a0,a0,220 # 6bf0 <malloc+0x1c96>
    3b1c:	7ab000ef          	jal	4ac6 <open>
  if(fd < 0){
    3b20:	04054863          	bltz	a0,3b70 <sharedfd+0x78>
    3b24:	eca6                	sd	s1,88(sp)
    3b26:	e8ca                	sd	s2,80(sp)
    3b28:	e4ce                	sd	s3,72(sp)
    3b2a:	fc56                	sd	s5,56(sp)
    3b2c:	f85a                	sd	s6,48(sp)
    3b2e:	f45e                	sd	s7,40(sp)
    3b30:	892a                	mv	s2,a0
  pid = fork();
    3b32:	74d000ef          	jal	4a7e <fork>
    3b36:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3b38:	07000593          	li	a1,112
    3b3c:	e119                	bnez	a0,3b42 <sharedfd+0x4a>
    3b3e:	06300593          	li	a1,99
    3b42:	4629                	li	a2,10
    3b44:	fa040513          	addi	a0,s0,-96
    3b48:	559000ef          	jal	48a0 <memset>
    3b4c:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3b50:	4629                	li	a2,10
    3b52:	fa040593          	addi	a1,s0,-96
    3b56:	854a                	mv	a0,s2
    3b58:	74f000ef          	jal	4aa6 <write>
    3b5c:	47a9                	li	a5,10
    3b5e:	02f51963          	bne	a0,a5,3b90 <sharedfd+0x98>
  for(i = 0; i < N; i++){
    3b62:	34fd                	addiw	s1,s1,-1
    3b64:	f4f5                	bnez	s1,3b50 <sharedfd+0x58>
  if(pid == 0) {
    3b66:	02099f63          	bnez	s3,3ba4 <sharedfd+0xac>
    exit(0);
    3b6a:	4501                	li	a0,0
    3b6c:	71b000ef          	jal	4a86 <exit>
    3b70:	eca6                	sd	s1,88(sp)
    3b72:	e8ca                	sd	s2,80(sp)
    3b74:	e4ce                	sd	s3,72(sp)
    3b76:	fc56                	sd	s5,56(sp)
    3b78:	f85a                	sd	s6,48(sp)
    3b7a:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3b7c:	85d2                	mv	a1,s4
    3b7e:	00003517          	auipc	a0,0x3
    3b82:	08250513          	addi	a0,a0,130 # 6c00 <malloc+0x1ca6>
    3b86:	320010ef          	jal	4ea6 <printf>
    exit(1);
    3b8a:	4505                	li	a0,1
    3b8c:	6fb000ef          	jal	4a86 <exit>
      printf("%s: write sharedfd failed\n", s);
    3b90:	85d2                	mv	a1,s4
    3b92:	00003517          	auipc	a0,0x3
    3b96:	09650513          	addi	a0,a0,150 # 6c28 <malloc+0x1cce>
    3b9a:	30c010ef          	jal	4ea6 <printf>
      exit(1);
    3b9e:	4505                	li	a0,1
    3ba0:	6e7000ef          	jal	4a86 <exit>
    wait(&xstatus);
    3ba4:	f9c40513          	addi	a0,s0,-100
    3ba8:	6e7000ef          	jal	4a8e <wait>
    if(xstatus != 0)
    3bac:	f9c42983          	lw	s3,-100(s0)
    3bb0:	00098563          	beqz	s3,3bba <sharedfd+0xc2>
      exit(xstatus);
    3bb4:	854e                	mv	a0,s3
    3bb6:	6d1000ef          	jal	4a86 <exit>
  close(fd);
    3bba:	854a                	mv	a0,s2
    3bbc:	6f3000ef          	jal	4aae <close>
  fd = open("sharedfd", 0);
    3bc0:	4581                	li	a1,0
    3bc2:	00003517          	auipc	a0,0x3
    3bc6:	02e50513          	addi	a0,a0,46 # 6bf0 <malloc+0x1c96>
    3bca:	6fd000ef          	jal	4ac6 <open>
    3bce:	8baa                	mv	s7,a0
  nc = np = 0;
    3bd0:	8ace                	mv	s5,s3
  if(fd < 0){
    3bd2:	02054363          	bltz	a0,3bf8 <sharedfd+0x100>
    3bd6:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3bda:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3bde:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3be2:	4629                	li	a2,10
    3be4:	fa040593          	addi	a1,s0,-96
    3be8:	855e                	mv	a0,s7
    3bea:	6b5000ef          	jal	4a9e <read>
    3bee:	02a05b63          	blez	a0,3c24 <sharedfd+0x12c>
    3bf2:	fa040793          	addi	a5,s0,-96
    3bf6:	a839                	j	3c14 <sharedfd+0x11c>
    printf("%s: cannot open sharedfd for reading\n", s);
    3bf8:	85d2                	mv	a1,s4
    3bfa:	00003517          	auipc	a0,0x3
    3bfe:	04e50513          	addi	a0,a0,78 # 6c48 <malloc+0x1cee>
    3c02:	2a4010ef          	jal	4ea6 <printf>
    exit(1);
    3c06:	4505                	li	a0,1
    3c08:	67f000ef          	jal	4a86 <exit>
        nc++;
    3c0c:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3c0e:	0785                	addi	a5,a5,1
    3c10:	fd2789e3          	beq	a5,s2,3be2 <sharedfd+0xea>
      if(buf[i] == 'c')
    3c14:	0007c703          	lbu	a4,0(a5)
    3c18:	fe970ae3          	beq	a4,s1,3c0c <sharedfd+0x114>
      if(buf[i] == 'p')
    3c1c:	ff6719e3          	bne	a4,s6,3c0e <sharedfd+0x116>
        np++;
    3c20:	2a85                	addiw	s5,s5,1
    3c22:	b7f5                	j	3c0e <sharedfd+0x116>
  close(fd);
    3c24:	855e                	mv	a0,s7
    3c26:	689000ef          	jal	4aae <close>
  unlink("sharedfd");
    3c2a:	00003517          	auipc	a0,0x3
    3c2e:	fc650513          	addi	a0,a0,-58 # 6bf0 <malloc+0x1c96>
    3c32:	6a5000ef          	jal	4ad6 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3c36:	6789                	lui	a5,0x2
    3c38:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x78>
    3c3c:	00f99763          	bne	s3,a5,3c4a <sharedfd+0x152>
    3c40:	6789                	lui	a5,0x2
    3c42:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x78>
    3c46:	00fa8c63          	beq	s5,a5,3c5e <sharedfd+0x166>
    printf("%s: nc/np test fails\n", s);
    3c4a:	85d2                	mv	a1,s4
    3c4c:	00003517          	auipc	a0,0x3
    3c50:	02450513          	addi	a0,a0,36 # 6c70 <malloc+0x1d16>
    3c54:	252010ef          	jal	4ea6 <printf>
    exit(1);
    3c58:	4505                	li	a0,1
    3c5a:	62d000ef          	jal	4a86 <exit>
    exit(0);
    3c5e:	4501                	li	a0,0
    3c60:	627000ef          	jal	4a86 <exit>

0000000000003c64 <fourfiles>:
{
    3c64:	7135                	addi	sp,sp,-160
    3c66:	ed06                	sd	ra,152(sp)
    3c68:	e922                	sd	s0,144(sp)
    3c6a:	e526                	sd	s1,136(sp)
    3c6c:	e14a                	sd	s2,128(sp)
    3c6e:	fcce                	sd	s3,120(sp)
    3c70:	f8d2                	sd	s4,112(sp)
    3c72:	f4d6                	sd	s5,104(sp)
    3c74:	f0da                	sd	s6,96(sp)
    3c76:	ecde                	sd	s7,88(sp)
    3c78:	e8e2                	sd	s8,80(sp)
    3c7a:	e4e6                	sd	s9,72(sp)
    3c7c:	e0ea                	sd	s10,64(sp)
    3c7e:	fc6e                	sd	s11,56(sp)
    3c80:	1100                	addi	s0,sp,160
    3c82:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c84:	00003797          	auipc	a5,0x3
    3c88:	00478793          	addi	a5,a5,4 # 6c88 <malloc+0x1d2e>
    3c8c:	f6f43823          	sd	a5,-144(s0)
    3c90:	00003797          	auipc	a5,0x3
    3c94:	00078793          	mv	a5,a5
    3c98:	f6f43c23          	sd	a5,-136(s0)
    3c9c:	00003797          	auipc	a5,0x3
    3ca0:	ffc78793          	addi	a5,a5,-4 # 6c98 <malloc+0x1d3e>
    3ca4:	f8f43023          	sd	a5,-128(s0)
    3ca8:	00003797          	auipc	a5,0x3
    3cac:	ff878793          	addi	a5,a5,-8 # 6ca0 <malloc+0x1d46>
    3cb0:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3cb4:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3cb8:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3cba:	4481                	li	s1,0
    3cbc:	4a11                	li	s4,4
    fname = names[pi];
    3cbe:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3cc2:	854e                	mv	a0,s3
    3cc4:	613000ef          	jal	4ad6 <unlink>
    pid = fork();
    3cc8:	5b7000ef          	jal	4a7e <fork>
    if(pid < 0){
    3ccc:	02054e63          	bltz	a0,3d08 <fourfiles+0xa4>
    if(pid == 0){
    3cd0:	c531                	beqz	a0,3d1c <fourfiles+0xb8>
  for(pi = 0; pi < NCHILD; pi++){
    3cd2:	2485                	addiw	s1,s1,1
    3cd4:	0921                	addi	s2,s2,8
    3cd6:	ff4494e3          	bne	s1,s4,3cbe <fourfiles+0x5a>
    3cda:	4491                	li	s1,4
    wait(&xstatus);
    3cdc:	f6c40513          	addi	a0,s0,-148
    3ce0:	5af000ef          	jal	4a8e <wait>
    if(xstatus != 0)
    3ce4:	f6c42a83          	lw	s5,-148(s0)
    3ce8:	0a0a9463          	bnez	s5,3d90 <fourfiles+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    3cec:	34fd                	addiw	s1,s1,-1
    3cee:	f4fd                	bnez	s1,3cdc <fourfiles+0x78>
    3cf0:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3cf4:	00009a17          	auipc	s4,0x9
    3cf8:	f84a0a13          	addi	s4,s4,-124 # cc78 <buf>
    if(total != N*SZ){
    3cfc:	6d05                	lui	s10,0x1
    3cfe:	770d0d13          	addi	s10,s10,1904 # 1770 <forkfork+0x1a>
  for(i = 0; i < NCHILD; i++){
    3d02:	03400d93          	li	s11,52
    3d06:	a0ed                	j	3df0 <fourfiles+0x18c>
      printf("%s: fork failed\n", s);
    3d08:	85e6                	mv	a1,s9
    3d0a:	00002517          	auipc	a0,0x2
    3d0e:	c1e50513          	addi	a0,a0,-994 # 5928 <malloc+0x9ce>
    3d12:	194010ef          	jal	4ea6 <printf>
      exit(1);
    3d16:	4505                	li	a0,1
    3d18:	56f000ef          	jal	4a86 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3d1c:	20200593          	li	a1,514
    3d20:	854e                	mv	a0,s3
    3d22:	5a5000ef          	jal	4ac6 <open>
    3d26:	892a                	mv	s2,a0
      if(fd < 0){
    3d28:	04054163          	bltz	a0,3d6a <fourfiles+0x106>
      memset(buf, '0'+pi, SZ);
    3d2c:	1f400613          	li	a2,500
    3d30:	0304859b          	addiw	a1,s1,48
    3d34:	00009517          	auipc	a0,0x9
    3d38:	f4450513          	addi	a0,a0,-188 # cc78 <buf>
    3d3c:	365000ef          	jal	48a0 <memset>
    3d40:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3d42:	00009997          	auipc	s3,0x9
    3d46:	f3698993          	addi	s3,s3,-202 # cc78 <buf>
    3d4a:	1f400613          	li	a2,500
    3d4e:	85ce                	mv	a1,s3
    3d50:	854a                	mv	a0,s2
    3d52:	555000ef          	jal	4aa6 <write>
    3d56:	85aa                	mv	a1,a0
    3d58:	1f400793          	li	a5,500
    3d5c:	02f51163          	bne	a0,a5,3d7e <fourfiles+0x11a>
      for(i = 0; i < N; i++){
    3d60:	34fd                	addiw	s1,s1,-1
    3d62:	f4e5                	bnez	s1,3d4a <fourfiles+0xe6>
      exit(0);
    3d64:	4501                	li	a0,0
    3d66:	521000ef          	jal	4a86 <exit>
        printf("%s: create failed\n", s);
    3d6a:	85e6                	mv	a1,s9
    3d6c:	00002517          	auipc	a0,0x2
    3d70:	c5450513          	addi	a0,a0,-940 # 59c0 <malloc+0xa66>
    3d74:	132010ef          	jal	4ea6 <printf>
        exit(1);
    3d78:	4505                	li	a0,1
    3d7a:	50d000ef          	jal	4a86 <exit>
          printf("write failed %d\n", n);
    3d7e:	00003517          	auipc	a0,0x3
    3d82:	f2a50513          	addi	a0,a0,-214 # 6ca8 <malloc+0x1d4e>
    3d86:	120010ef          	jal	4ea6 <printf>
          exit(1);
    3d8a:	4505                	li	a0,1
    3d8c:	4fb000ef          	jal	4a86 <exit>
      exit(xstatus);
    3d90:	8556                	mv	a0,s5
    3d92:	4f5000ef          	jal	4a86 <exit>
          printf("%s: wrong char\n", s);
    3d96:	85e6                	mv	a1,s9
    3d98:	00003517          	auipc	a0,0x3
    3d9c:	f2850513          	addi	a0,a0,-216 # 6cc0 <malloc+0x1d66>
    3da0:	106010ef          	jal	4ea6 <printf>
          exit(1);
    3da4:	4505                	li	a0,1
    3da6:	4e1000ef          	jal	4a86 <exit>
      total += n;
    3daa:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3dae:	660d                	lui	a2,0x3
    3db0:	85d2                	mv	a1,s4
    3db2:	854e                	mv	a0,s3
    3db4:	4eb000ef          	jal	4a9e <read>
    3db8:	02a05063          	blez	a0,3dd8 <fourfiles+0x174>
    3dbc:	00009797          	auipc	a5,0x9
    3dc0:	ebc78793          	addi	a5,a5,-324 # cc78 <buf>
    3dc4:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3dc8:	0007c703          	lbu	a4,0(a5)
    3dcc:	fc9715e3          	bne	a4,s1,3d96 <fourfiles+0x132>
      for(j = 0; j < n; j++){
    3dd0:	0785                	addi	a5,a5,1
    3dd2:	fed79be3          	bne	a5,a3,3dc8 <fourfiles+0x164>
    3dd6:	bfd1                	j	3daa <fourfiles+0x146>
    close(fd);
    3dd8:	854e                	mv	a0,s3
    3dda:	4d5000ef          	jal	4aae <close>
    if(total != N*SZ){
    3dde:	03a91463          	bne	s2,s10,3e06 <fourfiles+0x1a2>
    unlink(fname);
    3de2:	8562                	mv	a0,s8
    3de4:	4f3000ef          	jal	4ad6 <unlink>
  for(i = 0; i < NCHILD; i++){
    3de8:	0ba1                	addi	s7,s7,8
    3dea:	2b05                	addiw	s6,s6,1
    3dec:	03bb0763          	beq	s6,s11,3e1a <fourfiles+0x1b6>
    fname = names[i];
    3df0:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3df4:	4581                	li	a1,0
    3df6:	8562                	mv	a0,s8
    3df8:	4cf000ef          	jal	4ac6 <open>
    3dfc:	89aa                	mv	s3,a0
    total = 0;
    3dfe:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    3e00:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3e04:	b76d                	j	3dae <fourfiles+0x14a>
      printf("wrong length %d\n", total);
    3e06:	85ca                	mv	a1,s2
    3e08:	00003517          	auipc	a0,0x3
    3e0c:	ec850513          	addi	a0,a0,-312 # 6cd0 <malloc+0x1d76>
    3e10:	096010ef          	jal	4ea6 <printf>
      exit(1);
    3e14:	4505                	li	a0,1
    3e16:	471000ef          	jal	4a86 <exit>
}
    3e1a:	60ea                	ld	ra,152(sp)
    3e1c:	644a                	ld	s0,144(sp)
    3e1e:	64aa                	ld	s1,136(sp)
    3e20:	690a                	ld	s2,128(sp)
    3e22:	79e6                	ld	s3,120(sp)
    3e24:	7a46                	ld	s4,112(sp)
    3e26:	7aa6                	ld	s5,104(sp)
    3e28:	7b06                	ld	s6,96(sp)
    3e2a:	6be6                	ld	s7,88(sp)
    3e2c:	6c46                	ld	s8,80(sp)
    3e2e:	6ca6                	ld	s9,72(sp)
    3e30:	6d06                	ld	s10,64(sp)
    3e32:	7de2                	ld	s11,56(sp)
    3e34:	610d                	addi	sp,sp,160
    3e36:	8082                	ret

0000000000003e38 <concreate>:
{
    3e38:	7135                	addi	sp,sp,-160
    3e3a:	ed06                	sd	ra,152(sp)
    3e3c:	e922                	sd	s0,144(sp)
    3e3e:	e526                	sd	s1,136(sp)
    3e40:	e14a                	sd	s2,128(sp)
    3e42:	fcce                	sd	s3,120(sp)
    3e44:	f8d2                	sd	s4,112(sp)
    3e46:	f4d6                	sd	s5,104(sp)
    3e48:	f0da                	sd	s6,96(sp)
    3e4a:	ecde                	sd	s7,88(sp)
    3e4c:	1100                	addi	s0,sp,160
    3e4e:	89aa                	mv	s3,a0
  file[0] = 'C';
    3e50:	04300793          	li	a5,67
    3e54:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3e58:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    3e5c:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    3e5e:	4b0d                	li	s6,3
    3e60:	4a85                	li	s5,1
      link("C0", file);
    3e62:	00003b97          	auipc	s7,0x3
    3e66:	e86b8b93          	addi	s7,s7,-378 # 6ce8 <malloc+0x1d8e>
  for(i = 0; i < N; i++){
    3e6a:	02800a13          	li	s4,40
    3e6e:	a41d                	j	4094 <concreate+0x25c>
      link("C0", file);
    3e70:	fa840593          	addi	a1,s0,-88
    3e74:	855e                	mv	a0,s7
    3e76:	471000ef          	jal	4ae6 <link>
    if(pid == 0) {
    3e7a:	a411                	j	407e <concreate+0x246>
    } else if(pid == 0 && (i % 5) == 1){
    3e7c:	4795                	li	a5,5
    3e7e:	02f9693b          	remw	s2,s2,a5
    3e82:	4785                	li	a5,1
    3e84:	02f90563          	beq	s2,a5,3eae <concreate+0x76>
      fd = open(file, O_CREATE | O_RDWR);
    3e88:	20200593          	li	a1,514
    3e8c:	fa840513          	addi	a0,s0,-88
    3e90:	437000ef          	jal	4ac6 <open>
      if(fd < 0){
    3e94:	1e055063          	bgez	a0,4074 <concreate+0x23c>
        printf("concreate create %s failed\n", file);
    3e98:	fa840593          	addi	a1,s0,-88
    3e9c:	00003517          	auipc	a0,0x3
    3ea0:	e5450513          	addi	a0,a0,-428 # 6cf0 <malloc+0x1d96>
    3ea4:	002010ef          	jal	4ea6 <printf>
        exit(1);
    3ea8:	4505                	li	a0,1
    3eaa:	3dd000ef          	jal	4a86 <exit>
      link("C0", file);
    3eae:	fa840593          	addi	a1,s0,-88
    3eb2:	00003517          	auipc	a0,0x3
    3eb6:	e3650513          	addi	a0,a0,-458 # 6ce8 <malloc+0x1d8e>
    3eba:	42d000ef          	jal	4ae6 <link>
      exit(0);
    3ebe:	4501                	li	a0,0
    3ec0:	3c7000ef          	jal	4a86 <exit>
        exit(1);
    3ec4:	4505                	li	a0,1
    3ec6:	3c1000ef          	jal	4a86 <exit>
  memset(fa, 0, sizeof(fa));
    3eca:	02800613          	li	a2,40
    3ece:	4581                	li	a1,0
    3ed0:	f8040513          	addi	a0,s0,-128
    3ed4:	1cd000ef          	jal	48a0 <memset>
  fd = open(".", 0);
    3ed8:	4581                	li	a1,0
    3eda:	00002517          	auipc	a0,0x2
    3ede:	8a650513          	addi	a0,a0,-1882 # 5780 <malloc+0x826>
    3ee2:	3e5000ef          	jal	4ac6 <open>
    3ee6:	892a                	mv	s2,a0
  n = 0;
    3ee8:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3eea:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    3eee:	02700b13          	li	s6,39
      fa[i] = 1;
    3ef2:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    3ef4:	4641                	li	a2,16
    3ef6:	f7040593          	addi	a1,s0,-144
    3efa:	854a                	mv	a0,s2
    3efc:	3a3000ef          	jal	4a9e <read>
    3f00:	06a05a63          	blez	a0,3f74 <concreate+0x13c>
    if(de.inum == 0)
    3f04:	f7045783          	lhu	a5,-144(s0)
    3f08:	d7f5                	beqz	a5,3ef4 <concreate+0xbc>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3f0a:	f7244783          	lbu	a5,-142(s0)
    3f0e:	ff4793e3          	bne	a5,s4,3ef4 <concreate+0xbc>
    3f12:	f7444783          	lbu	a5,-140(s0)
    3f16:	fff9                	bnez	a5,3ef4 <concreate+0xbc>
      i = de.name[1] - '0';
    3f18:	f7344783          	lbu	a5,-141(s0)
    3f1c:	fd07879b          	addiw	a5,a5,-48
    3f20:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    3f24:	02eb6063          	bltu	s6,a4,3f44 <concreate+0x10c>
      if(fa[i]){
    3f28:	fb070793          	addi	a5,a4,-80 # fb0 <bigdir+0x10e>
    3f2c:	97a2                	add	a5,a5,s0
    3f2e:	fd07c783          	lbu	a5,-48(a5)
    3f32:	e78d                	bnez	a5,3f5c <concreate+0x124>
      fa[i] = 1;
    3f34:	fb070793          	addi	a5,a4,-80
    3f38:	00878733          	add	a4,a5,s0
    3f3c:	fd770823          	sb	s7,-48(a4)
      n++;
    3f40:	2a85                	addiw	s5,s5,1
    3f42:	bf4d                	j	3ef4 <concreate+0xbc>
        printf("%s: concreate weird file %s\n", s, de.name);
    3f44:	f7240613          	addi	a2,s0,-142
    3f48:	85ce                	mv	a1,s3
    3f4a:	00003517          	auipc	a0,0x3
    3f4e:	dc650513          	addi	a0,a0,-570 # 6d10 <malloc+0x1db6>
    3f52:	755000ef          	jal	4ea6 <printf>
        exit(1);
    3f56:	4505                	li	a0,1
    3f58:	32f000ef          	jal	4a86 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3f5c:	f7240613          	addi	a2,s0,-142
    3f60:	85ce                	mv	a1,s3
    3f62:	00003517          	auipc	a0,0x3
    3f66:	dce50513          	addi	a0,a0,-562 # 6d30 <malloc+0x1dd6>
    3f6a:	73d000ef          	jal	4ea6 <printf>
        exit(1);
    3f6e:	4505                	li	a0,1
    3f70:	317000ef          	jal	4a86 <exit>
  close(fd);
    3f74:	854a                	mv	a0,s2
    3f76:	339000ef          	jal	4aae <close>
  if(n != N){
    3f7a:	02800793          	li	a5,40
    3f7e:	00fa9763          	bne	s5,a5,3f8c <concreate+0x154>
    if(((i % 3) == 0 && pid == 0) ||
    3f82:	4a8d                	li	s5,3
    3f84:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    3f86:	02800a13          	li	s4,40
    3f8a:	a079                	j	4018 <concreate+0x1e0>
    printf("%s: concreate not enough files in directory listing\n", s);
    3f8c:	85ce                	mv	a1,s3
    3f8e:	00003517          	auipc	a0,0x3
    3f92:	dca50513          	addi	a0,a0,-566 # 6d58 <malloc+0x1dfe>
    3f96:	711000ef          	jal	4ea6 <printf>
    exit(1);
    3f9a:	4505                	li	a0,1
    3f9c:	2eb000ef          	jal	4a86 <exit>
      printf("%s: fork failed\n", s);
    3fa0:	85ce                	mv	a1,s3
    3fa2:	00002517          	auipc	a0,0x2
    3fa6:	98650513          	addi	a0,a0,-1658 # 5928 <malloc+0x9ce>
    3faa:	6fd000ef          	jal	4ea6 <printf>
      exit(1);
    3fae:	4505                	li	a0,1
    3fb0:	2d7000ef          	jal	4a86 <exit>
      close(open(file, 0));
    3fb4:	4581                	li	a1,0
    3fb6:	fa840513          	addi	a0,s0,-88
    3fba:	30d000ef          	jal	4ac6 <open>
    3fbe:	2f1000ef          	jal	4aae <close>
      close(open(file, 0));
    3fc2:	4581                	li	a1,0
    3fc4:	fa840513          	addi	a0,s0,-88
    3fc8:	2ff000ef          	jal	4ac6 <open>
    3fcc:	2e3000ef          	jal	4aae <close>
      close(open(file, 0));
    3fd0:	4581                	li	a1,0
    3fd2:	fa840513          	addi	a0,s0,-88
    3fd6:	2f1000ef          	jal	4ac6 <open>
    3fda:	2d5000ef          	jal	4aae <close>
      close(open(file, 0));
    3fde:	4581                	li	a1,0
    3fe0:	fa840513          	addi	a0,s0,-88
    3fe4:	2e3000ef          	jal	4ac6 <open>
    3fe8:	2c7000ef          	jal	4aae <close>
      close(open(file, 0));
    3fec:	4581                	li	a1,0
    3fee:	fa840513          	addi	a0,s0,-88
    3ff2:	2d5000ef          	jal	4ac6 <open>
    3ff6:	2b9000ef          	jal	4aae <close>
      close(open(file, 0));
    3ffa:	4581                	li	a1,0
    3ffc:	fa840513          	addi	a0,s0,-88
    4000:	2c7000ef          	jal	4ac6 <open>
    4004:	2ab000ef          	jal	4aae <close>
    if(pid == 0)
    4008:	06090363          	beqz	s2,406e <concreate+0x236>
      wait(0);
    400c:	4501                	li	a0,0
    400e:	281000ef          	jal	4a8e <wait>
  for(i = 0; i < N; i++){
    4012:	2485                	addiw	s1,s1,1
    4014:	0b448963          	beq	s1,s4,40c6 <concreate+0x28e>
    file[1] = '0' + i;
    4018:	0304879b          	addiw	a5,s1,48
    401c:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    4020:	25f000ef          	jal	4a7e <fork>
    4024:	892a                	mv	s2,a0
    if(pid < 0){
    4026:	f6054de3          	bltz	a0,3fa0 <concreate+0x168>
    if(((i % 3) == 0 && pid == 0) ||
    402a:	0354e73b          	remw	a4,s1,s5
    402e:	00a767b3          	or	a5,a4,a0
    4032:	2781                	sext.w	a5,a5
    4034:	d3c1                	beqz	a5,3fb4 <concreate+0x17c>
    4036:	01671363          	bne	a4,s6,403c <concreate+0x204>
       ((i % 3) == 1 && pid != 0)){
    403a:	fd2d                	bnez	a0,3fb4 <concreate+0x17c>
      unlink(file);
    403c:	fa840513          	addi	a0,s0,-88
    4040:	297000ef          	jal	4ad6 <unlink>
      unlink(file);
    4044:	fa840513          	addi	a0,s0,-88
    4048:	28f000ef          	jal	4ad6 <unlink>
      unlink(file);
    404c:	fa840513          	addi	a0,s0,-88
    4050:	287000ef          	jal	4ad6 <unlink>
      unlink(file);
    4054:	fa840513          	addi	a0,s0,-88
    4058:	27f000ef          	jal	4ad6 <unlink>
      unlink(file);
    405c:	fa840513          	addi	a0,s0,-88
    4060:	277000ef          	jal	4ad6 <unlink>
      unlink(file);
    4064:	fa840513          	addi	a0,s0,-88
    4068:	26f000ef          	jal	4ad6 <unlink>
    406c:	bf71                	j	4008 <concreate+0x1d0>
      exit(0);
    406e:	4501                	li	a0,0
    4070:	217000ef          	jal	4a86 <exit>
      close(fd);
    4074:	23b000ef          	jal	4aae <close>
    if(pid == 0) {
    4078:	b599                	j	3ebe <concreate+0x86>
      close(fd);
    407a:	235000ef          	jal	4aae <close>
      wait(&xstatus);
    407e:	f6c40513          	addi	a0,s0,-148
    4082:	20d000ef          	jal	4a8e <wait>
      if(xstatus != 0)
    4086:	f6c42483          	lw	s1,-148(s0)
    408a:	e2049de3          	bnez	s1,3ec4 <concreate+0x8c>
  for(i = 0; i < N; i++){
    408e:	2905                	addiw	s2,s2,1
    4090:	e3490de3          	beq	s2,s4,3eca <concreate+0x92>
    file[1] = '0' + i;
    4094:	0309079b          	addiw	a5,s2,48
    4098:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    409c:	fa840513          	addi	a0,s0,-88
    40a0:	237000ef          	jal	4ad6 <unlink>
    pid = fork();
    40a4:	1db000ef          	jal	4a7e <fork>
    if(pid && (i % 3) == 1){
    40a8:	dc050ae3          	beqz	a0,3e7c <concreate+0x44>
    40ac:	036967bb          	remw	a5,s2,s6
    40b0:	dd5780e3          	beq	a5,s5,3e70 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    40b4:	20200593          	li	a1,514
    40b8:	fa840513          	addi	a0,s0,-88
    40bc:	20b000ef          	jal	4ac6 <open>
      if(fd < 0){
    40c0:	fa055de3          	bgez	a0,407a <concreate+0x242>
    40c4:	bbd1                	j	3e98 <concreate+0x60>
}
    40c6:	60ea                	ld	ra,152(sp)
    40c8:	644a                	ld	s0,144(sp)
    40ca:	64aa                	ld	s1,136(sp)
    40cc:	690a                	ld	s2,128(sp)
    40ce:	79e6                	ld	s3,120(sp)
    40d0:	7a46                	ld	s4,112(sp)
    40d2:	7aa6                	ld	s5,104(sp)
    40d4:	7b06                	ld	s6,96(sp)
    40d6:	6be6                	ld	s7,88(sp)
    40d8:	610d                	addi	sp,sp,160
    40da:	8082                	ret

00000000000040dc <bigfile>:
{
    40dc:	7139                	addi	sp,sp,-64
    40de:	fc06                	sd	ra,56(sp)
    40e0:	f822                	sd	s0,48(sp)
    40e2:	f426                	sd	s1,40(sp)
    40e4:	f04a                	sd	s2,32(sp)
    40e6:	ec4e                	sd	s3,24(sp)
    40e8:	e852                	sd	s4,16(sp)
    40ea:	e456                	sd	s5,8(sp)
    40ec:	0080                	addi	s0,sp,64
    40ee:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    40f0:	00003517          	auipc	a0,0x3
    40f4:	ca050513          	addi	a0,a0,-864 # 6d90 <malloc+0x1e36>
    40f8:	1df000ef          	jal	4ad6 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    40fc:	20200593          	li	a1,514
    4100:	00003517          	auipc	a0,0x3
    4104:	c9050513          	addi	a0,a0,-880 # 6d90 <malloc+0x1e36>
    4108:	1bf000ef          	jal	4ac6 <open>
    410c:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    410e:	4481                	li	s1,0
    memset(buf, i, SZ);
    4110:	00009917          	auipc	s2,0x9
    4114:	b6890913          	addi	s2,s2,-1176 # cc78 <buf>
  for(i = 0; i < N; i++){
    4118:	4a51                	li	s4,20
  if(fd < 0){
    411a:	08054663          	bltz	a0,41a6 <bigfile+0xca>
    memset(buf, i, SZ);
    411e:	25800613          	li	a2,600
    4122:	85a6                	mv	a1,s1
    4124:	854a                	mv	a0,s2
    4126:	77a000ef          	jal	48a0 <memset>
    if(write(fd, buf, SZ) != SZ){
    412a:	25800613          	li	a2,600
    412e:	85ca                	mv	a1,s2
    4130:	854e                	mv	a0,s3
    4132:	175000ef          	jal	4aa6 <write>
    4136:	25800793          	li	a5,600
    413a:	08f51063          	bne	a0,a5,41ba <bigfile+0xde>
  for(i = 0; i < N; i++){
    413e:	2485                	addiw	s1,s1,1
    4140:	fd449fe3          	bne	s1,s4,411e <bigfile+0x42>
  close(fd);
    4144:	854e                	mv	a0,s3
    4146:	169000ef          	jal	4aae <close>
  fd = open("bigfile.dat", 0);
    414a:	4581                	li	a1,0
    414c:	00003517          	auipc	a0,0x3
    4150:	c4450513          	addi	a0,a0,-956 # 6d90 <malloc+0x1e36>
    4154:	173000ef          	jal	4ac6 <open>
    4158:	8a2a                	mv	s4,a0
  total = 0;
    415a:	4981                	li	s3,0
  for(i = 0; ; i++){
    415c:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    415e:	00009917          	auipc	s2,0x9
    4162:	b1a90913          	addi	s2,s2,-1254 # cc78 <buf>
  if(fd < 0){
    4166:	06054463          	bltz	a0,41ce <bigfile+0xf2>
    cc = read(fd, buf, SZ/2);
    416a:	12c00613          	li	a2,300
    416e:	85ca                	mv	a1,s2
    4170:	8552                	mv	a0,s4
    4172:	12d000ef          	jal	4a9e <read>
    if(cc < 0){
    4176:	06054663          	bltz	a0,41e2 <bigfile+0x106>
    if(cc == 0)
    417a:	c155                	beqz	a0,421e <bigfile+0x142>
    if(cc != SZ/2){
    417c:	12c00793          	li	a5,300
    4180:	06f51b63          	bne	a0,a5,41f6 <bigfile+0x11a>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4184:	01f4d79b          	srliw	a5,s1,0x1f
    4188:	9fa5                	addw	a5,a5,s1
    418a:	4017d79b          	sraiw	a5,a5,0x1
    418e:	00094703          	lbu	a4,0(s2)
    4192:	06f71c63          	bne	a4,a5,420a <bigfile+0x12e>
    4196:	12b94703          	lbu	a4,299(s2)
    419a:	06f71863          	bne	a4,a5,420a <bigfile+0x12e>
    total += cc;
    419e:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    41a2:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    41a4:	b7d9                	j	416a <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    41a6:	85d6                	mv	a1,s5
    41a8:	00003517          	auipc	a0,0x3
    41ac:	bf850513          	addi	a0,a0,-1032 # 6da0 <malloc+0x1e46>
    41b0:	4f7000ef          	jal	4ea6 <printf>
    exit(1);
    41b4:	4505                	li	a0,1
    41b6:	0d1000ef          	jal	4a86 <exit>
      printf("%s: write bigfile failed\n", s);
    41ba:	85d6                	mv	a1,s5
    41bc:	00003517          	auipc	a0,0x3
    41c0:	c0450513          	addi	a0,a0,-1020 # 6dc0 <malloc+0x1e66>
    41c4:	4e3000ef          	jal	4ea6 <printf>
      exit(1);
    41c8:	4505                	li	a0,1
    41ca:	0bd000ef          	jal	4a86 <exit>
    printf("%s: cannot open bigfile\n", s);
    41ce:	85d6                	mv	a1,s5
    41d0:	00003517          	auipc	a0,0x3
    41d4:	c1050513          	addi	a0,a0,-1008 # 6de0 <malloc+0x1e86>
    41d8:	4cf000ef          	jal	4ea6 <printf>
    exit(1);
    41dc:	4505                	li	a0,1
    41de:	0a9000ef          	jal	4a86 <exit>
      printf("%s: read bigfile failed\n", s);
    41e2:	85d6                	mv	a1,s5
    41e4:	00003517          	auipc	a0,0x3
    41e8:	c1c50513          	addi	a0,a0,-996 # 6e00 <malloc+0x1ea6>
    41ec:	4bb000ef          	jal	4ea6 <printf>
      exit(1);
    41f0:	4505                	li	a0,1
    41f2:	095000ef          	jal	4a86 <exit>
      printf("%s: short read bigfile\n", s);
    41f6:	85d6                	mv	a1,s5
    41f8:	00003517          	auipc	a0,0x3
    41fc:	c2850513          	addi	a0,a0,-984 # 6e20 <malloc+0x1ec6>
    4200:	4a7000ef          	jal	4ea6 <printf>
      exit(1);
    4204:	4505                	li	a0,1
    4206:	081000ef          	jal	4a86 <exit>
      printf("%s: read bigfile wrong data\n", s);
    420a:	85d6                	mv	a1,s5
    420c:	00003517          	auipc	a0,0x3
    4210:	c2c50513          	addi	a0,a0,-980 # 6e38 <malloc+0x1ede>
    4214:	493000ef          	jal	4ea6 <printf>
      exit(1);
    4218:	4505                	li	a0,1
    421a:	06d000ef          	jal	4a86 <exit>
  close(fd);
    421e:	8552                	mv	a0,s4
    4220:	08f000ef          	jal	4aae <close>
  if(total != N*SZ){
    4224:	678d                	lui	a5,0x3
    4226:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x2fe>
    422a:	02f99163          	bne	s3,a5,424c <bigfile+0x170>
  unlink("bigfile.dat");
    422e:	00003517          	auipc	a0,0x3
    4232:	b6250513          	addi	a0,a0,-1182 # 6d90 <malloc+0x1e36>
    4236:	0a1000ef          	jal	4ad6 <unlink>
}
    423a:	70e2                	ld	ra,56(sp)
    423c:	7442                	ld	s0,48(sp)
    423e:	74a2                	ld	s1,40(sp)
    4240:	7902                	ld	s2,32(sp)
    4242:	69e2                	ld	s3,24(sp)
    4244:	6a42                	ld	s4,16(sp)
    4246:	6aa2                	ld	s5,8(sp)
    4248:	6121                	addi	sp,sp,64
    424a:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    424c:	85d6                	mv	a1,s5
    424e:	00003517          	auipc	a0,0x3
    4252:	c0a50513          	addi	a0,a0,-1014 # 6e58 <malloc+0x1efe>
    4256:	451000ef          	jal	4ea6 <printf>
    exit(1);
    425a:	4505                	li	a0,1
    425c:	02b000ef          	jal	4a86 <exit>

0000000000004260 <bigargtest>:
{
    4260:	7121                	addi	sp,sp,-448
    4262:	ff06                	sd	ra,440(sp)
    4264:	fb22                	sd	s0,432(sp)
    4266:	f726                	sd	s1,424(sp)
    4268:	0380                	addi	s0,sp,448
    426a:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    426c:	00003517          	auipc	a0,0x3
    4270:	c0c50513          	addi	a0,a0,-1012 # 6e78 <malloc+0x1f1e>
    4274:	063000ef          	jal	4ad6 <unlink>
  pid = fork();
    4278:	007000ef          	jal	4a7e <fork>
  if(pid == 0){
    427c:	c915                	beqz	a0,42b0 <bigargtest+0x50>
  } else if(pid < 0){
    427e:	08054a63          	bltz	a0,4312 <bigargtest+0xb2>
  wait(&xstatus);
    4282:	fdc40513          	addi	a0,s0,-36
    4286:	009000ef          	jal	4a8e <wait>
  if(xstatus != 0)
    428a:	fdc42503          	lw	a0,-36(s0)
    428e:	ed41                	bnez	a0,4326 <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    4290:	4581                	li	a1,0
    4292:	00003517          	auipc	a0,0x3
    4296:	be650513          	addi	a0,a0,-1050 # 6e78 <malloc+0x1f1e>
    429a:	02d000ef          	jal	4ac6 <open>
  if(fd < 0){
    429e:	08054663          	bltz	a0,432a <bigargtest+0xca>
  close(fd);
    42a2:	00d000ef          	jal	4aae <close>
}
    42a6:	70fa                	ld	ra,440(sp)
    42a8:	745a                	ld	s0,432(sp)
    42aa:	74ba                	ld	s1,424(sp)
    42ac:	6139                	addi	sp,sp,448
    42ae:	8082                	ret
    memset(big, ' ', sizeof(big));
    42b0:	19000613          	li	a2,400
    42b4:	02000593          	li	a1,32
    42b8:	e4840513          	addi	a0,s0,-440
    42bc:	5e4000ef          	jal	48a0 <memset>
    big[sizeof(big)-1] = '\0';
    42c0:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    42c4:	00005797          	auipc	a5,0x5
    42c8:	19c78793          	addi	a5,a5,412 # 9460 <args.1>
    42cc:	00005697          	auipc	a3,0x5
    42d0:	28c68693          	addi	a3,a3,652 # 9558 <args.1+0xf8>
      args[i] = big;
    42d4:	e4840713          	addi	a4,s0,-440
    42d8:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    42da:	07a1                	addi	a5,a5,8
    42dc:	fed79ee3          	bne	a5,a3,42d8 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    42e0:	00005597          	auipc	a1,0x5
    42e4:	18058593          	addi	a1,a1,384 # 9460 <args.1>
    42e8:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    42ec:	00001517          	auipc	a0,0x1
    42f0:	dac50513          	addi	a0,a0,-596 # 5098 <malloc+0x13e>
    42f4:	7ca000ef          	jal	4abe <exec>
    fd = open("bigarg-ok", O_CREATE);
    42f8:	20000593          	li	a1,512
    42fc:	00003517          	auipc	a0,0x3
    4300:	b7c50513          	addi	a0,a0,-1156 # 6e78 <malloc+0x1f1e>
    4304:	7c2000ef          	jal	4ac6 <open>
    close(fd);
    4308:	7a6000ef          	jal	4aae <close>
    exit(0);
    430c:	4501                	li	a0,0
    430e:	778000ef          	jal	4a86 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    4312:	85a6                	mv	a1,s1
    4314:	00003517          	auipc	a0,0x3
    4318:	b7450513          	addi	a0,a0,-1164 # 6e88 <malloc+0x1f2e>
    431c:	38b000ef          	jal	4ea6 <printf>
    exit(1);
    4320:	4505                	li	a0,1
    4322:	764000ef          	jal	4a86 <exit>
    exit(xstatus);
    4326:	760000ef          	jal	4a86 <exit>
    printf("%s: bigarg test failed!\n", s);
    432a:	85a6                	mv	a1,s1
    432c:	00003517          	auipc	a0,0x3
    4330:	b7c50513          	addi	a0,a0,-1156 # 6ea8 <malloc+0x1f4e>
    4334:	373000ef          	jal	4ea6 <printf>
    exit(1);
    4338:	4505                	li	a0,1
    433a:	74c000ef          	jal	4a86 <exit>

000000000000433e <fsfull>:
{
    433e:	7135                	addi	sp,sp,-160
    4340:	ed06                	sd	ra,152(sp)
    4342:	e922                	sd	s0,144(sp)
    4344:	e526                	sd	s1,136(sp)
    4346:	e14a                	sd	s2,128(sp)
    4348:	fcce                	sd	s3,120(sp)
    434a:	f8d2                	sd	s4,112(sp)
    434c:	f4d6                	sd	s5,104(sp)
    434e:	f0da                	sd	s6,96(sp)
    4350:	ecde                	sd	s7,88(sp)
    4352:	e8e2                	sd	s8,80(sp)
    4354:	e4e6                	sd	s9,72(sp)
    4356:	e0ea                	sd	s10,64(sp)
    4358:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    435a:	00003517          	auipc	a0,0x3
    435e:	b6e50513          	addi	a0,a0,-1170 # 6ec8 <malloc+0x1f6e>
    4362:	345000ef          	jal	4ea6 <printf>
  for(nfiles = 0; ; nfiles++){
    4366:	4481                	li	s1,0
    name[0] = 'f';
    4368:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    436c:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    4370:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    4374:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4376:	00003c97          	auipc	s9,0x3
    437a:	b62c8c93          	addi	s9,s9,-1182 # 6ed8 <malloc+0x1f7e>
    name[0] = 'f';
    437e:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4382:	0384c7bb          	divw	a5,s1,s8
    4386:	0307879b          	addiw	a5,a5,48
    438a:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    438e:	0384e7bb          	remw	a5,s1,s8
    4392:	0377c7bb          	divw	a5,a5,s7
    4396:	0307879b          	addiw	a5,a5,48
    439a:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    439e:	0374e7bb          	remw	a5,s1,s7
    43a2:	0367c7bb          	divw	a5,a5,s6
    43a6:	0307879b          	addiw	a5,a5,48
    43aa:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    43ae:	0364e7bb          	remw	a5,s1,s6
    43b2:	0307879b          	addiw	a5,a5,48
    43b6:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    43ba:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    43be:	f6040593          	addi	a1,s0,-160
    43c2:	8566                	mv	a0,s9
    43c4:	2e3000ef          	jal	4ea6 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    43c8:	20200593          	li	a1,514
    43cc:	f6040513          	addi	a0,s0,-160
    43d0:	6f6000ef          	jal	4ac6 <open>
    43d4:	892a                	mv	s2,a0
    if(fd < 0){
    43d6:	08055f63          	bgez	a0,4474 <fsfull+0x136>
      printf("open %s failed\n", name);
    43da:	f6040593          	addi	a1,s0,-160
    43de:	00003517          	auipc	a0,0x3
    43e2:	b0a50513          	addi	a0,a0,-1270 # 6ee8 <malloc+0x1f8e>
    43e6:	2c1000ef          	jal	4ea6 <printf>
  while(nfiles >= 0){
    43ea:	0604c163          	bltz	s1,444c <fsfull+0x10e>
    name[0] = 'f';
    43ee:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    43f2:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    43f6:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    43fa:	4929                	li	s2,10
  while(nfiles >= 0){
    43fc:	5afd                	li	s5,-1
    name[0] = 'f';
    43fe:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    4402:	0344c7bb          	divw	a5,s1,s4
    4406:	0307879b          	addiw	a5,a5,48
    440a:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    440e:	0344e7bb          	remw	a5,s1,s4
    4412:	0337c7bb          	divw	a5,a5,s3
    4416:	0307879b          	addiw	a5,a5,48
    441a:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    441e:	0334e7bb          	remw	a5,s1,s3
    4422:	0327c7bb          	divw	a5,a5,s2
    4426:	0307879b          	addiw	a5,a5,48
    442a:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    442e:	0324e7bb          	remw	a5,s1,s2
    4432:	0307879b          	addiw	a5,a5,48
    4436:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    443a:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    443e:	f6040513          	addi	a0,s0,-160
    4442:	694000ef          	jal	4ad6 <unlink>
    nfiles--;
    4446:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4448:	fb549be3          	bne	s1,s5,43fe <fsfull+0xc0>
  printf("fsfull test finished\n");
    444c:	00003517          	auipc	a0,0x3
    4450:	abc50513          	addi	a0,a0,-1348 # 6f08 <malloc+0x1fae>
    4454:	253000ef          	jal	4ea6 <printf>
}
    4458:	60ea                	ld	ra,152(sp)
    445a:	644a                	ld	s0,144(sp)
    445c:	64aa                	ld	s1,136(sp)
    445e:	690a                	ld	s2,128(sp)
    4460:	79e6                	ld	s3,120(sp)
    4462:	7a46                	ld	s4,112(sp)
    4464:	7aa6                	ld	s5,104(sp)
    4466:	7b06                	ld	s6,96(sp)
    4468:	6be6                	ld	s7,88(sp)
    446a:	6c46                	ld	s8,80(sp)
    446c:	6ca6                	ld	s9,72(sp)
    446e:	6d06                	ld	s10,64(sp)
    4470:	610d                	addi	sp,sp,160
    4472:	8082                	ret
    int total = 0;
    4474:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4476:	00009a97          	auipc	s5,0x9
    447a:	802a8a93          	addi	s5,s5,-2046 # cc78 <buf>
      if(cc < BSIZE)
    447e:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    4482:	40000613          	li	a2,1024
    4486:	85d6                	mv	a1,s5
    4488:	854a                	mv	a0,s2
    448a:	61c000ef          	jal	4aa6 <write>
      if(cc < BSIZE)
    448e:	00aa5563          	bge	s4,a0,4498 <fsfull+0x15a>
      total += cc;
    4492:	00a989bb          	addw	s3,s3,a0
    while(1){
    4496:	b7f5                	j	4482 <fsfull+0x144>
    printf("wrote %d bytes\n", total);
    4498:	85ce                	mv	a1,s3
    449a:	00003517          	auipc	a0,0x3
    449e:	a5e50513          	addi	a0,a0,-1442 # 6ef8 <malloc+0x1f9e>
    44a2:	205000ef          	jal	4ea6 <printf>
    close(fd);
    44a6:	854a                	mv	a0,s2
    44a8:	606000ef          	jal	4aae <close>
    if(total == 0)
    44ac:	f2098fe3          	beqz	s3,43ea <fsfull+0xac>
  for(nfiles = 0; ; nfiles++){
    44b0:	2485                	addiw	s1,s1,1
    44b2:	b5f1                	j	437e <fsfull+0x40>

00000000000044b4 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    44b4:	7179                	addi	sp,sp,-48
    44b6:	f406                	sd	ra,40(sp)
    44b8:	f022                	sd	s0,32(sp)
    44ba:	ec26                	sd	s1,24(sp)
    44bc:	e84a                	sd	s2,16(sp)
    44be:	1800                	addi	s0,sp,48
    44c0:	84aa                	mv	s1,a0
    44c2:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    44c4:	00003517          	auipc	a0,0x3
    44c8:	a5c50513          	addi	a0,a0,-1444 # 6f20 <malloc+0x1fc6>
    44cc:	1db000ef          	jal	4ea6 <printf>
  if((pid = fork()) < 0) {
    44d0:	5ae000ef          	jal	4a7e <fork>
    44d4:	02054a63          	bltz	a0,4508 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    44d8:	c129                	beqz	a0,451a <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    44da:	fdc40513          	addi	a0,s0,-36
    44de:	5b0000ef          	jal	4a8e <wait>
    if(xstatus != 0) 
    44e2:	fdc42783          	lw	a5,-36(s0)
    44e6:	cf9d                	beqz	a5,4524 <run+0x70>
      printf("FAILED\n");
    44e8:	00003517          	auipc	a0,0x3
    44ec:	a6050513          	addi	a0,a0,-1440 # 6f48 <malloc+0x1fee>
    44f0:	1b7000ef          	jal	4ea6 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    44f4:	fdc42503          	lw	a0,-36(s0)
  }
}
    44f8:	00153513          	seqz	a0,a0
    44fc:	70a2                	ld	ra,40(sp)
    44fe:	7402                	ld	s0,32(sp)
    4500:	64e2                	ld	s1,24(sp)
    4502:	6942                	ld	s2,16(sp)
    4504:	6145                	addi	sp,sp,48
    4506:	8082                	ret
    printf("runtest: fork error\n");
    4508:	00003517          	auipc	a0,0x3
    450c:	a2850513          	addi	a0,a0,-1496 # 6f30 <malloc+0x1fd6>
    4510:	197000ef          	jal	4ea6 <printf>
    exit(1);
    4514:	4505                	li	a0,1
    4516:	570000ef          	jal	4a86 <exit>
    f(s);
    451a:	854a                	mv	a0,s2
    451c:	9482                	jalr	s1
    exit(0);
    451e:	4501                	li	a0,0
    4520:	566000ef          	jal	4a86 <exit>
      printf("OK\n");
    4524:	00003517          	auipc	a0,0x3
    4528:	a2c50513          	addi	a0,a0,-1492 # 6f50 <malloc+0x1ff6>
    452c:	17b000ef          	jal	4ea6 <printf>
    4530:	b7d1                	j	44f4 <run+0x40>

0000000000004532 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    4532:	7139                	addi	sp,sp,-64
    4534:	fc06                	sd	ra,56(sp)
    4536:	f822                	sd	s0,48(sp)
    4538:	f04a                	sd	s2,32(sp)
    453a:	0080                	addi	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
    453c:	00853903          	ld	s2,8(a0)
    4540:	06090463          	beqz	s2,45a8 <runtests+0x76>
    4544:	f426                	sd	s1,40(sp)
    4546:	ec4e                	sd	s3,24(sp)
    4548:	e852                	sd	s4,16(sp)
    454a:	e456                	sd	s5,8(sp)
    454c:	84aa                	mv	s1,a0
    454e:	89ae                	mv	s3,a1
    4550:	8a32                	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    4552:	4a89                	li	s5,2
    4554:	a031                	j	4560 <runtests+0x2e>
  for (struct test *t = tests; t->s != 0; t++) {
    4556:	04c1                	addi	s1,s1,16
    4558:	0084b903          	ld	s2,8(s1)
    455c:	02090c63          	beqz	s2,4594 <runtests+0x62>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    4560:	00098763          	beqz	s3,456e <runtests+0x3c>
    4564:	85ce                	mv	a1,s3
    4566:	854a                	mv	a0,s2
    4568:	2e2000ef          	jal	484a <strcmp>
    456c:	f56d                	bnez	a0,4556 <runtests+0x24>
      if(!run(t->f, t->s)){
    456e:	85ca                	mv	a1,s2
    4570:	6088                	ld	a0,0(s1)
    4572:	f43ff0ef          	jal	44b4 <run>
    4576:	f165                	bnez	a0,4556 <runtests+0x24>
        if(continuous != 2){
    4578:	fd5a0fe3          	beq	s4,s5,4556 <runtests+0x24>
          printf("SOME TESTS FAILED\n");
    457c:	00003517          	auipc	a0,0x3
    4580:	9dc50513          	addi	a0,a0,-1572 # 6f58 <malloc+0x1ffe>
    4584:	123000ef          	jal	4ea6 <printf>
          return 1;
    4588:	4505                	li	a0,1
    458a:	74a2                	ld	s1,40(sp)
    458c:	69e2                	ld	s3,24(sp)
    458e:	6a42                	ld	s4,16(sp)
    4590:	6aa2                	ld	s5,8(sp)
    4592:	a031                	j	459e <runtests+0x6c>
        }
      }
    }
  }
  return 0;
    4594:	4501                	li	a0,0
    4596:	74a2                	ld	s1,40(sp)
    4598:	69e2                	ld	s3,24(sp)
    459a:	6a42                	ld	s4,16(sp)
    459c:	6aa2                	ld	s5,8(sp)
}
    459e:	70e2                	ld	ra,56(sp)
    45a0:	7442                	ld	s0,48(sp)
    45a2:	7902                	ld	s2,32(sp)
    45a4:	6121                	addi	sp,sp,64
    45a6:	8082                	ret
  return 0;
    45a8:	4501                	li	a0,0
    45aa:	bfd5                	j	459e <runtests+0x6c>

00000000000045ac <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    45ac:	7139                	addi	sp,sp,-64
    45ae:	fc06                	sd	ra,56(sp)
    45b0:	f822                	sd	s0,48(sp)
    45b2:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    45b4:	fc840513          	addi	a0,s0,-56
    45b8:	4de000ef          	jal	4a96 <pipe>
    45bc:	04054e63          	bltz	a0,4618 <countfree+0x6c>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    45c0:	4be000ef          	jal	4a7e <fork>

  if(pid < 0){
    45c4:	06054663          	bltz	a0,4630 <countfree+0x84>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    45c8:	e159                	bnez	a0,464e <countfree+0xa2>
    45ca:	f426                	sd	s1,40(sp)
    45cc:	f04a                	sd	s2,32(sp)
    45ce:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    45d0:	fc842503          	lw	a0,-56(s0)
    45d4:	4da000ef          	jal	4aae <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    45d8:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    45da:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    45dc:	00001997          	auipc	s3,0x1
    45e0:	b2c98993          	addi	s3,s3,-1236 # 5108 <malloc+0x1ae>
      uint64 a = (uint64) sbrk(4096);
    45e4:	6505                	lui	a0,0x1
    45e6:	528000ef          	jal	4b0e <sbrk>
      if(a == 0xffffffffffffffff){
    45ea:	05250f63          	beq	a0,s2,4648 <countfree+0x9c>
      *(char *)(a + 4096 - 1) = 1;
    45ee:	6785                	lui	a5,0x1
    45f0:	97aa                	add	a5,a5,a0
    45f2:	fe978fa3          	sb	s1,-1(a5) # fff <pgbug+0x27>
      if(write(fds[1], "x", 1) != 1){
    45f6:	8626                	mv	a2,s1
    45f8:	85ce                	mv	a1,s3
    45fa:	fcc42503          	lw	a0,-52(s0)
    45fe:	4a8000ef          	jal	4aa6 <write>
    4602:	fe9501e3          	beq	a0,s1,45e4 <countfree+0x38>
        printf("write() failed in countfree()\n");
    4606:	00003517          	auipc	a0,0x3
    460a:	9aa50513          	addi	a0,a0,-1622 # 6fb0 <malloc+0x2056>
    460e:	099000ef          	jal	4ea6 <printf>
        exit(1);
    4612:	4505                	li	a0,1
    4614:	472000ef          	jal	4a86 <exit>
    4618:	f426                	sd	s1,40(sp)
    461a:	f04a                	sd	s2,32(sp)
    461c:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    461e:	00003517          	auipc	a0,0x3
    4622:	95250513          	addi	a0,a0,-1710 # 6f70 <malloc+0x2016>
    4626:	081000ef          	jal	4ea6 <printf>
    exit(1);
    462a:	4505                	li	a0,1
    462c:	45a000ef          	jal	4a86 <exit>
    4630:	f426                	sd	s1,40(sp)
    4632:	f04a                	sd	s2,32(sp)
    4634:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    4636:	00003517          	auipc	a0,0x3
    463a:	95a50513          	addi	a0,a0,-1702 # 6f90 <malloc+0x2036>
    463e:	069000ef          	jal	4ea6 <printf>
    exit(1);
    4642:	4505                	li	a0,1
    4644:	442000ef          	jal	4a86 <exit>
      }
    }

    exit(0);
    4648:	4501                	li	a0,0
    464a:	43c000ef          	jal	4a86 <exit>
    464e:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    4650:	fcc42503          	lw	a0,-52(s0)
    4654:	45a000ef          	jal	4aae <close>

  int n = 0;
    4658:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    465a:	4605                	li	a2,1
    465c:	fc740593          	addi	a1,s0,-57
    4660:	fc842503          	lw	a0,-56(s0)
    4664:	43a000ef          	jal	4a9e <read>
    if(cc < 0){
    4668:	00054563          	bltz	a0,4672 <countfree+0xc6>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    466c:	cd11                	beqz	a0,4688 <countfree+0xdc>
      break;
    n += 1;
    466e:	2485                	addiw	s1,s1,1
  while(1){
    4670:	b7ed                	j	465a <countfree+0xae>
    4672:	f04a                	sd	s2,32(sp)
    4674:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    4676:	00003517          	auipc	a0,0x3
    467a:	95a50513          	addi	a0,a0,-1702 # 6fd0 <malloc+0x2076>
    467e:	029000ef          	jal	4ea6 <printf>
      exit(1);
    4682:	4505                	li	a0,1
    4684:	402000ef          	jal	4a86 <exit>
  }

  close(fds[0]);
    4688:	fc842503          	lw	a0,-56(s0)
    468c:	422000ef          	jal	4aae <close>
  wait((int*)0);
    4690:	4501                	li	a0,0
    4692:	3fc000ef          	jal	4a8e <wait>
  
  return n;
}
    4696:	8526                	mv	a0,s1
    4698:	74a2                	ld	s1,40(sp)
    469a:	70e2                	ld	ra,56(sp)
    469c:	7442                	ld	s0,48(sp)
    469e:	6121                	addi	sp,sp,64
    46a0:	8082                	ret

00000000000046a2 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    46a2:	711d                	addi	sp,sp,-96
    46a4:	ec86                	sd	ra,88(sp)
    46a6:	e8a2                	sd	s0,80(sp)
    46a8:	e4a6                	sd	s1,72(sp)
    46aa:	e0ca                	sd	s2,64(sp)
    46ac:	fc4e                	sd	s3,56(sp)
    46ae:	f852                	sd	s4,48(sp)
    46b0:	f456                	sd	s5,40(sp)
    46b2:	f05a                	sd	s6,32(sp)
    46b4:	ec5e                	sd	s7,24(sp)
    46b6:	e862                	sd	s8,16(sp)
    46b8:	e466                	sd	s9,8(sp)
    46ba:	e06a                	sd	s10,0(sp)
    46bc:	1080                	addi	s0,sp,96
    46be:	8aaa                	mv	s5,a0
    46c0:	892e                	mv	s2,a1
    46c2:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    46c4:	00003b97          	auipc	s7,0x3
    46c8:	92cb8b93          	addi	s7,s7,-1748 # 6ff0 <malloc+0x2096>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    46cc:	00005b17          	auipc	s6,0x5
    46d0:	944b0b13          	addi	s6,s6,-1724 # 9010 <quicktests>
      if(continuous != 2) {
    46d4:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    46d6:	00005c17          	auipc	s8,0x5
    46da:	d0ac0c13          	addi	s8,s8,-758 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    46de:	00003d17          	auipc	s10,0x3
    46e2:	92ad0d13          	addi	s10,s10,-1750 # 7008 <malloc+0x20ae>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    46e6:	00003c97          	auipc	s9,0x3
    46ea:	942c8c93          	addi	s9,s9,-1726 # 7028 <malloc+0x20ce>
    46ee:	a819                	j	4704 <drivetests+0x62>
        printf("usertests slow tests starting\n");
    46f0:	856a                	mv	a0,s10
    46f2:	7b4000ef          	jal	4ea6 <printf>
    46f6:	a80d                	j	4728 <drivetests+0x86>
    if((free1 = countfree()) < free0) {
    46f8:	eb5ff0ef          	jal	45ac <countfree>
    46fc:	04954063          	blt	a0,s1,473c <drivetests+0x9a>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    4700:	04090963          	beqz	s2,4752 <drivetests+0xb0>
    printf("usertests starting\n");
    4704:	855e                	mv	a0,s7
    4706:	7a0000ef          	jal	4ea6 <printf>
    int free0 = countfree();
    470a:	ea3ff0ef          	jal	45ac <countfree>
    470e:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    4710:	864a                	mv	a2,s2
    4712:	85ce                	mv	a1,s3
    4714:	855a                	mv	a0,s6
    4716:	e1dff0ef          	jal	4532 <runtests>
    471a:	c119                	beqz	a0,4720 <drivetests+0x7e>
      if(continuous != 2) {
    471c:	03491963          	bne	s2,s4,474e <drivetests+0xac>
    if(!quick) {
    4720:	fc0a9ce3          	bnez	s5,46f8 <drivetests+0x56>
      if (justone == 0)
    4724:	fc0986e3          	beqz	s3,46f0 <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    4728:	864a                	mv	a2,s2
    472a:	85ce                	mv	a1,s3
    472c:	8562                	mv	a0,s8
    472e:	e05ff0ef          	jal	4532 <runtests>
    4732:	d179                	beqz	a0,46f8 <drivetests+0x56>
        if(continuous != 2) {
    4734:	fd4902e3          	beq	s2,s4,46f8 <drivetests+0x56>
          return 1;
    4738:	4505                	li	a0,1
    473a:	a829                	j	4754 <drivetests+0xb2>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    473c:	8626                	mv	a2,s1
    473e:	85aa                	mv	a1,a0
    4740:	8566                	mv	a0,s9
    4742:	764000ef          	jal	4ea6 <printf>
      if(continuous != 2) {
    4746:	fb490fe3          	beq	s2,s4,4704 <drivetests+0x62>
        return 1;
    474a:	4505                	li	a0,1
    474c:	a021                	j	4754 <drivetests+0xb2>
        return 1;
    474e:	4505                	li	a0,1
    4750:	a011                	j	4754 <drivetests+0xb2>
  return 0;
    4752:	854a                	mv	a0,s2
}
    4754:	60e6                	ld	ra,88(sp)
    4756:	6446                	ld	s0,80(sp)
    4758:	64a6                	ld	s1,72(sp)
    475a:	6906                	ld	s2,64(sp)
    475c:	79e2                	ld	s3,56(sp)
    475e:	7a42                	ld	s4,48(sp)
    4760:	7aa2                	ld	s5,40(sp)
    4762:	7b02                	ld	s6,32(sp)
    4764:	6be2                	ld	s7,24(sp)
    4766:	6c42                	ld	s8,16(sp)
    4768:	6ca2                	ld	s9,8(sp)
    476a:	6d02                	ld	s10,0(sp)
    476c:	6125                	addi	sp,sp,96
    476e:	8082                	ret

0000000000004770 <main>:

int
main(int argc, char *argv[])
{
    4770:	1101                	addi	sp,sp,-32
    4772:	ec06                	sd	ra,24(sp)
    4774:	e822                	sd	s0,16(sp)
    4776:	e426                	sd	s1,8(sp)
    4778:	e04a                	sd	s2,0(sp)
    477a:	1000                	addi	s0,sp,32
    477c:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    477e:	4789                	li	a5,2
    4780:	00f50f63          	beq	a0,a5,479e <main+0x2e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4784:	4785                	li	a5,1
    4786:	06a7c063          	blt	a5,a0,47e6 <main+0x76>
  char *justone = 0;
    478a:	4901                	li	s2,0
  int quick = 0;
    478c:	4501                	li	a0,0
  int continuous = 0;
    478e:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    4790:	864a                	mv	a2,s2
    4792:	f11ff0ef          	jal	46a2 <drivetests>
    4796:	c935                	beqz	a0,480a <main+0x9a>
    exit(1);
    4798:	4505                	li	a0,1
    479a:	2ec000ef          	jal	4a86 <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    479e:	0085b903          	ld	s2,8(a1)
    47a2:	00003597          	auipc	a1,0x3
    47a6:	8b658593          	addi	a1,a1,-1866 # 7058 <malloc+0x20fe>
    47aa:	854a                	mv	a0,s2
    47ac:	09e000ef          	jal	484a <strcmp>
    47b0:	85aa                	mv	a1,a0
    47b2:	c139                	beqz	a0,47f8 <main+0x88>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    47b4:	00003597          	auipc	a1,0x3
    47b8:	8ac58593          	addi	a1,a1,-1876 # 7060 <malloc+0x2106>
    47bc:	854a                	mv	a0,s2
    47be:	08c000ef          	jal	484a <strcmp>
    47c2:	cd15                	beqz	a0,47fe <main+0x8e>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    47c4:	00003597          	auipc	a1,0x3
    47c8:	8a458593          	addi	a1,a1,-1884 # 7068 <malloc+0x210e>
    47cc:	854a                	mv	a0,s2
    47ce:	07c000ef          	jal	484a <strcmp>
    47d2:	c90d                	beqz	a0,4804 <main+0x94>
  } else if(argc == 2 && argv[1][0] != '-'){
    47d4:	00094703          	lbu	a4,0(s2)
    47d8:	02d00793          	li	a5,45
    47dc:	00f70563          	beq	a4,a5,47e6 <main+0x76>
  int quick = 0;
    47e0:	4501                	li	a0,0
  int continuous = 0;
    47e2:	4581                	li	a1,0
    47e4:	b775                	j	4790 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    47e6:	00003517          	auipc	a0,0x3
    47ea:	88a50513          	addi	a0,a0,-1910 # 7070 <malloc+0x2116>
    47ee:	6b8000ef          	jal	4ea6 <printf>
    exit(1);
    47f2:	4505                	li	a0,1
    47f4:	292000ef          	jal	4a86 <exit>
  char *justone = 0;
    47f8:	4901                	li	s2,0
    quick = 1;
    47fa:	4505                	li	a0,1
    47fc:	bf51                	j	4790 <main+0x20>
  char *justone = 0;
    47fe:	4901                	li	s2,0
    continuous = 1;
    4800:	4585                	li	a1,1
    4802:	b779                	j	4790 <main+0x20>
    continuous = 2;
    4804:	85a6                	mv	a1,s1
  char *justone = 0;
    4806:	4901                	li	s2,0
    4808:	b761                	j	4790 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    480a:	00003517          	auipc	a0,0x3
    480e:	89650513          	addi	a0,a0,-1898 # 70a0 <malloc+0x2146>
    4812:	694000ef          	jal	4ea6 <printf>
  exit(0);
    4816:	4501                	li	a0,0
    4818:	26e000ef          	jal	4a86 <exit>

000000000000481c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    481c:	1141                	addi	sp,sp,-16
    481e:	e406                	sd	ra,8(sp)
    4820:	e022                	sd	s0,0(sp)
    4822:	0800                	addi	s0,sp,16
  extern int main();
  main();
    4824:	f4dff0ef          	jal	4770 <main>
  exit(0);
    4828:	4501                	li	a0,0
    482a:	25c000ef          	jal	4a86 <exit>

000000000000482e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    482e:	1141                	addi	sp,sp,-16
    4830:	e422                	sd	s0,8(sp)
    4832:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4834:	87aa                	mv	a5,a0
    4836:	0585                	addi	a1,a1,1
    4838:	0785                	addi	a5,a5,1
    483a:	fff5c703          	lbu	a4,-1(a1)
    483e:	fee78fa3          	sb	a4,-1(a5)
    4842:	fb75                	bnez	a4,4836 <strcpy+0x8>
    ;
  return os;
}
    4844:	6422                	ld	s0,8(sp)
    4846:	0141                	addi	sp,sp,16
    4848:	8082                	ret

000000000000484a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    484a:	1141                	addi	sp,sp,-16
    484c:	e422                	sd	s0,8(sp)
    484e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4850:	00054783          	lbu	a5,0(a0)
    4854:	cb91                	beqz	a5,4868 <strcmp+0x1e>
    4856:	0005c703          	lbu	a4,0(a1)
    485a:	00f71763          	bne	a4,a5,4868 <strcmp+0x1e>
    p++, q++;
    485e:	0505                	addi	a0,a0,1
    4860:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4862:	00054783          	lbu	a5,0(a0)
    4866:	fbe5                	bnez	a5,4856 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    4868:	0005c503          	lbu	a0,0(a1)
}
    486c:	40a7853b          	subw	a0,a5,a0
    4870:	6422                	ld	s0,8(sp)
    4872:	0141                	addi	sp,sp,16
    4874:	8082                	ret

0000000000004876 <strlen>:

uint
strlen(const char *s)
{
    4876:	1141                	addi	sp,sp,-16
    4878:	e422                	sd	s0,8(sp)
    487a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    487c:	00054783          	lbu	a5,0(a0)
    4880:	cf91                	beqz	a5,489c <strlen+0x26>
    4882:	0505                	addi	a0,a0,1
    4884:	87aa                	mv	a5,a0
    4886:	86be                	mv	a3,a5
    4888:	0785                	addi	a5,a5,1
    488a:	fff7c703          	lbu	a4,-1(a5)
    488e:	ff65                	bnez	a4,4886 <strlen+0x10>
    4890:	40a6853b          	subw	a0,a3,a0
    4894:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    4896:	6422                	ld	s0,8(sp)
    4898:	0141                	addi	sp,sp,16
    489a:	8082                	ret
  for(n = 0; s[n]; n++)
    489c:	4501                	li	a0,0
    489e:	bfe5                	j	4896 <strlen+0x20>

00000000000048a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    48a0:	1141                	addi	sp,sp,-16
    48a2:	e422                	sd	s0,8(sp)
    48a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    48a6:	ca19                	beqz	a2,48bc <memset+0x1c>
    48a8:	87aa                	mv	a5,a0
    48aa:	1602                	slli	a2,a2,0x20
    48ac:	9201                	srli	a2,a2,0x20
    48ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    48b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    48b6:	0785                	addi	a5,a5,1
    48b8:	fee79de3          	bne	a5,a4,48b2 <memset+0x12>
  }
  return dst;
}
    48bc:	6422                	ld	s0,8(sp)
    48be:	0141                	addi	sp,sp,16
    48c0:	8082                	ret

00000000000048c2 <strchr>:

char*
strchr(const char *s, char c)
{
    48c2:	1141                	addi	sp,sp,-16
    48c4:	e422                	sd	s0,8(sp)
    48c6:	0800                	addi	s0,sp,16
  for(; *s; s++)
    48c8:	00054783          	lbu	a5,0(a0)
    48cc:	cb99                	beqz	a5,48e2 <strchr+0x20>
    if(*s == c)
    48ce:	00f58763          	beq	a1,a5,48dc <strchr+0x1a>
  for(; *s; s++)
    48d2:	0505                	addi	a0,a0,1
    48d4:	00054783          	lbu	a5,0(a0)
    48d8:	fbfd                	bnez	a5,48ce <strchr+0xc>
      return (char*)s;
  return 0;
    48da:	4501                	li	a0,0
}
    48dc:	6422                	ld	s0,8(sp)
    48de:	0141                	addi	sp,sp,16
    48e0:	8082                	ret
  return 0;
    48e2:	4501                	li	a0,0
    48e4:	bfe5                	j	48dc <strchr+0x1a>

00000000000048e6 <gets>:

char*
gets(char *buf, int max)
{
    48e6:	711d                	addi	sp,sp,-96
    48e8:	ec86                	sd	ra,88(sp)
    48ea:	e8a2                	sd	s0,80(sp)
    48ec:	e4a6                	sd	s1,72(sp)
    48ee:	e0ca                	sd	s2,64(sp)
    48f0:	fc4e                	sd	s3,56(sp)
    48f2:	f852                	sd	s4,48(sp)
    48f4:	f456                	sd	s5,40(sp)
    48f6:	f05a                	sd	s6,32(sp)
    48f8:	ec5e                	sd	s7,24(sp)
    48fa:	1080                	addi	s0,sp,96
    48fc:	8baa                	mv	s7,a0
    48fe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4900:	892a                	mv	s2,a0
    4902:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    4904:	4aa9                	li	s5,10
    4906:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    4908:	89a6                	mv	s3,s1
    490a:	2485                	addiw	s1,s1,1
    490c:	0344d663          	bge	s1,s4,4938 <gets+0x52>
    cc = read(0, &c, 1);
    4910:	4605                	li	a2,1
    4912:	faf40593          	addi	a1,s0,-81
    4916:	4501                	li	a0,0
    4918:	186000ef          	jal	4a9e <read>
    if(cc < 1)
    491c:	00a05e63          	blez	a0,4938 <gets+0x52>
    buf[i++] = c;
    4920:	faf44783          	lbu	a5,-81(s0)
    4924:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4928:	01578763          	beq	a5,s5,4936 <gets+0x50>
    492c:	0905                	addi	s2,s2,1
    492e:	fd679de3          	bne	a5,s6,4908 <gets+0x22>
    buf[i++] = c;
    4932:	89a6                	mv	s3,s1
    4934:	a011                	j	4938 <gets+0x52>
    4936:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    4938:	99de                	add	s3,s3,s7
    493a:	00098023          	sb	zero,0(s3)
  return buf;
}
    493e:	855e                	mv	a0,s7
    4940:	60e6                	ld	ra,88(sp)
    4942:	6446                	ld	s0,80(sp)
    4944:	64a6                	ld	s1,72(sp)
    4946:	6906                	ld	s2,64(sp)
    4948:	79e2                	ld	s3,56(sp)
    494a:	7a42                	ld	s4,48(sp)
    494c:	7aa2                	ld	s5,40(sp)
    494e:	7b02                	ld	s6,32(sp)
    4950:	6be2                	ld	s7,24(sp)
    4952:	6125                	addi	sp,sp,96
    4954:	8082                	ret

0000000000004956 <stat>:

int
stat(const char *n, struct stat *st)
{
    4956:	1101                	addi	sp,sp,-32
    4958:	ec06                	sd	ra,24(sp)
    495a:	e822                	sd	s0,16(sp)
    495c:	e04a                	sd	s2,0(sp)
    495e:	1000                	addi	s0,sp,32
    4960:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4962:	4581                	li	a1,0
    4964:	162000ef          	jal	4ac6 <open>
  if(fd < 0)
    4968:	02054263          	bltz	a0,498c <stat+0x36>
    496c:	e426                	sd	s1,8(sp)
    496e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4970:	85ca                	mv	a1,s2
    4972:	16c000ef          	jal	4ade <fstat>
    4976:	892a                	mv	s2,a0
  close(fd);
    4978:	8526                	mv	a0,s1
    497a:	134000ef          	jal	4aae <close>
  return r;
    497e:	64a2                	ld	s1,8(sp)
}
    4980:	854a                	mv	a0,s2
    4982:	60e2                	ld	ra,24(sp)
    4984:	6442                	ld	s0,16(sp)
    4986:	6902                	ld	s2,0(sp)
    4988:	6105                	addi	sp,sp,32
    498a:	8082                	ret
    return -1;
    498c:	597d                	li	s2,-1
    498e:	bfcd                	j	4980 <stat+0x2a>

0000000000004990 <atoi>:

int
atoi(const char *s)
{
    4990:	1141                	addi	sp,sp,-16
    4992:	e422                	sd	s0,8(sp)
    4994:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4996:	00054683          	lbu	a3,0(a0)
    499a:	fd06879b          	addiw	a5,a3,-48
    499e:	0ff7f793          	zext.b	a5,a5
    49a2:	4625                	li	a2,9
    49a4:	02f66863          	bltu	a2,a5,49d4 <atoi+0x44>
    49a8:	872a                	mv	a4,a0
  n = 0;
    49aa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    49ac:	0705                	addi	a4,a4,1
    49ae:	0025179b          	slliw	a5,a0,0x2
    49b2:	9fa9                	addw	a5,a5,a0
    49b4:	0017979b          	slliw	a5,a5,0x1
    49b8:	9fb5                	addw	a5,a5,a3
    49ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    49be:	00074683          	lbu	a3,0(a4)
    49c2:	fd06879b          	addiw	a5,a3,-48
    49c6:	0ff7f793          	zext.b	a5,a5
    49ca:	fef671e3          	bgeu	a2,a5,49ac <atoi+0x1c>
  return n;
}
    49ce:	6422                	ld	s0,8(sp)
    49d0:	0141                	addi	sp,sp,16
    49d2:	8082                	ret
  n = 0;
    49d4:	4501                	li	a0,0
    49d6:	bfe5                	j	49ce <atoi+0x3e>

00000000000049d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    49d8:	1141                	addi	sp,sp,-16
    49da:	e422                	sd	s0,8(sp)
    49dc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    49de:	02b57463          	bgeu	a0,a1,4a06 <memmove+0x2e>
    while(n-- > 0)
    49e2:	00c05f63          	blez	a2,4a00 <memmove+0x28>
    49e6:	1602                	slli	a2,a2,0x20
    49e8:	9201                	srli	a2,a2,0x20
    49ea:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    49ee:	872a                	mv	a4,a0
      *dst++ = *src++;
    49f0:	0585                	addi	a1,a1,1
    49f2:	0705                	addi	a4,a4,1
    49f4:	fff5c683          	lbu	a3,-1(a1)
    49f8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    49fc:	fef71ae3          	bne	a4,a5,49f0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4a00:	6422                	ld	s0,8(sp)
    4a02:	0141                	addi	sp,sp,16
    4a04:	8082                	ret
    dst += n;
    4a06:	00c50733          	add	a4,a0,a2
    src += n;
    4a0a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    4a0c:	fec05ae3          	blez	a2,4a00 <memmove+0x28>
    4a10:	fff6079b          	addiw	a5,a2,-1 # 2fff <subdir+0x41d>
    4a14:	1782                	slli	a5,a5,0x20
    4a16:	9381                	srli	a5,a5,0x20
    4a18:	fff7c793          	not	a5,a5
    4a1c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4a1e:	15fd                	addi	a1,a1,-1
    4a20:	177d                	addi	a4,a4,-1
    4a22:	0005c683          	lbu	a3,0(a1)
    4a26:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4a2a:	fee79ae3          	bne	a5,a4,4a1e <memmove+0x46>
    4a2e:	bfc9                	j	4a00 <memmove+0x28>

0000000000004a30 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4a30:	1141                	addi	sp,sp,-16
    4a32:	e422                	sd	s0,8(sp)
    4a34:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4a36:	ca05                	beqz	a2,4a66 <memcmp+0x36>
    4a38:	fff6069b          	addiw	a3,a2,-1
    4a3c:	1682                	slli	a3,a3,0x20
    4a3e:	9281                	srli	a3,a3,0x20
    4a40:	0685                	addi	a3,a3,1
    4a42:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    4a44:	00054783          	lbu	a5,0(a0)
    4a48:	0005c703          	lbu	a4,0(a1)
    4a4c:	00e79863          	bne	a5,a4,4a5c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    4a50:	0505                	addi	a0,a0,1
    p2++;
    4a52:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4a54:	fed518e3          	bne	a0,a3,4a44 <memcmp+0x14>
  }
  return 0;
    4a58:	4501                	li	a0,0
    4a5a:	a019                	j	4a60 <memcmp+0x30>
      return *p1 - *p2;
    4a5c:	40e7853b          	subw	a0,a5,a4
}
    4a60:	6422                	ld	s0,8(sp)
    4a62:	0141                	addi	sp,sp,16
    4a64:	8082                	ret
  return 0;
    4a66:	4501                	li	a0,0
    4a68:	bfe5                	j	4a60 <memcmp+0x30>

0000000000004a6a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4a6a:	1141                	addi	sp,sp,-16
    4a6c:	e406                	sd	ra,8(sp)
    4a6e:	e022                	sd	s0,0(sp)
    4a70:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4a72:	f67ff0ef          	jal	49d8 <memmove>
}
    4a76:	60a2                	ld	ra,8(sp)
    4a78:	6402                	ld	s0,0(sp)
    4a7a:	0141                	addi	sp,sp,16
    4a7c:	8082                	ret

0000000000004a7e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4a7e:	4885                	li	a7,1
 ecall
    4a80:	00000073          	ecall
 ret
    4a84:	8082                	ret

0000000000004a86 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4a86:	4889                	li	a7,2
 ecall
    4a88:	00000073          	ecall
 ret
    4a8c:	8082                	ret

0000000000004a8e <wait>:
.global wait
wait:
 li a7, SYS_wait
    4a8e:	488d                	li	a7,3
 ecall
    4a90:	00000073          	ecall
 ret
    4a94:	8082                	ret

0000000000004a96 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4a96:	4891                	li	a7,4
 ecall
    4a98:	00000073          	ecall
 ret
    4a9c:	8082                	ret

0000000000004a9e <read>:
.global read
read:
 li a7, SYS_read
    4a9e:	4895                	li	a7,5
 ecall
    4aa0:	00000073          	ecall
 ret
    4aa4:	8082                	ret

0000000000004aa6 <write>:
.global write
write:
 li a7, SYS_write
    4aa6:	48c1                	li	a7,16
 ecall
    4aa8:	00000073          	ecall
 ret
    4aac:	8082                	ret

0000000000004aae <close>:
.global close
close:
 li a7, SYS_close
    4aae:	48d5                	li	a7,21
 ecall
    4ab0:	00000073          	ecall
 ret
    4ab4:	8082                	ret

0000000000004ab6 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4ab6:	4899                	li	a7,6
 ecall
    4ab8:	00000073          	ecall
 ret
    4abc:	8082                	ret

0000000000004abe <exec>:
.global exec
exec:
 li a7, SYS_exec
    4abe:	489d                	li	a7,7
 ecall
    4ac0:	00000073          	ecall
 ret
    4ac4:	8082                	ret

0000000000004ac6 <open>:
.global open
open:
 li a7, SYS_open
    4ac6:	48bd                	li	a7,15
 ecall
    4ac8:	00000073          	ecall
 ret
    4acc:	8082                	ret

0000000000004ace <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4ace:	48c5                	li	a7,17
 ecall
    4ad0:	00000073          	ecall
 ret
    4ad4:	8082                	ret

0000000000004ad6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4ad6:	48c9                	li	a7,18
 ecall
    4ad8:	00000073          	ecall
 ret
    4adc:	8082                	ret

0000000000004ade <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4ade:	48a1                	li	a7,8
 ecall
    4ae0:	00000073          	ecall
 ret
    4ae4:	8082                	ret

0000000000004ae6 <link>:
.global link
link:
 li a7, SYS_link
    4ae6:	48cd                	li	a7,19
 ecall
    4ae8:	00000073          	ecall
 ret
    4aec:	8082                	ret

0000000000004aee <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4aee:	48d1                	li	a7,20
 ecall
    4af0:	00000073          	ecall
 ret
    4af4:	8082                	ret

0000000000004af6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4af6:	48a5                	li	a7,9
 ecall
    4af8:	00000073          	ecall
 ret
    4afc:	8082                	ret

0000000000004afe <dup>:
.global dup
dup:
 li a7, SYS_dup
    4afe:	48a9                	li	a7,10
 ecall
    4b00:	00000073          	ecall
 ret
    4b04:	8082                	ret

0000000000004b06 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4b06:	48ad                	li	a7,11
 ecall
    4b08:	00000073          	ecall
 ret
    4b0c:	8082                	ret

0000000000004b0e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    4b0e:	48b1                	li	a7,12
 ecall
    4b10:	00000073          	ecall
 ret
    4b14:	8082                	ret

0000000000004b16 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    4b16:	48b5                	li	a7,13
 ecall
    4b18:	00000073          	ecall
 ret
    4b1c:	8082                	ret

0000000000004b1e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4b1e:	48b9                	li	a7,14
 ecall
    4b20:	00000073          	ecall
 ret
    4b24:	8082                	ret

0000000000004b26 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
    4b26:	48d9                	li	a7,22
 ecall
    4b28:	00000073          	ecall
 ret
    4b2c:	8082                	ret

0000000000004b2e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4b2e:	1101                	addi	sp,sp,-32
    4b30:	ec06                	sd	ra,24(sp)
    4b32:	e822                	sd	s0,16(sp)
    4b34:	1000                	addi	s0,sp,32
    4b36:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4b3a:	4605                	li	a2,1
    4b3c:	fef40593          	addi	a1,s0,-17
    4b40:	f67ff0ef          	jal	4aa6 <write>
}
    4b44:	60e2                	ld	ra,24(sp)
    4b46:	6442                	ld	s0,16(sp)
    4b48:	6105                	addi	sp,sp,32
    4b4a:	8082                	ret

0000000000004b4c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4b4c:	7139                	addi	sp,sp,-64
    4b4e:	fc06                	sd	ra,56(sp)
    4b50:	f822                	sd	s0,48(sp)
    4b52:	f426                	sd	s1,40(sp)
    4b54:	0080                	addi	s0,sp,64
    4b56:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4b58:	c299                	beqz	a3,4b5e <printint+0x12>
    4b5a:	0805c963          	bltz	a1,4bec <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4b5e:	2581                	sext.w	a1,a1
  neg = 0;
    4b60:	4881                	li	a7,0
    4b62:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    4b66:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4b68:	2601                	sext.w	a2,a2
    4b6a:	00003517          	auipc	a0,0x3
    4b6e:	90650513          	addi	a0,a0,-1786 # 7470 <digits>
    4b72:	883a                	mv	a6,a4
    4b74:	2705                	addiw	a4,a4,1
    4b76:	02c5f7bb          	remuw	a5,a1,a2
    4b7a:	1782                	slli	a5,a5,0x20
    4b7c:	9381                	srli	a5,a5,0x20
    4b7e:	97aa                	add	a5,a5,a0
    4b80:	0007c783          	lbu	a5,0(a5)
    4b84:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4b88:	0005879b          	sext.w	a5,a1
    4b8c:	02c5d5bb          	divuw	a1,a1,a2
    4b90:	0685                	addi	a3,a3,1
    4b92:	fec7f0e3          	bgeu	a5,a2,4b72 <printint+0x26>
  if(neg)
    4b96:	00088c63          	beqz	a7,4bae <printint+0x62>
    buf[i++] = '-';
    4b9a:	fd070793          	addi	a5,a4,-48
    4b9e:	00878733          	add	a4,a5,s0
    4ba2:	02d00793          	li	a5,45
    4ba6:	fef70823          	sb	a5,-16(a4)
    4baa:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    4bae:	02e05a63          	blez	a4,4be2 <printint+0x96>
    4bb2:	f04a                	sd	s2,32(sp)
    4bb4:	ec4e                	sd	s3,24(sp)
    4bb6:	fc040793          	addi	a5,s0,-64
    4bba:	00e78933          	add	s2,a5,a4
    4bbe:	fff78993          	addi	s3,a5,-1
    4bc2:	99ba                	add	s3,s3,a4
    4bc4:	377d                	addiw	a4,a4,-1
    4bc6:	1702                	slli	a4,a4,0x20
    4bc8:	9301                	srli	a4,a4,0x20
    4bca:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    4bce:	fff94583          	lbu	a1,-1(s2)
    4bd2:	8526                	mv	a0,s1
    4bd4:	f5bff0ef          	jal	4b2e <putc>
  while(--i >= 0)
    4bd8:	197d                	addi	s2,s2,-1
    4bda:	ff391ae3          	bne	s2,s3,4bce <printint+0x82>
    4bde:	7902                	ld	s2,32(sp)
    4be0:	69e2                	ld	s3,24(sp)
}
    4be2:	70e2                	ld	ra,56(sp)
    4be4:	7442                	ld	s0,48(sp)
    4be6:	74a2                	ld	s1,40(sp)
    4be8:	6121                	addi	sp,sp,64
    4bea:	8082                	ret
    x = -xx;
    4bec:	40b005bb          	negw	a1,a1
    neg = 1;
    4bf0:	4885                	li	a7,1
    x = -xx;
    4bf2:	bf85                	j	4b62 <printint+0x16>

0000000000004bf4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4bf4:	711d                	addi	sp,sp,-96
    4bf6:	ec86                	sd	ra,88(sp)
    4bf8:	e8a2                	sd	s0,80(sp)
    4bfa:	e0ca                	sd	s2,64(sp)
    4bfc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4bfe:	0005c903          	lbu	s2,0(a1)
    4c02:	26090863          	beqz	s2,4e72 <vprintf+0x27e>
    4c06:	e4a6                	sd	s1,72(sp)
    4c08:	fc4e                	sd	s3,56(sp)
    4c0a:	f852                	sd	s4,48(sp)
    4c0c:	f456                	sd	s5,40(sp)
    4c0e:	f05a                	sd	s6,32(sp)
    4c10:	ec5e                	sd	s7,24(sp)
    4c12:	e862                	sd	s8,16(sp)
    4c14:	e466                	sd	s9,8(sp)
    4c16:	8b2a                	mv	s6,a0
    4c18:	8a2e                	mv	s4,a1
    4c1a:	8bb2                	mv	s7,a2
  state = 0;
    4c1c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4c1e:	4481                	li	s1,0
    4c20:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4c22:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4c26:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4c2a:	06c00c93          	li	s9,108
    4c2e:	a005                	j	4c4e <vprintf+0x5a>
        putc(fd, c0);
    4c30:	85ca                	mv	a1,s2
    4c32:	855a                	mv	a0,s6
    4c34:	efbff0ef          	jal	4b2e <putc>
    4c38:	a019                	j	4c3e <vprintf+0x4a>
    } else if(state == '%'){
    4c3a:	03598263          	beq	s3,s5,4c5e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    4c3e:	2485                	addiw	s1,s1,1
    4c40:	8726                	mv	a4,s1
    4c42:	009a07b3          	add	a5,s4,s1
    4c46:	0007c903          	lbu	s2,0(a5)
    4c4a:	20090c63          	beqz	s2,4e62 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    4c4e:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4c52:	fe0994e3          	bnez	s3,4c3a <vprintf+0x46>
      if(c0 == '%'){
    4c56:	fd579de3          	bne	a5,s5,4c30 <vprintf+0x3c>
        state = '%';
    4c5a:	89be                	mv	s3,a5
    4c5c:	b7cd                	j	4c3e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    4c5e:	00ea06b3          	add	a3,s4,a4
    4c62:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4c66:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4c68:	c681                	beqz	a3,4c70 <vprintf+0x7c>
    4c6a:	9752                	add	a4,a4,s4
    4c6c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4c70:	03878f63          	beq	a5,s8,4cae <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    4c74:	05978963          	beq	a5,s9,4cc6 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4c78:	07500713          	li	a4,117
    4c7c:	0ee78363          	beq	a5,a4,4d62 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4c80:	07800713          	li	a4,120
    4c84:	12e78563          	beq	a5,a4,4dae <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4c88:	07000713          	li	a4,112
    4c8c:	14e78a63          	beq	a5,a4,4de0 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    4c90:	07300713          	li	a4,115
    4c94:	18e78a63          	beq	a5,a4,4e28 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4c98:	02500713          	li	a4,37
    4c9c:	04e79563          	bne	a5,a4,4ce6 <vprintf+0xf2>
        putc(fd, '%');
    4ca0:	02500593          	li	a1,37
    4ca4:	855a                	mv	a0,s6
    4ca6:	e89ff0ef          	jal	4b2e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    4caa:	4981                	li	s3,0
    4cac:	bf49                	j	4c3e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    4cae:	008b8913          	addi	s2,s7,8
    4cb2:	4685                	li	a3,1
    4cb4:	4629                	li	a2,10
    4cb6:	000ba583          	lw	a1,0(s7)
    4cba:	855a                	mv	a0,s6
    4cbc:	e91ff0ef          	jal	4b4c <printint>
    4cc0:	8bca                	mv	s7,s2
      state = 0;
    4cc2:	4981                	li	s3,0
    4cc4:	bfad                	j	4c3e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    4cc6:	06400793          	li	a5,100
    4cca:	02f68963          	beq	a3,a5,4cfc <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4cce:	06c00793          	li	a5,108
    4cd2:	04f68263          	beq	a3,a5,4d16 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    4cd6:	07500793          	li	a5,117
    4cda:	0af68063          	beq	a3,a5,4d7a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    4cde:	07800793          	li	a5,120
    4ce2:	0ef68263          	beq	a3,a5,4dc6 <vprintf+0x1d2>
        putc(fd, '%');
    4ce6:	02500593          	li	a1,37
    4cea:	855a                	mv	a0,s6
    4cec:	e43ff0ef          	jal	4b2e <putc>
        putc(fd, c0);
    4cf0:	85ca                	mv	a1,s2
    4cf2:	855a                	mv	a0,s6
    4cf4:	e3bff0ef          	jal	4b2e <putc>
      state = 0;
    4cf8:	4981                	li	s3,0
    4cfa:	b791                	j	4c3e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4cfc:	008b8913          	addi	s2,s7,8
    4d00:	4685                	li	a3,1
    4d02:	4629                	li	a2,10
    4d04:	000ba583          	lw	a1,0(s7)
    4d08:	855a                	mv	a0,s6
    4d0a:	e43ff0ef          	jal	4b4c <printint>
        i += 1;
    4d0e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4d10:	8bca                	mv	s7,s2
      state = 0;
    4d12:	4981                	li	s3,0
        i += 1;
    4d14:	b72d                	j	4c3e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4d16:	06400793          	li	a5,100
    4d1a:	02f60763          	beq	a2,a5,4d48 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4d1e:	07500793          	li	a5,117
    4d22:	06f60963          	beq	a2,a5,4d94 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4d26:	07800793          	li	a5,120
    4d2a:	faf61ee3          	bne	a2,a5,4ce6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d2e:	008b8913          	addi	s2,s7,8
    4d32:	4681                	li	a3,0
    4d34:	4641                	li	a2,16
    4d36:	000ba583          	lw	a1,0(s7)
    4d3a:	855a                	mv	a0,s6
    4d3c:	e11ff0ef          	jal	4b4c <printint>
        i += 2;
    4d40:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d42:	8bca                	mv	s7,s2
      state = 0;
    4d44:	4981                	li	s3,0
        i += 2;
    4d46:	bde5                	j	4c3e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4d48:	008b8913          	addi	s2,s7,8
    4d4c:	4685                	li	a3,1
    4d4e:	4629                	li	a2,10
    4d50:	000ba583          	lw	a1,0(s7)
    4d54:	855a                	mv	a0,s6
    4d56:	df7ff0ef          	jal	4b4c <printint>
        i += 2;
    4d5a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4d5c:	8bca                	mv	s7,s2
      state = 0;
    4d5e:	4981                	li	s3,0
        i += 2;
    4d60:	bdf9                	j	4c3e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    4d62:	008b8913          	addi	s2,s7,8
    4d66:	4681                	li	a3,0
    4d68:	4629                	li	a2,10
    4d6a:	000ba583          	lw	a1,0(s7)
    4d6e:	855a                	mv	a0,s6
    4d70:	dddff0ef          	jal	4b4c <printint>
    4d74:	8bca                	mv	s7,s2
      state = 0;
    4d76:	4981                	li	s3,0
    4d78:	b5d9                	j	4c3e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d7a:	008b8913          	addi	s2,s7,8
    4d7e:	4681                	li	a3,0
    4d80:	4629                	li	a2,10
    4d82:	000ba583          	lw	a1,0(s7)
    4d86:	855a                	mv	a0,s6
    4d88:	dc5ff0ef          	jal	4b4c <printint>
        i += 1;
    4d8c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d8e:	8bca                	mv	s7,s2
      state = 0;
    4d90:	4981                	li	s3,0
        i += 1;
    4d92:	b575                	j	4c3e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d94:	008b8913          	addi	s2,s7,8
    4d98:	4681                	li	a3,0
    4d9a:	4629                	li	a2,10
    4d9c:	000ba583          	lw	a1,0(s7)
    4da0:	855a                	mv	a0,s6
    4da2:	dabff0ef          	jal	4b4c <printint>
        i += 2;
    4da6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    4da8:	8bca                	mv	s7,s2
      state = 0;
    4daa:	4981                	li	s3,0
        i += 2;
    4dac:	bd49                	j	4c3e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    4dae:	008b8913          	addi	s2,s7,8
    4db2:	4681                	li	a3,0
    4db4:	4641                	li	a2,16
    4db6:	000ba583          	lw	a1,0(s7)
    4dba:	855a                	mv	a0,s6
    4dbc:	d91ff0ef          	jal	4b4c <printint>
    4dc0:	8bca                	mv	s7,s2
      state = 0;
    4dc2:	4981                	li	s3,0
    4dc4:	bdad                	j	4c3e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4dc6:	008b8913          	addi	s2,s7,8
    4dca:	4681                	li	a3,0
    4dcc:	4641                	li	a2,16
    4dce:	000ba583          	lw	a1,0(s7)
    4dd2:	855a                	mv	a0,s6
    4dd4:	d79ff0ef          	jal	4b4c <printint>
        i += 1;
    4dd8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    4dda:	8bca                	mv	s7,s2
      state = 0;
    4ddc:	4981                	li	s3,0
        i += 1;
    4dde:	b585                	j	4c3e <vprintf+0x4a>
    4de0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    4de2:	008b8d13          	addi	s10,s7,8
    4de6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    4dea:	03000593          	li	a1,48
    4dee:	855a                	mv	a0,s6
    4df0:	d3fff0ef          	jal	4b2e <putc>
  putc(fd, 'x');
    4df4:	07800593          	li	a1,120
    4df8:	855a                	mv	a0,s6
    4dfa:	d35ff0ef          	jal	4b2e <putc>
    4dfe:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4e00:	00002b97          	auipc	s7,0x2
    4e04:	670b8b93          	addi	s7,s7,1648 # 7470 <digits>
    4e08:	03c9d793          	srli	a5,s3,0x3c
    4e0c:	97de                	add	a5,a5,s7
    4e0e:	0007c583          	lbu	a1,0(a5)
    4e12:	855a                	mv	a0,s6
    4e14:	d1bff0ef          	jal	4b2e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    4e18:	0992                	slli	s3,s3,0x4
    4e1a:	397d                	addiw	s2,s2,-1
    4e1c:	fe0916e3          	bnez	s2,4e08 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    4e20:	8bea                	mv	s7,s10
      state = 0;
    4e22:	4981                	li	s3,0
    4e24:	6d02                	ld	s10,0(sp)
    4e26:	bd21                	j	4c3e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    4e28:	008b8993          	addi	s3,s7,8
    4e2c:	000bb903          	ld	s2,0(s7)
    4e30:	00090f63          	beqz	s2,4e4e <vprintf+0x25a>
        for(; *s; s++)
    4e34:	00094583          	lbu	a1,0(s2)
    4e38:	c195                	beqz	a1,4e5c <vprintf+0x268>
          putc(fd, *s);
    4e3a:	855a                	mv	a0,s6
    4e3c:	cf3ff0ef          	jal	4b2e <putc>
        for(; *s; s++)
    4e40:	0905                	addi	s2,s2,1
    4e42:	00094583          	lbu	a1,0(s2)
    4e46:	f9f5                	bnez	a1,4e3a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    4e48:	8bce                	mv	s7,s3
      state = 0;
    4e4a:	4981                	li	s3,0
    4e4c:	bbcd                	j	4c3e <vprintf+0x4a>
          s = "(null)";
    4e4e:	00002917          	auipc	s2,0x2
    4e52:	5a290913          	addi	s2,s2,1442 # 73f0 <malloc+0x2496>
        for(; *s; s++)
    4e56:	02800593          	li	a1,40
    4e5a:	b7c5                	j	4e3a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    4e5c:	8bce                	mv	s7,s3
      state = 0;
    4e5e:	4981                	li	s3,0
    4e60:	bbf9                	j	4c3e <vprintf+0x4a>
    4e62:	64a6                	ld	s1,72(sp)
    4e64:	79e2                	ld	s3,56(sp)
    4e66:	7a42                	ld	s4,48(sp)
    4e68:	7aa2                	ld	s5,40(sp)
    4e6a:	7b02                	ld	s6,32(sp)
    4e6c:	6be2                	ld	s7,24(sp)
    4e6e:	6c42                	ld	s8,16(sp)
    4e70:	6ca2                	ld	s9,8(sp)
    }
  }
}
    4e72:	60e6                	ld	ra,88(sp)
    4e74:	6446                	ld	s0,80(sp)
    4e76:	6906                	ld	s2,64(sp)
    4e78:	6125                	addi	sp,sp,96
    4e7a:	8082                	ret

0000000000004e7c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    4e7c:	715d                	addi	sp,sp,-80
    4e7e:	ec06                	sd	ra,24(sp)
    4e80:	e822                	sd	s0,16(sp)
    4e82:	1000                	addi	s0,sp,32
    4e84:	e010                	sd	a2,0(s0)
    4e86:	e414                	sd	a3,8(s0)
    4e88:	e818                	sd	a4,16(s0)
    4e8a:	ec1c                	sd	a5,24(s0)
    4e8c:	03043023          	sd	a6,32(s0)
    4e90:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    4e94:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    4e98:	8622                	mv	a2,s0
    4e9a:	d5bff0ef          	jal	4bf4 <vprintf>
}
    4e9e:	60e2                	ld	ra,24(sp)
    4ea0:	6442                	ld	s0,16(sp)
    4ea2:	6161                	addi	sp,sp,80
    4ea4:	8082                	ret

0000000000004ea6 <printf>:

void
printf(const char *fmt, ...)
{
    4ea6:	711d                	addi	sp,sp,-96
    4ea8:	ec06                	sd	ra,24(sp)
    4eaa:	e822                	sd	s0,16(sp)
    4eac:	1000                	addi	s0,sp,32
    4eae:	e40c                	sd	a1,8(s0)
    4eb0:	e810                	sd	a2,16(s0)
    4eb2:	ec14                	sd	a3,24(s0)
    4eb4:	f018                	sd	a4,32(s0)
    4eb6:	f41c                	sd	a5,40(s0)
    4eb8:	03043823          	sd	a6,48(s0)
    4ebc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    4ec0:	00840613          	addi	a2,s0,8
    4ec4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    4ec8:	85aa                	mv	a1,a0
    4eca:	4505                	li	a0,1
    4ecc:	d29ff0ef          	jal	4bf4 <vprintf>
}
    4ed0:	60e2                	ld	ra,24(sp)
    4ed2:	6442                	ld	s0,16(sp)
    4ed4:	6125                	addi	sp,sp,96
    4ed6:	8082                	ret

0000000000004ed8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4ed8:	1141                	addi	sp,sp,-16
    4eda:	e422                	sd	s0,8(sp)
    4edc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4ede:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4ee2:	00004797          	auipc	a5,0x4
    4ee6:	56e7b783          	ld	a5,1390(a5) # 9450 <freep>
    4eea:	a02d                	j	4f14 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    4eec:	4618                	lw	a4,8(a2)
    4eee:	9f2d                	addw	a4,a4,a1
    4ef0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    4ef4:	6398                	ld	a4,0(a5)
    4ef6:	6310                	ld	a2,0(a4)
    4ef8:	a83d                	j	4f36 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    4efa:	ff852703          	lw	a4,-8(a0)
    4efe:	9f31                	addw	a4,a4,a2
    4f00:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    4f02:	ff053683          	ld	a3,-16(a0)
    4f06:	a091                	j	4f4a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4f08:	6398                	ld	a4,0(a5)
    4f0a:	00e7e463          	bltu	a5,a4,4f12 <free+0x3a>
    4f0e:	00e6ea63          	bltu	a3,a4,4f22 <free+0x4a>
{
    4f12:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4f14:	fed7fae3          	bgeu	a5,a3,4f08 <free+0x30>
    4f18:	6398                	ld	a4,0(a5)
    4f1a:	00e6e463          	bltu	a3,a4,4f22 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4f1e:	fee7eae3          	bltu	a5,a4,4f12 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    4f22:	ff852583          	lw	a1,-8(a0)
    4f26:	6390                	ld	a2,0(a5)
    4f28:	02059813          	slli	a6,a1,0x20
    4f2c:	01c85713          	srli	a4,a6,0x1c
    4f30:	9736                	add	a4,a4,a3
    4f32:	fae60de3          	beq	a2,a4,4eec <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    4f36:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    4f3a:	4790                	lw	a2,8(a5)
    4f3c:	02061593          	slli	a1,a2,0x20
    4f40:	01c5d713          	srli	a4,a1,0x1c
    4f44:	973e                	add	a4,a4,a5
    4f46:	fae68ae3          	beq	a3,a4,4efa <free+0x22>
    p->s.ptr = bp->s.ptr;
    4f4a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    4f4c:	00004717          	auipc	a4,0x4
    4f50:	50f73223          	sd	a5,1284(a4) # 9450 <freep>
}
    4f54:	6422                	ld	s0,8(sp)
    4f56:	0141                	addi	sp,sp,16
    4f58:	8082                	ret

0000000000004f5a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4f5a:	7139                	addi	sp,sp,-64
    4f5c:	fc06                	sd	ra,56(sp)
    4f5e:	f822                	sd	s0,48(sp)
    4f60:	f426                	sd	s1,40(sp)
    4f62:	ec4e                	sd	s3,24(sp)
    4f64:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4f66:	02051493          	slli	s1,a0,0x20
    4f6a:	9081                	srli	s1,s1,0x20
    4f6c:	04bd                	addi	s1,s1,15
    4f6e:	8091                	srli	s1,s1,0x4
    4f70:	0014899b          	addiw	s3,s1,1
    4f74:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    4f76:	00004517          	auipc	a0,0x4
    4f7a:	4da53503          	ld	a0,1242(a0) # 9450 <freep>
    4f7e:	c915                	beqz	a0,4fb2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4f80:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4f82:	4798                	lw	a4,8(a5)
    4f84:	08977a63          	bgeu	a4,s1,5018 <malloc+0xbe>
    4f88:	f04a                	sd	s2,32(sp)
    4f8a:	e852                	sd	s4,16(sp)
    4f8c:	e456                	sd	s5,8(sp)
    4f8e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    4f90:	8a4e                	mv	s4,s3
    4f92:	0009871b          	sext.w	a4,s3
    4f96:	6685                	lui	a3,0x1
    4f98:	00d77363          	bgeu	a4,a3,4f9e <malloc+0x44>
    4f9c:	6a05                	lui	s4,0x1
    4f9e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    4fa2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    4fa6:	00004917          	auipc	s2,0x4
    4faa:	4aa90913          	addi	s2,s2,1194 # 9450 <freep>
  if(p == (char*)-1)
    4fae:	5afd                	li	s5,-1
    4fb0:	a081                	j	4ff0 <malloc+0x96>
    4fb2:	f04a                	sd	s2,32(sp)
    4fb4:	e852                	sd	s4,16(sp)
    4fb6:	e456                	sd	s5,8(sp)
    4fb8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    4fba:	0000b797          	auipc	a5,0xb
    4fbe:	cbe78793          	addi	a5,a5,-834 # fc78 <base>
    4fc2:	00004717          	auipc	a4,0x4
    4fc6:	48f73723          	sd	a5,1166(a4) # 9450 <freep>
    4fca:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    4fcc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    4fd0:	b7c1                	j	4f90 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    4fd2:	6398                	ld	a4,0(a5)
    4fd4:	e118                	sd	a4,0(a0)
    4fd6:	a8a9                	j	5030 <malloc+0xd6>
  hp->s.size = nu;
    4fd8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    4fdc:	0541                	addi	a0,a0,16
    4fde:	efbff0ef          	jal	4ed8 <free>
  return freep;
    4fe2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    4fe6:	c12d                	beqz	a0,5048 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4fe8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4fea:	4798                	lw	a4,8(a5)
    4fec:	02977263          	bgeu	a4,s1,5010 <malloc+0xb6>
    if(p == freep)
    4ff0:	00093703          	ld	a4,0(s2)
    4ff4:	853e                	mv	a0,a5
    4ff6:	fef719e3          	bne	a4,a5,4fe8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    4ffa:	8552                	mv	a0,s4
    4ffc:	b13ff0ef          	jal	4b0e <sbrk>
  if(p == (char*)-1)
    5000:	fd551ce3          	bne	a0,s5,4fd8 <malloc+0x7e>
        return 0;
    5004:	4501                	li	a0,0
    5006:	7902                	ld	s2,32(sp)
    5008:	6a42                	ld	s4,16(sp)
    500a:	6aa2                	ld	s5,8(sp)
    500c:	6b02                	ld	s6,0(sp)
    500e:	a03d                	j	503c <malloc+0xe2>
    5010:	7902                	ld	s2,32(sp)
    5012:	6a42                	ld	s4,16(sp)
    5014:	6aa2                	ld	s5,8(sp)
    5016:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    5018:	fae48de3          	beq	s1,a4,4fd2 <malloc+0x78>
        p->s.size -= nunits;
    501c:	4137073b          	subw	a4,a4,s3
    5020:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5022:	02071693          	slli	a3,a4,0x20
    5026:	01c6d713          	srli	a4,a3,0x1c
    502a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    502c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5030:	00004717          	auipc	a4,0x4
    5034:	42a73023          	sd	a0,1056(a4) # 9450 <freep>
      return (void*)(p + 1);
    5038:	01078513          	addi	a0,a5,16
  }
}
    503c:	70e2                	ld	ra,56(sp)
    503e:	7442                	ld	s0,48(sp)
    5040:	74a2                	ld	s1,40(sp)
    5042:	69e2                	ld	s3,24(sp)
    5044:	6121                	addi	sp,sp,64
    5046:	8082                	ret
    5048:	7902                	ld	s2,32(sp)
    504a:	6a42                	ld	s4,16(sp)
    504c:	6aa2                	ld	s5,8(sp)
    504e:	6b02                	ld	s6,0(sp)
    5050:	b7f5                	j	503c <malloc+0xe2>
