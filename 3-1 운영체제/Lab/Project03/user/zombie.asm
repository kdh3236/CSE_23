
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

0000000000000328 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 328:	48d9                	li	a7,22
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 330:	1101                	addi	sp,sp,-32
 332:	ec06                	sd	ra,24(sp)
 334:	e822                	sd	s0,16(sp)
 336:	1000                	addi	s0,sp,32
 338:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 33c:	4605                	li	a2,1
 33e:	fef40593          	addi	a1,s0,-17
 342:	f67ff0ef          	jal	2a8 <write>
}
 346:	60e2                	ld	ra,24(sp)
 348:	6442                	ld	s0,16(sp)
 34a:	6105                	addi	sp,sp,32
 34c:	8082                	ret

000000000000034e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 34e:	7139                	addi	sp,sp,-64
 350:	fc06                	sd	ra,56(sp)
 352:	f822                	sd	s0,48(sp)
 354:	f426                	sd	s1,40(sp)
 356:	0080                	addi	s0,sp,64
 358:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 35a:	c299                	beqz	a3,360 <printint+0x12>
 35c:	0805c963          	bltz	a1,3ee <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 360:	2581                	sext.w	a1,a1
  neg = 0;
 362:	4881                	li	a7,0
 364:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 368:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 36a:	2601                	sext.w	a2,a2
 36c:	00000517          	auipc	a0,0x0
 370:	4fc50513          	addi	a0,a0,1276 # 868 <digits>
 374:	883a                	mv	a6,a4
 376:	2705                	addiw	a4,a4,1
 378:	02c5f7bb          	remuw	a5,a1,a2
 37c:	1782                	slli	a5,a5,0x20
 37e:	9381                	srli	a5,a5,0x20
 380:	97aa                	add	a5,a5,a0
 382:	0007c783          	lbu	a5,0(a5)
 386:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 38a:	0005879b          	sext.w	a5,a1
 38e:	02c5d5bb          	divuw	a1,a1,a2
 392:	0685                	addi	a3,a3,1
 394:	fec7f0e3          	bgeu	a5,a2,374 <printint+0x26>
  if(neg)
 398:	00088c63          	beqz	a7,3b0 <printint+0x62>
    buf[i++] = '-';
 39c:	fd070793          	addi	a5,a4,-48
 3a0:	00878733          	add	a4,a5,s0
 3a4:	02d00793          	li	a5,45
 3a8:	fef70823          	sb	a5,-16(a4)
 3ac:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3b0:	02e05a63          	blez	a4,3e4 <printint+0x96>
 3b4:	f04a                	sd	s2,32(sp)
 3b6:	ec4e                	sd	s3,24(sp)
 3b8:	fc040793          	addi	a5,s0,-64
 3bc:	00e78933          	add	s2,a5,a4
 3c0:	fff78993          	addi	s3,a5,-1
 3c4:	99ba                	add	s3,s3,a4
 3c6:	377d                	addiw	a4,a4,-1
 3c8:	1702                	slli	a4,a4,0x20
 3ca:	9301                	srli	a4,a4,0x20
 3cc:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 3d0:	fff94583          	lbu	a1,-1(s2)
 3d4:	8526                	mv	a0,s1
 3d6:	f5bff0ef          	jal	330 <putc>
  while(--i >= 0)
 3da:	197d                	addi	s2,s2,-1
 3dc:	ff391ae3          	bne	s2,s3,3d0 <printint+0x82>
 3e0:	7902                	ld	s2,32(sp)
 3e2:	69e2                	ld	s3,24(sp)
}
 3e4:	70e2                	ld	ra,56(sp)
 3e6:	7442                	ld	s0,48(sp)
 3e8:	74a2                	ld	s1,40(sp)
 3ea:	6121                	addi	sp,sp,64
 3ec:	8082                	ret
    x = -xx;
 3ee:	40b005bb          	negw	a1,a1
    neg = 1;
 3f2:	4885                	li	a7,1
    x = -xx;
 3f4:	bf85                	j	364 <printint+0x16>

