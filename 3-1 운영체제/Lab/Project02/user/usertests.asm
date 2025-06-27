
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
      12:	46a78793          	addi	a5,a5,1130 # 7478 <thread_join+0x23d4>
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
      46:	27b040ef          	jal	4ac0 <open>
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
      6a:	07a50513          	addi	a0,a0,122 # 50e0 <thread_join+0x3c>
      6e:	63b040ef          	jal	4ea8 <printf>
      exit(1);
      72:	4505                	li	a0,1
      74:	20d040ef          	jal	4a80 <exit>

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
      a4:	06050513          	addi	a0,a0,96 # 5100 <thread_join+0x5c>
      a8:	601040ef          	jal	4ea8 <printf>
      exit(1);
      ac:	4505                	li	a0,1
      ae:	1d3040ef          	jal	4a80 <exit>

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
      c4:	05850513          	addi	a0,a0,88 # 5118 <thread_join+0x74>
      c8:	1f9040ef          	jal	4ac0 <open>
  if(fd < 0){
      cc:	02054263          	bltz	a0,f0 <opentest+0x3e>
  close(fd);
      d0:	1d9040ef          	jal	4aa8 <close>
  fd = open("doesnotexist", 0);
      d4:	4581                	li	a1,0
      d6:	00005517          	auipc	a0,0x5
      da:	06250513          	addi	a0,a0,98 # 5138 <thread_join+0x94>
      de:	1e3040ef          	jal	4ac0 <open>
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
      f6:	02e50513          	addi	a0,a0,46 # 5120 <thread_join+0x7c>
      fa:	5af040ef          	jal	4ea8 <printf>
    exit(1);
      fe:	4505                	li	a0,1
     100:	181040ef          	jal	4a80 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     104:	85a6                	mv	a1,s1
     106:	00005517          	auipc	a0,0x5
     10a:	04250513          	addi	a0,a0,66 # 5148 <thread_join+0xa4>
     10e:	59b040ef          	jal	4ea8 <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	16d040ef          	jal	4a80 <exit>

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
     12c:	04850513          	addi	a0,a0,72 # 5170 <thread_join+0xcc>
     130:	1a1040ef          	jal	4ad0 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     134:	60100593          	li	a1,1537
     138:	00005517          	auipc	a0,0x5
     13c:	03850513          	addi	a0,a0,56 # 5170 <thread_join+0xcc>
     140:	181040ef          	jal	4ac0 <open>
     144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     146:	4611                	li	a2,4
     148:	00005597          	auipc	a1,0x5
     14c:	03858593          	addi	a1,a1,56 # 5180 <thread_join+0xdc>
     150:	151040ef          	jal	4aa0 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     154:	40100593          	li	a1,1025
     158:	00005517          	auipc	a0,0x5
     15c:	01850513          	addi	a0,a0,24 # 5170 <thread_join+0xcc>
     160:	161040ef          	jal	4ac0 <open>
     164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     166:	4605                	li	a2,1
     168:	00005597          	auipc	a1,0x5
     16c:	02058593          	addi	a1,a1,32 # 5188 <thread_join+0xe4>
     170:	8526                	mv	a0,s1
     172:	12f040ef          	jal	4aa0 <write>
  if(n != -1){
     176:	57fd                	li	a5,-1
     178:	02f51563          	bne	a0,a5,1a2 <truncate2+0x8a>
  unlink("truncfile");
     17c:	00005517          	auipc	a0,0x5
     180:	ff450513          	addi	a0,a0,-12 # 5170 <thread_join+0xcc>
     184:	14d040ef          	jal	4ad0 <unlink>
  close(fd1);
     188:	8526                	mv	a0,s1
     18a:	11f040ef          	jal	4aa8 <close>
  close(fd2);
     18e:	854a                	mv	a0,s2
     190:	119040ef          	jal	4aa8 <close>
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
     1aa:	fea50513          	addi	a0,a0,-22 # 5190 <thread_join+0xec>
     1ae:	4fb040ef          	jal	4ea8 <printf>
    exit(1);
     1b2:	4505                	li	a0,1
     1b4:	0cd040ef          	jal	4a80 <exit>

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
     1e4:	0dd040ef          	jal	4ac0 <open>
    close(fd);
     1e8:	0c1040ef          	jal	4aa8 <close>
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
     212:	0bf040ef          	jal	4ad0 <unlink>
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
     248:	f7450513          	addi	a0,a0,-140 # 51b8 <thread_join+0x114>
     24c:	085040ef          	jal	4ad0 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     254:	00005a97          	auipc	s5,0x5
     258:	f64a8a93          	addi	s5,s5,-156 # 51b8 <thread_join+0x114>
      int cc = write(fd, buf, sz);
     25c:	0000da17          	auipc	s4,0xd
     260:	a1ca0a13          	addi	s4,s4,-1508 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     264:	6b0d                	lui	s6,0x3
     266:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x5ed>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200593          	li	a1,514
     26e:	8556                	mv	a0,s5
     270:	051040ef          	jal	4ac0 <open>
     274:	892a                	mv	s2,a0
    if(fd < 0){
     276:	04054563          	bltz	a0,2c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
     27a:	8626                	mv	a2,s1
     27c:	85d2                	mv	a1,s4
     27e:	023040ef          	jal	4aa0 <write>
     282:	89aa                	mv	s3,a0
      if(cc != sz){
     284:	04a49863          	bne	s1,a0,2d4 <bigwrite+0xa8>
      int cc = write(fd, buf, sz);
     288:	8626                	mv	a2,s1
     28a:	85d2                	mv	a1,s4
     28c:	854a                	mv	a0,s2
     28e:	013040ef          	jal	4aa0 <write>
      if(cc != sz){
     292:	04951263          	bne	a0,s1,2d6 <bigwrite+0xaa>
    close(fd);
     296:	854a                	mv	a0,s2
     298:	011040ef          	jal	4aa8 <close>
    unlink("bigwrite");
     29c:	8556                	mv	a0,s5
     29e:	033040ef          	jal	4ad0 <unlink>
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
     2c6:	f0650513          	addi	a0,a0,-250 # 51c8 <thread_join+0x124>
     2ca:	3df040ef          	jal	4ea8 <printf>
      exit(1);
     2ce:	4505                	li	a0,1
     2d0:	7b0040ef          	jal	4a80 <exit>
      if(cc != sz){
     2d4:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2d6:	86aa                	mv	a3,a0
     2d8:	864e                	mv	a2,s3
     2da:	85de                	mv	a1,s7
     2dc:	00005517          	auipc	a0,0x5
     2e0:	f0c50513          	addi	a0,a0,-244 # 51e8 <thread_join+0x144>
     2e4:	3c5040ef          	jal	4ea8 <printf>
        exit(1);
     2e8:	4505                	li	a0,1
     2ea:	796040ef          	jal	4a80 <exit>

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
     302:	f0250513          	addi	a0,a0,-254 # 5200 <thread_join+0x15c>
     306:	7ca040ef          	jal	4ad0 <unlink>
     30a:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     30e:	00005997          	auipc	s3,0x5
     312:	ef298993          	addi	s3,s3,-270 # 5200 <thread_join+0x15c>
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
     322:	79e040ef          	jal	4ac0 <open>
     326:	84aa                	mv	s1,a0
    if(fd < 0){
     328:	04054d63          	bltz	a0,382 <badwrite+0x94>
    write(fd, (char*)0xffffffffffL, 1);
     32c:	4605                	li	a2,1
     32e:	85d2                	mv	a1,s4
     330:	770040ef          	jal	4aa0 <write>
    close(fd);
     334:	8526                	mv	a0,s1
     336:	772040ef          	jal	4aa8 <close>
    unlink("junk");
     33a:	854e                	mv	a0,s3
     33c:	794040ef          	jal	4ad0 <unlink>
  for(int i = 0; i < assumed_free; i++){
     340:	397d                	addiw	s2,s2,-1
     342:	fc091de3          	bnez	s2,31c <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     346:	20100593          	li	a1,513
     34a:	00005517          	auipc	a0,0x5
     34e:	eb650513          	addi	a0,a0,-330 # 5200 <thread_join+0x15c>
     352:	76e040ef          	jal	4ac0 <open>
     356:	84aa                	mv	s1,a0
  if(fd < 0){
     358:	02054e63          	bltz	a0,394 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     35c:	4605                	li	a2,1
     35e:	00005597          	auipc	a1,0x5
     362:	e2a58593          	addi	a1,a1,-470 # 5188 <thread_join+0xe4>
     366:	73a040ef          	jal	4aa0 <write>
     36a:	4785                	li	a5,1
     36c:	02f50d63          	beq	a0,a5,3a6 <badwrite+0xb8>
    printf("write failed\n");
     370:	00005517          	auipc	a0,0x5
     374:	eb050513          	addi	a0,a0,-336 # 5220 <thread_join+0x17c>
     378:	331040ef          	jal	4ea8 <printf>
    exit(1);
     37c:	4505                	li	a0,1
     37e:	702040ef          	jal	4a80 <exit>
      printf("open junk failed\n");
     382:	00005517          	auipc	a0,0x5
     386:	e8650513          	addi	a0,a0,-378 # 5208 <thread_join+0x164>
     38a:	31f040ef          	jal	4ea8 <printf>
      exit(1);
     38e:	4505                	li	a0,1
     390:	6f0040ef          	jal	4a80 <exit>
    printf("open junk failed\n");
     394:	00005517          	auipc	a0,0x5
     398:	e7450513          	addi	a0,a0,-396 # 5208 <thread_join+0x164>
     39c:	30d040ef          	jal	4ea8 <printf>
    exit(1);
     3a0:	4505                	li	a0,1
     3a2:	6de040ef          	jal	4a80 <exit>
  }
  close(fd);
     3a6:	8526                	mv	a0,s1
     3a8:	700040ef          	jal	4aa8 <close>
  unlink("junk");
     3ac:	00005517          	auipc	a0,0x5
     3b0:	e5450513          	addi	a0,a0,-428 # 5200 <thread_join+0x15c>
     3b4:	71c040ef          	jal	4ad0 <unlink>

  exit(0);
     3b8:	4501                	li	a0,0
     3ba:	6c6040ef          	jal	4a80 <exit>

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
     40a:	6c6040ef          	jal	4ad0 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     40e:	60200593          	li	a1,1538
     412:	fb040513          	addi	a0,s0,-80
     416:	6aa040ef          	jal	4ac0 <open>
    if(fd < 0){
     41a:	00054763          	bltz	a0,428 <outofinodes+0x6a>
      // failure is eventually expected.
      break;
    }
    close(fd);
     41e:	68a040ef          	jal	4aa8 <close>
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
     466:	66a040ef          	jal	4ad0 <unlink>
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
     494:	fe878793          	addi	a5,a5,-24 # 7478 <thread_join+0x23d4>
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
     4c2:	d72a0a13          	addi	s4,s4,-654 # 5230 <thread_join+0x18c>
    uint64 addr = addrs[ai];
     4c6:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4ca:	20100593          	li	a1,513
     4ce:	8552                	mv	a0,s4
     4d0:	5f0040ef          	jal	4ac0 <open>
     4d4:	84aa                	mv	s1,a0
    if(fd < 0){
     4d6:	06054763          	bltz	a0,544 <copyin+0xc6>
    int n = write(fd, (void*)addr, 8192);
     4da:	6609                	lui	a2,0x2
     4dc:	85ce                	mv	a1,s3
     4de:	5c2040ef          	jal	4aa0 <write>
    if(n >= 0){
     4e2:	06055a63          	bgez	a0,556 <copyin+0xd8>
    close(fd);
     4e6:	8526                	mv	a0,s1
     4e8:	5c0040ef          	jal	4aa8 <close>
    unlink("copyin1");
     4ec:	8552                	mv	a0,s4
     4ee:	5e2040ef          	jal	4ad0 <unlink>
    n = write(1, (char*)addr, 8192);
     4f2:	6609                	lui	a2,0x2
     4f4:	85ce                	mv	a1,s3
     4f6:	4505                	li	a0,1
     4f8:	5a8040ef          	jal	4aa0 <write>
    if(n > 0){
     4fc:	06a04863          	bgtz	a0,56c <copyin+0xee>
    if(pipe(fds) < 0){
     500:	f9040513          	addi	a0,s0,-112
     504:	58c040ef          	jal	4a90 <pipe>
     508:	06054d63          	bltz	a0,582 <copyin+0x104>
    n = write(fds[1], (char*)addr, 8192);
     50c:	6609                	lui	a2,0x2
     50e:	85ce                	mv	a1,s3
     510:	f9442503          	lw	a0,-108(s0)
     514:	58c040ef          	jal	4aa0 <write>
    if(n > 0){
     518:	06a04e63          	bgtz	a0,594 <copyin+0x116>
    close(fds[0]);
     51c:	f9042503          	lw	a0,-112(s0)
     520:	588040ef          	jal	4aa8 <close>
    close(fds[1]);
     524:	f9442503          	lw	a0,-108(s0)
     528:	580040ef          	jal	4aa8 <close>
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
     548:	cf450513          	addi	a0,a0,-780 # 5238 <thread_join+0x194>
     54c:	15d040ef          	jal	4ea8 <printf>
      exit(1);
     550:	4505                	li	a0,1
     552:	52e040ef          	jal	4a80 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     556:	862a                	mv	a2,a0
     558:	85ce                	mv	a1,s3
     55a:	00005517          	auipc	a0,0x5
     55e:	cf650513          	addi	a0,a0,-778 # 5250 <thread_join+0x1ac>
     562:	147040ef          	jal	4ea8 <printf>
      exit(1);
     566:	4505                	li	a0,1
     568:	518040ef          	jal	4a80 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     56c:	862a                	mv	a2,a0
     56e:	85ce                	mv	a1,s3
     570:	00005517          	auipc	a0,0x5
     574:	d1050513          	addi	a0,a0,-752 # 5280 <thread_join+0x1dc>
     578:	131040ef          	jal	4ea8 <printf>
      exit(1);
     57c:	4505                	li	a0,1
     57e:	502040ef          	jal	4a80 <exit>
      printf("pipe() failed\n");
     582:	00005517          	auipc	a0,0x5
     586:	d2e50513          	addi	a0,a0,-722 # 52b0 <thread_join+0x20c>
     58a:	11f040ef          	jal	4ea8 <printf>
      exit(1);
     58e:	4505                	li	a0,1
     590:	4f0040ef          	jal	4a80 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     594:	862a                	mv	a2,a0
     596:	85ce                	mv	a1,s3
     598:	00005517          	auipc	a0,0x5
     59c:	d2850513          	addi	a0,a0,-728 # 52c0 <thread_join+0x21c>
     5a0:	109040ef          	jal	4ea8 <printf>
      exit(1);
     5a4:	4505                	li	a0,1
     5a6:	4da040ef          	jal	4a80 <exit>

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
     5c2:	eba78793          	addi	a5,a5,-326 # 7478 <thread_join+0x23d4>
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
     5f6:	cfea0a13          	addi	s4,s4,-770 # 52f0 <thread_join+0x24c>
    n = write(fds[1], "x", 1);
     5fa:	00005a97          	auipc	s5,0x5
     5fe:	b8ea8a93          	addi	s5,s5,-1138 # 5188 <thread_join+0xe4>
    uint64 addr = addrs[ai];
     602:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     606:	4581                	li	a1,0
     608:	8552                	mv	a0,s4
     60a:	4b6040ef          	jal	4ac0 <open>
     60e:	84aa                	mv	s1,a0
    if(fd < 0){
     610:	06054763          	bltz	a0,67e <copyout+0xd4>
    int n = read(fd, (void*)addr, 8192);
     614:	6609                	lui	a2,0x2
     616:	85ce                	mv	a1,s3
     618:	480040ef          	jal	4a98 <read>
    if(n > 0){
     61c:	06a04a63          	bgtz	a0,690 <copyout+0xe6>
    close(fd);
     620:	8526                	mv	a0,s1
     622:	486040ef          	jal	4aa8 <close>
    if(pipe(fds) < 0){
     626:	f8840513          	addi	a0,s0,-120
     62a:	466040ef          	jal	4a90 <pipe>
     62e:	06054c63          	bltz	a0,6a6 <copyout+0xfc>
    n = write(fds[1], "x", 1);
     632:	4605                	li	a2,1
     634:	85d6                	mv	a1,s5
     636:	f8c42503          	lw	a0,-116(s0)
     63a:	466040ef          	jal	4aa0 <write>
    if(n != 1){
     63e:	4785                	li	a5,1
     640:	06f51c63          	bne	a0,a5,6b8 <copyout+0x10e>
    n = read(fds[0], (void*)addr, 8192);
     644:	6609                	lui	a2,0x2
     646:	85ce                	mv	a1,s3
     648:	f8842503          	lw	a0,-120(s0)
     64c:	44c040ef          	jal	4a98 <read>
    if(n > 0){
     650:	06a04d63          	bgtz	a0,6ca <copyout+0x120>
    close(fds[0]);
     654:	f8842503          	lw	a0,-120(s0)
     658:	450040ef          	jal	4aa8 <close>
    close(fds[1]);
     65c:	f8c42503          	lw	a0,-116(s0)
     660:	448040ef          	jal	4aa8 <close>
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
     682:	c7a50513          	addi	a0,a0,-902 # 52f8 <thread_join+0x254>
     686:	023040ef          	jal	4ea8 <printf>
      exit(1);
     68a:	4505                	li	a0,1
     68c:	3f4040ef          	jal	4a80 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     690:	862a                	mv	a2,a0
     692:	85ce                	mv	a1,s3
     694:	00005517          	auipc	a0,0x5
     698:	c7c50513          	addi	a0,a0,-900 # 5310 <thread_join+0x26c>
     69c:	00d040ef          	jal	4ea8 <printf>
      exit(1);
     6a0:	4505                	li	a0,1
     6a2:	3de040ef          	jal	4a80 <exit>
      printf("pipe() failed\n");
     6a6:	00005517          	auipc	a0,0x5
     6aa:	c0a50513          	addi	a0,a0,-1014 # 52b0 <thread_join+0x20c>
     6ae:	7fa040ef          	jal	4ea8 <printf>
      exit(1);
     6b2:	4505                	li	a0,1
     6b4:	3cc040ef          	jal	4a80 <exit>
      printf("pipe write failed\n");
     6b8:	00005517          	auipc	a0,0x5
     6bc:	c8850513          	addi	a0,a0,-888 # 5340 <thread_join+0x29c>
     6c0:	7e8040ef          	jal	4ea8 <printf>
      exit(1);
     6c4:	4505                	li	a0,1
     6c6:	3ba040ef          	jal	4a80 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6ca:	862a                	mv	a2,a0
     6cc:	85ce                	mv	a1,s3
     6ce:	00005517          	auipc	a0,0x5
     6d2:	c8a50513          	addi	a0,a0,-886 # 5358 <thread_join+0x2b4>
     6d6:	7d2040ef          	jal	4ea8 <printf>
      exit(1);
     6da:	4505                	li	a0,1
     6dc:	3a4040ef          	jal	4a80 <exit>

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
     6f8:	a7c50513          	addi	a0,a0,-1412 # 5170 <thread_join+0xcc>
     6fc:	3d4040ef          	jal	4ad0 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     700:	60100593          	li	a1,1537
     704:	00005517          	auipc	a0,0x5
     708:	a6c50513          	addi	a0,a0,-1428 # 5170 <thread_join+0xcc>
     70c:	3b4040ef          	jal	4ac0 <open>
     710:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     712:	4611                	li	a2,4
     714:	00005597          	auipc	a1,0x5
     718:	a6c58593          	addi	a1,a1,-1428 # 5180 <thread_join+0xdc>
     71c:	384040ef          	jal	4aa0 <write>
  close(fd1);
     720:	8526                	mv	a0,s1
     722:	386040ef          	jal	4aa8 <close>
  int fd2 = open("truncfile", O_RDONLY);
     726:	4581                	li	a1,0
     728:	00005517          	auipc	a0,0x5
     72c:	a4850513          	addi	a0,a0,-1464 # 5170 <thread_join+0xcc>
     730:	390040ef          	jal	4ac0 <open>
     734:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     736:	02000613          	li	a2,32
     73a:	fa040593          	addi	a1,s0,-96
     73e:	35a040ef          	jal	4a98 <read>
  if(n != 4){
     742:	4791                	li	a5,4
     744:	0af51863          	bne	a0,a5,7f4 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     748:	40100593          	li	a1,1025
     74c:	00005517          	auipc	a0,0x5
     750:	a2450513          	addi	a0,a0,-1500 # 5170 <thread_join+0xcc>
     754:	36c040ef          	jal	4ac0 <open>
     758:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     75a:	4581                	li	a1,0
     75c:	00005517          	auipc	a0,0x5
     760:	a1450513          	addi	a0,a0,-1516 # 5170 <thread_join+0xcc>
     764:	35c040ef          	jal	4ac0 <open>
     768:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     76a:	02000613          	li	a2,32
     76e:	fa040593          	addi	a1,s0,-96
     772:	326040ef          	jal	4a98 <read>
     776:	8a2a                	mv	s4,a0
  if(n != 0){
     778:	e949                	bnez	a0,80a <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     77a:	02000613          	li	a2,32
     77e:	fa040593          	addi	a1,s0,-96
     782:	8526                	mv	a0,s1
     784:	314040ef          	jal	4a98 <read>
     788:	8a2a                	mv	s4,a0
  if(n != 0){
     78a:	e155                	bnez	a0,82e <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     78c:	4619                	li	a2,6
     78e:	00005597          	auipc	a1,0x5
     792:	c5a58593          	addi	a1,a1,-934 # 53e8 <thread_join+0x344>
     796:	854e                	mv	a0,s3
     798:	308040ef          	jal	4aa0 <write>
  n = read(fd3, buf, sizeof(buf));
     79c:	02000613          	li	a2,32
     7a0:	fa040593          	addi	a1,s0,-96
     7a4:	854a                	mv	a0,s2
     7a6:	2f2040ef          	jal	4a98 <read>
  if(n != 6){
     7aa:	4799                	li	a5,6
     7ac:	0af51363          	bne	a0,a5,852 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     7b0:	02000613          	li	a2,32
     7b4:	fa040593          	addi	a1,s0,-96
     7b8:	8526                	mv	a0,s1
     7ba:	2de040ef          	jal	4a98 <read>
  if(n != 2){
     7be:	4789                	li	a5,2
     7c0:	0af51463          	bne	a0,a5,868 <truncate1+0x188>
  unlink("truncfile");
     7c4:	00005517          	auipc	a0,0x5
     7c8:	9ac50513          	addi	a0,a0,-1620 # 5170 <thread_join+0xcc>
     7cc:	304040ef          	jal	4ad0 <unlink>
  close(fd1);
     7d0:	854e                	mv	a0,s3
     7d2:	2d6040ef          	jal	4aa8 <close>
  close(fd2);
     7d6:	8526                	mv	a0,s1
     7d8:	2d0040ef          	jal	4aa8 <close>
  close(fd3);
     7dc:	854a                	mv	a0,s2
     7de:	2ca040ef          	jal	4aa8 <close>
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
     7fc:	b9050513          	addi	a0,a0,-1136 # 5388 <thread_join+0x2e4>
     800:	6a8040ef          	jal	4ea8 <printf>
    exit(1);
     804:	4505                	li	a0,1
     806:	27a040ef          	jal	4a80 <exit>
    printf("aaa fd3=%d\n", fd3);
     80a:	85ca                	mv	a1,s2
     80c:	00005517          	auipc	a0,0x5
     810:	b9c50513          	addi	a0,a0,-1124 # 53a8 <thread_join+0x304>
     814:	694040ef          	jal	4ea8 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     818:	8652                	mv	a2,s4
     81a:	85d6                	mv	a1,s5
     81c:	00005517          	auipc	a0,0x5
     820:	b9c50513          	addi	a0,a0,-1124 # 53b8 <thread_join+0x314>
     824:	684040ef          	jal	4ea8 <printf>
    exit(1);
     828:	4505                	li	a0,1
     82a:	256040ef          	jal	4a80 <exit>
    printf("bbb fd2=%d\n", fd2);
     82e:	85a6                	mv	a1,s1
     830:	00005517          	auipc	a0,0x5
     834:	ba850513          	addi	a0,a0,-1112 # 53d8 <thread_join+0x334>
     838:	670040ef          	jal	4ea8 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     83c:	8652                	mv	a2,s4
     83e:	85d6                	mv	a1,s5
     840:	00005517          	auipc	a0,0x5
     844:	b7850513          	addi	a0,a0,-1160 # 53b8 <thread_join+0x314>
     848:	660040ef          	jal	4ea8 <printf>
    exit(1);
     84c:	4505                	li	a0,1
     84e:	232040ef          	jal	4a80 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     852:	862a                	mv	a2,a0
     854:	85d6                	mv	a1,s5
     856:	00005517          	auipc	a0,0x5
     85a:	b9a50513          	addi	a0,a0,-1126 # 53f0 <thread_join+0x34c>
     85e:	64a040ef          	jal	4ea8 <printf>
    exit(1);
     862:	4505                	li	a0,1
     864:	21c040ef          	jal	4a80 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     868:	862a                	mv	a2,a0
     86a:	85d6                	mv	a1,s5
     86c:	00005517          	auipc	a0,0x5
     870:	ba450513          	addi	a0,a0,-1116 # 5410 <thread_join+0x36c>
     874:	634040ef          	jal	4ea8 <printf>
    exit(1);
     878:	4505                	li	a0,1
     87a:	206040ef          	jal	4a80 <exit>

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
     89c:	b9850513          	addi	a0,a0,-1128 # 5430 <thread_join+0x38c>
     8a0:	220040ef          	jal	4ac0 <open>
  if(fd < 0){
     8a4:	08054f63          	bltz	a0,942 <writetest+0xc4>
     8a8:	892a                	mv	s2,a0
     8aa:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8ac:	00005997          	auipc	s3,0x5
     8b0:	bac98993          	addi	s3,s3,-1108 # 5458 <thread_join+0x3b4>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8b4:	00005a97          	auipc	s5,0x5
     8b8:	bdca8a93          	addi	s5,s5,-1060 # 5490 <thread_join+0x3ec>
  for(i = 0; i < N; i++){
     8bc:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     8c0:	4629                	li	a2,10
     8c2:	85ce                	mv	a1,s3
     8c4:	854a                	mv	a0,s2
     8c6:	1da040ef          	jal	4aa0 <write>
     8ca:	47a9                	li	a5,10
     8cc:	08f51563          	bne	a0,a5,956 <writetest+0xd8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     8d0:	4629                	li	a2,10
     8d2:	85d6                	mv	a1,s5
     8d4:	854a                	mv	a0,s2
     8d6:	1ca040ef          	jal	4aa0 <write>
     8da:	47a9                	li	a5,10
     8dc:	08f51863          	bne	a0,a5,96c <writetest+0xee>
  for(i = 0; i < N; i++){
     8e0:	2485                	addiw	s1,s1,1
     8e2:	fd449fe3          	bne	s1,s4,8c0 <writetest+0x42>
  close(fd);
     8e6:	854a                	mv	a0,s2
     8e8:	1c0040ef          	jal	4aa8 <close>
  fd = open("small", O_RDONLY);
     8ec:	4581                	li	a1,0
     8ee:	00005517          	auipc	a0,0x5
     8f2:	b4250513          	addi	a0,a0,-1214 # 5430 <thread_join+0x38c>
     8f6:	1ca040ef          	jal	4ac0 <open>
     8fa:	84aa                	mv	s1,a0
  if(fd < 0){
     8fc:	08054363          	bltz	a0,982 <writetest+0x104>
  i = read(fd, buf, N*SZ*2);
     900:	7d000613          	li	a2,2000
     904:	0000c597          	auipc	a1,0xc
     908:	37458593          	addi	a1,a1,884 # cc78 <buf>
     90c:	18c040ef          	jal	4a98 <read>
  if(i != N*SZ*2){
     910:	7d000793          	li	a5,2000
     914:	08f51163          	bne	a0,a5,996 <writetest+0x118>
  close(fd);
     918:	8526                	mv	a0,s1
     91a:	18e040ef          	jal	4aa8 <close>
  if(unlink("small") < 0){
     91e:	00005517          	auipc	a0,0x5
     922:	b1250513          	addi	a0,a0,-1262 # 5430 <thread_join+0x38c>
     926:	1aa040ef          	jal	4ad0 <unlink>
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
     948:	af450513          	addi	a0,a0,-1292 # 5438 <thread_join+0x394>
     94c:	55c040ef          	jal	4ea8 <printf>
    exit(1);
     950:	4505                	li	a0,1
     952:	12e040ef          	jal	4a80 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     956:	8626                	mv	a2,s1
     958:	85da                	mv	a1,s6
     95a:	00005517          	auipc	a0,0x5
     95e:	b0e50513          	addi	a0,a0,-1266 # 5468 <thread_join+0x3c4>
     962:	546040ef          	jal	4ea8 <printf>
      exit(1);
     966:	4505                	li	a0,1
     968:	118040ef          	jal	4a80 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     96c:	8626                	mv	a2,s1
     96e:	85da                	mv	a1,s6
     970:	00005517          	auipc	a0,0x5
     974:	b3050513          	addi	a0,a0,-1232 # 54a0 <thread_join+0x3fc>
     978:	530040ef          	jal	4ea8 <printf>
      exit(1);
     97c:	4505                	li	a0,1
     97e:	102040ef          	jal	4a80 <exit>
    printf("%s: error: open small failed!\n", s);
     982:	85da                	mv	a1,s6
     984:	00005517          	auipc	a0,0x5
     988:	b4450513          	addi	a0,a0,-1212 # 54c8 <thread_join+0x424>
     98c:	51c040ef          	jal	4ea8 <printf>
    exit(1);
     990:	4505                	li	a0,1
     992:	0ee040ef          	jal	4a80 <exit>
    printf("%s: read failed\n", s);
     996:	85da                	mv	a1,s6
     998:	00005517          	auipc	a0,0x5
     99c:	b5050513          	addi	a0,a0,-1200 # 54e8 <thread_join+0x444>
     9a0:	508040ef          	jal	4ea8 <printf>
    exit(1);
     9a4:	4505                	li	a0,1
     9a6:	0da040ef          	jal	4a80 <exit>
    printf("%s: unlink small failed\n", s);
     9aa:	85da                	mv	a1,s6
     9ac:	00005517          	auipc	a0,0x5
     9b0:	b5450513          	addi	a0,a0,-1196 # 5500 <thread_join+0x45c>
     9b4:	4f4040ef          	jal	4ea8 <printf>
    exit(1);
     9b8:	4505                	li	a0,1
     9ba:	0c6040ef          	jal	4a80 <exit>

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
     9da:	b4a50513          	addi	a0,a0,-1206 # 5520 <thread_join+0x47c>
     9de:	0e2040ef          	jal	4ac0 <open>
     9e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     9e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     9e6:	0000c917          	auipc	s2,0xc
     9ea:	29290913          	addi	s2,s2,658 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     9ee:	10c00a13          	li	s4,268
  if(fd < 0){
     9f2:	06054463          	bltz	a0,a5a <writebig+0x9c>
    ((int*)buf)[0] = i;
     9f6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     9fa:	40000613          	li	a2,1024
     9fe:	85ca                	mv	a1,s2
     a00:	854e                	mv	a0,s3
     a02:	09e040ef          	jal	4aa0 <write>
     a06:	40000793          	li	a5,1024
     a0a:	06f51263          	bne	a0,a5,a6e <writebig+0xb0>
  for(i = 0; i < MAXFILE; i++){
     a0e:	2485                	addiw	s1,s1,1
     a10:	ff4493e3          	bne	s1,s4,9f6 <writebig+0x38>
  close(fd);
     a14:	854e                	mv	a0,s3
     a16:	092040ef          	jal	4aa8 <close>
  fd = open("big", O_RDONLY);
     a1a:	4581                	li	a1,0
     a1c:	00005517          	auipc	a0,0x5
     a20:	b0450513          	addi	a0,a0,-1276 # 5520 <thread_join+0x47c>
     a24:	09c040ef          	jal	4ac0 <open>
     a28:	89aa                	mv	s3,a0
  n = 0;
     a2a:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a2c:	0000c917          	auipc	s2,0xc
     a30:	24c90913          	addi	s2,s2,588 # cc78 <buf>
  if(fd < 0){
     a34:	04054863          	bltz	a0,a84 <writebig+0xc6>
    i = read(fd, buf, BSIZE);
     a38:	40000613          	li	a2,1024
     a3c:	85ca                	mv	a1,s2
     a3e:	854e                	mv	a0,s3
     a40:	058040ef          	jal	4a98 <read>
    if(i == 0){
     a44:	c931                	beqz	a0,a98 <writebig+0xda>
    } else if(i != BSIZE){
     a46:	40000793          	li	a5,1024
     a4a:	08f51a63          	bne	a0,a5,ade <writebig+0x120>
    if(((int*)buf)[0] != n){
     a4e:	00092683          	lw	a3,0(s2)
     a52:	0a969163          	bne	a3,s1,af4 <writebig+0x136>
    n++;
     a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     a58:	b7c5                	j	a38 <writebig+0x7a>
    printf("%s: error: creat big failed!\n", s);
     a5a:	85d6                	mv	a1,s5
     a5c:	00005517          	auipc	a0,0x5
     a60:	acc50513          	addi	a0,a0,-1332 # 5528 <thread_join+0x484>
     a64:	444040ef          	jal	4ea8 <printf>
    exit(1);
     a68:	4505                	li	a0,1
     a6a:	016040ef          	jal	4a80 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     a6e:	8626                	mv	a2,s1
     a70:	85d6                	mv	a1,s5
     a72:	00005517          	auipc	a0,0x5
     a76:	ad650513          	addi	a0,a0,-1322 # 5548 <thread_join+0x4a4>
     a7a:	42e040ef          	jal	4ea8 <printf>
      exit(1);
     a7e:	4505                	li	a0,1
     a80:	000040ef          	jal	4a80 <exit>
    printf("%s: error: open big failed!\n", s);
     a84:	85d6                	mv	a1,s5
     a86:	00005517          	auipc	a0,0x5
     a8a:	aea50513          	addi	a0,a0,-1302 # 5570 <thread_join+0x4cc>
     a8e:	41a040ef          	jal	4ea8 <printf>
    exit(1);
     a92:	4505                	li	a0,1
     a94:	7ed030ef          	jal	4a80 <exit>
      if(n != MAXFILE){
     a98:	10c00793          	li	a5,268
     a9c:	02f49663          	bne	s1,a5,ac8 <writebig+0x10a>
  close(fd);
     aa0:	854e                	mv	a0,s3
     aa2:	006040ef          	jal	4aa8 <close>
  if(unlink("big") < 0){
     aa6:	00005517          	auipc	a0,0x5
     aaa:	a7a50513          	addi	a0,a0,-1414 # 5520 <thread_join+0x47c>
     aae:	022040ef          	jal	4ad0 <unlink>
     ab2:	04054c63          	bltz	a0,b0a <writebig+0x14c>
}
     ab6:	70e2                	ld	ra,56(sp)
     ab8:	7442                	ld	s0,48(sp)
     aba:	74a2                	ld	s1,40(sp)
     abc:	7902                	ld	s2,32(sp)
     abe:	69e2                	ld	s3,24(sp)
     ac0:	6a42                	ld	s4,16(sp)
     ac2:	6aa2                	ld	s5,8(sp)
     ac4:	6121                	addi	sp,sp,64
     ac6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     ac8:	8626                	mv	a2,s1
     aca:	85d6                	mv	a1,s5
     acc:	00005517          	auipc	a0,0x5
     ad0:	ac450513          	addi	a0,a0,-1340 # 5590 <thread_join+0x4ec>
     ad4:	3d4040ef          	jal	4ea8 <printf>
        exit(1);
     ad8:	4505                	li	a0,1
     ada:	7a7030ef          	jal	4a80 <exit>
      printf("%s: read failed %d\n", s, i);
     ade:	862a                	mv	a2,a0
     ae0:	85d6                	mv	a1,s5
     ae2:	00005517          	auipc	a0,0x5
     ae6:	ad650513          	addi	a0,a0,-1322 # 55b8 <thread_join+0x514>
     aea:	3be040ef          	jal	4ea8 <printf>
      exit(1);
     aee:	4505                	li	a0,1
     af0:	791030ef          	jal	4a80 <exit>
      printf("%s: read content of block %d is %d\n", s,
     af4:	8626                	mv	a2,s1
     af6:	85d6                	mv	a1,s5
     af8:	00005517          	auipc	a0,0x5
     afc:	ad850513          	addi	a0,a0,-1320 # 55d0 <thread_join+0x52c>
     b00:	3a8040ef          	jal	4ea8 <printf>
      exit(1);
     b04:	4505                	li	a0,1
     b06:	77b030ef          	jal	4a80 <exit>
    printf("%s: unlink big failed\n", s);
     b0a:	85d6                	mv	a1,s5
     b0c:	00005517          	auipc	a0,0x5
     b10:	aec50513          	addi	a0,a0,-1300 # 55f8 <thread_join+0x554>
     b14:	394040ef          	jal	4ea8 <printf>
    exit(1);
     b18:	4505                	li	a0,1
     b1a:	767030ef          	jal	4a80 <exit>

0000000000000b1e <unlinkread>:
{
     b1e:	7179                	addi	sp,sp,-48
     b20:	f406                	sd	ra,40(sp)
     b22:	f022                	sd	s0,32(sp)
     b24:	ec26                	sd	s1,24(sp)
     b26:	e84a                	sd	s2,16(sp)
     b28:	e44e                	sd	s3,8(sp)
     b2a:	1800                	addi	s0,sp,48
     b2c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b2e:	20200593          	li	a1,514
     b32:	00005517          	auipc	a0,0x5
     b36:	ade50513          	addi	a0,a0,-1314 # 5610 <thread_join+0x56c>
     b3a:	787030ef          	jal	4ac0 <open>
  if(fd < 0){
     b3e:	0a054f63          	bltz	a0,bfc <unlinkread+0xde>
     b42:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b44:	4615                	li	a2,5
     b46:	00005597          	auipc	a1,0x5
     b4a:	afa58593          	addi	a1,a1,-1286 # 5640 <thread_join+0x59c>
     b4e:	753030ef          	jal	4aa0 <write>
  close(fd);
     b52:	8526                	mv	a0,s1
     b54:	755030ef          	jal	4aa8 <close>
  fd = open("unlinkread", O_RDWR);
     b58:	4589                	li	a1,2
     b5a:	00005517          	auipc	a0,0x5
     b5e:	ab650513          	addi	a0,a0,-1354 # 5610 <thread_join+0x56c>
     b62:	75f030ef          	jal	4ac0 <open>
     b66:	84aa                	mv	s1,a0
  if(fd < 0){
     b68:	0a054463          	bltz	a0,c10 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     b6c:	00005517          	auipc	a0,0x5
     b70:	aa450513          	addi	a0,a0,-1372 # 5610 <thread_join+0x56c>
     b74:	75d030ef          	jal	4ad0 <unlink>
     b78:	e555                	bnez	a0,c24 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     b7a:	20200593          	li	a1,514
     b7e:	00005517          	auipc	a0,0x5
     b82:	a9250513          	addi	a0,a0,-1390 # 5610 <thread_join+0x56c>
     b86:	73b030ef          	jal	4ac0 <open>
     b8a:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     b8c:	460d                	li	a2,3
     b8e:	00005597          	auipc	a1,0x5
     b92:	afa58593          	addi	a1,a1,-1286 # 5688 <thread_join+0x5e4>
     b96:	70b030ef          	jal	4aa0 <write>
  close(fd1);
     b9a:	854a                	mv	a0,s2
     b9c:	70d030ef          	jal	4aa8 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     ba0:	660d                	lui	a2,0x3
     ba2:	0000c597          	auipc	a1,0xc
     ba6:	0d658593          	addi	a1,a1,214 # cc78 <buf>
     baa:	8526                	mv	a0,s1
     bac:	6ed030ef          	jal	4a98 <read>
     bb0:	4795                	li	a5,5
     bb2:	08f51363          	bne	a0,a5,c38 <unlinkread+0x11a>
  if(buf[0] != 'h'){
     bb6:	0000c717          	auipc	a4,0xc
     bba:	0c274703          	lbu	a4,194(a4) # cc78 <buf>
     bbe:	06800793          	li	a5,104
     bc2:	08f71563          	bne	a4,a5,c4c <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     bc6:	4629                	li	a2,10
     bc8:	0000c597          	auipc	a1,0xc
     bcc:	0b058593          	addi	a1,a1,176 # cc78 <buf>
     bd0:	8526                	mv	a0,s1
     bd2:	6cf030ef          	jal	4aa0 <write>
     bd6:	47a9                	li	a5,10
     bd8:	08f51463          	bne	a0,a5,c60 <unlinkread+0x142>
  close(fd);
     bdc:	8526                	mv	a0,s1
     bde:	6cb030ef          	jal	4aa8 <close>
  unlink("unlinkread");
     be2:	00005517          	auipc	a0,0x5
     be6:	a2e50513          	addi	a0,a0,-1490 # 5610 <thread_join+0x56c>
     bea:	6e7030ef          	jal	4ad0 <unlink>
}
     bee:	70a2                	ld	ra,40(sp)
     bf0:	7402                	ld	s0,32(sp)
     bf2:	64e2                	ld	s1,24(sp)
     bf4:	6942                	ld	s2,16(sp)
     bf6:	69a2                	ld	s3,8(sp)
     bf8:	6145                	addi	sp,sp,48
     bfa:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     bfc:	85ce                	mv	a1,s3
     bfe:	00005517          	auipc	a0,0x5
     c02:	a2250513          	addi	a0,a0,-1502 # 5620 <thread_join+0x57c>
     c06:	2a2040ef          	jal	4ea8 <printf>
    exit(1);
     c0a:	4505                	li	a0,1
     c0c:	675030ef          	jal	4a80 <exit>
    printf("%s: open unlinkread failed\n", s);
     c10:	85ce                	mv	a1,s3
     c12:	00005517          	auipc	a0,0x5
     c16:	a3650513          	addi	a0,a0,-1482 # 5648 <thread_join+0x5a4>
     c1a:	28e040ef          	jal	4ea8 <printf>
    exit(1);
     c1e:	4505                	li	a0,1
     c20:	661030ef          	jal	4a80 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c24:	85ce                	mv	a1,s3
     c26:	00005517          	auipc	a0,0x5
     c2a:	a4250513          	addi	a0,a0,-1470 # 5668 <thread_join+0x5c4>
     c2e:	27a040ef          	jal	4ea8 <printf>
    exit(1);
     c32:	4505                	li	a0,1
     c34:	64d030ef          	jal	4a80 <exit>
    printf("%s: unlinkread read failed", s);
     c38:	85ce                	mv	a1,s3
     c3a:	00005517          	auipc	a0,0x5
     c3e:	a5650513          	addi	a0,a0,-1450 # 5690 <thread_join+0x5ec>
     c42:	266040ef          	jal	4ea8 <printf>
    exit(1);
     c46:	4505                	li	a0,1
     c48:	639030ef          	jal	4a80 <exit>
    printf("%s: unlinkread wrong data\n", s);
     c4c:	85ce                	mv	a1,s3
     c4e:	00005517          	auipc	a0,0x5
     c52:	a6250513          	addi	a0,a0,-1438 # 56b0 <thread_join+0x60c>
     c56:	252040ef          	jal	4ea8 <printf>
    exit(1);
     c5a:	4505                	li	a0,1
     c5c:	625030ef          	jal	4a80 <exit>
    printf("%s: unlinkread write failed\n", s);
     c60:	85ce                	mv	a1,s3
     c62:	00005517          	auipc	a0,0x5
     c66:	a6e50513          	addi	a0,a0,-1426 # 56d0 <thread_join+0x62c>
     c6a:	23e040ef          	jal	4ea8 <printf>
    exit(1);
     c6e:	4505                	li	a0,1
     c70:	611030ef          	jal	4a80 <exit>

0000000000000c74 <linktest>:
{
     c74:	1101                	addi	sp,sp,-32
     c76:	ec06                	sd	ra,24(sp)
     c78:	e822                	sd	s0,16(sp)
     c7a:	e426                	sd	s1,8(sp)
     c7c:	e04a                	sd	s2,0(sp)
     c7e:	1000                	addi	s0,sp,32
     c80:	892a                	mv	s2,a0
  unlink("lf1");
     c82:	00005517          	auipc	a0,0x5
     c86:	a6e50513          	addi	a0,a0,-1426 # 56f0 <thread_join+0x64c>
     c8a:	647030ef          	jal	4ad0 <unlink>
  unlink("lf2");
     c8e:	00005517          	auipc	a0,0x5
     c92:	a6a50513          	addi	a0,a0,-1430 # 56f8 <thread_join+0x654>
     c96:	63b030ef          	jal	4ad0 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     c9a:	20200593          	li	a1,514
     c9e:	00005517          	auipc	a0,0x5
     ca2:	a5250513          	addi	a0,a0,-1454 # 56f0 <thread_join+0x64c>
     ca6:	61b030ef          	jal	4ac0 <open>
  if(fd < 0){
     caa:	0c054f63          	bltz	a0,d88 <linktest+0x114>
     cae:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     cb0:	4615                	li	a2,5
     cb2:	00005597          	auipc	a1,0x5
     cb6:	98e58593          	addi	a1,a1,-1650 # 5640 <thread_join+0x59c>
     cba:	5e7030ef          	jal	4aa0 <write>
     cbe:	4795                	li	a5,5
     cc0:	0cf51e63          	bne	a0,a5,d9c <linktest+0x128>
  close(fd);
     cc4:	8526                	mv	a0,s1
     cc6:	5e3030ef          	jal	4aa8 <close>
  if(link("lf1", "lf2") < 0){
     cca:	00005597          	auipc	a1,0x5
     cce:	a2e58593          	addi	a1,a1,-1490 # 56f8 <thread_join+0x654>
     cd2:	00005517          	auipc	a0,0x5
     cd6:	a1e50513          	addi	a0,a0,-1506 # 56f0 <thread_join+0x64c>
     cda:	607030ef          	jal	4ae0 <link>
     cde:	0c054963          	bltz	a0,db0 <linktest+0x13c>
  unlink("lf1");
     ce2:	00005517          	auipc	a0,0x5
     ce6:	a0e50513          	addi	a0,a0,-1522 # 56f0 <thread_join+0x64c>
     cea:	5e7030ef          	jal	4ad0 <unlink>
  if(open("lf1", 0) >= 0){
     cee:	4581                	li	a1,0
     cf0:	00005517          	auipc	a0,0x5
     cf4:	a0050513          	addi	a0,a0,-1536 # 56f0 <thread_join+0x64c>
     cf8:	5c9030ef          	jal	4ac0 <open>
     cfc:	0c055463          	bgez	a0,dc4 <linktest+0x150>
  fd = open("lf2", 0);
     d00:	4581                	li	a1,0
     d02:	00005517          	auipc	a0,0x5
     d06:	9f650513          	addi	a0,a0,-1546 # 56f8 <thread_join+0x654>
     d0a:	5b7030ef          	jal	4ac0 <open>
     d0e:	84aa                	mv	s1,a0
  if(fd < 0){
     d10:	0c054463          	bltz	a0,dd8 <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d14:	660d                	lui	a2,0x3
     d16:	0000c597          	auipc	a1,0xc
     d1a:	f6258593          	addi	a1,a1,-158 # cc78 <buf>
     d1e:	57b030ef          	jal	4a98 <read>
     d22:	4795                	li	a5,5
     d24:	0cf51463          	bne	a0,a5,dec <linktest+0x178>
  close(fd);
     d28:	8526                	mv	a0,s1
     d2a:	57f030ef          	jal	4aa8 <close>
  if(link("lf2", "lf2") >= 0){
     d2e:	00005597          	auipc	a1,0x5
     d32:	9ca58593          	addi	a1,a1,-1590 # 56f8 <thread_join+0x654>
     d36:	852e                	mv	a0,a1
     d38:	5a9030ef          	jal	4ae0 <link>
     d3c:	0c055263          	bgez	a0,e00 <linktest+0x18c>
  unlink("lf2");
     d40:	00005517          	auipc	a0,0x5
     d44:	9b850513          	addi	a0,a0,-1608 # 56f8 <thread_join+0x654>
     d48:	589030ef          	jal	4ad0 <unlink>
  if(link("lf2", "lf1") >= 0){
     d4c:	00005597          	auipc	a1,0x5
     d50:	9a458593          	addi	a1,a1,-1628 # 56f0 <thread_join+0x64c>
     d54:	00005517          	auipc	a0,0x5
     d58:	9a450513          	addi	a0,a0,-1628 # 56f8 <thread_join+0x654>
     d5c:	585030ef          	jal	4ae0 <link>
     d60:	0a055a63          	bgez	a0,e14 <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     d64:	00005597          	auipc	a1,0x5
     d68:	98c58593          	addi	a1,a1,-1652 # 56f0 <thread_join+0x64c>
     d6c:	00005517          	auipc	a0,0x5
     d70:	a9450513          	addi	a0,a0,-1388 # 5800 <thread_join+0x75c>
     d74:	56d030ef          	jal	4ae0 <link>
     d78:	0a055863          	bgez	a0,e28 <linktest+0x1b4>
}
     d7c:	60e2                	ld	ra,24(sp)
     d7e:	6442                	ld	s0,16(sp)
     d80:	64a2                	ld	s1,8(sp)
     d82:	6902                	ld	s2,0(sp)
     d84:	6105                	addi	sp,sp,32
     d86:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     d88:	85ca                	mv	a1,s2
     d8a:	00005517          	auipc	a0,0x5
     d8e:	97650513          	addi	a0,a0,-1674 # 5700 <thread_join+0x65c>
     d92:	116040ef          	jal	4ea8 <printf>
    exit(1);
     d96:	4505                	li	a0,1
     d98:	4e9030ef          	jal	4a80 <exit>
    printf("%s: write lf1 failed\n", s);
     d9c:	85ca                	mv	a1,s2
     d9e:	00005517          	auipc	a0,0x5
     da2:	97a50513          	addi	a0,a0,-1670 # 5718 <thread_join+0x674>
     da6:	102040ef          	jal	4ea8 <printf>
    exit(1);
     daa:	4505                	li	a0,1
     dac:	4d5030ef          	jal	4a80 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     db0:	85ca                	mv	a1,s2
     db2:	00005517          	auipc	a0,0x5
     db6:	97e50513          	addi	a0,a0,-1666 # 5730 <thread_join+0x68c>
     dba:	0ee040ef          	jal	4ea8 <printf>
    exit(1);
     dbe:	4505                	li	a0,1
     dc0:	4c1030ef          	jal	4a80 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     dc4:	85ca                	mv	a1,s2
     dc6:	00005517          	auipc	a0,0x5
     dca:	98a50513          	addi	a0,a0,-1654 # 5750 <thread_join+0x6ac>
     dce:	0da040ef          	jal	4ea8 <printf>
    exit(1);
     dd2:	4505                	li	a0,1
     dd4:	4ad030ef          	jal	4a80 <exit>
    printf("%s: open lf2 failed\n", s);
     dd8:	85ca                	mv	a1,s2
     dda:	00005517          	auipc	a0,0x5
     dde:	9a650513          	addi	a0,a0,-1626 # 5780 <thread_join+0x6dc>
     de2:	0c6040ef          	jal	4ea8 <printf>
    exit(1);
     de6:	4505                	li	a0,1
     de8:	499030ef          	jal	4a80 <exit>
    printf("%s: read lf2 failed\n", s);
     dec:	85ca                	mv	a1,s2
     dee:	00005517          	auipc	a0,0x5
     df2:	9aa50513          	addi	a0,a0,-1622 # 5798 <thread_join+0x6f4>
     df6:	0b2040ef          	jal	4ea8 <printf>
    exit(1);
     dfa:	4505                	li	a0,1
     dfc:	485030ef          	jal	4a80 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e00:	85ca                	mv	a1,s2
     e02:	00005517          	auipc	a0,0x5
     e06:	9ae50513          	addi	a0,a0,-1618 # 57b0 <thread_join+0x70c>
     e0a:	09e040ef          	jal	4ea8 <printf>
    exit(1);
     e0e:	4505                	li	a0,1
     e10:	471030ef          	jal	4a80 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e14:	85ca                	mv	a1,s2
     e16:	00005517          	auipc	a0,0x5
     e1a:	9c250513          	addi	a0,a0,-1598 # 57d8 <thread_join+0x734>
     e1e:	08a040ef          	jal	4ea8 <printf>
    exit(1);
     e22:	4505                	li	a0,1
     e24:	45d030ef          	jal	4a80 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e28:	85ca                	mv	a1,s2
     e2a:	00005517          	auipc	a0,0x5
     e2e:	9de50513          	addi	a0,a0,-1570 # 5808 <thread_join+0x764>
     e32:	076040ef          	jal	4ea8 <printf>
    exit(1);
     e36:	4505                	li	a0,1
     e38:	449030ef          	jal	4a80 <exit>

0000000000000e3c <validatetest>:
{
     e3c:	7139                	addi	sp,sp,-64
     e3e:	fc06                	sd	ra,56(sp)
     e40:	f822                	sd	s0,48(sp)
     e42:	f426                	sd	s1,40(sp)
     e44:	f04a                	sd	s2,32(sp)
     e46:	ec4e                	sd	s3,24(sp)
     e48:	e852                	sd	s4,16(sp)
     e4a:	e456                	sd	s5,8(sp)
     e4c:	e05a                	sd	s6,0(sp)
     e4e:	0080                	addi	s0,sp,64
     e50:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e52:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     e54:	00005997          	auipc	s3,0x5
     e58:	9d498993          	addi	s3,s3,-1580 # 5828 <thread_join+0x784>
     e5c:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e5e:	6a85                	lui	s5,0x1
     e60:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     e64:	85a6                	mv	a1,s1
     e66:	854e                	mv	a0,s3
     e68:	479030ef          	jal	4ae0 <link>
     e6c:	01251f63          	bne	a0,s2,e8a <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     e70:	94d6                	add	s1,s1,s5
     e72:	ff4499e3          	bne	s1,s4,e64 <validatetest+0x28>
}
     e76:	70e2                	ld	ra,56(sp)
     e78:	7442                	ld	s0,48(sp)
     e7a:	74a2                	ld	s1,40(sp)
     e7c:	7902                	ld	s2,32(sp)
     e7e:	69e2                	ld	s3,24(sp)
     e80:	6a42                	ld	s4,16(sp)
     e82:	6aa2                	ld	s5,8(sp)
     e84:	6b02                	ld	s6,0(sp)
     e86:	6121                	addi	sp,sp,64
     e88:	8082                	ret
      printf("%s: link should not succeed\n", s);
     e8a:	85da                	mv	a1,s6
     e8c:	00005517          	auipc	a0,0x5
     e90:	9ac50513          	addi	a0,a0,-1620 # 5838 <thread_join+0x794>
     e94:	014040ef          	jal	4ea8 <printf>
      exit(1);
     e98:	4505                	li	a0,1
     e9a:	3e7030ef          	jal	4a80 <exit>

0000000000000e9e <bigdir>:
{
     e9e:	715d                	addi	sp,sp,-80
     ea0:	e486                	sd	ra,72(sp)
     ea2:	e0a2                	sd	s0,64(sp)
     ea4:	fc26                	sd	s1,56(sp)
     ea6:	f84a                	sd	s2,48(sp)
     ea8:	f44e                	sd	s3,40(sp)
     eaa:	f052                	sd	s4,32(sp)
     eac:	ec56                	sd	s5,24(sp)
     eae:	e85a                	sd	s6,16(sp)
     eb0:	0880                	addi	s0,sp,80
     eb2:	89aa                	mv	s3,a0
  unlink("bd");
     eb4:	00005517          	auipc	a0,0x5
     eb8:	9a450513          	addi	a0,a0,-1628 # 5858 <thread_join+0x7b4>
     ebc:	415030ef          	jal	4ad0 <unlink>
  fd = open("bd", O_CREATE);
     ec0:	20000593          	li	a1,512
     ec4:	00005517          	auipc	a0,0x5
     ec8:	99450513          	addi	a0,a0,-1644 # 5858 <thread_join+0x7b4>
     ecc:	3f5030ef          	jal	4ac0 <open>
  if(fd < 0){
     ed0:	0c054163          	bltz	a0,f92 <bigdir+0xf4>
  close(fd);
     ed4:	3d5030ef          	jal	4aa8 <close>
  for(i = 0; i < N; i++){
     ed8:	4901                	li	s2,0
    name[0] = 'x';
     eda:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     ede:	00005a17          	auipc	s4,0x5
     ee2:	97aa0a13          	addi	s4,s4,-1670 # 5858 <thread_join+0x7b4>
  for(i = 0; i < N; i++){
     ee6:	1f400b13          	li	s6,500
    name[0] = 'x';
     eea:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
     eee:	41f9571b          	sraiw	a4,s2,0x1f
     ef2:	01a7571b          	srliw	a4,a4,0x1a
     ef6:	012707bb          	addw	a5,a4,s2
     efa:	4067d69b          	sraiw	a3,a5,0x6
     efe:	0306869b          	addiw	a3,a3,48
     f02:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f06:	03f7f793          	andi	a5,a5,63
     f0a:	9f99                	subw	a5,a5,a4
     f0c:	0307879b          	addiw	a5,a5,48
     f10:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f14:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
     f18:	fb040593          	addi	a1,s0,-80
     f1c:	8552                	mv	a0,s4
     f1e:	3c3030ef          	jal	4ae0 <link>
     f22:	84aa                	mv	s1,a0
     f24:	e149                	bnez	a0,fa6 <bigdir+0x108>
  for(i = 0; i < N; i++){
     f26:	2905                	addiw	s2,s2,1
     f28:	fd6911e3          	bne	s2,s6,eea <bigdir+0x4c>
  unlink("bd");
     f2c:	00005517          	auipc	a0,0x5
     f30:	92c50513          	addi	a0,a0,-1748 # 5858 <thread_join+0x7b4>
     f34:	39d030ef          	jal	4ad0 <unlink>
    name[0] = 'x';
     f38:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
     f3c:	1f400a13          	li	s4,500
    name[0] = 'x';
     f40:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
     f44:	41f4d71b          	sraiw	a4,s1,0x1f
     f48:	01a7571b          	srliw	a4,a4,0x1a
     f4c:	009707bb          	addw	a5,a4,s1
     f50:	4067d69b          	sraiw	a3,a5,0x6
     f54:	0306869b          	addiw	a3,a3,48
     f58:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
     f5c:	03f7f793          	andi	a5,a5,63
     f60:	9f99                	subw	a5,a5,a4
     f62:	0307879b          	addiw	a5,a5,48
     f66:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
     f6a:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
     f6e:	fb040513          	addi	a0,s0,-80
     f72:	35f030ef          	jal	4ad0 <unlink>
     f76:	e529                	bnez	a0,fc0 <bigdir+0x122>
  for(i = 0; i < N; i++){
     f78:	2485                	addiw	s1,s1,1
     f7a:	fd4493e3          	bne	s1,s4,f40 <bigdir+0xa2>
}
     f7e:	60a6                	ld	ra,72(sp)
     f80:	6406                	ld	s0,64(sp)
     f82:	74e2                	ld	s1,56(sp)
     f84:	7942                	ld	s2,48(sp)
     f86:	79a2                	ld	s3,40(sp)
     f88:	7a02                	ld	s4,32(sp)
     f8a:	6ae2                	ld	s5,24(sp)
     f8c:	6b42                	ld	s6,16(sp)
     f8e:	6161                	addi	sp,sp,80
     f90:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     f92:	85ce                	mv	a1,s3
     f94:	00005517          	auipc	a0,0x5
     f98:	8cc50513          	addi	a0,a0,-1844 # 5860 <thread_join+0x7bc>
     f9c:	70d030ef          	jal	4ea8 <printf>
    exit(1);
     fa0:	4505                	li	a0,1
     fa2:	2df030ef          	jal	4a80 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
     fa6:	fb040693          	addi	a3,s0,-80
     faa:	864a                	mv	a2,s2
     fac:	85ce                	mv	a1,s3
     fae:	00005517          	auipc	a0,0x5
     fb2:	8d250513          	addi	a0,a0,-1838 # 5880 <thread_join+0x7dc>
     fb6:	6f3030ef          	jal	4ea8 <printf>
      exit(1);
     fba:	4505                	li	a0,1
     fbc:	2c5030ef          	jal	4a80 <exit>
      printf("%s: bigdir unlink failed", s);
     fc0:	85ce                	mv	a1,s3
     fc2:	00005517          	auipc	a0,0x5
     fc6:	8e650513          	addi	a0,a0,-1818 # 58a8 <thread_join+0x804>
     fca:	6df030ef          	jal	4ea8 <printf>
      exit(1);
     fce:	4505                	li	a0,1
     fd0:	2b1030ef          	jal	4a80 <exit>

0000000000000fd4 <pgbug>:
{
     fd4:	7179                	addi	sp,sp,-48
     fd6:	f406                	sd	ra,40(sp)
     fd8:	f022                	sd	s0,32(sp)
     fda:	ec26                	sd	s1,24(sp)
     fdc:	1800                	addi	s0,sp,48
  argv[0] = 0;
     fde:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
     fe2:	00008497          	auipc	s1,0x8
     fe6:	01e48493          	addi	s1,s1,30 # 9000 <big>
     fea:	fd840593          	addi	a1,s0,-40
     fee:	6088                	ld	a0,0(s1)
     ff0:	2c9030ef          	jal	4ab8 <exec>
  pipe(big);
     ff4:	6088                	ld	a0,0(s1)
     ff6:	29b030ef          	jal	4a90 <pipe>
  exit(0);
     ffa:	4501                	li	a0,0
     ffc:	285030ef          	jal	4a80 <exit>

0000000000001000 <badarg>:
{
    1000:	7139                	addi	sp,sp,-64
    1002:	fc06                	sd	ra,56(sp)
    1004:	f822                	sd	s0,48(sp)
    1006:	f426                	sd	s1,40(sp)
    1008:	f04a                	sd	s2,32(sp)
    100a:	ec4e                	sd	s3,24(sp)
    100c:	0080                	addi	s0,sp,64
    100e:	64b1                	lui	s1,0xc
    1010:	35048493          	addi	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    1014:	597d                	li	s2,-1
    1016:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    101a:	00004997          	auipc	s3,0x4
    101e:	0fe98993          	addi	s3,s3,254 # 5118 <thread_join+0x74>
    argv[0] = (char*)0xffffffff;
    1022:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1026:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    102a:	fc040593          	addi	a1,s0,-64
    102e:	854e                	mv	a0,s3
    1030:	289030ef          	jal	4ab8 <exec>
  for(int i = 0; i < 50000; i++){
    1034:	34fd                	addiw	s1,s1,-1
    1036:	f4f5                	bnez	s1,1022 <badarg+0x22>
  exit(0);
    1038:	4501                	li	a0,0
    103a:	247030ef          	jal	4a80 <exit>

000000000000103e <copyinstr2>:
{
    103e:	7155                	addi	sp,sp,-208
    1040:	e586                	sd	ra,200(sp)
    1042:	e1a2                	sd	s0,192(sp)
    1044:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1046:	f6840793          	addi	a5,s0,-152
    104a:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    104e:	07800713          	li	a4,120
    1052:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    1056:	0785                	addi	a5,a5,1
    1058:	fed79de3          	bne	a5,a3,1052 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    105c:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    1060:	f6840513          	addi	a0,s0,-152
    1064:	26d030ef          	jal	4ad0 <unlink>
  if(ret != -1){
    1068:	57fd                	li	a5,-1
    106a:	0cf51263          	bne	a0,a5,112e <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    106e:	20100593          	li	a1,513
    1072:	f6840513          	addi	a0,s0,-152
    1076:	24b030ef          	jal	4ac0 <open>
  if(fd != -1){
    107a:	57fd                	li	a5,-1
    107c:	0cf51563          	bne	a0,a5,1146 <copyinstr2+0x108>
  ret = link(b, b);
    1080:	f6840593          	addi	a1,s0,-152
    1084:	852e                	mv	a0,a1
    1086:	25b030ef          	jal	4ae0 <link>
  if(ret != -1){
    108a:	57fd                	li	a5,-1
    108c:	0cf51963          	bne	a0,a5,115e <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    1090:	00006797          	auipc	a5,0x6
    1094:	96878793          	addi	a5,a5,-1688 # 69f8 <thread_join+0x1954>
    1098:	f4f43c23          	sd	a5,-168(s0)
    109c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    10a0:	f5840593          	addi	a1,s0,-168
    10a4:	f6840513          	addi	a0,s0,-152
    10a8:	211030ef          	jal	4ab8 <exec>
  if(ret != -1){
    10ac:	57fd                	li	a5,-1
    10ae:	0cf51563          	bne	a0,a5,1178 <copyinstr2+0x13a>
  int pid = fork();
    10b2:	1c7030ef          	jal	4a78 <fork>
  if(pid < 0){
    10b6:	0c054d63          	bltz	a0,1190 <copyinstr2+0x152>
  if(pid == 0){
    10ba:	0e051863          	bnez	a0,11aa <copyinstr2+0x16c>
    10be:	00008797          	auipc	a5,0x8
    10c2:	4a278793          	addi	a5,a5,1186 # 9560 <big.0>
    10c6:	00009697          	auipc	a3,0x9
    10ca:	49a68693          	addi	a3,a3,1178 # a560 <big.0+0x1000>
      big[i] = 'x';
    10ce:	07800713          	li	a4,120
    10d2:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    10d6:	0785                	addi	a5,a5,1
    10d8:	fed79de3          	bne	a5,a3,10d2 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    10dc:	00009797          	auipc	a5,0x9
    10e0:	48078223          	sb	zero,1156(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    10e4:	00006797          	auipc	a5,0x6
    10e8:	39478793          	addi	a5,a5,916 # 7478 <thread_join+0x23d4>
    10ec:	6fb0                	ld	a2,88(a5)
    10ee:	73b4                	ld	a3,96(a5)
    10f0:	77b8                	ld	a4,104(a5)
    10f2:	7bbc                	ld	a5,112(a5)
    10f4:	f2c43823          	sd	a2,-208(s0)
    10f8:	f2d43c23          	sd	a3,-200(s0)
    10fc:	f4e43023          	sd	a4,-192(s0)
    1100:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1104:	f3040593          	addi	a1,s0,-208
    1108:	00004517          	auipc	a0,0x4
    110c:	01050513          	addi	a0,a0,16 # 5118 <thread_join+0x74>
    1110:	1a9030ef          	jal	4ab8 <exec>
    if(ret != -1){
    1114:	57fd                	li	a5,-1
    1116:	08f50663          	beq	a0,a5,11a2 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    111a:	55fd                	li	a1,-1
    111c:	00005517          	auipc	a0,0x5
    1120:	83450513          	addi	a0,a0,-1996 # 5950 <thread_join+0x8ac>
    1124:	585030ef          	jal	4ea8 <printf>
      exit(1);
    1128:	4505                	li	a0,1
    112a:	157030ef          	jal	4a80 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    112e:	862a                	mv	a2,a0
    1130:	f6840593          	addi	a1,s0,-152
    1134:	00004517          	auipc	a0,0x4
    1138:	79450513          	addi	a0,a0,1940 # 58c8 <thread_join+0x824>
    113c:	56d030ef          	jal	4ea8 <printf>
    exit(1);
    1140:	4505                	li	a0,1
    1142:	13f030ef          	jal	4a80 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1146:	862a                	mv	a2,a0
    1148:	f6840593          	addi	a1,s0,-152
    114c:	00004517          	auipc	a0,0x4
    1150:	79c50513          	addi	a0,a0,1948 # 58e8 <thread_join+0x844>
    1154:	555030ef          	jal	4ea8 <printf>
    exit(1);
    1158:	4505                	li	a0,1
    115a:	127030ef          	jal	4a80 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    115e:	86aa                	mv	a3,a0
    1160:	f6840613          	addi	a2,s0,-152
    1164:	85b2                	mv	a1,a2
    1166:	00004517          	auipc	a0,0x4
    116a:	7a250513          	addi	a0,a0,1954 # 5908 <thread_join+0x864>
    116e:	53b030ef          	jal	4ea8 <printf>
    exit(1);
    1172:	4505                	li	a0,1
    1174:	10d030ef          	jal	4a80 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1178:	567d                	li	a2,-1
    117a:	f6840593          	addi	a1,s0,-152
    117e:	00004517          	auipc	a0,0x4
    1182:	7b250513          	addi	a0,a0,1970 # 5930 <thread_join+0x88c>
    1186:	523030ef          	jal	4ea8 <printf>
    exit(1);
    118a:	4505                	li	a0,1
    118c:	0f5030ef          	jal	4a80 <exit>
    printf("fork failed\n");
    1190:	00006517          	auipc	a0,0x6
    1194:	d8850513          	addi	a0,a0,-632 # 6f18 <thread_join+0x1e74>
    1198:	511030ef          	jal	4ea8 <printf>
    exit(1);
    119c:	4505                	li	a0,1
    119e:	0e3030ef          	jal	4a80 <exit>
    exit(747); // OK
    11a2:	2eb00513          	li	a0,747
    11a6:	0db030ef          	jal	4a80 <exit>
  int st = 0;
    11aa:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    11ae:	f5440513          	addi	a0,s0,-172
    11b2:	0d7030ef          	jal	4a88 <wait>
  if(st != 747){
    11b6:	f5442703          	lw	a4,-172(s0)
    11ba:	2eb00793          	li	a5,747
    11be:	00f71663          	bne	a4,a5,11ca <copyinstr2+0x18c>
}
    11c2:	60ae                	ld	ra,200(sp)
    11c4:	640e                	ld	s0,192(sp)
    11c6:	6169                	addi	sp,sp,208
    11c8:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    11ca:	00004517          	auipc	a0,0x4
    11ce:	7ae50513          	addi	a0,a0,1966 # 5978 <thread_join+0x8d4>
    11d2:	4d7030ef          	jal	4ea8 <printf>
    exit(1);
    11d6:	4505                	li	a0,1
    11d8:	0a9030ef          	jal	4a80 <exit>

00000000000011dc <truncate3>:
{
    11dc:	7159                	addi	sp,sp,-112
    11de:	f486                	sd	ra,104(sp)
    11e0:	f0a2                	sd	s0,96(sp)
    11e2:	e8ca                	sd	s2,80(sp)
    11e4:	1880                	addi	s0,sp,112
    11e6:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    11e8:	60100593          	li	a1,1537
    11ec:	00004517          	auipc	a0,0x4
    11f0:	f8450513          	addi	a0,a0,-124 # 5170 <thread_join+0xcc>
    11f4:	0cd030ef          	jal	4ac0 <open>
    11f8:	0b1030ef          	jal	4aa8 <close>
  pid = fork();
    11fc:	07d030ef          	jal	4a78 <fork>
  if(pid < 0){
    1200:	06054663          	bltz	a0,126c <truncate3+0x90>
  if(pid == 0){
    1204:	e55d                	bnez	a0,12b2 <truncate3+0xd6>
    1206:	eca6                	sd	s1,88(sp)
    1208:	e4ce                	sd	s3,72(sp)
    120a:	e0d2                	sd	s4,64(sp)
    120c:	fc56                	sd	s5,56(sp)
    120e:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    1212:	00004a17          	auipc	s4,0x4
    1216:	f5ea0a13          	addi	s4,s4,-162 # 5170 <thread_join+0xcc>
      int n = write(fd, "1234567890", 10);
    121a:	00004a97          	auipc	s5,0x4
    121e:	7bea8a93          	addi	s5,s5,1982 # 59d8 <thread_join+0x934>
      int fd = open("truncfile", O_WRONLY);
    1222:	4585                	li	a1,1
    1224:	8552                	mv	a0,s4
    1226:	09b030ef          	jal	4ac0 <open>
    122a:	84aa                	mv	s1,a0
      if(fd < 0){
    122c:	04054e63          	bltz	a0,1288 <truncate3+0xac>
      int n = write(fd, "1234567890", 10);
    1230:	4629                	li	a2,10
    1232:	85d6                	mv	a1,s5
    1234:	06d030ef          	jal	4aa0 <write>
      if(n != 10){
    1238:	47a9                	li	a5,10
    123a:	06f51163          	bne	a0,a5,129c <truncate3+0xc0>
      close(fd);
    123e:	8526                	mv	a0,s1
    1240:	069030ef          	jal	4aa8 <close>
      fd = open("truncfile", O_RDONLY);
    1244:	4581                	li	a1,0
    1246:	8552                	mv	a0,s4
    1248:	079030ef          	jal	4ac0 <open>
    124c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    124e:	02000613          	li	a2,32
    1252:	f9840593          	addi	a1,s0,-104
    1256:	043030ef          	jal	4a98 <read>
      close(fd);
    125a:	8526                	mv	a0,s1
    125c:	04d030ef          	jal	4aa8 <close>
    for(int i = 0; i < 100; i++){
    1260:	39fd                	addiw	s3,s3,-1
    1262:	fc0990e3          	bnez	s3,1222 <truncate3+0x46>
    exit(0);
    1266:	4501                	li	a0,0
    1268:	019030ef          	jal	4a80 <exit>
    126c:	eca6                	sd	s1,88(sp)
    126e:	e4ce                	sd	s3,72(sp)
    1270:	e0d2                	sd	s4,64(sp)
    1272:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1274:	85ca                	mv	a1,s2
    1276:	00004517          	auipc	a0,0x4
    127a:	73250513          	addi	a0,a0,1842 # 59a8 <thread_join+0x904>
    127e:	42b030ef          	jal	4ea8 <printf>
    exit(1);
    1282:	4505                	li	a0,1
    1284:	7fc030ef          	jal	4a80 <exit>
        printf("%s: open failed\n", s);
    1288:	85ca                	mv	a1,s2
    128a:	00004517          	auipc	a0,0x4
    128e:	73650513          	addi	a0,a0,1846 # 59c0 <thread_join+0x91c>
    1292:	417030ef          	jal	4ea8 <printf>
        exit(1);
    1296:	4505                	li	a0,1
    1298:	7e8030ef          	jal	4a80 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    129c:	862a                	mv	a2,a0
    129e:	85ca                	mv	a1,s2
    12a0:	00004517          	auipc	a0,0x4
    12a4:	74850513          	addi	a0,a0,1864 # 59e8 <thread_join+0x944>
    12a8:	401030ef          	jal	4ea8 <printf>
        exit(1);
    12ac:	4505                	li	a0,1
    12ae:	7d2030ef          	jal	4a80 <exit>
    12b2:	eca6                	sd	s1,88(sp)
    12b4:	e4ce                	sd	s3,72(sp)
    12b6:	e0d2                	sd	s4,64(sp)
    12b8:	fc56                	sd	s5,56(sp)
    12ba:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12be:	00004a17          	auipc	s4,0x4
    12c2:	eb2a0a13          	addi	s4,s4,-334 # 5170 <thread_join+0xcc>
    int n = write(fd, "xxx", 3);
    12c6:	00004a97          	auipc	s5,0x4
    12ca:	742a8a93          	addi	s5,s5,1858 # 5a08 <thread_join+0x964>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    12ce:	60100593          	li	a1,1537
    12d2:	8552                	mv	a0,s4
    12d4:	7ec030ef          	jal	4ac0 <open>
    12d8:	84aa                	mv	s1,a0
    if(fd < 0){
    12da:	02054d63          	bltz	a0,1314 <truncate3+0x138>
    int n = write(fd, "xxx", 3);
    12de:	460d                	li	a2,3
    12e0:	85d6                	mv	a1,s5
    12e2:	7be030ef          	jal	4aa0 <write>
    if(n != 3){
    12e6:	478d                	li	a5,3
    12e8:	04f51063          	bne	a0,a5,1328 <truncate3+0x14c>
    close(fd);
    12ec:	8526                	mv	a0,s1
    12ee:	7ba030ef          	jal	4aa8 <close>
  for(int i = 0; i < 150; i++){
    12f2:	39fd                	addiw	s3,s3,-1
    12f4:	fc099de3          	bnez	s3,12ce <truncate3+0xf2>
  wait(&xstatus);
    12f8:	fbc40513          	addi	a0,s0,-68
    12fc:	78c030ef          	jal	4a88 <wait>
  unlink("truncfile");
    1300:	00004517          	auipc	a0,0x4
    1304:	e7050513          	addi	a0,a0,-400 # 5170 <thread_join+0xcc>
    1308:	7c8030ef          	jal	4ad0 <unlink>
  exit(xstatus);
    130c:	fbc42503          	lw	a0,-68(s0)
    1310:	770030ef          	jal	4a80 <exit>
      printf("%s: open failed\n", s);
    1314:	85ca                	mv	a1,s2
    1316:	00004517          	auipc	a0,0x4
    131a:	6aa50513          	addi	a0,a0,1706 # 59c0 <thread_join+0x91c>
    131e:	38b030ef          	jal	4ea8 <printf>
      exit(1);
    1322:	4505                	li	a0,1
    1324:	75c030ef          	jal	4a80 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1328:	862a                	mv	a2,a0
    132a:	85ca                	mv	a1,s2
    132c:	00004517          	auipc	a0,0x4
    1330:	6e450513          	addi	a0,a0,1764 # 5a10 <thread_join+0x96c>
    1334:	375030ef          	jal	4ea8 <printf>
      exit(1);
    1338:	4505                	li	a0,1
    133a:	746030ef          	jal	4a80 <exit>

000000000000133e <exectest>:
{
    133e:	715d                	addi	sp,sp,-80
    1340:	e486                	sd	ra,72(sp)
    1342:	e0a2                	sd	s0,64(sp)
    1344:	f84a                	sd	s2,48(sp)
    1346:	0880                	addi	s0,sp,80
    1348:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    134a:	00004797          	auipc	a5,0x4
    134e:	dce78793          	addi	a5,a5,-562 # 5118 <thread_join+0x74>
    1352:	fcf43023          	sd	a5,-64(s0)
    1356:	00004797          	auipc	a5,0x4
    135a:	6da78793          	addi	a5,a5,1754 # 5a30 <thread_join+0x98c>
    135e:	fcf43423          	sd	a5,-56(s0)
    1362:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1366:	00004517          	auipc	a0,0x4
    136a:	6d250513          	addi	a0,a0,1746 # 5a38 <thread_join+0x994>
    136e:	762030ef          	jal	4ad0 <unlink>
  pid = fork();
    1372:	706030ef          	jal	4a78 <fork>
  if(pid < 0) {
    1376:	02054f63          	bltz	a0,13b4 <exectest+0x76>
    137a:	fc26                	sd	s1,56(sp)
    137c:	84aa                	mv	s1,a0
  if(pid == 0) {
    137e:	e935                	bnez	a0,13f2 <exectest+0xb4>
    close(1);
    1380:	4505                	li	a0,1
    1382:	726030ef          	jal	4aa8 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1386:	20100593          	li	a1,513
    138a:	00004517          	auipc	a0,0x4
    138e:	6ae50513          	addi	a0,a0,1710 # 5a38 <thread_join+0x994>
    1392:	72e030ef          	jal	4ac0 <open>
    if(fd < 0) {
    1396:	02054a63          	bltz	a0,13ca <exectest+0x8c>
    if(fd != 1) {
    139a:	4785                	li	a5,1
    139c:	04f50163          	beq	a0,a5,13de <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    13a0:	85ca                	mv	a1,s2
    13a2:	00004517          	auipc	a0,0x4
    13a6:	6b650513          	addi	a0,a0,1718 # 5a58 <thread_join+0x9b4>
    13aa:	2ff030ef          	jal	4ea8 <printf>
      exit(1);
    13ae:	4505                	li	a0,1
    13b0:	6d0030ef          	jal	4a80 <exit>
    13b4:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    13b6:	85ca                	mv	a1,s2
    13b8:	00004517          	auipc	a0,0x4
    13bc:	5f050513          	addi	a0,a0,1520 # 59a8 <thread_join+0x904>
    13c0:	2e9030ef          	jal	4ea8 <printf>
     exit(1);
    13c4:	4505                	li	a0,1
    13c6:	6ba030ef          	jal	4a80 <exit>
      printf("%s: create failed\n", s);
    13ca:	85ca                	mv	a1,s2
    13cc:	00004517          	auipc	a0,0x4
    13d0:	67450513          	addi	a0,a0,1652 # 5a40 <thread_join+0x99c>
    13d4:	2d5030ef          	jal	4ea8 <printf>
      exit(1);
    13d8:	4505                	li	a0,1
    13da:	6a6030ef          	jal	4a80 <exit>
    if(exec("echo", echoargv) < 0){
    13de:	fc040593          	addi	a1,s0,-64
    13e2:	00004517          	auipc	a0,0x4
    13e6:	d3650513          	addi	a0,a0,-714 # 5118 <thread_join+0x74>
    13ea:	6ce030ef          	jal	4ab8 <exec>
    13ee:	00054d63          	bltz	a0,1408 <exectest+0xca>
  if (wait(&xstatus) != pid) {
    13f2:	fdc40513          	addi	a0,s0,-36
    13f6:	692030ef          	jal	4a88 <wait>
    13fa:	02951163          	bne	a0,s1,141c <exectest+0xde>
  if(xstatus != 0)
    13fe:	fdc42503          	lw	a0,-36(s0)
    1402:	c50d                	beqz	a0,142c <exectest+0xee>
    exit(xstatus);
    1404:	67c030ef          	jal	4a80 <exit>
      printf("%s: exec echo failed\n", s);
    1408:	85ca                	mv	a1,s2
    140a:	00004517          	auipc	a0,0x4
    140e:	65e50513          	addi	a0,a0,1630 # 5a68 <thread_join+0x9c4>
    1412:	297030ef          	jal	4ea8 <printf>
      exit(1);
    1416:	4505                	li	a0,1
    1418:	668030ef          	jal	4a80 <exit>
    printf("%s: wait failed!\n", s);
    141c:	85ca                	mv	a1,s2
    141e:	00004517          	auipc	a0,0x4
    1422:	66250513          	addi	a0,a0,1634 # 5a80 <thread_join+0x9dc>
    1426:	283030ef          	jal	4ea8 <printf>
    142a:	bfd1                	j	13fe <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    142c:	4581                	li	a1,0
    142e:	00004517          	auipc	a0,0x4
    1432:	60a50513          	addi	a0,a0,1546 # 5a38 <thread_join+0x994>
    1436:	68a030ef          	jal	4ac0 <open>
  if(fd < 0) {
    143a:	02054463          	bltz	a0,1462 <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    143e:	4609                	li	a2,2
    1440:	fb840593          	addi	a1,s0,-72
    1444:	654030ef          	jal	4a98 <read>
    1448:	4789                	li	a5,2
    144a:	02f50663          	beq	a0,a5,1476 <exectest+0x138>
    printf("%s: read failed\n", s);
    144e:	85ca                	mv	a1,s2
    1450:	00004517          	auipc	a0,0x4
    1454:	09850513          	addi	a0,a0,152 # 54e8 <thread_join+0x444>
    1458:	251030ef          	jal	4ea8 <printf>
    exit(1);
    145c:	4505                	li	a0,1
    145e:	622030ef          	jal	4a80 <exit>
    printf("%s: open failed\n", s);
    1462:	85ca                	mv	a1,s2
    1464:	00004517          	auipc	a0,0x4
    1468:	55c50513          	addi	a0,a0,1372 # 59c0 <thread_join+0x91c>
    146c:	23d030ef          	jal	4ea8 <printf>
    exit(1);
    1470:	4505                	li	a0,1
    1472:	60e030ef          	jal	4a80 <exit>
  unlink("echo-ok");
    1476:	00004517          	auipc	a0,0x4
    147a:	5c250513          	addi	a0,a0,1474 # 5a38 <thread_join+0x994>
    147e:	652030ef          	jal	4ad0 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1482:	fb844703          	lbu	a4,-72(s0)
    1486:	04f00793          	li	a5,79
    148a:	00f71863          	bne	a4,a5,149a <exectest+0x15c>
    148e:	fb944703          	lbu	a4,-71(s0)
    1492:	04b00793          	li	a5,75
    1496:	00f70c63          	beq	a4,a5,14ae <exectest+0x170>
    printf("%s: wrong output\n", s);
    149a:	85ca                	mv	a1,s2
    149c:	00004517          	auipc	a0,0x4
    14a0:	5fc50513          	addi	a0,a0,1532 # 5a98 <thread_join+0x9f4>
    14a4:	205030ef          	jal	4ea8 <printf>
    exit(1);
    14a8:	4505                	li	a0,1
    14aa:	5d6030ef          	jal	4a80 <exit>
    exit(0);
    14ae:	4501                	li	a0,0
    14b0:	5d0030ef          	jal	4a80 <exit>

00000000000014b4 <pipe1>:
{
    14b4:	711d                	addi	sp,sp,-96
    14b6:	ec86                	sd	ra,88(sp)
    14b8:	e8a2                	sd	s0,80(sp)
    14ba:	fc4e                	sd	s3,56(sp)
    14bc:	1080                	addi	s0,sp,96
    14be:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    14c0:	fa840513          	addi	a0,s0,-88
    14c4:	5cc030ef          	jal	4a90 <pipe>
    14c8:	e92d                	bnez	a0,153a <pipe1+0x86>
    14ca:	e4a6                	sd	s1,72(sp)
    14cc:	f852                	sd	s4,48(sp)
    14ce:	84aa                	mv	s1,a0
  pid = fork();
    14d0:	5a8030ef          	jal	4a78 <fork>
    14d4:	8a2a                	mv	s4,a0
  if(pid == 0){
    14d6:	c151                	beqz	a0,155a <pipe1+0xa6>
  } else if(pid > 0){
    14d8:	14a05e63          	blez	a0,1634 <pipe1+0x180>
    14dc:	e0ca                	sd	s2,64(sp)
    14de:	f456                	sd	s5,40(sp)
    close(fds[1]);
    14e0:	fac42503          	lw	a0,-84(s0)
    14e4:	5c4030ef          	jal	4aa8 <close>
    total = 0;
    14e8:	8a26                	mv	s4,s1
    cc = 1;
    14ea:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    14ec:	0000ba97          	auipc	s5,0xb
    14f0:	78ca8a93          	addi	s5,s5,1932 # cc78 <buf>
    14f4:	864a                	mv	a2,s2
    14f6:	85d6                	mv	a1,s5
    14f8:	fa842503          	lw	a0,-88(s0)
    14fc:	59c030ef          	jal	4a98 <read>
    1500:	0ea05a63          	blez	a0,15f4 <pipe1+0x140>
      for(i = 0; i < n; i++){
    1504:	0000b717          	auipc	a4,0xb
    1508:	77470713          	addi	a4,a4,1908 # cc78 <buf>
    150c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    1510:	00074683          	lbu	a3,0(a4)
    1514:	0ff4f793          	zext.b	a5,s1
    1518:	2485                	addiw	s1,s1,1
    151a:	0af69d63          	bne	a3,a5,15d4 <pipe1+0x120>
      for(i = 0; i < n; i++){
    151e:	0705                	addi	a4,a4,1
    1520:	fec498e3          	bne	s1,a2,1510 <pipe1+0x5c>
      total += n;
    1524:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    1528:	0019179b          	slliw	a5,s2,0x1
    152c:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    1530:	670d                	lui	a4,0x3
    1532:	fd2771e3          	bgeu	a4,s2,14f4 <pipe1+0x40>
        cc = sizeof(buf);
    1536:	690d                	lui	s2,0x3
    1538:	bf75                	j	14f4 <pipe1+0x40>
    153a:	e4a6                	sd	s1,72(sp)
    153c:	e0ca                	sd	s2,64(sp)
    153e:	f852                	sd	s4,48(sp)
    1540:	f456                	sd	s5,40(sp)
    1542:	f05a                	sd	s6,32(sp)
    1544:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    1546:	85ce                	mv	a1,s3
    1548:	00004517          	auipc	a0,0x4
    154c:	56850513          	addi	a0,a0,1384 # 5ab0 <thread_join+0xa0c>
    1550:	159030ef          	jal	4ea8 <printf>
    exit(1);
    1554:	4505                	li	a0,1
    1556:	52a030ef          	jal	4a80 <exit>
    155a:	e0ca                	sd	s2,64(sp)
    155c:	f456                	sd	s5,40(sp)
    155e:	f05a                	sd	s6,32(sp)
    1560:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1562:	fa842503          	lw	a0,-88(s0)
    1566:	542030ef          	jal	4aa8 <close>
    for(n = 0; n < N; n++){
    156a:	0000bb17          	auipc	s6,0xb
    156e:	70eb0b13          	addi	s6,s6,1806 # cc78 <buf>
    1572:	416004bb          	negw	s1,s6
    1576:	0ff4f493          	zext.b	s1,s1
    157a:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    157e:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1580:	6a85                	lui	s5,0x1
    1582:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0xef>
{
    1586:	87da                	mv	a5,s6
        buf[i] = seq++;
    1588:	0097873b          	addw	a4,a5,s1
    158c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1590:	0785                	addi	a5,a5,1
    1592:	ff279be3          	bne	a5,s2,1588 <pipe1+0xd4>
    1596:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    159a:	40900613          	li	a2,1033
    159e:	85de                	mv	a1,s7
    15a0:	fac42503          	lw	a0,-84(s0)
    15a4:	4fc030ef          	jal	4aa0 <write>
    15a8:	40900793          	li	a5,1033
    15ac:	00f51a63          	bne	a0,a5,15c0 <pipe1+0x10c>
    for(n = 0; n < N; n++){
    15b0:	24a5                	addiw	s1,s1,9
    15b2:	0ff4f493          	zext.b	s1,s1
    15b6:	fd5a18e3          	bne	s4,s5,1586 <pipe1+0xd2>
    exit(0);
    15ba:	4501                	li	a0,0
    15bc:	4c4030ef          	jal	4a80 <exit>
        printf("%s: pipe1 oops 1\n", s);
    15c0:	85ce                	mv	a1,s3
    15c2:	00004517          	auipc	a0,0x4
    15c6:	50650513          	addi	a0,a0,1286 # 5ac8 <thread_join+0xa24>
    15ca:	0df030ef          	jal	4ea8 <printf>
        exit(1);
    15ce:	4505                	li	a0,1
    15d0:	4b0030ef          	jal	4a80 <exit>
          printf("%s: pipe1 oops 2\n", s);
    15d4:	85ce                	mv	a1,s3
    15d6:	00004517          	auipc	a0,0x4
    15da:	50a50513          	addi	a0,a0,1290 # 5ae0 <thread_join+0xa3c>
    15de:	0cb030ef          	jal	4ea8 <printf>
          return;
    15e2:	64a6                	ld	s1,72(sp)
    15e4:	6906                	ld	s2,64(sp)
    15e6:	7a42                	ld	s4,48(sp)
    15e8:	7aa2                	ld	s5,40(sp)
}
    15ea:	60e6                	ld	ra,88(sp)
    15ec:	6446                	ld	s0,80(sp)
    15ee:	79e2                	ld	s3,56(sp)
    15f0:	6125                	addi	sp,sp,96
    15f2:	8082                	ret
    if(total != N * SZ){
    15f4:	6785                	lui	a5,0x1
    15f6:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0xef>
    15fa:	00fa0f63          	beq	s4,a5,1618 <pipe1+0x164>
    15fe:	f05a                	sd	s6,32(sp)
    1600:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1602:	8652                	mv	a2,s4
    1604:	85ce                	mv	a1,s3
    1606:	00004517          	auipc	a0,0x4
    160a:	4f250513          	addi	a0,a0,1266 # 5af8 <thread_join+0xa54>
    160e:	09b030ef          	jal	4ea8 <printf>
      exit(1);
    1612:	4505                	li	a0,1
    1614:	46c030ef          	jal	4a80 <exit>
    1618:	f05a                	sd	s6,32(sp)
    161a:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    161c:	fa842503          	lw	a0,-88(s0)
    1620:	488030ef          	jal	4aa8 <close>
    wait(&xstatus);
    1624:	fa440513          	addi	a0,s0,-92
    1628:	460030ef          	jal	4a88 <wait>
    exit(xstatus);
    162c:	fa442503          	lw	a0,-92(s0)
    1630:	450030ef          	jal	4a80 <exit>
    1634:	e0ca                	sd	s2,64(sp)
    1636:	f456                	sd	s5,40(sp)
    1638:	f05a                	sd	s6,32(sp)
    163a:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    163c:	85ce                	mv	a1,s3
    163e:	00004517          	auipc	a0,0x4
    1642:	4da50513          	addi	a0,a0,1242 # 5b18 <thread_join+0xa74>
    1646:	063030ef          	jal	4ea8 <printf>
    exit(1);
    164a:	4505                	li	a0,1
    164c:	434030ef          	jal	4a80 <exit>

0000000000001650 <exitwait>:
{
    1650:	7139                	addi	sp,sp,-64
    1652:	fc06                	sd	ra,56(sp)
    1654:	f822                	sd	s0,48(sp)
    1656:	f426                	sd	s1,40(sp)
    1658:	f04a                	sd	s2,32(sp)
    165a:	ec4e                	sd	s3,24(sp)
    165c:	e852                	sd	s4,16(sp)
    165e:	0080                	addi	s0,sp,64
    1660:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1662:	4901                	li	s2,0
    1664:	06400993          	li	s3,100
    pid = fork();
    1668:	410030ef          	jal	4a78 <fork>
    166c:	84aa                	mv	s1,a0
    if(pid < 0){
    166e:	02054863          	bltz	a0,169e <exitwait+0x4e>
    if(pid){
    1672:	c525                	beqz	a0,16da <exitwait+0x8a>
      if(wait(&xstate) != pid){
    1674:	fcc40513          	addi	a0,s0,-52
    1678:	410030ef          	jal	4a88 <wait>
    167c:	02951b63          	bne	a0,s1,16b2 <exitwait+0x62>
      if(i != xstate) {
    1680:	fcc42783          	lw	a5,-52(s0)
    1684:	05279163          	bne	a5,s2,16c6 <exitwait+0x76>
  for(i = 0; i < 100; i++){
    1688:	2905                	addiw	s2,s2,1 # 3001 <subdir+0x425>
    168a:	fd391fe3          	bne	s2,s3,1668 <exitwait+0x18>
}
    168e:	70e2                	ld	ra,56(sp)
    1690:	7442                	ld	s0,48(sp)
    1692:	74a2                	ld	s1,40(sp)
    1694:	7902                	ld	s2,32(sp)
    1696:	69e2                	ld	s3,24(sp)
    1698:	6a42                	ld	s4,16(sp)
    169a:	6121                	addi	sp,sp,64
    169c:	8082                	ret
      printf("%s: fork failed\n", s);
    169e:	85d2                	mv	a1,s4
    16a0:	00004517          	auipc	a0,0x4
    16a4:	30850513          	addi	a0,a0,776 # 59a8 <thread_join+0x904>
    16a8:	001030ef          	jal	4ea8 <printf>
      exit(1);
    16ac:	4505                	li	a0,1
    16ae:	3d2030ef          	jal	4a80 <exit>
        printf("%s: wait wrong pid\n", s);
    16b2:	85d2                	mv	a1,s4
    16b4:	00004517          	auipc	a0,0x4
    16b8:	47c50513          	addi	a0,a0,1148 # 5b30 <thread_join+0xa8c>
    16bc:	7ec030ef          	jal	4ea8 <printf>
        exit(1);
    16c0:	4505                	li	a0,1
    16c2:	3be030ef          	jal	4a80 <exit>
        printf("%s: wait wrong exit status\n", s);
    16c6:	85d2                	mv	a1,s4
    16c8:	00004517          	auipc	a0,0x4
    16cc:	48050513          	addi	a0,a0,1152 # 5b48 <thread_join+0xaa4>
    16d0:	7d8030ef          	jal	4ea8 <printf>
        exit(1);
    16d4:	4505                	li	a0,1
    16d6:	3aa030ef          	jal	4a80 <exit>
      exit(i);
    16da:	854a                	mv	a0,s2
    16dc:	3a4030ef          	jal	4a80 <exit>

00000000000016e0 <twochildren>:
{
    16e0:	1101                	addi	sp,sp,-32
    16e2:	ec06                	sd	ra,24(sp)
    16e4:	e822                	sd	s0,16(sp)
    16e6:	e426                	sd	s1,8(sp)
    16e8:	e04a                	sd	s2,0(sp)
    16ea:	1000                	addi	s0,sp,32
    16ec:	892a                	mv	s2,a0
    16ee:	3e800493          	li	s1,1000
    int pid1 = fork();
    16f2:	386030ef          	jal	4a78 <fork>
    if(pid1 < 0){
    16f6:	02054663          	bltz	a0,1722 <twochildren+0x42>
    if(pid1 == 0){
    16fa:	cd15                	beqz	a0,1736 <twochildren+0x56>
      int pid2 = fork();
    16fc:	37c030ef          	jal	4a78 <fork>
      if(pid2 < 0){
    1700:	02054d63          	bltz	a0,173a <twochildren+0x5a>
      if(pid2 == 0){
    1704:	c529                	beqz	a0,174e <twochildren+0x6e>
        wait(0);
    1706:	4501                	li	a0,0
    1708:	380030ef          	jal	4a88 <wait>
        wait(0);
    170c:	4501                	li	a0,0
    170e:	37a030ef          	jal	4a88 <wait>
  for(int i = 0; i < 1000; i++){
    1712:	34fd                	addiw	s1,s1,-1
    1714:	fcf9                	bnez	s1,16f2 <twochildren+0x12>
}
    1716:	60e2                	ld	ra,24(sp)
    1718:	6442                	ld	s0,16(sp)
    171a:	64a2                	ld	s1,8(sp)
    171c:	6902                	ld	s2,0(sp)
    171e:	6105                	addi	sp,sp,32
    1720:	8082                	ret
      printf("%s: fork failed\n", s);
    1722:	85ca                	mv	a1,s2
    1724:	00004517          	auipc	a0,0x4
    1728:	28450513          	addi	a0,a0,644 # 59a8 <thread_join+0x904>
    172c:	77c030ef          	jal	4ea8 <printf>
      exit(1);
    1730:	4505                	li	a0,1
    1732:	34e030ef          	jal	4a80 <exit>
      exit(0);
    1736:	34a030ef          	jal	4a80 <exit>
        printf("%s: fork failed\n", s);
    173a:	85ca                	mv	a1,s2
    173c:	00004517          	auipc	a0,0x4
    1740:	26c50513          	addi	a0,a0,620 # 59a8 <thread_join+0x904>
    1744:	764030ef          	jal	4ea8 <printf>
        exit(1);
    1748:	4505                	li	a0,1
    174a:	336030ef          	jal	4a80 <exit>
        exit(0);
    174e:	332030ef          	jal	4a80 <exit>

0000000000001752 <forkfork>:
{
    1752:	7179                	addi	sp,sp,-48
    1754:	f406                	sd	ra,40(sp)
    1756:	f022                	sd	s0,32(sp)
    1758:	ec26                	sd	s1,24(sp)
    175a:	1800                	addi	s0,sp,48
    175c:	84aa                	mv	s1,a0
    int pid = fork();
    175e:	31a030ef          	jal	4a78 <fork>
    if(pid < 0){
    1762:	02054b63          	bltz	a0,1798 <forkfork+0x46>
    if(pid == 0){
    1766:	c139                	beqz	a0,17ac <forkfork+0x5a>
    int pid = fork();
    1768:	310030ef          	jal	4a78 <fork>
    if(pid < 0){
    176c:	02054663          	bltz	a0,1798 <forkfork+0x46>
    if(pid == 0){
    1770:	cd15                	beqz	a0,17ac <forkfork+0x5a>
    wait(&xstatus);
    1772:	fdc40513          	addi	a0,s0,-36
    1776:	312030ef          	jal	4a88 <wait>
    if(xstatus != 0) {
    177a:	fdc42783          	lw	a5,-36(s0)
    177e:	ebb9                	bnez	a5,17d4 <forkfork+0x82>
    wait(&xstatus);
    1780:	fdc40513          	addi	a0,s0,-36
    1784:	304030ef          	jal	4a88 <wait>
    if(xstatus != 0) {
    1788:	fdc42783          	lw	a5,-36(s0)
    178c:	e7a1                	bnez	a5,17d4 <forkfork+0x82>
}
    178e:	70a2                	ld	ra,40(sp)
    1790:	7402                	ld	s0,32(sp)
    1792:	64e2                	ld	s1,24(sp)
    1794:	6145                	addi	sp,sp,48
    1796:	8082                	ret
      printf("%s: fork failed", s);
    1798:	85a6                	mv	a1,s1
    179a:	00004517          	auipc	a0,0x4
    179e:	3ce50513          	addi	a0,a0,974 # 5b68 <thread_join+0xac4>
    17a2:	706030ef          	jal	4ea8 <printf>
      exit(1);
    17a6:	4505                	li	a0,1
    17a8:	2d8030ef          	jal	4a80 <exit>
{
    17ac:	0c800493          	li	s1,200
        int pid1 = fork();
    17b0:	2c8030ef          	jal	4a78 <fork>
        if(pid1 < 0){
    17b4:	00054b63          	bltz	a0,17ca <forkfork+0x78>
        if(pid1 == 0){
    17b8:	cd01                	beqz	a0,17d0 <forkfork+0x7e>
        wait(0);
    17ba:	4501                	li	a0,0
    17bc:	2cc030ef          	jal	4a88 <wait>
      for(int j = 0; j < 200; j++){
    17c0:	34fd                	addiw	s1,s1,-1
    17c2:	f4fd                	bnez	s1,17b0 <forkfork+0x5e>
      exit(0);
    17c4:	4501                	li	a0,0
    17c6:	2ba030ef          	jal	4a80 <exit>
          exit(1);
    17ca:	4505                	li	a0,1
    17cc:	2b4030ef          	jal	4a80 <exit>
          exit(0);
    17d0:	2b0030ef          	jal	4a80 <exit>
      printf("%s: fork in child failed", s);
    17d4:	85a6                	mv	a1,s1
    17d6:	00004517          	auipc	a0,0x4
    17da:	3a250513          	addi	a0,a0,930 # 5b78 <thread_join+0xad4>
    17de:	6ca030ef          	jal	4ea8 <printf>
      exit(1);
    17e2:	4505                	li	a0,1
    17e4:	29c030ef          	jal	4a80 <exit>

00000000000017e8 <reparent2>:
{
    17e8:	1101                	addi	sp,sp,-32
    17ea:	ec06                	sd	ra,24(sp)
    17ec:	e822                	sd	s0,16(sp)
    17ee:	e426                	sd	s1,8(sp)
    17f0:	1000                	addi	s0,sp,32
    17f2:	32000493          	li	s1,800
    int pid1 = fork();
    17f6:	282030ef          	jal	4a78 <fork>
    if(pid1 < 0){
    17fa:	00054b63          	bltz	a0,1810 <reparent2+0x28>
    if(pid1 == 0){
    17fe:	c115                	beqz	a0,1822 <reparent2+0x3a>
    wait(0);
    1800:	4501                	li	a0,0
    1802:	286030ef          	jal	4a88 <wait>
  for(int i = 0; i < 800; i++){
    1806:	34fd                	addiw	s1,s1,-1
    1808:	f4fd                	bnez	s1,17f6 <reparent2+0xe>
  exit(0);
    180a:	4501                	li	a0,0
    180c:	274030ef          	jal	4a80 <exit>
      printf("fork failed\n");
    1810:	00005517          	auipc	a0,0x5
    1814:	70850513          	addi	a0,a0,1800 # 6f18 <thread_join+0x1e74>
    1818:	690030ef          	jal	4ea8 <printf>
      exit(1);
    181c:	4505                	li	a0,1
    181e:	262030ef          	jal	4a80 <exit>
      fork();
    1822:	256030ef          	jal	4a78 <fork>
      fork();
    1826:	252030ef          	jal	4a78 <fork>
      exit(0);
    182a:	4501                	li	a0,0
    182c:	254030ef          	jal	4a80 <exit>

0000000000001830 <createdelete>:
{
    1830:	7175                	addi	sp,sp,-144
    1832:	e506                	sd	ra,136(sp)
    1834:	e122                	sd	s0,128(sp)
    1836:	fca6                	sd	s1,120(sp)
    1838:	f8ca                	sd	s2,112(sp)
    183a:	f4ce                	sd	s3,104(sp)
    183c:	f0d2                	sd	s4,96(sp)
    183e:	ecd6                	sd	s5,88(sp)
    1840:	e8da                	sd	s6,80(sp)
    1842:	e4de                	sd	s7,72(sp)
    1844:	e0e2                	sd	s8,64(sp)
    1846:	fc66                	sd	s9,56(sp)
    1848:	0900                	addi	s0,sp,144
    184a:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    184c:	4901                	li	s2,0
    184e:	4991                	li	s3,4
    pid = fork();
    1850:	228030ef          	jal	4a78 <fork>
    1854:	84aa                	mv	s1,a0
    if(pid < 0){
    1856:	02054d63          	bltz	a0,1890 <createdelete+0x60>
    if(pid == 0){
    185a:	c529                	beqz	a0,18a4 <createdelete+0x74>
  for(pi = 0; pi < NCHILD; pi++){
    185c:	2905                	addiw	s2,s2,1
    185e:	ff3919e3          	bne	s2,s3,1850 <createdelete+0x20>
    1862:	4491                	li	s1,4
    wait(&xstatus);
    1864:	f7c40513          	addi	a0,s0,-132
    1868:	220030ef          	jal	4a88 <wait>
    if(xstatus != 0)
    186c:	f7c42903          	lw	s2,-132(s0)
    1870:	0a091e63          	bnez	s2,192c <createdelete+0xfc>
  for(pi = 0; pi < NCHILD; pi++){
    1874:	34fd                	addiw	s1,s1,-1
    1876:	f4fd                	bnez	s1,1864 <createdelete+0x34>
  name[0] = name[1] = name[2] = 0;
    1878:	f8040123          	sb	zero,-126(s0)
    187c:	03000993          	li	s3,48
    1880:	5a7d                	li	s4,-1
    1882:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    1886:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1888:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    188a:	07400a93          	li	s5,116
    188e:	aa39                	j	19ac <createdelete+0x17c>
      printf("%s: fork failed\n", s);
    1890:	85e6                	mv	a1,s9
    1892:	00004517          	auipc	a0,0x4
    1896:	11650513          	addi	a0,a0,278 # 59a8 <thread_join+0x904>
    189a:	60e030ef          	jal	4ea8 <printf>
      exit(1);
    189e:	4505                	li	a0,1
    18a0:	1e0030ef          	jal	4a80 <exit>
      name[0] = 'p' + pi;
    18a4:	0709091b          	addiw	s2,s2,112
    18a8:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    18ac:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    18b0:	4951                	li	s2,20
    18b2:	a831                	j	18ce <createdelete+0x9e>
          printf("%s: create failed\n", s);
    18b4:	85e6                	mv	a1,s9
    18b6:	00004517          	auipc	a0,0x4
    18ba:	18a50513          	addi	a0,a0,394 # 5a40 <thread_join+0x99c>
    18be:	5ea030ef          	jal	4ea8 <printf>
          exit(1);
    18c2:	4505                	li	a0,1
    18c4:	1bc030ef          	jal	4a80 <exit>
      for(i = 0; i < N; i++){
    18c8:	2485                	addiw	s1,s1,1
    18ca:	05248e63          	beq	s1,s2,1926 <createdelete+0xf6>
        name[1] = '0' + i;
    18ce:	0304879b          	addiw	a5,s1,48
    18d2:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    18d6:	20200593          	li	a1,514
    18da:	f8040513          	addi	a0,s0,-128
    18de:	1e2030ef          	jal	4ac0 <open>
        if(fd < 0){
    18e2:	fc0549e3          	bltz	a0,18b4 <createdelete+0x84>
        close(fd);
    18e6:	1c2030ef          	jal	4aa8 <close>
        if(i > 0 && (i % 2 ) == 0){
    18ea:	10905063          	blez	s1,19ea <createdelete+0x1ba>
    18ee:	0014f793          	andi	a5,s1,1
    18f2:	fbf9                	bnez	a5,18c8 <createdelete+0x98>
          name[1] = '0' + (i / 2);
    18f4:	01f4d79b          	srliw	a5,s1,0x1f
    18f8:	9fa5                	addw	a5,a5,s1
    18fa:	4017d79b          	sraiw	a5,a5,0x1
    18fe:	0307879b          	addiw	a5,a5,48
    1902:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1906:	f8040513          	addi	a0,s0,-128
    190a:	1c6030ef          	jal	4ad0 <unlink>
    190e:	fa055de3          	bgez	a0,18c8 <createdelete+0x98>
            printf("%s: unlink failed\n", s);
    1912:	85e6                	mv	a1,s9
    1914:	00004517          	auipc	a0,0x4
    1918:	28450513          	addi	a0,a0,644 # 5b98 <thread_join+0xaf4>
    191c:	58c030ef          	jal	4ea8 <printf>
            exit(1);
    1920:	4505                	li	a0,1
    1922:	15e030ef          	jal	4a80 <exit>
      exit(0);
    1926:	4501                	li	a0,0
    1928:	158030ef          	jal	4a80 <exit>
      exit(1);
    192c:	4505                	li	a0,1
    192e:	152030ef          	jal	4a80 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1932:	f8040613          	addi	a2,s0,-128
    1936:	85e6                	mv	a1,s9
    1938:	00004517          	auipc	a0,0x4
    193c:	27850513          	addi	a0,a0,632 # 5bb0 <thread_join+0xb0c>
    1940:	568030ef          	jal	4ea8 <printf>
        exit(1);
    1944:	4505                	li	a0,1
    1946:	13a030ef          	jal	4a80 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    194a:	034bfb63          	bgeu	s7,s4,1980 <createdelete+0x150>
      if(fd >= 0)
    194e:	02055663          	bgez	a0,197a <createdelete+0x14a>
    for(pi = 0; pi < NCHILD; pi++){
    1952:	2485                	addiw	s1,s1,1
    1954:	0ff4f493          	zext.b	s1,s1
    1958:	05548263          	beq	s1,s5,199c <createdelete+0x16c>
      name[0] = 'p' + pi;
    195c:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1960:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1964:	4581                	li	a1,0
    1966:	f8040513          	addi	a0,s0,-128
    196a:	156030ef          	jal	4ac0 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    196e:	00090463          	beqz	s2,1976 <createdelete+0x146>
    1972:	fd2b5ce3          	bge	s6,s2,194a <createdelete+0x11a>
    1976:	fa054ee3          	bltz	a0,1932 <createdelete+0x102>
        close(fd);
    197a:	12e030ef          	jal	4aa8 <close>
    197e:	bfd1                	j	1952 <createdelete+0x122>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1980:	fc0549e3          	bltz	a0,1952 <createdelete+0x122>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1984:	f8040613          	addi	a2,s0,-128
    1988:	85e6                	mv	a1,s9
    198a:	00004517          	auipc	a0,0x4
    198e:	24e50513          	addi	a0,a0,590 # 5bd8 <thread_join+0xb34>
    1992:	516030ef          	jal	4ea8 <printf>
        exit(1);
    1996:	4505                	li	a0,1
    1998:	0e8030ef          	jal	4a80 <exit>
  for(i = 0; i < N; i++){
    199c:	2905                	addiw	s2,s2,1
    199e:	2a05                	addiw	s4,s4,1
    19a0:	2985                	addiw	s3,s3,1
    19a2:	0ff9f993          	zext.b	s3,s3
    19a6:	47d1                	li	a5,20
    19a8:	02f90863          	beq	s2,a5,19d8 <createdelete+0x1a8>
    for(pi = 0; pi < NCHILD; pi++){
    19ac:	84e2                	mv	s1,s8
    19ae:	b77d                	j	195c <createdelete+0x12c>
  for(i = 0; i < N; i++){
    19b0:	2905                	addiw	s2,s2,1
    19b2:	0ff97913          	zext.b	s2,s2
    19b6:	03490c63          	beq	s2,s4,19ee <createdelete+0x1be>
  name[0] = name[1] = name[2] = 0;
    19ba:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    19bc:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    19c0:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    19c4:	f8040513          	addi	a0,s0,-128
    19c8:	108030ef          	jal	4ad0 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    19cc:	2485                	addiw	s1,s1,1
    19ce:	0ff4f493          	zext.b	s1,s1
    19d2:	ff3495e3          	bne	s1,s3,19bc <createdelete+0x18c>
    19d6:	bfe9                	j	19b0 <createdelete+0x180>
    19d8:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    19dc:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    19e0:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    19e4:	04400a13          	li	s4,68
    19e8:	bfc9                	j	19ba <createdelete+0x18a>
      for(i = 0; i < N; i++){
    19ea:	2485                	addiw	s1,s1,1
    19ec:	b5cd                	j	18ce <createdelete+0x9e>
}
    19ee:	60aa                	ld	ra,136(sp)
    19f0:	640a                	ld	s0,128(sp)
    19f2:	74e6                	ld	s1,120(sp)
    19f4:	7946                	ld	s2,112(sp)
    19f6:	79a6                	ld	s3,104(sp)
    19f8:	7a06                	ld	s4,96(sp)
    19fa:	6ae6                	ld	s5,88(sp)
    19fc:	6b46                	ld	s6,80(sp)
    19fe:	6ba6                	ld	s7,72(sp)
    1a00:	6c06                	ld	s8,64(sp)
    1a02:	7ce2                	ld	s9,56(sp)
    1a04:	6149                	addi	sp,sp,144
    1a06:	8082                	ret

0000000000001a08 <linkunlink>:
{
    1a08:	711d                	addi	sp,sp,-96
    1a0a:	ec86                	sd	ra,88(sp)
    1a0c:	e8a2                	sd	s0,80(sp)
    1a0e:	e4a6                	sd	s1,72(sp)
    1a10:	e0ca                	sd	s2,64(sp)
    1a12:	fc4e                	sd	s3,56(sp)
    1a14:	f852                	sd	s4,48(sp)
    1a16:	f456                	sd	s5,40(sp)
    1a18:	f05a                	sd	s6,32(sp)
    1a1a:	ec5e                	sd	s7,24(sp)
    1a1c:	e862                	sd	s8,16(sp)
    1a1e:	e466                	sd	s9,8(sp)
    1a20:	1080                	addi	s0,sp,96
    1a22:	84aa                	mv	s1,a0
  unlink("x");
    1a24:	00003517          	auipc	a0,0x3
    1a28:	76450513          	addi	a0,a0,1892 # 5188 <thread_join+0xe4>
    1a2c:	0a4030ef          	jal	4ad0 <unlink>
  pid = fork();
    1a30:	048030ef          	jal	4a78 <fork>
  if(pid < 0){
    1a34:	02054b63          	bltz	a0,1a6a <linkunlink+0x62>
    1a38:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1a3a:	06100913          	li	s2,97
    1a3e:	c111                	beqz	a0,1a42 <linkunlink+0x3a>
    1a40:	4905                	li	s2,1
    1a42:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1a46:	41c65a37          	lui	s4,0x41c65
    1a4a:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c551f5>
    1a4e:	698d                	lui	s3,0x3
    1a50:	0399899b          	addiw	s3,s3,57 # 3039 <subdir+0x45d>
    if((x % 3) == 0){
    1a54:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    1a56:	4b85                	li	s7,1
      unlink("x");
    1a58:	00003b17          	auipc	s6,0x3
    1a5c:	730b0b13          	addi	s6,s6,1840 # 5188 <thread_join+0xe4>
      link("cat", "x");
    1a60:	00004c17          	auipc	s8,0x4
    1a64:	1a0c0c13          	addi	s8,s8,416 # 5c00 <thread_join+0xb5c>
    1a68:	a025                	j	1a90 <linkunlink+0x88>
    printf("%s: fork failed\n", s);
    1a6a:	85a6                	mv	a1,s1
    1a6c:	00004517          	auipc	a0,0x4
    1a70:	f3c50513          	addi	a0,a0,-196 # 59a8 <thread_join+0x904>
    1a74:	434030ef          	jal	4ea8 <printf>
    exit(1);
    1a78:	4505                	li	a0,1
    1a7a:	006030ef          	jal	4a80 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1a7e:	20200593          	li	a1,514
    1a82:	855a                	mv	a0,s6
    1a84:	03c030ef          	jal	4ac0 <open>
    1a88:	020030ef          	jal	4aa8 <close>
  for(i = 0; i < 100; i++){
    1a8c:	34fd                	addiw	s1,s1,-1
    1a8e:	c495                	beqz	s1,1aba <linkunlink+0xb2>
    x = x * 1103515245 + 12345;
    1a90:	034907bb          	mulw	a5,s2,s4
    1a94:	013787bb          	addw	a5,a5,s3
    1a98:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    1a9c:	0357f7bb          	remuw	a5,a5,s5
    1aa0:	2781                	sext.w	a5,a5
    1aa2:	dff1                	beqz	a5,1a7e <linkunlink+0x76>
    } else if((x % 3) == 1){
    1aa4:	01778663          	beq	a5,s7,1ab0 <linkunlink+0xa8>
      unlink("x");
    1aa8:	855a                	mv	a0,s6
    1aaa:	026030ef          	jal	4ad0 <unlink>
    1aae:	bff9                	j	1a8c <linkunlink+0x84>
      link("cat", "x");
    1ab0:	85da                	mv	a1,s6
    1ab2:	8562                	mv	a0,s8
    1ab4:	02c030ef          	jal	4ae0 <link>
    1ab8:	bfd1                	j	1a8c <linkunlink+0x84>
  if(pid)
    1aba:	020c8263          	beqz	s9,1ade <linkunlink+0xd6>
    wait(0);
    1abe:	4501                	li	a0,0
    1ac0:	7c9020ef          	jal	4a88 <wait>
}
    1ac4:	60e6                	ld	ra,88(sp)
    1ac6:	6446                	ld	s0,80(sp)
    1ac8:	64a6                	ld	s1,72(sp)
    1aca:	6906                	ld	s2,64(sp)
    1acc:	79e2                	ld	s3,56(sp)
    1ace:	7a42                	ld	s4,48(sp)
    1ad0:	7aa2                	ld	s5,40(sp)
    1ad2:	7b02                	ld	s6,32(sp)
    1ad4:	6be2                	ld	s7,24(sp)
    1ad6:	6c42                	ld	s8,16(sp)
    1ad8:	6ca2                	ld	s9,8(sp)
    1ada:	6125                	addi	sp,sp,96
    1adc:	8082                	ret
    exit(0);
    1ade:	4501                	li	a0,0
    1ae0:	7a1020ef          	jal	4a80 <exit>

0000000000001ae4 <forktest>:
{
    1ae4:	7179                	addi	sp,sp,-48
    1ae6:	f406                	sd	ra,40(sp)
    1ae8:	f022                	sd	s0,32(sp)
    1aea:	ec26                	sd	s1,24(sp)
    1aec:	e84a                	sd	s2,16(sp)
    1aee:	e44e                	sd	s3,8(sp)
    1af0:	1800                	addi	s0,sp,48
    1af2:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1af4:	4481                	li	s1,0
    1af6:	3e800913          	li	s2,1000
    pid = fork();
    1afa:	77f020ef          	jal	4a78 <fork>
    if(pid < 0)
    1afe:	06054063          	bltz	a0,1b5e <forktest+0x7a>
    if(pid == 0)
    1b02:	cd11                	beqz	a0,1b1e <forktest+0x3a>
  for(n=0; n<N; n++){
    1b04:	2485                	addiw	s1,s1,1
    1b06:	ff249ae3          	bne	s1,s2,1afa <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1b0a:	85ce                	mv	a1,s3
    1b0c:	00004517          	auipc	a0,0x4
    1b10:	14450513          	addi	a0,a0,324 # 5c50 <thread_join+0xbac>
    1b14:	394030ef          	jal	4ea8 <printf>
    exit(1);
    1b18:	4505                	li	a0,1
    1b1a:	767020ef          	jal	4a80 <exit>
      exit(0);
    1b1e:	763020ef          	jal	4a80 <exit>
    printf("%s: no fork at all!\n", s);
    1b22:	85ce                	mv	a1,s3
    1b24:	00004517          	auipc	a0,0x4
    1b28:	0e450513          	addi	a0,a0,228 # 5c08 <thread_join+0xb64>
    1b2c:	37c030ef          	jal	4ea8 <printf>
    exit(1);
    1b30:	4505                	li	a0,1
    1b32:	74f020ef          	jal	4a80 <exit>
      printf("%s: wait stopped early\n", s);
    1b36:	85ce                	mv	a1,s3
    1b38:	00004517          	auipc	a0,0x4
    1b3c:	0e850513          	addi	a0,a0,232 # 5c20 <thread_join+0xb7c>
    1b40:	368030ef          	jal	4ea8 <printf>
      exit(1);
    1b44:	4505                	li	a0,1
    1b46:	73b020ef          	jal	4a80 <exit>
    printf("%s: wait got too many\n", s);
    1b4a:	85ce                	mv	a1,s3
    1b4c:	00004517          	auipc	a0,0x4
    1b50:	0ec50513          	addi	a0,a0,236 # 5c38 <thread_join+0xb94>
    1b54:	354030ef          	jal	4ea8 <printf>
    exit(1);
    1b58:	4505                	li	a0,1
    1b5a:	727020ef          	jal	4a80 <exit>
  if (n == 0) {
    1b5e:	d0f1                	beqz	s1,1b22 <forktest+0x3e>
  for(; n > 0; n--){
    1b60:	00905963          	blez	s1,1b72 <forktest+0x8e>
    if(wait(0) < 0){
    1b64:	4501                	li	a0,0
    1b66:	723020ef          	jal	4a88 <wait>
    1b6a:	fc0546e3          	bltz	a0,1b36 <forktest+0x52>
  for(; n > 0; n--){
    1b6e:	34fd                	addiw	s1,s1,-1
    1b70:	f8f5                	bnez	s1,1b64 <forktest+0x80>
  if(wait(0) != -1){
    1b72:	4501                	li	a0,0
    1b74:	715020ef          	jal	4a88 <wait>
    1b78:	57fd                	li	a5,-1
    1b7a:	fcf518e3          	bne	a0,a5,1b4a <forktest+0x66>
}
    1b7e:	70a2                	ld	ra,40(sp)
    1b80:	7402                	ld	s0,32(sp)
    1b82:	64e2                	ld	s1,24(sp)
    1b84:	6942                	ld	s2,16(sp)
    1b86:	69a2                	ld	s3,8(sp)
    1b88:	6145                	addi	sp,sp,48
    1b8a:	8082                	ret

0000000000001b8c <kernmem>:
{
    1b8c:	715d                	addi	sp,sp,-80
    1b8e:	e486                	sd	ra,72(sp)
    1b90:	e0a2                	sd	s0,64(sp)
    1b92:	fc26                	sd	s1,56(sp)
    1b94:	f84a                	sd	s2,48(sp)
    1b96:	f44e                	sd	s3,40(sp)
    1b98:	f052                	sd	s4,32(sp)
    1b9a:	ec56                	sd	s5,24(sp)
    1b9c:	0880                	addi	s0,sp,80
    1b9e:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ba0:	4485                	li	s1,1
    1ba2:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    1ba4:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ba6:	69b1                	lui	s3,0xc
    1ba8:	35098993          	addi	s3,s3,848 # c350 <uninit+0x1de8>
    1bac:	1003d937          	lui	s2,0x1003d
    1bb0:	090e                	slli	s2,s2,0x3
    1bb2:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    1bb6:	6c3020ef          	jal	4a78 <fork>
    if(pid < 0){
    1bba:	02054763          	bltz	a0,1be8 <kernmem+0x5c>
    if(pid == 0){
    1bbe:	cd1d                	beqz	a0,1bfc <kernmem+0x70>
    wait(&xstatus);
    1bc0:	fbc40513          	addi	a0,s0,-68
    1bc4:	6c5020ef          	jal	4a88 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1bc8:	fbc42783          	lw	a5,-68(s0)
    1bcc:	05479563          	bne	a5,s4,1c16 <kernmem+0x8a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1bd0:	94ce                	add	s1,s1,s3
    1bd2:	ff2492e3          	bne	s1,s2,1bb6 <kernmem+0x2a>
}
    1bd6:	60a6                	ld	ra,72(sp)
    1bd8:	6406                	ld	s0,64(sp)
    1bda:	74e2                	ld	s1,56(sp)
    1bdc:	7942                	ld	s2,48(sp)
    1bde:	79a2                	ld	s3,40(sp)
    1be0:	7a02                	ld	s4,32(sp)
    1be2:	6ae2                	ld	s5,24(sp)
    1be4:	6161                	addi	sp,sp,80
    1be6:	8082                	ret
      printf("%s: fork failed\n", s);
    1be8:	85d6                	mv	a1,s5
    1bea:	00004517          	auipc	a0,0x4
    1bee:	dbe50513          	addi	a0,a0,-578 # 59a8 <thread_join+0x904>
    1bf2:	2b6030ef          	jal	4ea8 <printf>
      exit(1);
    1bf6:	4505                	li	a0,1
    1bf8:	689020ef          	jal	4a80 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1bfc:	0004c683          	lbu	a3,0(s1)
    1c00:	8626                	mv	a2,s1
    1c02:	85d6                	mv	a1,s5
    1c04:	00004517          	auipc	a0,0x4
    1c08:	07450513          	addi	a0,a0,116 # 5c78 <thread_join+0xbd4>
    1c0c:	29c030ef          	jal	4ea8 <printf>
      exit(1);
    1c10:	4505                	li	a0,1
    1c12:	66f020ef          	jal	4a80 <exit>
      exit(1);
    1c16:	4505                	li	a0,1
    1c18:	669020ef          	jal	4a80 <exit>

0000000000001c1c <MAXVAplus>:
{
    1c1c:	7179                	addi	sp,sp,-48
    1c1e:	f406                	sd	ra,40(sp)
    1c20:	f022                	sd	s0,32(sp)
    1c22:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    1c24:	4785                	li	a5,1
    1c26:	179a                	slli	a5,a5,0x26
    1c28:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    1c2c:	fd843783          	ld	a5,-40(s0)
    1c30:	cf85                	beqz	a5,1c68 <MAXVAplus+0x4c>
    1c32:	ec26                	sd	s1,24(sp)
    1c34:	e84a                	sd	s2,16(sp)
    1c36:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    1c38:	54fd                	li	s1,-1
    pid = fork();
    1c3a:	63f020ef          	jal	4a78 <fork>
    if(pid < 0){
    1c3e:	02054963          	bltz	a0,1c70 <MAXVAplus+0x54>
    if(pid == 0){
    1c42:	c129                	beqz	a0,1c84 <MAXVAplus+0x68>
    wait(&xstatus);
    1c44:	fd440513          	addi	a0,s0,-44
    1c48:	641020ef          	jal	4a88 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c4c:	fd442783          	lw	a5,-44(s0)
    1c50:	04979c63          	bne	a5,s1,1ca8 <MAXVAplus+0x8c>
  for( ; a != 0; a <<= 1){
    1c54:	fd843783          	ld	a5,-40(s0)
    1c58:	0786                	slli	a5,a5,0x1
    1c5a:	fcf43c23          	sd	a5,-40(s0)
    1c5e:	fd843783          	ld	a5,-40(s0)
    1c62:	ffe1                	bnez	a5,1c3a <MAXVAplus+0x1e>
    1c64:	64e2                	ld	s1,24(sp)
    1c66:	6942                	ld	s2,16(sp)
}
    1c68:	70a2                	ld	ra,40(sp)
    1c6a:	7402                	ld	s0,32(sp)
    1c6c:	6145                	addi	sp,sp,48
    1c6e:	8082                	ret
      printf("%s: fork failed\n", s);
    1c70:	85ca                	mv	a1,s2
    1c72:	00004517          	auipc	a0,0x4
    1c76:	d3650513          	addi	a0,a0,-714 # 59a8 <thread_join+0x904>
    1c7a:	22e030ef          	jal	4ea8 <printf>
      exit(1);
    1c7e:	4505                	li	a0,1
    1c80:	601020ef          	jal	4a80 <exit>
      *(char*)a = 99;
    1c84:	fd843783          	ld	a5,-40(s0)
    1c88:	06300713          	li	a4,99
    1c8c:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1c90:	fd843603          	ld	a2,-40(s0)
    1c94:	85ca                	mv	a1,s2
    1c96:	00004517          	auipc	a0,0x4
    1c9a:	00250513          	addi	a0,a0,2 # 5c98 <thread_join+0xbf4>
    1c9e:	20a030ef          	jal	4ea8 <printf>
      exit(1);
    1ca2:	4505                	li	a0,1
    1ca4:	5dd020ef          	jal	4a80 <exit>
      exit(1);
    1ca8:	4505                	li	a0,1
    1caa:	5d7020ef          	jal	4a80 <exit>

0000000000001cae <stacktest>:
{
    1cae:	7179                	addi	sp,sp,-48
    1cb0:	f406                	sd	ra,40(sp)
    1cb2:	f022                	sd	s0,32(sp)
    1cb4:	ec26                	sd	s1,24(sp)
    1cb6:	1800                	addi	s0,sp,48
    1cb8:	84aa                	mv	s1,a0
  pid = fork();
    1cba:	5bf020ef          	jal	4a78 <fork>
  if(pid == 0) {
    1cbe:	cd11                	beqz	a0,1cda <stacktest+0x2c>
  } else if(pid < 0){
    1cc0:	02054c63          	bltz	a0,1cf8 <stacktest+0x4a>
  wait(&xstatus);
    1cc4:	fdc40513          	addi	a0,s0,-36
    1cc8:	5c1020ef          	jal	4a88 <wait>
  if(xstatus == -1)  // kernel killed child?
    1ccc:	fdc42503          	lw	a0,-36(s0)
    1cd0:	57fd                	li	a5,-1
    1cd2:	02f50d63          	beq	a0,a5,1d0c <stacktest+0x5e>
    exit(xstatus);
    1cd6:	5ab020ef          	jal	4a80 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1cda:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1cdc:	77fd                	lui	a5,0xfffff
    1cde:	97ba                	add	a5,a5,a4
    1ce0:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    1ce4:	85a6                	mv	a1,s1
    1ce6:	00004517          	auipc	a0,0x4
    1cea:	fca50513          	addi	a0,a0,-54 # 5cb0 <thread_join+0xc0c>
    1cee:	1ba030ef          	jal	4ea8 <printf>
    exit(1);
    1cf2:	4505                	li	a0,1
    1cf4:	58d020ef          	jal	4a80 <exit>
    printf("%s: fork failed\n", s);
    1cf8:	85a6                	mv	a1,s1
    1cfa:	00004517          	auipc	a0,0x4
    1cfe:	cae50513          	addi	a0,a0,-850 # 59a8 <thread_join+0x904>
    1d02:	1a6030ef          	jal	4ea8 <printf>
    exit(1);
    1d06:	4505                	li	a0,1
    1d08:	579020ef          	jal	4a80 <exit>
    exit(0);
    1d0c:	4501                	li	a0,0
    1d0e:	573020ef          	jal	4a80 <exit>

0000000000001d12 <nowrite>:
{
    1d12:	7159                	addi	sp,sp,-112
    1d14:	f486                	sd	ra,104(sp)
    1d16:	f0a2                	sd	s0,96(sp)
    1d18:	eca6                	sd	s1,88(sp)
    1d1a:	e8ca                	sd	s2,80(sp)
    1d1c:	e4ce                	sd	s3,72(sp)
    1d1e:	1880                	addi	s0,sp,112
    1d20:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1d22:	00005797          	auipc	a5,0x5
    1d26:	75678793          	addi	a5,a5,1878 # 7478 <thread_join+0x23d4>
    1d2a:	7788                	ld	a0,40(a5)
    1d2c:	7b8c                	ld	a1,48(a5)
    1d2e:	7f90                	ld	a2,56(a5)
    1d30:	63b4                	ld	a3,64(a5)
    1d32:	67b8                	ld	a4,72(a5)
    1d34:	6bbc                	ld	a5,80(a5)
    1d36:	f8a43c23          	sd	a0,-104(s0)
    1d3a:	fab43023          	sd	a1,-96(s0)
    1d3e:	fac43423          	sd	a2,-88(s0)
    1d42:	fad43823          	sd	a3,-80(s0)
    1d46:	fae43c23          	sd	a4,-72(s0)
    1d4a:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d4e:	4481                	li	s1,0
    1d50:	4919                	li	s2,6
    pid = fork();
    1d52:	527020ef          	jal	4a78 <fork>
    if(pid == 0) {
    1d56:	c105                	beqz	a0,1d76 <nowrite+0x64>
    } else if(pid < 0){
    1d58:	04054263          	bltz	a0,1d9c <nowrite+0x8a>
    wait(&xstatus);
    1d5c:	fcc40513          	addi	a0,s0,-52
    1d60:	529020ef          	jal	4a88 <wait>
    if(xstatus == 0){
    1d64:	fcc42783          	lw	a5,-52(s0)
    1d68:	c7a1                	beqz	a5,1db0 <nowrite+0x9e>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1d6a:	2485                	addiw	s1,s1,1
    1d6c:	ff2493e3          	bne	s1,s2,1d52 <nowrite+0x40>
  exit(0);
    1d70:	4501                	li	a0,0
    1d72:	50f020ef          	jal	4a80 <exit>
      volatile int *addr = (int *) addrs[ai];
    1d76:	048e                	slli	s1,s1,0x3
    1d78:	fd048793          	addi	a5,s1,-48
    1d7c:	008784b3          	add	s1,a5,s0
    1d80:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1d84:	47a9                	li	a5,10
    1d86:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1d88:	85ce                	mv	a1,s3
    1d8a:	00004517          	auipc	a0,0x4
    1d8e:	f4e50513          	addi	a0,a0,-178 # 5cd8 <thread_join+0xc34>
    1d92:	116030ef          	jal	4ea8 <printf>
      exit(0);
    1d96:	4501                	li	a0,0
    1d98:	4e9020ef          	jal	4a80 <exit>
      printf("%s: fork failed\n", s);
    1d9c:	85ce                	mv	a1,s3
    1d9e:	00004517          	auipc	a0,0x4
    1da2:	c0a50513          	addi	a0,a0,-1014 # 59a8 <thread_join+0x904>
    1da6:	102030ef          	jal	4ea8 <printf>
      exit(1);
    1daa:	4505                	li	a0,1
    1dac:	4d5020ef          	jal	4a80 <exit>
      exit(1);
    1db0:	4505                	li	a0,1
    1db2:	4cf020ef          	jal	4a80 <exit>

0000000000001db6 <manywrites>:
{
    1db6:	711d                	addi	sp,sp,-96
    1db8:	ec86                	sd	ra,88(sp)
    1dba:	e8a2                	sd	s0,80(sp)
    1dbc:	e4a6                	sd	s1,72(sp)
    1dbe:	e0ca                	sd	s2,64(sp)
    1dc0:	fc4e                	sd	s3,56(sp)
    1dc2:	f456                	sd	s5,40(sp)
    1dc4:	1080                	addi	s0,sp,96
    1dc6:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1dc8:	4981                	li	s3,0
    1dca:	4911                	li	s2,4
    int pid = fork();
    1dcc:	4ad020ef          	jal	4a78 <fork>
    1dd0:	84aa                	mv	s1,a0
    if(pid < 0){
    1dd2:	02054963          	bltz	a0,1e04 <manywrites+0x4e>
    if(pid == 0){
    1dd6:	c139                	beqz	a0,1e1c <manywrites+0x66>
  for(int ci = 0; ci < nchildren; ci++){
    1dd8:	2985                	addiw	s3,s3,1
    1dda:	ff2999e3          	bne	s3,s2,1dcc <manywrites+0x16>
    1dde:	f852                	sd	s4,48(sp)
    1de0:	f05a                	sd	s6,32(sp)
    1de2:	ec5e                	sd	s7,24(sp)
    1de4:	4491                	li	s1,4
    int st = 0;
    1de6:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    1dea:	fa840513          	addi	a0,s0,-88
    1dee:	49b020ef          	jal	4a88 <wait>
    if(st != 0)
    1df2:	fa842503          	lw	a0,-88(s0)
    1df6:	0c051863          	bnez	a0,1ec6 <manywrites+0x110>
  for(int ci = 0; ci < nchildren; ci++){
    1dfa:	34fd                	addiw	s1,s1,-1
    1dfc:	f4ed                	bnez	s1,1de6 <manywrites+0x30>
  exit(0);
    1dfe:	4501                	li	a0,0
    1e00:	481020ef          	jal	4a80 <exit>
    1e04:	f852                	sd	s4,48(sp)
    1e06:	f05a                	sd	s6,32(sp)
    1e08:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    1e0a:	00005517          	auipc	a0,0x5
    1e0e:	10e50513          	addi	a0,a0,270 # 6f18 <thread_join+0x1e74>
    1e12:	096030ef          	jal	4ea8 <printf>
      exit(1);
    1e16:	4505                	li	a0,1
    1e18:	469020ef          	jal	4a80 <exit>
    1e1c:	f852                	sd	s4,48(sp)
    1e1e:	f05a                	sd	s6,32(sp)
    1e20:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    1e22:	06200793          	li	a5,98
    1e26:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    1e2a:	0619879b          	addiw	a5,s3,97
    1e2e:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    1e32:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    1e36:	fa840513          	addi	a0,s0,-88
    1e3a:	497020ef          	jal	4ad0 <unlink>
    1e3e:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    1e40:	0000bb17          	auipc	s6,0xb
    1e44:	e38b0b13          	addi	s6,s6,-456 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    1e48:	8a26                	mv	s4,s1
    1e4a:	0209c863          	bltz	s3,1e7a <manywrites+0xc4>
          int fd = open(name, O_CREATE | O_RDWR);
    1e4e:	20200593          	li	a1,514
    1e52:	fa840513          	addi	a0,s0,-88
    1e56:	46b020ef          	jal	4ac0 <open>
    1e5a:	892a                	mv	s2,a0
          if(fd < 0){
    1e5c:	02054d63          	bltz	a0,1e96 <manywrites+0xe0>
          int cc = write(fd, buf, sz);
    1e60:	660d                	lui	a2,0x3
    1e62:	85da                	mv	a1,s6
    1e64:	43d020ef          	jal	4aa0 <write>
          if(cc != sz){
    1e68:	678d                	lui	a5,0x3
    1e6a:	04f51263          	bne	a0,a5,1eae <manywrites+0xf8>
          close(fd);
    1e6e:	854a                	mv	a0,s2
    1e70:	439020ef          	jal	4aa8 <close>
        for(int i = 0; i < ci+1; i++){
    1e74:	2a05                	addiw	s4,s4,1
    1e76:	fd49dce3          	bge	s3,s4,1e4e <manywrites+0x98>
        unlink(name);
    1e7a:	fa840513          	addi	a0,s0,-88
    1e7e:	453020ef          	jal	4ad0 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1e82:	3bfd                	addiw	s7,s7,-1
    1e84:	fc0b92e3          	bnez	s7,1e48 <manywrites+0x92>
      unlink(name);
    1e88:	fa840513          	addi	a0,s0,-88
    1e8c:	445020ef          	jal	4ad0 <unlink>
      exit(0);
    1e90:	4501                	li	a0,0
    1e92:	3ef020ef          	jal	4a80 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e96:	fa840613          	addi	a2,s0,-88
    1e9a:	85d6                	mv	a1,s5
    1e9c:	00004517          	auipc	a0,0x4
    1ea0:	e5c50513          	addi	a0,a0,-420 # 5cf8 <thread_join+0xc54>
    1ea4:	004030ef          	jal	4ea8 <printf>
            exit(1);
    1ea8:	4505                	li	a0,1
    1eaa:	3d7020ef          	jal	4a80 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1eae:	86aa                	mv	a3,a0
    1eb0:	660d                	lui	a2,0x3
    1eb2:	85d6                	mv	a1,s5
    1eb4:	00003517          	auipc	a0,0x3
    1eb8:	33450513          	addi	a0,a0,820 # 51e8 <thread_join+0x144>
    1ebc:	7ed020ef          	jal	4ea8 <printf>
            exit(1);
    1ec0:	4505                	li	a0,1
    1ec2:	3bf020ef          	jal	4a80 <exit>
      exit(st);
    1ec6:	3bb020ef          	jal	4a80 <exit>

0000000000001eca <copyinstr3>:
{
    1eca:	7179                	addi	sp,sp,-48
    1ecc:	f406                	sd	ra,40(sp)
    1ece:	f022                	sd	s0,32(sp)
    1ed0:	ec26                	sd	s1,24(sp)
    1ed2:	1800                	addi	s0,sp,48
  sbrk(8192);
    1ed4:	6509                	lui	a0,0x2
    1ed6:	433020ef          	jal	4b08 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1eda:	4501                	li	a0,0
    1edc:	42d020ef          	jal	4b08 <sbrk>
  if((top % PGSIZE) != 0){
    1ee0:	03451793          	slli	a5,a0,0x34
    1ee4:	e7bd                	bnez	a5,1f52 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1ee6:	4501                	li	a0,0
    1ee8:	421020ef          	jal	4b08 <sbrk>
  if(top % PGSIZE){
    1eec:	03451793          	slli	a5,a0,0x34
    1ef0:	ebad                	bnez	a5,1f62 <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ef2:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0x31>
  *b = 'x';
    1ef6:	07800793          	li	a5,120
    1efa:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1efe:	8526                	mv	a0,s1
    1f00:	3d1020ef          	jal	4ad0 <unlink>
  if(ret != -1){
    1f04:	57fd                	li	a5,-1
    1f06:	06f51763          	bne	a0,a5,1f74 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1f0a:	20100593          	li	a1,513
    1f0e:	8526                	mv	a0,s1
    1f10:	3b1020ef          	jal	4ac0 <open>
  if(fd != -1){
    1f14:	57fd                	li	a5,-1
    1f16:	06f51a63          	bne	a0,a5,1f8a <copyinstr3+0xc0>
  ret = link(b, b);
    1f1a:	85a6                	mv	a1,s1
    1f1c:	8526                	mv	a0,s1
    1f1e:	3c3020ef          	jal	4ae0 <link>
  if(ret != -1){
    1f22:	57fd                	li	a5,-1
    1f24:	06f51e63          	bne	a0,a5,1fa0 <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    1f28:	00005797          	auipc	a5,0x5
    1f2c:	ad078793          	addi	a5,a5,-1328 # 69f8 <thread_join+0x1954>
    1f30:	fcf43823          	sd	a5,-48(s0)
    1f34:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1f38:	fd040593          	addi	a1,s0,-48
    1f3c:	8526                	mv	a0,s1
    1f3e:	37b020ef          	jal	4ab8 <exec>
  if(ret != -1){
    1f42:	57fd                	li	a5,-1
    1f44:	06f51a63          	bne	a0,a5,1fb8 <copyinstr3+0xee>
}
    1f48:	70a2                	ld	ra,40(sp)
    1f4a:	7402                	ld	s0,32(sp)
    1f4c:	64e2                	ld	s1,24(sp)
    1f4e:	6145                	addi	sp,sp,48
    1f50:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1f52:	0347d513          	srli	a0,a5,0x34
    1f56:	6785                	lui	a5,0x1
    1f58:	40a7853b          	subw	a0,a5,a0
    1f5c:	3ad020ef          	jal	4b08 <sbrk>
    1f60:	b759                	j	1ee6 <copyinstr3+0x1c>
    printf("oops\n");
    1f62:	00004517          	auipc	a0,0x4
    1f66:	dae50513          	addi	a0,a0,-594 # 5d10 <thread_join+0xc6c>
    1f6a:	73f020ef          	jal	4ea8 <printf>
    exit(1);
    1f6e:	4505                	li	a0,1
    1f70:	311020ef          	jal	4a80 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f74:	862a                	mv	a2,a0
    1f76:	85a6                	mv	a1,s1
    1f78:	00004517          	auipc	a0,0x4
    1f7c:	95050513          	addi	a0,a0,-1712 # 58c8 <thread_join+0x824>
    1f80:	729020ef          	jal	4ea8 <printf>
    exit(1);
    1f84:	4505                	li	a0,1
    1f86:	2fb020ef          	jal	4a80 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f8a:	862a                	mv	a2,a0
    1f8c:	85a6                	mv	a1,s1
    1f8e:	00004517          	auipc	a0,0x4
    1f92:	95a50513          	addi	a0,a0,-1702 # 58e8 <thread_join+0x844>
    1f96:	713020ef          	jal	4ea8 <printf>
    exit(1);
    1f9a:	4505                	li	a0,1
    1f9c:	2e5020ef          	jal	4a80 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1fa0:	86aa                	mv	a3,a0
    1fa2:	8626                	mv	a2,s1
    1fa4:	85a6                	mv	a1,s1
    1fa6:	00004517          	auipc	a0,0x4
    1faa:	96250513          	addi	a0,a0,-1694 # 5908 <thread_join+0x864>
    1fae:	6fb020ef          	jal	4ea8 <printf>
    exit(1);
    1fb2:	4505                	li	a0,1
    1fb4:	2cd020ef          	jal	4a80 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1fb8:	567d                	li	a2,-1
    1fba:	85a6                	mv	a1,s1
    1fbc:	00004517          	auipc	a0,0x4
    1fc0:	97450513          	addi	a0,a0,-1676 # 5930 <thread_join+0x88c>
    1fc4:	6e5020ef          	jal	4ea8 <printf>
    exit(1);
    1fc8:	4505                	li	a0,1
    1fca:	2b7020ef          	jal	4a80 <exit>

0000000000001fce <rwsbrk>:
{
    1fce:	1101                	addi	sp,sp,-32
    1fd0:	ec06                	sd	ra,24(sp)
    1fd2:	e822                	sd	s0,16(sp)
    1fd4:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    1fd6:	6509                	lui	a0,0x2
    1fd8:	331020ef          	jal	4b08 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    1fdc:	57fd                	li	a5,-1
    1fde:	04f50a63          	beq	a0,a5,2032 <rwsbrk+0x64>
    1fe2:	e426                	sd	s1,8(sp)
    1fe4:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    1fe6:	7579                	lui	a0,0xffffe
    1fe8:	321020ef          	jal	4b08 <sbrk>
    1fec:	57fd                	li	a5,-1
    1fee:	04f50d63          	beq	a0,a5,2048 <rwsbrk+0x7a>
    1ff2:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    1ff4:	20100593          	li	a1,513
    1ff8:	00004517          	auipc	a0,0x4
    1ffc:	d5850513          	addi	a0,a0,-680 # 5d50 <thread_join+0xcac>
    2000:	2c1020ef          	jal	4ac0 <open>
    2004:	892a                	mv	s2,a0
  if(fd < 0){
    2006:	04054b63          	bltz	a0,205c <rwsbrk+0x8e>
  n = write(fd, (void*)(a+4096), 1024);
    200a:	6785                	lui	a5,0x1
    200c:	94be                	add	s1,s1,a5
    200e:	40000613          	li	a2,1024
    2012:	85a6                	mv	a1,s1
    2014:	28d020ef          	jal	4aa0 <write>
    2018:	862a                	mv	a2,a0
  if(n >= 0){
    201a:	04054a63          	bltz	a0,206e <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    201e:	85a6                	mv	a1,s1
    2020:	00004517          	auipc	a0,0x4
    2024:	d5050513          	addi	a0,a0,-688 # 5d70 <thread_join+0xccc>
    2028:	681020ef          	jal	4ea8 <printf>
    exit(1);
    202c:	4505                	li	a0,1
    202e:	253020ef          	jal	4a80 <exit>
    2032:	e426                	sd	s1,8(sp)
    2034:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2036:	00004517          	auipc	a0,0x4
    203a:	ce250513          	addi	a0,a0,-798 # 5d18 <thread_join+0xc74>
    203e:	66b020ef          	jal	4ea8 <printf>
    exit(1);
    2042:	4505                	li	a0,1
    2044:	23d020ef          	jal	4a80 <exit>
    2048:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    204a:	00004517          	auipc	a0,0x4
    204e:	ce650513          	addi	a0,a0,-794 # 5d30 <thread_join+0xc8c>
    2052:	657020ef          	jal	4ea8 <printf>
    exit(1);
    2056:	4505                	li	a0,1
    2058:	229020ef          	jal	4a80 <exit>
    printf("open(rwsbrk) failed\n");
    205c:	00004517          	auipc	a0,0x4
    2060:	cfc50513          	addi	a0,a0,-772 # 5d58 <thread_join+0xcb4>
    2064:	645020ef          	jal	4ea8 <printf>
    exit(1);
    2068:	4505                	li	a0,1
    206a:	217020ef          	jal	4a80 <exit>
  close(fd);
    206e:	854a                	mv	a0,s2
    2070:	239020ef          	jal	4aa8 <close>
  unlink("rwsbrk");
    2074:	00004517          	auipc	a0,0x4
    2078:	cdc50513          	addi	a0,a0,-804 # 5d50 <thread_join+0xcac>
    207c:	255020ef          	jal	4ad0 <unlink>
  fd = open("README", O_RDONLY);
    2080:	4581                	li	a1,0
    2082:	00003517          	auipc	a0,0x3
    2086:	26e50513          	addi	a0,a0,622 # 52f0 <thread_join+0x24c>
    208a:	237020ef          	jal	4ac0 <open>
    208e:	892a                	mv	s2,a0
  if(fd < 0){
    2090:	02054363          	bltz	a0,20b6 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+4096), 10);
    2094:	4629                	li	a2,10
    2096:	85a6                	mv	a1,s1
    2098:	201020ef          	jal	4a98 <read>
    209c:	862a                	mv	a2,a0
  if(n >= 0){
    209e:	02054563          	bltz	a0,20c8 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    20a2:	85a6                	mv	a1,s1
    20a4:	00004517          	auipc	a0,0x4
    20a8:	cfc50513          	addi	a0,a0,-772 # 5da0 <thread_join+0xcfc>
    20ac:	5fd020ef          	jal	4ea8 <printf>
    exit(1);
    20b0:	4505                	li	a0,1
    20b2:	1cf020ef          	jal	4a80 <exit>
    printf("open(rwsbrk) failed\n");
    20b6:	00004517          	auipc	a0,0x4
    20ba:	ca250513          	addi	a0,a0,-862 # 5d58 <thread_join+0xcb4>
    20be:	5eb020ef          	jal	4ea8 <printf>
    exit(1);
    20c2:	4505                	li	a0,1
    20c4:	1bd020ef          	jal	4a80 <exit>
  close(fd);
    20c8:	854a                	mv	a0,s2
    20ca:	1df020ef          	jal	4aa8 <close>
  exit(0);
    20ce:	4501                	li	a0,0
    20d0:	1b1020ef          	jal	4a80 <exit>

00000000000020d4 <sbrkbasic>:
{
    20d4:	7139                	addi	sp,sp,-64
    20d6:	fc06                	sd	ra,56(sp)
    20d8:	f822                	sd	s0,48(sp)
    20da:	ec4e                	sd	s3,24(sp)
    20dc:	0080                	addi	s0,sp,64
    20de:	89aa                	mv	s3,a0
  pid = fork();
    20e0:	199020ef          	jal	4a78 <fork>
  if(pid < 0){
    20e4:	02054b63          	bltz	a0,211a <sbrkbasic+0x46>
  if(pid == 0){
    20e8:	e939                	bnez	a0,213e <sbrkbasic+0x6a>
    a = sbrk(TOOMUCH);
    20ea:	40000537          	lui	a0,0x40000
    20ee:	21b020ef          	jal	4b08 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    20f2:	57fd                	li	a5,-1
    20f4:	02f50f63          	beq	a0,a5,2132 <sbrkbasic+0x5e>
    20f8:	f426                	sd	s1,40(sp)
    20fa:	f04a                	sd	s2,32(sp)
    20fc:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    20fe:	400007b7          	lui	a5,0x40000
    2102:	97aa                	add	a5,a5,a0
      *b = 99;
    2104:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2108:	6705                	lui	a4,0x1
      *b = 99;
    210a:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    210e:	953a                	add	a0,a0,a4
    2110:	fef51de3          	bne	a0,a5,210a <sbrkbasic+0x36>
    exit(1);
    2114:	4505                	li	a0,1
    2116:	16b020ef          	jal	4a80 <exit>
    211a:	f426                	sd	s1,40(sp)
    211c:	f04a                	sd	s2,32(sp)
    211e:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    2120:	00004517          	auipc	a0,0x4
    2124:	ca850513          	addi	a0,a0,-856 # 5dc8 <thread_join+0xd24>
    2128:	581020ef          	jal	4ea8 <printf>
    exit(1);
    212c:	4505                	li	a0,1
    212e:	153020ef          	jal	4a80 <exit>
    2132:	f426                	sd	s1,40(sp)
    2134:	f04a                	sd	s2,32(sp)
    2136:	e852                	sd	s4,16(sp)
      exit(0);
    2138:	4501                	li	a0,0
    213a:	147020ef          	jal	4a80 <exit>
  wait(&xstatus);
    213e:	fcc40513          	addi	a0,s0,-52
    2142:	147020ef          	jal	4a88 <wait>
  if(xstatus == 1){
    2146:	fcc42703          	lw	a4,-52(s0)
    214a:	4785                	li	a5,1
    214c:	00f70e63          	beq	a4,a5,2168 <sbrkbasic+0x94>
    2150:	f426                	sd	s1,40(sp)
    2152:	f04a                	sd	s2,32(sp)
    2154:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    2156:	4501                	li	a0,0
    2158:	1b1020ef          	jal	4b08 <sbrk>
    215c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    215e:	4901                	li	s2,0
    2160:	6a05                	lui	s4,0x1
    2162:	388a0a13          	addi	s4,s4,904 # 1388 <exectest+0x4a>
    2166:	a839                	j	2184 <sbrkbasic+0xb0>
    2168:	f426                	sd	s1,40(sp)
    216a:	f04a                	sd	s2,32(sp)
    216c:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    216e:	85ce                	mv	a1,s3
    2170:	00004517          	auipc	a0,0x4
    2174:	c7850513          	addi	a0,a0,-904 # 5de8 <thread_join+0xd44>
    2178:	531020ef          	jal	4ea8 <printf>
    exit(1);
    217c:	4505                	li	a0,1
    217e:	103020ef          	jal	4a80 <exit>
    2182:	84be                	mv	s1,a5
    b = sbrk(1);
    2184:	4505                	li	a0,1
    2186:	183020ef          	jal	4b08 <sbrk>
    if(b != a){
    218a:	04951263          	bne	a0,s1,21ce <sbrkbasic+0xfa>
    *b = 1;
    218e:	4785                	li	a5,1
    2190:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    2194:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2198:	2905                	addiw	s2,s2,1
    219a:	ff4914e3          	bne	s2,s4,2182 <sbrkbasic+0xae>
  pid = fork();
    219e:	0db020ef          	jal	4a78 <fork>
    21a2:	892a                	mv	s2,a0
  if(pid < 0){
    21a4:	04054263          	bltz	a0,21e8 <sbrkbasic+0x114>
  c = sbrk(1);
    21a8:	4505                	li	a0,1
    21aa:	15f020ef          	jal	4b08 <sbrk>
  c = sbrk(1);
    21ae:	4505                	li	a0,1
    21b0:	159020ef          	jal	4b08 <sbrk>
  if(c != a + 1){
    21b4:	0489                	addi	s1,s1,2
    21b6:	04a48363          	beq	s1,a0,21fc <sbrkbasic+0x128>
    printf("%s: sbrk test failed post-fork\n", s);
    21ba:	85ce                	mv	a1,s3
    21bc:	00004517          	auipc	a0,0x4
    21c0:	c8c50513          	addi	a0,a0,-884 # 5e48 <thread_join+0xda4>
    21c4:	4e5020ef          	jal	4ea8 <printf>
    exit(1);
    21c8:	4505                	li	a0,1
    21ca:	0b7020ef          	jal	4a80 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    21ce:	872a                	mv	a4,a0
    21d0:	86a6                	mv	a3,s1
    21d2:	864a                	mv	a2,s2
    21d4:	85ce                	mv	a1,s3
    21d6:	00004517          	auipc	a0,0x4
    21da:	c3250513          	addi	a0,a0,-974 # 5e08 <thread_join+0xd64>
    21de:	4cb020ef          	jal	4ea8 <printf>
      exit(1);
    21e2:	4505                	li	a0,1
    21e4:	09d020ef          	jal	4a80 <exit>
    printf("%s: sbrk test fork failed\n", s);
    21e8:	85ce                	mv	a1,s3
    21ea:	00004517          	auipc	a0,0x4
    21ee:	c3e50513          	addi	a0,a0,-962 # 5e28 <thread_join+0xd84>
    21f2:	4b7020ef          	jal	4ea8 <printf>
    exit(1);
    21f6:	4505                	li	a0,1
    21f8:	089020ef          	jal	4a80 <exit>
  if(pid == 0)
    21fc:	00091563          	bnez	s2,2206 <sbrkbasic+0x132>
    exit(0);
    2200:	4501                	li	a0,0
    2202:	07f020ef          	jal	4a80 <exit>
  wait(&xstatus);
    2206:	fcc40513          	addi	a0,s0,-52
    220a:	07f020ef          	jal	4a88 <wait>
  exit(xstatus);
    220e:	fcc42503          	lw	a0,-52(s0)
    2212:	06f020ef          	jal	4a80 <exit>

0000000000002216 <sbrkmuch>:
{
    2216:	7179                	addi	sp,sp,-48
    2218:	f406                	sd	ra,40(sp)
    221a:	f022                	sd	s0,32(sp)
    221c:	ec26                	sd	s1,24(sp)
    221e:	e84a                	sd	s2,16(sp)
    2220:	e44e                	sd	s3,8(sp)
    2222:	e052                	sd	s4,0(sp)
    2224:	1800                	addi	s0,sp,48
    2226:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2228:	4501                	li	a0,0
    222a:	0df020ef          	jal	4b08 <sbrk>
    222e:	892a                	mv	s2,a0
  a = sbrk(0);
    2230:	4501                	li	a0,0
    2232:	0d7020ef          	jal	4b08 <sbrk>
    2236:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2238:	06400537          	lui	a0,0x6400
    223c:	9d05                	subw	a0,a0,s1
    223e:	0cb020ef          	jal	4b08 <sbrk>
  if (p != a) {
    2242:	0aa49463          	bne	s1,a0,22ea <sbrkmuch+0xd4>
  char *eee = sbrk(0);
    2246:	4501                	li	a0,0
    2248:	0c1020ef          	jal	4b08 <sbrk>
    224c:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    224e:	00a4f963          	bgeu	s1,a0,2260 <sbrkmuch+0x4a>
    *pp = 1;
    2252:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2254:	6705                	lui	a4,0x1
    *pp = 1;
    2256:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    225a:	94ba                	add	s1,s1,a4
    225c:	fef4ede3          	bltu	s1,a5,2256 <sbrkmuch+0x40>
  *lastaddr = 99;
    2260:	064007b7          	lui	a5,0x6400
    2264:	06300713          	li	a4,99
    2268:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    226c:	4501                	li	a0,0
    226e:	09b020ef          	jal	4b08 <sbrk>
    2272:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2274:	757d                	lui	a0,0xfffff
    2276:	093020ef          	jal	4b08 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    227a:	57fd                	li	a5,-1
    227c:	08f50163          	beq	a0,a5,22fe <sbrkmuch+0xe8>
  c = sbrk(0);
    2280:	4501                	li	a0,0
    2282:	087020ef          	jal	4b08 <sbrk>
  if(c != a - PGSIZE){
    2286:	77fd                	lui	a5,0xfffff
    2288:	97a6                	add	a5,a5,s1
    228a:	08f51463          	bne	a0,a5,2312 <sbrkmuch+0xfc>
  a = sbrk(0);
    228e:	4501                	li	a0,0
    2290:	079020ef          	jal	4b08 <sbrk>
    2294:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2296:	6505                	lui	a0,0x1
    2298:	071020ef          	jal	4b08 <sbrk>
    229c:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    229e:	08a49663          	bne	s1,a0,232a <sbrkmuch+0x114>
    22a2:	4501                	li	a0,0
    22a4:	065020ef          	jal	4b08 <sbrk>
    22a8:	6785                	lui	a5,0x1
    22aa:	97a6                	add	a5,a5,s1
    22ac:	06f51f63          	bne	a0,a5,232a <sbrkmuch+0x114>
  if(*lastaddr == 99){
    22b0:	064007b7          	lui	a5,0x6400
    22b4:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    22b8:	06300793          	li	a5,99
    22bc:	08f70363          	beq	a4,a5,2342 <sbrkmuch+0x12c>
  a = sbrk(0);
    22c0:	4501                	li	a0,0
    22c2:	047020ef          	jal	4b08 <sbrk>
    22c6:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    22c8:	4501                	li	a0,0
    22ca:	03f020ef          	jal	4b08 <sbrk>
    22ce:	40a9053b          	subw	a0,s2,a0
    22d2:	037020ef          	jal	4b08 <sbrk>
  if(c != a){
    22d6:	08a49063          	bne	s1,a0,2356 <sbrkmuch+0x140>
}
    22da:	70a2                	ld	ra,40(sp)
    22dc:	7402                	ld	s0,32(sp)
    22de:	64e2                	ld	s1,24(sp)
    22e0:	6942                	ld	s2,16(sp)
    22e2:	69a2                	ld	s3,8(sp)
    22e4:	6a02                	ld	s4,0(sp)
    22e6:	6145                	addi	sp,sp,48
    22e8:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    22ea:	85ce                	mv	a1,s3
    22ec:	00004517          	auipc	a0,0x4
    22f0:	b7c50513          	addi	a0,a0,-1156 # 5e68 <thread_join+0xdc4>
    22f4:	3b5020ef          	jal	4ea8 <printf>
    exit(1);
    22f8:	4505                	li	a0,1
    22fa:	786020ef          	jal	4a80 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    22fe:	85ce                	mv	a1,s3
    2300:	00004517          	auipc	a0,0x4
    2304:	bb050513          	addi	a0,a0,-1104 # 5eb0 <thread_join+0xe0c>
    2308:	3a1020ef          	jal	4ea8 <printf>
    exit(1);
    230c:	4505                	li	a0,1
    230e:	772020ef          	jal	4a80 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2312:	86aa                	mv	a3,a0
    2314:	8626                	mv	a2,s1
    2316:	85ce                	mv	a1,s3
    2318:	00004517          	auipc	a0,0x4
    231c:	bb850513          	addi	a0,a0,-1096 # 5ed0 <thread_join+0xe2c>
    2320:	389020ef          	jal	4ea8 <printf>
    exit(1);
    2324:	4505                	li	a0,1
    2326:	75a020ef          	jal	4a80 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    232a:	86d2                	mv	a3,s4
    232c:	8626                	mv	a2,s1
    232e:	85ce                	mv	a1,s3
    2330:	00004517          	auipc	a0,0x4
    2334:	be050513          	addi	a0,a0,-1056 # 5f10 <thread_join+0xe6c>
    2338:	371020ef          	jal	4ea8 <printf>
    exit(1);
    233c:	4505                	li	a0,1
    233e:	742020ef          	jal	4a80 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2342:	85ce                	mv	a1,s3
    2344:	00004517          	auipc	a0,0x4
    2348:	bfc50513          	addi	a0,a0,-1028 # 5f40 <thread_join+0xe9c>
    234c:	35d020ef          	jal	4ea8 <printf>
    exit(1);
    2350:	4505                	li	a0,1
    2352:	72e020ef          	jal	4a80 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    2356:	86aa                	mv	a3,a0
    2358:	8626                	mv	a2,s1
    235a:	85ce                	mv	a1,s3
    235c:	00004517          	auipc	a0,0x4
    2360:	c1c50513          	addi	a0,a0,-996 # 5f78 <thread_join+0xed4>
    2364:	345020ef          	jal	4ea8 <printf>
    exit(1);
    2368:	4505                	li	a0,1
    236a:	716020ef          	jal	4a80 <exit>

000000000000236e <sbrkarg>:
{
    236e:	7179                	addi	sp,sp,-48
    2370:	f406                	sd	ra,40(sp)
    2372:	f022                	sd	s0,32(sp)
    2374:	ec26                	sd	s1,24(sp)
    2376:	e84a                	sd	s2,16(sp)
    2378:	e44e                	sd	s3,8(sp)
    237a:	1800                	addi	s0,sp,48
    237c:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    237e:	6505                	lui	a0,0x1
    2380:	788020ef          	jal	4b08 <sbrk>
    2384:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2386:	20100593          	li	a1,513
    238a:	00004517          	auipc	a0,0x4
    238e:	c1650513          	addi	a0,a0,-1002 # 5fa0 <thread_join+0xefc>
    2392:	72e020ef          	jal	4ac0 <open>
    2396:	84aa                	mv	s1,a0
  unlink("sbrk");
    2398:	00004517          	auipc	a0,0x4
    239c:	c0850513          	addi	a0,a0,-1016 # 5fa0 <thread_join+0xefc>
    23a0:	730020ef          	jal	4ad0 <unlink>
  if(fd < 0)  {
    23a4:	0204c963          	bltz	s1,23d6 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    23a8:	6605                	lui	a2,0x1
    23aa:	85ca                	mv	a1,s2
    23ac:	8526                	mv	a0,s1
    23ae:	6f2020ef          	jal	4aa0 <write>
    23b2:	02054c63          	bltz	a0,23ea <sbrkarg+0x7c>
  close(fd);
    23b6:	8526                	mv	a0,s1
    23b8:	6f0020ef          	jal	4aa8 <close>
  a = sbrk(PGSIZE);
    23bc:	6505                	lui	a0,0x1
    23be:	74a020ef          	jal	4b08 <sbrk>
  if(pipe((int *) a) != 0){
    23c2:	6ce020ef          	jal	4a90 <pipe>
    23c6:	ed05                	bnez	a0,23fe <sbrkarg+0x90>
}
    23c8:	70a2                	ld	ra,40(sp)
    23ca:	7402                	ld	s0,32(sp)
    23cc:	64e2                	ld	s1,24(sp)
    23ce:	6942                	ld	s2,16(sp)
    23d0:	69a2                	ld	s3,8(sp)
    23d2:	6145                	addi	sp,sp,48
    23d4:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    23d6:	85ce                	mv	a1,s3
    23d8:	00004517          	auipc	a0,0x4
    23dc:	bd050513          	addi	a0,a0,-1072 # 5fa8 <thread_join+0xf04>
    23e0:	2c9020ef          	jal	4ea8 <printf>
    exit(1);
    23e4:	4505                	li	a0,1
    23e6:	69a020ef          	jal	4a80 <exit>
    printf("%s: write sbrk failed\n", s);
    23ea:	85ce                	mv	a1,s3
    23ec:	00004517          	auipc	a0,0x4
    23f0:	bd450513          	addi	a0,a0,-1068 # 5fc0 <thread_join+0xf1c>
    23f4:	2b5020ef          	jal	4ea8 <printf>
    exit(1);
    23f8:	4505                	li	a0,1
    23fa:	686020ef          	jal	4a80 <exit>
    printf("%s: pipe() failed\n", s);
    23fe:	85ce                	mv	a1,s3
    2400:	00003517          	auipc	a0,0x3
    2404:	6b050513          	addi	a0,a0,1712 # 5ab0 <thread_join+0xa0c>
    2408:	2a1020ef          	jal	4ea8 <printf>
    exit(1);
    240c:	4505                	li	a0,1
    240e:	672020ef          	jal	4a80 <exit>

0000000000002412 <argptest>:
{
    2412:	1101                	addi	sp,sp,-32
    2414:	ec06                	sd	ra,24(sp)
    2416:	e822                	sd	s0,16(sp)
    2418:	e426                	sd	s1,8(sp)
    241a:	e04a                	sd	s2,0(sp)
    241c:	1000                	addi	s0,sp,32
    241e:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2420:	4581                	li	a1,0
    2422:	00004517          	auipc	a0,0x4
    2426:	bb650513          	addi	a0,a0,-1098 # 5fd8 <thread_join+0xf34>
    242a:	696020ef          	jal	4ac0 <open>
  if (fd < 0) {
    242e:	02054563          	bltz	a0,2458 <argptest+0x46>
    2432:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2434:	4501                	li	a0,0
    2436:	6d2020ef          	jal	4b08 <sbrk>
    243a:	567d                	li	a2,-1
    243c:	fff50593          	addi	a1,a0,-1
    2440:	8526                	mv	a0,s1
    2442:	656020ef          	jal	4a98 <read>
  close(fd);
    2446:	8526                	mv	a0,s1
    2448:	660020ef          	jal	4aa8 <close>
}
    244c:	60e2                	ld	ra,24(sp)
    244e:	6442                	ld	s0,16(sp)
    2450:	64a2                	ld	s1,8(sp)
    2452:	6902                	ld	s2,0(sp)
    2454:	6105                	addi	sp,sp,32
    2456:	8082                	ret
    printf("%s: open failed\n", s);
    2458:	85ca                	mv	a1,s2
    245a:	00003517          	auipc	a0,0x3
    245e:	56650513          	addi	a0,a0,1382 # 59c0 <thread_join+0x91c>
    2462:	247020ef          	jal	4ea8 <printf>
    exit(1);
    2466:	4505                	li	a0,1
    2468:	618020ef          	jal	4a80 <exit>

000000000000246c <sbrkbugs>:
{
    246c:	1141                	addi	sp,sp,-16
    246e:	e406                	sd	ra,8(sp)
    2470:	e022                	sd	s0,0(sp)
    2472:	0800                	addi	s0,sp,16
  int pid = fork();
    2474:	604020ef          	jal	4a78 <fork>
  if(pid < 0){
    2478:	00054c63          	bltz	a0,2490 <sbrkbugs+0x24>
  if(pid == 0){
    247c:	e11d                	bnez	a0,24a2 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    247e:	68a020ef          	jal	4b08 <sbrk>
    sbrk(-sz);
    2482:	40a0053b          	negw	a0,a0
    2486:	682020ef          	jal	4b08 <sbrk>
    exit(0);
    248a:	4501                	li	a0,0
    248c:	5f4020ef          	jal	4a80 <exit>
    printf("fork failed\n");
    2490:	00005517          	auipc	a0,0x5
    2494:	a8850513          	addi	a0,a0,-1400 # 6f18 <thread_join+0x1e74>
    2498:	211020ef          	jal	4ea8 <printf>
    exit(1);
    249c:	4505                	li	a0,1
    249e:	5e2020ef          	jal	4a80 <exit>
  wait(0);
    24a2:	4501                	li	a0,0
    24a4:	5e4020ef          	jal	4a88 <wait>
  pid = fork();
    24a8:	5d0020ef          	jal	4a78 <fork>
  if(pid < 0){
    24ac:	00054f63          	bltz	a0,24ca <sbrkbugs+0x5e>
  if(pid == 0){
    24b0:	e515                	bnez	a0,24dc <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    24b2:	656020ef          	jal	4b08 <sbrk>
    sbrk(-(sz - 3500));
    24b6:	6785                	lui	a5,0x1
    24b8:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0x138>
    24bc:	40a7853b          	subw	a0,a5,a0
    24c0:	648020ef          	jal	4b08 <sbrk>
    exit(0);
    24c4:	4501                	li	a0,0
    24c6:	5ba020ef          	jal	4a80 <exit>
    printf("fork failed\n");
    24ca:	00005517          	auipc	a0,0x5
    24ce:	a4e50513          	addi	a0,a0,-1458 # 6f18 <thread_join+0x1e74>
    24d2:	1d7020ef          	jal	4ea8 <printf>
    exit(1);
    24d6:	4505                	li	a0,1
    24d8:	5a8020ef          	jal	4a80 <exit>
  wait(0);
    24dc:	4501                	li	a0,0
    24de:	5aa020ef          	jal	4a88 <wait>
  pid = fork();
    24e2:	596020ef          	jal	4a78 <fork>
  if(pid < 0){
    24e6:	02054263          	bltz	a0,250a <sbrkbugs+0x9e>
  if(pid == 0){
    24ea:	e90d                	bnez	a0,251c <sbrkbugs+0xb0>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    24ec:	61c020ef          	jal	4b08 <sbrk>
    24f0:	67ad                	lui	a5,0xb
    24f2:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x298>
    24f6:	40a7853b          	subw	a0,a5,a0
    24fa:	60e020ef          	jal	4b08 <sbrk>
    sbrk(-10);
    24fe:	5559                	li	a0,-10
    2500:	608020ef          	jal	4b08 <sbrk>
    exit(0);
    2504:	4501                	li	a0,0
    2506:	57a020ef          	jal	4a80 <exit>
    printf("fork failed\n");
    250a:	00005517          	auipc	a0,0x5
    250e:	a0e50513          	addi	a0,a0,-1522 # 6f18 <thread_join+0x1e74>
    2512:	197020ef          	jal	4ea8 <printf>
    exit(1);
    2516:	4505                	li	a0,1
    2518:	568020ef          	jal	4a80 <exit>
  wait(0);
    251c:	4501                	li	a0,0
    251e:	56a020ef          	jal	4a88 <wait>
  exit(0);
    2522:	4501                	li	a0,0
    2524:	55c020ef          	jal	4a80 <exit>

0000000000002528 <sbrklast>:
{
    2528:	7179                	addi	sp,sp,-48
    252a:	f406                	sd	ra,40(sp)
    252c:	f022                	sd	s0,32(sp)
    252e:	ec26                	sd	s1,24(sp)
    2530:	e84a                	sd	s2,16(sp)
    2532:	e44e                	sd	s3,8(sp)
    2534:	e052                	sd	s4,0(sp)
    2536:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2538:	4501                	li	a0,0
    253a:	5ce020ef          	jal	4b08 <sbrk>
  if((top % 4096) != 0)
    253e:	03451793          	slli	a5,a0,0x34
    2542:	ebad                	bnez	a5,25b4 <sbrklast+0x8c>
  sbrk(4096);
    2544:	6505                	lui	a0,0x1
    2546:	5c2020ef          	jal	4b08 <sbrk>
  sbrk(10);
    254a:	4529                	li	a0,10
    254c:	5bc020ef          	jal	4b08 <sbrk>
  sbrk(-20);
    2550:	5531                	li	a0,-20
    2552:	5b6020ef          	jal	4b08 <sbrk>
  top = (uint64) sbrk(0);
    2556:	4501                	li	a0,0
    2558:	5b0020ef          	jal	4b08 <sbrk>
    255c:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    255e:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0x122>
  p[0] = 'x';
    2562:	07800a13          	li	s4,120
    2566:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    256a:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    256e:	20200593          	li	a1,514
    2572:	854a                	mv	a0,s2
    2574:	54c020ef          	jal	4ac0 <open>
    2578:	89aa                	mv	s3,a0
  write(fd, p, 1);
    257a:	4605                	li	a2,1
    257c:	85ca                	mv	a1,s2
    257e:	522020ef          	jal	4aa0 <write>
  close(fd);
    2582:	854e                	mv	a0,s3
    2584:	524020ef          	jal	4aa8 <close>
  fd = open(p, O_RDWR);
    2588:	4589                	li	a1,2
    258a:	854a                	mv	a0,s2
    258c:	534020ef          	jal	4ac0 <open>
  p[0] = '\0';
    2590:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2594:	4605                	li	a2,1
    2596:	85ca                	mv	a1,s2
    2598:	500020ef          	jal	4a98 <read>
  if(p[0] != 'x')
    259c:	fc04c783          	lbu	a5,-64(s1)
    25a0:	03479263          	bne	a5,s4,25c4 <sbrklast+0x9c>
}
    25a4:	70a2                	ld	ra,40(sp)
    25a6:	7402                	ld	s0,32(sp)
    25a8:	64e2                	ld	s1,24(sp)
    25aa:	6942                	ld	s2,16(sp)
    25ac:	69a2                	ld	s3,8(sp)
    25ae:	6a02                	ld	s4,0(sp)
    25b0:	6145                	addi	sp,sp,48
    25b2:	8082                	ret
    sbrk(4096 - (top % 4096));
    25b4:	0347d513          	srli	a0,a5,0x34
    25b8:	6785                	lui	a5,0x1
    25ba:	40a7853b          	subw	a0,a5,a0
    25be:	54a020ef          	jal	4b08 <sbrk>
    25c2:	b749                	j	2544 <sbrklast+0x1c>
    exit(1);
    25c4:	4505                	li	a0,1
    25c6:	4ba020ef          	jal	4a80 <exit>

00000000000025ca <sbrk8000>:
{
    25ca:	1141                	addi	sp,sp,-16
    25cc:	e406                	sd	ra,8(sp)
    25ce:	e022                	sd	s0,0(sp)
    25d0:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    25d2:	80000537          	lui	a0,0x80000
    25d6:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    25d8:	530020ef          	jal	4b08 <sbrk>
  volatile char *top = sbrk(0);
    25dc:	4501                	li	a0,0
    25de:	52a020ef          	jal	4b08 <sbrk>
  *(top-1) = *(top-1) + 1;
    25e2:	fff54783          	lbu	a5,-1(a0)
    25e6:	2785                	addiw	a5,a5,1 # 1001 <badarg+0x1>
    25e8:	0ff7f793          	zext.b	a5,a5
    25ec:	fef50fa3          	sb	a5,-1(a0)
}
    25f0:	60a2                	ld	ra,8(sp)
    25f2:	6402                	ld	s0,0(sp)
    25f4:	0141                	addi	sp,sp,16
    25f6:	8082                	ret

00000000000025f8 <execout>:
{
    25f8:	715d                	addi	sp,sp,-80
    25fa:	e486                	sd	ra,72(sp)
    25fc:	e0a2                	sd	s0,64(sp)
    25fe:	fc26                	sd	s1,56(sp)
    2600:	f84a                	sd	s2,48(sp)
    2602:	f44e                	sd	s3,40(sp)
    2604:	f052                	sd	s4,32(sp)
    2606:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2608:	4901                	li	s2,0
    260a:	49bd                	li	s3,15
    int pid = fork();
    260c:	46c020ef          	jal	4a78 <fork>
    2610:	84aa                	mv	s1,a0
    if(pid < 0){
    2612:	00054c63          	bltz	a0,262a <execout+0x32>
    } else if(pid == 0){
    2616:	c11d                	beqz	a0,263c <execout+0x44>
      wait((int*)0);
    2618:	4501                	li	a0,0
    261a:	46e020ef          	jal	4a88 <wait>
  for(int avail = 0; avail < 15; avail++){
    261e:	2905                	addiw	s2,s2,1
    2620:	ff3916e3          	bne	s2,s3,260c <execout+0x14>
  exit(0);
    2624:	4501                	li	a0,0
    2626:	45a020ef          	jal	4a80 <exit>
      printf("fork failed\n");
    262a:	00005517          	auipc	a0,0x5
    262e:	8ee50513          	addi	a0,a0,-1810 # 6f18 <thread_join+0x1e74>
    2632:	077020ef          	jal	4ea8 <printf>
      exit(1);
    2636:	4505                	li	a0,1
    2638:	448020ef          	jal	4a80 <exit>
        if(a == 0xffffffffffffffffLL)
    263c:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    263e:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    2640:	6505                	lui	a0,0x1
    2642:	4c6020ef          	jal	4b08 <sbrk>
        if(a == 0xffffffffffffffffLL)
    2646:	01350763          	beq	a0,s3,2654 <execout+0x5c>
        *(char*)(a + 4096 - 1) = 1;
    264a:	6785                	lui	a5,0x1
    264c:	97aa                	add	a5,a5,a0
    264e:	ff478fa3          	sb	s4,-1(a5) # fff <pgbug+0x2b>
      while(1){
    2652:	b7fd                	j	2640 <execout+0x48>
      for(int i = 0; i < avail; i++)
    2654:	01205863          	blez	s2,2664 <execout+0x6c>
        sbrk(-4096);
    2658:	757d                	lui	a0,0xfffff
    265a:	4ae020ef          	jal	4b08 <sbrk>
      for(int i = 0; i < avail; i++)
    265e:	2485                	addiw	s1,s1,1
    2660:	ff249ce3          	bne	s1,s2,2658 <execout+0x60>
      close(1);
    2664:	4505                	li	a0,1
    2666:	442020ef          	jal	4aa8 <close>
      char *args[] = { "echo", "x", 0 };
    266a:	00003517          	auipc	a0,0x3
    266e:	aae50513          	addi	a0,a0,-1362 # 5118 <thread_join+0x74>
    2672:	faa43c23          	sd	a0,-72(s0)
    2676:	00003797          	auipc	a5,0x3
    267a:	b1278793          	addi	a5,a5,-1262 # 5188 <thread_join+0xe4>
    267e:	fcf43023          	sd	a5,-64(s0)
    2682:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    2686:	fb840593          	addi	a1,s0,-72
    268a:	42e020ef          	jal	4ab8 <exec>
      exit(0);
    268e:	4501                	li	a0,0
    2690:	3f0020ef          	jal	4a80 <exit>

0000000000002694 <fourteen>:
{
    2694:	1101                	addi	sp,sp,-32
    2696:	ec06                	sd	ra,24(sp)
    2698:	e822                	sd	s0,16(sp)
    269a:	e426                	sd	s1,8(sp)
    269c:	1000                	addi	s0,sp,32
    269e:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    26a0:	00004517          	auipc	a0,0x4
    26a4:	b1050513          	addi	a0,a0,-1264 # 61b0 <thread_join+0x110c>
    26a8:	440020ef          	jal	4ae8 <mkdir>
    26ac:	e555                	bnez	a0,2758 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    26ae:	00004517          	auipc	a0,0x4
    26b2:	95a50513          	addi	a0,a0,-1702 # 6008 <thread_join+0xf64>
    26b6:	432020ef          	jal	4ae8 <mkdir>
    26ba:	e94d                	bnez	a0,276c <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    26bc:	20000593          	li	a1,512
    26c0:	00004517          	auipc	a0,0x4
    26c4:	9a050513          	addi	a0,a0,-1632 # 6060 <thread_join+0xfbc>
    26c8:	3f8020ef          	jal	4ac0 <open>
  if(fd < 0){
    26cc:	0a054a63          	bltz	a0,2780 <fourteen+0xec>
  close(fd);
    26d0:	3d8020ef          	jal	4aa8 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    26d4:	4581                	li	a1,0
    26d6:	00004517          	auipc	a0,0x4
    26da:	a0250513          	addi	a0,a0,-1534 # 60d8 <thread_join+0x1034>
    26de:	3e2020ef          	jal	4ac0 <open>
  if(fd < 0){
    26e2:	0a054963          	bltz	a0,2794 <fourteen+0x100>
  close(fd);
    26e6:	3c2020ef          	jal	4aa8 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    26ea:	00004517          	auipc	a0,0x4
    26ee:	a5e50513          	addi	a0,a0,-1442 # 6148 <thread_join+0x10a4>
    26f2:	3f6020ef          	jal	4ae8 <mkdir>
    26f6:	c94d                	beqz	a0,27a8 <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    26f8:	00004517          	auipc	a0,0x4
    26fc:	aa850513          	addi	a0,a0,-1368 # 61a0 <thread_join+0x10fc>
    2700:	3e8020ef          	jal	4ae8 <mkdir>
    2704:	cd45                	beqz	a0,27bc <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    2706:	00004517          	auipc	a0,0x4
    270a:	a9a50513          	addi	a0,a0,-1382 # 61a0 <thread_join+0x10fc>
    270e:	3c2020ef          	jal	4ad0 <unlink>
  unlink("12345678901234/12345678901234");
    2712:	00004517          	auipc	a0,0x4
    2716:	a3650513          	addi	a0,a0,-1482 # 6148 <thread_join+0x10a4>
    271a:	3b6020ef          	jal	4ad0 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    271e:	00004517          	auipc	a0,0x4
    2722:	9ba50513          	addi	a0,a0,-1606 # 60d8 <thread_join+0x1034>
    2726:	3aa020ef          	jal	4ad0 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    272a:	00004517          	auipc	a0,0x4
    272e:	93650513          	addi	a0,a0,-1738 # 6060 <thread_join+0xfbc>
    2732:	39e020ef          	jal	4ad0 <unlink>
  unlink("12345678901234/123456789012345");
    2736:	00004517          	auipc	a0,0x4
    273a:	8d250513          	addi	a0,a0,-1838 # 6008 <thread_join+0xf64>
    273e:	392020ef          	jal	4ad0 <unlink>
  unlink("12345678901234");
    2742:	00004517          	auipc	a0,0x4
    2746:	a6e50513          	addi	a0,a0,-1426 # 61b0 <thread_join+0x110c>
    274a:	386020ef          	jal	4ad0 <unlink>
}
    274e:	60e2                	ld	ra,24(sp)
    2750:	6442                	ld	s0,16(sp)
    2752:	64a2                	ld	s1,8(sp)
    2754:	6105                	addi	sp,sp,32
    2756:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2758:	85a6                	mv	a1,s1
    275a:	00004517          	auipc	a0,0x4
    275e:	88650513          	addi	a0,a0,-1914 # 5fe0 <thread_join+0xf3c>
    2762:	746020ef          	jal	4ea8 <printf>
    exit(1);
    2766:	4505                	li	a0,1
    2768:	318020ef          	jal	4a80 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    276c:	85a6                	mv	a1,s1
    276e:	00004517          	auipc	a0,0x4
    2772:	8ba50513          	addi	a0,a0,-1862 # 6028 <thread_join+0xf84>
    2776:	732020ef          	jal	4ea8 <printf>
    exit(1);
    277a:	4505                	li	a0,1
    277c:	304020ef          	jal	4a80 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2780:	85a6                	mv	a1,s1
    2782:	00004517          	auipc	a0,0x4
    2786:	90e50513          	addi	a0,a0,-1778 # 6090 <thread_join+0xfec>
    278a:	71e020ef          	jal	4ea8 <printf>
    exit(1);
    278e:	4505                	li	a0,1
    2790:	2f0020ef          	jal	4a80 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2794:	85a6                	mv	a1,s1
    2796:	00004517          	auipc	a0,0x4
    279a:	97250513          	addi	a0,a0,-1678 # 6108 <thread_join+0x1064>
    279e:	70a020ef          	jal	4ea8 <printf>
    exit(1);
    27a2:	4505                	li	a0,1
    27a4:	2dc020ef          	jal	4a80 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    27a8:	85a6                	mv	a1,s1
    27aa:	00004517          	auipc	a0,0x4
    27ae:	9be50513          	addi	a0,a0,-1602 # 6168 <thread_join+0x10c4>
    27b2:	6f6020ef          	jal	4ea8 <printf>
    exit(1);
    27b6:	4505                	li	a0,1
    27b8:	2c8020ef          	jal	4a80 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    27bc:	85a6                	mv	a1,s1
    27be:	00004517          	auipc	a0,0x4
    27c2:	a0250513          	addi	a0,a0,-1534 # 61c0 <thread_join+0x111c>
    27c6:	6e2020ef          	jal	4ea8 <printf>
    exit(1);
    27ca:	4505                	li	a0,1
    27cc:	2b4020ef          	jal	4a80 <exit>

00000000000027d0 <diskfull>:
{
    27d0:	b8010113          	addi	sp,sp,-1152
    27d4:	46113c23          	sd	ra,1144(sp)
    27d8:	46813823          	sd	s0,1136(sp)
    27dc:	46913423          	sd	s1,1128(sp)
    27e0:	47213023          	sd	s2,1120(sp)
    27e4:	45313c23          	sd	s3,1112(sp)
    27e8:	45413823          	sd	s4,1104(sp)
    27ec:	45513423          	sd	s5,1096(sp)
    27f0:	45613023          	sd	s6,1088(sp)
    27f4:	43713c23          	sd	s7,1080(sp)
    27f8:	43813823          	sd	s8,1072(sp)
    27fc:	43913423          	sd	s9,1064(sp)
    2800:	48010413          	addi	s0,sp,1152
    2804:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    2806:	00004517          	auipc	a0,0x4
    280a:	9f250513          	addi	a0,a0,-1550 # 61f8 <thread_join+0x1154>
    280e:	2c2020ef          	jal	4ad0 <unlink>
    2812:	03000993          	li	s3,48
    name[0] = 'b';
    2816:	06200b13          	li	s6,98
    name[1] = 'i';
    281a:	06900a93          	li	s5,105
    name[2] = 'g';
    281e:	06700a13          	li	s4,103
    2822:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2826:	07f00c13          	li	s8,127
    282a:	aab9                	j	2988 <diskfull+0x1b8>
      printf("%s: could not create file %s\n", s, name);
    282c:	b8040613          	addi	a2,s0,-1152
    2830:	85e6                	mv	a1,s9
    2832:	00004517          	auipc	a0,0x4
    2836:	9d650513          	addi	a0,a0,-1578 # 6208 <thread_join+0x1164>
    283a:	66e020ef          	jal	4ea8 <printf>
      break;
    283e:	a039                	j	284c <diskfull+0x7c>
        close(fd);
    2840:	854a                	mv	a0,s2
    2842:	266020ef          	jal	4aa8 <close>
    close(fd);
    2846:	854a                	mv	a0,s2
    2848:	260020ef          	jal	4aa8 <close>
  for(int i = 0; i < nzz; i++){
    284c:	4481                	li	s1,0
    name[0] = 'z';
    284e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    2852:	08000993          	li	s3,128
    name[0] = 'z';
    2856:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    285a:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    285e:	41f4d71b          	sraiw	a4,s1,0x1f
    2862:	01b7571b          	srliw	a4,a4,0x1b
    2866:	009707bb          	addw	a5,a4,s1
    286a:	4057d69b          	sraiw	a3,a5,0x5
    286e:	0306869b          	addiw	a3,a3,48
    2872:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    2876:	8bfd                	andi	a5,a5,31
    2878:	9f99                	subw	a5,a5,a4
    287a:	0307879b          	addiw	a5,a5,48
    287e:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    2882:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2886:	ba040513          	addi	a0,s0,-1120
    288a:	246020ef          	jal	4ad0 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    288e:	60200593          	li	a1,1538
    2892:	ba040513          	addi	a0,s0,-1120
    2896:	22a020ef          	jal	4ac0 <open>
    if(fd < 0)
    289a:	00054763          	bltz	a0,28a8 <diskfull+0xd8>
    close(fd);
    289e:	20a020ef          	jal	4aa8 <close>
  for(int i = 0; i < nzz; i++){
    28a2:	2485                	addiw	s1,s1,1
    28a4:	fb3499e3          	bne	s1,s3,2856 <diskfull+0x86>
  if(mkdir("diskfulldir") == 0)
    28a8:	00004517          	auipc	a0,0x4
    28ac:	95050513          	addi	a0,a0,-1712 # 61f8 <thread_join+0x1154>
    28b0:	238020ef          	jal	4ae8 <mkdir>
    28b4:	12050063          	beqz	a0,29d4 <diskfull+0x204>
  unlink("diskfulldir");
    28b8:	00004517          	auipc	a0,0x4
    28bc:	94050513          	addi	a0,a0,-1728 # 61f8 <thread_join+0x1154>
    28c0:	210020ef          	jal	4ad0 <unlink>
  for(int i = 0; i < nzz; i++){
    28c4:	4481                	li	s1,0
    name[0] = 'z';
    28c6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    28ca:	08000993          	li	s3,128
    name[0] = 'z';
    28ce:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    28d2:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    28d6:	41f4d71b          	sraiw	a4,s1,0x1f
    28da:	01b7571b          	srliw	a4,a4,0x1b
    28de:	009707bb          	addw	a5,a4,s1
    28e2:	4057d69b          	sraiw	a3,a5,0x5
    28e6:	0306869b          	addiw	a3,a3,48
    28ea:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    28ee:	8bfd                	andi	a5,a5,31
    28f0:	9f99                	subw	a5,a5,a4
    28f2:	0307879b          	addiw	a5,a5,48
    28f6:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    28fa:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    28fe:	ba040513          	addi	a0,s0,-1120
    2902:	1ce020ef          	jal	4ad0 <unlink>
  for(int i = 0; i < nzz; i++){
    2906:	2485                	addiw	s1,s1,1
    2908:	fd3493e3          	bne	s1,s3,28ce <diskfull+0xfe>
    290c:	03000493          	li	s1,48
    name[0] = 'b';
    2910:	06200a93          	li	s5,98
    name[1] = 'i';
    2914:	06900a13          	li	s4,105
    name[2] = 'g';
    2918:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    291c:	07f00913          	li	s2,127
    name[0] = 'b';
    2920:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    2924:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    2928:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    292c:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    2930:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    2934:	ba040513          	addi	a0,s0,-1120
    2938:	198020ef          	jal	4ad0 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    293c:	2485                	addiw	s1,s1,1
    293e:	0ff4f493          	zext.b	s1,s1
    2942:	fd249fe3          	bne	s1,s2,2920 <diskfull+0x150>
}
    2946:	47813083          	ld	ra,1144(sp)
    294a:	47013403          	ld	s0,1136(sp)
    294e:	46813483          	ld	s1,1128(sp)
    2952:	46013903          	ld	s2,1120(sp)
    2956:	45813983          	ld	s3,1112(sp)
    295a:	45013a03          	ld	s4,1104(sp)
    295e:	44813a83          	ld	s5,1096(sp)
    2962:	44013b03          	ld	s6,1088(sp)
    2966:	43813b83          	ld	s7,1080(sp)
    296a:	43013c03          	ld	s8,1072(sp)
    296e:	42813c83          	ld	s9,1064(sp)
    2972:	48010113          	addi	sp,sp,1152
    2976:	8082                	ret
    close(fd);
    2978:	854a                	mv	a0,s2
    297a:	12e020ef          	jal	4aa8 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    297e:	2985                	addiw	s3,s3,1
    2980:	0ff9f993          	zext.b	s3,s3
    2984:	ed8984e3          	beq	s3,s8,284c <diskfull+0x7c>
    name[0] = 'b';
    2988:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    298c:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    2990:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    2994:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    2998:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    299c:	b8040513          	addi	a0,s0,-1152
    29a0:	130020ef          	jal	4ad0 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    29a4:	60200593          	li	a1,1538
    29a8:	b8040513          	addi	a0,s0,-1152
    29ac:	114020ef          	jal	4ac0 <open>
    29b0:	892a                	mv	s2,a0
    if(fd < 0){
    29b2:	e6054de3          	bltz	a0,282c <diskfull+0x5c>
    29b6:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    29b8:	40000613          	li	a2,1024
    29bc:	ba040593          	addi	a1,s0,-1120
    29c0:	854a                	mv	a0,s2
    29c2:	0de020ef          	jal	4aa0 <write>
    29c6:	40000793          	li	a5,1024
    29ca:	e6f51be3          	bne	a0,a5,2840 <diskfull+0x70>
    for(int i = 0; i < MAXFILE; i++){
    29ce:	34fd                	addiw	s1,s1,-1
    29d0:	f4e5                	bnez	s1,29b8 <diskfull+0x1e8>
    29d2:	b75d                	j	2978 <diskfull+0x1a8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    29d4:	85e6                	mv	a1,s9
    29d6:	00004517          	auipc	a0,0x4
    29da:	85250513          	addi	a0,a0,-1966 # 6228 <thread_join+0x1184>
    29de:	4ca020ef          	jal	4ea8 <printf>
    29e2:	bdd9                	j	28b8 <diskfull+0xe8>

00000000000029e4 <iputtest>:
{
    29e4:	1101                	addi	sp,sp,-32
    29e6:	ec06                	sd	ra,24(sp)
    29e8:	e822                	sd	s0,16(sp)
    29ea:	e426                	sd	s1,8(sp)
    29ec:	1000                	addi	s0,sp,32
    29ee:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    29f0:	00004517          	auipc	a0,0x4
    29f4:	86850513          	addi	a0,a0,-1944 # 6258 <thread_join+0x11b4>
    29f8:	0f0020ef          	jal	4ae8 <mkdir>
    29fc:	02054f63          	bltz	a0,2a3a <iputtest+0x56>
  if(chdir("iputdir") < 0){
    2a00:	00004517          	auipc	a0,0x4
    2a04:	85850513          	addi	a0,a0,-1960 # 6258 <thread_join+0x11b4>
    2a08:	0e8020ef          	jal	4af0 <chdir>
    2a0c:	04054163          	bltz	a0,2a4e <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    2a10:	00004517          	auipc	a0,0x4
    2a14:	88850513          	addi	a0,a0,-1912 # 6298 <thread_join+0x11f4>
    2a18:	0b8020ef          	jal	4ad0 <unlink>
    2a1c:	04054363          	bltz	a0,2a62 <iputtest+0x7e>
  if(chdir("/") < 0){
    2a20:	00004517          	auipc	a0,0x4
    2a24:	8a850513          	addi	a0,a0,-1880 # 62c8 <thread_join+0x1224>
    2a28:	0c8020ef          	jal	4af0 <chdir>
    2a2c:	04054563          	bltz	a0,2a76 <iputtest+0x92>
}
    2a30:	60e2                	ld	ra,24(sp)
    2a32:	6442                	ld	s0,16(sp)
    2a34:	64a2                	ld	s1,8(sp)
    2a36:	6105                	addi	sp,sp,32
    2a38:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2a3a:	85a6                	mv	a1,s1
    2a3c:	00004517          	auipc	a0,0x4
    2a40:	82450513          	addi	a0,a0,-2012 # 6260 <thread_join+0x11bc>
    2a44:	464020ef          	jal	4ea8 <printf>
    exit(1);
    2a48:	4505                	li	a0,1
    2a4a:	036020ef          	jal	4a80 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2a4e:	85a6                	mv	a1,s1
    2a50:	00004517          	auipc	a0,0x4
    2a54:	82850513          	addi	a0,a0,-2008 # 6278 <thread_join+0x11d4>
    2a58:	450020ef          	jal	4ea8 <printf>
    exit(1);
    2a5c:	4505                	li	a0,1
    2a5e:	022020ef          	jal	4a80 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a62:	85a6                	mv	a1,s1
    2a64:	00004517          	auipc	a0,0x4
    2a68:	84450513          	addi	a0,a0,-1980 # 62a8 <thread_join+0x1204>
    2a6c:	43c020ef          	jal	4ea8 <printf>
    exit(1);
    2a70:	4505                	li	a0,1
    2a72:	00e020ef          	jal	4a80 <exit>
    printf("%s: chdir / failed\n", s);
    2a76:	85a6                	mv	a1,s1
    2a78:	00004517          	auipc	a0,0x4
    2a7c:	85850513          	addi	a0,a0,-1960 # 62d0 <thread_join+0x122c>
    2a80:	428020ef          	jal	4ea8 <printf>
    exit(1);
    2a84:	4505                	li	a0,1
    2a86:	7fb010ef          	jal	4a80 <exit>

0000000000002a8a <exitiputtest>:
{
    2a8a:	7179                	addi	sp,sp,-48
    2a8c:	f406                	sd	ra,40(sp)
    2a8e:	f022                	sd	s0,32(sp)
    2a90:	ec26                	sd	s1,24(sp)
    2a92:	1800                	addi	s0,sp,48
    2a94:	84aa                	mv	s1,a0
  pid = fork();
    2a96:	7e3010ef          	jal	4a78 <fork>
  if(pid < 0){
    2a9a:	02054e63          	bltz	a0,2ad6 <exitiputtest+0x4c>
  if(pid == 0){
    2a9e:	e541                	bnez	a0,2b26 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2aa0:	00003517          	auipc	a0,0x3
    2aa4:	7b850513          	addi	a0,a0,1976 # 6258 <thread_join+0x11b4>
    2aa8:	040020ef          	jal	4ae8 <mkdir>
    2aac:	02054f63          	bltz	a0,2aea <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2ab0:	00003517          	auipc	a0,0x3
    2ab4:	7a850513          	addi	a0,a0,1960 # 6258 <thread_join+0x11b4>
    2ab8:	038020ef          	jal	4af0 <chdir>
    2abc:	04054163          	bltz	a0,2afe <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2ac0:	00003517          	auipc	a0,0x3
    2ac4:	7d850513          	addi	a0,a0,2008 # 6298 <thread_join+0x11f4>
    2ac8:	008020ef          	jal	4ad0 <unlink>
    2acc:	04054363          	bltz	a0,2b12 <exitiputtest+0x88>
    exit(0);
    2ad0:	4501                	li	a0,0
    2ad2:	7af010ef          	jal	4a80 <exit>
    printf("%s: fork failed\n", s);
    2ad6:	85a6                	mv	a1,s1
    2ad8:	00003517          	auipc	a0,0x3
    2adc:	ed050513          	addi	a0,a0,-304 # 59a8 <thread_join+0x904>
    2ae0:	3c8020ef          	jal	4ea8 <printf>
    exit(1);
    2ae4:	4505                	li	a0,1
    2ae6:	79b010ef          	jal	4a80 <exit>
      printf("%s: mkdir failed\n", s);
    2aea:	85a6                	mv	a1,s1
    2aec:	00003517          	auipc	a0,0x3
    2af0:	77450513          	addi	a0,a0,1908 # 6260 <thread_join+0x11bc>
    2af4:	3b4020ef          	jal	4ea8 <printf>
      exit(1);
    2af8:	4505                	li	a0,1
    2afa:	787010ef          	jal	4a80 <exit>
      printf("%s: child chdir failed\n", s);
    2afe:	85a6                	mv	a1,s1
    2b00:	00003517          	auipc	a0,0x3
    2b04:	7e850513          	addi	a0,a0,2024 # 62e8 <thread_join+0x1244>
    2b08:	3a0020ef          	jal	4ea8 <printf>
      exit(1);
    2b0c:	4505                	li	a0,1
    2b0e:	773010ef          	jal	4a80 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2b12:	85a6                	mv	a1,s1
    2b14:	00003517          	auipc	a0,0x3
    2b18:	79450513          	addi	a0,a0,1940 # 62a8 <thread_join+0x1204>
    2b1c:	38c020ef          	jal	4ea8 <printf>
      exit(1);
    2b20:	4505                	li	a0,1
    2b22:	75f010ef          	jal	4a80 <exit>
  wait(&xstatus);
    2b26:	fdc40513          	addi	a0,s0,-36
    2b2a:	75f010ef          	jal	4a88 <wait>
  exit(xstatus);
    2b2e:	fdc42503          	lw	a0,-36(s0)
    2b32:	74f010ef          	jal	4a80 <exit>

0000000000002b36 <dirtest>:
{
    2b36:	1101                	addi	sp,sp,-32
    2b38:	ec06                	sd	ra,24(sp)
    2b3a:	e822                	sd	s0,16(sp)
    2b3c:	e426                	sd	s1,8(sp)
    2b3e:	1000                	addi	s0,sp,32
    2b40:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2b42:	00003517          	auipc	a0,0x3
    2b46:	7be50513          	addi	a0,a0,1982 # 6300 <thread_join+0x125c>
    2b4a:	79f010ef          	jal	4ae8 <mkdir>
    2b4e:	02054f63          	bltz	a0,2b8c <dirtest+0x56>
  if(chdir("dir0") < 0){
    2b52:	00003517          	auipc	a0,0x3
    2b56:	7ae50513          	addi	a0,a0,1966 # 6300 <thread_join+0x125c>
    2b5a:	797010ef          	jal	4af0 <chdir>
    2b5e:	04054163          	bltz	a0,2ba0 <dirtest+0x6a>
  if(chdir("..") < 0){
    2b62:	00003517          	auipc	a0,0x3
    2b66:	7be50513          	addi	a0,a0,1982 # 6320 <thread_join+0x127c>
    2b6a:	787010ef          	jal	4af0 <chdir>
    2b6e:	04054363          	bltz	a0,2bb4 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2b72:	00003517          	auipc	a0,0x3
    2b76:	78e50513          	addi	a0,a0,1934 # 6300 <thread_join+0x125c>
    2b7a:	757010ef          	jal	4ad0 <unlink>
    2b7e:	04054563          	bltz	a0,2bc8 <dirtest+0x92>
}
    2b82:	60e2                	ld	ra,24(sp)
    2b84:	6442                	ld	s0,16(sp)
    2b86:	64a2                	ld	s1,8(sp)
    2b88:	6105                	addi	sp,sp,32
    2b8a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b8c:	85a6                	mv	a1,s1
    2b8e:	00003517          	auipc	a0,0x3
    2b92:	6d250513          	addi	a0,a0,1746 # 6260 <thread_join+0x11bc>
    2b96:	312020ef          	jal	4ea8 <printf>
    exit(1);
    2b9a:	4505                	li	a0,1
    2b9c:	6e5010ef          	jal	4a80 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2ba0:	85a6                	mv	a1,s1
    2ba2:	00003517          	auipc	a0,0x3
    2ba6:	76650513          	addi	a0,a0,1894 # 6308 <thread_join+0x1264>
    2baa:	2fe020ef          	jal	4ea8 <printf>
    exit(1);
    2bae:	4505                	li	a0,1
    2bb0:	6d1010ef          	jal	4a80 <exit>
    printf("%s: chdir .. failed\n", s);
    2bb4:	85a6                	mv	a1,s1
    2bb6:	00003517          	auipc	a0,0x3
    2bba:	77250513          	addi	a0,a0,1906 # 6328 <thread_join+0x1284>
    2bbe:	2ea020ef          	jal	4ea8 <printf>
    exit(1);
    2bc2:	4505                	li	a0,1
    2bc4:	6bd010ef          	jal	4a80 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2bc8:	85a6                	mv	a1,s1
    2bca:	00003517          	auipc	a0,0x3
    2bce:	77650513          	addi	a0,a0,1910 # 6340 <thread_join+0x129c>
    2bd2:	2d6020ef          	jal	4ea8 <printf>
    exit(1);
    2bd6:	4505                	li	a0,1
    2bd8:	6a9010ef          	jal	4a80 <exit>

0000000000002bdc <subdir>:
{
    2bdc:	1101                	addi	sp,sp,-32
    2bde:	ec06                	sd	ra,24(sp)
    2be0:	e822                	sd	s0,16(sp)
    2be2:	e426                	sd	s1,8(sp)
    2be4:	e04a                	sd	s2,0(sp)
    2be6:	1000                	addi	s0,sp,32
    2be8:	892a                	mv	s2,a0
  unlink("ff");
    2bea:	00004517          	auipc	a0,0x4
    2bee:	89e50513          	addi	a0,a0,-1890 # 6488 <thread_join+0x13e4>
    2bf2:	6df010ef          	jal	4ad0 <unlink>
  if(mkdir("dd") != 0){
    2bf6:	00003517          	auipc	a0,0x3
    2bfa:	76250513          	addi	a0,a0,1890 # 6358 <thread_join+0x12b4>
    2bfe:	6eb010ef          	jal	4ae8 <mkdir>
    2c02:	2e051263          	bnez	a0,2ee6 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2c06:	20200593          	li	a1,514
    2c0a:	00003517          	auipc	a0,0x3
    2c0e:	76e50513          	addi	a0,a0,1902 # 6378 <thread_join+0x12d4>
    2c12:	6af010ef          	jal	4ac0 <open>
    2c16:	84aa                	mv	s1,a0
  if(fd < 0){
    2c18:	2e054163          	bltz	a0,2efa <subdir+0x31e>
  write(fd, "ff", 2);
    2c1c:	4609                	li	a2,2
    2c1e:	00004597          	auipc	a1,0x4
    2c22:	86a58593          	addi	a1,a1,-1942 # 6488 <thread_join+0x13e4>
    2c26:	67b010ef          	jal	4aa0 <write>
  close(fd);
    2c2a:	8526                	mv	a0,s1
    2c2c:	67d010ef          	jal	4aa8 <close>
  if(unlink("dd") >= 0){
    2c30:	00003517          	auipc	a0,0x3
    2c34:	72850513          	addi	a0,a0,1832 # 6358 <thread_join+0x12b4>
    2c38:	699010ef          	jal	4ad0 <unlink>
    2c3c:	2c055963          	bgez	a0,2f0e <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2c40:	00003517          	auipc	a0,0x3
    2c44:	79050513          	addi	a0,a0,1936 # 63d0 <thread_join+0x132c>
    2c48:	6a1010ef          	jal	4ae8 <mkdir>
    2c4c:	2c051b63          	bnez	a0,2f22 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2c50:	20200593          	li	a1,514
    2c54:	00003517          	auipc	a0,0x3
    2c58:	7a450513          	addi	a0,a0,1956 # 63f8 <thread_join+0x1354>
    2c5c:	665010ef          	jal	4ac0 <open>
    2c60:	84aa                	mv	s1,a0
  if(fd < 0){
    2c62:	2c054a63          	bltz	a0,2f36 <subdir+0x35a>
  write(fd, "FF", 2);
    2c66:	4609                	li	a2,2
    2c68:	00003597          	auipc	a1,0x3
    2c6c:	7c058593          	addi	a1,a1,1984 # 6428 <thread_join+0x1384>
    2c70:	631010ef          	jal	4aa0 <write>
  close(fd);
    2c74:	8526                	mv	a0,s1
    2c76:	633010ef          	jal	4aa8 <close>
  fd = open("dd/dd/../ff", 0);
    2c7a:	4581                	li	a1,0
    2c7c:	00003517          	auipc	a0,0x3
    2c80:	7b450513          	addi	a0,a0,1972 # 6430 <thread_join+0x138c>
    2c84:	63d010ef          	jal	4ac0 <open>
    2c88:	84aa                	mv	s1,a0
  if(fd < 0){
    2c8a:	2c054063          	bltz	a0,2f4a <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c8e:	660d                	lui	a2,0x3
    2c90:	0000a597          	auipc	a1,0xa
    2c94:	fe858593          	addi	a1,a1,-24 # cc78 <buf>
    2c98:	601010ef          	jal	4a98 <read>
  if(cc != 2 || buf[0] != 'f'){
    2c9c:	4789                	li	a5,2
    2c9e:	2cf51063          	bne	a0,a5,2f5e <subdir+0x382>
    2ca2:	0000a717          	auipc	a4,0xa
    2ca6:	fd674703          	lbu	a4,-42(a4) # cc78 <buf>
    2caa:	06600793          	li	a5,102
    2cae:	2af71863          	bne	a4,a5,2f5e <subdir+0x382>
  close(fd);
    2cb2:	8526                	mv	a0,s1
    2cb4:	5f5010ef          	jal	4aa8 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2cb8:	00003597          	auipc	a1,0x3
    2cbc:	7c858593          	addi	a1,a1,1992 # 6480 <thread_join+0x13dc>
    2cc0:	00003517          	auipc	a0,0x3
    2cc4:	73850513          	addi	a0,a0,1848 # 63f8 <thread_join+0x1354>
    2cc8:	619010ef          	jal	4ae0 <link>
    2ccc:	2a051363          	bnez	a0,2f72 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2cd0:	00003517          	auipc	a0,0x3
    2cd4:	72850513          	addi	a0,a0,1832 # 63f8 <thread_join+0x1354>
    2cd8:	5f9010ef          	jal	4ad0 <unlink>
    2cdc:	2a051563          	bnez	a0,2f86 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2ce0:	4581                	li	a1,0
    2ce2:	00003517          	auipc	a0,0x3
    2ce6:	71650513          	addi	a0,a0,1814 # 63f8 <thread_join+0x1354>
    2cea:	5d7010ef          	jal	4ac0 <open>
    2cee:	2a055663          	bgez	a0,2f9a <subdir+0x3be>
  if(chdir("dd") != 0){
    2cf2:	00003517          	auipc	a0,0x3
    2cf6:	66650513          	addi	a0,a0,1638 # 6358 <thread_join+0x12b4>
    2cfa:	5f7010ef          	jal	4af0 <chdir>
    2cfe:	2a051863          	bnez	a0,2fae <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2d02:	00004517          	auipc	a0,0x4
    2d06:	81650513          	addi	a0,a0,-2026 # 6518 <thread_join+0x1474>
    2d0a:	5e7010ef          	jal	4af0 <chdir>
    2d0e:	2a051a63          	bnez	a0,2fc2 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2d12:	00004517          	auipc	a0,0x4
    2d16:	83650513          	addi	a0,a0,-1994 # 6548 <thread_join+0x14a4>
    2d1a:	5d7010ef          	jal	4af0 <chdir>
    2d1e:	2a051c63          	bnez	a0,2fd6 <subdir+0x3fa>
  if(chdir("./..") != 0){
    2d22:	00004517          	auipc	a0,0x4
    2d26:	85e50513          	addi	a0,a0,-1954 # 6580 <thread_join+0x14dc>
    2d2a:	5c7010ef          	jal	4af0 <chdir>
    2d2e:	2a051e63          	bnez	a0,2fea <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2d32:	4581                	li	a1,0
    2d34:	00003517          	auipc	a0,0x3
    2d38:	74c50513          	addi	a0,a0,1868 # 6480 <thread_join+0x13dc>
    2d3c:	585010ef          	jal	4ac0 <open>
    2d40:	84aa                	mv	s1,a0
  if(fd < 0){
    2d42:	2a054e63          	bltz	a0,2ffe <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2d46:	660d                	lui	a2,0x3
    2d48:	0000a597          	auipc	a1,0xa
    2d4c:	f3058593          	addi	a1,a1,-208 # cc78 <buf>
    2d50:	549010ef          	jal	4a98 <read>
    2d54:	4789                	li	a5,2
    2d56:	2af51e63          	bne	a0,a5,3012 <subdir+0x436>
  close(fd);
    2d5a:	8526                	mv	a0,s1
    2d5c:	54d010ef          	jal	4aa8 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2d60:	4581                	li	a1,0
    2d62:	00003517          	auipc	a0,0x3
    2d66:	69650513          	addi	a0,a0,1686 # 63f8 <thread_join+0x1354>
    2d6a:	557010ef          	jal	4ac0 <open>
    2d6e:	2a055c63          	bgez	a0,3026 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2d72:	20200593          	li	a1,514
    2d76:	00004517          	auipc	a0,0x4
    2d7a:	89a50513          	addi	a0,a0,-1894 # 6610 <thread_join+0x156c>
    2d7e:	543010ef          	jal	4ac0 <open>
    2d82:	2a055c63          	bgez	a0,303a <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2d86:	20200593          	li	a1,514
    2d8a:	00004517          	auipc	a0,0x4
    2d8e:	8b650513          	addi	a0,a0,-1866 # 6640 <thread_join+0x159c>
    2d92:	52f010ef          	jal	4ac0 <open>
    2d96:	2a055c63          	bgez	a0,304e <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2d9a:	20000593          	li	a1,512
    2d9e:	00003517          	auipc	a0,0x3
    2da2:	5ba50513          	addi	a0,a0,1466 # 6358 <thread_join+0x12b4>
    2da6:	51b010ef          	jal	4ac0 <open>
    2daa:	2a055c63          	bgez	a0,3062 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2dae:	4589                	li	a1,2
    2db0:	00003517          	auipc	a0,0x3
    2db4:	5a850513          	addi	a0,a0,1448 # 6358 <thread_join+0x12b4>
    2db8:	509010ef          	jal	4ac0 <open>
    2dbc:	2a055d63          	bgez	a0,3076 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2dc0:	4585                	li	a1,1
    2dc2:	00003517          	auipc	a0,0x3
    2dc6:	59650513          	addi	a0,a0,1430 # 6358 <thread_join+0x12b4>
    2dca:	4f7010ef          	jal	4ac0 <open>
    2dce:	2a055e63          	bgez	a0,308a <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2dd2:	00004597          	auipc	a1,0x4
    2dd6:	8fe58593          	addi	a1,a1,-1794 # 66d0 <thread_join+0x162c>
    2dda:	00004517          	auipc	a0,0x4
    2dde:	83650513          	addi	a0,a0,-1994 # 6610 <thread_join+0x156c>
    2de2:	4ff010ef          	jal	4ae0 <link>
    2de6:	2a050c63          	beqz	a0,309e <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2dea:	00004597          	auipc	a1,0x4
    2dee:	8e658593          	addi	a1,a1,-1818 # 66d0 <thread_join+0x162c>
    2df2:	00004517          	auipc	a0,0x4
    2df6:	84e50513          	addi	a0,a0,-1970 # 6640 <thread_join+0x159c>
    2dfa:	4e7010ef          	jal	4ae0 <link>
    2dfe:	2a050a63          	beqz	a0,30b2 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2e02:	00003597          	auipc	a1,0x3
    2e06:	67e58593          	addi	a1,a1,1662 # 6480 <thread_join+0x13dc>
    2e0a:	00003517          	auipc	a0,0x3
    2e0e:	56e50513          	addi	a0,a0,1390 # 6378 <thread_join+0x12d4>
    2e12:	4cf010ef          	jal	4ae0 <link>
    2e16:	2a050863          	beqz	a0,30c6 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2e1a:	00003517          	auipc	a0,0x3
    2e1e:	7f650513          	addi	a0,a0,2038 # 6610 <thread_join+0x156c>
    2e22:	4c7010ef          	jal	4ae8 <mkdir>
    2e26:	2a050a63          	beqz	a0,30da <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2e2a:	00004517          	auipc	a0,0x4
    2e2e:	81650513          	addi	a0,a0,-2026 # 6640 <thread_join+0x159c>
    2e32:	4b7010ef          	jal	4ae8 <mkdir>
    2e36:	2a050c63          	beqz	a0,30ee <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2e3a:	00003517          	auipc	a0,0x3
    2e3e:	64650513          	addi	a0,a0,1606 # 6480 <thread_join+0x13dc>
    2e42:	4a7010ef          	jal	4ae8 <mkdir>
    2e46:	2a050e63          	beqz	a0,3102 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2e4a:	00003517          	auipc	a0,0x3
    2e4e:	7f650513          	addi	a0,a0,2038 # 6640 <thread_join+0x159c>
    2e52:	47f010ef          	jal	4ad0 <unlink>
    2e56:	2c050063          	beqz	a0,3116 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2e5a:	00003517          	auipc	a0,0x3
    2e5e:	7b650513          	addi	a0,a0,1974 # 6610 <thread_join+0x156c>
    2e62:	46f010ef          	jal	4ad0 <unlink>
    2e66:	2c050263          	beqz	a0,312a <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2e6a:	00003517          	auipc	a0,0x3
    2e6e:	50e50513          	addi	a0,a0,1294 # 6378 <thread_join+0x12d4>
    2e72:	47f010ef          	jal	4af0 <chdir>
    2e76:	2c050463          	beqz	a0,313e <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2e7a:	00004517          	auipc	a0,0x4
    2e7e:	9a650513          	addi	a0,a0,-1626 # 6820 <thread_join+0x177c>
    2e82:	46f010ef          	jal	4af0 <chdir>
    2e86:	2c050663          	beqz	a0,3152 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2e8a:	00003517          	auipc	a0,0x3
    2e8e:	5f650513          	addi	a0,a0,1526 # 6480 <thread_join+0x13dc>
    2e92:	43f010ef          	jal	4ad0 <unlink>
    2e96:	2c051863          	bnez	a0,3166 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2e9a:	00003517          	auipc	a0,0x3
    2e9e:	4de50513          	addi	a0,a0,1246 # 6378 <thread_join+0x12d4>
    2ea2:	42f010ef          	jal	4ad0 <unlink>
    2ea6:	2c051a63          	bnez	a0,317a <subdir+0x59e>
  if(unlink("dd") == 0){
    2eaa:	00003517          	auipc	a0,0x3
    2eae:	4ae50513          	addi	a0,a0,1198 # 6358 <thread_join+0x12b4>
    2eb2:	41f010ef          	jal	4ad0 <unlink>
    2eb6:	2c050c63          	beqz	a0,318e <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2eba:	00004517          	auipc	a0,0x4
    2ebe:	9d650513          	addi	a0,a0,-1578 # 6890 <thread_join+0x17ec>
    2ec2:	40f010ef          	jal	4ad0 <unlink>
    2ec6:	2c054e63          	bltz	a0,31a2 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2eca:	00003517          	auipc	a0,0x3
    2ece:	48e50513          	addi	a0,a0,1166 # 6358 <thread_join+0x12b4>
    2ed2:	3ff010ef          	jal	4ad0 <unlink>
    2ed6:	2e054063          	bltz	a0,31b6 <subdir+0x5da>
}
    2eda:	60e2                	ld	ra,24(sp)
    2edc:	6442                	ld	s0,16(sp)
    2ede:	64a2                	ld	s1,8(sp)
    2ee0:	6902                	ld	s2,0(sp)
    2ee2:	6105                	addi	sp,sp,32
    2ee4:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2ee6:	85ca                	mv	a1,s2
    2ee8:	00003517          	auipc	a0,0x3
    2eec:	47850513          	addi	a0,a0,1144 # 6360 <thread_join+0x12bc>
    2ef0:	7b9010ef          	jal	4ea8 <printf>
    exit(1);
    2ef4:	4505                	li	a0,1
    2ef6:	38b010ef          	jal	4a80 <exit>
    printf("%s: create dd/ff failed\n", s);
    2efa:	85ca                	mv	a1,s2
    2efc:	00003517          	auipc	a0,0x3
    2f00:	48450513          	addi	a0,a0,1156 # 6380 <thread_join+0x12dc>
    2f04:	7a5010ef          	jal	4ea8 <printf>
    exit(1);
    2f08:	4505                	li	a0,1
    2f0a:	377010ef          	jal	4a80 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2f0e:	85ca                	mv	a1,s2
    2f10:	00003517          	auipc	a0,0x3
    2f14:	49050513          	addi	a0,a0,1168 # 63a0 <thread_join+0x12fc>
    2f18:	791010ef          	jal	4ea8 <printf>
    exit(1);
    2f1c:	4505                	li	a0,1
    2f1e:	363010ef          	jal	4a80 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2f22:	85ca                	mv	a1,s2
    2f24:	00003517          	auipc	a0,0x3
    2f28:	4b450513          	addi	a0,a0,1204 # 63d8 <thread_join+0x1334>
    2f2c:	77d010ef          	jal	4ea8 <printf>
    exit(1);
    2f30:	4505                	li	a0,1
    2f32:	34f010ef          	jal	4a80 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2f36:	85ca                	mv	a1,s2
    2f38:	00003517          	auipc	a0,0x3
    2f3c:	4d050513          	addi	a0,a0,1232 # 6408 <thread_join+0x1364>
    2f40:	769010ef          	jal	4ea8 <printf>
    exit(1);
    2f44:	4505                	li	a0,1
    2f46:	33b010ef          	jal	4a80 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2f4a:	85ca                	mv	a1,s2
    2f4c:	00003517          	auipc	a0,0x3
    2f50:	4f450513          	addi	a0,a0,1268 # 6440 <thread_join+0x139c>
    2f54:	755010ef          	jal	4ea8 <printf>
    exit(1);
    2f58:	4505                	li	a0,1
    2f5a:	327010ef          	jal	4a80 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f5e:	85ca                	mv	a1,s2
    2f60:	00003517          	auipc	a0,0x3
    2f64:	50050513          	addi	a0,a0,1280 # 6460 <thread_join+0x13bc>
    2f68:	741010ef          	jal	4ea8 <printf>
    exit(1);
    2f6c:	4505                	li	a0,1
    2f6e:	313010ef          	jal	4a80 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f72:	85ca                	mv	a1,s2
    2f74:	00003517          	auipc	a0,0x3
    2f78:	51c50513          	addi	a0,a0,1308 # 6490 <thread_join+0x13ec>
    2f7c:	72d010ef          	jal	4ea8 <printf>
    exit(1);
    2f80:	4505                	li	a0,1
    2f82:	2ff010ef          	jal	4a80 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f86:	85ca                	mv	a1,s2
    2f88:	00003517          	auipc	a0,0x3
    2f8c:	53050513          	addi	a0,a0,1328 # 64b8 <thread_join+0x1414>
    2f90:	719010ef          	jal	4ea8 <printf>
    exit(1);
    2f94:	4505                	li	a0,1
    2f96:	2eb010ef          	jal	4a80 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f9a:	85ca                	mv	a1,s2
    2f9c:	00003517          	auipc	a0,0x3
    2fa0:	53c50513          	addi	a0,a0,1340 # 64d8 <thread_join+0x1434>
    2fa4:	705010ef          	jal	4ea8 <printf>
    exit(1);
    2fa8:	4505                	li	a0,1
    2faa:	2d7010ef          	jal	4a80 <exit>
    printf("%s: chdir dd failed\n", s);
    2fae:	85ca                	mv	a1,s2
    2fb0:	00003517          	auipc	a0,0x3
    2fb4:	55050513          	addi	a0,a0,1360 # 6500 <thread_join+0x145c>
    2fb8:	6f1010ef          	jal	4ea8 <printf>
    exit(1);
    2fbc:	4505                	li	a0,1
    2fbe:	2c3010ef          	jal	4a80 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2fc2:	85ca                	mv	a1,s2
    2fc4:	00003517          	auipc	a0,0x3
    2fc8:	56450513          	addi	a0,a0,1380 # 6528 <thread_join+0x1484>
    2fcc:	6dd010ef          	jal	4ea8 <printf>
    exit(1);
    2fd0:	4505                	li	a0,1
    2fd2:	2af010ef          	jal	4a80 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2fd6:	85ca                	mv	a1,s2
    2fd8:	00003517          	auipc	a0,0x3
    2fdc:	58050513          	addi	a0,a0,1408 # 6558 <thread_join+0x14b4>
    2fe0:	6c9010ef          	jal	4ea8 <printf>
    exit(1);
    2fe4:	4505                	li	a0,1
    2fe6:	29b010ef          	jal	4a80 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2fea:	85ca                	mv	a1,s2
    2fec:	00003517          	auipc	a0,0x3
    2ff0:	59c50513          	addi	a0,a0,1436 # 6588 <thread_join+0x14e4>
    2ff4:	6b5010ef          	jal	4ea8 <printf>
    exit(1);
    2ff8:	4505                	li	a0,1
    2ffa:	287010ef          	jal	4a80 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2ffe:	85ca                	mv	a1,s2
    3000:	00003517          	auipc	a0,0x3
    3004:	5a050513          	addi	a0,a0,1440 # 65a0 <thread_join+0x14fc>
    3008:	6a1010ef          	jal	4ea8 <printf>
    exit(1);
    300c:	4505                	li	a0,1
    300e:	273010ef          	jal	4a80 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3012:	85ca                	mv	a1,s2
    3014:	00003517          	auipc	a0,0x3
    3018:	5ac50513          	addi	a0,a0,1452 # 65c0 <thread_join+0x151c>
    301c:	68d010ef          	jal	4ea8 <printf>
    exit(1);
    3020:	4505                	li	a0,1
    3022:	25f010ef          	jal	4a80 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3026:	85ca                	mv	a1,s2
    3028:	00003517          	auipc	a0,0x3
    302c:	5b850513          	addi	a0,a0,1464 # 65e0 <thread_join+0x153c>
    3030:	679010ef          	jal	4ea8 <printf>
    exit(1);
    3034:	4505                	li	a0,1
    3036:	24b010ef          	jal	4a80 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    303a:	85ca                	mv	a1,s2
    303c:	00003517          	auipc	a0,0x3
    3040:	5e450513          	addi	a0,a0,1508 # 6620 <thread_join+0x157c>
    3044:	665010ef          	jal	4ea8 <printf>
    exit(1);
    3048:	4505                	li	a0,1
    304a:	237010ef          	jal	4a80 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    304e:	85ca                	mv	a1,s2
    3050:	00003517          	auipc	a0,0x3
    3054:	60050513          	addi	a0,a0,1536 # 6650 <thread_join+0x15ac>
    3058:	651010ef          	jal	4ea8 <printf>
    exit(1);
    305c:	4505                	li	a0,1
    305e:	223010ef          	jal	4a80 <exit>
    printf("%s: create dd succeeded!\n", s);
    3062:	85ca                	mv	a1,s2
    3064:	00003517          	auipc	a0,0x3
    3068:	60c50513          	addi	a0,a0,1548 # 6670 <thread_join+0x15cc>
    306c:	63d010ef          	jal	4ea8 <printf>
    exit(1);
    3070:	4505                	li	a0,1
    3072:	20f010ef          	jal	4a80 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3076:	85ca                	mv	a1,s2
    3078:	00003517          	auipc	a0,0x3
    307c:	61850513          	addi	a0,a0,1560 # 6690 <thread_join+0x15ec>
    3080:	629010ef          	jal	4ea8 <printf>
    exit(1);
    3084:	4505                	li	a0,1
    3086:	1fb010ef          	jal	4a80 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    308a:	85ca                	mv	a1,s2
    308c:	00003517          	auipc	a0,0x3
    3090:	62450513          	addi	a0,a0,1572 # 66b0 <thread_join+0x160c>
    3094:	615010ef          	jal	4ea8 <printf>
    exit(1);
    3098:	4505                	li	a0,1
    309a:	1e7010ef          	jal	4a80 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    309e:	85ca                	mv	a1,s2
    30a0:	00003517          	auipc	a0,0x3
    30a4:	64050513          	addi	a0,a0,1600 # 66e0 <thread_join+0x163c>
    30a8:	601010ef          	jal	4ea8 <printf>
    exit(1);
    30ac:	4505                	li	a0,1
    30ae:	1d3010ef          	jal	4a80 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    30b2:	85ca                	mv	a1,s2
    30b4:	00003517          	auipc	a0,0x3
    30b8:	65450513          	addi	a0,a0,1620 # 6708 <thread_join+0x1664>
    30bc:	5ed010ef          	jal	4ea8 <printf>
    exit(1);
    30c0:	4505                	li	a0,1
    30c2:	1bf010ef          	jal	4a80 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    30c6:	85ca                	mv	a1,s2
    30c8:	00003517          	auipc	a0,0x3
    30cc:	66850513          	addi	a0,a0,1640 # 6730 <thread_join+0x168c>
    30d0:	5d9010ef          	jal	4ea8 <printf>
    exit(1);
    30d4:	4505                	li	a0,1
    30d6:	1ab010ef          	jal	4a80 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    30da:	85ca                	mv	a1,s2
    30dc:	00003517          	auipc	a0,0x3
    30e0:	67c50513          	addi	a0,a0,1660 # 6758 <thread_join+0x16b4>
    30e4:	5c5010ef          	jal	4ea8 <printf>
    exit(1);
    30e8:	4505                	li	a0,1
    30ea:	197010ef          	jal	4a80 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    30ee:	85ca                	mv	a1,s2
    30f0:	00003517          	auipc	a0,0x3
    30f4:	68850513          	addi	a0,a0,1672 # 6778 <thread_join+0x16d4>
    30f8:	5b1010ef          	jal	4ea8 <printf>
    exit(1);
    30fc:	4505                	li	a0,1
    30fe:	183010ef          	jal	4a80 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3102:	85ca                	mv	a1,s2
    3104:	00003517          	auipc	a0,0x3
    3108:	69450513          	addi	a0,a0,1684 # 6798 <thread_join+0x16f4>
    310c:	59d010ef          	jal	4ea8 <printf>
    exit(1);
    3110:	4505                	li	a0,1
    3112:	16f010ef          	jal	4a80 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3116:	85ca                	mv	a1,s2
    3118:	00003517          	auipc	a0,0x3
    311c:	6a850513          	addi	a0,a0,1704 # 67c0 <thread_join+0x171c>
    3120:	589010ef          	jal	4ea8 <printf>
    exit(1);
    3124:	4505                	li	a0,1
    3126:	15b010ef          	jal	4a80 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    312a:	85ca                	mv	a1,s2
    312c:	00003517          	auipc	a0,0x3
    3130:	6b450513          	addi	a0,a0,1716 # 67e0 <thread_join+0x173c>
    3134:	575010ef          	jal	4ea8 <printf>
    exit(1);
    3138:	4505                	li	a0,1
    313a:	147010ef          	jal	4a80 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    313e:	85ca                	mv	a1,s2
    3140:	00003517          	auipc	a0,0x3
    3144:	6c050513          	addi	a0,a0,1728 # 6800 <thread_join+0x175c>
    3148:	561010ef          	jal	4ea8 <printf>
    exit(1);
    314c:	4505                	li	a0,1
    314e:	133010ef          	jal	4a80 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3152:	85ca                	mv	a1,s2
    3154:	00003517          	auipc	a0,0x3
    3158:	6d450513          	addi	a0,a0,1748 # 6828 <thread_join+0x1784>
    315c:	54d010ef          	jal	4ea8 <printf>
    exit(1);
    3160:	4505                	li	a0,1
    3162:	11f010ef          	jal	4a80 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3166:	85ca                	mv	a1,s2
    3168:	00003517          	auipc	a0,0x3
    316c:	35050513          	addi	a0,a0,848 # 64b8 <thread_join+0x1414>
    3170:	539010ef          	jal	4ea8 <printf>
    exit(1);
    3174:	4505                	li	a0,1
    3176:	10b010ef          	jal	4a80 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    317a:	85ca                	mv	a1,s2
    317c:	00003517          	auipc	a0,0x3
    3180:	6cc50513          	addi	a0,a0,1740 # 6848 <thread_join+0x17a4>
    3184:	525010ef          	jal	4ea8 <printf>
    exit(1);
    3188:	4505                	li	a0,1
    318a:	0f7010ef          	jal	4a80 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    318e:	85ca                	mv	a1,s2
    3190:	00003517          	auipc	a0,0x3
    3194:	6d850513          	addi	a0,a0,1752 # 6868 <thread_join+0x17c4>
    3198:	511010ef          	jal	4ea8 <printf>
    exit(1);
    319c:	4505                	li	a0,1
    319e:	0e3010ef          	jal	4a80 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    31a2:	85ca                	mv	a1,s2
    31a4:	00003517          	auipc	a0,0x3
    31a8:	6f450513          	addi	a0,a0,1780 # 6898 <thread_join+0x17f4>
    31ac:	4fd010ef          	jal	4ea8 <printf>
    exit(1);
    31b0:	4505                	li	a0,1
    31b2:	0cf010ef          	jal	4a80 <exit>
    printf("%s: unlink dd failed\n", s);
    31b6:	85ca                	mv	a1,s2
    31b8:	00003517          	auipc	a0,0x3
    31bc:	70050513          	addi	a0,a0,1792 # 68b8 <thread_join+0x1814>
    31c0:	4e9010ef          	jal	4ea8 <printf>
    exit(1);
    31c4:	4505                	li	a0,1
    31c6:	0bb010ef          	jal	4a80 <exit>

00000000000031ca <rmdot>:
{
    31ca:	1101                	addi	sp,sp,-32
    31cc:	ec06                	sd	ra,24(sp)
    31ce:	e822                	sd	s0,16(sp)
    31d0:	e426                	sd	s1,8(sp)
    31d2:	1000                	addi	s0,sp,32
    31d4:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    31d6:	00003517          	auipc	a0,0x3
    31da:	6fa50513          	addi	a0,a0,1786 # 68d0 <thread_join+0x182c>
    31de:	10b010ef          	jal	4ae8 <mkdir>
    31e2:	e53d                	bnez	a0,3250 <rmdot+0x86>
  if(chdir("dots") != 0){
    31e4:	00003517          	auipc	a0,0x3
    31e8:	6ec50513          	addi	a0,a0,1772 # 68d0 <thread_join+0x182c>
    31ec:	105010ef          	jal	4af0 <chdir>
    31f0:	e935                	bnez	a0,3264 <rmdot+0x9a>
  if(unlink(".") == 0){
    31f2:	00002517          	auipc	a0,0x2
    31f6:	60e50513          	addi	a0,a0,1550 # 5800 <thread_join+0x75c>
    31fa:	0d7010ef          	jal	4ad0 <unlink>
    31fe:	cd2d                	beqz	a0,3278 <rmdot+0xae>
  if(unlink("..") == 0){
    3200:	00003517          	auipc	a0,0x3
    3204:	12050513          	addi	a0,a0,288 # 6320 <thread_join+0x127c>
    3208:	0c9010ef          	jal	4ad0 <unlink>
    320c:	c141                	beqz	a0,328c <rmdot+0xc2>
  if(chdir("/") != 0){
    320e:	00003517          	auipc	a0,0x3
    3212:	0ba50513          	addi	a0,a0,186 # 62c8 <thread_join+0x1224>
    3216:	0db010ef          	jal	4af0 <chdir>
    321a:	e159                	bnez	a0,32a0 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    321c:	00003517          	auipc	a0,0x3
    3220:	71c50513          	addi	a0,a0,1820 # 6938 <thread_join+0x1894>
    3224:	0ad010ef          	jal	4ad0 <unlink>
    3228:	c551                	beqz	a0,32b4 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    322a:	00003517          	auipc	a0,0x3
    322e:	73650513          	addi	a0,a0,1846 # 6960 <thread_join+0x18bc>
    3232:	09f010ef          	jal	4ad0 <unlink>
    3236:	c949                	beqz	a0,32c8 <rmdot+0xfe>
  if(unlink("dots") != 0){
    3238:	00003517          	auipc	a0,0x3
    323c:	69850513          	addi	a0,a0,1688 # 68d0 <thread_join+0x182c>
    3240:	091010ef          	jal	4ad0 <unlink>
    3244:	ed41                	bnez	a0,32dc <rmdot+0x112>
}
    3246:	60e2                	ld	ra,24(sp)
    3248:	6442                	ld	s0,16(sp)
    324a:	64a2                	ld	s1,8(sp)
    324c:	6105                	addi	sp,sp,32
    324e:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3250:	85a6                	mv	a1,s1
    3252:	00003517          	auipc	a0,0x3
    3256:	68650513          	addi	a0,a0,1670 # 68d8 <thread_join+0x1834>
    325a:	44f010ef          	jal	4ea8 <printf>
    exit(1);
    325e:	4505                	li	a0,1
    3260:	021010ef          	jal	4a80 <exit>
    printf("%s: chdir dots failed\n", s);
    3264:	85a6                	mv	a1,s1
    3266:	00003517          	auipc	a0,0x3
    326a:	68a50513          	addi	a0,a0,1674 # 68f0 <thread_join+0x184c>
    326e:	43b010ef          	jal	4ea8 <printf>
    exit(1);
    3272:	4505                	li	a0,1
    3274:	00d010ef          	jal	4a80 <exit>
    printf("%s: rm . worked!\n", s);
    3278:	85a6                	mv	a1,s1
    327a:	00003517          	auipc	a0,0x3
    327e:	68e50513          	addi	a0,a0,1678 # 6908 <thread_join+0x1864>
    3282:	427010ef          	jal	4ea8 <printf>
    exit(1);
    3286:	4505                	li	a0,1
    3288:	7f8010ef          	jal	4a80 <exit>
    printf("%s: rm .. worked!\n", s);
    328c:	85a6                	mv	a1,s1
    328e:	00003517          	auipc	a0,0x3
    3292:	69250513          	addi	a0,a0,1682 # 6920 <thread_join+0x187c>
    3296:	413010ef          	jal	4ea8 <printf>
    exit(1);
    329a:	4505                	li	a0,1
    329c:	7e4010ef          	jal	4a80 <exit>
    printf("%s: chdir / failed\n", s);
    32a0:	85a6                	mv	a1,s1
    32a2:	00003517          	auipc	a0,0x3
    32a6:	02e50513          	addi	a0,a0,46 # 62d0 <thread_join+0x122c>
    32aa:	3ff010ef          	jal	4ea8 <printf>
    exit(1);
    32ae:	4505                	li	a0,1
    32b0:	7d0010ef          	jal	4a80 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    32b4:	85a6                	mv	a1,s1
    32b6:	00003517          	auipc	a0,0x3
    32ba:	68a50513          	addi	a0,a0,1674 # 6940 <thread_join+0x189c>
    32be:	3eb010ef          	jal	4ea8 <printf>
    exit(1);
    32c2:	4505                	li	a0,1
    32c4:	7bc010ef          	jal	4a80 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    32c8:	85a6                	mv	a1,s1
    32ca:	00003517          	auipc	a0,0x3
    32ce:	69e50513          	addi	a0,a0,1694 # 6968 <thread_join+0x18c4>
    32d2:	3d7010ef          	jal	4ea8 <printf>
    exit(1);
    32d6:	4505                	li	a0,1
    32d8:	7a8010ef          	jal	4a80 <exit>
    printf("%s: unlink dots failed!\n", s);
    32dc:	85a6                	mv	a1,s1
    32de:	00003517          	auipc	a0,0x3
    32e2:	6aa50513          	addi	a0,a0,1706 # 6988 <thread_join+0x18e4>
    32e6:	3c3010ef          	jal	4ea8 <printf>
    exit(1);
    32ea:	4505                	li	a0,1
    32ec:	794010ef          	jal	4a80 <exit>

00000000000032f0 <dirfile>:
{
    32f0:	1101                	addi	sp,sp,-32
    32f2:	ec06                	sd	ra,24(sp)
    32f4:	e822                	sd	s0,16(sp)
    32f6:	e426                	sd	s1,8(sp)
    32f8:	e04a                	sd	s2,0(sp)
    32fa:	1000                	addi	s0,sp,32
    32fc:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32fe:	20000593          	li	a1,512
    3302:	00003517          	auipc	a0,0x3
    3306:	6a650513          	addi	a0,a0,1702 # 69a8 <thread_join+0x1904>
    330a:	7b6010ef          	jal	4ac0 <open>
  if(fd < 0){
    330e:	0c054563          	bltz	a0,33d8 <dirfile+0xe8>
  close(fd);
    3312:	796010ef          	jal	4aa8 <close>
  if(chdir("dirfile") == 0){
    3316:	00003517          	auipc	a0,0x3
    331a:	69250513          	addi	a0,a0,1682 # 69a8 <thread_join+0x1904>
    331e:	7d2010ef          	jal	4af0 <chdir>
    3322:	c569                	beqz	a0,33ec <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    3324:	4581                	li	a1,0
    3326:	00003517          	auipc	a0,0x3
    332a:	6ca50513          	addi	a0,a0,1738 # 69f0 <thread_join+0x194c>
    332e:	792010ef          	jal	4ac0 <open>
  if(fd >= 0){
    3332:	0c055763          	bgez	a0,3400 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    3336:	20000593          	li	a1,512
    333a:	00003517          	auipc	a0,0x3
    333e:	6b650513          	addi	a0,a0,1718 # 69f0 <thread_join+0x194c>
    3342:	77e010ef          	jal	4ac0 <open>
  if(fd >= 0){
    3346:	0c055763          	bgez	a0,3414 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    334a:	00003517          	auipc	a0,0x3
    334e:	6a650513          	addi	a0,a0,1702 # 69f0 <thread_join+0x194c>
    3352:	796010ef          	jal	4ae8 <mkdir>
    3356:	0c050963          	beqz	a0,3428 <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    335a:	00003517          	auipc	a0,0x3
    335e:	69650513          	addi	a0,a0,1686 # 69f0 <thread_join+0x194c>
    3362:	76e010ef          	jal	4ad0 <unlink>
    3366:	0c050b63          	beqz	a0,343c <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    336a:	00003597          	auipc	a1,0x3
    336e:	68658593          	addi	a1,a1,1670 # 69f0 <thread_join+0x194c>
    3372:	00002517          	auipc	a0,0x2
    3376:	f7e50513          	addi	a0,a0,-130 # 52f0 <thread_join+0x24c>
    337a:	766010ef          	jal	4ae0 <link>
    337e:	0c050963          	beqz	a0,3450 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    3382:	00003517          	auipc	a0,0x3
    3386:	62650513          	addi	a0,a0,1574 # 69a8 <thread_join+0x1904>
    338a:	746010ef          	jal	4ad0 <unlink>
    338e:	0c051b63          	bnez	a0,3464 <dirfile+0x174>
  fd = open(".", O_RDWR);
    3392:	4589                	li	a1,2
    3394:	00002517          	auipc	a0,0x2
    3398:	46c50513          	addi	a0,a0,1132 # 5800 <thread_join+0x75c>
    339c:	724010ef          	jal	4ac0 <open>
  if(fd >= 0){
    33a0:	0c055c63          	bgez	a0,3478 <dirfile+0x188>
  fd = open(".", 0);
    33a4:	4581                	li	a1,0
    33a6:	00002517          	auipc	a0,0x2
    33aa:	45a50513          	addi	a0,a0,1114 # 5800 <thread_join+0x75c>
    33ae:	712010ef          	jal	4ac0 <open>
    33b2:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    33b4:	4605                	li	a2,1
    33b6:	00002597          	auipc	a1,0x2
    33ba:	dd258593          	addi	a1,a1,-558 # 5188 <thread_join+0xe4>
    33be:	6e2010ef          	jal	4aa0 <write>
    33c2:	0ca04563          	bgtz	a0,348c <dirfile+0x19c>
  close(fd);
    33c6:	8526                	mv	a0,s1
    33c8:	6e0010ef          	jal	4aa8 <close>
}
    33cc:	60e2                	ld	ra,24(sp)
    33ce:	6442                	ld	s0,16(sp)
    33d0:	64a2                	ld	s1,8(sp)
    33d2:	6902                	ld	s2,0(sp)
    33d4:	6105                	addi	sp,sp,32
    33d6:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    33d8:	85ca                	mv	a1,s2
    33da:	00003517          	auipc	a0,0x3
    33de:	5d650513          	addi	a0,a0,1494 # 69b0 <thread_join+0x190c>
    33e2:	2c7010ef          	jal	4ea8 <printf>
    exit(1);
    33e6:	4505                	li	a0,1
    33e8:	698010ef          	jal	4a80 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    33ec:	85ca                	mv	a1,s2
    33ee:	00003517          	auipc	a0,0x3
    33f2:	5e250513          	addi	a0,a0,1506 # 69d0 <thread_join+0x192c>
    33f6:	2b3010ef          	jal	4ea8 <printf>
    exit(1);
    33fa:	4505                	li	a0,1
    33fc:	684010ef          	jal	4a80 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3400:	85ca                	mv	a1,s2
    3402:	00003517          	auipc	a0,0x3
    3406:	5fe50513          	addi	a0,a0,1534 # 6a00 <thread_join+0x195c>
    340a:	29f010ef          	jal	4ea8 <printf>
    exit(1);
    340e:	4505                	li	a0,1
    3410:	670010ef          	jal	4a80 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3414:	85ca                	mv	a1,s2
    3416:	00003517          	auipc	a0,0x3
    341a:	5ea50513          	addi	a0,a0,1514 # 6a00 <thread_join+0x195c>
    341e:	28b010ef          	jal	4ea8 <printf>
    exit(1);
    3422:	4505                	li	a0,1
    3424:	65c010ef          	jal	4a80 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3428:	85ca                	mv	a1,s2
    342a:	00003517          	auipc	a0,0x3
    342e:	5fe50513          	addi	a0,a0,1534 # 6a28 <thread_join+0x1984>
    3432:	277010ef          	jal	4ea8 <printf>
    exit(1);
    3436:	4505                	li	a0,1
    3438:	648010ef          	jal	4a80 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    343c:	85ca                	mv	a1,s2
    343e:	00003517          	auipc	a0,0x3
    3442:	61250513          	addi	a0,a0,1554 # 6a50 <thread_join+0x19ac>
    3446:	263010ef          	jal	4ea8 <printf>
    exit(1);
    344a:	4505                	li	a0,1
    344c:	634010ef          	jal	4a80 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3450:	85ca                	mv	a1,s2
    3452:	00003517          	auipc	a0,0x3
    3456:	62650513          	addi	a0,a0,1574 # 6a78 <thread_join+0x19d4>
    345a:	24f010ef          	jal	4ea8 <printf>
    exit(1);
    345e:	4505                	li	a0,1
    3460:	620010ef          	jal	4a80 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    3464:	85ca                	mv	a1,s2
    3466:	00003517          	auipc	a0,0x3
    346a:	63a50513          	addi	a0,a0,1594 # 6aa0 <thread_join+0x19fc>
    346e:	23b010ef          	jal	4ea8 <printf>
    exit(1);
    3472:	4505                	li	a0,1
    3474:	60c010ef          	jal	4a80 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3478:	85ca                	mv	a1,s2
    347a:	00003517          	auipc	a0,0x3
    347e:	64650513          	addi	a0,a0,1606 # 6ac0 <thread_join+0x1a1c>
    3482:	227010ef          	jal	4ea8 <printf>
    exit(1);
    3486:	4505                	li	a0,1
    3488:	5f8010ef          	jal	4a80 <exit>
    printf("%s: write . succeeded!\n", s);
    348c:	85ca                	mv	a1,s2
    348e:	00003517          	auipc	a0,0x3
    3492:	65a50513          	addi	a0,a0,1626 # 6ae8 <thread_join+0x1a44>
    3496:	213010ef          	jal	4ea8 <printf>
    exit(1);
    349a:	4505                	li	a0,1
    349c:	5e4010ef          	jal	4a80 <exit>

00000000000034a0 <iref>:
{
    34a0:	7139                	addi	sp,sp,-64
    34a2:	fc06                	sd	ra,56(sp)
    34a4:	f822                	sd	s0,48(sp)
    34a6:	f426                	sd	s1,40(sp)
    34a8:	f04a                	sd	s2,32(sp)
    34aa:	ec4e                	sd	s3,24(sp)
    34ac:	e852                	sd	s4,16(sp)
    34ae:	e456                	sd	s5,8(sp)
    34b0:	e05a                	sd	s6,0(sp)
    34b2:	0080                	addi	s0,sp,64
    34b4:	8b2a                	mv	s6,a0
    34b6:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    34ba:	00003a17          	auipc	s4,0x3
    34be:	646a0a13          	addi	s4,s4,1606 # 6b00 <thread_join+0x1a5c>
    mkdir("");
    34c2:	00003497          	auipc	s1,0x3
    34c6:	14648493          	addi	s1,s1,326 # 6608 <thread_join+0x1564>
    link("README", "");
    34ca:	00002a97          	auipc	s5,0x2
    34ce:	e26a8a93          	addi	s5,s5,-474 # 52f0 <thread_join+0x24c>
    fd = open("xx", O_CREATE);
    34d2:	00003997          	auipc	s3,0x3
    34d6:	52698993          	addi	s3,s3,1318 # 69f8 <thread_join+0x1954>
    34da:	a835                	j	3516 <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    34dc:	85da                	mv	a1,s6
    34de:	00003517          	auipc	a0,0x3
    34e2:	62a50513          	addi	a0,a0,1578 # 6b08 <thread_join+0x1a64>
    34e6:	1c3010ef          	jal	4ea8 <printf>
      exit(1);
    34ea:	4505                	li	a0,1
    34ec:	594010ef          	jal	4a80 <exit>
      printf("%s: chdir irefd failed\n", s);
    34f0:	85da                	mv	a1,s6
    34f2:	00003517          	auipc	a0,0x3
    34f6:	62e50513          	addi	a0,a0,1582 # 6b20 <thread_join+0x1a7c>
    34fa:	1af010ef          	jal	4ea8 <printf>
      exit(1);
    34fe:	4505                	li	a0,1
    3500:	580010ef          	jal	4a80 <exit>
      close(fd);
    3504:	5a4010ef          	jal	4aa8 <close>
    3508:	a82d                	j	3542 <iref+0xa2>
    unlink("xx");
    350a:	854e                	mv	a0,s3
    350c:	5c4010ef          	jal	4ad0 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3510:	397d                	addiw	s2,s2,-1
    3512:	04090263          	beqz	s2,3556 <iref+0xb6>
    if(mkdir("irefd") != 0){
    3516:	8552                	mv	a0,s4
    3518:	5d0010ef          	jal	4ae8 <mkdir>
    351c:	f161                	bnez	a0,34dc <iref+0x3c>
    if(chdir("irefd") != 0){
    351e:	8552                	mv	a0,s4
    3520:	5d0010ef          	jal	4af0 <chdir>
    3524:	f571                	bnez	a0,34f0 <iref+0x50>
    mkdir("");
    3526:	8526                	mv	a0,s1
    3528:	5c0010ef          	jal	4ae8 <mkdir>
    link("README", "");
    352c:	85a6                	mv	a1,s1
    352e:	8556                	mv	a0,s5
    3530:	5b0010ef          	jal	4ae0 <link>
    fd = open("", O_CREATE);
    3534:	20000593          	li	a1,512
    3538:	8526                	mv	a0,s1
    353a:	586010ef          	jal	4ac0 <open>
    if(fd >= 0)
    353e:	fc0553e3          	bgez	a0,3504 <iref+0x64>
    fd = open("xx", O_CREATE);
    3542:	20000593          	li	a1,512
    3546:	854e                	mv	a0,s3
    3548:	578010ef          	jal	4ac0 <open>
    if(fd >= 0)
    354c:	fa054fe3          	bltz	a0,350a <iref+0x6a>
      close(fd);
    3550:	558010ef          	jal	4aa8 <close>
    3554:	bf5d                	j	350a <iref+0x6a>
    3556:	03300493          	li	s1,51
    chdir("..");
    355a:	00003997          	auipc	s3,0x3
    355e:	dc698993          	addi	s3,s3,-570 # 6320 <thread_join+0x127c>
    unlink("irefd");
    3562:	00003917          	auipc	s2,0x3
    3566:	59e90913          	addi	s2,s2,1438 # 6b00 <thread_join+0x1a5c>
    chdir("..");
    356a:	854e                	mv	a0,s3
    356c:	584010ef          	jal	4af0 <chdir>
    unlink("irefd");
    3570:	854a                	mv	a0,s2
    3572:	55e010ef          	jal	4ad0 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3576:	34fd                	addiw	s1,s1,-1
    3578:	f8ed                	bnez	s1,356a <iref+0xca>
  chdir("/");
    357a:	00003517          	auipc	a0,0x3
    357e:	d4e50513          	addi	a0,a0,-690 # 62c8 <thread_join+0x1224>
    3582:	56e010ef          	jal	4af0 <chdir>
}
    3586:	70e2                	ld	ra,56(sp)
    3588:	7442                	ld	s0,48(sp)
    358a:	74a2                	ld	s1,40(sp)
    358c:	7902                	ld	s2,32(sp)
    358e:	69e2                	ld	s3,24(sp)
    3590:	6a42                	ld	s4,16(sp)
    3592:	6aa2                	ld	s5,8(sp)
    3594:	6b02                	ld	s6,0(sp)
    3596:	6121                	addi	sp,sp,64
    3598:	8082                	ret

000000000000359a <openiputtest>:
{
    359a:	7179                	addi	sp,sp,-48
    359c:	f406                	sd	ra,40(sp)
    359e:	f022                	sd	s0,32(sp)
    35a0:	ec26                	sd	s1,24(sp)
    35a2:	1800                	addi	s0,sp,48
    35a4:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    35a6:	00003517          	auipc	a0,0x3
    35aa:	59250513          	addi	a0,a0,1426 # 6b38 <thread_join+0x1a94>
    35ae:	53a010ef          	jal	4ae8 <mkdir>
    35b2:	02054a63          	bltz	a0,35e6 <openiputtest+0x4c>
  pid = fork();
    35b6:	4c2010ef          	jal	4a78 <fork>
  if(pid < 0){
    35ba:	04054063          	bltz	a0,35fa <openiputtest+0x60>
  if(pid == 0){
    35be:	e939                	bnez	a0,3614 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    35c0:	4589                	li	a1,2
    35c2:	00003517          	auipc	a0,0x3
    35c6:	57650513          	addi	a0,a0,1398 # 6b38 <thread_join+0x1a94>
    35ca:	4f6010ef          	jal	4ac0 <open>
    if(fd >= 0){
    35ce:	04054063          	bltz	a0,360e <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    35d2:	85a6                	mv	a1,s1
    35d4:	00003517          	auipc	a0,0x3
    35d8:	58450513          	addi	a0,a0,1412 # 6b58 <thread_join+0x1ab4>
    35dc:	0cd010ef          	jal	4ea8 <printf>
      exit(1);
    35e0:	4505                	li	a0,1
    35e2:	49e010ef          	jal	4a80 <exit>
    printf("%s: mkdir oidir failed\n", s);
    35e6:	85a6                	mv	a1,s1
    35e8:	00003517          	auipc	a0,0x3
    35ec:	55850513          	addi	a0,a0,1368 # 6b40 <thread_join+0x1a9c>
    35f0:	0b9010ef          	jal	4ea8 <printf>
    exit(1);
    35f4:	4505                	li	a0,1
    35f6:	48a010ef          	jal	4a80 <exit>
    printf("%s: fork failed\n", s);
    35fa:	85a6                	mv	a1,s1
    35fc:	00002517          	auipc	a0,0x2
    3600:	3ac50513          	addi	a0,a0,940 # 59a8 <thread_join+0x904>
    3604:	0a5010ef          	jal	4ea8 <printf>
    exit(1);
    3608:	4505                	li	a0,1
    360a:	476010ef          	jal	4a80 <exit>
    exit(0);
    360e:	4501                	li	a0,0
    3610:	470010ef          	jal	4a80 <exit>
  sleep(1);
    3614:	4505                	li	a0,1
    3616:	4fa010ef          	jal	4b10 <sleep>
  if(unlink("oidir") != 0){
    361a:	00003517          	auipc	a0,0x3
    361e:	51e50513          	addi	a0,a0,1310 # 6b38 <thread_join+0x1a94>
    3622:	4ae010ef          	jal	4ad0 <unlink>
    3626:	c919                	beqz	a0,363c <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    3628:	85a6                	mv	a1,s1
    362a:	00002517          	auipc	a0,0x2
    362e:	56e50513          	addi	a0,a0,1390 # 5b98 <thread_join+0xaf4>
    3632:	077010ef          	jal	4ea8 <printf>
    exit(1);
    3636:	4505                	li	a0,1
    3638:	448010ef          	jal	4a80 <exit>
  wait(&xstatus);
    363c:	fdc40513          	addi	a0,s0,-36
    3640:	448010ef          	jal	4a88 <wait>
  exit(xstatus);
    3644:	fdc42503          	lw	a0,-36(s0)
    3648:	438010ef          	jal	4a80 <exit>

000000000000364c <forkforkfork>:
{
    364c:	1101                	addi	sp,sp,-32
    364e:	ec06                	sd	ra,24(sp)
    3650:	e822                	sd	s0,16(sp)
    3652:	e426                	sd	s1,8(sp)
    3654:	1000                	addi	s0,sp,32
    3656:	84aa                	mv	s1,a0
  unlink("stopforking");
    3658:	00003517          	auipc	a0,0x3
    365c:	52850513          	addi	a0,a0,1320 # 6b80 <thread_join+0x1adc>
    3660:	470010ef          	jal	4ad0 <unlink>
  int pid = fork();
    3664:	414010ef          	jal	4a78 <fork>
  if(pid < 0){
    3668:	02054b63          	bltz	a0,369e <forkforkfork+0x52>
  if(pid == 0){
    366c:	c139                	beqz	a0,36b2 <forkforkfork+0x66>
  sleep(20); // two seconds
    366e:	4551                	li	a0,20
    3670:	4a0010ef          	jal	4b10 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    3674:	20200593          	li	a1,514
    3678:	00003517          	auipc	a0,0x3
    367c:	50850513          	addi	a0,a0,1288 # 6b80 <thread_join+0x1adc>
    3680:	440010ef          	jal	4ac0 <open>
    3684:	424010ef          	jal	4aa8 <close>
  wait(0);
    3688:	4501                	li	a0,0
    368a:	3fe010ef          	jal	4a88 <wait>
  sleep(10); // one second
    368e:	4529                	li	a0,10
    3690:	480010ef          	jal	4b10 <sleep>
}
    3694:	60e2                	ld	ra,24(sp)
    3696:	6442                	ld	s0,16(sp)
    3698:	64a2                	ld	s1,8(sp)
    369a:	6105                	addi	sp,sp,32
    369c:	8082                	ret
    printf("%s: fork failed", s);
    369e:	85a6                	mv	a1,s1
    36a0:	00002517          	auipc	a0,0x2
    36a4:	4c850513          	addi	a0,a0,1224 # 5b68 <thread_join+0xac4>
    36a8:	001010ef          	jal	4ea8 <printf>
    exit(1);
    36ac:	4505                	li	a0,1
    36ae:	3d2010ef          	jal	4a80 <exit>
      int fd = open("stopforking", 0);
    36b2:	00003497          	auipc	s1,0x3
    36b6:	4ce48493          	addi	s1,s1,1230 # 6b80 <thread_join+0x1adc>
    36ba:	4581                	li	a1,0
    36bc:	8526                	mv	a0,s1
    36be:	402010ef          	jal	4ac0 <open>
      if(fd >= 0){
    36c2:	02055163          	bgez	a0,36e4 <forkforkfork+0x98>
      if(fork() < 0){
    36c6:	3b2010ef          	jal	4a78 <fork>
    36ca:	fe0558e3          	bgez	a0,36ba <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    36ce:	20200593          	li	a1,514
    36d2:	00003517          	auipc	a0,0x3
    36d6:	4ae50513          	addi	a0,a0,1198 # 6b80 <thread_join+0x1adc>
    36da:	3e6010ef          	jal	4ac0 <open>
    36de:	3ca010ef          	jal	4aa8 <close>
    36e2:	bfe1                	j	36ba <forkforkfork+0x6e>
        exit(0);
    36e4:	4501                	li	a0,0
    36e6:	39a010ef          	jal	4a80 <exit>

00000000000036ea <killstatus>:
{
    36ea:	7139                	addi	sp,sp,-64
    36ec:	fc06                	sd	ra,56(sp)
    36ee:	f822                	sd	s0,48(sp)
    36f0:	f426                	sd	s1,40(sp)
    36f2:	f04a                	sd	s2,32(sp)
    36f4:	ec4e                	sd	s3,24(sp)
    36f6:	e852                	sd	s4,16(sp)
    36f8:	0080                	addi	s0,sp,64
    36fa:	8a2a                	mv	s4,a0
    36fc:	06400913          	li	s2,100
    if(xst != -1) {
    3700:	59fd                	li	s3,-1
    int pid1 = fork();
    3702:	376010ef          	jal	4a78 <fork>
    3706:	84aa                	mv	s1,a0
    if(pid1 < 0){
    3708:	02054763          	bltz	a0,3736 <killstatus+0x4c>
    if(pid1 == 0){
    370c:	cd1d                	beqz	a0,374a <killstatus+0x60>
    sleep(1);
    370e:	4505                	li	a0,1
    3710:	400010ef          	jal	4b10 <sleep>
    kill(pid1);
    3714:	8526                	mv	a0,s1
    3716:	39a010ef          	jal	4ab0 <kill>
    wait(&xst);
    371a:	fcc40513          	addi	a0,s0,-52
    371e:	36a010ef          	jal	4a88 <wait>
    if(xst != -1) {
    3722:	fcc42783          	lw	a5,-52(s0)
    3726:	03379563          	bne	a5,s3,3750 <killstatus+0x66>
  for(int i = 0; i < 100; i++){
    372a:	397d                	addiw	s2,s2,-1
    372c:	fc091be3          	bnez	s2,3702 <killstatus+0x18>
  exit(0);
    3730:	4501                	li	a0,0
    3732:	34e010ef          	jal	4a80 <exit>
      printf("%s: fork failed\n", s);
    3736:	85d2                	mv	a1,s4
    3738:	00002517          	auipc	a0,0x2
    373c:	27050513          	addi	a0,a0,624 # 59a8 <thread_join+0x904>
    3740:	768010ef          	jal	4ea8 <printf>
      exit(1);
    3744:	4505                	li	a0,1
    3746:	33a010ef          	jal	4a80 <exit>
        getpid();
    374a:	3b6010ef          	jal	4b00 <getpid>
      while(1) {
    374e:	bff5                	j	374a <killstatus+0x60>
       printf("%s: status should be -1\n", s);
    3750:	85d2                	mv	a1,s4
    3752:	00003517          	auipc	a0,0x3
    3756:	43e50513          	addi	a0,a0,1086 # 6b90 <thread_join+0x1aec>
    375a:	74e010ef          	jal	4ea8 <printf>
       exit(1);
    375e:	4505                	li	a0,1
    3760:	320010ef          	jal	4a80 <exit>

0000000000003764 <preempt>:
{
    3764:	7139                	addi	sp,sp,-64
    3766:	fc06                	sd	ra,56(sp)
    3768:	f822                	sd	s0,48(sp)
    376a:	f426                	sd	s1,40(sp)
    376c:	f04a                	sd	s2,32(sp)
    376e:	ec4e                	sd	s3,24(sp)
    3770:	e852                	sd	s4,16(sp)
    3772:	0080                	addi	s0,sp,64
    3774:	892a                	mv	s2,a0
  pid1 = fork();
    3776:	302010ef          	jal	4a78 <fork>
  if(pid1 < 0) {
    377a:	00054563          	bltz	a0,3784 <preempt+0x20>
    377e:	84aa                	mv	s1,a0
  if(pid1 == 0)
    3780:	ed01                	bnez	a0,3798 <preempt+0x34>
    for(;;)
    3782:	a001                	j	3782 <preempt+0x1e>
    printf("%s: fork failed", s);
    3784:	85ca                	mv	a1,s2
    3786:	00002517          	auipc	a0,0x2
    378a:	3e250513          	addi	a0,a0,994 # 5b68 <thread_join+0xac4>
    378e:	71a010ef          	jal	4ea8 <printf>
    exit(1);
    3792:	4505                	li	a0,1
    3794:	2ec010ef          	jal	4a80 <exit>
  pid2 = fork();
    3798:	2e0010ef          	jal	4a78 <fork>
    379c:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    379e:	00054463          	bltz	a0,37a6 <preempt+0x42>
  if(pid2 == 0)
    37a2:	ed01                	bnez	a0,37ba <preempt+0x56>
    for(;;)
    37a4:	a001                	j	37a4 <preempt+0x40>
    printf("%s: fork failed\n", s);
    37a6:	85ca                	mv	a1,s2
    37a8:	00002517          	auipc	a0,0x2
    37ac:	20050513          	addi	a0,a0,512 # 59a8 <thread_join+0x904>
    37b0:	6f8010ef          	jal	4ea8 <printf>
    exit(1);
    37b4:	4505                	li	a0,1
    37b6:	2ca010ef          	jal	4a80 <exit>
  pipe(pfds);
    37ba:	fc840513          	addi	a0,s0,-56
    37be:	2d2010ef          	jal	4a90 <pipe>
  pid3 = fork();
    37c2:	2b6010ef          	jal	4a78 <fork>
    37c6:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    37c8:	02054863          	bltz	a0,37f8 <preempt+0x94>
  if(pid3 == 0){
    37cc:	e921                	bnez	a0,381c <preempt+0xb8>
    close(pfds[0]);
    37ce:	fc842503          	lw	a0,-56(s0)
    37d2:	2d6010ef          	jal	4aa8 <close>
    if(write(pfds[1], "x", 1) != 1)
    37d6:	4605                	li	a2,1
    37d8:	00002597          	auipc	a1,0x2
    37dc:	9b058593          	addi	a1,a1,-1616 # 5188 <thread_join+0xe4>
    37e0:	fcc42503          	lw	a0,-52(s0)
    37e4:	2bc010ef          	jal	4aa0 <write>
    37e8:	4785                	li	a5,1
    37ea:	02f51163          	bne	a0,a5,380c <preempt+0xa8>
    close(pfds[1]);
    37ee:	fcc42503          	lw	a0,-52(s0)
    37f2:	2b6010ef          	jal	4aa8 <close>
    for(;;)
    37f6:	a001                	j	37f6 <preempt+0x92>
     printf("%s: fork failed\n", s);
    37f8:	85ca                	mv	a1,s2
    37fa:	00002517          	auipc	a0,0x2
    37fe:	1ae50513          	addi	a0,a0,430 # 59a8 <thread_join+0x904>
    3802:	6a6010ef          	jal	4ea8 <printf>
     exit(1);
    3806:	4505                	li	a0,1
    3808:	278010ef          	jal	4a80 <exit>
      printf("%s: preempt write error", s);
    380c:	85ca                	mv	a1,s2
    380e:	00003517          	auipc	a0,0x3
    3812:	3a250513          	addi	a0,a0,930 # 6bb0 <thread_join+0x1b0c>
    3816:	692010ef          	jal	4ea8 <printf>
    381a:	bfd1                	j	37ee <preempt+0x8a>
  close(pfds[1]);
    381c:	fcc42503          	lw	a0,-52(s0)
    3820:	288010ef          	jal	4aa8 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3824:	660d                	lui	a2,0x3
    3826:	00009597          	auipc	a1,0x9
    382a:	45258593          	addi	a1,a1,1106 # cc78 <buf>
    382e:	fc842503          	lw	a0,-56(s0)
    3832:	266010ef          	jal	4a98 <read>
    3836:	4785                	li	a5,1
    3838:	02f50163          	beq	a0,a5,385a <preempt+0xf6>
    printf("%s: preempt read error", s);
    383c:	85ca                	mv	a1,s2
    383e:	00003517          	auipc	a0,0x3
    3842:	38a50513          	addi	a0,a0,906 # 6bc8 <thread_join+0x1b24>
    3846:	662010ef          	jal	4ea8 <printf>
}
    384a:	70e2                	ld	ra,56(sp)
    384c:	7442                	ld	s0,48(sp)
    384e:	74a2                	ld	s1,40(sp)
    3850:	7902                	ld	s2,32(sp)
    3852:	69e2                	ld	s3,24(sp)
    3854:	6a42                	ld	s4,16(sp)
    3856:	6121                	addi	sp,sp,64
    3858:	8082                	ret
  close(pfds[0]);
    385a:	fc842503          	lw	a0,-56(s0)
    385e:	24a010ef          	jal	4aa8 <close>
  printf("kill... ");
    3862:	00003517          	auipc	a0,0x3
    3866:	37e50513          	addi	a0,a0,894 # 6be0 <thread_join+0x1b3c>
    386a:	63e010ef          	jal	4ea8 <printf>
  kill(pid1);
    386e:	8526                	mv	a0,s1
    3870:	240010ef          	jal	4ab0 <kill>
  kill(pid2);
    3874:	854e                	mv	a0,s3
    3876:	23a010ef          	jal	4ab0 <kill>
  kill(pid3);
    387a:	8552                	mv	a0,s4
    387c:	234010ef          	jal	4ab0 <kill>
  printf("wait... ");
    3880:	00003517          	auipc	a0,0x3
    3884:	37050513          	addi	a0,a0,880 # 6bf0 <thread_join+0x1b4c>
    3888:	620010ef          	jal	4ea8 <printf>
  wait(0);
    388c:	4501                	li	a0,0
    388e:	1fa010ef          	jal	4a88 <wait>
  wait(0);
    3892:	4501                	li	a0,0
    3894:	1f4010ef          	jal	4a88 <wait>
  wait(0);
    3898:	4501                	li	a0,0
    389a:	1ee010ef          	jal	4a88 <wait>
    389e:	b775                	j	384a <preempt+0xe6>

00000000000038a0 <reparent>:
{
    38a0:	7179                	addi	sp,sp,-48
    38a2:	f406                	sd	ra,40(sp)
    38a4:	f022                	sd	s0,32(sp)
    38a6:	ec26                	sd	s1,24(sp)
    38a8:	e84a                	sd	s2,16(sp)
    38aa:	e44e                	sd	s3,8(sp)
    38ac:	e052                	sd	s4,0(sp)
    38ae:	1800                	addi	s0,sp,48
    38b0:	89aa                	mv	s3,a0
  int master_pid = getpid();
    38b2:	24e010ef          	jal	4b00 <getpid>
    38b6:	8a2a                	mv	s4,a0
    38b8:	0c800913          	li	s2,200
    int pid = fork();
    38bc:	1bc010ef          	jal	4a78 <fork>
    38c0:	84aa                	mv	s1,a0
    if(pid < 0){
    38c2:	00054e63          	bltz	a0,38de <reparent+0x3e>
    if(pid){
    38c6:	c121                	beqz	a0,3906 <reparent+0x66>
      if(wait(0) != pid){
    38c8:	4501                	li	a0,0
    38ca:	1be010ef          	jal	4a88 <wait>
    38ce:	02951263          	bne	a0,s1,38f2 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    38d2:	397d                	addiw	s2,s2,-1
    38d4:	fe0914e3          	bnez	s2,38bc <reparent+0x1c>
  exit(0);
    38d8:	4501                	li	a0,0
    38da:	1a6010ef          	jal	4a80 <exit>
      printf("%s: fork failed\n", s);
    38de:	85ce                	mv	a1,s3
    38e0:	00002517          	auipc	a0,0x2
    38e4:	0c850513          	addi	a0,a0,200 # 59a8 <thread_join+0x904>
    38e8:	5c0010ef          	jal	4ea8 <printf>
      exit(1);
    38ec:	4505                	li	a0,1
    38ee:	192010ef          	jal	4a80 <exit>
        printf("%s: wait wrong pid\n", s);
    38f2:	85ce                	mv	a1,s3
    38f4:	00002517          	auipc	a0,0x2
    38f8:	23c50513          	addi	a0,a0,572 # 5b30 <thread_join+0xa8c>
    38fc:	5ac010ef          	jal	4ea8 <printf>
        exit(1);
    3900:	4505                	li	a0,1
    3902:	17e010ef          	jal	4a80 <exit>
      int pid2 = fork();
    3906:	172010ef          	jal	4a78 <fork>
      if(pid2 < 0){
    390a:	00054563          	bltz	a0,3914 <reparent+0x74>
      exit(0);
    390e:	4501                	li	a0,0
    3910:	170010ef          	jal	4a80 <exit>
        kill(master_pid);
    3914:	8552                	mv	a0,s4
    3916:	19a010ef          	jal	4ab0 <kill>
        exit(1);
    391a:	4505                	li	a0,1
    391c:	164010ef          	jal	4a80 <exit>

0000000000003920 <sbrkfail>:
{
    3920:	7119                	addi	sp,sp,-128
    3922:	fc86                	sd	ra,120(sp)
    3924:	f8a2                	sd	s0,112(sp)
    3926:	f4a6                	sd	s1,104(sp)
    3928:	f0ca                	sd	s2,96(sp)
    392a:	ecce                	sd	s3,88(sp)
    392c:	e8d2                	sd	s4,80(sp)
    392e:	e4d6                	sd	s5,72(sp)
    3930:	0100                	addi	s0,sp,128
    3932:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    3934:	fb040513          	addi	a0,s0,-80
    3938:	158010ef          	jal	4a90 <pipe>
    393c:	e901                	bnez	a0,394c <sbrkfail+0x2c>
    393e:	f8040493          	addi	s1,s0,-128
    3942:	fa840993          	addi	s3,s0,-88
    3946:	8926                	mv	s2,s1
    if(pids[i] != -1)
    3948:	5a7d                	li	s4,-1
    394a:	a0a1                	j	3992 <sbrkfail+0x72>
    printf("%s: pipe() failed\n", s);
    394c:	85d6                	mv	a1,s5
    394e:	00002517          	auipc	a0,0x2
    3952:	16250513          	addi	a0,a0,354 # 5ab0 <thread_join+0xa0c>
    3956:	552010ef          	jal	4ea8 <printf>
    exit(1);
    395a:	4505                	li	a0,1
    395c:	124010ef          	jal	4a80 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3960:	1a8010ef          	jal	4b08 <sbrk>
    3964:	064007b7          	lui	a5,0x6400
    3968:	40a7853b          	subw	a0,a5,a0
    396c:	19c010ef          	jal	4b08 <sbrk>
      write(fds[1], "x", 1);
    3970:	4605                	li	a2,1
    3972:	00002597          	auipc	a1,0x2
    3976:	81658593          	addi	a1,a1,-2026 # 5188 <thread_join+0xe4>
    397a:	fb442503          	lw	a0,-76(s0)
    397e:	122010ef          	jal	4aa0 <write>
      for(;;) sleep(1000);
    3982:	3e800513          	li	a0,1000
    3986:	18a010ef          	jal	4b10 <sleep>
    398a:	bfe5                	j	3982 <sbrkfail+0x62>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    398c:	0911                	addi	s2,s2,4
    398e:	03390163          	beq	s2,s3,39b0 <sbrkfail+0x90>
    if((pids[i] = fork()) == 0){
    3992:	0e6010ef          	jal	4a78 <fork>
    3996:	00a92023          	sw	a0,0(s2)
    399a:	d179                	beqz	a0,3960 <sbrkfail+0x40>
    if(pids[i] != -1)
    399c:	ff4508e3          	beq	a0,s4,398c <sbrkfail+0x6c>
      read(fds[0], &scratch, 1);
    39a0:	4605                	li	a2,1
    39a2:	faf40593          	addi	a1,s0,-81
    39a6:	fb042503          	lw	a0,-80(s0)
    39aa:	0ee010ef          	jal	4a98 <read>
    39ae:	bff9                	j	398c <sbrkfail+0x6c>
  c = sbrk(PGSIZE);
    39b0:	6505                	lui	a0,0x1
    39b2:	156010ef          	jal	4b08 <sbrk>
    39b6:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    39b8:	597d                	li	s2,-1
    39ba:	a021                	j	39c2 <sbrkfail+0xa2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    39bc:	0491                	addi	s1,s1,4
    39be:	01348b63          	beq	s1,s3,39d4 <sbrkfail+0xb4>
    if(pids[i] == -1)
    39c2:	4088                	lw	a0,0(s1)
    39c4:	ff250ce3          	beq	a0,s2,39bc <sbrkfail+0x9c>
    kill(pids[i]);
    39c8:	0e8010ef          	jal	4ab0 <kill>
    wait(0);
    39cc:	4501                	li	a0,0
    39ce:	0ba010ef          	jal	4a88 <wait>
    39d2:	b7ed                	j	39bc <sbrkfail+0x9c>
  if(c == (char*)0xffffffffffffffffL){
    39d4:	57fd                	li	a5,-1
    39d6:	02fa0d63          	beq	s4,a5,3a10 <sbrkfail+0xf0>
  pid = fork();
    39da:	09e010ef          	jal	4a78 <fork>
    39de:	84aa                	mv	s1,a0
  if(pid < 0){
    39e0:	04054263          	bltz	a0,3a24 <sbrkfail+0x104>
  if(pid == 0){
    39e4:	c931                	beqz	a0,3a38 <sbrkfail+0x118>
  wait(&xstatus);
    39e6:	fbc40513          	addi	a0,s0,-68
    39ea:	09e010ef          	jal	4a88 <wait>
  if(xstatus != -1 && xstatus != 2)
    39ee:	fbc42783          	lw	a5,-68(s0)
    39f2:	577d                	li	a4,-1
    39f4:	00e78563          	beq	a5,a4,39fe <sbrkfail+0xde>
    39f8:	4709                	li	a4,2
    39fa:	06e79d63          	bne	a5,a4,3a74 <sbrkfail+0x154>
}
    39fe:	70e6                	ld	ra,120(sp)
    3a00:	7446                	ld	s0,112(sp)
    3a02:	74a6                	ld	s1,104(sp)
    3a04:	7906                	ld	s2,96(sp)
    3a06:	69e6                	ld	s3,88(sp)
    3a08:	6a46                	ld	s4,80(sp)
    3a0a:	6aa6                	ld	s5,72(sp)
    3a0c:	6109                	addi	sp,sp,128
    3a0e:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3a10:	85d6                	mv	a1,s5
    3a12:	00003517          	auipc	a0,0x3
    3a16:	1ee50513          	addi	a0,a0,494 # 6c00 <thread_join+0x1b5c>
    3a1a:	48e010ef          	jal	4ea8 <printf>
    exit(1);
    3a1e:	4505                	li	a0,1
    3a20:	060010ef          	jal	4a80 <exit>
    printf("%s: fork failed\n", s);
    3a24:	85d6                	mv	a1,s5
    3a26:	00002517          	auipc	a0,0x2
    3a2a:	f8250513          	addi	a0,a0,-126 # 59a8 <thread_join+0x904>
    3a2e:	47a010ef          	jal	4ea8 <printf>
    exit(1);
    3a32:	4505                	li	a0,1
    3a34:	04c010ef          	jal	4a80 <exit>
    a = sbrk(0);
    3a38:	4501                	li	a0,0
    3a3a:	0ce010ef          	jal	4b08 <sbrk>
    3a3e:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3a40:	3e800537          	lui	a0,0x3e800
    3a44:	0c4010ef          	jal	4b08 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3a48:	87ca                	mv	a5,s2
    3a4a:	3e800737          	lui	a4,0x3e800
    3a4e:	993a                	add	s2,s2,a4
    3a50:	6705                	lui	a4,0x1
      n += *(a+i);
    3a52:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    3a56:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3a58:	97ba                	add	a5,a5,a4
    3a5a:	fef91ce3          	bne	s2,a5,3a52 <sbrkfail+0x132>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    3a5e:	8626                	mv	a2,s1
    3a60:	85d6                	mv	a1,s5
    3a62:	00003517          	auipc	a0,0x3
    3a66:	1be50513          	addi	a0,a0,446 # 6c20 <thread_join+0x1b7c>
    3a6a:	43e010ef          	jal	4ea8 <printf>
    exit(1);
    3a6e:	4505                	li	a0,1
    3a70:	010010ef          	jal	4a80 <exit>
    exit(1);
    3a74:	4505                	li	a0,1
    3a76:	00a010ef          	jal	4a80 <exit>

0000000000003a7a <mem>:
{
    3a7a:	7139                	addi	sp,sp,-64
    3a7c:	fc06                	sd	ra,56(sp)
    3a7e:	f822                	sd	s0,48(sp)
    3a80:	f426                	sd	s1,40(sp)
    3a82:	f04a                	sd	s2,32(sp)
    3a84:	ec4e                	sd	s3,24(sp)
    3a86:	0080                	addi	s0,sp,64
    3a88:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3a8a:	7ef000ef          	jal	4a78 <fork>
    m1 = 0;
    3a8e:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3a90:	6909                	lui	s2,0x2
    3a92:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0x7d>
  if((pid = fork()) == 0){
    3a96:	cd11                	beqz	a0,3ab2 <mem+0x38>
    wait(&xstatus);
    3a98:	fcc40513          	addi	a0,s0,-52
    3a9c:	7ed000ef          	jal	4a88 <wait>
    if(xstatus == -1){
    3aa0:	fcc42503          	lw	a0,-52(s0)
    3aa4:	57fd                	li	a5,-1
    3aa6:	04f50363          	beq	a0,a5,3aec <mem+0x72>
    exit(xstatus);
    3aaa:	7d7000ef          	jal	4a80 <exit>
      *(char**)m2 = m1;
    3aae:	e104                	sd	s1,0(a0)
      m1 = m2;
    3ab0:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3ab2:	854a                	mv	a0,s2
    3ab4:	4a8010ef          	jal	4f5c <malloc>
    3ab8:	f97d                	bnez	a0,3aae <mem+0x34>
    while(m1){
    3aba:	c491                	beqz	s1,3ac6 <mem+0x4c>
      m2 = *(char**)m1;
    3abc:	8526                	mv	a0,s1
    3abe:	6084                	ld	s1,0(s1)
      free(m1);
    3ac0:	41a010ef          	jal	4eda <free>
    while(m1){
    3ac4:	fce5                	bnez	s1,3abc <mem+0x42>
    m1 = malloc(1024*20);
    3ac6:	6515                	lui	a0,0x5
    3ac8:	494010ef          	jal	4f5c <malloc>
    if(m1 == 0){
    3acc:	c511                	beqz	a0,3ad8 <mem+0x5e>
    free(m1);
    3ace:	40c010ef          	jal	4eda <free>
    exit(0);
    3ad2:	4501                	li	a0,0
    3ad4:	7ad000ef          	jal	4a80 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3ad8:	85ce                	mv	a1,s3
    3ada:	00003517          	auipc	a0,0x3
    3ade:	17650513          	addi	a0,a0,374 # 6c50 <thread_join+0x1bac>
    3ae2:	3c6010ef          	jal	4ea8 <printf>
      exit(1);
    3ae6:	4505                	li	a0,1
    3ae8:	799000ef          	jal	4a80 <exit>
      exit(0);
    3aec:	4501                	li	a0,0
    3aee:	793000ef          	jal	4a80 <exit>

0000000000003af2 <sharedfd>:
{
    3af2:	7159                	addi	sp,sp,-112
    3af4:	f486                	sd	ra,104(sp)
    3af6:	f0a2                	sd	s0,96(sp)
    3af8:	e0d2                	sd	s4,64(sp)
    3afa:	1880                	addi	s0,sp,112
    3afc:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    3afe:	00003517          	auipc	a0,0x3
    3b02:	17250513          	addi	a0,a0,370 # 6c70 <thread_join+0x1bcc>
    3b06:	7cb000ef          	jal	4ad0 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3b0a:	20200593          	li	a1,514
    3b0e:	00003517          	auipc	a0,0x3
    3b12:	16250513          	addi	a0,a0,354 # 6c70 <thread_join+0x1bcc>
    3b16:	7ab000ef          	jal	4ac0 <open>
  if(fd < 0){
    3b1a:	04054863          	bltz	a0,3b6a <sharedfd+0x78>
    3b1e:	eca6                	sd	s1,88(sp)
    3b20:	e8ca                	sd	s2,80(sp)
    3b22:	e4ce                	sd	s3,72(sp)
    3b24:	fc56                	sd	s5,56(sp)
    3b26:	f85a                	sd	s6,48(sp)
    3b28:	f45e                	sd	s7,40(sp)
    3b2a:	892a                	mv	s2,a0
  pid = fork();
    3b2c:	74d000ef          	jal	4a78 <fork>
    3b30:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3b32:	07000593          	li	a1,112
    3b36:	e119                	bnez	a0,3b3c <sharedfd+0x4a>
    3b38:	06300593          	li	a1,99
    3b3c:	4629                	li	a2,10
    3b3e:	fa040513          	addi	a0,s0,-96
    3b42:	559000ef          	jal	489a <memset>
    3b46:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3b4a:	4629                	li	a2,10
    3b4c:	fa040593          	addi	a1,s0,-96
    3b50:	854a                	mv	a0,s2
    3b52:	74f000ef          	jal	4aa0 <write>
    3b56:	47a9                	li	a5,10
    3b58:	02f51963          	bne	a0,a5,3b8a <sharedfd+0x98>
  for(i = 0; i < N; i++){
    3b5c:	34fd                	addiw	s1,s1,-1
    3b5e:	f4f5                	bnez	s1,3b4a <sharedfd+0x58>
  if(pid == 0) {
    3b60:	02099f63          	bnez	s3,3b9e <sharedfd+0xac>
    exit(0);
    3b64:	4501                	li	a0,0
    3b66:	71b000ef          	jal	4a80 <exit>
    3b6a:	eca6                	sd	s1,88(sp)
    3b6c:	e8ca                	sd	s2,80(sp)
    3b6e:	e4ce                	sd	s3,72(sp)
    3b70:	fc56                	sd	s5,56(sp)
    3b72:	f85a                	sd	s6,48(sp)
    3b74:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3b76:	85d2                	mv	a1,s4
    3b78:	00003517          	auipc	a0,0x3
    3b7c:	10850513          	addi	a0,a0,264 # 6c80 <thread_join+0x1bdc>
    3b80:	328010ef          	jal	4ea8 <printf>
    exit(1);
    3b84:	4505                	li	a0,1
    3b86:	6fb000ef          	jal	4a80 <exit>
      printf("%s: write sharedfd failed\n", s);
    3b8a:	85d2                	mv	a1,s4
    3b8c:	00003517          	auipc	a0,0x3
    3b90:	11c50513          	addi	a0,a0,284 # 6ca8 <thread_join+0x1c04>
    3b94:	314010ef          	jal	4ea8 <printf>
      exit(1);
    3b98:	4505                	li	a0,1
    3b9a:	6e7000ef          	jal	4a80 <exit>
    wait(&xstatus);
    3b9e:	f9c40513          	addi	a0,s0,-100
    3ba2:	6e7000ef          	jal	4a88 <wait>
    if(xstatus != 0)
    3ba6:	f9c42983          	lw	s3,-100(s0)
    3baa:	00098563          	beqz	s3,3bb4 <sharedfd+0xc2>
      exit(xstatus);
    3bae:	854e                	mv	a0,s3
    3bb0:	6d1000ef          	jal	4a80 <exit>
  close(fd);
    3bb4:	854a                	mv	a0,s2
    3bb6:	6f3000ef          	jal	4aa8 <close>
  fd = open("sharedfd", 0);
    3bba:	4581                	li	a1,0
    3bbc:	00003517          	auipc	a0,0x3
    3bc0:	0b450513          	addi	a0,a0,180 # 6c70 <thread_join+0x1bcc>
    3bc4:	6fd000ef          	jal	4ac0 <open>
    3bc8:	8baa                	mv	s7,a0
  nc = np = 0;
    3bca:	8ace                	mv	s5,s3
  if(fd < 0){
    3bcc:	02054363          	bltz	a0,3bf2 <sharedfd+0x100>
    3bd0:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3bd4:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3bd8:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3bdc:	4629                	li	a2,10
    3bde:	fa040593          	addi	a1,s0,-96
    3be2:	855e                	mv	a0,s7
    3be4:	6b5000ef          	jal	4a98 <read>
    3be8:	02a05b63          	blez	a0,3c1e <sharedfd+0x12c>
    3bec:	fa040793          	addi	a5,s0,-96
    3bf0:	a839                	j	3c0e <sharedfd+0x11c>
    printf("%s: cannot open sharedfd for reading\n", s);
    3bf2:	85d2                	mv	a1,s4
    3bf4:	00003517          	auipc	a0,0x3
    3bf8:	0d450513          	addi	a0,a0,212 # 6cc8 <thread_join+0x1c24>
    3bfc:	2ac010ef          	jal	4ea8 <printf>
    exit(1);
    3c00:	4505                	li	a0,1
    3c02:	67f000ef          	jal	4a80 <exit>
        nc++;
    3c06:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    3c08:	0785                	addi	a5,a5,1
    3c0a:	fd2789e3          	beq	a5,s2,3bdc <sharedfd+0xea>
      if(buf[i] == 'c')
    3c0e:	0007c703          	lbu	a4,0(a5)
    3c12:	fe970ae3          	beq	a4,s1,3c06 <sharedfd+0x114>
      if(buf[i] == 'p')
    3c16:	ff6719e3          	bne	a4,s6,3c08 <sharedfd+0x116>
        np++;
    3c1a:	2a85                	addiw	s5,s5,1
    3c1c:	b7f5                	j	3c08 <sharedfd+0x116>
  close(fd);
    3c1e:	855e                	mv	a0,s7
    3c20:	689000ef          	jal	4aa8 <close>
  unlink("sharedfd");
    3c24:	00003517          	auipc	a0,0x3
    3c28:	04c50513          	addi	a0,a0,76 # 6c70 <thread_join+0x1bcc>
    3c2c:	6a5000ef          	jal	4ad0 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3c30:	6789                	lui	a5,0x2
    3c32:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x7c>
    3c36:	00f99763          	bne	s3,a5,3c44 <sharedfd+0x152>
    3c3a:	6789                	lui	a5,0x2
    3c3c:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0x7c>
    3c40:	00fa8c63          	beq	s5,a5,3c58 <sharedfd+0x166>
    printf("%s: nc/np test fails\n", s);
    3c44:	85d2                	mv	a1,s4
    3c46:	00003517          	auipc	a0,0x3
    3c4a:	0aa50513          	addi	a0,a0,170 # 6cf0 <thread_join+0x1c4c>
    3c4e:	25a010ef          	jal	4ea8 <printf>
    exit(1);
    3c52:	4505                	li	a0,1
    3c54:	62d000ef          	jal	4a80 <exit>
    exit(0);
    3c58:	4501                	li	a0,0
    3c5a:	627000ef          	jal	4a80 <exit>

0000000000003c5e <fourfiles>:
{
    3c5e:	7135                	addi	sp,sp,-160
    3c60:	ed06                	sd	ra,152(sp)
    3c62:	e922                	sd	s0,144(sp)
    3c64:	e526                	sd	s1,136(sp)
    3c66:	e14a                	sd	s2,128(sp)
    3c68:	fcce                	sd	s3,120(sp)
    3c6a:	f8d2                	sd	s4,112(sp)
    3c6c:	f4d6                	sd	s5,104(sp)
    3c6e:	f0da                	sd	s6,96(sp)
    3c70:	ecde                	sd	s7,88(sp)
    3c72:	e8e2                	sd	s8,80(sp)
    3c74:	e4e6                	sd	s9,72(sp)
    3c76:	e0ea                	sd	s10,64(sp)
    3c78:	fc6e                	sd	s11,56(sp)
    3c7a:	1100                	addi	s0,sp,160
    3c7c:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3c7e:	00003797          	auipc	a5,0x3
    3c82:	08a78793          	addi	a5,a5,138 # 6d08 <thread_join+0x1c64>
    3c86:	f6f43823          	sd	a5,-144(s0)
    3c8a:	00003797          	auipc	a5,0x3
    3c8e:	08678793          	addi	a5,a5,134 # 6d10 <thread_join+0x1c6c>
    3c92:	f6f43c23          	sd	a5,-136(s0)
    3c96:	00003797          	auipc	a5,0x3
    3c9a:	08278793          	addi	a5,a5,130 # 6d18 <thread_join+0x1c74>
    3c9e:	f8f43023          	sd	a5,-128(s0)
    3ca2:	00003797          	auipc	a5,0x3
    3ca6:	07e78793          	addi	a5,a5,126 # 6d20 <thread_join+0x1c7c>
    3caa:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3cae:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3cb2:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3cb4:	4481                	li	s1,0
    3cb6:	4a11                	li	s4,4
    fname = names[pi];
    3cb8:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3cbc:	854e                	mv	a0,s3
    3cbe:	613000ef          	jal	4ad0 <unlink>
    pid = fork();
    3cc2:	5b7000ef          	jal	4a78 <fork>
    if(pid < 0){
    3cc6:	02054e63          	bltz	a0,3d02 <fourfiles+0xa4>
    if(pid == 0){
    3cca:	c531                	beqz	a0,3d16 <fourfiles+0xb8>
  for(pi = 0; pi < NCHILD; pi++){
    3ccc:	2485                	addiw	s1,s1,1
    3cce:	0921                	addi	s2,s2,8
    3cd0:	ff4494e3          	bne	s1,s4,3cb8 <fourfiles+0x5a>
    3cd4:	4491                	li	s1,4
    wait(&xstatus);
    3cd6:	f6c40513          	addi	a0,s0,-148
    3cda:	5af000ef          	jal	4a88 <wait>
    if(xstatus != 0)
    3cde:	f6c42a83          	lw	s5,-148(s0)
    3ce2:	0a0a9463          	bnez	s5,3d8a <fourfiles+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    3ce6:	34fd                	addiw	s1,s1,-1
    3ce8:	f4fd                	bnez	s1,3cd6 <fourfiles+0x78>
    3cea:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3cee:	00009a17          	auipc	s4,0x9
    3cf2:	f8aa0a13          	addi	s4,s4,-118 # cc78 <buf>
    if(total != N*SZ){
    3cf6:	6d05                	lui	s10,0x1
    3cf8:	770d0d13          	addi	s10,s10,1904 # 1770 <forkfork+0x1e>
  for(i = 0; i < NCHILD; i++){
    3cfc:	03400d93          	li	s11,52
    3d00:	a0ed                	j	3dea <fourfiles+0x18c>
      printf("%s: fork failed\n", s);
    3d02:	85e6                	mv	a1,s9
    3d04:	00002517          	auipc	a0,0x2
    3d08:	ca450513          	addi	a0,a0,-860 # 59a8 <thread_join+0x904>
    3d0c:	19c010ef          	jal	4ea8 <printf>
      exit(1);
    3d10:	4505                	li	a0,1
    3d12:	56f000ef          	jal	4a80 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3d16:	20200593          	li	a1,514
    3d1a:	854e                	mv	a0,s3
    3d1c:	5a5000ef          	jal	4ac0 <open>
    3d20:	892a                	mv	s2,a0
      if(fd < 0){
    3d22:	04054163          	bltz	a0,3d64 <fourfiles+0x106>
      memset(buf, '0'+pi, SZ);
    3d26:	1f400613          	li	a2,500
    3d2a:	0304859b          	addiw	a1,s1,48
    3d2e:	00009517          	auipc	a0,0x9
    3d32:	f4a50513          	addi	a0,a0,-182 # cc78 <buf>
    3d36:	365000ef          	jal	489a <memset>
    3d3a:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3d3c:	00009997          	auipc	s3,0x9
    3d40:	f3c98993          	addi	s3,s3,-196 # cc78 <buf>
    3d44:	1f400613          	li	a2,500
    3d48:	85ce                	mv	a1,s3
    3d4a:	854a                	mv	a0,s2
    3d4c:	555000ef          	jal	4aa0 <write>
    3d50:	85aa                	mv	a1,a0
    3d52:	1f400793          	li	a5,500
    3d56:	02f51163          	bne	a0,a5,3d78 <fourfiles+0x11a>
      for(i = 0; i < N; i++){
    3d5a:	34fd                	addiw	s1,s1,-1
    3d5c:	f4e5                	bnez	s1,3d44 <fourfiles+0xe6>
      exit(0);
    3d5e:	4501                	li	a0,0
    3d60:	521000ef          	jal	4a80 <exit>
        printf("%s: create failed\n", s);
    3d64:	85e6                	mv	a1,s9
    3d66:	00002517          	auipc	a0,0x2
    3d6a:	cda50513          	addi	a0,a0,-806 # 5a40 <thread_join+0x99c>
    3d6e:	13a010ef          	jal	4ea8 <printf>
        exit(1);
    3d72:	4505                	li	a0,1
    3d74:	50d000ef          	jal	4a80 <exit>
          printf("write failed %d\n", n);
    3d78:	00003517          	auipc	a0,0x3
    3d7c:	fb050513          	addi	a0,a0,-80 # 6d28 <thread_join+0x1c84>
    3d80:	128010ef          	jal	4ea8 <printf>
          exit(1);
    3d84:	4505                	li	a0,1
    3d86:	4fb000ef          	jal	4a80 <exit>
      exit(xstatus);
    3d8a:	8556                	mv	a0,s5
    3d8c:	4f5000ef          	jal	4a80 <exit>
          printf("%s: wrong char\n", s);
    3d90:	85e6                	mv	a1,s9
    3d92:	00003517          	auipc	a0,0x3
    3d96:	fae50513          	addi	a0,a0,-82 # 6d40 <thread_join+0x1c9c>
    3d9a:	10e010ef          	jal	4ea8 <printf>
          exit(1);
    3d9e:	4505                	li	a0,1
    3da0:	4e1000ef          	jal	4a80 <exit>
      total += n;
    3da4:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3da8:	660d                	lui	a2,0x3
    3daa:	85d2                	mv	a1,s4
    3dac:	854e                	mv	a0,s3
    3dae:	4eb000ef          	jal	4a98 <read>
    3db2:	02a05063          	blez	a0,3dd2 <fourfiles+0x174>
    3db6:	00009797          	auipc	a5,0x9
    3dba:	ec278793          	addi	a5,a5,-318 # cc78 <buf>
    3dbe:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3dc2:	0007c703          	lbu	a4,0(a5)
    3dc6:	fc9715e3          	bne	a4,s1,3d90 <fourfiles+0x132>
      for(j = 0; j < n; j++){
    3dca:	0785                	addi	a5,a5,1
    3dcc:	fed79be3          	bne	a5,a3,3dc2 <fourfiles+0x164>
    3dd0:	bfd1                	j	3da4 <fourfiles+0x146>
    close(fd);
    3dd2:	854e                	mv	a0,s3
    3dd4:	4d5000ef          	jal	4aa8 <close>
    if(total != N*SZ){
    3dd8:	03a91463          	bne	s2,s10,3e00 <fourfiles+0x1a2>
    unlink(fname);
    3ddc:	8562                	mv	a0,s8
    3dde:	4f3000ef          	jal	4ad0 <unlink>
  for(i = 0; i < NCHILD; i++){
    3de2:	0ba1                	addi	s7,s7,8
    3de4:	2b05                	addiw	s6,s6,1
    3de6:	03bb0763          	beq	s6,s11,3e14 <fourfiles+0x1b6>
    fname = names[i];
    3dea:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3dee:	4581                	li	a1,0
    3df0:	8562                	mv	a0,s8
    3df2:	4cf000ef          	jal	4ac0 <open>
    3df6:	89aa                	mv	s3,a0
    total = 0;
    3df8:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    3dfa:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3dfe:	b76d                	j	3da8 <fourfiles+0x14a>
      printf("wrong length %d\n", total);
    3e00:	85ca                	mv	a1,s2
    3e02:	00003517          	auipc	a0,0x3
    3e06:	f4e50513          	addi	a0,a0,-178 # 6d50 <thread_join+0x1cac>
    3e0a:	09e010ef          	jal	4ea8 <printf>
      exit(1);
    3e0e:	4505                	li	a0,1
    3e10:	471000ef          	jal	4a80 <exit>
}
    3e14:	60ea                	ld	ra,152(sp)
    3e16:	644a                	ld	s0,144(sp)
    3e18:	64aa                	ld	s1,136(sp)
    3e1a:	690a                	ld	s2,128(sp)
    3e1c:	79e6                	ld	s3,120(sp)
    3e1e:	7a46                	ld	s4,112(sp)
    3e20:	7aa6                	ld	s5,104(sp)
    3e22:	7b06                	ld	s6,96(sp)
    3e24:	6be6                	ld	s7,88(sp)
    3e26:	6c46                	ld	s8,80(sp)
    3e28:	6ca6                	ld	s9,72(sp)
    3e2a:	6d06                	ld	s10,64(sp)
    3e2c:	7de2                	ld	s11,56(sp)
    3e2e:	610d                	addi	sp,sp,160
    3e30:	8082                	ret

0000000000003e32 <concreate>:
{
    3e32:	7135                	addi	sp,sp,-160
    3e34:	ed06                	sd	ra,152(sp)
    3e36:	e922                	sd	s0,144(sp)
    3e38:	e526                	sd	s1,136(sp)
    3e3a:	e14a                	sd	s2,128(sp)
    3e3c:	fcce                	sd	s3,120(sp)
    3e3e:	f8d2                	sd	s4,112(sp)
    3e40:	f4d6                	sd	s5,104(sp)
    3e42:	f0da                	sd	s6,96(sp)
    3e44:	ecde                	sd	s7,88(sp)
    3e46:	1100                	addi	s0,sp,160
    3e48:	89aa                	mv	s3,a0
  file[0] = 'C';
    3e4a:	04300793          	li	a5,67
    3e4e:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    3e52:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    3e56:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    3e58:	4b0d                	li	s6,3
    3e5a:	4a85                	li	s5,1
      link("C0", file);
    3e5c:	00003b97          	auipc	s7,0x3
    3e60:	f0cb8b93          	addi	s7,s7,-244 # 6d68 <thread_join+0x1cc4>
  for(i = 0; i < N; i++){
    3e64:	02800a13          	li	s4,40
    3e68:	a41d                	j	408e <concreate+0x25c>
      link("C0", file);
    3e6a:	fa840593          	addi	a1,s0,-88
    3e6e:	855e                	mv	a0,s7
    3e70:	471000ef          	jal	4ae0 <link>
    if(pid == 0) {
    3e74:	a411                	j	4078 <concreate+0x246>
    } else if(pid == 0 && (i % 5) == 1){
    3e76:	4795                	li	a5,5
    3e78:	02f9693b          	remw	s2,s2,a5
    3e7c:	4785                	li	a5,1
    3e7e:	02f90563          	beq	s2,a5,3ea8 <concreate+0x76>
      fd = open(file, O_CREATE | O_RDWR);
    3e82:	20200593          	li	a1,514
    3e86:	fa840513          	addi	a0,s0,-88
    3e8a:	437000ef          	jal	4ac0 <open>
      if(fd < 0){
    3e8e:	1e055063          	bgez	a0,406e <concreate+0x23c>
        printf("concreate create %s failed\n", file);
    3e92:	fa840593          	addi	a1,s0,-88
    3e96:	00003517          	auipc	a0,0x3
    3e9a:	eda50513          	addi	a0,a0,-294 # 6d70 <thread_join+0x1ccc>
    3e9e:	00a010ef          	jal	4ea8 <printf>
        exit(1);
    3ea2:	4505                	li	a0,1
    3ea4:	3dd000ef          	jal	4a80 <exit>
      link("C0", file);
    3ea8:	fa840593          	addi	a1,s0,-88
    3eac:	00003517          	auipc	a0,0x3
    3eb0:	ebc50513          	addi	a0,a0,-324 # 6d68 <thread_join+0x1cc4>
    3eb4:	42d000ef          	jal	4ae0 <link>
      exit(0);
    3eb8:	4501                	li	a0,0
    3eba:	3c7000ef          	jal	4a80 <exit>
        exit(1);
    3ebe:	4505                	li	a0,1
    3ec0:	3c1000ef          	jal	4a80 <exit>
  memset(fa, 0, sizeof(fa));
    3ec4:	02800613          	li	a2,40
    3ec8:	4581                	li	a1,0
    3eca:	f8040513          	addi	a0,s0,-128
    3ece:	1cd000ef          	jal	489a <memset>
  fd = open(".", 0);
    3ed2:	4581                	li	a1,0
    3ed4:	00002517          	auipc	a0,0x2
    3ed8:	92c50513          	addi	a0,a0,-1748 # 5800 <thread_join+0x75c>
    3edc:	3e5000ef          	jal	4ac0 <open>
    3ee0:	892a                	mv	s2,a0
  n = 0;
    3ee2:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3ee4:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    3ee8:	02700b13          	li	s6,39
      fa[i] = 1;
    3eec:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    3eee:	4641                	li	a2,16
    3ef0:	f7040593          	addi	a1,s0,-144
    3ef4:	854a                	mv	a0,s2
    3ef6:	3a3000ef          	jal	4a98 <read>
    3efa:	06a05a63          	blez	a0,3f6e <concreate+0x13c>
    if(de.inum == 0)
    3efe:	f7045783          	lhu	a5,-144(s0)
    3f02:	d7f5                	beqz	a5,3eee <concreate+0xbc>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    3f04:	f7244783          	lbu	a5,-142(s0)
    3f08:	ff4793e3          	bne	a5,s4,3eee <concreate+0xbc>
    3f0c:	f7444783          	lbu	a5,-140(s0)
    3f10:	fff9                	bnez	a5,3eee <concreate+0xbc>
      i = de.name[1] - '0';
    3f12:	f7344783          	lbu	a5,-141(s0)
    3f16:	fd07879b          	addiw	a5,a5,-48
    3f1a:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    3f1e:	02eb6063          	bltu	s6,a4,3f3e <concreate+0x10c>
      if(fa[i]){
    3f22:	fb070793          	addi	a5,a4,-80 # fb0 <bigdir+0x112>
    3f26:	97a2                	add	a5,a5,s0
    3f28:	fd07c783          	lbu	a5,-48(a5)
    3f2c:	e78d                	bnez	a5,3f56 <concreate+0x124>
      fa[i] = 1;
    3f2e:	fb070793          	addi	a5,a4,-80
    3f32:	00878733          	add	a4,a5,s0
    3f36:	fd770823          	sb	s7,-48(a4)
      n++;
    3f3a:	2a85                	addiw	s5,s5,1
    3f3c:	bf4d                	j	3eee <concreate+0xbc>
        printf("%s: concreate weird file %s\n", s, de.name);
    3f3e:	f7240613          	addi	a2,s0,-142
    3f42:	85ce                	mv	a1,s3
    3f44:	00003517          	auipc	a0,0x3
    3f48:	e4c50513          	addi	a0,a0,-436 # 6d90 <thread_join+0x1cec>
    3f4c:	75d000ef          	jal	4ea8 <printf>
        exit(1);
    3f50:	4505                	li	a0,1
    3f52:	32f000ef          	jal	4a80 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    3f56:	f7240613          	addi	a2,s0,-142
    3f5a:	85ce                	mv	a1,s3
    3f5c:	00003517          	auipc	a0,0x3
    3f60:	e5450513          	addi	a0,a0,-428 # 6db0 <thread_join+0x1d0c>
    3f64:	745000ef          	jal	4ea8 <printf>
        exit(1);
    3f68:	4505                	li	a0,1
    3f6a:	317000ef          	jal	4a80 <exit>
  close(fd);
    3f6e:	854a                	mv	a0,s2
    3f70:	339000ef          	jal	4aa8 <close>
  if(n != N){
    3f74:	02800793          	li	a5,40
    3f78:	00fa9763          	bne	s5,a5,3f86 <concreate+0x154>
    if(((i % 3) == 0 && pid == 0) ||
    3f7c:	4a8d                	li	s5,3
    3f7e:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    3f80:	02800a13          	li	s4,40
    3f84:	a079                	j	4012 <concreate+0x1e0>
    printf("%s: concreate not enough files in directory listing\n", s);
    3f86:	85ce                	mv	a1,s3
    3f88:	00003517          	auipc	a0,0x3
    3f8c:	e5050513          	addi	a0,a0,-432 # 6dd8 <thread_join+0x1d34>
    3f90:	719000ef          	jal	4ea8 <printf>
    exit(1);
    3f94:	4505                	li	a0,1
    3f96:	2eb000ef          	jal	4a80 <exit>
      printf("%s: fork failed\n", s);
    3f9a:	85ce                	mv	a1,s3
    3f9c:	00002517          	auipc	a0,0x2
    3fa0:	a0c50513          	addi	a0,a0,-1524 # 59a8 <thread_join+0x904>
    3fa4:	705000ef          	jal	4ea8 <printf>
      exit(1);
    3fa8:	4505                	li	a0,1
    3faa:	2d7000ef          	jal	4a80 <exit>
      close(open(file, 0));
    3fae:	4581                	li	a1,0
    3fb0:	fa840513          	addi	a0,s0,-88
    3fb4:	30d000ef          	jal	4ac0 <open>
    3fb8:	2f1000ef          	jal	4aa8 <close>
      close(open(file, 0));
    3fbc:	4581                	li	a1,0
    3fbe:	fa840513          	addi	a0,s0,-88
    3fc2:	2ff000ef          	jal	4ac0 <open>
    3fc6:	2e3000ef          	jal	4aa8 <close>
      close(open(file, 0));
    3fca:	4581                	li	a1,0
    3fcc:	fa840513          	addi	a0,s0,-88
    3fd0:	2f1000ef          	jal	4ac0 <open>
    3fd4:	2d5000ef          	jal	4aa8 <close>
      close(open(file, 0));
    3fd8:	4581                	li	a1,0
    3fda:	fa840513          	addi	a0,s0,-88
    3fde:	2e3000ef          	jal	4ac0 <open>
    3fe2:	2c7000ef          	jal	4aa8 <close>
      close(open(file, 0));
    3fe6:	4581                	li	a1,0
    3fe8:	fa840513          	addi	a0,s0,-88
    3fec:	2d5000ef          	jal	4ac0 <open>
    3ff0:	2b9000ef          	jal	4aa8 <close>
      close(open(file, 0));
    3ff4:	4581                	li	a1,0
    3ff6:	fa840513          	addi	a0,s0,-88
    3ffa:	2c7000ef          	jal	4ac0 <open>
    3ffe:	2ab000ef          	jal	4aa8 <close>
    if(pid == 0)
    4002:	06090363          	beqz	s2,4068 <concreate+0x236>
      wait(0);
    4006:	4501                	li	a0,0
    4008:	281000ef          	jal	4a88 <wait>
  for(i = 0; i < N; i++){
    400c:	2485                	addiw	s1,s1,1
    400e:	0b448963          	beq	s1,s4,40c0 <concreate+0x28e>
    file[1] = '0' + i;
    4012:	0304879b          	addiw	a5,s1,48
    4016:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    401a:	25f000ef          	jal	4a78 <fork>
    401e:	892a                	mv	s2,a0
    if(pid < 0){
    4020:	f6054de3          	bltz	a0,3f9a <concreate+0x168>
    if(((i % 3) == 0 && pid == 0) ||
    4024:	0354e73b          	remw	a4,s1,s5
    4028:	00a767b3          	or	a5,a4,a0
    402c:	2781                	sext.w	a5,a5
    402e:	d3c1                	beqz	a5,3fae <concreate+0x17c>
    4030:	01671363          	bne	a4,s6,4036 <concreate+0x204>
       ((i % 3) == 1 && pid != 0)){
    4034:	fd2d                	bnez	a0,3fae <concreate+0x17c>
      unlink(file);
    4036:	fa840513          	addi	a0,s0,-88
    403a:	297000ef          	jal	4ad0 <unlink>
      unlink(file);
    403e:	fa840513          	addi	a0,s0,-88
    4042:	28f000ef          	jal	4ad0 <unlink>
      unlink(file);
    4046:	fa840513          	addi	a0,s0,-88
    404a:	287000ef          	jal	4ad0 <unlink>
      unlink(file);
    404e:	fa840513          	addi	a0,s0,-88
    4052:	27f000ef          	jal	4ad0 <unlink>
      unlink(file);
    4056:	fa840513          	addi	a0,s0,-88
    405a:	277000ef          	jal	4ad0 <unlink>
      unlink(file);
    405e:	fa840513          	addi	a0,s0,-88
    4062:	26f000ef          	jal	4ad0 <unlink>
    4066:	bf71                	j	4002 <concreate+0x1d0>
      exit(0);
    4068:	4501                	li	a0,0
    406a:	217000ef          	jal	4a80 <exit>
      close(fd);
    406e:	23b000ef          	jal	4aa8 <close>
    if(pid == 0) {
    4072:	b599                	j	3eb8 <concreate+0x86>
      close(fd);
    4074:	235000ef          	jal	4aa8 <close>
      wait(&xstatus);
    4078:	f6c40513          	addi	a0,s0,-148
    407c:	20d000ef          	jal	4a88 <wait>
      if(xstatus != 0)
    4080:	f6c42483          	lw	s1,-148(s0)
    4084:	e2049de3          	bnez	s1,3ebe <concreate+0x8c>
  for(i = 0; i < N; i++){
    4088:	2905                	addiw	s2,s2,1
    408a:	e3490de3          	beq	s2,s4,3ec4 <concreate+0x92>
    file[1] = '0' + i;
    408e:	0309079b          	addiw	a5,s2,48
    4092:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    4096:	fa840513          	addi	a0,s0,-88
    409a:	237000ef          	jal	4ad0 <unlink>
    pid = fork();
    409e:	1db000ef          	jal	4a78 <fork>
    if(pid && (i % 3) == 1){
    40a2:	dc050ae3          	beqz	a0,3e76 <concreate+0x44>
    40a6:	036967bb          	remw	a5,s2,s6
    40aa:	dd5780e3          	beq	a5,s5,3e6a <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    40ae:	20200593          	li	a1,514
    40b2:	fa840513          	addi	a0,s0,-88
    40b6:	20b000ef          	jal	4ac0 <open>
      if(fd < 0){
    40ba:	fa055de3          	bgez	a0,4074 <concreate+0x242>
    40be:	bbd1                	j	3e92 <concreate+0x60>
}
    40c0:	60ea                	ld	ra,152(sp)
    40c2:	644a                	ld	s0,144(sp)
    40c4:	64aa                	ld	s1,136(sp)
    40c6:	690a                	ld	s2,128(sp)
    40c8:	79e6                	ld	s3,120(sp)
    40ca:	7a46                	ld	s4,112(sp)
    40cc:	7aa6                	ld	s5,104(sp)
    40ce:	7b06                	ld	s6,96(sp)
    40d0:	6be6                	ld	s7,88(sp)
    40d2:	610d                	addi	sp,sp,160
    40d4:	8082                	ret

00000000000040d6 <bigfile>:
{
    40d6:	7139                	addi	sp,sp,-64
    40d8:	fc06                	sd	ra,56(sp)
    40da:	f822                	sd	s0,48(sp)
    40dc:	f426                	sd	s1,40(sp)
    40de:	f04a                	sd	s2,32(sp)
    40e0:	ec4e                	sd	s3,24(sp)
    40e2:	e852                	sd	s4,16(sp)
    40e4:	e456                	sd	s5,8(sp)
    40e6:	0080                	addi	s0,sp,64
    40e8:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    40ea:	00003517          	auipc	a0,0x3
    40ee:	d2650513          	addi	a0,a0,-730 # 6e10 <thread_join+0x1d6c>
    40f2:	1df000ef          	jal	4ad0 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    40f6:	20200593          	li	a1,514
    40fa:	00003517          	auipc	a0,0x3
    40fe:	d1650513          	addi	a0,a0,-746 # 6e10 <thread_join+0x1d6c>
    4102:	1bf000ef          	jal	4ac0 <open>
    4106:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    4108:	4481                	li	s1,0
    memset(buf, i, SZ);
    410a:	00009917          	auipc	s2,0x9
    410e:	b6e90913          	addi	s2,s2,-1170 # cc78 <buf>
  for(i = 0; i < N; i++){
    4112:	4a51                	li	s4,20
  if(fd < 0){
    4114:	08054663          	bltz	a0,41a0 <bigfile+0xca>
    memset(buf, i, SZ);
    4118:	25800613          	li	a2,600
    411c:	85a6                	mv	a1,s1
    411e:	854a                	mv	a0,s2
    4120:	77a000ef          	jal	489a <memset>
    if(write(fd, buf, SZ) != SZ){
    4124:	25800613          	li	a2,600
    4128:	85ca                	mv	a1,s2
    412a:	854e                	mv	a0,s3
    412c:	175000ef          	jal	4aa0 <write>
    4130:	25800793          	li	a5,600
    4134:	08f51063          	bne	a0,a5,41b4 <bigfile+0xde>
  for(i = 0; i < N; i++){
    4138:	2485                	addiw	s1,s1,1
    413a:	fd449fe3          	bne	s1,s4,4118 <bigfile+0x42>
  close(fd);
    413e:	854e                	mv	a0,s3
    4140:	169000ef          	jal	4aa8 <close>
  fd = open("bigfile.dat", 0);
    4144:	4581                	li	a1,0
    4146:	00003517          	auipc	a0,0x3
    414a:	cca50513          	addi	a0,a0,-822 # 6e10 <thread_join+0x1d6c>
    414e:	173000ef          	jal	4ac0 <open>
    4152:	8a2a                	mv	s4,a0
  total = 0;
    4154:	4981                	li	s3,0
  for(i = 0; ; i++){
    4156:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    4158:	00009917          	auipc	s2,0x9
    415c:	b2090913          	addi	s2,s2,-1248 # cc78 <buf>
  if(fd < 0){
    4160:	06054463          	bltz	a0,41c8 <bigfile+0xf2>
    cc = read(fd, buf, SZ/2);
    4164:	12c00613          	li	a2,300
    4168:	85ca                	mv	a1,s2
    416a:	8552                	mv	a0,s4
    416c:	12d000ef          	jal	4a98 <read>
    if(cc < 0){
    4170:	06054663          	bltz	a0,41dc <bigfile+0x106>
    if(cc == 0)
    4174:	c155                	beqz	a0,4218 <bigfile+0x142>
    if(cc != SZ/2){
    4176:	12c00793          	li	a5,300
    417a:	06f51b63          	bne	a0,a5,41f0 <bigfile+0x11a>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    417e:	01f4d79b          	srliw	a5,s1,0x1f
    4182:	9fa5                	addw	a5,a5,s1
    4184:	4017d79b          	sraiw	a5,a5,0x1
    4188:	00094703          	lbu	a4,0(s2)
    418c:	06f71c63          	bne	a4,a5,4204 <bigfile+0x12e>
    4190:	12b94703          	lbu	a4,299(s2)
    4194:	06f71863          	bne	a4,a5,4204 <bigfile+0x12e>
    total += cc;
    4198:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    419c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    419e:	b7d9                	j	4164 <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    41a0:	85d6                	mv	a1,s5
    41a2:	00003517          	auipc	a0,0x3
    41a6:	c7e50513          	addi	a0,a0,-898 # 6e20 <thread_join+0x1d7c>
    41aa:	4ff000ef          	jal	4ea8 <printf>
    exit(1);
    41ae:	4505                	li	a0,1
    41b0:	0d1000ef          	jal	4a80 <exit>
      printf("%s: write bigfile failed\n", s);
    41b4:	85d6                	mv	a1,s5
    41b6:	00003517          	auipc	a0,0x3
    41ba:	c8a50513          	addi	a0,a0,-886 # 6e40 <thread_join+0x1d9c>
    41be:	4eb000ef          	jal	4ea8 <printf>
      exit(1);
    41c2:	4505                	li	a0,1
    41c4:	0bd000ef          	jal	4a80 <exit>
    printf("%s: cannot open bigfile\n", s);
    41c8:	85d6                	mv	a1,s5
    41ca:	00003517          	auipc	a0,0x3
    41ce:	c9650513          	addi	a0,a0,-874 # 6e60 <thread_join+0x1dbc>
    41d2:	4d7000ef          	jal	4ea8 <printf>
    exit(1);
    41d6:	4505                	li	a0,1
    41d8:	0a9000ef          	jal	4a80 <exit>
      printf("%s: read bigfile failed\n", s);
    41dc:	85d6                	mv	a1,s5
    41de:	00003517          	auipc	a0,0x3
    41e2:	ca250513          	addi	a0,a0,-862 # 6e80 <thread_join+0x1ddc>
    41e6:	4c3000ef          	jal	4ea8 <printf>
      exit(1);
    41ea:	4505                	li	a0,1
    41ec:	095000ef          	jal	4a80 <exit>
      printf("%s: short read bigfile\n", s);
    41f0:	85d6                	mv	a1,s5
    41f2:	00003517          	auipc	a0,0x3
    41f6:	cae50513          	addi	a0,a0,-850 # 6ea0 <thread_join+0x1dfc>
    41fa:	4af000ef          	jal	4ea8 <printf>
      exit(1);
    41fe:	4505                	li	a0,1
    4200:	081000ef          	jal	4a80 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4204:	85d6                	mv	a1,s5
    4206:	00003517          	auipc	a0,0x3
    420a:	cb250513          	addi	a0,a0,-846 # 6eb8 <thread_join+0x1e14>
    420e:	49b000ef          	jal	4ea8 <printf>
      exit(1);
    4212:	4505                	li	a0,1
    4214:	06d000ef          	jal	4a80 <exit>
  close(fd);
    4218:	8552                	mv	a0,s4
    421a:	08f000ef          	jal	4aa8 <close>
  if(total != N*SZ){
    421e:	678d                	lui	a5,0x3
    4220:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x304>
    4224:	02f99163          	bne	s3,a5,4246 <bigfile+0x170>
  unlink("bigfile.dat");
    4228:	00003517          	auipc	a0,0x3
    422c:	be850513          	addi	a0,a0,-1048 # 6e10 <thread_join+0x1d6c>
    4230:	0a1000ef          	jal	4ad0 <unlink>
}
    4234:	70e2                	ld	ra,56(sp)
    4236:	7442                	ld	s0,48(sp)
    4238:	74a2                	ld	s1,40(sp)
    423a:	7902                	ld	s2,32(sp)
    423c:	69e2                	ld	s3,24(sp)
    423e:	6a42                	ld	s4,16(sp)
    4240:	6aa2                	ld	s5,8(sp)
    4242:	6121                	addi	sp,sp,64
    4244:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4246:	85d6                	mv	a1,s5
    4248:	00003517          	auipc	a0,0x3
    424c:	c9050513          	addi	a0,a0,-880 # 6ed8 <thread_join+0x1e34>
    4250:	459000ef          	jal	4ea8 <printf>
    exit(1);
    4254:	4505                	li	a0,1
    4256:	02b000ef          	jal	4a80 <exit>

000000000000425a <bigargtest>:
{
    425a:	7121                	addi	sp,sp,-448
    425c:	ff06                	sd	ra,440(sp)
    425e:	fb22                	sd	s0,432(sp)
    4260:	f726                	sd	s1,424(sp)
    4262:	0380                	addi	s0,sp,448
    4264:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4266:	00003517          	auipc	a0,0x3
    426a:	c9250513          	addi	a0,a0,-878 # 6ef8 <thread_join+0x1e54>
    426e:	063000ef          	jal	4ad0 <unlink>
  pid = fork();
    4272:	007000ef          	jal	4a78 <fork>
  if(pid == 0){
    4276:	c915                	beqz	a0,42aa <bigargtest+0x50>
  } else if(pid < 0){
    4278:	08054a63          	bltz	a0,430c <bigargtest+0xb2>
  wait(&xstatus);
    427c:	fdc40513          	addi	a0,s0,-36
    4280:	009000ef          	jal	4a88 <wait>
  if(xstatus != 0)
    4284:	fdc42503          	lw	a0,-36(s0)
    4288:	ed41                	bnez	a0,4320 <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    428a:	4581                	li	a1,0
    428c:	00003517          	auipc	a0,0x3
    4290:	c6c50513          	addi	a0,a0,-916 # 6ef8 <thread_join+0x1e54>
    4294:	02d000ef          	jal	4ac0 <open>
  if(fd < 0){
    4298:	08054663          	bltz	a0,4324 <bigargtest+0xca>
  close(fd);
    429c:	00d000ef          	jal	4aa8 <close>
}
    42a0:	70fa                	ld	ra,440(sp)
    42a2:	745a                	ld	s0,432(sp)
    42a4:	74ba                	ld	s1,424(sp)
    42a6:	6139                	addi	sp,sp,448
    42a8:	8082                	ret
    memset(big, ' ', sizeof(big));
    42aa:	19000613          	li	a2,400
    42ae:	02000593          	li	a1,32
    42b2:	e4840513          	addi	a0,s0,-440
    42b6:	5e4000ef          	jal	489a <memset>
    big[sizeof(big)-1] = '\0';
    42ba:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    42be:	00005797          	auipc	a5,0x5
    42c2:	1a278793          	addi	a5,a5,418 # 9460 <args.1>
    42c6:	00005697          	auipc	a3,0x5
    42ca:	29268693          	addi	a3,a3,658 # 9558 <args.1+0xf8>
      args[i] = big;
    42ce:	e4840713          	addi	a4,s0,-440
    42d2:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    42d4:	07a1                	addi	a5,a5,8
    42d6:	fed79ee3          	bne	a5,a3,42d2 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    42da:	00005597          	auipc	a1,0x5
    42de:	18658593          	addi	a1,a1,390 # 9460 <args.1>
    42e2:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    42e6:	00001517          	auipc	a0,0x1
    42ea:	e3250513          	addi	a0,a0,-462 # 5118 <thread_join+0x74>
    42ee:	7ca000ef          	jal	4ab8 <exec>
    fd = open("bigarg-ok", O_CREATE);
    42f2:	20000593          	li	a1,512
    42f6:	00003517          	auipc	a0,0x3
    42fa:	c0250513          	addi	a0,a0,-1022 # 6ef8 <thread_join+0x1e54>
    42fe:	7c2000ef          	jal	4ac0 <open>
    close(fd);
    4302:	7a6000ef          	jal	4aa8 <close>
    exit(0);
    4306:	4501                	li	a0,0
    4308:	778000ef          	jal	4a80 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    430c:	85a6                	mv	a1,s1
    430e:	00003517          	auipc	a0,0x3
    4312:	bfa50513          	addi	a0,a0,-1030 # 6f08 <thread_join+0x1e64>
    4316:	393000ef          	jal	4ea8 <printf>
    exit(1);
    431a:	4505                	li	a0,1
    431c:	764000ef          	jal	4a80 <exit>
    exit(xstatus);
    4320:	760000ef          	jal	4a80 <exit>
    printf("%s: bigarg test failed!\n", s);
    4324:	85a6                	mv	a1,s1
    4326:	00003517          	auipc	a0,0x3
    432a:	c0250513          	addi	a0,a0,-1022 # 6f28 <thread_join+0x1e84>
    432e:	37b000ef          	jal	4ea8 <printf>
    exit(1);
    4332:	4505                	li	a0,1
    4334:	74c000ef          	jal	4a80 <exit>

0000000000004338 <fsfull>:
{
    4338:	7135                	addi	sp,sp,-160
    433a:	ed06                	sd	ra,152(sp)
    433c:	e922                	sd	s0,144(sp)
    433e:	e526                	sd	s1,136(sp)
    4340:	e14a                	sd	s2,128(sp)
    4342:	fcce                	sd	s3,120(sp)
    4344:	f8d2                	sd	s4,112(sp)
    4346:	f4d6                	sd	s5,104(sp)
    4348:	f0da                	sd	s6,96(sp)
    434a:	ecde                	sd	s7,88(sp)
    434c:	e8e2                	sd	s8,80(sp)
    434e:	e4e6                	sd	s9,72(sp)
    4350:	e0ea                	sd	s10,64(sp)
    4352:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    4354:	00003517          	auipc	a0,0x3
    4358:	bf450513          	addi	a0,a0,-1036 # 6f48 <thread_join+0x1ea4>
    435c:	34d000ef          	jal	4ea8 <printf>
  for(nfiles = 0; ; nfiles++){
    4360:	4481                	li	s1,0
    name[0] = 'f';
    4362:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    4366:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    436a:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    436e:	4b29                	li	s6,10
    printf("writing %s\n", name);
    4370:	00003c97          	auipc	s9,0x3
    4374:	be8c8c93          	addi	s9,s9,-1048 # 6f58 <thread_join+0x1eb4>
    name[0] = 'f';
    4378:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    437c:	0384c7bb          	divw	a5,s1,s8
    4380:	0307879b          	addiw	a5,a5,48
    4384:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4388:	0384e7bb          	remw	a5,s1,s8
    438c:	0377c7bb          	divw	a5,a5,s7
    4390:	0307879b          	addiw	a5,a5,48
    4394:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4398:	0374e7bb          	remw	a5,s1,s7
    439c:	0367c7bb          	divw	a5,a5,s6
    43a0:	0307879b          	addiw	a5,a5,48
    43a4:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    43a8:	0364e7bb          	remw	a5,s1,s6
    43ac:	0307879b          	addiw	a5,a5,48
    43b0:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    43b4:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    43b8:	f6040593          	addi	a1,s0,-160
    43bc:	8566                	mv	a0,s9
    43be:	2eb000ef          	jal	4ea8 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    43c2:	20200593          	li	a1,514
    43c6:	f6040513          	addi	a0,s0,-160
    43ca:	6f6000ef          	jal	4ac0 <open>
    43ce:	892a                	mv	s2,a0
    if(fd < 0){
    43d0:	08055f63          	bgez	a0,446e <fsfull+0x136>
      printf("open %s failed\n", name);
    43d4:	f6040593          	addi	a1,s0,-160
    43d8:	00003517          	auipc	a0,0x3
    43dc:	b9050513          	addi	a0,a0,-1136 # 6f68 <thread_join+0x1ec4>
    43e0:	2c9000ef          	jal	4ea8 <printf>
  while(nfiles >= 0){
    43e4:	0604c163          	bltz	s1,4446 <fsfull+0x10e>
    name[0] = 'f';
    43e8:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    43ec:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    43f0:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    43f4:	4929                	li	s2,10
  while(nfiles >= 0){
    43f6:	5afd                	li	s5,-1
    name[0] = 'f';
    43f8:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    43fc:	0344c7bb          	divw	a5,s1,s4
    4400:	0307879b          	addiw	a5,a5,48
    4404:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4408:	0344e7bb          	remw	a5,s1,s4
    440c:	0337c7bb          	divw	a5,a5,s3
    4410:	0307879b          	addiw	a5,a5,48
    4414:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4418:	0334e7bb          	remw	a5,s1,s3
    441c:	0327c7bb          	divw	a5,a5,s2
    4420:	0307879b          	addiw	a5,a5,48
    4424:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    4428:	0324e7bb          	remw	a5,s1,s2
    442c:	0307879b          	addiw	a5,a5,48
    4430:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    4434:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    4438:	f6040513          	addi	a0,s0,-160
    443c:	694000ef          	jal	4ad0 <unlink>
    nfiles--;
    4440:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4442:	fb549be3          	bne	s1,s5,43f8 <fsfull+0xc0>
  printf("fsfull test finished\n");
    4446:	00003517          	auipc	a0,0x3
    444a:	b4250513          	addi	a0,a0,-1214 # 6f88 <thread_join+0x1ee4>
    444e:	25b000ef          	jal	4ea8 <printf>
}
    4452:	60ea                	ld	ra,152(sp)
    4454:	644a                	ld	s0,144(sp)
    4456:	64aa                	ld	s1,136(sp)
    4458:	690a                	ld	s2,128(sp)
    445a:	79e6                	ld	s3,120(sp)
    445c:	7a46                	ld	s4,112(sp)
    445e:	7aa6                	ld	s5,104(sp)
    4460:	7b06                	ld	s6,96(sp)
    4462:	6be6                	ld	s7,88(sp)
    4464:	6c46                	ld	s8,80(sp)
    4466:	6ca6                	ld	s9,72(sp)
    4468:	6d06                	ld	s10,64(sp)
    446a:	610d                	addi	sp,sp,160
    446c:	8082                	ret
    int total = 0;
    446e:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4470:	00009a97          	auipc	s5,0x9
    4474:	808a8a93          	addi	s5,s5,-2040 # cc78 <buf>
      if(cc < BSIZE)
    4478:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    447c:	40000613          	li	a2,1024
    4480:	85d6                	mv	a1,s5
    4482:	854a                	mv	a0,s2
    4484:	61c000ef          	jal	4aa0 <write>
      if(cc < BSIZE)
    4488:	00aa5563          	bge	s4,a0,4492 <fsfull+0x15a>
      total += cc;
    448c:	00a989bb          	addw	s3,s3,a0
    while(1){
    4490:	b7f5                	j	447c <fsfull+0x144>
    printf("wrote %d bytes\n", total);
    4492:	85ce                	mv	a1,s3
    4494:	00003517          	auipc	a0,0x3
    4498:	ae450513          	addi	a0,a0,-1308 # 6f78 <thread_join+0x1ed4>
    449c:	20d000ef          	jal	4ea8 <printf>
    close(fd);
    44a0:	854a                	mv	a0,s2
    44a2:	606000ef          	jal	4aa8 <close>
    if(total == 0)
    44a6:	f2098fe3          	beqz	s3,43e4 <fsfull+0xac>
  for(nfiles = 0; ; nfiles++){
    44aa:	2485                	addiw	s1,s1,1
    44ac:	b5f1                	j	4378 <fsfull+0x40>

00000000000044ae <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    44ae:	7179                	addi	sp,sp,-48
    44b0:	f406                	sd	ra,40(sp)
    44b2:	f022                	sd	s0,32(sp)
    44b4:	ec26                	sd	s1,24(sp)
    44b6:	e84a                	sd	s2,16(sp)
    44b8:	1800                	addi	s0,sp,48
    44ba:	84aa                	mv	s1,a0
    44bc:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    44be:	00003517          	auipc	a0,0x3
    44c2:	ae250513          	addi	a0,a0,-1310 # 6fa0 <thread_join+0x1efc>
    44c6:	1e3000ef          	jal	4ea8 <printf>
  if((pid = fork()) < 0) {
    44ca:	5ae000ef          	jal	4a78 <fork>
    44ce:	02054a63          	bltz	a0,4502 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    44d2:	c129                	beqz	a0,4514 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    44d4:	fdc40513          	addi	a0,s0,-36
    44d8:	5b0000ef          	jal	4a88 <wait>
    if(xstatus != 0) 
    44dc:	fdc42783          	lw	a5,-36(s0)
    44e0:	cf9d                	beqz	a5,451e <run+0x70>
      printf("FAILED\n");
    44e2:	00003517          	auipc	a0,0x3
    44e6:	ae650513          	addi	a0,a0,-1306 # 6fc8 <thread_join+0x1f24>
    44ea:	1bf000ef          	jal	4ea8 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    44ee:	fdc42503          	lw	a0,-36(s0)
  }
}
    44f2:	00153513          	seqz	a0,a0
    44f6:	70a2                	ld	ra,40(sp)
    44f8:	7402                	ld	s0,32(sp)
    44fa:	64e2                	ld	s1,24(sp)
    44fc:	6942                	ld	s2,16(sp)
    44fe:	6145                	addi	sp,sp,48
    4500:	8082                	ret
    printf("runtest: fork error\n");
    4502:	00003517          	auipc	a0,0x3
    4506:	aae50513          	addi	a0,a0,-1362 # 6fb0 <thread_join+0x1f0c>
    450a:	19f000ef          	jal	4ea8 <printf>
    exit(1);
    450e:	4505                	li	a0,1
    4510:	570000ef          	jal	4a80 <exit>
    f(s);
    4514:	854a                	mv	a0,s2
    4516:	9482                	jalr	s1
    exit(0);
    4518:	4501                	li	a0,0
    451a:	566000ef          	jal	4a80 <exit>
      printf("OK\n");
    451e:	00003517          	auipc	a0,0x3
    4522:	ab250513          	addi	a0,a0,-1358 # 6fd0 <thread_join+0x1f2c>
    4526:	183000ef          	jal	4ea8 <printf>
    452a:	b7d1                	j	44ee <run+0x40>

000000000000452c <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    452c:	7139                	addi	sp,sp,-64
    452e:	fc06                	sd	ra,56(sp)
    4530:	f822                	sd	s0,48(sp)
    4532:	f04a                	sd	s2,32(sp)
    4534:	0080                	addi	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
    4536:	00853903          	ld	s2,8(a0)
    453a:	06090463          	beqz	s2,45a2 <runtests+0x76>
    453e:	f426                	sd	s1,40(sp)
    4540:	ec4e                	sd	s3,24(sp)
    4542:	e852                	sd	s4,16(sp)
    4544:	e456                	sd	s5,8(sp)
    4546:	84aa                	mv	s1,a0
    4548:	89ae                	mv	s3,a1
    454a:	8a32                	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    454c:	4a89                	li	s5,2
    454e:	a031                	j	455a <runtests+0x2e>
  for (struct test *t = tests; t->s != 0; t++) {
    4550:	04c1                	addi	s1,s1,16
    4552:	0084b903          	ld	s2,8(s1)
    4556:	02090c63          	beqz	s2,458e <runtests+0x62>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    455a:	00098763          	beqz	s3,4568 <runtests+0x3c>
    455e:	85ce                	mv	a1,s3
    4560:	854a                	mv	a0,s2
    4562:	2e2000ef          	jal	4844 <strcmp>
    4566:	f56d                	bnez	a0,4550 <runtests+0x24>
      if(!run(t->f, t->s)){
    4568:	85ca                	mv	a1,s2
    456a:	6088                	ld	a0,0(s1)
    456c:	f43ff0ef          	jal	44ae <run>
    4570:	f165                	bnez	a0,4550 <runtests+0x24>
        if(continuous != 2){
    4572:	fd5a0fe3          	beq	s4,s5,4550 <runtests+0x24>
          printf("SOME TESTS FAILED\n");
    4576:	00003517          	auipc	a0,0x3
    457a:	a6250513          	addi	a0,a0,-1438 # 6fd8 <thread_join+0x1f34>
    457e:	12b000ef          	jal	4ea8 <printf>
          return 1;
    4582:	4505                	li	a0,1
    4584:	74a2                	ld	s1,40(sp)
    4586:	69e2                	ld	s3,24(sp)
    4588:	6a42                	ld	s4,16(sp)
    458a:	6aa2                	ld	s5,8(sp)
    458c:	a031                	j	4598 <runtests+0x6c>
        }
      }
    }
  }
  return 0;
    458e:	4501                	li	a0,0
    4590:	74a2                	ld	s1,40(sp)
    4592:	69e2                	ld	s3,24(sp)
    4594:	6a42                	ld	s4,16(sp)
    4596:	6aa2                	ld	s5,8(sp)
}
    4598:	70e2                	ld	ra,56(sp)
    459a:	7442                	ld	s0,48(sp)
    459c:	7902                	ld	s2,32(sp)
    459e:	6121                	addi	sp,sp,64
    45a0:	8082                	ret
  return 0;
    45a2:	4501                	li	a0,0
    45a4:	bfd5                	j	4598 <runtests+0x6c>

00000000000045a6 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    45a6:	7139                	addi	sp,sp,-64
    45a8:	fc06                	sd	ra,56(sp)
    45aa:	f822                	sd	s0,48(sp)
    45ac:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    45ae:	fc840513          	addi	a0,s0,-56
    45b2:	4de000ef          	jal	4a90 <pipe>
    45b6:	04054e63          	bltz	a0,4612 <countfree+0x6c>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    45ba:	4be000ef          	jal	4a78 <fork>

  if(pid < 0){
    45be:	06054663          	bltz	a0,462a <countfree+0x84>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    45c2:	e159                	bnez	a0,4648 <countfree+0xa2>
    45c4:	f426                	sd	s1,40(sp)
    45c6:	f04a                	sd	s2,32(sp)
    45c8:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    45ca:	fc842503          	lw	a0,-56(s0)
    45ce:	4da000ef          	jal	4aa8 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    45d2:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    45d4:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    45d6:	00001997          	auipc	s3,0x1
    45da:	bb298993          	addi	s3,s3,-1102 # 5188 <thread_join+0xe4>
      uint64 a = (uint64) sbrk(4096);
    45de:	6505                	lui	a0,0x1
    45e0:	528000ef          	jal	4b08 <sbrk>
      if(a == 0xffffffffffffffff){
    45e4:	05250f63          	beq	a0,s2,4642 <countfree+0x9c>
      *(char *)(a + 4096 - 1) = 1;
    45e8:	6785                	lui	a5,0x1
    45ea:	97aa                	add	a5,a5,a0
    45ec:	fe978fa3          	sb	s1,-1(a5) # fff <pgbug+0x2b>
      if(write(fds[1], "x", 1) != 1){
    45f0:	8626                	mv	a2,s1
    45f2:	85ce                	mv	a1,s3
    45f4:	fcc42503          	lw	a0,-52(s0)
    45f8:	4a8000ef          	jal	4aa0 <write>
    45fc:	fe9501e3          	beq	a0,s1,45de <countfree+0x38>
        printf("write() failed in countfree()\n");
    4600:	00003517          	auipc	a0,0x3
    4604:	a3050513          	addi	a0,a0,-1488 # 7030 <thread_join+0x1f8c>
    4608:	0a1000ef          	jal	4ea8 <printf>
        exit(1);
    460c:	4505                	li	a0,1
    460e:	472000ef          	jal	4a80 <exit>
    4612:	f426                	sd	s1,40(sp)
    4614:	f04a                	sd	s2,32(sp)
    4616:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    4618:	00003517          	auipc	a0,0x3
    461c:	9d850513          	addi	a0,a0,-1576 # 6ff0 <thread_join+0x1f4c>
    4620:	089000ef          	jal	4ea8 <printf>
    exit(1);
    4624:	4505                	li	a0,1
    4626:	45a000ef          	jal	4a80 <exit>
    462a:	f426                	sd	s1,40(sp)
    462c:	f04a                	sd	s2,32(sp)
    462e:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    4630:	00003517          	auipc	a0,0x3
    4634:	9e050513          	addi	a0,a0,-1568 # 7010 <thread_join+0x1f6c>
    4638:	071000ef          	jal	4ea8 <printf>
    exit(1);
    463c:	4505                	li	a0,1
    463e:	442000ef          	jal	4a80 <exit>
      }
    }

    exit(0);
    4642:	4501                	li	a0,0
    4644:	43c000ef          	jal	4a80 <exit>
    4648:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    464a:	fcc42503          	lw	a0,-52(s0)
    464e:	45a000ef          	jal	4aa8 <close>

  int n = 0;
    4652:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    4654:	4605                	li	a2,1
    4656:	fc740593          	addi	a1,s0,-57
    465a:	fc842503          	lw	a0,-56(s0)
    465e:	43a000ef          	jal	4a98 <read>
    if(cc < 0){
    4662:	00054563          	bltz	a0,466c <countfree+0xc6>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    4666:	cd11                	beqz	a0,4682 <countfree+0xdc>
      break;
    n += 1;
    4668:	2485                	addiw	s1,s1,1
  while(1){
    466a:	b7ed                	j	4654 <countfree+0xae>
    466c:	f04a                	sd	s2,32(sp)
    466e:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    4670:	00003517          	auipc	a0,0x3
    4674:	9e050513          	addi	a0,a0,-1568 # 7050 <thread_join+0x1fac>
    4678:	031000ef          	jal	4ea8 <printf>
      exit(1);
    467c:	4505                	li	a0,1
    467e:	402000ef          	jal	4a80 <exit>
  }

  close(fds[0]);
    4682:	fc842503          	lw	a0,-56(s0)
    4686:	422000ef          	jal	4aa8 <close>
  wait((int*)0);
    468a:	4501                	li	a0,0
    468c:	3fc000ef          	jal	4a88 <wait>
  
  return n;
}
    4690:	8526                	mv	a0,s1
    4692:	74a2                	ld	s1,40(sp)
    4694:	70e2                	ld	ra,56(sp)
    4696:	7442                	ld	s0,48(sp)
    4698:	6121                	addi	sp,sp,64
    469a:	8082                	ret

000000000000469c <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    469c:	711d                	addi	sp,sp,-96
    469e:	ec86                	sd	ra,88(sp)
    46a0:	e8a2                	sd	s0,80(sp)
    46a2:	e4a6                	sd	s1,72(sp)
    46a4:	e0ca                	sd	s2,64(sp)
    46a6:	fc4e                	sd	s3,56(sp)
    46a8:	f852                	sd	s4,48(sp)
    46aa:	f456                	sd	s5,40(sp)
    46ac:	f05a                	sd	s6,32(sp)
    46ae:	ec5e                	sd	s7,24(sp)
    46b0:	e862                	sd	s8,16(sp)
    46b2:	e466                	sd	s9,8(sp)
    46b4:	e06a                	sd	s10,0(sp)
    46b6:	1080                	addi	s0,sp,96
    46b8:	8aaa                	mv	s5,a0
    46ba:	892e                	mv	s2,a1
    46bc:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    46be:	00003b97          	auipc	s7,0x3
    46c2:	9b2b8b93          	addi	s7,s7,-1614 # 7070 <thread_join+0x1fcc>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    46c6:	00005b17          	auipc	s6,0x5
    46ca:	94ab0b13          	addi	s6,s6,-1718 # 9010 <quicktests>
      if(continuous != 2) {
    46ce:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    46d0:	00005c17          	auipc	s8,0x5
    46d4:	d10c0c13          	addi	s8,s8,-752 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    46d8:	00003d17          	auipc	s10,0x3
    46dc:	9b0d0d13          	addi	s10,s10,-1616 # 7088 <thread_join+0x1fe4>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    46e0:	00003c97          	auipc	s9,0x3
    46e4:	9c8c8c93          	addi	s9,s9,-1592 # 70a8 <thread_join+0x2004>
    46e8:	a819                	j	46fe <drivetests+0x62>
        printf("usertests slow tests starting\n");
    46ea:	856a                	mv	a0,s10
    46ec:	7bc000ef          	jal	4ea8 <printf>
    46f0:	a80d                	j	4722 <drivetests+0x86>
    if((free1 = countfree()) < free0) {
    46f2:	eb5ff0ef          	jal	45a6 <countfree>
    46f6:	04954063          	blt	a0,s1,4736 <drivetests+0x9a>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    46fa:	04090963          	beqz	s2,474c <drivetests+0xb0>
    printf("usertests starting\n");
    46fe:	855e                	mv	a0,s7
    4700:	7a8000ef          	jal	4ea8 <printf>
    int free0 = countfree();
    4704:	ea3ff0ef          	jal	45a6 <countfree>
    4708:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    470a:	864a                	mv	a2,s2
    470c:	85ce                	mv	a1,s3
    470e:	855a                	mv	a0,s6
    4710:	e1dff0ef          	jal	452c <runtests>
    4714:	c119                	beqz	a0,471a <drivetests+0x7e>
      if(continuous != 2) {
    4716:	03491963          	bne	s2,s4,4748 <drivetests+0xac>
    if(!quick) {
    471a:	fc0a9ce3          	bnez	s5,46f2 <drivetests+0x56>
      if (justone == 0)
    471e:	fc0986e3          	beqz	s3,46ea <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    4722:	864a                	mv	a2,s2
    4724:	85ce                	mv	a1,s3
    4726:	8562                	mv	a0,s8
    4728:	e05ff0ef          	jal	452c <runtests>
    472c:	d179                	beqz	a0,46f2 <drivetests+0x56>
        if(continuous != 2) {
    472e:	fd4902e3          	beq	s2,s4,46f2 <drivetests+0x56>
          return 1;
    4732:	4505                	li	a0,1
    4734:	a829                	j	474e <drivetests+0xb2>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4736:	8626                	mv	a2,s1
    4738:	85aa                	mv	a1,a0
    473a:	8566                	mv	a0,s9
    473c:	76c000ef          	jal	4ea8 <printf>
      if(continuous != 2) {
    4740:	fb490fe3          	beq	s2,s4,46fe <drivetests+0x62>
        return 1;
    4744:	4505                	li	a0,1
    4746:	a021                	j	474e <drivetests+0xb2>
        return 1;
    4748:	4505                	li	a0,1
    474a:	a011                	j	474e <drivetests+0xb2>
  return 0;
    474c:	854a                	mv	a0,s2
}
    474e:	60e6                	ld	ra,88(sp)
    4750:	6446                	ld	s0,80(sp)
    4752:	64a6                	ld	s1,72(sp)
    4754:	6906                	ld	s2,64(sp)
    4756:	79e2                	ld	s3,56(sp)
    4758:	7a42                	ld	s4,48(sp)
    475a:	7aa2                	ld	s5,40(sp)
    475c:	7b02                	ld	s6,32(sp)
    475e:	6be2                	ld	s7,24(sp)
    4760:	6c42                	ld	s8,16(sp)
    4762:	6ca2                	ld	s9,8(sp)
    4764:	6d02                	ld	s10,0(sp)
    4766:	6125                	addi	sp,sp,96
    4768:	8082                	ret

000000000000476a <main>:

int
main(int argc, char *argv[])
{
    476a:	1101                	addi	sp,sp,-32
    476c:	ec06                	sd	ra,24(sp)
    476e:	e822                	sd	s0,16(sp)
    4770:	e426                	sd	s1,8(sp)
    4772:	e04a                	sd	s2,0(sp)
    4774:	1000                	addi	s0,sp,32
    4776:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4778:	4789                	li	a5,2
    477a:	00f50f63          	beq	a0,a5,4798 <main+0x2e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    477e:	4785                	li	a5,1
    4780:	06a7c063          	blt	a5,a0,47e0 <main+0x76>
  char *justone = 0;
    4784:	4901                	li	s2,0
  int quick = 0;
    4786:	4501                	li	a0,0
  int continuous = 0;
    4788:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    478a:	864a                	mv	a2,s2
    478c:	f11ff0ef          	jal	469c <drivetests>
    4790:	c935                	beqz	a0,4804 <main+0x9a>
    exit(1);
    4792:	4505                	li	a0,1
    4794:	2ec000ef          	jal	4a80 <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4798:	0085b903          	ld	s2,8(a1)
    479c:	00003597          	auipc	a1,0x3
    47a0:	93c58593          	addi	a1,a1,-1732 # 70d8 <thread_join+0x2034>
    47a4:	854a                	mv	a0,s2
    47a6:	09e000ef          	jal	4844 <strcmp>
    47aa:	85aa                	mv	a1,a0
    47ac:	c139                	beqz	a0,47f2 <main+0x88>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    47ae:	00003597          	auipc	a1,0x3
    47b2:	93258593          	addi	a1,a1,-1742 # 70e0 <thread_join+0x203c>
    47b6:	854a                	mv	a0,s2
    47b8:	08c000ef          	jal	4844 <strcmp>
    47bc:	cd15                	beqz	a0,47f8 <main+0x8e>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    47be:	00003597          	auipc	a1,0x3
    47c2:	92a58593          	addi	a1,a1,-1750 # 70e8 <thread_join+0x2044>
    47c6:	854a                	mv	a0,s2
    47c8:	07c000ef          	jal	4844 <strcmp>
    47cc:	c90d                	beqz	a0,47fe <main+0x94>
  } else if(argc == 2 && argv[1][0] != '-'){
    47ce:	00094703          	lbu	a4,0(s2)
    47d2:	02d00793          	li	a5,45
    47d6:	00f70563          	beq	a4,a5,47e0 <main+0x76>
  int quick = 0;
    47da:	4501                	li	a0,0
  int continuous = 0;
    47dc:	4581                	li	a1,0
    47de:	b775                	j	478a <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    47e0:	00003517          	auipc	a0,0x3
    47e4:	91050513          	addi	a0,a0,-1776 # 70f0 <thread_join+0x204c>
    47e8:	6c0000ef          	jal	4ea8 <printf>
    exit(1);
    47ec:	4505                	li	a0,1
    47ee:	292000ef          	jal	4a80 <exit>
  char *justone = 0;
    47f2:	4901                	li	s2,0
    quick = 1;
    47f4:	4505                	li	a0,1
    47f6:	bf51                	j	478a <main+0x20>
  char *justone = 0;
    47f8:	4901                	li	s2,0
    continuous = 1;
    47fa:	4585                	li	a1,1
    47fc:	b779                	j	478a <main+0x20>
    continuous = 2;
    47fe:	85a6                	mv	a1,s1
  char *justone = 0;
    4800:	4901                	li	s2,0
    4802:	b761                	j	478a <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4804:	00003517          	auipc	a0,0x3
    4808:	91c50513          	addi	a0,a0,-1764 # 7120 <thread_join+0x207c>
    480c:	69c000ef          	jal	4ea8 <printf>
  exit(0);
    4810:	4501                	li	a0,0
    4812:	26e000ef          	jal	4a80 <exit>

0000000000004816 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    4816:	1141                	addi	sp,sp,-16
    4818:	e406                	sd	ra,8(sp)
    481a:	e022                	sd	s0,0(sp)
    481c:	0800                	addi	s0,sp,16
  extern int main();
  main();
    481e:	f4dff0ef          	jal	476a <main>
  exit(0);
    4822:	4501                	li	a0,0
    4824:	25c000ef          	jal	4a80 <exit>

0000000000004828 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4828:	1141                	addi	sp,sp,-16
    482a:	e422                	sd	s0,8(sp)
    482c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    482e:	87aa                	mv	a5,a0
    4830:	0585                	addi	a1,a1,1
    4832:	0785                	addi	a5,a5,1
    4834:	fff5c703          	lbu	a4,-1(a1)
    4838:	fee78fa3          	sb	a4,-1(a5)
    483c:	fb75                	bnez	a4,4830 <strcpy+0x8>
    ;
  return os;
}
    483e:	6422                	ld	s0,8(sp)
    4840:	0141                	addi	sp,sp,16
    4842:	8082                	ret

0000000000004844 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4844:	1141                	addi	sp,sp,-16
    4846:	e422                	sd	s0,8(sp)
    4848:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    484a:	00054783          	lbu	a5,0(a0)
    484e:	cb91                	beqz	a5,4862 <strcmp+0x1e>
    4850:	0005c703          	lbu	a4,0(a1)
    4854:	00f71763          	bne	a4,a5,4862 <strcmp+0x1e>
    p++, q++;
    4858:	0505                	addi	a0,a0,1
    485a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    485c:	00054783          	lbu	a5,0(a0)
    4860:	fbe5                	bnez	a5,4850 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    4862:	0005c503          	lbu	a0,0(a1)
}
    4866:	40a7853b          	subw	a0,a5,a0
    486a:	6422                	ld	s0,8(sp)
    486c:	0141                	addi	sp,sp,16
    486e:	8082                	ret

0000000000004870 <strlen>:

uint
strlen(const char *s)
{
    4870:	1141                	addi	sp,sp,-16
    4872:	e422                	sd	s0,8(sp)
    4874:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4876:	00054783          	lbu	a5,0(a0)
    487a:	cf91                	beqz	a5,4896 <strlen+0x26>
    487c:	0505                	addi	a0,a0,1
    487e:	87aa                	mv	a5,a0
    4880:	86be                	mv	a3,a5
    4882:	0785                	addi	a5,a5,1
    4884:	fff7c703          	lbu	a4,-1(a5)
    4888:	ff65                	bnez	a4,4880 <strlen+0x10>
    488a:	40a6853b          	subw	a0,a3,a0
    488e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    4890:	6422                	ld	s0,8(sp)
    4892:	0141                	addi	sp,sp,16
    4894:	8082                	ret
  for(n = 0; s[n]; n++)
    4896:	4501                	li	a0,0
    4898:	bfe5                	j	4890 <strlen+0x20>

000000000000489a <memset>:

void*
memset(void *dst, int c, uint n)
{
    489a:	1141                	addi	sp,sp,-16
    489c:	e422                	sd	s0,8(sp)
    489e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    48a0:	ca19                	beqz	a2,48b6 <memset+0x1c>
    48a2:	87aa                	mv	a5,a0
    48a4:	1602                	slli	a2,a2,0x20
    48a6:	9201                	srli	a2,a2,0x20
    48a8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    48ac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    48b0:	0785                	addi	a5,a5,1
    48b2:	fee79de3          	bne	a5,a4,48ac <memset+0x12>
  }
  return dst;
}
    48b6:	6422                	ld	s0,8(sp)
    48b8:	0141                	addi	sp,sp,16
    48ba:	8082                	ret

00000000000048bc <strchr>:

char*
strchr(const char *s, char c)
{
    48bc:	1141                	addi	sp,sp,-16
    48be:	e422                	sd	s0,8(sp)
    48c0:	0800                	addi	s0,sp,16
  for(; *s; s++)
    48c2:	00054783          	lbu	a5,0(a0)
    48c6:	cb99                	beqz	a5,48dc <strchr+0x20>
    if(*s == c)
    48c8:	00f58763          	beq	a1,a5,48d6 <strchr+0x1a>
  for(; *s; s++)
    48cc:	0505                	addi	a0,a0,1
    48ce:	00054783          	lbu	a5,0(a0)
    48d2:	fbfd                	bnez	a5,48c8 <strchr+0xc>
      return (char*)s;
  return 0;
    48d4:	4501                	li	a0,0
}
    48d6:	6422                	ld	s0,8(sp)
    48d8:	0141                	addi	sp,sp,16
    48da:	8082                	ret
  return 0;
    48dc:	4501                	li	a0,0
    48de:	bfe5                	j	48d6 <strchr+0x1a>

00000000000048e0 <gets>:

char*
gets(char *buf, int max)
{
    48e0:	711d                	addi	sp,sp,-96
    48e2:	ec86                	sd	ra,88(sp)
    48e4:	e8a2                	sd	s0,80(sp)
    48e6:	e4a6                	sd	s1,72(sp)
    48e8:	e0ca                	sd	s2,64(sp)
    48ea:	fc4e                	sd	s3,56(sp)
    48ec:	f852                	sd	s4,48(sp)
    48ee:	f456                	sd	s5,40(sp)
    48f0:	f05a                	sd	s6,32(sp)
    48f2:	ec5e                	sd	s7,24(sp)
    48f4:	1080                	addi	s0,sp,96
    48f6:	8baa                	mv	s7,a0
    48f8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    48fa:	892a                	mv	s2,a0
    48fc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    48fe:	4aa9                	li	s5,10
    4900:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    4902:	89a6                	mv	s3,s1
    4904:	2485                	addiw	s1,s1,1
    4906:	0344d663          	bge	s1,s4,4932 <gets+0x52>
    cc = read(0, &c, 1);
    490a:	4605                	li	a2,1
    490c:	faf40593          	addi	a1,s0,-81
    4910:	4501                	li	a0,0
    4912:	186000ef          	jal	4a98 <read>
    if(cc < 1)
    4916:	00a05e63          	blez	a0,4932 <gets+0x52>
    buf[i++] = c;
    491a:	faf44783          	lbu	a5,-81(s0)
    491e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4922:	01578763          	beq	a5,s5,4930 <gets+0x50>
    4926:	0905                	addi	s2,s2,1
    4928:	fd679de3          	bne	a5,s6,4902 <gets+0x22>
    buf[i++] = c;
    492c:	89a6                	mv	s3,s1
    492e:	a011                	j	4932 <gets+0x52>
    4930:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    4932:	99de                	add	s3,s3,s7
    4934:	00098023          	sb	zero,0(s3)
  return buf;
}
    4938:	855e                	mv	a0,s7
    493a:	60e6                	ld	ra,88(sp)
    493c:	6446                	ld	s0,80(sp)
    493e:	64a6                	ld	s1,72(sp)
    4940:	6906                	ld	s2,64(sp)
    4942:	79e2                	ld	s3,56(sp)
    4944:	7a42                	ld	s4,48(sp)
    4946:	7aa2                	ld	s5,40(sp)
    4948:	7b02                	ld	s6,32(sp)
    494a:	6be2                	ld	s7,24(sp)
    494c:	6125                	addi	sp,sp,96
    494e:	8082                	ret

0000000000004950 <stat>:

int
stat(const char *n, struct stat *st)
{
    4950:	1101                	addi	sp,sp,-32
    4952:	ec06                	sd	ra,24(sp)
    4954:	e822                	sd	s0,16(sp)
    4956:	e04a                	sd	s2,0(sp)
    4958:	1000                	addi	s0,sp,32
    495a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    495c:	4581                	li	a1,0
    495e:	162000ef          	jal	4ac0 <open>
  if(fd < 0)
    4962:	02054263          	bltz	a0,4986 <stat+0x36>
    4966:	e426                	sd	s1,8(sp)
    4968:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    496a:	85ca                	mv	a1,s2
    496c:	16c000ef          	jal	4ad8 <fstat>
    4970:	892a                	mv	s2,a0
  close(fd);
    4972:	8526                	mv	a0,s1
    4974:	134000ef          	jal	4aa8 <close>
  return r;
    4978:	64a2                	ld	s1,8(sp)
}
    497a:	854a                	mv	a0,s2
    497c:	60e2                	ld	ra,24(sp)
    497e:	6442                	ld	s0,16(sp)
    4980:	6902                	ld	s2,0(sp)
    4982:	6105                	addi	sp,sp,32
    4984:	8082                	ret
    return -1;
    4986:	597d                	li	s2,-1
    4988:	bfcd                	j	497a <stat+0x2a>

000000000000498a <atoi>:

int
atoi(const char *s)
{
    498a:	1141                	addi	sp,sp,-16
    498c:	e422                	sd	s0,8(sp)
    498e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4990:	00054683          	lbu	a3,0(a0)
    4994:	fd06879b          	addiw	a5,a3,-48
    4998:	0ff7f793          	zext.b	a5,a5
    499c:	4625                	li	a2,9
    499e:	02f66863          	bltu	a2,a5,49ce <atoi+0x44>
    49a2:	872a                	mv	a4,a0
  n = 0;
    49a4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    49a6:	0705                	addi	a4,a4,1
    49a8:	0025179b          	slliw	a5,a0,0x2
    49ac:	9fa9                	addw	a5,a5,a0
    49ae:	0017979b          	slliw	a5,a5,0x1
    49b2:	9fb5                	addw	a5,a5,a3
    49b4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    49b8:	00074683          	lbu	a3,0(a4)
    49bc:	fd06879b          	addiw	a5,a3,-48
    49c0:	0ff7f793          	zext.b	a5,a5
    49c4:	fef671e3          	bgeu	a2,a5,49a6 <atoi+0x1c>
  return n;
}
    49c8:	6422                	ld	s0,8(sp)
    49ca:	0141                	addi	sp,sp,16
    49cc:	8082                	ret
  n = 0;
    49ce:	4501                	li	a0,0
    49d0:	bfe5                	j	49c8 <atoi+0x3e>

00000000000049d2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    49d2:	1141                	addi	sp,sp,-16
    49d4:	e422                	sd	s0,8(sp)
    49d6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    49d8:	02b57463          	bgeu	a0,a1,4a00 <memmove+0x2e>
    while(n-- > 0)
    49dc:	00c05f63          	blez	a2,49fa <memmove+0x28>
    49e0:	1602                	slli	a2,a2,0x20
    49e2:	9201                	srli	a2,a2,0x20
    49e4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    49e8:	872a                	mv	a4,a0
      *dst++ = *src++;
    49ea:	0585                	addi	a1,a1,1
    49ec:	0705                	addi	a4,a4,1
    49ee:	fff5c683          	lbu	a3,-1(a1)
    49f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    49f6:	fef71ae3          	bne	a4,a5,49ea <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    49fa:	6422                	ld	s0,8(sp)
    49fc:	0141                	addi	sp,sp,16
    49fe:	8082                	ret
    dst += n;
    4a00:	00c50733          	add	a4,a0,a2
    src += n;
    4a04:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    4a06:	fec05ae3          	blez	a2,49fa <memmove+0x28>
    4a0a:	fff6079b          	addiw	a5,a2,-1 # 2fff <subdir+0x423>
    4a0e:	1782                	slli	a5,a5,0x20
    4a10:	9381                	srli	a5,a5,0x20
    4a12:	fff7c793          	not	a5,a5
    4a16:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4a18:	15fd                	addi	a1,a1,-1
    4a1a:	177d                	addi	a4,a4,-1
    4a1c:	0005c683          	lbu	a3,0(a1)
    4a20:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4a24:	fee79ae3          	bne	a5,a4,4a18 <memmove+0x46>
    4a28:	bfc9                	j	49fa <memmove+0x28>

0000000000004a2a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4a2a:	1141                	addi	sp,sp,-16
    4a2c:	e422                	sd	s0,8(sp)
    4a2e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4a30:	ca05                	beqz	a2,4a60 <memcmp+0x36>
    4a32:	fff6069b          	addiw	a3,a2,-1
    4a36:	1682                	slli	a3,a3,0x20
    4a38:	9281                	srli	a3,a3,0x20
    4a3a:	0685                	addi	a3,a3,1
    4a3c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    4a3e:	00054783          	lbu	a5,0(a0)
    4a42:	0005c703          	lbu	a4,0(a1)
    4a46:	00e79863          	bne	a5,a4,4a56 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    4a4a:	0505                	addi	a0,a0,1
    p2++;
    4a4c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4a4e:	fed518e3          	bne	a0,a3,4a3e <memcmp+0x14>
  }
  return 0;
    4a52:	4501                	li	a0,0
    4a54:	a019                	j	4a5a <memcmp+0x30>
      return *p1 - *p2;
    4a56:	40e7853b          	subw	a0,a5,a4
}
    4a5a:	6422                	ld	s0,8(sp)
    4a5c:	0141                	addi	sp,sp,16
    4a5e:	8082                	ret
  return 0;
    4a60:	4501                	li	a0,0
    4a62:	bfe5                	j	4a5a <memcmp+0x30>

0000000000004a64 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4a64:	1141                	addi	sp,sp,-16
    4a66:	e406                	sd	ra,8(sp)
    4a68:	e022                	sd	s0,0(sp)
    4a6a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4a6c:	f67ff0ef          	jal	49d2 <memmove>
}
    4a70:	60a2                	ld	ra,8(sp)
    4a72:	6402                	ld	s0,0(sp)
    4a74:	0141                	addi	sp,sp,16
    4a76:	8082                	ret

0000000000004a78 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4a78:	4885                	li	a7,1
 ecall
    4a7a:	00000073          	ecall
 ret
    4a7e:	8082                	ret

0000000000004a80 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4a80:	4889                	li	a7,2
 ecall
    4a82:	00000073          	ecall
 ret
    4a86:	8082                	ret

0000000000004a88 <wait>:
.global wait
wait:
 li a7, SYS_wait
    4a88:	488d                	li	a7,3
 ecall
    4a8a:	00000073          	ecall
 ret
    4a8e:	8082                	ret

0000000000004a90 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4a90:	4891                	li	a7,4
 ecall
    4a92:	00000073          	ecall
 ret
    4a96:	8082                	ret

0000000000004a98 <read>:
.global read
read:
 li a7, SYS_read
    4a98:	4895                	li	a7,5
 ecall
    4a9a:	00000073          	ecall
 ret
    4a9e:	8082                	ret

0000000000004aa0 <write>:
.global write
write:
 li a7, SYS_write
    4aa0:	48c1                	li	a7,16
 ecall
    4aa2:	00000073          	ecall
 ret
    4aa6:	8082                	ret

0000000000004aa8 <close>:
.global close
close:
 li a7, SYS_close
    4aa8:	48d5                	li	a7,21
 ecall
    4aaa:	00000073          	ecall
 ret
    4aae:	8082                	ret

0000000000004ab0 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4ab0:	4899                	li	a7,6
 ecall
    4ab2:	00000073          	ecall
 ret
    4ab6:	8082                	ret

0000000000004ab8 <exec>:
.global exec
exec:
 li a7, SYS_exec
    4ab8:	489d                	li	a7,7
 ecall
    4aba:	00000073          	ecall
 ret
    4abe:	8082                	ret

0000000000004ac0 <open>:
.global open
open:
 li a7, SYS_open
    4ac0:	48bd                	li	a7,15
 ecall
    4ac2:	00000073          	ecall
 ret
    4ac6:	8082                	ret

0000000000004ac8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4ac8:	48c5                	li	a7,17
 ecall
    4aca:	00000073          	ecall
 ret
    4ace:	8082                	ret

0000000000004ad0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4ad0:	48c9                	li	a7,18
 ecall
    4ad2:	00000073          	ecall
 ret
    4ad6:	8082                	ret

0000000000004ad8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4ad8:	48a1                	li	a7,8
 ecall
    4ada:	00000073          	ecall
 ret
    4ade:	8082                	ret

0000000000004ae0 <link>:
.global link
link:
 li a7, SYS_link
    4ae0:	48cd                	li	a7,19
 ecall
    4ae2:	00000073          	ecall
 ret
    4ae6:	8082                	ret

0000000000004ae8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4ae8:	48d1                	li	a7,20
 ecall
    4aea:	00000073          	ecall
 ret
    4aee:	8082                	ret

0000000000004af0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4af0:	48a5                	li	a7,9
 ecall
    4af2:	00000073          	ecall
 ret
    4af6:	8082                	ret

0000000000004af8 <dup>:
.global dup
dup:
 li a7, SYS_dup
    4af8:	48a9                	li	a7,10
 ecall
    4afa:	00000073          	ecall
 ret
    4afe:	8082                	ret

0000000000004b00 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4b00:	48ad                	li	a7,11
 ecall
    4b02:	00000073          	ecall
 ret
    4b06:	8082                	ret

0000000000004b08 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    4b08:	48b1                	li	a7,12
 ecall
    4b0a:	00000073          	ecall
 ret
    4b0e:	8082                	ret

0000000000004b10 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    4b10:	48b5                	li	a7,13
 ecall
    4b12:	00000073          	ecall
 ret
    4b16:	8082                	ret

0000000000004b18 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4b18:	48b9                	li	a7,14
 ecall
    4b1a:	00000073          	ecall
 ret
    4b1e:	8082                	ret

0000000000004b20 <clone>:
.global clone
clone:
 li a7, SYS_clone
    4b20:	48d9                	li	a7,22
 ecall
    4b22:	00000073          	ecall
 ret
    4b26:	8082                	ret

0000000000004b28 <join>:
.global join
join:
 li a7, SYS_join
    4b28:	48dd                	li	a7,23
 ecall
    4b2a:	00000073          	ecall
 ret
    4b2e:	8082                	ret

0000000000004b30 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4b30:	1101                	addi	sp,sp,-32
    4b32:	ec06                	sd	ra,24(sp)
    4b34:	e822                	sd	s0,16(sp)
    4b36:	1000                	addi	s0,sp,32
    4b38:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4b3c:	4605                	li	a2,1
    4b3e:	fef40593          	addi	a1,s0,-17
    4b42:	f5fff0ef          	jal	4aa0 <write>
}
    4b46:	60e2                	ld	ra,24(sp)
    4b48:	6442                	ld	s0,16(sp)
    4b4a:	6105                	addi	sp,sp,32
    4b4c:	8082                	ret

0000000000004b4e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4b4e:	7139                	addi	sp,sp,-64
    4b50:	fc06                	sd	ra,56(sp)
    4b52:	f822                	sd	s0,48(sp)
    4b54:	f426                	sd	s1,40(sp)
    4b56:	0080                	addi	s0,sp,64
    4b58:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4b5a:	c299                	beqz	a3,4b60 <printint+0x12>
    4b5c:	0805c963          	bltz	a1,4bee <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    4b60:	2581                	sext.w	a1,a1
  neg = 0;
    4b62:	4881                	li	a7,0
    4b64:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    4b68:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4b6a:	2601                	sext.w	a2,a2
    4b6c:	00003517          	auipc	a0,0x3
    4b70:	98450513          	addi	a0,a0,-1660 # 74f0 <digits>
    4b74:	883a                	mv	a6,a4
    4b76:	2705                	addiw	a4,a4,1
    4b78:	02c5f7bb          	remuw	a5,a1,a2
    4b7c:	1782                	slli	a5,a5,0x20
    4b7e:	9381                	srli	a5,a5,0x20
    4b80:	97aa                	add	a5,a5,a0
    4b82:	0007c783          	lbu	a5,0(a5)
    4b86:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4b8a:	0005879b          	sext.w	a5,a1
    4b8e:	02c5d5bb          	divuw	a1,a1,a2
    4b92:	0685                	addi	a3,a3,1
    4b94:	fec7f0e3          	bgeu	a5,a2,4b74 <printint+0x26>
  if(neg)
    4b98:	00088c63          	beqz	a7,4bb0 <printint+0x62>
    buf[i++] = '-';
    4b9c:	fd070793          	addi	a5,a4,-48
    4ba0:	00878733          	add	a4,a5,s0
    4ba4:	02d00793          	li	a5,45
    4ba8:	fef70823          	sb	a5,-16(a4)
    4bac:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    4bb0:	02e05a63          	blez	a4,4be4 <printint+0x96>
    4bb4:	f04a                	sd	s2,32(sp)
    4bb6:	ec4e                	sd	s3,24(sp)
    4bb8:	fc040793          	addi	a5,s0,-64
    4bbc:	00e78933          	add	s2,a5,a4
    4bc0:	fff78993          	addi	s3,a5,-1
    4bc4:	99ba                	add	s3,s3,a4
    4bc6:	377d                	addiw	a4,a4,-1
    4bc8:	1702                	slli	a4,a4,0x20
    4bca:	9301                	srli	a4,a4,0x20
    4bcc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    4bd0:	fff94583          	lbu	a1,-1(s2)
    4bd4:	8526                	mv	a0,s1
    4bd6:	f5bff0ef          	jal	4b30 <putc>
  while(--i >= 0)
    4bda:	197d                	addi	s2,s2,-1
    4bdc:	ff391ae3          	bne	s2,s3,4bd0 <printint+0x82>
    4be0:	7902                	ld	s2,32(sp)
    4be2:	69e2                	ld	s3,24(sp)
}
    4be4:	70e2                	ld	ra,56(sp)
    4be6:	7442                	ld	s0,48(sp)
    4be8:	74a2                	ld	s1,40(sp)
    4bea:	6121                	addi	sp,sp,64
    4bec:	8082                	ret
    x = -xx;
    4bee:	40b005bb          	negw	a1,a1
    neg = 1;
    4bf2:	4885                	li	a7,1
    x = -xx;
    4bf4:	bf85                	j	4b64 <printint+0x16>

0000000000004bf6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4bf6:	711d                	addi	sp,sp,-96
    4bf8:	ec86                	sd	ra,88(sp)
    4bfa:	e8a2                	sd	s0,80(sp)
    4bfc:	e0ca                	sd	s2,64(sp)
    4bfe:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4c00:	0005c903          	lbu	s2,0(a1)
    4c04:	26090863          	beqz	s2,4e74 <vprintf+0x27e>
    4c08:	e4a6                	sd	s1,72(sp)
    4c0a:	fc4e                	sd	s3,56(sp)
    4c0c:	f852                	sd	s4,48(sp)
    4c0e:	f456                	sd	s5,40(sp)
    4c10:	f05a                	sd	s6,32(sp)
    4c12:	ec5e                	sd	s7,24(sp)
    4c14:	e862                	sd	s8,16(sp)
    4c16:	e466                	sd	s9,8(sp)
    4c18:	8b2a                	mv	s6,a0
    4c1a:	8a2e                	mv	s4,a1
    4c1c:	8bb2                	mv	s7,a2
  state = 0;
    4c1e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4c20:	4481                	li	s1,0
    4c22:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4c24:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4c28:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4c2c:	06c00c93          	li	s9,108
    4c30:	a005                	j	4c50 <vprintf+0x5a>
        putc(fd, c0);
    4c32:	85ca                	mv	a1,s2
    4c34:	855a                	mv	a0,s6
    4c36:	efbff0ef          	jal	4b30 <putc>
    4c3a:	a019                	j	4c40 <vprintf+0x4a>
    } else if(state == '%'){
    4c3c:	03598263          	beq	s3,s5,4c60 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    4c40:	2485                	addiw	s1,s1,1
    4c42:	8726                	mv	a4,s1
    4c44:	009a07b3          	add	a5,s4,s1
    4c48:	0007c903          	lbu	s2,0(a5)
    4c4c:	20090c63          	beqz	s2,4e64 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    4c50:	0009079b          	sext.w	a5,s2
    if(state == 0){
    4c54:	fe0994e3          	bnez	s3,4c3c <vprintf+0x46>
      if(c0 == '%'){
    4c58:	fd579de3          	bne	a5,s5,4c32 <vprintf+0x3c>
        state = '%';
    4c5c:	89be                	mv	s3,a5
    4c5e:	b7cd                	j	4c40 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    4c60:	00ea06b3          	add	a3,s4,a4
    4c64:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4c68:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4c6a:	c681                	beqz	a3,4c72 <vprintf+0x7c>
    4c6c:	9752                	add	a4,a4,s4
    4c6e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4c72:	03878f63          	beq	a5,s8,4cb0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    4c76:	05978963          	beq	a5,s9,4cc8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4c7a:	07500713          	li	a4,117
    4c7e:	0ee78363          	beq	a5,a4,4d64 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4c82:	07800713          	li	a4,120
    4c86:	12e78563          	beq	a5,a4,4db0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4c8a:	07000713          	li	a4,112
    4c8e:	14e78a63          	beq	a5,a4,4de2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    4c92:	07300713          	li	a4,115
    4c96:	18e78a63          	beq	a5,a4,4e2a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4c9a:	02500713          	li	a4,37
    4c9e:	04e79563          	bne	a5,a4,4ce8 <vprintf+0xf2>
        putc(fd, '%');
    4ca2:	02500593          	li	a1,37
    4ca6:	855a                	mv	a0,s6
    4ca8:	e89ff0ef          	jal	4b30 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    4cac:	4981                	li	s3,0
    4cae:	bf49                	j	4c40 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    4cb0:	008b8913          	addi	s2,s7,8
    4cb4:	4685                	li	a3,1
    4cb6:	4629                	li	a2,10
    4cb8:	000ba583          	lw	a1,0(s7)
    4cbc:	855a                	mv	a0,s6
    4cbe:	e91ff0ef          	jal	4b4e <printint>
    4cc2:	8bca                	mv	s7,s2
      state = 0;
    4cc4:	4981                	li	s3,0
    4cc6:	bfad                	j	4c40 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    4cc8:	06400793          	li	a5,100
    4ccc:	02f68963          	beq	a3,a5,4cfe <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4cd0:	06c00793          	li	a5,108
    4cd4:	04f68263          	beq	a3,a5,4d18 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    4cd8:	07500793          	li	a5,117
    4cdc:	0af68063          	beq	a3,a5,4d7c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    4ce0:	07800793          	li	a5,120
    4ce4:	0ef68263          	beq	a3,a5,4dc8 <vprintf+0x1d2>
        putc(fd, '%');
    4ce8:	02500593          	li	a1,37
    4cec:	855a                	mv	a0,s6
    4cee:	e43ff0ef          	jal	4b30 <putc>
        putc(fd, c0);
    4cf2:	85ca                	mv	a1,s2
    4cf4:	855a                	mv	a0,s6
    4cf6:	e3bff0ef          	jal	4b30 <putc>
      state = 0;
    4cfa:	4981                	li	s3,0
    4cfc:	b791                	j	4c40 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4cfe:	008b8913          	addi	s2,s7,8
    4d02:	4685                	li	a3,1
    4d04:	4629                	li	a2,10
    4d06:	000ba583          	lw	a1,0(s7)
    4d0a:	855a                	mv	a0,s6
    4d0c:	e43ff0ef          	jal	4b4e <printint>
        i += 1;
    4d10:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4d12:	8bca                	mv	s7,s2
      state = 0;
    4d14:	4981                	li	s3,0
        i += 1;
    4d16:	b72d                	j	4c40 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4d18:	06400793          	li	a5,100
    4d1c:	02f60763          	beq	a2,a5,4d4a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4d20:	07500793          	li	a5,117
    4d24:	06f60963          	beq	a2,a5,4d96 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4d28:	07800793          	li	a5,120
    4d2c:	faf61ee3          	bne	a2,a5,4ce8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d30:	008b8913          	addi	s2,s7,8
    4d34:	4681                	li	a3,0
    4d36:	4641                	li	a2,16
    4d38:	000ba583          	lw	a1,0(s7)
    4d3c:	855a                	mv	a0,s6
    4d3e:	e11ff0ef          	jal	4b4e <printint>
        i += 2;
    4d42:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4d44:	8bca                	mv	s7,s2
      state = 0;
    4d46:	4981                	li	s3,0
        i += 2;
    4d48:	bde5                	j	4c40 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4d4a:	008b8913          	addi	s2,s7,8
    4d4e:	4685                	li	a3,1
    4d50:	4629                	li	a2,10
    4d52:	000ba583          	lw	a1,0(s7)
    4d56:	855a                	mv	a0,s6
    4d58:	df7ff0ef          	jal	4b4e <printint>
        i += 2;
    4d5c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4d5e:	8bca                	mv	s7,s2
      state = 0;
    4d60:	4981                	li	s3,0
        i += 2;
    4d62:	bdf9                	j	4c40 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    4d64:	008b8913          	addi	s2,s7,8
    4d68:	4681                	li	a3,0
    4d6a:	4629                	li	a2,10
    4d6c:	000ba583          	lw	a1,0(s7)
    4d70:	855a                	mv	a0,s6
    4d72:	dddff0ef          	jal	4b4e <printint>
    4d76:	8bca                	mv	s7,s2
      state = 0;
    4d78:	4981                	li	s3,0
    4d7a:	b5d9                	j	4c40 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d7c:	008b8913          	addi	s2,s7,8
    4d80:	4681                	li	a3,0
    4d82:	4629                	li	a2,10
    4d84:	000ba583          	lw	a1,0(s7)
    4d88:	855a                	mv	a0,s6
    4d8a:	dc5ff0ef          	jal	4b4e <printint>
        i += 1;
    4d8e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d90:	8bca                	mv	s7,s2
      state = 0;
    4d92:	4981                	li	s3,0
        i += 1;
    4d94:	b575                	j	4c40 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4d96:	008b8913          	addi	s2,s7,8
    4d9a:	4681                	li	a3,0
    4d9c:	4629                	li	a2,10
    4d9e:	000ba583          	lw	a1,0(s7)
    4da2:	855a                	mv	a0,s6
    4da4:	dabff0ef          	jal	4b4e <printint>
        i += 2;
    4da8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    4daa:	8bca                	mv	s7,s2
      state = 0;
    4dac:	4981                	li	s3,0
        i += 2;
    4dae:	bd49                	j	4c40 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    4db0:	008b8913          	addi	s2,s7,8
    4db4:	4681                	li	a3,0
    4db6:	4641                	li	a2,16
    4db8:	000ba583          	lw	a1,0(s7)
    4dbc:	855a                	mv	a0,s6
    4dbe:	d91ff0ef          	jal	4b4e <printint>
    4dc2:	8bca                	mv	s7,s2
      state = 0;
    4dc4:	4981                	li	s3,0
    4dc6:	bdad                	j	4c40 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4dc8:	008b8913          	addi	s2,s7,8
    4dcc:	4681                	li	a3,0
    4dce:	4641                	li	a2,16
    4dd0:	000ba583          	lw	a1,0(s7)
    4dd4:	855a                	mv	a0,s6
    4dd6:	d79ff0ef          	jal	4b4e <printint>
        i += 1;
    4dda:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    4ddc:	8bca                	mv	s7,s2
      state = 0;
    4dde:	4981                	li	s3,0
        i += 1;
    4de0:	b585                	j	4c40 <vprintf+0x4a>
    4de2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    4de4:	008b8d13          	addi	s10,s7,8
    4de8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    4dec:	03000593          	li	a1,48
    4df0:	855a                	mv	a0,s6
    4df2:	d3fff0ef          	jal	4b30 <putc>
  putc(fd, 'x');
    4df6:	07800593          	li	a1,120
    4dfa:	855a                	mv	a0,s6
    4dfc:	d35ff0ef          	jal	4b30 <putc>
    4e00:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    4e02:	00002b97          	auipc	s7,0x2
    4e06:	6eeb8b93          	addi	s7,s7,1774 # 74f0 <digits>
    4e0a:	03c9d793          	srli	a5,s3,0x3c
    4e0e:	97de                	add	a5,a5,s7
    4e10:	0007c583          	lbu	a1,0(a5)
    4e14:	855a                	mv	a0,s6
    4e16:	d1bff0ef          	jal	4b30 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    4e1a:	0992                	slli	s3,s3,0x4
    4e1c:	397d                	addiw	s2,s2,-1
    4e1e:	fe0916e3          	bnez	s2,4e0a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    4e22:	8bea                	mv	s7,s10
      state = 0;
    4e24:	4981                	li	s3,0
    4e26:	6d02                	ld	s10,0(sp)
    4e28:	bd21                	j	4c40 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    4e2a:	008b8993          	addi	s3,s7,8
    4e2e:	000bb903          	ld	s2,0(s7)
    4e32:	00090f63          	beqz	s2,4e50 <vprintf+0x25a>
        for(; *s; s++)
    4e36:	00094583          	lbu	a1,0(s2)
    4e3a:	c195                	beqz	a1,4e5e <vprintf+0x268>
          putc(fd, *s);
    4e3c:	855a                	mv	a0,s6
    4e3e:	cf3ff0ef          	jal	4b30 <putc>
        for(; *s; s++)
    4e42:	0905                	addi	s2,s2,1
    4e44:	00094583          	lbu	a1,0(s2)
    4e48:	f9f5                	bnez	a1,4e3c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    4e4a:	8bce                	mv	s7,s3
      state = 0;
    4e4c:	4981                	li	s3,0
    4e4e:	bbcd                	j	4c40 <vprintf+0x4a>
          s = "(null)";
    4e50:	00002917          	auipc	s2,0x2
    4e54:	62090913          	addi	s2,s2,1568 # 7470 <thread_join+0x23cc>
        for(; *s; s++)
    4e58:	02800593          	li	a1,40
    4e5c:	b7c5                	j	4e3c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    4e5e:	8bce                	mv	s7,s3
      state = 0;
    4e60:	4981                	li	s3,0
    4e62:	bbf9                	j	4c40 <vprintf+0x4a>
    4e64:	64a6                	ld	s1,72(sp)
    4e66:	79e2                	ld	s3,56(sp)
    4e68:	7a42                	ld	s4,48(sp)
    4e6a:	7aa2                	ld	s5,40(sp)
    4e6c:	7b02                	ld	s6,32(sp)
    4e6e:	6be2                	ld	s7,24(sp)
    4e70:	6c42                	ld	s8,16(sp)
    4e72:	6ca2                	ld	s9,8(sp)
    }
  }
}
    4e74:	60e6                	ld	ra,88(sp)
    4e76:	6446                	ld	s0,80(sp)
    4e78:	6906                	ld	s2,64(sp)
    4e7a:	6125                	addi	sp,sp,96
    4e7c:	8082                	ret

0000000000004e7e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    4e7e:	715d                	addi	sp,sp,-80
    4e80:	ec06                	sd	ra,24(sp)
    4e82:	e822                	sd	s0,16(sp)
    4e84:	1000                	addi	s0,sp,32
    4e86:	e010                	sd	a2,0(s0)
    4e88:	e414                	sd	a3,8(s0)
    4e8a:	e818                	sd	a4,16(s0)
    4e8c:	ec1c                	sd	a5,24(s0)
    4e8e:	03043023          	sd	a6,32(s0)
    4e92:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    4e96:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    4e9a:	8622                	mv	a2,s0
    4e9c:	d5bff0ef          	jal	4bf6 <vprintf>
}
    4ea0:	60e2                	ld	ra,24(sp)
    4ea2:	6442                	ld	s0,16(sp)
    4ea4:	6161                	addi	sp,sp,80
    4ea6:	8082                	ret

0000000000004ea8 <printf>:

void
printf(const char *fmt, ...)
{
    4ea8:	711d                	addi	sp,sp,-96
    4eaa:	ec06                	sd	ra,24(sp)
    4eac:	e822                	sd	s0,16(sp)
    4eae:	1000                	addi	s0,sp,32
    4eb0:	e40c                	sd	a1,8(s0)
    4eb2:	e810                	sd	a2,16(s0)
    4eb4:	ec14                	sd	a3,24(s0)
    4eb6:	f018                	sd	a4,32(s0)
    4eb8:	f41c                	sd	a5,40(s0)
    4eba:	03043823          	sd	a6,48(s0)
    4ebe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    4ec2:	00840613          	addi	a2,s0,8
    4ec6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    4eca:	85aa                	mv	a1,a0
    4ecc:	4505                	li	a0,1
    4ece:	d29ff0ef          	jal	4bf6 <vprintf>
}
    4ed2:	60e2                	ld	ra,24(sp)
    4ed4:	6442                	ld	s0,16(sp)
    4ed6:	6125                	addi	sp,sp,96
    4ed8:	8082                	ret

0000000000004eda <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    4eda:	1141                	addi	sp,sp,-16
    4edc:	e422                	sd	s0,8(sp)
    4ede:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    4ee0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4ee4:	00004797          	auipc	a5,0x4
    4ee8:	56c7b783          	ld	a5,1388(a5) # 9450 <freep>
    4eec:	a02d                	j	4f16 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    4eee:	4618                	lw	a4,8(a2)
    4ef0:	9f2d                	addw	a4,a4,a1
    4ef2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    4ef6:	6398                	ld	a4,0(a5)
    4ef8:	6310                	ld	a2,0(a4)
    4efa:	a83d                	j	4f38 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    4efc:	ff852703          	lw	a4,-8(a0)
    4f00:	9f31                	addw	a4,a4,a2
    4f02:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    4f04:	ff053683          	ld	a3,-16(a0)
    4f08:	a091                	j	4f4c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4f0a:	6398                	ld	a4,0(a5)
    4f0c:	00e7e463          	bltu	a5,a4,4f14 <free+0x3a>
    4f10:	00e6ea63          	bltu	a3,a4,4f24 <free+0x4a>
{
    4f14:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4f16:	fed7fae3          	bgeu	a5,a3,4f0a <free+0x30>
    4f1a:	6398                	ld	a4,0(a5)
    4f1c:	00e6e463          	bltu	a3,a4,4f24 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4f20:	fee7eae3          	bltu	a5,a4,4f14 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    4f24:	ff852583          	lw	a1,-8(a0)
    4f28:	6390                	ld	a2,0(a5)
    4f2a:	02059813          	slli	a6,a1,0x20
    4f2e:	01c85713          	srli	a4,a6,0x1c
    4f32:	9736                	add	a4,a4,a3
    4f34:	fae60de3          	beq	a2,a4,4eee <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    4f38:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    4f3c:	4790                	lw	a2,8(a5)
    4f3e:	02061593          	slli	a1,a2,0x20
    4f42:	01c5d713          	srli	a4,a1,0x1c
    4f46:	973e                	add	a4,a4,a5
    4f48:	fae68ae3          	beq	a3,a4,4efc <free+0x22>
    p->s.ptr = bp->s.ptr;
    4f4c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    4f4e:	00004717          	auipc	a4,0x4
    4f52:	50f73123          	sd	a5,1282(a4) # 9450 <freep>
}
    4f56:	6422                	ld	s0,8(sp)
    4f58:	0141                	addi	sp,sp,16
    4f5a:	8082                	ret

0000000000004f5c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    4f5c:	7139                	addi	sp,sp,-64
    4f5e:	fc06                	sd	ra,56(sp)
    4f60:	f822                	sd	s0,48(sp)
    4f62:	f426                	sd	s1,40(sp)
    4f64:	ec4e                	sd	s3,24(sp)
    4f66:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    4f68:	02051493          	slli	s1,a0,0x20
    4f6c:	9081                	srli	s1,s1,0x20
    4f6e:	04bd                	addi	s1,s1,15
    4f70:	8091                	srli	s1,s1,0x4
    4f72:	0014899b          	addiw	s3,s1,1
    4f76:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    4f78:	00004517          	auipc	a0,0x4
    4f7c:	4d853503          	ld	a0,1240(a0) # 9450 <freep>
    4f80:	c915                	beqz	a0,4fb4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4f82:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4f84:	4798                	lw	a4,8(a5)
    4f86:	08977a63          	bgeu	a4,s1,501a <malloc+0xbe>
    4f8a:	f04a                	sd	s2,32(sp)
    4f8c:	e852                	sd	s4,16(sp)
    4f8e:	e456                	sd	s5,8(sp)
    4f90:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    4f92:	8a4e                	mv	s4,s3
    4f94:	0009871b          	sext.w	a4,s3
    4f98:	6685                	lui	a3,0x1
    4f9a:	00d77363          	bgeu	a4,a3,4fa0 <malloc+0x44>
    4f9e:	6a05                	lui	s4,0x1
    4fa0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    4fa4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    4fa8:	00004917          	auipc	s2,0x4
    4fac:	4a890913          	addi	s2,s2,1192 # 9450 <freep>
  if(p == (char*)-1)
    4fb0:	5afd                	li	s5,-1
    4fb2:	a081                	j	4ff2 <malloc+0x96>
    4fb4:	f04a                	sd	s2,32(sp)
    4fb6:	e852                	sd	s4,16(sp)
    4fb8:	e456                	sd	s5,8(sp)
    4fba:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    4fbc:	0000b797          	auipc	a5,0xb
    4fc0:	cbc78793          	addi	a5,a5,-836 # fc78 <base>
    4fc4:	00004717          	auipc	a4,0x4
    4fc8:	48f73623          	sd	a5,1164(a4) # 9450 <freep>
    4fcc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    4fce:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    4fd2:	b7c1                	j	4f92 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    4fd4:	6398                	ld	a4,0(a5)
    4fd6:	e118                	sd	a4,0(a0)
    4fd8:	a8a9                	j	5032 <malloc+0xd6>
  hp->s.size = nu;
    4fda:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    4fde:	0541                	addi	a0,a0,16
    4fe0:	efbff0ef          	jal	4eda <free>
  return freep;
    4fe4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    4fe8:	c12d                	beqz	a0,504a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    4fea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    4fec:	4798                	lw	a4,8(a5)
    4fee:	02977263          	bgeu	a4,s1,5012 <malloc+0xb6>
    if(p == freep)
    4ff2:	00093703          	ld	a4,0(s2)
    4ff6:	853e                	mv	a0,a5
    4ff8:	fef719e3          	bne	a4,a5,4fea <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    4ffc:	8552                	mv	a0,s4
    4ffe:	b0bff0ef          	jal	4b08 <sbrk>
  if(p == (char*)-1)
    5002:	fd551ce3          	bne	a0,s5,4fda <malloc+0x7e>
        return 0;
    5006:	4501                	li	a0,0
    5008:	7902                	ld	s2,32(sp)
    500a:	6a42                	ld	s4,16(sp)
    500c:	6aa2                	ld	s5,8(sp)
    500e:	6b02                	ld	s6,0(sp)
    5010:	a03d                	j	503e <malloc+0xe2>
    5012:	7902                	ld	s2,32(sp)
    5014:	6a42                	ld	s4,16(sp)
    5016:	6aa2                	ld	s5,8(sp)
    5018:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    501a:	fae48de3          	beq	s1,a4,4fd4 <malloc+0x78>
        p->s.size -= nunits;
    501e:	4137073b          	subw	a4,a4,s3
    5022:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5024:	02071693          	slli	a3,a4,0x20
    5028:	01c6d713          	srli	a4,a3,0x1c
    502c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    502e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5032:	00004717          	auipc	a4,0x4
    5036:	40a73f23          	sd	a0,1054(a4) # 9450 <freep>
      return (void*)(p + 1);
    503a:	01078513          	addi	a0,a5,16
  }
}
    503e:	70e2                	ld	ra,56(sp)
    5040:	7442                	ld	s0,48(sp)
    5042:	74a2                	ld	s1,40(sp)
    5044:	69e2                	ld	s3,24(sp)
    5046:	6121                	addi	sp,sp,64
    5048:	8082                	ret
    504a:	7902                	ld	s2,32(sp)
    504c:	6a42                	ld	s4,16(sp)
    504e:	6aa2                	ld	s5,8(sp)
    5050:	6b02                	ld	s6,0(sp)
    5052:	b7f5                	j	503e <malloc+0xe2>

0000000000005054 <thread_create>:
#include "kernel/types.h"
#include "kernel/riscv.h"

int 
thread_create(void (*start_routine)(void*, void*), void *arg1, void* arg2)
{
    5054:	7179                	addi	sp,sp,-48
    5056:	f406                	sd	ra,40(sp)
    5058:	f022                	sd	s0,32(sp)
    505a:	e84a                	sd	s2,16(sp)
    505c:	e44e                	sd	s3,8(sp)
    505e:	e052                	sd	s4,0(sp)
    5060:	1800                	addi	s0,sp,48
    5062:	892a                	mv	s2,a0
    5064:	89ae                	mv	s3,a1
    5066:	8a32                	mv	s4,a2
    int tid;

    void *stack = malloc(2 * PGSIZE);
    5068:	6509                	lui	a0,0x2
    506a:	ef3ff0ef          	jal	4f5c <malloc>
    if (stack == 0) return -1;
    506e:	c90d                	beqz	a0,50a0 <thread_create+0x4c>
    5070:	ec26                	sd	s1,24(sp)
    5072:	84aa                	mv	s1,a0
    
    if ((tid = clone(start_routine, arg1, arg2, stack)) < 0) {
    5074:	86aa                	mv	a3,a0
    5076:	8652                	mv	a2,s4
    5078:	85ce                	mv	a1,s3
    507a:	854a                	mv	a0,s2
    507c:	aa5ff0ef          	jal	4b20 <clone>
    5080:	00054a63          	bltz	a0,5094 <thread_create+0x40>
    5084:	64e2                	ld	s1,24(sp)
        free(stack);
        return -1;
    }
    
    return tid;
}
    5086:	70a2                	ld	ra,40(sp)
    5088:	7402                	ld	s0,32(sp)
    508a:	6942                	ld	s2,16(sp)
    508c:	69a2                	ld	s3,8(sp)
    508e:	6a02                	ld	s4,0(sp)
    5090:	6145                	addi	sp,sp,48
    5092:	8082                	ret
        free(stack);
    5094:	8526                	mv	a0,s1
    5096:	e45ff0ef          	jal	4eda <free>
        return -1;
    509a:	557d                	li	a0,-1
    509c:	64e2                	ld	s1,24(sp)
    509e:	b7e5                	j	5086 <thread_create+0x32>
    if (stack == 0) return -1;
    50a0:	557d                	li	a0,-1
    50a2:	b7d5                	j	5086 <thread_create+0x32>

00000000000050a4 <thread_join>:

int 
thread_join()
{   
    50a4:	7179                	addi	sp,sp,-48
    50a6:	f406                	sd	ra,40(sp)
    50a8:	f022                	sd	s0,32(sp)
    50aa:	ec26                	sd	s1,24(sp)
    50ac:	1800                	addi	s0,sp,48
    int tid;
    void *stack;
    
    if ((tid = join(&stack)) < 0) {
    50ae:	fd840513          	addi	a0,s0,-40
    50b2:	a77ff0ef          	jal	4b28 <join>
    50b6:	00054d63          	bltz	a0,50d0 <thread_join+0x2c>
    50ba:	84aa                	mv	s1,a0
        return -1;
    }

    free(stack);
    50bc:	fd843503          	ld	a0,-40(s0)
    50c0:	e1bff0ef          	jal	4eda <free>
    return tid;
}
    50c4:	8526                	mv	a0,s1
    50c6:	70a2                	ld	ra,40(sp)
    50c8:	7402                	ld	s0,32(sp)
    50ca:	64e2                	ld	s1,24(sp)
    50cc:	6145                	addi	sp,sp,48
    50ce:	8082                	ret
        return -1;
    50d0:	54fd                	li	s1,-1
    50d2:	bfcd                	j	50c4 <thread_join+0x20>
