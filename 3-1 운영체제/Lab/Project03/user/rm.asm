
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7d763          	bge	a5,a0,38 <main+0x38>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(unlink(argv[i]) < 0){
  26:	6088                	ld	a0,0(s1)
  28:	2f8000ef          	jal	320 <unlink>
  2c:	02054263          	bltz	a0,50 <main+0x50>
  for(i = 1; i < argc; i++){
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
  36:	a02d                	j	60 <main+0x60>
  38:	e426                	sd	s1,8(sp)
  3a:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: rm files...\n");
  3c:	00001597          	auipc	a1,0x1
  40:	86458593          	addi	a1,a1,-1948 # 8a0 <malloc+0xfc>
  44:	4509                	li	a0,2
  46:	680000ef          	jal	6c6 <fprintf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	284000ef          	jal	2d0 <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  50:	6090                	ld	a2,0(s1)
  52:	00001597          	auipc	a1,0x1
  56:	86658593          	addi	a1,a1,-1946 # 8b8 <malloc+0x114>
  5a:	4509                	li	a0,2
  5c:	66a000ef          	jal	6c6 <fprintf>
      break;
    }
  }

  exit(0);
  60:	4501                	li	a0,0
  62:	26e000ef          	jal	2d0 <exit>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  extern int main();
  main();
  6e:	f93ff0ef          	jal	0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	25c000ef          	jal	2d0 <exit>

0000000000000078 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  78:	1141                	addi	sp,sp,-16
  7a:	e422                	sd	s0,8(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0x8>
    ;
  return os;
}
  8e:	6422                	ld	s0,8(sp)
  90:	0141                	addi	sp,sp,16
  92:	8082                	ret

0000000000000094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  94:	1141                	addi	sp,sp,-16
  96:	e422                	sd	s0,8(sp)
  98:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  9a:	00054783          	lbu	a5,0(a0)
  9e:	cb91                	beqz	a5,b2 <strcmp+0x1e>
  a0:	0005c703          	lbu	a4,0(a1)
  a4:	00f71763          	bne	a4,a5,b2 <strcmp+0x1e>
    p++, q++;
  a8:	0505                	addi	a0,a0,1
  aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	fbe5                	bnez	a5,a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b2:	0005c503          	lbu	a0,0(a1)
}
  b6:	40a7853b          	subw	a0,a5,a0
  ba:	6422                	ld	s0,8(sp)
  bc:	0141                	addi	sp,sp,16
  be:	8082                	ret

00000000000000c0 <strlen>:

uint
strlen(const char *s)
{
  c0:	1141                	addi	sp,sp,-16
  c2:	e422                	sd	s0,8(sp)
  c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	cf91                	beqz	a5,e6 <strlen+0x26>
  cc:	0505                	addi	a0,a0,1
  ce:	87aa                	mv	a5,a0
  d0:	86be                	mv	a3,a5
  d2:	0785                	addi	a5,a5,1
  d4:	fff7c703          	lbu	a4,-1(a5)
  d8:	ff65                	bnez	a4,d0 <strlen+0x10>
  da:	40a6853b          	subw	a0,a3,a0
  de:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  e0:	6422                	ld	s0,8(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  for(n = 0; s[n]; n++)
  e6:	4501                	li	a0,0
  e8:	bfe5                	j	e0 <strlen+0x20>

00000000000000ea <memset>:

void*
memset(void *dst, int c, uint n)
{
  ea:	1141                	addi	sp,sp,-16
  ec:	e422                	sd	s0,8(sp)
  ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f0:	ca19                	beqz	a2,106 <memset+0x1c>
  f2:	87aa                	mv	a5,a0
  f4:	1602                	slli	a2,a2,0x20
  f6:	9201                	srli	a2,a2,0x20
  f8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 100:	0785                	addi	a5,a5,1
 102:	fee79de3          	bne	a5,a4,fc <memset+0x12>
  }
  return dst;
}
 106:	6422                	ld	s0,8(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret

000000000000010c <strchr>:

char*
strchr(const char *s, char c)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e422                	sd	s0,8(sp)
 110:	0800                	addi	s0,sp,16
  for(; *s; s++)
 112:	00054783          	lbu	a5,0(a0)
 116:	cb99                	beqz	a5,12c <strchr+0x20>
    if(*s == c)
 118:	00f58763          	beq	a1,a5,126 <strchr+0x1a>
  for(; *s; s++)
 11c:	0505                	addi	a0,a0,1
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbfd                	bnez	a5,118 <strchr+0xc>
      return (char*)s;
  return 0;
 124:	4501                	li	a0,0
}
 126:	6422                	ld	s0,8(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret
  return 0;
 12c:	4501                	li	a0,0
 12e:	bfe5                	j	126 <strchr+0x1a>

0000000000000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	711d                	addi	sp,sp,-96
 132:	ec86                	sd	ra,88(sp)
 134:	e8a2                	sd	s0,80(sp)
 136:	e4a6                	sd	s1,72(sp)
 138:	e0ca                	sd	s2,64(sp)
 13a:	fc4e                	sd	s3,56(sp)
 13c:	f852                	sd	s4,48(sp)
 13e:	f456                	sd	s5,40(sp)
 140:	f05a                	sd	s6,32(sp)
 142:	ec5e                	sd	s7,24(sp)
 144:	1080                	addi	s0,sp,96
 146:	8baa                	mv	s7,a0
 148:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14a:	892a                	mv	s2,a0
 14c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 14e:	4aa9                	li	s5,10
 150:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 152:	89a6                	mv	s3,s1
 154:	2485                	addiw	s1,s1,1
 156:	0344d663          	bge	s1,s4,182 <gets+0x52>
    cc = read(0, &c, 1);
 15a:	4605                	li	a2,1
 15c:	faf40593          	addi	a1,s0,-81
 160:	4501                	li	a0,0
 162:	186000ef          	jal	2e8 <read>
    if(cc < 1)
 166:	00a05e63          	blez	a0,182 <gets+0x52>
    buf[i++] = c;
 16a:	faf44783          	lbu	a5,-81(s0)
 16e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 172:	01578763          	beq	a5,s5,180 <gets+0x50>
 176:	0905                	addi	s2,s2,1
 178:	fd679de3          	bne	a5,s6,152 <gets+0x22>
    buf[i++] = c;
 17c:	89a6                	mv	s3,s1
 17e:	a011                	j	182 <gets+0x52>
 180:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 182:	99de                	add	s3,s3,s7
 184:	00098023          	sb	zero,0(s3)
  return buf;
}
 188:	855e                	mv	a0,s7
 18a:	60e6                	ld	ra,88(sp)
 18c:	6446                	ld	s0,80(sp)
 18e:	64a6                	ld	s1,72(sp)
 190:	6906                	ld	s2,64(sp)
 192:	79e2                	ld	s3,56(sp)
 194:	7a42                	ld	s4,48(sp)
 196:	7aa2                	ld	s5,40(sp)
 198:	7b02                	ld	s6,32(sp)
 19a:	6be2                	ld	s7,24(sp)
 19c:	6125                	addi	sp,sp,96
 19e:	8082                	ret

00000000000001a0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a0:	1101                	addi	sp,sp,-32
 1a2:	ec06                	sd	ra,24(sp)
 1a4:	e822                	sd	s0,16(sp)
 1a6:	e04a                	sd	s2,0(sp)
 1a8:	1000                	addi	s0,sp,32
 1aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ac:	4581                	li	a1,0
 1ae:	162000ef          	jal	310 <open>
  if(fd < 0)
 1b2:	02054263          	bltz	a0,1d6 <stat+0x36>
 1b6:	e426                	sd	s1,8(sp)
 1b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ba:	85ca                	mv	a1,s2
 1bc:	16c000ef          	jal	328 <fstat>
 1c0:	892a                	mv	s2,a0
  close(fd);
 1c2:	8526                	mv	a0,s1
 1c4:	134000ef          	jal	2f8 <close>
  return r;
 1c8:	64a2                	ld	s1,8(sp)
}
 1ca:	854a                	mv	a0,s2
 1cc:	60e2                	ld	ra,24(sp)
 1ce:	6442                	ld	s0,16(sp)
 1d0:	6902                	ld	s2,0(sp)
 1d2:	6105                	addi	sp,sp,32
 1d4:	8082                	ret
    return -1;
 1d6:	597d                	li	s2,-1
 1d8:	bfcd                	j	1ca <stat+0x2a>

00000000000001da <atoi>:

int
atoi(const char *s)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e422                	sd	s0,8(sp)
 1de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e0:	00054683          	lbu	a3,0(a0)
 1e4:	fd06879b          	addiw	a5,a3,-48
 1e8:	0ff7f793          	zext.b	a5,a5
 1ec:	4625                	li	a2,9
 1ee:	02f66863          	bltu	a2,a5,21e <atoi+0x44>
 1f2:	872a                	mv	a4,a0
  n = 0;
 1f4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f6:	0705                	addi	a4,a4,1
 1f8:	0025179b          	slliw	a5,a0,0x2
 1fc:	9fa9                	addw	a5,a5,a0
 1fe:	0017979b          	slliw	a5,a5,0x1
 202:	9fb5                	addw	a5,a5,a3
 204:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 208:	00074683          	lbu	a3,0(a4)
 20c:	fd06879b          	addiw	a5,a3,-48
 210:	0ff7f793          	zext.b	a5,a5
 214:	fef671e3          	bgeu	a2,a5,1f6 <atoi+0x1c>
  return n;
}
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret
  n = 0;
 21e:	4501                	li	a0,0
 220:	bfe5                	j	218 <atoi+0x3e>

