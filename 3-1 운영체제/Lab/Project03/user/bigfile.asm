
user/_bigfile:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"
#include "kernel/fs.h"

int
main()
{
   0:	bd010113          	addi	sp,sp,-1072
   4:	42113423          	sd	ra,1064(sp)
   8:	42813023          	sd	s0,1056(sp)
   c:	43010413          	addi	s0,sp,1072
  char buf[BSIZE];
  int fd, i, blocks;

  fd = open("big.file", O_CREATE | O_WRONLY);
  10:	20100593          	li	a1,513
  14:	00001517          	auipc	a0,0x1
  18:	96c50513          	addi	a0,a0,-1684 # 980 <malloc+0xf8>
  1c:	3d8000ef          	jal	3f4 <open>
  if(fd < 0){
  20:	04054863          	bltz	a0,70 <main+0x70>
  24:	40913c23          	sd	s1,1048(sp)
  28:	41213823          	sd	s2,1040(sp)
  2c:	41313423          	sd	s3,1032(sp)
  30:	41413023          	sd	s4,1024(sp)
  34:	892a                	mv	s2,a0
  36:	4481                	li	s1,0
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
    if(cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
  38:	06400993          	li	s3,100
      printf(".");
  3c:	00001a17          	auipc	s4,0x1
  40:	984a0a13          	addi	s4,s4,-1660 # 9c0 <malloc+0x138>
    *(int*)buf = blocks;
  44:	bc942823          	sw	s1,-1072(s0)
    int cc = write(fd, buf, sizeof(buf));
  48:	40000613          	li	a2,1024
  4c:	bd040593          	addi	a1,s0,-1072
  50:	854a                	mv	a0,s2
  52:	382000ef          	jal	3d4 <write>
    if(cc <= 0)
  56:	02a05e63          	blez	a0,92 <main+0x92>
    blocks++;
  5a:	0014879b          	addiw	a5,s1,1
  5e:	0007849b          	sext.w	s1,a5
    if (blocks % 100 == 0)
  62:	0337e7bb          	remw	a5,a5,s3
  66:	fff9                	bnez	a5,44 <main+0x44>
      printf(".");
  68:	8552                	mv	a0,s4
  6a:	76a000ef          	jal	7d4 <printf>
  6e:	bfd9                	j	44 <main+0x44>
  70:	40913c23          	sd	s1,1048(sp)
  74:	41213823          	sd	s2,1040(sp)
  78:	41313423          	sd	s3,1032(sp)
  7c:	41413023          	sd	s4,1024(sp)
    printf("bigfile: cannot open big.file for writing\n");
  80:	00001517          	auipc	a0,0x1
  84:	91050513          	addi	a0,a0,-1776 # 990 <malloc+0x108>
  88:	74c000ef          	jal	7d4 <printf>
    exit(-1);
  8c:	557d                	li	a0,-1
  8e:	326000ef          	jal	3b4 <exit>
  }

  printf("\nwrote %d blocks\n", blocks);
  92:	85a6                	mv	a1,s1
  94:	00001517          	auipc	a0,0x1
  98:	93450513          	addi	a0,a0,-1740 # 9c8 <malloc+0x140>
  9c:	738000ef          	jal	7d4 <printf>
  if(blocks != 65803) {
  a0:	67c1                	lui	a5,0x10
  a2:	10b78793          	addi	a5,a5,267 # 1010b <base+0xf0fb>
  a6:	00f48b63          	beq	s1,a5,bc <main+0xbc>
    printf("bigfile: file is too small\n");
  aa:	00001517          	auipc	a0,0x1
  ae:	93650513          	addi	a0,a0,-1738 # 9e0 <malloc+0x158>
  b2:	722000ef          	jal	7d4 <printf>
    exit(-1);
  b6:	557d                	li	a0,-1
  b8:	2fc000ef          	jal	3b4 <exit>
  }
  
  close(fd);
  bc:	854a                	mv	a0,s2
  be:	31e000ef          	jal	3dc <close>
  fd = open("big.file", O_RDONLY);
  c2:	4581                	li	a1,0
  c4:	00001517          	auipc	a0,0x1
  c8:	8bc50513          	addi	a0,a0,-1860 # 980 <malloc+0xf8>
  cc:	328000ef          	jal	3f4 <open>
  d0:	892a                	mv	s2,a0
  if(fd < 0){
    printf("bigfile: cannot re-open big.file for reading\n");
    exit(-1);
  }
  for(i = 0; i < blocks; i++){
  d2:	4481                	li	s1,0
  if(fd < 0){
  d4:	02054e63          	bltz	a0,110 <main+0x110>
  for(i = 0; i < blocks; i++){
  d8:	69c1                	lui	s3,0x10
  da:	10b98993          	addi	s3,s3,267 # 1010b <base+0xf0fb>
    int cc = read(fd, buf, sizeof(buf));
  de:	40000613          	li	a2,1024
  e2:	bd040593          	addi	a1,s0,-1072
  e6:	854a                	mv	a0,s2
  e8:	2e4000ef          	jal	3cc <read>
    if(cc <= 0){
  ec:	02a05b63          	blez	a0,122 <main+0x122>
      printf("bigfile: read error at block %d\n", i);
      exit(-1);
    }
    if(*(int*)buf != i){
  f0:	bd042583          	lw	a1,-1072(s0)
  f4:	04959163          	bne	a1,s1,136 <main+0x136>
  for(i = 0; i < blocks; i++){
  f8:	2485                	addiw	s1,s1,1
  fa:	ff3492e3          	bne	s1,s3,de <main+0xde>
             *(int*)buf, i);
      exit(-1);
    }
  }

  printf("bigfile done; ok\n"); 
  fe:	00001517          	auipc	a0,0x1
 102:	98a50513          	addi	a0,a0,-1654 # a88 <malloc+0x200>
 106:	6ce000ef          	jal	7d4 <printf>

  exit(0);
 10a:	4501                	li	a0,0
 10c:	2a8000ef          	jal	3b4 <exit>
    printf("bigfile: cannot re-open big.file for reading\n");
 110:	00001517          	auipc	a0,0x1
 114:	8f050513          	addi	a0,a0,-1808 # a00 <malloc+0x178>
 118:	6bc000ef          	jal	7d4 <printf>
    exit(-1);
 11c:	557d                	li	a0,-1
 11e:	296000ef          	jal	3b4 <exit>
      printf("bigfile: read error at block %d\n", i);
 122:	85a6                	mv	a1,s1
 124:	00001517          	auipc	a0,0x1
 128:	90c50513          	addi	a0,a0,-1780 # a30 <malloc+0x1a8>
 12c:	6a8000ef          	jal	7d4 <printf>
      exit(-1);
 130:	557d                	li	a0,-1
 132:	282000ef          	jal	3b4 <exit>
      printf("bigfile: read the wrong data (%d) for block %d\n",
 136:	8626                	mv	a2,s1
 138:	00001517          	auipc	a0,0x1
 13c:	92050513          	addi	a0,a0,-1760 # a58 <malloc+0x1d0>
 140:	694000ef          	jal	7d4 <printf>
      exit(-1);
 144:	557d                	li	a0,-1
 146:	26e000ef          	jal	3b4 <exit>

000000000000014a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  extern int main();
  main();
 152:	eafff0ef          	jal	0 <main>
  exit(0);
 156:	4501                	li	a0,0
 158:	25c000ef          	jal	3b4 <exit>

000000000000015c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e422                	sd	s0,8(sp)
 160:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 162:	87aa                	mv	a5,a0
 164:	0585                	addi	a1,a1,1
 166:	0785                	addi	a5,a5,1
 168:	fff5c703          	lbu	a4,-1(a1)
 16c:	fee78fa3          	sb	a4,-1(a5)
 170:	fb75                	bnez	a4,164 <strcpy+0x8>
    ;
  return os;
}
 172:	6422                	ld	s0,8(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret

0000000000000178 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 178:	1141                	addi	sp,sp,-16
 17a:	e422                	sd	s0,8(sp)
 17c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 17e:	00054783          	lbu	a5,0(a0)
 182:	cb91                	beqz	a5,196 <strcmp+0x1e>
 184:	0005c703          	lbu	a4,0(a1)
 188:	00f71763          	bne	a4,a5,196 <strcmp+0x1e>
    p++, q++;
 18c:	0505                	addi	a0,a0,1
 18e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 190:	00054783          	lbu	a5,0(a0)
 194:	fbe5                	bnez	a5,184 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 196:	0005c503          	lbu	a0,0(a1)
}
 19a:	40a7853b          	subw	a0,a5,a0
 19e:	6422                	ld	s0,8(sp)
 1a0:	0141                	addi	sp,sp,16
 1a2:	8082                	ret

00000000000001a4 <strlen>:

uint
strlen(const char *s)
{
 1a4:	1141                	addi	sp,sp,-16
 1a6:	e422                	sd	s0,8(sp)
 1a8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1aa:	00054783          	lbu	a5,0(a0)
 1ae:	cf91                	beqz	a5,1ca <strlen+0x26>
 1b0:	0505                	addi	a0,a0,1
 1b2:	87aa                	mv	a5,a0
 1b4:	86be                	mv	a3,a5
 1b6:	0785                	addi	a5,a5,1
 1b8:	fff7c703          	lbu	a4,-1(a5)
 1bc:	ff65                	bnez	a4,1b4 <strlen+0x10>
 1be:	40a6853b          	subw	a0,a3,a0
 1c2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 1c4:	6422                	ld	s0,8(sp)
 1c6:	0141                	addi	sp,sp,16
 1c8:	8082                	ret
  for(n = 0; s[n]; n++)
 1ca:	4501                	li	a0,0
 1cc:	bfe5                	j	1c4 <strlen+0x20>

00000000000001ce <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e422                	sd	s0,8(sp)
 1d2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1d4:	ca19                	beqz	a2,1ea <memset+0x1c>
 1d6:	87aa                	mv	a5,a0
 1d8:	1602                	slli	a2,a2,0x20
 1da:	9201                	srli	a2,a2,0x20
 1dc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1e0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1e4:	0785                	addi	a5,a5,1
 1e6:	fee79de3          	bne	a5,a4,1e0 <memset+0x12>
  }
  return dst;
}
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret

00000000000001f0 <strchr>:

char*
strchr(const char *s, char c)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1f6:	00054783          	lbu	a5,0(a0)
 1fa:	cb99                	beqz	a5,210 <strchr+0x20>
    if(*s == c)
 1fc:	00f58763          	beq	a1,a5,20a <strchr+0x1a>
  for(; *s; s++)
 200:	0505                	addi	a0,a0,1
 202:	00054783          	lbu	a5,0(a0)
 206:	fbfd                	bnez	a5,1fc <strchr+0xc>
      return (char*)s;
  return 0;
 208:	4501                	li	a0,0
}
 20a:	6422                	ld	s0,8(sp)
 20c:	0141                	addi	sp,sp,16
 20e:	8082                	ret
  return 0;
 210:	4501                	li	a0,0
 212:	bfe5                	j	20a <strchr+0x1a>

0000000000000214 <gets>:

char*
gets(char *buf, int max)
{
 214:	711d                	addi	sp,sp,-96
 216:	ec86                	sd	ra,88(sp)
 218:	e8a2                	sd	s0,80(sp)
 21a:	e4a6                	sd	s1,72(sp)
 21c:	e0ca                	sd	s2,64(sp)
 21e:	fc4e                	sd	s3,56(sp)
 220:	f852                	sd	s4,48(sp)
 222:	f456                	sd	s5,40(sp)
 224:	f05a                	sd	s6,32(sp)
 226:	ec5e                	sd	s7,24(sp)
 228:	1080                	addi	s0,sp,96
 22a:	8baa                	mv	s7,a0
 22c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22e:	892a                	mv	s2,a0
 230:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 232:	4aa9                	li	s5,10
 234:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 236:	89a6                	mv	s3,s1
 238:	2485                	addiw	s1,s1,1
 23a:	0344d663          	bge	s1,s4,266 <gets+0x52>
    cc = read(0, &c, 1);
 23e:	4605                	li	a2,1
 240:	faf40593          	addi	a1,s0,-81
 244:	4501                	li	a0,0
 246:	186000ef          	jal	3cc <read>
    if(cc < 1)
 24a:	00a05e63          	blez	a0,266 <gets+0x52>
    buf[i++] = c;
 24e:	faf44783          	lbu	a5,-81(s0)
 252:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 256:	01578763          	beq	a5,s5,264 <gets+0x50>
 25a:	0905                	addi	s2,s2,1
 25c:	fd679de3          	bne	a5,s6,236 <gets+0x22>
    buf[i++] = c;
 260:	89a6                	mv	s3,s1
 262:	a011                	j	266 <gets+0x52>
 264:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 266:	99de                	add	s3,s3,s7
 268:	00098023          	sb	zero,0(s3)
  return buf;
}
 26c:	855e                	mv	a0,s7
 26e:	60e6                	ld	ra,88(sp)
 270:	6446                	ld	s0,80(sp)
 272:	64a6                	ld	s1,72(sp)
 274:	6906                	ld	s2,64(sp)
 276:	79e2                	ld	s3,56(sp)
 278:	7a42                	ld	s4,48(sp)
 27a:	7aa2                	ld	s5,40(sp)
 27c:	7b02                	ld	s6,32(sp)
 27e:	6be2                	ld	s7,24(sp)
 280:	6125                	addi	sp,sp,96
 282:	8082                	ret

0000000000000284 <stat>:

int
stat(const char *n, struct stat *st)
{
 284:	1101                	addi	sp,sp,-32
 286:	ec06                	sd	ra,24(sp)
 288:	e822                	sd	s0,16(sp)
 28a:	e04a                	sd	s2,0(sp)
 28c:	1000                	addi	s0,sp,32
 28e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 290:	4581                	li	a1,0
 292:	162000ef          	jal	3f4 <open>
  if(fd < 0)
 296:	02054263          	bltz	a0,2ba <stat+0x36>
 29a:	e426                	sd	s1,8(sp)
 29c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 29e:	85ca                	mv	a1,s2
 2a0:	16c000ef          	jal	40c <fstat>
 2a4:	892a                	mv	s2,a0
  close(fd);
 2a6:	8526                	mv	a0,s1
 2a8:	134000ef          	jal	3dc <close>
  return r;
 2ac:	64a2                	ld	s1,8(sp)
}
 2ae:	854a                	mv	a0,s2
 2b0:	60e2                	ld	ra,24(sp)
 2b2:	6442                	ld	s0,16(sp)
 2b4:	6902                	ld	s2,0(sp)
 2b6:	6105                	addi	sp,sp,32
 2b8:	8082                	ret
    return -1;
 2ba:	597d                	li	s2,-1
 2bc:	bfcd                	j	2ae <stat+0x2a>

00000000000002be <atoi>:

int
atoi(const char *s)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e422                	sd	s0,8(sp)
 2c2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2c4:	00054683          	lbu	a3,0(a0)
 2c8:	fd06879b          	addiw	a5,a3,-48
 2cc:	0ff7f793          	zext.b	a5,a5
 2d0:	4625                	li	a2,9
 2d2:	02f66863          	bltu	a2,a5,302 <atoi+0x44>
 2d6:	872a                	mv	a4,a0
  n = 0;
 2d8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2da:	0705                	addi	a4,a4,1
 2dc:	0025179b          	slliw	a5,a0,0x2
 2e0:	9fa9                	addw	a5,a5,a0
 2e2:	0017979b          	slliw	a5,a5,0x1
 2e6:	9fb5                	addw	a5,a5,a3
 2e8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2ec:	00074683          	lbu	a3,0(a4)
 2f0:	fd06879b          	addiw	a5,a3,-48
 2f4:	0ff7f793          	zext.b	a5,a5
 2f8:	fef671e3          	bgeu	a2,a5,2da <atoi+0x1c>
  return n;
}
 2fc:	6422                	ld	s0,8(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret
  n = 0;
 302:	4501                	li	a0,0
 304:	bfe5                	j	2fc <atoi+0x3e>

0000000000000306 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 306:	1141                	addi	sp,sp,-16
 308:	e422                	sd	s0,8(sp)
 30a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 30c:	02b57463          	bgeu	a0,a1,334 <memmove+0x2e>
    while(n-- > 0)
 310:	00c05f63          	blez	a2,32e <memmove+0x28>
 314:	1602                	slli	a2,a2,0x20
 316:	9201                	srli	a2,a2,0x20
 318:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 31c:	872a                	mv	a4,a0
      *dst++ = *src++;
 31e:	0585                	addi	a1,a1,1
 320:	0705                	addi	a4,a4,1
 322:	fff5c683          	lbu	a3,-1(a1)
 326:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 32a:	fef71ae3          	bne	a4,a5,31e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 32e:	6422                	ld	s0,8(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret
    dst += n;
 334:	00c50733          	add	a4,a0,a2
    src += n;
 338:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 33a:	fec05ae3          	blez	a2,32e <memmove+0x28>
 33e:	fff6079b          	addiw	a5,a2,-1
 342:	1782                	slli	a5,a5,0x20
 344:	9381                	srli	a5,a5,0x20
 346:	fff7c793          	not	a5,a5
 34a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 34c:	15fd                	addi	a1,a1,-1
 34e:	177d                	addi	a4,a4,-1
 350:	0005c683          	lbu	a3,0(a1)
 354:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 358:	fee79ae3          	bne	a5,a4,34c <memmove+0x46>
 35c:	bfc9                	j	32e <memmove+0x28>

000000000000035e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e422                	sd	s0,8(sp)
 362:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 364:	ca05                	beqz	a2,394 <memcmp+0x36>
 366:	fff6069b          	addiw	a3,a2,-1
 36a:	1682                	slli	a3,a3,0x20
 36c:	9281                	srli	a3,a3,0x20
 36e:	0685                	addi	a3,a3,1
 370:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 372:	00054783          	lbu	a5,0(a0)
 376:	0005c703          	lbu	a4,0(a1)
 37a:	00e79863          	bne	a5,a4,38a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 37e:	0505                	addi	a0,a0,1
    p2++;
 380:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 382:	fed518e3          	bne	a0,a3,372 <memcmp+0x14>
  }
  return 0;
 386:	4501                	li	a0,0
 388:	a019                	j	38e <memcmp+0x30>
      return *p1 - *p2;
 38a:	40e7853b          	subw	a0,a5,a4
}
 38e:	6422                	ld	s0,8(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret
  return 0;
 394:	4501                	li	a0,0
 396:	bfe5                	j	38e <memcmp+0x30>

0000000000000398 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 398:	1141                	addi	sp,sp,-16
 39a:	e406                	sd	ra,8(sp)
 39c:	e022                	sd	s0,0(sp)
 39e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3a0:	f67ff0ef          	jal	306 <memmove>
}
 3a4:	60a2                	ld	ra,8(sp)
 3a6:	6402                	ld	s0,0(sp)
 3a8:	0141                	addi	sp,sp,16
 3aa:	8082                	ret

00000000000003ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ac:	4885                	li	a7,1
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b4:	4889                	li	a7,2
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <wait>:
.global wait
wait:
 li a7, SYS_wait
 3bc:	488d                	li	a7,3
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c4:	4891                	li	a7,4
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <read>:
.global read
read:
 li a7, SYS_read
 3cc:	4895                	li	a7,5
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <write>:
.global write
write:
 li a7, SYS_write
 3d4:	48c1                	li	a7,16
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <close>:
.global close
close:
 li a7, SYS_close
 3dc:	48d5                	li	a7,21
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e4:	4899                	li	a7,6
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ec:	489d                	li	a7,7
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <open>:
.global open
open:
 li a7, SYS_open
 3f4:	48bd                	li	a7,15
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3fc:	48c5                	li	a7,17
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 404:	48c9                	li	a7,18
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 40c:	48a1                	li	a7,8
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <link>:
.global link
link:
 li a7, SYS_link
 414:	48cd                	li	a7,19
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 41c:	48d1                	li	a7,20
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 424:	48a5                	li	a7,9
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <dup>:
.global dup
dup:
 li a7, SYS_dup
 42c:	48a9                	li	a7,10
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 434:	48ad                	li	a7,11
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 43c:	48b1                	li	a7,12
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 444:	48b5                	li	a7,13
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 44c:	48b9                	li	a7,14
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 454:	48d9                	li	a7,22
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45c:	1101                	addi	sp,sp,-32
 45e:	ec06                	sd	ra,24(sp)
 460:	e822                	sd	s0,16(sp)
 462:	1000                	addi	s0,sp,32
 464:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 468:	4605                	li	a2,1
 46a:	fef40593          	addi	a1,s0,-17
 46e:	f67ff0ef          	jal	3d4 <write>
}
 472:	60e2                	ld	ra,24(sp)
 474:	6442                	ld	s0,16(sp)
 476:	6105                	addi	sp,sp,32
 478:	8082                	ret

