
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	278000ef          	jal	280 <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    sleep(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	276000ef          	jal	288 <exit>
    sleep(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	300000ef          	jal	318 <sleep>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	25c000ef          	jal	288 <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e422                	sd	s0,8(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0x8>
    ;
  return os;
}
  46:	6422                	ld	s0,8(sp)
  48:	0141                	addi	sp,sp,16
  4a:	8082                	ret

000000000000004c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4c:	1141                	addi	sp,sp,-16
  4e:	e422                	sd	s0,8(sp)
  50:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  52:	00054783          	lbu	a5,0(a0)
  56:	cb91                	beqz	a5,6a <strcmp+0x1e>
  58:	0005c703          	lbu	a4,0(a1)
  5c:	00f71763          	bne	a4,a5,6a <strcmp+0x1e>
    p++, q++;
  60:	0505                	addi	a0,a0,1
  62:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  64:	00054783          	lbu	a5,0(a0)
  68:	fbe5                	bnez	a5,58 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  6a:	0005c503          	lbu	a0,0(a1)
}
  6e:	40a7853b          	subw	a0,a5,a0
  72:	6422                	ld	s0,8(sp)
  74:	0141                	addi	sp,sp,16
  76:	8082                	ret

0000000000000078 <strlen>:

uint
strlen(const char *s)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  7e:	00054783          	lbu	a5,0(a0)
  82:	cf91                	beqz	a5,9e <strlen+0x26>
  84:	0505                	addi	a0,a0,1
  86:	87aa                	mv	a5,a0
  88:	86be                	mv	a3,a5
  8a:	0785                	addi	a5,a5,1
  8c:	fff7c703          	lbu	a4,-1(a5)
  90:	ff65                	bnez	a4,88 <strlen+0x10>
  92:	40a6853b          	subw	a0,a3,a0
  96:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	addi	sp,sp,16
  9c:	8082                	ret
  for(n = 0; s[n]; n++)
  9e:	4501                	li	a0,0
  a0:	bfe5                	j	98 <strlen+0x20>

00000000000000a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a2:	1141                	addi	sp,sp,-16
  a4:	e422                	sd	s0,8(sp)
  a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a8:	ca19                	beqz	a2,be <memset+0x1c>
  aa:	87aa                	mv	a5,a0
  ac:	1602                	slli	a2,a2,0x20
  ae:	9201                	srli	a2,a2,0x20
  b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b8:	0785                	addi	a5,a5,1
  ba:	fee79de3          	bne	a5,a4,b4 <memset+0x12>
  }
  return dst;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char*
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb99                	beqz	a5,e4 <strchr+0x20>
    if(*s == c)
  d0:	00f58763          	beq	a1,a5,de <strchr+0x1a>
  for(; *s; s++)
  d4:	0505                	addi	a0,a0,1
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbfd                	bnez	a5,d0 <strchr+0xc>
      return (char*)s;
  return 0;
  dc:	4501                	li	a0,0
}
  de:	6422                	ld	s0,8(sp)
  e0:	0141                	addi	sp,sp,16
  e2:	8082                	ret
  return 0;
  e4:	4501                	li	a0,0
  e6:	bfe5                	j	de <strchr+0x1a>

00000000000000e8 <gets>:

char*
gets(char *buf, int max)
{
  e8:	711d                	addi	sp,sp,-96
  ea:	ec86                	sd	ra,88(sp)
  ec:	e8a2                	sd	s0,80(sp)
  ee:	e4a6                	sd	s1,72(sp)
  f0:	e0ca                	sd	s2,64(sp)
  f2:	fc4e                	sd	s3,56(sp)
  f4:	f852                	sd	s4,48(sp)
  f6:	f456                	sd	s5,40(sp)
  f8:	f05a                	sd	s6,32(sp)
  fa:	ec5e                	sd	s7,24(sp)
  fc:	1080                	addi	s0,sp,96
  fe:	8baa                	mv	s7,a0
 100:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 102:	892a                	mv	s2,a0
 104:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 106:	4aa9                	li	s5,10
 108:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 10a:	89a6                	mv	s3,s1
 10c:	2485                	addiw	s1,s1,1
 10e:	0344d663          	bge	s1,s4,13a <gets+0x52>
    cc = read(0, &c, 1);
 112:	4605                	li	a2,1
 114:	faf40593          	addi	a1,s0,-81
 118:	4501                	li	a0,0
 11a:	186000ef          	jal	2a0 <read>
    if(cc < 1)
 11e:	00a05e63          	blez	a0,13a <gets+0x52>
    buf[i++] = c;
 122:	faf44783          	lbu	a5,-81(s0)
 126:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 12a:	01578763          	beq	a5,s5,138 <gets+0x50>
 12e:	0905                	addi	s2,s2,1
 130:	fd679de3          	bne	a5,s6,10a <gets+0x22>
    buf[i++] = c;
 134:	89a6                	mv	s3,s1
 136:	a011                	j	13a <gets+0x52>
 138:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 13a:	99de                	add	s3,s3,s7
 13c:	00098023          	sb	zero,0(s3)
  return buf;
}
 140:	855e                	mv	a0,s7
 142:	60e6                	ld	ra,88(sp)
 144:	6446                	ld	s0,80(sp)
 146:	64a6                	ld	s1,72(sp)
 148:	6906                	ld	s2,64(sp)
 14a:	79e2                	ld	s3,56(sp)
 14c:	7a42                	ld	s4,48(sp)
 14e:	7aa2                	ld	s5,40(sp)
 150:	7b02                	ld	s6,32(sp)
 152:	6be2                	ld	s7,24(sp)
 154:	6125                	addi	sp,sp,96
 156:	8082                	ret