00000000000003f6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 3f6:	711d                	addi	sp,sp,-96
 3f8:	ec86                	sd	ra,88(sp)
 3fa:	e8a2                	sd	s0,80(sp)
 3fc:	e0ca                	sd	s2,64(sp)
 3fe:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 400:	0005c903          	lbu	s2,0(a1)
 404:	26090863          	beqz	s2,674 <vprintf+0x27e>
 408:	e4a6                	sd	s1,72(sp)
 40a:	fc4e                	sd	s3,56(sp)
 40c:	f852                	sd	s4,48(sp)
 40e:	f456                	sd	s5,40(sp)
 410:	f05a                	sd	s6,32(sp)
 412:	ec5e                	sd	s7,24(sp)
 414:	e862                	sd	s8,16(sp)
 416:	e466                	sd	s9,8(sp)
 418:	8b2a                	mv	s6,a0
 41a:	8a2e                	mv	s4,a1
 41c:	8bb2                	mv	s7,a2
  state = 0;
 41e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 420:	4481                	li	s1,0
 422:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 424:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 428:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 42c:	06c00c93          	li	s9,108
 430:	a005                	j	450 <vprintf+0x5a>
        putc(fd, c0);
 432:	85ca                	mv	a1,s2
 434:	855a                	mv	a0,s6
 436:	efbff0ef          	jal	330 <putc>
 43a:	a019                	j	440 <vprintf+0x4a>
    } else if(state == '%'){
 43c:	03598263          	beq	s3,s5,460 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 440:	2485                	addiw	s1,s1,1
 442:	8726                	mv	a4,s1
 444:	009a07b3          	add	a5,s4,s1
 448:	0007c903          	lbu	s2,0(a5)
 44c:	20090c63          	beqz	s2,664 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 450:	0009079b          	sext.w	a5,s2
    if(state == 0){
 454:	fe0994e3          	bnez	s3,43c <vprintf+0x46>
      if(c0 == '%'){
 458:	fd579de3          	bne	a5,s5,432 <vprintf+0x3c>
        state = '%';
 45c:	89be                	mv	s3,a5
 45e:	b7cd                	j	440 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 460:	00ea06b3          	add	a3,s4,a4
 464:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 468:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 46a:	c681                	beqz	a3,472 <vprintf+0x7c>
 46c:	9752                	add	a4,a4,s4
 46e:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 472:	03878f63          	beq	a5,s8,4b0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 476:	05978963          	beq	a5,s9,4c8 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 47a:	07500713          	li	a4,117
 47e:	0ee78363          	beq	a5,a4,564 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 482:	07800713          	li	a4,120
 486:	12e78563          	beq	a5,a4,5b0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 48a:	07000713          	li	a4,112
 48e:	14e78a63          	beq	a5,a4,5e2 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 492:	07300713          	li	a4,115
 496:	18e78a63          	beq	a5,a4,62a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 49a:	02500713          	li	a4,37
 49e:	04e79563          	bne	a5,a4,4e8 <vprintf+0xf2>
        putc(fd, '%');
 4a2:	02500593          	li	a1,37
 4a6:	855a                	mv	a0,s6
 4a8:	e89ff0ef          	jal	330 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4ac:	4981                	li	s3,0
 4ae:	bf49                	j	440 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4b0:	008b8913          	addi	s2,s7,8
 4b4:	4685                	li	a3,1
 4b6:	4629                	li	a2,10
 4b8:	000ba583          	lw	a1,0(s7)
 4bc:	855a                	mv	a0,s6
 4be:	e91ff0ef          	jal	34e <printint>
 4c2:	8bca                	mv	s7,s2
      state = 0;
 4c4:	4981                	li	s3,0
 4c6:	bfad                	j	440 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4c8:	06400793          	li	a5,100
 4cc:	02f68963          	beq	a3,a5,4fe <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4d0:	06c00793          	li	a5,108
 4d4:	04f68263          	beq	a3,a5,518 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4d8:	07500793          	li	a5,117
 4dc:	0af68063          	beq	a3,a5,57c <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 4e0:	07800793          	li	a5,120
 4e4:	0ef68263          	beq	a3,a5,5c8 <vprintf+0x1d2>
        putc(fd, '%');
 4e8:	02500593          	li	a1,37
 4ec:	855a                	mv	a0,s6
 4ee:	e43ff0ef          	jal	330 <putc>
        putc(fd, c0);
 4f2:	85ca                	mv	a1,s2
 4f4:	855a                	mv	a0,s6
 4f6:	e3bff0ef          	jal	330 <putc>
      state = 0;
 4fa:	4981                	li	s3,0
 4fc:	b791                	j	440 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4fe:	008b8913          	addi	s2,s7,8
 502:	4685                	li	a3,1
 504:	4629                	li	a2,10
 506:	000ba583          	lw	a1,0(s7)
 50a:	855a                	mv	a0,s6
 50c:	e43ff0ef          	jal	34e <printint>
        i += 1;
 510:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 512:	8bca                	mv	s7,s2
      state = 0;
 514:	4981                	li	s3,0
        i += 1;
 516:	b72d                	j	440 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 518:	06400793          	li	a5,100
 51c:	02f60763          	beq	a2,a5,54a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 520:	07500793          	li	a5,117
 524:	06f60963          	beq	a2,a5,596 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 528:	07800793          	li	a5,120
 52c:	faf61ee3          	bne	a2,a5,4e8 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 530:	008b8913          	addi	s2,s7,8
 534:	4681                	li	a3,0
 536:	4641                	li	a2,16
 538:	000ba583          	lw	a1,0(s7)
 53c:	855a                	mv	a0,s6
 53e:	e11ff0ef          	jal	34e <printint>
        i += 2;
 542:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 544:	8bca                	mv	s7,s2
      state = 0;
 546:	4981                	li	s3,0
        i += 2;
 548:	bde5                	j	440 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 54a:	008b8913          	addi	s2,s7,8
 54e:	4685                	li	a3,1
 550:	4629                	li	a2,10
 552:	000ba583          	lw	a1,0(s7)
 556:	855a                	mv	a0,s6
 558:	df7ff0ef          	jal	34e <printint>
        i += 2;
 55c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 55e:	8bca                	mv	s7,s2
      state = 0;
 560:	4981                	li	s3,0
        i += 2;
 562:	bdf9                	j	440 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 564:	008b8913          	addi	s2,s7,8
 568:	4681                	li	a3,0
 56a:	4629                	li	a2,10
 56c:	000ba583          	lw	a1,0(s7)
 570:	855a                	mv	a0,s6
 572:	dddff0ef          	jal	34e <printint>
 576:	8bca                	mv	s7,s2
      state = 0;
 578:	4981                	li	s3,0
 57a:	b5d9                	j	440 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 57c:	008b8913          	addi	s2,s7,8
 580:	4681                	li	a3,0
 582:	4629                	li	a2,10
 584:	000ba583          	lw	a1,0(s7)
 588:	855a                	mv	a0,s6
 58a:	dc5ff0ef          	jal	34e <printint>
        i += 1;
 58e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 590:	8bca                	mv	s7,s2
      state = 0;
 592:	4981                	li	s3,0
        i += 1;
 594:	b575                	j	440 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 596:	008b8913          	addi	s2,s7,8
 59a:	4681                	li	a3,0
 59c:	4629                	li	a2,10
 59e:	000ba583          	lw	a1,0(s7)
 5a2:	855a                	mv	a0,s6
 5a4:	dabff0ef          	jal	34e <printint>
        i += 2;
 5a8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5aa:	8bca                	mv	s7,s2
      state = 0;
 5ac:	4981                	li	s3,0
        i += 2;
 5ae:	bd49                	j	440 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5b0:	008b8913          	addi	s2,s7,8
 5b4:	4681                	li	a3,0
 5b6:	4641                	li	a2,16
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	d91ff0ef          	jal	34e <printint>
 5c2:	8bca                	mv	s7,s2
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	bdad                	j	440 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5c8:	008b8913          	addi	s2,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4641                	li	a2,16
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	d79ff0ef          	jal	34e <printint>
        i += 1;
 5da:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5dc:	8bca                	mv	s7,s2
      state = 0;
 5de:	4981                	li	s3,0
        i += 1;
 5e0:	b585                	j	440 <vprintf+0x4a>
 5e2:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 5e4:	008b8d13          	addi	s10,s7,8
 5e8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5ec:	03000593          	li	a1,48
 5f0:	855a                	mv	a0,s6
 5f2:	d3fff0ef          	jal	330 <putc>
  putc(fd, 'x');
 5f6:	07800593          	li	a1,120
 5fa:	855a                	mv	a0,s6
 5fc:	d35ff0ef          	jal	330 <putc>
 600:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 602:	00000b97          	auipc	s7,0x0
 606:	266b8b93          	addi	s7,s7,614 # 868 <digits>
 60a:	03c9d793          	srli	a5,s3,0x3c
 60e:	97de                	add	a5,a5,s7
 610:	0007c583          	lbu	a1,0(a5)
 614:	855a                	mv	a0,s6
 616:	d1bff0ef          	jal	330 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 61a:	0992                	slli	s3,s3,0x4
 61c:	397d                	addiw	s2,s2,-1
 61e:	fe0916e3          	bnez	s2,60a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 622:	8bea                	mv	s7,s10
      state = 0;
 624:	4981                	li	s3,0
 626:	6d02                	ld	s10,0(sp)
 628:	bd21                	j	440 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 62a:	008b8993          	addi	s3,s7,8
 62e:	000bb903          	ld	s2,0(s7)
 632:	00090f63          	beqz	s2,650 <vprintf+0x25a>
        for(; *s; s++)
 636:	00094583          	lbu	a1,0(s2)
 63a:	c195                	beqz	a1,65e <vprintf+0x268>
          putc(fd, *s);
 63c:	855a                	mv	a0,s6
 63e:	cf3ff0ef          	jal	330 <putc>
        for(; *s; s++)
 642:	0905                	addi	s2,s2,1
 644:	00094583          	lbu	a1,0(s2)
 648:	f9f5                	bnez	a1,63c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 64a:	8bce                	mv	s7,s3
      state = 0;
 64c:	4981                	li	s3,0
 64e:	bbcd                	j	440 <vprintf+0x4a>
          s = "(null)";
 650:	00000917          	auipc	s2,0x0
 654:	21090913          	addi	s2,s2,528 # 860 <malloc+0x104>
        for(; *s; s++)
 658:	02800593          	li	a1,40
 65c:	b7c5                	j	63c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 65e:	8bce                	mv	s7,s3
      state = 0;
 660:	4981                	li	s3,0
 662:	bbf9                	j	440 <vprintf+0x4a>
 664:	64a6                	ld	s1,72(sp)
 666:	79e2                	ld	s3,56(sp)
 668:	7a42                	ld	s4,48(sp)
 66a:	7aa2                	ld	s5,40(sp)
 66c:	7b02                	ld	s6,32(sp)
 66e:	6be2                	ld	s7,24(sp)
 670:	6c42                	ld	s8,16(sp)
 672:	6ca2                	ld	s9,8(sp)
    }
  }
}
 674:	60e6                	ld	ra,88(sp)
 676:	6446                	ld	s0,80(sp)
 678:	6906                	ld	s2,64(sp)
 67a:	6125                	addi	sp,sp,96
 67c:	8082                	ret

