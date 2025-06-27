
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	31013103          	ld	sp,784(sp) # 8000a310 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda75f>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	de278793          	addi	a5,a5,-542 # 80000e62 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	28e020ef          	jal	80002388 <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	035000ef          	jal	8000093a <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
    80000114:	74e2                	ld	s1,56(sp)
    80000116:	79a2                	ld	s3,40(sp)
    80000118:	7a02                	ld	s4,32(sp)
    8000011a:	6ae2                	ld	s5,24(sp)
    8000011c:	a039                	j	8000012a <consolewrite+0x5a>
    8000011e:	4901                	li	s2,0
    80000120:	a029                	j	8000012a <consolewrite+0x5a>
    80000122:	74e2                	ld	s1,56(sp)
    80000124:	79a2                	ld	s3,40(sp)
    80000126:	7a02                	ld	s4,32(sp)
    80000128:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000136:	711d                	addi	sp,sp,-96
    80000138:	ec86                	sd	ra,88(sp)
    8000013a:	e8a2                	sd	s0,80(sp)
    8000013c:	e4a6                	sd	s1,72(sp)
    8000013e:	e0ca                	sd	s2,64(sp)
    80000140:	fc4e                	sd	s3,56(sp)
    80000142:	f852                	sd	s4,48(sp)
    80000144:	f456                	sd	s5,40(sp)
    80000146:	f05a                	sd	s6,32(sp)
    80000148:	1080                	addi	s0,sp,96
    8000014a:	8aaa                	mv	s5,a0
    8000014c:	8a2e                	mv	s4,a1
    8000014e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000150:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000154:	00012517          	auipc	a0,0x12
    80000158:	21c50513          	addi	a0,a0,540 # 80012370 <cons>
    8000015c:	299000ef          	jal	80000bf4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00012497          	auipc	s1,0x12
    80000164:	21048493          	addi	s1,s1,528 # 80012370 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	2a090913          	addi	s2,s2,672 # 80012408 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	796010ef          	jal	80001916 <myproc>
    80000184:	096020ef          	jal	8000221a <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	5df010ef          	jal	80001f6c <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	1d070713          	addi	a4,a4,464 # 80012370 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	16c020ef          	jal	8000233e <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
      break;

    dst++;
    800001dc:	0a05                	addi	s4,s4,1
    --n;
    800001de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
        release(&cons.lock);
    800001ea:	00012517          	auipc	a0,0x12
    800001ee:	18650513          	addi	a0,a0,390 # 80012370 <cons>
    800001f2:	29b000ef          	jal	80000c8c <release>
        return -1;
    800001f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800001f8:	60e6                	ld	ra,88(sp)
    800001fa:	6446                	ld	s0,80(sp)
    800001fc:	64a6                	ld	s1,72(sp)
    800001fe:	6906                	ld	s2,64(sp)
    80000200:	79e2                	ld	s3,56(sp)
    80000202:	7a42                	ld	s4,48(sp)
    80000204:	7aa2                	ld	s5,40(sp)
    80000206:	7b02                	ld	s6,32(sp)
    80000208:	6125                	addi	sp,sp,96
    8000020a:	8082                	ret
      if(n < target){
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
        cons.r--;
    80000214:	00012717          	auipc	a4,0x12
    80000218:	1ef72a23          	sw	a5,500(a4) # 80012408 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	14650513          	addi	a0,a0,326 # 80012370 <cons>
    80000232:	25b000ef          	jal	80000c8c <release>
  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    uartputc_sync(c);
    80000250:	604000ef          	jal	80000854 <uartputc_sync>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000025c:	4521                	li	a0,8
    8000025e:	5f6000ef          	jal	80000854 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	5ee000ef          	jal	80000854 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	5e8000ef          	jal	80000854 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000027e:	00012517          	auipc	a0,0x12
    80000282:	0f250513          	addi	a0,a0,242 # 80012370 <cons>
    80000286:	16f000ef          	jal	80000bf4 <acquire>

  switch(c){
    8000028a:	47d5                	li	a5,21
    8000028c:	08f48f63          	beq	s1,a5,8000032a <consoleintr+0xb8>
    80000290:	0297c563          	blt	a5,s1,800002ba <consoleintr+0x48>
    80000294:	47a1                	li	a5,8
    80000296:	0ef48463          	beq	s1,a5,8000037e <consoleintr+0x10c>
    8000029a:	47c1                	li	a5,16
    8000029c:	10f49563          	bne	s1,a5,800003a6 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800002a0:	132020ef          	jal	800023d2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	00012517          	auipc	a0,0x12
    800002a8:	0cc50513          	addi	a0,a0,204 # 80012370 <cons>
    800002ac:	1e1000ef          	jal	80000c8c <release>
}
    800002b0:	60e2                	ld	ra,24(sp)
    800002b2:	6442                	ld	s0,16(sp)
    800002b4:	64a2                	ld	s1,8(sp)
    800002b6:	6105                	addi	sp,sp,32
    800002b8:	8082                	ret
  switch(c){
    800002ba:	07f00793          	li	a5,127
    800002be:	0cf48063          	beq	s1,a5,8000037e <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002c2:	00012717          	auipc	a4,0x12
    800002c6:	0ae70713          	addi	a4,a4,174 # 80012370 <cons>
    800002ca:	0a072783          	lw	a5,160(a4)
    800002ce:	09872703          	lw	a4,152(a4)
    800002d2:	9f99                	subw	a5,a5,a4
    800002d4:	07f00713          	li	a4,127
    800002d8:	fcf766e3          	bltu	a4,a5,800002a4 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002dc:	47b5                	li	a5,13
    800002de:	0cf48763          	beq	s1,a5,800003ac <consoleintr+0x13a>
      consputc(c);
    800002e2:	8526                	mv	a0,s1
    800002e4:	f5dff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800002e8:	00012797          	auipc	a5,0x12
    800002ec:	08878793          	addi	a5,a5,136 # 80012370 <cons>
    800002f0:	0a07a683          	lw	a3,160(a5)
    800002f4:	0016871b          	addiw	a4,a3,1
    800002f8:	0007061b          	sext.w	a2,a4
    800002fc:	0ae7a023          	sw	a4,160(a5)
    80000300:	07f6f693          	andi	a3,a3,127
    80000304:	97b6                	add	a5,a5,a3
    80000306:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000030a:	47a9                	li	a5,10
    8000030c:	0cf48563          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000310:	4791                	li	a5,4
    80000312:	0cf48263          	beq	s1,a5,800003d6 <consoleintr+0x164>
    80000316:	00012797          	auipc	a5,0x12
    8000031a:	0f27a783          	lw	a5,242(a5) # 80012408 <cons+0x98>
    8000031e:	9f1d                	subw	a4,a4,a5
    80000320:	08000793          	li	a5,128
    80000324:	f8f710e3          	bne	a4,a5,800002a4 <consoleintr+0x32>
    80000328:	a07d                	j	800003d6 <consoleintr+0x164>
    8000032a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000032c:	00012717          	auipc	a4,0x12
    80000330:	04470713          	addi	a4,a4,68 # 80012370 <cons>
    80000334:	0a072783          	lw	a5,160(a4)
    80000338:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000033c:	00012497          	auipc	s1,0x12
    80000340:	03448493          	addi	s1,s1,52 # 80012370 <cons>
    while(cons.e != cons.w &&
    80000344:	4929                	li	s2,10
    80000346:	02f70863          	beq	a4,a5,80000376 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000034a:	37fd                	addiw	a5,a5,-1
    8000034c:	07f7f713          	andi	a4,a5,127
    80000350:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000352:	01874703          	lbu	a4,24(a4)
    80000356:	03270263          	beq	a4,s2,8000037a <consoleintr+0x108>
      cons.e--;
    8000035a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000035e:	10000513          	li	a0,256
    80000362:	edfff0ef          	jal	80000240 <consputc>
    while(cons.e != cons.w &&
    80000366:	0a04a783          	lw	a5,160(s1)
    8000036a:	09c4a703          	lw	a4,156(s1)
    8000036e:	fcf71ee3          	bne	a4,a5,8000034a <consoleintr+0xd8>
    80000372:	6902                	ld	s2,0(sp)
    80000374:	bf05                	j	800002a4 <consoleintr+0x32>
    80000376:	6902                	ld	s2,0(sp)
    80000378:	b735                	j	800002a4 <consoleintr+0x32>
    8000037a:	6902                	ld	s2,0(sp)
    8000037c:	b725                	j	800002a4 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000037e:	00012717          	auipc	a4,0x12
    80000382:	ff270713          	addi	a4,a4,-14 # 80012370 <cons>
    80000386:	0a072783          	lw	a5,160(a4)
    8000038a:	09c72703          	lw	a4,156(a4)
    8000038e:	f0f70be3          	beq	a4,a5,800002a4 <consoleintr+0x32>
      cons.e--;
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	00012717          	auipc	a4,0x12
    80000398:	06f72e23          	sw	a5,124(a4) # 80012410 <cons+0xa0>
      consputc(BACKSPACE);
    8000039c:	10000513          	li	a0,256
    800003a0:	ea1ff0ef          	jal	80000240 <consputc>
    800003a4:	b701                	j	800002a4 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003a6:	ee048fe3          	beqz	s1,800002a4 <consoleintr+0x32>
    800003aa:	bf21                	j	800002c2 <consoleintr+0x50>
      consputc(c);
    800003ac:	4529                	li	a0,10
    800003ae:	e93ff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003b2:	00012797          	auipc	a5,0x12
    800003b6:	fbe78793          	addi	a5,a5,-66 # 80012370 <cons>
    800003ba:	0a07a703          	lw	a4,160(a5)
    800003be:	0017069b          	addiw	a3,a4,1
    800003c2:	0006861b          	sext.w	a2,a3
    800003c6:	0ad7a023          	sw	a3,160(a5)
    800003ca:	07f77713          	andi	a4,a4,127
    800003ce:	97ba                	add	a5,a5,a4
    800003d0:	4729                	li	a4,10
    800003d2:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800003d6:	00012797          	auipc	a5,0x12
    800003da:	02c7ab23          	sw	a2,54(a5) # 8001240c <cons+0x9c>
        wakeup(&cons.r);
    800003de:	00012517          	auipc	a0,0x12
    800003e2:	02a50513          	addi	a0,a0,42 # 80012408 <cons+0x98>
    800003e6:	3d3010ef          	jal	80001fb8 <wakeup>
    800003ea:	bd6d                	j	800002a4 <consoleintr+0x32>

00000000800003ec <consoleinit>:

void
consoleinit(void)
{
    800003ec:	1141                	addi	sp,sp,-16
    800003ee:	e406                	sd	ra,8(sp)
    800003f0:	e022                	sd	s0,0(sp)
    800003f2:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800003f4:	00007597          	auipc	a1,0x7
    800003f8:	c0c58593          	addi	a1,a1,-1012 # 80007000 <etext>
    800003fc:	00012517          	auipc	a0,0x12
    80000400:	f7450513          	addi	a0,a0,-140 # 80012370 <cons>
    80000404:	770000ef          	jal	80000b74 <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	00023797          	auipc	a5,0x23
    80000410:	afc78793          	addi	a5,a5,-1284 # 80022f08 <devsw>
    80000414:	00000717          	auipc	a4,0x0
    80000418:	d2270713          	addi	a4,a4,-734 # 80000136 <consoleread>
    8000041c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000041e:	00000717          	auipc	a4,0x0
    80000422:	cb270713          	addi	a4,a4,-846 # 800000d0 <consolewrite>
    80000426:	ef98                	sd	a4,24(a5)
}
    80000428:	60a2                	ld	ra,8(sp)
    8000042a:	6402                	ld	s0,0(sp)
    8000042c:	0141                	addi	sp,sp,16
    8000042e:	8082                	ret

0000000080000430 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000430:	7179                	addi	sp,sp,-48
    80000432:	f406                	sd	ra,40(sp)
    80000434:	f022                	sd	s0,32(sp)
    80000436:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80000438:	c219                	beqz	a2,8000043e <printint+0xe>
    8000043a:	08054063          	bltz	a0,800004ba <printint+0x8a>
    x = -xx;
  else
    x = xx;
    8000043e:	4881                	li	a7,0
    80000440:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000444:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000446:	00007617          	auipc	a2,0x7
    8000044a:	33a60613          	addi	a2,a2,826 # 80007780 <digits>
    8000044e:	883e                	mv	a6,a5
    80000450:	2785                	addiw	a5,a5,1
    80000452:	02b57733          	remu	a4,a0,a1
    80000456:	9732                	add	a4,a4,a2
    80000458:	00074703          	lbu	a4,0(a4)
    8000045c:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000460:	872a                	mv	a4,a0
    80000462:	02b55533          	divu	a0,a0,a1
    80000466:	0685                	addi	a3,a3,1
    80000468:	feb773e3          	bgeu	a4,a1,8000044e <printint+0x1e>

  if(sign)
    8000046c:	00088a63          	beqz	a7,80000480 <printint+0x50>
    buf[i++] = '-';
    80000470:	1781                	addi	a5,a5,-32
    80000472:	97a2                	add	a5,a5,s0
    80000474:	02d00713          	li	a4,45
    80000478:	fee78823          	sb	a4,-16(a5)
    8000047c:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    80000480:	02f05963          	blez	a5,800004b2 <printint+0x82>
    80000484:	ec26                	sd	s1,24(sp)
    80000486:	e84a                	sd	s2,16(sp)
    80000488:	fd040713          	addi	a4,s0,-48
    8000048c:	00f704b3          	add	s1,a4,a5
    80000490:	fff70913          	addi	s2,a4,-1
    80000494:	993e                	add	s2,s2,a5
    80000496:	37fd                	addiw	a5,a5,-1
    80000498:	1782                	slli	a5,a5,0x20
    8000049a:	9381                	srli	a5,a5,0x20
    8000049c:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004a0:	fff4c503          	lbu	a0,-1(s1)
    800004a4:	d9dff0ef          	jal	80000240 <consputc>
  while(--i >= 0)
    800004a8:	14fd                	addi	s1,s1,-1
    800004aa:	ff249be3          	bne	s1,s2,800004a0 <printint+0x70>
    800004ae:	64e2                	ld	s1,24(sp)
    800004b0:	6942                	ld	s2,16(sp)
}
    800004b2:	70a2                	ld	ra,40(sp)
    800004b4:	7402                	ld	s0,32(sp)
    800004b6:	6145                	addi	sp,sp,48
    800004b8:	8082                	ret
    x = -xx;
    800004ba:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004be:	4885                	li	a7,1
    x = -xx;
    800004c0:	b741                	j	80000440 <printint+0x10>

00000000800004c2 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004c2:	7155                	addi	sp,sp,-208
    800004c4:	e506                	sd	ra,136(sp)
    800004c6:	e122                	sd	s0,128(sp)
    800004c8:	f0d2                	sd	s4,96(sp)
    800004ca:	0900                	addi	s0,sp,144
    800004cc:	8a2a                	mv	s4,a0
    800004ce:	e40c                	sd	a1,8(s0)
    800004d0:	e810                	sd	a2,16(s0)
    800004d2:	ec14                	sd	a3,24(s0)
    800004d4:	f018                	sd	a4,32(s0)
    800004d6:	f41c                	sd	a5,40(s0)
    800004d8:	03043823          	sd	a6,48(s0)
    800004dc:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800004e0:	00012797          	auipc	a5,0x12
    800004e4:	f507a783          	lw	a5,-176(a5) # 80012430 <pr+0x18>
    800004e8:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    800004ec:	e3a1                	bnez	a5,8000052c <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800004ee:	00840793          	addi	a5,s0,8
    800004f2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800004f6:	00054503          	lbu	a0,0(a0)
    800004fa:	26050763          	beqz	a0,80000768 <printf+0x2a6>
    800004fe:	fca6                	sd	s1,120(sp)
    80000500:	f8ca                	sd	s2,112(sp)
    80000502:	f4ce                	sd	s3,104(sp)
    80000504:	ecd6                	sd	s5,88(sp)
    80000506:	e8da                	sd	s6,80(sp)
    80000508:	e0e2                	sd	s8,64(sp)
    8000050a:	fc66                	sd	s9,56(sp)
    8000050c:	f86a                	sd	s10,48(sp)
    8000050e:	f46e                	sd	s11,40(sp)
    80000510:	4981                	li	s3,0
    if(cx != '%'){
    80000512:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000516:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000051a:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000051e:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000522:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000526:	07000d93          	li	s11,112
    8000052a:	a815                	j	8000055e <printf+0x9c>
    acquire(&pr.lock);
    8000052c:	00012517          	auipc	a0,0x12
    80000530:	eec50513          	addi	a0,a0,-276 # 80012418 <pr>
    80000534:	6c0000ef          	jal	80000bf4 <acquire>
  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000540:	000a4503          	lbu	a0,0(s4)
    80000544:	fd4d                	bnez	a0,800004fe <printf+0x3c>
    80000546:	a481                	j	80000786 <printf+0x2c4>
      consputc(cx);
    80000548:	cf9ff0ef          	jal	80000240 <consputc>
      continue;
    8000054c:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000054e:	0014899b          	addiw	s3,s1,1
    80000552:	013a07b3          	add	a5,s4,s3
    80000556:	0007c503          	lbu	a0,0(a5)
    8000055a:	1e050b63          	beqz	a0,80000750 <printf+0x28e>
    if(cx != '%'){
    8000055e:	ff5515e3          	bne	a0,s5,80000548 <printf+0x86>
    i++;
    80000562:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000566:	009a07b3          	add	a5,s4,s1
    8000056a:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    8000056e:	1e090163          	beqz	s2,80000750 <printf+0x28e>
    80000572:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    80000576:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    80000578:	c789                	beqz	a5,80000582 <printf+0xc0>
    8000057a:	009a0733          	add	a4,s4,s1
    8000057e:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    80000582:	03690763          	beq	s2,s6,800005b0 <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    80000586:	05890163          	beq	s2,s8,800005c8 <printf+0x106>
    } else if(c0 == 'u'){
    8000058a:	0d990b63          	beq	s2,s9,80000660 <printf+0x19e>
    } else if(c0 == 'x'){
    8000058e:	13a90163          	beq	s2,s10,800006b0 <printf+0x1ee>
    } else if(c0 == 'p'){
    80000592:	13b90b63          	beq	s2,s11,800006c8 <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    80000596:	07300793          	li	a5,115
    8000059a:	16f90a63          	beq	s2,a5,8000070e <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    8000059e:	1b590463          	beq	s2,s5,80000746 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005a2:	8556                	mv	a0,s5
    800005a4:	c9dff0ef          	jal	80000240 <consputc>
      consputc(c0);
    800005a8:	854a                	mv	a0,s2
    800005aa:	c97ff0ef          	jal	80000240 <consputc>
    800005ae:	b745                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005b0:	f8843783          	ld	a5,-120(s0)
    800005b4:	00878713          	addi	a4,a5,8
    800005b8:	f8e43423          	sd	a4,-120(s0)
    800005bc:	4605                	li	a2,1
    800005be:	45a9                	li	a1,10
    800005c0:	4388                	lw	a0,0(a5)
    800005c2:	e6fff0ef          	jal	80000430 <printint>
    800005c6:	b761                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005c8:	03678663          	beq	a5,s6,800005f4 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005cc:	05878263          	beq	a5,s8,80000610 <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    800005d0:	0b978463          	beq	a5,s9,80000678 <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    800005d4:	fda797e3          	bne	a5,s10,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    800005d8:	f8843783          	ld	a5,-120(s0)
    800005dc:	00878713          	addi	a4,a5,8
    800005e0:	f8e43423          	sd	a4,-120(s0)
    800005e4:	4601                	li	a2,0
    800005e6:	45c1                	li	a1,16
    800005e8:	6388                	ld	a0,0(a5)
    800005ea:	e47ff0ef          	jal	80000430 <printint>
      i += 1;
    800005ee:	0029849b          	addiw	s1,s3,2
    800005f2:	bfb1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800005f4:	f8843783          	ld	a5,-120(s0)
    800005f8:	00878713          	addi	a4,a5,8
    800005fc:	f8e43423          	sd	a4,-120(s0)
    80000600:	4605                	li	a2,1
    80000602:	45a9                	li	a1,10
    80000604:	6388                	ld	a0,0(a5)
    80000606:	e2bff0ef          	jal	80000430 <printint>
      i += 1;
    8000060a:	0029849b          	addiw	s1,s3,2
    8000060e:	b781                	j	8000054e <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000610:	06400793          	li	a5,100
    80000614:	02f68863          	beq	a3,a5,80000644 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80000618:	07500793          	li	a5,117
    8000061c:	06f68c63          	beq	a3,a5,80000694 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000620:	07800793          	li	a5,120
    80000624:	f6f69fe3          	bne	a3,a5,800005a2 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    80000628:	f8843783          	ld	a5,-120(s0)
    8000062c:	00878713          	addi	a4,a5,8
    80000630:	f8e43423          	sd	a4,-120(s0)
    80000634:	4601                	li	a2,0
    80000636:	45c1                	li	a1,16
    80000638:	6388                	ld	a0,0(a5)
    8000063a:	df7ff0ef          	jal	80000430 <printint>
      i += 2;
    8000063e:	0039849b          	addiw	s1,s3,3
    80000642:	b731                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000644:	f8843783          	ld	a5,-120(s0)
    80000648:	00878713          	addi	a4,a5,8
    8000064c:	f8e43423          	sd	a4,-120(s0)
    80000650:	4605                	li	a2,1
    80000652:	45a9                	li	a1,10
    80000654:	6388                	ld	a0,0(a5)
    80000656:	ddbff0ef          	jal	80000430 <printint>
      i += 2;
    8000065a:	0039849b          	addiw	s1,s3,3
    8000065e:	bdc5                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80000660:	f8843783          	ld	a5,-120(s0)
    80000664:	00878713          	addi	a4,a5,8
    80000668:	f8e43423          	sd	a4,-120(s0)
    8000066c:	4601                	li	a2,0
    8000066e:	45a9                	li	a1,10
    80000670:	4388                	lw	a0,0(a5)
    80000672:	dbfff0ef          	jal	80000430 <printint>
    80000676:	bde1                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000678:	f8843783          	ld	a5,-120(s0)
    8000067c:	00878713          	addi	a4,a5,8
    80000680:	f8e43423          	sd	a4,-120(s0)
    80000684:	4601                	li	a2,0
    80000686:	45a9                	li	a1,10
    80000688:	6388                	ld	a0,0(a5)
    8000068a:	da7ff0ef          	jal	80000430 <printint>
      i += 1;
    8000068e:	0029849b          	addiw	s1,s3,2
    80000692:	bd75                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    80000694:	f8843783          	ld	a5,-120(s0)
    80000698:	00878713          	addi	a4,a5,8
    8000069c:	f8e43423          	sd	a4,-120(s0)
    800006a0:	4601                	li	a2,0
    800006a2:	45a9                	li	a1,10
    800006a4:	6388                	ld	a0,0(a5)
    800006a6:	d8bff0ef          	jal	80000430 <printint>
      i += 2;
    800006aa:	0039849b          	addiw	s1,s3,3
    800006ae:	b545                	j	8000054e <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006b0:	f8843783          	ld	a5,-120(s0)
    800006b4:	00878713          	addi	a4,a5,8
    800006b8:	f8e43423          	sd	a4,-120(s0)
    800006bc:	4601                	li	a2,0
    800006be:	45c1                	li	a1,16
    800006c0:	4388                	lw	a0,0(a5)
    800006c2:	d6fff0ef          	jal	80000430 <printint>
    800006c6:	b561                	j	8000054e <printf+0x8c>
    800006c8:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006ca:	f8843783          	ld	a5,-120(s0)
    800006ce:	00878713          	addi	a4,a5,8
    800006d2:	f8e43423          	sd	a4,-120(s0)
    800006d6:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006da:	03000513          	li	a0,48
    800006de:	b63ff0ef          	jal	80000240 <consputc>
  consputc('x');
    800006e2:	07800513          	li	a0,120
    800006e6:	b5bff0ef          	jal	80000240 <consputc>
    800006ea:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ec:	00007b97          	auipc	s7,0x7
    800006f0:	094b8b93          	addi	s7,s7,148 # 80007780 <digits>
    800006f4:	03c9d793          	srli	a5,s3,0x3c
    800006f8:	97de                	add	a5,a5,s7
    800006fa:	0007c503          	lbu	a0,0(a5)
    800006fe:	b43ff0ef          	jal	80000240 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000702:	0992                	slli	s3,s3,0x4
    80000704:	397d                	addiw	s2,s2,-1
    80000706:	fe0917e3          	bnez	s2,800006f4 <printf+0x232>
    8000070a:	6ba6                	ld	s7,72(sp)
    8000070c:	b589                	j	8000054e <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    8000070e:	f8843783          	ld	a5,-120(s0)
    80000712:	00878713          	addi	a4,a5,8
    80000716:	f8e43423          	sd	a4,-120(s0)
    8000071a:	0007b903          	ld	s2,0(a5)
    8000071e:	00090d63          	beqz	s2,80000738 <printf+0x276>
      for(; *s; s++)
    80000722:	00094503          	lbu	a0,0(s2)
    80000726:	e20504e3          	beqz	a0,8000054e <printf+0x8c>
        consputc(*s);
    8000072a:	b17ff0ef          	jal	80000240 <consputc>
      for(; *s; s++)
    8000072e:	0905                	addi	s2,s2,1
    80000730:	00094503          	lbu	a0,0(s2)
    80000734:	f97d                	bnez	a0,8000072a <printf+0x268>
    80000736:	bd21                	j	8000054e <printf+0x8c>
        s = "(null)";
    80000738:	00007917          	auipc	s2,0x7
    8000073c:	8d090913          	addi	s2,s2,-1840 # 80007008 <etext+0x8>
      for(; *s; s++)
    80000740:	02800513          	li	a0,40
    80000744:	b7dd                	j	8000072a <printf+0x268>
      consputc('%');
    80000746:	02500513          	li	a0,37
    8000074a:	af7ff0ef          	jal	80000240 <consputc>
    8000074e:	b501                	j	8000054e <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80000750:	f7843783          	ld	a5,-136(s0)
    80000754:	e385                	bnez	a5,80000774 <printf+0x2b2>
    80000756:	74e6                	ld	s1,120(sp)
    80000758:	7946                	ld	s2,112(sp)
    8000075a:	79a6                	ld	s3,104(sp)
    8000075c:	6ae6                	ld	s5,88(sp)
    8000075e:	6b46                	ld	s6,80(sp)
    80000760:	6c06                	ld	s8,64(sp)
    80000762:	7ce2                	ld	s9,56(sp)
    80000764:	7d42                	ld	s10,48(sp)
    80000766:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    80000768:	4501                	li	a0,0
    8000076a:	60aa                	ld	ra,136(sp)
    8000076c:	640a                	ld	s0,128(sp)
    8000076e:	7a06                	ld	s4,96(sp)
    80000770:	6169                	addi	sp,sp,208
    80000772:	8082                	ret
    80000774:	74e6                	ld	s1,120(sp)
    80000776:	7946                	ld	s2,112(sp)
    80000778:	79a6                	ld	s3,104(sp)
    8000077a:	6ae6                	ld	s5,88(sp)
    8000077c:	6b46                	ld	s6,80(sp)
    8000077e:	6c06                	ld	s8,64(sp)
    80000780:	7ce2                	ld	s9,56(sp)
    80000782:	7d42                	ld	s10,48(sp)
    80000784:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80000786:	00012517          	auipc	a0,0x12
    8000078a:	c9250513          	addi	a0,a0,-878 # 80012418 <pr>
    8000078e:	4fe000ef          	jal	80000c8c <release>
    80000792:	bfd9                	j	80000768 <printf+0x2a6>

0000000080000794 <panic>:

void
panic(char *s)
{
    80000794:	1101                	addi	sp,sp,-32
    80000796:	ec06                	sd	ra,24(sp)
    80000798:	e822                	sd	s0,16(sp)
    8000079a:	e426                	sd	s1,8(sp)
    8000079c:	1000                	addi	s0,sp,32
    8000079e:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007a0:	00012797          	auipc	a5,0x12
    800007a4:	c807a823          	sw	zero,-880(a5) # 80012430 <pr+0x18>
  printf("panic: ");
    800007a8:	00007517          	auipc	a0,0x7
    800007ac:	87050513          	addi	a0,a0,-1936 # 80007018 <etext+0x18>
    800007b0:	d13ff0ef          	jal	800004c2 <printf>
  printf("%s\n", s);
    800007b4:	85a6                	mv	a1,s1
    800007b6:	00007517          	auipc	a0,0x7
    800007ba:	86a50513          	addi	a0,a0,-1942 # 80007020 <etext+0x20>
    800007be:	d05ff0ef          	jal	800004c2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007c2:	4785                	li	a5,1
    800007c4:	0000a717          	auipc	a4,0xa
    800007c8:	b6f72623          	sw	a5,-1172(a4) # 8000a330 <panicked>
  for(;;)
    800007cc:	a001                	j	800007cc <panic+0x38>

00000000800007ce <printfinit>:
    ;
}

void
printfinit(void)
{
    800007ce:	1101                	addi	sp,sp,-32
    800007d0:	ec06                	sd	ra,24(sp)
    800007d2:	e822                	sd	s0,16(sp)
    800007d4:	e426                	sd	s1,8(sp)
    800007d6:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007d8:	00012497          	auipc	s1,0x12
    800007dc:	c4048493          	addi	s1,s1,-960 # 80012418 <pr>
    800007e0:	00007597          	auipc	a1,0x7
    800007e4:	84858593          	addi	a1,a1,-1976 # 80007028 <etext+0x28>
    800007e8:	8526                	mv	a0,s1
    800007ea:	38a000ef          	jal	80000b74 <initlock>
  pr.locking = 1;
    800007ee:	4785                	li	a5,1
    800007f0:	cc9c                	sw	a5,24(s1)
}
    800007f2:	60e2                	ld	ra,24(sp)
    800007f4:	6442                	ld	s0,16(sp)
    800007f6:	64a2                	ld	s1,8(sp)
    800007f8:	6105                	addi	sp,sp,32
    800007fa:	8082                	ret

00000000800007fc <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007fc:	1141                	addi	sp,sp,-16
    800007fe:	e406                	sd	ra,8(sp)
    80000800:	e022                	sd	s0,0(sp)
    80000802:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000804:	100007b7          	lui	a5,0x10000
    80000808:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000080c:	10000737          	lui	a4,0x10000
    80000810:	f8000693          	li	a3,-128
    80000814:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000818:	468d                	li	a3,3
    8000081a:	10000637          	lui	a2,0x10000
    8000081e:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000822:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000826:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000082a:	10000737          	lui	a4,0x10000
    8000082e:	461d                	li	a2,7
    80000830:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000834:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000838:	00006597          	auipc	a1,0x6
    8000083c:	7f858593          	addi	a1,a1,2040 # 80007030 <etext+0x30>
    80000840:	00012517          	auipc	a0,0x12
    80000844:	bf850513          	addi	a0,a0,-1032 # 80012438 <uart_tx_lock>
    80000848:	32c000ef          	jal	80000b74 <initlock>
}
    8000084c:	60a2                	ld	ra,8(sp)
    8000084e:	6402                	ld	s0,0(sp)
    80000850:	0141                	addi	sp,sp,16
    80000852:	8082                	ret

0000000080000854 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
    8000085e:	84aa                	mv	s1,a0
  push_off();
    80000860:	354000ef          	jal	80000bb4 <push_off>

  if(panicked){
    80000864:	0000a797          	auipc	a5,0xa
    80000868:	acc7a783          	lw	a5,-1332(a5) # 8000a330 <panicked>
    8000086c:	e795                	bnez	a5,80000898 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000086e:	10000737          	lui	a4,0x10000
    80000872:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000874:	00074783          	lbu	a5,0(a4)
    80000878:	0207f793          	andi	a5,a5,32
    8000087c:	dfe5                	beqz	a5,80000874 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000087e:	0ff4f513          	zext.b	a0,s1
    80000882:	100007b7          	lui	a5,0x10000
    80000886:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088a:	3ae000ef          	jal	80000c38 <pop_off>
}
    8000088e:	60e2                	ld	ra,24(sp)
    80000890:	6442                	ld	s0,16(sp)
    80000892:	64a2                	ld	s1,8(sp)
    80000894:	6105                	addi	sp,sp,32
    80000896:	8082                	ret
    for(;;)
    80000898:	a001                	j	80000898 <uartputc_sync+0x44>

000000008000089a <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000089a:	0000a797          	auipc	a5,0xa
    8000089e:	a9e7b783          	ld	a5,-1378(a5) # 8000a338 <uart_tx_r>
    800008a2:	0000a717          	auipc	a4,0xa
    800008a6:	a9e73703          	ld	a4,-1378(a4) # 8000a340 <uart_tx_w>
    800008aa:	08f70263          	beq	a4,a5,8000092e <uartstart+0x94>
{
    800008ae:	7139                	addi	sp,sp,-64
    800008b0:	fc06                	sd	ra,56(sp)
    800008b2:	f822                	sd	s0,48(sp)
    800008b4:	f426                	sd	s1,40(sp)
    800008b6:	f04a                	sd	s2,32(sp)
    800008b8:	ec4e                	sd	s3,24(sp)
    800008ba:	e852                	sd	s4,16(sp)
    800008bc:	e456                	sd	s5,8(sp)
    800008be:	e05a                	sd	s6,0(sp)
    800008c0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c2:	10000937          	lui	s2,0x10000
    800008c6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008c8:	00012a97          	auipc	s5,0x12
    800008cc:	b70a8a93          	addi	s5,s5,-1168 # 80012438 <uart_tx_lock>
    uart_tx_r += 1;
    800008d0:	0000a497          	auipc	s1,0xa
    800008d4:	a6848493          	addi	s1,s1,-1432 # 8000a338 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008dc:	0000a997          	auipc	s3,0xa
    800008e0:	a6498993          	addi	s3,s3,-1436 # 8000a340 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008e4:	00094703          	lbu	a4,0(s2)
    800008e8:	02077713          	andi	a4,a4,32
    800008ec:	c71d                	beqz	a4,8000091a <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ee:	01f7f713          	andi	a4,a5,31
    800008f2:	9756                	add	a4,a4,s5
    800008f4:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008f8:	0785                	addi	a5,a5,1
    800008fa:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008fc:	8526                	mv	a0,s1
    800008fe:	6ba010ef          	jal	80001fb8 <wakeup>
    WriteReg(THR, c);
    80000902:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000906:	609c                	ld	a5,0(s1)
    80000908:	0009b703          	ld	a4,0(s3)
    8000090c:	fcf71ce3          	bne	a4,a5,800008e4 <uartstart+0x4a>
      ReadReg(ISR);
    80000910:	100007b7          	lui	a5,0x10000
    80000914:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000916:	0007c783          	lbu	a5,0(a5)
  }
}
    8000091a:	70e2                	ld	ra,56(sp)
    8000091c:	7442                	ld	s0,48(sp)
    8000091e:	74a2                	ld	s1,40(sp)
    80000920:	7902                	ld	s2,32(sp)
    80000922:	69e2                	ld	s3,24(sp)
    80000924:	6a42                	ld	s4,16(sp)
    80000926:	6aa2                	ld	s5,8(sp)
    80000928:	6b02                	ld	s6,0(sp)
    8000092a:	6121                	addi	sp,sp,64
    8000092c:	8082                	ret
      ReadReg(ISR);
    8000092e:	100007b7          	lui	a5,0x10000
    80000932:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000934:	0007c783          	lbu	a5,0(a5)
      return;
    80000938:	8082                	ret

000000008000093a <uartputc>:
{
    8000093a:	7179                	addi	sp,sp,-48
    8000093c:	f406                	sd	ra,40(sp)
    8000093e:	f022                	sd	s0,32(sp)
    80000940:	ec26                	sd	s1,24(sp)
    80000942:	e84a                	sd	s2,16(sp)
    80000944:	e44e                	sd	s3,8(sp)
    80000946:	e052                	sd	s4,0(sp)
    80000948:	1800                	addi	s0,sp,48
    8000094a:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000094c:	00012517          	auipc	a0,0x12
    80000950:	aec50513          	addi	a0,a0,-1300 # 80012438 <uart_tx_lock>
    80000954:	2a0000ef          	jal	80000bf4 <acquire>
  if(panicked){
    80000958:	0000a797          	auipc	a5,0xa
    8000095c:	9d87a783          	lw	a5,-1576(a5) # 8000a330 <panicked>
    80000960:	efbd                	bnez	a5,800009de <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	0000a717          	auipc	a4,0xa
    80000966:	9de73703          	ld	a4,-1570(a4) # 8000a340 <uart_tx_w>
    8000096a:	0000a797          	auipc	a5,0xa
    8000096e:	9ce7b783          	ld	a5,-1586(a5) # 8000a338 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	00012997          	auipc	s3,0x12
    8000097a:	ac298993          	addi	s3,s3,-1342 # 80012438 <uart_tx_lock>
    8000097e:	0000a497          	auipc	s1,0xa
    80000982:	9ba48493          	addi	s1,s1,-1606 # 8000a338 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	0000a917          	auipc	s2,0xa
    8000098a:	9ba90913          	addi	s2,s2,-1606 # 8000a340 <uart_tx_w>
    8000098e:	00e79d63          	bne	a5,a4,800009a8 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	5d6010ef          	jal	80001f6c <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099a:	00093703          	ld	a4,0(s2)
    8000099e:	609c                	ld	a5,0(s1)
    800009a0:	02078793          	addi	a5,a5,32
    800009a4:	fee787e3          	beq	a5,a4,80000992 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a8:	00012497          	auipc	s1,0x12
    800009ac:	a9048493          	addi	s1,s1,-1392 # 80012438 <uart_tx_lock>
    800009b0:	01f77793          	andi	a5,a4,31
    800009b4:	97a6                	add	a5,a5,s1
    800009b6:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ba:	0705                	addi	a4,a4,1
    800009bc:	0000a797          	auipc	a5,0xa
    800009c0:	98e7b223          	sd	a4,-1660(a5) # 8000a340 <uart_tx_w>
  uartstart();
    800009c4:	ed7ff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    800009c8:	8526                	mv	a0,s1
    800009ca:	2c2000ef          	jal	80000c8c <release>
}
    800009ce:	70a2                	ld	ra,40(sp)
    800009d0:	7402                	ld	s0,32(sp)
    800009d2:	64e2                	ld	s1,24(sp)
    800009d4:	6942                	ld	s2,16(sp)
    800009d6:	69a2                	ld	s3,8(sp)
    800009d8:	6a02                	ld	s4,0(sp)
    800009da:	6145                	addi	sp,sp,48
    800009dc:	8082                	ret
    for(;;)
    800009de:	a001                	j	800009de <uartputc+0xa4>

00000000800009e0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009e0:	1141                	addi	sp,sp,-16
    800009e2:	e422                	sd	s0,8(sp)
    800009e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009e6:	100007b7          	lui	a5,0x10000
    800009ea:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    800009ec:	0007c783          	lbu	a5,0(a5)
    800009f0:	8b85                	andi	a5,a5,1
    800009f2:	cb81                	beqz	a5,80000a02 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    800009f4:	100007b7          	lui	a5,0x10000
    800009f8:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009fc:	6422                	ld	s0,8(sp)
    800009fe:	0141                	addi	sp,sp,16
    80000a00:	8082                	ret
    return -1;
    80000a02:	557d                	li	a0,-1
    80000a04:	bfe5                	j	800009fc <uartgetc+0x1c>

0000000080000a06 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a06:	1101                	addi	sp,sp,-32
    80000a08:	ec06                	sd	ra,24(sp)
    80000a0a:	e822                	sd	s0,16(sp)
    80000a0c:	e426                	sd	s1,8(sp)
    80000a0e:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a10:	54fd                	li	s1,-1
    80000a12:	a019                	j	80000a18 <uartintr+0x12>
      break;
    consoleintr(c);
    80000a14:	85fff0ef          	jal	80000272 <consoleintr>
    int c = uartgetc();
    80000a18:	fc9ff0ef          	jal	800009e0 <uartgetc>
    if(c == -1)
    80000a1c:	fe951ce3          	bne	a0,s1,80000a14 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a20:	00012497          	auipc	s1,0x12
    80000a24:	a1848493          	addi	s1,s1,-1512 # 80012438 <uart_tx_lock>
    80000a28:	8526                	mv	a0,s1
    80000a2a:	1ca000ef          	jal	80000bf4 <acquire>
  uartstart();
    80000a2e:	e6dff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    80000a32:	8526                	mv	a0,s1
    80000a34:	258000ef          	jal	80000c8c <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6105                	addi	sp,sp,32
    80000a40:	8082                	ret

0000000080000a42 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a42:	1101                	addi	sp,sp,-32
    80000a44:	ec06                	sd	ra,24(sp)
    80000a46:	e822                	sd	s0,16(sp)
    80000a48:	e426                	sd	s1,8(sp)
    80000a4a:	e04a                	sd	s2,0(sp)
    80000a4c:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a4e:	03451793          	slli	a5,a0,0x34
    80000a52:	e7a9                	bnez	a5,80000a9c <kfree+0x5a>
    80000a54:	84aa                	mv	s1,a0
    80000a56:	00023797          	auipc	a5,0x23
    80000a5a:	64a78793          	addi	a5,a5,1610 # 800240a0 <end>
    80000a5e:	02f56f63          	bltu	a0,a5,80000a9c <kfree+0x5a>
    80000a62:	47c5                	li	a5,17
    80000a64:	07ee                	slli	a5,a5,0x1b
    80000a66:	02f57b63          	bgeu	a0,a5,80000a9c <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a6a:	6605                	lui	a2,0x1
    80000a6c:	4585                	li	a1,1
    80000a6e:	25a000ef          	jal	80000cc8 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a72:	00012917          	auipc	s2,0x12
    80000a76:	9fe90913          	addi	s2,s2,-1538 # 80012470 <kmem>
    80000a7a:	854a                	mv	a0,s2
    80000a7c:	178000ef          	jal	80000bf4 <acquire>
  r->next = kmem.freelist;
    80000a80:	01893783          	ld	a5,24(s2)
    80000a84:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a86:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a8a:	854a                	mv	a0,s2
    80000a8c:	200000ef          	jal	80000c8c <release>
}
    80000a90:	60e2                	ld	ra,24(sp)
    80000a92:	6442                	ld	s0,16(sp)
    80000a94:	64a2                	ld	s1,8(sp)
    80000a96:	6902                	ld	s2,0(sp)
    80000a98:	6105                	addi	sp,sp,32
    80000a9a:	8082                	ret
    panic("kfree");
    80000a9c:	00006517          	auipc	a0,0x6
    80000aa0:	59c50513          	addi	a0,a0,1436 # 80007038 <etext+0x38>
    80000aa4:	cf1ff0ef          	jal	80000794 <panic>

0000000080000aa8 <freerange>:
{
    80000aa8:	7179                	addi	sp,sp,-48
    80000aaa:	f406                	sd	ra,40(sp)
    80000aac:	f022                	sd	s0,32(sp)
    80000aae:	ec26                	sd	s1,24(sp)
    80000ab0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ab2:	6785                	lui	a5,0x1
    80000ab4:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab8:	00e504b3          	add	s1,a0,a4
    80000abc:	777d                	lui	a4,0xfffff
    80000abe:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ac0:	94be                	add	s1,s1,a5
    80000ac2:	0295e263          	bltu	a1,s1,80000ae6 <freerange+0x3e>
    80000ac6:	e84a                	sd	s2,16(sp)
    80000ac8:	e44e                	sd	s3,8(sp)
    80000aca:	e052                	sd	s4,0(sp)
    80000acc:	892e                	mv	s2,a1
    kfree(p);
    80000ace:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ad0:	6985                	lui	s3,0x1
    kfree(p);
    80000ad2:	01448533          	add	a0,s1,s4
    80000ad6:	f6dff0ef          	jal	80000a42 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ada:	94ce                	add	s1,s1,s3
    80000adc:	fe997be3          	bgeu	s2,s1,80000ad2 <freerange+0x2a>
    80000ae0:	6942                	ld	s2,16(sp)
    80000ae2:	69a2                	ld	s3,8(sp)
    80000ae4:	6a02                	ld	s4,0(sp)
}
    80000ae6:	70a2                	ld	ra,40(sp)
    80000ae8:	7402                	ld	s0,32(sp)
    80000aea:	64e2                	ld	s1,24(sp)
    80000aec:	6145                	addi	sp,sp,48
    80000aee:	8082                	ret

0000000080000af0 <kinit>:
{
    80000af0:	1141                	addi	sp,sp,-16
    80000af2:	e406                	sd	ra,8(sp)
    80000af4:	e022                	sd	s0,0(sp)
    80000af6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af8:	00006597          	auipc	a1,0x6
    80000afc:	54858593          	addi	a1,a1,1352 # 80007040 <etext+0x40>
    80000b00:	00012517          	auipc	a0,0x12
    80000b04:	97050513          	addi	a0,a0,-1680 # 80012470 <kmem>
    80000b08:	06c000ef          	jal	80000b74 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b0c:	45c5                	li	a1,17
    80000b0e:	05ee                	slli	a1,a1,0x1b
    80000b10:	00023517          	auipc	a0,0x23
    80000b14:	59050513          	addi	a0,a0,1424 # 800240a0 <end>
    80000b18:	f91ff0ef          	jal	80000aa8 <freerange>
}
    80000b1c:	60a2                	ld	ra,8(sp)
    80000b1e:	6402                	ld	s0,0(sp)
    80000b20:	0141                	addi	sp,sp,16
    80000b22:	8082                	ret

0000000080000b24 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b24:	1101                	addi	sp,sp,-32
    80000b26:	ec06                	sd	ra,24(sp)
    80000b28:	e822                	sd	s0,16(sp)
    80000b2a:	e426                	sd	s1,8(sp)
    80000b2c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b2e:	00012497          	auipc	s1,0x12
    80000b32:	94248493          	addi	s1,s1,-1726 # 80012470 <kmem>
    80000b36:	8526                	mv	a0,s1
    80000b38:	0bc000ef          	jal	80000bf4 <acquire>
  r = kmem.freelist;
    80000b3c:	6c84                	ld	s1,24(s1)
  if(r)
    80000b3e:	c485                	beqz	s1,80000b66 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b40:	609c                	ld	a5,0(s1)
    80000b42:	00012517          	auipc	a0,0x12
    80000b46:	92e50513          	addi	a0,a0,-1746 # 80012470 <kmem>
    80000b4a:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b4c:	140000ef          	jal	80000c8c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b50:	6605                	lui	a2,0x1
    80000b52:	4595                	li	a1,5
    80000b54:	8526                	mv	a0,s1
    80000b56:	172000ef          	jal	80000cc8 <memset>
  return (void*)r;
}
    80000b5a:	8526                	mv	a0,s1
    80000b5c:	60e2                	ld	ra,24(sp)
    80000b5e:	6442                	ld	s0,16(sp)
    80000b60:	64a2                	ld	s1,8(sp)
    80000b62:	6105                	addi	sp,sp,32
    80000b64:	8082                	ret
  release(&kmem.lock);
    80000b66:	00012517          	auipc	a0,0x12
    80000b6a:	90a50513          	addi	a0,a0,-1782 # 80012470 <kmem>
    80000b6e:	11e000ef          	jal	80000c8c <release>
  if(r)
    80000b72:	b7e5                	j	80000b5a <kalloc+0x36>

0000000080000b74 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b74:	1141                	addi	sp,sp,-16
    80000b76:	e422                	sd	s0,8(sp)
    80000b78:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b7a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b7c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b80:	00053823          	sd	zero,16(a0)
}
    80000b84:	6422                	ld	s0,8(sp)
    80000b86:	0141                	addi	sp,sp,16
    80000b88:	8082                	ret

0000000080000b8a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b8a:	411c                	lw	a5,0(a0)
    80000b8c:	e399                	bnez	a5,80000b92 <holding+0x8>
    80000b8e:	4501                	li	a0,0
  return r;
}
    80000b90:	8082                	ret
{
    80000b92:	1101                	addi	sp,sp,-32
    80000b94:	ec06                	sd	ra,24(sp)
    80000b96:	e822                	sd	s0,16(sp)
    80000b98:	e426                	sd	s1,8(sp)
    80000b9a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000b9c:	6904                	ld	s1,16(a0)
    80000b9e:	55d000ef          	jal	800018fa <mycpu>
    80000ba2:	40a48533          	sub	a0,s1,a0
    80000ba6:	00153513          	seqz	a0,a0
}
    80000baa:	60e2                	ld	ra,24(sp)
    80000bac:	6442                	ld	s0,16(sp)
    80000bae:	64a2                	ld	s1,8(sp)
    80000bb0:	6105                	addi	sp,sp,32
    80000bb2:	8082                	ret

0000000080000bb4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bb4:	1101                	addi	sp,sp,-32
    80000bb6:	ec06                	sd	ra,24(sp)
    80000bb8:	e822                	sd	s0,16(sp)
    80000bba:	e426                	sd	s1,8(sp)
    80000bbc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bbe:	100024f3          	csrr	s1,sstatus
    80000bc2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bc6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bc8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bcc:	52f000ef          	jal	800018fa <mycpu>
    80000bd0:	5d3c                	lw	a5,120(a0)
    80000bd2:	cb99                	beqz	a5,80000be8 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd4:	527000ef          	jal	800018fa <mycpu>
    80000bd8:	5d3c                	lw	a5,120(a0)
    80000bda:	2785                	addiw	a5,a5,1
    80000bdc:	dd3c                	sw	a5,120(a0)
}
    80000bde:	60e2                	ld	ra,24(sp)
    80000be0:	6442                	ld	s0,16(sp)
    80000be2:	64a2                	ld	s1,8(sp)
    80000be4:	6105                	addi	sp,sp,32
    80000be6:	8082                	ret
    mycpu()->intena = old;
    80000be8:	513000ef          	jal	800018fa <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000bec:	8085                	srli	s1,s1,0x1
    80000bee:	8885                	andi	s1,s1,1
    80000bf0:	dd64                	sw	s1,124(a0)
    80000bf2:	b7cd                	j	80000bd4 <push_off+0x20>

0000000080000bf4 <acquire>:
{
    80000bf4:	1101                	addi	sp,sp,-32
    80000bf6:	ec06                	sd	ra,24(sp)
    80000bf8:	e822                	sd	s0,16(sp)
    80000bfa:	e426                	sd	s1,8(sp)
    80000bfc:	1000                	addi	s0,sp,32
    80000bfe:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c00:	fb5ff0ef          	jal	80000bb4 <push_off>
  if(holding(lk)) 
    80000c04:	8526                	mv	a0,s1
    80000c06:	f85ff0ef          	jal	80000b8a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0a:	4705                	li	a4,1
  if(holding(lk)) 
    80000c0c:	e105                	bnez	a0,80000c2c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c0e:	87ba                	mv	a5,a4
    80000c10:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c14:	2781                	sext.w	a5,a5
    80000c16:	ffe5                	bnez	a5,80000c0e <acquire+0x1a>
  __sync_synchronize();
    80000c18:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c1c:	4df000ef          	jal	800018fa <mycpu>
    80000c20:	e888                	sd	a0,16(s1)
}
    80000c22:	60e2                	ld	ra,24(sp)
    80000c24:	6442                	ld	s0,16(sp)
    80000c26:	64a2                	ld	s1,8(sp)
    80000c28:	6105                	addi	sp,sp,32
    80000c2a:	8082                	ret
    panic("acquire");
    80000c2c:	00006517          	auipc	a0,0x6
    80000c30:	41c50513          	addi	a0,a0,1052 # 80007048 <etext+0x48>
    80000c34:	b61ff0ef          	jal	80000794 <panic>

0000000080000c38 <pop_off>:

void
pop_off(void)
{
    80000c38:	1141                	addi	sp,sp,-16
    80000c3a:	e406                	sd	ra,8(sp)
    80000c3c:	e022                	sd	s0,0(sp)
    80000c3e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c40:	4bb000ef          	jal	800018fa <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c48:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c4a:	e78d                	bnez	a5,80000c74 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c4c:	5d3c                	lw	a5,120(a0)
    80000c4e:	02f05963          	blez	a5,80000c80 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c52:	37fd                	addiw	a5,a5,-1
    80000c54:	0007871b          	sext.w	a4,a5
    80000c58:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c5a:	eb09                	bnez	a4,80000c6c <pop_off+0x34>
    80000c5c:	5d7c                	lw	a5,124(a0)
    80000c5e:	c799                	beqz	a5,80000c6c <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c68:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c6c:	60a2                	ld	ra,8(sp)
    80000c6e:	6402                	ld	s0,0(sp)
    80000c70:	0141                	addi	sp,sp,16
    80000c72:	8082                	ret
    panic("pop_off - interruptible");
    80000c74:	00006517          	auipc	a0,0x6
    80000c78:	3dc50513          	addi	a0,a0,988 # 80007050 <etext+0x50>
    80000c7c:	b19ff0ef          	jal	80000794 <panic>
    panic("pop_off");
    80000c80:	00006517          	auipc	a0,0x6
    80000c84:	3e850513          	addi	a0,a0,1000 # 80007068 <etext+0x68>
    80000c88:	b0dff0ef          	jal	80000794 <panic>

0000000080000c8c <release>:
{
    80000c8c:	1101                	addi	sp,sp,-32
    80000c8e:	ec06                	sd	ra,24(sp)
    80000c90:	e822                	sd	s0,16(sp)
    80000c92:	e426                	sd	s1,8(sp)
    80000c94:	1000                	addi	s0,sp,32
    80000c96:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000c98:	ef3ff0ef          	jal	80000b8a <holding>
    80000c9c:	c105                	beqz	a0,80000cbc <release+0x30>
  lk->cpu = 0;
    80000c9e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000ca2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000ca6:	0310000f          	fence	rw,w
    80000caa:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cae:	f8bff0ef          	jal	80000c38 <pop_off>
}
    80000cb2:	60e2                	ld	ra,24(sp)
    80000cb4:	6442                	ld	s0,16(sp)
    80000cb6:	64a2                	ld	s1,8(sp)
    80000cb8:	6105                	addi	sp,sp,32
    80000cba:	8082                	ret
    panic("release");
    80000cbc:	00006517          	auipc	a0,0x6
    80000cc0:	3b450513          	addi	a0,a0,948 # 80007070 <etext+0x70>
    80000cc4:	ad1ff0ef          	jal	80000794 <panic>

0000000080000cc8 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cc8:	1141                	addi	sp,sp,-16
    80000cca:	e422                	sd	s0,8(sp)
    80000ccc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000cce:	ca19                	beqz	a2,80000ce4 <memset+0x1c>
    80000cd0:	87aa                	mv	a5,a0
    80000cd2:	1602                	slli	a2,a2,0x20
    80000cd4:	9201                	srli	a2,a2,0x20
    80000cd6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cda:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000cde:	0785                	addi	a5,a5,1
    80000ce0:	fee79de3          	bne	a5,a4,80000cda <memset+0x12>
  }
  return dst;
}
    80000ce4:	6422                	ld	s0,8(sp)
    80000ce6:	0141                	addi	sp,sp,16
    80000ce8:	8082                	ret

0000000080000cea <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cea:	1141                	addi	sp,sp,-16
    80000cec:	e422                	sd	s0,8(sp)
    80000cee:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000cf0:	ca05                	beqz	a2,80000d20 <memcmp+0x36>
    80000cf2:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000cf6:	1682                	slli	a3,a3,0x20
    80000cf8:	9281                	srli	a3,a3,0x20
    80000cfa:	0685                	addi	a3,a3,1
    80000cfc:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000cfe:	00054783          	lbu	a5,0(a0)
    80000d02:	0005c703          	lbu	a4,0(a1)
    80000d06:	00e79863          	bne	a5,a4,80000d16 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d0a:	0505                	addi	a0,a0,1
    80000d0c:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d0e:	fed518e3          	bne	a0,a3,80000cfe <memcmp+0x14>
  }

  return 0;
    80000d12:	4501                	li	a0,0
    80000d14:	a019                	j	80000d1a <memcmp+0x30>
      return *s1 - *s2;
    80000d16:	40e7853b          	subw	a0,a5,a4
}
    80000d1a:	6422                	ld	s0,8(sp)
    80000d1c:	0141                	addi	sp,sp,16
    80000d1e:	8082                	ret
  return 0;
    80000d20:	4501                	li	a0,0
    80000d22:	bfe5                	j	80000d1a <memcmp+0x30>

0000000080000d24 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d24:	1141                	addi	sp,sp,-16
    80000d26:	e422                	sd	s0,8(sp)
    80000d28:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d2a:	c205                	beqz	a2,80000d4a <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d2c:	02a5e263          	bltu	a1,a0,80000d50 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d30:	1602                	slli	a2,a2,0x20
    80000d32:	9201                	srli	a2,a2,0x20
    80000d34:	00c587b3          	add	a5,a1,a2
{
    80000d38:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d3a:	0585                	addi	a1,a1,1
    80000d3c:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffdaf61>
    80000d3e:	fff5c683          	lbu	a3,-1(a1)
    80000d42:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d46:	feb79ae3          	bne	a5,a1,80000d3a <memmove+0x16>

  return dst;
}
    80000d4a:	6422                	ld	s0,8(sp)
    80000d4c:	0141                	addi	sp,sp,16
    80000d4e:	8082                	ret
  if(s < d && s + n > d){
    80000d50:	02061693          	slli	a3,a2,0x20
    80000d54:	9281                	srli	a3,a3,0x20
    80000d56:	00d58733          	add	a4,a1,a3
    80000d5a:	fce57be3          	bgeu	a0,a4,80000d30 <memmove+0xc>
    d += n;
    80000d5e:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d60:	fff6079b          	addiw	a5,a2,-1
    80000d64:	1782                	slli	a5,a5,0x20
    80000d66:	9381                	srli	a5,a5,0x20
    80000d68:	fff7c793          	not	a5,a5
    80000d6c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d6e:	177d                	addi	a4,a4,-1
    80000d70:	16fd                	addi	a3,a3,-1
    80000d72:	00074603          	lbu	a2,0(a4)
    80000d76:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000d7a:	fef71ae3          	bne	a4,a5,80000d6e <memmove+0x4a>
    80000d7e:	b7f1                	j	80000d4a <memmove+0x26>

0000000080000d80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000d80:	1141                	addi	sp,sp,-16
    80000d82:	e406                	sd	ra,8(sp)
    80000d84:	e022                	sd	s0,0(sp)
    80000d86:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d88:	f9dff0ef          	jal	80000d24 <memmove>
}
    80000d8c:	60a2                	ld	ra,8(sp)
    80000d8e:	6402                	ld	s0,0(sp)
    80000d90:	0141                	addi	sp,sp,16
    80000d92:	8082                	ret

0000000080000d94 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d94:	1141                	addi	sp,sp,-16
    80000d96:	e422                	sd	s0,8(sp)
    80000d98:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000d9a:	ce11                	beqz	a2,80000db6 <strncmp+0x22>
    80000d9c:	00054783          	lbu	a5,0(a0)
    80000da0:	cf89                	beqz	a5,80000dba <strncmp+0x26>
    80000da2:	0005c703          	lbu	a4,0(a1)
    80000da6:	00f71a63          	bne	a4,a5,80000dba <strncmp+0x26>
    n--, p++, q++;
    80000daa:	367d                	addiw	a2,a2,-1
    80000dac:	0505                	addi	a0,a0,1
    80000dae:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000db0:	f675                	bnez	a2,80000d9c <strncmp+0x8>
  if(n == 0)
    return 0;
    80000db2:	4501                	li	a0,0
    80000db4:	a801                	j	80000dc4 <strncmp+0x30>
    80000db6:	4501                	li	a0,0
    80000db8:	a031                	j	80000dc4 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dba:	00054503          	lbu	a0,0(a0)
    80000dbe:	0005c783          	lbu	a5,0(a1)
    80000dc2:	9d1d                	subw	a0,a0,a5
}
    80000dc4:	6422                	ld	s0,8(sp)
    80000dc6:	0141                	addi	sp,sp,16
    80000dc8:	8082                	ret

0000000080000dca <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dca:	1141                	addi	sp,sp,-16
    80000dcc:	e422                	sd	s0,8(sp)
    80000dce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000dd0:	87aa                	mv	a5,a0
    80000dd2:	86b2                	mv	a3,a2
    80000dd4:	367d                	addiw	a2,a2,-1
    80000dd6:	02d05563          	blez	a3,80000e00 <strncpy+0x36>
    80000dda:	0785                	addi	a5,a5,1
    80000ddc:	0005c703          	lbu	a4,0(a1)
    80000de0:	fee78fa3          	sb	a4,-1(a5)
    80000de4:	0585                	addi	a1,a1,1
    80000de6:	f775                	bnez	a4,80000dd2 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000de8:	873e                	mv	a4,a5
    80000dea:	9fb5                	addw	a5,a5,a3
    80000dec:	37fd                	addiw	a5,a5,-1
    80000dee:	00c05963          	blez	a2,80000e00 <strncpy+0x36>
    *s++ = 0;
    80000df2:	0705                	addi	a4,a4,1
    80000df4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000df8:	40e786bb          	subw	a3,a5,a4
    80000dfc:	fed04be3          	bgtz	a3,80000df2 <strncpy+0x28>
  return os;
}
    80000e00:	6422                	ld	s0,8(sp)
    80000e02:	0141                	addi	sp,sp,16
    80000e04:	8082                	ret

0000000080000e06 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e06:	1141                	addi	sp,sp,-16
    80000e08:	e422                	sd	s0,8(sp)
    80000e0a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e0c:	02c05363          	blez	a2,80000e32 <safestrcpy+0x2c>
    80000e10:	fff6069b          	addiw	a3,a2,-1
    80000e14:	1682                	slli	a3,a3,0x20
    80000e16:	9281                	srli	a3,a3,0x20
    80000e18:	96ae                	add	a3,a3,a1
    80000e1a:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e1c:	00d58963          	beq	a1,a3,80000e2e <safestrcpy+0x28>
    80000e20:	0585                	addi	a1,a1,1
    80000e22:	0785                	addi	a5,a5,1
    80000e24:	fff5c703          	lbu	a4,-1(a1)
    80000e28:	fee78fa3          	sb	a4,-1(a5)
    80000e2c:	fb65                	bnez	a4,80000e1c <safestrcpy+0x16>
    ;
  *s = 0;
    80000e2e:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <strlen>:

int
strlen(const char *s)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e3e:	00054783          	lbu	a5,0(a0)
    80000e42:	cf91                	beqz	a5,80000e5e <strlen+0x26>
    80000e44:	0505                	addi	a0,a0,1
    80000e46:	87aa                	mv	a5,a0
    80000e48:	86be                	mv	a3,a5
    80000e4a:	0785                	addi	a5,a5,1
    80000e4c:	fff7c703          	lbu	a4,-1(a5)
    80000e50:	ff65                	bnez	a4,80000e48 <strlen+0x10>
    80000e52:	40a6853b          	subw	a0,a3,a0
    80000e56:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e58:	6422                	ld	s0,8(sp)
    80000e5a:	0141                	addi	sp,sp,16
    80000e5c:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e5e:	4501                	li	a0,0
    80000e60:	bfe5                	j	80000e58 <strlen+0x20>

0000000080000e62 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e62:	1141                	addi	sp,sp,-16
    80000e64:	e406                	sd	ra,8(sp)
    80000e66:	e022                	sd	s0,0(sp)
    80000e68:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e6a:	281000ef          	jal	800018ea <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000e6e:	00009717          	auipc	a4,0x9
    80000e72:	4da70713          	addi	a4,a4,1242 # 8000a348 <started>
  if(cpuid() == 0){
    80000e76:	c51d                	beqz	a0,80000ea4 <main+0x42>
    while(started == 0)
    80000e78:	431c                	lw	a5,0(a4)
    80000e7a:	2781                	sext.w	a5,a5
    80000e7c:	dff5                	beqz	a5,80000e78 <main+0x16>
      ;
    __sync_synchronize();
    80000e7e:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000e82:	269000ef          	jal	800018ea <cpuid>
    80000e86:	85aa                	mv	a1,a0
    80000e88:	00006517          	auipc	a0,0x6
    80000e8c:	21050513          	addi	a0,a0,528 # 80007098 <etext+0x98>
    80000e90:	e32ff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000e94:	080000ef          	jal	80000f14 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000e98:	0ed010ef          	jal	80002784 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000e9c:	10d040ef          	jal	800057a8 <plicinithart>
  }

  scheduler();        
    80000ea0:	733000ef          	jal	80001dd2 <scheduler>
    consoleinit();
    80000ea4:	d48ff0ef          	jal	800003ec <consoleinit>
    printfinit();
    80000ea8:	927ff0ef          	jal	800007ce <printfinit>
    printf("\n");
    80000eac:	00006517          	auipc	a0,0x6
    80000eb0:	1cc50513          	addi	a0,a0,460 # 80007078 <etext+0x78>
    80000eb4:	e0eff0ef          	jal	800004c2 <printf>
    printf("xv6 kernel is booting\n");
    80000eb8:	00006517          	auipc	a0,0x6
    80000ebc:	1c850513          	addi	a0,a0,456 # 80007080 <etext+0x80>
    80000ec0:	e02ff0ef          	jal	800004c2 <printf>
    printf("\n");
    80000ec4:	00006517          	auipc	a0,0x6
    80000ec8:	1b450513          	addi	a0,a0,436 # 80007078 <etext+0x78>
    80000ecc:	df6ff0ef          	jal	800004c2 <printf>
    kinit();         // physical page allocator
    80000ed0:	c21ff0ef          	jal	80000af0 <kinit>
    kvminit();       // create kernel page table
    80000ed4:	300000ef          	jal	800011d4 <kvminit>
    kvminithart();   // turn on paging
    80000ed8:	03c000ef          	jal	80000f14 <kvminithart>
    procinit();      // process table
    80000edc:	159000ef          	jal	80001834 <procinit>
    trapinit();      // trap vectors
    80000ee0:	081010ef          	jal	80002760 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ee4:	0a1010ef          	jal	80002784 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ee8:	0a7040ef          	jal	8000578e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000eec:	0bd040ef          	jal	800057a8 <plicinithart>
    binit();         // buffer cache
    80000ef0:	765010ef          	jal	80002e54 <binit>
    iinit();         // inode table
    80000ef4:	556020ef          	jal	8000344a <iinit>
    fileinit();      // file table
    80000ef8:	302030ef          	jal	800041fa <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efc:	19d040ef          	jal	80005898 <virtio_disk_init>
    userinit();      // first user process
    80000f00:	4cf000ef          	jal	80001bce <userinit>
    __sync_synchronize();
    80000f04:	0330000f          	fence	rw,rw
    started = 1;
    80000f08:	4785                	li	a5,1
    80000f0a:	00009717          	auipc	a4,0x9
    80000f0e:	42f72f23          	sw	a5,1086(a4) # 8000a348 <started>
    80000f12:	b779                	j	80000ea0 <main+0x3e>

0000000080000f14 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e422                	sd	s0,8(sp)
    80000f18:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f1a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f1e:	00009797          	auipc	a5,0x9
    80000f22:	4327b783          	ld	a5,1074(a5) # 8000a350 <kernel_pagetable>
    80000f26:	83b1                	srli	a5,a5,0xc
    80000f28:	577d                	li	a4,-1
    80000f2a:	177e                	slli	a4,a4,0x3f
    80000f2c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f2e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f32:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f36:	6422                	ld	s0,8(sp)
    80000f38:	0141                	addi	sp,sp,16
    80000f3a:	8082                	ret

0000000080000f3c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f3c:	7139                	addi	sp,sp,-64
    80000f3e:	fc06                	sd	ra,56(sp)
    80000f40:	f822                	sd	s0,48(sp)
    80000f42:	f426                	sd	s1,40(sp)
    80000f44:	f04a                	sd	s2,32(sp)
    80000f46:	ec4e                	sd	s3,24(sp)
    80000f48:	e852                	sd	s4,16(sp)
    80000f4a:	e456                	sd	s5,8(sp)
    80000f4c:	e05a                	sd	s6,0(sp)
    80000f4e:	0080                	addi	s0,sp,64
    80000f50:	84aa                	mv	s1,a0
    80000f52:	89ae                	mv	s3,a1
    80000f54:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f56:	57fd                	li	a5,-1
    80000f58:	83e9                	srli	a5,a5,0x1a
    80000f5a:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f5c:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f5e:	02b7fc63          	bgeu	a5,a1,80000f96 <walk+0x5a>
    panic("walk");
    80000f62:	00006517          	auipc	a0,0x6
    80000f66:	14e50513          	addi	a0,a0,334 # 800070b0 <etext+0xb0>
    80000f6a:	82bff0ef          	jal	80000794 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000f6e:	060a8263          	beqz	s5,80000fd2 <walk+0x96>
    80000f72:	bb3ff0ef          	jal	80000b24 <kalloc>
    80000f76:	84aa                	mv	s1,a0
    80000f78:	c139                	beqz	a0,80000fbe <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	4581                	li	a1,0
    80000f7e:	d4bff0ef          	jal	80000cc8 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f82:	00c4d793          	srli	a5,s1,0xc
    80000f86:	07aa                	slli	a5,a5,0xa
    80000f88:	0017e793          	ori	a5,a5,1
    80000f8c:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000f90:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffdaf57>
    80000f92:	036a0063          	beq	s4,s6,80000fb2 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f96:	0149d933          	srl	s2,s3,s4
    80000f9a:	1ff97913          	andi	s2,s2,511
    80000f9e:	090e                	slli	s2,s2,0x3
    80000fa0:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fa2:	00093483          	ld	s1,0(s2)
    80000fa6:	0014f793          	andi	a5,s1,1
    80000faa:	d3f1                	beqz	a5,80000f6e <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fac:	80a9                	srli	s1,s1,0xa
    80000fae:	04b2                	slli	s1,s1,0xc
    80000fb0:	b7c5                	j	80000f90 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fb2:	00c9d513          	srli	a0,s3,0xc
    80000fb6:	1ff57513          	andi	a0,a0,511
    80000fba:	050e                	slli	a0,a0,0x3
    80000fbc:	9526                	add	a0,a0,s1
}
    80000fbe:	70e2                	ld	ra,56(sp)
    80000fc0:	7442                	ld	s0,48(sp)
    80000fc2:	74a2                	ld	s1,40(sp)
    80000fc4:	7902                	ld	s2,32(sp)
    80000fc6:	69e2                	ld	s3,24(sp)
    80000fc8:	6a42                	ld	s4,16(sp)
    80000fca:	6aa2                	ld	s5,8(sp)
    80000fcc:	6b02                	ld	s6,0(sp)
    80000fce:	6121                	addi	sp,sp,64
    80000fd0:	8082                	ret
        return 0;
    80000fd2:	4501                	li	a0,0
    80000fd4:	b7ed                	j	80000fbe <walk+0x82>

0000000080000fd6 <kwalkaddr>:
  if(va >= MAXVA)
    80000fd6:	57fd                	li	a5,-1
    80000fd8:	83e9                	srli	a5,a5,0x1a
    80000fda:	00b7f463          	bgeu	a5,a1,80000fe2 <kwalkaddr+0xc>
    return 0;
    80000fde:	4501                	li	a0,0
}
    80000fe0:	8082                	ret
{
    80000fe2:	1141                	addi	sp,sp,-16
    80000fe4:	e406                	sd	ra,8(sp)
    80000fe6:	e022                	sd	s0,0(sp)
    80000fe8:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fea:	4601                	li	a2,0
    80000fec:	f51ff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80000ff0:	cd01                	beqz	a0,80001008 <kwalkaddr+0x32>
  if((*pte & PTE_V) == 0)
    80000ff2:	611c                	ld	a5,0(a0)
    80000ff4:	0017f513          	andi	a0,a5,1
    80000ff8:	c501                	beqz	a0,80001000 <kwalkaddr+0x2a>
  pa = PTE2PA(*pte);
    80000ffa:	83a9                	srli	a5,a5,0xa
    80000ffc:	00c79513          	slli	a0,a5,0xc
}
    80001000:	60a2                	ld	ra,8(sp)
    80001002:	6402                	ld	s0,0(sp)
    80001004:	0141                	addi	sp,sp,16
    80001006:	8082                	ret
    return 0;
    80001008:	4501                	li	a0,0
    8000100a:	bfdd                	j	80001000 <kwalkaddr+0x2a>

000000008000100c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000100c:	57fd                	li	a5,-1
    8000100e:	83e9                	srli	a5,a5,0x1a
    80001010:	00b7f463          	bgeu	a5,a1,80001018 <walkaddr+0xc>
    return 0;
    80001014:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001016:	8082                	ret
{
    80001018:	1141                	addi	sp,sp,-16
    8000101a:	e406                	sd	ra,8(sp)
    8000101c:	e022                	sd	s0,0(sp)
    8000101e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001020:	4601                	li	a2,0
    80001022:	f1bff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    80001026:	c105                	beqz	a0,80001046 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80001028:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000102a:	0117f693          	andi	a3,a5,17
    8000102e:	4745                	li	a4,17
    return 0;
    80001030:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001032:	00e68663          	beq	a3,a4,8000103e <walkaddr+0x32>
}
    80001036:	60a2                	ld	ra,8(sp)
    80001038:	6402                	ld	s0,0(sp)
    8000103a:	0141                	addi	sp,sp,16
    8000103c:	8082                	ret
  pa = PTE2PA(*pte);
    8000103e:	83a9                	srli	a5,a5,0xa
    80001040:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001044:	bfcd                	j	80001036 <walkaddr+0x2a>
    return 0;
    80001046:	4501                	li	a0,0
    80001048:	b7fd                	j	80001036 <walkaddr+0x2a>

000000008000104a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000104a:	715d                	addi	sp,sp,-80
    8000104c:	e486                	sd	ra,72(sp)
    8000104e:	e0a2                	sd	s0,64(sp)
    80001050:	fc26                	sd	s1,56(sp)
    80001052:	f84a                	sd	s2,48(sp)
    80001054:	f44e                	sd	s3,40(sp)
    80001056:	f052                	sd	s4,32(sp)
    80001058:	ec56                	sd	s5,24(sp)
    8000105a:	e85a                	sd	s6,16(sp)
    8000105c:	e45e                	sd	s7,8(sp)
    8000105e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001060:	03459793          	slli	a5,a1,0x34
    80001064:	e7a9                	bnez	a5,800010ae <mappages+0x64>
    80001066:	8aaa                	mv	s5,a0
    80001068:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000106a:	03461793          	slli	a5,a2,0x34
    8000106e:	e7b1                	bnez	a5,800010ba <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80001070:	ca39                	beqz	a2,800010c6 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001072:	77fd                	lui	a5,0xfffff
    80001074:	963e                	add	a2,a2,a5
    80001076:	00b609b3          	add	s3,a2,a1
  a = va;
    8000107a:	892e                	mv	s2,a1
    8000107c:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001080:	6b85                	lui	s7,0x1
    80001082:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001086:	4605                	li	a2,1
    80001088:	85ca                	mv	a1,s2
    8000108a:	8556                	mv	a0,s5
    8000108c:	eb1ff0ef          	jal	80000f3c <walk>
    80001090:	c539                	beqz	a0,800010de <mappages+0x94>
    if(*pte & PTE_V)
    80001092:	611c                	ld	a5,0(a0)
    80001094:	8b85                	andi	a5,a5,1
    80001096:	ef95                	bnez	a5,800010d2 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001098:	80b1                	srli	s1,s1,0xc
    8000109a:	04aa                	slli	s1,s1,0xa
    8000109c:	0164e4b3          	or	s1,s1,s6
    800010a0:	0014e493          	ori	s1,s1,1
    800010a4:	e104                	sd	s1,0(a0)
    if(a == last)
    800010a6:	05390863          	beq	s2,s3,800010f6 <mappages+0xac>
    a += PGSIZE;
    800010aa:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010ac:	bfd9                	j	80001082 <mappages+0x38>
    panic("mappages: va not aligned");
    800010ae:	00006517          	auipc	a0,0x6
    800010b2:	00a50513          	addi	a0,a0,10 # 800070b8 <etext+0xb8>
    800010b6:	edeff0ef          	jal	80000794 <panic>
    panic("mappages: size not aligned");
    800010ba:	00006517          	auipc	a0,0x6
    800010be:	01e50513          	addi	a0,a0,30 # 800070d8 <etext+0xd8>
    800010c2:	ed2ff0ef          	jal	80000794 <panic>
    panic("mappages: size");
    800010c6:	00006517          	auipc	a0,0x6
    800010ca:	03250513          	addi	a0,a0,50 # 800070f8 <etext+0xf8>
    800010ce:	ec6ff0ef          	jal	80000794 <panic>
      panic("mappages: remap");
    800010d2:	00006517          	auipc	a0,0x6
    800010d6:	03650513          	addi	a0,a0,54 # 80007108 <etext+0x108>
    800010da:	ebaff0ef          	jal	80000794 <panic>
      return -1;
    800010de:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010e0:	60a6                	ld	ra,72(sp)
    800010e2:	6406                	ld	s0,64(sp)
    800010e4:	74e2                	ld	s1,56(sp)
    800010e6:	7942                	ld	s2,48(sp)
    800010e8:	79a2                	ld	s3,40(sp)
    800010ea:	7a02                	ld	s4,32(sp)
    800010ec:	6ae2                	ld	s5,24(sp)
    800010ee:	6b42                	ld	s6,16(sp)
    800010f0:	6ba2                	ld	s7,8(sp)
    800010f2:	6161                	addi	sp,sp,80
    800010f4:	8082                	ret
  return 0;
    800010f6:	4501                	li	a0,0
    800010f8:	b7e5                	j	800010e0 <mappages+0x96>

00000000800010fa <kvmmap>:
{
    800010fa:	1141                	addi	sp,sp,-16
    800010fc:	e406                	sd	ra,8(sp)
    800010fe:	e022                	sd	s0,0(sp)
    80001100:	0800                	addi	s0,sp,16
    80001102:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001104:	86b2                	mv	a3,a2
    80001106:	863e                	mv	a2,a5
    80001108:	f43ff0ef          	jal	8000104a <mappages>
    8000110c:	e509                	bnez	a0,80001116 <kvmmap+0x1c>
}
    8000110e:	60a2                	ld	ra,8(sp)
    80001110:	6402                	ld	s0,0(sp)
    80001112:	0141                	addi	sp,sp,16
    80001114:	8082                	ret
    panic("kvmmap");
    80001116:	00006517          	auipc	a0,0x6
    8000111a:	00250513          	addi	a0,a0,2 # 80007118 <etext+0x118>
    8000111e:	e76ff0ef          	jal	80000794 <panic>

0000000080001122 <kvmmake>:
{
    80001122:	1101                	addi	sp,sp,-32
    80001124:	ec06                	sd	ra,24(sp)
    80001126:	e822                	sd	s0,16(sp)
    80001128:	e426                	sd	s1,8(sp)
    8000112a:	e04a                	sd	s2,0(sp)
    8000112c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000112e:	9f7ff0ef          	jal	80000b24 <kalloc>
    80001132:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001134:	6605                	lui	a2,0x1
    80001136:	4581                	li	a1,0
    80001138:	b91ff0ef          	jal	80000cc8 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000113c:	4719                	li	a4,6
    8000113e:	6685                	lui	a3,0x1
    80001140:	10000637          	lui	a2,0x10000
    80001144:	100005b7          	lui	a1,0x10000
    80001148:	8526                	mv	a0,s1
    8000114a:	fb1ff0ef          	jal	800010fa <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000114e:	4719                	li	a4,6
    80001150:	6685                	lui	a3,0x1
    80001152:	10001637          	lui	a2,0x10001
    80001156:	100015b7          	lui	a1,0x10001
    8000115a:	8526                	mv	a0,s1
    8000115c:	f9fff0ef          	jal	800010fa <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001160:	4719                	li	a4,6
    80001162:	040006b7          	lui	a3,0x4000
    80001166:	0c000637          	lui	a2,0xc000
    8000116a:	0c0005b7          	lui	a1,0xc000
    8000116e:	8526                	mv	a0,s1
    80001170:	f8bff0ef          	jal	800010fa <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001174:	00006917          	auipc	s2,0x6
    80001178:	e8c90913          	addi	s2,s2,-372 # 80007000 <etext>
    8000117c:	4729                	li	a4,10
    8000117e:	80006697          	auipc	a3,0x80006
    80001182:	e8268693          	addi	a3,a3,-382 # 7000 <_entry-0x7fff9000>
    80001186:	4605                	li	a2,1
    80001188:	067e                	slli	a2,a2,0x1f
    8000118a:	85b2                	mv	a1,a2
    8000118c:	8526                	mv	a0,s1
    8000118e:	f6dff0ef          	jal	800010fa <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001192:	46c5                	li	a3,17
    80001194:	06ee                	slli	a3,a3,0x1b
    80001196:	4719                	li	a4,6
    80001198:	412686b3          	sub	a3,a3,s2
    8000119c:	864a                	mv	a2,s2
    8000119e:	85ca                	mv	a1,s2
    800011a0:	8526                	mv	a0,s1
    800011a2:	f59ff0ef          	jal	800010fa <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011a6:	4729                	li	a4,10
    800011a8:	6685                	lui	a3,0x1
    800011aa:	00005617          	auipc	a2,0x5
    800011ae:	e5660613          	addi	a2,a2,-426 # 80006000 <_trampoline>
    800011b2:	040005b7          	lui	a1,0x4000
    800011b6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011b8:	05b2                	slli	a1,a1,0xc
    800011ba:	8526                	mv	a0,s1
    800011bc:	f3fff0ef          	jal	800010fa <kvmmap>
  proc_mapstacks(kpgtbl);
    800011c0:	8526                	mv	a0,s1
    800011c2:	5da000ef          	jal	8000179c <proc_mapstacks>
}
    800011c6:	8526                	mv	a0,s1
    800011c8:	60e2                	ld	ra,24(sp)
    800011ca:	6442                	ld	s0,16(sp)
    800011cc:	64a2                	ld	s1,8(sp)
    800011ce:	6902                	ld	s2,0(sp)
    800011d0:	6105                	addi	sp,sp,32
    800011d2:	8082                	ret

00000000800011d4 <kvminit>:
{
    800011d4:	1141                	addi	sp,sp,-16
    800011d6:	e406                	sd	ra,8(sp)
    800011d8:	e022                	sd	s0,0(sp)
    800011da:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011dc:	f47ff0ef          	jal	80001122 <kvmmake>
    800011e0:	00009797          	auipc	a5,0x9
    800011e4:	16a7b823          	sd	a0,368(a5) # 8000a350 <kernel_pagetable>
}
    800011e8:	60a2                	ld	ra,8(sp)
    800011ea:	6402                	ld	s0,0(sp)
    800011ec:	0141                	addi	sp,sp,16
    800011ee:	8082                	ret

00000000800011f0 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011f0:	715d                	addi	sp,sp,-80
    800011f2:	e486                	sd	ra,72(sp)
    800011f4:	e0a2                	sd	s0,64(sp)
    800011f6:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011f8:	03459793          	slli	a5,a1,0x34
    800011fc:	e39d                	bnez	a5,80001222 <uvmunmap+0x32>
    800011fe:	f84a                	sd	s2,48(sp)
    80001200:	f44e                	sd	s3,40(sp)
    80001202:	f052                	sd	s4,32(sp)
    80001204:	ec56                	sd	s5,24(sp)
    80001206:	e85a                	sd	s6,16(sp)
    80001208:	e45e                	sd	s7,8(sp)
    8000120a:	8a2a                	mv	s4,a0
    8000120c:	892e                	mv	s2,a1
    8000120e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001210:	0632                	slli	a2,a2,0xc
    80001212:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001216:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001218:	6b05                	lui	s6,0x1
    8000121a:	0735ff63          	bgeu	a1,s3,80001298 <uvmunmap+0xa8>
    8000121e:	fc26                	sd	s1,56(sp)
    80001220:	a0a9                	j	8000126a <uvmunmap+0x7a>
    80001222:	fc26                	sd	s1,56(sp)
    80001224:	f84a                	sd	s2,48(sp)
    80001226:	f44e                	sd	s3,40(sp)
    80001228:	f052                	sd	s4,32(sp)
    8000122a:	ec56                	sd	s5,24(sp)
    8000122c:	e85a                	sd	s6,16(sp)
    8000122e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001230:	00006517          	auipc	a0,0x6
    80001234:	ef050513          	addi	a0,a0,-272 # 80007120 <etext+0x120>
    80001238:	d5cff0ef          	jal	80000794 <panic>
      panic("uvmunmap: walk");
    8000123c:	00006517          	auipc	a0,0x6
    80001240:	efc50513          	addi	a0,a0,-260 # 80007138 <etext+0x138>
    80001244:	d50ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not mapped");
    80001248:	00006517          	auipc	a0,0x6
    8000124c:	f0050513          	addi	a0,a0,-256 # 80007148 <etext+0x148>
    80001250:	d44ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not a leaf");
    80001254:	00006517          	auipc	a0,0x6
    80001258:	f0c50513          	addi	a0,a0,-244 # 80007160 <etext+0x160>
    8000125c:	d38ff0ef          	jal	80000794 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001260:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001264:	995a                	add	s2,s2,s6
    80001266:	03397863          	bgeu	s2,s3,80001296 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000126a:	4601                	li	a2,0
    8000126c:	85ca                	mv	a1,s2
    8000126e:	8552                	mv	a0,s4
    80001270:	ccdff0ef          	jal	80000f3c <walk>
    80001274:	84aa                	mv	s1,a0
    80001276:	d179                	beqz	a0,8000123c <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001278:	6108                	ld	a0,0(a0)
    8000127a:	00157793          	andi	a5,a0,1
    8000127e:	d7e9                	beqz	a5,80001248 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001280:	3ff57793          	andi	a5,a0,1023
    80001284:	fd7788e3          	beq	a5,s7,80001254 <uvmunmap+0x64>
    if(do_free){
    80001288:	fc0a8ce3          	beqz	s5,80001260 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    8000128c:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000128e:	0532                	slli	a0,a0,0xc
    80001290:	fb2ff0ef          	jal	80000a42 <kfree>
    80001294:	b7f1                	j	80001260 <uvmunmap+0x70>
    80001296:	74e2                	ld	s1,56(sp)
    80001298:	7942                	ld	s2,48(sp)
    8000129a:	79a2                	ld	s3,40(sp)
    8000129c:	7a02                	ld	s4,32(sp)
    8000129e:	6ae2                	ld	s5,24(sp)
    800012a0:	6b42                	ld	s6,16(sp)
    800012a2:	6ba2                	ld	s7,8(sp)
  }
}
    800012a4:	60a6                	ld	ra,72(sp)
    800012a6:	6406                	ld	s0,64(sp)
    800012a8:	6161                	addi	sp,sp,80
    800012aa:	8082                	ret

00000000800012ac <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800012ac:	1101                	addi	sp,sp,-32
    800012ae:	ec06                	sd	ra,24(sp)
    800012b0:	e822                	sd	s0,16(sp)
    800012b2:	e426                	sd	s1,8(sp)
    800012b4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800012b6:	86fff0ef          	jal	80000b24 <kalloc>
    800012ba:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800012bc:	c509                	beqz	a0,800012c6 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800012be:	6605                	lui	a2,0x1
    800012c0:	4581                	li	a1,0
    800012c2:	a07ff0ef          	jal	80000cc8 <memset>
  return pagetable;
}
    800012c6:	8526                	mv	a0,s1
    800012c8:	60e2                	ld	ra,24(sp)
    800012ca:	6442                	ld	s0,16(sp)
    800012cc:	64a2                	ld	s1,8(sp)
    800012ce:	6105                	addi	sp,sp,32
    800012d0:	8082                	ret

00000000800012d2 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800012d2:	7179                	addi	sp,sp,-48
    800012d4:	f406                	sd	ra,40(sp)
    800012d6:	f022                	sd	s0,32(sp)
    800012d8:	ec26                	sd	s1,24(sp)
    800012da:	e84a                	sd	s2,16(sp)
    800012dc:	e44e                	sd	s3,8(sp)
    800012de:	e052                	sd	s4,0(sp)
    800012e0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012e2:	6785                	lui	a5,0x1
    800012e4:	04f67063          	bgeu	a2,a5,80001324 <uvmfirst+0x52>
    800012e8:	8a2a                	mv	s4,a0
    800012ea:	89ae                	mv	s3,a1
    800012ec:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012ee:	837ff0ef          	jal	80000b24 <kalloc>
    800012f2:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012f4:	6605                	lui	a2,0x1
    800012f6:	4581                	li	a1,0
    800012f8:	9d1ff0ef          	jal	80000cc8 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012fc:	4779                	li	a4,30
    800012fe:	86ca                	mv	a3,s2
    80001300:	6605                	lui	a2,0x1
    80001302:	4581                	li	a1,0
    80001304:	8552                	mv	a0,s4
    80001306:	d45ff0ef          	jal	8000104a <mappages>
  memmove(mem, src, sz);
    8000130a:	8626                	mv	a2,s1
    8000130c:	85ce                	mv	a1,s3
    8000130e:	854a                	mv	a0,s2
    80001310:	a15ff0ef          	jal	80000d24 <memmove>
}
    80001314:	70a2                	ld	ra,40(sp)
    80001316:	7402                	ld	s0,32(sp)
    80001318:	64e2                	ld	s1,24(sp)
    8000131a:	6942                	ld	s2,16(sp)
    8000131c:	69a2                	ld	s3,8(sp)
    8000131e:	6a02                	ld	s4,0(sp)
    80001320:	6145                	addi	sp,sp,48
    80001322:	8082                	ret
    panic("uvmfirst: more than a page");
    80001324:	00006517          	auipc	a0,0x6
    80001328:	e5450513          	addi	a0,a0,-428 # 80007178 <etext+0x178>
    8000132c:	c68ff0ef          	jal	80000794 <panic>

0000000080001330 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001330:	1101                	addi	sp,sp,-32
    80001332:	ec06                	sd	ra,24(sp)
    80001334:	e822                	sd	s0,16(sp)
    80001336:	e426                	sd	s1,8(sp)
    80001338:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000133a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000133c:	00b67d63          	bgeu	a2,a1,80001356 <uvmdealloc+0x26>
    80001340:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001342:	6785                	lui	a5,0x1
    80001344:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001346:	00f60733          	add	a4,a2,a5
    8000134a:	76fd                	lui	a3,0xfffff
    8000134c:	8f75                	and	a4,a4,a3
    8000134e:	97ae                	add	a5,a5,a1
    80001350:	8ff5                	and	a5,a5,a3
    80001352:	00f76863          	bltu	a4,a5,80001362 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001356:	8526                	mv	a0,s1
    80001358:	60e2                	ld	ra,24(sp)
    8000135a:	6442                	ld	s0,16(sp)
    8000135c:	64a2                	ld	s1,8(sp)
    8000135e:	6105                	addi	sp,sp,32
    80001360:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001362:	8f99                	sub	a5,a5,a4
    80001364:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001366:	4685                	li	a3,1
    80001368:	0007861b          	sext.w	a2,a5
    8000136c:	85ba                	mv	a1,a4
    8000136e:	e83ff0ef          	jal	800011f0 <uvmunmap>
    80001372:	b7d5                	j	80001356 <uvmdealloc+0x26>

0000000080001374 <uvmalloc>:
  if(newsz < oldsz)
    80001374:	08b66f63          	bltu	a2,a1,80001412 <uvmalloc+0x9e>
{
    80001378:	7139                	addi	sp,sp,-64
    8000137a:	fc06                	sd	ra,56(sp)
    8000137c:	f822                	sd	s0,48(sp)
    8000137e:	ec4e                	sd	s3,24(sp)
    80001380:	e852                	sd	s4,16(sp)
    80001382:	e456                	sd	s5,8(sp)
    80001384:	0080                	addi	s0,sp,64
    80001386:	8aaa                	mv	s5,a0
    80001388:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000138a:	6785                	lui	a5,0x1
    8000138c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000138e:	95be                	add	a1,a1,a5
    80001390:	77fd                	lui	a5,0xfffff
    80001392:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001396:	08c9f063          	bgeu	s3,a2,80001416 <uvmalloc+0xa2>
    8000139a:	f426                	sd	s1,40(sp)
    8000139c:	f04a                	sd	s2,32(sp)
    8000139e:	e05a                	sd	s6,0(sp)
    800013a0:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800013a2:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800013a6:	f7eff0ef          	jal	80000b24 <kalloc>
    800013aa:	84aa                	mv	s1,a0
    if(mem == 0){
    800013ac:	c515                	beqz	a0,800013d8 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800013ae:	6605                	lui	a2,0x1
    800013b0:	4581                	li	a1,0
    800013b2:	917ff0ef          	jal	80000cc8 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800013b6:	875a                	mv	a4,s6
    800013b8:	86a6                	mv	a3,s1
    800013ba:	6605                	lui	a2,0x1
    800013bc:	85ca                	mv	a1,s2
    800013be:	8556                	mv	a0,s5
    800013c0:	c8bff0ef          	jal	8000104a <mappages>
    800013c4:	e915                	bnez	a0,800013f8 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800013c6:	6785                	lui	a5,0x1
    800013c8:	993e                	add	s2,s2,a5
    800013ca:	fd496ee3          	bltu	s2,s4,800013a6 <uvmalloc+0x32>
  return newsz;
    800013ce:	8552                	mv	a0,s4
    800013d0:	74a2                	ld	s1,40(sp)
    800013d2:	7902                	ld	s2,32(sp)
    800013d4:	6b02                	ld	s6,0(sp)
    800013d6:	a811                	j	800013ea <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013d8:	864e                	mv	a2,s3
    800013da:	85ca                	mv	a1,s2
    800013dc:	8556                	mv	a0,s5
    800013de:	f53ff0ef          	jal	80001330 <uvmdealloc>
      return 0;
    800013e2:	4501                	li	a0,0
    800013e4:	74a2                	ld	s1,40(sp)
    800013e6:	7902                	ld	s2,32(sp)
    800013e8:	6b02                	ld	s6,0(sp)
}
    800013ea:	70e2                	ld	ra,56(sp)
    800013ec:	7442                	ld	s0,48(sp)
    800013ee:	69e2                	ld	s3,24(sp)
    800013f0:	6a42                	ld	s4,16(sp)
    800013f2:	6aa2                	ld	s5,8(sp)
    800013f4:	6121                	addi	sp,sp,64
    800013f6:	8082                	ret
      kfree(mem);
    800013f8:	8526                	mv	a0,s1
    800013fa:	e48ff0ef          	jal	80000a42 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013fe:	864e                	mv	a2,s3
    80001400:	85ca                	mv	a1,s2
    80001402:	8556                	mv	a0,s5
    80001404:	f2dff0ef          	jal	80001330 <uvmdealloc>
      return 0;
    80001408:	4501                	li	a0,0
    8000140a:	74a2                	ld	s1,40(sp)
    8000140c:	7902                	ld	s2,32(sp)
    8000140e:	6b02                	ld	s6,0(sp)
    80001410:	bfe9                	j	800013ea <uvmalloc+0x76>
    return oldsz;
    80001412:	852e                	mv	a0,a1
}
    80001414:	8082                	ret
  return newsz;
    80001416:	8532                	mv	a0,a2
    80001418:	bfc9                	j	800013ea <uvmalloc+0x76>

000000008000141a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000141a:	7179                	addi	sp,sp,-48
    8000141c:	f406                	sd	ra,40(sp)
    8000141e:	f022                	sd	s0,32(sp)
    80001420:	ec26                	sd	s1,24(sp)
    80001422:	e84a                	sd	s2,16(sp)
    80001424:	e44e                	sd	s3,8(sp)
    80001426:	e052                	sd	s4,0(sp)
    80001428:	1800                	addi	s0,sp,48
    8000142a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000142c:	84aa                	mv	s1,a0
    8000142e:	6905                	lui	s2,0x1
    80001430:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001432:	4985                	li	s3,1
    80001434:	a819                	j	8000144a <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001436:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001438:	00c79513          	slli	a0,a5,0xc
    8000143c:	fdfff0ef          	jal	8000141a <freewalk>
      pagetable[i] = 0;
    80001440:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001444:	04a1                	addi	s1,s1,8
    80001446:	01248f63          	beq	s1,s2,80001464 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000144a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000144c:	00f7f713          	andi	a4,a5,15
    80001450:	ff3703e3          	beq	a4,s3,80001436 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001454:	8b85                	andi	a5,a5,1
    80001456:	d7fd                	beqz	a5,80001444 <freewalk+0x2a>
      panic("freewalk: leaf");
    80001458:	00006517          	auipc	a0,0x6
    8000145c:	d4050513          	addi	a0,a0,-704 # 80007198 <etext+0x198>
    80001460:	b34ff0ef          	jal	80000794 <panic>
    }
  }
  kfree((void*)pagetable);
    80001464:	8552                	mv	a0,s4
    80001466:	ddcff0ef          	jal	80000a42 <kfree>
}
    8000146a:	70a2                	ld	ra,40(sp)
    8000146c:	7402                	ld	s0,32(sp)
    8000146e:	64e2                	ld	s1,24(sp)
    80001470:	6942                	ld	s2,16(sp)
    80001472:	69a2                	ld	s3,8(sp)
    80001474:	6a02                	ld	s4,0(sp)
    80001476:	6145                	addi	sp,sp,48
    80001478:	8082                	ret

000000008000147a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000147a:	1101                	addi	sp,sp,-32
    8000147c:	ec06                	sd	ra,24(sp)
    8000147e:	e822                	sd	s0,16(sp)
    80001480:	e426                	sd	s1,8(sp)
    80001482:	1000                	addi	s0,sp,32
    80001484:	84aa                	mv	s1,a0
  if(sz > 0)
    80001486:	e989                	bnez	a1,80001498 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001488:	8526                	mv	a0,s1
    8000148a:	f91ff0ef          	jal	8000141a <freewalk>
}
    8000148e:	60e2                	ld	ra,24(sp)
    80001490:	6442                	ld	s0,16(sp)
    80001492:	64a2                	ld	s1,8(sp)
    80001494:	6105                	addi	sp,sp,32
    80001496:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001498:	6785                	lui	a5,0x1
    8000149a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000149c:	95be                	add	a1,a1,a5
    8000149e:	4685                	li	a3,1
    800014a0:	00c5d613          	srli	a2,a1,0xc
    800014a4:	4581                	li	a1,0
    800014a6:	d4bff0ef          	jal	800011f0 <uvmunmap>
    800014aa:	bff9                	j	80001488 <uvmfree+0xe>

00000000800014ac <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800014ac:	c65d                	beqz	a2,8000155a <uvmcopy+0xae>
{
    800014ae:	715d                	addi	sp,sp,-80
    800014b0:	e486                	sd	ra,72(sp)
    800014b2:	e0a2                	sd	s0,64(sp)
    800014b4:	fc26                	sd	s1,56(sp)
    800014b6:	f84a                	sd	s2,48(sp)
    800014b8:	f44e                	sd	s3,40(sp)
    800014ba:	f052                	sd	s4,32(sp)
    800014bc:	ec56                	sd	s5,24(sp)
    800014be:	e85a                	sd	s6,16(sp)
    800014c0:	e45e                	sd	s7,8(sp)
    800014c2:	0880                	addi	s0,sp,80
    800014c4:	8b2a                	mv	s6,a0
    800014c6:	8aae                	mv	s5,a1
    800014c8:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800014ca:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800014cc:	4601                	li	a2,0
    800014ce:	85ce                	mv	a1,s3
    800014d0:	855a                	mv	a0,s6
    800014d2:	a6bff0ef          	jal	80000f3c <walk>
    800014d6:	c121                	beqz	a0,80001516 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014d8:	6118                	ld	a4,0(a0)
    800014da:	00177793          	andi	a5,a4,1
    800014de:	c3b1                	beqz	a5,80001522 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014e0:	00a75593          	srli	a1,a4,0xa
    800014e4:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014e8:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014ec:	e38ff0ef          	jal	80000b24 <kalloc>
    800014f0:	892a                	mv	s2,a0
    800014f2:	c129                	beqz	a0,80001534 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014f4:	6605                	lui	a2,0x1
    800014f6:	85de                	mv	a1,s7
    800014f8:	82dff0ef          	jal	80000d24 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014fc:	8726                	mv	a4,s1
    800014fe:	86ca                	mv	a3,s2
    80001500:	6605                	lui	a2,0x1
    80001502:	85ce                	mv	a1,s3
    80001504:	8556                	mv	a0,s5
    80001506:	b45ff0ef          	jal	8000104a <mappages>
    8000150a:	e115                	bnez	a0,8000152e <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    8000150c:	6785                	lui	a5,0x1
    8000150e:	99be                	add	s3,s3,a5
    80001510:	fb49eee3          	bltu	s3,s4,800014cc <uvmcopy+0x20>
    80001514:	a805                	j	80001544 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80001516:	00006517          	auipc	a0,0x6
    8000151a:	c9250513          	addi	a0,a0,-878 # 800071a8 <etext+0x1a8>
    8000151e:	a76ff0ef          	jal	80000794 <panic>
      panic("uvmcopy: page not present");
    80001522:	00006517          	auipc	a0,0x6
    80001526:	ca650513          	addi	a0,a0,-858 # 800071c8 <etext+0x1c8>
    8000152a:	a6aff0ef          	jal	80000794 <panic>
      kfree(mem);
    8000152e:	854a                	mv	a0,s2
    80001530:	d12ff0ef          	jal	80000a42 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001534:	4685                	li	a3,1
    80001536:	00c9d613          	srli	a2,s3,0xc
    8000153a:	4581                	li	a1,0
    8000153c:	8556                	mv	a0,s5
    8000153e:	cb3ff0ef          	jal	800011f0 <uvmunmap>
  return -1;
    80001542:	557d                	li	a0,-1
}
    80001544:	60a6                	ld	ra,72(sp)
    80001546:	6406                	ld	s0,64(sp)
    80001548:	74e2                	ld	s1,56(sp)
    8000154a:	7942                	ld	s2,48(sp)
    8000154c:	79a2                	ld	s3,40(sp)
    8000154e:	7a02                	ld	s4,32(sp)
    80001550:	6ae2                	ld	s5,24(sp)
    80001552:	6b42                	ld	s6,16(sp)
    80001554:	6ba2                	ld	s7,8(sp)
    80001556:	6161                	addi	sp,sp,80
    80001558:	8082                	ret
  return 0;
    8000155a:	4501                	li	a0,0
}
    8000155c:	8082                	ret

000000008000155e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000155e:	1141                	addi	sp,sp,-16
    80001560:	e406                	sd	ra,8(sp)
    80001562:	e022                	sd	s0,0(sp)
    80001564:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001566:	4601                	li	a2,0
    80001568:	9d5ff0ef          	jal	80000f3c <walk>
  if(pte == 0)
    8000156c:	c901                	beqz	a0,8000157c <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000156e:	611c                	ld	a5,0(a0)
    80001570:	9bbd                	andi	a5,a5,-17
    80001572:	e11c                	sd	a5,0(a0)
}
    80001574:	60a2                	ld	ra,8(sp)
    80001576:	6402                	ld	s0,0(sp)
    80001578:	0141                	addi	sp,sp,16
    8000157a:	8082                	ret
    panic("uvmclear");
    8000157c:	00006517          	auipc	a0,0x6
    80001580:	c6c50513          	addi	a0,a0,-916 # 800071e8 <etext+0x1e8>
    80001584:	a10ff0ef          	jal	80000794 <panic>

0000000080001588 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001588:	cad1                	beqz	a3,8000161c <copyout+0x94>
{
    8000158a:	711d                	addi	sp,sp,-96
    8000158c:	ec86                	sd	ra,88(sp)
    8000158e:	e8a2                	sd	s0,80(sp)
    80001590:	e4a6                	sd	s1,72(sp)
    80001592:	fc4e                	sd	s3,56(sp)
    80001594:	f456                	sd	s5,40(sp)
    80001596:	f05a                	sd	s6,32(sp)
    80001598:	ec5e                	sd	s7,24(sp)
    8000159a:	1080                	addi	s0,sp,96
    8000159c:	8baa                	mv	s7,a0
    8000159e:	8aae                	mv	s5,a1
    800015a0:	8b32                	mv	s6,a2
    800015a2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800015a4:	74fd                	lui	s1,0xfffff
    800015a6:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    800015a8:	57fd                	li	a5,-1
    800015aa:	83e9                	srli	a5,a5,0x1a
    800015ac:	0697ea63          	bltu	a5,s1,80001620 <copyout+0x98>
    800015b0:	e0ca                	sd	s2,64(sp)
    800015b2:	f852                	sd	s4,48(sp)
    800015b4:	e862                	sd	s8,16(sp)
    800015b6:	e466                	sd	s9,8(sp)
    800015b8:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015ba:	4cd5                	li	s9,21
    800015bc:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    800015be:	8c3e                	mv	s8,a5
    800015c0:	a025                	j	800015e8 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    800015c2:	83a9                	srli	a5,a5,0xa
    800015c4:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015c6:	409a8533          	sub	a0,s5,s1
    800015ca:	0009061b          	sext.w	a2,s2
    800015ce:	85da                	mv	a1,s6
    800015d0:	953e                	add	a0,a0,a5
    800015d2:	f52ff0ef          	jal	80000d24 <memmove>

    len -= n;
    800015d6:	412989b3          	sub	s3,s3,s2
    src += n;
    800015da:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015dc:	02098963          	beqz	s3,8000160e <copyout+0x86>
    if(va0 >= MAXVA)
    800015e0:	054c6263          	bltu	s8,s4,80001624 <copyout+0x9c>
    800015e4:	84d2                	mv	s1,s4
    800015e6:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015e8:	4601                	li	a2,0
    800015ea:	85a6                	mv	a1,s1
    800015ec:	855e                	mv	a0,s7
    800015ee:	94fff0ef          	jal	80000f3c <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015f2:	c121                	beqz	a0,80001632 <copyout+0xaa>
    800015f4:	611c                	ld	a5,0(a0)
    800015f6:	0157f713          	andi	a4,a5,21
    800015fa:	05971b63          	bne	a4,s9,80001650 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015fe:	01a48a33          	add	s4,s1,s10
    80001602:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80001606:	fb29fee3          	bgeu	s3,s2,800015c2 <copyout+0x3a>
    8000160a:	894e                	mv	s2,s3
    8000160c:	bf5d                	j	800015c2 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    8000160e:	4501                	li	a0,0
    80001610:	6906                	ld	s2,64(sp)
    80001612:	7a42                	ld	s4,48(sp)
    80001614:	6c42                	ld	s8,16(sp)
    80001616:	6ca2                	ld	s9,8(sp)
    80001618:	6d02                	ld	s10,0(sp)
    8000161a:	a015                	j	8000163e <copyout+0xb6>
    8000161c:	4501                	li	a0,0
}
    8000161e:	8082                	ret
      return -1;
    80001620:	557d                	li	a0,-1
    80001622:	a831                	j	8000163e <copyout+0xb6>
    80001624:	557d                	li	a0,-1
    80001626:	6906                	ld	s2,64(sp)
    80001628:	7a42                	ld	s4,48(sp)
    8000162a:	6c42                	ld	s8,16(sp)
    8000162c:	6ca2                	ld	s9,8(sp)
    8000162e:	6d02                	ld	s10,0(sp)
    80001630:	a039                	j	8000163e <copyout+0xb6>
      return -1;
    80001632:	557d                	li	a0,-1
    80001634:	6906                	ld	s2,64(sp)
    80001636:	7a42                	ld	s4,48(sp)
    80001638:	6c42                	ld	s8,16(sp)
    8000163a:	6ca2                	ld	s9,8(sp)
    8000163c:	6d02                	ld	s10,0(sp)
}
    8000163e:	60e6                	ld	ra,88(sp)
    80001640:	6446                	ld	s0,80(sp)
    80001642:	64a6                	ld	s1,72(sp)
    80001644:	79e2                	ld	s3,56(sp)
    80001646:	7aa2                	ld	s5,40(sp)
    80001648:	7b02                	ld	s6,32(sp)
    8000164a:	6be2                	ld	s7,24(sp)
    8000164c:	6125                	addi	sp,sp,96
    8000164e:	8082                	ret
      return -1;
    80001650:	557d                	li	a0,-1
    80001652:	6906                	ld	s2,64(sp)
    80001654:	7a42                	ld	s4,48(sp)
    80001656:	6c42                	ld	s8,16(sp)
    80001658:	6ca2                	ld	s9,8(sp)
    8000165a:	6d02                	ld	s10,0(sp)
    8000165c:	b7cd                	j	8000163e <copyout+0xb6>

000000008000165e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000165e:	c6a5                	beqz	a3,800016c6 <copyin+0x68>
{
    80001660:	715d                	addi	sp,sp,-80
    80001662:	e486                	sd	ra,72(sp)
    80001664:	e0a2                	sd	s0,64(sp)
    80001666:	fc26                	sd	s1,56(sp)
    80001668:	f84a                	sd	s2,48(sp)
    8000166a:	f44e                	sd	s3,40(sp)
    8000166c:	f052                	sd	s4,32(sp)
    8000166e:	ec56                	sd	s5,24(sp)
    80001670:	e85a                	sd	s6,16(sp)
    80001672:	e45e                	sd	s7,8(sp)
    80001674:	e062                	sd	s8,0(sp)
    80001676:	0880                	addi	s0,sp,80
    80001678:	8b2a                	mv	s6,a0
    8000167a:	8a2e                	mv	s4,a1
    8000167c:	8c32                	mv	s8,a2
    8000167e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001680:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001682:	6a85                	lui	s5,0x1
    80001684:	a00d                	j	800016a6 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001686:	018505b3          	add	a1,a0,s8
    8000168a:	0004861b          	sext.w	a2,s1
    8000168e:	412585b3          	sub	a1,a1,s2
    80001692:	8552                	mv	a0,s4
    80001694:	e90ff0ef          	jal	80000d24 <memmove>

    len -= n;
    80001698:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000169c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000169e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800016a2:	02098063          	beqz	s3,800016c2 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    800016a6:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016aa:	85ca                	mv	a1,s2
    800016ac:	855a                	mv	a0,s6
    800016ae:	95fff0ef          	jal	8000100c <walkaddr>
    if(pa0 == 0)
    800016b2:	cd01                	beqz	a0,800016ca <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    800016b4:	418904b3          	sub	s1,s2,s8
    800016b8:	94d6                	add	s1,s1,s5
    if(n > len)
    800016ba:	fc99f6e3          	bgeu	s3,s1,80001686 <copyin+0x28>
    800016be:	84ce                	mv	s1,s3
    800016c0:	b7d9                	j	80001686 <copyin+0x28>
  }
  return 0;
    800016c2:	4501                	li	a0,0
    800016c4:	a021                	j	800016cc <copyin+0x6e>
    800016c6:	4501                	li	a0,0
}
    800016c8:	8082                	ret
      return -1;
    800016ca:	557d                	li	a0,-1
}
    800016cc:	60a6                	ld	ra,72(sp)
    800016ce:	6406                	ld	s0,64(sp)
    800016d0:	74e2                	ld	s1,56(sp)
    800016d2:	7942                	ld	s2,48(sp)
    800016d4:	79a2                	ld	s3,40(sp)
    800016d6:	7a02                	ld	s4,32(sp)
    800016d8:	6ae2                	ld	s5,24(sp)
    800016da:	6b42                	ld	s6,16(sp)
    800016dc:	6ba2                	ld	s7,8(sp)
    800016de:	6c02                	ld	s8,0(sp)
    800016e0:	6161                	addi	sp,sp,80
    800016e2:	8082                	ret

00000000800016e4 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016e4:	c6dd                	beqz	a3,80001792 <copyinstr+0xae>
{
    800016e6:	715d                	addi	sp,sp,-80
    800016e8:	e486                	sd	ra,72(sp)
    800016ea:	e0a2                	sd	s0,64(sp)
    800016ec:	fc26                	sd	s1,56(sp)
    800016ee:	f84a                	sd	s2,48(sp)
    800016f0:	f44e                	sd	s3,40(sp)
    800016f2:	f052                	sd	s4,32(sp)
    800016f4:	ec56                	sd	s5,24(sp)
    800016f6:	e85a                	sd	s6,16(sp)
    800016f8:	e45e                	sd	s7,8(sp)
    800016fa:	0880                	addi	s0,sp,80
    800016fc:	8a2a                	mv	s4,a0
    800016fe:	8b2e                	mv	s6,a1
    80001700:	8bb2                	mv	s7,a2
    80001702:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80001704:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001706:	6985                	lui	s3,0x1
    80001708:	a825                	j	80001740 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000170a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000170e:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001710:	37fd                	addiw	a5,a5,-1
    80001712:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001716:	60a6                	ld	ra,72(sp)
    80001718:	6406                	ld	s0,64(sp)
    8000171a:	74e2                	ld	s1,56(sp)
    8000171c:	7942                	ld	s2,48(sp)
    8000171e:	79a2                	ld	s3,40(sp)
    80001720:	7a02                	ld	s4,32(sp)
    80001722:	6ae2                	ld	s5,24(sp)
    80001724:	6b42                	ld	s6,16(sp)
    80001726:	6ba2                	ld	s7,8(sp)
    80001728:	6161                	addi	sp,sp,80
    8000172a:	8082                	ret
    8000172c:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001730:	9742                	add	a4,a4,a6
      --max;
    80001732:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001736:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    8000173a:	04e58463          	beq	a1,a4,80001782 <copyinstr+0x9e>
{
    8000173e:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001740:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001744:	85a6                	mv	a1,s1
    80001746:	8552                	mv	a0,s4
    80001748:	8c5ff0ef          	jal	8000100c <walkaddr>
    if(pa0 == 0)
    8000174c:	cd0d                	beqz	a0,80001786 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    8000174e:	417486b3          	sub	a3,s1,s7
    80001752:	96ce                	add	a3,a3,s3
    if(n > max)
    80001754:	00d97363          	bgeu	s2,a3,8000175a <copyinstr+0x76>
    80001758:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    8000175a:	955e                	add	a0,a0,s7
    8000175c:	8d05                	sub	a0,a0,s1
    while(n > 0){
    8000175e:	c695                	beqz	a3,8000178a <copyinstr+0xa6>
    80001760:	87da                	mv	a5,s6
    80001762:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001764:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001768:	96da                	add	a3,a3,s6
    8000176a:	85be                	mv	a1,a5
      if(*p == '\0'){
    8000176c:	00f60733          	add	a4,a2,a5
    80001770:	00074703          	lbu	a4,0(a4)
    80001774:	db59                	beqz	a4,8000170a <copyinstr+0x26>
        *dst = *p;
    80001776:	00e78023          	sb	a4,0(a5)
      dst++;
    8000177a:	0785                	addi	a5,a5,1
    while(n > 0){
    8000177c:	fed797e3          	bne	a5,a3,8000176a <copyinstr+0x86>
    80001780:	b775                	j	8000172c <copyinstr+0x48>
    80001782:	4781                	li	a5,0
    80001784:	b771                	j	80001710 <copyinstr+0x2c>
      return -1;
    80001786:	557d                	li	a0,-1
    80001788:	b779                	j	80001716 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    8000178a:	6b85                	lui	s7,0x1
    8000178c:	9ba6                	add	s7,s7,s1
    8000178e:	87da                	mv	a5,s6
    80001790:	b77d                	j	8000173e <copyinstr+0x5a>
  int got_null = 0;
    80001792:	4781                	li	a5,0
  if(got_null){
    80001794:	37fd                	addiw	a5,a5,-1
    80001796:	0007851b          	sext.w	a0,a5
}
    8000179a:	8082                	ret

000000008000179c <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000179c:	7139                	addi	sp,sp,-64
    8000179e:	fc06                	sd	ra,56(sp)
    800017a0:	f822                	sd	s0,48(sp)
    800017a2:	f426                	sd	s1,40(sp)
    800017a4:	f04a                	sd	s2,32(sp)
    800017a6:	ec4e                	sd	s3,24(sp)
    800017a8:	e852                	sd	s4,16(sp)
    800017aa:	e456                	sd	s5,8(sp)
    800017ac:	e05a                	sd	s6,0(sp)
    800017ae:	0080                	addi	s0,sp,64
    800017b0:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800017b2:	00011497          	auipc	s1,0x11
    800017b6:	10e48493          	addi	s1,s1,270 # 800128c0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800017ba:	8b26                	mv	s6,s1
    800017bc:	ff8f6937          	lui	s2,0xff8f6
    800017c0:	c2990913          	addi	s2,s2,-983 # ffffffffff8f5c29 <end+0xffffffff7f8d1b89>
    800017c4:	093e                	slli	s2,s2,0xf
    800017c6:	ae190913          	addi	s2,s2,-1311
    800017ca:	0932                	slli	s2,s2,0xc
    800017cc:	47b90913          	addi	s2,s2,1147
    800017d0:	0936                	slli	s2,s2,0xd
    800017d2:	c2990913          	addi	s2,s2,-983
    800017d6:	040009b7          	lui	s3,0x4000
    800017da:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800017dc:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800017de:	00017a97          	auipc	s5,0x17
    800017e2:	4e2a8a93          	addi	s5,s5,1250 # 80018cc0 <tickslock>
    char *pa = kalloc();
    800017e6:	b3eff0ef          	jal	80000b24 <kalloc>
    800017ea:	862a                	mv	a2,a0
    if(pa == 0)
    800017ec:	cd15                	beqz	a0,80001828 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    800017ee:	416485b3          	sub	a1,s1,s6
    800017f2:	8591                	srai	a1,a1,0x4
    800017f4:	032585b3          	mul	a1,a1,s2
    800017f8:	2585                	addiw	a1,a1,1
    800017fa:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017fe:	4719                	li	a4,6
    80001800:	6685                	lui	a3,0x1
    80001802:	40b985b3          	sub	a1,s3,a1
    80001806:	8552                	mv	a0,s4
    80001808:	8f3ff0ef          	jal	800010fa <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000180c:	19048493          	addi	s1,s1,400
    80001810:	fd549be3          	bne	s1,s5,800017e6 <proc_mapstacks+0x4a>
  }
}
    80001814:	70e2                	ld	ra,56(sp)
    80001816:	7442                	ld	s0,48(sp)
    80001818:	74a2                	ld	s1,40(sp)
    8000181a:	7902                	ld	s2,32(sp)
    8000181c:	69e2                	ld	s3,24(sp)
    8000181e:	6a42                	ld	s4,16(sp)
    80001820:	6aa2                	ld	s5,8(sp)
    80001822:	6b02                	ld	s6,0(sp)
    80001824:	6121                	addi	sp,sp,64
    80001826:	8082                	ret
      panic("kalloc");
    80001828:	00006517          	auipc	a0,0x6
    8000182c:	9d050513          	addi	a0,a0,-1584 # 800071f8 <etext+0x1f8>
    80001830:	f65fe0ef          	jal	80000794 <panic>

0000000080001834 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001834:	7139                	addi	sp,sp,-64
    80001836:	fc06                	sd	ra,56(sp)
    80001838:	f822                	sd	s0,48(sp)
    8000183a:	f426                	sd	s1,40(sp)
    8000183c:	f04a                	sd	s2,32(sp)
    8000183e:	ec4e                	sd	s3,24(sp)
    80001840:	e852                	sd	s4,16(sp)
    80001842:	e456                	sd	s5,8(sp)
    80001844:	e05a                	sd	s6,0(sp)
    80001846:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001848:	00006597          	auipc	a1,0x6
    8000184c:	9b858593          	addi	a1,a1,-1608 # 80007200 <etext+0x200>
    80001850:	00011517          	auipc	a0,0x11
    80001854:	c4050513          	addi	a0,a0,-960 # 80012490 <pid_lock>
    80001858:	b1cff0ef          	jal	80000b74 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000185c:	00006597          	auipc	a1,0x6
    80001860:	9ac58593          	addi	a1,a1,-1620 # 80007208 <etext+0x208>
    80001864:	00011517          	auipc	a0,0x11
    80001868:	c4450513          	addi	a0,a0,-956 # 800124a8 <wait_lock>
    8000186c:	b08ff0ef          	jal	80000b74 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001870:	00011497          	auipc	s1,0x11
    80001874:	05048493          	addi	s1,s1,80 # 800128c0 <proc>
      initlock(&p->lock, "proc");
    80001878:	00006b17          	auipc	s6,0x6
    8000187c:	9a0b0b13          	addi	s6,s6,-1632 # 80007218 <etext+0x218>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001880:	8aa6                	mv	s5,s1
    80001882:	ff8f6937          	lui	s2,0xff8f6
    80001886:	c2990913          	addi	s2,s2,-983 # ffffffffff8f5c29 <end+0xffffffff7f8d1b89>
    8000188a:	093e                	slli	s2,s2,0xf
    8000188c:	ae190913          	addi	s2,s2,-1311
    80001890:	0932                	slli	s2,s2,0xc
    80001892:	47b90913          	addi	s2,s2,1147
    80001896:	0936                	slli	s2,s2,0xd
    80001898:	c2990913          	addi	s2,s2,-983
    8000189c:	040009b7          	lui	s3,0x4000
    800018a0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    800018a2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    800018a4:	00017a17          	auipc	s4,0x17
    800018a8:	41ca0a13          	addi	s4,s4,1052 # 80018cc0 <tickslock>
      initlock(&p->lock, "proc");
    800018ac:	85da                	mv	a1,s6
    800018ae:	8526                	mv	a0,s1
    800018b0:	ac4ff0ef          	jal	80000b74 <initlock>
      p->state = UNUSED;
    800018b4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800018b8:	415487b3          	sub	a5,s1,s5
    800018bc:	8791                	srai	a5,a5,0x4
    800018be:	032787b3          	mul	a5,a5,s2
    800018c2:	2785                	addiw	a5,a5,1
    800018c4:	00d7979b          	slliw	a5,a5,0xd
    800018c8:	40f987b3          	sub	a5,s3,a5
    800018cc:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800018ce:	19048493          	addi	s1,s1,400
    800018d2:	fd449de3          	bne	s1,s4,800018ac <procinit+0x78>
  }
}
    800018d6:	70e2                	ld	ra,56(sp)
    800018d8:	7442                	ld	s0,48(sp)
    800018da:	74a2                	ld	s1,40(sp)
    800018dc:	7902                	ld	s2,32(sp)
    800018de:	69e2                	ld	s3,24(sp)
    800018e0:	6a42                	ld	s4,16(sp)
    800018e2:	6aa2                	ld	s5,8(sp)
    800018e4:	6b02                	ld	s6,0(sp)
    800018e6:	6121                	addi	sp,sp,64
    800018e8:	8082                	ret

00000000800018ea <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018ea:	1141                	addi	sp,sp,-16
    800018ec:	e422                	sd	s0,8(sp)
    800018ee:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800018f0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018f2:	2501                	sext.w	a0,a0
    800018f4:	6422                	ld	s0,8(sp)
    800018f6:	0141                	addi	sp,sp,16
    800018f8:	8082                	ret

00000000800018fa <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800018fa:	1141                	addi	sp,sp,-16
    800018fc:	e422                	sd	s0,8(sp)
    800018fe:	0800                	addi	s0,sp,16
    80001900:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001902:	2781                	sext.w	a5,a5
    80001904:	079e                	slli	a5,a5,0x7
  return c;
}
    80001906:	00011517          	auipc	a0,0x11
    8000190a:	bba50513          	addi	a0,a0,-1094 # 800124c0 <cpus>
    8000190e:	953e                	add	a0,a0,a5
    80001910:	6422                	ld	s0,8(sp)
    80001912:	0141                	addi	sp,sp,16
    80001914:	8082                	ret

0000000080001916 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001916:	1101                	addi	sp,sp,-32
    80001918:	ec06                	sd	ra,24(sp)
    8000191a:	e822                	sd	s0,16(sp)
    8000191c:	e426                	sd	s1,8(sp)
    8000191e:	1000                	addi	s0,sp,32
  push_off();
    80001920:	a94ff0ef          	jal	80000bb4 <push_off>
    80001924:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001926:	2781                	sext.w	a5,a5
    80001928:	079e                	slli	a5,a5,0x7
    8000192a:	00011717          	auipc	a4,0x11
    8000192e:	b6670713          	addi	a4,a4,-1178 # 80012490 <pid_lock>
    80001932:	97ba                	add	a5,a5,a4
    80001934:	7b84                	ld	s1,48(a5)
  pop_off();
    80001936:	b02ff0ef          	jal	80000c38 <pop_off>
  return p;
}
    8000193a:	8526                	mv	a0,s1
    8000193c:	60e2                	ld	ra,24(sp)
    8000193e:	6442                	ld	s0,16(sp)
    80001940:	64a2                	ld	s1,8(sp)
    80001942:	6105                	addi	sp,sp,32
    80001944:	8082                	ret

0000000080001946 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001946:	1141                	addi	sp,sp,-16
    80001948:	e406                	sd	ra,8(sp)
    8000194a:	e022                	sd	s0,0(sp)
    8000194c:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    8000194e:	fc9ff0ef          	jal	80001916 <myproc>
    80001952:	b3aff0ef          	jal	80000c8c <release>

  if (first) {
    80001956:	00009797          	auipc	a5,0x9
    8000195a:	96a7a783          	lw	a5,-1686(a5) # 8000a2c0 <first.1>
    8000195e:	e799                	bnez	a5,8000196c <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001960:	63d000ef          	jal	8000279c <usertrapret>
}
    80001964:	60a2                	ld	ra,8(sp)
    80001966:	6402                	ld	s0,0(sp)
    80001968:	0141                	addi	sp,sp,16
    8000196a:	8082                	ret
    fsinit(ROOTDEV);
    8000196c:	4505                	li	a0,1
    8000196e:	271010ef          	jal	800033de <fsinit>
    first = 0;
    80001972:	00009797          	auipc	a5,0x9
    80001976:	9407a723          	sw	zero,-1714(a5) # 8000a2c0 <first.1>
    __sync_synchronize();
    8000197a:	0330000f          	fence	rw,rw
    8000197e:	b7cd                	j	80001960 <forkret+0x1a>

0000000080001980 <allocpid>:
{
    80001980:	1101                	addi	sp,sp,-32
    80001982:	ec06                	sd	ra,24(sp)
    80001984:	e822                	sd	s0,16(sp)
    80001986:	e426                	sd	s1,8(sp)
    80001988:	e04a                	sd	s2,0(sp)
    8000198a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    8000198c:	00011917          	auipc	s2,0x11
    80001990:	b0490913          	addi	s2,s2,-1276 # 80012490 <pid_lock>
    80001994:	854a                	mv	a0,s2
    80001996:	a5eff0ef          	jal	80000bf4 <acquire>
  pid = nextpid;
    8000199a:	00009797          	auipc	a5,0x9
    8000199e:	92a78793          	addi	a5,a5,-1750 # 8000a2c4 <nextpid>
    800019a2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019a4:	0014871b          	addiw	a4,s1,1
    800019a8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019aa:	854a                	mv	a0,s2
    800019ac:	ae0ff0ef          	jal	80000c8c <release>
}
    800019b0:	8526                	mv	a0,s1
    800019b2:	60e2                	ld	ra,24(sp)
    800019b4:	6442                	ld	s0,16(sp)
    800019b6:	64a2                	ld	s1,8(sp)
    800019b8:	6902                	ld	s2,0(sp)
    800019ba:	6105                	addi	sp,sp,32
    800019bc:	8082                	ret

00000000800019be <proc_pagetable>:
{
    800019be:	1101                	addi	sp,sp,-32
    800019c0:	ec06                	sd	ra,24(sp)
    800019c2:	e822                	sd	s0,16(sp)
    800019c4:	e426                	sd	s1,8(sp)
    800019c6:	e04a                	sd	s2,0(sp)
    800019c8:	1000                	addi	s0,sp,32
    800019ca:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019cc:	8e1ff0ef          	jal	800012ac <uvmcreate>
    800019d0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800019d2:	cd15                	beqz	a0,80001a0e <proc_pagetable+0x50>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800019d4:	4729                	li	a4,10
    800019d6:	00004697          	auipc	a3,0x4
    800019da:	62a68693          	addi	a3,a3,1578 # 80006000 <_trampoline>
    800019de:	6605                	lui	a2,0x1
    800019e0:	040005b7          	lui	a1,0x4000
    800019e4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800019e6:	05b2                	slli	a1,a1,0xc
    800019e8:	e62ff0ef          	jal	8000104a <mappages>
    800019ec:	02054863          	bltz	a0,80001a1c <proc_pagetable+0x5e>
  if(mappages(pagetable, p->trapframe_va = TRAPFRAME, PGSIZE,
    800019f0:	020005b7          	lui	a1,0x2000
    800019f4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800019f6:	05b6                	slli	a1,a1,0xd
    800019f8:	04b93c23          	sd	a1,88(s2)
    800019fc:	4719                	li	a4,6
    800019fe:	06093683          	ld	a3,96(s2)
    80001a02:	6605                	lui	a2,0x1
    80001a04:	8526                	mv	a0,s1
    80001a06:	e44ff0ef          	jal	8000104a <mappages>
    80001a0a:	00054f63          	bltz	a0,80001a28 <proc_pagetable+0x6a>
}
    80001a0e:	8526                	mv	a0,s1
    80001a10:	60e2                	ld	ra,24(sp)
    80001a12:	6442                	ld	s0,16(sp)
    80001a14:	64a2                	ld	s1,8(sp)
    80001a16:	6902                	ld	s2,0(sp)
    80001a18:	6105                	addi	sp,sp,32
    80001a1a:	8082                	ret
    uvmfree(pagetable, 0);
    80001a1c:	4581                	li	a1,0
    80001a1e:	8526                	mv	a0,s1
    80001a20:	a5bff0ef          	jal	8000147a <uvmfree>
    return 0;
    80001a24:	4481                	li	s1,0
    80001a26:	b7e5                	j	80001a0e <proc_pagetable+0x50>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a28:	4681                	li	a3,0
    80001a2a:	4605                	li	a2,1
    80001a2c:	040005b7          	lui	a1,0x4000
    80001a30:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a32:	05b2                	slli	a1,a1,0xc
    80001a34:	8526                	mv	a0,s1
    80001a36:	fbaff0ef          	jal	800011f0 <uvmunmap>
    uvmfree(pagetable, 0);
    80001a3a:	4581                	li	a1,0
    80001a3c:	8526                	mv	a0,s1
    80001a3e:	a3dff0ef          	jal	8000147a <uvmfree>
    return 0;
    80001a42:	4481                	li	s1,0
    80001a44:	b7e9                	j	80001a0e <proc_pagetable+0x50>

0000000080001a46 <proc_freepagetable>:
{
    80001a46:	1101                	addi	sp,sp,-32
    80001a48:	ec06                	sd	ra,24(sp)
    80001a4a:	e822                	sd	s0,16(sp)
    80001a4c:	e426                	sd	s1,8(sp)
    80001a4e:	e04a                	sd	s2,0(sp)
    80001a50:	1000                	addi	s0,sp,32
    80001a52:	84aa                	mv	s1,a0
    80001a54:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a56:	4681                	li	a3,0
    80001a58:	4605                	li	a2,1
    80001a5a:	040005b7          	lui	a1,0x4000
    80001a5e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a60:	05b2                	slli	a1,a1,0xc
    80001a62:	f8eff0ef          	jal	800011f0 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a66:	4681                	li	a3,0
    80001a68:	4605                	li	a2,1
    80001a6a:	020005b7          	lui	a1,0x2000
    80001a6e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a70:	05b6                	slli	a1,a1,0xd
    80001a72:	8526                	mv	a0,s1
    80001a74:	f7cff0ef          	jal	800011f0 <uvmunmap>
  uvmfree(pagetable, sz);
    80001a78:	85ca                	mv	a1,s2
    80001a7a:	8526                	mv	a0,s1
    80001a7c:	9ffff0ef          	jal	8000147a <uvmfree>
}
    80001a80:	60e2                	ld	ra,24(sp)
    80001a82:	6442                	ld	s0,16(sp)
    80001a84:	64a2                	ld	s1,8(sp)
    80001a86:	6902                	ld	s2,0(sp)
    80001a88:	6105                	addi	sp,sp,32
    80001a8a:	8082                	ret

0000000080001a8c <freeproc>:
{
    80001a8c:	1101                	addi	sp,sp,-32
    80001a8e:	ec06                	sd	ra,24(sp)
    80001a90:	e822                	sd	s0,16(sp)
    80001a92:	e426                	sd	s1,8(sp)
    80001a94:	1000                	addi	s0,sp,32
    80001a96:	84aa                	mv	s1,a0
  if (p->isThread == 0) {
    80001a98:	17052783          	lw	a5,368(a0)
    80001a9c:	ebb1                	bnez	a5,80001af0 <freeproc+0x64>
    if(p->pagetable) {
    80001a9e:	6928                	ld	a0,80(a0)
    80001aa0:	c909                	beqz	a0,80001ab2 <freeproc+0x26>
      proc_freepagetable(p->pagetable, p->sz);
    80001aa2:	64ac                	ld	a1,72(s1)
    80001aa4:	fa3ff0ef          	jal	80001a46 <proc_freepagetable>
      p->thread_num = 1;
    80001aa8:	4785                	li	a5,1
    80001aaa:	16f4ac23          	sw	a5,376(s1)
      p->sz = 0;
    80001aae:	0404b423          	sd	zero,72(s1)
  if(p->trapframe)
    80001ab2:	70a8                	ld	a0,96(s1)
    80001ab4:	c119                	beqz	a0,80001aba <freeproc+0x2e>
    kfree((void*)p->trapframe);
    80001ab6:	f8dfe0ef          	jal	80000a42 <kfree>
  p->trapframe = 0;
    80001aba:	0604b023          	sd	zero,96(s1)
  p->trapframe_va = 0;
    80001abe:	0404bc23          	sd	zero,88(s1)
  p->name[0] = 0;
    80001ac2:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001ac6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001aca:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001ace:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ad2:	0004ac23          	sw	zero,24(s1)
  p->pid = 0;
    80001ad6:	0204a823          	sw	zero,48(s1)
  p->tid = 0;
    80001ada:	1604aa23          	sw	zero,372(s1)
  p->parent = 0;
    80001ade:	0204bc23          	sd	zero,56(s1)
  p->pagetable = 0;
    80001ae2:	0404b823          	sd	zero,80(s1)
}
    80001ae6:	60e2                	ld	ra,24(sp)
    80001ae8:	6442                	ld	s0,16(sp)
    80001aea:	64a2                	ld	s1,8(sp)
    80001aec:	6105                	addi	sp,sp,32
    80001aee:	8082                	ret
    p->isThread = 0;
    80001af0:	16052823          	sw	zero,368(a0)
    p->main_thread = 0;
    80001af4:	18053423          	sd	zero,392(a0)
    uvmunmap(p->pagetable, p->trapframe_va, 1, 0);
    80001af8:	4681                	li	a3,0
    80001afa:	4605                	li	a2,1
    80001afc:	6d2c                	ld	a1,88(a0)
    80001afe:	6928                	ld	a0,80(a0)
    80001b00:	ef0ff0ef          	jal	800011f0 <uvmunmap>
    80001b04:	b77d                	j	80001ab2 <freeproc+0x26>

0000000080001b06 <allocproc>:
{
    80001b06:	7179                	addi	sp,sp,-48
    80001b08:	f406                	sd	ra,40(sp)
    80001b0a:	f022                	sd	s0,32(sp)
    80001b0c:	ec26                	sd	s1,24(sp)
    80001b0e:	e84a                	sd	s2,16(sp)
    80001b10:	e44e                	sd	s3,8(sp)
    80001b12:	1800                	addi	s0,sp,48
    80001b14:	89aa                	mv	s3,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b16:	00011497          	auipc	s1,0x11
    80001b1a:	daa48493          	addi	s1,s1,-598 # 800128c0 <proc>
    80001b1e:	00017917          	auipc	s2,0x17
    80001b22:	1a290913          	addi	s2,s2,418 # 80018cc0 <tickslock>
    acquire(&p->lock);
    80001b26:	8526                	mv	a0,s1
    80001b28:	8ccff0ef          	jal	80000bf4 <acquire>
    if(p->state == UNUSED) {
    80001b2c:	4c9c                	lw	a5,24(s1)
    80001b2e:	cb91                	beqz	a5,80001b42 <allocproc+0x3c>
      release(&p->lock);
    80001b30:	8526                	mv	a0,s1
    80001b32:	95aff0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001b36:	19048493          	addi	s1,s1,400
    80001b3a:	ff2496e3          	bne	s1,s2,80001b26 <allocproc+0x20>
  return 0;
    80001b3e:	4481                	li	s1,0
    80001b40:	a82d                	j	80001b7a <allocproc+0x74>
  p->pid = allocpid();
    80001b42:	e3fff0ef          	jal	80001980 <allocpid>
    80001b46:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b48:	4785                	li	a5,1
    80001b4a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001b4c:	fd9fe0ef          	jal	80000b24 <kalloc>
    80001b50:	892a                	mv	s2,a0
    80001b52:	f0a8                	sd	a0,96(s1)
    80001b54:	c91d                	beqz	a0,80001b8a <allocproc+0x84>
  memset(&p->context, 0, sizeof(p->context));
    80001b56:	07000613          	li	a2,112
    80001b5a:	4581                	li	a1,0
    80001b5c:	06848513          	addi	a0,s1,104
    80001b60:	968ff0ef          	jal	80000cc8 <memset>
  p->context.ra = (uint64)forkret;
    80001b64:	00000797          	auipc	a5,0x0
    80001b68:	de278793          	addi	a5,a5,-542 # 80001946 <forkret>
    80001b6c:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b6e:	60bc                	ld	a5,64(s1)
    80001b70:	6705                	lui	a4,0x1
    80001b72:	97ba                	add	a5,a5,a4
    80001b74:	f8bc                	sd	a5,112(s1)
  if (isThread == 0) {
    80001b76:	02098263          	beqz	s3,80001b9a <allocproc+0x94>
}
    80001b7a:	8526                	mv	a0,s1
    80001b7c:	70a2                	ld	ra,40(sp)
    80001b7e:	7402                	ld	s0,32(sp)
    80001b80:	64e2                	ld	s1,24(sp)
    80001b82:	6942                	ld	s2,16(sp)
    80001b84:	69a2                	ld	s3,8(sp)
    80001b86:	6145                	addi	sp,sp,48
    80001b88:	8082                	ret
    release(&p->lock);
    80001b8a:	8526                	mv	a0,s1
    80001b8c:	900ff0ef          	jal	80000c8c <release>
    freeproc(p);
    80001b90:	8526                	mv	a0,s1
    80001b92:	efbff0ef          	jal	80001a8c <freeproc>
    return 0;
    80001b96:	84ca                	mv	s1,s2
    80001b98:	b7cd                	j	80001b7a <allocproc+0x74>
    p->pagetable = proc_pagetable(p);
    80001b9a:	8526                	mv	a0,s1
    80001b9c:	e23ff0ef          	jal	800019be <proc_pagetable>
    80001ba0:	892a                	mv	s2,a0
    80001ba2:	e8a8                	sd	a0,80(s1)
    if(p->pagetable == 0){
    80001ba4:	cd09                	beqz	a0,80001bbe <allocproc+0xb8>
    p->isThread = 0;                
    80001ba6:	1604a823          	sw	zero,368(s1)
    p->tid = 1;               
    80001baa:	4785                	li	a5,1
    80001bac:	16f4aa23          	sw	a5,372(s1)
    p->main_thread = 0;   
    80001bb0:	1804b423          	sd	zero,392(s1)
    p->stack = 0; 
    80001bb4:	1804b023          	sd	zero,384(s1)
    p->thread_num = 1;
    80001bb8:	16f4ac23          	sw	a5,376(s1)
    80001bbc:	bf7d                	j	80001b7a <allocproc+0x74>
      release(&p->lock);
    80001bbe:	8526                	mv	a0,s1
    80001bc0:	8ccff0ef          	jal	80000c8c <release>
      freeproc(p);
    80001bc4:	8526                	mv	a0,s1
    80001bc6:	ec7ff0ef          	jal	80001a8c <freeproc>
      return 0;
    80001bca:	84ca                	mv	s1,s2
    80001bcc:	b77d                	j	80001b7a <allocproc+0x74>

0000000080001bce <userinit>:
{
    80001bce:	1101                	addi	sp,sp,-32
    80001bd0:	ec06                	sd	ra,24(sp)
    80001bd2:	e822                	sd	s0,16(sp)
    80001bd4:	e426                	sd	s1,8(sp)
    80001bd6:	1000                	addi	s0,sp,32
  p = allocproc(0);
    80001bd8:	4501                	li	a0,0
    80001bda:	f2dff0ef          	jal	80001b06 <allocproc>
    80001bde:	84aa                	mv	s1,a0
  initproc = p;
    80001be0:	00008797          	auipc	a5,0x8
    80001be4:	76a7bc23          	sd	a0,1912(a5) # 8000a358 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001be8:	03400613          	li	a2,52
    80001bec:	00008597          	auipc	a1,0x8
    80001bf0:	6e458593          	addi	a1,a1,1764 # 8000a2d0 <initcode>
    80001bf4:	6928                	ld	a0,80(a0)
    80001bf6:	edcff0ef          	jal	800012d2 <uvmfirst>
  p->sz = PGSIZE;
    80001bfa:	6785                	lui	a5,0x1
    80001bfc:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001bfe:	70b8                	ld	a4,96(s1)
    80001c00:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001c04:	70b8                	ld	a4,96(s1)
    80001c06:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001c08:	4641                	li	a2,16
    80001c0a:	00005597          	auipc	a1,0x5
    80001c0e:	61658593          	addi	a1,a1,1558 # 80007220 <etext+0x220>
    80001c12:	16048513          	addi	a0,s1,352
    80001c16:	9f0ff0ef          	jal	80000e06 <safestrcpy>
  p->cwd = namei("/");
    80001c1a:	00005517          	auipc	a0,0x5
    80001c1e:	61650513          	addi	a0,a0,1558 # 80007230 <etext+0x230>
    80001c22:	0ca020ef          	jal	80003cec <namei>
    80001c26:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001c2a:	478d                	li	a5,3
    80001c2c:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001c2e:	8526                	mv	a0,s1
    80001c30:	85cff0ef          	jal	80000c8c <release>
}
    80001c34:	60e2                	ld	ra,24(sp)
    80001c36:	6442                	ld	s0,16(sp)
    80001c38:	64a2                	ld	s1,8(sp)
    80001c3a:	6105                	addi	sp,sp,32
    80001c3c:	8082                	ret

0000000080001c3e <growproc>:
{
    80001c3e:	7179                	addi	sp,sp,-48
    80001c40:	f406                	sd	ra,40(sp)
    80001c42:	f022                	sd	s0,32(sp)
    80001c44:	ec26                	sd	s1,24(sp)
    80001c46:	e84a                	sd	s2,16(sp)
    80001c48:	e44e                	sd	s3,8(sp)
    80001c4a:	1800                	addi	s0,sp,48
    80001c4c:	892a                	mv	s2,a0
  struct proc *p = myproc()->isThread ? myproc()->main_thread : myproc();
    80001c4e:	cc9ff0ef          	jal	80001916 <myproc>
    80001c52:	17052783          	lw	a5,368(a0)
    80001c56:	cb95                	beqz	a5,80001c8a <growproc+0x4c>
    80001c58:	cbfff0ef          	jal	80001916 <myproc>
    80001c5c:	18853483          	ld	s1,392(a0)
  acquire(&p->lock);
    80001c60:	89a6                	mv	s3,s1
    80001c62:	8526                	mv	a0,s1
    80001c64:	f91fe0ef          	jal	80000bf4 <acquire>
  sz = p->sz;
    80001c68:	64ac                	ld	a1,72(s1)
  if(n > 0){
    80001c6a:	03204463          	bgtz	s2,80001c92 <growproc+0x54>
  } else if(n < 0){
    80001c6e:	02094c63          	bltz	s2,80001ca6 <growproc+0x68>
  p->sz = sz;
    80001c72:	e4ac                	sd	a1,72(s1)
  release(&p->lock);
    80001c74:	854e                	mv	a0,s3
    80001c76:	816ff0ef          	jal	80000c8c <release>
  return 0;
    80001c7a:	4501                	li	a0,0
}
    80001c7c:	70a2                	ld	ra,40(sp)
    80001c7e:	7402                	ld	s0,32(sp)
    80001c80:	64e2                	ld	s1,24(sp)
    80001c82:	6942                	ld	s2,16(sp)
    80001c84:	69a2                	ld	s3,8(sp)
    80001c86:	6145                	addi	sp,sp,48
    80001c88:	8082                	ret
  struct proc *p = myproc()->isThread ? myproc()->main_thread : myproc();
    80001c8a:	c8dff0ef          	jal	80001916 <myproc>
    80001c8e:	84aa                	mv	s1,a0
    80001c90:	bfc1                	j	80001c60 <growproc+0x22>
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c92:	4691                	li	a3,4
    80001c94:	00b90633          	add	a2,s2,a1
    80001c98:	68a8                	ld	a0,80(s1)
    80001c9a:	edaff0ef          	jal	80001374 <uvmalloc>
    80001c9e:	85aa                	mv	a1,a0
    80001ca0:	f969                	bnez	a0,80001c72 <growproc+0x34>
      return -1;
    80001ca2:	557d                	li	a0,-1
    80001ca4:	bfe1                	j	80001c7c <growproc+0x3e>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001ca6:	00b90633          	add	a2,s2,a1
    80001caa:	68a8                	ld	a0,80(s1)
    80001cac:	e84ff0ef          	jal	80001330 <uvmdealloc>
    80001cb0:	85aa                	mv	a1,a0
    80001cb2:	b7c1                	j	80001c72 <growproc+0x34>

0000000080001cb4 <fork>:
{
    80001cb4:	7139                	addi	sp,sp,-64
    80001cb6:	fc06                	sd	ra,56(sp)
    80001cb8:	f822                	sd	s0,48(sp)
    80001cba:	f04a                	sd	s2,32(sp)
    80001cbc:	e852                	sd	s4,16(sp)
    80001cbe:	e456                	sd	s5,8(sp)
    80001cc0:	e05a                	sd	s6,0(sp)
    80001cc2:	0080                	addi	s0,sp,64
  struct proc *t = myproc();
    80001cc4:	c53ff0ef          	jal	80001916 <myproc>
    80001cc8:	8b2a                	mv	s6,a0
  struct proc *p = t->isThread ? t->main_thread : t;
    80001cca:	17052783          	lw	a5,368(a0)
    80001cce:	8aaa                	mv	s5,a0
    80001cd0:	c399                	beqz	a5,80001cd6 <fork+0x22>
    80001cd2:	18853a83          	ld	s5,392(a0)
  if((np = allocproc(0)) == 0){
    80001cd6:	4501                	li	a0,0
    80001cd8:	e2fff0ef          	jal	80001b06 <allocproc>
    80001cdc:	8a2a                	mv	s4,a0
    80001cde:	0e050863          	beqz	a0,80001dce <fork+0x11a>
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001ce2:	048ab603          	ld	a2,72(s5)
    80001ce6:	692c                	ld	a1,80(a0)
    80001ce8:	050ab503          	ld	a0,80(s5)
    80001cec:	fc0ff0ef          	jal	800014ac <uvmcopy>
    80001cf0:	04054a63          	bltz	a0,80001d44 <fork+0x90>
    80001cf4:	f426                	sd	s1,40(sp)
    80001cf6:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001cf8:	048ab783          	ld	a5,72(s5)
    80001cfc:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(t->trapframe);
    80001d00:	060b3683          	ld	a3,96(s6)
    80001d04:	87b6                	mv	a5,a3
    80001d06:	060a3703          	ld	a4,96(s4)
    80001d0a:	12068693          	addi	a3,a3,288
    80001d0e:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001d12:	6788                	ld	a0,8(a5)
    80001d14:	6b8c                	ld	a1,16(a5)
    80001d16:	6f90                	ld	a2,24(a5)
    80001d18:	01073023          	sd	a6,0(a4)
    80001d1c:	e708                	sd	a0,8(a4)
    80001d1e:	eb0c                	sd	a1,16(a4)
    80001d20:	ef10                	sd	a2,24(a4)
    80001d22:	02078793          	addi	a5,a5,32
    80001d26:	02070713          	addi	a4,a4,32
    80001d2a:	fed792e3          	bne	a5,a3,80001d0e <fork+0x5a>
  np->trapframe->a0 = 0;
    80001d2e:	060a3783          	ld	a5,96(s4)
    80001d32:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001d36:	0d8a8493          	addi	s1,s5,216
    80001d3a:	0d8a0913          	addi	s2,s4,216
    80001d3e:	158a8993          	addi	s3,s5,344
    80001d42:	a829                	j	80001d5c <fork+0xa8>
    freeproc(np);
    80001d44:	8552                	mv	a0,s4
    80001d46:	d47ff0ef          	jal	80001a8c <freeproc>
    release(&np->lock);
    80001d4a:	8552                	mv	a0,s4
    80001d4c:	f41fe0ef          	jal	80000c8c <release>
    return -1;
    80001d50:	597d                	li	s2,-1
    80001d52:	a0ad                	j	80001dbc <fork+0x108>
  for(i = 0; i < NOFILE; i++)
    80001d54:	04a1                	addi	s1,s1,8
    80001d56:	0921                	addi	s2,s2,8
    80001d58:	01348963          	beq	s1,s3,80001d6a <fork+0xb6>
    if(p->ofile[i])
    80001d5c:	6088                	ld	a0,0(s1)
    80001d5e:	d97d                	beqz	a0,80001d54 <fork+0xa0>
      np->ofile[i] = filedup(p->ofile[i]);
    80001d60:	51c020ef          	jal	8000427c <filedup>
    80001d64:	00a93023          	sd	a0,0(s2)
    80001d68:	b7f5                	j	80001d54 <fork+0xa0>
  np->cwd = idup(p->cwd);
    80001d6a:	158ab503          	ld	a0,344(s5)
    80001d6e:	06f010ef          	jal	800035dc <idup>
    80001d72:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001d76:	4641                	li	a2,16
    80001d78:	160a8593          	addi	a1,s5,352
    80001d7c:	160a0513          	addi	a0,s4,352
    80001d80:	886ff0ef          	jal	80000e06 <safestrcpy>
  pid = np->pid;
    80001d84:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001d88:	8552                	mv	a0,s4
    80001d8a:	f03fe0ef          	jal	80000c8c <release>
  acquire(&wait_lock);
    80001d8e:	00010497          	auipc	s1,0x10
    80001d92:	71a48493          	addi	s1,s1,1818 # 800124a8 <wait_lock>
    80001d96:	8526                	mv	a0,s1
    80001d98:	e5dfe0ef          	jal	80000bf4 <acquire>
  np->parent = t;
    80001d9c:	036a3c23          	sd	s6,56(s4)
  release(&wait_lock);
    80001da0:	8526                	mv	a0,s1
    80001da2:	eebfe0ef          	jal	80000c8c <release>
  acquire(&np->lock);
    80001da6:	8552                	mv	a0,s4
    80001da8:	e4dfe0ef          	jal	80000bf4 <acquire>
  np->state = RUNNABLE;
    80001dac:	478d                	li	a5,3
    80001dae:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001db2:	8552                	mv	a0,s4
    80001db4:	ed9fe0ef          	jal	80000c8c <release>
  return pid;
    80001db8:	74a2                	ld	s1,40(sp)
    80001dba:	69e2                	ld	s3,24(sp)
}
    80001dbc:	854a                	mv	a0,s2
    80001dbe:	70e2                	ld	ra,56(sp)
    80001dc0:	7442                	ld	s0,48(sp)
    80001dc2:	7902                	ld	s2,32(sp)
    80001dc4:	6a42                	ld	s4,16(sp)
    80001dc6:	6aa2                	ld	s5,8(sp)
    80001dc8:	6b02                	ld	s6,0(sp)
    80001dca:	6121                	addi	sp,sp,64
    80001dcc:	8082                	ret
    return -1;
    80001dce:	597d                	li	s2,-1
    80001dd0:	b7f5                	j	80001dbc <fork+0x108>

0000000080001dd2 <scheduler>:
{
    80001dd2:	715d                	addi	sp,sp,-80
    80001dd4:	e486                	sd	ra,72(sp)
    80001dd6:	e0a2                	sd	s0,64(sp)
    80001dd8:	fc26                	sd	s1,56(sp)
    80001dda:	f84a                	sd	s2,48(sp)
    80001ddc:	f44e                	sd	s3,40(sp)
    80001dde:	f052                	sd	s4,32(sp)
    80001de0:	ec56                	sd	s5,24(sp)
    80001de2:	e85a                	sd	s6,16(sp)
    80001de4:	e45e                	sd	s7,8(sp)
    80001de6:	e062                	sd	s8,0(sp)
    80001de8:	0880                	addi	s0,sp,80
    80001dea:	8792                	mv	a5,tp
  int id = r_tp();
    80001dec:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001dee:	00779b13          	slli	s6,a5,0x7
    80001df2:	00010717          	auipc	a4,0x10
    80001df6:	69e70713          	addi	a4,a4,1694 # 80012490 <pid_lock>
    80001dfa:	975a                	add	a4,a4,s6
    80001dfc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001e00:	00010717          	auipc	a4,0x10
    80001e04:	6c870713          	addi	a4,a4,1736 # 800124c8 <cpus+0x8>
    80001e08:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001e0a:	4c11                	li	s8,4
        c->proc = p;
    80001e0c:	079e                	slli	a5,a5,0x7
    80001e0e:	00010a17          	auipc	s4,0x10
    80001e12:	682a0a13          	addi	s4,s4,1666 # 80012490 <pid_lock>
    80001e16:	9a3e                	add	s4,s4,a5
        found = 1;
    80001e18:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e1a:	00017997          	auipc	s3,0x17
    80001e1e:	ea698993          	addi	s3,s3,-346 # 80018cc0 <tickslock>
    80001e22:	a0a9                	j	80001e6c <scheduler+0x9a>
      release(&p->lock);
    80001e24:	8526                	mv	a0,s1
    80001e26:	e67fe0ef          	jal	80000c8c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e2a:	19048493          	addi	s1,s1,400
    80001e2e:	03348563          	beq	s1,s3,80001e58 <scheduler+0x86>
      acquire(&p->lock);
    80001e32:	8526                	mv	a0,s1
    80001e34:	dc1fe0ef          	jal	80000bf4 <acquire>
      if(p->state == RUNNABLE) {
    80001e38:	4c9c                	lw	a5,24(s1)
    80001e3a:	ff2795e3          	bne	a5,s2,80001e24 <scheduler+0x52>
        p->state = RUNNING;
    80001e3e:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001e42:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001e46:	06848593          	addi	a1,s1,104
    80001e4a:	855a                	mv	a0,s6
    80001e4c:	0ab000ef          	jal	800026f6 <swtch>
        c->proc = 0;
    80001e50:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001e54:	8ade                	mv	s5,s7
    80001e56:	b7f9                	j	80001e24 <scheduler+0x52>
    if(found == 0) {
    80001e58:	000a9a63          	bnez	s5,80001e6c <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e5c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e60:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e64:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001e68:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e6c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001e70:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e74:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001e78:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001e7a:	00011497          	auipc	s1,0x11
    80001e7e:	a4648493          	addi	s1,s1,-1466 # 800128c0 <proc>
      if(p->state == RUNNABLE) {
    80001e82:	490d                	li	s2,3
    80001e84:	b77d                	j	80001e32 <scheduler+0x60>

0000000080001e86 <sched>:
{
    80001e86:	7179                	addi	sp,sp,-48
    80001e88:	f406                	sd	ra,40(sp)
    80001e8a:	f022                	sd	s0,32(sp)
    80001e8c:	ec26                	sd	s1,24(sp)
    80001e8e:	e84a                	sd	s2,16(sp)
    80001e90:	e44e                	sd	s3,8(sp)
    80001e92:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e94:	a83ff0ef          	jal	80001916 <myproc>
    80001e98:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001e9a:	cf1fe0ef          	jal	80000b8a <holding>
    80001e9e:	c92d                	beqz	a0,80001f10 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ea0:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001ea2:	2781                	sext.w	a5,a5
    80001ea4:	079e                	slli	a5,a5,0x7
    80001ea6:	00010717          	auipc	a4,0x10
    80001eaa:	5ea70713          	addi	a4,a4,1514 # 80012490 <pid_lock>
    80001eae:	97ba                	add	a5,a5,a4
    80001eb0:	0a87a703          	lw	a4,168(a5)
    80001eb4:	4785                	li	a5,1
    80001eb6:	06f71363          	bne	a4,a5,80001f1c <sched+0x96>
  if(p->state == RUNNING)
    80001eba:	4c98                	lw	a4,24(s1)
    80001ebc:	4791                	li	a5,4
    80001ebe:	06f70563          	beq	a4,a5,80001f28 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ec2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ec6:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001ec8:	e7b5                	bnez	a5,80001f34 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001eca:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001ecc:	00010917          	auipc	s2,0x10
    80001ed0:	5c490913          	addi	s2,s2,1476 # 80012490 <pid_lock>
    80001ed4:	2781                	sext.w	a5,a5
    80001ed6:	079e                	slli	a5,a5,0x7
    80001ed8:	97ca                	add	a5,a5,s2
    80001eda:	0ac7a983          	lw	s3,172(a5)
    80001ede:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001ee0:	2781                	sext.w	a5,a5
    80001ee2:	079e                	slli	a5,a5,0x7
    80001ee4:	00010597          	auipc	a1,0x10
    80001ee8:	5e458593          	addi	a1,a1,1508 # 800124c8 <cpus+0x8>
    80001eec:	95be                	add	a1,a1,a5
    80001eee:	06848513          	addi	a0,s1,104
    80001ef2:	005000ef          	jal	800026f6 <swtch>
    80001ef6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001ef8:	2781                	sext.w	a5,a5
    80001efa:	079e                	slli	a5,a5,0x7
    80001efc:	993e                	add	s2,s2,a5
    80001efe:	0b392623          	sw	s3,172(s2)
}
    80001f02:	70a2                	ld	ra,40(sp)
    80001f04:	7402                	ld	s0,32(sp)
    80001f06:	64e2                	ld	s1,24(sp)
    80001f08:	6942                	ld	s2,16(sp)
    80001f0a:	69a2                	ld	s3,8(sp)
    80001f0c:	6145                	addi	sp,sp,48
    80001f0e:	8082                	ret
    panic("sched p->lock");
    80001f10:	00005517          	auipc	a0,0x5
    80001f14:	32850513          	addi	a0,a0,808 # 80007238 <etext+0x238>
    80001f18:	87dfe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80001f1c:	00005517          	auipc	a0,0x5
    80001f20:	32c50513          	addi	a0,a0,812 # 80007248 <etext+0x248>
    80001f24:	871fe0ef          	jal	80000794 <panic>
    panic("sched running");
    80001f28:	00005517          	auipc	a0,0x5
    80001f2c:	33050513          	addi	a0,a0,816 # 80007258 <etext+0x258>
    80001f30:	865fe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    80001f34:	00005517          	auipc	a0,0x5
    80001f38:	33450513          	addi	a0,a0,820 # 80007268 <etext+0x268>
    80001f3c:	859fe0ef          	jal	80000794 <panic>

0000000080001f40 <yield>:
{
    80001f40:	1101                	addi	sp,sp,-32
    80001f42:	ec06                	sd	ra,24(sp)
    80001f44:	e822                	sd	s0,16(sp)
    80001f46:	e426                	sd	s1,8(sp)
    80001f48:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f4a:	9cdff0ef          	jal	80001916 <myproc>
    80001f4e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001f50:	ca5fe0ef          	jal	80000bf4 <acquire>
  p->state = RUNNABLE;
    80001f54:	478d                	li	a5,3
    80001f56:	cc9c                	sw	a5,24(s1)
  sched();
    80001f58:	f2fff0ef          	jal	80001e86 <sched>
  release(&p->lock);
    80001f5c:	8526                	mv	a0,s1
    80001f5e:	d2ffe0ef          	jal	80000c8c <release>
}
    80001f62:	60e2                	ld	ra,24(sp)
    80001f64:	6442                	ld	s0,16(sp)
    80001f66:	64a2                	ld	s1,8(sp)
    80001f68:	6105                	addi	sp,sp,32
    80001f6a:	8082                	ret

0000000080001f6c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001f6c:	7179                	addi	sp,sp,-48
    80001f6e:	f406                	sd	ra,40(sp)
    80001f70:	f022                	sd	s0,32(sp)
    80001f72:	ec26                	sd	s1,24(sp)
    80001f74:	e84a                	sd	s2,16(sp)
    80001f76:	e44e                	sd	s3,8(sp)
    80001f78:	1800                	addi	s0,sp,48
    80001f7a:	89aa                	mv	s3,a0
    80001f7c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001f7e:	999ff0ef          	jal	80001916 <myproc>
    80001f82:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001f84:	c71fe0ef          	jal	80000bf4 <acquire>
  release(lk);
    80001f88:	854a                	mv	a0,s2
    80001f8a:	d03fe0ef          	jal	80000c8c <release>

  // Go to sleep.
  p->chan = chan;
    80001f8e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001f92:	4789                	li	a5,2
    80001f94:	cc9c                	sw	a5,24(s1)

  sched();
    80001f96:	ef1ff0ef          	jal	80001e86 <sched>

  // Tidy up.
  p->chan = 0;
    80001f9a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f9e:	8526                	mv	a0,s1
    80001fa0:	cedfe0ef          	jal	80000c8c <release>
  acquire(lk);
    80001fa4:	854a                	mv	a0,s2
    80001fa6:	c4ffe0ef          	jal	80000bf4 <acquire>
}
    80001faa:	70a2                	ld	ra,40(sp)
    80001fac:	7402                	ld	s0,32(sp)
    80001fae:	64e2                	ld	s1,24(sp)
    80001fb0:	6942                	ld	s2,16(sp)
    80001fb2:	69a2                	ld	s3,8(sp)
    80001fb4:	6145                	addi	sp,sp,48
    80001fb6:	8082                	ret

0000000080001fb8 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001fb8:	7139                	addi	sp,sp,-64
    80001fba:	fc06                	sd	ra,56(sp)
    80001fbc:	f822                	sd	s0,48(sp)
    80001fbe:	f426                	sd	s1,40(sp)
    80001fc0:	f04a                	sd	s2,32(sp)
    80001fc2:	ec4e                	sd	s3,24(sp)
    80001fc4:	e852                	sd	s4,16(sp)
    80001fc6:	e456                	sd	s5,8(sp)
    80001fc8:	0080                	addi	s0,sp,64
    80001fca:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001fcc:	00011497          	auipc	s1,0x11
    80001fd0:	8f448493          	addi	s1,s1,-1804 # 800128c0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001fd4:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001fd6:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001fd8:	00017917          	auipc	s2,0x17
    80001fdc:	ce890913          	addi	s2,s2,-792 # 80018cc0 <tickslock>
    80001fe0:	a801                	j	80001ff0 <wakeup+0x38>
      }
      release(&p->lock);
    80001fe2:	8526                	mv	a0,s1
    80001fe4:	ca9fe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001fe8:	19048493          	addi	s1,s1,400
    80001fec:	03248263          	beq	s1,s2,80002010 <wakeup+0x58>
    if(p != myproc()){
    80001ff0:	927ff0ef          	jal	80001916 <myproc>
    80001ff4:	fea48ae3          	beq	s1,a0,80001fe8 <wakeup+0x30>
      acquire(&p->lock);
    80001ff8:	8526                	mv	a0,s1
    80001ffa:	bfbfe0ef          	jal	80000bf4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001ffe:	4c9c                	lw	a5,24(s1)
    80002000:	ff3791e3          	bne	a5,s3,80001fe2 <wakeup+0x2a>
    80002004:	709c                	ld	a5,32(s1)
    80002006:	fd479ee3          	bne	a5,s4,80001fe2 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000200a:	0154ac23          	sw	s5,24(s1)
    8000200e:	bfd1                	j	80001fe2 <wakeup+0x2a>
    }
  }
}
    80002010:	70e2                	ld	ra,56(sp)
    80002012:	7442                	ld	s0,48(sp)
    80002014:	74a2                	ld	s1,40(sp)
    80002016:	7902                	ld	s2,32(sp)
    80002018:	69e2                	ld	s3,24(sp)
    8000201a:	6a42                	ld	s4,16(sp)
    8000201c:	6aa2                	ld	s5,8(sp)
    8000201e:	6121                	addi	sp,sp,64
    80002020:	8082                	ret

0000000080002022 <reparent>:
{
    80002022:	7179                	addi	sp,sp,-48
    80002024:	f406                	sd	ra,40(sp)
    80002026:	f022                	sd	s0,32(sp)
    80002028:	ec26                	sd	s1,24(sp)
    8000202a:	e84a                	sd	s2,16(sp)
    8000202c:	e44e                	sd	s3,8(sp)
    8000202e:	e052                	sd	s4,0(sp)
    80002030:	1800                	addi	s0,sp,48
    80002032:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002034:	00011497          	auipc	s1,0x11
    80002038:	88c48493          	addi	s1,s1,-1908 # 800128c0 <proc>
      pp->parent = initproc;
    8000203c:	00008a17          	auipc	s4,0x8
    80002040:	31ca0a13          	addi	s4,s4,796 # 8000a358 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002044:	00017997          	auipc	s3,0x17
    80002048:	c7c98993          	addi	s3,s3,-900 # 80018cc0 <tickslock>
    8000204c:	a029                	j	80002056 <reparent+0x34>
    8000204e:	19048493          	addi	s1,s1,400
    80002052:	01348b63          	beq	s1,s3,80002068 <reparent+0x46>
    if(pp->parent == p){
    80002056:	7c9c                	ld	a5,56(s1)
    80002058:	ff279be3          	bne	a5,s2,8000204e <reparent+0x2c>
      pp->parent = initproc;
    8000205c:	000a3503          	ld	a0,0(s4)
    80002060:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80002062:	f57ff0ef          	jal	80001fb8 <wakeup>
    80002066:	b7e5                	j	8000204e <reparent+0x2c>
}
    80002068:	70a2                	ld	ra,40(sp)
    8000206a:	7402                	ld	s0,32(sp)
    8000206c:	64e2                	ld	s1,24(sp)
    8000206e:	6942                	ld	s2,16(sp)
    80002070:	69a2                	ld	s3,8(sp)
    80002072:	6a02                	ld	s4,0(sp)
    80002074:	6145                	addi	sp,sp,48
    80002076:	8082                	ret

0000000080002078 <exit>:
{
    80002078:	715d                	addi	sp,sp,-80
    8000207a:	e486                	sd	ra,72(sp)
    8000207c:	e0a2                	sd	s0,64(sp)
    8000207e:	fc26                	sd	s1,56(sp)
    80002080:	f84a                	sd	s2,48(sp)
    80002082:	f44e                	sd	s3,40(sp)
    80002084:	f052                	sd	s4,32(sp)
    80002086:	ec56                	sd	s5,24(sp)
    80002088:	0880                	addi	s0,sp,80
    8000208a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000208c:	88bff0ef          	jal	80001916 <myproc>
    80002090:	892a                	mv	s2,a0
  struct proc *main = p->isThread ? p->main_thread : p;
    80002092:	17052783          	lw	a5,368(a0)
    80002096:	8aaa                	mv	s5,a0
    80002098:	c399                	beqz	a5,8000209e <exit+0x26>
    8000209a:	18853a83          	ld	s5,392(a0)
  if(p == initproc)
    8000209e:	00008797          	auipc	a5,0x8
    800020a2:	2ba7b783          	ld	a5,698(a5) # 8000a358 <initproc>
    800020a6:	0d890493          	addi	s1,s2,216
    800020aa:	15890993          	addi	s3,s2,344
    800020ae:	01278563          	beq	a5,s2,800020b8 <exit+0x40>
    800020b2:	e85a                	sd	s6,16(sp)
    800020b4:	e45e                	sd	s7,8(sp)
    800020b6:	a821                	j	800020ce <exit+0x56>
    800020b8:	e85a                	sd	s6,16(sp)
    800020ba:	e45e                	sd	s7,8(sp)
    panic("init exiting");
    800020bc:	00005517          	auipc	a0,0x5
    800020c0:	1c450513          	addi	a0,a0,452 # 80007280 <etext+0x280>
    800020c4:	ed0fe0ef          	jal	80000794 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800020c8:	04a1                	addi	s1,s1,8
    800020ca:	01348963          	beq	s1,s3,800020dc <exit+0x64>
    if(p->ofile[fd]){
    800020ce:	6088                	ld	a0,0(s1)
    800020d0:	dd65                	beqz	a0,800020c8 <exit+0x50>
      fileclose(f);
    800020d2:	1f0020ef          	jal	800042c2 <fileclose>
      p->ofile[fd] = 0;
    800020d6:	0004b023          	sd	zero,0(s1)
    800020da:	b7fd                	j	800020c8 <exit+0x50>
  begin_op();
    800020dc:	5cd010ef          	jal	80003ea8 <begin_op>
  iput(p->cwd);
    800020e0:	15893503          	ld	a0,344(s2)
    800020e4:	6b0010ef          	jal	80003794 <iput>
  end_op();
    800020e8:	62b010ef          	jal	80003f12 <end_op>
  p->cwd = 0;
    800020ec:	14093c23          	sd	zero,344(s2)
  acquire(&wait_lock);
    800020f0:	00010517          	auipc	a0,0x10
    800020f4:	3b850513          	addi	a0,a0,952 # 800124a8 <wait_lock>
    800020f8:	afdfe0ef          	jal	80000bf4 <acquire>
  if (p == main) {
    800020fc:	032a8e63          	beq	s5,s2,80002138 <exit+0xc0>
    wakeup(main);
    80002100:	8556                	mv	a0,s5
    80002102:	eb7ff0ef          	jal	80001fb8 <wakeup>
  reparent(p);
    80002106:	854a                	mv	a0,s2
    80002108:	f1bff0ef          	jal	80002022 <reparent>
  acquire(&p->lock);
    8000210c:	854a                	mv	a0,s2
    8000210e:	ae7fe0ef          	jal	80000bf4 <acquire>
  p->xstate = status;
    80002112:	03492623          	sw	s4,44(s2)
  p->state = ZOMBIE;
    80002116:	4795                	li	a5,5
    80002118:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    8000211c:	00010517          	auipc	a0,0x10
    80002120:	38c50513          	addi	a0,a0,908 # 800124a8 <wait_lock>
    80002124:	b69fe0ef          	jal	80000c8c <release>
  sched();
    80002128:	d5fff0ef          	jal	80001e86 <sched>
  panic("zombie exit");
    8000212c:	00005517          	auipc	a0,0x5
    80002130:	16450513          	addi	a0,a0,356 # 80007290 <etext+0x290>
    80002134:	e60fe0ef          	jal	80000794 <panic>
    for (struct proc *t = proc; t < &proc[NPROC]; t++) {
    80002138:	00010497          	auipc	s1,0x10
    8000213c:	78848493          	addi	s1,s1,1928 # 800128c0 <proc>
        t->killed = 1;
    80002140:	4b05                	li	s6,1
        if (t->state == SLEEPING) {
    80002142:	4a89                	li	s5,2
          t->state = RUNNABLE;
    80002144:	4b8d                	li	s7,3
    for (struct proc *t = proc; t < &proc[NPROC]; t++) {
    80002146:	00017997          	auipc	s3,0x17
    8000214a:	b7a98993          	addi	s3,s3,-1158 # 80018cc0 <tickslock>
    8000214e:	a811                	j	80002162 <exit+0xea>
          t->state = RUNNABLE;
    80002150:	0174ac23          	sw	s7,24(s1)
      release(&t->lock);
    80002154:	8526                	mv	a0,s1
    80002156:	b37fe0ef          	jal	80000c8c <release>
    for (struct proc *t = proc; t < &proc[NPROC]; t++) {
    8000215a:	19048493          	addi	s1,s1,400
    8000215e:	03348463          	beq	s1,s3,80002186 <exit+0x10e>
      if (t == p) continue;
    80002162:	fe990ce3          	beq	s2,s1,8000215a <exit+0xe2>
      acquire(&t->lock);
    80002166:	8526                	mv	a0,s1
    80002168:	a8dfe0ef          	jal	80000bf4 <acquire>
      if ((t->main_thread == main && t->isThread)) {
    8000216c:	1884b783          	ld	a5,392(s1)
    80002170:	ff2792e3          	bne	a5,s2,80002154 <exit+0xdc>
    80002174:	1704a783          	lw	a5,368(s1)
    80002178:	dff1                	beqz	a5,80002154 <exit+0xdc>
        t->killed = 1;
    8000217a:	0364a423          	sw	s6,40(s1)
        if (t->state == SLEEPING) {
    8000217e:	4c9c                	lw	a5,24(s1)
    80002180:	fd579ae3          	bne	a5,s5,80002154 <exit+0xdc>
    80002184:	b7f1                	j	80002150 <exit+0xd8>
    wakeup(p->parent);
    80002186:	03893503          	ld	a0,56(s2)
    8000218a:	e2fff0ef          	jal	80001fb8 <wakeup>
    8000218e:	bfa5                	j	80002106 <exit+0x8e>

0000000080002190 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002190:	7179                	addi	sp,sp,-48
    80002192:	f406                	sd	ra,40(sp)
    80002194:	f022                	sd	s0,32(sp)
    80002196:	ec26                	sd	s1,24(sp)
    80002198:	e84a                	sd	s2,16(sp)
    8000219a:	e44e                	sd	s3,8(sp)
    8000219c:	1800                	addi	s0,sp,48
    8000219e:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800021a0:	00010497          	auipc	s1,0x10
    800021a4:	72048493          	addi	s1,s1,1824 # 800128c0 <proc>
    800021a8:	00017997          	auipc	s3,0x17
    800021ac:	b1898993          	addi	s3,s3,-1256 # 80018cc0 <tickslock>
    acquire(&p->lock);
    800021b0:	8526                	mv	a0,s1
    800021b2:	a43fe0ef          	jal	80000bf4 <acquire>
    if(p->pid == pid){
    800021b6:	589c                	lw	a5,48(s1)
    800021b8:	01278b63          	beq	a5,s2,800021ce <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800021bc:	8526                	mv	a0,s1
    800021be:	acffe0ef          	jal	80000c8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800021c2:	19048493          	addi	s1,s1,400
    800021c6:	ff3495e3          	bne	s1,s3,800021b0 <kill+0x20>
  }
  return -1;
    800021ca:	557d                	li	a0,-1
    800021cc:	a819                	j	800021e2 <kill+0x52>
      p->killed = 1;
    800021ce:	4785                	li	a5,1
    800021d0:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800021d2:	4c98                	lw	a4,24(s1)
    800021d4:	4789                	li	a5,2
    800021d6:	00f70d63          	beq	a4,a5,800021f0 <kill+0x60>
      release(&p->lock);
    800021da:	8526                	mv	a0,s1
    800021dc:	ab1fe0ef          	jal	80000c8c <release>
      return 0;
    800021e0:	4501                	li	a0,0
}
    800021e2:	70a2                	ld	ra,40(sp)
    800021e4:	7402                	ld	s0,32(sp)
    800021e6:	64e2                	ld	s1,24(sp)
    800021e8:	6942                	ld	s2,16(sp)
    800021ea:	69a2                	ld	s3,8(sp)
    800021ec:	6145                	addi	sp,sp,48
    800021ee:	8082                	ret
        p->state = RUNNABLE;
    800021f0:	478d                	li	a5,3
    800021f2:	cc9c                	sw	a5,24(s1)
    800021f4:	b7dd                	j	800021da <kill+0x4a>

00000000800021f6 <setkilled>:

void
setkilled(struct proc *p)
{
    800021f6:	1101                	addi	sp,sp,-32
    800021f8:	ec06                	sd	ra,24(sp)
    800021fa:	e822                	sd	s0,16(sp)
    800021fc:	e426                	sd	s1,8(sp)
    800021fe:	1000                	addi	s0,sp,32
    80002200:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002202:	9f3fe0ef          	jal	80000bf4 <acquire>
  p->killed = 1;
    80002206:	4785                	li	a5,1
    80002208:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000220a:	8526                	mv	a0,s1
    8000220c:	a81fe0ef          	jal	80000c8c <release>
}
    80002210:	60e2                	ld	ra,24(sp)
    80002212:	6442                	ld	s0,16(sp)
    80002214:	64a2                	ld	s1,8(sp)
    80002216:	6105                	addi	sp,sp,32
    80002218:	8082                	ret

000000008000221a <killed>:

int
killed(struct proc *p)
{
    8000221a:	1101                	addi	sp,sp,-32
    8000221c:	ec06                	sd	ra,24(sp)
    8000221e:	e822                	sd	s0,16(sp)
    80002220:	e426                	sd	s1,8(sp)
    80002222:	e04a                	sd	s2,0(sp)
    80002224:	1000                	addi	s0,sp,32
    80002226:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002228:	9cdfe0ef          	jal	80000bf4 <acquire>
  k = p->killed;
    8000222c:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002230:	8526                	mv	a0,s1
    80002232:	a5bfe0ef          	jal	80000c8c <release>
  return k;
}
    80002236:	854a                	mv	a0,s2
    80002238:	60e2                	ld	ra,24(sp)
    8000223a:	6442                	ld	s0,16(sp)
    8000223c:	64a2                	ld	s1,8(sp)
    8000223e:	6902                	ld	s2,0(sp)
    80002240:	6105                	addi	sp,sp,32
    80002242:	8082                	ret

0000000080002244 <wait>:
{
    80002244:	715d                	addi	sp,sp,-80
    80002246:	e486                	sd	ra,72(sp)
    80002248:	e0a2                	sd	s0,64(sp)
    8000224a:	fc26                	sd	s1,56(sp)
    8000224c:	f84a                	sd	s2,48(sp)
    8000224e:	f44e                	sd	s3,40(sp)
    80002250:	f052                	sd	s4,32(sp)
    80002252:	ec56                	sd	s5,24(sp)
    80002254:	e85a                	sd	s6,16(sp)
    80002256:	e45e                	sd	s7,8(sp)
    80002258:	e062                	sd	s8,0(sp)
    8000225a:	0880                	addi	s0,sp,80
    8000225c:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    8000225e:	eb8ff0ef          	jal	80001916 <myproc>
    80002262:	892a                	mv	s2,a0
  acquire(&wait_lock);  
    80002264:	00010517          	auipc	a0,0x10
    80002268:	24450513          	addi	a0,a0,580 # 800124a8 <wait_lock>
    8000226c:	989fe0ef          	jal	80000bf4 <acquire>
    havekids = 0;
    80002270:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002272:	4a15                	li	s4,5
        havekids = 1;
    80002274:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002276:	00017997          	auipc	s3,0x17
    8000227a:	a4a98993          	addi	s3,s3,-1462 # 80018cc0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000227e:	00010c17          	auipc	s8,0x10
    80002282:	22ac0c13          	addi	s8,s8,554 # 800124a8 <wait_lock>
    80002286:	a871                	j	80002322 <wait+0xde>
          pid = pp->pid;
    80002288:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000228c:	000b0c63          	beqz	s6,800022a4 <wait+0x60>
    80002290:	4691                	li	a3,4
    80002292:	02c48613          	addi	a2,s1,44
    80002296:	85da                	mv	a1,s6
    80002298:	05093503          	ld	a0,80(s2)
    8000229c:	aecff0ef          	jal	80001588 <copyout>
    800022a0:	02054b63          	bltz	a0,800022d6 <wait+0x92>
          freeproc(pp);
    800022a4:	8526                	mv	a0,s1
    800022a6:	fe6ff0ef          	jal	80001a8c <freeproc>
          release(&pp->lock);
    800022aa:	8526                	mv	a0,s1
    800022ac:	9e1fe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    800022b0:	00010517          	auipc	a0,0x10
    800022b4:	1f850513          	addi	a0,a0,504 # 800124a8 <wait_lock>
    800022b8:	9d5fe0ef          	jal	80000c8c <release>
}
    800022bc:	854e                	mv	a0,s3
    800022be:	60a6                	ld	ra,72(sp)
    800022c0:	6406                	ld	s0,64(sp)
    800022c2:	74e2                	ld	s1,56(sp)
    800022c4:	7942                	ld	s2,48(sp)
    800022c6:	79a2                	ld	s3,40(sp)
    800022c8:	7a02                	ld	s4,32(sp)
    800022ca:	6ae2                	ld	s5,24(sp)
    800022cc:	6b42                	ld	s6,16(sp)
    800022ce:	6ba2                	ld	s7,8(sp)
    800022d0:	6c02                	ld	s8,0(sp)
    800022d2:	6161                	addi	sp,sp,80
    800022d4:	8082                	ret
            release(&pp->lock);
    800022d6:	8526                	mv	a0,s1
    800022d8:	9b5fe0ef          	jal	80000c8c <release>
            release(&wait_lock);
    800022dc:	00010517          	auipc	a0,0x10
    800022e0:	1cc50513          	addi	a0,a0,460 # 800124a8 <wait_lock>
    800022e4:	9a9fe0ef          	jal	80000c8c <release>
            return -1;
    800022e8:	59fd                	li	s3,-1
    800022ea:	bfc9                	j	800022bc <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800022ec:	19048493          	addi	s1,s1,400
    800022f0:	03348063          	beq	s1,s3,80002310 <wait+0xcc>
      if(pp->parent == p){
    800022f4:	7c9c                	ld	a5,56(s1)
    800022f6:	ff279be3          	bne	a5,s2,800022ec <wait+0xa8>
        acquire(&pp->lock);
    800022fa:	8526                	mv	a0,s1
    800022fc:	8f9fe0ef          	jal	80000bf4 <acquire>
        if(pp->state == ZOMBIE){
    80002300:	4c9c                	lw	a5,24(s1)
    80002302:	f94783e3          	beq	a5,s4,80002288 <wait+0x44>
        release(&pp->lock);
    80002306:	8526                	mv	a0,s1
    80002308:	985fe0ef          	jal	80000c8c <release>
        havekids = 1;
    8000230c:	8756                	mv	a4,s5
    8000230e:	bff9                	j	800022ec <wait+0xa8>
    if(!havekids || killed(p)){
    80002310:	cf19                	beqz	a4,8000232e <wait+0xea>
    80002312:	854a                	mv	a0,s2
    80002314:	f07ff0ef          	jal	8000221a <killed>
    80002318:	e919                	bnez	a0,8000232e <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000231a:	85e2                	mv	a1,s8
    8000231c:	854a                	mv	a0,s2
    8000231e:	c4fff0ef          	jal	80001f6c <sleep>
    havekids = 0;
    80002322:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002324:	00010497          	auipc	s1,0x10
    80002328:	59c48493          	addi	s1,s1,1436 # 800128c0 <proc>
    8000232c:	b7e1                	j	800022f4 <wait+0xb0>
      release(&wait_lock);
    8000232e:	00010517          	auipc	a0,0x10
    80002332:	17a50513          	addi	a0,a0,378 # 800124a8 <wait_lock>
    80002336:	957fe0ef          	jal	80000c8c <release>
      return -1;
    8000233a:	59fd                	li	s3,-1
    8000233c:	b741                	j	800022bc <wait+0x78>

000000008000233e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000233e:	7179                	addi	sp,sp,-48
    80002340:	f406                	sd	ra,40(sp)
    80002342:	f022                	sd	s0,32(sp)
    80002344:	ec26                	sd	s1,24(sp)
    80002346:	e84a                	sd	s2,16(sp)
    80002348:	e44e                	sd	s3,8(sp)
    8000234a:	e052                	sd	s4,0(sp)
    8000234c:	1800                	addi	s0,sp,48
    8000234e:	84aa                	mv	s1,a0
    80002350:	892e                	mv	s2,a1
    80002352:	89b2                	mv	s3,a2
    80002354:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002356:	dc0ff0ef          	jal	80001916 <myproc>
  if(user_dst){
    8000235a:	cc99                	beqz	s1,80002378 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000235c:	86d2                	mv	a3,s4
    8000235e:	864e                	mv	a2,s3
    80002360:	85ca                	mv	a1,s2
    80002362:	6928                	ld	a0,80(a0)
    80002364:	a24ff0ef          	jal	80001588 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002368:	70a2                	ld	ra,40(sp)
    8000236a:	7402                	ld	s0,32(sp)
    8000236c:	64e2                	ld	s1,24(sp)
    8000236e:	6942                	ld	s2,16(sp)
    80002370:	69a2                	ld	s3,8(sp)
    80002372:	6a02                	ld	s4,0(sp)
    80002374:	6145                	addi	sp,sp,48
    80002376:	8082                	ret
    memmove((char *)dst, src, len);
    80002378:	000a061b          	sext.w	a2,s4
    8000237c:	85ce                	mv	a1,s3
    8000237e:	854a                	mv	a0,s2
    80002380:	9a5fe0ef          	jal	80000d24 <memmove>
    return 0;
    80002384:	8526                	mv	a0,s1
    80002386:	b7cd                	j	80002368 <either_copyout+0x2a>

0000000080002388 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002388:	7179                	addi	sp,sp,-48
    8000238a:	f406                	sd	ra,40(sp)
    8000238c:	f022                	sd	s0,32(sp)
    8000238e:	ec26                	sd	s1,24(sp)
    80002390:	e84a                	sd	s2,16(sp)
    80002392:	e44e                	sd	s3,8(sp)
    80002394:	e052                	sd	s4,0(sp)
    80002396:	1800                	addi	s0,sp,48
    80002398:	892a                	mv	s2,a0
    8000239a:	84ae                	mv	s1,a1
    8000239c:	89b2                	mv	s3,a2
    8000239e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800023a0:	d76ff0ef          	jal	80001916 <myproc>
  if(user_src){
    800023a4:	cc99                	beqz	s1,800023c2 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800023a6:	86d2                	mv	a3,s4
    800023a8:	864e                	mv	a2,s3
    800023aa:	85ca                	mv	a1,s2
    800023ac:	6928                	ld	a0,80(a0)
    800023ae:	ab0ff0ef          	jal	8000165e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800023b2:	70a2                	ld	ra,40(sp)
    800023b4:	7402                	ld	s0,32(sp)
    800023b6:	64e2                	ld	s1,24(sp)
    800023b8:	6942                	ld	s2,16(sp)
    800023ba:	69a2                	ld	s3,8(sp)
    800023bc:	6a02                	ld	s4,0(sp)
    800023be:	6145                	addi	sp,sp,48
    800023c0:	8082                	ret
    memmove(dst, (char*)src, len);
    800023c2:	000a061b          	sext.w	a2,s4
    800023c6:	85ce                	mv	a1,s3
    800023c8:	854a                	mv	a0,s2
    800023ca:	95bfe0ef          	jal	80000d24 <memmove>
    return 0;
    800023ce:	8526                	mv	a0,s1
    800023d0:	b7cd                	j	800023b2 <either_copyin+0x2a>

00000000800023d2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800023d2:	715d                	addi	sp,sp,-80
    800023d4:	e486                	sd	ra,72(sp)
    800023d6:	e0a2                	sd	s0,64(sp)
    800023d8:	fc26                	sd	s1,56(sp)
    800023da:	f84a                	sd	s2,48(sp)
    800023dc:	f44e                	sd	s3,40(sp)
    800023de:	f052                	sd	s4,32(sp)
    800023e0:	ec56                	sd	s5,24(sp)
    800023e2:	e85a                	sd	s6,16(sp)
    800023e4:	e45e                	sd	s7,8(sp)
    800023e6:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800023e8:	00005517          	auipc	a0,0x5
    800023ec:	c9050513          	addi	a0,a0,-880 # 80007078 <etext+0x78>
    800023f0:	8d2fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800023f4:	00010497          	auipc	s1,0x10
    800023f8:	62c48493          	addi	s1,s1,1580 # 80012a20 <proc+0x160>
    800023fc:	00017917          	auipc	s2,0x17
    80002400:	a2490913          	addi	s2,s2,-1500 # 80018e20 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002404:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002406:	00005997          	auipc	s3,0x5
    8000240a:	e9a98993          	addi	s3,s3,-358 # 800072a0 <etext+0x2a0>
    printf("%d %s %s", p->pid, state, p->name);
    8000240e:	00005a97          	auipc	s5,0x5
    80002412:	e9aa8a93          	addi	s5,s5,-358 # 800072a8 <etext+0x2a8>
    printf("\n");
    80002416:	00005a17          	auipc	s4,0x5
    8000241a:	c62a0a13          	addi	s4,s4,-926 # 80007078 <etext+0x78>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000241e:	00005b97          	auipc	s7,0x5
    80002422:	37ab8b93          	addi	s7,s7,890 # 80007798 <states.0>
    80002426:	a829                	j	80002440 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002428:	ed06a583          	lw	a1,-304(a3)
    8000242c:	8556                	mv	a0,s5
    8000242e:	894fe0ef          	jal	800004c2 <printf>
    printf("\n");
    80002432:	8552                	mv	a0,s4
    80002434:	88efe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002438:	19048493          	addi	s1,s1,400
    8000243c:	03248263          	beq	s1,s2,80002460 <procdump+0x8e>
    if(p->state == UNUSED)
    80002440:	86a6                	mv	a3,s1
    80002442:	eb84a783          	lw	a5,-328(s1)
    80002446:	dbed                	beqz	a5,80002438 <procdump+0x66>
      state = "???";
    80002448:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000244a:	fcfb6fe3          	bltu	s6,a5,80002428 <procdump+0x56>
    8000244e:	02079713          	slli	a4,a5,0x20
    80002452:	01d75793          	srli	a5,a4,0x1d
    80002456:	97de                	add	a5,a5,s7
    80002458:	6390                	ld	a2,0(a5)
    8000245a:	f679                	bnez	a2,80002428 <procdump+0x56>
      state = "???";
    8000245c:	864e                	mv	a2,s3
    8000245e:	b7e9                	j	80002428 <procdump+0x56>
  }
}
    80002460:	60a6                	ld	ra,72(sp)
    80002462:	6406                	ld	s0,64(sp)
    80002464:	74e2                	ld	s1,56(sp)
    80002466:	7942                	ld	s2,48(sp)
    80002468:	79a2                	ld	s3,40(sp)
    8000246a:	7a02                	ld	s4,32(sp)
    8000246c:	6ae2                	ld	s5,24(sp)
    8000246e:	6b42                	ld	s6,16(sp)
    80002470:	6ba2                	ld	s7,8(sp)
    80002472:	6161                	addi	sp,sp,80
    80002474:	8082                	ret

0000000080002476 <clone>:

int 
clone(void (*fcn)(void*, void*), void *arg1, void *arg2, void *stack) 
{
    80002476:	711d                	addi	sp,sp,-96
    80002478:	ec86                	sd	ra,88(sp)
    8000247a:	e8a2                	sd	s0,80(sp)
    8000247c:	f456                	sd	s5,40(sp)
    8000247e:	f05a                	sd	s6,32(sp)
    80002480:	ec5e                	sd	s7,24(sp)
    80002482:	e862                	sd	s8,16(sp)
    80002484:	e466                	sd	s9,8(sp)
    80002486:	1080                	addi	s0,sp,96
    80002488:	8c2a                	mv	s8,a0
    8000248a:	8bae                	mv	s7,a1
    8000248c:	8b32                	mv	s6,a2
    8000248e:	8ab6                	mv	s5,a3
  struct proc *p = myproc();
    80002490:	c86ff0ef          	jal	80001916 <myproc>
    80002494:	8caa                	mv	s9,a0
  struct proc *nt;

  if ((nt = allocproc(1)) == 0) {
    80002496:	4505                	li	a0,1
    80002498:	e6eff0ef          	jal	80001b06 <allocproc>
    8000249c:	14050a63          	beqz	a0,800025f0 <clone+0x17a>
    800024a0:	e4a6                	sd	s1,72(sp)
    800024a2:	e0ca                	sd	s2,64(sp)
    800024a4:	fc4e                	sd	s3,56(sp)
    800024a6:	f852                	sd	s4,48(sp)
    800024a8:	89aa                	mv	s3,a0
    return -1;
  }

  // Thread 관련 부분 처리
  nt->isThread = 1;
    800024aa:	4785                	li	a5,1
    800024ac:	16f52823          	sw	a5,368(a0)
  nt->main_thread = p->isThread ? p->main_thread : p;
    800024b0:	170ca783          	lw	a5,368(s9)
    800024b4:	8566                	mv	a0,s9
    800024b6:	c399                	beqz	a5,800024bc <clone+0x46>
    800024b8:	188cb503          	ld	a0,392(s9)
    800024bc:	18a9b423          	sd	a0,392(s3)
  nt->parent = nt->main_thread;
    800024c0:	02a9bc23          	sd	a0,56(s3)

  acquire(&nt->main_thread->lock);
    800024c4:	f30fe0ef          	jal	80000bf4 <acquire>
  nt->pagetable = nt->main_thread->pagetable;
    800024c8:	1889b703          	ld	a4,392(s3)
    800024cc:	6b3c                	ld	a5,80(a4)
    800024ce:	04f9b823          	sd	a5,80(s3)
  nt->tid = ++nt->main_thread->thread_num;
    800024d2:	17872783          	lw	a5,376(a4)
    800024d6:	2785                	addiw	a5,a5,1
    800024d8:	16f72c23          	sw	a5,376(a4)
    800024dc:	16f9aa23          	sw	a5,372(s3)
  release(&nt->main_thread->lock);
    800024e0:	1889b503          	ld	a0,392(s3)
    800024e4:	fa8fe0ef          	jal	80000c8c <release>

  // 각 Thread가 File descriptor copy를 가짐
  for(int i = 0; i < NOFILE; i++)
    800024e8:	0d8c8493          	addi	s1,s9,216
    800024ec:	0d898913          	addi	s2,s3,216
    800024f0:	158c8a13          	addi	s4,s9,344
    800024f4:	a029                	j	800024fe <clone+0x88>
    800024f6:	04a1                	addi	s1,s1,8
    800024f8:	0921                	addi	s2,s2,8
    800024fa:	01448963          	beq	s1,s4,8000250c <clone+0x96>
    if(p->ofile[i])
    800024fe:	6088                	ld	a0,0(s1)
    80002500:	d97d                	beqz	a0,800024f6 <clone+0x80>
      nt->ofile[i] = filedup(p->ofile[i]);
    80002502:	57b010ef          	jal	8000427c <filedup>
    80002506:	00a93023          	sd	a0,0(s2)
    8000250a:	b7f5                	j	800024f6 <clone+0x80>

  nt->cwd = idup(p->cwd);
    8000250c:	158cb503          	ld	a0,344(s9)
    80002510:	0cc010ef          	jal	800035dc <idup>
    80002514:	14a9bc23          	sd	a0,344(s3)

  safestrcpy(nt->name, p->name, sizeof(p->name));
    80002518:	4641                	li	a2,16
    8000251a:	160c8593          	addi	a1,s9,352
    8000251e:	16098513          	addi	a0,s3,352
    80002522:	8e5fe0ef          	jal	80000e06 <safestrcpy>

  // map the trapframe page just below the trampoline page, for
  // trampoline.S.
  if(mappages(nt->pagetable, nt->trapframe_va = TRAMPOLINE - (nt->tid * PGSIZE), PGSIZE,
    80002526:	1749a783          	lw	a5,372(s3)
    8000252a:	00c7979b          	slliw	a5,a5,0xc
    8000252e:	040005b7          	lui	a1,0x4000
    80002532:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002534:	05b2                	slli	a1,a1,0xc
    80002536:	8d9d                	sub	a1,a1,a5
    80002538:	04b9bc23          	sd	a1,88(s3)
    8000253c:	4719                	li	a4,6
    8000253e:	0609b683          	ld	a3,96(s3)
    80002542:	6605                	lui	a2,0x1
    80002544:	0509b503          	ld	a0,80(s3)
    80002548:	b03fe0ef          	jal	8000104a <mappages>
    8000254c:	08054663          	bltz	a0,800025d8 <clone+0x162>
    release(&nt->lock);
    return 0;
  }

  // trapframe 우선 복사
  *(nt->trapframe) = *(p->trapframe);
    80002550:	060cb683          	ld	a3,96(s9)
    80002554:	87b6                	mv	a5,a3
    80002556:	0609b703          	ld	a4,96(s3)
    8000255a:	12068693          	addi	a3,a3,288
    8000255e:	0007b803          	ld	a6,0(a5)
    80002562:	6788                	ld	a0,8(a5)
    80002564:	6b8c                	ld	a1,16(a5)
    80002566:	6f90                	ld	a2,24(a5)
    80002568:	01073023          	sd	a6,0(a4)
    8000256c:	e708                	sd	a0,8(a4)
    8000256e:	eb0c                	sd	a1,16(a4)
    80002570:	ef10                	sd	a2,24(a4)
    80002572:	02078793          	addi	a5,a5,32
    80002576:	02070713          	addi	a4,a4,32
    8000257a:	fed792e3          	bne	a5,a3,8000255e <clone+0xe8>
  // fcn, stack, argument를 넘겨줌
  nt->trapframe->epc = (uint64)fcn;
    8000257e:	0609b783          	ld	a5,96(s3)
    80002582:	0187bc23          	sd	s8,24(a5)
  nt->trapframe->a0 = (uint64)arg1;
    80002586:	0609b783          	ld	a5,96(s3)
    8000258a:	0777b823          	sd	s7,112(a5)
  nt->trapframe->a1 = (uint64)arg2;
    8000258e:	0609b783          	ld	a5,96(s3)
    80002592:	0767bc23          	sd	s6,120(a5)

  void *user_stack = (void *)(((uint64)stack + PGSIZE - 1) & ~(PGSIZE - 1));
  nt->trapframe->sp = (uint64)user_stack + PGSIZE;
    80002596:	0609b683          	ld	a3,96(s3)
  void *user_stack = (void *)(((uint64)stack + PGSIZE - 1) & ~(PGSIZE - 1));
    8000259a:	6705                	lui	a4,0x1
    8000259c:	fff70793          	addi	a5,a4,-1 # fff <_entry-0x7ffff001>
    800025a0:	97d6                	add	a5,a5,s5
    800025a2:	767d                	lui	a2,0xfffff
    800025a4:	8ff1                	and	a5,a5,a2
  nt->trapframe->sp = (uint64)user_stack + PGSIZE;
    800025a6:	97ba                	add	a5,a5,a4
    800025a8:	fa9c                	sd	a5,48(a3)

  nt->stack = stack;
    800025aa:	1959b023          	sd	s5,384(s3)

  nt->state = RUNNABLE;
    800025ae:	478d                	li	a5,3
    800025b0:	00f9ac23          	sw	a5,24(s3)
  release(&nt->lock);
    800025b4:	854e                	mv	a0,s3
    800025b6:	ed6fe0ef          	jal	80000c8c <release>

  return nt->pid;
    800025ba:	0309a503          	lw	a0,48(s3)
    800025be:	64a6                	ld	s1,72(sp)
    800025c0:	6906                	ld	s2,64(sp)
    800025c2:	79e2                	ld	s3,56(sp)
    800025c4:	7a42                	ld	s4,48(sp)
}
    800025c6:	60e6                	ld	ra,88(sp)
    800025c8:	6446                	ld	s0,80(sp)
    800025ca:	7aa2                	ld	s5,40(sp)
    800025cc:	7b02                	ld	s6,32(sp)
    800025ce:	6be2                	ld	s7,24(sp)
    800025d0:	6c42                	ld	s8,16(sp)
    800025d2:	6ca2                	ld	s9,8(sp)
    800025d4:	6125                	addi	sp,sp,96
    800025d6:	8082                	ret
    freeproc(nt);
    800025d8:	854e                	mv	a0,s3
    800025da:	cb2ff0ef          	jal	80001a8c <freeproc>
    release(&nt->lock);
    800025de:	854e                	mv	a0,s3
    800025e0:	eacfe0ef          	jal	80000c8c <release>
    return 0;
    800025e4:	4501                	li	a0,0
    800025e6:	64a6                	ld	s1,72(sp)
    800025e8:	6906                	ld	s2,64(sp)
    800025ea:	79e2                	ld	s3,56(sp)
    800025ec:	7a42                	ld	s4,48(sp)
    800025ee:	bfe1                	j	800025c6 <clone+0x150>
    return -1;
    800025f0:	557d                	li	a0,-1
    800025f2:	bfd1                	j	800025c6 <clone+0x150>

00000000800025f4 <join>:

int 
join(void **stack) 
{
    800025f4:	711d                	addi	sp,sp,-96
    800025f6:	ec86                	sd	ra,88(sp)
    800025f8:	e8a2                	sd	s0,80(sp)
    800025fa:	e4a6                	sd	s1,72(sp)
    800025fc:	e0ca                	sd	s2,64(sp)
    800025fe:	fc4e                	sd	s3,56(sp)
    80002600:	f852                	sd	s4,48(sp)
    80002602:	f456                	sd	s5,40(sp)
    80002604:	f05a                	sd	s6,32(sp)
    80002606:	ec5e                	sd	s7,24(sp)
    80002608:	e862                	sd	s8,16(sp)
    8000260a:	e466                	sd	s9,8(sp)
    8000260c:	1080                	addi	s0,sp,96
    8000260e:	8c2a                	mv	s8,a0
  int havekids, pid;
  struct proc *p = myproc();
    80002610:	b06ff0ef          	jal	80001916 <myproc>
    80002614:	8b2a                	mv	s6,a0
  struct proc *main_thread = p->isThread ? p->main_thread : p;
    80002616:	17052783          	lw	a5,368(a0)
    8000261a:	892a                	mv	s2,a0
    8000261c:	c399                	beqz	a5,80002622 <join+0x2e>
    8000261e:	18853903          	ld	s2,392(a0)
  struct proc *t;

  acquire(&wait_lock);
    80002622:	00010517          	auipc	a0,0x10
    80002626:	e8650513          	addi	a0,a0,-378 # 800124a8 <wait_lock>
    8000262a:	dcafe0ef          	jal	80000bf4 <acquire>

  for (;;) {
    havekids = 0;
    8000262e:	4b81                	li	s7,0
    for (t = proc; t < &proc[NPROC]; t++) {
      if (t->main_thread == main_thread && t->isThread) {
        acquire(&t->lock);
        havekids = 1;

        if (t->state == ZOMBIE) {
    80002630:	4a15                	li	s4,5
        havekids = 1;
    80002632:	4a85                	li	s5,1
    for (t = proc; t < &proc[NPROC]; t++) {
    80002634:	00016997          	auipc	s3,0x16
    80002638:	68c98993          	addi	s3,s3,1676 # 80018cc0 <tickslock>
    if (!havekids || killed(p)) {
      release(&wait_lock);
      return -1;
    }

    sleep(p, &wait_lock);
    8000263c:	00010c97          	auipc	s9,0x10
    80002640:	e6cc8c93          	addi	s9,s9,-404 # 800124a8 <wait_lock>
    80002644:	a859                	j	800026da <join+0xe6>
        release(&t->lock);
    80002646:	8526                	mv	a0,s1
    80002648:	e44fe0ef          	jal	80000c8c <release>
        havekids = 1;
    8000264c:	8756                	mv	a4,s5
    for (t = proc; t < &proc[NPROC]; t++) {
    8000264e:	19048493          	addi	s1,s1,400
    80002652:	07348b63          	beq	s1,s3,800026c8 <join+0xd4>
      if (t->main_thread == main_thread && t->isThread) {
    80002656:	1884b783          	ld	a5,392(s1)
    8000265a:	ff279ae3          	bne	a5,s2,8000264e <join+0x5a>
    8000265e:	1704a783          	lw	a5,368(s1)
    80002662:	d7f5                	beqz	a5,8000264e <join+0x5a>
        acquire(&t->lock);
    80002664:	8526                	mv	a0,s1
    80002666:	d8efe0ef          	jal	80000bf4 <acquire>
        if (t->state == ZOMBIE) {
    8000266a:	4c9c                	lw	a5,24(s1)
    8000266c:	fd479de3          	bne	a5,s4,80002646 <join+0x52>
          printf("ZOMBIE pid %d\n", p->pid);
    80002670:	030b2583          	lw	a1,48(s6)
    80002674:	00005517          	auipc	a0,0x5
    80002678:	c4450513          	addi	a0,a0,-956 # 800072b8 <etext+0x2b8>
    8000267c:	e47fd0ef          	jal	800004c2 <printf>
          pid = t->pid;
    80002680:	0304a983          	lw	s3,48(s1)
          copyout(main_thread->pagetable, (uint64)stack, (char *)&t->stack, sizeof(t->stack));
    80002684:	46a1                	li	a3,8
    80002686:	18048613          	addi	a2,s1,384
    8000268a:	85e2                	mv	a1,s8
    8000268c:	05093503          	ld	a0,80(s2)
    80002690:	ef9fe0ef          	jal	80001588 <copyout>
          freeproc(t);
    80002694:	8526                	mv	a0,s1
    80002696:	bf6ff0ef          	jal	80001a8c <freeproc>
          release(&t->lock);
    8000269a:	8526                	mv	a0,s1
    8000269c:	df0fe0ef          	jal	80000c8c <release>
          release(&wait_lock);
    800026a0:	00010517          	auipc	a0,0x10
    800026a4:	e0850513          	addi	a0,a0,-504 # 800124a8 <wait_lock>
    800026a8:	de4fe0ef          	jal	80000c8c <release>
  } 
    800026ac:	854e                	mv	a0,s3
    800026ae:	60e6                	ld	ra,88(sp)
    800026b0:	6446                	ld	s0,80(sp)
    800026b2:	64a6                	ld	s1,72(sp)
    800026b4:	6906                	ld	s2,64(sp)
    800026b6:	79e2                	ld	s3,56(sp)
    800026b8:	7a42                	ld	s4,48(sp)
    800026ba:	7aa2                	ld	s5,40(sp)
    800026bc:	7b02                	ld	s6,32(sp)
    800026be:	6be2                	ld	s7,24(sp)
    800026c0:	6c42                	ld	s8,16(sp)
    800026c2:	6ca2                	ld	s9,8(sp)
    800026c4:	6125                	addi	sp,sp,96
    800026c6:	8082                	ret
    if (!havekids || killed(p)) {
    800026c8:	cf19                	beqz	a4,800026e6 <join+0xf2>
    800026ca:	855a                	mv	a0,s6
    800026cc:	b4fff0ef          	jal	8000221a <killed>
    800026d0:	e919                	bnez	a0,800026e6 <join+0xf2>
    sleep(p, &wait_lock);
    800026d2:	85e6                	mv	a1,s9
    800026d4:	855a                	mv	a0,s6
    800026d6:	897ff0ef          	jal	80001f6c <sleep>
    for (t = proc; t < &proc[NPROC]; t++) {
    800026da:	00010497          	auipc	s1,0x10
    800026de:	1e648493          	addi	s1,s1,486 # 800128c0 <proc>
    havekids = 0;
    800026e2:	875e                	mv	a4,s7
    800026e4:	bf8d                	j	80002656 <join+0x62>
      release(&wait_lock);
    800026e6:	00010517          	auipc	a0,0x10
    800026ea:	dc250513          	addi	a0,a0,-574 # 800124a8 <wait_lock>
    800026ee:	d9efe0ef          	jal	80000c8c <release>
      return -1;
    800026f2:	59fd                	li	s3,-1
    800026f4:	bf65                	j	800026ac <join+0xb8>

00000000800026f6 <swtch>:
    800026f6:	00153023          	sd	ra,0(a0)
    800026fa:	00253423          	sd	sp,8(a0)
    800026fe:	e900                	sd	s0,16(a0)
    80002700:	ed04                	sd	s1,24(a0)
    80002702:	03253023          	sd	s2,32(a0)
    80002706:	03353423          	sd	s3,40(a0)
    8000270a:	03453823          	sd	s4,48(a0)
    8000270e:	03553c23          	sd	s5,56(a0)
    80002712:	05653023          	sd	s6,64(a0)
    80002716:	05753423          	sd	s7,72(a0)
    8000271a:	05853823          	sd	s8,80(a0)
    8000271e:	05953c23          	sd	s9,88(a0)
    80002722:	07a53023          	sd	s10,96(a0)
    80002726:	07b53423          	sd	s11,104(a0)
    8000272a:	0005b083          	ld	ra,0(a1)
    8000272e:	0085b103          	ld	sp,8(a1)
    80002732:	6980                	ld	s0,16(a1)
    80002734:	6d84                	ld	s1,24(a1)
    80002736:	0205b903          	ld	s2,32(a1)
    8000273a:	0285b983          	ld	s3,40(a1)
    8000273e:	0305ba03          	ld	s4,48(a1)
    80002742:	0385ba83          	ld	s5,56(a1)
    80002746:	0405bb03          	ld	s6,64(a1)
    8000274a:	0485bb83          	ld	s7,72(a1)
    8000274e:	0505bc03          	ld	s8,80(a1)
    80002752:	0585bc83          	ld	s9,88(a1)
    80002756:	0605bd03          	ld	s10,96(a1)
    8000275a:	0685bd83          	ld	s11,104(a1)
    8000275e:	8082                	ret

0000000080002760 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002760:	1141                	addi	sp,sp,-16
    80002762:	e406                	sd	ra,8(sp)
    80002764:	e022                	sd	s0,0(sp)
    80002766:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002768:	00005597          	auipc	a1,0x5
    8000276c:	b9058593          	addi	a1,a1,-1136 # 800072f8 <etext+0x2f8>
    80002770:	00016517          	auipc	a0,0x16
    80002774:	55050513          	addi	a0,a0,1360 # 80018cc0 <tickslock>
    80002778:	bfcfe0ef          	jal	80000b74 <initlock>
}
    8000277c:	60a2                	ld	ra,8(sp)
    8000277e:	6402                	ld	s0,0(sp)
    80002780:	0141                	addi	sp,sp,16
    80002782:	8082                	ret

0000000080002784 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002784:	1141                	addi	sp,sp,-16
    80002786:	e422                	sd	s0,8(sp)
    80002788:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000278a:	00003797          	auipc	a5,0x3
    8000278e:	fa678793          	addi	a5,a5,-90 # 80005730 <kernelvec>
    80002792:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002796:	6422                	ld	s0,8(sp)
    80002798:	0141                	addi	sp,sp,16
    8000279a:	8082                	ret

000000008000279c <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    8000279c:	1141                	addi	sp,sp,-16
    8000279e:	e406                	sd	ra,8(sp)
    800027a0:	e022                	sd	s0,0(sp)
    800027a2:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800027a4:	972ff0ef          	jal	80001916 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027a8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800027ac:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027ae:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800027b2:	00004697          	auipc	a3,0x4
    800027b6:	84e68693          	addi	a3,a3,-1970 # 80006000 <_trampoline>
    800027ba:	00004717          	auipc	a4,0x4
    800027be:	84670713          	addi	a4,a4,-1978 # 80006000 <_trampoline>
    800027c2:	8f15                	sub	a4,a4,a3
    800027c4:	040007b7          	lui	a5,0x4000
    800027c8:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800027ca:	07b2                	slli	a5,a5,0xc
    800027cc:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027ce:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800027d2:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800027d4:	18002673          	csrr	a2,satp
    800027d8:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800027da:	7130                	ld	a2,96(a0)
    800027dc:	6138                	ld	a4,64(a0)
    800027de:	6585                	lui	a1,0x1
    800027e0:	972e                	add	a4,a4,a1
    800027e2:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800027e4:	7138                	ld	a4,96(a0)
    800027e6:	00000617          	auipc	a2,0x0
    800027ea:	11660613          	addi	a2,a2,278 # 800028fc <usertrap>
    800027ee:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800027f0:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800027f2:	8612                	mv	a2,tp
    800027f4:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027f6:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800027fa:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800027fe:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002802:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002806:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002808:	6f18                	ld	a4,24(a4)
    8000280a:	14171073          	csrw	sepc,a4

  asm volatile("csrw sscratch, %0" : : "r" (p->trapframe_va));
    8000280e:	6d2c                	ld	a1,88(a0)
    80002810:	14059073          	csrw	sscratch,a1

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002814:	6928                	ld	a0,80(a0)
    80002816:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002818:	00004717          	auipc	a4,0x4
    8000281c:	87c70713          	addi	a4,a4,-1924 # 80006094 <userret>
    80002820:	8f15                	sub	a4,a4,a3
    80002822:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))trampoline_userret)(satp, p->trapframe_va);
    80002824:	577d                	li	a4,-1
    80002826:	177e                	slli	a4,a4,0x3f
    80002828:	8d59                	or	a0,a0,a4
    8000282a:	9782                	jalr	a5
}
    8000282c:	60a2                	ld	ra,8(sp)
    8000282e:	6402                	ld	s0,0(sp)
    80002830:	0141                	addi	sp,sp,16
    80002832:	8082                	ret

0000000080002834 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002834:	1101                	addi	sp,sp,-32
    80002836:	ec06                	sd	ra,24(sp)
    80002838:	e822                	sd	s0,16(sp)
    8000283a:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000283c:	8aeff0ef          	jal	800018ea <cpuid>
    80002840:	cd11                	beqz	a0,8000285c <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002842:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002846:	000f4737          	lui	a4,0xf4
    8000284a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000284e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002850:	14d79073          	csrw	stimecmp,a5
}
    80002854:	60e2                	ld	ra,24(sp)
    80002856:	6442                	ld	s0,16(sp)
    80002858:	6105                	addi	sp,sp,32
    8000285a:	8082                	ret
    8000285c:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000285e:	00016497          	auipc	s1,0x16
    80002862:	46248493          	addi	s1,s1,1122 # 80018cc0 <tickslock>
    80002866:	8526                	mv	a0,s1
    80002868:	b8cfe0ef          	jal	80000bf4 <acquire>
    ticks++;
    8000286c:	00008517          	auipc	a0,0x8
    80002870:	af450513          	addi	a0,a0,-1292 # 8000a360 <ticks>
    80002874:	411c                	lw	a5,0(a0)
    80002876:	2785                	addiw	a5,a5,1
    80002878:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    8000287a:	f3eff0ef          	jal	80001fb8 <wakeup>
    release(&tickslock);
    8000287e:	8526                	mv	a0,s1
    80002880:	c0cfe0ef          	jal	80000c8c <release>
    80002884:	64a2                	ld	s1,8(sp)
    80002886:	bf75                	j	80002842 <clockintr+0xe>

0000000080002888 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002888:	1101                	addi	sp,sp,-32
    8000288a:	ec06                	sd	ra,24(sp)
    8000288c:	e822                	sd	s0,16(sp)
    8000288e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002890:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002894:	57fd                	li	a5,-1
    80002896:	17fe                	slli	a5,a5,0x3f
    80002898:	07a5                	addi	a5,a5,9
    8000289a:	00f70c63          	beq	a4,a5,800028b2 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    8000289e:	57fd                	li	a5,-1
    800028a0:	17fe                	slli	a5,a5,0x3f
    800028a2:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800028a4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800028a6:	04f70763          	beq	a4,a5,800028f4 <devintr+0x6c>
  }
}
    800028aa:	60e2                	ld	ra,24(sp)
    800028ac:	6442                	ld	s0,16(sp)
    800028ae:	6105                	addi	sp,sp,32
    800028b0:	8082                	ret
    800028b2:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800028b4:	729020ef          	jal	800057dc <plic_claim>
    800028b8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800028ba:	47a9                	li	a5,10
    800028bc:	00f50963          	beq	a0,a5,800028ce <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800028c0:	4785                	li	a5,1
    800028c2:	00f50963          	beq	a0,a5,800028d4 <devintr+0x4c>
    return 1;
    800028c6:	4505                	li	a0,1
    } else if(irq){
    800028c8:	e889                	bnez	s1,800028da <devintr+0x52>
    800028ca:	64a2                	ld	s1,8(sp)
    800028cc:	bff9                	j	800028aa <devintr+0x22>
      uartintr();
    800028ce:	938fe0ef          	jal	80000a06 <uartintr>
    if(irq)
    800028d2:	a819                	j	800028e8 <devintr+0x60>
      virtio_disk_intr();
    800028d4:	3ce030ef          	jal	80005ca2 <virtio_disk_intr>
    if(irq)
    800028d8:	a801                	j	800028e8 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    800028da:	85a6                	mv	a1,s1
    800028dc:	00005517          	auipc	a0,0x5
    800028e0:	a2450513          	addi	a0,a0,-1500 # 80007300 <etext+0x300>
    800028e4:	bdffd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    800028e8:	8526                	mv	a0,s1
    800028ea:	713020ef          	jal	800057fc <plic_complete>
    return 1;
    800028ee:	4505                	li	a0,1
    800028f0:	64a2                	ld	s1,8(sp)
    800028f2:	bf65                	j	800028aa <devintr+0x22>
    clockintr();
    800028f4:	f41ff0ef          	jal	80002834 <clockintr>
    return 2;
    800028f8:	4509                	li	a0,2
    800028fa:	bf45                	j	800028aa <devintr+0x22>

00000000800028fc <usertrap>:
{
    800028fc:	1101                	addi	sp,sp,-32
    800028fe:	ec06                	sd	ra,24(sp)
    80002900:	e822                	sd	s0,16(sp)
    80002902:	e426                	sd	s1,8(sp)
    80002904:	e04a                	sd	s2,0(sp)
    80002906:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002908:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000290c:	1007f793          	andi	a5,a5,256
    80002910:	ef85                	bnez	a5,80002948 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002912:	00003797          	auipc	a5,0x3
    80002916:	e1e78793          	addi	a5,a5,-482 # 80005730 <kernelvec>
    8000291a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000291e:	ff9fe0ef          	jal	80001916 <myproc>
    80002922:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002924:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002926:	14102773          	csrr	a4,sepc
    8000292a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000292c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002930:	47a1                	li	a5,8
    80002932:	02f70163          	beq	a4,a5,80002954 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80002936:	f53ff0ef          	jal	80002888 <devintr>
    8000293a:	892a                	mv	s2,a0
    8000293c:	c135                	beqz	a0,800029a0 <usertrap+0xa4>
  if(killed(p))
    8000293e:	8526                	mv	a0,s1
    80002940:	8dbff0ef          	jal	8000221a <killed>
    80002944:	cd1d                	beqz	a0,80002982 <usertrap+0x86>
    80002946:	a81d                	j	8000297c <usertrap+0x80>
    panic("usertrap: not from user mode");
    80002948:	00005517          	auipc	a0,0x5
    8000294c:	9d850513          	addi	a0,a0,-1576 # 80007320 <etext+0x320>
    80002950:	e45fd0ef          	jal	80000794 <panic>
    if(killed(p))
    80002954:	8c7ff0ef          	jal	8000221a <killed>
    80002958:	e121                	bnez	a0,80002998 <usertrap+0x9c>
    p->trapframe->epc += 4;
    8000295a:	70b8                	ld	a4,96(s1)
    8000295c:	6f1c                	ld	a5,24(a4)
    8000295e:	0791                	addi	a5,a5,4
    80002960:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002962:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002966:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000296a:	10079073          	csrw	sstatus,a5
    syscall();
    8000296e:	25c000ef          	jal	80002bca <syscall>
  if(killed(p))
    80002972:	8526                	mv	a0,s1
    80002974:	8a7ff0ef          	jal	8000221a <killed>
    80002978:	c901                	beqz	a0,80002988 <usertrap+0x8c>
    8000297a:	4901                	li	s2,0
    exit(-1);
    8000297c:	557d                	li	a0,-1
    8000297e:	efaff0ef          	jal	80002078 <exit>
  if(which_dev == 2)
    80002982:	4789                	li	a5,2
    80002984:	04f90563          	beq	s2,a5,800029ce <usertrap+0xd2>
  usertrapret();
    80002988:	e15ff0ef          	jal	8000279c <usertrapret>
}
    8000298c:	60e2                	ld	ra,24(sp)
    8000298e:	6442                	ld	s0,16(sp)
    80002990:	64a2                	ld	s1,8(sp)
    80002992:	6902                	ld	s2,0(sp)
    80002994:	6105                	addi	sp,sp,32
    80002996:	8082                	ret
      exit(-1);
    80002998:	557d                	li	a0,-1
    8000299a:	edeff0ef          	jal	80002078 <exit>
    8000299e:	bf75                	j	8000295a <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029a0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800029a4:	5890                	lw	a2,48(s1)
    800029a6:	00005517          	auipc	a0,0x5
    800029aa:	99a50513          	addi	a0,a0,-1638 # 80007340 <etext+0x340>
    800029ae:	b15fd0ef          	jal	800004c2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029b2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800029b6:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800029ba:	00005517          	auipc	a0,0x5
    800029be:	9b650513          	addi	a0,a0,-1610 # 80007370 <etext+0x370>
    800029c2:	b01fd0ef          	jal	800004c2 <printf>
    setkilled(p);
    800029c6:	8526                	mv	a0,s1
    800029c8:	82fff0ef          	jal	800021f6 <setkilled>
    800029cc:	b75d                	j	80002972 <usertrap+0x76>
    yield();
    800029ce:	d72ff0ef          	jal	80001f40 <yield>
    800029d2:	bf5d                	j	80002988 <usertrap+0x8c>

00000000800029d4 <kerneltrap>:
{
    800029d4:	7179                	addi	sp,sp,-48
    800029d6:	f406                	sd	ra,40(sp)
    800029d8:	f022                	sd	s0,32(sp)
    800029da:	ec26                	sd	s1,24(sp)
    800029dc:	e84a                	sd	s2,16(sp)
    800029de:	e44e                	sd	s3,8(sp)
    800029e0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800029e2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029e6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029ea:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800029ee:	1004f793          	andi	a5,s1,256
    800029f2:	c795                	beqz	a5,80002a1e <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029f4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800029f8:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800029fa:	eb85                	bnez	a5,80002a2a <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800029fc:	e8dff0ef          	jal	80002888 <devintr>
    80002a00:	c91d                	beqz	a0,80002a36 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80002a02:	4789                	li	a5,2
    80002a04:	04f50a63          	beq	a0,a5,80002a58 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002a08:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002a0c:	10049073          	csrw	sstatus,s1
}
    80002a10:	70a2                	ld	ra,40(sp)
    80002a12:	7402                	ld	s0,32(sp)
    80002a14:	64e2                	ld	s1,24(sp)
    80002a16:	6942                	ld	s2,16(sp)
    80002a18:	69a2                	ld	s3,8(sp)
    80002a1a:	6145                	addi	sp,sp,48
    80002a1c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002a1e:	00005517          	auipc	a0,0x5
    80002a22:	97a50513          	addi	a0,a0,-1670 # 80007398 <etext+0x398>
    80002a26:	d6ffd0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    80002a2a:	00005517          	auipc	a0,0x5
    80002a2e:	99650513          	addi	a0,a0,-1642 # 800073c0 <etext+0x3c0>
    80002a32:	d63fd0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002a36:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a3a:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80002a3e:	85ce                	mv	a1,s3
    80002a40:	00005517          	auipc	a0,0x5
    80002a44:	9a050513          	addi	a0,a0,-1632 # 800073e0 <etext+0x3e0>
    80002a48:	a7bfd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    80002a4c:	00005517          	auipc	a0,0x5
    80002a50:	9bc50513          	addi	a0,a0,-1604 # 80007408 <etext+0x408>
    80002a54:	d41fd0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002a58:	ebffe0ef          	jal	80001916 <myproc>
    80002a5c:	d555                	beqz	a0,80002a08 <kerneltrap+0x34>
    yield();
    80002a5e:	ce2ff0ef          	jal	80001f40 <yield>
    80002a62:	b75d                	j	80002a08 <kerneltrap+0x34>

0000000080002a64 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002a64:	1101                	addi	sp,sp,-32
    80002a66:	ec06                	sd	ra,24(sp)
    80002a68:	e822                	sd	s0,16(sp)
    80002a6a:	e426                	sd	s1,8(sp)
    80002a6c:	1000                	addi	s0,sp,32
    80002a6e:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002a70:	ea7fe0ef          	jal	80001916 <myproc>
  switch (n) {
    80002a74:	4795                	li	a5,5
    80002a76:	0497e163          	bltu	a5,s1,80002ab8 <argraw+0x54>
    80002a7a:	048a                	slli	s1,s1,0x2
    80002a7c:	00005717          	auipc	a4,0x5
    80002a80:	d4c70713          	addi	a4,a4,-692 # 800077c8 <states.0+0x30>
    80002a84:	94ba                	add	s1,s1,a4
    80002a86:	409c                	lw	a5,0(s1)
    80002a88:	97ba                	add	a5,a5,a4
    80002a8a:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002a8c:	713c                	ld	a5,96(a0)
    80002a8e:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002a90:	60e2                	ld	ra,24(sp)
    80002a92:	6442                	ld	s0,16(sp)
    80002a94:	64a2                	ld	s1,8(sp)
    80002a96:	6105                	addi	sp,sp,32
    80002a98:	8082                	ret
    return p->trapframe->a1;
    80002a9a:	713c                	ld	a5,96(a0)
    80002a9c:	7fa8                	ld	a0,120(a5)
    80002a9e:	bfcd                	j	80002a90 <argraw+0x2c>
    return p->trapframe->a2;
    80002aa0:	713c                	ld	a5,96(a0)
    80002aa2:	63c8                	ld	a0,128(a5)
    80002aa4:	b7f5                	j	80002a90 <argraw+0x2c>
    return p->trapframe->a3;
    80002aa6:	713c                	ld	a5,96(a0)
    80002aa8:	67c8                	ld	a0,136(a5)
    80002aaa:	b7dd                	j	80002a90 <argraw+0x2c>
    return p->trapframe->a4;
    80002aac:	713c                	ld	a5,96(a0)
    80002aae:	6bc8                	ld	a0,144(a5)
    80002ab0:	b7c5                	j	80002a90 <argraw+0x2c>
    return p->trapframe->a5;
    80002ab2:	713c                	ld	a5,96(a0)
    80002ab4:	6fc8                	ld	a0,152(a5)
    80002ab6:	bfe9                	j	80002a90 <argraw+0x2c>
  panic("argraw");
    80002ab8:	00005517          	auipc	a0,0x5
    80002abc:	96050513          	addi	a0,a0,-1696 # 80007418 <etext+0x418>
    80002ac0:	cd5fd0ef          	jal	80000794 <panic>

0000000080002ac4 <fetchaddr>:
{
    80002ac4:	1101                	addi	sp,sp,-32
    80002ac6:	ec06                	sd	ra,24(sp)
    80002ac8:	e822                	sd	s0,16(sp)
    80002aca:	e426                	sd	s1,8(sp)
    80002acc:	e04a                	sd	s2,0(sp)
    80002ace:	1000                	addi	s0,sp,32
    80002ad0:	84aa                	mv	s1,a0
    80002ad2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002ad4:	e43fe0ef          	jal	80001916 <myproc>
  struct proc *main = p->isThread ? p->main_thread : p;
    80002ad8:	17052783          	lw	a5,368(a0)
    80002adc:	c399                	beqz	a5,80002ae2 <fetchaddr+0x1e>
    80002ade:	18853503          	ld	a0,392(a0)
  if(addr >= main->sz || addr+sizeof(uint64) > main->sz) // both tests needed, in case of overflow
    80002ae2:	653c                	ld	a5,72(a0)
    80002ae4:	02f4f663          	bgeu	s1,a5,80002b10 <fetchaddr+0x4c>
    80002ae8:	00848713          	addi	a4,s1,8
    80002aec:	02e7e463          	bltu	a5,a4,80002b14 <fetchaddr+0x50>
  if(copyin(main->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002af0:	46a1                	li	a3,8
    80002af2:	8626                	mv	a2,s1
    80002af4:	85ca                	mv	a1,s2
    80002af6:	6928                	ld	a0,80(a0)
    80002af8:	b67fe0ef          	jal	8000165e <copyin>
    80002afc:	00a03533          	snez	a0,a0
    80002b00:	40a00533          	neg	a0,a0
}
    80002b04:	60e2                	ld	ra,24(sp)
    80002b06:	6442                	ld	s0,16(sp)
    80002b08:	64a2                	ld	s1,8(sp)
    80002b0a:	6902                	ld	s2,0(sp)
    80002b0c:	6105                	addi	sp,sp,32
    80002b0e:	8082                	ret
    return -1;
    80002b10:	557d                	li	a0,-1
    80002b12:	bfcd                	j	80002b04 <fetchaddr+0x40>
    80002b14:	557d                	li	a0,-1
    80002b16:	b7fd                	j	80002b04 <fetchaddr+0x40>

0000000080002b18 <fetchstr>:
{
    80002b18:	7179                	addi	sp,sp,-48
    80002b1a:	f406                	sd	ra,40(sp)
    80002b1c:	f022                	sd	s0,32(sp)
    80002b1e:	ec26                	sd	s1,24(sp)
    80002b20:	e84a                	sd	s2,16(sp)
    80002b22:	e44e                	sd	s3,8(sp)
    80002b24:	1800                	addi	s0,sp,48
    80002b26:	892a                	mv	s2,a0
    80002b28:	84ae                	mv	s1,a1
    80002b2a:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002b2c:	debfe0ef          	jal	80001916 <myproc>
  struct proc *main = p->isThread ? p->main_thread : p;
    80002b30:	17052783          	lw	a5,368(a0)
    80002b34:	c399                	beqz	a5,80002b3a <fetchstr+0x22>
    80002b36:	18853503          	ld	a0,392(a0)
  if(copyinstr(main->pagetable, buf, addr, max) < 0)
    80002b3a:	86ce                	mv	a3,s3
    80002b3c:	864a                	mv	a2,s2
    80002b3e:	85a6                	mv	a1,s1
    80002b40:	6928                	ld	a0,80(a0)
    80002b42:	ba3fe0ef          	jal	800016e4 <copyinstr>
    80002b46:	00054c63          	bltz	a0,80002b5e <fetchstr+0x46>
  return strlen(buf);
    80002b4a:	8526                	mv	a0,s1
    80002b4c:	aecfe0ef          	jal	80000e38 <strlen>
}
    80002b50:	70a2                	ld	ra,40(sp)
    80002b52:	7402                	ld	s0,32(sp)
    80002b54:	64e2                	ld	s1,24(sp)
    80002b56:	6942                	ld	s2,16(sp)
    80002b58:	69a2                	ld	s3,8(sp)
    80002b5a:	6145                	addi	sp,sp,48
    80002b5c:	8082                	ret
    return -1;
    80002b5e:	557d                	li	a0,-1
    80002b60:	bfc5                	j	80002b50 <fetchstr+0x38>

0000000080002b62 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002b62:	1101                	addi	sp,sp,-32
    80002b64:	ec06                	sd	ra,24(sp)
    80002b66:	e822                	sd	s0,16(sp)
    80002b68:	e426                	sd	s1,8(sp)
    80002b6a:	1000                	addi	s0,sp,32
    80002b6c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b6e:	ef7ff0ef          	jal	80002a64 <argraw>
    80002b72:	c088                	sw	a0,0(s1)
}
    80002b74:	60e2                	ld	ra,24(sp)
    80002b76:	6442                	ld	s0,16(sp)
    80002b78:	64a2                	ld	s1,8(sp)
    80002b7a:	6105                	addi	sp,sp,32
    80002b7c:	8082                	ret

0000000080002b7e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002b7e:	1101                	addi	sp,sp,-32
    80002b80:	ec06                	sd	ra,24(sp)
    80002b82:	e822                	sd	s0,16(sp)
    80002b84:	e426                	sd	s1,8(sp)
    80002b86:	1000                	addi	s0,sp,32
    80002b88:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002b8a:	edbff0ef          	jal	80002a64 <argraw>
    80002b8e:	e088                	sd	a0,0(s1)
}
    80002b90:	60e2                	ld	ra,24(sp)
    80002b92:	6442                	ld	s0,16(sp)
    80002b94:	64a2                	ld	s1,8(sp)
    80002b96:	6105                	addi	sp,sp,32
    80002b98:	8082                	ret

0000000080002b9a <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002b9a:	7179                	addi	sp,sp,-48
    80002b9c:	f406                	sd	ra,40(sp)
    80002b9e:	f022                	sd	s0,32(sp)
    80002ba0:	ec26                	sd	s1,24(sp)
    80002ba2:	e84a                	sd	s2,16(sp)
    80002ba4:	1800                	addi	s0,sp,48
    80002ba6:	84ae                	mv	s1,a1
    80002ba8:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002baa:	fd840593          	addi	a1,s0,-40
    80002bae:	fd1ff0ef          	jal	80002b7e <argaddr>
  return fetchstr(addr, buf, max);
    80002bb2:	864a                	mv	a2,s2
    80002bb4:	85a6                	mv	a1,s1
    80002bb6:	fd843503          	ld	a0,-40(s0)
    80002bba:	f5fff0ef          	jal	80002b18 <fetchstr>
}
    80002bbe:	70a2                	ld	ra,40(sp)
    80002bc0:	7402                	ld	s0,32(sp)
    80002bc2:	64e2                	ld	s1,24(sp)
    80002bc4:	6942                	ld	s2,16(sp)
    80002bc6:	6145                	addi	sp,sp,48
    80002bc8:	8082                	ret

0000000080002bca <syscall>:
[SYS_join]    sys_join,
};

void
syscall(void)
{
    80002bca:	1101                	addi	sp,sp,-32
    80002bcc:	ec06                	sd	ra,24(sp)
    80002bce:	e822                	sd	s0,16(sp)
    80002bd0:	e426                	sd	s1,8(sp)
    80002bd2:	e04a                	sd	s2,0(sp)
    80002bd4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002bd6:	d41fe0ef          	jal	80001916 <myproc>
    80002bda:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002bdc:	06053903          	ld	s2,96(a0)
    80002be0:	0a893783          	ld	a5,168(s2)
    80002be4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002be8:	37fd                	addiw	a5,a5,-1
    80002bea:	4759                	li	a4,22
    80002bec:	00f76f63          	bltu	a4,a5,80002c0a <syscall+0x40>
    80002bf0:	00369713          	slli	a4,a3,0x3
    80002bf4:	00005797          	auipc	a5,0x5
    80002bf8:	bec78793          	addi	a5,a5,-1044 # 800077e0 <syscalls>
    80002bfc:	97ba                	add	a5,a5,a4
    80002bfe:	639c                	ld	a5,0(a5)
    80002c00:	c789                	beqz	a5,80002c0a <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002c02:	9782                	jalr	a5
    80002c04:	06a93823          	sd	a0,112(s2)
    80002c08:	a829                	j	80002c22 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002c0a:	16048613          	addi	a2,s1,352
    80002c0e:	588c                	lw	a1,48(s1)
    80002c10:	00005517          	auipc	a0,0x5
    80002c14:	81050513          	addi	a0,a0,-2032 # 80007420 <etext+0x420>
    80002c18:	8abfd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002c1c:	70bc                	ld	a5,96(s1)
    80002c1e:	577d                	li	a4,-1
    80002c20:	fbb8                	sd	a4,112(a5)
  }
}
    80002c22:	60e2                	ld	ra,24(sp)
    80002c24:	6442                	ld	s0,16(sp)
    80002c26:	64a2                	ld	s1,8(sp)
    80002c28:	6902                	ld	s2,0(sp)
    80002c2a:	6105                	addi	sp,sp,32
    80002c2c:	8082                	ret

0000000080002c2e <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002c2e:	1101                	addi	sp,sp,-32
    80002c30:	ec06                	sd	ra,24(sp)
    80002c32:	e822                	sd	s0,16(sp)
    80002c34:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002c36:	fec40593          	addi	a1,s0,-20
    80002c3a:	4501                	li	a0,0
    80002c3c:	f27ff0ef          	jal	80002b62 <argint>
  exit(n);
    80002c40:	fec42503          	lw	a0,-20(s0)
    80002c44:	c34ff0ef          	jal	80002078 <exit>
  return 0;  // not reached
}
    80002c48:	4501                	li	a0,0
    80002c4a:	60e2                	ld	ra,24(sp)
    80002c4c:	6442                	ld	s0,16(sp)
    80002c4e:	6105                	addi	sp,sp,32
    80002c50:	8082                	ret

0000000080002c52 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002c52:	1141                	addi	sp,sp,-16
    80002c54:	e406                	sd	ra,8(sp)
    80002c56:	e022                	sd	s0,0(sp)
    80002c58:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002c5a:	cbdfe0ef          	jal	80001916 <myproc>
}
    80002c5e:	5908                	lw	a0,48(a0)
    80002c60:	60a2                	ld	ra,8(sp)
    80002c62:	6402                	ld	s0,0(sp)
    80002c64:	0141                	addi	sp,sp,16
    80002c66:	8082                	ret

0000000080002c68 <sys_fork>:

uint64
sys_fork(void)
{
    80002c68:	1141                	addi	sp,sp,-16
    80002c6a:	e406                	sd	ra,8(sp)
    80002c6c:	e022                	sd	s0,0(sp)
    80002c6e:	0800                	addi	s0,sp,16
  return fork();
    80002c70:	844ff0ef          	jal	80001cb4 <fork>
}
    80002c74:	60a2                	ld	ra,8(sp)
    80002c76:	6402                	ld	s0,0(sp)
    80002c78:	0141                	addi	sp,sp,16
    80002c7a:	8082                	ret

0000000080002c7c <sys_wait>:

uint64
sys_wait(void)
{
    80002c7c:	1101                	addi	sp,sp,-32
    80002c7e:	ec06                	sd	ra,24(sp)
    80002c80:	e822                	sd	s0,16(sp)
    80002c82:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002c84:	fe840593          	addi	a1,s0,-24
    80002c88:	4501                	li	a0,0
    80002c8a:	ef5ff0ef          	jal	80002b7e <argaddr>
  return wait(p);
    80002c8e:	fe843503          	ld	a0,-24(s0)
    80002c92:	db2ff0ef          	jal	80002244 <wait>
}
    80002c96:	60e2                	ld	ra,24(sp)
    80002c98:	6442                	ld	s0,16(sp)
    80002c9a:	6105                	addi	sp,sp,32
    80002c9c:	8082                	ret

0000000080002c9e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002c9e:	7179                	addi	sp,sp,-48
    80002ca0:	f406                	sd	ra,40(sp)
    80002ca2:	f022                	sd	s0,32(sp)
    80002ca4:	ec26                	sd	s1,24(sp)
    80002ca6:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;
  struct proc *p = myproc()->isThread ? myproc()->main_thread : myproc();
    80002ca8:	c6ffe0ef          	jal	80001916 <myproc>
    80002cac:	17052783          	lw	a5,368(a0)
    80002cb0:	c79d                	beqz	a5,80002cde <sys_sbrk+0x40>
    80002cb2:	c65fe0ef          	jal	80001916 <myproc>
    80002cb6:	18853483          	ld	s1,392(a0)

  argint(0, &n);
    80002cba:	fdc40593          	addi	a1,s0,-36
    80002cbe:	4501                	li	a0,0
    80002cc0:	ea3ff0ef          	jal	80002b62 <argint>
  addr = p->sz;
    80002cc4:	64a4                	ld	s1,72(s1)
  if(growproc(n) < 0)
    80002cc6:	fdc42503          	lw	a0,-36(s0)
    80002cca:	f75fe0ef          	jal	80001c3e <growproc>
    80002cce:	00054c63          	bltz	a0,80002ce6 <sys_sbrk+0x48>
    return -1;
  return addr;
}
    80002cd2:	8526                	mv	a0,s1
    80002cd4:	70a2                	ld	ra,40(sp)
    80002cd6:	7402                	ld	s0,32(sp)
    80002cd8:	64e2                	ld	s1,24(sp)
    80002cda:	6145                	addi	sp,sp,48
    80002cdc:	8082                	ret
  struct proc *p = myproc()->isThread ? myproc()->main_thread : myproc();
    80002cde:	c39fe0ef          	jal	80001916 <myproc>
    80002ce2:	84aa                	mv	s1,a0
    80002ce4:	bfd9                	j	80002cba <sys_sbrk+0x1c>
    return -1;
    80002ce6:	54fd                	li	s1,-1
    80002ce8:	b7ed                	j	80002cd2 <sys_sbrk+0x34>

0000000080002cea <sys_sleep>:

uint64
sys_sleep(void)
{
    80002cea:	7139                	addi	sp,sp,-64
    80002cec:	fc06                	sd	ra,56(sp)
    80002cee:	f822                	sd	s0,48(sp)
    80002cf0:	f04a                	sd	s2,32(sp)
    80002cf2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002cf4:	fcc40593          	addi	a1,s0,-52
    80002cf8:	4501                	li	a0,0
    80002cfa:	e69ff0ef          	jal	80002b62 <argint>
  if(n < 0)
    80002cfe:	fcc42783          	lw	a5,-52(s0)
    80002d02:	0607c763          	bltz	a5,80002d70 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002d06:	00016517          	auipc	a0,0x16
    80002d0a:	fba50513          	addi	a0,a0,-70 # 80018cc0 <tickslock>
    80002d0e:	ee7fd0ef          	jal	80000bf4 <acquire>
  ticks0 = ticks;
    80002d12:	00007917          	auipc	s2,0x7
    80002d16:	64e92903          	lw	s2,1614(s2) # 8000a360 <ticks>
  while(ticks - ticks0 < n){
    80002d1a:	fcc42783          	lw	a5,-52(s0)
    80002d1e:	cf8d                	beqz	a5,80002d58 <sys_sleep+0x6e>
    80002d20:	f426                	sd	s1,40(sp)
    80002d22:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002d24:	00016997          	auipc	s3,0x16
    80002d28:	f9c98993          	addi	s3,s3,-100 # 80018cc0 <tickslock>
    80002d2c:	00007497          	auipc	s1,0x7
    80002d30:	63448493          	addi	s1,s1,1588 # 8000a360 <ticks>
    if(killed(myproc())){
    80002d34:	be3fe0ef          	jal	80001916 <myproc>
    80002d38:	ce2ff0ef          	jal	8000221a <killed>
    80002d3c:	ed0d                	bnez	a0,80002d76 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002d3e:	85ce                	mv	a1,s3
    80002d40:	8526                	mv	a0,s1
    80002d42:	a2aff0ef          	jal	80001f6c <sleep>
  while(ticks - ticks0 < n){
    80002d46:	409c                	lw	a5,0(s1)
    80002d48:	412787bb          	subw	a5,a5,s2
    80002d4c:	fcc42703          	lw	a4,-52(s0)
    80002d50:	fee7e2e3          	bltu	a5,a4,80002d34 <sys_sleep+0x4a>
    80002d54:	74a2                	ld	s1,40(sp)
    80002d56:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002d58:	00016517          	auipc	a0,0x16
    80002d5c:	f6850513          	addi	a0,a0,-152 # 80018cc0 <tickslock>
    80002d60:	f2dfd0ef          	jal	80000c8c <release>
  return 0;
    80002d64:	4501                	li	a0,0
}
    80002d66:	70e2                	ld	ra,56(sp)
    80002d68:	7442                	ld	s0,48(sp)
    80002d6a:	7902                	ld	s2,32(sp)
    80002d6c:	6121                	addi	sp,sp,64
    80002d6e:	8082                	ret
    n = 0;
    80002d70:	fc042623          	sw	zero,-52(s0)
    80002d74:	bf49                	j	80002d06 <sys_sleep+0x1c>
      release(&tickslock);
    80002d76:	00016517          	auipc	a0,0x16
    80002d7a:	f4a50513          	addi	a0,a0,-182 # 80018cc0 <tickslock>
    80002d7e:	f0ffd0ef          	jal	80000c8c <release>
      return -1;
    80002d82:	557d                	li	a0,-1
    80002d84:	74a2                	ld	s1,40(sp)
    80002d86:	69e2                	ld	s3,24(sp)
    80002d88:	bff9                	j	80002d66 <sys_sleep+0x7c>

0000000080002d8a <sys_kill>:

uint64
sys_kill(void)
{
    80002d8a:	1101                	addi	sp,sp,-32
    80002d8c:	ec06                	sd	ra,24(sp)
    80002d8e:	e822                	sd	s0,16(sp)
    80002d90:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002d92:	fec40593          	addi	a1,s0,-20
    80002d96:	4501                	li	a0,0
    80002d98:	dcbff0ef          	jal	80002b62 <argint>
  return kill(pid);
    80002d9c:	fec42503          	lw	a0,-20(s0)
    80002da0:	bf0ff0ef          	jal	80002190 <kill>
}
    80002da4:	60e2                	ld	ra,24(sp)
    80002da6:	6442                	ld	s0,16(sp)
    80002da8:	6105                	addi	sp,sp,32
    80002daa:	8082                	ret

0000000080002dac <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002dac:	1101                	addi	sp,sp,-32
    80002dae:	ec06                	sd	ra,24(sp)
    80002db0:	e822                	sd	s0,16(sp)
    80002db2:	e426                	sd	s1,8(sp)
    80002db4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002db6:	00016517          	auipc	a0,0x16
    80002dba:	f0a50513          	addi	a0,a0,-246 # 80018cc0 <tickslock>
    80002dbe:	e37fd0ef          	jal	80000bf4 <acquire>
  xticks = ticks;
    80002dc2:	00007497          	auipc	s1,0x7
    80002dc6:	59e4a483          	lw	s1,1438(s1) # 8000a360 <ticks>
  release(&tickslock);
    80002dca:	00016517          	auipc	a0,0x16
    80002dce:	ef650513          	addi	a0,a0,-266 # 80018cc0 <tickslock>
    80002dd2:	ebbfd0ef          	jal	80000c8c <release>
  return xticks;
}
    80002dd6:	02049513          	slli	a0,s1,0x20
    80002dda:	9101                	srli	a0,a0,0x20
    80002ddc:	60e2                	ld	ra,24(sp)
    80002dde:	6442                	ld	s0,16(sp)
    80002de0:	64a2                	ld	s1,8(sp)
    80002de2:	6105                	addi	sp,sp,32
    80002de4:	8082                	ret

0000000080002de6 <sys_clone>:

uint64
sys_clone(void) 
{ 
    80002de6:	7179                	addi	sp,sp,-48
    80002de8:	f406                	sd	ra,40(sp)
    80002dea:	f022                	sd	s0,32(sp)
    80002dec:	1800                	addi	s0,sp,48
  uint64 fcn, arg1, arg2, stack;

  argaddr(0, &fcn);
    80002dee:	fe840593          	addi	a1,s0,-24
    80002df2:	4501                	li	a0,0
    80002df4:	d8bff0ef          	jal	80002b7e <argaddr>
  argaddr(1, &arg1);
    80002df8:	fe040593          	addi	a1,s0,-32
    80002dfc:	4505                	li	a0,1
    80002dfe:	d81ff0ef          	jal	80002b7e <argaddr>
  argaddr(2, &arg2);
    80002e02:	fd840593          	addi	a1,s0,-40
    80002e06:	4509                	li	a0,2
    80002e08:	d77ff0ef          	jal	80002b7e <argaddr>
  argaddr(3, &stack);
    80002e0c:	fd040593          	addi	a1,s0,-48
    80002e10:	450d                	li	a0,3
    80002e12:	d6dff0ef          	jal	80002b7e <argaddr>
 
  return clone((void (*)(void*, void*))fcn, (void *)arg1, (void *)arg2, (void *)stack);
    80002e16:	fd043683          	ld	a3,-48(s0)
    80002e1a:	fd843603          	ld	a2,-40(s0)
    80002e1e:	fe043583          	ld	a1,-32(s0)
    80002e22:	fe843503          	ld	a0,-24(s0)
    80002e26:	e50ff0ef          	jal	80002476 <clone>
}
    80002e2a:	70a2                	ld	ra,40(sp)
    80002e2c:	7402                	ld	s0,32(sp)
    80002e2e:	6145                	addi	sp,sp,48
    80002e30:	8082                	ret

0000000080002e32 <sys_join>:

uint64
sys_join(void) 
{
    80002e32:	1101                	addi	sp,sp,-32
    80002e34:	ec06                	sd	ra,24(sp)
    80002e36:	e822                	sd	s0,16(sp)
    80002e38:	1000                	addi	s0,sp,32
  uint64 stack;

  argaddr(0, &stack);
    80002e3a:	fe840593          	addi	a1,s0,-24
    80002e3e:	4501                	li	a0,0
    80002e40:	d3fff0ef          	jal	80002b7e <argaddr>
  return join((void **)stack);
    80002e44:	fe843503          	ld	a0,-24(s0)
    80002e48:	facff0ef          	jal	800025f4 <join>
    80002e4c:	60e2                	ld	ra,24(sp)
    80002e4e:	6442                	ld	s0,16(sp)
    80002e50:	6105                	addi	sp,sp,32
    80002e52:	8082                	ret

0000000080002e54 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002e54:	7179                	addi	sp,sp,-48
    80002e56:	f406                	sd	ra,40(sp)
    80002e58:	f022                	sd	s0,32(sp)
    80002e5a:	ec26                	sd	s1,24(sp)
    80002e5c:	e84a                	sd	s2,16(sp)
    80002e5e:	e44e                	sd	s3,8(sp)
    80002e60:	e052                	sd	s4,0(sp)
    80002e62:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002e64:	00004597          	auipc	a1,0x4
    80002e68:	5dc58593          	addi	a1,a1,1500 # 80007440 <etext+0x440>
    80002e6c:	00016517          	auipc	a0,0x16
    80002e70:	e6c50513          	addi	a0,a0,-404 # 80018cd8 <bcache>
    80002e74:	d01fd0ef          	jal	80000b74 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002e78:	0001e797          	auipc	a5,0x1e
    80002e7c:	e6078793          	addi	a5,a5,-416 # 80020cd8 <bcache+0x8000>
    80002e80:	0001e717          	auipc	a4,0x1e
    80002e84:	0c070713          	addi	a4,a4,192 # 80020f40 <bcache+0x8268>
    80002e88:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002e8c:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002e90:	00016497          	auipc	s1,0x16
    80002e94:	e6048493          	addi	s1,s1,-416 # 80018cf0 <bcache+0x18>
    b->next = bcache.head.next;
    80002e98:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002e9a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002e9c:	00004a17          	auipc	s4,0x4
    80002ea0:	5aca0a13          	addi	s4,s4,1452 # 80007448 <etext+0x448>
    b->next = bcache.head.next;
    80002ea4:	2b893783          	ld	a5,696(s2)
    80002ea8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002eaa:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002eae:	85d2                	mv	a1,s4
    80002eb0:	01048513          	addi	a0,s1,16
    80002eb4:	248010ef          	jal	800040fc <initsleeplock>
    bcache.head.next->prev = b;
    80002eb8:	2b893783          	ld	a5,696(s2)
    80002ebc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002ebe:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002ec2:	45848493          	addi	s1,s1,1112
    80002ec6:	fd349fe3          	bne	s1,s3,80002ea4 <binit+0x50>
  }
}
    80002eca:	70a2                	ld	ra,40(sp)
    80002ecc:	7402                	ld	s0,32(sp)
    80002ece:	64e2                	ld	s1,24(sp)
    80002ed0:	6942                	ld	s2,16(sp)
    80002ed2:	69a2                	ld	s3,8(sp)
    80002ed4:	6a02                	ld	s4,0(sp)
    80002ed6:	6145                	addi	sp,sp,48
    80002ed8:	8082                	ret

0000000080002eda <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002eda:	7179                	addi	sp,sp,-48
    80002edc:	f406                	sd	ra,40(sp)
    80002ede:	f022                	sd	s0,32(sp)
    80002ee0:	ec26                	sd	s1,24(sp)
    80002ee2:	e84a                	sd	s2,16(sp)
    80002ee4:	e44e                	sd	s3,8(sp)
    80002ee6:	1800                	addi	s0,sp,48
    80002ee8:	892a                	mv	s2,a0
    80002eea:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002eec:	00016517          	auipc	a0,0x16
    80002ef0:	dec50513          	addi	a0,a0,-532 # 80018cd8 <bcache>
    80002ef4:	d01fd0ef          	jal	80000bf4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002ef8:	0001e497          	auipc	s1,0x1e
    80002efc:	0984b483          	ld	s1,152(s1) # 80020f90 <bcache+0x82b8>
    80002f00:	0001e797          	auipc	a5,0x1e
    80002f04:	04078793          	addi	a5,a5,64 # 80020f40 <bcache+0x8268>
    80002f08:	02f48b63          	beq	s1,a5,80002f3e <bread+0x64>
    80002f0c:	873e                	mv	a4,a5
    80002f0e:	a021                	j	80002f16 <bread+0x3c>
    80002f10:	68a4                	ld	s1,80(s1)
    80002f12:	02e48663          	beq	s1,a4,80002f3e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002f16:	449c                	lw	a5,8(s1)
    80002f18:	ff279ce3          	bne	a5,s2,80002f10 <bread+0x36>
    80002f1c:	44dc                	lw	a5,12(s1)
    80002f1e:	ff3799e3          	bne	a5,s3,80002f10 <bread+0x36>
      b->refcnt++;
    80002f22:	40bc                	lw	a5,64(s1)
    80002f24:	2785                	addiw	a5,a5,1
    80002f26:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f28:	00016517          	auipc	a0,0x16
    80002f2c:	db050513          	addi	a0,a0,-592 # 80018cd8 <bcache>
    80002f30:	d5dfd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002f34:	01048513          	addi	a0,s1,16
    80002f38:	1fa010ef          	jal	80004132 <acquiresleep>
      return b;
    80002f3c:	a889                	j	80002f8e <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f3e:	0001e497          	auipc	s1,0x1e
    80002f42:	04a4b483          	ld	s1,74(s1) # 80020f88 <bcache+0x82b0>
    80002f46:	0001e797          	auipc	a5,0x1e
    80002f4a:	ffa78793          	addi	a5,a5,-6 # 80020f40 <bcache+0x8268>
    80002f4e:	00f48863          	beq	s1,a5,80002f5e <bread+0x84>
    80002f52:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002f54:	40bc                	lw	a5,64(s1)
    80002f56:	cb91                	beqz	a5,80002f6a <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002f58:	64a4                	ld	s1,72(s1)
    80002f5a:	fee49de3          	bne	s1,a4,80002f54 <bread+0x7a>
  panic("bget: no buffers");
    80002f5e:	00004517          	auipc	a0,0x4
    80002f62:	4f250513          	addi	a0,a0,1266 # 80007450 <etext+0x450>
    80002f66:	82ffd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002f6a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002f6e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002f72:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002f76:	4785                	li	a5,1
    80002f78:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002f7a:	00016517          	auipc	a0,0x16
    80002f7e:	d5e50513          	addi	a0,a0,-674 # 80018cd8 <bcache>
    80002f82:	d0bfd0ef          	jal	80000c8c <release>
      acquiresleep(&b->lock);
    80002f86:	01048513          	addi	a0,s1,16
    80002f8a:	1a8010ef          	jal	80004132 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002f8e:	409c                	lw	a5,0(s1)
    80002f90:	cb89                	beqz	a5,80002fa2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002f92:	8526                	mv	a0,s1
    80002f94:	70a2                	ld	ra,40(sp)
    80002f96:	7402                	ld	s0,32(sp)
    80002f98:	64e2                	ld	s1,24(sp)
    80002f9a:	6942                	ld	s2,16(sp)
    80002f9c:	69a2                	ld	s3,8(sp)
    80002f9e:	6145                	addi	sp,sp,48
    80002fa0:	8082                	ret
    virtio_disk_rw(b, 0);
    80002fa2:	4581                	li	a1,0
    80002fa4:	8526                	mv	a0,s1
    80002fa6:	2eb020ef          	jal	80005a90 <virtio_disk_rw>
    b->valid = 1;
    80002faa:	4785                	li	a5,1
    80002fac:	c09c                	sw	a5,0(s1)
  return b;
    80002fae:	b7d5                	j	80002f92 <bread+0xb8>

0000000080002fb0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002fb0:	1101                	addi	sp,sp,-32
    80002fb2:	ec06                	sd	ra,24(sp)
    80002fb4:	e822                	sd	s0,16(sp)
    80002fb6:	e426                	sd	s1,8(sp)
    80002fb8:	1000                	addi	s0,sp,32
    80002fba:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002fbc:	0541                	addi	a0,a0,16
    80002fbe:	1f2010ef          	jal	800041b0 <holdingsleep>
    80002fc2:	c911                	beqz	a0,80002fd6 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002fc4:	4585                	li	a1,1
    80002fc6:	8526                	mv	a0,s1
    80002fc8:	2c9020ef          	jal	80005a90 <virtio_disk_rw>
}
    80002fcc:	60e2                	ld	ra,24(sp)
    80002fce:	6442                	ld	s0,16(sp)
    80002fd0:	64a2                	ld	s1,8(sp)
    80002fd2:	6105                	addi	sp,sp,32
    80002fd4:	8082                	ret
    panic("bwrite");
    80002fd6:	00004517          	auipc	a0,0x4
    80002fda:	49250513          	addi	a0,a0,1170 # 80007468 <etext+0x468>
    80002fde:	fb6fd0ef          	jal	80000794 <panic>

0000000080002fe2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002fe2:	1101                	addi	sp,sp,-32
    80002fe4:	ec06                	sd	ra,24(sp)
    80002fe6:	e822                	sd	s0,16(sp)
    80002fe8:	e426                	sd	s1,8(sp)
    80002fea:	e04a                	sd	s2,0(sp)
    80002fec:	1000                	addi	s0,sp,32
    80002fee:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002ff0:	01050913          	addi	s2,a0,16
    80002ff4:	854a                	mv	a0,s2
    80002ff6:	1ba010ef          	jal	800041b0 <holdingsleep>
    80002ffa:	c135                	beqz	a0,8000305e <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002ffc:	854a                	mv	a0,s2
    80002ffe:	17a010ef          	jal	80004178 <releasesleep>

  acquire(&bcache.lock);
    80003002:	00016517          	auipc	a0,0x16
    80003006:	cd650513          	addi	a0,a0,-810 # 80018cd8 <bcache>
    8000300a:	bebfd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    8000300e:	40bc                	lw	a5,64(s1)
    80003010:	37fd                	addiw	a5,a5,-1
    80003012:	0007871b          	sext.w	a4,a5
    80003016:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003018:	e71d                	bnez	a4,80003046 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000301a:	68b8                	ld	a4,80(s1)
    8000301c:	64bc                	ld	a5,72(s1)
    8000301e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003020:	68b8                	ld	a4,80(s1)
    80003022:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003024:	0001e797          	auipc	a5,0x1e
    80003028:	cb478793          	addi	a5,a5,-844 # 80020cd8 <bcache+0x8000>
    8000302c:	2b87b703          	ld	a4,696(a5)
    80003030:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003032:	0001e717          	auipc	a4,0x1e
    80003036:	f0e70713          	addi	a4,a4,-242 # 80020f40 <bcache+0x8268>
    8000303a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000303c:	2b87b703          	ld	a4,696(a5)
    80003040:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003042:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80003046:	00016517          	auipc	a0,0x16
    8000304a:	c9250513          	addi	a0,a0,-878 # 80018cd8 <bcache>
    8000304e:	c3ffd0ef          	jal	80000c8c <release>
}
    80003052:	60e2                	ld	ra,24(sp)
    80003054:	6442                	ld	s0,16(sp)
    80003056:	64a2                	ld	s1,8(sp)
    80003058:	6902                	ld	s2,0(sp)
    8000305a:	6105                	addi	sp,sp,32
    8000305c:	8082                	ret
    panic("brelse");
    8000305e:	00004517          	auipc	a0,0x4
    80003062:	41250513          	addi	a0,a0,1042 # 80007470 <etext+0x470>
    80003066:	f2efd0ef          	jal	80000794 <panic>

000000008000306a <bpin>:

void
bpin(struct buf *b) {
    8000306a:	1101                	addi	sp,sp,-32
    8000306c:	ec06                	sd	ra,24(sp)
    8000306e:	e822                	sd	s0,16(sp)
    80003070:	e426                	sd	s1,8(sp)
    80003072:	1000                	addi	s0,sp,32
    80003074:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003076:	00016517          	auipc	a0,0x16
    8000307a:	c6250513          	addi	a0,a0,-926 # 80018cd8 <bcache>
    8000307e:	b77fd0ef          	jal	80000bf4 <acquire>
  b->refcnt++;
    80003082:	40bc                	lw	a5,64(s1)
    80003084:	2785                	addiw	a5,a5,1
    80003086:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003088:	00016517          	auipc	a0,0x16
    8000308c:	c5050513          	addi	a0,a0,-944 # 80018cd8 <bcache>
    80003090:	bfdfd0ef          	jal	80000c8c <release>
}
    80003094:	60e2                	ld	ra,24(sp)
    80003096:	6442                	ld	s0,16(sp)
    80003098:	64a2                	ld	s1,8(sp)
    8000309a:	6105                	addi	sp,sp,32
    8000309c:	8082                	ret

000000008000309e <bunpin>:

void
bunpin(struct buf *b) {
    8000309e:	1101                	addi	sp,sp,-32
    800030a0:	ec06                	sd	ra,24(sp)
    800030a2:	e822                	sd	s0,16(sp)
    800030a4:	e426                	sd	s1,8(sp)
    800030a6:	1000                	addi	s0,sp,32
    800030a8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800030aa:	00016517          	auipc	a0,0x16
    800030ae:	c2e50513          	addi	a0,a0,-978 # 80018cd8 <bcache>
    800030b2:	b43fd0ef          	jal	80000bf4 <acquire>
  b->refcnt--;
    800030b6:	40bc                	lw	a5,64(s1)
    800030b8:	37fd                	addiw	a5,a5,-1
    800030ba:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800030bc:	00016517          	auipc	a0,0x16
    800030c0:	c1c50513          	addi	a0,a0,-996 # 80018cd8 <bcache>
    800030c4:	bc9fd0ef          	jal	80000c8c <release>
}
    800030c8:	60e2                	ld	ra,24(sp)
    800030ca:	6442                	ld	s0,16(sp)
    800030cc:	64a2                	ld	s1,8(sp)
    800030ce:	6105                	addi	sp,sp,32
    800030d0:	8082                	ret

00000000800030d2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800030d2:	1101                	addi	sp,sp,-32
    800030d4:	ec06                	sd	ra,24(sp)
    800030d6:	e822                	sd	s0,16(sp)
    800030d8:	e426                	sd	s1,8(sp)
    800030da:	e04a                	sd	s2,0(sp)
    800030dc:	1000                	addi	s0,sp,32
    800030de:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800030e0:	00d5d59b          	srliw	a1,a1,0xd
    800030e4:	0001e797          	auipc	a5,0x1e
    800030e8:	2d07a783          	lw	a5,720(a5) # 800213b4 <sb+0x1c>
    800030ec:	9dbd                	addw	a1,a1,a5
    800030ee:	dedff0ef          	jal	80002eda <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800030f2:	0074f713          	andi	a4,s1,7
    800030f6:	4785                	li	a5,1
    800030f8:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800030fc:	14ce                	slli	s1,s1,0x33
    800030fe:	90d9                	srli	s1,s1,0x36
    80003100:	00950733          	add	a4,a0,s1
    80003104:	05874703          	lbu	a4,88(a4)
    80003108:	00e7f6b3          	and	a3,a5,a4
    8000310c:	c29d                	beqz	a3,80003132 <bfree+0x60>
    8000310e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003110:	94aa                	add	s1,s1,a0
    80003112:	fff7c793          	not	a5,a5
    80003116:	8f7d                	and	a4,a4,a5
    80003118:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000311c:	711000ef          	jal	8000402c <log_write>
  brelse(bp);
    80003120:	854a                	mv	a0,s2
    80003122:	ec1ff0ef          	jal	80002fe2 <brelse>
}
    80003126:	60e2                	ld	ra,24(sp)
    80003128:	6442                	ld	s0,16(sp)
    8000312a:	64a2                	ld	s1,8(sp)
    8000312c:	6902                	ld	s2,0(sp)
    8000312e:	6105                	addi	sp,sp,32
    80003130:	8082                	ret
    panic("freeing free block");
    80003132:	00004517          	auipc	a0,0x4
    80003136:	34650513          	addi	a0,a0,838 # 80007478 <etext+0x478>
    8000313a:	e5afd0ef          	jal	80000794 <panic>

000000008000313e <balloc>:
{
    8000313e:	711d                	addi	sp,sp,-96
    80003140:	ec86                	sd	ra,88(sp)
    80003142:	e8a2                	sd	s0,80(sp)
    80003144:	e4a6                	sd	s1,72(sp)
    80003146:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003148:	0001e797          	auipc	a5,0x1e
    8000314c:	2547a783          	lw	a5,596(a5) # 8002139c <sb+0x4>
    80003150:	0e078f63          	beqz	a5,8000324e <balloc+0x110>
    80003154:	e0ca                	sd	s2,64(sp)
    80003156:	fc4e                	sd	s3,56(sp)
    80003158:	f852                	sd	s4,48(sp)
    8000315a:	f456                	sd	s5,40(sp)
    8000315c:	f05a                	sd	s6,32(sp)
    8000315e:	ec5e                	sd	s7,24(sp)
    80003160:	e862                	sd	s8,16(sp)
    80003162:	e466                	sd	s9,8(sp)
    80003164:	8baa                	mv	s7,a0
    80003166:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003168:	0001eb17          	auipc	s6,0x1e
    8000316c:	230b0b13          	addi	s6,s6,560 # 80021398 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003170:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003172:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003174:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003176:	6c89                	lui	s9,0x2
    80003178:	a0b5                	j	800031e4 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000317a:	97ca                	add	a5,a5,s2
    8000317c:	8e55                	or	a2,a2,a3
    8000317e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003182:	854a                	mv	a0,s2
    80003184:	6a9000ef          	jal	8000402c <log_write>
        brelse(bp);
    80003188:	854a                	mv	a0,s2
    8000318a:	e59ff0ef          	jal	80002fe2 <brelse>
  bp = bread(dev, bno);
    8000318e:	85a6                	mv	a1,s1
    80003190:	855e                	mv	a0,s7
    80003192:	d49ff0ef          	jal	80002eda <bread>
    80003196:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003198:	40000613          	li	a2,1024
    8000319c:	4581                	li	a1,0
    8000319e:	05850513          	addi	a0,a0,88
    800031a2:	b27fd0ef          	jal	80000cc8 <memset>
  log_write(bp);
    800031a6:	854a                	mv	a0,s2
    800031a8:	685000ef          	jal	8000402c <log_write>
  brelse(bp);
    800031ac:	854a                	mv	a0,s2
    800031ae:	e35ff0ef          	jal	80002fe2 <brelse>
}
    800031b2:	6906                	ld	s2,64(sp)
    800031b4:	79e2                	ld	s3,56(sp)
    800031b6:	7a42                	ld	s4,48(sp)
    800031b8:	7aa2                	ld	s5,40(sp)
    800031ba:	7b02                	ld	s6,32(sp)
    800031bc:	6be2                	ld	s7,24(sp)
    800031be:	6c42                	ld	s8,16(sp)
    800031c0:	6ca2                	ld	s9,8(sp)
}
    800031c2:	8526                	mv	a0,s1
    800031c4:	60e6                	ld	ra,88(sp)
    800031c6:	6446                	ld	s0,80(sp)
    800031c8:	64a6                	ld	s1,72(sp)
    800031ca:	6125                	addi	sp,sp,96
    800031cc:	8082                	ret
    brelse(bp);
    800031ce:	854a                	mv	a0,s2
    800031d0:	e13ff0ef          	jal	80002fe2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800031d4:	015c87bb          	addw	a5,s9,s5
    800031d8:	00078a9b          	sext.w	s5,a5
    800031dc:	004b2703          	lw	a4,4(s6)
    800031e0:	04eaff63          	bgeu	s5,a4,8000323e <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    800031e4:	41fad79b          	sraiw	a5,s5,0x1f
    800031e8:	0137d79b          	srliw	a5,a5,0x13
    800031ec:	015787bb          	addw	a5,a5,s5
    800031f0:	40d7d79b          	sraiw	a5,a5,0xd
    800031f4:	01cb2583          	lw	a1,28(s6)
    800031f8:	9dbd                	addw	a1,a1,a5
    800031fa:	855e                	mv	a0,s7
    800031fc:	cdfff0ef          	jal	80002eda <bread>
    80003200:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003202:	004b2503          	lw	a0,4(s6)
    80003206:	000a849b          	sext.w	s1,s5
    8000320a:	8762                	mv	a4,s8
    8000320c:	fca4f1e3          	bgeu	s1,a0,800031ce <balloc+0x90>
      m = 1 << (bi % 8);
    80003210:	00777693          	andi	a3,a4,7
    80003214:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003218:	41f7579b          	sraiw	a5,a4,0x1f
    8000321c:	01d7d79b          	srliw	a5,a5,0x1d
    80003220:	9fb9                	addw	a5,a5,a4
    80003222:	4037d79b          	sraiw	a5,a5,0x3
    80003226:	00f90633          	add	a2,s2,a5
    8000322a:	05864603          	lbu	a2,88(a2)
    8000322e:	00c6f5b3          	and	a1,a3,a2
    80003232:	d5a1                	beqz	a1,8000317a <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003234:	2705                	addiw	a4,a4,1
    80003236:	2485                	addiw	s1,s1,1
    80003238:	fd471ae3          	bne	a4,s4,8000320c <balloc+0xce>
    8000323c:	bf49                	j	800031ce <balloc+0x90>
    8000323e:	6906                	ld	s2,64(sp)
    80003240:	79e2                	ld	s3,56(sp)
    80003242:	7a42                	ld	s4,48(sp)
    80003244:	7aa2                	ld	s5,40(sp)
    80003246:	7b02                	ld	s6,32(sp)
    80003248:	6be2                	ld	s7,24(sp)
    8000324a:	6c42                	ld	s8,16(sp)
    8000324c:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    8000324e:	00004517          	auipc	a0,0x4
    80003252:	24250513          	addi	a0,a0,578 # 80007490 <etext+0x490>
    80003256:	a6cfd0ef          	jal	800004c2 <printf>
  return 0;
    8000325a:	4481                	li	s1,0
    8000325c:	b79d                	j	800031c2 <balloc+0x84>

000000008000325e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000325e:	7179                	addi	sp,sp,-48
    80003260:	f406                	sd	ra,40(sp)
    80003262:	f022                	sd	s0,32(sp)
    80003264:	ec26                	sd	s1,24(sp)
    80003266:	e84a                	sd	s2,16(sp)
    80003268:	e44e                	sd	s3,8(sp)
    8000326a:	1800                	addi	s0,sp,48
    8000326c:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000326e:	47ad                	li	a5,11
    80003270:	02b7e663          	bltu	a5,a1,8000329c <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80003274:	02059793          	slli	a5,a1,0x20
    80003278:	01e7d593          	srli	a1,a5,0x1e
    8000327c:	00b504b3          	add	s1,a0,a1
    80003280:	0504a903          	lw	s2,80(s1)
    80003284:	06091a63          	bnez	s2,800032f8 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003288:	4108                	lw	a0,0(a0)
    8000328a:	eb5ff0ef          	jal	8000313e <balloc>
    8000328e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003292:	06090363          	beqz	s2,800032f8 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003296:	0524a823          	sw	s2,80(s1)
    8000329a:	a8b9                	j	800032f8 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000329c:	ff45849b          	addiw	s1,a1,-12
    800032a0:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    800032a4:	0ff00793          	li	a5,255
    800032a8:	06e7ee63          	bltu	a5,a4,80003324 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800032ac:	08052903          	lw	s2,128(a0)
    800032b0:	00091d63          	bnez	s2,800032ca <bmap+0x6c>
      addr = balloc(ip->dev);
    800032b4:	4108                	lw	a0,0(a0)
    800032b6:	e89ff0ef          	jal	8000313e <balloc>
    800032ba:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800032be:	02090d63          	beqz	s2,800032f8 <bmap+0x9a>
    800032c2:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800032c4:	0929a023          	sw	s2,128(s3)
    800032c8:	a011                	j	800032cc <bmap+0x6e>
    800032ca:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800032cc:	85ca                	mv	a1,s2
    800032ce:	0009a503          	lw	a0,0(s3)
    800032d2:	c09ff0ef          	jal	80002eda <bread>
    800032d6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800032d8:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800032dc:	02049713          	slli	a4,s1,0x20
    800032e0:	01e75593          	srli	a1,a4,0x1e
    800032e4:	00b784b3          	add	s1,a5,a1
    800032e8:	0004a903          	lw	s2,0(s1)
    800032ec:	00090e63          	beqz	s2,80003308 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800032f0:	8552                	mv	a0,s4
    800032f2:	cf1ff0ef          	jal	80002fe2 <brelse>
    return addr;
    800032f6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800032f8:	854a                	mv	a0,s2
    800032fa:	70a2                	ld	ra,40(sp)
    800032fc:	7402                	ld	s0,32(sp)
    800032fe:	64e2                	ld	s1,24(sp)
    80003300:	6942                	ld	s2,16(sp)
    80003302:	69a2                	ld	s3,8(sp)
    80003304:	6145                	addi	sp,sp,48
    80003306:	8082                	ret
      addr = balloc(ip->dev);
    80003308:	0009a503          	lw	a0,0(s3)
    8000330c:	e33ff0ef          	jal	8000313e <balloc>
    80003310:	0005091b          	sext.w	s2,a0
      if(addr){
    80003314:	fc090ee3          	beqz	s2,800032f0 <bmap+0x92>
        a[bn] = addr;
    80003318:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    8000331c:	8552                	mv	a0,s4
    8000331e:	50f000ef          	jal	8000402c <log_write>
    80003322:	b7f9                	j	800032f0 <bmap+0x92>
    80003324:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003326:	00004517          	auipc	a0,0x4
    8000332a:	18250513          	addi	a0,a0,386 # 800074a8 <etext+0x4a8>
    8000332e:	c66fd0ef          	jal	80000794 <panic>

0000000080003332 <iget>:
{
    80003332:	7179                	addi	sp,sp,-48
    80003334:	f406                	sd	ra,40(sp)
    80003336:	f022                	sd	s0,32(sp)
    80003338:	ec26                	sd	s1,24(sp)
    8000333a:	e84a                	sd	s2,16(sp)
    8000333c:	e44e                	sd	s3,8(sp)
    8000333e:	e052                	sd	s4,0(sp)
    80003340:	1800                	addi	s0,sp,48
    80003342:	89aa                	mv	s3,a0
    80003344:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003346:	0001e517          	auipc	a0,0x1e
    8000334a:	07250513          	addi	a0,a0,114 # 800213b8 <itable>
    8000334e:	8a7fd0ef          	jal	80000bf4 <acquire>
  empty = 0;
    80003352:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003354:	0001e497          	auipc	s1,0x1e
    80003358:	07c48493          	addi	s1,s1,124 # 800213d0 <itable+0x18>
    8000335c:	00020697          	auipc	a3,0x20
    80003360:	b0468693          	addi	a3,a3,-1276 # 80022e60 <log>
    80003364:	a039                	j	80003372 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003366:	02090963          	beqz	s2,80003398 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000336a:	08848493          	addi	s1,s1,136
    8000336e:	02d48863          	beq	s1,a3,8000339e <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003372:	449c                	lw	a5,8(s1)
    80003374:	fef059e3          	blez	a5,80003366 <iget+0x34>
    80003378:	4098                	lw	a4,0(s1)
    8000337a:	ff3716e3          	bne	a4,s3,80003366 <iget+0x34>
    8000337e:	40d8                	lw	a4,4(s1)
    80003380:	ff4713e3          	bne	a4,s4,80003366 <iget+0x34>
      ip->ref++;
    80003384:	2785                	addiw	a5,a5,1
    80003386:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003388:	0001e517          	auipc	a0,0x1e
    8000338c:	03050513          	addi	a0,a0,48 # 800213b8 <itable>
    80003390:	8fdfd0ef          	jal	80000c8c <release>
      return ip;
    80003394:	8926                	mv	s2,s1
    80003396:	a02d                	j	800033c0 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003398:	fbe9                	bnez	a5,8000336a <iget+0x38>
      empty = ip;
    8000339a:	8926                	mv	s2,s1
    8000339c:	b7f9                	j	8000336a <iget+0x38>
  if(empty == 0)
    8000339e:	02090a63          	beqz	s2,800033d2 <iget+0xa0>
  ip->dev = dev;
    800033a2:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800033a6:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800033aa:	4785                	li	a5,1
    800033ac:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800033b0:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800033b4:	0001e517          	auipc	a0,0x1e
    800033b8:	00450513          	addi	a0,a0,4 # 800213b8 <itable>
    800033bc:	8d1fd0ef          	jal	80000c8c <release>
}
    800033c0:	854a                	mv	a0,s2
    800033c2:	70a2                	ld	ra,40(sp)
    800033c4:	7402                	ld	s0,32(sp)
    800033c6:	64e2                	ld	s1,24(sp)
    800033c8:	6942                	ld	s2,16(sp)
    800033ca:	69a2                	ld	s3,8(sp)
    800033cc:	6a02                	ld	s4,0(sp)
    800033ce:	6145                	addi	sp,sp,48
    800033d0:	8082                	ret
    panic("iget: no inodes");
    800033d2:	00004517          	auipc	a0,0x4
    800033d6:	0ee50513          	addi	a0,a0,238 # 800074c0 <etext+0x4c0>
    800033da:	bbafd0ef          	jal	80000794 <panic>

00000000800033de <fsinit>:
fsinit(int dev) {
    800033de:	7179                	addi	sp,sp,-48
    800033e0:	f406                	sd	ra,40(sp)
    800033e2:	f022                	sd	s0,32(sp)
    800033e4:	ec26                	sd	s1,24(sp)
    800033e6:	e84a                	sd	s2,16(sp)
    800033e8:	e44e                	sd	s3,8(sp)
    800033ea:	1800                	addi	s0,sp,48
    800033ec:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800033ee:	4585                	li	a1,1
    800033f0:	aebff0ef          	jal	80002eda <bread>
    800033f4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800033f6:	0001e997          	auipc	s3,0x1e
    800033fa:	fa298993          	addi	s3,s3,-94 # 80021398 <sb>
    800033fe:	02000613          	li	a2,32
    80003402:	05850593          	addi	a1,a0,88
    80003406:	854e                	mv	a0,s3
    80003408:	91dfd0ef          	jal	80000d24 <memmove>
  brelse(bp);
    8000340c:	8526                	mv	a0,s1
    8000340e:	bd5ff0ef          	jal	80002fe2 <brelse>
  if(sb.magic != FSMAGIC)
    80003412:	0009a703          	lw	a4,0(s3)
    80003416:	102037b7          	lui	a5,0x10203
    8000341a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000341e:	02f71063          	bne	a4,a5,8000343e <fsinit+0x60>
  initlog(dev, &sb);
    80003422:	0001e597          	auipc	a1,0x1e
    80003426:	f7658593          	addi	a1,a1,-138 # 80021398 <sb>
    8000342a:	854a                	mv	a0,s2
    8000342c:	1f9000ef          	jal	80003e24 <initlog>
}
    80003430:	70a2                	ld	ra,40(sp)
    80003432:	7402                	ld	s0,32(sp)
    80003434:	64e2                	ld	s1,24(sp)
    80003436:	6942                	ld	s2,16(sp)
    80003438:	69a2                	ld	s3,8(sp)
    8000343a:	6145                	addi	sp,sp,48
    8000343c:	8082                	ret
    panic("invalid file system");
    8000343e:	00004517          	auipc	a0,0x4
    80003442:	09250513          	addi	a0,a0,146 # 800074d0 <etext+0x4d0>
    80003446:	b4efd0ef          	jal	80000794 <panic>

000000008000344a <iinit>:
{
    8000344a:	7179                	addi	sp,sp,-48
    8000344c:	f406                	sd	ra,40(sp)
    8000344e:	f022                	sd	s0,32(sp)
    80003450:	ec26                	sd	s1,24(sp)
    80003452:	e84a                	sd	s2,16(sp)
    80003454:	e44e                	sd	s3,8(sp)
    80003456:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003458:	00004597          	auipc	a1,0x4
    8000345c:	09058593          	addi	a1,a1,144 # 800074e8 <etext+0x4e8>
    80003460:	0001e517          	auipc	a0,0x1e
    80003464:	f5850513          	addi	a0,a0,-168 # 800213b8 <itable>
    80003468:	f0cfd0ef          	jal	80000b74 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000346c:	0001e497          	auipc	s1,0x1e
    80003470:	f7448493          	addi	s1,s1,-140 # 800213e0 <itable+0x28>
    80003474:	00020997          	auipc	s3,0x20
    80003478:	9fc98993          	addi	s3,s3,-1540 # 80022e70 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000347c:	00004917          	auipc	s2,0x4
    80003480:	07490913          	addi	s2,s2,116 # 800074f0 <etext+0x4f0>
    80003484:	85ca                	mv	a1,s2
    80003486:	8526                	mv	a0,s1
    80003488:	475000ef          	jal	800040fc <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000348c:	08848493          	addi	s1,s1,136
    80003490:	ff349ae3          	bne	s1,s3,80003484 <iinit+0x3a>
}
    80003494:	70a2                	ld	ra,40(sp)
    80003496:	7402                	ld	s0,32(sp)
    80003498:	64e2                	ld	s1,24(sp)
    8000349a:	6942                	ld	s2,16(sp)
    8000349c:	69a2                	ld	s3,8(sp)
    8000349e:	6145                	addi	sp,sp,48
    800034a0:	8082                	ret

00000000800034a2 <ialloc>:
{
    800034a2:	7139                	addi	sp,sp,-64
    800034a4:	fc06                	sd	ra,56(sp)
    800034a6:	f822                	sd	s0,48(sp)
    800034a8:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800034aa:	0001e717          	auipc	a4,0x1e
    800034ae:	efa72703          	lw	a4,-262(a4) # 800213a4 <sb+0xc>
    800034b2:	4785                	li	a5,1
    800034b4:	06e7f063          	bgeu	a5,a4,80003514 <ialloc+0x72>
    800034b8:	f426                	sd	s1,40(sp)
    800034ba:	f04a                	sd	s2,32(sp)
    800034bc:	ec4e                	sd	s3,24(sp)
    800034be:	e852                	sd	s4,16(sp)
    800034c0:	e456                	sd	s5,8(sp)
    800034c2:	e05a                	sd	s6,0(sp)
    800034c4:	8aaa                	mv	s5,a0
    800034c6:	8b2e                	mv	s6,a1
    800034c8:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800034ca:	0001ea17          	auipc	s4,0x1e
    800034ce:	ecea0a13          	addi	s4,s4,-306 # 80021398 <sb>
    800034d2:	00495593          	srli	a1,s2,0x4
    800034d6:	018a2783          	lw	a5,24(s4)
    800034da:	9dbd                	addw	a1,a1,a5
    800034dc:	8556                	mv	a0,s5
    800034de:	9fdff0ef          	jal	80002eda <bread>
    800034e2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800034e4:	05850993          	addi	s3,a0,88
    800034e8:	00f97793          	andi	a5,s2,15
    800034ec:	079a                	slli	a5,a5,0x6
    800034ee:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800034f0:	00099783          	lh	a5,0(s3)
    800034f4:	cb9d                	beqz	a5,8000352a <ialloc+0x88>
    brelse(bp);
    800034f6:	aedff0ef          	jal	80002fe2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800034fa:	0905                	addi	s2,s2,1
    800034fc:	00ca2703          	lw	a4,12(s4)
    80003500:	0009079b          	sext.w	a5,s2
    80003504:	fce7e7e3          	bltu	a5,a4,800034d2 <ialloc+0x30>
    80003508:	74a2                	ld	s1,40(sp)
    8000350a:	7902                	ld	s2,32(sp)
    8000350c:	69e2                	ld	s3,24(sp)
    8000350e:	6a42                	ld	s4,16(sp)
    80003510:	6aa2                	ld	s5,8(sp)
    80003512:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003514:	00004517          	auipc	a0,0x4
    80003518:	fe450513          	addi	a0,a0,-28 # 800074f8 <etext+0x4f8>
    8000351c:	fa7fc0ef          	jal	800004c2 <printf>
  return 0;
    80003520:	4501                	li	a0,0
}
    80003522:	70e2                	ld	ra,56(sp)
    80003524:	7442                	ld	s0,48(sp)
    80003526:	6121                	addi	sp,sp,64
    80003528:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000352a:	04000613          	li	a2,64
    8000352e:	4581                	li	a1,0
    80003530:	854e                	mv	a0,s3
    80003532:	f96fd0ef          	jal	80000cc8 <memset>
      dip->type = type;
    80003536:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000353a:	8526                	mv	a0,s1
    8000353c:	2f1000ef          	jal	8000402c <log_write>
      brelse(bp);
    80003540:	8526                	mv	a0,s1
    80003542:	aa1ff0ef          	jal	80002fe2 <brelse>
      return iget(dev, inum);
    80003546:	0009059b          	sext.w	a1,s2
    8000354a:	8556                	mv	a0,s5
    8000354c:	de7ff0ef          	jal	80003332 <iget>
    80003550:	74a2                	ld	s1,40(sp)
    80003552:	7902                	ld	s2,32(sp)
    80003554:	69e2                	ld	s3,24(sp)
    80003556:	6a42                	ld	s4,16(sp)
    80003558:	6aa2                	ld	s5,8(sp)
    8000355a:	6b02                	ld	s6,0(sp)
    8000355c:	b7d9                	j	80003522 <ialloc+0x80>

000000008000355e <iupdate>:
{
    8000355e:	1101                	addi	sp,sp,-32
    80003560:	ec06                	sd	ra,24(sp)
    80003562:	e822                	sd	s0,16(sp)
    80003564:	e426                	sd	s1,8(sp)
    80003566:	e04a                	sd	s2,0(sp)
    80003568:	1000                	addi	s0,sp,32
    8000356a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000356c:	415c                	lw	a5,4(a0)
    8000356e:	0047d79b          	srliw	a5,a5,0x4
    80003572:	0001e597          	auipc	a1,0x1e
    80003576:	e3e5a583          	lw	a1,-450(a1) # 800213b0 <sb+0x18>
    8000357a:	9dbd                	addw	a1,a1,a5
    8000357c:	4108                	lw	a0,0(a0)
    8000357e:	95dff0ef          	jal	80002eda <bread>
    80003582:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003584:	05850793          	addi	a5,a0,88
    80003588:	40d8                	lw	a4,4(s1)
    8000358a:	8b3d                	andi	a4,a4,15
    8000358c:	071a                	slli	a4,a4,0x6
    8000358e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003590:	04449703          	lh	a4,68(s1)
    80003594:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003598:	04649703          	lh	a4,70(s1)
    8000359c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800035a0:	04849703          	lh	a4,72(s1)
    800035a4:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800035a8:	04a49703          	lh	a4,74(s1)
    800035ac:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800035b0:	44f8                	lw	a4,76(s1)
    800035b2:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800035b4:	03400613          	li	a2,52
    800035b8:	05048593          	addi	a1,s1,80
    800035bc:	00c78513          	addi	a0,a5,12
    800035c0:	f64fd0ef          	jal	80000d24 <memmove>
  log_write(bp);
    800035c4:	854a                	mv	a0,s2
    800035c6:	267000ef          	jal	8000402c <log_write>
  brelse(bp);
    800035ca:	854a                	mv	a0,s2
    800035cc:	a17ff0ef          	jal	80002fe2 <brelse>
}
    800035d0:	60e2                	ld	ra,24(sp)
    800035d2:	6442                	ld	s0,16(sp)
    800035d4:	64a2                	ld	s1,8(sp)
    800035d6:	6902                	ld	s2,0(sp)
    800035d8:	6105                	addi	sp,sp,32
    800035da:	8082                	ret

00000000800035dc <idup>:
{
    800035dc:	1101                	addi	sp,sp,-32
    800035de:	ec06                	sd	ra,24(sp)
    800035e0:	e822                	sd	s0,16(sp)
    800035e2:	e426                	sd	s1,8(sp)
    800035e4:	1000                	addi	s0,sp,32
    800035e6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800035e8:	0001e517          	auipc	a0,0x1e
    800035ec:	dd050513          	addi	a0,a0,-560 # 800213b8 <itable>
    800035f0:	e04fd0ef          	jal	80000bf4 <acquire>
  ip->ref++;
    800035f4:	449c                	lw	a5,8(s1)
    800035f6:	2785                	addiw	a5,a5,1
    800035f8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800035fa:	0001e517          	auipc	a0,0x1e
    800035fe:	dbe50513          	addi	a0,a0,-578 # 800213b8 <itable>
    80003602:	e8afd0ef          	jal	80000c8c <release>
}
    80003606:	8526                	mv	a0,s1
    80003608:	60e2                	ld	ra,24(sp)
    8000360a:	6442                	ld	s0,16(sp)
    8000360c:	64a2                	ld	s1,8(sp)
    8000360e:	6105                	addi	sp,sp,32
    80003610:	8082                	ret

0000000080003612 <ilock>:
{
    80003612:	1101                	addi	sp,sp,-32
    80003614:	ec06                	sd	ra,24(sp)
    80003616:	e822                	sd	s0,16(sp)
    80003618:	e426                	sd	s1,8(sp)
    8000361a:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000361c:	cd19                	beqz	a0,8000363a <ilock+0x28>
    8000361e:	84aa                	mv	s1,a0
    80003620:	451c                	lw	a5,8(a0)
    80003622:	00f05c63          	blez	a5,8000363a <ilock+0x28>
  acquiresleep(&ip->lock);
    80003626:	0541                	addi	a0,a0,16
    80003628:	30b000ef          	jal	80004132 <acquiresleep>
  if(ip->valid == 0){
    8000362c:	40bc                	lw	a5,64(s1)
    8000362e:	cf89                	beqz	a5,80003648 <ilock+0x36>
}
    80003630:	60e2                	ld	ra,24(sp)
    80003632:	6442                	ld	s0,16(sp)
    80003634:	64a2                	ld	s1,8(sp)
    80003636:	6105                	addi	sp,sp,32
    80003638:	8082                	ret
    8000363a:	e04a                	sd	s2,0(sp)
    panic("ilock");
    8000363c:	00004517          	auipc	a0,0x4
    80003640:	ed450513          	addi	a0,a0,-300 # 80007510 <etext+0x510>
    80003644:	950fd0ef          	jal	80000794 <panic>
    80003648:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000364a:	40dc                	lw	a5,4(s1)
    8000364c:	0047d79b          	srliw	a5,a5,0x4
    80003650:	0001e597          	auipc	a1,0x1e
    80003654:	d605a583          	lw	a1,-672(a1) # 800213b0 <sb+0x18>
    80003658:	9dbd                	addw	a1,a1,a5
    8000365a:	4088                	lw	a0,0(s1)
    8000365c:	87fff0ef          	jal	80002eda <bread>
    80003660:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003662:	05850593          	addi	a1,a0,88
    80003666:	40dc                	lw	a5,4(s1)
    80003668:	8bbd                	andi	a5,a5,15
    8000366a:	079a                	slli	a5,a5,0x6
    8000366c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000366e:	00059783          	lh	a5,0(a1)
    80003672:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003676:	00259783          	lh	a5,2(a1)
    8000367a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000367e:	00459783          	lh	a5,4(a1)
    80003682:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003686:	00659783          	lh	a5,6(a1)
    8000368a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000368e:	459c                	lw	a5,8(a1)
    80003690:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003692:	03400613          	li	a2,52
    80003696:	05b1                	addi	a1,a1,12
    80003698:	05048513          	addi	a0,s1,80
    8000369c:	e88fd0ef          	jal	80000d24 <memmove>
    brelse(bp);
    800036a0:	854a                	mv	a0,s2
    800036a2:	941ff0ef          	jal	80002fe2 <brelse>
    ip->valid = 1;
    800036a6:	4785                	li	a5,1
    800036a8:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800036aa:	04449783          	lh	a5,68(s1)
    800036ae:	c399                	beqz	a5,800036b4 <ilock+0xa2>
    800036b0:	6902                	ld	s2,0(sp)
    800036b2:	bfbd                	j	80003630 <ilock+0x1e>
      panic("ilock: no type");
    800036b4:	00004517          	auipc	a0,0x4
    800036b8:	e6450513          	addi	a0,a0,-412 # 80007518 <etext+0x518>
    800036bc:	8d8fd0ef          	jal	80000794 <panic>

00000000800036c0 <iunlock>:
{
    800036c0:	1101                	addi	sp,sp,-32
    800036c2:	ec06                	sd	ra,24(sp)
    800036c4:	e822                	sd	s0,16(sp)
    800036c6:	e426                	sd	s1,8(sp)
    800036c8:	e04a                	sd	s2,0(sp)
    800036ca:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800036cc:	c505                	beqz	a0,800036f4 <iunlock+0x34>
    800036ce:	84aa                	mv	s1,a0
    800036d0:	01050913          	addi	s2,a0,16
    800036d4:	854a                	mv	a0,s2
    800036d6:	2db000ef          	jal	800041b0 <holdingsleep>
    800036da:	cd09                	beqz	a0,800036f4 <iunlock+0x34>
    800036dc:	449c                	lw	a5,8(s1)
    800036de:	00f05b63          	blez	a5,800036f4 <iunlock+0x34>
  releasesleep(&ip->lock);
    800036e2:	854a                	mv	a0,s2
    800036e4:	295000ef          	jal	80004178 <releasesleep>
}
    800036e8:	60e2                	ld	ra,24(sp)
    800036ea:	6442                	ld	s0,16(sp)
    800036ec:	64a2                	ld	s1,8(sp)
    800036ee:	6902                	ld	s2,0(sp)
    800036f0:	6105                	addi	sp,sp,32
    800036f2:	8082                	ret
    panic("iunlock");
    800036f4:	00004517          	auipc	a0,0x4
    800036f8:	e3450513          	addi	a0,a0,-460 # 80007528 <etext+0x528>
    800036fc:	898fd0ef          	jal	80000794 <panic>

0000000080003700 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003700:	7179                	addi	sp,sp,-48
    80003702:	f406                	sd	ra,40(sp)
    80003704:	f022                	sd	s0,32(sp)
    80003706:	ec26                	sd	s1,24(sp)
    80003708:	e84a                	sd	s2,16(sp)
    8000370a:	e44e                	sd	s3,8(sp)
    8000370c:	1800                	addi	s0,sp,48
    8000370e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003710:	05050493          	addi	s1,a0,80
    80003714:	08050913          	addi	s2,a0,128
    80003718:	a021                	j	80003720 <itrunc+0x20>
    8000371a:	0491                	addi	s1,s1,4
    8000371c:	01248b63          	beq	s1,s2,80003732 <itrunc+0x32>
    if(ip->addrs[i]){
    80003720:	408c                	lw	a1,0(s1)
    80003722:	dde5                	beqz	a1,8000371a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003724:	0009a503          	lw	a0,0(s3)
    80003728:	9abff0ef          	jal	800030d2 <bfree>
      ip->addrs[i] = 0;
    8000372c:	0004a023          	sw	zero,0(s1)
    80003730:	b7ed                	j	8000371a <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003732:	0809a583          	lw	a1,128(s3)
    80003736:	ed89                	bnez	a1,80003750 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003738:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000373c:	854e                	mv	a0,s3
    8000373e:	e21ff0ef          	jal	8000355e <iupdate>
}
    80003742:	70a2                	ld	ra,40(sp)
    80003744:	7402                	ld	s0,32(sp)
    80003746:	64e2                	ld	s1,24(sp)
    80003748:	6942                	ld	s2,16(sp)
    8000374a:	69a2                	ld	s3,8(sp)
    8000374c:	6145                	addi	sp,sp,48
    8000374e:	8082                	ret
    80003750:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003752:	0009a503          	lw	a0,0(s3)
    80003756:	f84ff0ef          	jal	80002eda <bread>
    8000375a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000375c:	05850493          	addi	s1,a0,88
    80003760:	45850913          	addi	s2,a0,1112
    80003764:	a021                	j	8000376c <itrunc+0x6c>
    80003766:	0491                	addi	s1,s1,4
    80003768:	01248963          	beq	s1,s2,8000377a <itrunc+0x7a>
      if(a[j])
    8000376c:	408c                	lw	a1,0(s1)
    8000376e:	dde5                	beqz	a1,80003766 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003770:	0009a503          	lw	a0,0(s3)
    80003774:	95fff0ef          	jal	800030d2 <bfree>
    80003778:	b7fd                	j	80003766 <itrunc+0x66>
    brelse(bp);
    8000377a:	8552                	mv	a0,s4
    8000377c:	867ff0ef          	jal	80002fe2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003780:	0809a583          	lw	a1,128(s3)
    80003784:	0009a503          	lw	a0,0(s3)
    80003788:	94bff0ef          	jal	800030d2 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000378c:	0809a023          	sw	zero,128(s3)
    80003790:	6a02                	ld	s4,0(sp)
    80003792:	b75d                	j	80003738 <itrunc+0x38>

0000000080003794 <iput>:
{
    80003794:	1101                	addi	sp,sp,-32
    80003796:	ec06                	sd	ra,24(sp)
    80003798:	e822                	sd	s0,16(sp)
    8000379a:	e426                	sd	s1,8(sp)
    8000379c:	1000                	addi	s0,sp,32
    8000379e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800037a0:	0001e517          	auipc	a0,0x1e
    800037a4:	c1850513          	addi	a0,a0,-1000 # 800213b8 <itable>
    800037a8:	c4cfd0ef          	jal	80000bf4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037ac:	4498                	lw	a4,8(s1)
    800037ae:	4785                	li	a5,1
    800037b0:	02f70063          	beq	a4,a5,800037d0 <iput+0x3c>
  ip->ref--;
    800037b4:	449c                	lw	a5,8(s1)
    800037b6:	37fd                	addiw	a5,a5,-1
    800037b8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800037ba:	0001e517          	auipc	a0,0x1e
    800037be:	bfe50513          	addi	a0,a0,-1026 # 800213b8 <itable>
    800037c2:	ccafd0ef          	jal	80000c8c <release>
}
    800037c6:	60e2                	ld	ra,24(sp)
    800037c8:	6442                	ld	s0,16(sp)
    800037ca:	64a2                	ld	s1,8(sp)
    800037cc:	6105                	addi	sp,sp,32
    800037ce:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800037d0:	40bc                	lw	a5,64(s1)
    800037d2:	d3ed                	beqz	a5,800037b4 <iput+0x20>
    800037d4:	04a49783          	lh	a5,74(s1)
    800037d8:	fff1                	bnez	a5,800037b4 <iput+0x20>
    800037da:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800037dc:	01048913          	addi	s2,s1,16
    800037e0:	854a                	mv	a0,s2
    800037e2:	151000ef          	jal	80004132 <acquiresleep>
    release(&itable.lock);
    800037e6:	0001e517          	auipc	a0,0x1e
    800037ea:	bd250513          	addi	a0,a0,-1070 # 800213b8 <itable>
    800037ee:	c9efd0ef          	jal	80000c8c <release>
    itrunc(ip);
    800037f2:	8526                	mv	a0,s1
    800037f4:	f0dff0ef          	jal	80003700 <itrunc>
    ip->type = 0;
    800037f8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800037fc:	8526                	mv	a0,s1
    800037fe:	d61ff0ef          	jal	8000355e <iupdate>
    ip->valid = 0;
    80003802:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003806:	854a                	mv	a0,s2
    80003808:	171000ef          	jal	80004178 <releasesleep>
    acquire(&itable.lock);
    8000380c:	0001e517          	auipc	a0,0x1e
    80003810:	bac50513          	addi	a0,a0,-1108 # 800213b8 <itable>
    80003814:	be0fd0ef          	jal	80000bf4 <acquire>
    80003818:	6902                	ld	s2,0(sp)
    8000381a:	bf69                	j	800037b4 <iput+0x20>

000000008000381c <iunlockput>:
{
    8000381c:	1101                	addi	sp,sp,-32
    8000381e:	ec06                	sd	ra,24(sp)
    80003820:	e822                	sd	s0,16(sp)
    80003822:	e426                	sd	s1,8(sp)
    80003824:	1000                	addi	s0,sp,32
    80003826:	84aa                	mv	s1,a0
  iunlock(ip);
    80003828:	e99ff0ef          	jal	800036c0 <iunlock>
  iput(ip);
    8000382c:	8526                	mv	a0,s1
    8000382e:	f67ff0ef          	jal	80003794 <iput>
}
    80003832:	60e2                	ld	ra,24(sp)
    80003834:	6442                	ld	s0,16(sp)
    80003836:	64a2                	ld	s1,8(sp)
    80003838:	6105                	addi	sp,sp,32
    8000383a:	8082                	ret

000000008000383c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000383c:	1141                	addi	sp,sp,-16
    8000383e:	e422                	sd	s0,8(sp)
    80003840:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003842:	411c                	lw	a5,0(a0)
    80003844:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003846:	415c                	lw	a5,4(a0)
    80003848:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000384a:	04451783          	lh	a5,68(a0)
    8000384e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003852:	04a51783          	lh	a5,74(a0)
    80003856:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000385a:	04c56783          	lwu	a5,76(a0)
    8000385e:	e99c                	sd	a5,16(a1)
}
    80003860:	6422                	ld	s0,8(sp)
    80003862:	0141                	addi	sp,sp,16
    80003864:	8082                	ret

0000000080003866 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003866:	457c                	lw	a5,76(a0)
    80003868:	0ed7eb63          	bltu	a5,a3,8000395e <readi+0xf8>
{
    8000386c:	7159                	addi	sp,sp,-112
    8000386e:	f486                	sd	ra,104(sp)
    80003870:	f0a2                	sd	s0,96(sp)
    80003872:	eca6                	sd	s1,88(sp)
    80003874:	e0d2                	sd	s4,64(sp)
    80003876:	fc56                	sd	s5,56(sp)
    80003878:	f85a                	sd	s6,48(sp)
    8000387a:	f45e                	sd	s7,40(sp)
    8000387c:	1880                	addi	s0,sp,112
    8000387e:	8b2a                	mv	s6,a0
    80003880:	8bae                	mv	s7,a1
    80003882:	8a32                	mv	s4,a2
    80003884:	84b6                	mv	s1,a3
    80003886:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003888:	9f35                	addw	a4,a4,a3
    return 0;
    8000388a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000388c:	0cd76063          	bltu	a4,a3,8000394c <readi+0xe6>
    80003890:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003892:	00e7f463          	bgeu	a5,a4,8000389a <readi+0x34>
    n = ip->size - off;
    80003896:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000389a:	080a8f63          	beqz	s5,80003938 <readi+0xd2>
    8000389e:	e8ca                	sd	s2,80(sp)
    800038a0:	f062                	sd	s8,32(sp)
    800038a2:	ec66                	sd	s9,24(sp)
    800038a4:	e86a                	sd	s10,16(sp)
    800038a6:	e46e                	sd	s11,8(sp)
    800038a8:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800038aa:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800038ae:	5c7d                	li	s8,-1
    800038b0:	a80d                	j	800038e2 <readi+0x7c>
    800038b2:	020d1d93          	slli	s11,s10,0x20
    800038b6:	020ddd93          	srli	s11,s11,0x20
    800038ba:	05890613          	addi	a2,s2,88
    800038be:	86ee                	mv	a3,s11
    800038c0:	963a                	add	a2,a2,a4
    800038c2:	85d2                	mv	a1,s4
    800038c4:	855e                	mv	a0,s7
    800038c6:	a79fe0ef          	jal	8000233e <either_copyout>
    800038ca:	05850763          	beq	a0,s8,80003918 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800038ce:	854a                	mv	a0,s2
    800038d0:	f12ff0ef          	jal	80002fe2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038d4:	013d09bb          	addw	s3,s10,s3
    800038d8:	009d04bb          	addw	s1,s10,s1
    800038dc:	9a6e                	add	s4,s4,s11
    800038de:	0559f763          	bgeu	s3,s5,8000392c <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    800038e2:	00a4d59b          	srliw	a1,s1,0xa
    800038e6:	855a                	mv	a0,s6
    800038e8:	977ff0ef          	jal	8000325e <bmap>
    800038ec:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800038f0:	c5b1                	beqz	a1,8000393c <readi+0xd6>
    bp = bread(ip->dev, addr);
    800038f2:	000b2503          	lw	a0,0(s6)
    800038f6:	de4ff0ef          	jal	80002eda <bread>
    800038fa:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800038fc:	3ff4f713          	andi	a4,s1,1023
    80003900:	40ec87bb          	subw	a5,s9,a4
    80003904:	413a86bb          	subw	a3,s5,s3
    80003908:	8d3e                	mv	s10,a5
    8000390a:	2781                	sext.w	a5,a5
    8000390c:	0006861b          	sext.w	a2,a3
    80003910:	faf671e3          	bgeu	a2,a5,800038b2 <readi+0x4c>
    80003914:	8d36                	mv	s10,a3
    80003916:	bf71                	j	800038b2 <readi+0x4c>
      brelse(bp);
    80003918:	854a                	mv	a0,s2
    8000391a:	ec8ff0ef          	jal	80002fe2 <brelse>
      tot = -1;
    8000391e:	59fd                	li	s3,-1
      break;
    80003920:	6946                	ld	s2,80(sp)
    80003922:	7c02                	ld	s8,32(sp)
    80003924:	6ce2                	ld	s9,24(sp)
    80003926:	6d42                	ld	s10,16(sp)
    80003928:	6da2                	ld	s11,8(sp)
    8000392a:	a831                	j	80003946 <readi+0xe0>
    8000392c:	6946                	ld	s2,80(sp)
    8000392e:	7c02                	ld	s8,32(sp)
    80003930:	6ce2                	ld	s9,24(sp)
    80003932:	6d42                	ld	s10,16(sp)
    80003934:	6da2                	ld	s11,8(sp)
    80003936:	a801                	j	80003946 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003938:	89d6                	mv	s3,s5
    8000393a:	a031                	j	80003946 <readi+0xe0>
    8000393c:	6946                	ld	s2,80(sp)
    8000393e:	7c02                	ld	s8,32(sp)
    80003940:	6ce2                	ld	s9,24(sp)
    80003942:	6d42                	ld	s10,16(sp)
    80003944:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003946:	0009851b          	sext.w	a0,s3
    8000394a:	69a6                	ld	s3,72(sp)
}
    8000394c:	70a6                	ld	ra,104(sp)
    8000394e:	7406                	ld	s0,96(sp)
    80003950:	64e6                	ld	s1,88(sp)
    80003952:	6a06                	ld	s4,64(sp)
    80003954:	7ae2                	ld	s5,56(sp)
    80003956:	7b42                	ld	s6,48(sp)
    80003958:	7ba2                	ld	s7,40(sp)
    8000395a:	6165                	addi	sp,sp,112
    8000395c:	8082                	ret
    return 0;
    8000395e:	4501                	li	a0,0
}
    80003960:	8082                	ret

0000000080003962 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003962:	457c                	lw	a5,76(a0)
    80003964:	10d7e063          	bltu	a5,a3,80003a64 <writei+0x102>
{
    80003968:	7159                	addi	sp,sp,-112
    8000396a:	f486                	sd	ra,104(sp)
    8000396c:	f0a2                	sd	s0,96(sp)
    8000396e:	e8ca                	sd	s2,80(sp)
    80003970:	e0d2                	sd	s4,64(sp)
    80003972:	fc56                	sd	s5,56(sp)
    80003974:	f85a                	sd	s6,48(sp)
    80003976:	f45e                	sd	s7,40(sp)
    80003978:	1880                	addi	s0,sp,112
    8000397a:	8aaa                	mv	s5,a0
    8000397c:	8bae                	mv	s7,a1
    8000397e:	8a32                	mv	s4,a2
    80003980:	8936                	mv	s2,a3
    80003982:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003984:	00e687bb          	addw	a5,a3,a4
    80003988:	0ed7e063          	bltu	a5,a3,80003a68 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000398c:	00043737          	lui	a4,0x43
    80003990:	0cf76e63          	bltu	a4,a5,80003a6c <writei+0x10a>
    80003994:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003996:	0a0b0f63          	beqz	s6,80003a54 <writei+0xf2>
    8000399a:	eca6                	sd	s1,88(sp)
    8000399c:	f062                	sd	s8,32(sp)
    8000399e:	ec66                	sd	s9,24(sp)
    800039a0:	e86a                	sd	s10,16(sp)
    800039a2:	e46e                	sd	s11,8(sp)
    800039a4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800039a6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800039aa:	5c7d                	li	s8,-1
    800039ac:	a825                	j	800039e4 <writei+0x82>
    800039ae:	020d1d93          	slli	s11,s10,0x20
    800039b2:	020ddd93          	srli	s11,s11,0x20
    800039b6:	05848513          	addi	a0,s1,88
    800039ba:	86ee                	mv	a3,s11
    800039bc:	8652                	mv	a2,s4
    800039be:	85de                	mv	a1,s7
    800039c0:	953a                	add	a0,a0,a4
    800039c2:	9c7fe0ef          	jal	80002388 <either_copyin>
    800039c6:	05850a63          	beq	a0,s8,80003a1a <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    800039ca:	8526                	mv	a0,s1
    800039cc:	660000ef          	jal	8000402c <log_write>
    brelse(bp);
    800039d0:	8526                	mv	a0,s1
    800039d2:	e10ff0ef          	jal	80002fe2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039d6:	013d09bb          	addw	s3,s10,s3
    800039da:	012d093b          	addw	s2,s10,s2
    800039de:	9a6e                	add	s4,s4,s11
    800039e0:	0569f063          	bgeu	s3,s6,80003a20 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800039e4:	00a9559b          	srliw	a1,s2,0xa
    800039e8:	8556                	mv	a0,s5
    800039ea:	875ff0ef          	jal	8000325e <bmap>
    800039ee:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    800039f2:	c59d                	beqz	a1,80003a20 <writei+0xbe>
    bp = bread(ip->dev, addr);
    800039f4:	000aa503          	lw	a0,0(s5)
    800039f8:	ce2ff0ef          	jal	80002eda <bread>
    800039fc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800039fe:	3ff97713          	andi	a4,s2,1023
    80003a02:	40ec87bb          	subw	a5,s9,a4
    80003a06:	413b06bb          	subw	a3,s6,s3
    80003a0a:	8d3e                	mv	s10,a5
    80003a0c:	2781                	sext.w	a5,a5
    80003a0e:	0006861b          	sext.w	a2,a3
    80003a12:	f8f67ee3          	bgeu	a2,a5,800039ae <writei+0x4c>
    80003a16:	8d36                	mv	s10,a3
    80003a18:	bf59                	j	800039ae <writei+0x4c>
      brelse(bp);
    80003a1a:	8526                	mv	a0,s1
    80003a1c:	dc6ff0ef          	jal	80002fe2 <brelse>
  }

  if(off > ip->size)
    80003a20:	04caa783          	lw	a5,76(s5)
    80003a24:	0327fa63          	bgeu	a5,s2,80003a58 <writei+0xf6>
    ip->size = off;
    80003a28:	052aa623          	sw	s2,76(s5)
    80003a2c:	64e6                	ld	s1,88(sp)
    80003a2e:	7c02                	ld	s8,32(sp)
    80003a30:	6ce2                	ld	s9,24(sp)
    80003a32:	6d42                	ld	s10,16(sp)
    80003a34:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003a36:	8556                	mv	a0,s5
    80003a38:	b27ff0ef          	jal	8000355e <iupdate>

  return tot;
    80003a3c:	0009851b          	sext.w	a0,s3
    80003a40:	69a6                	ld	s3,72(sp)
}
    80003a42:	70a6                	ld	ra,104(sp)
    80003a44:	7406                	ld	s0,96(sp)
    80003a46:	6946                	ld	s2,80(sp)
    80003a48:	6a06                	ld	s4,64(sp)
    80003a4a:	7ae2                	ld	s5,56(sp)
    80003a4c:	7b42                	ld	s6,48(sp)
    80003a4e:	7ba2                	ld	s7,40(sp)
    80003a50:	6165                	addi	sp,sp,112
    80003a52:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003a54:	89da                	mv	s3,s6
    80003a56:	b7c5                	j	80003a36 <writei+0xd4>
    80003a58:	64e6                	ld	s1,88(sp)
    80003a5a:	7c02                	ld	s8,32(sp)
    80003a5c:	6ce2                	ld	s9,24(sp)
    80003a5e:	6d42                	ld	s10,16(sp)
    80003a60:	6da2                	ld	s11,8(sp)
    80003a62:	bfd1                	j	80003a36 <writei+0xd4>
    return -1;
    80003a64:	557d                	li	a0,-1
}
    80003a66:	8082                	ret
    return -1;
    80003a68:	557d                	li	a0,-1
    80003a6a:	bfe1                	j	80003a42 <writei+0xe0>
    return -1;
    80003a6c:	557d                	li	a0,-1
    80003a6e:	bfd1                	j	80003a42 <writei+0xe0>

0000000080003a70 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003a70:	1141                	addi	sp,sp,-16
    80003a72:	e406                	sd	ra,8(sp)
    80003a74:	e022                	sd	s0,0(sp)
    80003a76:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003a78:	4639                	li	a2,14
    80003a7a:	b1afd0ef          	jal	80000d94 <strncmp>
}
    80003a7e:	60a2                	ld	ra,8(sp)
    80003a80:	6402                	ld	s0,0(sp)
    80003a82:	0141                	addi	sp,sp,16
    80003a84:	8082                	ret

0000000080003a86 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003a86:	7139                	addi	sp,sp,-64
    80003a88:	fc06                	sd	ra,56(sp)
    80003a8a:	f822                	sd	s0,48(sp)
    80003a8c:	f426                	sd	s1,40(sp)
    80003a8e:	f04a                	sd	s2,32(sp)
    80003a90:	ec4e                	sd	s3,24(sp)
    80003a92:	e852                	sd	s4,16(sp)
    80003a94:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003a96:	04451703          	lh	a4,68(a0)
    80003a9a:	4785                	li	a5,1
    80003a9c:	00f71a63          	bne	a4,a5,80003ab0 <dirlookup+0x2a>
    80003aa0:	892a                	mv	s2,a0
    80003aa2:	89ae                	mv	s3,a1
    80003aa4:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003aa6:	457c                	lw	a5,76(a0)
    80003aa8:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003aaa:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003aac:	e39d                	bnez	a5,80003ad2 <dirlookup+0x4c>
    80003aae:	a095                	j	80003b12 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003ab0:	00004517          	auipc	a0,0x4
    80003ab4:	a8050513          	addi	a0,a0,-1408 # 80007530 <etext+0x530>
    80003ab8:	cddfc0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    80003abc:	00004517          	auipc	a0,0x4
    80003ac0:	a8c50513          	addi	a0,a0,-1396 # 80007548 <etext+0x548>
    80003ac4:	cd1fc0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003ac8:	24c1                	addiw	s1,s1,16
    80003aca:	04c92783          	lw	a5,76(s2)
    80003ace:	04f4f163          	bgeu	s1,a5,80003b10 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ad2:	4741                	li	a4,16
    80003ad4:	86a6                	mv	a3,s1
    80003ad6:	fc040613          	addi	a2,s0,-64
    80003ada:	4581                	li	a1,0
    80003adc:	854a                	mv	a0,s2
    80003ade:	d89ff0ef          	jal	80003866 <readi>
    80003ae2:	47c1                	li	a5,16
    80003ae4:	fcf51ce3          	bne	a0,a5,80003abc <dirlookup+0x36>
    if(de.inum == 0)
    80003ae8:	fc045783          	lhu	a5,-64(s0)
    80003aec:	dff1                	beqz	a5,80003ac8 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003aee:	fc240593          	addi	a1,s0,-62
    80003af2:	854e                	mv	a0,s3
    80003af4:	f7dff0ef          	jal	80003a70 <namecmp>
    80003af8:	f961                	bnez	a0,80003ac8 <dirlookup+0x42>
      if(poff)
    80003afa:	000a0463          	beqz	s4,80003b02 <dirlookup+0x7c>
        *poff = off;
    80003afe:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003b02:	fc045583          	lhu	a1,-64(s0)
    80003b06:	00092503          	lw	a0,0(s2)
    80003b0a:	829ff0ef          	jal	80003332 <iget>
    80003b0e:	a011                	j	80003b12 <dirlookup+0x8c>
  return 0;
    80003b10:	4501                	li	a0,0
}
    80003b12:	70e2                	ld	ra,56(sp)
    80003b14:	7442                	ld	s0,48(sp)
    80003b16:	74a2                	ld	s1,40(sp)
    80003b18:	7902                	ld	s2,32(sp)
    80003b1a:	69e2                	ld	s3,24(sp)
    80003b1c:	6a42                	ld	s4,16(sp)
    80003b1e:	6121                	addi	sp,sp,64
    80003b20:	8082                	ret

0000000080003b22 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003b22:	711d                	addi	sp,sp,-96
    80003b24:	ec86                	sd	ra,88(sp)
    80003b26:	e8a2                	sd	s0,80(sp)
    80003b28:	e4a6                	sd	s1,72(sp)
    80003b2a:	e0ca                	sd	s2,64(sp)
    80003b2c:	fc4e                	sd	s3,56(sp)
    80003b2e:	f852                	sd	s4,48(sp)
    80003b30:	f456                	sd	s5,40(sp)
    80003b32:	f05a                	sd	s6,32(sp)
    80003b34:	ec5e                	sd	s7,24(sp)
    80003b36:	e862                	sd	s8,16(sp)
    80003b38:	e466                	sd	s9,8(sp)
    80003b3a:	1080                	addi	s0,sp,96
    80003b3c:	84aa                	mv	s1,a0
    80003b3e:	8b2e                	mv	s6,a1
    80003b40:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003b42:	00054703          	lbu	a4,0(a0)
    80003b46:	02f00793          	li	a5,47
    80003b4a:	00f70e63          	beq	a4,a5,80003b66 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003b4e:	dc9fd0ef          	jal	80001916 <myproc>
    80003b52:	15853503          	ld	a0,344(a0)
    80003b56:	a87ff0ef          	jal	800035dc <idup>
    80003b5a:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003b5c:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003b60:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003b62:	4b85                	li	s7,1
    80003b64:	a871                	j	80003c00 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003b66:	4585                	li	a1,1
    80003b68:	4505                	li	a0,1
    80003b6a:	fc8ff0ef          	jal	80003332 <iget>
    80003b6e:	8a2a                	mv	s4,a0
    80003b70:	b7f5                	j	80003b5c <namex+0x3a>
      iunlockput(ip);
    80003b72:	8552                	mv	a0,s4
    80003b74:	ca9ff0ef          	jal	8000381c <iunlockput>
      return 0;
    80003b78:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003b7a:	8552                	mv	a0,s4
    80003b7c:	60e6                	ld	ra,88(sp)
    80003b7e:	6446                	ld	s0,80(sp)
    80003b80:	64a6                	ld	s1,72(sp)
    80003b82:	6906                	ld	s2,64(sp)
    80003b84:	79e2                	ld	s3,56(sp)
    80003b86:	7a42                	ld	s4,48(sp)
    80003b88:	7aa2                	ld	s5,40(sp)
    80003b8a:	7b02                	ld	s6,32(sp)
    80003b8c:	6be2                	ld	s7,24(sp)
    80003b8e:	6c42                	ld	s8,16(sp)
    80003b90:	6ca2                	ld	s9,8(sp)
    80003b92:	6125                	addi	sp,sp,96
    80003b94:	8082                	ret
      iunlock(ip);
    80003b96:	8552                	mv	a0,s4
    80003b98:	b29ff0ef          	jal	800036c0 <iunlock>
      return ip;
    80003b9c:	bff9                	j	80003b7a <namex+0x58>
      iunlockput(ip);
    80003b9e:	8552                	mv	a0,s4
    80003ba0:	c7dff0ef          	jal	8000381c <iunlockput>
      return 0;
    80003ba4:	8a4e                	mv	s4,s3
    80003ba6:	bfd1                	j	80003b7a <namex+0x58>
  len = path - s;
    80003ba8:	40998633          	sub	a2,s3,s1
    80003bac:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003bb0:	099c5063          	bge	s8,s9,80003c30 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003bb4:	4639                	li	a2,14
    80003bb6:	85a6                	mv	a1,s1
    80003bb8:	8556                	mv	a0,s5
    80003bba:	96afd0ef          	jal	80000d24 <memmove>
    80003bbe:	84ce                	mv	s1,s3
  while(*path == '/')
    80003bc0:	0004c783          	lbu	a5,0(s1)
    80003bc4:	01279763          	bne	a5,s2,80003bd2 <namex+0xb0>
    path++;
    80003bc8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003bca:	0004c783          	lbu	a5,0(s1)
    80003bce:	ff278de3          	beq	a5,s2,80003bc8 <namex+0xa6>
    ilock(ip);
    80003bd2:	8552                	mv	a0,s4
    80003bd4:	a3fff0ef          	jal	80003612 <ilock>
    if(ip->type != T_DIR){
    80003bd8:	044a1783          	lh	a5,68(s4)
    80003bdc:	f9779be3          	bne	a5,s7,80003b72 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003be0:	000b0563          	beqz	s6,80003bea <namex+0xc8>
    80003be4:	0004c783          	lbu	a5,0(s1)
    80003be8:	d7dd                	beqz	a5,80003b96 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003bea:	4601                	li	a2,0
    80003bec:	85d6                	mv	a1,s5
    80003bee:	8552                	mv	a0,s4
    80003bf0:	e97ff0ef          	jal	80003a86 <dirlookup>
    80003bf4:	89aa                	mv	s3,a0
    80003bf6:	d545                	beqz	a0,80003b9e <namex+0x7c>
    iunlockput(ip);
    80003bf8:	8552                	mv	a0,s4
    80003bfa:	c23ff0ef          	jal	8000381c <iunlockput>
    ip = next;
    80003bfe:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003c00:	0004c783          	lbu	a5,0(s1)
    80003c04:	01279763          	bne	a5,s2,80003c12 <namex+0xf0>
    path++;
    80003c08:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003c0a:	0004c783          	lbu	a5,0(s1)
    80003c0e:	ff278de3          	beq	a5,s2,80003c08 <namex+0xe6>
  if(*path == 0)
    80003c12:	cb8d                	beqz	a5,80003c44 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003c14:	0004c783          	lbu	a5,0(s1)
    80003c18:	89a6                	mv	s3,s1
  len = path - s;
    80003c1a:	4c81                	li	s9,0
    80003c1c:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003c1e:	01278963          	beq	a5,s2,80003c30 <namex+0x10e>
    80003c22:	d3d9                	beqz	a5,80003ba8 <namex+0x86>
    path++;
    80003c24:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003c26:	0009c783          	lbu	a5,0(s3)
    80003c2a:	ff279ce3          	bne	a5,s2,80003c22 <namex+0x100>
    80003c2e:	bfad                	j	80003ba8 <namex+0x86>
    memmove(name, s, len);
    80003c30:	2601                	sext.w	a2,a2
    80003c32:	85a6                	mv	a1,s1
    80003c34:	8556                	mv	a0,s5
    80003c36:	8eefd0ef          	jal	80000d24 <memmove>
    name[len] = 0;
    80003c3a:	9cd6                	add	s9,s9,s5
    80003c3c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003c40:	84ce                	mv	s1,s3
    80003c42:	bfbd                	j	80003bc0 <namex+0x9e>
  if(nameiparent){
    80003c44:	f20b0be3          	beqz	s6,80003b7a <namex+0x58>
    iput(ip);
    80003c48:	8552                	mv	a0,s4
    80003c4a:	b4bff0ef          	jal	80003794 <iput>
    return 0;
    80003c4e:	4a01                	li	s4,0
    80003c50:	b72d                	j	80003b7a <namex+0x58>

0000000080003c52 <dirlink>:
{
    80003c52:	7139                	addi	sp,sp,-64
    80003c54:	fc06                	sd	ra,56(sp)
    80003c56:	f822                	sd	s0,48(sp)
    80003c58:	f04a                	sd	s2,32(sp)
    80003c5a:	ec4e                	sd	s3,24(sp)
    80003c5c:	e852                	sd	s4,16(sp)
    80003c5e:	0080                	addi	s0,sp,64
    80003c60:	892a                	mv	s2,a0
    80003c62:	8a2e                	mv	s4,a1
    80003c64:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003c66:	4601                	li	a2,0
    80003c68:	e1fff0ef          	jal	80003a86 <dirlookup>
    80003c6c:	e535                	bnez	a0,80003cd8 <dirlink+0x86>
    80003c6e:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c70:	04c92483          	lw	s1,76(s2)
    80003c74:	c48d                	beqz	s1,80003c9e <dirlink+0x4c>
    80003c76:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c78:	4741                	li	a4,16
    80003c7a:	86a6                	mv	a3,s1
    80003c7c:	fc040613          	addi	a2,s0,-64
    80003c80:	4581                	li	a1,0
    80003c82:	854a                	mv	a0,s2
    80003c84:	be3ff0ef          	jal	80003866 <readi>
    80003c88:	47c1                	li	a5,16
    80003c8a:	04f51b63          	bne	a0,a5,80003ce0 <dirlink+0x8e>
    if(de.inum == 0)
    80003c8e:	fc045783          	lhu	a5,-64(s0)
    80003c92:	c791                	beqz	a5,80003c9e <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c94:	24c1                	addiw	s1,s1,16
    80003c96:	04c92783          	lw	a5,76(s2)
    80003c9a:	fcf4efe3          	bltu	s1,a5,80003c78 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003c9e:	4639                	li	a2,14
    80003ca0:	85d2                	mv	a1,s4
    80003ca2:	fc240513          	addi	a0,s0,-62
    80003ca6:	924fd0ef          	jal	80000dca <strncpy>
  de.inum = inum;
    80003caa:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003cae:	4741                	li	a4,16
    80003cb0:	86a6                	mv	a3,s1
    80003cb2:	fc040613          	addi	a2,s0,-64
    80003cb6:	4581                	li	a1,0
    80003cb8:	854a                	mv	a0,s2
    80003cba:	ca9ff0ef          	jal	80003962 <writei>
    80003cbe:	1541                	addi	a0,a0,-16
    80003cc0:	00a03533          	snez	a0,a0
    80003cc4:	40a00533          	neg	a0,a0
    80003cc8:	74a2                	ld	s1,40(sp)
}
    80003cca:	70e2                	ld	ra,56(sp)
    80003ccc:	7442                	ld	s0,48(sp)
    80003cce:	7902                	ld	s2,32(sp)
    80003cd0:	69e2                	ld	s3,24(sp)
    80003cd2:	6a42                	ld	s4,16(sp)
    80003cd4:	6121                	addi	sp,sp,64
    80003cd6:	8082                	ret
    iput(ip);
    80003cd8:	abdff0ef          	jal	80003794 <iput>
    return -1;
    80003cdc:	557d                	li	a0,-1
    80003cde:	b7f5                	j	80003cca <dirlink+0x78>
      panic("dirlink read");
    80003ce0:	00004517          	auipc	a0,0x4
    80003ce4:	87850513          	addi	a0,a0,-1928 # 80007558 <etext+0x558>
    80003ce8:	aadfc0ef          	jal	80000794 <panic>

0000000080003cec <namei>:

struct inode*
namei(char *path)
{
    80003cec:	1101                	addi	sp,sp,-32
    80003cee:	ec06                	sd	ra,24(sp)
    80003cf0:	e822                	sd	s0,16(sp)
    80003cf2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003cf4:	fe040613          	addi	a2,s0,-32
    80003cf8:	4581                	li	a1,0
    80003cfa:	e29ff0ef          	jal	80003b22 <namex>
}
    80003cfe:	60e2                	ld	ra,24(sp)
    80003d00:	6442                	ld	s0,16(sp)
    80003d02:	6105                	addi	sp,sp,32
    80003d04:	8082                	ret

0000000080003d06 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003d06:	1141                	addi	sp,sp,-16
    80003d08:	e406                	sd	ra,8(sp)
    80003d0a:	e022                	sd	s0,0(sp)
    80003d0c:	0800                	addi	s0,sp,16
    80003d0e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003d10:	4585                	li	a1,1
    80003d12:	e11ff0ef          	jal	80003b22 <namex>
}
    80003d16:	60a2                	ld	ra,8(sp)
    80003d18:	6402                	ld	s0,0(sp)
    80003d1a:	0141                	addi	sp,sp,16
    80003d1c:	8082                	ret

0000000080003d1e <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003d1e:	1101                	addi	sp,sp,-32
    80003d20:	ec06                	sd	ra,24(sp)
    80003d22:	e822                	sd	s0,16(sp)
    80003d24:	e426                	sd	s1,8(sp)
    80003d26:	e04a                	sd	s2,0(sp)
    80003d28:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003d2a:	0001f917          	auipc	s2,0x1f
    80003d2e:	13690913          	addi	s2,s2,310 # 80022e60 <log>
    80003d32:	01892583          	lw	a1,24(s2)
    80003d36:	02892503          	lw	a0,40(s2)
    80003d3a:	9a0ff0ef          	jal	80002eda <bread>
    80003d3e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003d40:	02c92603          	lw	a2,44(s2)
    80003d44:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003d46:	00c05f63          	blez	a2,80003d64 <write_head+0x46>
    80003d4a:	0001f717          	auipc	a4,0x1f
    80003d4e:	14670713          	addi	a4,a4,326 # 80022e90 <log+0x30>
    80003d52:	87aa                	mv	a5,a0
    80003d54:	060a                	slli	a2,a2,0x2
    80003d56:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003d58:	4314                	lw	a3,0(a4)
    80003d5a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003d5c:	0711                	addi	a4,a4,4
    80003d5e:	0791                	addi	a5,a5,4
    80003d60:	fec79ce3          	bne	a5,a2,80003d58 <write_head+0x3a>
  }
  bwrite(buf);
    80003d64:	8526                	mv	a0,s1
    80003d66:	a4aff0ef          	jal	80002fb0 <bwrite>
  brelse(buf);
    80003d6a:	8526                	mv	a0,s1
    80003d6c:	a76ff0ef          	jal	80002fe2 <brelse>
}
    80003d70:	60e2                	ld	ra,24(sp)
    80003d72:	6442                	ld	s0,16(sp)
    80003d74:	64a2                	ld	s1,8(sp)
    80003d76:	6902                	ld	s2,0(sp)
    80003d78:	6105                	addi	sp,sp,32
    80003d7a:	8082                	ret

0000000080003d7c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d7c:	0001f797          	auipc	a5,0x1f
    80003d80:	1107a783          	lw	a5,272(a5) # 80022e8c <log+0x2c>
    80003d84:	08f05f63          	blez	a5,80003e22 <install_trans+0xa6>
{
    80003d88:	7139                	addi	sp,sp,-64
    80003d8a:	fc06                	sd	ra,56(sp)
    80003d8c:	f822                	sd	s0,48(sp)
    80003d8e:	f426                	sd	s1,40(sp)
    80003d90:	f04a                	sd	s2,32(sp)
    80003d92:	ec4e                	sd	s3,24(sp)
    80003d94:	e852                	sd	s4,16(sp)
    80003d96:	e456                	sd	s5,8(sp)
    80003d98:	e05a                	sd	s6,0(sp)
    80003d9a:	0080                	addi	s0,sp,64
    80003d9c:	8b2a                	mv	s6,a0
    80003d9e:	0001fa97          	auipc	s5,0x1f
    80003da2:	0f2a8a93          	addi	s5,s5,242 # 80022e90 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003da6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003da8:	0001f997          	auipc	s3,0x1f
    80003dac:	0b898993          	addi	s3,s3,184 # 80022e60 <log>
    80003db0:	a829                	j	80003dca <install_trans+0x4e>
    brelse(lbuf);
    80003db2:	854a                	mv	a0,s2
    80003db4:	a2eff0ef          	jal	80002fe2 <brelse>
    brelse(dbuf);
    80003db8:	8526                	mv	a0,s1
    80003dba:	a28ff0ef          	jal	80002fe2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003dbe:	2a05                	addiw	s4,s4,1
    80003dc0:	0a91                	addi	s5,s5,4
    80003dc2:	02c9a783          	lw	a5,44(s3)
    80003dc6:	04fa5463          	bge	s4,a5,80003e0e <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003dca:	0189a583          	lw	a1,24(s3)
    80003dce:	014585bb          	addw	a1,a1,s4
    80003dd2:	2585                	addiw	a1,a1,1
    80003dd4:	0289a503          	lw	a0,40(s3)
    80003dd8:	902ff0ef          	jal	80002eda <bread>
    80003ddc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003dde:	000aa583          	lw	a1,0(s5)
    80003de2:	0289a503          	lw	a0,40(s3)
    80003de6:	8f4ff0ef          	jal	80002eda <bread>
    80003dea:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003dec:	40000613          	li	a2,1024
    80003df0:	05890593          	addi	a1,s2,88
    80003df4:	05850513          	addi	a0,a0,88
    80003df8:	f2dfc0ef          	jal	80000d24 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003dfc:	8526                	mv	a0,s1
    80003dfe:	9b2ff0ef          	jal	80002fb0 <bwrite>
    if(recovering == 0)
    80003e02:	fa0b18e3          	bnez	s6,80003db2 <install_trans+0x36>
      bunpin(dbuf);
    80003e06:	8526                	mv	a0,s1
    80003e08:	a96ff0ef          	jal	8000309e <bunpin>
    80003e0c:	b75d                	j	80003db2 <install_trans+0x36>
}
    80003e0e:	70e2                	ld	ra,56(sp)
    80003e10:	7442                	ld	s0,48(sp)
    80003e12:	74a2                	ld	s1,40(sp)
    80003e14:	7902                	ld	s2,32(sp)
    80003e16:	69e2                	ld	s3,24(sp)
    80003e18:	6a42                	ld	s4,16(sp)
    80003e1a:	6aa2                	ld	s5,8(sp)
    80003e1c:	6b02                	ld	s6,0(sp)
    80003e1e:	6121                	addi	sp,sp,64
    80003e20:	8082                	ret
    80003e22:	8082                	ret

0000000080003e24 <initlog>:
{
    80003e24:	7179                	addi	sp,sp,-48
    80003e26:	f406                	sd	ra,40(sp)
    80003e28:	f022                	sd	s0,32(sp)
    80003e2a:	ec26                	sd	s1,24(sp)
    80003e2c:	e84a                	sd	s2,16(sp)
    80003e2e:	e44e                	sd	s3,8(sp)
    80003e30:	1800                	addi	s0,sp,48
    80003e32:	892a                	mv	s2,a0
    80003e34:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003e36:	0001f497          	auipc	s1,0x1f
    80003e3a:	02a48493          	addi	s1,s1,42 # 80022e60 <log>
    80003e3e:	00003597          	auipc	a1,0x3
    80003e42:	72a58593          	addi	a1,a1,1834 # 80007568 <etext+0x568>
    80003e46:	8526                	mv	a0,s1
    80003e48:	d2dfc0ef          	jal	80000b74 <initlock>
  log.start = sb->logstart;
    80003e4c:	0149a583          	lw	a1,20(s3)
    80003e50:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003e52:	0109a783          	lw	a5,16(s3)
    80003e56:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003e58:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003e5c:	854a                	mv	a0,s2
    80003e5e:	87cff0ef          	jal	80002eda <bread>
  log.lh.n = lh->n;
    80003e62:	4d30                	lw	a2,88(a0)
    80003e64:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003e66:	00c05f63          	blez	a2,80003e84 <initlog+0x60>
    80003e6a:	87aa                	mv	a5,a0
    80003e6c:	0001f717          	auipc	a4,0x1f
    80003e70:	02470713          	addi	a4,a4,36 # 80022e90 <log+0x30>
    80003e74:	060a                	slli	a2,a2,0x2
    80003e76:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003e78:	4ff4                	lw	a3,92(a5)
    80003e7a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003e7c:	0791                	addi	a5,a5,4
    80003e7e:	0711                	addi	a4,a4,4
    80003e80:	fec79ce3          	bne	a5,a2,80003e78 <initlog+0x54>
  brelse(buf);
    80003e84:	95eff0ef          	jal	80002fe2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003e88:	4505                	li	a0,1
    80003e8a:	ef3ff0ef          	jal	80003d7c <install_trans>
  log.lh.n = 0;
    80003e8e:	0001f797          	auipc	a5,0x1f
    80003e92:	fe07af23          	sw	zero,-2(a5) # 80022e8c <log+0x2c>
  write_head(); // clear the log
    80003e96:	e89ff0ef          	jal	80003d1e <write_head>
}
    80003e9a:	70a2                	ld	ra,40(sp)
    80003e9c:	7402                	ld	s0,32(sp)
    80003e9e:	64e2                	ld	s1,24(sp)
    80003ea0:	6942                	ld	s2,16(sp)
    80003ea2:	69a2                	ld	s3,8(sp)
    80003ea4:	6145                	addi	sp,sp,48
    80003ea6:	8082                	ret

0000000080003ea8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003ea8:	1101                	addi	sp,sp,-32
    80003eaa:	ec06                	sd	ra,24(sp)
    80003eac:	e822                	sd	s0,16(sp)
    80003eae:	e426                	sd	s1,8(sp)
    80003eb0:	e04a                	sd	s2,0(sp)
    80003eb2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003eb4:	0001f517          	auipc	a0,0x1f
    80003eb8:	fac50513          	addi	a0,a0,-84 # 80022e60 <log>
    80003ebc:	d39fc0ef          	jal	80000bf4 <acquire>
  while(1){
    if(log.committing){
    80003ec0:	0001f497          	auipc	s1,0x1f
    80003ec4:	fa048493          	addi	s1,s1,-96 # 80022e60 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ec8:	4979                	li	s2,30
    80003eca:	a029                	j	80003ed4 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003ecc:	85a6                	mv	a1,s1
    80003ece:	8526                	mv	a0,s1
    80003ed0:	89cfe0ef          	jal	80001f6c <sleep>
    if(log.committing){
    80003ed4:	50dc                	lw	a5,36(s1)
    80003ed6:	fbfd                	bnez	a5,80003ecc <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003ed8:	5098                	lw	a4,32(s1)
    80003eda:	2705                	addiw	a4,a4,1
    80003edc:	0027179b          	slliw	a5,a4,0x2
    80003ee0:	9fb9                	addw	a5,a5,a4
    80003ee2:	0017979b          	slliw	a5,a5,0x1
    80003ee6:	54d4                	lw	a3,44(s1)
    80003ee8:	9fb5                	addw	a5,a5,a3
    80003eea:	00f95763          	bge	s2,a5,80003ef8 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003eee:	85a6                	mv	a1,s1
    80003ef0:	8526                	mv	a0,s1
    80003ef2:	87afe0ef          	jal	80001f6c <sleep>
    80003ef6:	bff9                	j	80003ed4 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003ef8:	0001f517          	auipc	a0,0x1f
    80003efc:	f6850513          	addi	a0,a0,-152 # 80022e60 <log>
    80003f00:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003f02:	d8bfc0ef          	jal	80000c8c <release>
      break;
    }
  }
}
    80003f06:	60e2                	ld	ra,24(sp)
    80003f08:	6442                	ld	s0,16(sp)
    80003f0a:	64a2                	ld	s1,8(sp)
    80003f0c:	6902                	ld	s2,0(sp)
    80003f0e:	6105                	addi	sp,sp,32
    80003f10:	8082                	ret

0000000080003f12 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003f12:	7139                	addi	sp,sp,-64
    80003f14:	fc06                	sd	ra,56(sp)
    80003f16:	f822                	sd	s0,48(sp)
    80003f18:	f426                	sd	s1,40(sp)
    80003f1a:	f04a                	sd	s2,32(sp)
    80003f1c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003f1e:	0001f497          	auipc	s1,0x1f
    80003f22:	f4248493          	addi	s1,s1,-190 # 80022e60 <log>
    80003f26:	8526                	mv	a0,s1
    80003f28:	ccdfc0ef          	jal	80000bf4 <acquire>
  log.outstanding -= 1;
    80003f2c:	509c                	lw	a5,32(s1)
    80003f2e:	37fd                	addiw	a5,a5,-1
    80003f30:	0007891b          	sext.w	s2,a5
    80003f34:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003f36:	50dc                	lw	a5,36(s1)
    80003f38:	ef9d                	bnez	a5,80003f76 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003f3a:	04091763          	bnez	s2,80003f88 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003f3e:	0001f497          	auipc	s1,0x1f
    80003f42:	f2248493          	addi	s1,s1,-222 # 80022e60 <log>
    80003f46:	4785                	li	a5,1
    80003f48:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	d41fc0ef          	jal	80000c8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003f50:	54dc                	lw	a5,44(s1)
    80003f52:	04f04b63          	bgtz	a5,80003fa8 <end_op+0x96>
    acquire(&log.lock);
    80003f56:	0001f497          	auipc	s1,0x1f
    80003f5a:	f0a48493          	addi	s1,s1,-246 # 80022e60 <log>
    80003f5e:	8526                	mv	a0,s1
    80003f60:	c95fc0ef          	jal	80000bf4 <acquire>
    log.committing = 0;
    80003f64:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003f68:	8526                	mv	a0,s1
    80003f6a:	84efe0ef          	jal	80001fb8 <wakeup>
    release(&log.lock);
    80003f6e:	8526                	mv	a0,s1
    80003f70:	d1dfc0ef          	jal	80000c8c <release>
}
    80003f74:	a025                	j	80003f9c <end_op+0x8a>
    80003f76:	ec4e                	sd	s3,24(sp)
    80003f78:	e852                	sd	s4,16(sp)
    80003f7a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003f7c:	00003517          	auipc	a0,0x3
    80003f80:	5f450513          	addi	a0,a0,1524 # 80007570 <etext+0x570>
    80003f84:	811fc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003f88:	0001f497          	auipc	s1,0x1f
    80003f8c:	ed848493          	addi	s1,s1,-296 # 80022e60 <log>
    80003f90:	8526                	mv	a0,s1
    80003f92:	826fe0ef          	jal	80001fb8 <wakeup>
  release(&log.lock);
    80003f96:	8526                	mv	a0,s1
    80003f98:	cf5fc0ef          	jal	80000c8c <release>
}
    80003f9c:	70e2                	ld	ra,56(sp)
    80003f9e:	7442                	ld	s0,48(sp)
    80003fa0:	74a2                	ld	s1,40(sp)
    80003fa2:	7902                	ld	s2,32(sp)
    80003fa4:	6121                	addi	sp,sp,64
    80003fa6:	8082                	ret
    80003fa8:	ec4e                	sd	s3,24(sp)
    80003faa:	e852                	sd	s4,16(sp)
    80003fac:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003fae:	0001fa97          	auipc	s5,0x1f
    80003fb2:	ee2a8a93          	addi	s5,s5,-286 # 80022e90 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003fb6:	0001fa17          	auipc	s4,0x1f
    80003fba:	eaaa0a13          	addi	s4,s4,-342 # 80022e60 <log>
    80003fbe:	018a2583          	lw	a1,24(s4)
    80003fc2:	012585bb          	addw	a1,a1,s2
    80003fc6:	2585                	addiw	a1,a1,1
    80003fc8:	028a2503          	lw	a0,40(s4)
    80003fcc:	f0ffe0ef          	jal	80002eda <bread>
    80003fd0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003fd2:	000aa583          	lw	a1,0(s5)
    80003fd6:	028a2503          	lw	a0,40(s4)
    80003fda:	f01fe0ef          	jal	80002eda <bread>
    80003fde:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003fe0:	40000613          	li	a2,1024
    80003fe4:	05850593          	addi	a1,a0,88
    80003fe8:	05848513          	addi	a0,s1,88
    80003fec:	d39fc0ef          	jal	80000d24 <memmove>
    bwrite(to);  // write the log
    80003ff0:	8526                	mv	a0,s1
    80003ff2:	fbffe0ef          	jal	80002fb0 <bwrite>
    brelse(from);
    80003ff6:	854e                	mv	a0,s3
    80003ff8:	febfe0ef          	jal	80002fe2 <brelse>
    brelse(to);
    80003ffc:	8526                	mv	a0,s1
    80003ffe:	fe5fe0ef          	jal	80002fe2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004002:	2905                	addiw	s2,s2,1
    80004004:	0a91                	addi	s5,s5,4
    80004006:	02ca2783          	lw	a5,44(s4)
    8000400a:	faf94ae3          	blt	s2,a5,80003fbe <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000400e:	d11ff0ef          	jal	80003d1e <write_head>
    install_trans(0); // Now install writes to home locations
    80004012:	4501                	li	a0,0
    80004014:	d69ff0ef          	jal	80003d7c <install_trans>
    log.lh.n = 0;
    80004018:	0001f797          	auipc	a5,0x1f
    8000401c:	e607aa23          	sw	zero,-396(a5) # 80022e8c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004020:	cffff0ef          	jal	80003d1e <write_head>
    80004024:	69e2                	ld	s3,24(sp)
    80004026:	6a42                	ld	s4,16(sp)
    80004028:	6aa2                	ld	s5,8(sp)
    8000402a:	b735                	j	80003f56 <end_op+0x44>

000000008000402c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000402c:	1101                	addi	sp,sp,-32
    8000402e:	ec06                	sd	ra,24(sp)
    80004030:	e822                	sd	s0,16(sp)
    80004032:	e426                	sd	s1,8(sp)
    80004034:	e04a                	sd	s2,0(sp)
    80004036:	1000                	addi	s0,sp,32
    80004038:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000403a:	0001f917          	auipc	s2,0x1f
    8000403e:	e2690913          	addi	s2,s2,-474 # 80022e60 <log>
    80004042:	854a                	mv	a0,s2
    80004044:	bb1fc0ef          	jal	80000bf4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004048:	02c92603          	lw	a2,44(s2)
    8000404c:	47f5                	li	a5,29
    8000404e:	06c7c363          	blt	a5,a2,800040b4 <log_write+0x88>
    80004052:	0001f797          	auipc	a5,0x1f
    80004056:	e2a7a783          	lw	a5,-470(a5) # 80022e7c <log+0x1c>
    8000405a:	37fd                	addiw	a5,a5,-1
    8000405c:	04f65c63          	bge	a2,a5,800040b4 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004060:	0001f797          	auipc	a5,0x1f
    80004064:	e207a783          	lw	a5,-480(a5) # 80022e80 <log+0x20>
    80004068:	04f05c63          	blez	a5,800040c0 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000406c:	4781                	li	a5,0
    8000406e:	04c05f63          	blez	a2,800040cc <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004072:	44cc                	lw	a1,12(s1)
    80004074:	0001f717          	auipc	a4,0x1f
    80004078:	e1c70713          	addi	a4,a4,-484 # 80022e90 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000407c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000407e:	4314                	lw	a3,0(a4)
    80004080:	04b68663          	beq	a3,a1,800040cc <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80004084:	2785                	addiw	a5,a5,1
    80004086:	0711                	addi	a4,a4,4
    80004088:	fef61be3          	bne	a2,a5,8000407e <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000408c:	0621                	addi	a2,a2,8
    8000408e:	060a                	slli	a2,a2,0x2
    80004090:	0001f797          	auipc	a5,0x1f
    80004094:	dd078793          	addi	a5,a5,-560 # 80022e60 <log>
    80004098:	97b2                	add	a5,a5,a2
    8000409a:	44d8                	lw	a4,12(s1)
    8000409c:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000409e:	8526                	mv	a0,s1
    800040a0:	fcbfe0ef          	jal	8000306a <bpin>
    log.lh.n++;
    800040a4:	0001f717          	auipc	a4,0x1f
    800040a8:	dbc70713          	addi	a4,a4,-580 # 80022e60 <log>
    800040ac:	575c                	lw	a5,44(a4)
    800040ae:	2785                	addiw	a5,a5,1
    800040b0:	d75c                	sw	a5,44(a4)
    800040b2:	a80d                	j	800040e4 <log_write+0xb8>
    panic("too big a transaction");
    800040b4:	00003517          	auipc	a0,0x3
    800040b8:	4cc50513          	addi	a0,a0,1228 # 80007580 <etext+0x580>
    800040bc:	ed8fc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    800040c0:	00003517          	auipc	a0,0x3
    800040c4:	4d850513          	addi	a0,a0,1240 # 80007598 <etext+0x598>
    800040c8:	eccfc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    800040cc:	00878693          	addi	a3,a5,8
    800040d0:	068a                	slli	a3,a3,0x2
    800040d2:	0001f717          	auipc	a4,0x1f
    800040d6:	d8e70713          	addi	a4,a4,-626 # 80022e60 <log>
    800040da:	9736                	add	a4,a4,a3
    800040dc:	44d4                	lw	a3,12(s1)
    800040de:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800040e0:	faf60fe3          	beq	a2,a5,8000409e <log_write+0x72>
  }
  release(&log.lock);
    800040e4:	0001f517          	auipc	a0,0x1f
    800040e8:	d7c50513          	addi	a0,a0,-644 # 80022e60 <log>
    800040ec:	ba1fc0ef          	jal	80000c8c <release>
}
    800040f0:	60e2                	ld	ra,24(sp)
    800040f2:	6442                	ld	s0,16(sp)
    800040f4:	64a2                	ld	s1,8(sp)
    800040f6:	6902                	ld	s2,0(sp)
    800040f8:	6105                	addi	sp,sp,32
    800040fa:	8082                	ret

00000000800040fc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800040fc:	1101                	addi	sp,sp,-32
    800040fe:	ec06                	sd	ra,24(sp)
    80004100:	e822                	sd	s0,16(sp)
    80004102:	e426                	sd	s1,8(sp)
    80004104:	e04a                	sd	s2,0(sp)
    80004106:	1000                	addi	s0,sp,32
    80004108:	84aa                	mv	s1,a0
    8000410a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000410c:	00003597          	auipc	a1,0x3
    80004110:	4ac58593          	addi	a1,a1,1196 # 800075b8 <etext+0x5b8>
    80004114:	0521                	addi	a0,a0,8
    80004116:	a5ffc0ef          	jal	80000b74 <initlock>
  lk->name = name;
    8000411a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000411e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004122:	0204a423          	sw	zero,40(s1)
}
    80004126:	60e2                	ld	ra,24(sp)
    80004128:	6442                	ld	s0,16(sp)
    8000412a:	64a2                	ld	s1,8(sp)
    8000412c:	6902                	ld	s2,0(sp)
    8000412e:	6105                	addi	sp,sp,32
    80004130:	8082                	ret

0000000080004132 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004132:	1101                	addi	sp,sp,-32
    80004134:	ec06                	sd	ra,24(sp)
    80004136:	e822                	sd	s0,16(sp)
    80004138:	e426                	sd	s1,8(sp)
    8000413a:	e04a                	sd	s2,0(sp)
    8000413c:	1000                	addi	s0,sp,32
    8000413e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004140:	00850913          	addi	s2,a0,8
    80004144:	854a                	mv	a0,s2
    80004146:	aaffc0ef          	jal	80000bf4 <acquire>
  while (lk->locked) {
    8000414a:	409c                	lw	a5,0(s1)
    8000414c:	c799                	beqz	a5,8000415a <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000414e:	85ca                	mv	a1,s2
    80004150:	8526                	mv	a0,s1
    80004152:	e1bfd0ef          	jal	80001f6c <sleep>
  while (lk->locked) {
    80004156:	409c                	lw	a5,0(s1)
    80004158:	fbfd                	bnez	a5,8000414e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000415a:	4785                	li	a5,1
    8000415c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000415e:	fb8fd0ef          	jal	80001916 <myproc>
    80004162:	591c                	lw	a5,48(a0)
    80004164:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004166:	854a                	mv	a0,s2
    80004168:	b25fc0ef          	jal	80000c8c <release>
}
    8000416c:	60e2                	ld	ra,24(sp)
    8000416e:	6442                	ld	s0,16(sp)
    80004170:	64a2                	ld	s1,8(sp)
    80004172:	6902                	ld	s2,0(sp)
    80004174:	6105                	addi	sp,sp,32
    80004176:	8082                	ret

0000000080004178 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004178:	1101                	addi	sp,sp,-32
    8000417a:	ec06                	sd	ra,24(sp)
    8000417c:	e822                	sd	s0,16(sp)
    8000417e:	e426                	sd	s1,8(sp)
    80004180:	e04a                	sd	s2,0(sp)
    80004182:	1000                	addi	s0,sp,32
    80004184:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004186:	00850913          	addi	s2,a0,8
    8000418a:	854a                	mv	a0,s2
    8000418c:	a69fc0ef          	jal	80000bf4 <acquire>
  lk->locked = 0;
    80004190:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004194:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004198:	8526                	mv	a0,s1
    8000419a:	e1ffd0ef          	jal	80001fb8 <wakeup>
  release(&lk->lk);
    8000419e:	854a                	mv	a0,s2
    800041a0:	aedfc0ef          	jal	80000c8c <release>
}
    800041a4:	60e2                	ld	ra,24(sp)
    800041a6:	6442                	ld	s0,16(sp)
    800041a8:	64a2                	ld	s1,8(sp)
    800041aa:	6902                	ld	s2,0(sp)
    800041ac:	6105                	addi	sp,sp,32
    800041ae:	8082                	ret

00000000800041b0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800041b0:	7179                	addi	sp,sp,-48
    800041b2:	f406                	sd	ra,40(sp)
    800041b4:	f022                	sd	s0,32(sp)
    800041b6:	ec26                	sd	s1,24(sp)
    800041b8:	e84a                	sd	s2,16(sp)
    800041ba:	1800                	addi	s0,sp,48
    800041bc:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800041be:	00850913          	addi	s2,a0,8
    800041c2:	854a                	mv	a0,s2
    800041c4:	a31fc0ef          	jal	80000bf4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800041c8:	409c                	lw	a5,0(s1)
    800041ca:	ef81                	bnez	a5,800041e2 <holdingsleep+0x32>
    800041cc:	4481                	li	s1,0
  release(&lk->lk);
    800041ce:	854a                	mv	a0,s2
    800041d0:	abdfc0ef          	jal	80000c8c <release>
  return r;
}
    800041d4:	8526                	mv	a0,s1
    800041d6:	70a2                	ld	ra,40(sp)
    800041d8:	7402                	ld	s0,32(sp)
    800041da:	64e2                	ld	s1,24(sp)
    800041dc:	6942                	ld	s2,16(sp)
    800041de:	6145                	addi	sp,sp,48
    800041e0:	8082                	ret
    800041e2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800041e4:	0284a983          	lw	s3,40(s1)
    800041e8:	f2efd0ef          	jal	80001916 <myproc>
    800041ec:	5904                	lw	s1,48(a0)
    800041ee:	413484b3          	sub	s1,s1,s3
    800041f2:	0014b493          	seqz	s1,s1
    800041f6:	69a2                	ld	s3,8(sp)
    800041f8:	bfd9                	j	800041ce <holdingsleep+0x1e>

00000000800041fa <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800041fa:	1141                	addi	sp,sp,-16
    800041fc:	e406                	sd	ra,8(sp)
    800041fe:	e022                	sd	s0,0(sp)
    80004200:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004202:	00003597          	auipc	a1,0x3
    80004206:	3c658593          	addi	a1,a1,966 # 800075c8 <etext+0x5c8>
    8000420a:	0001f517          	auipc	a0,0x1f
    8000420e:	d9e50513          	addi	a0,a0,-610 # 80022fa8 <ftable>
    80004212:	963fc0ef          	jal	80000b74 <initlock>
}
    80004216:	60a2                	ld	ra,8(sp)
    80004218:	6402                	ld	s0,0(sp)
    8000421a:	0141                	addi	sp,sp,16
    8000421c:	8082                	ret

000000008000421e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000421e:	1101                	addi	sp,sp,-32
    80004220:	ec06                	sd	ra,24(sp)
    80004222:	e822                	sd	s0,16(sp)
    80004224:	e426                	sd	s1,8(sp)
    80004226:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004228:	0001f517          	auipc	a0,0x1f
    8000422c:	d8050513          	addi	a0,a0,-640 # 80022fa8 <ftable>
    80004230:	9c5fc0ef          	jal	80000bf4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004234:	0001f497          	auipc	s1,0x1f
    80004238:	d8c48493          	addi	s1,s1,-628 # 80022fc0 <ftable+0x18>
    8000423c:	00020717          	auipc	a4,0x20
    80004240:	d2470713          	addi	a4,a4,-732 # 80023f60 <disk>
    if(f->ref == 0){
    80004244:	40dc                	lw	a5,4(s1)
    80004246:	cf89                	beqz	a5,80004260 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004248:	02848493          	addi	s1,s1,40
    8000424c:	fee49ce3          	bne	s1,a4,80004244 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004250:	0001f517          	auipc	a0,0x1f
    80004254:	d5850513          	addi	a0,a0,-680 # 80022fa8 <ftable>
    80004258:	a35fc0ef          	jal	80000c8c <release>
  return 0;
    8000425c:	4481                	li	s1,0
    8000425e:	a809                	j	80004270 <filealloc+0x52>
      f->ref = 1;
    80004260:	4785                	li	a5,1
    80004262:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004264:	0001f517          	auipc	a0,0x1f
    80004268:	d4450513          	addi	a0,a0,-700 # 80022fa8 <ftable>
    8000426c:	a21fc0ef          	jal	80000c8c <release>
}
    80004270:	8526                	mv	a0,s1
    80004272:	60e2                	ld	ra,24(sp)
    80004274:	6442                	ld	s0,16(sp)
    80004276:	64a2                	ld	s1,8(sp)
    80004278:	6105                	addi	sp,sp,32
    8000427a:	8082                	ret

000000008000427c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000427c:	1101                	addi	sp,sp,-32
    8000427e:	ec06                	sd	ra,24(sp)
    80004280:	e822                	sd	s0,16(sp)
    80004282:	e426                	sd	s1,8(sp)
    80004284:	1000                	addi	s0,sp,32
    80004286:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004288:	0001f517          	auipc	a0,0x1f
    8000428c:	d2050513          	addi	a0,a0,-736 # 80022fa8 <ftable>
    80004290:	965fc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    80004294:	40dc                	lw	a5,4(s1)
    80004296:	02f05063          	blez	a5,800042b6 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000429a:	2785                	addiw	a5,a5,1
    8000429c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000429e:	0001f517          	auipc	a0,0x1f
    800042a2:	d0a50513          	addi	a0,a0,-758 # 80022fa8 <ftable>
    800042a6:	9e7fc0ef          	jal	80000c8c <release>
  return f;
}
    800042aa:	8526                	mv	a0,s1
    800042ac:	60e2                	ld	ra,24(sp)
    800042ae:	6442                	ld	s0,16(sp)
    800042b0:	64a2                	ld	s1,8(sp)
    800042b2:	6105                	addi	sp,sp,32
    800042b4:	8082                	ret
    panic("filedup");
    800042b6:	00003517          	auipc	a0,0x3
    800042ba:	31a50513          	addi	a0,a0,794 # 800075d0 <etext+0x5d0>
    800042be:	cd6fc0ef          	jal	80000794 <panic>

00000000800042c2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800042c2:	7139                	addi	sp,sp,-64
    800042c4:	fc06                	sd	ra,56(sp)
    800042c6:	f822                	sd	s0,48(sp)
    800042c8:	f426                	sd	s1,40(sp)
    800042ca:	0080                	addi	s0,sp,64
    800042cc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800042ce:	0001f517          	auipc	a0,0x1f
    800042d2:	cda50513          	addi	a0,a0,-806 # 80022fa8 <ftable>
    800042d6:	91ffc0ef          	jal	80000bf4 <acquire>
  if(f->ref < 1)
    800042da:	40dc                	lw	a5,4(s1)
    800042dc:	04f05a63          	blez	a5,80004330 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800042e0:	37fd                	addiw	a5,a5,-1
    800042e2:	0007871b          	sext.w	a4,a5
    800042e6:	c0dc                	sw	a5,4(s1)
    800042e8:	04e04e63          	bgtz	a4,80004344 <fileclose+0x82>
    800042ec:	f04a                	sd	s2,32(sp)
    800042ee:	ec4e                	sd	s3,24(sp)
    800042f0:	e852                	sd	s4,16(sp)
    800042f2:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800042f4:	0004a903          	lw	s2,0(s1)
    800042f8:	0094ca83          	lbu	s5,9(s1)
    800042fc:	0104ba03          	ld	s4,16(s1)
    80004300:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004304:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004308:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000430c:	0001f517          	auipc	a0,0x1f
    80004310:	c9c50513          	addi	a0,a0,-868 # 80022fa8 <ftable>
    80004314:	979fc0ef          	jal	80000c8c <release>

  if(ff.type == FD_PIPE){
    80004318:	4785                	li	a5,1
    8000431a:	04f90063          	beq	s2,a5,8000435a <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000431e:	3979                	addiw	s2,s2,-2
    80004320:	4785                	li	a5,1
    80004322:	0527f563          	bgeu	a5,s2,8000436c <fileclose+0xaa>
    80004326:	7902                	ld	s2,32(sp)
    80004328:	69e2                	ld	s3,24(sp)
    8000432a:	6a42                	ld	s4,16(sp)
    8000432c:	6aa2                	ld	s5,8(sp)
    8000432e:	a00d                	j	80004350 <fileclose+0x8e>
    80004330:	f04a                	sd	s2,32(sp)
    80004332:	ec4e                	sd	s3,24(sp)
    80004334:	e852                	sd	s4,16(sp)
    80004336:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004338:	00003517          	auipc	a0,0x3
    8000433c:	2a050513          	addi	a0,a0,672 # 800075d8 <etext+0x5d8>
    80004340:	c54fc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    80004344:	0001f517          	auipc	a0,0x1f
    80004348:	c6450513          	addi	a0,a0,-924 # 80022fa8 <ftable>
    8000434c:	941fc0ef          	jal	80000c8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004350:	70e2                	ld	ra,56(sp)
    80004352:	7442                	ld	s0,48(sp)
    80004354:	74a2                	ld	s1,40(sp)
    80004356:	6121                	addi	sp,sp,64
    80004358:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000435a:	85d6                	mv	a1,s5
    8000435c:	8552                	mv	a0,s4
    8000435e:	336000ef          	jal	80004694 <pipeclose>
    80004362:	7902                	ld	s2,32(sp)
    80004364:	69e2                	ld	s3,24(sp)
    80004366:	6a42                	ld	s4,16(sp)
    80004368:	6aa2                	ld	s5,8(sp)
    8000436a:	b7dd                	j	80004350 <fileclose+0x8e>
    begin_op();
    8000436c:	b3dff0ef          	jal	80003ea8 <begin_op>
    iput(ff.ip);
    80004370:	854e                	mv	a0,s3
    80004372:	c22ff0ef          	jal	80003794 <iput>
    end_op();
    80004376:	b9dff0ef          	jal	80003f12 <end_op>
    8000437a:	7902                	ld	s2,32(sp)
    8000437c:	69e2                	ld	s3,24(sp)
    8000437e:	6a42                	ld	s4,16(sp)
    80004380:	6aa2                	ld	s5,8(sp)
    80004382:	b7f9                	j	80004350 <fileclose+0x8e>

0000000080004384 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004384:	715d                	addi	sp,sp,-80
    80004386:	e486                	sd	ra,72(sp)
    80004388:	e0a2                	sd	s0,64(sp)
    8000438a:	fc26                	sd	s1,56(sp)
    8000438c:	f44e                	sd	s3,40(sp)
    8000438e:	0880                	addi	s0,sp,80
    80004390:	84aa                	mv	s1,a0
    80004392:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004394:	d82fd0ef          	jal	80001916 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004398:	409c                	lw	a5,0(s1)
    8000439a:	37f9                	addiw	a5,a5,-2
    8000439c:	4705                	li	a4,1
    8000439e:	04f76063          	bltu	a4,a5,800043de <filestat+0x5a>
    800043a2:	f84a                	sd	s2,48(sp)
    800043a4:	892a                	mv	s2,a0
    ilock(f->ip);
    800043a6:	6c88                	ld	a0,24(s1)
    800043a8:	a6aff0ef          	jal	80003612 <ilock>
    stati(f->ip, &st);
    800043ac:	fb840593          	addi	a1,s0,-72
    800043b0:	6c88                	ld	a0,24(s1)
    800043b2:	c8aff0ef          	jal	8000383c <stati>
    iunlock(f->ip);
    800043b6:	6c88                	ld	a0,24(s1)
    800043b8:	b08ff0ef          	jal	800036c0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800043bc:	46e1                	li	a3,24
    800043be:	fb840613          	addi	a2,s0,-72
    800043c2:	85ce                	mv	a1,s3
    800043c4:	05093503          	ld	a0,80(s2)
    800043c8:	9c0fd0ef          	jal	80001588 <copyout>
    800043cc:	41f5551b          	sraiw	a0,a0,0x1f
    800043d0:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800043d2:	60a6                	ld	ra,72(sp)
    800043d4:	6406                	ld	s0,64(sp)
    800043d6:	74e2                	ld	s1,56(sp)
    800043d8:	79a2                	ld	s3,40(sp)
    800043da:	6161                	addi	sp,sp,80
    800043dc:	8082                	ret
  return -1;
    800043de:	557d                	li	a0,-1
    800043e0:	bfcd                	j	800043d2 <filestat+0x4e>

00000000800043e2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800043e2:	7179                	addi	sp,sp,-48
    800043e4:	f406                	sd	ra,40(sp)
    800043e6:	f022                	sd	s0,32(sp)
    800043e8:	e84a                	sd	s2,16(sp)
    800043ea:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800043ec:	00854783          	lbu	a5,8(a0)
    800043f0:	cfd1                	beqz	a5,8000448c <fileread+0xaa>
    800043f2:	ec26                	sd	s1,24(sp)
    800043f4:	e44e                	sd	s3,8(sp)
    800043f6:	84aa                	mv	s1,a0
    800043f8:	89ae                	mv	s3,a1
    800043fa:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    800043fc:	411c                	lw	a5,0(a0)
    800043fe:	4705                	li	a4,1
    80004400:	04e78363          	beq	a5,a4,80004446 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004404:	470d                	li	a4,3
    80004406:	04e78763          	beq	a5,a4,80004454 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000440a:	4709                	li	a4,2
    8000440c:	06e79a63          	bne	a5,a4,80004480 <fileread+0x9e>
    ilock(f->ip);
    80004410:	6d08                	ld	a0,24(a0)
    80004412:	a00ff0ef          	jal	80003612 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004416:	874a                	mv	a4,s2
    80004418:	5094                	lw	a3,32(s1)
    8000441a:	864e                	mv	a2,s3
    8000441c:	4585                	li	a1,1
    8000441e:	6c88                	ld	a0,24(s1)
    80004420:	c46ff0ef          	jal	80003866 <readi>
    80004424:	892a                	mv	s2,a0
    80004426:	00a05563          	blez	a0,80004430 <fileread+0x4e>
      f->off += r;
    8000442a:	509c                	lw	a5,32(s1)
    8000442c:	9fa9                	addw	a5,a5,a0
    8000442e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004430:	6c88                	ld	a0,24(s1)
    80004432:	a8eff0ef          	jal	800036c0 <iunlock>
    80004436:	64e2                	ld	s1,24(sp)
    80004438:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000443a:	854a                	mv	a0,s2
    8000443c:	70a2                	ld	ra,40(sp)
    8000443e:	7402                	ld	s0,32(sp)
    80004440:	6942                	ld	s2,16(sp)
    80004442:	6145                	addi	sp,sp,48
    80004444:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004446:	6908                	ld	a0,16(a0)
    80004448:	39c000ef          	jal	800047e4 <piperead>
    8000444c:	892a                	mv	s2,a0
    8000444e:	64e2                	ld	s1,24(sp)
    80004450:	69a2                	ld	s3,8(sp)
    80004452:	b7e5                	j	8000443a <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004454:	02451783          	lh	a5,36(a0)
    80004458:	03079693          	slli	a3,a5,0x30
    8000445c:	92c1                	srli	a3,a3,0x30
    8000445e:	4725                	li	a4,9
    80004460:	02d76863          	bltu	a4,a3,80004490 <fileread+0xae>
    80004464:	0792                	slli	a5,a5,0x4
    80004466:	0001f717          	auipc	a4,0x1f
    8000446a:	aa270713          	addi	a4,a4,-1374 # 80022f08 <devsw>
    8000446e:	97ba                	add	a5,a5,a4
    80004470:	639c                	ld	a5,0(a5)
    80004472:	c39d                	beqz	a5,80004498 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004474:	4505                	li	a0,1
    80004476:	9782                	jalr	a5
    80004478:	892a                	mv	s2,a0
    8000447a:	64e2                	ld	s1,24(sp)
    8000447c:	69a2                	ld	s3,8(sp)
    8000447e:	bf75                	j	8000443a <fileread+0x58>
    panic("fileread");
    80004480:	00003517          	auipc	a0,0x3
    80004484:	16850513          	addi	a0,a0,360 # 800075e8 <etext+0x5e8>
    80004488:	b0cfc0ef          	jal	80000794 <panic>
    return -1;
    8000448c:	597d                	li	s2,-1
    8000448e:	b775                	j	8000443a <fileread+0x58>
      return -1;
    80004490:	597d                	li	s2,-1
    80004492:	64e2                	ld	s1,24(sp)
    80004494:	69a2                	ld	s3,8(sp)
    80004496:	b755                	j	8000443a <fileread+0x58>
    80004498:	597d                	li	s2,-1
    8000449a:	64e2                	ld	s1,24(sp)
    8000449c:	69a2                	ld	s3,8(sp)
    8000449e:	bf71                	j	8000443a <fileread+0x58>

00000000800044a0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800044a0:	00954783          	lbu	a5,9(a0)
    800044a4:	10078b63          	beqz	a5,800045ba <filewrite+0x11a>
{
    800044a8:	715d                	addi	sp,sp,-80
    800044aa:	e486                	sd	ra,72(sp)
    800044ac:	e0a2                	sd	s0,64(sp)
    800044ae:	f84a                	sd	s2,48(sp)
    800044b0:	f052                	sd	s4,32(sp)
    800044b2:	e85a                	sd	s6,16(sp)
    800044b4:	0880                	addi	s0,sp,80
    800044b6:	892a                	mv	s2,a0
    800044b8:	8b2e                	mv	s6,a1
    800044ba:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    800044bc:	411c                	lw	a5,0(a0)
    800044be:	4705                	li	a4,1
    800044c0:	02e78763          	beq	a5,a4,800044ee <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800044c4:	470d                	li	a4,3
    800044c6:	02e78863          	beq	a5,a4,800044f6 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800044ca:	4709                	li	a4,2
    800044cc:	0ce79c63          	bne	a5,a4,800045a4 <filewrite+0x104>
    800044d0:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800044d2:	0ac05863          	blez	a2,80004582 <filewrite+0xe2>
    800044d6:	fc26                	sd	s1,56(sp)
    800044d8:	ec56                	sd	s5,24(sp)
    800044da:	e45e                	sd	s7,8(sp)
    800044dc:	e062                	sd	s8,0(sp)
    int i = 0;
    800044de:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    800044e0:	6b85                	lui	s7,0x1
    800044e2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800044e6:	6c05                	lui	s8,0x1
    800044e8:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    800044ec:	a8b5                	j	80004568 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    800044ee:	6908                	ld	a0,16(a0)
    800044f0:	1fc000ef          	jal	800046ec <pipewrite>
    800044f4:	a04d                	j	80004596 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800044f6:	02451783          	lh	a5,36(a0)
    800044fa:	03079693          	slli	a3,a5,0x30
    800044fe:	92c1                	srli	a3,a3,0x30
    80004500:	4725                	li	a4,9
    80004502:	0ad76e63          	bltu	a4,a3,800045be <filewrite+0x11e>
    80004506:	0792                	slli	a5,a5,0x4
    80004508:	0001f717          	auipc	a4,0x1f
    8000450c:	a0070713          	addi	a4,a4,-1536 # 80022f08 <devsw>
    80004510:	97ba                	add	a5,a5,a4
    80004512:	679c                	ld	a5,8(a5)
    80004514:	c7dd                	beqz	a5,800045c2 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80004516:	4505                	li	a0,1
    80004518:	9782                	jalr	a5
    8000451a:	a8b5                	j	80004596 <filewrite+0xf6>
      if(n1 > max)
    8000451c:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004520:	989ff0ef          	jal	80003ea8 <begin_op>
      ilock(f->ip);
    80004524:	01893503          	ld	a0,24(s2)
    80004528:	8eaff0ef          	jal	80003612 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000452c:	8756                	mv	a4,s5
    8000452e:	02092683          	lw	a3,32(s2)
    80004532:	01698633          	add	a2,s3,s6
    80004536:	4585                	li	a1,1
    80004538:	01893503          	ld	a0,24(s2)
    8000453c:	c26ff0ef          	jal	80003962 <writei>
    80004540:	84aa                	mv	s1,a0
    80004542:	00a05763          	blez	a0,80004550 <filewrite+0xb0>
        f->off += r;
    80004546:	02092783          	lw	a5,32(s2)
    8000454a:	9fa9                	addw	a5,a5,a0
    8000454c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004550:	01893503          	ld	a0,24(s2)
    80004554:	96cff0ef          	jal	800036c0 <iunlock>
      end_op();
    80004558:	9bbff0ef          	jal	80003f12 <end_op>

      if(r != n1){
    8000455c:	029a9563          	bne	s5,s1,80004586 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004560:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004564:	0149da63          	bge	s3,s4,80004578 <filewrite+0xd8>
      int n1 = n - i;
    80004568:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    8000456c:	0004879b          	sext.w	a5,s1
    80004570:	fafbd6e3          	bge	s7,a5,8000451c <filewrite+0x7c>
    80004574:	84e2                	mv	s1,s8
    80004576:	b75d                	j	8000451c <filewrite+0x7c>
    80004578:	74e2                	ld	s1,56(sp)
    8000457a:	6ae2                	ld	s5,24(sp)
    8000457c:	6ba2                	ld	s7,8(sp)
    8000457e:	6c02                	ld	s8,0(sp)
    80004580:	a039                	j	8000458e <filewrite+0xee>
    int i = 0;
    80004582:	4981                	li	s3,0
    80004584:	a029                	j	8000458e <filewrite+0xee>
    80004586:	74e2                	ld	s1,56(sp)
    80004588:	6ae2                	ld	s5,24(sp)
    8000458a:	6ba2                	ld	s7,8(sp)
    8000458c:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    8000458e:	033a1c63          	bne	s4,s3,800045c6 <filewrite+0x126>
    80004592:	8552                	mv	a0,s4
    80004594:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004596:	60a6                	ld	ra,72(sp)
    80004598:	6406                	ld	s0,64(sp)
    8000459a:	7942                	ld	s2,48(sp)
    8000459c:	7a02                	ld	s4,32(sp)
    8000459e:	6b42                	ld	s6,16(sp)
    800045a0:	6161                	addi	sp,sp,80
    800045a2:	8082                	ret
    800045a4:	fc26                	sd	s1,56(sp)
    800045a6:	f44e                	sd	s3,40(sp)
    800045a8:	ec56                	sd	s5,24(sp)
    800045aa:	e45e                	sd	s7,8(sp)
    800045ac:	e062                	sd	s8,0(sp)
    panic("filewrite");
    800045ae:	00003517          	auipc	a0,0x3
    800045b2:	04a50513          	addi	a0,a0,74 # 800075f8 <etext+0x5f8>
    800045b6:	9defc0ef          	jal	80000794 <panic>
    return -1;
    800045ba:	557d                	li	a0,-1
}
    800045bc:	8082                	ret
      return -1;
    800045be:	557d                	li	a0,-1
    800045c0:	bfd9                	j	80004596 <filewrite+0xf6>
    800045c2:	557d                	li	a0,-1
    800045c4:	bfc9                	j	80004596 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800045c6:	557d                	li	a0,-1
    800045c8:	79a2                	ld	s3,40(sp)
    800045ca:	b7f1                	j	80004596 <filewrite+0xf6>

00000000800045cc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800045cc:	7179                	addi	sp,sp,-48
    800045ce:	f406                	sd	ra,40(sp)
    800045d0:	f022                	sd	s0,32(sp)
    800045d2:	ec26                	sd	s1,24(sp)
    800045d4:	e052                	sd	s4,0(sp)
    800045d6:	1800                	addi	s0,sp,48
    800045d8:	84aa                	mv	s1,a0
    800045da:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800045dc:	0005b023          	sd	zero,0(a1)
    800045e0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800045e4:	c3bff0ef          	jal	8000421e <filealloc>
    800045e8:	e088                	sd	a0,0(s1)
    800045ea:	c549                	beqz	a0,80004674 <pipealloc+0xa8>
    800045ec:	c33ff0ef          	jal	8000421e <filealloc>
    800045f0:	00aa3023          	sd	a0,0(s4)
    800045f4:	cd25                	beqz	a0,8000466c <pipealloc+0xa0>
    800045f6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800045f8:	d2cfc0ef          	jal	80000b24 <kalloc>
    800045fc:	892a                	mv	s2,a0
    800045fe:	c12d                	beqz	a0,80004660 <pipealloc+0x94>
    80004600:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004602:	4985                	li	s3,1
    80004604:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004608:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000460c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004610:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004614:	00003597          	auipc	a1,0x3
    80004618:	ff458593          	addi	a1,a1,-12 # 80007608 <etext+0x608>
    8000461c:	d58fc0ef          	jal	80000b74 <initlock>
  (*f0)->type = FD_PIPE;
    80004620:	609c                	ld	a5,0(s1)
    80004622:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004626:	609c                	ld	a5,0(s1)
    80004628:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000462c:	609c                	ld	a5,0(s1)
    8000462e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004632:	609c                	ld	a5,0(s1)
    80004634:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004638:	000a3783          	ld	a5,0(s4)
    8000463c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004640:	000a3783          	ld	a5,0(s4)
    80004644:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004648:	000a3783          	ld	a5,0(s4)
    8000464c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004650:	000a3783          	ld	a5,0(s4)
    80004654:	0127b823          	sd	s2,16(a5)
  return 0;
    80004658:	4501                	li	a0,0
    8000465a:	6942                	ld	s2,16(sp)
    8000465c:	69a2                	ld	s3,8(sp)
    8000465e:	a01d                	j	80004684 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004660:	6088                	ld	a0,0(s1)
    80004662:	c119                	beqz	a0,80004668 <pipealloc+0x9c>
    80004664:	6942                	ld	s2,16(sp)
    80004666:	a029                	j	80004670 <pipealloc+0xa4>
    80004668:	6942                	ld	s2,16(sp)
    8000466a:	a029                	j	80004674 <pipealloc+0xa8>
    8000466c:	6088                	ld	a0,0(s1)
    8000466e:	c10d                	beqz	a0,80004690 <pipealloc+0xc4>
    fileclose(*f0);
    80004670:	c53ff0ef          	jal	800042c2 <fileclose>
  if(*f1)
    80004674:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004678:	557d                	li	a0,-1
  if(*f1)
    8000467a:	c789                	beqz	a5,80004684 <pipealloc+0xb8>
    fileclose(*f1);
    8000467c:	853e                	mv	a0,a5
    8000467e:	c45ff0ef          	jal	800042c2 <fileclose>
  return -1;
    80004682:	557d                	li	a0,-1
}
    80004684:	70a2                	ld	ra,40(sp)
    80004686:	7402                	ld	s0,32(sp)
    80004688:	64e2                	ld	s1,24(sp)
    8000468a:	6a02                	ld	s4,0(sp)
    8000468c:	6145                	addi	sp,sp,48
    8000468e:	8082                	ret
  return -1;
    80004690:	557d                	li	a0,-1
    80004692:	bfcd                	j	80004684 <pipealloc+0xb8>

0000000080004694 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004694:	1101                	addi	sp,sp,-32
    80004696:	ec06                	sd	ra,24(sp)
    80004698:	e822                	sd	s0,16(sp)
    8000469a:	e426                	sd	s1,8(sp)
    8000469c:	e04a                	sd	s2,0(sp)
    8000469e:	1000                	addi	s0,sp,32
    800046a0:	84aa                	mv	s1,a0
    800046a2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800046a4:	d50fc0ef          	jal	80000bf4 <acquire>
  if(writable){
    800046a8:	02090763          	beqz	s2,800046d6 <pipeclose+0x42>
    pi->writeopen = 0;
    800046ac:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800046b0:	21848513          	addi	a0,s1,536
    800046b4:	905fd0ef          	jal	80001fb8 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800046b8:	2204b783          	ld	a5,544(s1)
    800046bc:	e785                	bnez	a5,800046e4 <pipeclose+0x50>
    release(&pi->lock);
    800046be:	8526                	mv	a0,s1
    800046c0:	dccfc0ef          	jal	80000c8c <release>
    kfree((char*)pi);
    800046c4:	8526                	mv	a0,s1
    800046c6:	b7cfc0ef          	jal	80000a42 <kfree>
  } else
    release(&pi->lock);
}
    800046ca:	60e2                	ld	ra,24(sp)
    800046cc:	6442                	ld	s0,16(sp)
    800046ce:	64a2                	ld	s1,8(sp)
    800046d0:	6902                	ld	s2,0(sp)
    800046d2:	6105                	addi	sp,sp,32
    800046d4:	8082                	ret
    pi->readopen = 0;
    800046d6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800046da:	21c48513          	addi	a0,s1,540
    800046de:	8dbfd0ef          	jal	80001fb8 <wakeup>
    800046e2:	bfd9                	j	800046b8 <pipeclose+0x24>
    release(&pi->lock);
    800046e4:	8526                	mv	a0,s1
    800046e6:	da6fc0ef          	jal	80000c8c <release>
}
    800046ea:	b7c5                	j	800046ca <pipeclose+0x36>

00000000800046ec <pipewrite>:


// pipewrite(), piperead() 모두 main_thread에서 pagetable을 참조하도록 한다.
int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800046ec:	711d                	addi	sp,sp,-96
    800046ee:	ec86                	sd	ra,88(sp)
    800046f0:	e8a2                	sd	s0,80(sp)
    800046f2:	e4a6                	sd	s1,72(sp)
    800046f4:	e0ca                	sd	s2,64(sp)
    800046f6:	fc4e                	sd	s3,56(sp)
    800046f8:	f852                	sd	s4,48(sp)
    800046fa:	f456                	sd	s5,40(sp)
    800046fc:	1080                	addi	s0,sp,96
    800046fe:	84aa                	mv	s1,a0
    80004700:	8aae                	mv	s5,a1
    80004702:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc()->isThread ? myproc()->main_thread : myproc();
    80004704:	a12fd0ef          	jal	80001916 <myproc>
    80004708:	17052783          	lw	a5,368(a0)
    8000470c:	c785                	beqz	a5,80004734 <pipewrite+0x48>
    8000470e:	a08fd0ef          	jal	80001916 <myproc>
    80004712:	18853983          	ld	s3,392(a0)

  acquire(&pi->lock);
    80004716:	8526                	mv	a0,s1
    80004718:	cdcfc0ef          	jal	80000bf4 <acquire>
  while(i < n){
    8000471c:	0b405e63          	blez	s4,800047d8 <pipewrite+0xec>
    80004720:	f05a                	sd	s6,32(sp)
    80004722:	ec5e                	sd	s7,24(sp)
    80004724:	e862                	sd	s8,16(sp)
  int i = 0;
    80004726:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004728:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000472a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000472e:	21c48b93          	addi	s7,s1,540
    80004732:	a83d                	j	80004770 <pipewrite+0x84>
  struct proc *pr = myproc()->isThread ? myproc()->main_thread : myproc();
    80004734:	9e2fd0ef          	jal	80001916 <myproc>
    80004738:	89aa                	mv	s3,a0
    8000473a:	bff1                	j	80004716 <pipewrite+0x2a>
      release(&pi->lock);
    8000473c:	8526                	mv	a0,s1
    8000473e:	d4efc0ef          	jal	80000c8c <release>
      return -1;
    80004742:	597d                	li	s2,-1
    80004744:	7b02                	ld	s6,32(sp)
    80004746:	6be2                	ld	s7,24(sp)
    80004748:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000474a:	854a                	mv	a0,s2
    8000474c:	60e6                	ld	ra,88(sp)
    8000474e:	6446                	ld	s0,80(sp)
    80004750:	64a6                	ld	s1,72(sp)
    80004752:	6906                	ld	s2,64(sp)
    80004754:	79e2                	ld	s3,56(sp)
    80004756:	7a42                	ld	s4,48(sp)
    80004758:	7aa2                	ld	s5,40(sp)
    8000475a:	6125                	addi	sp,sp,96
    8000475c:	8082                	ret
      wakeup(&pi->nread);
    8000475e:	8562                	mv	a0,s8
    80004760:	859fd0ef          	jal	80001fb8 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004764:	85a6                	mv	a1,s1
    80004766:	855e                	mv	a0,s7
    80004768:	805fd0ef          	jal	80001f6c <sleep>
  while(i < n){
    8000476c:	05495b63          	bge	s2,s4,800047c2 <pipewrite+0xd6>
    if(pi->readopen == 0 || killed(pr)){
    80004770:	2204a783          	lw	a5,544(s1)
    80004774:	d7e1                	beqz	a5,8000473c <pipewrite+0x50>
    80004776:	854e                	mv	a0,s3
    80004778:	aa3fd0ef          	jal	8000221a <killed>
    8000477c:	f161                	bnez	a0,8000473c <pipewrite+0x50>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000477e:	2184a783          	lw	a5,536(s1)
    80004782:	21c4a703          	lw	a4,540(s1)
    80004786:	2007879b          	addiw	a5,a5,512
    8000478a:	fcf70ae3          	beq	a4,a5,8000475e <pipewrite+0x72>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000478e:	4685                	li	a3,1
    80004790:	01590633          	add	a2,s2,s5
    80004794:	faf40593          	addi	a1,s0,-81
    80004798:	0509b503          	ld	a0,80(s3)
    8000479c:	ec3fc0ef          	jal	8000165e <copyin>
    800047a0:	03650e63          	beq	a0,s6,800047dc <pipewrite+0xf0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800047a4:	21c4a783          	lw	a5,540(s1)
    800047a8:	0017871b          	addiw	a4,a5,1
    800047ac:	20e4ae23          	sw	a4,540(s1)
    800047b0:	1ff7f793          	andi	a5,a5,511
    800047b4:	97a6                	add	a5,a5,s1
    800047b6:	faf44703          	lbu	a4,-81(s0)
    800047ba:	00e78c23          	sb	a4,24(a5)
      i++;
    800047be:	2905                	addiw	s2,s2,1
    800047c0:	b775                	j	8000476c <pipewrite+0x80>
    800047c2:	7b02                	ld	s6,32(sp)
    800047c4:	6be2                	ld	s7,24(sp)
    800047c6:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    800047c8:	21848513          	addi	a0,s1,536
    800047cc:	fecfd0ef          	jal	80001fb8 <wakeup>
  release(&pi->lock);
    800047d0:	8526                	mv	a0,s1
    800047d2:	cbafc0ef          	jal	80000c8c <release>
  return i;
    800047d6:	bf95                	j	8000474a <pipewrite+0x5e>
  int i = 0;
    800047d8:	4901                	li	s2,0
    800047da:	b7fd                	j	800047c8 <pipewrite+0xdc>
    800047dc:	7b02                	ld	s6,32(sp)
    800047de:	6be2                	ld	s7,24(sp)
    800047e0:	6c42                	ld	s8,16(sp)
    800047e2:	b7dd                	j	800047c8 <pipewrite+0xdc>

00000000800047e4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800047e4:	715d                	addi	sp,sp,-80
    800047e6:	e486                	sd	ra,72(sp)
    800047e8:	e0a2                	sd	s0,64(sp)
    800047ea:	fc26                	sd	s1,56(sp)
    800047ec:	f84a                	sd	s2,48(sp)
    800047ee:	f44e                	sd	s3,40(sp)
    800047f0:	f052                	sd	s4,32(sp)
    800047f2:	ec56                	sd	s5,24(sp)
    800047f4:	0880                	addi	s0,sp,80
    800047f6:	84aa                	mv	s1,a0
    800047f8:	892e                	mv	s2,a1
    800047fa:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc()->isThread ? myproc()->main_thread : myproc();
    800047fc:	91afd0ef          	jal	80001916 <myproc>
    80004800:	17052783          	lw	a5,368(a0)
    80004804:	c3b9                	beqz	a5,8000484a <piperead+0x66>
    80004806:	910fd0ef          	jal	80001916 <myproc>
    8000480a:	18853a03          	ld	s4,392(a0)
  char ch;

  acquire(&pi->lock);
    8000480e:	8526                	mv	a0,s1
    80004810:	be4fc0ef          	jal	80000bf4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004814:	2184a703          	lw	a4,536(s1)
    80004818:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000481c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004820:	02f71963          	bne	a4,a5,80004852 <piperead+0x6e>
    80004824:	2244a783          	lw	a5,548(s1)
    80004828:	cf85                	beqz	a5,80004860 <piperead+0x7c>
    if(killed(pr)){
    8000482a:	8552                	mv	a0,s4
    8000482c:	9effd0ef          	jal	8000221a <killed>
    80004830:	e11d                	bnez	a0,80004856 <piperead+0x72>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004832:	85a6                	mv	a1,s1
    80004834:	854e                	mv	a0,s3
    80004836:	f36fd0ef          	jal	80001f6c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000483a:	2184a703          	lw	a4,536(s1)
    8000483e:	21c4a783          	lw	a5,540(s1)
    80004842:	fef701e3          	beq	a4,a5,80004824 <piperead+0x40>
    80004846:	e85a                	sd	s6,16(sp)
    80004848:	a829                	j	80004862 <piperead+0x7e>
  struct proc *pr = myproc()->isThread ? myproc()->main_thread : myproc();
    8000484a:	8ccfd0ef          	jal	80001916 <myproc>
    8000484e:	8a2a                	mv	s4,a0
    80004850:	bf7d                	j	8000480e <piperead+0x2a>
    80004852:	e85a                	sd	s6,16(sp)
    80004854:	a039                	j	80004862 <piperead+0x7e>
      release(&pi->lock);
    80004856:	8526                	mv	a0,s1
    80004858:	c34fc0ef          	jal	80000c8c <release>
      return -1;
    8000485c:	59fd                	li	s3,-1
    8000485e:	a8b1                	j	800048ba <piperead+0xd6>
    80004860:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004862:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004864:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004866:	05505263          	blez	s5,800048aa <piperead+0xc6>
    if(pi->nread == pi->nwrite)
    8000486a:	2184a783          	lw	a5,536(s1)
    8000486e:	21c4a703          	lw	a4,540(s1)
    80004872:	02f70c63          	beq	a4,a5,800048aa <piperead+0xc6>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004876:	0017871b          	addiw	a4,a5,1
    8000487a:	20e4ac23          	sw	a4,536(s1)
    8000487e:	1ff7f793          	andi	a5,a5,511
    80004882:	97a6                	add	a5,a5,s1
    80004884:	0187c783          	lbu	a5,24(a5)
    80004888:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000488c:	4685                	li	a3,1
    8000488e:	fbf40613          	addi	a2,s0,-65
    80004892:	85ca                	mv	a1,s2
    80004894:	050a3503          	ld	a0,80(s4)
    80004898:	cf1fc0ef          	jal	80001588 <copyout>
    8000489c:	01650763          	beq	a0,s6,800048aa <piperead+0xc6>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800048a0:	2985                	addiw	s3,s3,1
    800048a2:	0905                	addi	s2,s2,1
    800048a4:	fd3a93e3          	bne	s5,s3,8000486a <piperead+0x86>
    800048a8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800048aa:	21c48513          	addi	a0,s1,540
    800048ae:	f0afd0ef          	jal	80001fb8 <wakeup>
  release(&pi->lock);
    800048b2:	8526                	mv	a0,s1
    800048b4:	bd8fc0ef          	jal	80000c8c <release>
    800048b8:	6b42                	ld	s6,16(sp)
  return i;
}
    800048ba:	854e                	mv	a0,s3
    800048bc:	60a6                	ld	ra,72(sp)
    800048be:	6406                	ld	s0,64(sp)
    800048c0:	74e2                	ld	s1,56(sp)
    800048c2:	7942                	ld	s2,48(sp)
    800048c4:	79a2                	ld	s3,40(sp)
    800048c6:	7a02                	ld	s4,32(sp)
    800048c8:	6ae2                	ld	s5,24(sp)
    800048ca:	6161                	addi	sp,sp,80
    800048cc:	8082                	ret

00000000800048ce <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800048ce:	1141                	addi	sp,sp,-16
    800048d0:	e422                	sd	s0,8(sp)
    800048d2:	0800                	addi	s0,sp,16
    800048d4:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800048d6:	8905                	andi	a0,a0,1
    800048d8:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    800048da:	8b89                	andi	a5,a5,2
    800048dc:	c399                	beqz	a5,800048e2 <flags2perm+0x14>
      perm |= PTE_W;
    800048de:	00456513          	ori	a0,a0,4
    return perm;
}
    800048e2:	6422                	ld	s0,8(sp)
    800048e4:	0141                	addi	sp,sp,16
    800048e6:	8082                	ret

00000000800048e8 <exec>:

int
exec(char *path, char **argv)
{
    800048e8:	de010113          	addi	sp,sp,-544
    800048ec:	20113c23          	sd	ra,536(sp)
    800048f0:	20813823          	sd	s0,528(sp)
    800048f4:	20913423          	sd	s1,520(sp)
    800048f8:	21213023          	sd	s2,512(sp)
    800048fc:	ffce                	sd	s3,504(sp)
    800048fe:	fbd2                	sd	s4,496(sp)
    80004900:	f7d6                	sd	s5,488(sp)
    80004902:	f3da                	sd	s6,480(sp)
    80004904:	1400                	addi	s0,sp,544
    80004906:	e0a43423          	sd	a0,-504(s0)
    8000490a:	deb43823          	sd	a1,-528(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000490e:	808fd0ef          	jal	80001916 <myproc>
    80004912:	892a                	mv	s2,a0
  struct proc *t;
  struct proc *main = p->isThread ? p->main_thread : p;
    80004914:	17052783          	lw	a5,368(a0)
  int i, off, pagetable_changed_allowed = 1;
    80004918:	4705                	li	a4,1
    8000491a:	dee43c23          	sd	a4,-520(s0)
  struct proc *main = p->isThread ? p->main_thread : p;
    8000491e:	c3c1                	beqz	a5,8000499e <exec+0xb6>
    80004920:	18853983          	ld	s3,392(a0)


  // exec을 호출한 thread를 main_thread로 변화
  if (p != main) {
    80004924:	09350963          	beq	a0,s3,800049b6 <exec+0xce>
    pagetable_changed_allowed = 0;

    for (t = proc; t < &proc[NPROC]; t++) {
    80004928:	0000e497          	auipc	s1,0xe
    8000492c:	f9848493          	addi	s1,s1,-104 # 800128c0 <proc>
        t->parent = p;
      }
      else if (t == p->main_thread) {
        t->main_thread = p;
        t->parent = p;
        t->isThread = 1;
    80004930:	4a85                	li	s5,1
    for (t = proc; t < &proc[NPROC]; t++) {
    80004932:	00014a17          	auipc	s4,0x14
    80004936:	38ea0a13          	addi	s4,s4,910 # 80018cc0 <tickslock>
    8000493a:	a80d                	j	8000496c <exec+0x84>
      if (t->main_thread == main && t != p) {
    8000493c:	02990163          	beq	s2,s1,8000495e <exec+0x76>
        t->main_thread = p;
    80004940:	1924b423          	sd	s2,392(s1)
        t->parent = p;
    80004944:	0324bc23          	sd	s2,56(s1)
    80004948:	a819                	j	8000495e <exec+0x76>
        t->main_thread = p;
    8000494a:	1924b423          	sd	s2,392(s1)
        t->parent = p;
    8000494e:	0324bc23          	sd	s2,56(s1)
        t->isThread = 1;
    80004952:	1754a823          	sw	s5,368(s1)
        t->tid = p->tid;
    80004956:	17492783          	lw	a5,372(s2)
    8000495a:	16f4aa23          	sw	a5,372(s1)
      }

      release(&t->lock);
    8000495e:	8526                	mv	a0,s1
    80004960:	b2cfc0ef          	jal	80000c8c <release>
    for (t = proc; t < &proc[NPROC]; t++) {
    80004964:	19048493          	addi	s1,s1,400
    80004968:	01448e63          	beq	s1,s4,80004984 <exec+0x9c>
      acquire(&t->lock);
    8000496c:	8526                	mv	a0,s1
    8000496e:	a86fc0ef          	jal	80000bf4 <acquire>
      if (t->main_thread == main && t != p) {
    80004972:	1884b783          	ld	a5,392(s1)
    80004976:	fd3783e3          	beq	a5,s3,8000493c <exec+0x54>
      else if (t == p->main_thread) {
    8000497a:	18893783          	ld	a5,392(s2)
    8000497e:	fe9790e3          	bne	a5,s1,8000495e <exec+0x76>
    80004982:	b7e1                	j	8000494a <exec+0x62>
    }

    p->sz = main->sz;
    80004984:	0489b783          	ld	a5,72(s3)
    80004988:	04f93423          	sd	a5,72(s2)
    p->isThread = 0;
    8000498c:	16092823          	sw	zero,368(s2)
    p->main_thread = 0;
    80004990:	18093423          	sd	zero,392(s2)
    p->tid = 1;
    80004994:	4785                	li	a5,1
    80004996:	16f92a23          	sw	a5,372(s2)
    pagetable_changed_allowed = 0;
    8000499a:	de043c23          	sd	zero,-520(s0)
  }

  for (t = proc; t < &proc[NPROC]; t++) {
    8000499e:	0000e497          	auipc	s1,0xe
    800049a2:	f2248493          	addi	s1,s1,-222 # 800128c0 <proc>
    if (t == p) continue;

    acquire(&t->lock);
    if ((t->isThread == 1 && t->main_thread == p&& t->state != UNUSED && t->state != ZOMBIE)) {
    800049a6:	4a05                	li	s4,1
    800049a8:	4a95                	li	s5,5
      t->killed = 1;
      if (t->state == SLEEPING) {
    800049aa:	4b09                	li	s6,2
  for (t = proc; t < &proc[NPROC]; t++) {
    800049ac:	00014997          	auipc	s3,0x14
    800049b0:	31498993          	addi	s3,s3,788 # 80018cc0 <tickslock>
    800049b4:	a831                	j	800049d0 <exec+0xe8>
  int i, off, pagetable_changed_allowed = 1;
    800049b6:	4785                	li	a5,1
    800049b8:	def43c23          	sd	a5,-520(s0)
    800049bc:	b7cd                	j	8000499e <exec+0xb6>
        t->state = RUNNABLE;
    800049be:	478d                	li	a5,3
    800049c0:	cc9c                	sw	a5,24(s1)
      }
    }
    release(&t->lock);
    800049c2:	8526                	mv	a0,s1
    800049c4:	ac8fc0ef          	jal	80000c8c <release>
  for (t = proc; t < &proc[NPROC]; t++) {
    800049c8:	19048493          	addi	s1,s1,400
    800049cc:	03348863          	beq	s1,s3,800049fc <exec+0x114>
    if (t == p) continue;
    800049d0:	fe990ce3          	beq	s2,s1,800049c8 <exec+0xe0>
    acquire(&t->lock);
    800049d4:	8526                	mv	a0,s1
    800049d6:	a1efc0ef          	jal	80000bf4 <acquire>
    if ((t->isThread == 1 && t->main_thread == p&& t->state != UNUSED && t->state != ZOMBIE)) {
    800049da:	1704a783          	lw	a5,368(s1)
    800049de:	ff4792e3          	bne	a5,s4,800049c2 <exec+0xda>
    800049e2:	1884b783          	ld	a5,392(s1)
    800049e6:	fd279ee3          	bne	a5,s2,800049c2 <exec+0xda>
    800049ea:	4c9c                	lw	a5,24(s1)
    800049ec:	dbf9                	beqz	a5,800049c2 <exec+0xda>
    800049ee:	fd578ae3          	beq	a5,s5,800049c2 <exec+0xda>
      t->killed = 1;
    800049f2:	0344a423          	sw	s4,40(s1)
      if (t->state == SLEEPING) {
    800049f6:	fd6796e3          	bne	a5,s6,800049c2 <exec+0xda>
    800049fa:	b7d1                	j	800049be <exec+0xd6>
  }
  
  begin_op();
    800049fc:	cacff0ef          	jal	80003ea8 <begin_op>

  if((ip = namei(path)) == 0){
    80004a00:	e0843503          	ld	a0,-504(s0)
    80004a04:	ae8ff0ef          	jal	80003cec <namei>
    80004a08:	8a2a                	mv	s4,a0
    80004a0a:	cd29                	beqz	a0,80004a64 <exec+0x17c>
    end_op();
    return -1;
  }
  ilock(ip);
    80004a0c:	c07fe0ef          	jal	80003612 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004a10:	04000713          	li	a4,64
    80004a14:	4681                	li	a3,0
    80004a16:	e5040613          	addi	a2,s0,-432
    80004a1a:	4581                	li	a1,0
    80004a1c:	8552                	mv	a0,s4
    80004a1e:	e49fe0ef          	jal	80003866 <readi>
    80004a22:	04000793          	li	a5,64
    80004a26:	00f51a63          	bne	a0,a5,80004a3a <exec+0x152>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004a2a:	e5042703          	lw	a4,-432(s0)
    80004a2e:	464c47b7          	lui	a5,0x464c4
    80004a32:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004a36:	02f70b63          	beq	a4,a5,80004a6c <exec+0x184>

 bad:
  if(pagetable) 
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004a3a:	8552                	mv	a0,s4
    80004a3c:	de1fe0ef          	jal	8000381c <iunlockput>
    end_op();
    80004a40:	cd2ff0ef          	jal	80003f12 <end_op>
  }
  return -1;
    80004a44:	557d                	li	a0,-1
}
    80004a46:	21813083          	ld	ra,536(sp)
    80004a4a:	21013403          	ld	s0,528(sp)
    80004a4e:	20813483          	ld	s1,520(sp)
    80004a52:	20013903          	ld	s2,512(sp)
    80004a56:	79fe                	ld	s3,504(sp)
    80004a58:	7a5e                	ld	s4,496(sp)
    80004a5a:	7abe                	ld	s5,488(sp)
    80004a5c:	7b1e                	ld	s6,480(sp)
    80004a5e:	22010113          	addi	sp,sp,544
    80004a62:	8082                	ret
    end_op();
    80004a64:	caeff0ef          	jal	80003f12 <end_op>
    return -1;
    80004a68:	557d                	li	a0,-1
    80004a6a:	bff1                	j	80004a46 <exec+0x15e>
  if((pagetable = proc_pagetable(p)) == 0)
    80004a6c:	854a                	mv	a0,s2
    80004a6e:	f51fc0ef          	jal	800019be <proc_pagetable>
    80004a72:	8b2a                	mv	s6,a0
    80004a74:	d179                	beqz	a0,80004a3a <exec+0x152>
    80004a76:	efde                	sd	s7,472(sp)
    80004a78:	ebe2                	sd	s8,464(sp)
    80004a7a:	e7e6                	sd	s9,456(sp)
    80004a7c:	e3ea                	sd	s10,448(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004a7e:	e7042d03          	lw	s10,-400(s0)
    80004a82:	e8845783          	lhu	a5,-376(s0)
    80004a86:	12078863          	beqz	a5,80004bb6 <exec+0x2ce>
    80004a8a:	ff6e                	sd	s11,440(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004a8c:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004a8e:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004a90:	6c85                	lui	s9,0x1
    80004a92:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004a96:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004a9a:	6a85                	lui	s5,0x1
    80004a9c:	a085                	j	80004afc <exec+0x214>
      panic("loadseg: address should exist");
    80004a9e:	00003517          	auipc	a0,0x3
    80004aa2:	b7250513          	addi	a0,a0,-1166 # 80007610 <etext+0x610>
    80004aa6:	ceffb0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    80004aaa:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004aac:	8726                	mv	a4,s1
    80004aae:	012c06bb          	addw	a3,s8,s2
    80004ab2:	4581                	li	a1,0
    80004ab4:	8552                	mv	a0,s4
    80004ab6:	db1fe0ef          	jal	80003866 <readi>
    80004aba:	2501                	sext.w	a0,a0
    80004abc:	24a49763          	bne	s1,a0,80004d0a <exec+0x422>
  for(i = 0; i < sz; i += PGSIZE){
    80004ac0:	012a893b          	addw	s2,s5,s2
    80004ac4:	03397363          	bgeu	s2,s3,80004aea <exec+0x202>
    pa = walkaddr(pagetable, va + i);
    80004ac8:	02091593          	slli	a1,s2,0x20
    80004acc:	9181                	srli	a1,a1,0x20
    80004ace:	95de                	add	a1,a1,s7
    80004ad0:	855a                	mv	a0,s6
    80004ad2:	d3afc0ef          	jal	8000100c <walkaddr>
    80004ad6:	862a                	mv	a2,a0
    if(pa == 0)
    80004ad8:	d179                	beqz	a0,80004a9e <exec+0x1b6>
    if(sz - i < PGSIZE)
    80004ada:	412984bb          	subw	s1,s3,s2
    80004ade:	0004879b          	sext.w	a5,s1
    80004ae2:	fcfcf4e3          	bgeu	s9,a5,80004aaa <exec+0x1c2>
    80004ae6:	84d6                	mv	s1,s5
    80004ae8:	b7c9                	j	80004aaa <exec+0x1c2>
    sz = sz1;
    80004aea:	e0043903          	ld	s2,-512(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004aee:	2d85                	addiw	s11,s11,1
    80004af0:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80004af4:	e8845783          	lhu	a5,-376(s0)
    80004af8:	08fdd063          	bge	s11,a5,80004b78 <exec+0x290>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004afc:	2d01                	sext.w	s10,s10
    80004afe:	03800713          	li	a4,56
    80004b02:	86ea                	mv	a3,s10
    80004b04:	e1840613          	addi	a2,s0,-488
    80004b08:	4581                	li	a1,0
    80004b0a:	8552                	mv	a0,s4
    80004b0c:	d5bfe0ef          	jal	80003866 <readi>
    80004b10:	03800793          	li	a5,56
    80004b14:	1cf51363          	bne	a0,a5,80004cda <exec+0x3f2>
    if(ph.type != ELF_PROG_LOAD)
    80004b18:	e1842783          	lw	a5,-488(s0)
    80004b1c:	4705                	li	a4,1
    80004b1e:	fce798e3          	bne	a5,a4,80004aee <exec+0x206>
    if(ph.memsz < ph.filesz)
    80004b22:	e4043483          	ld	s1,-448(s0)
    80004b26:	e3843783          	ld	a5,-456(s0)
    80004b2a:	1af4ec63          	bltu	s1,a5,80004ce2 <exec+0x3fa>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004b2e:	e2843783          	ld	a5,-472(s0)
    80004b32:	94be                	add	s1,s1,a5
    80004b34:	1af4eb63          	bltu	s1,a5,80004cea <exec+0x402>
    if(ph.vaddr % PGSIZE != 0)
    80004b38:	de843703          	ld	a4,-536(s0)
    80004b3c:	8ff9                	and	a5,a5,a4
    80004b3e:	1a079a63          	bnez	a5,80004cf2 <exec+0x40a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004b42:	e1c42503          	lw	a0,-484(s0)
    80004b46:	d89ff0ef          	jal	800048ce <flags2perm>
    80004b4a:	86aa                	mv	a3,a0
    80004b4c:	8626                	mv	a2,s1
    80004b4e:	85ca                	mv	a1,s2
    80004b50:	855a                	mv	a0,s6
    80004b52:	823fc0ef          	jal	80001374 <uvmalloc>
    80004b56:	e0a43023          	sd	a0,-512(s0)
    80004b5a:	1a050063          	beqz	a0,80004cfa <exec+0x412>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004b5e:	e2843b83          	ld	s7,-472(s0)
    80004b62:	e2042c03          	lw	s8,-480(s0)
    80004b66:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004b6a:	00098463          	beqz	s3,80004b72 <exec+0x28a>
    80004b6e:	4901                	li	s2,0
    80004b70:	bfa1                	j	80004ac8 <exec+0x1e0>
    sz = sz1;
    80004b72:	e0043903          	ld	s2,-512(s0)
    80004b76:	bfa5                	j	80004aee <exec+0x206>
    80004b78:	7dfa                	ld	s11,440(sp)
  iunlockput(ip);
    80004b7a:	8552                	mv	a0,s4
    80004b7c:	ca1fe0ef          	jal	8000381c <iunlockput>
  end_op();
    80004b80:	b92ff0ef          	jal	80003f12 <end_op>
  p = myproc();
    80004b84:	d93fc0ef          	jal	80001916 <myproc>
    80004b88:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    80004b8a:	04853a83          	ld	s5,72(a0)
  sz = PGROUNDUP(sz);
    80004b8e:	6485                	lui	s1,0x1
    80004b90:	14fd                	addi	s1,s1,-1 # fff <_entry-0x7ffff001>
    80004b92:	94ca                	add	s1,s1,s2
    80004b94:	77fd                	lui	a5,0xfffff
    80004b96:	8cfd                	and	s1,s1,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004b98:	4691                	li	a3,4
    80004b9a:	6609                	lui	a2,0x2
    80004b9c:	9626                	add	a2,a2,s1
    80004b9e:	85a6                	mv	a1,s1
    80004ba0:	855a                	mv	a0,s6
    80004ba2:	fd2fc0ef          	jal	80001374 <uvmalloc>
    80004ba6:	892a                	mv	s2,a0
    80004ba8:	e0a43023          	sd	a0,-512(s0)
    80004bac:	e519                	bnez	a0,80004bba <exec+0x2d2>
  sz = PGROUNDUP(sz);
    80004bae:	e0943023          	sd	s1,-512(s0)
  if(pagetable) 
    80004bb2:	4a01                	li	s4,0
    80004bb4:	aaa1                	j	80004d0c <exec+0x424>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004bb6:	4901                	li	s2,0
    80004bb8:	b7c9                	j	80004b7a <exec+0x292>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004bba:	75f9                	lui	a1,0xffffe
    80004bbc:	95aa                	add	a1,a1,a0
    80004bbe:	855a                	mv	a0,s6
    80004bc0:	99ffc0ef          	jal	8000155e <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004bc4:	7a7d                	lui	s4,0xfffff
    80004bc6:	9a4a                	add	s4,s4,s2
  for(argc = 0; argv[argc]; argc++) {
    80004bc8:	df043783          	ld	a5,-528(s0)
    80004bcc:	6388                	ld	a0,0(a5)
    80004bce:	cd39                	beqz	a0,80004c2c <exec+0x344>
    80004bd0:	e9040b93          	addi	s7,s0,-368
    80004bd4:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004bd6:	a62fc0ef          	jal	80000e38 <strlen>
    80004bda:	0015079b          	addiw	a5,a0,1
    80004bde:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004be2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004be6:	11496e63          	bltu	s2,s4,80004d02 <exec+0x41a>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004bea:	df043c83          	ld	s9,-528(s0)
    80004bee:	000cbc03          	ld	s8,0(s9)
    80004bf2:	8562                	mv	a0,s8
    80004bf4:	a44fc0ef          	jal	80000e38 <strlen>
    80004bf8:	0015069b          	addiw	a3,a0,1
    80004bfc:	8662                	mv	a2,s8
    80004bfe:	85ca                	mv	a1,s2
    80004c00:	855a                	mv	a0,s6
    80004c02:	987fc0ef          	jal	80001588 <copyout>
    80004c06:	10054063          	bltz	a0,80004d06 <exec+0x41e>
    ustack[argc] = sp;
    80004c0a:	012bb023          	sd	s2,0(s7)
  for(argc = 0; argv[argc]; argc++) {
    80004c0e:	0485                	addi	s1,s1,1
    80004c10:	008c8793          	addi	a5,s9,8
    80004c14:	def43823          	sd	a5,-528(s0)
    80004c18:	008cb503          	ld	a0,8(s9)
    80004c1c:	c919                	beqz	a0,80004c32 <exec+0x34a>
    if(argc >= MAXARG)
    80004c1e:	0ba1                	addi	s7,s7,8
    80004c20:	f9040793          	addi	a5,s0,-112
    80004c24:	fafb99e3          	bne	s7,a5,80004bd6 <exec+0x2ee>
  ip = 0;
    80004c28:	4a01                	li	s4,0
    80004c2a:	a0cd                	j	80004d0c <exec+0x424>
  sp = sz;
    80004c2c:	e0043903          	ld	s2,-512(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004c30:	4481                	li	s1,0
  ustack[argc] = 0;
    80004c32:	00349793          	slli	a5,s1,0x3
    80004c36:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffdaef0>
    80004c3a:	97a2                	add	a5,a5,s0
    80004c3c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004c40:	00148693          	addi	a3,s1,1
    80004c44:	068e                	slli	a3,a3,0x3
    80004c46:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004c4a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    80004c4e:	f74962e3          	bltu	s2,s4,80004bb2 <exec+0x2ca>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004c52:	e9040613          	addi	a2,s0,-368
    80004c56:	85ca                	mv	a1,s2
    80004c58:	855a                	mv	a0,s6
    80004c5a:	92ffc0ef          	jal	80001588 <copyout>
    80004c5e:	f4054ae3          	bltz	a0,80004bb2 <exec+0x2ca>
  p->trapframe->a1 = sp;
    80004c62:	0609b783          	ld	a5,96(s3)
    80004c66:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004c6a:	e0843783          	ld	a5,-504(s0)
    80004c6e:	0007c703          	lbu	a4,0(a5)
    80004c72:	cf11                	beqz	a4,80004c8e <exec+0x3a6>
    80004c74:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004c76:	02f00693          	li	a3,47
    80004c7a:	a029                	j	80004c84 <exec+0x39c>
  for(last=s=path; *s; s++)
    80004c7c:	0785                	addi	a5,a5,1
    80004c7e:	fff7c703          	lbu	a4,-1(a5)
    80004c82:	c711                	beqz	a4,80004c8e <exec+0x3a6>
    if(*s == '/')
    80004c84:	fed71ce3          	bne	a4,a3,80004c7c <exec+0x394>
      last = s+1;
    80004c88:	e0f43423          	sd	a5,-504(s0)
    80004c8c:	bfc5                	j	80004c7c <exec+0x394>
  safestrcpy(p->name, last, sizeof(p->name));
    80004c8e:	4641                	li	a2,16
    80004c90:	e0843583          	ld	a1,-504(s0)
    80004c94:	16098513          	addi	a0,s3,352
    80004c98:	96efc0ef          	jal	80000e06 <safestrcpy>
  oldpagetable = p->pagetable;
    80004c9c:	0509b503          	ld	a0,80(s3)
  p->pagetable = pagetable;
    80004ca0:	0569b823          	sd	s6,80(s3)
  p->sz = sz;
    80004ca4:	e0043783          	ld	a5,-512(s0)
    80004ca8:	04f9b423          	sd	a5,72(s3)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004cac:	0609b783          	ld	a5,96(s3)
    80004cb0:	e6843703          	ld	a4,-408(s0)
    80004cb4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004cb6:	0609b783          	ld	a5,96(s3)
    80004cba:	0327b823          	sd	s2,48(a5)
  if (pagetable_changed_allowed) proc_freepagetable(oldpagetable, oldsz);
    80004cbe:	df843783          	ld	a5,-520(s0)
    80004cc2:	eb81                	bnez	a5,80004cd2 <exec+0x3ea>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004cc4:	0004851b          	sext.w	a0,s1
    80004cc8:	6bfe                	ld	s7,472(sp)
    80004cca:	6c5e                	ld	s8,464(sp)
    80004ccc:	6cbe                	ld	s9,456(sp)
    80004cce:	6d1e                	ld	s10,448(sp)
    80004cd0:	bb9d                	j	80004a46 <exec+0x15e>
  if (pagetable_changed_allowed) proc_freepagetable(oldpagetable, oldsz);
    80004cd2:	85d6                	mv	a1,s5
    80004cd4:	d73fc0ef          	jal	80001a46 <proc_freepagetable>
    80004cd8:	b7f5                	j	80004cc4 <exec+0x3dc>
    80004cda:	e1243023          	sd	s2,-512(s0)
    80004cde:	7dfa                	ld	s11,440(sp)
    80004ce0:	a035                	j	80004d0c <exec+0x424>
    80004ce2:	e1243023          	sd	s2,-512(s0)
    80004ce6:	7dfa                	ld	s11,440(sp)
    80004ce8:	a015                	j	80004d0c <exec+0x424>
    80004cea:	e1243023          	sd	s2,-512(s0)
    80004cee:	7dfa                	ld	s11,440(sp)
    80004cf0:	a831                	j	80004d0c <exec+0x424>
    80004cf2:	e1243023          	sd	s2,-512(s0)
    80004cf6:	7dfa                	ld	s11,440(sp)
    80004cf8:	a811                	j	80004d0c <exec+0x424>
    80004cfa:	e1243023          	sd	s2,-512(s0)
    80004cfe:	7dfa                	ld	s11,440(sp)
    80004d00:	a031                	j	80004d0c <exec+0x424>
  ip = 0;
    80004d02:	4a01                	li	s4,0
    80004d04:	a021                	j	80004d0c <exec+0x424>
    80004d06:	4a01                	li	s4,0
  if(pagetable) 
    80004d08:	a011                	j	80004d0c <exec+0x424>
    80004d0a:	7dfa                	ld	s11,440(sp)
    proc_freepagetable(pagetable, sz);
    80004d0c:	e0043583          	ld	a1,-512(s0)
    80004d10:	855a                	mv	a0,s6
    80004d12:	d35fc0ef          	jal	80001a46 <proc_freepagetable>
  return -1;
    80004d16:	557d                	li	a0,-1
  if(ip){
    80004d18:	000a1763          	bnez	s4,80004d26 <exec+0x43e>
    80004d1c:	6bfe                	ld	s7,472(sp)
    80004d1e:	6c5e                	ld	s8,464(sp)
    80004d20:	6cbe                	ld	s9,456(sp)
    80004d22:	6d1e                	ld	s10,448(sp)
    80004d24:	b30d                	j	80004a46 <exec+0x15e>
    80004d26:	6bfe                	ld	s7,472(sp)
    80004d28:	6c5e                	ld	s8,464(sp)
    80004d2a:	6cbe                	ld	s9,456(sp)
    80004d2c:	6d1e                	ld	s10,448(sp)
    80004d2e:	b331                	j	80004a3a <exec+0x152>

0000000080004d30 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004d30:	7179                	addi	sp,sp,-48
    80004d32:	f406                	sd	ra,40(sp)
    80004d34:	f022                	sd	s0,32(sp)
    80004d36:	ec26                	sd	s1,24(sp)
    80004d38:	e84a                	sd	s2,16(sp)
    80004d3a:	1800                	addi	s0,sp,48
    80004d3c:	892e                	mv	s2,a1
    80004d3e:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004d40:	fdc40593          	addi	a1,s0,-36
    80004d44:	e1ffd0ef          	jal	80002b62 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004d48:	fdc42703          	lw	a4,-36(s0)
    80004d4c:	47bd                	li	a5,15
    80004d4e:	02e7e963          	bltu	a5,a4,80004d80 <argfd+0x50>
    80004d52:	bc5fc0ef          	jal	80001916 <myproc>
    80004d56:	fdc42703          	lw	a4,-36(s0)
    80004d5a:	01a70793          	addi	a5,a4,26
    80004d5e:	078e                	slli	a5,a5,0x3
    80004d60:	953e                	add	a0,a0,a5
    80004d62:	651c                	ld	a5,8(a0)
    80004d64:	c385                	beqz	a5,80004d84 <argfd+0x54>
    return -1;
  if(pfd)
    80004d66:	00090463          	beqz	s2,80004d6e <argfd+0x3e>
    *pfd = fd;
    80004d6a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004d6e:	4501                	li	a0,0
  if(pf)
    80004d70:	c091                	beqz	s1,80004d74 <argfd+0x44>
    *pf = f;
    80004d72:	e09c                	sd	a5,0(s1)
}
    80004d74:	70a2                	ld	ra,40(sp)
    80004d76:	7402                	ld	s0,32(sp)
    80004d78:	64e2                	ld	s1,24(sp)
    80004d7a:	6942                	ld	s2,16(sp)
    80004d7c:	6145                	addi	sp,sp,48
    80004d7e:	8082                	ret
    return -1;
    80004d80:	557d                	li	a0,-1
    80004d82:	bfcd                	j	80004d74 <argfd+0x44>
    80004d84:	557d                	li	a0,-1
    80004d86:	b7fd                	j	80004d74 <argfd+0x44>

0000000080004d88 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004d88:	1101                	addi	sp,sp,-32
    80004d8a:	ec06                	sd	ra,24(sp)
    80004d8c:	e822                	sd	s0,16(sp)
    80004d8e:	e426                	sd	s1,8(sp)
    80004d90:	1000                	addi	s0,sp,32
    80004d92:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004d94:	b83fc0ef          	jal	80001916 <myproc>
    80004d98:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004d9a:	0d850793          	addi	a5,a0,216
    80004d9e:	4501                	li	a0,0
    80004da0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004da2:	6398                	ld	a4,0(a5)
    80004da4:	cb19                	beqz	a4,80004dba <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004da6:	2505                	addiw	a0,a0,1
    80004da8:	07a1                	addi	a5,a5,8
    80004daa:	fed51ce3          	bne	a0,a3,80004da2 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004dae:	557d                	li	a0,-1
}
    80004db0:	60e2                	ld	ra,24(sp)
    80004db2:	6442                	ld	s0,16(sp)
    80004db4:	64a2                	ld	s1,8(sp)
    80004db6:	6105                	addi	sp,sp,32
    80004db8:	8082                	ret
      p->ofile[fd] = f;
    80004dba:	01a50793          	addi	a5,a0,26
    80004dbe:	078e                	slli	a5,a5,0x3
    80004dc0:	963e                	add	a2,a2,a5
    80004dc2:	e604                	sd	s1,8(a2)
      return fd;
    80004dc4:	b7f5                	j	80004db0 <fdalloc+0x28>

0000000080004dc6 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004dc6:	715d                	addi	sp,sp,-80
    80004dc8:	e486                	sd	ra,72(sp)
    80004dca:	e0a2                	sd	s0,64(sp)
    80004dcc:	fc26                	sd	s1,56(sp)
    80004dce:	f84a                	sd	s2,48(sp)
    80004dd0:	f44e                	sd	s3,40(sp)
    80004dd2:	ec56                	sd	s5,24(sp)
    80004dd4:	e85a                	sd	s6,16(sp)
    80004dd6:	0880                	addi	s0,sp,80
    80004dd8:	8b2e                	mv	s6,a1
    80004dda:	89b2                	mv	s3,a2
    80004ddc:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004dde:	fb040593          	addi	a1,s0,-80
    80004de2:	f25fe0ef          	jal	80003d06 <nameiparent>
    80004de6:	84aa                	mv	s1,a0
    80004de8:	10050a63          	beqz	a0,80004efc <create+0x136>
    return 0;

  ilock(dp);
    80004dec:	827fe0ef          	jal	80003612 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004df0:	4601                	li	a2,0
    80004df2:	fb040593          	addi	a1,s0,-80
    80004df6:	8526                	mv	a0,s1
    80004df8:	c8ffe0ef          	jal	80003a86 <dirlookup>
    80004dfc:	8aaa                	mv	s5,a0
    80004dfe:	c129                	beqz	a0,80004e40 <create+0x7a>
    iunlockput(dp);
    80004e00:	8526                	mv	a0,s1
    80004e02:	a1bfe0ef          	jal	8000381c <iunlockput>
    ilock(ip);
    80004e06:	8556                	mv	a0,s5
    80004e08:	80bfe0ef          	jal	80003612 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004e0c:	4789                	li	a5,2
    80004e0e:	02fb1463          	bne	s6,a5,80004e36 <create+0x70>
    80004e12:	044ad783          	lhu	a5,68(s5) # 1044 <_entry-0x7fffefbc>
    80004e16:	37f9                	addiw	a5,a5,-2
    80004e18:	17c2                	slli	a5,a5,0x30
    80004e1a:	93c1                	srli	a5,a5,0x30
    80004e1c:	4705                	li	a4,1
    80004e1e:	00f76c63          	bltu	a4,a5,80004e36 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004e22:	8556                	mv	a0,s5
    80004e24:	60a6                	ld	ra,72(sp)
    80004e26:	6406                	ld	s0,64(sp)
    80004e28:	74e2                	ld	s1,56(sp)
    80004e2a:	7942                	ld	s2,48(sp)
    80004e2c:	79a2                	ld	s3,40(sp)
    80004e2e:	6ae2                	ld	s5,24(sp)
    80004e30:	6b42                	ld	s6,16(sp)
    80004e32:	6161                	addi	sp,sp,80
    80004e34:	8082                	ret
    iunlockput(ip);
    80004e36:	8556                	mv	a0,s5
    80004e38:	9e5fe0ef          	jal	8000381c <iunlockput>
    return 0;
    80004e3c:	4a81                	li	s5,0
    80004e3e:	b7d5                	j	80004e22 <create+0x5c>
    80004e40:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004e42:	85da                	mv	a1,s6
    80004e44:	4088                	lw	a0,0(s1)
    80004e46:	e5cfe0ef          	jal	800034a2 <ialloc>
    80004e4a:	8a2a                	mv	s4,a0
    80004e4c:	cd15                	beqz	a0,80004e88 <create+0xc2>
  ilock(ip);
    80004e4e:	fc4fe0ef          	jal	80003612 <ilock>
  ip->major = major;
    80004e52:	053a1323          	sh	s3,70(s4) # fffffffffffff046 <end+0xffffffff7ffdafa6>
  ip->minor = minor;
    80004e56:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80004e5a:	4905                	li	s2,1
    80004e5c:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004e60:	8552                	mv	a0,s4
    80004e62:	efcfe0ef          	jal	8000355e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004e66:	032b0763          	beq	s6,s2,80004e94 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004e6a:	004a2603          	lw	a2,4(s4)
    80004e6e:	fb040593          	addi	a1,s0,-80
    80004e72:	8526                	mv	a0,s1
    80004e74:	ddffe0ef          	jal	80003c52 <dirlink>
    80004e78:	06054563          	bltz	a0,80004ee2 <create+0x11c>
  iunlockput(dp);
    80004e7c:	8526                	mv	a0,s1
    80004e7e:	99ffe0ef          	jal	8000381c <iunlockput>
  return ip;
    80004e82:	8ad2                	mv	s5,s4
    80004e84:	7a02                	ld	s4,32(sp)
    80004e86:	bf71                	j	80004e22 <create+0x5c>
    iunlockput(dp);
    80004e88:	8526                	mv	a0,s1
    80004e8a:	993fe0ef          	jal	8000381c <iunlockput>
    return 0;
    80004e8e:	8ad2                	mv	s5,s4
    80004e90:	7a02                	ld	s4,32(sp)
    80004e92:	bf41                	j	80004e22 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004e94:	004a2603          	lw	a2,4(s4)
    80004e98:	00002597          	auipc	a1,0x2
    80004e9c:	79858593          	addi	a1,a1,1944 # 80007630 <etext+0x630>
    80004ea0:	8552                	mv	a0,s4
    80004ea2:	db1fe0ef          	jal	80003c52 <dirlink>
    80004ea6:	02054e63          	bltz	a0,80004ee2 <create+0x11c>
    80004eaa:	40d0                	lw	a2,4(s1)
    80004eac:	00002597          	auipc	a1,0x2
    80004eb0:	78c58593          	addi	a1,a1,1932 # 80007638 <etext+0x638>
    80004eb4:	8552                	mv	a0,s4
    80004eb6:	d9dfe0ef          	jal	80003c52 <dirlink>
    80004eba:	02054463          	bltz	a0,80004ee2 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004ebe:	004a2603          	lw	a2,4(s4)
    80004ec2:	fb040593          	addi	a1,s0,-80
    80004ec6:	8526                	mv	a0,s1
    80004ec8:	d8bfe0ef          	jal	80003c52 <dirlink>
    80004ecc:	00054b63          	bltz	a0,80004ee2 <create+0x11c>
    dp->nlink++;  // for ".."
    80004ed0:	04a4d783          	lhu	a5,74(s1)
    80004ed4:	2785                	addiw	a5,a5,1
    80004ed6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004eda:	8526                	mv	a0,s1
    80004edc:	e82fe0ef          	jal	8000355e <iupdate>
    80004ee0:	bf71                	j	80004e7c <create+0xb6>
  ip->nlink = 0;
    80004ee2:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004ee6:	8552                	mv	a0,s4
    80004ee8:	e76fe0ef          	jal	8000355e <iupdate>
  iunlockput(ip);
    80004eec:	8552                	mv	a0,s4
    80004eee:	92ffe0ef          	jal	8000381c <iunlockput>
  iunlockput(dp);
    80004ef2:	8526                	mv	a0,s1
    80004ef4:	929fe0ef          	jal	8000381c <iunlockput>
  return 0;
    80004ef8:	7a02                	ld	s4,32(sp)
    80004efa:	b725                	j	80004e22 <create+0x5c>
    return 0;
    80004efc:	8aaa                	mv	s5,a0
    80004efe:	b715                	j	80004e22 <create+0x5c>

0000000080004f00 <sys_dup>:
{
    80004f00:	7179                	addi	sp,sp,-48
    80004f02:	f406                	sd	ra,40(sp)
    80004f04:	f022                	sd	s0,32(sp)
    80004f06:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004f08:	fd840613          	addi	a2,s0,-40
    80004f0c:	4581                	li	a1,0
    80004f0e:	4501                	li	a0,0
    80004f10:	e21ff0ef          	jal	80004d30 <argfd>
    return -1;
    80004f14:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004f16:	02054363          	bltz	a0,80004f3c <sys_dup+0x3c>
    80004f1a:	ec26                	sd	s1,24(sp)
    80004f1c:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004f1e:	fd843903          	ld	s2,-40(s0)
    80004f22:	854a                	mv	a0,s2
    80004f24:	e65ff0ef          	jal	80004d88 <fdalloc>
    80004f28:	84aa                	mv	s1,a0
    return -1;
    80004f2a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004f2c:	00054d63          	bltz	a0,80004f46 <sys_dup+0x46>
  filedup(f);
    80004f30:	854a                	mv	a0,s2
    80004f32:	b4aff0ef          	jal	8000427c <filedup>
  return fd;
    80004f36:	87a6                	mv	a5,s1
    80004f38:	64e2                	ld	s1,24(sp)
    80004f3a:	6942                	ld	s2,16(sp)
}
    80004f3c:	853e                	mv	a0,a5
    80004f3e:	70a2                	ld	ra,40(sp)
    80004f40:	7402                	ld	s0,32(sp)
    80004f42:	6145                	addi	sp,sp,48
    80004f44:	8082                	ret
    80004f46:	64e2                	ld	s1,24(sp)
    80004f48:	6942                	ld	s2,16(sp)
    80004f4a:	bfcd                	j	80004f3c <sys_dup+0x3c>

0000000080004f4c <sys_read>:
{
    80004f4c:	7179                	addi	sp,sp,-48
    80004f4e:	f406                	sd	ra,40(sp)
    80004f50:	f022                	sd	s0,32(sp)
    80004f52:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004f54:	fd840593          	addi	a1,s0,-40
    80004f58:	4505                	li	a0,1
    80004f5a:	c25fd0ef          	jal	80002b7e <argaddr>
  argint(2, &n);
    80004f5e:	fe440593          	addi	a1,s0,-28
    80004f62:	4509                	li	a0,2
    80004f64:	bfffd0ef          	jal	80002b62 <argint>
  if(argfd(0, 0, &f) < 0)
    80004f68:	fe840613          	addi	a2,s0,-24
    80004f6c:	4581                	li	a1,0
    80004f6e:	4501                	li	a0,0
    80004f70:	dc1ff0ef          	jal	80004d30 <argfd>
    80004f74:	87aa                	mv	a5,a0
    return -1;
    80004f76:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004f78:	0007ca63          	bltz	a5,80004f8c <sys_read+0x40>
  return fileread(f, p, n);
    80004f7c:	fe442603          	lw	a2,-28(s0)
    80004f80:	fd843583          	ld	a1,-40(s0)
    80004f84:	fe843503          	ld	a0,-24(s0)
    80004f88:	c5aff0ef          	jal	800043e2 <fileread>
}
    80004f8c:	70a2                	ld	ra,40(sp)
    80004f8e:	7402                	ld	s0,32(sp)
    80004f90:	6145                	addi	sp,sp,48
    80004f92:	8082                	ret

0000000080004f94 <sys_write>:
{
    80004f94:	7179                	addi	sp,sp,-48
    80004f96:	f406                	sd	ra,40(sp)
    80004f98:	f022                	sd	s0,32(sp)
    80004f9a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004f9c:	fd840593          	addi	a1,s0,-40
    80004fa0:	4505                	li	a0,1
    80004fa2:	bddfd0ef          	jal	80002b7e <argaddr>
  argint(2, &n);
    80004fa6:	fe440593          	addi	a1,s0,-28
    80004faa:	4509                	li	a0,2
    80004fac:	bb7fd0ef          	jal	80002b62 <argint>
  if(argfd(0, 0, &f) < 0)
    80004fb0:	fe840613          	addi	a2,s0,-24
    80004fb4:	4581                	li	a1,0
    80004fb6:	4501                	li	a0,0
    80004fb8:	d79ff0ef          	jal	80004d30 <argfd>
    80004fbc:	87aa                	mv	a5,a0
    return -1;
    80004fbe:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004fc0:	0007ca63          	bltz	a5,80004fd4 <sys_write+0x40>
  return filewrite(f, p, n);
    80004fc4:	fe442603          	lw	a2,-28(s0)
    80004fc8:	fd843583          	ld	a1,-40(s0)
    80004fcc:	fe843503          	ld	a0,-24(s0)
    80004fd0:	cd0ff0ef          	jal	800044a0 <filewrite>
}
    80004fd4:	70a2                	ld	ra,40(sp)
    80004fd6:	7402                	ld	s0,32(sp)
    80004fd8:	6145                	addi	sp,sp,48
    80004fda:	8082                	ret

0000000080004fdc <sys_close>:
{
    80004fdc:	1101                	addi	sp,sp,-32
    80004fde:	ec06                	sd	ra,24(sp)
    80004fe0:	e822                	sd	s0,16(sp)
    80004fe2:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004fe4:	fe040613          	addi	a2,s0,-32
    80004fe8:	fec40593          	addi	a1,s0,-20
    80004fec:	4501                	li	a0,0
    80004fee:	d43ff0ef          	jal	80004d30 <argfd>
    return -1;
    80004ff2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004ff4:	02054063          	bltz	a0,80005014 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004ff8:	91ffc0ef          	jal	80001916 <myproc>
    80004ffc:	fec42783          	lw	a5,-20(s0)
    80005000:	07e9                	addi	a5,a5,26
    80005002:	078e                	slli	a5,a5,0x3
    80005004:	953e                	add	a0,a0,a5
    80005006:	00053423          	sd	zero,8(a0)
  fileclose(f);
    8000500a:	fe043503          	ld	a0,-32(s0)
    8000500e:	ab4ff0ef          	jal	800042c2 <fileclose>
  return 0;
    80005012:	4781                	li	a5,0
}
    80005014:	853e                	mv	a0,a5
    80005016:	60e2                	ld	ra,24(sp)
    80005018:	6442                	ld	s0,16(sp)
    8000501a:	6105                	addi	sp,sp,32
    8000501c:	8082                	ret

000000008000501e <sys_fstat>:
{
    8000501e:	1101                	addi	sp,sp,-32
    80005020:	ec06                	sd	ra,24(sp)
    80005022:	e822                	sd	s0,16(sp)
    80005024:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005026:	fe040593          	addi	a1,s0,-32
    8000502a:	4505                	li	a0,1
    8000502c:	b53fd0ef          	jal	80002b7e <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005030:	fe840613          	addi	a2,s0,-24
    80005034:	4581                	li	a1,0
    80005036:	4501                	li	a0,0
    80005038:	cf9ff0ef          	jal	80004d30 <argfd>
    8000503c:	87aa                	mv	a5,a0
    return -1;
    8000503e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005040:	0007c863          	bltz	a5,80005050 <sys_fstat+0x32>
  return filestat(f, st);
    80005044:	fe043583          	ld	a1,-32(s0)
    80005048:	fe843503          	ld	a0,-24(s0)
    8000504c:	b38ff0ef          	jal	80004384 <filestat>
}
    80005050:	60e2                	ld	ra,24(sp)
    80005052:	6442                	ld	s0,16(sp)
    80005054:	6105                	addi	sp,sp,32
    80005056:	8082                	ret

0000000080005058 <sys_link>:
{
    80005058:	7169                	addi	sp,sp,-304
    8000505a:	f606                	sd	ra,296(sp)
    8000505c:	f222                	sd	s0,288(sp)
    8000505e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005060:	08000613          	li	a2,128
    80005064:	ed040593          	addi	a1,s0,-304
    80005068:	4501                	li	a0,0
    8000506a:	b31fd0ef          	jal	80002b9a <argstr>
    return -1;
    8000506e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005070:	0c054e63          	bltz	a0,8000514c <sys_link+0xf4>
    80005074:	08000613          	li	a2,128
    80005078:	f5040593          	addi	a1,s0,-176
    8000507c:	4505                	li	a0,1
    8000507e:	b1dfd0ef          	jal	80002b9a <argstr>
    return -1;
    80005082:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005084:	0c054463          	bltz	a0,8000514c <sys_link+0xf4>
    80005088:	ee26                	sd	s1,280(sp)
  begin_op();
    8000508a:	e1ffe0ef          	jal	80003ea8 <begin_op>
  if((ip = namei(old)) == 0){
    8000508e:	ed040513          	addi	a0,s0,-304
    80005092:	c5bfe0ef          	jal	80003cec <namei>
    80005096:	84aa                	mv	s1,a0
    80005098:	c53d                	beqz	a0,80005106 <sys_link+0xae>
  ilock(ip);
    8000509a:	d78fe0ef          	jal	80003612 <ilock>
  if(ip->type == T_DIR){
    8000509e:	04449703          	lh	a4,68(s1)
    800050a2:	4785                	li	a5,1
    800050a4:	06f70663          	beq	a4,a5,80005110 <sys_link+0xb8>
    800050a8:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800050aa:	04a4d783          	lhu	a5,74(s1)
    800050ae:	2785                	addiw	a5,a5,1
    800050b0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800050b4:	8526                	mv	a0,s1
    800050b6:	ca8fe0ef          	jal	8000355e <iupdate>
  iunlock(ip);
    800050ba:	8526                	mv	a0,s1
    800050bc:	e04fe0ef          	jal	800036c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800050c0:	fd040593          	addi	a1,s0,-48
    800050c4:	f5040513          	addi	a0,s0,-176
    800050c8:	c3ffe0ef          	jal	80003d06 <nameiparent>
    800050cc:	892a                	mv	s2,a0
    800050ce:	cd21                	beqz	a0,80005126 <sys_link+0xce>
  ilock(dp);
    800050d0:	d42fe0ef          	jal	80003612 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800050d4:	00092703          	lw	a4,0(s2)
    800050d8:	409c                	lw	a5,0(s1)
    800050da:	04f71363          	bne	a4,a5,80005120 <sys_link+0xc8>
    800050de:	40d0                	lw	a2,4(s1)
    800050e0:	fd040593          	addi	a1,s0,-48
    800050e4:	854a                	mv	a0,s2
    800050e6:	b6dfe0ef          	jal	80003c52 <dirlink>
    800050ea:	02054b63          	bltz	a0,80005120 <sys_link+0xc8>
  iunlockput(dp);
    800050ee:	854a                	mv	a0,s2
    800050f0:	f2cfe0ef          	jal	8000381c <iunlockput>
  iput(ip);
    800050f4:	8526                	mv	a0,s1
    800050f6:	e9efe0ef          	jal	80003794 <iput>
  end_op();
    800050fa:	e19fe0ef          	jal	80003f12 <end_op>
  return 0;
    800050fe:	4781                	li	a5,0
    80005100:	64f2                	ld	s1,280(sp)
    80005102:	6952                	ld	s2,272(sp)
    80005104:	a0a1                	j	8000514c <sys_link+0xf4>
    end_op();
    80005106:	e0dfe0ef          	jal	80003f12 <end_op>
    return -1;
    8000510a:	57fd                	li	a5,-1
    8000510c:	64f2                	ld	s1,280(sp)
    8000510e:	a83d                	j	8000514c <sys_link+0xf4>
    iunlockput(ip);
    80005110:	8526                	mv	a0,s1
    80005112:	f0afe0ef          	jal	8000381c <iunlockput>
    end_op();
    80005116:	dfdfe0ef          	jal	80003f12 <end_op>
    return -1;
    8000511a:	57fd                	li	a5,-1
    8000511c:	64f2                	ld	s1,280(sp)
    8000511e:	a03d                	j	8000514c <sys_link+0xf4>
    iunlockput(dp);
    80005120:	854a                	mv	a0,s2
    80005122:	efafe0ef          	jal	8000381c <iunlockput>
  ilock(ip);
    80005126:	8526                	mv	a0,s1
    80005128:	ceafe0ef          	jal	80003612 <ilock>
  ip->nlink--;
    8000512c:	04a4d783          	lhu	a5,74(s1)
    80005130:	37fd                	addiw	a5,a5,-1
    80005132:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005136:	8526                	mv	a0,s1
    80005138:	c26fe0ef          	jal	8000355e <iupdate>
  iunlockput(ip);
    8000513c:	8526                	mv	a0,s1
    8000513e:	edefe0ef          	jal	8000381c <iunlockput>
  end_op();
    80005142:	dd1fe0ef          	jal	80003f12 <end_op>
  return -1;
    80005146:	57fd                	li	a5,-1
    80005148:	64f2                	ld	s1,280(sp)
    8000514a:	6952                	ld	s2,272(sp)
}
    8000514c:	853e                	mv	a0,a5
    8000514e:	70b2                	ld	ra,296(sp)
    80005150:	7412                	ld	s0,288(sp)
    80005152:	6155                	addi	sp,sp,304
    80005154:	8082                	ret

0000000080005156 <sys_unlink>:
{
    80005156:	7151                	addi	sp,sp,-240
    80005158:	f586                	sd	ra,232(sp)
    8000515a:	f1a2                	sd	s0,224(sp)
    8000515c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000515e:	08000613          	li	a2,128
    80005162:	f3040593          	addi	a1,s0,-208
    80005166:	4501                	li	a0,0
    80005168:	a33fd0ef          	jal	80002b9a <argstr>
    8000516c:	16054063          	bltz	a0,800052cc <sys_unlink+0x176>
    80005170:	eda6                	sd	s1,216(sp)
  begin_op();
    80005172:	d37fe0ef          	jal	80003ea8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005176:	fb040593          	addi	a1,s0,-80
    8000517a:	f3040513          	addi	a0,s0,-208
    8000517e:	b89fe0ef          	jal	80003d06 <nameiparent>
    80005182:	84aa                	mv	s1,a0
    80005184:	c945                	beqz	a0,80005234 <sys_unlink+0xde>
  ilock(dp);
    80005186:	c8cfe0ef          	jal	80003612 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000518a:	00002597          	auipc	a1,0x2
    8000518e:	4a658593          	addi	a1,a1,1190 # 80007630 <etext+0x630>
    80005192:	fb040513          	addi	a0,s0,-80
    80005196:	8dbfe0ef          	jal	80003a70 <namecmp>
    8000519a:	10050e63          	beqz	a0,800052b6 <sys_unlink+0x160>
    8000519e:	00002597          	auipc	a1,0x2
    800051a2:	49a58593          	addi	a1,a1,1178 # 80007638 <etext+0x638>
    800051a6:	fb040513          	addi	a0,s0,-80
    800051aa:	8c7fe0ef          	jal	80003a70 <namecmp>
    800051ae:	10050463          	beqz	a0,800052b6 <sys_unlink+0x160>
    800051b2:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800051b4:	f2c40613          	addi	a2,s0,-212
    800051b8:	fb040593          	addi	a1,s0,-80
    800051bc:	8526                	mv	a0,s1
    800051be:	8c9fe0ef          	jal	80003a86 <dirlookup>
    800051c2:	892a                	mv	s2,a0
    800051c4:	0e050863          	beqz	a0,800052b4 <sys_unlink+0x15e>
  ilock(ip);
    800051c8:	c4afe0ef          	jal	80003612 <ilock>
  if(ip->nlink < 1)
    800051cc:	04a91783          	lh	a5,74(s2)
    800051d0:	06f05763          	blez	a5,8000523e <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800051d4:	04491703          	lh	a4,68(s2)
    800051d8:	4785                	li	a5,1
    800051da:	06f70963          	beq	a4,a5,8000524c <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    800051de:	4641                	li	a2,16
    800051e0:	4581                	li	a1,0
    800051e2:	fc040513          	addi	a0,s0,-64
    800051e6:	ae3fb0ef          	jal	80000cc8 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800051ea:	4741                	li	a4,16
    800051ec:	f2c42683          	lw	a3,-212(s0)
    800051f0:	fc040613          	addi	a2,s0,-64
    800051f4:	4581                	li	a1,0
    800051f6:	8526                	mv	a0,s1
    800051f8:	f6afe0ef          	jal	80003962 <writei>
    800051fc:	47c1                	li	a5,16
    800051fe:	08f51b63          	bne	a0,a5,80005294 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80005202:	04491703          	lh	a4,68(s2)
    80005206:	4785                	li	a5,1
    80005208:	08f70d63          	beq	a4,a5,800052a2 <sys_unlink+0x14c>
  iunlockput(dp);
    8000520c:	8526                	mv	a0,s1
    8000520e:	e0efe0ef          	jal	8000381c <iunlockput>
  ip->nlink--;
    80005212:	04a95783          	lhu	a5,74(s2)
    80005216:	37fd                	addiw	a5,a5,-1
    80005218:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000521c:	854a                	mv	a0,s2
    8000521e:	b40fe0ef          	jal	8000355e <iupdate>
  iunlockput(ip);
    80005222:	854a                	mv	a0,s2
    80005224:	df8fe0ef          	jal	8000381c <iunlockput>
  end_op();
    80005228:	cebfe0ef          	jal	80003f12 <end_op>
  return 0;
    8000522c:	4501                	li	a0,0
    8000522e:	64ee                	ld	s1,216(sp)
    80005230:	694e                	ld	s2,208(sp)
    80005232:	a849                	j	800052c4 <sys_unlink+0x16e>
    end_op();
    80005234:	cdffe0ef          	jal	80003f12 <end_op>
    return -1;
    80005238:	557d                	li	a0,-1
    8000523a:	64ee                	ld	s1,216(sp)
    8000523c:	a061                	j	800052c4 <sys_unlink+0x16e>
    8000523e:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005240:	00002517          	auipc	a0,0x2
    80005244:	40050513          	addi	a0,a0,1024 # 80007640 <etext+0x640>
    80005248:	d4cfb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000524c:	04c92703          	lw	a4,76(s2)
    80005250:	02000793          	li	a5,32
    80005254:	f8e7f5e3          	bgeu	a5,a4,800051de <sys_unlink+0x88>
    80005258:	e5ce                	sd	s3,200(sp)
    8000525a:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000525e:	4741                	li	a4,16
    80005260:	86ce                	mv	a3,s3
    80005262:	f1840613          	addi	a2,s0,-232
    80005266:	4581                	li	a1,0
    80005268:	854a                	mv	a0,s2
    8000526a:	dfcfe0ef          	jal	80003866 <readi>
    8000526e:	47c1                	li	a5,16
    80005270:	00f51c63          	bne	a0,a5,80005288 <sys_unlink+0x132>
    if(de.inum != 0)
    80005274:	f1845783          	lhu	a5,-232(s0)
    80005278:	efa1                	bnez	a5,800052d0 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000527a:	29c1                	addiw	s3,s3,16
    8000527c:	04c92783          	lw	a5,76(s2)
    80005280:	fcf9efe3          	bltu	s3,a5,8000525e <sys_unlink+0x108>
    80005284:	69ae                	ld	s3,200(sp)
    80005286:	bfa1                	j	800051de <sys_unlink+0x88>
      panic("isdirempty: readi");
    80005288:	00002517          	auipc	a0,0x2
    8000528c:	3d050513          	addi	a0,a0,976 # 80007658 <etext+0x658>
    80005290:	d04fb0ef          	jal	80000794 <panic>
    80005294:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005296:	00002517          	auipc	a0,0x2
    8000529a:	3da50513          	addi	a0,a0,986 # 80007670 <etext+0x670>
    8000529e:	cf6fb0ef          	jal	80000794 <panic>
    dp->nlink--;
    800052a2:	04a4d783          	lhu	a5,74(s1)
    800052a6:	37fd                	addiw	a5,a5,-1
    800052a8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800052ac:	8526                	mv	a0,s1
    800052ae:	ab0fe0ef          	jal	8000355e <iupdate>
    800052b2:	bfa9                	j	8000520c <sys_unlink+0xb6>
    800052b4:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800052b6:	8526                	mv	a0,s1
    800052b8:	d64fe0ef          	jal	8000381c <iunlockput>
  end_op();
    800052bc:	c57fe0ef          	jal	80003f12 <end_op>
  return -1;
    800052c0:	557d                	li	a0,-1
    800052c2:	64ee                	ld	s1,216(sp)
}
    800052c4:	70ae                	ld	ra,232(sp)
    800052c6:	740e                	ld	s0,224(sp)
    800052c8:	616d                	addi	sp,sp,240
    800052ca:	8082                	ret
    return -1;
    800052cc:	557d                	li	a0,-1
    800052ce:	bfdd                	j	800052c4 <sys_unlink+0x16e>
    iunlockput(ip);
    800052d0:	854a                	mv	a0,s2
    800052d2:	d4afe0ef          	jal	8000381c <iunlockput>
    goto bad;
    800052d6:	694e                	ld	s2,208(sp)
    800052d8:	69ae                	ld	s3,200(sp)
    800052da:	bff1                	j	800052b6 <sys_unlink+0x160>

00000000800052dc <sys_open>:

uint64
sys_open(void)
{
    800052dc:	7131                	addi	sp,sp,-192
    800052de:	fd06                	sd	ra,184(sp)
    800052e0:	f922                	sd	s0,176(sp)
    800052e2:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800052e4:	f4c40593          	addi	a1,s0,-180
    800052e8:	4505                	li	a0,1
    800052ea:	879fd0ef          	jal	80002b62 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800052ee:	08000613          	li	a2,128
    800052f2:	f5040593          	addi	a1,s0,-176
    800052f6:	4501                	li	a0,0
    800052f8:	8a3fd0ef          	jal	80002b9a <argstr>
    800052fc:	87aa                	mv	a5,a0
    return -1;
    800052fe:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005300:	0a07c263          	bltz	a5,800053a4 <sys_open+0xc8>
    80005304:	f526                	sd	s1,168(sp)

  begin_op();
    80005306:	ba3fe0ef          	jal	80003ea8 <begin_op>

  if(omode & O_CREATE){
    8000530a:	f4c42783          	lw	a5,-180(s0)
    8000530e:	2007f793          	andi	a5,a5,512
    80005312:	c3d5                	beqz	a5,800053b6 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80005314:	4681                	li	a3,0
    80005316:	4601                	li	a2,0
    80005318:	4589                	li	a1,2
    8000531a:	f5040513          	addi	a0,s0,-176
    8000531e:	aa9ff0ef          	jal	80004dc6 <create>
    80005322:	84aa                	mv	s1,a0
    if(ip == 0){
    80005324:	c541                	beqz	a0,800053ac <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005326:	04449703          	lh	a4,68(s1)
    8000532a:	478d                	li	a5,3
    8000532c:	00f71763          	bne	a4,a5,8000533a <sys_open+0x5e>
    80005330:	0464d703          	lhu	a4,70(s1)
    80005334:	47a5                	li	a5,9
    80005336:	0ae7ed63          	bltu	a5,a4,800053f0 <sys_open+0x114>
    8000533a:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000533c:	ee3fe0ef          	jal	8000421e <filealloc>
    80005340:	892a                	mv	s2,a0
    80005342:	c179                	beqz	a0,80005408 <sys_open+0x12c>
    80005344:	ed4e                	sd	s3,152(sp)
    80005346:	a43ff0ef          	jal	80004d88 <fdalloc>
    8000534a:	89aa                	mv	s3,a0
    8000534c:	0a054a63          	bltz	a0,80005400 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005350:	04449703          	lh	a4,68(s1)
    80005354:	478d                	li	a5,3
    80005356:	0cf70263          	beq	a4,a5,8000541a <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000535a:	4789                	li	a5,2
    8000535c:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005360:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005364:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005368:	f4c42783          	lw	a5,-180(s0)
    8000536c:	0017c713          	xori	a4,a5,1
    80005370:	8b05                	andi	a4,a4,1
    80005372:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005376:	0037f713          	andi	a4,a5,3
    8000537a:	00e03733          	snez	a4,a4
    8000537e:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005382:	4007f793          	andi	a5,a5,1024
    80005386:	c791                	beqz	a5,80005392 <sys_open+0xb6>
    80005388:	04449703          	lh	a4,68(s1)
    8000538c:	4789                	li	a5,2
    8000538e:	08f70d63          	beq	a4,a5,80005428 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80005392:	8526                	mv	a0,s1
    80005394:	b2cfe0ef          	jal	800036c0 <iunlock>
  end_op();
    80005398:	b7bfe0ef          	jal	80003f12 <end_op>

  return fd;
    8000539c:	854e                	mv	a0,s3
    8000539e:	74aa                	ld	s1,168(sp)
    800053a0:	790a                	ld	s2,160(sp)
    800053a2:	69ea                	ld	s3,152(sp)
}
    800053a4:	70ea                	ld	ra,184(sp)
    800053a6:	744a                	ld	s0,176(sp)
    800053a8:	6129                	addi	sp,sp,192
    800053aa:	8082                	ret
      end_op();
    800053ac:	b67fe0ef          	jal	80003f12 <end_op>
      return -1;
    800053b0:	557d                	li	a0,-1
    800053b2:	74aa                	ld	s1,168(sp)
    800053b4:	bfc5                	j	800053a4 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    800053b6:	f5040513          	addi	a0,s0,-176
    800053ba:	933fe0ef          	jal	80003cec <namei>
    800053be:	84aa                	mv	s1,a0
    800053c0:	c11d                	beqz	a0,800053e6 <sys_open+0x10a>
    ilock(ip);
    800053c2:	a50fe0ef          	jal	80003612 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800053c6:	04449703          	lh	a4,68(s1)
    800053ca:	4785                	li	a5,1
    800053cc:	f4f71de3          	bne	a4,a5,80005326 <sys_open+0x4a>
    800053d0:	f4c42783          	lw	a5,-180(s0)
    800053d4:	d3bd                	beqz	a5,8000533a <sys_open+0x5e>
      iunlockput(ip);
    800053d6:	8526                	mv	a0,s1
    800053d8:	c44fe0ef          	jal	8000381c <iunlockput>
      end_op();
    800053dc:	b37fe0ef          	jal	80003f12 <end_op>
      return -1;
    800053e0:	557d                	li	a0,-1
    800053e2:	74aa                	ld	s1,168(sp)
    800053e4:	b7c1                	j	800053a4 <sys_open+0xc8>
      end_op();
    800053e6:	b2dfe0ef          	jal	80003f12 <end_op>
      return -1;
    800053ea:	557d                	li	a0,-1
    800053ec:	74aa                	ld	s1,168(sp)
    800053ee:	bf5d                	j	800053a4 <sys_open+0xc8>
    iunlockput(ip);
    800053f0:	8526                	mv	a0,s1
    800053f2:	c2afe0ef          	jal	8000381c <iunlockput>
    end_op();
    800053f6:	b1dfe0ef          	jal	80003f12 <end_op>
    return -1;
    800053fa:	557d                	li	a0,-1
    800053fc:	74aa                	ld	s1,168(sp)
    800053fe:	b75d                	j	800053a4 <sys_open+0xc8>
      fileclose(f);
    80005400:	854a                	mv	a0,s2
    80005402:	ec1fe0ef          	jal	800042c2 <fileclose>
    80005406:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005408:	8526                	mv	a0,s1
    8000540a:	c12fe0ef          	jal	8000381c <iunlockput>
    end_op();
    8000540e:	b05fe0ef          	jal	80003f12 <end_op>
    return -1;
    80005412:	557d                	li	a0,-1
    80005414:	74aa                	ld	s1,168(sp)
    80005416:	790a                	ld	s2,160(sp)
    80005418:	b771                	j	800053a4 <sys_open+0xc8>
    f->type = FD_DEVICE;
    8000541a:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    8000541e:	04649783          	lh	a5,70(s1)
    80005422:	02f91223          	sh	a5,36(s2)
    80005426:	bf3d                	j	80005364 <sys_open+0x88>
    itrunc(ip);
    80005428:	8526                	mv	a0,s1
    8000542a:	ad6fe0ef          	jal	80003700 <itrunc>
    8000542e:	b795                	j	80005392 <sys_open+0xb6>

0000000080005430 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005430:	7175                	addi	sp,sp,-144
    80005432:	e506                	sd	ra,136(sp)
    80005434:	e122                	sd	s0,128(sp)
    80005436:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005438:	a71fe0ef          	jal	80003ea8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000543c:	08000613          	li	a2,128
    80005440:	f7040593          	addi	a1,s0,-144
    80005444:	4501                	li	a0,0
    80005446:	f54fd0ef          	jal	80002b9a <argstr>
    8000544a:	02054363          	bltz	a0,80005470 <sys_mkdir+0x40>
    8000544e:	4681                	li	a3,0
    80005450:	4601                	li	a2,0
    80005452:	4585                	li	a1,1
    80005454:	f7040513          	addi	a0,s0,-144
    80005458:	96fff0ef          	jal	80004dc6 <create>
    8000545c:	c911                	beqz	a0,80005470 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000545e:	bbefe0ef          	jal	8000381c <iunlockput>
  end_op();
    80005462:	ab1fe0ef          	jal	80003f12 <end_op>
  return 0;
    80005466:	4501                	li	a0,0
}
    80005468:	60aa                	ld	ra,136(sp)
    8000546a:	640a                	ld	s0,128(sp)
    8000546c:	6149                	addi	sp,sp,144
    8000546e:	8082                	ret
    end_op();
    80005470:	aa3fe0ef          	jal	80003f12 <end_op>
    return -1;
    80005474:	557d                	li	a0,-1
    80005476:	bfcd                	j	80005468 <sys_mkdir+0x38>

0000000080005478 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005478:	7135                	addi	sp,sp,-160
    8000547a:	ed06                	sd	ra,152(sp)
    8000547c:	e922                	sd	s0,144(sp)
    8000547e:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005480:	a29fe0ef          	jal	80003ea8 <begin_op>
  argint(1, &major);
    80005484:	f6c40593          	addi	a1,s0,-148
    80005488:	4505                	li	a0,1
    8000548a:	ed8fd0ef          	jal	80002b62 <argint>
  argint(2, &minor);
    8000548e:	f6840593          	addi	a1,s0,-152
    80005492:	4509                	li	a0,2
    80005494:	ecefd0ef          	jal	80002b62 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005498:	08000613          	li	a2,128
    8000549c:	f7040593          	addi	a1,s0,-144
    800054a0:	4501                	li	a0,0
    800054a2:	ef8fd0ef          	jal	80002b9a <argstr>
    800054a6:	02054563          	bltz	a0,800054d0 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800054aa:	f6841683          	lh	a3,-152(s0)
    800054ae:	f6c41603          	lh	a2,-148(s0)
    800054b2:	458d                	li	a1,3
    800054b4:	f7040513          	addi	a0,s0,-144
    800054b8:	90fff0ef          	jal	80004dc6 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800054bc:	c911                	beqz	a0,800054d0 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800054be:	b5efe0ef          	jal	8000381c <iunlockput>
  end_op();
    800054c2:	a51fe0ef          	jal	80003f12 <end_op>
  return 0;
    800054c6:	4501                	li	a0,0
}
    800054c8:	60ea                	ld	ra,152(sp)
    800054ca:	644a                	ld	s0,144(sp)
    800054cc:	610d                	addi	sp,sp,160
    800054ce:	8082                	ret
    end_op();
    800054d0:	a43fe0ef          	jal	80003f12 <end_op>
    return -1;
    800054d4:	557d                	li	a0,-1
    800054d6:	bfcd                	j	800054c8 <sys_mknod+0x50>

00000000800054d8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800054d8:	7135                	addi	sp,sp,-160
    800054da:	ed06                	sd	ra,152(sp)
    800054dc:	e922                	sd	s0,144(sp)
    800054de:	e14a                	sd	s2,128(sp)
    800054e0:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800054e2:	c34fc0ef          	jal	80001916 <myproc>
    800054e6:	892a                	mv	s2,a0
  
  begin_op();
    800054e8:	9c1fe0ef          	jal	80003ea8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800054ec:	08000613          	li	a2,128
    800054f0:	f6040593          	addi	a1,s0,-160
    800054f4:	4501                	li	a0,0
    800054f6:	ea4fd0ef          	jal	80002b9a <argstr>
    800054fa:	04054363          	bltz	a0,80005540 <sys_chdir+0x68>
    800054fe:	e526                	sd	s1,136(sp)
    80005500:	f6040513          	addi	a0,s0,-160
    80005504:	fe8fe0ef          	jal	80003cec <namei>
    80005508:	84aa                	mv	s1,a0
    8000550a:	c915                	beqz	a0,8000553e <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000550c:	906fe0ef          	jal	80003612 <ilock>
  if(ip->type != T_DIR){
    80005510:	04449703          	lh	a4,68(s1)
    80005514:	4785                	li	a5,1
    80005516:	02f71963          	bne	a4,a5,80005548 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000551a:	8526                	mv	a0,s1
    8000551c:	9a4fe0ef          	jal	800036c0 <iunlock>
  iput(p->cwd);
    80005520:	15893503          	ld	a0,344(s2)
    80005524:	a70fe0ef          	jal	80003794 <iput>
  end_op();
    80005528:	9ebfe0ef          	jal	80003f12 <end_op>
  p->cwd = ip;
    8000552c:	14993c23          	sd	s1,344(s2)
  return 0;
    80005530:	4501                	li	a0,0
    80005532:	64aa                	ld	s1,136(sp)
}
    80005534:	60ea                	ld	ra,152(sp)
    80005536:	644a                	ld	s0,144(sp)
    80005538:	690a                	ld	s2,128(sp)
    8000553a:	610d                	addi	sp,sp,160
    8000553c:	8082                	ret
    8000553e:	64aa                	ld	s1,136(sp)
    end_op();
    80005540:	9d3fe0ef          	jal	80003f12 <end_op>
    return -1;
    80005544:	557d                	li	a0,-1
    80005546:	b7fd                	j	80005534 <sys_chdir+0x5c>
    iunlockput(ip);
    80005548:	8526                	mv	a0,s1
    8000554a:	ad2fe0ef          	jal	8000381c <iunlockput>
    end_op();
    8000554e:	9c5fe0ef          	jal	80003f12 <end_op>
    return -1;
    80005552:	557d                	li	a0,-1
    80005554:	64aa                	ld	s1,136(sp)
    80005556:	bff9                	j	80005534 <sys_chdir+0x5c>

0000000080005558 <sys_exec>:

uint64
sys_exec(void)
{
    80005558:	7121                	addi	sp,sp,-448
    8000555a:	ff06                	sd	ra,440(sp)
    8000555c:	fb22                	sd	s0,432(sp)
    8000555e:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005560:	e4840593          	addi	a1,s0,-440
    80005564:	4505                	li	a0,1
    80005566:	e18fd0ef          	jal	80002b7e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000556a:	08000613          	li	a2,128
    8000556e:	f5040593          	addi	a1,s0,-176
    80005572:	4501                	li	a0,0
    80005574:	e26fd0ef          	jal	80002b9a <argstr>
    80005578:	87aa                	mv	a5,a0
    return -1;
    8000557a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000557c:	0c07c463          	bltz	a5,80005644 <sys_exec+0xec>
    80005580:	f726                	sd	s1,424(sp)
    80005582:	f34a                	sd	s2,416(sp)
    80005584:	ef4e                	sd	s3,408(sp)
    80005586:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005588:	10000613          	li	a2,256
    8000558c:	4581                	li	a1,0
    8000558e:	e5040513          	addi	a0,s0,-432
    80005592:	f36fb0ef          	jal	80000cc8 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005596:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    8000559a:	89a6                	mv	s3,s1
    8000559c:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    8000559e:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800055a2:	00391513          	slli	a0,s2,0x3
    800055a6:	e4040593          	addi	a1,s0,-448
    800055aa:	e4843783          	ld	a5,-440(s0)
    800055ae:	953e                	add	a0,a0,a5
    800055b0:	d14fd0ef          	jal	80002ac4 <fetchaddr>
    800055b4:	02054663          	bltz	a0,800055e0 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    800055b8:	e4043783          	ld	a5,-448(s0)
    800055bc:	c3a9                	beqz	a5,800055fe <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    800055be:	d66fb0ef          	jal	80000b24 <kalloc>
    800055c2:	85aa                	mv	a1,a0
    800055c4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0) 
    800055c8:	cd01                	beqz	a0,800055e0 <sys_exec+0x88>
      goto bad;    
    
    if(fetchstr(uarg, argv[i], PGSIZE) < 0) 
    800055ca:	6605                	lui	a2,0x1
    800055cc:	e4043503          	ld	a0,-448(s0)
    800055d0:	d48fd0ef          	jal	80002b18 <fetchstr>
    800055d4:	00054663          	bltz	a0,800055e0 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    800055d8:	0905                	addi	s2,s2,1
    800055da:	09a1                	addi	s3,s3,8
    800055dc:	fd4913e3          	bne	s2,s4,800055a2 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800055e0:	f5040913          	addi	s2,s0,-176
    800055e4:	6088                	ld	a0,0(s1)
    800055e6:	c931                	beqz	a0,8000563a <sys_exec+0xe2>
    kfree(argv[i]);
    800055e8:	c5afb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800055ec:	04a1                	addi	s1,s1,8
    800055ee:	ff249be3          	bne	s1,s2,800055e4 <sys_exec+0x8c>
  return -1;
    800055f2:	557d                	li	a0,-1
    800055f4:	74ba                	ld	s1,424(sp)
    800055f6:	791a                	ld	s2,416(sp)
    800055f8:	69fa                	ld	s3,408(sp)
    800055fa:	6a5a                	ld	s4,400(sp)
    800055fc:	a0a1                	j	80005644 <sys_exec+0xec>
      argv[i] = 0;
    800055fe:	0009079b          	sext.w	a5,s2
    80005602:	078e                	slli	a5,a5,0x3
    80005604:	fd078793          	addi	a5,a5,-48
    80005608:	97a2                	add	a5,a5,s0
    8000560a:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    8000560e:	e5040593          	addi	a1,s0,-432
    80005612:	f5040513          	addi	a0,s0,-176
    80005616:	ad2ff0ef          	jal	800048e8 <exec>
    8000561a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000561c:	f5040993          	addi	s3,s0,-176
    80005620:	6088                	ld	a0,0(s1)
    80005622:	c511                	beqz	a0,8000562e <sys_exec+0xd6>
    kfree(argv[i]);
    80005624:	c1efb0ef          	jal	80000a42 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005628:	04a1                	addi	s1,s1,8
    8000562a:	ff349be3          	bne	s1,s3,80005620 <sys_exec+0xc8>
  return ret;
    8000562e:	854a                	mv	a0,s2
    80005630:	74ba                	ld	s1,424(sp)
    80005632:	791a                	ld	s2,416(sp)
    80005634:	69fa                	ld	s3,408(sp)
    80005636:	6a5a                	ld	s4,400(sp)
    80005638:	a031                	j	80005644 <sys_exec+0xec>
  return -1;
    8000563a:	557d                	li	a0,-1
    8000563c:	74ba                	ld	s1,424(sp)
    8000563e:	791a                	ld	s2,416(sp)
    80005640:	69fa                	ld	s3,408(sp)
    80005642:	6a5a                	ld	s4,400(sp)
}
    80005644:	70fa                	ld	ra,440(sp)
    80005646:	745a                	ld	s0,432(sp)
    80005648:	6139                	addi	sp,sp,448
    8000564a:	8082                	ret

000000008000564c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000564c:	7139                	addi	sp,sp,-64
    8000564e:	fc06                	sd	ra,56(sp)
    80005650:	f822                	sd	s0,48(sp)
    80005652:	f426                	sd	s1,40(sp)
    80005654:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005656:	ac0fc0ef          	jal	80001916 <myproc>
    8000565a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000565c:	fd840593          	addi	a1,s0,-40
    80005660:	4501                	li	a0,0
    80005662:	d1cfd0ef          	jal	80002b7e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005666:	fc840593          	addi	a1,s0,-56
    8000566a:	fd040513          	addi	a0,s0,-48
    8000566e:	f5ffe0ef          	jal	800045cc <pipealloc>
    return -1;
    80005672:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005674:	0a054463          	bltz	a0,8000571c <sys_pipe+0xd0>
  fd0 = -1;
    80005678:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000567c:	fd043503          	ld	a0,-48(s0)
    80005680:	f08ff0ef          	jal	80004d88 <fdalloc>
    80005684:	fca42223          	sw	a0,-60(s0)
    80005688:	08054163          	bltz	a0,8000570a <sys_pipe+0xbe>
    8000568c:	fc843503          	ld	a0,-56(s0)
    80005690:	ef8ff0ef          	jal	80004d88 <fdalloc>
    80005694:	fca42023          	sw	a0,-64(s0)
    80005698:	06054063          	bltz	a0,800056f8 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000569c:	4691                	li	a3,4
    8000569e:	fc440613          	addi	a2,s0,-60
    800056a2:	fd843583          	ld	a1,-40(s0)
    800056a6:	68a8                	ld	a0,80(s1)
    800056a8:	ee1fb0ef          	jal	80001588 <copyout>
    800056ac:	00054e63          	bltz	a0,800056c8 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800056b0:	4691                	li	a3,4
    800056b2:	fc040613          	addi	a2,s0,-64
    800056b6:	fd843583          	ld	a1,-40(s0)
    800056ba:	0591                	addi	a1,a1,4
    800056bc:	68a8                	ld	a0,80(s1)
    800056be:	ecbfb0ef          	jal	80001588 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800056c2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800056c4:	04055c63          	bgez	a0,8000571c <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800056c8:	fc442783          	lw	a5,-60(s0)
    800056cc:	07e9                	addi	a5,a5,26
    800056ce:	078e                	slli	a5,a5,0x3
    800056d0:	97a6                	add	a5,a5,s1
    800056d2:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800056d6:	fc042783          	lw	a5,-64(s0)
    800056da:	07e9                	addi	a5,a5,26
    800056dc:	078e                	slli	a5,a5,0x3
    800056de:	94be                	add	s1,s1,a5
    800056e0:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    800056e4:	fd043503          	ld	a0,-48(s0)
    800056e8:	bdbfe0ef          	jal	800042c2 <fileclose>
    fileclose(wf);
    800056ec:	fc843503          	ld	a0,-56(s0)
    800056f0:	bd3fe0ef          	jal	800042c2 <fileclose>
    return -1;
    800056f4:	57fd                	li	a5,-1
    800056f6:	a01d                	j	8000571c <sys_pipe+0xd0>
    if(fd0 >= 0)
    800056f8:	fc442783          	lw	a5,-60(s0)
    800056fc:	0007c763          	bltz	a5,8000570a <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005700:	07e9                	addi	a5,a5,26
    80005702:	078e                	slli	a5,a5,0x3
    80005704:	97a6                	add	a5,a5,s1
    80005706:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000570a:	fd043503          	ld	a0,-48(s0)
    8000570e:	bb5fe0ef          	jal	800042c2 <fileclose>
    fileclose(wf);
    80005712:	fc843503          	ld	a0,-56(s0)
    80005716:	badfe0ef          	jal	800042c2 <fileclose>
    return -1;
    8000571a:	57fd                	li	a5,-1
}
    8000571c:	853e                	mv	a0,a5
    8000571e:	70e2                	ld	ra,56(sp)
    80005720:	7442                	ld	s0,48(sp)
    80005722:	74a2                	ld	s1,40(sp)
    80005724:	6121                	addi	sp,sp,64
    80005726:	8082                	ret
	...

0000000080005730 <kernelvec>:
    80005730:	7111                	addi	sp,sp,-256
    80005732:	e006                	sd	ra,0(sp)
    80005734:	e40a                	sd	sp,8(sp)
    80005736:	e80e                	sd	gp,16(sp)
    80005738:	ec12                	sd	tp,24(sp)
    8000573a:	f016                	sd	t0,32(sp)
    8000573c:	f41a                	sd	t1,40(sp)
    8000573e:	f81e                	sd	t2,48(sp)
    80005740:	e4aa                	sd	a0,72(sp)
    80005742:	e8ae                	sd	a1,80(sp)
    80005744:	ecb2                	sd	a2,88(sp)
    80005746:	f0b6                	sd	a3,96(sp)
    80005748:	f4ba                	sd	a4,104(sp)
    8000574a:	f8be                	sd	a5,112(sp)
    8000574c:	fcc2                	sd	a6,120(sp)
    8000574e:	e146                	sd	a7,128(sp)
    80005750:	edf2                	sd	t3,216(sp)
    80005752:	f1f6                	sd	t4,224(sp)
    80005754:	f5fa                	sd	t5,232(sp)
    80005756:	f9fe                	sd	t6,240(sp)
    80005758:	a7cfd0ef          	jal	800029d4 <kerneltrap>
    8000575c:	6082                	ld	ra,0(sp)
    8000575e:	6122                	ld	sp,8(sp)
    80005760:	61c2                	ld	gp,16(sp)
    80005762:	7282                	ld	t0,32(sp)
    80005764:	7322                	ld	t1,40(sp)
    80005766:	73c2                	ld	t2,48(sp)
    80005768:	6526                	ld	a0,72(sp)
    8000576a:	65c6                	ld	a1,80(sp)
    8000576c:	6666                	ld	a2,88(sp)
    8000576e:	7686                	ld	a3,96(sp)
    80005770:	7726                	ld	a4,104(sp)
    80005772:	77c6                	ld	a5,112(sp)
    80005774:	7866                	ld	a6,120(sp)
    80005776:	688a                	ld	a7,128(sp)
    80005778:	6e6e                	ld	t3,216(sp)
    8000577a:	7e8e                	ld	t4,224(sp)
    8000577c:	7f2e                	ld	t5,232(sp)
    8000577e:	7fce                	ld	t6,240(sp)
    80005780:	6111                	addi	sp,sp,256
    80005782:	10200073          	sret
	...

000000008000578e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000578e:	1141                	addi	sp,sp,-16
    80005790:	e422                	sd	s0,8(sp)
    80005792:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005794:	0c0007b7          	lui	a5,0xc000
    80005798:	4705                	li	a4,1
    8000579a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000579c:	0c0007b7          	lui	a5,0xc000
    800057a0:	c3d8                	sw	a4,4(a5)
}
    800057a2:	6422                	ld	s0,8(sp)
    800057a4:	0141                	addi	sp,sp,16
    800057a6:	8082                	ret

00000000800057a8 <plicinithart>:

void
plicinithart(void)
{
    800057a8:	1141                	addi	sp,sp,-16
    800057aa:	e406                	sd	ra,8(sp)
    800057ac:	e022                	sd	s0,0(sp)
    800057ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800057b0:	93afc0ef          	jal	800018ea <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800057b4:	0085171b          	slliw	a4,a0,0x8
    800057b8:	0c0027b7          	lui	a5,0xc002
    800057bc:	97ba                	add	a5,a5,a4
    800057be:	40200713          	li	a4,1026
    800057c2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800057c6:	00d5151b          	slliw	a0,a0,0xd
    800057ca:	0c2017b7          	lui	a5,0xc201
    800057ce:	97aa                	add	a5,a5,a0
    800057d0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800057d4:	60a2                	ld	ra,8(sp)
    800057d6:	6402                	ld	s0,0(sp)
    800057d8:	0141                	addi	sp,sp,16
    800057da:	8082                	ret

00000000800057dc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800057dc:	1141                	addi	sp,sp,-16
    800057de:	e406                	sd	ra,8(sp)
    800057e0:	e022                	sd	s0,0(sp)
    800057e2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800057e4:	906fc0ef          	jal	800018ea <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800057e8:	00d5151b          	slliw	a0,a0,0xd
    800057ec:	0c2017b7          	lui	a5,0xc201
    800057f0:	97aa                	add	a5,a5,a0
  return irq;
}
    800057f2:	43c8                	lw	a0,4(a5)
    800057f4:	60a2                	ld	ra,8(sp)
    800057f6:	6402                	ld	s0,0(sp)
    800057f8:	0141                	addi	sp,sp,16
    800057fa:	8082                	ret

00000000800057fc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800057fc:	1101                	addi	sp,sp,-32
    800057fe:	ec06                	sd	ra,24(sp)
    80005800:	e822                	sd	s0,16(sp)
    80005802:	e426                	sd	s1,8(sp)
    80005804:	1000                	addi	s0,sp,32
    80005806:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005808:	8e2fc0ef          	jal	800018ea <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000580c:	00d5151b          	slliw	a0,a0,0xd
    80005810:	0c2017b7          	lui	a5,0xc201
    80005814:	97aa                	add	a5,a5,a0
    80005816:	c3c4                	sw	s1,4(a5)
}
    80005818:	60e2                	ld	ra,24(sp)
    8000581a:	6442                	ld	s0,16(sp)
    8000581c:	64a2                	ld	s1,8(sp)
    8000581e:	6105                	addi	sp,sp,32
    80005820:	8082                	ret

0000000080005822 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005822:	1141                	addi	sp,sp,-16
    80005824:	e406                	sd	ra,8(sp)
    80005826:	e022                	sd	s0,0(sp)
    80005828:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000582a:	479d                	li	a5,7
    8000582c:	04a7ca63          	blt	a5,a0,80005880 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005830:	0001e797          	auipc	a5,0x1e
    80005834:	73078793          	addi	a5,a5,1840 # 80023f60 <disk>
    80005838:	97aa                	add	a5,a5,a0
    8000583a:	0187c783          	lbu	a5,24(a5)
    8000583e:	e7b9                	bnez	a5,8000588c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005840:	00451693          	slli	a3,a0,0x4
    80005844:	0001e797          	auipc	a5,0x1e
    80005848:	71c78793          	addi	a5,a5,1820 # 80023f60 <disk>
    8000584c:	6398                	ld	a4,0(a5)
    8000584e:	9736                	add	a4,a4,a3
    80005850:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005854:	6398                	ld	a4,0(a5)
    80005856:	9736                	add	a4,a4,a3
    80005858:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000585c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005860:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005864:	97aa                	add	a5,a5,a0
    80005866:	4705                	li	a4,1
    80005868:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000586c:	0001e517          	auipc	a0,0x1e
    80005870:	70c50513          	addi	a0,a0,1804 # 80023f78 <disk+0x18>
    80005874:	f44fc0ef          	jal	80001fb8 <wakeup>
}
    80005878:	60a2                	ld	ra,8(sp)
    8000587a:	6402                	ld	s0,0(sp)
    8000587c:	0141                	addi	sp,sp,16
    8000587e:	8082                	ret
    panic("free_desc 1");
    80005880:	00002517          	auipc	a0,0x2
    80005884:	e0050513          	addi	a0,a0,-512 # 80007680 <etext+0x680>
    80005888:	f0dfa0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    8000588c:	00002517          	auipc	a0,0x2
    80005890:	e0450513          	addi	a0,a0,-508 # 80007690 <etext+0x690>
    80005894:	f01fa0ef          	jal	80000794 <panic>

0000000080005898 <virtio_disk_init>:
{
    80005898:	1101                	addi	sp,sp,-32
    8000589a:	ec06                	sd	ra,24(sp)
    8000589c:	e822                	sd	s0,16(sp)
    8000589e:	e426                	sd	s1,8(sp)
    800058a0:	e04a                	sd	s2,0(sp)
    800058a2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800058a4:	00002597          	auipc	a1,0x2
    800058a8:	dfc58593          	addi	a1,a1,-516 # 800076a0 <etext+0x6a0>
    800058ac:	0001e517          	auipc	a0,0x1e
    800058b0:	7dc50513          	addi	a0,a0,2012 # 80024088 <disk+0x128>
    800058b4:	ac0fb0ef          	jal	80000b74 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800058b8:	100017b7          	lui	a5,0x10001
    800058bc:	4398                	lw	a4,0(a5)
    800058be:	2701                	sext.w	a4,a4
    800058c0:	747277b7          	lui	a5,0x74727
    800058c4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800058c8:	18f71063          	bne	a4,a5,80005a48 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800058cc:	100017b7          	lui	a5,0x10001
    800058d0:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800058d2:	439c                	lw	a5,0(a5)
    800058d4:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800058d6:	4709                	li	a4,2
    800058d8:	16e79863          	bne	a5,a4,80005a48 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800058dc:	100017b7          	lui	a5,0x10001
    800058e0:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    800058e2:	439c                	lw	a5,0(a5)
    800058e4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800058e6:	16e79163          	bne	a5,a4,80005a48 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800058ea:	100017b7          	lui	a5,0x10001
    800058ee:	47d8                	lw	a4,12(a5)
    800058f0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800058f2:	554d47b7          	lui	a5,0x554d4
    800058f6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800058fa:	14f71763          	bne	a4,a5,80005a48 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    800058fe:	100017b7          	lui	a5,0x10001
    80005902:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005906:	4705                	li	a4,1
    80005908:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000590a:	470d                	li	a4,3
    8000590c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000590e:	10001737          	lui	a4,0x10001
    80005912:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005914:	c7ffe737          	lui	a4,0xc7ffe
    80005918:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fda6bf>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000591c:	8ef9                	and	a3,a3,a4
    8000591e:	10001737          	lui	a4,0x10001
    80005922:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005924:	472d                	li	a4,11
    80005926:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005928:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    8000592c:	439c                	lw	a5,0(a5)
    8000592e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005932:	8ba1                	andi	a5,a5,8
    80005934:	12078063          	beqz	a5,80005a54 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005938:	100017b7          	lui	a5,0x10001
    8000593c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005940:	100017b7          	lui	a5,0x10001
    80005944:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005948:	439c                	lw	a5,0(a5)
    8000594a:	2781                	sext.w	a5,a5
    8000594c:	10079a63          	bnez	a5,80005a60 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005950:	100017b7          	lui	a5,0x10001
    80005954:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005958:	439c                	lw	a5,0(a5)
    8000595a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000595c:	10078863          	beqz	a5,80005a6c <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005960:	471d                	li	a4,7
    80005962:	10f77b63          	bgeu	a4,a5,80005a78 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005966:	9befb0ef          	jal	80000b24 <kalloc>
    8000596a:	0001e497          	auipc	s1,0x1e
    8000596e:	5f648493          	addi	s1,s1,1526 # 80023f60 <disk>
    80005972:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005974:	9b0fb0ef          	jal	80000b24 <kalloc>
    80005978:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000597a:	9aafb0ef          	jal	80000b24 <kalloc>
    8000597e:	87aa                	mv	a5,a0
    80005980:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005982:	6088                	ld	a0,0(s1)
    80005984:	10050063          	beqz	a0,80005a84 <virtio_disk_init+0x1ec>
    80005988:	0001e717          	auipc	a4,0x1e
    8000598c:	5e073703          	ld	a4,1504(a4) # 80023f68 <disk+0x8>
    80005990:	0e070a63          	beqz	a4,80005a84 <virtio_disk_init+0x1ec>
    80005994:	0e078863          	beqz	a5,80005a84 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005998:	6605                	lui	a2,0x1
    8000599a:	4581                	li	a1,0
    8000599c:	b2cfb0ef          	jal	80000cc8 <memset>
  memset(disk.avail, 0, PGSIZE);
    800059a0:	0001e497          	auipc	s1,0x1e
    800059a4:	5c048493          	addi	s1,s1,1472 # 80023f60 <disk>
    800059a8:	6605                	lui	a2,0x1
    800059aa:	4581                	li	a1,0
    800059ac:	6488                	ld	a0,8(s1)
    800059ae:	b1afb0ef          	jal	80000cc8 <memset>
  memset(disk.used, 0, PGSIZE);
    800059b2:	6605                	lui	a2,0x1
    800059b4:	4581                	li	a1,0
    800059b6:	6888                	ld	a0,16(s1)
    800059b8:	b10fb0ef          	jal	80000cc8 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800059bc:	100017b7          	lui	a5,0x10001
    800059c0:	4721                	li	a4,8
    800059c2:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800059c4:	4098                	lw	a4,0(s1)
    800059c6:	100017b7          	lui	a5,0x10001
    800059ca:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800059ce:	40d8                	lw	a4,4(s1)
    800059d0:	100017b7          	lui	a5,0x10001
    800059d4:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800059d8:	649c                	ld	a5,8(s1)
    800059da:	0007869b          	sext.w	a3,a5
    800059de:	10001737          	lui	a4,0x10001
    800059e2:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800059e6:	9781                	srai	a5,a5,0x20
    800059e8:	10001737          	lui	a4,0x10001
    800059ec:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800059f0:	689c                	ld	a5,16(s1)
    800059f2:	0007869b          	sext.w	a3,a5
    800059f6:	10001737          	lui	a4,0x10001
    800059fa:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800059fe:	9781                	srai	a5,a5,0x20
    80005a00:	10001737          	lui	a4,0x10001
    80005a04:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005a08:	10001737          	lui	a4,0x10001
    80005a0c:	4785                	li	a5,1
    80005a0e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005a10:	00f48c23          	sb	a5,24(s1)
    80005a14:	00f48ca3          	sb	a5,25(s1)
    80005a18:	00f48d23          	sb	a5,26(s1)
    80005a1c:	00f48da3          	sb	a5,27(s1)
    80005a20:	00f48e23          	sb	a5,28(s1)
    80005a24:	00f48ea3          	sb	a5,29(s1)
    80005a28:	00f48f23          	sb	a5,30(s1)
    80005a2c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005a30:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005a34:	100017b7          	lui	a5,0x10001
    80005a38:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    80005a3c:	60e2                	ld	ra,24(sp)
    80005a3e:	6442                	ld	s0,16(sp)
    80005a40:	64a2                	ld	s1,8(sp)
    80005a42:	6902                	ld	s2,0(sp)
    80005a44:	6105                	addi	sp,sp,32
    80005a46:	8082                	ret
    panic("could not find virtio disk");
    80005a48:	00002517          	auipc	a0,0x2
    80005a4c:	c6850513          	addi	a0,a0,-920 # 800076b0 <etext+0x6b0>
    80005a50:	d45fa0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005a54:	00002517          	auipc	a0,0x2
    80005a58:	c7c50513          	addi	a0,a0,-900 # 800076d0 <etext+0x6d0>
    80005a5c:	d39fa0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    80005a60:	00002517          	auipc	a0,0x2
    80005a64:	c9050513          	addi	a0,a0,-880 # 800076f0 <etext+0x6f0>
    80005a68:	d2dfa0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    80005a6c:	00002517          	auipc	a0,0x2
    80005a70:	ca450513          	addi	a0,a0,-860 # 80007710 <etext+0x710>
    80005a74:	d21fa0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005a78:	00002517          	auipc	a0,0x2
    80005a7c:	cb850513          	addi	a0,a0,-840 # 80007730 <etext+0x730>
    80005a80:	d15fa0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    80005a84:	00002517          	auipc	a0,0x2
    80005a88:	ccc50513          	addi	a0,a0,-820 # 80007750 <etext+0x750>
    80005a8c:	d09fa0ef          	jal	80000794 <panic>

0000000080005a90 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005a90:	7159                	addi	sp,sp,-112
    80005a92:	f486                	sd	ra,104(sp)
    80005a94:	f0a2                	sd	s0,96(sp)
    80005a96:	eca6                	sd	s1,88(sp)
    80005a98:	e8ca                	sd	s2,80(sp)
    80005a9a:	e4ce                	sd	s3,72(sp)
    80005a9c:	e0d2                	sd	s4,64(sp)
    80005a9e:	fc56                	sd	s5,56(sp)
    80005aa0:	f85a                	sd	s6,48(sp)
    80005aa2:	f45e                	sd	s7,40(sp)
    80005aa4:	f062                	sd	s8,32(sp)
    80005aa6:	ec66                	sd	s9,24(sp)
    80005aa8:	1880                	addi	s0,sp,112
    80005aaa:	8a2a                	mv	s4,a0
    80005aac:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005aae:	00c52c83          	lw	s9,12(a0)
    80005ab2:	001c9c9b          	slliw	s9,s9,0x1
    80005ab6:	1c82                	slli	s9,s9,0x20
    80005ab8:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005abc:	0001e517          	auipc	a0,0x1e
    80005ac0:	5cc50513          	addi	a0,a0,1484 # 80024088 <disk+0x128>
    80005ac4:	930fb0ef          	jal	80000bf4 <acquire>
  for(int i = 0; i < 3; i++){
    80005ac8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005aca:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005acc:	0001eb17          	auipc	s6,0x1e
    80005ad0:	494b0b13          	addi	s6,s6,1172 # 80023f60 <disk>
  for(int i = 0; i < 3; i++){
    80005ad4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005ad6:	0001ec17          	auipc	s8,0x1e
    80005ada:	5b2c0c13          	addi	s8,s8,1458 # 80024088 <disk+0x128>
    80005ade:	a8b9                	j	80005b3c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80005ae0:	00fb0733          	add	a4,s6,a5
    80005ae4:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80005ae8:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005aea:	0207c563          	bltz	a5,80005b14 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    80005aee:	2905                	addiw	s2,s2,1
    80005af0:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005af2:	05590963          	beq	s2,s5,80005b44 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80005af6:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80005af8:	0001e717          	auipc	a4,0x1e
    80005afc:	46870713          	addi	a4,a4,1128 # 80023f60 <disk>
    80005b00:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80005b02:	01874683          	lbu	a3,24(a4)
    80005b06:	fee9                	bnez	a3,80005ae0 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80005b08:	2785                	addiw	a5,a5,1
    80005b0a:	0705                	addi	a4,a4,1
    80005b0c:	fe979be3          	bne	a5,s1,80005b02 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80005b10:	57fd                	li	a5,-1
    80005b12:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80005b14:	01205d63          	blez	s2,80005b2e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005b18:	f9042503          	lw	a0,-112(s0)
    80005b1c:	d07ff0ef          	jal	80005822 <free_desc>
      for(int j = 0; j < i; j++)
    80005b20:	4785                	li	a5,1
    80005b22:	0127d663          	bge	a5,s2,80005b2e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80005b26:	f9442503          	lw	a0,-108(s0)
    80005b2a:	cf9ff0ef          	jal	80005822 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005b2e:	85e2                	mv	a1,s8
    80005b30:	0001e517          	auipc	a0,0x1e
    80005b34:	44850513          	addi	a0,a0,1096 # 80023f78 <disk+0x18>
    80005b38:	c34fc0ef          	jal	80001f6c <sleep>
  for(int i = 0; i < 3; i++){
    80005b3c:	f9040613          	addi	a2,s0,-112
    80005b40:	894e                	mv	s2,s3
    80005b42:	bf55                	j	80005af6 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005b44:	f9042503          	lw	a0,-112(s0)
    80005b48:	00451693          	slli	a3,a0,0x4

  if(write)
    80005b4c:	0001e797          	auipc	a5,0x1e
    80005b50:	41478793          	addi	a5,a5,1044 # 80023f60 <disk>
    80005b54:	00a50713          	addi	a4,a0,10
    80005b58:	0712                	slli	a4,a4,0x4
    80005b5a:	973e                	add	a4,a4,a5
    80005b5c:	01703633          	snez	a2,s7
    80005b60:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005b62:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005b66:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005b6a:	6398                	ld	a4,0(a5)
    80005b6c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005b6e:	0a868613          	addi	a2,a3,168
    80005b72:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005b74:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005b76:	6390                	ld	a2,0(a5)
    80005b78:	00d605b3          	add	a1,a2,a3
    80005b7c:	4741                	li	a4,16
    80005b7e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005b80:	4805                	li	a6,1
    80005b82:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005b86:	f9442703          	lw	a4,-108(s0)
    80005b8a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005b8e:	0712                	slli	a4,a4,0x4
    80005b90:	963a                	add	a2,a2,a4
    80005b92:	058a0593          	addi	a1,s4,88
    80005b96:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005b98:	0007b883          	ld	a7,0(a5)
    80005b9c:	9746                	add	a4,a4,a7
    80005b9e:	40000613          	li	a2,1024
    80005ba2:	c710                	sw	a2,8(a4)
  if(write)
    80005ba4:	001bb613          	seqz	a2,s7
    80005ba8:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005bac:	00166613          	ori	a2,a2,1
    80005bb0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005bb4:	f9842583          	lw	a1,-104(s0)
    80005bb8:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005bbc:	00250613          	addi	a2,a0,2
    80005bc0:	0612                	slli	a2,a2,0x4
    80005bc2:	963e                	add	a2,a2,a5
    80005bc4:	577d                	li	a4,-1
    80005bc6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005bca:	0592                	slli	a1,a1,0x4
    80005bcc:	98ae                	add	a7,a7,a1
    80005bce:	03068713          	addi	a4,a3,48
    80005bd2:	973e                	add	a4,a4,a5
    80005bd4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005bd8:	6398                	ld	a4,0(a5)
    80005bda:	972e                	add	a4,a4,a1
    80005bdc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005be0:	4689                	li	a3,2
    80005be2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005be6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005bea:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80005bee:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005bf2:	6794                	ld	a3,8(a5)
    80005bf4:	0026d703          	lhu	a4,2(a3)
    80005bf8:	8b1d                	andi	a4,a4,7
    80005bfa:	0706                	slli	a4,a4,0x1
    80005bfc:	96ba                	add	a3,a3,a4
    80005bfe:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005c02:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005c06:	6798                	ld	a4,8(a5)
    80005c08:	00275783          	lhu	a5,2(a4)
    80005c0c:	2785                	addiw	a5,a5,1
    80005c0e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005c12:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005c16:	100017b7          	lui	a5,0x10001
    80005c1a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005c1e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80005c22:	0001e917          	auipc	s2,0x1e
    80005c26:	46690913          	addi	s2,s2,1126 # 80024088 <disk+0x128>
  while(b->disk == 1) {
    80005c2a:	4485                	li	s1,1
    80005c2c:	01079a63          	bne	a5,a6,80005c40 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005c30:	85ca                	mv	a1,s2
    80005c32:	8552                	mv	a0,s4
    80005c34:	b38fc0ef          	jal	80001f6c <sleep>
  while(b->disk == 1) {
    80005c38:	004a2783          	lw	a5,4(s4)
    80005c3c:	fe978ae3          	beq	a5,s1,80005c30 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005c40:	f9042903          	lw	s2,-112(s0)
    80005c44:	00290713          	addi	a4,s2,2
    80005c48:	0712                	slli	a4,a4,0x4
    80005c4a:	0001e797          	auipc	a5,0x1e
    80005c4e:	31678793          	addi	a5,a5,790 # 80023f60 <disk>
    80005c52:	97ba                	add	a5,a5,a4
    80005c54:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005c58:	0001e997          	auipc	s3,0x1e
    80005c5c:	30898993          	addi	s3,s3,776 # 80023f60 <disk>
    80005c60:	00491713          	slli	a4,s2,0x4
    80005c64:	0009b783          	ld	a5,0(s3)
    80005c68:	97ba                	add	a5,a5,a4
    80005c6a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005c6e:	854a                	mv	a0,s2
    80005c70:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005c74:	bafff0ef          	jal	80005822 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005c78:	8885                	andi	s1,s1,1
    80005c7a:	f0fd                	bnez	s1,80005c60 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005c7c:	0001e517          	auipc	a0,0x1e
    80005c80:	40c50513          	addi	a0,a0,1036 # 80024088 <disk+0x128>
    80005c84:	808fb0ef          	jal	80000c8c <release>
}
    80005c88:	70a6                	ld	ra,104(sp)
    80005c8a:	7406                	ld	s0,96(sp)
    80005c8c:	64e6                	ld	s1,88(sp)
    80005c8e:	6946                	ld	s2,80(sp)
    80005c90:	69a6                	ld	s3,72(sp)
    80005c92:	6a06                	ld	s4,64(sp)
    80005c94:	7ae2                	ld	s5,56(sp)
    80005c96:	7b42                	ld	s6,48(sp)
    80005c98:	7ba2                	ld	s7,40(sp)
    80005c9a:	7c02                	ld	s8,32(sp)
    80005c9c:	6ce2                	ld	s9,24(sp)
    80005c9e:	6165                	addi	sp,sp,112
    80005ca0:	8082                	ret

0000000080005ca2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005ca2:	1101                	addi	sp,sp,-32
    80005ca4:	ec06                	sd	ra,24(sp)
    80005ca6:	e822                	sd	s0,16(sp)
    80005ca8:	e426                	sd	s1,8(sp)
    80005caa:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005cac:	0001e497          	auipc	s1,0x1e
    80005cb0:	2b448493          	addi	s1,s1,692 # 80023f60 <disk>
    80005cb4:	0001e517          	auipc	a0,0x1e
    80005cb8:	3d450513          	addi	a0,a0,980 # 80024088 <disk+0x128>
    80005cbc:	f39fa0ef          	jal	80000bf4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005cc0:	100017b7          	lui	a5,0x10001
    80005cc4:	53b8                	lw	a4,96(a5)
    80005cc6:	8b0d                	andi	a4,a4,3
    80005cc8:	100017b7          	lui	a5,0x10001
    80005ccc:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80005cce:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005cd2:	689c                	ld	a5,16(s1)
    80005cd4:	0204d703          	lhu	a4,32(s1)
    80005cd8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005cdc:	04f70663          	beq	a4,a5,80005d28 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80005ce0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005ce4:	6898                	ld	a4,16(s1)
    80005ce6:	0204d783          	lhu	a5,32(s1)
    80005cea:	8b9d                	andi	a5,a5,7
    80005cec:	078e                	slli	a5,a5,0x3
    80005cee:	97ba                	add	a5,a5,a4
    80005cf0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005cf2:	00278713          	addi	a4,a5,2
    80005cf6:	0712                	slli	a4,a4,0x4
    80005cf8:	9726                	add	a4,a4,s1
    80005cfa:	01074703          	lbu	a4,16(a4)
    80005cfe:	e321                	bnez	a4,80005d3e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005d00:	0789                	addi	a5,a5,2
    80005d02:	0792                	slli	a5,a5,0x4
    80005d04:	97a6                	add	a5,a5,s1
    80005d06:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005d08:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005d0c:	aacfc0ef          	jal	80001fb8 <wakeup>

    disk.used_idx += 1;
    80005d10:	0204d783          	lhu	a5,32(s1)
    80005d14:	2785                	addiw	a5,a5,1
    80005d16:	17c2                	slli	a5,a5,0x30
    80005d18:	93c1                	srli	a5,a5,0x30
    80005d1a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005d1e:	6898                	ld	a4,16(s1)
    80005d20:	00275703          	lhu	a4,2(a4)
    80005d24:	faf71ee3          	bne	a4,a5,80005ce0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005d28:	0001e517          	auipc	a0,0x1e
    80005d2c:	36050513          	addi	a0,a0,864 # 80024088 <disk+0x128>
    80005d30:	f5dfa0ef          	jal	80000c8c <release>
}
    80005d34:	60e2                	ld	ra,24(sp)
    80005d36:	6442                	ld	s0,16(sp)
    80005d38:	64a2                	ld	s1,8(sp)
    80005d3a:	6105                	addi	sp,sp,32
    80005d3c:	8082                	ret
      panic("virtio_disk_intr status");
    80005d3e:	00002517          	auipc	a0,0x2
    80005d42:	a2a50513          	addi	a0,a0,-1494 # 80007768 <etext+0x768>
    80005d46:	a4ffa0ef          	jal	80000794 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051573          	csrrw	a0,sscratch,a0
    80006004:	02153423          	sd	ra,40(a0)
    80006008:	02253823          	sd	sp,48(a0)
    8000600c:	02353c23          	sd	gp,56(a0)
    80006010:	04453023          	sd	tp,64(a0)
    80006014:	04553423          	sd	t0,72(a0)
    80006018:	04653823          	sd	t1,80(a0)
    8000601c:	04753c23          	sd	t2,88(a0)
    80006020:	f120                	sd	s0,96(a0)
    80006022:	f524                	sd	s1,104(a0)
    80006024:	fd2c                	sd	a1,120(a0)
    80006026:	e150                	sd	a2,128(a0)
    80006028:	e554                	sd	a3,136(a0)
    8000602a:	e958                	sd	a4,144(a0)
    8000602c:	ed5c                	sd	a5,152(a0)
    8000602e:	0b053023          	sd	a6,160(a0)
    80006032:	0b153423          	sd	a7,168(a0)
    80006036:	0b253823          	sd	s2,176(a0)
    8000603a:	0b353c23          	sd	s3,184(a0)
    8000603e:	0d453023          	sd	s4,192(a0)
    80006042:	0d553423          	sd	s5,200(a0)
    80006046:	0d653823          	sd	s6,208(a0)
    8000604a:	0d753c23          	sd	s7,216(a0)
    8000604e:	0f853023          	sd	s8,224(a0)
    80006052:	0f953423          	sd	s9,232(a0)
    80006056:	0fa53823          	sd	s10,240(a0)
    8000605a:	0fb53c23          	sd	s11,248(a0)
    8000605e:	11c53023          	sd	t3,256(a0)
    80006062:	11d53423          	sd	t4,264(a0)
    80006066:	11e53823          	sd	t5,272(a0)
    8000606a:	11f53c23          	sd	t6,280(a0)
    8000606e:	140022f3          	csrr	t0,sscratch
    80006072:	06553823          	sd	t0,112(a0)
    80006076:	00853103          	ld	sp,8(a0)
    8000607a:	02053203          	ld	tp,32(a0)
    8000607e:	01053283          	ld	t0,16(a0)
    80006082:	00053303          	ld	t1,0(a0)
    80006086:	12000073          	sfence.vma
    8000608a:	18031073          	csrw	satp,t1
    8000608e:	12000073          	sfence.vma
    80006092:	8282                	jr	t0

0000000080006094 <userret>:
    80006094:	12000073          	sfence.vma
    80006098:	18051073          	csrw	satp,a0
    8000609c:	12000073          	sfence.vma
    800060a0:	852e                	mv	a0,a1
    800060a2:	02853083          	ld	ra,40(a0)
    800060a6:	03053103          	ld	sp,48(a0)
    800060aa:	03853183          	ld	gp,56(a0)
    800060ae:	04053203          	ld	tp,64(a0)
    800060b2:	04853283          	ld	t0,72(a0)
    800060b6:	05053303          	ld	t1,80(a0)
    800060ba:	05853383          	ld	t2,88(a0)
    800060be:	7120                	ld	s0,96(a0)
    800060c0:	7524                	ld	s1,104(a0)
    800060c2:	7d2c                	ld	a1,120(a0)
    800060c4:	6150                	ld	a2,128(a0)
    800060c6:	6554                	ld	a3,136(a0)
    800060c8:	6958                	ld	a4,144(a0)
    800060ca:	6d5c                	ld	a5,152(a0)
    800060cc:	0a053803          	ld	a6,160(a0)
    800060d0:	0a853883          	ld	a7,168(a0)
    800060d4:	0b053903          	ld	s2,176(a0)
    800060d8:	0b853983          	ld	s3,184(a0)
    800060dc:	0c053a03          	ld	s4,192(a0)
    800060e0:	0c853a83          	ld	s5,200(a0)
    800060e4:	0d053b03          	ld	s6,208(a0)
    800060e8:	0d853b83          	ld	s7,216(a0)
    800060ec:	0e053c03          	ld	s8,224(a0)
    800060f0:	0e853c83          	ld	s9,232(a0)
    800060f4:	0f053d03          	ld	s10,240(a0)
    800060f8:	0f853d83          	ld	s11,248(a0)
    800060fc:	10053e03          	ld	t3,256(a0)
    80006100:	10853e83          	ld	t4,264(a0)
    80006104:	11053f03          	ld	t5,272(a0)
    80006108:	11853f83          	ld	t6,280(a0)
    8000610c:	7928                	ld	a0,112(a0)
    8000610e:	10200073          	sret
	...
