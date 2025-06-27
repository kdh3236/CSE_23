
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	1a0000ef          	jal	1c8 <atoi>
  2c:	2c2000ef          	jal	2ee <kill>
  for(i=1; i<argc; i++)
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  36:	4501                	li	a0,0
  38:	286000ef          	jal	2be <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  40:	00001597          	auipc	a1,0x1
  44:	85058593          	addi	a1,a1,-1968 # 890 <malloc+0xfe>
  48:	4509                	li	a0,2
  4a:	66a000ef          	jal	6b4 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	26e000ef          	jal	2be <exit>

0000000000000054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  54:	1141                	addi	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	addi	s0,sp,16
  extern int main();
  main();
  5c:	fa5ff0ef          	jal	0 <main>
  exit(0);
  60:	4501                	li	a0,0
  62:	25c000ef          	jal	2be <exit>

0000000000000066 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  66:	1141                	addi	sp,sp,-16
  68:	e422                	sd	s0,8(sp)
  6a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6c:	87aa                	mv	a5,a0
  6e:	0585                	addi	a1,a1,1
  70:	0785                	addi	a5,a5,1
  72:	fff5c703          	lbu	a4,-1(a1)
  76:	fee78fa3          	sb	a4,-1(a5)
  7a:	fb75                	bnez	a4,6e <strcpy+0x8>
    ;
  return os;
}
  7c:	6422                	ld	s0,8(sp)
  7e:	0141                	addi	sp,sp,16
  80:	8082                	ret

0000000000000082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  82:	1141                	addi	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cb91                	beqz	a5,a0 <strcmp+0x1e>
  8e:	0005c703          	lbu	a4,0(a1)
  92:	00f71763          	bne	a4,a5,a0 <strcmp+0x1e>
    p++, q++;
  96:	0505                	addi	a0,a0,1
  98:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	fbe5                	bnez	a5,8e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  a0:	0005c503          	lbu	a0,0(a1)
}
  a4:	40a7853b          	subw	a0,a5,a0
  a8:	6422                	ld	s0,8(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e422                	sd	s0,8(sp)
  b2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cf91                	beqz	a5,d4 <strlen+0x26>
  ba:	0505                	addi	a0,a0,1
  bc:	87aa                	mv	a5,a0
  be:	86be                	mv	a3,a5
  c0:	0785                	addi	a5,a5,1
  c2:	fff7c703          	lbu	a4,-1(a5)
  c6:	ff65                	bnez	a4,be <strlen+0x10>
  c8:	40a6853b          	subw	a0,a3,a0
  cc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  ce:	6422                	ld	s0,8(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret
  for(n = 0; s[n]; n++)
  d4:	4501                	li	a0,0
  d6:	bfe5                	j	ce <strlen+0x20>

00000000000000d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  de:	ca19                	beqz	a2,f4 <memset+0x1c>
  e0:	87aa                	mv	a5,a0
  e2:	1602                	slli	a2,a2,0x20
  e4:	9201                	srli	a2,a2,0x20
  e6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  ee:	0785                	addi	a5,a5,1
  f0:	fee79de3          	bne	a5,a4,ea <memset+0x12>
  }
  return dst;
}
  f4:	6422                	ld	s0,8(sp)
  f6:	0141                	addi	sp,sp,16
  f8:	8082                	ret

00000000000000fa <strchr>:

char*
strchr(const char *s, char c)
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e422                	sd	s0,8(sp)
  fe:	0800                	addi	s0,sp,16
  for(; *s; s++)
 100:	00054783          	lbu	a5,0(a0)
 104:	cb99                	beqz	a5,11a <strchr+0x20>
    if(*s == c)
 106:	00f58763          	beq	a1,a5,114 <strchr+0x1a>
  for(; *s; s++)
 10a:	0505                	addi	a0,a0,1
 10c:	00054783          	lbu	a5,0(a0)
 110:	fbfd                	bnez	a5,106 <strchr+0xc>
      return (char*)s;
  return 0;
 112:	4501                	li	a0,0
}
 114:	6422                	ld	s0,8(sp)
 116:	0141                	addi	sp,sp,16
 118:	8082                	ret
  return 0;
 11a:	4501                	li	a0,0
 11c:	bfe5                	j	114 <strchr+0x1a>

000000000000011e <gets>:

char*
gets(char *buf, int max)
{
 11e:	711d                	addi	sp,sp,-96
 120:	ec86                	sd	ra,88(sp)
 122:	e8a2                	sd	s0,80(sp)
 124:	e4a6                	sd	s1,72(sp)
 126:	e0ca                	sd	s2,64(sp)
 128:	fc4e                	sd	s3,56(sp)
 12a:	f852                	sd	s4,48(sp)
 12c:	f456                	sd	s5,40(sp)
 12e:	f05a                	sd	s6,32(sp)
 130:	ec5e                	sd	s7,24(sp)
 132:	1080                	addi	s0,sp,96
 134:	8baa                	mv	s7,a0
 136:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 138:	892a                	mv	s2,a0
 13a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 13c:	4aa9                	li	s5,10
 13e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 140:	89a6                	mv	s3,s1
 142:	2485                	addiw	s1,s1,1
 144:	0344d663          	bge	s1,s4,170 <gets+0x52>
    cc = read(0, &c, 1);
 148:	4605                	li	a2,1
 14a:	faf40593          	addi	a1,s0,-81
 14e:	4501                	li	a0,0
 150:	186000ef          	jal	2d6 <read>
    if(cc < 1)
 154:	00a05e63          	blez	a0,170 <gets+0x52>
    buf[i++] = c;
 158:	faf44783          	lbu	a5,-81(s0)
 15c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 160:	01578763          	beq	a5,s5,16e <gets+0x50>
 164:	0905                	addi	s2,s2,1
 166:	fd679de3          	bne	a5,s6,140 <gets+0x22>
    buf[i++] = c;
 16a:	89a6                	mv	s3,s1
 16c:	a011                	j	170 <gets+0x52>
 16e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 170:	99de                	add	s3,s3,s7
 172:	00098023          	sb	zero,0(s3)
  return buf;
}
 176:	855e                	mv	a0,s7
 178:	60e6                	ld	ra,88(sp)
 17a:	6446                	ld	s0,80(sp)
 17c:	64a6                	ld	s1,72(sp)
 17e:	6906                	ld	s2,64(sp)
 180:	79e2                	ld	s3,56(sp)
 182:	7a42                	ld	s4,48(sp)
 184:	7aa2                	ld	s5,40(sp)
 186:	7b02                	ld	s6,32(sp)
 188:	6be2                	ld	s7,24(sp)
 18a:	6125                	addi	sp,sp,96
 18c:	8082                	ret

000000000000018e <stat>:

int
stat(const char *n, struct stat *st)
{
 18e:	1101                	addi	sp,sp,-32
 190:	ec06                	sd	ra,24(sp)
 192:	e822                	sd	s0,16(sp)
 194:	e04a                	sd	s2,0(sp)
 196:	1000                	addi	s0,sp,32
 198:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19a:	4581                	li	a1,0
 19c:	162000ef          	jal	2fe <open>
  if(fd < 0)
 1a0:	02054263          	bltz	a0,1c4 <stat+0x36>
 1a4:	e426                	sd	s1,8(sp)
 1a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a8:	85ca                	mv	a1,s2
 1aa:	16c000ef          	jal	316 <fstat>
 1ae:	892a                	mv	s2,a0
  close(fd);
 1b0:	8526                	mv	a0,s1
 1b2:	134000ef          	jal	2e6 <close>
  return r;
 1b6:	64a2                	ld	s1,8(sp)
}
 1b8:	854a                	mv	a0,s2
 1ba:	60e2                	ld	ra,24(sp)
 1bc:	6442                	ld	s0,16(sp)
 1be:	6902                	ld	s2,0(sp)
 1c0:	6105                	addi	sp,sp,32
 1c2:	8082                	ret
    return -1;
 1c4:	597d                	li	s2,-1
 1c6:	bfcd                	j	1b8 <stat+0x2a>

00000000000001c8 <atoi>:

int
atoi(const char *s)
{
 1c8:	1141                	addi	sp,sp,-16
 1ca:	e422                	sd	s0,8(sp)
 1cc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ce:	00054683          	lbu	a3,0(a0)
 1d2:	fd06879b          	addiw	a5,a3,-48
 1d6:	0ff7f793          	zext.b	a5,a5
 1da:	4625                	li	a2,9
 1dc:	02f66863          	bltu	a2,a5,20c <atoi+0x44>
 1e0:	872a                	mv	a4,a0
  n = 0;
 1e2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e4:	0705                	addi	a4,a4,1
 1e6:	0025179b          	slliw	a5,a0,0x2
 1ea:	9fa9                	addw	a5,a5,a0
 1ec:	0017979b          	slliw	a5,a5,0x1
 1f0:	9fb5                	addw	a5,a5,a3
 1f2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f6:	00074683          	lbu	a3,0(a4)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	fef671e3          	bgeu	a2,a5,1e4 <atoi+0x1c>
  return n;
}
 206:	6422                	ld	s0,8(sp)
 208:	0141                	addi	sp,sp,16
 20a:	8082                	ret
  n = 0;
 20c:	4501                	li	a0,0
 20e:	bfe5                	j	206 <atoi+0x3e>