000000000000047a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 47a:	7139                	addi	sp,sp,-64
 47c:	fc06                	sd	ra,56(sp)
 47e:	f822                	sd	s0,48(sp)
 480:	f426                	sd	s1,40(sp)
 482:	0080                	addi	s0,sp,64
 484:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 486:	c299                	beqz	a3,48c <printint+0x12>
 488:	0805c963          	bltz	a1,51a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 48c:	2581                	sext.w	a1,a1
  neg = 0;
 48e:	4881                	li	a7,0
 490:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 494:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 496:	2601                	sext.w	a2,a2
 498:	00000517          	auipc	a0,0x0
 49c:	61050513          	addi	a0,a0,1552 # aa8 <digits>
 4a0:	883a                	mv	a6,a4
 4a2:	2705                	addiw	a4,a4,1
 4a4:	02c5f7bb          	remuw	a5,a1,a2
 4a8:	1782                	slli	a5,a5,0x20
 4aa:	9381                	srli	a5,a5,0x20
 4ac:	97aa                	add	a5,a5,a0
 4ae:	0007c783          	lbu	a5,0(a5)
 4b2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b6:	0005879b          	sext.w	a5,a1
 4ba:	02c5d5bb          	divuw	a1,a1,a2
 4be:	0685                	addi	a3,a3,1
 4c0:	fec7f0e3          	bgeu	a5,a2,4a0 <printint+0x26>
  if(neg)
 4c4:	00088c63          	beqz	a7,4dc <printint+0x62>
    buf[i++] = '-';
 4c8:	fd070793          	addi	a5,a4,-48
 4cc:	00878733          	add	a4,a5,s0
 4d0:	02d00793          	li	a5,45
 4d4:	fef70823          	sb	a5,-16(a4)
 4d8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 4dc:	02e05a63          	blez	a4,510 <printint+0x96>
 4e0:	f04a                	sd	s2,32(sp)
 4e2:	ec4e                	sd	s3,24(sp)
 4e4:	fc040793          	addi	a5,s0,-64
 4e8:	00e78933          	add	s2,a5,a4
 4ec:	fff78993          	addi	s3,a5,-1
 4f0:	99ba                	add	s3,s3,a4
 4f2:	377d                	addiw	a4,a4,-1
 4f4:	1702                	slli	a4,a4,0x20
 4f6:	9301                	srli	a4,a4,0x20
 4f8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fc:	fff94583          	lbu	a1,-1(s2)
 500:	8526                	mv	a0,s1
 502:	f5bff0ef          	jal	45c <putc>
  while(--i >= 0)
 506:	197d                	addi	s2,s2,-1
 508:	ff391ae3          	bne	s2,s3,4fc <printint+0x82>
 50c:	7902                	ld	s2,32(sp)
 50e:	69e2                	ld	s3,24(sp)
}
 510:	70e2                	ld	ra,56(sp)
 512:	7442                	ld	s0,48(sp)
 514:	74a2                	ld	s1,40(sp)
 516:	6121                	addi	sp,sp,64
 518:	8082                	ret
    x = -xx;
 51a:	40b005bb          	negw	a1,a1
    neg = 1;
 51e:	4885                	li	a7,1
    x = -xx;
 520:	bf85                	j	490 <printint+0x16>

