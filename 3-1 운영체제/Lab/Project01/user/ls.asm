
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	2b6000ef          	jal	2c2 <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	28e000ef          	jal	2c2 <strlen>
  38:	2501                	sext.w	a0,a0
  3a:	47b5                	li	a5,13
  3c:	00a7f863          	bgeu	a5,a0,4c <fmtname+0x4c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  40:	8526                	mv	a0,s1
  42:	70a2                	ld	ra,40(sp)
  44:	7402                	ld	s0,32(sp)
  46:	64e2                	ld	s1,24(sp)
  48:	6145                	addi	sp,sp,48
  4a:	8082                	ret
  4c:	e84a                	sd	s2,16(sp)
  4e:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  50:	8526                	mv	a0,s1
  52:	270000ef          	jal	2c2 <strlen>
  56:	00001997          	auipc	s3,0x1
  5a:	fba98993          	addi	s3,s3,-70 # 1010 <buf.0>
  5e:	0005061b          	sext.w	a2,a0
  62:	85a6                	mv	a1,s1
  64:	854e                	mv	a0,s3
  66:	3be000ef          	jal	424 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6a:	8526                	mv	a0,s1
  6c:	256000ef          	jal	2c2 <strlen>
  70:	0005091b          	sext.w	s2,a0
  74:	8526                	mv	a0,s1
  76:	24c000ef          	jal	2c2 <strlen>
  7a:	1902                	slli	s2,s2,0x20
  7c:	02095913          	srli	s2,s2,0x20
  80:	4639                	li	a2,14
  82:	9e09                	subw	a2,a2,a0
  84:	02000593          	li	a1,32
  88:	01298533          	add	a0,s3,s2
  8c:	260000ef          	jal	2ec <memset>
  return buf;
  90:	84ce                	mv	s1,s3
  92:	6942                	ld	s2,16(sp)
  94:	69a2                	ld	s3,8(sp)
  96:	b76d                	j	40 <fmtname+0x40>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	d9010113          	addi	sp,sp,-624
  9c:	26113423          	sd	ra,616(sp)
  a0:	26813023          	sd	s0,608(sp)
  a4:	25213823          	sd	s2,592(sp)
  a8:	1c80                	addi	s0,sp,624
  aa:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
  ac:	4581                	li	a1,0
  ae:	464000ef          	jal	512 <open>
  b2:	06054363          	bltz	a0,118 <ls+0x80>
  b6:	24913c23          	sd	s1,600(sp)
  ba:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  bc:	d9840593          	addi	a1,s0,-616
  c0:	46a000ef          	jal	52a <fstat>
  c4:	06054363          	bltz	a0,12a <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  c8:	da041783          	lh	a5,-608(s0)
  cc:	4705                	li	a4,1
  ce:	06e78c63          	beq	a5,a4,146 <ls+0xae>
  d2:	37f9                	addiw	a5,a5,-2
  d4:	17c2                	slli	a5,a5,0x30
  d6:	93c1                	srli	a5,a5,0x30
  d8:	02f76263          	bltu	a4,a5,fc <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
  dc:	854a                	mv	a0,s2
  de:	f23ff0ef          	jal	0 <fmtname>
  e2:	85aa                	mv	a1,a0
  e4:	da842703          	lw	a4,-600(s0)
  e8:	d9c42683          	lw	a3,-612(s0)
  ec:	da041603          	lh	a2,-608(s0)
  f0:	00001517          	auipc	a0,0x1
  f4:	a1050513          	addi	a0,a0,-1520 # b00 <malloc+0x12a>
  f8:	02b000ef          	jal	922 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
  fc:	8526                	mv	a0,s1
  fe:	3fc000ef          	jal	4fa <close>
 102:	25813483          	ld	s1,600(sp)
}
 106:	26813083          	ld	ra,616(sp)
 10a:	26013403          	ld	s0,608(sp)
 10e:	25013903          	ld	s2,592(sp)
 112:	27010113          	addi	sp,sp,624
 116:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 118:	864a                	mv	a2,s2
 11a:	00001597          	auipc	a1,0x1
 11e:	9b658593          	addi	a1,a1,-1610 # ad0 <malloc+0xfa>
 122:	4509                	li	a0,2
 124:	7d4000ef          	jal	8f8 <fprintf>
    return;
 128:	bff9                	j	106 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 12a:	864a                	mv	a2,s2
 12c:	00001597          	auipc	a1,0x1
 130:	9bc58593          	addi	a1,a1,-1604 # ae8 <malloc+0x112>
 134:	4509                	li	a0,2
 136:	7c2000ef          	jal	8f8 <fprintf>
    close(fd);
 13a:	8526                	mv	a0,s1
 13c:	3be000ef          	jal	4fa <close>
    return;
 140:	25813483          	ld	s1,600(sp)
 144:	b7c9                	j	106 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 146:	854a                	mv	a0,s2
 148:	17a000ef          	jal	2c2 <strlen>
 14c:	2541                	addiw	a0,a0,16
 14e:	20000793          	li	a5,512
 152:	00a7f963          	bgeu	a5,a0,164 <ls+0xcc>
      printf("ls: path too long\n");
 156:	00001517          	auipc	a0,0x1
 15a:	9ba50513          	addi	a0,a0,-1606 # b10 <malloc+0x13a>
 15e:	7c4000ef          	jal	922 <printf>
      break;
 162:	bf69                	j	fc <ls+0x64>
 164:	25313423          	sd	s3,584(sp)
 168:	25413023          	sd	s4,576(sp)
 16c:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
 170:	85ca                	mv	a1,s2
 172:	dc040513          	addi	a0,s0,-576
 176:	104000ef          	jal	27a <strcpy>
    p = buf+strlen(buf);
 17a:	dc040513          	addi	a0,s0,-576
 17e:	144000ef          	jal	2c2 <strlen>
 182:	1502                	slli	a0,a0,0x20
 184:	9101                	srli	a0,a0,0x20
 186:	dc040793          	addi	a5,s0,-576
 18a:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 18e:	00190993          	addi	s3,s2,1
 192:	02f00793          	li	a5,47
 196:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 19a:	00001a17          	auipc	s4,0x1
 19e:	966a0a13          	addi	s4,s4,-1690 # b00 <malloc+0x12a>
        printf("ls: cannot stat %s\n", buf);
 1a2:	00001a97          	auipc	s5,0x1
 1a6:	946a8a93          	addi	s5,s5,-1722 # ae8 <malloc+0x112>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1aa:	a031                	j	1b6 <ls+0x11e>
        printf("ls: cannot stat %s\n", buf);
 1ac:	dc040593          	addi	a1,s0,-576
 1b0:	8556                	mv	a0,s5
 1b2:	770000ef          	jal	922 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1b6:	4641                	li	a2,16
 1b8:	db040593          	addi	a1,s0,-592
 1bc:	8526                	mv	a0,s1
 1be:	32c000ef          	jal	4ea <read>
 1c2:	47c1                	li	a5,16
 1c4:	04f51463          	bne	a0,a5,20c <ls+0x174>
      if(de.inum == 0)
 1c8:	db045783          	lhu	a5,-592(s0)
 1cc:	d7ed                	beqz	a5,1b6 <ls+0x11e>
      memmove(p, de.name, DIRSIZ);
 1ce:	4639                	li	a2,14
 1d0:	db240593          	addi	a1,s0,-590
 1d4:	854e                	mv	a0,s3
 1d6:	24e000ef          	jal	424 <memmove>
      p[DIRSIZ] = 0;
 1da:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 1de:	d9840593          	addi	a1,s0,-616
 1e2:	dc040513          	addi	a0,s0,-576
 1e6:	1bc000ef          	jal	3a2 <stat>
 1ea:	fc0541e3          	bltz	a0,1ac <ls+0x114>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
 1ee:	dc040513          	addi	a0,s0,-576
 1f2:	e0fff0ef          	jal	0 <fmtname>
 1f6:	85aa                	mv	a1,a0
 1f8:	da842703          	lw	a4,-600(s0)
 1fc:	d9c42683          	lw	a3,-612(s0)
 200:	da041603          	lh	a2,-608(s0)
 204:	8552                	mv	a0,s4
 206:	71c000ef          	jal	922 <printf>
 20a:	b775                	j	1b6 <ls+0x11e>
 20c:	24813983          	ld	s3,584(sp)
 210:	24013a03          	ld	s4,576(sp)
 214:	23813a83          	ld	s5,568(sp)
 218:	b5d5                	j	fc <ls+0x64>