000000000000067e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 67e:	715d                	addi	sp,sp,-80
 680:	ec06                	sd	ra,24(sp)
 682:	e822                	sd	s0,16(sp)
 684:	1000                	addi	s0,sp,32
 686:	e010                	sd	a2,0(s0)
 688:	e414                	sd	a3,8(s0)
 68a:	e818                	sd	a4,16(s0)
 68c:	ec1c                	sd	a5,24(s0)
 68e:	03043023          	sd	a6,32(s0)
 692:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 696:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 69a:	8622                	mv	a2,s0
 69c:	d5bff0ef          	jal	3f6 <vprintf>
}
 6a0:	60e2                	ld	ra,24(sp)
 6a2:	6442                	ld	s0,16(sp)
 6a4:	6161                	addi	sp,sp,80
 6a6:	8082                	ret

00000000000006a8 <printf>:

void
printf(const char *fmt, ...)
{
 6a8:	711d                	addi	sp,sp,-96
 6aa:	ec06                	sd	ra,24(sp)
 6ac:	e822                	sd	s0,16(sp)
 6ae:	1000                	addi	s0,sp,32
 6b0:	e40c                	sd	a1,8(s0)
 6b2:	e810                	sd	a2,16(s0)
 6b4:	ec14                	sd	a3,24(s0)
 6b6:	f018                	sd	a4,32(s0)
 6b8:	f41c                	sd	a5,40(s0)
 6ba:	03043823          	sd	a6,48(s0)
 6be:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6c2:	00840613          	addi	a2,s0,8
 6c6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6ca:	85aa                	mv	a1,a0
 6cc:	4505                	li	a0,1
 6ce:	d29ff0ef          	jal	3f6 <vprintf>
}
 6d2:	60e2                	ld	ra,24(sp)
 6d4:	6442                	ld	s0,16(sp)
 6d6:	6125                	addi	sp,sp,96
 6d8:	8082                	ret