0000000000000522 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 522:	711d                	addi	sp,sp,-96
 524:	ec86                	sd	ra,88(sp)
 526:	e8a2                	sd	s0,80(sp)
 528:	e0ca                	sd	s2,64(sp)
 52a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52c:	0005c903          	lbu	s2,0(a1)
 530:	26090863          	beqz	s2,7a0 <vprintf+0x27e>
 534:	e4a6                	sd	s1,72(sp)
 536:	fc4e                	sd	s3,56(sp)
 538:	f852                	sd	s4,48(sp)
 53a:	f456                	sd	s5,40(sp)
 53c:	f05a                	sd	s6,32(sp)
 53e:	ec5e                	sd	s7,24(sp)
 540:	e862                	sd	s8,16(sp)
 542:	e466                	sd	s9,8(sp)
 544:	8b2a                	mv	s6,a0
 546:	8a2e                	mv	s4,a1
 548:	8bb2                	mv	s7,a2
  state = 0;
 54a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 54c:	4481                	li	s1,0
 54e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 550:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 554:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 558:	06c00c93          	li	s9,108
 55c:	a005                	j	57c <vprintf+0x5a>
        putc(fd, c0);
 55e:	85ca                	mv	a1,s2
 560:	855a                	mv	a0,s6
 562:	efbff0ef          	jal	45c <putc>
 566:	a019                	j	56c <vprintf+0x4a>
    } else if(state == '%'){
 568:	03598263          	beq	s3,s5,58c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 56c:	2485                	addiw	s1,s1,1
 56e:	8726                	mv	a4,s1
 570:	009a07b3          	add	a5,s4,s1
 574:	0007c903          	lbu	s2,0(a5)
 578:	20090c63          	beqz	s2,790 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 57c:	0009079b          	sext.w	a5,s2
    if(state == 0){
 580:	fe0994e3          	bnez	s3,568 <vprintf+0x46>
      if(c0 == '%'){
 584:	fd579de3          	bne	a5,s5,55e <vprintf+0x3c>
        state = '%';
 588:	89be                	mv	s3,a5
 58a:	b7cd                	j	56c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 58c:	00ea06b3          	add	a3,s4,a4
 590:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 594:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 596:	c681                	beqz	a3,59e <vprintf+0x7c>
 598:	9752                	add	a4,a4,s4
 59a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 59e:	03878f63          	beq	a5,s8,5dc <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 5a2:	05978963          	beq	a5,s9,5f4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 5a6:	07500713          	li	a4,117
 5aa:	0ee78363          	beq	a5,a4,690 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 5ae:	07800713          	li	a4,120
 5b2:	12e78563          	beq	a5,a4,6dc <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 5b6:	07000713          	li	a4,112
 5ba:	14e78a63          	beq	a5,a4,70e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 5be:	07300713          	li	a4,115
 5c2:	18e78a63          	beq	a5,a4,756 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 5c6:	02500713          	li	a4,37
 5ca:	04e79563          	bne	a5,a4,614 <vprintf+0xf2>
        putc(fd, '%');
 5ce:	02500593          	li	a1,37
 5d2:	855a                	mv	a0,s6
 5d4:	e89ff0ef          	jal	45c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	bf49                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 5dc:	008b8913          	addi	s2,s7,8
 5e0:	4685                	li	a3,1
 5e2:	4629                	li	a2,10
 5e4:	000ba583          	lw	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	e91ff0ef          	jal	47a <printint>
 5ee:	8bca                	mv	s7,s2
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	bfad                	j	56c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 5f4:	06400793          	li	a5,100
 5f8:	02f68963          	beq	a3,a5,62a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5fc:	06c00793          	li	a5,108
 600:	04f68263          	beq	a3,a5,644 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 604:	07500793          	li	a5,117
 608:	0af68063          	beq	a3,a5,6a8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 60c:	07800793          	li	a5,120
 610:	0ef68263          	beq	a3,a5,6f4 <vprintf+0x1d2>
        putc(fd, '%');
 614:	02500593          	li	a1,37
 618:	855a                	mv	a0,s6
 61a:	e43ff0ef          	jal	45c <putc>
        putc(fd, c0);
 61e:	85ca                	mv	a1,s2
 620:	855a                	mv	a0,s6
 622:	e3bff0ef          	jal	45c <putc>
      state = 0;
 626:	4981                	li	s3,0
 628:	b791                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 62a:	008b8913          	addi	s2,s7,8
 62e:	4685                	li	a3,1
 630:	4629                	li	a2,10
 632:	000ba583          	lw	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	e43ff0ef          	jal	47a <printint>
        i += 1;
 63c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 63e:	8bca                	mv	s7,s2
      state = 0;
 640:	4981                	li	s3,0
        i += 1;
 642:	b72d                	j	56c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 644:	06400793          	li	a5,100
 648:	02f60763          	beq	a2,a5,676 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 64c:	07500793          	li	a5,117
 650:	06f60963          	beq	a2,a5,6c2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 654:	07800793          	li	a5,120
 658:	faf61ee3          	bne	a2,a5,614 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65c:	008b8913          	addi	s2,s7,8
 660:	4681                	li	a3,0
 662:	4641                	li	a2,16
 664:	000ba583          	lw	a1,0(s7)
 668:	855a                	mv	a0,s6
 66a:	e11ff0ef          	jal	47a <printint>
        i += 2;
 66e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 670:	8bca                	mv	s7,s2
      state = 0;
 672:	4981                	li	s3,0
        i += 2;
 674:	bde5                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 676:	008b8913          	addi	s2,s7,8
 67a:	4685                	li	a3,1
 67c:	4629                	li	a2,10
 67e:	000ba583          	lw	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	df7ff0ef          	jal	47a <printint>
        i += 2;
 688:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 68a:	8bca                	mv	s7,s2
      state = 0;
 68c:	4981                	li	s3,0
        i += 2;
 68e:	bdf9                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 690:	008b8913          	addi	s2,s7,8
 694:	4681                	li	a3,0
 696:	4629                	li	a2,10
 698:	000ba583          	lw	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	dddff0ef          	jal	47a <printint>
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b5d9                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a8:	008b8913          	addi	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4629                	li	a2,10
 6b0:	000ba583          	lw	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	dc5ff0ef          	jal	47a <printint>
        i += 1;
 6ba:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6bc:	8bca                	mv	s7,s2
      state = 0;
 6be:	4981                	li	s3,0
        i += 1;
 6c0:	b575                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c2:	008b8913          	addi	s2,s7,8
 6c6:	4681                	li	a3,0
 6c8:	4629                	li	a2,10
 6ca:	000ba583          	lw	a1,0(s7)
 6ce:	855a                	mv	a0,s6
 6d0:	dabff0ef          	jal	47a <printint>
        i += 2;
 6d4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d6:	8bca                	mv	s7,s2
      state = 0;
 6d8:	4981                	li	s3,0
        i += 2;
 6da:	bd49                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 6dc:	008b8913          	addi	s2,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4641                	li	a2,16
 6e4:	000ba583          	lw	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	d91ff0ef          	jal	47a <printint>
 6ee:	8bca                	mv	s7,s2
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	bdad                	j	56c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f4:	008b8913          	addi	s2,s7,8
 6f8:	4681                	li	a3,0
 6fa:	4641                	li	a2,16
 6fc:	000ba583          	lw	a1,0(s7)
 700:	855a                	mv	a0,s6
 702:	d79ff0ef          	jal	47a <printint>
        i += 1;
 706:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 708:	8bca                	mv	s7,s2
      state = 0;
 70a:	4981                	li	s3,0
        i += 1;
 70c:	b585                	j	56c <vprintf+0x4a>
 70e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 710:	008b8d13          	addi	s10,s7,8
 714:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 718:	03000593          	li	a1,48
 71c:	855a                	mv	a0,s6
 71e:	d3fff0ef          	jal	45c <putc>
  putc(fd, 'x');
 722:	07800593          	li	a1,120
 726:	855a                	mv	a0,s6
 728:	d35ff0ef          	jal	45c <putc>
 72c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 72e:	00000b97          	auipc	s7,0x0
 732:	37ab8b93          	addi	s7,s7,890 # aa8 <digits>
 736:	03c9d793          	srli	a5,s3,0x3c
 73a:	97de                	add	a5,a5,s7
 73c:	0007c583          	lbu	a1,0(a5)
 740:	855a                	mv	a0,s6
 742:	d1bff0ef          	jal	45c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 746:	0992                	slli	s3,s3,0x4
 748:	397d                	addiw	s2,s2,-1
 74a:	fe0916e3          	bnez	s2,736 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 74e:	8bea                	mv	s7,s10
      state = 0;
 750:	4981                	li	s3,0
 752:	6d02                	ld	s10,0(sp)
 754:	bd21                	j	56c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 756:	008b8993          	addi	s3,s7,8
 75a:	000bb903          	ld	s2,0(s7)
 75e:	00090f63          	beqz	s2,77c <vprintf+0x25a>
        for(; *s; s++)
 762:	00094583          	lbu	a1,0(s2)
 766:	c195                	beqz	a1,78a <vprintf+0x268>
          putc(fd, *s);
 768:	855a                	mv	a0,s6
 76a:	cf3ff0ef          	jal	45c <putc>
        for(; *s; s++)
 76e:	0905                	addi	s2,s2,1
 770:	00094583          	lbu	a1,0(s2)
 774:	f9f5                	bnez	a1,768 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 776:	8bce                	mv	s7,s3
      state = 0;
 778:	4981                	li	s3,0
 77a:	bbcd                	j	56c <vprintf+0x4a>
          s = "(null)";
 77c:	00000917          	auipc	s2,0x0
 780:	32490913          	addi	s2,s2,804 # aa0 <malloc+0x218>
        for(; *s; s++)
 784:	02800593          	li	a1,40
 788:	b7c5                	j	768 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 78a:	8bce                	mv	s7,s3
      state = 0;
 78c:	4981                	li	s3,0
 78e:	bbf9                	j	56c <vprintf+0x4a>
 790:	64a6                	ld	s1,72(sp)
 792:	79e2                	ld	s3,56(sp)
 794:	7a42                	ld	s4,48(sp)
 796:	7aa2                	ld	s5,40(sp)
 798:	7b02                	ld	s6,32(sp)
 79a:	6be2                	ld	s7,24(sp)
 79c:	6c42                	ld	s8,16(sp)
 79e:	6ca2                	ld	s9,8(sp)
    }
  }
}
 7a0:	60e6                	ld	ra,88(sp)
 7a2:	6446                	ld	s0,80(sp)
 7a4:	6906                	ld	s2,64(sp)
 7a6:	6125                	addi	sp,sp,96
 7a8:	8082                	ret