0000000000000158 <stat>:

int
stat(const char *n, struct stat *st)
{
 158:	1101                	addi	sp,sp,-32
 15a:	ec06                	sd	ra,24(sp)
 15c:	e822                	sd	s0,16(sp)
 15e:	e04a                	sd	s2,0(sp)
 160:	1000                	addi	s0,sp,32
 162:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 164:	4581                	li	a1,0
 166:	162000ef          	jal	2c8 <open>
  if(fd < 0)
 16a:	02054263          	bltz	a0,18e <stat+0x36>
 16e:	e426                	sd	s1,8(sp)
 170:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 172:	85ca                	mv	a1,s2
 174:	16c000ef          	jal	2e0 <fstat>
 178:	892a                	mv	s2,a0
  close(fd);
 17a:	8526                	mv	a0,s1
 17c:	134000ef          	jal	2b0 <close>
  return r;
 180:	64a2                	ld	s1,8(sp)
}
 182:	854a                	mv	a0,s2
 184:	60e2                	ld	ra,24(sp)
 186:	6442                	ld	s0,16(sp)
 188:	6902                	ld	s2,0(sp)
 18a:	6105                	addi	sp,sp,32
 18c:	8082                	ret
    return -1;
 18e:	597d                	li	s2,-1
 190:	bfcd                	j	182 <stat+0x2a>

0000000000000192 <atoi>:

int
atoi(const char *s)
{
 192:	1141                	addi	sp,sp,-16
 194:	e422                	sd	s0,8(sp)
 196:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 198:	00054683          	lbu	a3,0(a0)
 19c:	fd06879b          	addiw	a5,a3,-48
 1a0:	0ff7f793          	zext.b	a5,a5
 1a4:	4625                	li	a2,9
 1a6:	02f66863          	bltu	a2,a5,1d6 <atoi+0x44>
 1aa:	872a                	mv	a4,a0
  n = 0;
 1ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ae:	0705                	addi	a4,a4,1
 1b0:	0025179b          	slliw	a5,a0,0x2
 1b4:	9fa9                	addw	a5,a5,a0
 1b6:	0017979b          	slliw	a5,a5,0x1
 1ba:	9fb5                	addw	a5,a5,a3
 1bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1c0:	00074683          	lbu	a3,0(a4)
 1c4:	fd06879b          	addiw	a5,a3,-48
 1c8:	0ff7f793          	zext.b	a5,a5
 1cc:	fef671e3          	bgeu	a2,a5,1ae <atoi+0x1c>
  return n;
}
 1d0:	6422                	ld	s0,8(sp)
 1d2:	0141                	addi	sp,sp,16
 1d4:	8082                	ret
  n = 0;
 1d6:	4501                	li	a0,0
 1d8:	bfe5                	j	1d0 <atoi+0x3e>

00000000000001da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1e0:	02b57463          	bgeu	a0,a1,208 <memmove+0x2e>
    while(n-- > 0)
 1e4:	00c05f63          	blez	a2,202 <memmove+0x28>
 1e8:	1602                	slli	a2,a2,0x20
 1ea:	9201                	srli	a2,a2,0x20
 1ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 1f0:	872a                	mv	a4,a0
      *dst++ = *src++;
 1f2:	0585                	addi	a1,a1,1
 1f4:	0705                	addi	a4,a4,1
 1f6:	fff5c683          	lbu	a3,-1(a1)
 1fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 1fe:	fef71ae3          	bne	a4,a5,1f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret
    dst += n;
 208:	00c50733          	add	a4,a0,a2
    src += n;
 20c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 20e:	fec05ae3          	blez	a2,202 <memmove+0x28>
 212:	fff6079b          	addiw	a5,a2,-1
 216:	1782                	slli	a5,a5,0x20
 218:	9381                	srli	a5,a5,0x20
 21a:	fff7c793          	not	a5,a5
 21e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 220:	15fd                	addi	a1,a1,-1
 222:	177d                	addi	a4,a4,-1
 224:	0005c683          	lbu	a3,0(a1)
 228:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x46>
 230:	bfc9                	j	202 <memmove+0x28>

0000000000000232 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 238:	ca05                	beqz	a2,268 <memcmp+0x36>
 23a:	fff6069b          	addiw	a3,a2,-1
 23e:	1682                	slli	a3,a3,0x20
 240:	9281                	srli	a3,a3,0x20
 242:	0685                	addi	a3,a3,1
 244:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 246:	00054783          	lbu	a5,0(a0)
 24a:	0005c703          	lbu	a4,0(a1)
 24e:	00e79863          	bne	a5,a4,25e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 252:	0505                	addi	a0,a0,1
    p2++;
 254:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 256:	fed518e3          	bne	a0,a3,246 <memcmp+0x14>
  }
  return 0;
 25a:	4501                	li	a0,0
 25c:	a019                	j	262 <memcmp+0x30>
      return *p1 - *p2;
 25e:	40e7853b          	subw	a0,a5,a4
}
 262:	6422                	ld	s0,8(sp)
 264:	0141                	addi	sp,sp,16
 266:	8082                	ret
  return 0;
 268:	4501                	li	a0,0
 26a:	bfe5                	j	262 <memcmp+0x30>