0000000000000222 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 222:	1141                	addi	sp,sp,-16
 224:	e422                	sd	s0,8(sp)
 226:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 228:	02b57463          	bgeu	a0,a1,250 <memmove+0x2e>
    while(n-- > 0)
 22c:	00c05f63          	blez	a2,24a <memmove+0x28>
 230:	1602                	slli	a2,a2,0x20
 232:	9201                	srli	a2,a2,0x20
 234:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 238:	872a                	mv	a4,a0
      *dst++ = *src++;
 23a:	0585                	addi	a1,a1,1
 23c:	0705                	addi	a4,a4,1
 23e:	fff5c683          	lbu	a3,-1(a1)
 242:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 246:	fef71ae3          	bne	a4,a5,23a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 24a:	6422                	ld	s0,8(sp)
 24c:	0141                	addi	sp,sp,16
 24e:	8082                	ret
    dst += n;
 250:	00c50733          	add	a4,a0,a2
    src += n;
 254:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 256:	fec05ae3          	blez	a2,24a <memmove+0x28>
 25a:	fff6079b          	addiw	a5,a2,-1
 25e:	1782                	slli	a5,a5,0x20
 260:	9381                	srli	a5,a5,0x20
 262:	fff7c793          	not	a5,a5
 266:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 268:	15fd                	addi	a1,a1,-1
 26a:	177d                	addi	a4,a4,-1
 26c:	0005c683          	lbu	a3,0(a1)
 270:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 274:	fee79ae3          	bne	a5,a4,268 <memmove+0x46>
 278:	bfc9                	j	24a <memmove+0x28>

000000000000027a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 280:	ca05                	beqz	a2,2b0 <memcmp+0x36>
 282:	fff6069b          	addiw	a3,a2,-1
 286:	1682                	slli	a3,a3,0x20
 288:	9281                	srli	a3,a3,0x20
 28a:	0685                	addi	a3,a3,1
 28c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 28e:	00054783          	lbu	a5,0(a0)
 292:	0005c703          	lbu	a4,0(a1)
 296:	00e79863          	bne	a5,a4,2a6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 29a:	0505                	addi	a0,a0,1
    p2++;
 29c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 29e:	fed518e3          	bne	a0,a3,28e <memcmp+0x14>
  }
  return 0;
 2a2:	4501                	li	a0,0
 2a4:	a019                	j	2aa <memcmp+0x30>
      return *p1 - *p2;
 2a6:	40e7853b          	subw	a0,a5,a4
}
 2aa:	6422                	ld	s0,8(sp)
 2ac:	0141                	addi	sp,sp,16
 2ae:	8082                	ret
  return 0;
 2b0:	4501                	li	a0,0
 2b2:	bfe5                	j	2aa <memcmp+0x30>

00000000000002b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2bc:	f67ff0ef          	jal	222 <memmove>
}
 2c0:	60a2                	ld	ra,8(sp)
 2c2:	6402                	ld	s0,0(sp)
 2c4:	0141                	addi	sp,sp,16
 2c6:	8082                	ret

00000000000002c8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c8:	4885                	li	a7,1
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d0:	4889                	li	a7,2
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d8:	488d                	li	a7,3
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e0:	4891                	li	a7,4
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <read>:
.global read
read:
 li a7, SYS_read
 2e8:	4895                	li	a7,5
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <write>:
.global write
write:
 li a7, SYS_write
 2f0:	48c1                	li	a7,16
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <close>:
.global close
close:
 li a7, SYS_close
 2f8:	48d5                	li	a7,21
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <kill>:
.global kill
kill:
 li a7, SYS_kill
 300:	4899                	li	a7,6
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <exec>:
.global exec
exec:
 li a7, SYS_exec
 308:	489d                	li	a7,7
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <open>:
.global open
open:
 li a7, SYS_open
 310:	48bd                	li	a7,15
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 318:	48c5                	li	a7,17
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 320:	48c9                	li	a7,18
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 328:	48a1                	li	a7,8
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <link>:
.global link
link:
 li a7, SYS_link
 330:	48cd                	li	a7,19
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 338:	48d1                	li	a7,20
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 340:	48a5                	li	a7,9
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <dup>:
.global dup
dup:
 li a7, SYS_dup
 348:	48a9                	li	a7,10
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 350:	48ad                	li	a7,11
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 358:	48b1                	li	a7,12
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 360:	48b5                	li	a7,13
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 368:	48b9                	li	a7,14
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 370:	48d9                	li	a7,22
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 378:	1101                	addi	sp,sp,-32
 37a:	ec06                	sd	ra,24(sp)
 37c:	e822                	sd	s0,16(sp)
 37e:	1000                	addi	s0,sp,32
 380:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 384:	4605                	li	a2,1
 386:	fef40593          	addi	a1,s0,-17
 38a:	f67ff0ef          	jal	2f0 <write>
}
 38e:	60e2                	ld	ra,24(sp)
 390:	6442                	ld	s0,16(sp)
 392:	6105                	addi	sp,sp,32
 394:	8082                	ret