000000000000021a <main>:

int
main(int argc, char *argv[])
{
 21a:	1101                	addi	sp,sp,-32
 21c:	ec06                	sd	ra,24(sp)
 21e:	e822                	sd	s0,16(sp)
 220:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
 222:	4785                	li	a5,1
 224:	02a7d763          	bge	a5,a0,252 <main+0x38>
 228:	e426                	sd	s1,8(sp)
 22a:	e04a                	sd	s2,0(sp)
 22c:	00858493          	addi	s1,a1,8
 230:	ffe5091b          	addiw	s2,a0,-2
 234:	02091793          	slli	a5,s2,0x20
 238:	01d7d913          	srli	s2,a5,0x1d
 23c:	05c1                	addi	a1,a1,16
 23e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 240:	6088                	ld	a0,0(s1)
 242:	e57ff0ef          	jal	98 <ls>
  for(i=1; i<argc; i++)
 246:	04a1                	addi	s1,s1,8
 248:	ff249ce3          	bne	s1,s2,240 <main+0x26>
  exit(0);
 24c:	4501                	li	a0,0
 24e:	284000ef          	jal	4d2 <exit>
 252:	e426                	sd	s1,8(sp)
 254:	e04a                	sd	s2,0(sp)
    ls(".");
 256:	00001517          	auipc	a0,0x1
 25a:	8d250513          	addi	a0,a0,-1838 # b28 <malloc+0x152>
 25e:	e3bff0ef          	jal	98 <ls>
    exit(0);
 262:	4501                	li	a0,0
 264:	26e000ef          	jal	4d2 <exit>

0000000000000268 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  extern int main();
  main();
 270:	fabff0ef          	jal	21a <main>
  exit(0);
 274:	4501                	li	a0,0
 276:	25c000ef          	jal	4d2 <exit>

000000000000027a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 27a:	1141                	addi	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 280:	87aa                	mv	a5,a0
 282:	0585                	addi	a1,a1,1
 284:	0785                	addi	a5,a5,1
 286:	fff5c703          	lbu	a4,-1(a1)
 28a:	fee78fa3          	sb	a4,-1(a5)
 28e:	fb75                	bnez	a4,282 <strcpy+0x8>
    ;
  return os;
}
 290:	6422                	ld	s0,8(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret

0000000000000296 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 296:	1141                	addi	sp,sp,-16
 298:	e422                	sd	s0,8(sp)
 29a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 29c:	00054783          	lbu	a5,0(a0)
 2a0:	cb91                	beqz	a5,2b4 <strcmp+0x1e>
 2a2:	0005c703          	lbu	a4,0(a1)
 2a6:	00f71763          	bne	a4,a5,2b4 <strcmp+0x1e>
    p++, q++;
 2aa:	0505                	addi	a0,a0,1
 2ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2ae:	00054783          	lbu	a5,0(a0)
 2b2:	fbe5                	bnez	a5,2a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2b4:	0005c503          	lbu	a0,0(a1)
}
 2b8:	40a7853b          	subw	a0,a5,a0
 2bc:	6422                	ld	s0,8(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <strlen>:

uint
strlen(const char *s)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e422                	sd	s0,8(sp)
 2c6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	cf91                	beqz	a5,2e8 <strlen+0x26>
 2ce:	0505                	addi	a0,a0,1
 2d0:	87aa                	mv	a5,a0
 2d2:	86be                	mv	a3,a5
 2d4:	0785                	addi	a5,a5,1
 2d6:	fff7c703          	lbu	a4,-1(a5)
 2da:	ff65                	bnez	a4,2d2 <strlen+0x10>
 2dc:	40a6853b          	subw	a0,a3,a0
 2e0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 2e2:	6422                	ld	s0,8(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret
  for(n = 0; s[n]; n++)
 2e8:	4501                	li	a0,0
 2ea:	bfe5                	j	2e2 <strlen+0x20>

00000000000002ec <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e422                	sd	s0,8(sp)
 2f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2f2:	ca19                	beqz	a2,308 <memset+0x1c>
 2f4:	87aa                	mv	a5,a0
 2f6:	1602                	slli	a2,a2,0x20
 2f8:	9201                	srli	a2,a2,0x20
 2fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 302:	0785                	addi	a5,a5,1
 304:	fee79de3          	bne	a5,a4,2fe <memset+0x12>
  }
  return dst;
}
 308:	6422                	ld	s0,8(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <strchr>:

char*
strchr(const char *s, char c)
{
 30e:	1141                	addi	sp,sp,-16
 310:	e422                	sd	s0,8(sp)
 312:	0800                	addi	s0,sp,16
  for(; *s; s++)
 314:	00054783          	lbu	a5,0(a0)
 318:	cb99                	beqz	a5,32e <strchr+0x20>
    if(*s == c)
 31a:	00f58763          	beq	a1,a5,328 <strchr+0x1a>
  for(; *s; s++)
 31e:	0505                	addi	a0,a0,1
 320:	00054783          	lbu	a5,0(a0)
 324:	fbfd                	bnez	a5,31a <strchr+0xc>
      return (char*)s;
  return 0;
 326:	4501                	li	a0,0
}
 328:	6422                	ld	s0,8(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret
  return 0;
 32e:	4501                	li	a0,0
 330:	bfe5                	j	328 <strchr+0x1a>

0000000000000332 <gets>:

char*
gets(char *buf, int max)
{
 332:	711d                	addi	sp,sp,-96
 334:	ec86                	sd	ra,88(sp)
 336:	e8a2                	sd	s0,80(sp)
 338:	e4a6                	sd	s1,72(sp)
 33a:	e0ca                	sd	s2,64(sp)
 33c:	fc4e                	sd	s3,56(sp)
 33e:	f852                	sd	s4,48(sp)
 340:	f456                	sd	s5,40(sp)
 342:	f05a                	sd	s6,32(sp)
 344:	ec5e                	sd	s7,24(sp)
 346:	1080                	addi	s0,sp,96
 348:	8baa                	mv	s7,a0
 34a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 34c:	892a                	mv	s2,a0
 34e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 350:	4aa9                	li	s5,10
 352:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 354:	89a6                	mv	s3,s1
 356:	2485                	addiw	s1,s1,1
 358:	0344d663          	bge	s1,s4,384 <gets+0x52>
    cc = read(0, &c, 1);
 35c:	4605                	li	a2,1
 35e:	faf40593          	addi	a1,s0,-81
 362:	4501                	li	a0,0
 364:	186000ef          	jal	4ea <read>
    if(cc < 1)
 368:	00a05e63          	blez	a0,384 <gets+0x52>
    buf[i++] = c;
 36c:	faf44783          	lbu	a5,-81(s0)
 370:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 374:	01578763          	beq	a5,s5,382 <gets+0x50>
 378:	0905                	addi	s2,s2,1
 37a:	fd679de3          	bne	a5,s6,354 <gets+0x22>
    buf[i++] = c;
 37e:	89a6                	mv	s3,s1
 380:	a011                	j	384 <gets+0x52>
 382:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 384:	99de                	add	s3,s3,s7
 386:	00098023          	sb	zero,0(s3)
  return buf;
}
 38a:	855e                	mv	a0,s7
 38c:	60e6                	ld	ra,88(sp)
 38e:	6446                	ld	s0,80(sp)
 390:	64a6                	ld	s1,72(sp)
 392:	6906                	ld	s2,64(sp)
 394:	79e2                	ld	s3,56(sp)
 396:	7a42                	ld	s4,48(sp)
 398:	7aa2                	ld	s5,40(sp)
 39a:	7b02                	ld	s6,32(sp)
 39c:	6be2                	ld	s7,24(sp)
 39e:	6125                	addi	sp,sp,96
 3a0:	8082                	ret

00000000000003a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3a2:	1101                	addi	sp,sp,-32
 3a4:	ec06                	sd	ra,24(sp)
 3a6:	e822                	sd	s0,16(sp)
 3a8:	e04a                	sd	s2,0(sp)
 3aa:	1000                	addi	s0,sp,32
 3ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ae:	4581                	li	a1,0
 3b0:	162000ef          	jal	512 <open>
  if(fd < 0)
 3b4:	02054263          	bltz	a0,3d8 <stat+0x36>
 3b8:	e426                	sd	s1,8(sp)
 3ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3bc:	85ca                	mv	a1,s2
 3be:	16c000ef          	jal	52a <fstat>
 3c2:	892a                	mv	s2,a0
  close(fd);
 3c4:	8526                	mv	a0,s1
 3c6:	134000ef          	jal	4fa <close>
  return r;
 3ca:	64a2                	ld	s1,8(sp)
}
 3cc:	854a                	mv	a0,s2
 3ce:	60e2                	ld	ra,24(sp)
 3d0:	6442                	ld	s0,16(sp)
 3d2:	6902                	ld	s2,0(sp)
 3d4:	6105                	addi	sp,sp,32
 3d6:	8082                	ret
    return -1;
 3d8:	597d                	li	s2,-1
 3da:	bfcd                	j	3cc <stat+0x2a>

00000000000003dc <atoi>:

int
atoi(const char *s)
{
 3dc:	1141                	addi	sp,sp,-16
 3de:	e422                	sd	s0,8(sp)
 3e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3e2:	00054683          	lbu	a3,0(a0)
 3e6:	fd06879b          	addiw	a5,a3,-48
 3ea:	0ff7f793          	zext.b	a5,a5
 3ee:	4625                	li	a2,9
 3f0:	02f66863          	bltu	a2,a5,420 <atoi+0x44>
 3f4:	872a                	mv	a4,a0
  n = 0;
 3f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3f8:	0705                	addi	a4,a4,1
 3fa:	0025179b          	slliw	a5,a0,0x2
 3fe:	9fa9                	addw	a5,a5,a0
 400:	0017979b          	slliw	a5,a5,0x1
 404:	9fb5                	addw	a5,a5,a3
 406:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 40a:	00074683          	lbu	a3,0(a4)
 40e:	fd06879b          	addiw	a5,a3,-48
 412:	0ff7f793          	zext.b	a5,a5
 416:	fef671e3          	bgeu	a2,a5,3f8 <atoi+0x1c>
  return n;
}
 41a:	6422                	ld	s0,8(sp)
 41c:	0141                	addi	sp,sp,16
 41e:	8082                	ret
  n = 0;
 420:	4501                	li	a0,0
 422:	bfe5                	j	41a <atoi+0x3e>

0000000000000424 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 424:	1141                	addi	sp,sp,-16
 426:	e422                	sd	s0,8(sp)
 428:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 42a:	02b57463          	bgeu	a0,a1,452 <memmove+0x2e>
    while(n-- > 0)
 42e:	00c05f63          	blez	a2,44c <memmove+0x28>
 432:	1602                	slli	a2,a2,0x20
 434:	9201                	srli	a2,a2,0x20
 436:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 43a:	872a                	mv	a4,a0
      *dst++ = *src++;
 43c:	0585                	addi	a1,a1,1
 43e:	0705                	addi	a4,a4,1
 440:	fff5c683          	lbu	a3,-1(a1)
 444:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 448:	fef71ae3          	bne	a4,a5,43c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 44c:	6422                	ld	s0,8(sp)
 44e:	0141                	addi	sp,sp,16
 450:	8082                	ret
    dst += n;
 452:	00c50733          	add	a4,a0,a2
    src += n;
 456:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 458:	fec05ae3          	blez	a2,44c <memmove+0x28>
 45c:	fff6079b          	addiw	a5,a2,-1
 460:	1782                	slli	a5,a5,0x20
 462:	9381                	srli	a5,a5,0x20
 464:	fff7c793          	not	a5,a5
 468:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 46a:	15fd                	addi	a1,a1,-1
 46c:	177d                	addi	a4,a4,-1
 46e:	0005c683          	lbu	a3,0(a1)
 472:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 476:	fee79ae3          	bne	a5,a4,46a <memmove+0x46>
 47a:	bfc9                	j	44c <memmove+0x28>

000000000000047c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 47c:	1141                	addi	sp,sp,-16
 47e:	e422                	sd	s0,8(sp)
 480:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 482:	ca05                	beqz	a2,4b2 <memcmp+0x36>
 484:	fff6069b          	addiw	a3,a2,-1
 488:	1682                	slli	a3,a3,0x20
 48a:	9281                	srli	a3,a3,0x20
 48c:	0685                	addi	a3,a3,1
 48e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 490:	00054783          	lbu	a5,0(a0)
 494:	0005c703          	lbu	a4,0(a1)
 498:	00e79863          	bne	a5,a4,4a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 49c:	0505                	addi	a0,a0,1
    p2++;
 49e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4a0:	fed518e3          	bne	a0,a3,490 <memcmp+0x14>
  }
  return 0;
 4a4:	4501                	li	a0,0
 4a6:	a019                	j	4ac <memcmp+0x30>
      return *p1 - *p2;
 4a8:	40e7853b          	subw	a0,a5,a4
}
 4ac:	6422                	ld	s0,8(sp)
 4ae:	0141                	addi	sp,sp,16
 4b0:	8082                	ret
  return 0;
 4b2:	4501                	li	a0,0
 4b4:	bfe5                	j	4ac <memcmp+0x30>

