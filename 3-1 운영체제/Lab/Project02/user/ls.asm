
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
  56:	00002997          	auipc	s3,0x2
  5a:	fba98993          	addi	s3,s3,-70 # 2010 <buf.0>
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
  f4:	a7050513          	addi	a0,a0,-1424 # b60 <thread_join+0x6a>
  f8:	003000ef          	jal	8fa <printf>
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
 11e:	a1658593          	addi	a1,a1,-1514 # b30 <thread_join+0x3a>
 122:	4509                	li	a0,2
 124:	7ac000ef          	jal	8d0 <fprintf>
    return;
 128:	bff9                	j	106 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 12a:	864a                	mv	a2,s2
 12c:	00001597          	auipc	a1,0x1
 130:	a1c58593          	addi	a1,a1,-1508 # b48 <thread_join+0x52>
 134:	4509                	li	a0,2
 136:	79a000ef          	jal	8d0 <fprintf>
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
 15a:	a1a50513          	addi	a0,a0,-1510 # b70 <thread_join+0x7a>
 15e:	79c000ef          	jal	8fa <printf>
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
 19e:	9c6a0a13          	addi	s4,s4,-1594 # b60 <thread_join+0x6a>
        printf("ls: cannot stat %s\n", buf);
 1a2:	00001a97          	auipc	s5,0x1
 1a6:	9a6a8a93          	addi	s5,s5,-1626 # b48 <thread_join+0x52>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1aa:	a031                	j	1b6 <ls+0x11e>
        printf("ls: cannot stat %s\n", buf);
 1ac:	dc040593          	addi	a1,s0,-576
 1b0:	8556                	mv	a0,s5
 1b2:	748000ef          	jal	8fa <printf>
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
 206:	6f4000ef          	jal	8fa <printf>
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
 25a:	93250513          	addi	a0,a0,-1742 # b88 <thread_join+0x92>
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

0000000000000572 <clone>:
.global clone
clone:
 li a7, SYS_clone
 572:	48d9                	li	a7,22
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <join>:
.global join
join:
 li a7, SYS_join
 57a:	48dd                	li	a7,23
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 582:	1101                	addi	sp,sp,-32
 584:	ec06                	sd	ra,24(sp)
 586:	e822                	sd	s0,16(sp)
 588:	1000                	addi	s0,sp,32
 58a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 58e:	4605                	li	a2,1
 590:	fef40593          	addi	a1,s0,-17
 594:	f5fff0ef          	jal	4f2 <write>
}
 598:	60e2                	ld	ra,24(sp)
 59a:	6442                	ld	s0,16(sp)
 59c:	6105                	addi	sp,sp,32
 59e:	8082                	ret

00000000000005a0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 5a0:	7139                	addi	sp,sp,-64
 5a2:	fc06                	sd	ra,56(sp)
 5a4:	f822                	sd	s0,48(sp)
 5a6:	f426                	sd	s1,40(sp)
 5a8:	0080                	addi	s0,sp,64
 5aa:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5ac:	c299                	beqz	a3,5b2 <printint+0x12>
 5ae:	0805c963          	bltz	a1,640 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 5b2:	2581                	sext.w	a1,a1
  neg = 0;
 5b4:	4881                	li	a7,0
 5b6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 5ba:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5bc:	2601                	sext.w	a2,a2
 5be:	00000517          	auipc	a0,0x0
 5c2:	5da50513          	addi	a0,a0,1498 # b98 <digits>
 5c6:	883a                	mv	a6,a4
 5c8:	2705                	addiw	a4,a4,1
 5ca:	02c5f7bb          	remuw	a5,a1,a2
 5ce:	1782                	slli	a5,a5,0x20
 5d0:	9381                	srli	a5,a5,0x20
 5d2:	97aa                	add	a5,a5,a0
 5d4:	0007c783          	lbu	a5,0(a5)
 5d8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5dc:	0005879b          	sext.w	a5,a1
 5e0:	02c5d5bb          	divuw	a1,a1,a2
 5e4:	0685                	addi	a3,a3,1
 5e6:	fec7f0e3          	bgeu	a5,a2,5c6 <printint+0x26>
  if(neg)
 5ea:	00088c63          	beqz	a7,602 <printint+0x62>
    buf[i++] = '-';
 5ee:	fd070793          	addi	a5,a4,-48
 5f2:	00878733          	add	a4,a5,s0
 5f6:	02d00793          	li	a5,45
 5fa:	fef70823          	sb	a5,-16(a4)
 5fe:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 602:	02e05a63          	blez	a4,636 <printint+0x96>
 606:	f04a                	sd	s2,32(sp)
 608:	ec4e                	sd	s3,24(sp)
 60a:	fc040793          	addi	a5,s0,-64
 60e:	00e78933          	add	s2,a5,a4
 612:	fff78993          	addi	s3,a5,-1
 616:	99ba                	add	s3,s3,a4
 618:	377d                	addiw	a4,a4,-1
 61a:	1702                	slli	a4,a4,0x20
 61c:	9301                	srli	a4,a4,0x20
 61e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 622:	fff94583          	lbu	a1,-1(s2)
 626:	8526                	mv	a0,s1
 628:	f5bff0ef          	jal	582 <putc>
  while(--i >= 0)
 62c:	197d                	addi	s2,s2,-1
 62e:	ff391ae3          	bne	s2,s3,622 <printint+0x82>
 632:	7902                	ld	s2,32(sp)
 634:	69e2                	ld	s3,24(sp)
}
 636:	70e2                	ld	ra,56(sp)
 638:	7442                	ld	s0,48(sp)
 63a:	74a2                	ld	s1,40(sp)
 63c:	6121                	addi	sp,sp,64
 63e:	8082                	ret
    x = -xx;
 640:	40b005bb          	negw	a1,a1
    neg = 1;
 644:	4885                	li	a7,1
    x = -xx;
 646:	bf85                	j	5b6 <printint+0x16>