0000000000000396 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 396:	7139                	addi	sp,sp,-64
 398:	fc06                	sd	ra,56(sp)
 39a:	f822                	sd	s0,48(sp)
 39c:	f426                	sd	s1,40(sp)
 39e:	0080                	addi	s0,sp,64
 3a0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a2:	c299                	beqz	a3,3a8 <printint+0x12>
 3a4:	0805c963          	bltz	a1,436 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3a8:	2581                	sext.w	a1,a1
  neg = 0;
 3aa:	4881                	li	a7,0
 3ac:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 3b0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3b2:	2601                	sext.w	a2,a2
 3b4:	00000517          	auipc	a0,0x0
 3b8:	52c50513          	addi	a0,a0,1324 # 8e0 <digits>
 3bc:	883a                	mv	a6,a4
 3be:	2705                	addiw	a4,a4,1
 3c0:	02c5f7bb          	remuw	a5,a1,a2
 3c4:	1782                	slli	a5,a5,0x20
 3c6:	9381                	srli	a5,a5,0x20
 3c8:	97aa                	add	a5,a5,a0
 3ca:	0007c783          	lbu	a5,0(a5)
 3ce:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d2:	0005879b          	sext.w	a5,a1
 3d6:	02c5d5bb          	divuw	a1,a1,a2
 3da:	0685                	addi	a3,a3,1
 3dc:	fec7f0e3          	bgeu	a5,a2,3bc <printint+0x26>
  if(neg)
 3e0:	00088c63          	beqz	a7,3f8 <printint+0x62>
    buf[i++] = '-';
 3e4:	fd070793          	addi	a5,a4,-48
 3e8:	00878733          	add	a4,a5,s0
 3ec:	02d00793          	li	a5,45
 3f0:	fef70823          	sb	a5,-16(a4)
 3f4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 3f8:	02e05a63          	blez	a4,42c <printint+0x96>
 3fc:	f04a                	sd	s2,32(sp)
 3fe:	ec4e                	sd	s3,24(sp)
 400:	fc040793          	addi	a5,s0,-64
 404:	00e78933          	add	s2,a5,a4
 408:	fff78993          	addi	s3,a5,-1
 40c:	99ba                	add	s3,s3,a4
 40e:	377d                	addiw	a4,a4,-1
 410:	1702                	slli	a4,a4,0x20
 412:	9301                	srli	a4,a4,0x20
 414:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 418:	fff94583          	lbu	a1,-1(s2)
 41c:	8526                	mv	a0,s1
 41e:	f5bff0ef          	jal	378 <putc>
  while(--i >= 0)
 422:	197d                	addi	s2,s2,-1
 424:	ff391ae3          	bne	s2,s3,418 <printint+0x82>
 428:	7902                	ld	s2,32(sp)
 42a:	69e2                	ld	s3,24(sp)
}
 42c:	70e2                	ld	ra,56(sp)
 42e:	7442                	ld	s0,48(sp)
 430:	74a2                	ld	s1,40(sp)
 432:	6121                	addi	sp,sp,64
 434:	8082                	ret
    x = -xx;
 436:	40b005bb          	negw	a1,a1
    neg = 1;
 43a:	4885                	li	a7,1
    x = -xx;
 43c:	bf85                	j	3ac <printint+0x16>