00000000000004b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4b6:	1141                	addi	sp,sp,-16
 4b8:	e406                	sd	ra,8(sp)
 4ba:	e022                	sd	s0,0(sp)
 4bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4be:	f67ff0ef          	jal	424 <memmove>
}
 4c2:	60a2                	ld	ra,8(sp)
 4c4:	6402                	ld	s0,0(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret

00000000000004ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ca:	4885                	li	a7,1
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d2:	4889                	li	a7,2
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <wait>:
.global wait
wait:
 li a7, SYS_wait
 4da:	488d                	li	a7,3
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e2:	4891                	li	a7,4
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <read>:
.global read
read:
 li a7, SYS_read
 4ea:	4895                	li	a7,5
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <write>:
.global write
write:
 li a7, SYS_write
 4f2:	48c1                	li	a7,16
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <close>:
.global close
close:
 li a7, SYS_close
 4fa:	48d5                	li	a7,21
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <kill>:
.global kill
kill:
 li a7, SYS_kill
 502:	4899                	li	a7,6
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <exec>:
.global exec
exec:
 li a7, SYS_exec
 50a:	489d                	li	a7,7
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <open>:
.global open
open:
 li a7, SYS_open
 512:	48bd                	li	a7,15
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 51a:	48c5                	li	a7,17
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 522:	48c9                	li	a7,18
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 52a:	48a1                	li	a7,8
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <link>:
.global link
link:
 li a7, SYS_link
 532:	48cd                	li	a7,19
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 53a:	48d1                	li	a7,20
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 542:	48a5                	li	a7,9
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <dup>:
.global dup
dup:
 li a7, SYS_dup
 54a:	48a9                	li	a7,10
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 552:	48ad                	li	a7,11
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 55a:	48b1                	li	a7,12
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 562:	48b5                	li	a7,13
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 56a:	48b9                	li	a7,14
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <yield>:
.global yield
yield:
 li a7, SYS_yield
 572:	48d9                	li	a7,22
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <getlev>:
.global getlev
getlev:
 li a7, SYS_getlev
 57a:	48dd                	li	a7,23
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <setpriority>:
.global setpriority
setpriority:
 li a7, SYS_setpriority
 582:	48e1                	li	a7,24
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <mlfqmode>:
.global mlfqmode
mlfqmode:
 li a7, SYS_mlfqmode
 58a:	48e5                	li	a7,25
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <fcfsmode>:
.global fcfsmode
fcfsmode:
 li a7, SYS_fcfsmode
 592:	48e9                	li	a7,26
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <showfcfs>:
.global showfcfs
showfcfs:
 li a7, SYS_showfcfs
 59a:	48ed                	li	a7,27
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <showmlfq>:
.global showmlfq
showmlfq:
 li a7, SYS_showmlfq
 5a2:	48f1                	li	a7,28
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5aa:	1101                	addi	sp,sp,-32
 5ac:	ec06                	sd	ra,24(sp)
 5ae:	e822                	sd	s0,16(sp)
 5b0:	1000                	addi	s0,sp,32
 5b2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5b6:	4605                	li	a2,1
 5b8:	fef40593          	addi	a1,s0,-17
 5bc:	f37ff0ef          	jal	4f2 <write>
}
 5c0:	60e2                	ld	ra,24(sp)
 5c2:	6442                	ld	s0,16(sp)
 5c4:	6105                	addi	sp,sp,32
 5c6:	8082                	ret