000000000000026c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e406                	sd	ra,8(sp)
 270:	e022                	sd	s0,0(sp)
 272:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 274:	f67ff0ef          	jal	1da <memmove>
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret

0000000000000280 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 280:	4885                	li	a7,1
 ecall
 282:	00000073          	ecall
 ret
 286:	8082                	ret

0000000000000288 <exit>:
.global exit
exit:
 li a7, SYS_exit
 288:	4889                	li	a7,2
 ecall
 28a:	00000073          	ecall
 ret
 28e:	8082                	ret

0000000000000290 <wait>:
.global wait
wait:
 li a7, SYS_wait
 290:	488d                	li	a7,3
 ecall
 292:	00000073          	ecall
 ret
 296:	8082                	ret

0000000000000298 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 298:	4891                	li	a7,4
 ecall
 29a:	00000073          	ecall
 ret
 29e:	8082                	ret

00000000000002a0 <read>:
.global read
read:
 li a7, SYS_read
 2a0:	4895                	li	a7,5
 ecall
 2a2:	00000073          	ecall
 ret
 2a6:	8082                	ret

00000000000002a8 <write>:
.global write
write:
 li a7, SYS_write
 2a8:	48c1                	li	a7,16
 ecall
 2aa:	00000073          	ecall
 ret
 2ae:	8082                	ret

00000000000002b0 <close>:
.global close
close:
 li a7, SYS_close
 2b0:	48d5                	li	a7,21
 ecall
 2b2:	00000073          	ecall
 ret
 2b6:	8082                	ret

00000000000002b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2b8:	4899                	li	a7,6
 ecall
 2ba:	00000073          	ecall
 ret
 2be:	8082                	ret

00000000000002c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2c0:	489d                	li	a7,7
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <open>:
.global open
open:
 li a7, SYS_open
 2c8:	48bd                	li	a7,15
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 2d0:	48c5                	li	a7,17
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 2d8:	48c9                	li	a7,18
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 2e0:	48a1                	li	a7,8
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <link>:
.global link
link:
 li a7, SYS_link
 2e8:	48cd                	li	a7,19
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 2f0:	48d1                	li	a7,20
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 2f8:	48a5                	li	a7,9
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <dup>:
.global dup
dup:
 li a7, SYS_dup
 300:	48a9                	li	a7,10
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 308:	48ad                	li	a7,11
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 310:	48b1                	li	a7,12
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 318:	48b5                	li	a7,13
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 320:	48b9                	li	a7,14
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <clone>:
.global clone
clone:
 li a7, SYS_clone
 328:	48d9                	li	a7,22
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <join>:
.global join
join:
 li a7, SYS_join
 330:	48dd                	li	a7,23
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 338:	1101                	addi	sp,sp,-32
 33a:	ec06                	sd	ra,24(sp)
 33c:	e822                	sd	s0,16(sp)
 33e:	1000                	addi	s0,sp,32
 340:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 344:	4605                	li	a2,1
 346:	fef40593          	addi	a1,s0,-17
 34a:	f5fff0ef          	jal	2a8 <write>
}
 34e:	60e2                	ld	ra,24(sp)
 350:	6442                	ld	s0,16(sp)
 352:	6105                	addi	sp,sp,32
 354:	8082                	ret