0000000000000648 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 648:	711d                	addi	sp,sp,-96
 64a:	ec86                	sd	ra,88(sp)
 64c:	e8a2                	sd	s0,80(sp)
 64e:	e0ca                	sd	s2,64(sp)
 650:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 652:	0005c903          	lbu	s2,0(a1)
 656:	26090863          	beqz	s2,8c6 <vprintf+0x27e>
 65a:	e4a6                	sd	s1,72(sp)
 65c:	fc4e                	sd	s3,56(sp)
 65e:	f852                	sd	s4,48(sp)
 660:	f456                	sd	s5,40(sp)
 662:	f05a                	sd	s6,32(sp)
 664:	ec5e                	sd	s7,24(sp)
 666:	e862                	sd	s8,16(sp)
 668:	e466                	sd	s9,8(sp)
 66a:	8b2a                	mv	s6,a0
 66c:	8a2e                	mv	s4,a1
 66e:	8bb2                	mv	s7,a2
  state = 0;
 670:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 672:	4481                	li	s1,0
 674:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 676:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 67a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 67e:	06c00c93          	li	s9,108
 682:	a005                	j	6a2 <vprintf+0x5a>
        putc(fd, c0);
 684:	85ca                	mv	a1,s2
 686:	855a                	mv	a0,s6
 688:	efbff0ef          	jal	582 <putc>
 68c:	a019                	j	692 <vprintf+0x4a>
    } else if(state == '%'){
 68e:	03598263          	beq	s3,s5,6b2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
 692:	2485                	addiw	s1,s1,1
 694:	8726                	mv	a4,s1
 696:	009a07b3          	add	a5,s4,s1
 69a:	0007c903          	lbu	s2,0(a5)
 69e:	20090c63          	beqz	s2,8b6 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
 6a2:	0009079b          	sext.w	a5,s2
    if(state == 0){
 6a6:	fe0994e3          	bnez	s3,68e <vprintf+0x46>
      if(c0 == '%'){
 6aa:	fd579de3          	bne	a5,s5,684 <vprintf+0x3c>
        state = '%';
 6ae:	89be                	mv	s3,a5
 6b0:	b7cd                	j	692 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 6b2:	00ea06b3          	add	a3,s4,a4
 6b6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 6ba:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 6bc:	c681                	beqz	a3,6c4 <vprintf+0x7c>
 6be:	9752                	add	a4,a4,s4
 6c0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 6c4:	03878f63          	beq	a5,s8,702 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 6c8:	05978963          	beq	a5,s9,71a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 6cc:	07500713          	li	a4,117
 6d0:	0ee78363          	beq	a5,a4,7b6 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 6d4:	07800713          	li	a4,120
 6d8:	12e78563          	beq	a5,a4,802 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 6dc:	07000713          	li	a4,112
 6e0:	14e78a63          	beq	a5,a4,834 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 6e4:	07300713          	li	a4,115
 6e8:	18e78a63          	beq	a5,a4,87c <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 6ec:	02500713          	li	a4,37
 6f0:	04e79563          	bne	a5,a4,73a <vprintf+0xf2>
        putc(fd, '%');
 6f4:	02500593          	li	a1,37
 6f8:	855a                	mv	a0,s6
 6fa:	e89ff0ef          	jal	582 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 6fe:	4981                	li	s3,0
 700:	bf49                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 702:	008b8913          	addi	s2,s7,8
 706:	4685                	li	a3,1
 708:	4629                	li	a2,10
 70a:	000ba583          	lw	a1,0(s7)
 70e:	855a                	mv	a0,s6
 710:	e91ff0ef          	jal	5a0 <printint>
 714:	8bca                	mv	s7,s2
      state = 0;
 716:	4981                	li	s3,0
 718:	bfad                	j	692 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 71a:	06400793          	li	a5,100
 71e:	02f68963          	beq	a3,a5,750 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 722:	06c00793          	li	a5,108
 726:	04f68263          	beq	a3,a5,76a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 72a:	07500793          	li	a5,117
 72e:	0af68063          	beq	a3,a5,7ce <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 732:	07800793          	li	a5,120
 736:	0ef68263          	beq	a3,a5,81a <vprintf+0x1d2>
        putc(fd, '%');
 73a:	02500593          	li	a1,37
 73e:	855a                	mv	a0,s6
 740:	e43ff0ef          	jal	582 <putc>
        putc(fd, c0);
 744:	85ca                	mv	a1,s2
 746:	855a                	mv	a0,s6
 748:	e3bff0ef          	jal	582 <putc>
      state = 0;
 74c:	4981                	li	s3,0
 74e:	b791                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 750:	008b8913          	addi	s2,s7,8
 754:	4685                	li	a3,1
 756:	4629                	li	a2,10
 758:	000ba583          	lw	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	e43ff0ef          	jal	5a0 <printint>
        i += 1;
 762:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 764:	8bca                	mv	s7,s2
      state = 0;
 766:	4981                	li	s3,0
        i += 1;
 768:	b72d                	j	692 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 76a:	06400793          	li	a5,100
 76e:	02f60763          	beq	a2,a5,79c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 772:	07500793          	li	a5,117
 776:	06f60963          	beq	a2,a5,7e8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 77a:	07800793          	li	a5,120
 77e:	faf61ee3          	bne	a2,a5,73a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 782:	008b8913          	addi	s2,s7,8
 786:	4681                	li	a3,0
 788:	4641                	li	a2,16
 78a:	000ba583          	lw	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	e11ff0ef          	jal	5a0 <printint>
        i += 2;
 794:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 796:	8bca                	mv	s7,s2
      state = 0;
 798:	4981                	li	s3,0
        i += 2;
 79a:	bde5                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 79c:	008b8913          	addi	s2,s7,8
 7a0:	4685                	li	a3,1
 7a2:	4629                	li	a2,10
 7a4:	000ba583          	lw	a1,0(s7)
 7a8:	855a                	mv	a0,s6
 7aa:	df7ff0ef          	jal	5a0 <printint>
        i += 2;
 7ae:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b0:	8bca                	mv	s7,s2
      state = 0;
 7b2:	4981                	li	s3,0
        i += 2;
 7b4:	bdf9                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 7b6:	008b8913          	addi	s2,s7,8
 7ba:	4681                	li	a3,0
 7bc:	4629                	li	a2,10
 7be:	000ba583          	lw	a1,0(s7)
 7c2:	855a                	mv	a0,s6
 7c4:	dddff0ef          	jal	5a0 <printint>
 7c8:	8bca                	mv	s7,s2
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	b5d9                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ce:	008b8913          	addi	s2,s7,8
 7d2:	4681                	li	a3,0
 7d4:	4629                	li	a2,10
 7d6:	000ba583          	lw	a1,0(s7)
 7da:	855a                	mv	a0,s6
 7dc:	dc5ff0ef          	jal	5a0 <printint>
        i += 1;
 7e0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e2:	8bca                	mv	s7,s2
      state = 0;
 7e4:	4981                	li	s3,0
        i += 1;
 7e6:	b575                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e8:	008b8913          	addi	s2,s7,8
 7ec:	4681                	li	a3,0
 7ee:	4629                	li	a2,10
 7f0:	000ba583          	lw	a1,0(s7)
 7f4:	855a                	mv	a0,s6
 7f6:	dabff0ef          	jal	5a0 <printint>
        i += 2;
 7fa:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7fc:	8bca                	mv	s7,s2
      state = 0;
 7fe:	4981                	li	s3,0
        i += 2;
 800:	bd49                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 802:	008b8913          	addi	s2,s7,8
 806:	4681                	li	a3,0
 808:	4641                	li	a2,16
 80a:	000ba583          	lw	a1,0(s7)
 80e:	855a                	mv	a0,s6
 810:	d91ff0ef          	jal	5a0 <printint>
 814:	8bca                	mv	s7,s2
      state = 0;
 816:	4981                	li	s3,0
 818:	bdad                	j	692 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 81a:	008b8913          	addi	s2,s7,8
 81e:	4681                	li	a3,0
 820:	4641                	li	a2,16
 822:	000ba583          	lw	a1,0(s7)
 826:	855a                	mv	a0,s6
 828:	d79ff0ef          	jal	5a0 <printint>
        i += 1;
 82c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 82e:	8bca                	mv	s7,s2
      state = 0;
 830:	4981                	li	s3,0
        i += 1;
 832:	b585                	j	692 <vprintf+0x4a>
 834:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 836:	008b8d13          	addi	s10,s7,8
 83a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 83e:	03000593          	li	a1,48
 842:	855a                	mv	a0,s6
 844:	d3fff0ef          	jal	582 <putc>
  putc(fd, 'x');
 848:	07800593          	li	a1,120
 84c:	855a                	mv	a0,s6
 84e:	d35ff0ef          	jal	582 <putc>
 852:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 854:	00000b97          	auipc	s7,0x0
 858:	344b8b93          	addi	s7,s7,836 # b98 <digits>
 85c:	03c9d793          	srli	a5,s3,0x3c
 860:	97de                	add	a5,a5,s7
 862:	0007c583          	lbu	a1,0(a5)
 866:	855a                	mv	a0,s6
 868:	d1bff0ef          	jal	582 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 86c:	0992                	slli	s3,s3,0x4
 86e:	397d                	addiw	s2,s2,-1
 870:	fe0916e3          	bnez	s2,85c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 874:	8bea                	mv	s7,s10
      state = 0;
 876:	4981                	li	s3,0
 878:	6d02                	ld	s10,0(sp)
 87a:	bd21                	j	692 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 87c:	008b8993          	addi	s3,s7,8
 880:	000bb903          	ld	s2,0(s7)
 884:	00090f63          	beqz	s2,8a2 <vprintf+0x25a>
        for(; *s; s++)
 888:	00094583          	lbu	a1,0(s2)
 88c:	c195                	beqz	a1,8b0 <vprintf+0x268>
          putc(fd, *s);
 88e:	855a                	mv	a0,s6
 890:	cf3ff0ef          	jal	582 <putc>
        for(; *s; s++)
 894:	0905                	addi	s2,s2,1
 896:	00094583          	lbu	a1,0(s2)
 89a:	f9f5                	bnez	a1,88e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 89c:	8bce                	mv	s7,s3
      state = 0;
 89e:	4981                	li	s3,0
 8a0:	bbcd                	j	692 <vprintf+0x4a>
          s = "(null)";
 8a2:	00000917          	auipc	s2,0x0
 8a6:	2ee90913          	addi	s2,s2,750 # b90 <thread_join+0x9a>
        for(; *s; s++)
 8aa:	02800593          	li	a1,40
 8ae:	b7c5                	j	88e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
 8b0:	8bce                	mv	s7,s3
      state = 0;
 8b2:	4981                	li	s3,0
 8b4:	bbf9                	j	692 <vprintf+0x4a>
 8b6:	64a6                	ld	s1,72(sp)
 8b8:	79e2                	ld	s3,56(sp)
 8ba:	7a42                	ld	s4,48(sp)
 8bc:	7aa2                	ld	s5,40(sp)
 8be:	7b02                	ld	s6,32(sp)
 8c0:	6be2                	ld	s7,24(sp)
 8c2:	6c42                	ld	s8,16(sp)
 8c4:	6ca2                	ld	s9,8(sp)
    }
  }
}
 8c6:	60e6                	ld	ra,88(sp)
 8c8:	6446                	ld	s0,80(sp)
 8ca:	6906                	ld	s2,64(sp)
 8cc:	6125                	addi	sp,sp,96
 8ce:	8082                	ret