00000000000005c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5c8:	7139                	addi	sp,sp,-64
 5ca:	fc06                	sd	ra,56(sp)
 5cc:	f822                	sd	s0,48(sp)
 5ce:	f426                	sd	s1,40(sp)
 5d0:	0080                	addi	s0,sp,64
 5d2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5d4:	c299                	beqz	a3,5da <printint+0x12>
 5d6:	0805c963          	bltz	a1,668 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5da:	2581                	sext.w	a1,a1
  neg = 0;
 5dc:	4881                	li	a7,0
 5de:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5e2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5e4:	2601                	sext.w	a2,a2
 5e6:	00000517          	auipc	a0,0x0
 5ea:	55250513          	addi	a0,a0,1362 # b38 <digits>
 5ee:	883a                	mv	a6,a4
 5f0:	2705                	addiw	a4,a4,1
 5f2:	02c5f7bb          	remuw	a5,a1,a2
 5f6:	1782                	slli	a5,a5,0x20
 5f8:	9381                	srli	a5,a5,0x20
 5fa:	97aa                	add	a5,a5,a0
 5fc:	0007c783          	lbu	a5,0(a5)
 600:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 604:	0005879b          	sext.w	a5,a1
 608:	02c5d5bb          	divuw	a1,a1,a2
 60c:	0685                	addi	a3,a3,1
 60e:	fec7f0e3          	bgeu	a5,a2,5ee <printint+0x26>
  if(neg)
 612:	00088c63          	beqz	a7,62a <printint+0x62>
    buf[i++] = '-';
 616:	fd070793          	addi	a5,a4,-48
 61a:	00878733          	add	a4,a5,s0
 61e:	02d00793          	li	a5,45
 622:	fef70823          	sb	a5,-16(a4)
 626:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 62a:	02e05a63          	blez	a4,65e <printint+0x96>
 62e:	f04a                	sd	s2,32(sp)
 630:	ec4e                	sd	s3,24(sp)
 632:	fc040793          	addi	a5,s0,-64
 636:	00e78933          	add	s2,a5,a4
 63a:	fff78993          	addi	s3,a5,-1
 63e:	99ba                	add	s3,s3,a4
 640:	377d                	addiw	a4,a4,-1
 642:	1702                	slli	a4,a4,0x20
 644:	9301                	srli	a4,a4,0x20
 646:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 64a:	fff94583          	lbu	a1,-1(s2)
 64e:	8526                	mv	a0,s1
 650:	f5bff0ef          	jal	5aa <putc>
  while(--i >= 0)
 654:	197d                	addi	s2,s2,-1
 656:	ff391ae3          	bne	s2,s3,64a <printint+0x82>
 65a:	7902                	ld	s2,32(sp)
 65c:	69e2                	ld	s3,24(sp)
}
 65e:	70e2                	ld	ra,56(sp)
 660:	7442                	ld	s0,48(sp)
 662:	74a2                	ld	s1,40(sp)
 664:	6121                	addi	sp,sp,64
 666:	8082                	ret
    x = -xx;
 668:	40b005bb          	negw	a1,a1
    neg = 1;
 66c:	4885                	li	a7,1
    x = -xx;
 66e:	bf85                	j	5de <printint+0x16>