0000000000000356 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 356:	7139                	addi	sp,sp,-64
 358:	fc06                	sd	ra,56(sp)
 35a:	f822                	sd	s0,48(sp)
 35c:	f426                	sd	s1,40(sp)
 35e:	0080                	addi	s0,sp,64
 360:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 362:	c299                	beqz	a3,368 <printint+0x12>
 364:	0805c963          	bltz	a1,3f6 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 368:	2581                	sext.w	a1,a1
  neg = 0;
 36a:	4881                	li	a7,0
 36c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 370:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 372:	2601                	sext.w	a2,a2
 374:	00000517          	auipc	a0,0x0
 378:	57450513          	addi	a0,a0,1396 # 8e8 <digits>
 37c:	883a                	mv	a6,a4
 37e:	2705                	addiw	a4,a4,1
 380:	02c5f7bb          	remuw	a5,a1,a2
 384:	1782                	slli	a5,a5,0x20
 386:	9381                	srli	a5,a5,0x20
 388:	97aa                	add	a5,a5,a0
 38a:	0007c783          	lbu	a5,0(a5)
 38e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 392:	0005879b          	sext.w	a5,a1
 396:	02c5d5bb          	divuw	a1,a1,a2
 39a:	0685                	addi	a3,a3,1
 39c:	fec7f0e3          	bgeu	a5,a2,37c <printint+0x26>
  if(neg)
 3a0:	00088c63          	beqz	a7,3b8 <printint+0x62>
    buf[i++] = '-';
 3a4:	fd070793          	addi	a5,a4,-48
 3a8:	00878733          	add	a4,a5,s0
 3ac:	02d00793          	li	a5,45
 3b0:	fef70823          	sb	a5,-16(a4)
 3b4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3b8:	02e05a63          	blez	a4,3ec <printint+0x96>
 3bc:	f04a                	sd	s2,32(sp)
 3be:	ec4e                	sd	s3,24(sp)
 3c0:	fc040793          	addi	a5,s0,-64
 3c4:	00e78933          	add	s2,a5,a4
 3c8:	fff78993          	addi	s3,a5,-1
 3cc:	99ba                	add	s3,s3,a4
 3ce:	377d                	addiw	a4,a4,-1
 3d0:	1702                	slli	a4,a4,0x20
 3d2:	9301                	srli	a4,a4,0x20
 3d4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3d8:	fff94583          	lbu	a1,-1(s2)
 3dc:	8526                	mv	a0,s1
 3de:	f5bff0ef          	jal	338 <putc>
  while(--i >= 0)
 3e2:	197d                	addi	s2,s2,-1
 3e4:	ff391ae3          	bne	s2,s3,3d8 <printint+0x82>
 3e8:	7902                	ld	s2,32(sp)
 3ea:	69e2                	ld	s3,24(sp)
}
 3ec:	70e2                	ld	ra,56(sp)
 3ee:	7442                	ld	s0,48(sp)
 3f0:	74a2                	ld	s1,40(sp)
 3f2:	6121                	addi	sp,sp,64
 3f4:	8082                	ret
    x = -xx;
 3f6:	40b005bb          	negw	a1,a1
    neg = 1;
 3fa:	4885                	li	a7,1
    x = -xx;
 3fc:	bf85                	j	36c <printint+0x16>