00000000000007aa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7aa:	715d                	addi	sp,sp,-80
 7ac:	ec06                	sd	ra,24(sp)
 7ae:	e822                	sd	s0,16(sp)
 7b0:	1000                	addi	s0,sp,32
 7b2:	e010                	sd	a2,0(s0)
 7b4:	e414                	sd	a3,8(s0)
 7b6:	e818                	sd	a4,16(s0)
 7b8:	ec1c                	sd	a5,24(s0)
 7ba:	03043023          	sd	a6,32(s0)
 7be:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c6:	8622                	mv	a2,s0
 7c8:	d5bff0ef          	jal	522 <vprintf>
}
 7cc:	60e2                	ld	ra,24(sp)
 7ce:	6442                	ld	s0,16(sp)
 7d0:	6161                	addi	sp,sp,80
 7d2:	8082                	ret

00000000000007d4 <printf>:

void
printf(const char *fmt, ...)
{
 7d4:	711d                	addi	sp,sp,-96
 7d6:	ec06                	sd	ra,24(sp)
 7d8:	e822                	sd	s0,16(sp)
 7da:	1000                	addi	s0,sp,32
 7dc:	e40c                	sd	a1,8(s0)
 7de:	e810                	sd	a2,16(s0)
 7e0:	ec14                	sd	a3,24(s0)
 7e2:	f018                	sd	a4,32(s0)
 7e4:	f41c                	sd	a5,40(s0)
 7e6:	03043823          	sd	a6,48(s0)
 7ea:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ee:	00840613          	addi	a2,s0,8
 7f2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f6:	85aa                	mv	a1,a0
 7f8:	4505                	li	a0,1
 7fa:	d29ff0ef          	jal	522 <vprintf>
}
 7fe:	60e2                	ld	ra,24(sp)
 800:	6442                	ld	s0,16(sp)
 802:	6125                	addi	sp,sp,96
 804:	8082                	ret