0000000000000670 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 670:	711d                	addi	sp,sp,-96
 672:	ec86                	sd	ra,88(sp)
 674:	e8a2                	sd	s0,80(sp)
 676:	e0ca                	sd	s2,64(sp)
 678:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 67a:	0005c903          	lbu	s2,0(a1)
 67e:	26090863          	beqz	s2,8ee <vprintf+0x27e>
 682:	e4a6                	sd	s1,72(sp)
 684:	fc4e                	sd	s3,56(sp)
 686:	f852                	sd	s4,48(sp)
 688:	f456                	sd	s5,40(sp)
 68a:	f05a                	sd	s6,32(sp)
 68c:	ec5e                	sd	s7,24(sp)
 68e:	e862                	sd	s8,16(sp)
 690:	e466                	sd	s9,8(sp)
 692:	8b2a                	mv	s6,a0
 694:	8a2e                	mv	s4,a1
 696:	8bb2                	mv	s7,a2
  state = 0;
 698:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 69a:	4481                	li	s1,0
 69c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 69e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6a2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6a6:	06c00c93          	li	s9,108
 6aa:	a005                	j	6ca <vprintf+0x5a>
        putc(fd, c0);
 6ac:	85ca                	mv	a1,s2
 6ae:	855a                	mv	a0,s6
 6b0:	efbff0ef          	jal	5aa <putc>
 6b4:	a019                	j	6ba <vprintf+0x4a>
    } else if(state == '%'){
 6b6:	03598263          	beq	s3,s5,6da <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 6ba:	2485                	addiw	s1,s1,1
 6bc:	8726                	mv	a4,s1
 6be:	009a07b3          	add	a5,s4,s1
 6c2:	0007c903          	lbu	s2,0(a5)
 6c6:	20090c63          	beqz	s2,8de <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6ca:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6ce:	fe0994e3          	bnez	s3,6b6 <vprintf+0x46>
      if(c0 == '%'){
 6d2:	fd579de3          	bne	a5,s5,6ac <vprintf+0x3c>
        state = '%';
 6d6:	89be                	mv	s3,a5
 6d8:	b7cd                	j	6ba <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6da:	00ea06b3          	add	a3,s4,a4
 6de:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6e2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6e4:	c681                	beqz	a3,6ec <vprintf+0x7c>
 6e6:	9752                	add	a4,a4,s4
 6e8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6ec:	03878f63          	beq	a5,s8,72a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6f0:	05978963          	beq	a5,s9,742 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6f4:	07500713          	li	a4,117
 6f8:	0ee78363          	beq	a5,a4,7de <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6fc:	07800713          	li	a4,120
 700:	12e78563          	beq	a5,a4,82a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 704:	07000713          	li	a4,112
 708:	14e78a63          	beq	a5,a4,85c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 70c:	07300713          	li	a4,115
 710:	18e78a63          	beq	a5,a4,8a4 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 714:	02500713          	li	a4,37
 718:	04e79563          	bne	a5,a4,762 <vprintf+0xf2>
        putc(fd, '%');
 71c:	02500593          	li	a1,37
 720:	855a                	mv	a0,s6
 722:	e89ff0ef          	jal	5aa <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 726:	4981                	li	s3,0
 728:	bf49                	j	6ba <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 72a:	008b8913          	addi	s2,s7,8
 72e:	4685                	li	a3,1
 730:	4629                	li	a2,10
 732:	000ba583          	lw	a1,0(s7)
 736:	855a                	mv	a0,s6
 738:	e91ff0ef          	jal	5c8 <printint>
 73c:	8bca                	mv	s7,s2
      state = 0;
 73e:	4981                	li	s3,0
 740:	bfad                	j	6ba <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 742:	06400793          	li	a5,100
 746:	02f68963          	beq	a3,a5,778 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 74a:	06c00793          	li	a5,108
 74e:	04f68263          	beq	a3,a5,792 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 752:	07500793          	li	a5,117
 756:	0af68063          	beq	a3,a5,7f6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 75a:	07800793          	li	a5,120
 75e:	0ef68263          	beq	a3,a5,842 <vprintf+0x1d2>
        putc(fd, '%');
 762:	02500593          	li	a1,37
 766:	855a                	mv	a0,s6
 768:	e43ff0ef          	jal	5aa <putc>
        putc(fd, c0);
 76c:	85ca                	mv	a1,s2
 76e:	855a                	mv	a0,s6
 770:	e3bff0ef          	jal	5aa <putc>
      state = 0;
 774:	4981                	li	s3,0
 776:	b791                	j	6ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 778:	008b8913          	addi	s2,s7,8
 77c:	4685                	li	a3,1
 77e:	4629                	li	a2,10
 780:	000ba583          	lw	a1,0(s7)
 784:	855a                	mv	a0,s6
 786:	e43ff0ef          	jal	5c8 <printint>
        i += 1;
 78a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 78c:	8bca                	mv	s7,s2
      state = 0;
 78e:	4981                	li	s3,0
        i += 1;
 790:	b72d                	j	6ba <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 792:	06400793          	li	a5,100
 796:	02f60763          	beq	a2,a5,7c4 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 79a:	07500793          	li	a5,117
 79e:	06f60963          	beq	a2,a5,810 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7a2:	07800793          	li	a5,120
 7a6:	faf61ee3          	bne	a2,a5,762 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7aa:	008b8913          	addi	s2,s7,8
 7ae:	4681                	li	a3,0
 7b0:	4641                	li	a2,16
 7b2:	000ba583          	lw	a1,0(s7)
 7b6:	855a                	mv	a0,s6
 7b8:	e11ff0ef          	jal	5c8 <printint>
        i += 2;
 7bc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7be:	8bca                	mv	s7,s2
      state = 0;
 7c0:	4981                	li	s3,0
        i += 2;
 7c2:	bde5                	j	6ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7c4:	008b8913          	addi	s2,s7,8
 7c8:	4685                	li	a3,1
 7ca:	4629                	li	a2,10
 7cc:	000ba583          	lw	a1,0(s7)
 7d0:	855a                	mv	a0,s6
 7d2:	df7ff0ef          	jal	5c8 <printint>
        i += 2;
 7d6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7d8:	8bca                	mv	s7,s2
      state = 0;
 7da:	4981                	li	s3,0
        i += 2;
 7dc:	bdf9                	j	6ba <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7de:	008b8913          	addi	s2,s7,8
 7e2:	4681                	li	a3,0
 7e4:	4629                	li	a2,10
 7e6:	000ba583          	lw	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	dddff0ef          	jal	5c8 <printint>
 7f0:	8bca                	mv	s7,s2
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	b5d9                	j	6ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7f6:	008b8913          	addi	s2,s7,8
 7fa:	4681                	li	a3,0
 7fc:	4629                	li	a2,10
 7fe:	000ba583          	lw	a1,0(s7)
 802:	855a                	mv	a0,s6
 804:	dc5ff0ef          	jal	5c8 <printint>
        i += 1;
 808:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 80a:	8bca                	mv	s7,s2
      state = 0;
 80c:	4981                	li	s3,0
        i += 1;
 80e:	b575                	j	6ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 810:	008b8913          	addi	s2,s7,8
 814:	4681                	li	a3,0
 816:	4629                	li	a2,10
 818:	000ba583          	lw	a1,0(s7)
 81c:	855a                	mv	a0,s6
 81e:	dabff0ef          	jal	5c8 <printint>
        i += 2;
 822:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 824:	8bca                	mv	s7,s2
      state = 0;
 826:	4981                	li	s3,0
        i += 2;
 828:	bd49                	j	6ba <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 82a:	008b8913          	addi	s2,s7,8
 82e:	4681                	li	a3,0
 830:	4641                	li	a2,16
 832:	000ba583          	lw	a1,0(s7)
 836:	855a                	mv	a0,s6
 838:	d91ff0ef          	jal	5c8 <printint>
 83c:	8bca                	mv	s7,s2
      state = 0;
 83e:	4981                	li	s3,0
 840:	bdad                	j	6ba <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 842:	008b8913          	addi	s2,s7,8
 846:	4681                	li	a3,0
 848:	4641                	li	a2,16
 84a:	000ba583          	lw	a1,0(s7)
 84e:	855a                	mv	a0,s6
 850:	d79ff0ef          	jal	5c8 <printint>
        i += 1;
 854:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 856:	8bca                	mv	s7,s2
      state = 0;
 858:	4981                	li	s3,0
        i += 1;
 85a:	b585                	j	6ba <vprintf+0x4a>
 85c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 85e:	008b8d13          	addi	s10,s7,8
 862:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 866:	03000593          	li	a1,48
 86a:	855a                	mv	a0,s6
 86c:	d3fff0ef          	jal	5aa <putc>
  putc(fd, 'x');
 870:	07800593          	li	a1,120
 874:	855a                	mv	a0,s6
 876:	d35ff0ef          	jal	5aa <putc>
 87a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 87c:	00000b97          	auipc	s7,0x0
 880:	2bcb8b93          	addi	s7,s7,700 # b38 <digits>
 884:	03c9d793          	srli	a5,s3,0x3c
 888:	97de                	add	a5,a5,s7
 88a:	0007c583          	lbu	a1,0(a5)
 88e:	855a                	mv	a0,s6
 890:	d1bff0ef          	jal	5aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 894:	0992                	slli	s3,s3,0x4
 896:	397d                	addiw	s2,s2,-1
 898:	fe0916e3          	bnez	s2,884 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 89c:	8bea                	mv	s7,s10
      state = 0;
 89e:	4981                	li	s3,0
 8a0:	6d02                	ld	s10,0(sp)
 8a2:	bd21                	j	6ba <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 8a4:	008b8993          	addi	s3,s7,8
 8a8:	000bb903          	ld	s2,0(s7)
 8ac:	00090f63          	beqz	s2,8ca <vprintf+0x25a>
        for(; *s; s++)
 8b0:	00094583          	lbu	a1,0(s2)
 8b4:	c195                	beqz	a1,8d8 <vprintf+0x268>
          putc(fd, *s);
 8b6:	855a                	mv	a0,s6
 8b8:	cf3ff0ef          	jal	5aa <putc>
        for(; *s; s++)
 8bc:	0905                	addi	s2,s2,1
 8be:	00094583          	lbu	a1,0(s2)
 8c2:	f9f5                	bnez	a1,8b6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8c4:	8bce                	mv	s7,s3
      state = 0;
 8c6:	4981                	li	s3,0
 8c8:	bbcd                	j	6ba <vprintf+0x4a>
          s = "(null)";
 8ca:	00000917          	auipc	s2,0x0
 8ce:	26690913          	addi	s2,s2,614 # b30 <malloc+0x15a>
        for(; *s; s++)
 8d2:	02800593          	li	a1,40
 8d6:	b7c5                	j	8b6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8d8:	8bce                	mv	s7,s3
      state = 0;
 8da:	4981                	li	s3,0
 8dc:	bbf9                	j	6ba <vprintf+0x4a>
 8de:	64a6                	ld	s1,72(sp)
 8e0:	79e2                	ld	s3,56(sp)
 8e2:	7a42                	ld	s4,48(sp)
 8e4:	7aa2                	ld	s5,40(sp)
 8e6:	7b02                	ld	s6,32(sp)
 8e8:	6be2                	ld	s7,24(sp)
 8ea:	6c42                	ld	s8,16(sp)
 8ec:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8ee:	60e6                	ld	ra,88(sp)
 8f0:	6446                	ld	s0,80(sp)
 8f2:	6906                	ld	s2,64(sp)
 8f4:	6125                	addi	sp,sp,96
 8f6:	8082                	ret

00000000000008f8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f8:	715d                	addi	sp,sp,-80
 8fa:	ec06                	sd	ra,24(sp)
 8fc:	e822                	sd	s0,16(sp)
 8fe:	1000                	addi	s0,sp,32
 900:	e010                	sd	a2,0(s0)
 902:	e414                	sd	a3,8(s0)
 904:	e818                	sd	a4,16(s0)
 906:	ec1c                	sd	a5,24(s0)
 908:	03043023          	sd	a6,32(s0)
 90c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 910:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 914:	8622                	mv	a2,s0
 916:	d5bff0ef          	jal	670 <vprintf>
}
 91a:	60e2                	ld	ra,24(sp)
 91c:	6442                	ld	s0,16(sp)
 91e:	6161                	addi	sp,sp,80
 920:	8082                	ret

0000000000000922 <printf>:

void
printf(const char *fmt, ...)
{
 922:	711d                	addi	sp,sp,-96
 924:	ec06                	sd	ra,24(sp)
 926:	e822                	sd	s0,16(sp)
 928:	1000                	addi	s0,sp,32
 92a:	e40c                	sd	a1,8(s0)
 92c:	e810                	sd	a2,16(s0)
 92e:	ec14                	sd	a3,24(s0)
 930:	f018                	sd	a4,32(s0)
 932:	f41c                	sd	a5,40(s0)
 934:	03043823          	sd	a6,48(s0)
 938:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 93c:	00840613          	addi	a2,s0,8
 940:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 944:	85aa                	mv	a1,a0
 946:	4505                	li	a0,1
 948:	d29ff0ef          	jal	670 <vprintf>
}
 94c:	60e2                	ld	ra,24(sp)
 94e:	6442                	ld	s0,16(sp)
 950:	6125                	addi	sp,sp,96
 952:	8082                	ret

0000000000000954 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 954:	1141                	addi	sp,sp,-16
 956:	e422                	sd	s0,8(sp)
 958:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 95a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95e:	00000797          	auipc	a5,0x0
 962:	6a27b783          	ld	a5,1698(a5) # 1000 <freep>
 966:	a02d                	j	990 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 968:	4618                	lw	a4,8(a2)
 96a:	9f2d                	addw	a4,a4,a1
 96c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 970:	6398                	ld	a4,0(a5)
 972:	6310                	ld	a2,0(a4)
 974:	a83d                	j	9b2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 976:	ff852703          	lw	a4,-8(a0)
 97a:	9f31                	addw	a4,a4,a2
 97c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 97e:	ff053683          	ld	a3,-16(a0)
 982:	a091                	j	9c6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 984:	6398                	ld	a4,0(a5)
 986:	00e7e463          	bltu	a5,a4,98e <free+0x3a>
 98a:	00e6ea63          	bltu	a3,a4,99e <free+0x4a>
{
 98e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 990:	fed7fae3          	bgeu	a5,a3,984 <free+0x30>
 994:	6398                	ld	a4,0(a5)
 996:	00e6e463          	bltu	a3,a4,99e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 99a:	fee7eae3          	bltu	a5,a4,98e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 99e:	ff852583          	lw	a1,-8(a0)
 9a2:	6390                	ld	a2,0(a5)
 9a4:	02059813          	slli	a6,a1,0x20
 9a8:	01c85713          	srli	a4,a6,0x1c
 9ac:	9736                	add	a4,a4,a3
 9ae:	fae60de3          	beq	a2,a4,968 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 9b2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 9b6:	4790                	lw	a2,8(a5)
 9b8:	02061593          	slli	a1,a2,0x20
 9bc:	01c5d713          	srli	a4,a1,0x1c
 9c0:	973e                	add	a4,a4,a5
 9c2:	fae68ae3          	beq	a3,a4,976 <free+0x22>
    p->s.ptr = bp->s.ptr;
 9c6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9c8:	00000717          	auipc	a4,0x0
 9cc:	62f73c23          	sd	a5,1592(a4) # 1000 <freep>
}
 9d0:	6422                	ld	s0,8(sp)
 9d2:	0141                	addi	sp,sp,16
 9d4:	8082                	ret

00000000000009d6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9d6:	7139                	addi	sp,sp,-64
 9d8:	fc06                	sd	ra,56(sp)
 9da:	f822                	sd	s0,48(sp)
 9dc:	f426                	sd	s1,40(sp)
 9de:	ec4e                	sd	s3,24(sp)
 9e0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e2:	02051493          	slli	s1,a0,0x20
 9e6:	9081                	srli	s1,s1,0x20
 9e8:	04bd                	addi	s1,s1,15
 9ea:	8091                	srli	s1,s1,0x4
 9ec:	0014899b          	addiw	s3,s1,1
 9f0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9f2:	00000517          	auipc	a0,0x0
 9f6:	60e53503          	ld	a0,1550(a0) # 1000 <freep>
 9fa:	c915                	beqz	a0,a2e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9fe:	4798                	lw	a4,8(a5)
 a00:	08977a63          	bgeu	a4,s1,a94 <malloc+0xbe>
 a04:	f04a                	sd	s2,32(sp)
 a06:	e852                	sd	s4,16(sp)
 a08:	e456                	sd	s5,8(sp)
 a0a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a0c:	8a4e                	mv	s4,s3
 a0e:	0009871b          	sext.w	a4,s3
 a12:	6685                	lui	a3,0x1
 a14:	00d77363          	bgeu	a4,a3,a1a <malloc+0x44>
 a18:	6a05                	lui	s4,0x1
 a1a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a1e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a22:	00000917          	auipc	s2,0x0
 a26:	5de90913          	addi	s2,s2,1502 # 1000 <freep>
  if(p == (char*)-1)
 a2a:	5afd                	li	s5,-1
 a2c:	a081                	j	a6c <malloc+0x96>
 a2e:	f04a                	sd	s2,32(sp)
 a30:	e852                	sd	s4,16(sp)
 a32:	e456                	sd	s5,8(sp)
 a34:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a36:	00000797          	auipc	a5,0x0
 a3a:	5ea78793          	addi	a5,a5,1514 # 1020 <base>
 a3e:	00000717          	auipc	a4,0x0
 a42:	5cf73123          	sd	a5,1474(a4) # 1000 <freep>
 a46:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a48:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a4c:	b7c1                	j	a0c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a4e:	6398                	ld	a4,0(a5)
 a50:	e118                	sd	a4,0(a0)
 a52:	a8a9                	j	aac <malloc+0xd6>
  hp->s.size = nu;
 a54:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a58:	0541                	addi	a0,a0,16
 a5a:	efbff0ef          	jal	954 <free>
  return freep;
 a5e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a62:	c12d                	beqz	a0,ac4 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a64:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a66:	4798                	lw	a4,8(a5)
 a68:	02977263          	bgeu	a4,s1,a8c <malloc+0xb6>
    if(p == freep)
 a6c:	00093703          	ld	a4,0(s2)
 a70:	853e                	mv	a0,a5
 a72:	fef719e3          	bne	a4,a5,a64 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a76:	8552                	mv	a0,s4
 a78:	ae3ff0ef          	jal	55a <sbrk>
  if(p == (char*)-1)
 a7c:	fd551ce3          	bne	a0,s5,a54 <malloc+0x7e>
        return 0;
 a80:	4501                	li	a0,0
 a82:	7902                	ld	s2,32(sp)
 a84:	6a42                	ld	s4,16(sp)
 a86:	6aa2                	ld	s5,8(sp)
 a88:	6b02                	ld	s6,0(sp)
 a8a:	a03d                	j	ab8 <malloc+0xe2>
 a8c:	7902                	ld	s2,32(sp)
 a8e:	6a42                	ld	s4,16(sp)
 a90:	6aa2                	ld	s5,8(sp)
 a92:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a94:	fae48de3          	beq	s1,a4,a4e <malloc+0x78>
        p->s.size -= nunits;
 a98:	4137073b          	subw	a4,a4,s3
 a9c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a9e:	02071693          	slli	a3,a4,0x20
 aa2:	01c6d713          	srli	a4,a3,0x1c
 aa6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aa8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aac:	00000717          	auipc	a4,0x0
 ab0:	54a73a23          	sd	a0,1364(a4) # 1000 <freep>
      return (void*)(p + 1);
 ab4:	01078513          	addi	a0,a5,16
  }
}
 ab8:	70e2                	ld	ra,56(sp)
 aba:	7442                	ld	s0,48(sp)
 abc:	74a2                	ld	s1,40(sp)
 abe:	69e2                	ld	s3,24(sp)
 ac0:	6121                	addi	sp,sp,64
 ac2:	8082                	ret
 ac4:	7902                	ld	s2,32(sp)
 ac6:	6a42                	ld	s4,16(sp)
 ac8:	6aa2                	ld	s5,8(sp)
 aca:	6b02                	ld	s6,0(sp)
 acc:	b7f5                	j	ab8 <malloc+0xe2>