00000000000003fe <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3fe:	711d                	addi	sp,sp,-96
 400:	ec86                	sd	ra,88(sp)
 402:	e8a2                	sd	s0,80(sp)
 404:	e0ca                	sd	s2,64(sp)
 406:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 408:	0005c903          	lbu	s2,0(a1)
 40c:	26090863          	beqz	s2,67c <vprintf+0x27e>
 410:	e4a6                	sd	s1,72(sp)
 412:	fc4e                	sd	s3,56(sp)
 414:	f852                	sd	s4,48(sp)
 416:	f456                	sd	s5,40(sp)
 418:	f05a                	sd	s6,32(sp)
 41a:	ec5e                	sd	s7,24(sp)
 41c:	e862                	sd	s8,16(sp)
 41e:	e466                	sd	s9,8(sp)
 420:	8b2a                	mv	s6,a0
 422:	8a2e                	mv	s4,a1
 424:	8bb2                	mv	s7,a2
  state = 0;
 426:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 428:	4481                	li	s1,0
 42a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 42c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 430:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 434:	06c00c93          	li	s9,108
 438:	a005                	j	458 <vprintf+0x5a>
        putc(fd, c0);
 43a:	85ca                	mv	a1,s2
 43c:	855a                	mv	a0,s6
 43e:	efbff0ef          	jal	338 <putc>
 442:	a019                	j	448 <vprintf+0x4a>
    } else if(state == '%'){
 444:	03598263          	beq	s3,s5,468 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 448:	2485                	addiw	s1,s1,1
 44a:	8726                	mv	a4,s1
 44c:	009a07b3          	add	a5,s4,s1
 450:	0007c903          	lbu	s2,0(a5)
 454:	20090c63          	beqz	s2,66c <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 458:	0009079b          	sext.w	a5,s2
    if(state == 0){
 45c:	fe0994e3          	bnez	s3,444 <vprintf+0x46>
      if(c0 == '%'){
 460:	fd579de3          	bne	a5,s5,43a <vprintf+0x3c>
        state = '%';
 464:	89be                	mv	s3,a5
 466:	b7cd                	j	448 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 468:	00ea06b3          	add	a3,s4,a4
 46c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 470:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 472:	c681                	beqz	a3,47a <vprintf+0x7c>
 474:	9752                	add	a4,a4,s4
 476:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 47a:	03878f63          	beq	a5,s8,4b8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 47e:	05978963          	beq	a5,s9,4d0 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 482:	07500713          	li	a4,117
 486:	0ee78363          	beq	a5,a4,56c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 48a:	07800713          	li	a4,120
 48e:	12e78563          	beq	a5,a4,5b8 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 492:	07000713          	li	a4,112
 496:	14e78a63          	beq	a5,a4,5ea <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 49a:	07300713          	li	a4,115
 49e:	18e78a63          	beq	a5,a4,632 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4a2:	02500713          	li	a4,37
 4a6:	04e79563          	bne	a5,a4,4f0 <vprintf+0xf2>
        putc(fd, '%');
 4aa:	02500593          	li	a1,37
 4ae:	855a                	mv	a0,s6
 4b0:	e89ff0ef          	jal	338 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4b4:	4981                	li	s3,0
 4b6:	bf49                	j	448 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4b8:	008b8913          	addi	s2,s7,8
 4bc:	4685                	li	a3,1
 4be:	4629                	li	a2,10
 4c0:	000ba583          	lw	a1,0(s7)
 4c4:	855a                	mv	a0,s6
 4c6:	e91ff0ef          	jal	356 <printint>
 4ca:	8bca                	mv	s7,s2
      state = 0;
 4cc:	4981                	li	s3,0
 4ce:	bfad                	j	448 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4d0:	06400793          	li	a5,100
 4d4:	02f68963          	beq	a3,a5,506 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4d8:	06c00793          	li	a5,108
 4dc:	04f68263          	beq	a3,a5,520 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4e0:	07500793          	li	a5,117
 4e4:	0af68063          	beq	a3,a5,584 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 4e8:	07800793          	li	a5,120
 4ec:	0ef68263          	beq	a3,a5,5d0 <vprintf+0x1d2>
        putc(fd, '%');
 4f0:	02500593          	li	a1,37
 4f4:	855a                	mv	a0,s6
 4f6:	e43ff0ef          	jal	338 <putc>
        putc(fd, c0);
 4fa:	85ca                	mv	a1,s2
 4fc:	855a                	mv	a0,s6
 4fe:	e3bff0ef          	jal	338 <putc>
      state = 0;
 502:	4981                	li	s3,0
 504:	b791                	j	448 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 506:	008b8913          	addi	s2,s7,8
 50a:	4685                	li	a3,1
 50c:	4629                	li	a2,10
 50e:	000ba583          	lw	a1,0(s7)
 512:	855a                	mv	a0,s6
 514:	e43ff0ef          	jal	356 <printint>
        i += 1;
 518:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 51a:	8bca                	mv	s7,s2
      state = 0;
 51c:	4981                	li	s3,0
        i += 1;
 51e:	b72d                	j	448 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 520:	06400793          	li	a5,100
 524:	02f60763          	beq	a2,a5,552 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 528:	07500793          	li	a5,117
 52c:	06f60963          	beq	a2,a5,59e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 530:	07800793          	li	a5,120
 534:	faf61ee3          	bne	a2,a5,4f0 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 538:	008b8913          	addi	s2,s7,8
 53c:	4681                	li	a3,0
 53e:	4641                	li	a2,16
 540:	000ba583          	lw	a1,0(s7)
 544:	855a                	mv	a0,s6
 546:	e11ff0ef          	jal	356 <printint>
        i += 2;
 54a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 54c:	8bca                	mv	s7,s2
      state = 0;
 54e:	4981                	li	s3,0
        i += 2;
 550:	bde5                	j	448 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 552:	008b8913          	addi	s2,s7,8
 556:	4685                	li	a3,1
 558:	4629                	li	a2,10
 55a:	000ba583          	lw	a1,0(s7)
 55e:	855a                	mv	a0,s6
 560:	df7ff0ef          	jal	356 <printint>
        i += 2;
 564:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 566:	8bca                	mv	s7,s2
      state = 0;
 568:	4981                	li	s3,0
        i += 2;
 56a:	bdf9                	j	448 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 56c:	008b8913          	addi	s2,s7,8
 570:	4681                	li	a3,0
 572:	4629                	li	a2,10
 574:	000ba583          	lw	a1,0(s7)
 578:	855a                	mv	a0,s6
 57a:	dddff0ef          	jal	356 <printint>
 57e:	8bca                	mv	s7,s2
      state = 0;
 580:	4981                	li	s3,0
 582:	b5d9                	j	448 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 584:	008b8913          	addi	s2,s7,8
 588:	4681                	li	a3,0
 58a:	4629                	li	a2,10
 58c:	000ba583          	lw	a1,0(s7)
 590:	855a                	mv	a0,s6
 592:	dc5ff0ef          	jal	356 <printint>
        i += 1;
 596:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 598:	8bca                	mv	s7,s2
      state = 0;
 59a:	4981                	li	s3,0
        i += 1;
 59c:	b575                	j	448 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59e:	008b8913          	addi	s2,s7,8
 5a2:	4681                	li	a3,0
 5a4:	4629                	li	a2,10
 5a6:	000ba583          	lw	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	dabff0ef          	jal	356 <printint>
        i += 2;
 5b0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b2:	8bca                	mv	s7,s2
      state = 0;
 5b4:	4981                	li	s3,0
        i += 2;
 5b6:	bd49                	j	448 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5b8:	008b8913          	addi	s2,s7,8
 5bc:	4681                	li	a3,0
 5be:	4641                	li	a2,16
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	d91ff0ef          	jal	356 <printint>
 5ca:	8bca                	mv	s7,s2
      state = 0;
 5cc:	4981                	li	s3,0
 5ce:	bdad                	j	448 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d0:	008b8913          	addi	s2,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4641                	li	a2,16
 5d8:	000ba583          	lw	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	d79ff0ef          	jal	356 <printint>
        i += 1;
 5e2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e4:	8bca                	mv	s7,s2
      state = 0;
 5e6:	4981                	li	s3,0
        i += 1;
 5e8:	b585                	j	448 <vprintf+0x4a>
 5ea:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5ec:	008b8d13          	addi	s10,s7,8
 5f0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5f4:	03000593          	li	a1,48
 5f8:	855a                	mv	a0,s6
 5fa:	d3fff0ef          	jal	338 <putc>
  putc(fd, 'x');
 5fe:	07800593          	li	a1,120
 602:	855a                	mv	a0,s6
 604:	d35ff0ef          	jal	338 <putc>
 608:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60a:	00000b97          	auipc	s7,0x0
 60e:	2deb8b93          	addi	s7,s7,734 # 8e8 <digits>
 612:	03c9d793          	srli	a5,s3,0x3c
 616:	97de                	add	a5,a5,s7
 618:	0007c583          	lbu	a1,0(a5)
 61c:	855a                	mv	a0,s6
 61e:	d1bff0ef          	jal	338 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 622:	0992                	slli	s3,s3,0x4
 624:	397d                	addiw	s2,s2,-1
 626:	fe0916e3          	bnez	s2,612 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 62a:	8bea                	mv	s7,s10
      state = 0;
 62c:	4981                	li	s3,0
 62e:	6d02                	ld	s10,0(sp)
 630:	bd21                	j	448 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 632:	008b8993          	addi	s3,s7,8
 636:	000bb903          	ld	s2,0(s7)
 63a:	00090f63          	beqz	s2,658 <vprintf+0x25a>
        for(; *s; s++)
 63e:	00094583          	lbu	a1,0(s2)
 642:	c195                	beqz	a1,666 <vprintf+0x268>
          putc(fd, *s);
 644:	855a                	mv	a0,s6
 646:	cf3ff0ef          	jal	338 <putc>
        for(; *s; s++)
 64a:	0905                	addi	s2,s2,1
 64c:	00094583          	lbu	a1,0(s2)
 650:	f9f5                	bnez	a1,644 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 652:	8bce                	mv	s7,s3
      state = 0;
 654:	4981                	li	s3,0
 656:	bbcd                	j	448 <vprintf+0x4a>
          s = "(null)";
 658:	00000917          	auipc	s2,0x0
 65c:	28890913          	addi	s2,s2,648 # 8e0 <thread_join+0x34>
        for(; *s; s++)
 660:	02800593          	li	a1,40
 664:	b7c5                	j	644 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 666:	8bce                	mv	s7,s3
      state = 0;
 668:	4981                	li	s3,0
 66a:	bbf9                	j	448 <vprintf+0x4a>
 66c:	64a6                	ld	s1,72(sp)
 66e:	79e2                	ld	s3,56(sp)
 670:	7a42                	ld	s4,48(sp)
 672:	7aa2                	ld	s5,40(sp)
 674:	7b02                	ld	s6,32(sp)
 676:	6be2                	ld	s7,24(sp)
 678:	6c42                	ld	s8,16(sp)
 67a:	6ca2                	ld	s9,8(sp)
    }
  }
}
 67c:	60e6                	ld	ra,88(sp)
 67e:	6446                	ld	s0,80(sp)
 680:	6906                	ld	s2,64(sp)
 682:	6125                	addi	sp,sp,96
 684:	8082                	ret