00000000000008d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d0:	715d                	addi	sp,sp,-80
 8d2:	ec06                	sd	ra,24(sp)
 8d4:	e822                	sd	s0,16(sp)
 8d6:	1000                	addi	s0,sp,32
 8d8:	e010                	sd	a2,0(s0)
 8da:	e414                	sd	a3,8(s0)
 8dc:	e818                	sd	a4,16(s0)
 8de:	ec1c                	sd	a5,24(s0)
 8e0:	03043023          	sd	a6,32(s0)
 8e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8ec:	8622                	mv	a2,s0
 8ee:	d5bff0ef          	jal	648 <vprintf>
}
 8f2:	60e2                	ld	ra,24(sp)
 8f4:	6442                	ld	s0,16(sp)
 8f6:	6161                	addi	sp,sp,80
 8f8:	8082                	ret

00000000000008fa <printf>:

void
printf(const char *fmt, ...)
{
 8fa:	711d                	addi	sp,sp,-96
 8fc:	ec06                	sd	ra,24(sp)
 8fe:	e822                	sd	s0,16(sp)
 900:	1000                	addi	s0,sp,32
 902:	e40c                	sd	a1,8(s0)
 904:	e810                	sd	a2,16(s0)
 906:	ec14                	sd	a3,24(s0)
 908:	f018                	sd	a4,32(s0)
 90a:	f41c                	sd	a5,40(s0)
 90c:	03043823          	sd	a6,48(s0)
 910:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 914:	00840613          	addi	a2,s0,8
 918:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 91c:	85aa                	mv	a1,a0
 91e:	4505                	li	a0,1
 920:	d29ff0ef          	jal	648 <vprintf>
}
 924:	60e2                	ld	ra,24(sp)
 926:	6442                	ld	s0,16(sp)
 928:	6125                	addi	sp,sp,96
 92a:	8082                	ret