00000000000006da <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6da:	1141                	addi	sp,sp,-16
 6dc:	e422                	sd	s0,8(sp)
 6de:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6e0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e4:	00001797          	auipc	a5,0x1
 6e8:	91c7b783          	ld	a5,-1764(a5) # 1000 <freep>
 6ec:	a02d                	j	716 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6ee:	4618                	lw	a4,8(a2)
 6f0:	9f2d                	addw	a4,a4,a1
 6f2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6f6:	6398                	ld	a4,0(a5)
 6f8:	6310                	ld	a2,0(a4)
 6fa:	a83d                	j	738 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6fc:	ff852703          	lw	a4,-8(a0)
 700:	9f31                	addw	a4,a4,a2
 702:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 704:	ff053683          	ld	a3,-16(a0)
 708:	a091                	j	74c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70a:	6398                	ld	a4,0(a5)
 70c:	00e7e463          	bltu	a5,a4,714 <free+0x3a>
 710:	00e6ea63          	bltu	a3,a4,724 <free+0x4a>
{
 714:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 716:	fed7fae3          	bgeu	a5,a3,70a <free+0x30>
 71a:	6398                	ld	a4,0(a5)
 71c:	00e6e463          	bltu	a3,a4,724 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 720:	fee7eae3          	bltu	a5,a4,714 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 724:	ff852583          	lw	a1,-8(a0)
 728:	6390                	ld	a2,0(a5)
 72a:	02059813          	slli	a6,a1,0x20
 72e:	01c85713          	srli	a4,a6,0x1c
 732:	9736                	add	a4,a4,a3
 734:	fae60de3          	beq	a2,a4,6ee <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 738:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 73c:	4790                	lw	a2,8(a5)
 73e:	02061593          	slli	a1,a2,0x20
 742:	01c5d713          	srli	a4,a1,0x1c
 746:	973e                	add	a4,a4,a5
 748:	fae68ae3          	beq	a3,a4,6fc <free+0x22>
    p->s.ptr = bp->s.ptr;
 74c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 74e:	00001717          	auipc	a4,0x1
 752:	8af73923          	sd	a5,-1870(a4) # 1000 <freep>
}
 756:	6422                	ld	s0,8(sp)
 758:	0141                	addi	sp,sp,16
 75a:	8082                	ret

