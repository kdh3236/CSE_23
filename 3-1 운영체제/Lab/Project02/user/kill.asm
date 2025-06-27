
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
  44:	8e058593          	addi	a1,a1,-1824 # 920 <thread_join+0x3e>
  48:	4509                	li	a0,2
  4a:	672000ef          	jal	6bc <fprintf>
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

000000000000035e <clone>:
.global clone
clone:
 li a7, SYS_clone
 35e:	48d9                	li	a7,22
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <join>:
.global join
join:
 li a7, SYS_join
 366:	48dd                	li	a7,23
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 36e:	1101                	addi	sp,sp,-32
 370:	ec06                	sd	ra,24(sp)
 372:	e822                	sd	s0,16(sp)
 374:	1000                	addi	s0,sp,32
 376:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 37a:	4605                	li	a2,1
 37c:	fef40593          	addi	a1,s0,-17
 380:	f5fff0ef          	jal	2de <write>
}
 384:	60e2                	ld	ra,24(sp)
 386:	6442                	ld	s0,16(sp)
 388:	6105                	addi	sp,sp,32
 38a:	8082                	ret

000000000000038c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 38c:	7139                	addi	sp,sp,-64
 38e:	fc06                	sd	ra,56(sp)
 390:	f822                	sd	s0,48(sp)
 392:	f426                	sd	s1,40(sp)
 394:	0080                	addi	s0,sp,64
 396:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 398:	c299                	beqz	a3,39e <printint+0x12>
 39a:	0805c963          	bltz	a1,42c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 39e:	2581                	sext.w	a1,a1
  neg = 0;
 3a0:	4881                	li	a7,0
 3a2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3a6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3a8:	2601                	sext.w	a2,a2
 3aa:	00000517          	auipc	a0,0x0
 3ae:	59650513          	addi	a0,a0,1430 # 940 <digits>
 3b2:	883a                	mv	a6,a4
 3b4:	2705                	addiw	a4,a4,1
 3b6:	02c5f7bb          	remuw	a5,a1,a2
 3ba:	1782                	slli	a5,a5,0x20
 3bc:	9381                	srli	a5,a5,0x20
 3be:	97aa                	add	a5,a5,a0
 3c0:	0007c783          	lbu	a5,0(a5)
 3c4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3c8:	0005879b          	sext.w	a5,a1
 3cc:	02c5d5bb          	divuw	a1,a1,a2
 3d0:	0685                	addi	a3,a3,1
 3d2:	fec7f0e3          	bgeu	a5,a2,3b2 <printint+0x26>
  if(neg)
 3d6:	00088c63          	beqz	a7,3ee <printint+0x62>
    buf[i++] = '-';
 3da:	fd070793          	addi	a5,a4,-48
 3de:	00878733          	add	a4,a5,s0
 3e2:	02d00793          	li	a5,45
 3e6:	fef70823          	sb	a5,-16(a4)
 3ea:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3ee:	02e05a63          	blez	a4,422 <printint+0x96>
 3f2:	f04a                	sd	s2,32(sp)
 3f4:	ec4e                	sd	s3,24(sp)
 3f6:	fc040793          	addi	a5,s0,-64
 3fa:	00e78933          	add	s2,a5,a4
 3fe:	fff78993          	addi	s3,a5,-1
 402:	99ba                	add	s3,s3,a4
 404:	377d                	addiw	a4,a4,-1
 406:	1702                	slli	a4,a4,0x20
 408:	9301                	srli	a4,a4,0x20
 40a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 40e:	fff94583          	lbu	a1,-1(s2)
 412:	8526                	mv	a0,s1
 414:	f5bff0ef          	jal	36e <putc>
  while(--i >= 0)
 418:	197d                	addi	s2,s2,-1
 41a:	ff391ae3          	bne	s2,s3,40e <printint+0x82>
 41e:	7902                	ld	s2,32(sp)
 420:	69e2                	ld	s3,24(sp)
}
 422:	70e2                	ld	ra,56(sp)
 424:	7442                	ld	s0,48(sp)
 426:	74a2                	ld	s1,40(sp)
 428:	6121                	addi	sp,sp,64
 42a:	8082                	ret
    x = -xx;
 42c:	40b005bb          	negw	a1,a1
    neg = 1;
 430:	4885                	li	a7,1
    x = -xx;
 432:	bf85                	j	3a2 <printint+0x16>