0000000000000686 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 686:	715d                	addi	sp,sp,-80
 688:	ec06                	sd	ra,24(sp)
 68a:	e822                	sd	s0,16(sp)
 68c:	1000                	addi	s0,sp,32
 68e:	e010                	sd	a2,0(s0)
 690:	e414                	sd	a3,8(s0)
 692:	e818                	sd	a4,16(s0)
 694:	ec1c                	sd	a5,24(s0)
 696:	03043023          	sd	a6,32(s0)
 69a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 69e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a2:	8622                	mv	a2,s0
 6a4:	d5bff0ef          	jal	3fe <vprintf>
}
 6a8:	60e2                	ld	ra,24(sp)
 6aa:	6442                	ld	s0,16(sp)
 6ac:	6161                	addi	sp,sp,80
 6ae:	8082                	ret

00000000000006b0 <printf>:

void
printf(const char *fmt, ...)
{
 6b0:	711d                	addi	sp,sp,-96
 6b2:	ec06                	sd	ra,24(sp)
 6b4:	e822                	sd	s0,16(sp)
 6b6:	1000                	addi	s0,sp,32
 6b8:	e40c                	sd	a1,8(s0)
 6ba:	e810                	sd	a2,16(s0)
 6bc:	ec14                	sd	a3,24(s0)
 6be:	f018                	sd	a4,32(s0)
 6c0:	f41c                	sd	a5,40(s0)
 6c2:	03043823          	sd	a6,48(s0)
 6c6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ca:	00840613          	addi	a2,s0,8
 6ce:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6d2:	85aa                	mv	a1,a0
 6d4:	4505                	li	a0,1
 6d6:	d29ff0ef          	jal	3fe <vprintf>
}
 6da:	60e2                	ld	ra,24(sp)
 6dc:	6442                	ld	s0,16(sp)
 6de:	6125                	addi	sp,sp,96
 6e0:	8082                	ret