000000000000075c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 75c:	7139                	addi	sp,sp,-64
 75e:	fc06                	sd	ra,56(sp)
 760:	f822                	sd	s0,48(sp)
 762:	f426                	sd	s1,40(sp)
 764:	ec4e                	sd	s3,24(sp)
 766:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 768:	02051493          	slli	s1,a0,0x20
 76c:	9081                	srli	s1,s1,0x20
 76e:	04bd                	addi	s1,s1,15
 770:	8091                	srli	s1,s1,0x4
 772:	0014899b          	addiw	s3,s1,1
 776:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 778:	00001517          	auipc	a0,0x1
 77c:	88853503          	ld	a0,-1912(a0) # 1000 <freep>
 780:	c915                	beqz	a0,7b4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 782:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 784:	4798                	lw	a4,8(a5)
 786:	08977a63          	bgeu	a4,s1,81a <malloc+0xbe>
 78a:	f04a                	sd	s2,32(sp)
 78c:	e852                	sd	s4,16(sp)
 78e:	e456                	sd	s5,8(sp)
 790:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 792:	8a4e                	mv	s4,s3
 794:	0009871b          	sext.w	a4,s3
 798:	6685                	lui	a3,0x1
 79a:	00d77363          	bgeu	a4,a3,7a0 <malloc+0x44>
 79e:	6a05                	lui	s4,0x1
 7a0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7a4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7a8:	00001917          	auipc	s2,0x1
 7ac:	85890913          	addi	s2,s2,-1960 # 1000 <freep>
  if(p == (char*)-1)
 7b0:	5afd                	li	s5,-1
 7b2:	a081                	j	7f2 <malloc+0x96>
 7b4:	f04a                	sd	s2,32(sp)
 7b6:	e852                	sd	s4,16(sp)
 7b8:	e456                	sd	s5,8(sp)
 7ba:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7bc:	00001797          	auipc	a5,0x1
 7c0:	85478793          	addi	a5,a5,-1964 # 1010 <base>
 7c4:	00001717          	auipc	a4,0x1
 7c8:	82f73e23          	sd	a5,-1988(a4) # 1000 <freep>
 7cc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ce:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7d2:	b7c1                	j	792 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7d4:	6398                	ld	a4,0(a5)
 7d6:	e118                	sd	a4,0(a0)
 7d8:	a8a9                	j	832 <malloc+0xd6>
  hp->s.size = nu;
 7da:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7de:	0541                	addi	a0,a0,16
 7e0:	efbff0ef          	jal	6da <free>
  return freep;
 7e4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7e8:	c12d                	beqz	a0,84a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ea:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7ec:	4798                	lw	a4,8(a5)
 7ee:	02977263          	bgeu	a4,s1,812 <malloc+0xb6>
    if(p == freep)
 7f2:	00093703          	ld	a4,0(s2)
 7f6:	853e                	mv	a0,a5
 7f8:	fef719e3          	bne	a4,a5,7ea <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 7fc:	8552                	mv	a0,s4
 7fe:	b13ff0ef          	jal	310 <sbrk>
  if(p == (char*)-1)
 802:	fd551ce3          	bne	a0,s5,7da <malloc+0x7e>
        return 0;
 806:	4501                	li	a0,0
 808:	7902                	ld	s2,32(sp)
 80a:	6a42                	ld	s4,16(sp)
 80c:	6aa2                	ld	s5,8(sp)
 80e:	6b02                	ld	s6,0(sp)
 810:	a03d                	j	83e <malloc+0xe2>
 812:	7902                	ld	s2,32(sp)
 814:	6a42                	ld	s4,16(sp)
 816:	6aa2                	ld	s5,8(sp)
 818:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 81a:	fae48de3          	beq	s1,a4,7d4 <malloc+0x78>
        p->s.size -= nunits;
 81e:	4137073b          	subw	a4,a4,s3
 822:	c798                	sw	a4,8(a5)
        p += p->s.size;
 824:	02071693          	slli	a3,a4,0x20
 828:	01c6d713          	srli	a4,a3,0x1c
 82c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 82e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 832:	00000717          	auipc	a4,0x0
 836:	7ca73723          	sd	a0,1998(a4) # 1000 <freep>
      return (void*)(p + 1);
 83a:	01078513          	addi	a0,a5,16
  }
}
 83e:	70e2                	ld	ra,56(sp)
 840:	7442                	ld	s0,48(sp)
 842:	74a2                	ld	s1,40(sp)
 844:	69e2                	ld	s3,24(sp)
 846:	6121                	addi	sp,sp,64
 848:	8082                	ret
 84a:	7902                	ld	s2,32(sp)
 84c:	6a42                	ld	s4,16(sp)
 84e:	6aa2                	ld	s5,8(sp)
 850:	6b02                	ld	s6,0(sp)
 852:	b7f5                	j	83e <malloc+0xe2>