000000000000092c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 92c:	1141                	addi	sp,sp,-16
 92e:	e422                	sd	s0,8(sp)
 930:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 932:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 936:	00001797          	auipc	a5,0x1
 93a:	6ca7b783          	ld	a5,1738(a5) # 2000 <freep>
 93e:	a02d                	j	968 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 940:	4618                	lw	a4,8(a2)
 942:	9f2d                	addw	a4,a4,a1
 944:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 948:	6398                	ld	a4,0(a5)
 94a:	6310                	ld	a2,0(a4)
 94c:	a83d                	j	98a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 94e:	ff852703          	lw	a4,-8(a0)
 952:	9f31                	addw	a4,a4,a2
 954:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 956:	ff053683          	ld	a3,-16(a0)
 95a:	a091                	j	99e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 95c:	6398                	ld	a4,0(a5)
 95e:	00e7e463          	bltu	a5,a4,966 <free+0x3a>
 962:	00e6ea63          	bltu	a3,a4,976 <free+0x4a>
{
 966:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 968:	fed7fae3          	bgeu	a5,a3,95c <free+0x30>
 96c:	6398                	ld	a4,0(a5)
 96e:	00e6e463          	bltu	a3,a4,976 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 972:	fee7eae3          	bltu	a5,a4,966 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 976:	ff852583          	lw	a1,-8(a0)
 97a:	6390                	ld	a2,0(a5)
 97c:	02059813          	slli	a6,a1,0x20
 980:	01c85713          	srli	a4,a6,0x1c
 984:	9736                	add	a4,a4,a3
 986:	fae60de3          	beq	a2,a4,940 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 98a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 98e:	4790                	lw	a2,8(a5)
 990:	02061593          	slli	a1,a2,0x20
 994:	01c5d713          	srli	a4,a1,0x1c
 998:	973e                	add	a4,a4,a5
 99a:	fae68ae3          	beq	a3,a4,94e <free+0x22>
    p->s.ptr = bp->s.ptr;
 99e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9a0:	00001717          	auipc	a4,0x1
 9a4:	66f73023          	sd	a5,1632(a4) # 2000 <freep>
}
 9a8:	6422                	ld	s0,8(sp)
 9aa:	0141                	addi	sp,sp,16
 9ac:	8082                	ret