0000000000000434 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 434:	711d                	addi	sp,sp,-96
 436:	ec86                	sd	ra,88(sp)
 438:	e8a2                	sd	s0,80(sp)
 43a:	e0ca                	sd	s2,64(sp)
 43c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 43e:	0005c903          	lbu	s2,0(a1)
 442:	26090863          	beqz	s2,6b2 <vprintf+0x27e>
 446:	e4a6                	sd	s1,72(sp)
 448:	fc4e                	sd	s3,56(sp)
 44a:	f852                	sd	s4,48(sp)
 44c:	f456                	sd	s5,40(sp)
 44e:	f05a                	sd	s6,32(sp)
 450:	ec5e                	sd	s7,24(sp)
 452:	e862                	sd	s8,16(sp)
 454:	e466                	sd	s9,8(sp)
 456:	8b2a                	mv	s6,a0
 458:	8a2e                	mv	s4,a1
 45a:	8bb2                	mv	s7,a2
  state = 0;
 45c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 45e:	4481                	li	s1,0
 460:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 462:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 466:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 46a:	06c00c93          	li	s9,108
 46e:	a005                	j	48e <vprintf+0x5a>
        putc(fd, c0);
 470:	85ca                	mv	a1,s2
 472:	855a                	mv	a0,s6
 474:	efbff0ef          	jal	36e <putc>
 478:	a019                	j	47e <vprintf+0x4a>
    } else if(state == '%'){
 47a:	03598263          	beq	s3,s5,49e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 47e:	2485                	addiw	s1,s1,1
 480:	8726                	mv	a4,s1
 482:	009a07b3          	add	a5,s4,s1
 486:	0007c903          	lbu	s2,0(a5)
 48a:	20090c63          	beqz	s2,6a2 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 48e:	0009079b          	sext.w	a5,s2
    if(state == 0){
 492:	fe0994e3          	bnez	s3,47a <vprintf+0x46>
      if(c0 == '%'){
 496:	fd579de3          	bne	a5,s5,470 <vprintf+0x3c>
        state = '%';
 49a:	89be                	mv	s3,a5
 49c:	b7cd                	j	47e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 49e:	00ea06b3          	add	a3,s4,a4
 4a2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4a6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4a8:	c681                	beqz	a3,4b0 <vprintf+0x7c>
 4aa:	9752                	add	a4,a4,s4
 4ac:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4b0:	03878f63          	beq	a5,s8,4ee <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4b4:	05978963          	beq	a5,s9,506 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4b8:	07500713          	li	a4,117
 4bc:	0ee78363          	beq	a5,a4,5a2 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4c0:	07800713          	li	a4,120
 4c4:	12e78563          	beq	a5,a4,5ee <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4c8:	07000713          	li	a4,112
 4cc:	14e78a63          	beq	a5,a4,620 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4d0:	07300713          	li	a4,115
 4d4:	18e78a63          	beq	a5,a4,668 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4d8:	02500713          	li	a4,37
 4dc:	04e79563          	bne	a5,a4,526 <vprintf+0xf2>
        putc(fd, '%');
 4e0:	02500593          	li	a1,37
 4e4:	855a                	mv	a0,s6
 4e6:	e89ff0ef          	jal	36e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4ea:	4981                	li	s3,0
 4ec:	bf49                	j	47e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4ee:	008b8913          	addi	s2,s7,8
 4f2:	4685                	li	a3,1
 4f4:	4629                	li	a2,10
 4f6:	000ba583          	lw	a1,0(s7)
 4fa:	855a                	mv	a0,s6
 4fc:	e91ff0ef          	jal	38c <printint>
 500:	8bca                	mv	s7,s2
      state = 0;
 502:	4981                	li	s3,0
 504:	bfad                	j	47e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 506:	06400793          	li	a5,100
 50a:	02f68963          	beq	a3,a5,53c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 50e:	06c00793          	li	a5,108
 512:	04f68263          	beq	a3,a5,556 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 516:	07500793          	li	a5,117
 51a:	0af68063          	beq	a3,a5,5ba <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 51e:	07800793          	li	a5,120
 522:	0ef68263          	beq	a3,a5,606 <vprintf+0x1d2>
        putc(fd, '%');
 526:	02500593          	li	a1,37
 52a:	855a                	mv	a0,s6
 52c:	e43ff0ef          	jal	36e <putc>
        putc(fd, c0);
 530:	85ca                	mv	a1,s2
 532:	855a                	mv	a0,s6
 534:	e3bff0ef          	jal	36e <putc>
      state = 0;
 538:	4981                	li	s3,0
 53a:	b791                	j	47e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53c:	008b8913          	addi	s2,s7,8
 540:	4685                	li	a3,1
 542:	4629                	li	a2,10
 544:	000ba583          	lw	a1,0(s7)
 548:	855a                	mv	a0,s6
 54a:	e43ff0ef          	jal	38c <printint>
        i += 1;
 54e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 550:	8bca                	mv	s7,s2
      state = 0;
 552:	4981                	li	s3,0
        i += 1;
 554:	b72d                	j	47e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 556:	06400793          	li	a5,100
 55a:	02f60763          	beq	a2,a5,588 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 55e:	07500793          	li	a5,117
 562:	06f60963          	beq	a2,a5,5d4 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 566:	07800793          	li	a5,120
 56a:	faf61ee3          	bne	a2,a5,526 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 56e:	008b8913          	addi	s2,s7,8
 572:	4681                	li	a3,0
 574:	4641                	li	a2,16
 576:	000ba583          	lw	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	e11ff0ef          	jal	38c <printint>
        i += 2;
 580:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 582:	8bca                	mv	s7,s2
      state = 0;
 584:	4981                	li	s3,0
        i += 2;
 586:	bde5                	j	47e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 588:	008b8913          	addi	s2,s7,8
 58c:	4685                	li	a3,1
 58e:	4629                	li	a2,10
 590:	000ba583          	lw	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	df7ff0ef          	jal	38c <printint>
        i += 2;
 59a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 59c:	8bca                	mv	s7,s2
      state = 0;
 59e:	4981                	li	s3,0
        i += 2;
 5a0:	bdf9                	j	47e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5a2:	008b8913          	addi	s2,s7,8
 5a6:	4681                	li	a3,0
 5a8:	4629                	li	a2,10
 5aa:	000ba583          	lw	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	dddff0ef          	jal	38c <printint>
 5b4:	8bca                	mv	s7,s2
      state = 0;
 5b6:	4981                	li	s3,0
 5b8:	b5d9                	j	47e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ba:	008b8913          	addi	s2,s7,8
 5be:	4681                	li	a3,0
 5c0:	4629                	li	a2,10
 5c2:	000ba583          	lw	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	dc5ff0ef          	jal	38c <printint>
        i += 1;
 5cc:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ce:	8bca                	mv	s7,s2
      state = 0;
 5d0:	4981                	li	s3,0
        i += 1;
 5d2:	b575                	j	47e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d4:	008b8913          	addi	s2,s7,8
 5d8:	4681                	li	a3,0
 5da:	4629                	li	a2,10
 5dc:	000ba583          	lw	a1,0(s7)
 5e0:	855a                	mv	a0,s6
 5e2:	dabff0ef          	jal	38c <printint>
        i += 2;
 5e6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e8:	8bca                	mv	s7,s2
      state = 0;
 5ea:	4981                	li	s3,0
        i += 2;
 5ec:	bd49                	j	47e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5ee:	008b8913          	addi	s2,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4641                	li	a2,16
 5f6:	000ba583          	lw	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	d91ff0ef          	jal	38c <printint>
 600:	8bca                	mv	s7,s2
      state = 0;
 602:	4981                	li	s3,0
 604:	bdad                	j	47e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 606:	008b8913          	addi	s2,s7,8
 60a:	4681                	li	a3,0
 60c:	4641                	li	a2,16
 60e:	000ba583          	lw	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	d79ff0ef          	jal	38c <printint>
        i += 1;
 618:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 61a:	8bca                	mv	s7,s2
      state = 0;
 61c:	4981                	li	s3,0
        i += 1;
 61e:	b585                	j	47e <vprintf+0x4a>
 620:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 622:	008b8d13          	addi	s10,s7,8
 626:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 62a:	03000593          	li	a1,48
 62e:	855a                	mv	a0,s6
 630:	d3fff0ef          	jal	36e <putc>
  putc(fd, 'x');
 634:	07800593          	li	a1,120
 638:	855a                	mv	a0,s6
 63a:	d35ff0ef          	jal	36e <putc>
 63e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 640:	00000b97          	auipc	s7,0x0
 644:	300b8b93          	addi	s7,s7,768 # 940 <digits>
 648:	03c9d793          	srli	a5,s3,0x3c
 64c:	97de                	add	a5,a5,s7
 64e:	0007c583          	lbu	a1,0(a5)
 652:	855a                	mv	a0,s6
 654:	d1bff0ef          	jal	36e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 658:	0992                	slli	s3,s3,0x4
 65a:	397d                	addiw	s2,s2,-1
 65c:	fe0916e3          	bnez	s2,648 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 660:	8bea                	mv	s7,s10
      state = 0;
 662:	4981                	li	s3,0
 664:	6d02                	ld	s10,0(sp)
 666:	bd21                	j	47e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 668:	008b8993          	addi	s3,s7,8
 66c:	000bb903          	ld	s2,0(s7)
 670:	00090f63          	beqz	s2,68e <vprintf+0x25a>
        for(; *s; s++)
 674:	00094583          	lbu	a1,0(s2)
 678:	c195                	beqz	a1,69c <vprintf+0x268>
          putc(fd, *s);
 67a:	855a                	mv	a0,s6
 67c:	cf3ff0ef          	jal	36e <putc>
        for(; *s; s++)
 680:	0905                	addi	s2,s2,1
 682:	00094583          	lbu	a1,0(s2)
 686:	f9f5                	bnez	a1,67a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 688:	8bce                	mv	s7,s3
      state = 0;
 68a:	4981                	li	s3,0
 68c:	bbcd                	j	47e <vprintf+0x4a>
          s = "(null)";
 68e:	00000917          	auipc	s2,0x0
 692:	2aa90913          	addi	s2,s2,682 # 938 <thread_join+0x56>
        for(; *s; s++)
 696:	02800593          	li	a1,40
 69a:	b7c5                	j	67a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 69c:	8bce                	mv	s7,s3
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	bbf9                	j	47e <vprintf+0x4a>
 6a2:	64a6                	ld	s1,72(sp)
 6a4:	79e2                	ld	s3,56(sp)
 6a6:	7a42                	ld	s4,48(sp)
 6a8:	7aa2                	ld	s5,40(sp)
 6aa:	7b02                	ld	s6,32(sp)
 6ac:	6be2                	ld	s7,24(sp)
 6ae:	6c42                	ld	s8,16(sp)
 6b0:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6b2:	60e6                	ld	ra,88(sp)
 6b4:	6446                	ld	s0,80(sp)
 6b6:	6906                	ld	s2,64(sp)
 6b8:	6125                	addi	sp,sp,96
 6ba:	8082                	ret

00000000000006bc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6bc:	715d                	addi	sp,sp,-80
 6be:	ec06                	sd	ra,24(sp)
 6c0:	e822                	sd	s0,16(sp)
 6c2:	1000                	addi	s0,sp,32
 6c4:	e010                	sd	a2,0(s0)
 6c6:	e414                	sd	a3,8(s0)
 6c8:	e818                	sd	a4,16(s0)
 6ca:	ec1c                	sd	a5,24(s0)
 6cc:	03043023          	sd	a6,32(s0)
 6d0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6d4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6d8:	8622                	mv	a2,s0
 6da:	d5bff0ef          	jal	434 <vprintf>
}
 6de:	60e2                	ld	ra,24(sp)
 6e0:	6442                	ld	s0,16(sp)
 6e2:	6161                	addi	sp,sp,80
 6e4:	8082                	ret

00000000000006e6 <printf>:

void
printf(const char *fmt, ...)
{
 6e6:	711d                	addi	sp,sp,-96
 6e8:	ec06                	sd	ra,24(sp)
 6ea:	e822                	sd	s0,16(sp)
 6ec:	1000                	addi	s0,sp,32
 6ee:	e40c                	sd	a1,8(s0)
 6f0:	e810                	sd	a2,16(s0)
 6f2:	ec14                	sd	a3,24(s0)
 6f4:	f018                	sd	a4,32(s0)
 6f6:	f41c                	sd	a5,40(s0)
 6f8:	03043823          	sd	a6,48(s0)
 6fc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 700:	00840613          	addi	a2,s0,8
 704:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 708:	85aa                	mv	a1,a0
 70a:	4505                	li	a0,1
 70c:	d29ff0ef          	jal	434 <vprintf>
}
 710:	60e2                	ld	ra,24(sp)
 712:	6442                	ld	s0,16(sp)
 714:	6125                	addi	sp,sp,96
 716:	8082                	ret

0000000000000718 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 718:	1141                	addi	sp,sp,-16
 71a:	e422                	sd	s0,8(sp)
 71c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 722:	00001797          	auipc	a5,0x1
 726:	8de7b783          	ld	a5,-1826(a5) # 1000 <freep>
 72a:	a02d                	j	754 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 72c:	4618                	lw	a4,8(a2)
 72e:	9f2d                	addw	a4,a4,a1
 730:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 734:	6398                	ld	a4,0(a5)
 736:	6310                	ld	a2,0(a4)
 738:	a83d                	j	776 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 73a:	ff852703          	lw	a4,-8(a0)
 73e:	9f31                	addw	a4,a4,a2
 740:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 742:	ff053683          	ld	a3,-16(a0)
 746:	a091                	j	78a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 748:	6398                	ld	a4,0(a5)
 74a:	00e7e463          	bltu	a5,a4,752 <free+0x3a>
 74e:	00e6ea63          	bltu	a3,a4,762 <free+0x4a>
{
 752:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 754:	fed7fae3          	bgeu	a5,a3,748 <free+0x30>
 758:	6398                	ld	a4,0(a5)
 75a:	00e6e463          	bltu	a3,a4,762 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75e:	fee7eae3          	bltu	a5,a4,752 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 762:	ff852583          	lw	a1,-8(a0)
 766:	6390                	ld	a2,0(a5)
 768:	02059813          	slli	a6,a1,0x20
 76c:	01c85713          	srli	a4,a6,0x1c
 770:	9736                	add	a4,a4,a3
 772:	fae60de3          	beq	a2,a4,72c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 776:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 77a:	4790                	lw	a2,8(a5)
 77c:	02061593          	slli	a1,a2,0x20
 780:	01c5d713          	srli	a4,a1,0x1c
 784:	973e                	add	a4,a4,a5
 786:	fae68ae3          	beq	a3,a4,73a <free+0x22>
    p->s.ptr = bp->s.ptr;
 78a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 78c:	00001717          	auipc	a4,0x1
 790:	86f73a23          	sd	a5,-1932(a4) # 1000 <freep>
}
 794:	6422                	ld	s0,8(sp)
 796:	0141                	addi	sp,sp,16
 798:	8082                	ret

000000000000079a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 79a:	7139                	addi	sp,sp,-64
 79c:	fc06                	sd	ra,56(sp)
 79e:	f822                	sd	s0,48(sp)
 7a0:	f426                	sd	s1,40(sp)
 7a2:	ec4e                	sd	s3,24(sp)
 7a4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7a6:	02051493          	slli	s1,a0,0x20
 7aa:	9081                	srli	s1,s1,0x20
 7ac:	04bd                	addi	s1,s1,15
 7ae:	8091                	srli	s1,s1,0x4
 7b0:	0014899b          	addiw	s3,s1,1
 7b4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7b6:	00001517          	auipc	a0,0x1
 7ba:	84a53503          	ld	a0,-1974(a0) # 1000 <freep>
 7be:	c915                	beqz	a0,7f2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7c2:	4798                	lw	a4,8(a5)
 7c4:	08977a63          	bgeu	a4,s1,858 <malloc+0xbe>
 7c8:	f04a                	sd	s2,32(sp)
 7ca:	e852                	sd	s4,16(sp)
 7cc:	e456                	sd	s5,8(sp)
 7ce:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7d0:	8a4e                	mv	s4,s3
 7d2:	0009871b          	sext.w	a4,s3
 7d6:	6685                	lui	a3,0x1
 7d8:	00d77363          	bgeu	a4,a3,7de <malloc+0x44>
 7dc:	6a05                	lui	s4,0x1
 7de:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7e2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7e6:	00001917          	auipc	s2,0x1
 7ea:	81a90913          	addi	s2,s2,-2022 # 1000 <freep>
  if(p == (char*)-1)
 7ee:	5afd                	li	s5,-1
 7f0:	a081                	j	830 <malloc+0x96>
 7f2:	f04a                	sd	s2,32(sp)
 7f4:	e852                	sd	s4,16(sp)
 7f6:	e456                	sd	s5,8(sp)
 7f8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7fa:	00001797          	auipc	a5,0x1
 7fe:	81678793          	addi	a5,a5,-2026 # 1010 <base>
 802:	00000717          	auipc	a4,0x0
 806:	7ef73f23          	sd	a5,2046(a4) # 1000 <freep>
 80a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 80c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 810:	b7c1                	j	7d0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 812:	6398                	ld	a4,0(a5)
 814:	e118                	sd	a4,0(a0)
 816:	a8a9                	j	870 <malloc+0xd6>
  hp->s.size = nu;
 818:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 81c:	0541                	addi	a0,a0,16
 81e:	efbff0ef          	jal	718 <free>
  return freep;
 822:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 826:	c12d                	beqz	a0,888 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 828:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 82a:	4798                	lw	a4,8(a5)
 82c:	02977263          	bgeu	a4,s1,850 <malloc+0xb6>
    if(p == freep)
 830:	00093703          	ld	a4,0(s2)
 834:	853e                	mv	a0,a5
 836:	fef719e3          	bne	a4,a5,828 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 83a:	8552                	mv	a0,s4
 83c:	b0bff0ef          	jal	346 <sbrk>
  if(p == (char*)-1)
 840:	fd551ce3          	bne	a0,s5,818 <malloc+0x7e>
        return 0;
 844:	4501                	li	a0,0
 846:	7902                	ld	s2,32(sp)
 848:	6a42                	ld	s4,16(sp)
 84a:	6aa2                	ld	s5,8(sp)
 84c:	6b02                	ld	s6,0(sp)
 84e:	a03d                	j	87c <malloc+0xe2>
 850:	7902                	ld	s2,32(sp)
 852:	6a42                	ld	s4,16(sp)
 854:	6aa2                	ld	s5,8(sp)
 856:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 858:	fae48de3          	beq	s1,a4,812 <malloc+0x78>
        p->s.size -= nunits;
 85c:	4137073b          	subw	a4,a4,s3
 860:	c798                	sw	a4,8(a5)
        p += p->s.size;
 862:	02071693          	slli	a3,a4,0x20
 866:	01c6d713          	srli	a4,a3,0x1c
 86a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 86c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 870:	00000717          	auipc	a4,0x0
 874:	78a73823          	sd	a0,1936(a4) # 1000 <freep>
      return (void*)(p + 1);
 878:	01078513          	addi	a0,a5,16
  }
}
 87c:	70e2                	ld	ra,56(sp)
 87e:	7442                	ld	s0,48(sp)
 880:	74a2                	ld	s1,40(sp)
 882:	69e2                	ld	s3,24(sp)
 884:	6121                	addi	sp,sp,64
 886:	8082                	ret
 888:	7902                	ld	s2,32(sp)
 88a:	6a42                	ld	s4,16(sp)
 88c:	6aa2                	ld	s5,8(sp)
 88e:	6b02                	ld	s6,0(sp)
 890:	b7f5                	j	87c <malloc+0xe2>