000000000000043e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 43e:	711d                	addi	sp,sp,-96
 440:	ec86                	sd	ra,88(sp)
 442:	e8a2                	sd	s0,80(sp)
 444:	e0ca                	sd	s2,64(sp)
 446:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 448:	0005c903          	lbu	s2,0(a1)
 44c:	26090863          	beqz	s2,6bc <vprintf+0x27e>
 450:	e4a6                	sd	s1,72(sp)
 452:	fc4e                	sd	s3,56(sp)
 454:	f852                	sd	s4,48(sp)
 456:	f456                	sd	s5,40(sp)
 458:	f05a                	sd	s6,32(sp)
 45a:	ec5e                	sd	s7,24(sp)
 45c:	e862                	sd	s8,16(sp)
 45e:	e466                	sd	s9,8(sp)
 460:	8b2a                	mv	s6,a0
 462:	8a2e                	mv	s4,a1
 464:	8bb2                	mv	s7,a2
  state = 0;
 466:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 468:	4481                	li	s1,0
 46a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 46c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 470:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 474:	06c00c93          	li	s9,108
 478:	a005                	j	498 <vprintf+0x5a>
        putc(fd, c0);
 47a:	85ca                	mv	a1,s2
 47c:	855a                	mv	a0,s6
 47e:	efbff0ef          	jal	378 <putc>
 482:	a019                	j	488 <vprintf+0x4a>
    } else if(state == '%'){
 484:	03598263          	beq	s3,s5,4a8 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 488:	2485                	addiw	s1,s1,1
 48a:	8726                	mv	a4,s1
 48c:	009a07b3          	add	a5,s4,s1
 490:	0007c903          	lbu	s2,0(a5)
 494:	20090c63          	beqz	s2,6ac <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 498:	0009079b          	sext.w	a5,s2
    if(state == 0){
 49c:	fe0994e3          	bnez	s3,484 <vprintf+0x46>
      if(c0 == '%'){
 4a0:	fd579de3          	bne	a5,s5,47a <vprintf+0x3c>
        state = '%';
 4a4:	89be                	mv	s3,a5
 4a6:	b7cd                	j	488 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 4a8:	00ea06b3          	add	a3,s4,a4
 4ac:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 4b0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 4b2:	c681                	beqz	a3,4ba <vprintf+0x7c>
 4b4:	9752                	add	a4,a4,s4
 4b6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 4ba:	03878f63          	beq	a5,s8,4f8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 4be:	05978963          	beq	a5,s9,510 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 4c2:	07500713          	li	a4,117
 4c6:	0ee78363          	beq	a5,a4,5ac <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4ca:	07800713          	li	a4,120
 4ce:	12e78563          	beq	a5,a4,5f8 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4d2:	07000713          	li	a4,112
 4d6:	14e78a63          	beq	a5,a4,62a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4da:	07300713          	li	a4,115
 4de:	18e78a63          	beq	a5,a4,672 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4e2:	02500713          	li	a4,37
 4e6:	04e79563          	bne	a5,a4,530 <vprintf+0xf2>
        putc(fd, '%');
 4ea:	02500593          	li	a1,37
 4ee:	855a                	mv	a0,s6
 4f0:	e89ff0ef          	jal	378 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4f4:	4981                	li	s3,0
 4f6:	bf49                	j	488 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4f8:	008b8913          	addi	s2,s7,8
 4fc:	4685                	li	a3,1
 4fe:	4629                	li	a2,10
 500:	000ba583          	lw	a1,0(s7)
 504:	855a                	mv	a0,s6
 506:	e91ff0ef          	jal	396 <printint>
 50a:	8bca                	mv	s7,s2
      state = 0;
 50c:	4981                	li	s3,0
 50e:	bfad                	j	488 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 510:	06400793          	li	a5,100
 514:	02f68963          	beq	a3,a5,546 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 518:	06c00793          	li	a5,108
 51c:	04f68263          	beq	a3,a5,560 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 520:	07500793          	li	a5,117
 524:	0af68063          	beq	a3,a5,5c4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 528:	07800793          	li	a5,120
 52c:	0ef68263          	beq	a3,a5,610 <vprintf+0x1d2>
        putc(fd, '%');
 530:	02500593          	li	a1,37
 534:	855a                	mv	a0,s6
 536:	e43ff0ef          	jal	378 <putc>
        putc(fd, c0);
 53a:	85ca                	mv	a1,s2
 53c:	855a                	mv	a0,s6
 53e:	e3bff0ef          	jal	378 <putc>
      state = 0;
 542:	4981                	li	s3,0
 544:	b791                	j	488 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 546:	008b8913          	addi	s2,s7,8
 54a:	4685                	li	a3,1
 54c:	4629                	li	a2,10
 54e:	000ba583          	lw	a1,0(s7)
 552:	855a                	mv	a0,s6
 554:	e43ff0ef          	jal	396 <printint>
        i += 1;
 558:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 55a:	8bca                	mv	s7,s2
      state = 0;
 55c:	4981                	li	s3,0
        i += 1;
 55e:	b72d                	j	488 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 560:	06400793          	li	a5,100
 564:	02f60763          	beq	a2,a5,592 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 568:	07500793          	li	a5,117
 56c:	06f60963          	beq	a2,a5,5de <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 570:	07800793          	li	a5,120
 574:	faf61ee3          	bne	a2,a5,530 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 578:	008b8913          	addi	s2,s7,8
 57c:	4681                	li	a3,0
 57e:	4641                	li	a2,16
 580:	000ba583          	lw	a1,0(s7)
 584:	855a                	mv	a0,s6
 586:	e11ff0ef          	jal	396 <printint>
        i += 2;
 58a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 58c:	8bca                	mv	s7,s2
      state = 0;
 58e:	4981                	li	s3,0
        i += 2;
 590:	bde5                	j	488 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 592:	008b8913          	addi	s2,s7,8
 596:	4685                	li	a3,1
 598:	4629                	li	a2,10
 59a:	000ba583          	lw	a1,0(s7)
 59e:	855a                	mv	a0,s6
 5a0:	df7ff0ef          	jal	396 <printint>
        i += 2;
 5a4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a6:	8bca                	mv	s7,s2
      state = 0;
 5a8:	4981                	li	s3,0
        i += 2;
 5aa:	bdf9                	j	488 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 5ac:	008b8913          	addi	s2,s7,8
 5b0:	4681                	li	a3,0
 5b2:	4629                	li	a2,10
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	855a                	mv	a0,s6
 5ba:	dddff0ef          	jal	396 <printint>
 5be:	8bca                	mv	s7,s2
      state = 0;
 5c0:	4981                	li	s3,0
 5c2:	b5d9                	j	488 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c4:	008b8913          	addi	s2,s7,8
 5c8:	4681                	li	a3,0
 5ca:	4629                	li	a2,10
 5cc:	000ba583          	lw	a1,0(s7)
 5d0:	855a                	mv	a0,s6
 5d2:	dc5ff0ef          	jal	396 <printint>
        i += 1;
 5d6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d8:	8bca                	mv	s7,s2
      state = 0;
 5da:	4981                	li	s3,0
        i += 1;
 5dc:	b575                	j	488 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5de:	008b8913          	addi	s2,s7,8
 5e2:	4681                	li	a3,0
 5e4:	4629                	li	a2,10
 5e6:	000ba583          	lw	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	dabff0ef          	jal	396 <printint>
        i += 2;
 5f0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
        i += 2;
 5f6:	bd49                	j	488 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5f8:	008b8913          	addi	s2,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4641                	li	a2,16
 600:	000ba583          	lw	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	d91ff0ef          	jal	396 <printint>
 60a:	8bca                	mv	s7,s2
      state = 0;
 60c:	4981                	li	s3,0
 60e:	bdad                	j	488 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 610:	008b8913          	addi	s2,s7,8
 614:	4681                	li	a3,0
 616:	4641                	li	a2,16
 618:	000ba583          	lw	a1,0(s7)
 61c:	855a                	mv	a0,s6
 61e:	d79ff0ef          	jal	396 <printint>
        i += 1;
 622:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 624:	8bca                	mv	s7,s2
      state = 0;
 626:	4981                	li	s3,0
        i += 1;
 628:	b585                	j	488 <vprintf+0x4a>
 62a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 62c:	008b8d13          	addi	s10,s7,8
 630:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 634:	03000593          	li	a1,48
 638:	855a                	mv	a0,s6
 63a:	d3fff0ef          	jal	378 <putc>
  putc(fd, 'x');
 63e:	07800593          	li	a1,120
 642:	855a                	mv	a0,s6
 644:	d35ff0ef          	jal	378 <putc>
 648:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 64a:	00000b97          	auipc	s7,0x0
 64e:	296b8b93          	addi	s7,s7,662 # 8e0 <digits>
 652:	03c9d793          	srli	a5,s3,0x3c
 656:	97de                	add	a5,a5,s7
 658:	0007c583          	lbu	a1,0(a5)
 65c:	855a                	mv	a0,s6
 65e:	d1bff0ef          	jal	378 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 662:	0992                	slli	s3,s3,0x4
 664:	397d                	addiw	s2,s2,-1
 666:	fe0916e3          	bnez	s2,652 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 66a:	8bea                	mv	s7,s10
      state = 0;
 66c:	4981                	li	s3,0
 66e:	6d02                	ld	s10,0(sp)
 670:	bd21                	j	488 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 672:	008b8993          	addi	s3,s7,8
 676:	000bb903          	ld	s2,0(s7)
 67a:	00090f63          	beqz	s2,698 <vprintf+0x25a>
        for(; *s; s++)
 67e:	00094583          	lbu	a1,0(s2)
 682:	c195                	beqz	a1,6a6 <vprintf+0x268>
          putc(fd, *s);
 684:	855a                	mv	a0,s6
 686:	cf3ff0ef          	jal	378 <putc>
        for(; *s; s++)
 68a:	0905                	addi	s2,s2,1
 68c:	00094583          	lbu	a1,0(s2)
 690:	f9f5                	bnez	a1,684 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 692:	8bce                	mv	s7,s3
      state = 0;
 694:	4981                	li	s3,0
 696:	bbcd                	j	488 <vprintf+0x4a>
          s = "(null)";
 698:	00000917          	auipc	s2,0x0
 69c:	24090913          	addi	s2,s2,576 # 8d8 <malloc+0x134>
        for(; *s; s++)
 6a0:	02800593          	li	a1,40
 6a4:	b7c5                	j	684 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 6a6:	8bce                	mv	s7,s3
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	bbf9                	j	488 <vprintf+0x4a>
 6ac:	64a6                	ld	s1,72(sp)
 6ae:	79e2                	ld	s3,56(sp)
 6b0:	7a42                	ld	s4,48(sp)
 6b2:	7aa2                	ld	s5,40(sp)
 6b4:	7b02                	ld	s6,32(sp)
 6b6:	6be2                	ld	s7,24(sp)
 6b8:	6c42                	ld	s8,16(sp)
 6ba:	6ca2                	ld	s9,8(sp)
    }
  }
}
 6bc:	60e6                	ld	ra,88(sp)
 6be:	6446                	ld	s0,80(sp)
 6c0:	6906                	ld	s2,64(sp)
 6c2:	6125                	addi	sp,sp,96
 6c4:	8082                	ret