0000000000000806 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 806:	1141                	addi	sp,sp,-16
 808:	e422                	sd	s0,8(sp)
 80a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 80c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 810:	00000797          	auipc	a5,0x0
 814:	7f07b783          	ld	a5,2032(a5) # 1000 <freep>
 818:	a02d                	j	842 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 81a:	4618                	lw	a4,8(a2)
 81c:	9f2d                	addw	a4,a4,a1
 81e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 822:	6398                	ld	a4,0(a5)
 824:	6310                	ld	a2,0(a4)
 826:	a83d                	j	864 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 828:	ff852703          	lw	a4,-8(a0)
 82c:	9f31                	addw	a4,a4,a2
 82e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 830:	ff053683          	ld	a3,-16(a0)
 834:	a091                	j	878 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 836:	6398                	ld	a4,0(a5)
 838:	00e7e463          	bltu	a5,a4,840 <free+0x3a>
 83c:	00e6ea63          	bltu	a3,a4,850 <free+0x4a>
{
 840:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 842:	fed7fae3          	bgeu	a5,a3,836 <free+0x30>
 846:	6398                	ld	a4,0(a5)
 848:	00e6e463          	bltu	a3,a4,850 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84c:	fee7eae3          	bltu	a5,a4,840 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 850:	ff852583          	lw	a1,-8(a0)
 854:	6390                	ld	a2,0(a5)
 856:	02059813          	slli	a6,a1,0x20
 85a:	01c85713          	srli	a4,a6,0x1c
 85e:	9736                	add	a4,a4,a3
 860:	fae60de3          	beq	a2,a4,81a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 864:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 868:	4790                	lw	a2,8(a5)
 86a:	02061593          	slli	a1,a2,0x20
 86e:	01c5d713          	srli	a4,a1,0x1c
 872:	973e                	add	a4,a4,a5
 874:	fae68ae3          	beq	a3,a4,828 <free+0x22>
    p->s.ptr = bp->s.ptr;
 878:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 87a:	00000717          	auipc	a4,0x0
 87e:	78f73323          	sd	a5,1926(a4) # 1000 <freep>
}
 882:	6422                	ld	s0,8(sp)
 884:	0141                	addi	sp,sp,16
 886:	8082                	ret