00000000000009ae <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ae:	7139                	addi	sp,sp,-64
 9b0:	fc06                	sd	ra,56(sp)
 9b2:	f822                	sd	s0,48(sp)
 9b4:	f426                	sd	s1,40(sp)
 9b6:	ec4e                	sd	s3,24(sp)
 9b8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ba:	02051493          	slli	s1,a0,0x20
 9be:	9081                	srli	s1,s1,0x20
 9c0:	04bd                	addi	s1,s1,15
 9c2:	8091                	srli	s1,s1,0x4
 9c4:	0014899b          	addiw	s3,s1,1
 9c8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 9ca:	00001517          	auipc	a0,0x1
 9ce:	63653503          	ld	a0,1590(a0) # 2000 <freep>
 9d2:	c915                	beqz	a0,a06 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d6:	4798                	lw	a4,8(a5)
 9d8:	08977a63          	bgeu	a4,s1,a6c <malloc+0xbe>
 9dc:	f04a                	sd	s2,32(sp)
 9de:	e852                	sd	s4,16(sp)
 9e0:	e456                	sd	s5,8(sp)
 9e2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9e4:	8a4e                	mv	s4,s3
 9e6:	0009871b          	sext.w	a4,s3
 9ea:	6685                	lui	a3,0x1
 9ec:	00d77363          	bgeu	a4,a3,9f2 <malloc+0x44>
 9f0:	6a05                	lui	s4,0x1
 9f2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9f6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9fa:	00001917          	auipc	s2,0x1
 9fe:	60690913          	addi	s2,s2,1542 # 2000 <freep>
  if(p == (char*)-1)
 a02:	5afd                	li	s5,-1
 a04:	a081                	j	a44 <malloc+0x96>
 a06:	f04a                	sd	s2,32(sp)
 a08:	e852                	sd	s4,16(sp)
 a0a:	e456                	sd	s5,8(sp)
 a0c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a0e:	00001797          	auipc	a5,0x1
 a12:	61278793          	addi	a5,a5,1554 # 2020 <base>
 a16:	00001717          	auipc	a4,0x1
 a1a:	5ef73523          	sd	a5,1514(a4) # 2000 <freep>
 a1e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a20:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a24:	b7c1                	j	9e4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a26:	6398                	ld	a4,0(a5)
 a28:	e118                	sd	a4,0(a0)
 a2a:	a8a9                	j	a84 <malloc+0xd6>
  hp->s.size = nu;
 a2c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a30:	0541                	addi	a0,a0,16
 a32:	efbff0ef          	jal	92c <free>
  return freep;
 a36:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a3a:	c12d                	beqz	a0,a9c <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a3c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a3e:	4798                	lw	a4,8(a5)
 a40:	02977263          	bgeu	a4,s1,a64 <malloc+0xb6>
    if(p == freep)
 a44:	00093703          	ld	a4,0(s2)
 a48:	853e                	mv	a0,a5
 a4a:	fef719e3          	bne	a4,a5,a3c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 a4e:	8552                	mv	a0,s4
 a50:	b0bff0ef          	jal	55a <sbrk>
  if(p == (char*)-1)
 a54:	fd551ce3          	bne	a0,s5,a2c <malloc+0x7e>
        return 0;
 a58:	4501                	li	a0,0
 a5a:	7902                	ld	s2,32(sp)
 a5c:	6a42                	ld	s4,16(sp)
 a5e:	6aa2                	ld	s5,8(sp)
 a60:	6b02                	ld	s6,0(sp)
 a62:	a03d                	j	a90 <malloc+0xe2>
 a64:	7902                	ld	s2,32(sp)
 a66:	6a42                	ld	s4,16(sp)
 a68:	6aa2                	ld	s5,8(sp)
 a6a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a6c:	fae48de3          	beq	s1,a4,a26 <malloc+0x78>
        p->s.size -= nunits;
 a70:	4137073b          	subw	a4,a4,s3
 a74:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a76:	02071693          	slli	a3,a4,0x20
 a7a:	01c6d713          	srli	a4,a3,0x1c
 a7e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a80:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a84:	00001717          	auipc	a4,0x1
 a88:	56a73e23          	sd	a0,1404(a4) # 2000 <freep>
      return (void*)(p + 1);
 a8c:	01078513          	addi	a0,a5,16
  }
}
 a90:	70e2                	ld	ra,56(sp)
 a92:	7442                	ld	s0,48(sp)
 a94:	74a2                	ld	s1,40(sp)
 a96:	69e2                	ld	s3,24(sp)
 a98:	6121                	addi	sp,sp,64
 a9a:	8082                	ret
 a9c:	7902                	ld	s2,32(sp)
 a9e:	6a42                	ld	s4,16(sp)
 aa0:	6aa2                	ld	s5,8(sp)
 aa2:	6b02                	ld	s6,0(sp)
 aa4:	b7f5                	j	a90 <malloc+0xe2>