00000000000006c6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6c6:	715d                	addi	sp,sp,-80
 6c8:	ec06                	sd	ra,24(sp)
 6ca:	e822                	sd	s0,16(sp)
 6cc:	1000                	addi	s0,sp,32
 6ce:	e010                	sd	a2,0(s0)
 6d0:	e414                	sd	a3,8(s0)
 6d2:	e818                	sd	a4,16(s0)
 6d4:	ec1c                	sd	a5,24(s0)
 6d6:	03043023          	sd	a6,32(s0)
 6da:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6de:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6e2:	8622                	mv	a2,s0
 6e4:	d5bff0ef          	jal	43e <vprintf>
}
 6e8:	60e2                	ld	ra,24(sp)
 6ea:	6442                	ld	s0,16(sp)
 6ec:	6161                	addi	sp,sp,80
 6ee:	8082                	ret

00000000000006f0 <printf>:

void
printf(const char *fmt, ...)
{
 6f0:	711d                	addi	sp,sp,-96
 6f2:	ec06                	sd	ra,24(sp)
 6f4:	e822                	sd	s0,16(sp)
 6f6:	1000                	addi	s0,sp,32
 6f8:	e40c                	sd	a1,8(s0)
 6fa:	e810                	sd	a2,16(s0)
 6fc:	ec14                	sd	a3,24(s0)
 6fe:	f018                	sd	a4,32(s0)
 700:	f41c                	sd	a5,40(s0)
 702:	03043823          	sd	a6,48(s0)
 706:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 70a:	00840613          	addi	a2,s0,8
 70e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 712:	85aa                	mv	a1,a0
 714:	4505                	li	a0,1
 716:	d29ff0ef          	jal	43e <vprintf>
}
 71a:	60e2                	ld	ra,24(sp)
 71c:	6442                	ld	s0,16(sp)
 71e:	6125                	addi	sp,sp,96
 720:	8082                	ret