0000000000000210 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 210:	1141                	addi	sp,sp,-16
 212:	e422                	sd	s0,8(sp)
 214:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 216:	02b57463          	bgeu	a0,a1,23e <memmove+0x2e>
    while(n-- > 0)
 21a:	00c05f63          	blez	a2,238 <memmove+0x28>
 21e:	1602                	slli	a2,a2,0x20
 220:	9201                	srli	a2,a2,0x20
 222:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 226:	872a                	mv	a4,a0
      *dst++ = *src++;
 228:	0585                	addi	a1,a1,1
 22a:	0705                	addi	a4,a4,1
 22c:	fff5c683          	lbu	a3,-1(a1)
 230:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 234:	fef71ae3          	bne	a4,a5,228 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
    dst += n;
 23e:	00c50733          	add	a4,a0,a2
    src += n;
 242:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 244:	fec05ae3          	blez	a2,238 <memmove+0x28>
 248:	fff6079b          	addiw	a5,a2,-1
 24c:	1782                	slli	a5,a5,0x20
 24e:	9381                	srli	a5,a5,0x20
 250:	fff7c793          	not	a5,a5
 254:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 256:	15fd                	addi	a1,a1,-1
 258:	177d                	addi	a4,a4,-1
 25a:	0005c683          	lbu	a3,0(a1)
 25e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 262:	fee79ae3          	bne	a5,a4,256 <memmove+0x46>
 266:	bfc9                	j	238 <memmove+0x28>

0000000000000268 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e422                	sd	s0,8(sp)
 26c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26e:	ca05                	beqz	a2,29e <memcmp+0x36>
 270:	fff6069b          	addiw	a3,a2,-1
 274:	1682                	slli	a3,a3,0x20
 276:	9281                	srli	a3,a3,0x20
 278:	0685                	addi	a3,a3,1
 27a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 27c:	00054783          	lbu	a5,0(a0)
 280:	0005c703          	lbu	a4,0(a1)
 284:	00e79863          	bne	a5,a4,294 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 288:	0505                	addi	a0,a0,1
    p2++;
 28a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 28c:	fed518e3          	bne	a0,a3,27c <memcmp+0x14>
  }
  return 0;
 290:	4501                	li	a0,0
 292:	a019                	j	298 <memcmp+0x30>
      return *p1 - *p2;
 294:	40e7853b          	subw	a0,a5,a4
}
 298:	6422                	ld	s0,8(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  return 0;
 29e:	4501                	li	a0,0
 2a0:	bfe5                	j	298 <memcmp+0x30>

00000000000002a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2aa:	f67ff0ef          	jal	210 <memmove>
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b6:	4885                	li	a7,1
 ecall
 2b8:	00000073          	ecall
 ret
 2bc:	8082                	ret

00000000000002be <exit>:
.global exit
exit:
 li a7, SYS_exit
 2be:	4889                	li	a7,2
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c6:	488d                	li	a7,3
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ce:	4891                	li	a7,4
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <read>:
.global read
read:
 li a7, SYS_read
 2d6:	4895                	li	a7,5
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <write>:
.global write
write:
 li a7, SYS_write
 2de:	48c1                	li	a7,16
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <close>:
.global close
close:
 li a7, SYS_close
 2e6:	48d5                	li	a7,21
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ee:	4899                	li	a7,6
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f6:	489d                	li	a7,7
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <open>:
.global open
open:
 li a7, SYS_open
 2fe:	48bd                	li	a7,15
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 306:	48c5                	li	a7,17
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30e:	48c9                	li	a7,18
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 316:	48a1                	li	a7,8
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <link>:
.global link
link:
 li a7, SYS_link
 31e:	48cd                	li	a7,19
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 326:	48d1                	li	a7,20
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32e:	48a5                	li	a7,9
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <dup>:
.global dup
dup:
 li a7, SYS_dup
 336:	48a9                	li	a7,10
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33e:	48ad                	li	a7,11
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 346:	48b1                	li	a7,12
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34e:	48b5                	li	a7,13
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 356:	48b9                	li	a7,14
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 35e:	48d9                	li	a7,22
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 366:	1101                	addi	sp,sp,-32
 368:	ec06                	sd	ra,24(sp)
 36a:	e822                	sd	s0,16(sp)
 36c:	1000                	addi	s0,sp,32
 36e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 372:	4605                	li	a2,1
 374:	fef40593          	addi	a1,s0,-17
 378:	f67ff0ef          	jal	2de <write>
}
 37c:	60e2                	ld	ra,24(sp)
 37e:	6442                	ld	s0,16(sp)
 380:	6105                	addi	sp,sp,32
 382:	8082                	ret