00000000000006e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e2:	1141                	addi	sp,sp,-16
 6e4:	e422                	sd	s0,8(sp)
 6e6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ec:	00001797          	auipc	a5,0x1
 6f0:	9147b783          	ld	a5,-1772(a5) # 1000 <freep>
 6f4:	a02d                	j	71e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6f6:	4618                	lw	a4,8(a2)
 6f8:	9f2d                	addw	a4,a4,a1
 6fa:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6fe:	6398                	ld	a4,0(a5)
 700:	6310                	ld	a2,0(a4)
 702:	a83d                	j	740 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 704:	ff852703          	lw	a4,-8(a0)
 708:	9f31                	addw	a4,a4,a2
 70a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 70c:	ff053683          	ld	a3,-16(a0)
 710:	a091                	j	754 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 712:	6398                	ld	a4,0(a5)
 714:	00e7e463          	bltu	a5,a4,71c <free+0x3a>
 718:	00e6ea63          	bltu	a3,a4,72c <free+0x4a>
{
 71c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	fed7fae3          	bgeu	a5,a3,712 <free+0x30>
 722:	6398                	ld	a4,0(a5)
 724:	00e6e463          	bltu	a3,a4,72c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 728:	fee7eae3          	bltu	a5,a4,71c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 72c:	ff852583          	lw	a1,-8(a0)
 730:	6390                	ld	a2,0(a5)
 732:	02059813          	slli	a6,a1,0x20
 736:	01c85713          	srli	a4,a6,0x1c
 73a:	9736                	add	a4,a4,a3
 73c:	fae60de3          	beq	a2,a4,6f6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 740:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 744:	4790                	lw	a2,8(a5)
 746:	02061593          	slli	a1,a2,0x20
 74a:	01c5d713          	srli	a4,a1,0x1c
 74e:	973e                	add	a4,a4,a5
 750:	fae68ae3          	beq	a3,a4,704 <free+0x22>
    p->s.ptr = bp->s.ptr;
 754:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 756:	00001717          	auipc	a4,0x1
 75a:	8af73523          	sd	a5,-1878(a4) # 1000 <freep>
}
 75e:	6422                	ld	s0,8(sp)
 760:	0141                	addi	sp,sp,16
 762:	8082                	ret

0000000000000764 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 764:	7139                	addi	sp,sp,-64
 766:	fc06                	sd	ra,56(sp)
 768:	f822                	sd	s0,48(sp)
 76a:	f426                	sd	s1,40(sp)
 76c:	ec4e                	sd	s3,24(sp)
 76e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 770:	02051493          	slli	s1,a0,0x20
 774:	9081                	srli	s1,s1,0x20
 776:	04bd                	addi	s1,s1,15
 778:	8091                	srli	s1,s1,0x4
 77a:	0014899b          	addiw	s3,s1,1
 77e:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 780:	00001517          	auipc	a0,0x1
 784:	88053503          	ld	a0,-1920(a0) # 1000 <freep>
 788:	c915                	beqz	a0,7bc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 78a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 78c:	4798                	lw	a4,8(a5)
 78e:	08977a63          	bgeu	a4,s1,822 <malloc+0xbe>
 792:	f04a                	sd	s2,32(sp)
 794:	e852                	sd	s4,16(sp)
 796:	e456                	sd	s5,8(sp)
 798:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 79a:	8a4e                	mv	s4,s3
 79c:	0009871b          	sext.w	a4,s3
 7a0:	6685                	lui	a3,0x1
 7a2:	00d77363          	bgeu	a4,a3,7a8 <malloc+0x44>
 7a6:	6a05                	lui	s4,0x1
 7a8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ac:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b0:	00001917          	auipc	s2,0x1
 7b4:	85090913          	addi	s2,s2,-1968 # 1000 <freep>
  if(p == (char*)-1)
 7b8:	5afd                	li	s5,-1
 7ba:	a081                	j	7fa <malloc+0x96>
 7bc:	f04a                	sd	s2,32(sp)
 7be:	e852                	sd	s4,16(sp)
 7c0:	e456                	sd	s5,8(sp)
 7c2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7c4:	00001797          	auipc	a5,0x1
 7c8:	84c78793          	addi	a5,a5,-1972 # 1010 <base>
 7cc:	00001717          	auipc	a4,0x1
 7d0:	82f73a23          	sd	a5,-1996(a4) # 1000 <freep>
 7d4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7d6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7da:	b7c1                	j	79a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7dc:	6398                	ld	a4,0(a5)
 7de:	e118                	sd	a4,0(a0)
 7e0:	a8a9                	j	83a <malloc+0xd6>
  hp->s.size = nu;
 7e2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7e6:	0541                	addi	a0,a0,16
 7e8:	efbff0ef          	jal	6e2 <free>
  return freep;
 7ec:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7f0:	c12d                	beqz	a0,852 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7f4:	4798                	lw	a4,8(a5)
 7f6:	02977263          	bgeu	a4,s1,81a <malloc+0xb6>
    if(p == freep)
 7fa:	00093703          	ld	a4,0(s2)
 7fe:	853e                	mv	a0,a5
 800:	fef719e3          	bne	a4,a5,7f2 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 804:	8552                	mv	a0,s4
 806:	b0bff0ef          	jal	310 <sbrk>
  if(p == (char*)-1)
 80a:	fd551ce3          	bne	a0,s5,7e2 <malloc+0x7e>
        return 0;
 80e:	4501                	li	a0,0
 810:	7902                	ld	s2,32(sp)
 812:	6a42                	ld	s4,16(sp)
 814:	6aa2                	ld	s5,8(sp)
 816:	6b02                	ld	s6,0(sp)
 818:	a03d                	j	846 <malloc+0xe2>
 81a:	7902                	ld	s2,32(sp)
 81c:	6a42                	ld	s4,16(sp)
 81e:	6aa2                	ld	s5,8(sp)
 820:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 822:	fae48de3          	beq	s1,a4,7dc <malloc+0x78>
        p->s.size -= nunits;
 826:	4137073b          	subw	a4,a4,s3
 82a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 82c:	02071693          	slli	a3,a4,0x20
 830:	01c6d713          	srli	a4,a3,0x1c
 834:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 836:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 83a:	00000717          	auipc	a4,0x0
 83e:	7ca73323          	sd	a0,1990(a4) # 1000 <freep>
      return (void*)(p + 1);
 842:	01078513          	addi	a0,a5,16
  }
}
 846:	70e2                	ld	ra,56(sp)
 848:	7442                	ld	s0,48(sp)
 84a:	74a2                	ld	s1,40(sp)
 84c:	69e2                	ld	s3,24(sp)
 84e:	6121                	addi	sp,sp,64
 850:	8082                	ret
 852:	7902                	ld	s2,32(sp)
 854:	6a42                	ld	s4,16(sp)
 856:	6aa2                	ld	s5,8(sp)
 858:	6b02                	ld	s6,0(sp)
 85a:	b7f5                	j	846 <malloc+0xe2>