0000000000000722 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 722:	1141                	addi	sp,sp,-16
 724:	e422                	sd	s0,8(sp)
 726:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 728:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 72c:	00001797          	auipc	a5,0x1
 730:	8d47b783          	ld	a5,-1836(a5) # 1000 <freep>
 734:	a02d                	j	75e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 736:	4618                	lw	a4,8(a2)
 738:	9f2d                	addw	a4,a4,a1
 73a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 73e:	6398                	ld	a4,0(a5)
 740:	6310                	ld	a2,0(a4)
 742:	a83d                	j	780 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 744:	ff852703          	lw	a4,-8(a0)
 748:	9f31                	addw	a4,a4,a2
 74a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 74c:	ff053683          	ld	a3,-16(a0)
 750:	a091                	j	794 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 752:	6398                	ld	a4,0(a5)
 754:	00e7e463          	bltu	a5,a4,75c <free+0x3a>
 758:	00e6ea63          	bltu	a3,a4,76c <free+0x4a>
{
 75c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	fed7fae3          	bgeu	a5,a3,752 <free+0x30>
 762:	6398                	ld	a4,0(a5)
 764:	00e6e463          	bltu	a3,a4,76c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 768:	fee7eae3          	bltu	a5,a4,75c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 76c:	ff852583          	lw	a1,-8(a0)
 770:	6390                	ld	a2,0(a5)
 772:	02059813          	slli	a6,a1,0x20
 776:	01c85713          	srli	a4,a6,0x1c
 77a:	9736                	add	a4,a4,a3
 77c:	fae60de3          	beq	a2,a4,736 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 780:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 784:	4790                	lw	a2,8(a5)
 786:	02061593          	slli	a1,a2,0x20
 78a:	01c5d713          	srli	a4,a1,0x1c
 78e:	973e                	add	a4,a4,a5
 790:	fae68ae3          	beq	a3,a4,744 <free+0x22>
    p->s.ptr = bp->s.ptr;
 794:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 796:	00001717          	auipc	a4,0x1
 79a:	86f73523          	sd	a5,-1942(a4) # 1000 <freep>
}
 79e:	6422                	ld	s0,8(sp)
 7a0:	0141                	addi	sp,sp,16
 7a2:	8082                	ret