0000000000000384 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 384:	7139                	addi	sp,sp,-64
 386:	fc06                	sd	ra,56(sp)
 388:	f822                	sd	s0,48(sp)
 38a:	f426                	sd	s1,40(sp)
 38c:	0080                	addi	s0,sp,64
 38e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 390:	c299                	beqz	a3,396 <printint+0x12>
 392:	0805c963          	bltz	a1,424 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 396:	2581                	sext.w	a1,a1
  neg = 0;
 398:	4881                	li	a7,0
 39a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 39e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a0:	2601                	sext.w	a2,a2
 3a2:	00000517          	auipc	a0,0x0
 3a6:	50e50513          	addi	a0,a0,1294 # 8b0 <digits>
 3aa:	883a                	mv	a6,a4
 3ac:	2705                	addiw	a4,a4,1
 3ae:	02c5f7bb          	remuw	a5,a1,a2
 3b2:	1782                	slli	a5,a5,0x20
 3b4:	9381                	srli	a5,a5,0x20
 3b6:	97aa                	add	a5,a5,a0
 3b8:	0007c783          	lbu	a5,0(a5)
 3bc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c0:	0005879b          	sext.w	a5,a1
 3c4:	02c5d5bb          	divuw	a1,a1,a2
 3c8:	0685                	addi	a3,a3,1
 3ca:	fec7f0e3          	bgeu	a5,a2,3aa <printint+0x26>
  if(neg)
 3ce:	00088c63          	beqz	a7,3e6 <printint+0x62>
    buf[i++] = '-';
 3d2:	fd070793          	addi	a5,a4,-48
 3d6:	00878733          	add	a4,a5,s0
 3da:	02d00793          	li	a5,45
 3de:	fef70823          	sb	a5,-16(a4)
 3e2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3e6:	02e05a63          	blez	a4,41a <printint+0x96>
 3ea:	f04a                	sd	s2,32(sp)
 3ec:	ec4e                	sd	s3,24(sp)
 3ee:	fc040793          	addi	a5,s0,-64
 3f2:	00e78933          	add	s2,a5,a4
 3f6:	fff78993          	addi	s3,a5,-1
 3fa:	99ba                	add	s3,s3,a4
 3fc:	377d                	addiw	a4,a4,-1
 3fe:	1702                	slli	a4,a4,0x20
 400:	9301                	srli	a4,a4,0x20
 402:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 406:	fff94583          	lbu	a1,-1(s2)
 40a:	8526                	mv	a0,s1
 40c:	f5bff0ef          	jal	366 <putc>
  while(--i >= 0)
 410:	197d                	addi	s2,s2,-1
 412:	ff391ae3          	bne	s2,s3,406 <printint+0x82>
 416:	7902                	ld	s2,32(sp)
 418:	69e2                	ld	s3,24(sp)
}
 41a:	70e2                	ld	ra,56(sp)
 41c:	7442                	ld	s0,48(sp)
 41e:	74a2                	ld	s1,40(sp)
 420:	6121                	addi	sp,sp,64
 422:	8082                	ret
    x = -xx;
 424:	40b005bb          	negw	a1,a1
    neg = 1;
 428:	4885                	li	a7,1
    x = -xx;
 42a:	bf85                	j	39a <printint+0x16>