0000000000000aa6 <thread_create>:
#include "kernel/types.h"
#include "kernel/riscv.h"

int 
thread_create(void (*start_routine)(void*, void*), void *arg1, void* arg2)
{
 aa6:	7179                	addi	sp,sp,-48
 aa8:	f406                	sd	ra,40(sp)
 aaa:	f022                	sd	s0,32(sp)
 aac:	e84a                	sd	s2,16(sp)
 aae:	e44e                	sd	s3,8(sp)
 ab0:	e052                	sd	s4,0(sp)
 ab2:	1800                	addi	s0,sp,48
 ab4:	892a                	mv	s2,a0
 ab6:	89ae                	mv	s3,a1
 ab8:	8a32                	mv	s4,a2
    int tid;

    void *stack = malloc(2 * PGSIZE);
 aba:	6509                	lui	a0,0x2
 abc:	ef3ff0ef          	jal	9ae <malloc>
    if (stack == 0) return -1;
 ac0:	c90d                	beqz	a0,af2 <thread_create+0x4c>
 ac2:	ec26                	sd	s1,24(sp)
 ac4:	84aa                	mv	s1,a0
    
    if ((tid = clone(start_routine, arg1, arg2, stack)) < 0) {
 ac6:	86aa                	mv	a3,a0
 ac8:	8652                	mv	a2,s4
 aca:	85ce                	mv	a1,s3
 acc:	854a                	mv	a0,s2
 ace:	aa5ff0ef          	jal	572 <clone>
 ad2:	00054a63          	bltz	a0,ae6 <thread_create+0x40>
 ad6:	64e2                	ld	s1,24(sp)
        free(stack);
        return -1;
    }
    
    return tid;
}
 ad8:	70a2                	ld	ra,40(sp)
 ada:	7402                	ld	s0,32(sp)
 adc:	6942                	ld	s2,16(sp)
 ade:	69a2                	ld	s3,8(sp)
 ae0:	6a02                	ld	s4,0(sp)
 ae2:	6145                	addi	sp,sp,48
 ae4:	8082                	ret
        free(stack);
 ae6:	8526                	mv	a0,s1
 ae8:	e45ff0ef          	jal	92c <free>
        return -1;
 aec:	557d                	li	a0,-1
 aee:	64e2                	ld	s1,24(sp)
 af0:	b7e5                	j	ad8 <thread_create+0x32>
    if (stack == 0) return -1;
 af2:	557d                	li	a0,-1
 af4:	b7d5                	j	ad8 <thread_create+0x32>

0000000000000af6 <thread_join>:

int 
thread_join()
{   
 af6:	7179                	addi	sp,sp,-48
 af8:	f406                	sd	ra,40(sp)
 afa:	f022                	sd	s0,32(sp)
 afc:	ec26                	sd	s1,24(sp)
 afe:	1800                	addi	s0,sp,48
    int tid;
    void *stack;
    
    if ((tid = join(&stack)) < 0) {
 b00:	fd840513          	addi	a0,s0,-40
 b04:	a77ff0ef          	jal	57a <join>
 b08:	00054d63          	bltz	a0,b22 <thread_join+0x2c>
 b0c:	84aa                	mv	s1,a0
        return -1;
    }

    free(stack);
 b0e:	fd843503          	ld	a0,-40(s0)
 b12:	e1bff0ef          	jal	92c <free>
    return tid;
}
 b16:	8526                	mv	a0,s1
 b18:	70a2                	ld	ra,40(sp)
 b1a:	7402                	ld	s0,32(sp)
 b1c:	64e2                	ld	s1,24(sp)
 b1e:	6145                	addi	sp,sp,48
 b20:	8082                	ret
        return -1;
 b22:	54fd                	li	s1,-1
 b24:	bfcd                	j	b16 <thread_join+0x20>