00000000000007a4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7a4:	7139                	addi	sp,sp,-64
 7a6:	fc06                	sd	ra,56(sp)
 7a8:	f822                	sd	s0,48(sp)
 7aa:	f426                	sd	s1,40(sp)
 7ac:	ec4e                	sd	s3,24(sp)
 7ae:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7b0:	02051493          	slli	s1,a0,0x20
 7b4:	9081                	srli	s1,s1,0x20
 7b6:	04bd                	addi	s1,s1,15
 7b8:	8091                	srli	s1,s1,0x4
 7ba:	0014899b          	addiw	s3,s1,1
 7be:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 7c0:	00001517          	auipc	a0,0x1
 7c4:	84053503          	ld	a0,-1984(a0) # 1000 <freep>
 7c8:	c915                	beqz	a0,7fc <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7cc:	4798                	lw	a4,8(a5)
 7ce:	08977a63          	bgeu	a4,s1,862 <malloc+0xbe>
 7d2:	f04a                	sd	s2,32(sp)
 7d4:	e852                	sd	s4,16(sp)
 7d6:	e456                	sd	s5,8(sp)
 7d8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7da:	8a4e                	mv	s4,s3
 7dc:	0009871b          	sext.w	a4,s3
 7e0:	6685                	lui	a3,0x1
 7e2:	00d77363          	bgeu	a4,a3,7e8 <malloc+0x44>
 7e6:	6a05                	lui	s4,0x1
 7e8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7ec:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7f0:	00001917          	auipc	s2,0x1
 7f4:	81090913          	addi	s2,s2,-2032 # 1000 <freep>
  if(p == (char*)-1)
 7f8:	5afd                	li	s5,-1
 7fa:	a081                	j	83a <malloc+0x96>
 7fc:	f04a                	sd	s2,32(sp)
 7fe:	e852                	sd	s4,16(sp)
 800:	e456                	sd	s5,8(sp)
 802:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 804:	00001797          	auipc	a5,0x1
 808:	80c78793          	addi	a5,a5,-2036 # 1010 <base>
 80c:	00000717          	auipc	a4,0x0
 810:	7ef73a23          	sd	a5,2036(a4) # 1000 <freep>
 814:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 816:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 81a:	b7c1                	j	7da <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 81c:	6398                	ld	a4,0(a5)
 81e:	e118                	sd	a4,0(a0)
 820:	a8a9                	j	87a <malloc+0xd6>
  hp->s.size = nu;
 822:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 826:	0541                	addi	a0,a0,16
 828:	efbff0ef          	jal	722 <free>
  return freep;
 82c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 830:	c12d                	beqz	a0,892 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 832:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 834:	4798                	lw	a4,8(a5)
 836:	02977263          	bgeu	a4,s1,85a <malloc+0xb6>
    if(p == freep)
 83a:	00093703          	ld	a4,0(s2)
 83e:	853e                	mv	a0,a5
 840:	fef719e3          	bne	a4,a5,832 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 844:	8552                	mv	a0,s4
 846:	b13ff0ef          	jal	358 <sbrk>
  if(p == (char*)-1)
 84a:	fd551ce3          	bne	a0,s5,822 <malloc+0x7e>
        return 0;
 84e:	4501                	li	a0,0
 850:	7902                	ld	s2,32(sp)
 852:	6a42                	ld	s4,16(sp)
 854:	6aa2                	ld	s5,8(sp)
 856:	6b02                	ld	s6,0(sp)
 858:	a03d                	j	886 <malloc+0xe2>
 85a:	7902                	ld	s2,32(sp)
 85c:	6a42                	ld	s4,16(sp)
 85e:	6aa2                	ld	s5,8(sp)
 860:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 862:	fae48de3          	beq	s1,a4,81c <malloc+0x78>
        p->s.size -= nunits;
 866:	4137073b          	subw	a4,a4,s3
 86a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 86c:	02071693          	slli	a3,a4,0x20
 870:	01c6d713          	srli	a4,a3,0x1c
 874:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 876:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 87a:	00000717          	auipc	a4,0x0
 87e:	78a73323          	sd	a0,1926(a4) # 1000 <freep>
      return (void*)(p + 1);
 882:	01078513          	addi	a0,a5,16
  }
}
 886:	70e2                	ld	ra,56(sp)
 888:	7442                	ld	s0,48(sp)
 88a:	74a2                	ld	s1,40(sp)
 88c:	69e2                	ld	s3,24(sp)
 88e:	6121                	addi	sp,sp,64
 890:	8082                	ret
 892:	7902                	ld	s2,32(sp)
 894:	6a42                	ld	s4,16(sp)
 896:	6aa2                	ld	s5,8(sp)
 898:	6b02                	ld	s6,0(sp)
 89a:	b7f5                	j	886 <malloc+0xe2>