000000000000042c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 42c:	711d                	addi	sp,sp,-96
 42e:	ec86                	sd	ra,88(sp)
 430:	e8a2                	sd	s0,80(sp)
 432:	e0ca                	sd	s2,64(sp)
 434:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 436:	0005c903          	lbu	s2,0(a1)
 43a:	26090863          	beqz	s2,6aa <vprintf+0x27e>
 43e:	e4a6                	sd	s1,72(sp)
 440:	fc4e                	sd	s3,56(sp)
 442:	f852                	sd	s4,48(sp)
 444:	f456                	sd	s5,40(sp)
 446:	f05a                	sd	s6,32(sp)
 448:	ec5e                	sd	s7,24(sp)
 44a:	e862                	sd	s8,16(sp)
 44c:	e466                	sd	s9,8(sp)
 44e:	8b2a                	mv	s6,a0
 450:	8a2e                	mv	s4,a1
 452:	8bb2                	mv	s7,a2
  state = 0;
 454:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 456:	4481                	li	s1,0
 458:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 45a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 45e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 462:	06c00c93          	li	s9,108
 466:	a005                	j	486 <vprintf+0x5a>
        putc(fd, c0);
 468:	85ca                	mv	a1,s2
 46a:	855a                	mv	a0,s6
 46c:	efbff0ef          	jal	366 <putc>
 470:	a019                	j	476 <vprintf+0x4a>
    } else if(state == '%'){
 472:	03598263          	beq	s3,s5,496 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 476:	2485                	addiw	s1,s1,1
 478:	8726                	mv	a4,s1
 47a:	009a07b3          	add	a5,s4,s1
 47e:	0007c903          	lbu	s2,0(a5)
 482:	20090c63          	beqz	s2,69a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 486:	0009079b          	sext.w	a5,s2
    if(state == 0){
 48a:	fe0994e3          	bnez	s3,472 <vprintf+0x46>
      if(c0 == '%'){
 48e:	fd579de3          	bne	a5,s5,468 <vprintf+0x3c>
        state = '%';
 492:	89be                	mv	s3,a5
 494:	b7cd                	j	476 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 496:	00ea06b3          	add	a3,s4,a4
 49a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 49e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4a0:	c681                	beqz	a3,4a8 <vprintf+0x7c>
 4a2:	9752                	add	a4,a4,s4
 4a4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4a8:	03878f63          	beq	a5,s8,4e6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4ac:	05978963          	beq	a5,s9,4fe <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4b0:	07500713          	li	a4,117
 4b4:	0ee78363          	beq	a5,a4,59a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4b8:	07800713          	li	a4,120
 4bc:	12e78563          	beq	a5,a4,5e6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4c0:	07000713          	li	a4,112
 4c4:	14e78a63          	beq	a5,a4,618 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4c8:	07300713          	li	a4,115
 4cc:	18e78a63          	beq	a5,a4,660 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4d0:	02500713          	li	a4,37
 4d4:	04e79563          	bne	a5,a4,51e <vprintf+0xf2>
        putc(fd, '%');
 4d8:	02500593          	li	a1,37
 4dc:	855a                	mv	a0,s6
 4de:	e89ff0ef          	jal	366 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4e2:	4981                	li	s3,0
 4e4:	bf49                	j	476 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4e6:	008b8913          	addi	s2,s7,8
 4ea:	4685                	li	a3,1
 4ec:	4629                	li	a2,10
 4ee:	000ba583          	lw	a1,0(s7)
 4f2:	855a                	mv	a0,s6
 4f4:	e91ff0ef          	jal	384 <printint>
 4f8:	8bca                	mv	s7,s2
      state = 0;
 4fa:	4981                	li	s3,0
 4fc:	bfad                	j	476 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4fe:	06400793          	li	a5,100
 502:	02f68963          	beq	a3,a5,534 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 506:	06c00793          	li	a5,108
 50a:	04f68263          	beq	a3,a5,54e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 50e:	07500793          	li	a5,117
 512:	0af68063          	beq	a3,a5,5b2 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 516:	07800793          	li	a5,120
 51a:	0ef68263          	beq	a3,a5,5fe <vprintf+0x1d2>
        putc(fd, '%');
 51e:	02500593          	li	a1,37
 522:	855a                	mv	a0,s6
 524:	e43ff0ef          	jal	366 <putc>
        putc(fd, c0);
 528:	85ca                	mv	a1,s2
 52a:	855a                	mv	a0,s6
 52c:	e3bff0ef          	jal	366 <putc>
      state = 0;
 530:	4981                	li	s3,0
 532:	b791                	j	476 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 534:	008b8913          	addi	s2,s7,8
 538:	4685                	li	a3,1
 53a:	4629                	li	a2,10
 53c:	000ba583          	lw	a1,0(s7)
 540:	855a                	mv	a0,s6
 542:	e43ff0ef          	jal	384 <printint>
        i += 1;
 546:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 548:	8bca                	mv	s7,s2
      state = 0;
 54a:	4981                	li	s3,0
        i += 1;
 54c:	b72d                	j	476 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 54e:	06400793          	li	a5,100
 552:	02f60763          	beq	a2,a5,580 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 556:	07500793          	li	a5,117
 55a:	06f60963          	beq	a2,a5,5cc <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 55e:	07800793          	li	a5,120
 562:	faf61ee3          	bne	a2,a5,51e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 566:	008b8913          	addi	s2,s7,8
 56a:	4681                	li	a3,0
 56c:	4641                	li	a2,16
 56e:	000ba583          	lw	a1,0(s7)
 572:	855a                	mv	a0,s6
 574:	e11ff0ef          	jal	384 <printint>
        i += 2;
 578:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 57a:	8bca                	mv	s7,s2
      state = 0;
 57c:	4981                	li	s3,0
        i += 2;
 57e:	bde5                	j	476 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 580:	008b8913          	addi	s2,s7,8
 584:	4685                	li	a3,1
 586:	4629                	li	a2,10
 588:	000ba583          	lw	a1,0(s7)
 58c:	855a                	mv	a0,s6
 58e:	df7ff0ef          	jal	384 <printint>
        i += 2;
 592:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 594:	8bca                	mv	s7,s2
      state = 0;
 596:	4981                	li	s3,0
        i += 2;
 598:	bdf9                	j	476 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 59a:	008b8913          	addi	s2,s7,8
 59e:	4681                	li	a3,0
 5a0:	4629                	li	a2,10
 5a2:	000ba583          	lw	a1,0(s7)
 5a6:	855a                	mv	a0,s6
 5a8:	dddff0ef          	jal	384 <printint>
 5ac:	8bca                	mv	s7,s2
      state = 0;
 5ae:	4981                	li	s3,0
 5b0:	b5d9                	j	476 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b2:	008b8913          	addi	s2,s7,8
 5b6:	4681                	li	a3,0
 5b8:	4629                	li	a2,10
 5ba:	000ba583          	lw	a1,0(s7)
 5be:	855a                	mv	a0,s6
 5c0:	dc5ff0ef          	jal	384 <printint>
        i += 1;
 5c4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c6:	8bca                	mv	s7,s2
      state = 0;
 5c8:	4981                	li	s3,0
        i += 1;
 5ca:	b575                	j	476 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5cc:	008b8913          	addi	s2,s7,8
 5d0:	4681                	li	a3,0
 5d2:	4629                	li	a2,10
 5d4:	000ba583          	lw	a1,0(s7)
 5d8:	855a                	mv	a0,s6
 5da:	dabff0ef          	jal	384 <printint>
        i += 2;
 5de:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e0:	8bca                	mv	s7,s2
      state = 0;
 5e2:	4981                	li	s3,0
        i += 2;
 5e4:	bd49                	j	476 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5e6:	008b8913          	addi	s2,s7,8
 5ea:	4681                	li	a3,0
 5ec:	4641                	li	a2,16
 5ee:	000ba583          	lw	a1,0(s7)
 5f2:	855a                	mv	a0,s6
 5f4:	d91ff0ef          	jal	384 <printint>
 5f8:	8bca                	mv	s7,s2
      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	bdad                	j	476 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fe:	008b8913          	addi	s2,s7,8
 602:	4681                	li	a3,0
 604:	4641                	li	a2,16
 606:	000ba583          	lw	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	d79ff0ef          	jal	384 <printint>
        i += 1;
 610:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 612:	8bca                	mv	s7,s2
      state = 0;
 614:	4981                	li	s3,0
        i += 1;
 616:	b585                	j	476 <vprintf+0x4a>
 618:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 61a:	008b8d13          	addi	s10,s7,8
 61e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 622:	03000593          	li	a1,48
 626:	855a                	mv	a0,s6
 628:	d3fff0ef          	jal	366 <putc>
  putc(fd, 'x');
 62c:	07800593          	li	a1,120
 630:	855a                	mv	a0,s6
 632:	d35ff0ef          	jal	366 <putc>
 636:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 638:	00000b97          	auipc	s7,0x0
 63c:	278b8b93          	addi	s7,s7,632 # 8b0 <digits>
 640:	03c9d793          	srli	a5,s3,0x3c
 644:	97de                	add	a5,a5,s7
 646:	0007c583          	lbu	a1,0(a5)
 64a:	855a                	mv	a0,s6
 64c:	d1bff0ef          	jal	366 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 650:	0992                	slli	s3,s3,0x4
 652:	397d                	addiw	s2,s2,-1
 654:	fe0916e3          	bnez	s2,640 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 658:	8bea                	mv	s7,s10
      state = 0;
 65a:	4981                	li	s3,0
 65c:	6d02                	ld	s10,0(sp)
 65e:	bd21                	j	476 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 660:	008b8993          	addi	s3,s7,8
 664:	000bb903          	ld	s2,0(s7)
 668:	00090f63          	beqz	s2,686 <vprintf+0x25a>
        for(; *s; s++)
 66c:	00094583          	lbu	a1,0(s2)
 670:	c195                	beqz	a1,694 <vprintf+0x268>
          putc(fd, *s);
 672:	855a                	mv	a0,s6
 674:	cf3ff0ef          	jal	366 <putc>
        for(; *s; s++)
 678:	0905                	addi	s2,s2,1
 67a:	00094583          	lbu	a1,0(s2)
 67e:	f9f5                	bnez	a1,672 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 680:	8bce                	mv	s7,s3
      state = 0;
 682:	4981                	li	s3,0
 684:	bbcd                	j	476 <vprintf+0x4a>
          s = "(null)";
 686:	00000917          	auipc	s2,0x0
 68a:	22290913          	addi	s2,s2,546 # 8a8 <malloc+0x116>
        for(; *s; s++)
 68e:	02800593          	li	a1,40
 692:	b7c5                	j	672 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 694:	8bce                	mv	s7,s3
      state = 0;
 696:	4981                	li	s3,0
 698:	bbf9                	j	476 <vprintf+0x4a>
 69a:	64a6                	ld	s1,72(sp)
 69c:	79e2                	ld	s3,56(sp)
 69e:	7a42                	ld	s4,48(sp)
 6a0:	7aa2                	ld	s5,40(sp)
 6a2:	7b02                	ld	s6,32(sp)
 6a4:	6be2                	ld	s7,24(sp)
 6a6:	6c42                	ld	s8,16(sp)
 6a8:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6aa:	60e6                	ld	ra,88(sp)
 6ac:	6446                	ld	s0,80(sp)
 6ae:	6906                	ld	s2,64(sp)
 6b0:	6125                	addi	sp,sp,96
 6b2:	8082                	ret

00000000000006b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6b4:	715d                	addi	sp,sp,-80
 6b6:	ec06                	sd	ra,24(sp)
 6b8:	e822                	sd	s0,16(sp)
 6ba:	1000                	addi	s0,sp,32
 6bc:	e010                	sd	a2,0(s0)
 6be:	e414                	sd	a3,8(s0)
 6c0:	e818                	sd	a4,16(s0)
 6c2:	ec1c                	sd	a5,24(s0)
 6c4:	03043023          	sd	a6,32(s0)
 6c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d0:	8622                	mv	a2,s0
 6d2:	d5bff0ef          	jal	42c <vprintf>
}
 6d6:	60e2                	ld	ra,24(sp)
 6d8:	6442                	ld	s0,16(sp)
 6da:	6161                	addi	sp,sp,80
 6dc:	8082                	ret

00000000000006de <printf>:

void
printf(const char *fmt, ...)
{
 6de:	711d                	addi	sp,sp,-96
 6e0:	ec06                	sd	ra,24(sp)
 6e2:	e822                	sd	s0,16(sp)
 6e4:	1000                	addi	s0,sp,32
 6e6:	e40c                	sd	a1,8(s0)
 6e8:	e810                	sd	a2,16(s0)
 6ea:	ec14                	sd	a3,24(s0)
 6ec:	f018                	sd	a4,32(s0)
 6ee:	f41c                	sd	a5,40(s0)
 6f0:	03043823          	sd	a6,48(s0)
 6f4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6f8:	00840613          	addi	a2,s0,8
 6fc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 700:	85aa                	mv	a1,a0
 702:	4505                	li	a0,1
 704:	d29ff0ef          	jal	42c <vprintf>
}
 708:	60e2                	ld	ra,24(sp)
 70a:	6442                	ld	s0,16(sp)
 70c:	6125                	addi	sp,sp,96
 70e:	8082                	ret

0000000000000710 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 710:	1141                	addi	sp,sp,-16
 712:	e422                	sd	s0,8(sp)
 714:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 716:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71a:	00001797          	auipc	a5,0x1
 71e:	8e67b783          	ld	a5,-1818(a5) # 1000 <freep>
 722:	a02d                	j	74c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 724:	4618                	lw	a4,8(a2)
 726:	9f2d                	addw	a4,a4,a1
 728:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 72c:	6398                	ld	a4,0(a5)
 72e:	6310                	ld	a2,0(a4)
 730:	a83d                	j	76e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 732:	ff852703          	lw	a4,-8(a0)
 736:	9f31                	addw	a4,a4,a2
 738:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 73a:	ff053683          	ld	a3,-16(a0)
 73e:	a091                	j	782 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 740:	6398                	ld	a4,0(a5)
 742:	00e7e463          	bltu	a5,a4,74a <free+0x3a>
 746:	00e6ea63          	bltu	a3,a4,75a <free+0x4a>
{
 74a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 74c:	fed7fae3          	bgeu	a5,a3,740 <free+0x30>
 750:	6398                	ld	a4,0(a5)
 752:	00e6e463          	bltu	a3,a4,75a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 756:	fee7eae3          	bltu	a5,a4,74a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 75a:	ff852583          	lw	a1,-8(a0)
 75e:	6390                	ld	a2,0(a5)
 760:	02059813          	slli	a6,a1,0x20
 764:	01c85713          	srli	a4,a6,0x1c
 768:	9736                	add	a4,a4,a3
 76a:	fae60de3          	beq	a2,a4,724 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 76e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 772:	4790                	lw	a2,8(a5)
 774:	02061593          	slli	a1,a2,0x20
 778:	01c5d713          	srli	a4,a1,0x1c
 77c:	973e                	add	a4,a4,a5
 77e:	fae68ae3          	beq	a3,a4,732 <free+0x22>
    p->s.ptr = bp->s.ptr;
 782:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 784:	00001717          	auipc	a4,0x1
 788:	86f73e23          	sd	a5,-1924(a4) # 1000 <freep>
}
 78c:	6422                	ld	s0,8(sp)
 78e:	0141                	addi	sp,sp,16
 790:	8082                	ret

0000000000000792 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 792:	7139                	addi	sp,sp,-64
 794:	fc06                	sd	ra,56(sp)
 796:	f822                	sd	s0,48(sp)
 798:	f426                	sd	s1,40(sp)
 79a:	ec4e                	sd	s3,24(sp)
 79c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 79e:	02051493          	slli	s1,a0,0x20
 7a2:	9081                	srli	s1,s1,0x20
 7a4:	04bd                	addi	s1,s1,15
 7a6:	8091                	srli	s1,s1,0x4
 7a8:	0014899b          	addiw	s3,s1,1
 7ac:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7ae:	00001517          	auipc	a0,0x1
 7b2:	85253503          	ld	a0,-1966(a0) # 1000 <freep>
 7b6:	c915                	beqz	a0,7ea <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ba:	4798                	lw	a4,8(a5)
 7bc:	08977a63          	bgeu	a4,s1,850 <malloc+0xbe>
 7c0:	f04a                	sd	s2,32(sp)
 7c2:	e852                	sd	s4,16(sp)
 7c4:	e456                	sd	s5,8(sp)
 7c6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7c8:	8a4e                	mv	s4,s3
 7ca:	0009871b          	sext.w	a4,s3
 7ce:	6685                	lui	a3,0x1
 7d0:	00d77363          	bgeu	a4,a3,7d6 <malloc+0x44>
 7d4:	6a05                	lui	s4,0x1
 7d6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7da:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7de:	00001917          	auipc	s2,0x1
 7e2:	82290913          	addi	s2,s2,-2014 # 1000 <freep>
  if(p == (char*)-1)
 7e6:	5afd                	li	s5,-1
 7e8:	a081                	j	828 <malloc+0x96>
 7ea:	f04a                	sd	s2,32(sp)
 7ec:	e852                	sd	s4,16(sp)
 7ee:	e456                	sd	s5,8(sp)
 7f0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7f2:	00001797          	auipc	a5,0x1
 7f6:	81e78793          	addi	a5,a5,-2018 # 1010 <base>
 7fa:	00001717          	auipc	a4,0x1
 7fe:	80f73323          	sd	a5,-2042(a4) # 1000 <freep>
 802:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 804:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 808:	b7c1                	j	7c8 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 80a:	6398                	ld	a4,0(a5)
 80c:	e118                	sd	a4,0(a0)
 80e:	a8a9                	j	868 <malloc+0xd6>
  hp->s.size = nu;
 810:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 814:	0541                	addi	a0,a0,16
 816:	efbff0ef          	jal	710 <free>
  return freep;
 81a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 81e:	c12d                	beqz	a0,880 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 820:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 822:	4798                	lw	a4,8(a5)
 824:	02977263          	bgeu	a4,s1,848 <malloc+0xb6>
    if(p == freep)
 828:	00093703          	ld	a4,0(s2)
 82c:	853e                	mv	a0,a5
 82e:	fef719e3          	bne	a4,a5,820 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 832:	8552                	mv	a0,s4
 834:	b13ff0ef          	jal	346 <sbrk>
  if(p == (char*)-1)
 838:	fd551ce3          	bne	a0,s5,810 <malloc+0x7e>
        return 0;
 83c:	4501                	li	a0,0
 83e:	7902                	ld	s2,32(sp)
 840:	6a42                	ld	s4,16(sp)
 842:	6aa2                	ld	s5,8(sp)
 844:	6b02                	ld	s6,0(sp)
 846:	a03d                	j	874 <malloc+0xe2>
 848:	7902                	ld	s2,32(sp)
 84a:	6a42                	ld	s4,16(sp)
 84c:	6aa2                	ld	s5,8(sp)
 84e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 850:	fae48de3          	beq	s1,a4,80a <malloc+0x78>
        p->s.size -= nunits;
 854:	4137073b          	subw	a4,a4,s3
 858:	c798                	sw	a4,8(a5)
        p += p->s.size;
 85a:	02071693          	slli	a3,a4,0x20
 85e:	01c6d713          	srli	a4,a3,0x1c
 862:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 864:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 868:	00000717          	auipc	a4,0x0
 86c:	78a73c23          	sd	a0,1944(a4) # 1000 <freep>
      return (void*)(p + 1);
 870:	01078513          	addi	a0,a5,16
  }
}
 874:	70e2                	ld	ra,56(sp)
 876:	7442                	ld	s0,48(sp)
 878:	74a2                	ld	s1,40(sp)
 87a:	69e2                	ld	s3,24(sp)
 87c:	6121                	addi	sp,sp,64
 87e:	8082                	ret
 880:	7902                	ld	s2,32(sp)
 882:	6a42                	ld	s4,16(sp)
 884:	6aa2                	ld	s5,8(sp)
 886:	6b02                	ld	s6,0(sp)
 888:	b7f5                	j	874 <malloc+0xe2>