000000000000085c <thread_create>:
#include "kernel/types.h"
#include "kernel/riscv.h"

int 
thread_create(void (*start_routine)(void*, void*), void *arg1, void* arg2)
{
 85c:	7179                	addi	sp,sp,-48
 85e:	f406                	sd	ra,40(sp)
 860:	f022                	sd	s0,32(sp)
 862:	e84a                	sd	s2,16(sp)
 864:	e44e                	sd	s3,8(sp)
 866:	e052                	sd	s4,0(sp)
 868:	1800                	addi	s0,sp,48
 86a:	892a                	mv	s2,a0
 86c:	89ae                	mv	s3,a1
 86e:	8a32                	mv	s4,a2
    int tid;

    void *stack = malloc(2 * PGSIZE);
 870:	6509                	lui	a0,0x2
 872:	ef3ff0ef          	jal	764 <malloc>
    if (stack == 0) return -1;
 876:	c90d                	beqz	a0,8a8 <thread_create+0x4c>
 878:	ec26                	sd	s1,24(sp)
 87a:	84aa                	mv	s1,a0
    
    if ((tid = clone(start_routine, arg1, arg2, stack)) < 0) {
 87c:	86aa                	mv	a3,a0
 87e:	8652                	mv	a2,s4
 880:	85ce                	mv	a1,s3
 882:	854a                	mv	a0,s2
 884:	aa5ff0ef          	jal	328 <clone>
 888:	00054a63          	bltz	a0,89c <thread_create+0x40>
 88c:	64e2                	ld	s1,24(sp)
        free(stack);
        return -1;
    }
    
    return tid;
}
 88e:	70a2                	ld	ra,40(sp)
 890:	7402                	ld	s0,32(sp)
 892:	6942                	ld	s2,16(sp)
 894:	69a2                	ld	s3,8(sp)
 896:	6a02                	ld	s4,0(sp)
 898:	6145                	addi	sp,sp,48
 89a:	8082                	ret
        free(stack);
 89c:	8526                	mv	a0,s1
 89e:	e45ff0ef          	jal	6e2 <free>
        return -1;
 8a2:	557d                	li	a0,-1
 8a4:	64e2                	ld	s1,24(sp)
 8a6:	b7e5                	j	88e <thread_create+0x32>
    if (stack == 0) return -1;
 8a8:	557d                	li	a0,-1
 8aa:	b7d5                	j	88e <thread_create+0x32>

00000000000008ac <thread_join>:

int 
thread_join()
{   
 8ac:	7179                	addi	sp,sp,-48
 8ae:	f406                	sd	ra,40(sp)
 8b0:	f022                	sd	s0,32(sp)
 8b2:	ec26                	sd	s1,24(sp)
 8b4:	1800                	addi	s0,sp,48
    int tid;
    void *stack;
    
    if ((tid = join(&stack)) < 0) {
 8b6:	fd840513          	addi	a0,s0,-40
 8ba:	a77ff0ef          	jal	330 <join>
 8be:	00054d63          	bltz	a0,8d8 <thread_join+0x2c>
 8c2:	84aa                	mv	s1,a0
        return -1;
    }

    free(stack);
 8c4:	fd843503          	ld	a0,-40(s0)
 8c8:	e1bff0ef          	jal	6e2 <free>
    return tid;
}
 8cc:	8526                	mv	a0,s1
 8ce:	70a2                	ld	ra,40(sp)
 8d0:	7402                	ld	s0,32(sp)
 8d2:	64e2                	ld	s1,24(sp)
 8d4:	6145                	addi	sp,sp,48
 8d6:	8082                	ret
        return -1;
 8d8:	54fd                	li	s1,-1
 8da:	bfcd                	j	8cc <thread_join+0x20>