0000000000000888 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 888:	7139                	addi	sp,sp,-64
 88a:	fc06                	sd	ra,56(sp)
 88c:	f822                	sd	s0,48(sp)
 88e:	f426                	sd	s1,40(sp)
 890:	ec4e                	sd	s3,24(sp)
 892:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 894:	02051493          	slli	s1,a0,0x20
 898:	9081                	srli	s1,s1,0x20
 89a:	04bd                	addi	s1,s1,15
 89c:	8091                	srli	s1,s1,0x4
 89e:	0014899b          	addiw	s3,s1,1
 8a2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8a4:	00000517          	auipc	a0,0x0
 8a8:	75c53503          	ld	a0,1884(a0) # 1000 <freep>
 8ac:	c915                	beqz	a0,8e0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b0:	4798                	lw	a4,8(a5)
 8b2:	08977a63          	bgeu	a4,s1,946 <malloc+0xbe>
 8b6:	f04a                	sd	s2,32(sp)
 8b8:	e852                	sd	s4,16(sp)
 8ba:	e456                	sd	s5,8(sp)
 8bc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8be:	8a4e                	mv	s4,s3
 8c0:	0009871b          	sext.w	a4,s3
 8c4:	6685                	lui	a3,0x1
 8c6:	00d77363          	bgeu	a4,a3,8cc <malloc+0x44>
 8ca:	6a05                	lui	s4,0x1
 8cc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d4:	00000917          	auipc	s2,0x0
 8d8:	72c90913          	addi	s2,s2,1836 # 1000 <freep>
  if(p == (char*)-1)
 8dc:	5afd                	li	s5,-1
 8de:	a081                	j	91e <malloc+0x96>
 8e0:	f04a                	sd	s2,32(sp)
 8e2:	e852                	sd	s4,16(sp)
 8e4:	e456                	sd	s5,8(sp)
 8e6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e8:	00000797          	auipc	a5,0x0
 8ec:	72878793          	addi	a5,a5,1832 # 1010 <base>
 8f0:	00000717          	auipc	a4,0x0
 8f4:	70f73823          	sd	a5,1808(a4) # 1000 <freep>
 8f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fe:	b7c1                	j	8be <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 900:	6398                	ld	a4,0(a5)
 902:	e118                	sd	a4,0(a0)
 904:	a8a9                	j	95e <malloc+0xd6>
  hp->s.size = nu;
 906:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 90a:	0541                	addi	a0,a0,16
 90c:	efbff0ef          	jal	806 <free>
  return freep;
 910:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 914:	c12d                	beqz	a0,976 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 916:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 918:	4798                	lw	a4,8(a5)
 91a:	02977263          	bgeu	a4,s1,93e <malloc+0xb6>
    if(p == freep)
 91e:	00093703          	ld	a4,0(s2)
 922:	853e                	mv	a0,a5
 924:	fef719e3          	bne	a4,a5,916 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 928:	8552                	mv	a0,s4
 92a:	b13ff0ef          	jal	43c <sbrk>
  if(p == (char*)-1)
 92e:	fd551ce3          	bne	a0,s5,906 <malloc+0x7e>
        return 0;
 932:	4501                	li	a0,0
 934:	7902                	ld	s2,32(sp)
 936:	6a42                	ld	s4,16(sp)
 938:	6aa2                	ld	s5,8(sp)
 93a:	6b02                	ld	s6,0(sp)
 93c:	a03d                	j	96a <malloc+0xe2>
 93e:	7902                	ld	s2,32(sp)
 940:	6a42                	ld	s4,16(sp)
 942:	6aa2                	ld	s5,8(sp)
 944:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 946:	fae48de3          	beq	s1,a4,900 <malloc+0x78>
        p->s.size -= nunits;
 94a:	4137073b          	subw	a4,a4,s3
 94e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 950:	02071693          	slli	a3,a4,0x20
 954:	01c6d713          	srli	a4,a3,0x1c
 958:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 95a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 95e:	00000717          	auipc	a4,0x0
 962:	6aa73123          	sd	a0,1698(a4) # 1000 <freep>
      return (void*)(p + 1);
 966:	01078513          	addi	a0,a5,16
  }
}
 96a:	70e2                	ld	ra,56(sp)
 96c:	7442                	ld	s0,48(sp)
 96e:	74a2                	ld	s1,40(sp)
 970:	69e2                	ld	s3,24(sp)
 972:	6121                	addi	sp,sp,64
 974:	8082                	ret
 976:	7902                	ld	s2,32(sp)
 978:	6a42                	ld	s4,16(sp)
 97a:	6aa2                	ld	s5,8(sp)
 97c:	6b02                	ld	s6,0(sp)
 97e:	b7f5                	j	96a <malloc+0xe2>