0000000000000892 <thread_create>:
#include "kernel/types.h"
#include "kernel/riscv.h"

int 
thread_create(void (*start_routine)(void*, void*), void *arg1, void* arg2)
{
 892:	7179                	addi	sp,sp,-48
 894:	f406                	sd	ra,40(sp)
 896:	f022                	sd	s0,32(sp)
 898:	e84a                	sd	s2,16(sp)
 89a:	e44e                	sd	s3,8(sp)
 89c:	e052                	sd	s4,0(sp)
 89e:	1800                	addi	s0,sp,48
 8a0:	892a                	mv	s2,a0
 8a2:	89ae                	mv	s3,a1
 8a4:	8a32                	mv	s4,a2
    int tid;

    void *stack = malloc(2 * PGSIZE);
 8a6:	6509                	lui	a0,0x2
 8a8:	ef3ff0ef          	jal	79a <malloc>
    if (stack == 0) return -1;
 8ac:	c90d                	beqz	a0,8de <thread_create+0x4c>
 8ae:	ec26                	sd	s1,24(sp)
 8b0:	84aa                	mv	s1,a0
    
    if ((tid = clone(start_routine, arg1, arg2, stack)) < 0) {
 8b2:	86aa                	mv	a3,a0
 8b4:	8652                	mv	a2,s4
 8b6:	85ce                	mv	a1,s3
 8b8:	854a                	mv	a0,s2
 8ba:	aa5ff0ef          	jal	35e <clone>
 8be:	00054a63          	bltz	a0,8d2 <thread_create+0x40>
 8c2:	64e2                	ld	s1,24(sp)
        free(stack);
        return -1;
    }
    
    return tid;
}
 8c4:	70a2                	ld	ra,40(sp)
 8c6:	7402                	ld	s0,32(sp)
 8c8:	6942                	ld	s2,16(sp)
 8ca:	69a2                	ld	s3,8(sp)
 8cc:	6a02                	ld	s4,0(sp)
 8ce:	6145                	addi	sp,sp,48
 8d0:	8082                	ret
        free(stack);
 8d2:	8526                	mv	a0,s1
 8d4:	e45ff0ef          	jal	718 <free>
        return -1;
 8d8:	557d                	li	a0,-1
 8da:	64e2                	ld	s1,24(sp)
 8dc:	b7e5                	j	8c4 <thread_create+0x32>
    if (stack == 0) return -1;
 8de:	557d                	li	a0,-1
 8e0:	b7d5                	j	8c4 <thread_create+0x32>

00000000000008e2 <thread_join>:

int 
thread_join()
{   
 8e2:	7179                	addi	sp,sp,-48
 8e4:	f406                	sd	ra,40(sp)
 8e6:	f022                	sd	s0,32(sp)
 8e8:	ec26                	sd	s1,24(sp)
 8ea:	1800                	addi	s0,sp,48
    int tid;
    void *stack;
    
    if ((tid = join(&stack)) < 0) {
 8ec:	fd840513          	addi	a0,s0,-40
 8f0:	a77ff0ef          	jal	366 <join>
 8f4:	00054d63          	bltz	a0,90e <thread_join+0x2c>
 8f8:	84aa                	mv	s1,a0
        return -1;
    }

    free(stack);
 8fa:	fd843503          	ld	a0,-40(s0)
 8fe:	e1bff0ef          	jal	718 <free>
    return tid;
}
 902:	8526                	mv	a0,s1
 904:	70a2                	ld	ra,40(sp)
 906:	7402                	ld	s0,32(sp)
 908:	64e2                	ld	s1,24(sp)
 90a:	6145                	addi	sp,sp,48
 90c:	8082                	ret
        return -1;
 90e:	54fd                	li	s1,-1
 910:	bfcd                	j	902 <thread_join+0x20>
