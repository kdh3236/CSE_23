
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	40013103          	ld	sp,1024(sp) # 8000a400 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fb9b057>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	f2878793          	addi	a5,a5,-216 # 80000fa8 <main>
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
    800000fa:	340020ef          	jal	8000243a <either_copyin>
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
    80000158:	30c50513          	addi	a0,a0,780 # 80012460 <cons>
    8000015c:	3df000ef          	jal	80000d3a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00012497          	auipc	s1,0x12
    80000164:	30048493          	addi	s1,s1,768 # 80012460 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00012917          	auipc	s2,0x12
    8000016c:	39090913          	addi	s2,s2,912 # 800124f8 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	147010ef          	jal	80001ac6 <myproc>
    80000184:	148020ef          	jal	800022cc <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	707010ef          	jal	80002094 <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00012717          	auipc	a4,0x12
    800001a4:	2c070713          	addi	a4,a4,704 # 80012460 <cons>
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
    800001d2:	21e020ef          	jal	800023f0 <either_copyout>
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
    800001ee:	27650513          	addi	a0,a0,630 # 80012460 <cons>
    800001f2:	3e1000ef          	jal	80000dd2 <release>
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
    80000218:	2ef72223          	sw	a5,740(a4) # 800124f8 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00012517          	auipc	a0,0x12
    8000022e:	23650513          	addi	a0,a0,566 # 80012460 <cons>
    80000232:	3a1000ef          	jal	80000dd2 <release>
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
    80000282:	1e250513          	addi	a0,a0,482 # 80012460 <cons>
    80000286:	2b5000ef          	jal	80000d3a <acquire>

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
    800002a0:	1e4020ef          	jal	80002484 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002a4:	00012517          	auipc	a0,0x12
    800002a8:	1bc50513          	addi	a0,a0,444 # 80012460 <cons>
    800002ac:	327000ef          	jal	80000dd2 <release>
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
    800002c6:	19e70713          	addi	a4,a4,414 # 80012460 <cons>
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
    800002ec:	17878793          	addi	a5,a5,376 # 80012460 <cons>
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
    8000031a:	1e27a783          	lw	a5,482(a5) # 800124f8 <cons+0x98>
    8000031e:	9f1d                	subw	a4,a4,a5
    80000320:	08000793          	li	a5,128
    80000324:	f8f710e3          	bne	a4,a5,800002a4 <consoleintr+0x32>
    80000328:	a07d                	j	800003d6 <consoleintr+0x164>
    8000032a:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000032c:	00012717          	auipc	a4,0x12
    80000330:	13470713          	addi	a4,a4,308 # 80012460 <cons>
    80000334:	0a072783          	lw	a5,160(a4)
    80000338:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000033c:	00012497          	auipc	s1,0x12
    80000340:	12448493          	addi	s1,s1,292 # 80012460 <cons>
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
    80000382:	0e270713          	addi	a4,a4,226 # 80012460 <cons>
    80000386:	0a072783          	lw	a5,160(a4)
    8000038a:	09c72703          	lw	a4,156(a4)
    8000038e:	f0f70be3          	beq	a4,a5,800002a4 <consoleintr+0x32>
      cons.e--;
    80000392:	37fd                	addiw	a5,a5,-1
    80000394:	00012717          	auipc	a4,0x12
    80000398:	16f72623          	sw	a5,364(a4) # 80012500 <cons+0xa0>
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
    800003b6:	0ae78793          	addi	a5,a5,174 # 80012460 <cons>
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
    800003da:	12c7a323          	sw	a2,294(a5) # 800124fc <cons+0x9c>
        wakeup(&cons.r);
    800003de:	00012517          	auipc	a0,0x12
    800003e2:	11a50513          	addi	a0,a0,282 # 800124f8 <cons+0x98>
    800003e6:	4fb010ef          	jal	800020e0 <wakeup>
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
    80000400:	06450513          	addi	a0,a0,100 # 80012460 <cons>
    80000404:	0b7000ef          	jal	80000cba <initlock>

  uartinit();
    80000408:	3f4000ef          	jal	800007fc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000040c:	00462797          	auipc	a5,0x462
    80000410:	20478793          	addi	a5,a5,516 # 80462610 <devsw>
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
    8000044a:	3aa60613          	addi	a2,a2,938 # 800077f0 <digits>
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
    800004e4:	0407a783          	lw	a5,64(a5) # 80012520 <pr+0x18>
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
    80000530:	fdc50513          	addi	a0,a0,-36 # 80012508 <pr>
    80000534:	007000ef          	jal	80000d3a <acquire>
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
    800006f0:	104b8b93          	addi	s7,s7,260 # 800077f0 <digits>
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
    8000078a:	d8250513          	addi	a0,a0,-638 # 80012508 <pr>
    8000078e:	644000ef          	jal	80000dd2 <release>
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
    800007a4:	d807a023          	sw	zero,-640(a5) # 80012520 <pr+0x18>
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
    800007c8:	c4f72e23          	sw	a5,-932(a4) # 8000a420 <panicked>
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
    800007dc:	d3048493          	addi	s1,s1,-720 # 80012508 <pr>
    800007e0:	00007597          	auipc	a1,0x7
    800007e4:	84858593          	addi	a1,a1,-1976 # 80007028 <etext+0x28>
    800007e8:	8526                	mv	a0,s1
    800007ea:	4d0000ef          	jal	80000cba <initlock>
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
    80000844:	ce850513          	addi	a0,a0,-792 # 80012528 <uart_tx_lock>
    80000848:	472000ef          	jal	80000cba <initlock>
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
    80000860:	49a000ef          	jal	80000cfa <push_off>

  if(panicked){
    80000864:	0000a797          	auipc	a5,0xa
    80000868:	bbc7a783          	lw	a5,-1092(a5) # 8000a420 <panicked>
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
    8000088a:	4f4000ef          	jal	80000d7e <pop_off>
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
    8000089e:	b8e7b783          	ld	a5,-1138(a5) # 8000a428 <uart_tx_r>
    800008a2:	0000a717          	auipc	a4,0xa
    800008a6:	b8e73703          	ld	a4,-1138(a4) # 8000a430 <uart_tx_w>
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
    800008cc:	c60a8a93          	addi	s5,s5,-928 # 80012528 <uart_tx_lock>
    uart_tx_r += 1;
    800008d0:	0000a497          	auipc	s1,0xa
    800008d4:	b5848493          	addi	s1,s1,-1192 # 8000a428 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008d8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008dc:	0000a997          	auipc	s3,0xa
    800008e0:	b5498993          	addi	s3,s3,-1196 # 8000a430 <uart_tx_w>
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
    800008fe:	7e2010ef          	jal	800020e0 <wakeup>
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
    80000950:	bdc50513          	addi	a0,a0,-1060 # 80012528 <uart_tx_lock>
    80000954:	3e6000ef          	jal	80000d3a <acquire>
  if(panicked){
    80000958:	0000a797          	auipc	a5,0xa
    8000095c:	ac87a783          	lw	a5,-1336(a5) # 8000a420 <panicked>
    80000960:	efbd                	bnez	a5,800009de <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000962:	0000a717          	auipc	a4,0xa
    80000966:	ace73703          	ld	a4,-1330(a4) # 8000a430 <uart_tx_w>
    8000096a:	0000a797          	auipc	a5,0xa
    8000096e:	abe7b783          	ld	a5,-1346(a5) # 8000a428 <uart_tx_r>
    80000972:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000976:	00012997          	auipc	s3,0x12
    8000097a:	bb298993          	addi	s3,s3,-1102 # 80012528 <uart_tx_lock>
    8000097e:	0000a497          	auipc	s1,0xa
    80000982:	aaa48493          	addi	s1,s1,-1366 # 8000a428 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000986:	0000a917          	auipc	s2,0xa
    8000098a:	aaa90913          	addi	s2,s2,-1366 # 8000a430 <uart_tx_w>
    8000098e:	00e79d63          	bne	a5,a4,800009a8 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000992:	85ce                	mv	a1,s3
    80000994:	8526                	mv	a0,s1
    80000996:	6fe010ef          	jal	80002094 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000099a:	00093703          	ld	a4,0(s2)
    8000099e:	609c                	ld	a5,0(s1)
    800009a0:	02078793          	addi	a5,a5,32
    800009a4:	fee787e3          	beq	a5,a4,80000992 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a8:	00012497          	auipc	s1,0x12
    800009ac:	b8048493          	addi	s1,s1,-1152 # 80012528 <uart_tx_lock>
    800009b0:	01f77793          	andi	a5,a4,31
    800009b4:	97a6                	add	a5,a5,s1
    800009b6:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ba:	0705                	addi	a4,a4,1
    800009bc:	0000a797          	auipc	a5,0xa
    800009c0:	a6e7ba23          	sd	a4,-1420(a5) # 8000a430 <uart_tx_w>
  uartstart();
    800009c4:	ed7ff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    800009c8:	8526                	mv	a0,s1
    800009ca:	408000ef          	jal	80000dd2 <release>
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
    80000a24:	b0848493          	addi	s1,s1,-1272 # 80012528 <uart_tx_lock>
    80000a28:	8526                	mv	a0,s1
    80000a2a:	310000ef          	jal	80000d3a <acquire>
  uartstart();
    80000a2e:	e6dff0ef          	jal	8000089a <uartstart>
  release(&uart_tx_lock);
    80000a32:	8526                	mv	a0,s1
    80000a34:	39e000ef          	jal	80000dd2 <release>
}
    80000a38:	60e2                	ld	ra,24(sp)
    80000a3a:	6442                	ld	s0,16(sp)
    80000a3c:	64a2                	ld	s1,8(sp)
    80000a3e:	6105                	addi	sp,sp,32
    80000a40:	8082                	ret

0000000080000a42 <getRefCount>:
void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

uint64 getRefCount(void *pa) {
    80000a42:	1101                	addi	sp,sp,-32
    80000a44:	ec06                	sd	ra,24(sp)
    80000a46:	e822                	sd	s0,16(sp)
    80000a48:	e426                	sd	s1,8(sp)
    80000a4a:	e04a                	sd	s2,0(sp)
    80000a4c:	1000                	addi	s0,sp,32
    80000a4e:	84aa                	mv	s1,a0
  int c;

  acquire(&ref_lock);
    80000a50:	00012917          	auipc	s2,0x12
    80000a54:	b1090913          	addi	s2,s2,-1264 # 80012560 <ref_lock>
    80000a58:	854a                	mv	a0,s2
    80000a5a:	2e0000ef          	jal	80000d3a <acquire>
  c = refCount[(uint64)pa / PGSIZE];
    80000a5e:	80b1                	srli	s1,s1,0xc
    80000a60:	048e                	slli	s1,s1,0x3
    80000a62:	00012797          	auipc	a5,0x12
    80000a66:	b3678793          	addi	a5,a5,-1226 # 80012598 <refCount>
    80000a6a:	97a6                	add	a5,a5,s1
    80000a6c:	4384                	lw	s1,0(a5)
  release(&ref_lock);
    80000a6e:	854a                	mv	a0,s2
    80000a70:	362000ef          	jal	80000dd2 <release>

  return c;
}
    80000a74:	8526                	mv	a0,s1
    80000a76:	60e2                	ld	ra,24(sp)
    80000a78:	6442                	ld	s0,16(sp)
    80000a7a:	64a2                	ld	s1,8(sp)
    80000a7c:	6902                	ld	s2,0(sp)
    80000a7e:	6105                	addi	sp,sp,32
    80000a80:	8082                	ret

0000000080000a82 <incRefCount>:

void incRefCount(void *pa) {
    80000a82:	1101                	addi	sp,sp,-32
    80000a84:	ec06                	sd	ra,24(sp)
    80000a86:	e822                	sd	s0,16(sp)
    80000a88:	e426                	sd	s1,8(sp)
    80000a8a:	e04a                	sd	s2,0(sp)
    80000a8c:	1000                	addi	s0,sp,32
    80000a8e:	84aa                	mv	s1,a0
  acquire(&ref_lock);
    80000a90:	00012917          	auipc	s2,0x12
    80000a94:	ad090913          	addi	s2,s2,-1328 # 80012560 <ref_lock>
    80000a98:	854a                	mv	a0,s2
    80000a9a:	2a0000ef          	jal	80000d3a <acquire>
  refCount[(uint64)pa / PGSIZE]++;
    80000a9e:	80b1                	srli	s1,s1,0xc
    80000aa0:	048e                	slli	s1,s1,0x3
    80000aa2:	00012797          	auipc	a5,0x12
    80000aa6:	af678793          	addi	a5,a5,-1290 # 80012598 <refCount>
    80000aaa:	97a6                	add	a5,a5,s1
    80000aac:	6398                	ld	a4,0(a5)
    80000aae:	0705                	addi	a4,a4,1
    80000ab0:	e398                	sd	a4,0(a5)
  release(&ref_lock);
    80000ab2:	854a                	mv	a0,s2
    80000ab4:	31e000ef          	jal	80000dd2 <release>
} 
    80000ab8:	60e2                	ld	ra,24(sp)
    80000aba:	6442                	ld	s0,16(sp)
    80000abc:	64a2                	ld	s1,8(sp)
    80000abe:	6902                	ld	s2,0(sp)
    80000ac0:	6105                	addi	sp,sp,32
    80000ac2:	8082                	ret

0000000080000ac4 <decRefCount>:

void decRefCount(void *pa) {
    80000ac4:	1101                	addi	sp,sp,-32
    80000ac6:	ec06                	sd	ra,24(sp)
    80000ac8:	e822                	sd	s0,16(sp)
    80000aca:	e426                	sd	s1,8(sp)
    80000acc:	e04a                	sd	s2,0(sp)
    80000ace:	1000                	addi	s0,sp,32
    80000ad0:	84aa                	mv	s1,a0
  acquire(&ref_lock);
    80000ad2:	00012917          	auipc	s2,0x12
    80000ad6:	a8e90913          	addi	s2,s2,-1394 # 80012560 <ref_lock>
    80000ada:	854a                	mv	a0,s2
    80000adc:	25e000ef          	jal	80000d3a <acquire>
  refCount[(uint64)pa / PGSIZE]--;
    80000ae0:	80b1                	srli	s1,s1,0xc
    80000ae2:	048e                	slli	s1,s1,0x3
    80000ae4:	00012797          	auipc	a5,0x12
    80000ae8:	ab478793          	addi	a5,a5,-1356 # 80012598 <refCount>
    80000aec:	97a6                	add	a5,a5,s1
    80000aee:	6398                	ld	a4,0(a5)
    80000af0:	177d                	addi	a4,a4,-1
    80000af2:	e398                	sd	a4,0(a5)
  release(&ref_lock);
    80000af4:	854a                	mv	a0,s2
    80000af6:	2dc000ef          	jal	80000dd2 <release>
}
    80000afa:	60e2                	ld	ra,24(sp)
    80000afc:	6442                	ld	s0,16(sp)
    80000afe:	64a2                	ld	s1,8(sp)
    80000b00:	6902                	ld	s2,0(sp)
    80000b02:	6105                	addi	sp,sp,32
    80000b04:	8082                	ret

0000000080000b06 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000b06:	7179                	addi	sp,sp,-48
    80000b08:	f406                	sd	ra,40(sp)
    80000b0a:	f022                	sd	s0,32(sp)
    80000b0c:	ec26                	sd	s1,24(sp)
    80000b0e:	1800                	addi	s0,sp,48
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000b10:	03451793          	slli	a5,a0,0x34
    80000b14:	eb85                	bnez	a5,80000b44 <kfree+0x3e>
    80000b16:	84aa                	mv	s1,a0
    80000b18:	00463797          	auipc	a5,0x463
    80000b1c:	c9078793          	addi	a5,a5,-880 # 804637a8 <end>
    80000b20:	02f56263          	bltu	a0,a5,80000b44 <kfree+0x3e>
    80000b24:	47c5                	li	a5,17
    80000b26:	07ee                	slli	a5,a5,0x1b
    80000b28:	00f57e63          	bgeu	a0,a5,80000b44 <kfree+0x3e>
      panic("kfree");
  
  if (getRefCount(pa) >= 1) decRefCount(pa);
    80000b2c:	f17ff0ef          	jal	80000a42 <getRefCount>
    80000b30:	e115                	bnez	a0,80000b54 <kfree+0x4e>

  if (getRefCount(pa) == 0) {
    80000b32:	8526                	mv	a0,s1
    80000b34:	f0fff0ef          	jal	80000a42 <getRefCount>
    80000b38:	c115                	beqz	a0,80000b5c <kfree+0x56>
    acquire(&kmem.lock);
    r->next = kmem.freelist;
    kmem.freelist = r;
    release(&kmem.lock);
  }
}
    80000b3a:	70a2                	ld	ra,40(sp)
    80000b3c:	7402                	ld	s0,32(sp)
    80000b3e:	64e2                	ld	s1,24(sp)
    80000b40:	6145                	addi	sp,sp,48
    80000b42:	8082                	ret
    80000b44:	e84a                	sd	s2,16(sp)
    80000b46:	e44e                	sd	s3,8(sp)
      panic("kfree");
    80000b48:	00006517          	auipc	a0,0x6
    80000b4c:	4f050513          	addi	a0,a0,1264 # 80007038 <etext+0x38>
    80000b50:	c45ff0ef          	jal	80000794 <panic>
  if (getRefCount(pa) >= 1) decRefCount(pa);
    80000b54:	8526                	mv	a0,s1
    80000b56:	f6fff0ef          	jal	80000ac4 <decRefCount>
    80000b5a:	bfe1                	j	80000b32 <kfree+0x2c>
    80000b5c:	e84a                	sd	s2,16(sp)
    80000b5e:	e44e                	sd	s3,8(sp)
    memset(pa, 1, PGSIZE);
    80000b60:	6605                	lui	a2,0x1
    80000b62:	4585                	li	a1,1
    80000b64:	8526                	mv	a0,s1
    80000b66:	2a8000ef          	jal	80000e0e <memset>
    acquire(&kmem.lock);
    80000b6a:	00012997          	auipc	s3,0x12
    80000b6e:	9f698993          	addi	s3,s3,-1546 # 80012560 <ref_lock>
    80000b72:	00012917          	auipc	s2,0x12
    80000b76:	a0690913          	addi	s2,s2,-1530 # 80012578 <kmem>
    80000b7a:	854a                	mv	a0,s2
    80000b7c:	1be000ef          	jal	80000d3a <acquire>
    r->next = kmem.freelist;
    80000b80:	0309b783          	ld	a5,48(s3)
    80000b84:	e09c                	sd	a5,0(s1)
    kmem.freelist = r;
    80000b86:	0299b823          	sd	s1,48(s3)
    release(&kmem.lock);
    80000b8a:	854a                	mv	a0,s2
    80000b8c:	246000ef          	jal	80000dd2 <release>
    80000b90:	6942                	ld	s2,16(sp)
    80000b92:	69a2                	ld	s3,8(sp)
}
    80000b94:	b75d                	j	80000b3a <kfree+0x34>

0000000080000b96 <freerange>:
{
    80000b96:	7179                	addi	sp,sp,-48
    80000b98:	f406                	sd	ra,40(sp)
    80000b9a:	f022                	sd	s0,32(sp)
    80000b9c:	ec26                	sd	s1,24(sp)
    80000b9e:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ba0:	6785                	lui	a5,0x1
    80000ba2:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ba6:	00e504b3          	add	s1,a0,a4
    80000baa:	777d                	lui	a4,0xfffff
    80000bac:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000bae:	94be                	add	s1,s1,a5
    80000bb0:	0295e263          	bltu	a1,s1,80000bd4 <freerange+0x3e>
    80000bb4:	e84a                	sd	s2,16(sp)
    80000bb6:	e44e                	sd	s3,8(sp)
    80000bb8:	e052                	sd	s4,0(sp)
    80000bba:	892e                	mv	s2,a1
    kfree(p);
    80000bbc:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000bbe:	6985                	lui	s3,0x1
    kfree(p);
    80000bc0:	01448533          	add	a0,s1,s4
    80000bc4:	f43ff0ef          	jal	80000b06 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000bc8:	94ce                	add	s1,s1,s3
    80000bca:	fe997be3          	bgeu	s2,s1,80000bc0 <freerange+0x2a>
    80000bce:	6942                	ld	s2,16(sp)
    80000bd0:	69a2                	ld	s3,8(sp)
    80000bd2:	6a02                	ld	s4,0(sp)
}
    80000bd4:	70a2                	ld	ra,40(sp)
    80000bd6:	7402                	ld	s0,32(sp)
    80000bd8:	64e2                	ld	s1,24(sp)
    80000bda:	6145                	addi	sp,sp,48
    80000bdc:	8082                	ret

0000000080000bde <kinit>:
{
    80000bde:	1141                	addi	sp,sp,-16
    80000be0:	e406                	sd	ra,8(sp)
    80000be2:	e022                	sd	s0,0(sp)
    80000be4:	0800                	addi	s0,sp,16
  initlock(&ref_lock, "refLock");
    80000be6:	00006597          	auipc	a1,0x6
    80000bea:	45a58593          	addi	a1,a1,1114 # 80007040 <etext+0x40>
    80000bee:	00012517          	auipc	a0,0x12
    80000bf2:	97250513          	addi	a0,a0,-1678 # 80012560 <ref_lock>
    80000bf6:	0c4000ef          	jal	80000cba <initlock>
  initlock(&kmem.lock, "kmem");
    80000bfa:	00006597          	auipc	a1,0x6
    80000bfe:	44e58593          	addi	a1,a1,1102 # 80007048 <etext+0x48>
    80000c02:	00012517          	auipc	a0,0x12
    80000c06:	97650513          	addi	a0,a0,-1674 # 80012578 <kmem>
    80000c0a:	0b0000ef          	jal	80000cba <initlock>
  memset(refCount, 0, sizeof(refCount));
    80000c0e:	00440637          	lui	a2,0x440
    80000c12:	4581                	li	a1,0
    80000c14:	00012517          	auipc	a0,0x12
    80000c18:	98450513          	addi	a0,a0,-1660 # 80012598 <refCount>
    80000c1c:	1f2000ef          	jal	80000e0e <memset>
  freerange(end, (void*)PHYSTOP);
    80000c20:	45c5                	li	a1,17
    80000c22:	05ee                	slli	a1,a1,0x1b
    80000c24:	00463517          	auipc	a0,0x463
    80000c28:	b8450513          	addi	a0,a0,-1148 # 804637a8 <end>
    80000c2c:	f6bff0ef          	jal	80000b96 <freerange>
}
    80000c30:	60a2                	ld	ra,8(sp)
    80000c32:	6402                	ld	s0,0(sp)
    80000c34:	0141                	addi	sp,sp,16
    80000c36:	8082                	ret

0000000080000c38 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000c38:	1101                	addi	sp,sp,-32
    80000c3a:	ec06                	sd	ra,24(sp)
    80000c3c:	e822                	sd	s0,16(sp)
    80000c3e:	e426                	sd	s1,8(sp)
    80000c40:	1000                	addi	s0,sp,32
  // free page가 linked list로 관리됨
  // run은 linked list의 Node
  struct run *r;

  acquire(&kmem.lock);
    80000c42:	00012517          	auipc	a0,0x12
    80000c46:	93650513          	addi	a0,a0,-1738 # 80012578 <kmem>
    80000c4a:	0f0000ef          	jal	80000d3a <acquire>
  // freelist의 가장 첫 번째 page를 가져옴
  r = kmem.freelist;
    80000c4e:	00012497          	auipc	s1,0x12
    80000c52:	9424b483          	ld	s1,-1726(s1) # 80012590 <kmem+0x18>
  if(r)
    80000c56:	c8b9                	beqz	s1,80000cac <kalloc+0x74>
    80000c58:	e04a                	sd	s2,0(sp)
    kmem.freelist = r->next;
    80000c5a:	609c                	ld	a5,0(s1)
    80000c5c:	00012917          	auipc	s2,0x12
    80000c60:	90490913          	addi	s2,s2,-1788 # 80012560 <ref_lock>
    80000c64:	02f93823          	sd	a5,48(s2)
  release(&kmem.lock);
    80000c68:	00012517          	auipc	a0,0x12
    80000c6c:	91050513          	addi	a0,a0,-1776 # 80012578 <kmem>
    80000c70:	162000ef          	jal	80000dd2 <release>

  if(r) {
    acquire(&ref_lock);
    80000c74:	854a                	mv	a0,s2
    80000c76:	0c4000ef          	jal	80000d3a <acquire>
    refCount[(uint64)r / PGSIZE] = 1;
    80000c7a:	00c4d713          	srli	a4,s1,0xc
    80000c7e:	070e                	slli	a4,a4,0x3
    80000c80:	00012797          	auipc	a5,0x12
    80000c84:	91878793          	addi	a5,a5,-1768 # 80012598 <refCount>
    80000c88:	97ba                	add	a5,a5,a4
    80000c8a:	4705                	li	a4,1
    80000c8c:	e398                	sd	a4,0(a5)
    release(&ref_lock);
    80000c8e:	854a                	mv	a0,s2
    80000c90:	142000ef          	jal	80000dd2 <release>
    // page 전체를 0x5로 채움
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000c94:	6605                	lui	a2,0x1
    80000c96:	4595                	li	a1,5
    80000c98:	8526                	mv	a0,s1
    80000c9a:	174000ef          	jal	80000e0e <memset>
  }
  return (void*)r;
    80000c9e:	6902                	ld	s2,0(sp)
}
    80000ca0:	8526                	mv	a0,s1
    80000ca2:	60e2                	ld	ra,24(sp)
    80000ca4:	6442                	ld	s0,16(sp)
    80000ca6:	64a2                	ld	s1,8(sp)
    80000ca8:	6105                	addi	sp,sp,32
    80000caa:	8082                	ret
  release(&kmem.lock);
    80000cac:	00012517          	auipc	a0,0x12
    80000cb0:	8cc50513          	addi	a0,a0,-1844 # 80012578 <kmem>
    80000cb4:	11e000ef          	jal	80000dd2 <release>
  if(r) {
    80000cb8:	b7e5                	j	80000ca0 <kalloc+0x68>

0000000080000cba <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000cba:	1141                	addi	sp,sp,-16
    80000cbc:	e422                	sd	s0,8(sp)
    80000cbe:	0800                	addi	s0,sp,16
  lk->name = name;
    80000cc0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000cc2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000cc6:	00053823          	sd	zero,16(a0)
}
    80000cca:	6422                	ld	s0,8(sp)
    80000ccc:	0141                	addi	sp,sp,16
    80000cce:	8082                	ret

0000000080000cd0 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000cd0:	411c                	lw	a5,0(a0)
    80000cd2:	e399                	bnez	a5,80000cd8 <holding+0x8>
    80000cd4:	4501                	li	a0,0
  return r;
}
    80000cd6:	8082                	ret
{
    80000cd8:	1101                	addi	sp,sp,-32
    80000cda:	ec06                	sd	ra,24(sp)
    80000cdc:	e822                	sd	s0,16(sp)
    80000cde:	e426                	sd	s1,8(sp)
    80000ce0:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ce2:	6904                	ld	s1,16(a0)
    80000ce4:	5c7000ef          	jal	80001aaa <mycpu>
    80000ce8:	40a48533          	sub	a0,s1,a0
    80000cec:	00153513          	seqz	a0,a0
}
    80000cf0:	60e2                	ld	ra,24(sp)
    80000cf2:	6442                	ld	s0,16(sp)
    80000cf4:	64a2                	ld	s1,8(sp)
    80000cf6:	6105                	addi	sp,sp,32
    80000cf8:	8082                	ret

0000000080000cfa <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000cfa:	1101                	addi	sp,sp,-32
    80000cfc:	ec06                	sd	ra,24(sp)
    80000cfe:	e822                	sd	s0,16(sp)
    80000d00:	e426                	sd	s1,8(sp)
    80000d02:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d04:	100024f3          	csrr	s1,sstatus
    80000d08:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000d0c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000d0e:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000d12:	599000ef          	jal	80001aaa <mycpu>
    80000d16:	5d3c                	lw	a5,120(a0)
    80000d18:	cb99                	beqz	a5,80000d2e <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000d1a:	591000ef          	jal	80001aaa <mycpu>
    80000d1e:	5d3c                	lw	a5,120(a0)
    80000d20:	2785                	addiw	a5,a5,1
    80000d22:	dd3c                	sw	a5,120(a0)
}
    80000d24:	60e2                	ld	ra,24(sp)
    80000d26:	6442                	ld	s0,16(sp)
    80000d28:	64a2                	ld	s1,8(sp)
    80000d2a:	6105                	addi	sp,sp,32
    80000d2c:	8082                	ret
    mycpu()->intena = old;
    80000d2e:	57d000ef          	jal	80001aaa <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000d32:	8085                	srli	s1,s1,0x1
    80000d34:	8885                	andi	s1,s1,1
    80000d36:	dd64                	sw	s1,124(a0)
    80000d38:	b7cd                	j	80000d1a <push_off+0x20>

0000000080000d3a <acquire>:
{
    80000d3a:	1101                	addi	sp,sp,-32
    80000d3c:	ec06                	sd	ra,24(sp)
    80000d3e:	e822                	sd	s0,16(sp)
    80000d40:	e426                	sd	s1,8(sp)
    80000d42:	1000                	addi	s0,sp,32
    80000d44:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000d46:	fb5ff0ef          	jal	80000cfa <push_off>
  if(holding(lk))
    80000d4a:	8526                	mv	a0,s1
    80000d4c:	f85ff0ef          	jal	80000cd0 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d50:	4705                	li	a4,1
  if(holding(lk))
    80000d52:	e105                	bnez	a0,80000d72 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000d54:	87ba                	mv	a5,a4
    80000d56:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000d5a:	2781                	sext.w	a5,a5
    80000d5c:	ffe5                	bnez	a5,80000d54 <acquire+0x1a>
  __sync_synchronize();
    80000d5e:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000d62:	549000ef          	jal	80001aaa <mycpu>
    80000d66:	e888                	sd	a0,16(s1)
}
    80000d68:	60e2                	ld	ra,24(sp)
    80000d6a:	6442                	ld	s0,16(sp)
    80000d6c:	64a2                	ld	s1,8(sp)
    80000d6e:	6105                	addi	sp,sp,32
    80000d70:	8082                	ret
    panic("acquire");
    80000d72:	00006517          	auipc	a0,0x6
    80000d76:	2de50513          	addi	a0,a0,734 # 80007050 <etext+0x50>
    80000d7a:	a1bff0ef          	jal	80000794 <panic>

0000000080000d7e <pop_off>:

void
pop_off(void)
{
    80000d7e:	1141                	addi	sp,sp,-16
    80000d80:	e406                	sd	ra,8(sp)
    80000d82:	e022                	sd	s0,0(sp)
    80000d84:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000d86:	525000ef          	jal	80001aaa <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d8a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000d8e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000d90:	e78d                	bnez	a5,80000dba <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000d92:	5d3c                	lw	a5,120(a0)
    80000d94:	02f05963          	blez	a5,80000dc6 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000d98:	37fd                	addiw	a5,a5,-1
    80000d9a:	0007871b          	sext.w	a4,a5
    80000d9e:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000da0:	eb09                	bnez	a4,80000db2 <pop_off+0x34>
    80000da2:	5d7c                	lw	a5,124(a0)
    80000da4:	c799                	beqz	a5,80000db2 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000da6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000daa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000dae:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000db2:	60a2                	ld	ra,8(sp)
    80000db4:	6402                	ld	s0,0(sp)
    80000db6:	0141                	addi	sp,sp,16
    80000db8:	8082                	ret
    panic("pop_off - interruptible");
    80000dba:	00006517          	auipc	a0,0x6
    80000dbe:	29e50513          	addi	a0,a0,670 # 80007058 <etext+0x58>
    80000dc2:	9d3ff0ef          	jal	80000794 <panic>
    panic("pop_off");
    80000dc6:	00006517          	auipc	a0,0x6
    80000dca:	2aa50513          	addi	a0,a0,682 # 80007070 <etext+0x70>
    80000dce:	9c7ff0ef          	jal	80000794 <panic>

0000000080000dd2 <release>:
{
    80000dd2:	1101                	addi	sp,sp,-32
    80000dd4:	ec06                	sd	ra,24(sp)
    80000dd6:	e822                	sd	s0,16(sp)
    80000dd8:	e426                	sd	s1,8(sp)
    80000dda:	1000                	addi	s0,sp,32
    80000ddc:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000dde:	ef3ff0ef          	jal	80000cd0 <holding>
    80000de2:	c105                	beqz	a0,80000e02 <release+0x30>
  lk->cpu = 0;
    80000de4:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000de8:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000dec:	0310000f          	fence	rw,w
    80000df0:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000df4:	f8bff0ef          	jal	80000d7e <pop_off>
}
    80000df8:	60e2                	ld	ra,24(sp)
    80000dfa:	6442                	ld	s0,16(sp)
    80000dfc:	64a2                	ld	s1,8(sp)
    80000dfe:	6105                	addi	sp,sp,32
    80000e00:	8082                	ret
    panic("release");
    80000e02:	00006517          	auipc	a0,0x6
    80000e06:	27650513          	addi	a0,a0,630 # 80007078 <etext+0x78>
    80000e0a:	98bff0ef          	jal	80000794 <panic>

0000000080000e0e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000e0e:	1141                	addi	sp,sp,-16
    80000e10:	e422                	sd	s0,8(sp)
    80000e12:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000e14:	ca19                	beqz	a2,80000e2a <memset+0x1c>
    80000e16:	87aa                	mv	a5,a0
    80000e18:	1602                	slli	a2,a2,0x20
    80000e1a:	9201                	srli	a2,a2,0x20
    80000e1c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000e20:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000e24:	0785                	addi	a5,a5,1
    80000e26:	fee79de3          	bne	a5,a4,80000e20 <memset+0x12>
  }
  return dst;
}
    80000e2a:	6422                	ld	s0,8(sp)
    80000e2c:	0141                	addi	sp,sp,16
    80000e2e:	8082                	ret

0000000080000e30 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000e30:	1141                	addi	sp,sp,-16
    80000e32:	e422                	sd	s0,8(sp)
    80000e34:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000e36:	ca05                	beqz	a2,80000e66 <memcmp+0x36>
    80000e38:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000e3c:	1682                	slli	a3,a3,0x20
    80000e3e:	9281                	srli	a3,a3,0x20
    80000e40:	0685                	addi	a3,a3,1
    80000e42:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000e44:	00054783          	lbu	a5,0(a0)
    80000e48:	0005c703          	lbu	a4,0(a1)
    80000e4c:	00e79863          	bne	a5,a4,80000e5c <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000e50:	0505                	addi	a0,a0,1
    80000e52:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000e54:	fed518e3          	bne	a0,a3,80000e44 <memcmp+0x14>
  }

  return 0;
    80000e58:	4501                	li	a0,0
    80000e5a:	a019                	j	80000e60 <memcmp+0x30>
      return *s1 - *s2;
    80000e5c:	40e7853b          	subw	a0,a5,a4
}
    80000e60:	6422                	ld	s0,8(sp)
    80000e62:	0141                	addi	sp,sp,16
    80000e64:	8082                	ret
  return 0;
    80000e66:	4501                	li	a0,0
    80000e68:	bfe5                	j	80000e60 <memcmp+0x30>

0000000080000e6a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000e6a:	1141                	addi	sp,sp,-16
    80000e6c:	e422                	sd	s0,8(sp)
    80000e6e:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000e70:	c205                	beqz	a2,80000e90 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e72:	02a5e263          	bltu	a1,a0,80000e96 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e76:	1602                	slli	a2,a2,0x20
    80000e78:	9201                	srli	a2,a2,0x20
    80000e7a:	00c587b3          	add	a5,a1,a2
{
    80000e7e:	872a                	mv	a4,a0
      *d++ = *s++;
    80000e80:	0585                	addi	a1,a1,1
    80000e82:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fb9b859>
    80000e84:	fff5c683          	lbu	a3,-1(a1)
    80000e88:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000e8c:	feb79ae3          	bne	a5,a1,80000e80 <memmove+0x16>

  return dst;
}
    80000e90:	6422                	ld	s0,8(sp)
    80000e92:	0141                	addi	sp,sp,16
    80000e94:	8082                	ret
  if(s < d && s + n > d){
    80000e96:	02061693          	slli	a3,a2,0x20
    80000e9a:	9281                	srli	a3,a3,0x20
    80000e9c:	00d58733          	add	a4,a1,a3
    80000ea0:	fce57be3          	bgeu	a0,a4,80000e76 <memmove+0xc>
    d += n;
    80000ea4:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000ea6:	fff6079b          	addiw	a5,a2,-1
    80000eaa:	1782                	slli	a5,a5,0x20
    80000eac:	9381                	srli	a5,a5,0x20
    80000eae:	fff7c793          	not	a5,a5
    80000eb2:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000eb4:	177d                	addi	a4,a4,-1
    80000eb6:	16fd                	addi	a3,a3,-1
    80000eb8:	00074603          	lbu	a2,0(a4)
    80000ebc:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000ec0:	fef71ae3          	bne	a4,a5,80000eb4 <memmove+0x4a>
    80000ec4:	b7f1                	j	80000e90 <memmove+0x26>

0000000080000ec6 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000ec6:	1141                	addi	sp,sp,-16
    80000ec8:	e406                	sd	ra,8(sp)
    80000eca:	e022                	sd	s0,0(sp)
    80000ecc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000ece:	f9dff0ef          	jal	80000e6a <memmove>
}
    80000ed2:	60a2                	ld	ra,8(sp)
    80000ed4:	6402                	ld	s0,0(sp)
    80000ed6:	0141                	addi	sp,sp,16
    80000ed8:	8082                	ret

0000000080000eda <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000eda:	1141                	addi	sp,sp,-16
    80000edc:	e422                	sd	s0,8(sp)
    80000ede:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000ee0:	ce11                	beqz	a2,80000efc <strncmp+0x22>
    80000ee2:	00054783          	lbu	a5,0(a0)
    80000ee6:	cf89                	beqz	a5,80000f00 <strncmp+0x26>
    80000ee8:	0005c703          	lbu	a4,0(a1)
    80000eec:	00f71a63          	bne	a4,a5,80000f00 <strncmp+0x26>
    n--, p++, q++;
    80000ef0:	367d                	addiw	a2,a2,-1
    80000ef2:	0505                	addi	a0,a0,1
    80000ef4:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000ef6:	f675                	bnez	a2,80000ee2 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000ef8:	4501                	li	a0,0
    80000efa:	a801                	j	80000f0a <strncmp+0x30>
    80000efc:	4501                	li	a0,0
    80000efe:	a031                	j	80000f0a <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000f00:	00054503          	lbu	a0,0(a0)
    80000f04:	0005c783          	lbu	a5,0(a1)
    80000f08:	9d1d                	subw	a0,a0,a5
}
    80000f0a:	6422                	ld	s0,8(sp)
    80000f0c:	0141                	addi	sp,sp,16
    80000f0e:	8082                	ret

0000000080000f10 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000f10:	1141                	addi	sp,sp,-16
    80000f12:	e422                	sd	s0,8(sp)
    80000f14:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000f16:	87aa                	mv	a5,a0
    80000f18:	86b2                	mv	a3,a2
    80000f1a:	367d                	addiw	a2,a2,-1
    80000f1c:	02d05563          	blez	a3,80000f46 <strncpy+0x36>
    80000f20:	0785                	addi	a5,a5,1
    80000f22:	0005c703          	lbu	a4,0(a1)
    80000f26:	fee78fa3          	sb	a4,-1(a5)
    80000f2a:	0585                	addi	a1,a1,1
    80000f2c:	f775                	bnez	a4,80000f18 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000f2e:	873e                	mv	a4,a5
    80000f30:	9fb5                	addw	a5,a5,a3
    80000f32:	37fd                	addiw	a5,a5,-1
    80000f34:	00c05963          	blez	a2,80000f46 <strncpy+0x36>
    *s++ = 0;
    80000f38:	0705                	addi	a4,a4,1
    80000f3a:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000f3e:	40e786bb          	subw	a3,a5,a4
    80000f42:	fed04be3          	bgtz	a3,80000f38 <strncpy+0x28>
  return os;
}
    80000f46:	6422                	ld	s0,8(sp)
    80000f48:	0141                	addi	sp,sp,16
    80000f4a:	8082                	ret

0000000080000f4c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000f4c:	1141                	addi	sp,sp,-16
    80000f4e:	e422                	sd	s0,8(sp)
    80000f50:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000f52:	02c05363          	blez	a2,80000f78 <safestrcpy+0x2c>
    80000f56:	fff6069b          	addiw	a3,a2,-1
    80000f5a:	1682                	slli	a3,a3,0x20
    80000f5c:	9281                	srli	a3,a3,0x20
    80000f5e:	96ae                	add	a3,a3,a1
    80000f60:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f62:	00d58963          	beq	a1,a3,80000f74 <safestrcpy+0x28>
    80000f66:	0585                	addi	a1,a1,1
    80000f68:	0785                	addi	a5,a5,1
    80000f6a:	fff5c703          	lbu	a4,-1(a1)
    80000f6e:	fee78fa3          	sb	a4,-1(a5)
    80000f72:	fb65                	bnez	a4,80000f62 <safestrcpy+0x16>
    ;
  *s = 0;
    80000f74:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f78:	6422                	ld	s0,8(sp)
    80000f7a:	0141                	addi	sp,sp,16
    80000f7c:	8082                	ret

0000000080000f7e <strlen>:

int
strlen(const char *s)
{
    80000f7e:	1141                	addi	sp,sp,-16
    80000f80:	e422                	sd	s0,8(sp)
    80000f82:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000f84:	00054783          	lbu	a5,0(a0)
    80000f88:	cf91                	beqz	a5,80000fa4 <strlen+0x26>
    80000f8a:	0505                	addi	a0,a0,1
    80000f8c:	87aa                	mv	a5,a0
    80000f8e:	86be                	mv	a3,a5
    80000f90:	0785                	addi	a5,a5,1
    80000f92:	fff7c703          	lbu	a4,-1(a5)
    80000f96:	ff65                	bnez	a4,80000f8e <strlen+0x10>
    80000f98:	40a6853b          	subw	a0,a3,a0
    80000f9c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000f9e:	6422                	ld	s0,8(sp)
    80000fa0:	0141                	addi	sp,sp,16
    80000fa2:	8082                	ret
  for(n = 0; s[n]; n++)
    80000fa4:	4501                	li	a0,0
    80000fa6:	bfe5                	j	80000f9e <strlen+0x20>

0000000080000fa8 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000fa8:	1141                	addi	sp,sp,-16
    80000faa:	e406                	sd	ra,8(sp)
    80000fac:	e022                	sd	s0,0(sp)
    80000fae:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000fb0:	2eb000ef          	jal	80001a9a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000fb4:	00009717          	auipc	a4,0x9
    80000fb8:	48470713          	addi	a4,a4,1156 # 8000a438 <started>
  if(cpuid() == 0){
    80000fbc:	c51d                	beqz	a0,80000fea <main+0x42>
    while(started == 0)
    80000fbe:	431c                	lw	a5,0(a4)
    80000fc0:	2781                	sext.w	a5,a5
    80000fc2:	dff5                	beqz	a5,80000fbe <main+0x16>
      ;
    __sync_synchronize();
    80000fc4:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000fc8:	2d3000ef          	jal	80001a9a <cpuid>
    80000fcc:	85aa                	mv	a1,a0
    80000fce:	00006517          	auipc	a0,0x6
    80000fd2:	0d250513          	addi	a0,a0,210 # 800070a0 <etext+0xa0>
    80000fd6:	cecff0ef          	jal	800004c2 <printf>
    kvminithart();    // turn on paging
    80000fda:	080000ef          	jal	8000105a <kvminithart>
    trapinithart();   // install kernel trap vector
    80000fde:	5d8010ef          	jal	800025b6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000fe2:	7c6040ef          	jal	800057a8 <plicinithart>
  }

  scheduler();        
    80000fe6:	715000ef          	jal	80001efa <scheduler>
    consoleinit();
    80000fea:	c02ff0ef          	jal	800003ec <consoleinit>
    printfinit();
    80000fee:	fe0ff0ef          	jal	800007ce <printfinit>
    printf("\n");
    80000ff2:	00006517          	auipc	a0,0x6
    80000ff6:	08e50513          	addi	a0,a0,142 # 80007080 <etext+0x80>
    80000ffa:	cc8ff0ef          	jal	800004c2 <printf>
    printf("xv6 kernel is booting\n");
    80000ffe:	00006517          	auipc	a0,0x6
    80001002:	08a50513          	addi	a0,a0,138 # 80007088 <etext+0x88>
    80001006:	cbcff0ef          	jal	800004c2 <printf>
    printf("\n");
    8000100a:	00006517          	auipc	a0,0x6
    8000100e:	07650513          	addi	a0,a0,118 # 80007080 <etext+0x80>
    80001012:	cb0ff0ef          	jal	800004c2 <printf>
    kinit();         // physical page allocator
    80001016:	bc9ff0ef          	jal	80000bde <kinit>
    kvminit();       // create kernel page table
    8000101a:	2ca000ef          	jal	800012e4 <kvminit>
    kvminithart();   // turn on paging
    8000101e:	03c000ef          	jal	8000105a <kvminithart>
    procinit();      // process table
    80001022:	1c3000ef          	jal	800019e4 <procinit>
    trapinit();      // trap vectors
    80001026:	56c010ef          	jal	80002592 <trapinit>
    trapinithart();  // install kernel trap vector
    8000102a:	58c010ef          	jal	800025b6 <trapinithart>
    plicinit();      // set up interrupt controller
    8000102e:	760040ef          	jal	8000578e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001032:	776040ef          	jal	800057a8 <plicinithart>
    binit();         // buffer cache
    80001036:	463010ef          	jal	80002c98 <binit>
    iinit();         // inode table
    8000103a:	314020ef          	jal	8000334e <iinit>
    fileinit();      // file table
    8000103e:	150030ef          	jal	8000418e <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001042:	057040ef          	jal	80005898 <virtio_disk_init>
    userinit();      // first user process
    80001046:	4e9000ef          	jal	80001d2e <userinit>
    __sync_synchronize();
    8000104a:	0330000f          	fence	rw,rw
    started = 1;
    8000104e:	4785                	li	a5,1
    80001050:	00009717          	auipc	a4,0x9
    80001054:	3ef72423          	sw	a5,1000(a4) # 8000a438 <started>
    80001058:	b779                	j	80000fe6 <main+0x3e>

000000008000105a <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000105a:	1141                	addi	sp,sp,-16
    8000105c:	e422                	sd	s0,8(sp)
    8000105e:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001060:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001064:	00009797          	auipc	a5,0x9
    80001068:	3dc7b783          	ld	a5,988(a5) # 8000a440 <kernel_pagetable>
    8000106c:	83b1                	srli	a5,a5,0xc
    8000106e:	577d                	li	a4,-1
    80001070:	177e                	slli	a4,a4,0x3f
    80001072:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001074:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001078:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000107c:	6422                	ld	s0,8(sp)
    8000107e:	0141                	addi	sp,sp,16
    80001080:	8082                	ret

0000000080001082 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001082:	7139                	addi	sp,sp,-64
    80001084:	fc06                	sd	ra,56(sp)
    80001086:	f822                	sd	s0,48(sp)
    80001088:	f426                	sd	s1,40(sp)
    8000108a:	f04a                	sd	s2,32(sp)
    8000108c:	ec4e                	sd	s3,24(sp)
    8000108e:	e852                	sd	s4,16(sp)
    80001090:	e456                	sd	s5,8(sp)
    80001092:	e05a                	sd	s6,0(sp)
    80001094:	0080                	addi	s0,sp,64
    80001096:	84aa                	mv	s1,a0
    80001098:	89ae                	mv	s3,a1
    8000109a:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    8000109c:	57fd                	li	a5,-1
    8000109e:	83e9                	srli	a5,a5,0x1a
    800010a0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800010a2:	4b31                	li	s6,12
  if(va >= MAXVA)
    800010a4:	02b7fc63          	bgeu	a5,a1,800010dc <walk+0x5a>
    panic("walk");
    800010a8:	00006517          	auipc	a0,0x6
    800010ac:	01050513          	addi	a0,a0,16 # 800070b8 <etext+0xb8>
    800010b0:	ee4ff0ef          	jal	80000794 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010b4:	060a8263          	beqz	s5,80001118 <walk+0x96>
    800010b8:	b81ff0ef          	jal	80000c38 <kalloc>
    800010bc:	84aa                	mv	s1,a0
    800010be:	c139                	beqz	a0,80001104 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800010c0:	6605                	lui	a2,0x1
    800010c2:	4581                	li	a1,0
    800010c4:	d4bff0ef          	jal	80000e0e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010c8:	00c4d793          	srli	a5,s1,0xc
    800010cc:	07aa                	slli	a5,a5,0xa
    800010ce:	0017e793          	ori	a5,a5,1
    800010d2:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800010d6:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7fb9b84f>
    800010d8:	036a0063          	beq	s4,s6,800010f8 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    800010dc:	0149d933          	srl	s2,s3,s4
    800010e0:	1ff97913          	andi	s2,s2,511
    800010e4:	090e                	slli	s2,s2,0x3
    800010e6:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800010e8:	00093483          	ld	s1,0(s2)
    800010ec:	0014f793          	andi	a5,s1,1
    800010f0:	d3f1                	beqz	a5,800010b4 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010f2:	80a9                	srli	s1,s1,0xa
    800010f4:	04b2                	slli	s1,s1,0xc
    800010f6:	b7c5                	j	800010d6 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    800010f8:	00c9d513          	srli	a0,s3,0xc
    800010fc:	1ff57513          	andi	a0,a0,511
    80001100:	050e                	slli	a0,a0,0x3
    80001102:	9526                	add	a0,a0,s1
}
    80001104:	70e2                	ld	ra,56(sp)
    80001106:	7442                	ld	s0,48(sp)
    80001108:	74a2                	ld	s1,40(sp)
    8000110a:	7902                	ld	s2,32(sp)
    8000110c:	69e2                	ld	s3,24(sp)
    8000110e:	6a42                	ld	s4,16(sp)
    80001110:	6aa2                	ld	s5,8(sp)
    80001112:	6b02                	ld	s6,0(sp)
    80001114:	6121                	addi	sp,sp,64
    80001116:	8082                	ret
        return 0;
    80001118:	4501                	li	a0,0
    8000111a:	b7ed                	j	80001104 <walk+0x82>

000000008000111c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000111c:	57fd                	li	a5,-1
    8000111e:	83e9                	srli	a5,a5,0x1a
    80001120:	00b7f463          	bgeu	a5,a1,80001128 <walkaddr+0xc>
    return 0;
    80001124:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001126:	8082                	ret
{
    80001128:	1141                	addi	sp,sp,-16
    8000112a:	e406                	sd	ra,8(sp)
    8000112c:	e022                	sd	s0,0(sp)
    8000112e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001130:	4601                	li	a2,0
    80001132:	f51ff0ef          	jal	80001082 <walk>
  if(pte == 0)
    80001136:	c105                	beqz	a0,80001156 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80001138:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000113a:	0117f693          	andi	a3,a5,17
    8000113e:	4745                	li	a4,17
    return 0;
    80001140:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001142:	00e68663          	beq	a3,a4,8000114e <walkaddr+0x32>
}
    80001146:	60a2                	ld	ra,8(sp)
    80001148:	6402                	ld	s0,0(sp)
    8000114a:	0141                	addi	sp,sp,16
    8000114c:	8082                	ret
  pa = PTE2PA(*pte);
    8000114e:	83a9                	srli	a5,a5,0xa
    80001150:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001154:	bfcd                	j	80001146 <walkaddr+0x2a>
    return 0;
    80001156:	4501                	li	a0,0
    80001158:	b7fd                	j	80001146 <walkaddr+0x2a>

000000008000115a <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000115a:	715d                	addi	sp,sp,-80
    8000115c:	e486                	sd	ra,72(sp)
    8000115e:	e0a2                	sd	s0,64(sp)
    80001160:	fc26                	sd	s1,56(sp)
    80001162:	f84a                	sd	s2,48(sp)
    80001164:	f44e                	sd	s3,40(sp)
    80001166:	f052                	sd	s4,32(sp)
    80001168:	ec56                	sd	s5,24(sp)
    8000116a:	e85a                	sd	s6,16(sp)
    8000116c:	e45e                	sd	s7,8(sp)
    8000116e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001170:	03459793          	slli	a5,a1,0x34
    80001174:	e7a9                	bnez	a5,800011be <mappages+0x64>
    80001176:	8aaa                	mv	s5,a0
    80001178:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000117a:	03461793          	slli	a5,a2,0x34
    8000117e:	e7b1                	bnez	a5,800011ca <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80001180:	ca39                	beqz	a2,800011d6 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001182:	77fd                	lui	a5,0xfffff
    80001184:	963e                	add	a2,a2,a5
    80001186:	00b609b3          	add	s3,a2,a1
  a = va;
    8000118a:	892e                	mv	s2,a1
    8000118c:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001190:	6b85                	lui	s7,0x1
    80001192:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001196:	4605                	li	a2,1
    80001198:	85ca                	mv	a1,s2
    8000119a:	8556                	mv	a0,s5
    8000119c:	ee7ff0ef          	jal	80001082 <walk>
    800011a0:	c539                	beqz	a0,800011ee <mappages+0x94>
    if(*pte & PTE_V)
    800011a2:	611c                	ld	a5,0(a0)
    800011a4:	8b85                	andi	a5,a5,1
    800011a6:	ef95                	bnez	a5,800011e2 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800011a8:	80b1                	srli	s1,s1,0xc
    800011aa:	04aa                	slli	s1,s1,0xa
    800011ac:	0164e4b3          	or	s1,s1,s6
    800011b0:	0014e493          	ori	s1,s1,1
    800011b4:	e104                	sd	s1,0(a0)
    if(a == last)
    800011b6:	05390863          	beq	s2,s3,80001206 <mappages+0xac>
    a += PGSIZE;
    800011ba:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800011bc:	bfd9                	j	80001192 <mappages+0x38>
    panic("mappages: va not aligned");
    800011be:	00006517          	auipc	a0,0x6
    800011c2:	f0250513          	addi	a0,a0,-254 # 800070c0 <etext+0xc0>
    800011c6:	dceff0ef          	jal	80000794 <panic>
    panic("mappages: size not aligned");
    800011ca:	00006517          	auipc	a0,0x6
    800011ce:	f1650513          	addi	a0,a0,-234 # 800070e0 <etext+0xe0>
    800011d2:	dc2ff0ef          	jal	80000794 <panic>
    panic("mappages: size");
    800011d6:	00006517          	auipc	a0,0x6
    800011da:	f2a50513          	addi	a0,a0,-214 # 80007100 <etext+0x100>
    800011de:	db6ff0ef          	jal	80000794 <panic>
      panic("mappages: remap");
    800011e2:	00006517          	auipc	a0,0x6
    800011e6:	f2e50513          	addi	a0,a0,-210 # 80007110 <etext+0x110>
    800011ea:	daaff0ef          	jal	80000794 <panic>
      return -1;
    800011ee:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800011f0:	60a6                	ld	ra,72(sp)
    800011f2:	6406                	ld	s0,64(sp)
    800011f4:	74e2                	ld	s1,56(sp)
    800011f6:	7942                	ld	s2,48(sp)
    800011f8:	79a2                	ld	s3,40(sp)
    800011fa:	7a02                	ld	s4,32(sp)
    800011fc:	6ae2                	ld	s5,24(sp)
    800011fe:	6b42                	ld	s6,16(sp)
    80001200:	6ba2                	ld	s7,8(sp)
    80001202:	6161                	addi	sp,sp,80
    80001204:	8082                	ret
  return 0;
    80001206:	4501                	li	a0,0
    80001208:	b7e5                	j	800011f0 <mappages+0x96>

000000008000120a <kvmmap>:
{
    8000120a:	1141                	addi	sp,sp,-16
    8000120c:	e406                	sd	ra,8(sp)
    8000120e:	e022                	sd	s0,0(sp)
    80001210:	0800                	addi	s0,sp,16
    80001212:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001214:	86b2                	mv	a3,a2
    80001216:	863e                	mv	a2,a5
    80001218:	f43ff0ef          	jal	8000115a <mappages>
    8000121c:	e509                	bnez	a0,80001226 <kvmmap+0x1c>
}
    8000121e:	60a2                	ld	ra,8(sp)
    80001220:	6402                	ld	s0,0(sp)
    80001222:	0141                	addi	sp,sp,16
    80001224:	8082                	ret
    panic("kvmmap");
    80001226:	00006517          	auipc	a0,0x6
    8000122a:	efa50513          	addi	a0,a0,-262 # 80007120 <etext+0x120>
    8000122e:	d66ff0ef          	jal	80000794 <panic>

0000000080001232 <kvmmake>:
{
    80001232:	1101                	addi	sp,sp,-32
    80001234:	ec06                	sd	ra,24(sp)
    80001236:	e822                	sd	s0,16(sp)
    80001238:	e426                	sd	s1,8(sp)
    8000123a:	e04a                	sd	s2,0(sp)
    8000123c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000123e:	9fbff0ef          	jal	80000c38 <kalloc>
    80001242:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001244:	6605                	lui	a2,0x1
    80001246:	4581                	li	a1,0
    80001248:	bc7ff0ef          	jal	80000e0e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000124c:	4719                	li	a4,6
    8000124e:	6685                	lui	a3,0x1
    80001250:	10000637          	lui	a2,0x10000
    80001254:	100005b7          	lui	a1,0x10000
    80001258:	8526                	mv	a0,s1
    8000125a:	fb1ff0ef          	jal	8000120a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000125e:	4719                	li	a4,6
    80001260:	6685                	lui	a3,0x1
    80001262:	10001637          	lui	a2,0x10001
    80001266:	100015b7          	lui	a1,0x10001
    8000126a:	8526                	mv	a0,s1
    8000126c:	f9fff0ef          	jal	8000120a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001270:	4719                	li	a4,6
    80001272:	040006b7          	lui	a3,0x4000
    80001276:	0c000637          	lui	a2,0xc000
    8000127a:	0c0005b7          	lui	a1,0xc000
    8000127e:	8526                	mv	a0,s1
    80001280:	f8bff0ef          	jal	8000120a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001284:	00006917          	auipc	s2,0x6
    80001288:	d7c90913          	addi	s2,s2,-644 # 80007000 <etext>
    8000128c:	4729                	li	a4,10
    8000128e:	80006697          	auipc	a3,0x80006
    80001292:	d7268693          	addi	a3,a3,-654 # 7000 <_entry-0x7fff9000>
    80001296:	4605                	li	a2,1
    80001298:	067e                	slli	a2,a2,0x1f
    8000129a:	85b2                	mv	a1,a2
    8000129c:	8526                	mv	a0,s1
    8000129e:	f6dff0ef          	jal	8000120a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800012a2:	46c5                	li	a3,17
    800012a4:	06ee                	slli	a3,a3,0x1b
    800012a6:	4719                	li	a4,6
    800012a8:	412686b3          	sub	a3,a3,s2
    800012ac:	864a                	mv	a2,s2
    800012ae:	85ca                	mv	a1,s2
    800012b0:	8526                	mv	a0,s1
    800012b2:	f59ff0ef          	jal	8000120a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800012b6:	4729                	li	a4,10
    800012b8:	6685                	lui	a3,0x1
    800012ba:	00005617          	auipc	a2,0x5
    800012be:	d4660613          	addi	a2,a2,-698 # 80006000 <_trampoline>
    800012c2:	040005b7          	lui	a1,0x4000
    800012c6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012c8:	05b2                	slli	a1,a1,0xc
    800012ca:	8526                	mv	a0,s1
    800012cc:	f3fff0ef          	jal	8000120a <kvmmap>
  proc_mapstacks(kpgtbl);
    800012d0:	8526                	mv	a0,s1
    800012d2:	67a000ef          	jal	8000194c <proc_mapstacks>
}
    800012d6:	8526                	mv	a0,s1
    800012d8:	60e2                	ld	ra,24(sp)
    800012da:	6442                	ld	s0,16(sp)
    800012dc:	64a2                	ld	s1,8(sp)
    800012de:	6902                	ld	s2,0(sp)
    800012e0:	6105                	addi	sp,sp,32
    800012e2:	8082                	ret

00000000800012e4 <kvminit>:
{
    800012e4:	1141                	addi	sp,sp,-16
    800012e6:	e406                	sd	ra,8(sp)
    800012e8:	e022                	sd	s0,0(sp)
    800012ea:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012ec:	f47ff0ef          	jal	80001232 <kvmmake>
    800012f0:	00009797          	auipc	a5,0x9
    800012f4:	14a7b823          	sd	a0,336(a5) # 8000a440 <kernel_pagetable>
}
    800012f8:	60a2                	ld	ra,8(sp)
    800012fa:	6402                	ld	s0,0(sp)
    800012fc:	0141                	addi	sp,sp,16
    800012fe:	8082                	ret

0000000080001300 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001300:	715d                	addi	sp,sp,-80
    80001302:	e486                	sd	ra,72(sp)
    80001304:	e0a2                	sd	s0,64(sp)
    80001306:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001308:	03459793          	slli	a5,a1,0x34
    8000130c:	e39d                	bnez	a5,80001332 <uvmunmap+0x32>
    8000130e:	f84a                	sd	s2,48(sp)
    80001310:	f44e                	sd	s3,40(sp)
    80001312:	f052                	sd	s4,32(sp)
    80001314:	ec56                	sd	s5,24(sp)
    80001316:	e85a                	sd	s6,16(sp)
    80001318:	e45e                	sd	s7,8(sp)
    8000131a:	8a2a                	mv	s4,a0
    8000131c:	892e                	mv	s2,a1
    8000131e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001320:	0632                	slli	a2,a2,0xc
    80001322:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001326:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001328:	6b05                	lui	s6,0x1
    8000132a:	0735ff63          	bgeu	a1,s3,800013a8 <uvmunmap+0xa8>
    8000132e:	fc26                	sd	s1,56(sp)
    80001330:	a0a9                	j	8000137a <uvmunmap+0x7a>
    80001332:	fc26                	sd	s1,56(sp)
    80001334:	f84a                	sd	s2,48(sp)
    80001336:	f44e                	sd	s3,40(sp)
    80001338:	f052                	sd	s4,32(sp)
    8000133a:	ec56                	sd	s5,24(sp)
    8000133c:	e85a                	sd	s6,16(sp)
    8000133e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001340:	00006517          	auipc	a0,0x6
    80001344:	de850513          	addi	a0,a0,-536 # 80007128 <etext+0x128>
    80001348:	c4cff0ef          	jal	80000794 <panic>
      panic("uvmunmap: walk");
    8000134c:	00006517          	auipc	a0,0x6
    80001350:	df450513          	addi	a0,a0,-524 # 80007140 <etext+0x140>
    80001354:	c40ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not mapped");
    80001358:	00006517          	auipc	a0,0x6
    8000135c:	df850513          	addi	a0,a0,-520 # 80007150 <etext+0x150>
    80001360:	c34ff0ef          	jal	80000794 <panic>
      panic("uvmunmap: not a leaf");
    80001364:	00006517          	auipc	a0,0x6
    80001368:	e0450513          	addi	a0,a0,-508 # 80007168 <etext+0x168>
    8000136c:	c28ff0ef          	jal	80000794 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001370:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001374:	995a                	add	s2,s2,s6
    80001376:	03397863          	bgeu	s2,s3,800013a6 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000137a:	4601                	li	a2,0
    8000137c:	85ca                	mv	a1,s2
    8000137e:	8552                	mv	a0,s4
    80001380:	d03ff0ef          	jal	80001082 <walk>
    80001384:	84aa                	mv	s1,a0
    80001386:	d179                	beqz	a0,8000134c <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001388:	6108                	ld	a0,0(a0)
    8000138a:	00157793          	andi	a5,a0,1
    8000138e:	d7e9                	beqz	a5,80001358 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001390:	3ff57793          	andi	a5,a0,1023
    80001394:	fd7788e3          	beq	a5,s7,80001364 <uvmunmap+0x64>
    if(do_free){
    80001398:	fc0a8ce3          	beqz	s5,80001370 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    8000139c:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000139e:	0532                	slli	a0,a0,0xc
    800013a0:	f66ff0ef          	jal	80000b06 <kfree>
    800013a4:	b7f1                	j	80001370 <uvmunmap+0x70>
    800013a6:	74e2                	ld	s1,56(sp)
    800013a8:	7942                	ld	s2,48(sp)
    800013aa:	79a2                	ld	s3,40(sp)
    800013ac:	7a02                	ld	s4,32(sp)
    800013ae:	6ae2                	ld	s5,24(sp)
    800013b0:	6b42                	ld	s6,16(sp)
    800013b2:	6ba2                	ld	s7,8(sp)
  }
}
    800013b4:	60a6                	ld	ra,72(sp)
    800013b6:	6406                	ld	s0,64(sp)
    800013b8:	6161                	addi	sp,sp,80
    800013ba:	8082                	ret

00000000800013bc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013bc:	1101                	addi	sp,sp,-32
    800013be:	ec06                	sd	ra,24(sp)
    800013c0:	e822                	sd	s0,16(sp)
    800013c2:	e426                	sd	s1,8(sp)
    800013c4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013c6:	873ff0ef          	jal	80000c38 <kalloc>
    800013ca:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013cc:	c509                	beqz	a0,800013d6 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013ce:	6605                	lui	a2,0x1
    800013d0:	4581                	li	a1,0
    800013d2:	a3dff0ef          	jal	80000e0e <memset>
  return pagetable;
}
    800013d6:	8526                	mv	a0,s1
    800013d8:	60e2                	ld	ra,24(sp)
    800013da:	6442                	ld	s0,16(sp)
    800013dc:	64a2                	ld	s1,8(sp)
    800013de:	6105                	addi	sp,sp,32
    800013e0:	8082                	ret

00000000800013e2 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800013e2:	7179                	addi	sp,sp,-48
    800013e4:	f406                	sd	ra,40(sp)
    800013e6:	f022                	sd	s0,32(sp)
    800013e8:	ec26                	sd	s1,24(sp)
    800013ea:	e84a                	sd	s2,16(sp)
    800013ec:	e44e                	sd	s3,8(sp)
    800013ee:	e052                	sd	s4,0(sp)
    800013f0:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800013f2:	6785                	lui	a5,0x1
    800013f4:	04f67063          	bgeu	a2,a5,80001434 <uvmfirst+0x52>
    800013f8:	8a2a                	mv	s4,a0
    800013fa:	89ae                	mv	s3,a1
    800013fc:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800013fe:	83bff0ef          	jal	80000c38 <kalloc>
    80001402:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001404:	6605                	lui	a2,0x1
    80001406:	4581                	li	a1,0
    80001408:	a07ff0ef          	jal	80000e0e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000140c:	4779                	li	a4,30
    8000140e:	86ca                	mv	a3,s2
    80001410:	6605                	lui	a2,0x1
    80001412:	4581                	li	a1,0
    80001414:	8552                	mv	a0,s4
    80001416:	d45ff0ef          	jal	8000115a <mappages>
  memmove(mem, src, sz);
    8000141a:	8626                	mv	a2,s1
    8000141c:	85ce                	mv	a1,s3
    8000141e:	854a                	mv	a0,s2
    80001420:	a4bff0ef          	jal	80000e6a <memmove>
}
    80001424:	70a2                	ld	ra,40(sp)
    80001426:	7402                	ld	s0,32(sp)
    80001428:	64e2                	ld	s1,24(sp)
    8000142a:	6942                	ld	s2,16(sp)
    8000142c:	69a2                	ld	s3,8(sp)
    8000142e:	6a02                	ld	s4,0(sp)
    80001430:	6145                	addi	sp,sp,48
    80001432:	8082                	ret
    panic("uvmfirst: more than a page");
    80001434:	00006517          	auipc	a0,0x6
    80001438:	d4c50513          	addi	a0,a0,-692 # 80007180 <etext+0x180>
    8000143c:	b58ff0ef          	jal	80000794 <panic>

0000000080001440 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001440:	1101                	addi	sp,sp,-32
    80001442:	ec06                	sd	ra,24(sp)
    80001444:	e822                	sd	s0,16(sp)
    80001446:	e426                	sd	s1,8(sp)
    80001448:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000144a:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000144c:	00b67d63          	bgeu	a2,a1,80001466 <uvmdealloc+0x26>
    80001450:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001452:	6785                	lui	a5,0x1
    80001454:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001456:	00f60733          	add	a4,a2,a5
    8000145a:	76fd                	lui	a3,0xfffff
    8000145c:	8f75                	and	a4,a4,a3
    8000145e:	97ae                	add	a5,a5,a1
    80001460:	8ff5                	and	a5,a5,a3
    80001462:	00f76863          	bltu	a4,a5,80001472 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001466:	8526                	mv	a0,s1
    80001468:	60e2                	ld	ra,24(sp)
    8000146a:	6442                	ld	s0,16(sp)
    8000146c:	64a2                	ld	s1,8(sp)
    8000146e:	6105                	addi	sp,sp,32
    80001470:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001472:	8f99                	sub	a5,a5,a4
    80001474:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001476:	4685                	li	a3,1
    80001478:	0007861b          	sext.w	a2,a5
    8000147c:	85ba                	mv	a1,a4
    8000147e:	e83ff0ef          	jal	80001300 <uvmunmap>
    80001482:	b7d5                	j	80001466 <uvmdealloc+0x26>

0000000080001484 <uvmalloc>:
  if(newsz < oldsz)
    80001484:	08b66f63          	bltu	a2,a1,80001522 <uvmalloc+0x9e>
{
    80001488:	7139                	addi	sp,sp,-64
    8000148a:	fc06                	sd	ra,56(sp)
    8000148c:	f822                	sd	s0,48(sp)
    8000148e:	ec4e                	sd	s3,24(sp)
    80001490:	e852                	sd	s4,16(sp)
    80001492:	e456                	sd	s5,8(sp)
    80001494:	0080                	addi	s0,sp,64
    80001496:	8aaa                	mv	s5,a0
    80001498:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000149a:	6785                	lui	a5,0x1
    8000149c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000149e:	95be                	add	a1,a1,a5
    800014a0:	77fd                	lui	a5,0xfffff
    800014a2:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014a6:	08c9f063          	bgeu	s3,a2,80001526 <uvmalloc+0xa2>
    800014aa:	f426                	sd	s1,40(sp)
    800014ac:	f04a                	sd	s2,32(sp)
    800014ae:	e05a                	sd	s6,0(sp)
    800014b0:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014b2:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800014b6:	f82ff0ef          	jal	80000c38 <kalloc>
    800014ba:	84aa                	mv	s1,a0
    if(mem == 0){
    800014bc:	c515                	beqz	a0,800014e8 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800014be:	6605                	lui	a2,0x1
    800014c0:	4581                	li	a1,0
    800014c2:	94dff0ef          	jal	80000e0e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014c6:	875a                	mv	a4,s6
    800014c8:	86a6                	mv	a3,s1
    800014ca:	6605                	lui	a2,0x1
    800014cc:	85ca                	mv	a1,s2
    800014ce:	8556                	mv	a0,s5
    800014d0:	c8bff0ef          	jal	8000115a <mappages>
    800014d4:	e915                	bnez	a0,80001508 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014d6:	6785                	lui	a5,0x1
    800014d8:	993e                	add	s2,s2,a5
    800014da:	fd496ee3          	bltu	s2,s4,800014b6 <uvmalloc+0x32>
  return newsz;
    800014de:	8552                	mv	a0,s4
    800014e0:	74a2                	ld	s1,40(sp)
    800014e2:	7902                	ld	s2,32(sp)
    800014e4:	6b02                	ld	s6,0(sp)
    800014e6:	a811                	j	800014fa <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800014e8:	864e                	mv	a2,s3
    800014ea:	85ca                	mv	a1,s2
    800014ec:	8556                	mv	a0,s5
    800014ee:	f53ff0ef          	jal	80001440 <uvmdealloc>
      return 0;
    800014f2:	4501                	li	a0,0
    800014f4:	74a2                	ld	s1,40(sp)
    800014f6:	7902                	ld	s2,32(sp)
    800014f8:	6b02                	ld	s6,0(sp)
}
    800014fa:	70e2                	ld	ra,56(sp)
    800014fc:	7442                	ld	s0,48(sp)
    800014fe:	69e2                	ld	s3,24(sp)
    80001500:	6a42                	ld	s4,16(sp)
    80001502:	6aa2                	ld	s5,8(sp)
    80001504:	6121                	addi	sp,sp,64
    80001506:	8082                	ret
      kfree(mem);
    80001508:	8526                	mv	a0,s1
    8000150a:	dfcff0ef          	jal	80000b06 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000150e:	864e                	mv	a2,s3
    80001510:	85ca                	mv	a1,s2
    80001512:	8556                	mv	a0,s5
    80001514:	f2dff0ef          	jal	80001440 <uvmdealloc>
      return 0;
    80001518:	4501                	li	a0,0
    8000151a:	74a2                	ld	s1,40(sp)
    8000151c:	7902                	ld	s2,32(sp)
    8000151e:	6b02                	ld	s6,0(sp)
    80001520:	bfe9                	j	800014fa <uvmalloc+0x76>
    return oldsz;
    80001522:	852e                	mv	a0,a1
}
    80001524:	8082                	ret
  return newsz;
    80001526:	8532                	mv	a0,a2
    80001528:	bfc9                	j	800014fa <uvmalloc+0x76>

000000008000152a <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000152a:	7179                	addi	sp,sp,-48
    8000152c:	f406                	sd	ra,40(sp)
    8000152e:	f022                	sd	s0,32(sp)
    80001530:	ec26                	sd	s1,24(sp)
    80001532:	e84a                	sd	s2,16(sp)
    80001534:	e44e                	sd	s3,8(sp)
    80001536:	e052                	sd	s4,0(sp)
    80001538:	1800                	addi	s0,sp,48
    8000153a:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000153c:	84aa                	mv	s1,a0
    8000153e:	6905                	lui	s2,0x1
    80001540:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001542:	4985                	li	s3,1
    80001544:	a819                	j	8000155a <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001546:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001548:	00c79513          	slli	a0,a5,0xc
    8000154c:	fdfff0ef          	jal	8000152a <freewalk>
      pagetable[i] = 0;
    80001550:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001554:	04a1                	addi	s1,s1,8
    80001556:	01248f63          	beq	s1,s2,80001574 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    8000155a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000155c:	00f7f713          	andi	a4,a5,15
    80001560:	ff3703e3          	beq	a4,s3,80001546 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001564:	8b85                	andi	a5,a5,1
    80001566:	d7fd                	beqz	a5,80001554 <freewalk+0x2a>
      panic("freewalk: leaf");
    80001568:	00006517          	auipc	a0,0x6
    8000156c:	c3850513          	addi	a0,a0,-968 # 800071a0 <etext+0x1a0>
    80001570:	a24ff0ef          	jal	80000794 <panic>
    }
  }
  kfree((void*)pagetable);
    80001574:	8552                	mv	a0,s4
    80001576:	d90ff0ef          	jal	80000b06 <kfree>
}
    8000157a:	70a2                	ld	ra,40(sp)
    8000157c:	7402                	ld	s0,32(sp)
    8000157e:	64e2                	ld	s1,24(sp)
    80001580:	6942                	ld	s2,16(sp)
    80001582:	69a2                	ld	s3,8(sp)
    80001584:	6a02                	ld	s4,0(sp)
    80001586:	6145                	addi	sp,sp,48
    80001588:	8082                	ret

000000008000158a <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000158a:	1101                	addi	sp,sp,-32
    8000158c:	ec06                	sd	ra,24(sp)
    8000158e:	e822                	sd	s0,16(sp)
    80001590:	e426                	sd	s1,8(sp)
    80001592:	1000                	addi	s0,sp,32
    80001594:	84aa                	mv	s1,a0
  if(sz > 0)
    80001596:	e989                	bnez	a1,800015a8 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001598:	8526                	mv	a0,s1
    8000159a:	f91ff0ef          	jal	8000152a <freewalk>
}
    8000159e:	60e2                	ld	ra,24(sp)
    800015a0:	6442                	ld	s0,16(sp)
    800015a2:	64a2                	ld	s1,8(sp)
    800015a4:	6105                	addi	sp,sp,32
    800015a6:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800015a8:	6785                	lui	a5,0x1
    800015aa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800015ac:	95be                	add	a1,a1,a5
    800015ae:	4685                	li	a3,1
    800015b0:	00c5d613          	srli	a2,a1,0xc
    800015b4:	4581                	li	a1,0
    800015b6:	d4bff0ef          	jal	80001300 <uvmunmap>
    800015ba:	bff9                	j	80001598 <uvmfree+0xe>

00000000800015bc <uvmcopy>:
// physical memory.
// returns 0 on success, -1 on failure.
// frees any allocated pages on failure.
int
uvmcopy(pagetable_t old, pagetable_t new, uint64 sz)
{
    800015bc:	7139                	addi	sp,sp,-64
    800015be:	fc06                	sd	ra,56(sp)
    800015c0:	f822                	sd	s0,48(sp)
    800015c2:	e05a                	sd	s6,0(sp)
    800015c4:	0080                	addi	s0,sp,64
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    800015c6:	c24d                	beqz	a2,80001668 <uvmcopy+0xac>
    800015c8:	f426                	sd	s1,40(sp)
    800015ca:	f04a                	sd	s2,32(sp)
    800015cc:	ec4e                	sd	s3,24(sp)
    800015ce:	e852                	sd	s4,16(sp)
    800015d0:	e456                	sd	s5,8(sp)
    800015d2:	8aaa                	mv	s5,a0
    800015d4:	8a2e                	mv	s4,a1
    800015d6:	89b2                	mv	s3,a2
    800015d8:	4481                	li	s1,0
    // Logical address에 해당하는 PTE를 찾음
    if((pte = walk(old, i, 0)) == 0)
    800015da:	4601                	li	a2,0
    800015dc:	85a6                	mv	a1,s1
    800015de:	8556                	mv	a0,s5
    800015e0:	aa3ff0ef          	jal	80001082 <walk>
    800015e4:	c139                	beqz	a0,8000162a <uvmcopy+0x6e>
      panic("uvmcopy: pte should exist");
    // PTE 존재하고 유효한지 확인
    if((*pte & PTE_V) == 0)
    800015e6:	6118                	ld	a4,0(a0)
    800015e8:	00177793          	andi	a5,a4,1
    800015ec:	c7a9                	beqz	a5,80001636 <uvmcopy+0x7a>
      panic("uvmcopy: page not present");

    // pte의 write
    *pte = *pte & ~PTE_W;
    800015ee:	9b6d                	andi	a4,a4,-5
    *pte = *pte | PTE_COW;
    800015f0:	10076713          	ori	a4,a4,256
    800015f4:	e118                	sd	a4,0(a0)

    // 해당 PTE에 맞는 physical address를 가져옴
    pa = PTE2PA(*pte);
    800015f6:	00a75913          	srli	s2,a4,0xa
    800015fa:	0932                	slli	s2,s2,0xc
    // Parent PTE의 권한을 가져옴
    flags = PTE_FLAGS(*pte);

    // page를 자식 page table에 매핑
    if(mappages(new, i, PGSIZE, pa, flags) != 0){
    800015fc:	3fb77713          	andi	a4,a4,1019
    80001600:	86ca                	mv	a3,s2
    80001602:	6605                	lui	a2,0x1
    80001604:	85a6                	mv	a1,s1
    80001606:	8552                	mv	a0,s4
    80001608:	b53ff0ef          	jal	8000115a <mappages>
    8000160c:	8b2a                	mv	s6,a0
    8000160e:	e915                	bnez	a0,80001642 <uvmcopy+0x86>
      goto err;
    }

    // 기존 Physical page reference count 증가
    incRefCount((void*)pa);
    80001610:	854a                	mv	a0,s2
    80001612:	c70ff0ef          	jal	80000a82 <incRefCount>
  for(i = 0; i < sz; i += PGSIZE){
    80001616:	6785                	lui	a5,0x1
    80001618:	94be                	add	s1,s1,a5
    8000161a:	fd34e0e3          	bltu	s1,s3,800015da <uvmcopy+0x1e>
    8000161e:	74a2                	ld	s1,40(sp)
    80001620:	7902                	ld	s2,32(sp)
    80001622:	69e2                	ld	s3,24(sp)
    80001624:	6a42                	ld	s4,16(sp)
    80001626:	6aa2                	ld	s5,8(sp)
    80001628:	a815                	j	8000165c <uvmcopy+0xa0>
      panic("uvmcopy: pte should exist");
    8000162a:	00006517          	auipc	a0,0x6
    8000162e:	b8650513          	addi	a0,a0,-1146 # 800071b0 <etext+0x1b0>
    80001632:	962ff0ef          	jal	80000794 <panic>
      panic("uvmcopy: page not present");
    80001636:	00006517          	auipc	a0,0x6
    8000163a:	b9a50513          	addi	a0,a0,-1126 # 800071d0 <etext+0x1d0>
    8000163e:	956ff0ef          	jal	80000794 <panic>
  return 0;

 err:
  // i: 0 ~ PGSIZE
  // 중간에 복사 실패 시, 이전까지 매핑한 페이지 해제  
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001642:	4685                	li	a3,1
    80001644:	00c4d613          	srli	a2,s1,0xc
    80001648:	4581                	li	a1,0
    8000164a:	8552                	mv	a0,s4
    8000164c:	cb5ff0ef          	jal	80001300 <uvmunmap>
  return -1;
    80001650:	5b7d                	li	s6,-1
    80001652:	74a2                	ld	s1,40(sp)
    80001654:	7902                	ld	s2,32(sp)
    80001656:	69e2                	ld	s3,24(sp)
    80001658:	6a42                	ld	s4,16(sp)
    8000165a:	6aa2                	ld	s5,8(sp)
}
    8000165c:	855a                	mv	a0,s6
    8000165e:	70e2                	ld	ra,56(sp)
    80001660:	7442                	ld	s0,48(sp)
    80001662:	6b02                	ld	s6,0(sp)
    80001664:	6121                	addi	sp,sp,64
    80001666:	8082                	ret
  return 0;
    80001668:	4b01                	li	s6,0
    8000166a:	bfcd                	j	8000165c <uvmcopy+0xa0>

000000008000166c <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000166c:	1141                	addi	sp,sp,-16
    8000166e:	e406                	sd	ra,8(sp)
    80001670:	e022                	sd	s0,0(sp)
    80001672:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001674:	4601                	li	a2,0
    80001676:	a0dff0ef          	jal	80001082 <walk>
  if(pte == 0)
    8000167a:	c901                	beqz	a0,8000168a <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000167c:	611c                	ld	a5,0(a0)
    8000167e:	9bbd                	andi	a5,a5,-17
    80001680:	e11c                	sd	a5,0(a0)
}
    80001682:	60a2                	ld	ra,8(sp)
    80001684:	6402                	ld	s0,0(sp)
    80001686:	0141                	addi	sp,sp,16
    80001688:	8082                	ret
    panic("uvmclear");
    8000168a:	00006517          	auipc	a0,0x6
    8000168e:	b6650513          	addi	a0,a0,-1178 # 800071f0 <etext+0x1f0>
    80001692:	902ff0ef          	jal	80000794 <panic>

0000000080001696 <copyout>:
{
  uint64 n, va0, pa0, pa, flags;
  char* mem;
  pte_t *pte;

  while(len > 0){
    80001696:	12068863          	beqz	a3,800017c6 <copyout+0x130>
{
    8000169a:	7159                	addi	sp,sp,-112
    8000169c:	f486                	sd	ra,104(sp)
    8000169e:	f0a2                	sd	s0,96(sp)
    800016a0:	eca6                	sd	s1,88(sp)
    800016a2:	e8ca                	sd	s2,80(sp)
    800016a4:	e4ce                	sd	s3,72(sp)
    800016a6:	e0d2                	sd	s4,64(sp)
    800016a8:	fc56                	sd	s5,56(sp)
    800016aa:	1880                	addi	s0,sp,112
    800016ac:	8aaa                	mv	s5,a0
    800016ae:	89ae                	mv	s3,a1
    800016b0:	8a32                	mv	s4,a2
    800016b2:	8936                	mv	s2,a3
    // Page 단위 정렬
    va0 = PGROUNDDOWN(dstva);
    800016b4:	74fd                	lui	s1,0xfffff
    800016b6:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    800016b8:	57fd                	li	a5,-1
    800016ba:	83e9                	srli	a5,a5,0x1a
    800016bc:	1097e763          	bltu	a5,s1,800017ca <copyout+0x134>
    800016c0:	f85a                	sd	s6,48(sp)
    800016c2:	f45e                	sd	s7,40(sp)
    800016c4:	f062                	sd	s8,32(sp)
    800016c6:	ec66                	sd	s9,24(sp)
    800016c8:	e86a                	sd	s10,16(sp)
    800016ca:	e46e                	sd	s11,8(sp)
      return -1;
    // va0에 맞는 PTE 가져옴
    pte = walk(pagetable, va0, 0);
    // PTE 유효한 지 확인 + Write 권한 여부 확인
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0) {
    800016cc:	4bc5                	li	s7,17
      return -1;
    }

    if ((*pte & PTE_W) == 0 && (*pte & PTE_COW)) {
    800016ce:	10000c13          	li	s8,256
    if(va0 >= MAXVA)
    800016d2:	8b3e                	mv	s6,a5
    800016d4:	a855                	j	80001788 <copyout+0xf2>
      pa = PTE2PA(*pte);
    800016d6:	00a75c93          	srli	s9,a4,0xa
    800016da:	0cb2                	slli	s9,s9,0xc
      flags = PTE_FLAGS(*pte);
      flags = flags | PTE_W; // write bit set
      flags = flags & ~PTE_COW; // cow bit 제거
    800016dc:	2ff77713          	andi	a4,a4,767
    800016e0:	00476d13          	ori	s10,a4,4
      
      if((mem = kalloc()) == 0) {
    800016e4:	d54ff0ef          	jal	80000c38 <kalloc>
    800016e8:	8daa                	mv	s11,a0
    800016ea:	cd05                	beqz	a0,80001722 <copyout+0x8c>
        printf("kalloc is failed\n");
        return -1;
      }

      // 새롭게 할당한 매모리에 우선 기존 pa에 해당되는 메모리에 존재하는 값을 옮김
      memmove(mem, (char*)pa, PGSIZE);
    800016ec:	6605                	lui	a2,0x1
    800016ee:	85e6                	mv	a1,s9
    800016f0:	f7aff0ef          	jal	80000e6a <memmove>
      // 기존 va0과 이전 pagetable의 매핑을 해제
      uvmunmap(pagetable, va0, 1, 0);
    800016f4:	4681                	li	a3,0
    800016f6:	4605                	li	a2,1
    800016f8:	85a6                	mv	a1,s1
    800016fa:	8556                	mv	a0,s5
    800016fc:	c05ff0ef          	jal	80001300 <uvmunmap>
      // 기존 Physical page reference count 감소
      // refCount = 0 인 경우에 할당 해제
      kfree((void*)pa);
    80001700:	8566                	mv	a0,s9
    80001702:	c04ff0ef          	jal	80000b06 <kfree>

      // 새로운 페이지 매핑
      if (mappages(pagetable, va0, PGSIZE, (uint64)mem, flags) != 0) {
    80001706:	876a                	mv	a4,s10
    80001708:	86ee                	mv	a3,s11
    8000170a:	6605                	lui	a2,0x1
    8000170c:	85a6                	mv	a1,s1
    8000170e:	8556                	mv	a0,s5
    80001710:	a4bff0ef          	jal	8000115a <mappages>
    80001714:	e50d                	bnez	a0,8000173e <copyout+0xa8>
        kfree(mem);
        printf("New page mapping failed\n");
        return -1;   
      }
      // page table을 변경했으니 새로운 pte를 사용하도록
      pte = walk(pagetable, va0, 0);
    80001716:	4601                	li	a2,0
    80001718:	85a6                	mv	a1,s1
    8000171a:	8556                	mv	a0,s5
    8000171c:	967ff0ef          	jal	80001082 <walk>
    80001720:	a059                	j	800017a6 <copyout+0x110>
        printf("kalloc is failed\n");
    80001722:	00006517          	auipc	a0,0x6
    80001726:	ade50513          	addi	a0,a0,-1314 # 80007200 <etext+0x200>
    8000172a:	d99fe0ef          	jal	800004c2 <printf>
        return -1;
    8000172e:	557d                	li	a0,-1
    80001730:	7b42                	ld	s6,48(sp)
    80001732:	7ba2                	ld	s7,40(sp)
    80001734:	7c02                	ld	s8,32(sp)
    80001736:	6ce2                	ld	s9,24(sp)
    80001738:	6d42                	ld	s10,16(sp)
    8000173a:	6da2                	ld	s11,8(sp)
    8000173c:	a845                	j	800017ec <copyout+0x156>
        kfree(mem);
    8000173e:	856e                	mv	a0,s11
    80001740:	bc6ff0ef          	jal	80000b06 <kfree>
        printf("New page mapping failed\n");
    80001744:	00006517          	auipc	a0,0x6
    80001748:	ad450513          	addi	a0,a0,-1324 # 80007218 <etext+0x218>
    8000174c:	d77fe0ef          	jal	800004c2 <printf>
        return -1;   
    80001750:	557d                	li	a0,-1
    80001752:	7b42                	ld	s6,48(sp)
    80001754:	7ba2                	ld	s7,40(sp)
    80001756:	7c02                	ld	s8,32(sp)
    80001758:	6ce2                	ld	s9,24(sp)
    8000175a:	6d42                	ld	s10,16(sp)
    8000175c:	6da2                	ld	s11,8(sp)
    8000175e:	a079                	j	800017ec <copyout+0x156>
    }

    // PTE에 맞는 physical address 가져옴
    pa0 = PTE2PA(*pte);
    80001760:	611c                	ld	a5,0(a0)
    80001762:	83a9                	srli	a5,a5,0xa
    80001764:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    // Kernel space data src를 va에 매핑되는 physical memory로 옮김
    // pa0 + (dstva - va0): page allign x -> 차이만큼 앞에서 시작
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001766:	40998533          	sub	a0,s3,s1
    8000176a:	000d061b          	sext.w	a2,s10
    8000176e:	85d2                	mv	a1,s4
    80001770:	953e                	add	a0,a0,a5
    80001772:	ef8ff0ef          	jal	80000e6a <memmove>

    len -= n;
    80001776:	41a90933          	sub	s2,s2,s10
    src += n;
    8000177a:	9a6a                	add	s4,s4,s10
  while(len > 0){
    8000177c:	02090d63          	beqz	s2,800017b6 <copyout+0x120>
    if(va0 >= MAXVA)
    80001780:	059b6763          	bltu	s6,s9,800017ce <copyout+0x138>
    80001784:	84e6                	mv	s1,s9
    80001786:	89e6                	mv	s3,s9
    pte = walk(pagetable, va0, 0);
    80001788:	4601                	li	a2,0
    8000178a:	85a6                	mv	a1,s1
    8000178c:	8556                	mv	a0,s5
    8000178e:	8f5ff0ef          	jal	80001082 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0) {
    80001792:	c531                	beqz	a0,800017de <copyout+0x148>
    80001794:	6118                	ld	a4,0(a0)
    80001796:	01177793          	andi	a5,a4,17
    8000179a:	07779263          	bne	a5,s7,800017fe <copyout+0x168>
    if ((*pte & PTE_W) == 0 && (*pte & PTE_COW)) {
    8000179e:	10477793          	andi	a5,a4,260
    800017a2:	f3878ae3          	beq	a5,s8,800016d6 <copyout+0x40>
    n = PGSIZE - (dstva - va0);
    800017a6:	6c85                	lui	s9,0x1
    800017a8:	9ca6                	add	s9,s9,s1
    800017aa:	413c8d33          	sub	s10,s9,s3
    if(n > len)
    800017ae:	fba979e3          	bgeu	s2,s10,80001760 <copyout+0xca>
    800017b2:	8d4a                	mv	s10,s2
    800017b4:	b775                	j	80001760 <copyout+0xca>
    dstva = va0 + PGSIZE;
  }

  return 0;
    800017b6:	4501                	li	a0,0
    800017b8:	7b42                	ld	s6,48(sp)
    800017ba:	7ba2                	ld	s7,40(sp)
    800017bc:	7c02                	ld	s8,32(sp)
    800017be:	6ce2                	ld	s9,24(sp)
    800017c0:	6d42                	ld	s10,16(sp)
    800017c2:	6da2                	ld	s11,8(sp)
    800017c4:	a025                	j	800017ec <copyout+0x156>
    800017c6:	4501                	li	a0,0
}
    800017c8:	8082                	ret
      return -1;
    800017ca:	557d                	li	a0,-1
    800017cc:	a005                	j	800017ec <copyout+0x156>
    800017ce:	557d                	li	a0,-1
    800017d0:	7b42                	ld	s6,48(sp)
    800017d2:	7ba2                	ld	s7,40(sp)
    800017d4:	7c02                	ld	s8,32(sp)
    800017d6:	6ce2                	ld	s9,24(sp)
    800017d8:	6d42                	ld	s10,16(sp)
    800017da:	6da2                	ld	s11,8(sp)
    800017dc:	a801                	j	800017ec <copyout+0x156>
      return -1;
    800017de:	557d                	li	a0,-1
    800017e0:	7b42                	ld	s6,48(sp)
    800017e2:	7ba2                	ld	s7,40(sp)
    800017e4:	7c02                	ld	s8,32(sp)
    800017e6:	6ce2                	ld	s9,24(sp)
    800017e8:	6d42                	ld	s10,16(sp)
    800017ea:	6da2                	ld	s11,8(sp)
}
    800017ec:	70a6                	ld	ra,104(sp)
    800017ee:	7406                	ld	s0,96(sp)
    800017f0:	64e6                	ld	s1,88(sp)
    800017f2:	6946                	ld	s2,80(sp)
    800017f4:	69a6                	ld	s3,72(sp)
    800017f6:	6a06                	ld	s4,64(sp)
    800017f8:	7ae2                	ld	s5,56(sp)
    800017fa:	6165                	addi	sp,sp,112
    800017fc:	8082                	ret
      return -1;
    800017fe:	557d                	li	a0,-1
    80001800:	7b42                	ld	s6,48(sp)
    80001802:	7ba2                	ld	s7,40(sp)
    80001804:	7c02                	ld	s8,32(sp)
    80001806:	6ce2                	ld	s9,24(sp)
    80001808:	6d42                	ld	s10,16(sp)
    8000180a:	6da2                	ld	s11,8(sp)
    8000180c:	b7c5                	j	800017ec <copyout+0x156>

000000008000180e <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000180e:	c6a5                	beqz	a3,80001876 <copyin+0x68>
{
    80001810:	715d                	addi	sp,sp,-80
    80001812:	e486                	sd	ra,72(sp)
    80001814:	e0a2                	sd	s0,64(sp)
    80001816:	fc26                	sd	s1,56(sp)
    80001818:	f84a                	sd	s2,48(sp)
    8000181a:	f44e                	sd	s3,40(sp)
    8000181c:	f052                	sd	s4,32(sp)
    8000181e:	ec56                	sd	s5,24(sp)
    80001820:	e85a                	sd	s6,16(sp)
    80001822:	e45e                	sd	s7,8(sp)
    80001824:	e062                	sd	s8,0(sp)
    80001826:	0880                	addi	s0,sp,80
    80001828:	8b2a                	mv	s6,a0
    8000182a:	8a2e                	mv	s4,a1
    8000182c:	8c32                	mv	s8,a2
    8000182e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001830:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001832:	6a85                	lui	s5,0x1
    80001834:	a00d                	j	80001856 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001836:	018505b3          	add	a1,a0,s8
    8000183a:	0004861b          	sext.w	a2,s1
    8000183e:	412585b3          	sub	a1,a1,s2
    80001842:	8552                	mv	a0,s4
    80001844:	e26ff0ef          	jal	80000e6a <memmove>

    len -= n;
    80001848:	409989b3          	sub	s3,s3,s1
    dst += n;
    8000184c:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000184e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001852:	02098063          	beqz	s3,80001872 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001856:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000185a:	85ca                	mv	a1,s2
    8000185c:	855a                	mv	a0,s6
    8000185e:	8bfff0ef          	jal	8000111c <walkaddr>
    if(pa0 == 0)
    80001862:	cd01                	beqz	a0,8000187a <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80001864:	418904b3          	sub	s1,s2,s8
    80001868:	94d6                	add	s1,s1,s5
    if(n > len)
    8000186a:	fc99f6e3          	bgeu	s3,s1,80001836 <copyin+0x28>
    8000186e:	84ce                	mv	s1,s3
    80001870:	b7d9                	j	80001836 <copyin+0x28>
  }
  return 0;
    80001872:	4501                	li	a0,0
    80001874:	a021                	j	8000187c <copyin+0x6e>
    80001876:	4501                	li	a0,0
}
    80001878:	8082                	ret
      return -1;
    8000187a:	557d                	li	a0,-1
}
    8000187c:	60a6                	ld	ra,72(sp)
    8000187e:	6406                	ld	s0,64(sp)
    80001880:	74e2                	ld	s1,56(sp)
    80001882:	7942                	ld	s2,48(sp)
    80001884:	79a2                	ld	s3,40(sp)
    80001886:	7a02                	ld	s4,32(sp)
    80001888:	6ae2                	ld	s5,24(sp)
    8000188a:	6b42                	ld	s6,16(sp)
    8000188c:	6ba2                	ld	s7,8(sp)
    8000188e:	6c02                	ld	s8,0(sp)
    80001890:	6161                	addi	sp,sp,80
    80001892:	8082                	ret

0000000080001894 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001894:	c6dd                	beqz	a3,80001942 <copyinstr+0xae>
{
    80001896:	715d                	addi	sp,sp,-80
    80001898:	e486                	sd	ra,72(sp)
    8000189a:	e0a2                	sd	s0,64(sp)
    8000189c:	fc26                	sd	s1,56(sp)
    8000189e:	f84a                	sd	s2,48(sp)
    800018a0:	f44e                	sd	s3,40(sp)
    800018a2:	f052                	sd	s4,32(sp)
    800018a4:	ec56                	sd	s5,24(sp)
    800018a6:	e85a                	sd	s6,16(sp)
    800018a8:	e45e                	sd	s7,8(sp)
    800018aa:	0880                	addi	s0,sp,80
    800018ac:	8a2a                	mv	s4,a0
    800018ae:	8b2e                	mv	s6,a1
    800018b0:	8bb2                	mv	s7,a2
    800018b2:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    800018b4:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800018b6:	6985                	lui	s3,0x1
    800018b8:	a825                	j	800018f0 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800018ba:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    800018be:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800018c0:	37fd                	addiw	a5,a5,-1
    800018c2:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800018c6:	60a6                	ld	ra,72(sp)
    800018c8:	6406                	ld	s0,64(sp)
    800018ca:	74e2                	ld	s1,56(sp)
    800018cc:	7942                	ld	s2,48(sp)
    800018ce:	79a2                	ld	s3,40(sp)
    800018d0:	7a02                	ld	s4,32(sp)
    800018d2:	6ae2                	ld	s5,24(sp)
    800018d4:	6b42                	ld	s6,16(sp)
    800018d6:	6ba2                	ld	s7,8(sp)
    800018d8:	6161                	addi	sp,sp,80
    800018da:	8082                	ret
    800018dc:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    800018e0:	9742                	add	a4,a4,a6
      --max;
    800018e2:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    800018e6:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    800018ea:	04e58463          	beq	a1,a4,80001932 <copyinstr+0x9e>
{
    800018ee:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    800018f0:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    800018f4:	85a6                	mv	a1,s1
    800018f6:	8552                	mv	a0,s4
    800018f8:	825ff0ef          	jal	8000111c <walkaddr>
    if(pa0 == 0)
    800018fc:	cd0d                	beqz	a0,80001936 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    800018fe:	417486b3          	sub	a3,s1,s7
    80001902:	96ce                	add	a3,a3,s3
    if(n > max)
    80001904:	00d97363          	bgeu	s2,a3,8000190a <copyinstr+0x76>
    80001908:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    8000190a:	955e                	add	a0,a0,s7
    8000190c:	8d05                	sub	a0,a0,s1
    while(n > 0){
    8000190e:	c695                	beqz	a3,8000193a <copyinstr+0xa6>
    80001910:	87da                	mv	a5,s6
    80001912:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001914:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001918:	96da                	add	a3,a3,s6
    8000191a:	85be                	mv	a1,a5
      if(*p == '\0'){
    8000191c:	00f60733          	add	a4,a2,a5
    80001920:	00074703          	lbu	a4,0(a4)
    80001924:	db59                	beqz	a4,800018ba <copyinstr+0x26>
        *dst = *p;
    80001926:	00e78023          	sb	a4,0(a5)
      dst++;
    8000192a:	0785                	addi	a5,a5,1
    while(n > 0){
    8000192c:	fed797e3          	bne	a5,a3,8000191a <copyinstr+0x86>
    80001930:	b775                	j	800018dc <copyinstr+0x48>
    80001932:	4781                	li	a5,0
    80001934:	b771                	j	800018c0 <copyinstr+0x2c>
      return -1;
    80001936:	557d                	li	a0,-1
    80001938:	b779                	j	800018c6 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    8000193a:	6b85                	lui	s7,0x1
    8000193c:	9ba6                	add	s7,s7,s1
    8000193e:	87da                	mv	a5,s6
    80001940:	b77d                	j	800018ee <copyinstr+0x5a>
  int got_null = 0;
    80001942:	4781                	li	a5,0
  if(got_null){
    80001944:	37fd                	addiw	a5,a5,-1
    80001946:	0007851b          	sext.w	a0,a5
}
    8000194a:	8082                	ret

000000008000194c <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000194c:	7139                	addi	sp,sp,-64
    8000194e:	fc06                	sd	ra,56(sp)
    80001950:	f822                	sd	s0,48(sp)
    80001952:	f426                	sd	s1,40(sp)
    80001954:	f04a                	sd	s2,32(sp)
    80001956:	ec4e                	sd	s3,24(sp)
    80001958:	e852                	sd	s4,16(sp)
    8000195a:	e456                	sd	s5,8(sp)
    8000195c:	e05a                	sd	s6,0(sp)
    8000195e:	0080                	addi	s0,sp,64
    80001960:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001962:	00451497          	auipc	s1,0x451
    80001966:	06648493          	addi	s1,s1,102 # 804529c8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    8000196a:	8b26                	mv	s6,s1
    8000196c:	04fa5937          	lui	s2,0x4fa5
    80001970:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001974:	0932                	slli	s2,s2,0xc
    80001976:	fa590913          	addi	s2,s2,-91
    8000197a:	0932                	slli	s2,s2,0xc
    8000197c:	fa590913          	addi	s2,s2,-91
    80001980:	0932                	slli	s2,s2,0xc
    80001982:	fa590913          	addi	s2,s2,-91
    80001986:	040009b7          	lui	s3,0x4000
    8000198a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000198c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000198e:	00457a97          	auipc	s5,0x457
    80001992:	a3aa8a93          	addi	s5,s5,-1478 # 804583c8 <tickslock>
    char *pa = kalloc();
    80001996:	aa2ff0ef          	jal	80000c38 <kalloc>
    8000199a:	862a                	mv	a2,a0
    if(pa == 0)
    8000199c:	cd15                	beqz	a0,800019d8 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    8000199e:	416485b3          	sub	a1,s1,s6
    800019a2:	858d                	srai	a1,a1,0x3
    800019a4:	032585b3          	mul	a1,a1,s2
    800019a8:	2585                	addiw	a1,a1,1
    800019aa:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800019ae:	4719                	li	a4,6
    800019b0:	6685                	lui	a3,0x1
    800019b2:	40b985b3          	sub	a1,s3,a1
    800019b6:	8552                	mv	a0,s4
    800019b8:	853ff0ef          	jal	8000120a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    800019bc:	16848493          	addi	s1,s1,360
    800019c0:	fd549be3          	bne	s1,s5,80001996 <proc_mapstacks+0x4a>
  }
}
    800019c4:	70e2                	ld	ra,56(sp)
    800019c6:	7442                	ld	s0,48(sp)
    800019c8:	74a2                	ld	s1,40(sp)
    800019ca:	7902                	ld	s2,32(sp)
    800019cc:	69e2                	ld	s3,24(sp)
    800019ce:	6a42                	ld	s4,16(sp)
    800019d0:	6aa2                	ld	s5,8(sp)
    800019d2:	6b02                	ld	s6,0(sp)
    800019d4:	6121                	addi	sp,sp,64
    800019d6:	8082                	ret
      panic("kalloc");
    800019d8:	00006517          	auipc	a0,0x6
    800019dc:	86050513          	addi	a0,a0,-1952 # 80007238 <etext+0x238>
    800019e0:	db5fe0ef          	jal	80000794 <panic>

00000000800019e4 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800019e4:	7139                	addi	sp,sp,-64
    800019e6:	fc06                	sd	ra,56(sp)
    800019e8:	f822                	sd	s0,48(sp)
    800019ea:	f426                	sd	s1,40(sp)
    800019ec:	f04a                	sd	s2,32(sp)
    800019ee:	ec4e                	sd	s3,24(sp)
    800019f0:	e852                	sd	s4,16(sp)
    800019f2:	e456                	sd	s5,8(sp)
    800019f4:	e05a                	sd	s6,0(sp)
    800019f6:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800019f8:	00006597          	auipc	a1,0x6
    800019fc:	84858593          	addi	a1,a1,-1976 # 80007240 <etext+0x240>
    80001a00:	00451517          	auipc	a0,0x451
    80001a04:	b9850513          	addi	a0,a0,-1128 # 80452598 <pid_lock>
    80001a08:	ab2ff0ef          	jal	80000cba <initlock>
  initlock(&wait_lock, "wait_lock");
    80001a0c:	00006597          	auipc	a1,0x6
    80001a10:	83c58593          	addi	a1,a1,-1988 # 80007248 <etext+0x248>
    80001a14:	00451517          	auipc	a0,0x451
    80001a18:	b9c50513          	addi	a0,a0,-1124 # 804525b0 <wait_lock>
    80001a1c:	a9eff0ef          	jal	80000cba <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a20:	00451497          	auipc	s1,0x451
    80001a24:	fa848493          	addi	s1,s1,-88 # 804529c8 <proc>
      initlock(&p->lock, "proc");
    80001a28:	00006b17          	auipc	s6,0x6
    80001a2c:	830b0b13          	addi	s6,s6,-2000 # 80007258 <etext+0x258>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001a30:	8aa6                	mv	s5,s1
    80001a32:	04fa5937          	lui	s2,0x4fa5
    80001a36:	fa590913          	addi	s2,s2,-91 # 4fa4fa5 <_entry-0x7b05b05b>
    80001a3a:	0932                	slli	s2,s2,0xc
    80001a3c:	fa590913          	addi	s2,s2,-91
    80001a40:	0932                	slli	s2,s2,0xc
    80001a42:	fa590913          	addi	s2,s2,-91
    80001a46:	0932                	slli	s2,s2,0xc
    80001a48:	fa590913          	addi	s2,s2,-91
    80001a4c:	040009b7          	lui	s3,0x4000
    80001a50:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001a52:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a54:	00457a17          	auipc	s4,0x457
    80001a58:	974a0a13          	addi	s4,s4,-1676 # 804583c8 <tickslock>
      initlock(&p->lock, "proc");
    80001a5c:	85da                	mv	a1,s6
    80001a5e:	8526                	mv	a0,s1
    80001a60:	a5aff0ef          	jal	80000cba <initlock>
      p->state = UNUSED;
    80001a64:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001a68:	415487b3          	sub	a5,s1,s5
    80001a6c:	878d                	srai	a5,a5,0x3
    80001a6e:	032787b3          	mul	a5,a5,s2
    80001a72:	2785                	addiw	a5,a5,1
    80001a74:	00d7979b          	slliw	a5,a5,0xd
    80001a78:	40f987b3          	sub	a5,s3,a5
    80001a7c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a7e:	16848493          	addi	s1,s1,360
    80001a82:	fd449de3          	bne	s1,s4,80001a5c <procinit+0x78>
  }
}
    80001a86:	70e2                	ld	ra,56(sp)
    80001a88:	7442                	ld	s0,48(sp)
    80001a8a:	74a2                	ld	s1,40(sp)
    80001a8c:	7902                	ld	s2,32(sp)
    80001a8e:	69e2                	ld	s3,24(sp)
    80001a90:	6a42                	ld	s4,16(sp)
    80001a92:	6aa2                	ld	s5,8(sp)
    80001a94:	6b02                	ld	s6,0(sp)
    80001a96:	6121                	addi	sp,sp,64
    80001a98:	8082                	ret

0000000080001a9a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001a9a:	1141                	addi	sp,sp,-16
    80001a9c:	e422                	sd	s0,8(sp)
    80001a9e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001aa0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001aa2:	2501                	sext.w	a0,a0
    80001aa4:	6422                	ld	s0,8(sp)
    80001aa6:	0141                	addi	sp,sp,16
    80001aa8:	8082                	ret

0000000080001aaa <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001aaa:	1141                	addi	sp,sp,-16
    80001aac:	e422                	sd	s0,8(sp)
    80001aae:	0800                	addi	s0,sp,16
    80001ab0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001ab2:	2781                	sext.w	a5,a5
    80001ab4:	079e                	slli	a5,a5,0x7
  return c;
}
    80001ab6:	00451517          	auipc	a0,0x451
    80001aba:	b1250513          	addi	a0,a0,-1262 # 804525c8 <cpus>
    80001abe:	953e                	add	a0,a0,a5
    80001ac0:	6422                	ld	s0,8(sp)
    80001ac2:	0141                	addi	sp,sp,16
    80001ac4:	8082                	ret

0000000080001ac6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001ac6:	1101                	addi	sp,sp,-32
    80001ac8:	ec06                	sd	ra,24(sp)
    80001aca:	e822                	sd	s0,16(sp)
    80001acc:	e426                	sd	s1,8(sp)
    80001ace:	1000                	addi	s0,sp,32
  push_off();
    80001ad0:	a2aff0ef          	jal	80000cfa <push_off>
    80001ad4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001ad6:	2781                	sext.w	a5,a5
    80001ad8:	079e                	slli	a5,a5,0x7
    80001ada:	00451717          	auipc	a4,0x451
    80001ade:	abe70713          	addi	a4,a4,-1346 # 80452598 <pid_lock>
    80001ae2:	97ba                	add	a5,a5,a4
    80001ae4:	7b84                	ld	s1,48(a5)
  pop_off();
    80001ae6:	a98ff0ef          	jal	80000d7e <pop_off>
  return p;
}
    80001aea:	8526                	mv	a0,s1
    80001aec:	60e2                	ld	ra,24(sp)
    80001aee:	6442                	ld	s0,16(sp)
    80001af0:	64a2                	ld	s1,8(sp)
    80001af2:	6105                	addi	sp,sp,32
    80001af4:	8082                	ret

0000000080001af6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001af6:	1141                	addi	sp,sp,-16
    80001af8:	e406                	sd	ra,8(sp)
    80001afa:	e022                	sd	s0,0(sp)
    80001afc:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001afe:	fc9ff0ef          	jal	80001ac6 <myproc>
    80001b02:	ad0ff0ef          	jal	80000dd2 <release>

  if (first) {
    80001b06:	00009797          	auipc	a5,0x9
    80001b0a:	8aa7a783          	lw	a5,-1878(a5) # 8000a3b0 <first.1>
    80001b0e:	e799                	bnez	a5,80001b1c <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001b10:	2bf000ef          	jal	800025ce <usertrapret>
}
    80001b14:	60a2                	ld	ra,8(sp)
    80001b16:	6402                	ld	s0,0(sp)
    80001b18:	0141                	addi	sp,sp,16
    80001b1a:	8082                	ret
    fsinit(ROOTDEV);
    80001b1c:	4505                	li	a0,1
    80001b1e:	7c4010ef          	jal	800032e2 <fsinit>
    first = 0;
    80001b22:	00009797          	auipc	a5,0x9
    80001b26:	8807a723          	sw	zero,-1906(a5) # 8000a3b0 <first.1>
    __sync_synchronize();
    80001b2a:	0330000f          	fence	rw,rw
    80001b2e:	b7cd                	j	80001b10 <forkret+0x1a>

0000000080001b30 <allocpid>:
{
    80001b30:	1101                	addi	sp,sp,-32
    80001b32:	ec06                	sd	ra,24(sp)
    80001b34:	e822                	sd	s0,16(sp)
    80001b36:	e426                	sd	s1,8(sp)
    80001b38:	e04a                	sd	s2,0(sp)
    80001b3a:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001b3c:	00451917          	auipc	s2,0x451
    80001b40:	a5c90913          	addi	s2,s2,-1444 # 80452598 <pid_lock>
    80001b44:	854a                	mv	a0,s2
    80001b46:	9f4ff0ef          	jal	80000d3a <acquire>
  pid = nextpid;
    80001b4a:	00009797          	auipc	a5,0x9
    80001b4e:	86a78793          	addi	a5,a5,-1942 # 8000a3b4 <nextpid>
    80001b52:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001b54:	0014871b          	addiw	a4,s1,1
    80001b58:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001b5a:	854a                	mv	a0,s2
    80001b5c:	a76ff0ef          	jal	80000dd2 <release>
}
    80001b60:	8526                	mv	a0,s1
    80001b62:	60e2                	ld	ra,24(sp)
    80001b64:	6442                	ld	s0,16(sp)
    80001b66:	64a2                	ld	s1,8(sp)
    80001b68:	6902                	ld	s2,0(sp)
    80001b6a:	6105                	addi	sp,sp,32
    80001b6c:	8082                	ret

0000000080001b6e <proc_pagetable>:
{
    80001b6e:	1101                	addi	sp,sp,-32
    80001b70:	ec06                	sd	ra,24(sp)
    80001b72:	e822                	sd	s0,16(sp)
    80001b74:	e426                	sd	s1,8(sp)
    80001b76:	e04a                	sd	s2,0(sp)
    80001b78:	1000                	addi	s0,sp,32
    80001b7a:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001b7c:	841ff0ef          	jal	800013bc <uvmcreate>
    80001b80:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001b82:	cd05                	beqz	a0,80001bba <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001b84:	4729                	li	a4,10
    80001b86:	00004697          	auipc	a3,0x4
    80001b8a:	47a68693          	addi	a3,a3,1146 # 80006000 <_trampoline>
    80001b8e:	6605                	lui	a2,0x1
    80001b90:	040005b7          	lui	a1,0x4000
    80001b94:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001b96:	05b2                	slli	a1,a1,0xc
    80001b98:	dc2ff0ef          	jal	8000115a <mappages>
    80001b9c:	02054663          	bltz	a0,80001bc8 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001ba0:	4719                	li	a4,6
    80001ba2:	05893683          	ld	a3,88(s2)
    80001ba6:	6605                	lui	a2,0x1
    80001ba8:	020005b7          	lui	a1,0x2000
    80001bac:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001bae:	05b6                	slli	a1,a1,0xd
    80001bb0:	8526                	mv	a0,s1
    80001bb2:	da8ff0ef          	jal	8000115a <mappages>
    80001bb6:	00054f63          	bltz	a0,80001bd4 <proc_pagetable+0x66>
}
    80001bba:	8526                	mv	a0,s1
    80001bbc:	60e2                	ld	ra,24(sp)
    80001bbe:	6442                	ld	s0,16(sp)
    80001bc0:	64a2                	ld	s1,8(sp)
    80001bc2:	6902                	ld	s2,0(sp)
    80001bc4:	6105                	addi	sp,sp,32
    80001bc6:	8082                	ret
    uvmfree(pagetable, 0);
    80001bc8:	4581                	li	a1,0
    80001bca:	8526                	mv	a0,s1
    80001bcc:	9bfff0ef          	jal	8000158a <uvmfree>
    return 0;
    80001bd0:	4481                	li	s1,0
    80001bd2:	b7e5                	j	80001bba <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001bd4:	4681                	li	a3,0
    80001bd6:	4605                	li	a2,1
    80001bd8:	040005b7          	lui	a1,0x4000
    80001bdc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001bde:	05b2                	slli	a1,a1,0xc
    80001be0:	8526                	mv	a0,s1
    80001be2:	f1eff0ef          	jal	80001300 <uvmunmap>
    uvmfree(pagetable, 0);
    80001be6:	4581                	li	a1,0
    80001be8:	8526                	mv	a0,s1
    80001bea:	9a1ff0ef          	jal	8000158a <uvmfree>
    return 0;
    80001bee:	4481                	li	s1,0
    80001bf0:	b7e9                	j	80001bba <proc_pagetable+0x4c>

0000000080001bf2 <proc_freepagetable>:
{
    80001bf2:	1101                	addi	sp,sp,-32
    80001bf4:	ec06                	sd	ra,24(sp)
    80001bf6:	e822                	sd	s0,16(sp)
    80001bf8:	e426                	sd	s1,8(sp)
    80001bfa:	e04a                	sd	s2,0(sp)
    80001bfc:	1000                	addi	s0,sp,32
    80001bfe:	84aa                	mv	s1,a0
    80001c00:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001c02:	4681                	li	a3,0
    80001c04:	4605                	li	a2,1
    80001c06:	040005b7          	lui	a1,0x4000
    80001c0a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001c0c:	05b2                	slli	a1,a1,0xc
    80001c0e:	ef2ff0ef          	jal	80001300 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001c12:	4681                	li	a3,0
    80001c14:	4605                	li	a2,1
    80001c16:	020005b7          	lui	a1,0x2000
    80001c1a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001c1c:	05b6                	slli	a1,a1,0xd
    80001c1e:	8526                	mv	a0,s1
    80001c20:	ee0ff0ef          	jal	80001300 <uvmunmap>
  uvmfree(pagetable, sz);
    80001c24:	85ca                	mv	a1,s2
    80001c26:	8526                	mv	a0,s1
    80001c28:	963ff0ef          	jal	8000158a <uvmfree>
}
    80001c2c:	60e2                	ld	ra,24(sp)
    80001c2e:	6442                	ld	s0,16(sp)
    80001c30:	64a2                	ld	s1,8(sp)
    80001c32:	6902                	ld	s2,0(sp)
    80001c34:	6105                	addi	sp,sp,32
    80001c36:	8082                	ret

0000000080001c38 <freeproc>:
{
    80001c38:	1101                	addi	sp,sp,-32
    80001c3a:	ec06                	sd	ra,24(sp)
    80001c3c:	e822                	sd	s0,16(sp)
    80001c3e:	e426                	sd	s1,8(sp)
    80001c40:	1000                	addi	s0,sp,32
    80001c42:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001c44:	6d28                	ld	a0,88(a0)
    80001c46:	c119                	beqz	a0,80001c4c <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001c48:	ebffe0ef          	jal	80000b06 <kfree>
  p->trapframe = 0;
    80001c4c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80001c50:	68a8                	ld	a0,80(s1)
    80001c52:	c501                	beqz	a0,80001c5a <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001c54:	64ac                	ld	a1,72(s1)
    80001c56:	f9dff0ef          	jal	80001bf2 <proc_freepagetable>
  p->pagetable = 0;
    80001c5a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001c5e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001c62:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001c66:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001c6a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001c6e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001c72:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001c76:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001c7a:	0004ac23          	sw	zero,24(s1)
}
    80001c7e:	60e2                	ld	ra,24(sp)
    80001c80:	6442                	ld	s0,16(sp)
    80001c82:	64a2                	ld	s1,8(sp)
    80001c84:	6105                	addi	sp,sp,32
    80001c86:	8082                	ret

0000000080001c88 <allocproc>:
{
    80001c88:	1101                	addi	sp,sp,-32
    80001c8a:	ec06                	sd	ra,24(sp)
    80001c8c:	e822                	sd	s0,16(sp)
    80001c8e:	e426                	sd	s1,8(sp)
    80001c90:	e04a                	sd	s2,0(sp)
    80001c92:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c94:	00451497          	auipc	s1,0x451
    80001c98:	d3448493          	addi	s1,s1,-716 # 804529c8 <proc>
    80001c9c:	00456917          	auipc	s2,0x456
    80001ca0:	72c90913          	addi	s2,s2,1836 # 804583c8 <tickslock>
    acquire(&p->lock);
    80001ca4:	8526                	mv	a0,s1
    80001ca6:	894ff0ef          	jal	80000d3a <acquire>
    if(p->state == UNUSED) {
    80001caa:	4c9c                	lw	a5,24(s1)
    80001cac:	cb91                	beqz	a5,80001cc0 <allocproc+0x38>
      release(&p->lock);
    80001cae:	8526                	mv	a0,s1
    80001cb0:	922ff0ef          	jal	80000dd2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001cb4:	16848493          	addi	s1,s1,360
    80001cb8:	ff2496e3          	bne	s1,s2,80001ca4 <allocproc+0x1c>
  return 0;
    80001cbc:	4481                	li	s1,0
    80001cbe:	a089                	j	80001d00 <allocproc+0x78>
  p->pid = allocpid();
    80001cc0:	e71ff0ef          	jal	80001b30 <allocpid>
    80001cc4:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001cc6:	4785                	li	a5,1
    80001cc8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001cca:	f6ffe0ef          	jal	80000c38 <kalloc>
    80001cce:	892a                	mv	s2,a0
    80001cd0:	eca8                	sd	a0,88(s1)
    80001cd2:	cd15                	beqz	a0,80001d0e <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001cd4:	8526                	mv	a0,s1
    80001cd6:	e99ff0ef          	jal	80001b6e <proc_pagetable>
    80001cda:	892a                	mv	s2,a0
    80001cdc:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001cde:	c121                	beqz	a0,80001d1e <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001ce0:	07000613          	li	a2,112
    80001ce4:	4581                	li	a1,0
    80001ce6:	06048513          	addi	a0,s1,96
    80001cea:	924ff0ef          	jal	80000e0e <memset>
  p->context.ra = (uint64)forkret;
    80001cee:	00000797          	auipc	a5,0x0
    80001cf2:	e0878793          	addi	a5,a5,-504 # 80001af6 <forkret>
    80001cf6:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001cf8:	60bc                	ld	a5,64(s1)
    80001cfa:	6705                	lui	a4,0x1
    80001cfc:	97ba                	add	a5,a5,a4
    80001cfe:	f4bc                	sd	a5,104(s1)
}
    80001d00:	8526                	mv	a0,s1
    80001d02:	60e2                	ld	ra,24(sp)
    80001d04:	6442                	ld	s0,16(sp)
    80001d06:	64a2                	ld	s1,8(sp)
    80001d08:	6902                	ld	s2,0(sp)
    80001d0a:	6105                	addi	sp,sp,32
    80001d0c:	8082                	ret
    freeproc(p);
    80001d0e:	8526                	mv	a0,s1
    80001d10:	f29ff0ef          	jal	80001c38 <freeproc>
    release(&p->lock);
    80001d14:	8526                	mv	a0,s1
    80001d16:	8bcff0ef          	jal	80000dd2 <release>
    return 0;
    80001d1a:	84ca                	mv	s1,s2
    80001d1c:	b7d5                	j	80001d00 <allocproc+0x78>
    freeproc(p);
    80001d1e:	8526                	mv	a0,s1
    80001d20:	f19ff0ef          	jal	80001c38 <freeproc>
    release(&p->lock);
    80001d24:	8526                	mv	a0,s1
    80001d26:	8acff0ef          	jal	80000dd2 <release>
    return 0;
    80001d2a:	84ca                	mv	s1,s2
    80001d2c:	bfd1                	j	80001d00 <allocproc+0x78>

0000000080001d2e <userinit>:
{
    80001d2e:	1101                	addi	sp,sp,-32
    80001d30:	ec06                	sd	ra,24(sp)
    80001d32:	e822                	sd	s0,16(sp)
    80001d34:	e426                	sd	s1,8(sp)
    80001d36:	1000                	addi	s0,sp,32
  p = allocproc();
    80001d38:	f51ff0ef          	jal	80001c88 <allocproc>
    80001d3c:	84aa                	mv	s1,a0
  initproc = p;
    80001d3e:	00008797          	auipc	a5,0x8
    80001d42:	70a7b523          	sd	a0,1802(a5) # 8000a448 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001d46:	03400613          	li	a2,52
    80001d4a:	00008597          	auipc	a1,0x8
    80001d4e:	67658593          	addi	a1,a1,1654 # 8000a3c0 <initcode>
    80001d52:	6928                	ld	a0,80(a0)
    80001d54:	e8eff0ef          	jal	800013e2 <uvmfirst>
  p->sz = PGSIZE;
    80001d58:	6785                	lui	a5,0x1
    80001d5a:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80001d5c:	6cb8                	ld	a4,88(s1)
    80001d5e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001d62:	6cb8                	ld	a4,88(s1)
    80001d64:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001d66:	4641                	li	a2,16
    80001d68:	00005597          	auipc	a1,0x5
    80001d6c:	4f858593          	addi	a1,a1,1272 # 80007260 <etext+0x260>
    80001d70:	15848513          	addi	a0,s1,344
    80001d74:	9d8ff0ef          	jal	80000f4c <safestrcpy>
  p->cwd = namei("/");
    80001d78:	00005517          	auipc	a0,0x5
    80001d7c:	4f850513          	addi	a0,a0,1272 # 80007270 <etext+0x270>
    80001d80:	701010ef          	jal	80003c80 <namei>
    80001d84:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001d88:	478d                	li	a5,3
    80001d8a:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001d8c:	8526                	mv	a0,s1
    80001d8e:	844ff0ef          	jal	80000dd2 <release>
}
    80001d92:	60e2                	ld	ra,24(sp)
    80001d94:	6442                	ld	s0,16(sp)
    80001d96:	64a2                	ld	s1,8(sp)
    80001d98:	6105                	addi	sp,sp,32
    80001d9a:	8082                	ret

0000000080001d9c <growproc>:
{
    80001d9c:	1101                	addi	sp,sp,-32
    80001d9e:	ec06                	sd	ra,24(sp)
    80001da0:	e822                	sd	s0,16(sp)
    80001da2:	e426                	sd	s1,8(sp)
    80001da4:	e04a                	sd	s2,0(sp)
    80001da6:	1000                	addi	s0,sp,32
    80001da8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001daa:	d1dff0ef          	jal	80001ac6 <myproc>
    80001dae:	84aa                	mv	s1,a0
  sz = p->sz;
    80001db0:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001db2:	01204c63          	bgtz	s2,80001dca <growproc+0x2e>
  } else if(n < 0){
    80001db6:	02094463          	bltz	s2,80001dde <growproc+0x42>
  p->sz = sz;
    80001dba:	e4ac                	sd	a1,72(s1)
  return 0;
    80001dbc:	4501                	li	a0,0
}
    80001dbe:	60e2                	ld	ra,24(sp)
    80001dc0:	6442                	ld	s0,16(sp)
    80001dc2:	64a2                	ld	s1,8(sp)
    80001dc4:	6902                	ld	s2,0(sp)
    80001dc6:	6105                	addi	sp,sp,32
    80001dc8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001dca:	4691                	li	a3,4
    80001dcc:	00b90633          	add	a2,s2,a1
    80001dd0:	6928                	ld	a0,80(a0)
    80001dd2:	eb2ff0ef          	jal	80001484 <uvmalloc>
    80001dd6:	85aa                	mv	a1,a0
    80001dd8:	f16d                	bnez	a0,80001dba <growproc+0x1e>
      return -1;
    80001dda:	557d                	li	a0,-1
    80001ddc:	b7cd                	j	80001dbe <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001dde:	00b90633          	add	a2,s2,a1
    80001de2:	6928                	ld	a0,80(a0)
    80001de4:	e5cff0ef          	jal	80001440 <uvmdealloc>
    80001de8:	85aa                	mv	a1,a0
    80001dea:	bfc1                	j	80001dba <growproc+0x1e>

0000000080001dec <fork>:
{
    80001dec:	7139                	addi	sp,sp,-64
    80001dee:	fc06                	sd	ra,56(sp)
    80001df0:	f822                	sd	s0,48(sp)
    80001df2:	f04a                	sd	s2,32(sp)
    80001df4:	e456                	sd	s5,8(sp)
    80001df6:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001df8:	ccfff0ef          	jal	80001ac6 <myproc>
    80001dfc:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001dfe:	e8bff0ef          	jal	80001c88 <allocproc>
    80001e02:	0e050a63          	beqz	a0,80001ef6 <fork+0x10a>
    80001e06:	e852                	sd	s4,16(sp)
    80001e08:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001e0a:	048ab603          	ld	a2,72(s5)
    80001e0e:	692c                	ld	a1,80(a0)
    80001e10:	050ab503          	ld	a0,80(s5)
    80001e14:	fa8ff0ef          	jal	800015bc <uvmcopy>
    80001e18:	04054a63          	bltz	a0,80001e6c <fork+0x80>
    80001e1c:	f426                	sd	s1,40(sp)
    80001e1e:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001e20:	048ab783          	ld	a5,72(s5)
    80001e24:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001e28:	058ab683          	ld	a3,88(s5)
    80001e2c:	87b6                	mv	a5,a3
    80001e2e:	058a3703          	ld	a4,88(s4)
    80001e32:	12068693          	addi	a3,a3,288
    80001e36:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001e3a:	6788                	ld	a0,8(a5)
    80001e3c:	6b8c                	ld	a1,16(a5)
    80001e3e:	6f90                	ld	a2,24(a5)
    80001e40:	01073023          	sd	a6,0(a4)
    80001e44:	e708                	sd	a0,8(a4)
    80001e46:	eb0c                	sd	a1,16(a4)
    80001e48:	ef10                	sd	a2,24(a4)
    80001e4a:	02078793          	addi	a5,a5,32
    80001e4e:	02070713          	addi	a4,a4,32
    80001e52:	fed792e3          	bne	a5,a3,80001e36 <fork+0x4a>
  np->trapframe->a0 = 0;
    80001e56:	058a3783          	ld	a5,88(s4)
    80001e5a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001e5e:	0d0a8493          	addi	s1,s5,208
    80001e62:	0d0a0913          	addi	s2,s4,208
    80001e66:	150a8993          	addi	s3,s5,336
    80001e6a:	a831                	j	80001e86 <fork+0x9a>
    freeproc(np);
    80001e6c:	8552                	mv	a0,s4
    80001e6e:	dcbff0ef          	jal	80001c38 <freeproc>
    release(&np->lock);
    80001e72:	8552                	mv	a0,s4
    80001e74:	f5ffe0ef          	jal	80000dd2 <release>
    return -1;
    80001e78:	597d                	li	s2,-1
    80001e7a:	6a42                	ld	s4,16(sp)
    80001e7c:	a0b5                	j	80001ee8 <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001e7e:	04a1                	addi	s1,s1,8
    80001e80:	0921                	addi	s2,s2,8
    80001e82:	01348963          	beq	s1,s3,80001e94 <fork+0xa8>
    if(p->ofile[i])
    80001e86:	6088                	ld	a0,0(s1)
    80001e88:	d97d                	beqz	a0,80001e7e <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001e8a:	386020ef          	jal	80004210 <filedup>
    80001e8e:	00a93023          	sd	a0,0(s2)
    80001e92:	b7f5                	j	80001e7e <fork+0x92>
  np->cwd = idup(p->cwd);
    80001e94:	150ab503          	ld	a0,336(s5)
    80001e98:	648010ef          	jal	800034e0 <idup>
    80001e9c:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001ea0:	4641                	li	a2,16
    80001ea2:	158a8593          	addi	a1,s5,344
    80001ea6:	158a0513          	addi	a0,s4,344
    80001eaa:	8a2ff0ef          	jal	80000f4c <safestrcpy>
  pid = np->pid;
    80001eae:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001eb2:	8552                	mv	a0,s4
    80001eb4:	f1ffe0ef          	jal	80000dd2 <release>
  acquire(&wait_lock);
    80001eb8:	00450497          	auipc	s1,0x450
    80001ebc:	6f848493          	addi	s1,s1,1784 # 804525b0 <wait_lock>
    80001ec0:	8526                	mv	a0,s1
    80001ec2:	e79fe0ef          	jal	80000d3a <acquire>
  np->parent = p;
    80001ec6:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001eca:	8526                	mv	a0,s1
    80001ecc:	f07fe0ef          	jal	80000dd2 <release>
  acquire(&np->lock);
    80001ed0:	8552                	mv	a0,s4
    80001ed2:	e69fe0ef          	jal	80000d3a <acquire>
  np->state = RUNNABLE;
    80001ed6:	478d                	li	a5,3
    80001ed8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001edc:	8552                	mv	a0,s4
    80001ede:	ef5fe0ef          	jal	80000dd2 <release>
  return pid;
    80001ee2:	74a2                	ld	s1,40(sp)
    80001ee4:	69e2                	ld	s3,24(sp)
    80001ee6:	6a42                	ld	s4,16(sp)
}
    80001ee8:	854a                	mv	a0,s2
    80001eea:	70e2                	ld	ra,56(sp)
    80001eec:	7442                	ld	s0,48(sp)
    80001eee:	7902                	ld	s2,32(sp)
    80001ef0:	6aa2                	ld	s5,8(sp)
    80001ef2:	6121                	addi	sp,sp,64
    80001ef4:	8082                	ret
    return -1;
    80001ef6:	597d                	li	s2,-1
    80001ef8:	bfc5                	j	80001ee8 <fork+0xfc>

0000000080001efa <scheduler>:
{
    80001efa:	715d                	addi	sp,sp,-80
    80001efc:	e486                	sd	ra,72(sp)
    80001efe:	e0a2                	sd	s0,64(sp)
    80001f00:	fc26                	sd	s1,56(sp)
    80001f02:	f84a                	sd	s2,48(sp)
    80001f04:	f44e                	sd	s3,40(sp)
    80001f06:	f052                	sd	s4,32(sp)
    80001f08:	ec56                	sd	s5,24(sp)
    80001f0a:	e85a                	sd	s6,16(sp)
    80001f0c:	e45e                	sd	s7,8(sp)
    80001f0e:	e062                	sd	s8,0(sp)
    80001f10:	0880                	addi	s0,sp,80
    80001f12:	8792                	mv	a5,tp
  int id = r_tp();
    80001f14:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001f16:	00779b13          	slli	s6,a5,0x7
    80001f1a:	00450717          	auipc	a4,0x450
    80001f1e:	67e70713          	addi	a4,a4,1662 # 80452598 <pid_lock>
    80001f22:	975a                	add	a4,a4,s6
    80001f24:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001f28:	00450717          	auipc	a4,0x450
    80001f2c:	6a870713          	addi	a4,a4,1704 # 804525d0 <cpus+0x8>
    80001f30:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001f32:	4c11                	li	s8,4
        c->proc = p;
    80001f34:	079e                	slli	a5,a5,0x7
    80001f36:	00450a17          	auipc	s4,0x450
    80001f3a:	662a0a13          	addi	s4,s4,1634 # 80452598 <pid_lock>
    80001f3e:	9a3e                	add	s4,s4,a5
        found = 1;
    80001f40:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f42:	00456997          	auipc	s3,0x456
    80001f46:	48698993          	addi	s3,s3,1158 # 804583c8 <tickslock>
    80001f4a:	a0a9                	j	80001f94 <scheduler+0x9a>
      release(&p->lock);
    80001f4c:	8526                	mv	a0,s1
    80001f4e:	e85fe0ef          	jal	80000dd2 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001f52:	16848493          	addi	s1,s1,360
    80001f56:	03348563          	beq	s1,s3,80001f80 <scheduler+0x86>
      acquire(&p->lock);
    80001f5a:	8526                	mv	a0,s1
    80001f5c:	ddffe0ef          	jal	80000d3a <acquire>
      if(p->state == RUNNABLE) {
    80001f60:	4c9c                	lw	a5,24(s1)
    80001f62:	ff2795e3          	bne	a5,s2,80001f4c <scheduler+0x52>
        p->state = RUNNING;
    80001f66:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001f6a:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001f6e:	06048593          	addi	a1,s1,96
    80001f72:	855a                	mv	a0,s6
    80001f74:	5b4000ef          	jal	80002528 <swtch>
        c->proc = 0;
    80001f78:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001f7c:	8ade                	mv	s5,s7
    80001f7e:	b7f9                	j	80001f4c <scheduler+0x52>
    if(found == 0) {
    80001f80:	000a9a63          	bnez	s5,80001f94 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f88:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f8c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001f90:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f94:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001f98:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f9c:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001fa0:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001fa2:	00451497          	auipc	s1,0x451
    80001fa6:	a2648493          	addi	s1,s1,-1498 # 804529c8 <proc>
      if(p->state == RUNNABLE) {
    80001faa:	490d                	li	s2,3
    80001fac:	b77d                	j	80001f5a <scheduler+0x60>

0000000080001fae <sched>:
{
    80001fae:	7179                	addi	sp,sp,-48
    80001fb0:	f406                	sd	ra,40(sp)
    80001fb2:	f022                	sd	s0,32(sp)
    80001fb4:	ec26                	sd	s1,24(sp)
    80001fb6:	e84a                	sd	s2,16(sp)
    80001fb8:	e44e                	sd	s3,8(sp)
    80001fba:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001fbc:	b0bff0ef          	jal	80001ac6 <myproc>
    80001fc0:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001fc2:	d0ffe0ef          	jal	80000cd0 <holding>
    80001fc6:	c92d                	beqz	a0,80002038 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001fc8:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001fca:	2781                	sext.w	a5,a5
    80001fcc:	079e                	slli	a5,a5,0x7
    80001fce:	00450717          	auipc	a4,0x450
    80001fd2:	5ca70713          	addi	a4,a4,1482 # 80452598 <pid_lock>
    80001fd6:	97ba                	add	a5,a5,a4
    80001fd8:	0a87a703          	lw	a4,168(a5)
    80001fdc:	4785                	li	a5,1
    80001fde:	06f71363          	bne	a4,a5,80002044 <sched+0x96>
  if(p->state == RUNNING)
    80001fe2:	4c98                	lw	a4,24(s1)
    80001fe4:	4791                	li	a5,4
    80001fe6:	06f70563          	beq	a4,a5,80002050 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001fea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001fee:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001ff0:	e7b5                	bnez	a5,8000205c <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001ff2:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001ff4:	00450917          	auipc	s2,0x450
    80001ff8:	5a490913          	addi	s2,s2,1444 # 80452598 <pid_lock>
    80001ffc:	2781                	sext.w	a5,a5
    80001ffe:	079e                	slli	a5,a5,0x7
    80002000:	97ca                	add	a5,a5,s2
    80002002:	0ac7a983          	lw	s3,172(a5)
    80002006:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002008:	2781                	sext.w	a5,a5
    8000200a:	079e                	slli	a5,a5,0x7
    8000200c:	00450597          	auipc	a1,0x450
    80002010:	5c458593          	addi	a1,a1,1476 # 804525d0 <cpus+0x8>
    80002014:	95be                	add	a1,a1,a5
    80002016:	06048513          	addi	a0,s1,96
    8000201a:	50e000ef          	jal	80002528 <swtch>
    8000201e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002020:	2781                	sext.w	a5,a5
    80002022:	079e                	slli	a5,a5,0x7
    80002024:	993e                	add	s2,s2,a5
    80002026:	0b392623          	sw	s3,172(s2)
}
    8000202a:	70a2                	ld	ra,40(sp)
    8000202c:	7402                	ld	s0,32(sp)
    8000202e:	64e2                	ld	s1,24(sp)
    80002030:	6942                	ld	s2,16(sp)
    80002032:	69a2                	ld	s3,8(sp)
    80002034:	6145                	addi	sp,sp,48
    80002036:	8082                	ret
    panic("sched p->lock");
    80002038:	00005517          	auipc	a0,0x5
    8000203c:	24050513          	addi	a0,a0,576 # 80007278 <etext+0x278>
    80002040:	f54fe0ef          	jal	80000794 <panic>
    panic("sched locks");
    80002044:	00005517          	auipc	a0,0x5
    80002048:	24450513          	addi	a0,a0,580 # 80007288 <etext+0x288>
    8000204c:	f48fe0ef          	jal	80000794 <panic>
    panic("sched running");
    80002050:	00005517          	auipc	a0,0x5
    80002054:	24850513          	addi	a0,a0,584 # 80007298 <etext+0x298>
    80002058:	f3cfe0ef          	jal	80000794 <panic>
    panic("sched interruptible");
    8000205c:	00005517          	auipc	a0,0x5
    80002060:	24c50513          	addi	a0,a0,588 # 800072a8 <etext+0x2a8>
    80002064:	f30fe0ef          	jal	80000794 <panic>

0000000080002068 <yield>:
{
    80002068:	1101                	addi	sp,sp,-32
    8000206a:	ec06                	sd	ra,24(sp)
    8000206c:	e822                	sd	s0,16(sp)
    8000206e:	e426                	sd	s1,8(sp)
    80002070:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80002072:	a55ff0ef          	jal	80001ac6 <myproc>
    80002076:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002078:	cc3fe0ef          	jal	80000d3a <acquire>
  p->state = RUNNABLE;
    8000207c:	478d                	li	a5,3
    8000207e:	cc9c                	sw	a5,24(s1)
  sched();
    80002080:	f2fff0ef          	jal	80001fae <sched>
  release(&p->lock);
    80002084:	8526                	mv	a0,s1
    80002086:	d4dfe0ef          	jal	80000dd2 <release>
}
    8000208a:	60e2                	ld	ra,24(sp)
    8000208c:	6442                	ld	s0,16(sp)
    8000208e:	64a2                	ld	s1,8(sp)
    80002090:	6105                	addi	sp,sp,32
    80002092:	8082                	ret

0000000080002094 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002094:	7179                	addi	sp,sp,-48
    80002096:	f406                	sd	ra,40(sp)
    80002098:	f022                	sd	s0,32(sp)
    8000209a:	ec26                	sd	s1,24(sp)
    8000209c:	e84a                	sd	s2,16(sp)
    8000209e:	e44e                	sd	s3,8(sp)
    800020a0:	1800                	addi	s0,sp,48
    800020a2:	89aa                	mv	s3,a0
    800020a4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800020a6:	a21ff0ef          	jal	80001ac6 <myproc>
    800020aa:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800020ac:	c8ffe0ef          	jal	80000d3a <acquire>
  release(lk);
    800020b0:	854a                	mv	a0,s2
    800020b2:	d21fe0ef          	jal	80000dd2 <release>

  // Go to sleep.
  p->chan = chan;
    800020b6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800020ba:	4789                	li	a5,2
    800020bc:	cc9c                	sw	a5,24(s1)

  sched();
    800020be:	ef1ff0ef          	jal	80001fae <sched>

  // Tidy up.
  p->chan = 0;
    800020c2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800020c6:	8526                	mv	a0,s1
    800020c8:	d0bfe0ef          	jal	80000dd2 <release>
  acquire(lk);
    800020cc:	854a                	mv	a0,s2
    800020ce:	c6dfe0ef          	jal	80000d3a <acquire>
}
    800020d2:	70a2                	ld	ra,40(sp)
    800020d4:	7402                	ld	s0,32(sp)
    800020d6:	64e2                	ld	s1,24(sp)
    800020d8:	6942                	ld	s2,16(sp)
    800020da:	69a2                	ld	s3,8(sp)
    800020dc:	6145                	addi	sp,sp,48
    800020de:	8082                	ret

00000000800020e0 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800020e0:	7139                	addi	sp,sp,-64
    800020e2:	fc06                	sd	ra,56(sp)
    800020e4:	f822                	sd	s0,48(sp)
    800020e6:	f426                	sd	s1,40(sp)
    800020e8:	f04a                	sd	s2,32(sp)
    800020ea:	ec4e                	sd	s3,24(sp)
    800020ec:	e852                	sd	s4,16(sp)
    800020ee:	e456                	sd	s5,8(sp)
    800020f0:	0080                	addi	s0,sp,64
    800020f2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800020f4:	00451497          	auipc	s1,0x451
    800020f8:	8d448493          	addi	s1,s1,-1836 # 804529c8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800020fc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800020fe:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002100:	00456917          	auipc	s2,0x456
    80002104:	2c890913          	addi	s2,s2,712 # 804583c8 <tickslock>
    80002108:	a801                	j	80002118 <wakeup+0x38>
      }
      release(&p->lock);
    8000210a:	8526                	mv	a0,s1
    8000210c:	cc7fe0ef          	jal	80000dd2 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002110:	16848493          	addi	s1,s1,360
    80002114:	03248263          	beq	s1,s2,80002138 <wakeup+0x58>
    if(p != myproc()){
    80002118:	9afff0ef          	jal	80001ac6 <myproc>
    8000211c:	fea48ae3          	beq	s1,a0,80002110 <wakeup+0x30>
      acquire(&p->lock);
    80002120:	8526                	mv	a0,s1
    80002122:	c19fe0ef          	jal	80000d3a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80002126:	4c9c                	lw	a5,24(s1)
    80002128:	ff3791e3          	bne	a5,s3,8000210a <wakeup+0x2a>
    8000212c:	709c                	ld	a5,32(s1)
    8000212e:	fd479ee3          	bne	a5,s4,8000210a <wakeup+0x2a>
        p->state = RUNNABLE;
    80002132:	0154ac23          	sw	s5,24(s1)
    80002136:	bfd1                	j	8000210a <wakeup+0x2a>
    }
  }
}
    80002138:	70e2                	ld	ra,56(sp)
    8000213a:	7442                	ld	s0,48(sp)
    8000213c:	74a2                	ld	s1,40(sp)
    8000213e:	7902                	ld	s2,32(sp)
    80002140:	69e2                	ld	s3,24(sp)
    80002142:	6a42                	ld	s4,16(sp)
    80002144:	6aa2                	ld	s5,8(sp)
    80002146:	6121                	addi	sp,sp,64
    80002148:	8082                	ret

000000008000214a <reparent>:
{
    8000214a:	7179                	addi	sp,sp,-48
    8000214c:	f406                	sd	ra,40(sp)
    8000214e:	f022                	sd	s0,32(sp)
    80002150:	ec26                	sd	s1,24(sp)
    80002152:	e84a                	sd	s2,16(sp)
    80002154:	e44e                	sd	s3,8(sp)
    80002156:	e052                	sd	s4,0(sp)
    80002158:	1800                	addi	s0,sp,48
    8000215a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000215c:	00451497          	auipc	s1,0x451
    80002160:	86c48493          	addi	s1,s1,-1940 # 804529c8 <proc>
      pp->parent = initproc;
    80002164:	00008a17          	auipc	s4,0x8
    80002168:	2e4a0a13          	addi	s4,s4,740 # 8000a448 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000216c:	00456997          	auipc	s3,0x456
    80002170:	25c98993          	addi	s3,s3,604 # 804583c8 <tickslock>
    80002174:	a029                	j	8000217e <reparent+0x34>
    80002176:	16848493          	addi	s1,s1,360
    8000217a:	01348b63          	beq	s1,s3,80002190 <reparent+0x46>
    if(pp->parent == p){
    8000217e:	7c9c                	ld	a5,56(s1)
    80002180:	ff279be3          	bne	a5,s2,80002176 <reparent+0x2c>
      pp->parent = initproc;
    80002184:	000a3503          	ld	a0,0(s4)
    80002188:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000218a:	f57ff0ef          	jal	800020e0 <wakeup>
    8000218e:	b7e5                	j	80002176 <reparent+0x2c>
}
    80002190:	70a2                	ld	ra,40(sp)
    80002192:	7402                	ld	s0,32(sp)
    80002194:	64e2                	ld	s1,24(sp)
    80002196:	6942                	ld	s2,16(sp)
    80002198:	69a2                	ld	s3,8(sp)
    8000219a:	6a02                	ld	s4,0(sp)
    8000219c:	6145                	addi	sp,sp,48
    8000219e:	8082                	ret

00000000800021a0 <exit>:
{
    800021a0:	7179                	addi	sp,sp,-48
    800021a2:	f406                	sd	ra,40(sp)
    800021a4:	f022                	sd	s0,32(sp)
    800021a6:	ec26                	sd	s1,24(sp)
    800021a8:	e84a                	sd	s2,16(sp)
    800021aa:	e44e                	sd	s3,8(sp)
    800021ac:	e052                	sd	s4,0(sp)
    800021ae:	1800                	addi	s0,sp,48
    800021b0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800021b2:	915ff0ef          	jal	80001ac6 <myproc>
    800021b6:	89aa                	mv	s3,a0
  if(p == initproc)
    800021b8:	00008797          	auipc	a5,0x8
    800021bc:	2907b783          	ld	a5,656(a5) # 8000a448 <initproc>
    800021c0:	0d050493          	addi	s1,a0,208
    800021c4:	15050913          	addi	s2,a0,336
    800021c8:	00a79f63          	bne	a5,a0,800021e6 <exit+0x46>
    panic("init exiting");
    800021cc:	00005517          	auipc	a0,0x5
    800021d0:	0f450513          	addi	a0,a0,244 # 800072c0 <etext+0x2c0>
    800021d4:	dc0fe0ef          	jal	80000794 <panic>
      fileclose(f);
    800021d8:	07e020ef          	jal	80004256 <fileclose>
      p->ofile[fd] = 0;
    800021dc:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800021e0:	04a1                	addi	s1,s1,8
    800021e2:	01248563          	beq	s1,s2,800021ec <exit+0x4c>
    if(p->ofile[fd]){
    800021e6:	6088                	ld	a0,0(s1)
    800021e8:	f965                	bnez	a0,800021d8 <exit+0x38>
    800021ea:	bfdd                	j	800021e0 <exit+0x40>
  begin_op();
    800021ec:	451010ef          	jal	80003e3c <begin_op>
  iput(p->cwd);
    800021f0:	1509b503          	ld	a0,336(s3)
    800021f4:	532010ef          	jal	80003726 <iput>
  end_op();
    800021f8:	4af010ef          	jal	80003ea6 <end_op>
  p->cwd = 0;
    800021fc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002200:	00450497          	auipc	s1,0x450
    80002204:	3b048493          	addi	s1,s1,944 # 804525b0 <wait_lock>
    80002208:	8526                	mv	a0,s1
    8000220a:	b31fe0ef          	jal	80000d3a <acquire>
  reparent(p);
    8000220e:	854e                	mv	a0,s3
    80002210:	f3bff0ef          	jal	8000214a <reparent>
  wakeup(p->parent);
    80002214:	0389b503          	ld	a0,56(s3)
    80002218:	ec9ff0ef          	jal	800020e0 <wakeup>
  acquire(&p->lock);
    8000221c:	854e                	mv	a0,s3
    8000221e:	b1dfe0ef          	jal	80000d3a <acquire>
  p->xstate = status;
    80002222:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002226:	4795                	li	a5,5
    80002228:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000222c:	8526                	mv	a0,s1
    8000222e:	ba5fe0ef          	jal	80000dd2 <release>
  sched();
    80002232:	d7dff0ef          	jal	80001fae <sched>
  panic("zombie exit");
    80002236:	00005517          	auipc	a0,0x5
    8000223a:	09a50513          	addi	a0,a0,154 # 800072d0 <etext+0x2d0>
    8000223e:	d56fe0ef          	jal	80000794 <panic>

0000000080002242 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    80002242:	7179                	addi	sp,sp,-48
    80002244:	f406                	sd	ra,40(sp)
    80002246:	f022                	sd	s0,32(sp)
    80002248:	ec26                	sd	s1,24(sp)
    8000224a:	e84a                	sd	s2,16(sp)
    8000224c:	e44e                	sd	s3,8(sp)
    8000224e:	1800                	addi	s0,sp,48
    80002250:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80002252:	00450497          	auipc	s1,0x450
    80002256:	77648493          	addi	s1,s1,1910 # 804529c8 <proc>
    8000225a:	00456997          	auipc	s3,0x456
    8000225e:	16e98993          	addi	s3,s3,366 # 804583c8 <tickslock>
    acquire(&p->lock);
    80002262:	8526                	mv	a0,s1
    80002264:	ad7fe0ef          	jal	80000d3a <acquire>
    if(p->pid == pid){
    80002268:	589c                	lw	a5,48(s1)
    8000226a:	01278b63          	beq	a5,s2,80002280 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000226e:	8526                	mv	a0,s1
    80002270:	b63fe0ef          	jal	80000dd2 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80002274:	16848493          	addi	s1,s1,360
    80002278:	ff3495e3          	bne	s1,s3,80002262 <kill+0x20>
  }
  return -1;
    8000227c:	557d                	li	a0,-1
    8000227e:	a819                	j	80002294 <kill+0x52>
      p->killed = 1;
    80002280:	4785                	li	a5,1
    80002282:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002284:	4c98                	lw	a4,24(s1)
    80002286:	4789                	li	a5,2
    80002288:	00f70d63          	beq	a4,a5,800022a2 <kill+0x60>
      release(&p->lock);
    8000228c:	8526                	mv	a0,s1
    8000228e:	b45fe0ef          	jal	80000dd2 <release>
      return 0;
    80002292:	4501                	li	a0,0
}
    80002294:	70a2                	ld	ra,40(sp)
    80002296:	7402                	ld	s0,32(sp)
    80002298:	64e2                	ld	s1,24(sp)
    8000229a:	6942                	ld	s2,16(sp)
    8000229c:	69a2                	ld	s3,8(sp)
    8000229e:	6145                	addi	sp,sp,48
    800022a0:	8082                	ret
        p->state = RUNNABLE;
    800022a2:	478d                	li	a5,3
    800022a4:	cc9c                	sw	a5,24(s1)
    800022a6:	b7dd                	j	8000228c <kill+0x4a>

00000000800022a8 <setkilled>:

void
setkilled(struct proc *p)
{
    800022a8:	1101                	addi	sp,sp,-32
    800022aa:	ec06                	sd	ra,24(sp)
    800022ac:	e822                	sd	s0,16(sp)
    800022ae:	e426                	sd	s1,8(sp)
    800022b0:	1000                	addi	s0,sp,32
    800022b2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800022b4:	a87fe0ef          	jal	80000d3a <acquire>
  p->killed = 1;
    800022b8:	4785                	li	a5,1
    800022ba:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800022bc:	8526                	mv	a0,s1
    800022be:	b15fe0ef          	jal	80000dd2 <release>
}
    800022c2:	60e2                	ld	ra,24(sp)
    800022c4:	6442                	ld	s0,16(sp)
    800022c6:	64a2                	ld	s1,8(sp)
    800022c8:	6105                	addi	sp,sp,32
    800022ca:	8082                	ret

00000000800022cc <killed>:

int
killed(struct proc *p)
{
    800022cc:	1101                	addi	sp,sp,-32
    800022ce:	ec06                	sd	ra,24(sp)
    800022d0:	e822                	sd	s0,16(sp)
    800022d2:	e426                	sd	s1,8(sp)
    800022d4:	e04a                	sd	s2,0(sp)
    800022d6:	1000                	addi	s0,sp,32
    800022d8:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800022da:	a61fe0ef          	jal	80000d3a <acquire>
  k = p->killed;
    800022de:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800022e2:	8526                	mv	a0,s1
    800022e4:	aeffe0ef          	jal	80000dd2 <release>
  return k;
}
    800022e8:	854a                	mv	a0,s2
    800022ea:	60e2                	ld	ra,24(sp)
    800022ec:	6442                	ld	s0,16(sp)
    800022ee:	64a2                	ld	s1,8(sp)
    800022f0:	6902                	ld	s2,0(sp)
    800022f2:	6105                	addi	sp,sp,32
    800022f4:	8082                	ret

00000000800022f6 <wait>:
{
    800022f6:	715d                	addi	sp,sp,-80
    800022f8:	e486                	sd	ra,72(sp)
    800022fa:	e0a2                	sd	s0,64(sp)
    800022fc:	fc26                	sd	s1,56(sp)
    800022fe:	f84a                	sd	s2,48(sp)
    80002300:	f44e                	sd	s3,40(sp)
    80002302:	f052                	sd	s4,32(sp)
    80002304:	ec56                	sd	s5,24(sp)
    80002306:	e85a                	sd	s6,16(sp)
    80002308:	e45e                	sd	s7,8(sp)
    8000230a:	e062                	sd	s8,0(sp)
    8000230c:	0880                	addi	s0,sp,80
    8000230e:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002310:	fb6ff0ef          	jal	80001ac6 <myproc>
    80002314:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002316:	00450517          	auipc	a0,0x450
    8000231a:	29a50513          	addi	a0,a0,666 # 804525b0 <wait_lock>
    8000231e:	a1dfe0ef          	jal	80000d3a <acquire>
    havekids = 0;
    80002322:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    80002324:	4a15                	li	s4,5
        havekids = 1;
    80002326:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002328:	00456997          	auipc	s3,0x456
    8000232c:	0a098993          	addi	s3,s3,160 # 804583c8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002330:	00450c17          	auipc	s8,0x450
    80002334:	280c0c13          	addi	s8,s8,640 # 804525b0 <wait_lock>
    80002338:	a871                	j	800023d4 <wait+0xde>
          pid = pp->pid;
    8000233a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000233e:	000b0c63          	beqz	s6,80002356 <wait+0x60>
    80002342:	4691                	li	a3,4
    80002344:	02c48613          	addi	a2,s1,44
    80002348:	85da                	mv	a1,s6
    8000234a:	05093503          	ld	a0,80(s2)
    8000234e:	b48ff0ef          	jal	80001696 <copyout>
    80002352:	02054b63          	bltz	a0,80002388 <wait+0x92>
          freeproc(pp);
    80002356:	8526                	mv	a0,s1
    80002358:	8e1ff0ef          	jal	80001c38 <freeproc>
          release(&pp->lock);
    8000235c:	8526                	mv	a0,s1
    8000235e:	a75fe0ef          	jal	80000dd2 <release>
          release(&wait_lock);
    80002362:	00450517          	auipc	a0,0x450
    80002366:	24e50513          	addi	a0,a0,590 # 804525b0 <wait_lock>
    8000236a:	a69fe0ef          	jal	80000dd2 <release>
}
    8000236e:	854e                	mv	a0,s3
    80002370:	60a6                	ld	ra,72(sp)
    80002372:	6406                	ld	s0,64(sp)
    80002374:	74e2                	ld	s1,56(sp)
    80002376:	7942                	ld	s2,48(sp)
    80002378:	79a2                	ld	s3,40(sp)
    8000237a:	7a02                	ld	s4,32(sp)
    8000237c:	6ae2                	ld	s5,24(sp)
    8000237e:	6b42                	ld	s6,16(sp)
    80002380:	6ba2                	ld	s7,8(sp)
    80002382:	6c02                	ld	s8,0(sp)
    80002384:	6161                	addi	sp,sp,80
    80002386:	8082                	ret
            release(&pp->lock);
    80002388:	8526                	mv	a0,s1
    8000238a:	a49fe0ef          	jal	80000dd2 <release>
            release(&wait_lock);
    8000238e:	00450517          	auipc	a0,0x450
    80002392:	22250513          	addi	a0,a0,546 # 804525b0 <wait_lock>
    80002396:	a3dfe0ef          	jal	80000dd2 <release>
            return -1;
    8000239a:	59fd                	li	s3,-1
    8000239c:	bfc9                	j	8000236e <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000239e:	16848493          	addi	s1,s1,360
    800023a2:	03348063          	beq	s1,s3,800023c2 <wait+0xcc>
      if(pp->parent == p){
    800023a6:	7c9c                	ld	a5,56(s1)
    800023a8:	ff279be3          	bne	a5,s2,8000239e <wait+0xa8>
        acquire(&pp->lock);
    800023ac:	8526                	mv	a0,s1
    800023ae:	98dfe0ef          	jal	80000d3a <acquire>
        if(pp->state == ZOMBIE){
    800023b2:	4c9c                	lw	a5,24(s1)
    800023b4:	f94783e3          	beq	a5,s4,8000233a <wait+0x44>
        release(&pp->lock);
    800023b8:	8526                	mv	a0,s1
    800023ba:	a19fe0ef          	jal	80000dd2 <release>
        havekids = 1;
    800023be:	8756                	mv	a4,s5
    800023c0:	bff9                	j	8000239e <wait+0xa8>
    if(!havekids || killed(p)){
    800023c2:	cf19                	beqz	a4,800023e0 <wait+0xea>
    800023c4:	854a                	mv	a0,s2
    800023c6:	f07ff0ef          	jal	800022cc <killed>
    800023ca:	e919                	bnez	a0,800023e0 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800023cc:	85e2                	mv	a1,s8
    800023ce:	854a                	mv	a0,s2
    800023d0:	cc5ff0ef          	jal	80002094 <sleep>
    havekids = 0;
    800023d4:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800023d6:	00450497          	auipc	s1,0x450
    800023da:	5f248493          	addi	s1,s1,1522 # 804529c8 <proc>
    800023de:	b7e1                	j	800023a6 <wait+0xb0>
      release(&wait_lock);
    800023e0:	00450517          	auipc	a0,0x450
    800023e4:	1d050513          	addi	a0,a0,464 # 804525b0 <wait_lock>
    800023e8:	9ebfe0ef          	jal	80000dd2 <release>
      return -1;
    800023ec:	59fd                	li	s3,-1
    800023ee:	b741                	j	8000236e <wait+0x78>

00000000800023f0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800023f0:	7179                	addi	sp,sp,-48
    800023f2:	f406                	sd	ra,40(sp)
    800023f4:	f022                	sd	s0,32(sp)
    800023f6:	ec26                	sd	s1,24(sp)
    800023f8:	e84a                	sd	s2,16(sp)
    800023fa:	e44e                	sd	s3,8(sp)
    800023fc:	e052                	sd	s4,0(sp)
    800023fe:	1800                	addi	s0,sp,48
    80002400:	84aa                	mv	s1,a0
    80002402:	892e                	mv	s2,a1
    80002404:	89b2                	mv	s3,a2
    80002406:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002408:	ebeff0ef          	jal	80001ac6 <myproc>
  if(user_dst){
    8000240c:	cc99                	beqz	s1,8000242a <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000240e:	86d2                	mv	a3,s4
    80002410:	864e                	mv	a2,s3
    80002412:	85ca                	mv	a1,s2
    80002414:	6928                	ld	a0,80(a0)
    80002416:	a80ff0ef          	jal	80001696 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000241a:	70a2                	ld	ra,40(sp)
    8000241c:	7402                	ld	s0,32(sp)
    8000241e:	64e2                	ld	s1,24(sp)
    80002420:	6942                	ld	s2,16(sp)
    80002422:	69a2                	ld	s3,8(sp)
    80002424:	6a02                	ld	s4,0(sp)
    80002426:	6145                	addi	sp,sp,48
    80002428:	8082                	ret
    memmove((char *)dst, src, len);
    8000242a:	000a061b          	sext.w	a2,s4
    8000242e:	85ce                	mv	a1,s3
    80002430:	854a                	mv	a0,s2
    80002432:	a39fe0ef          	jal	80000e6a <memmove>
    return 0;
    80002436:	8526                	mv	a0,s1
    80002438:	b7cd                	j	8000241a <either_copyout+0x2a>

000000008000243a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000243a:	7179                	addi	sp,sp,-48
    8000243c:	f406                	sd	ra,40(sp)
    8000243e:	f022                	sd	s0,32(sp)
    80002440:	ec26                	sd	s1,24(sp)
    80002442:	e84a                	sd	s2,16(sp)
    80002444:	e44e                	sd	s3,8(sp)
    80002446:	e052                	sd	s4,0(sp)
    80002448:	1800                	addi	s0,sp,48
    8000244a:	892a                	mv	s2,a0
    8000244c:	84ae                	mv	s1,a1
    8000244e:	89b2                	mv	s3,a2
    80002450:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002452:	e74ff0ef          	jal	80001ac6 <myproc>
  if(user_src){
    80002456:	cc99                	beqz	s1,80002474 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002458:	86d2                	mv	a3,s4
    8000245a:	864e                	mv	a2,s3
    8000245c:	85ca                	mv	a1,s2
    8000245e:	6928                	ld	a0,80(a0)
    80002460:	baeff0ef          	jal	8000180e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80002464:	70a2                	ld	ra,40(sp)
    80002466:	7402                	ld	s0,32(sp)
    80002468:	64e2                	ld	s1,24(sp)
    8000246a:	6942                	ld	s2,16(sp)
    8000246c:	69a2                	ld	s3,8(sp)
    8000246e:	6a02                	ld	s4,0(sp)
    80002470:	6145                	addi	sp,sp,48
    80002472:	8082                	ret
    memmove(dst, (char*)src, len);
    80002474:	000a061b          	sext.w	a2,s4
    80002478:	85ce                	mv	a1,s3
    8000247a:	854a                	mv	a0,s2
    8000247c:	9effe0ef          	jal	80000e6a <memmove>
    return 0;
    80002480:	8526                	mv	a0,s1
    80002482:	b7cd                	j	80002464 <either_copyin+0x2a>

0000000080002484 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002484:	715d                	addi	sp,sp,-80
    80002486:	e486                	sd	ra,72(sp)
    80002488:	e0a2                	sd	s0,64(sp)
    8000248a:	fc26                	sd	s1,56(sp)
    8000248c:	f84a                	sd	s2,48(sp)
    8000248e:	f44e                	sd	s3,40(sp)
    80002490:	f052                	sd	s4,32(sp)
    80002492:	ec56                	sd	s5,24(sp)
    80002494:	e85a                	sd	s6,16(sp)
    80002496:	e45e                	sd	s7,8(sp)
    80002498:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000249a:	00005517          	auipc	a0,0x5
    8000249e:	be650513          	addi	a0,a0,-1050 # 80007080 <etext+0x80>
    800024a2:	820fe0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800024a6:	00450497          	auipc	s1,0x450
    800024aa:	67a48493          	addi	s1,s1,1658 # 80452b20 <proc+0x158>
    800024ae:	00456917          	auipc	s2,0x456
    800024b2:	07290913          	addi	s2,s2,114 # 80458520 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024b6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800024b8:	00005997          	auipc	s3,0x5
    800024bc:	e2898993          	addi	s3,s3,-472 # 800072e0 <etext+0x2e0>
    printf("%d %s %s", p->pid, state, p->name);
    800024c0:	00005a97          	auipc	s5,0x5
    800024c4:	e28a8a93          	addi	s5,s5,-472 # 800072e8 <etext+0x2e8>
    printf("\n");
    800024c8:	00005a17          	auipc	s4,0x5
    800024cc:	bb8a0a13          	addi	s4,s4,-1096 # 80007080 <etext+0x80>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024d0:	00005b97          	auipc	s7,0x5
    800024d4:	338b8b93          	addi	s7,s7,824 # 80007808 <states.0>
    800024d8:	a829                	j	800024f2 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800024da:	ed86a583          	lw	a1,-296(a3)
    800024de:	8556                	mv	a0,s5
    800024e0:	fe3fd0ef          	jal	800004c2 <printf>
    printf("\n");
    800024e4:	8552                	mv	a0,s4
    800024e6:	fddfd0ef          	jal	800004c2 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800024ea:	16848493          	addi	s1,s1,360
    800024ee:	03248263          	beq	s1,s2,80002512 <procdump+0x8e>
    if(p->state == UNUSED)
    800024f2:	86a6                	mv	a3,s1
    800024f4:	ec04a783          	lw	a5,-320(s1)
    800024f8:	dbed                	beqz	a5,800024ea <procdump+0x66>
      state = "???";
    800024fa:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800024fc:	fcfb6fe3          	bltu	s6,a5,800024da <procdump+0x56>
    80002500:	02079713          	slli	a4,a5,0x20
    80002504:	01d75793          	srli	a5,a4,0x1d
    80002508:	97de                	add	a5,a5,s7
    8000250a:	6390                	ld	a2,0(a5)
    8000250c:	f679                	bnez	a2,800024da <procdump+0x56>
      state = "???";
    8000250e:	864e                	mv	a2,s3
    80002510:	b7e9                	j	800024da <procdump+0x56>
  }
}
    80002512:	60a6                	ld	ra,72(sp)
    80002514:	6406                	ld	s0,64(sp)
    80002516:	74e2                	ld	s1,56(sp)
    80002518:	7942                	ld	s2,48(sp)
    8000251a:	79a2                	ld	s3,40(sp)
    8000251c:	7a02                	ld	s4,32(sp)
    8000251e:	6ae2                	ld	s5,24(sp)
    80002520:	6b42                	ld	s6,16(sp)
    80002522:	6ba2                	ld	s7,8(sp)
    80002524:	6161                	addi	sp,sp,80
    80002526:	8082                	ret

0000000080002528 <swtch>:
    80002528:	00153023          	sd	ra,0(a0)
    8000252c:	00253423          	sd	sp,8(a0)
    80002530:	e900                	sd	s0,16(a0)
    80002532:	ed04                	sd	s1,24(a0)
    80002534:	03253023          	sd	s2,32(a0)
    80002538:	03353423          	sd	s3,40(a0)
    8000253c:	03453823          	sd	s4,48(a0)
    80002540:	03553c23          	sd	s5,56(a0)
    80002544:	05653023          	sd	s6,64(a0)
    80002548:	05753423          	sd	s7,72(a0)
    8000254c:	05853823          	sd	s8,80(a0)
    80002550:	05953c23          	sd	s9,88(a0)
    80002554:	07a53023          	sd	s10,96(a0)
    80002558:	07b53423          	sd	s11,104(a0)
    8000255c:	0005b083          	ld	ra,0(a1)
    80002560:	0085b103          	ld	sp,8(a1)
    80002564:	6980                	ld	s0,16(a1)
    80002566:	6d84                	ld	s1,24(a1)
    80002568:	0205b903          	ld	s2,32(a1)
    8000256c:	0285b983          	ld	s3,40(a1)
    80002570:	0305ba03          	ld	s4,48(a1)
    80002574:	0385ba83          	ld	s5,56(a1)
    80002578:	0405bb03          	ld	s6,64(a1)
    8000257c:	0485bb83          	ld	s7,72(a1)
    80002580:	0505bc03          	ld	s8,80(a1)
    80002584:	0585bc83          	ld	s9,88(a1)
    80002588:	0605bd03          	ld	s10,96(a1)
    8000258c:	0685bd83          	ld	s11,104(a1)
    80002590:	8082                	ret

0000000080002592 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002592:	1141                	addi	sp,sp,-16
    80002594:	e406                	sd	ra,8(sp)
    80002596:	e022                	sd	s0,0(sp)
    80002598:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000259a:	00005597          	auipc	a1,0x5
    8000259e:	d8e58593          	addi	a1,a1,-626 # 80007328 <etext+0x328>
    800025a2:	00456517          	auipc	a0,0x456
    800025a6:	e2650513          	addi	a0,a0,-474 # 804583c8 <tickslock>
    800025aa:	f10fe0ef          	jal	80000cba <initlock>
}
    800025ae:	60a2                	ld	ra,8(sp)
    800025b0:	6402                	ld	s0,0(sp)
    800025b2:	0141                	addi	sp,sp,16
    800025b4:	8082                	ret

00000000800025b6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800025b6:	1141                	addi	sp,sp,-16
    800025b8:	e422                	sd	s0,8(sp)
    800025ba:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800025bc:	00003797          	auipc	a5,0x3
    800025c0:	17478793          	addi	a5,a5,372 # 80005730 <kernelvec>
    800025c4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800025c8:	6422                	ld	s0,8(sp)
    800025ca:	0141                	addi	sp,sp,16
    800025cc:	8082                	ret

00000000800025ce <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    800025ce:	1141                	addi	sp,sp,-16
    800025d0:	e406                	sd	ra,8(sp)
    800025d2:	e022                	sd	s0,0(sp)
    800025d4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800025d6:	cf0ff0ef          	jal	80001ac6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800025da:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800025de:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800025e0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800025e4:	00004697          	auipc	a3,0x4
    800025e8:	a1c68693          	addi	a3,a3,-1508 # 80006000 <_trampoline>
    800025ec:	00004717          	auipc	a4,0x4
    800025f0:	a1470713          	addi	a4,a4,-1516 # 80006000 <_trampoline>
    800025f4:	8f15                	sub	a4,a4,a3
    800025f6:	040007b7          	lui	a5,0x4000
    800025fa:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    800025fc:	07b2                	slli	a5,a5,0xc
    800025fe:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002600:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002604:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002606:	18002673          	csrr	a2,satp
    8000260a:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000260c:	6d30                	ld	a2,88(a0)
    8000260e:	6138                	ld	a4,64(a0)
    80002610:	6585                	lui	a1,0x1
    80002612:	972e                	add	a4,a4,a1
    80002614:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002616:	6d38                	ld	a4,88(a0)
    80002618:	00000617          	auipc	a2,0x0
    8000261c:	11060613          	addi	a2,a2,272 # 80002728 <usertrap>
    80002620:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002622:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002624:	8612                	mv	a2,tp
    80002626:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002628:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000262c:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002630:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002634:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002638:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000263a:	6f18                	ld	a4,24(a4)
    8000263c:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002640:	6928                	ld	a0,80(a0)
    80002642:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002644:	00004717          	auipc	a4,0x4
    80002648:	a5870713          	addi	a4,a4,-1448 # 8000609c <userret>
    8000264c:	8f15                	sub	a4,a4,a3
    8000264e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002650:	577d                	li	a4,-1
    80002652:	177e                	slli	a4,a4,0x3f
    80002654:	8d59                	or	a0,a0,a4
    80002656:	9782                	jalr	a5
}
    80002658:	60a2                	ld	ra,8(sp)
    8000265a:	6402                	ld	s0,0(sp)
    8000265c:	0141                	addi	sp,sp,16
    8000265e:	8082                	ret

0000000080002660 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002660:	1101                	addi	sp,sp,-32
    80002662:	ec06                	sd	ra,24(sp)
    80002664:	e822                	sd	s0,16(sp)
    80002666:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002668:	c32ff0ef          	jal	80001a9a <cpuid>
    8000266c:	cd11                	beqz	a0,80002688 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000266e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002672:	000f4737          	lui	a4,0xf4
    80002676:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000267a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000267c:	14d79073          	csrw	stimecmp,a5
}
    80002680:	60e2                	ld	ra,24(sp)
    80002682:	6442                	ld	s0,16(sp)
    80002684:	6105                	addi	sp,sp,32
    80002686:	8082                	ret
    80002688:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    8000268a:	00456497          	auipc	s1,0x456
    8000268e:	d3e48493          	addi	s1,s1,-706 # 804583c8 <tickslock>
    80002692:	8526                	mv	a0,s1
    80002694:	ea6fe0ef          	jal	80000d3a <acquire>
    ticks++;
    80002698:	00008517          	auipc	a0,0x8
    8000269c:	db850513          	addi	a0,a0,-584 # 8000a450 <ticks>
    800026a0:	411c                	lw	a5,0(a0)
    800026a2:	2785                	addiw	a5,a5,1
    800026a4:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    800026a6:	a3bff0ef          	jal	800020e0 <wakeup>
    release(&tickslock);
    800026aa:	8526                	mv	a0,s1
    800026ac:	f26fe0ef          	jal	80000dd2 <release>
    800026b0:	64a2                	ld	s1,8(sp)
    800026b2:	bf75                	j	8000266e <clockintr+0xe>

00000000800026b4 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800026b4:	1101                	addi	sp,sp,-32
    800026b6:	ec06                	sd	ra,24(sp)
    800026b8:	e822                	sd	s0,16(sp)
    800026ba:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800026bc:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800026c0:	57fd                	li	a5,-1
    800026c2:	17fe                	slli	a5,a5,0x3f
    800026c4:	07a5                	addi	a5,a5,9
    800026c6:	00f70c63          	beq	a4,a5,800026de <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800026ca:	57fd                	li	a5,-1
    800026cc:	17fe                	slli	a5,a5,0x3f
    800026ce:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800026d0:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800026d2:	04f70763          	beq	a4,a5,80002720 <devintr+0x6c>
  }
}
    800026d6:	60e2                	ld	ra,24(sp)
    800026d8:	6442                	ld	s0,16(sp)
    800026da:	6105                	addi	sp,sp,32
    800026dc:	8082                	ret
    800026de:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800026e0:	0fc030ef          	jal	800057dc <plic_claim>
    800026e4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800026e6:	47a9                	li	a5,10
    800026e8:	00f50963          	beq	a0,a5,800026fa <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    800026ec:	4785                	li	a5,1
    800026ee:	00f50963          	beq	a0,a5,80002700 <devintr+0x4c>
    return 1;
    800026f2:	4505                	li	a0,1
    } else if(irq){
    800026f4:	e889                	bnez	s1,80002706 <devintr+0x52>
    800026f6:	64a2                	ld	s1,8(sp)
    800026f8:	bff9                	j	800026d6 <devintr+0x22>
      uartintr();
    800026fa:	b0cfe0ef          	jal	80000a06 <uartintr>
    if(irq)
    800026fe:	a819                	j	80002714 <devintr+0x60>
      virtio_disk_intr();
    80002700:	5a2030ef          	jal	80005ca2 <virtio_disk_intr>
    if(irq)
    80002704:	a801                	j	80002714 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002706:	85a6                	mv	a1,s1
    80002708:	00005517          	auipc	a0,0x5
    8000270c:	c2850513          	addi	a0,a0,-984 # 80007330 <etext+0x330>
    80002710:	db3fd0ef          	jal	800004c2 <printf>
      plic_complete(irq);
    80002714:	8526                	mv	a0,s1
    80002716:	0e6030ef          	jal	800057fc <plic_complete>
    return 1;
    8000271a:	4505                	li	a0,1
    8000271c:	64a2                	ld	s1,8(sp)
    8000271e:	bf65                	j	800026d6 <devintr+0x22>
    clockintr();
    80002720:	f41ff0ef          	jal	80002660 <clockintr>
    return 2;
    80002724:	4509                	li	a0,2
    80002726:	bf45                	j	800026d6 <devintr+0x22>

0000000080002728 <usertrap>:
{
    80002728:	7139                	addi	sp,sp,-64
    8000272a:	fc06                	sd	ra,56(sp)
    8000272c:	f822                	sd	s0,48(sp)
    8000272e:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002730:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002734:	1007f793          	andi	a5,a5,256
    80002738:	eba5                	bnez	a5,800027a8 <usertrap+0x80>
    8000273a:	f426                	sd	s1,40(sp)
    8000273c:	f04a                	sd	s2,32(sp)
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000273e:	00003797          	auipc	a5,0x3
    80002742:	ff278793          	addi	a5,a5,-14 # 80005730 <kernelvec>
    80002746:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000274a:	b7cff0ef          	jal	80001ac6 <myproc>
    8000274e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002750:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002752:	14102773          	csrr	a4,sepc
    80002756:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002758:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000275c:	47a1                	li	a5,8
    8000275e:	06f70063          	beq	a4,a5,800027be <usertrap+0x96>
  else if((which_dev = devintr()) != 0){
    80002762:	f53ff0ef          	jal	800026b4 <devintr>
    80002766:	892a                	mv	s2,a0
    80002768:	12051563          	bnez	a0,80002892 <usertrap+0x16a>
    8000276c:	14202773          	csrr	a4,scause
  else if (r_scause() == 15) {
    80002770:	47bd                	li	a5,15
    80002772:	06f71563          	bne	a4,a5,800027dc <usertrap+0xb4>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002776:	14302973          	csrr	s2,stval
    va = PGROUNDDOWN(r_stval());
    8000277a:	77fd                	lui	a5,0xfffff
    8000277c:	00f97933          	and	s2,s2,a5
    pte = walk(p->pagetable, va, 0);
    80002780:	4601                	li	a2,0
    80002782:	85ca                	mv	a1,s2
    80002784:	68a8                	ld	a0,80(s1)
    80002786:	8fdfe0ef          	jal	80001082 <walk>
    if (pte == 0 || (*pte & PTE_V) == 0) {
    8000278a:	c509                	beqz	a0,80002794 <usertrap+0x6c>
    8000278c:	611c                	ld	a5,0(a0)
    8000278e:	0017f713          	andi	a4,a5,1
    80002792:	e72d                	bnez	a4,800027fc <usertrap+0xd4>
      printf("Cannot find a pagetable\n");
    80002794:	00005517          	auipc	a0,0x5
    80002798:	bdc50513          	addi	a0,a0,-1060 # 80007370 <etext+0x370>
    8000279c:	d27fd0ef          	jal	800004c2 <printf>
      setkilled(p);
    800027a0:	8526                	mv	a0,s1
    800027a2:	b07ff0ef          	jal	800022a8 <setkilled>
    800027a6:	a81d                	j	800027dc <usertrap+0xb4>
    800027a8:	f426                	sd	s1,40(sp)
    800027aa:	f04a                	sd	s2,32(sp)
    800027ac:	ec4e                	sd	s3,24(sp)
    800027ae:	e852                	sd	s4,16(sp)
    800027b0:	e456                	sd	s5,8(sp)
    panic("usertrap: not from user mode");
    800027b2:	00005517          	auipc	a0,0x5
    800027b6:	b9e50513          	addi	a0,a0,-1122 # 80007350 <etext+0x350>
    800027ba:	fdbfd0ef          	jal	80000794 <panic>
    if(killed(p))
    800027be:	b0fff0ef          	jal	800022cc <killed>
    800027c2:	e90d                	bnez	a0,800027f4 <usertrap+0xcc>
    p->trapframe->epc += 4;
    800027c4:	6cb8                	ld	a4,88(s1)
    800027c6:	6f1c                	ld	a5,24(a4)
    800027c8:	0791                	addi	a5,a5,4 # fffffffffffff004 <end+0xffffffff7fb9b85c>
    800027ca:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800027cc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800027d0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800027d4:	10079073          	csrw	sstatus,a5
    syscall();
    800027d8:	2ba000ef          	jal	80002a92 <syscall>
  if(killed(p))
    800027dc:	8526                	mv	a0,s1
    800027de:	aefff0ef          	jal	800022cc <killed>
    800027e2:	ed4d                	bnez	a0,8000289c <usertrap+0x174>
  usertrapret();
    800027e4:	debff0ef          	jal	800025ce <usertrapret>
    800027e8:	74a2                	ld	s1,40(sp)
    800027ea:	7902                	ld	s2,32(sp)
}
    800027ec:	70e2                	ld	ra,56(sp)
    800027ee:	7442                	ld	s0,48(sp)
    800027f0:	6121                	addi	sp,sp,64
    800027f2:	8082                	ret
      exit(-1);
    800027f4:	557d                	li	a0,-1
    800027f6:	9abff0ef          	jal	800021a0 <exit>
    800027fa:	b7e9                	j	800027c4 <usertrap+0x9c>
    else if ((*pte & PTE_COW) && (*pte & PTE_W) == 0) {
    800027fc:	1047f713          	andi	a4,a5,260
    80002800:	10000693          	li	a3,256
    80002804:	00d70c63          	beq	a4,a3,8000281c <usertrap+0xf4>
      printf("Non-cow fork occurs cow page fault\n");
    80002808:	00005517          	auipc	a0,0x5
    8000280c:	ba850513          	addi	a0,a0,-1112 # 800073b0 <etext+0x3b0>
    80002810:	cb3fd0ef          	jal	800004c2 <printf>
      setkilled(p);
    80002814:	8526                	mv	a0,s1
    80002816:	a93ff0ef          	jal	800022a8 <setkilled>
    8000281a:	b7c9                	j	800027dc <usertrap+0xb4>
    8000281c:	ec4e                	sd	s3,24(sp)
    8000281e:	e852                	sd	s4,16(sp)
    80002820:	e456                	sd	s5,8(sp)
      pa = PTE2PA(*pte);
    80002822:	00a7da93          	srli	s5,a5,0xa
    80002826:	0ab2                	slli	s5,s5,0xc
      flags = flags & ~PTE_COW; // cow bit 제거
    80002828:	2ff7f793          	andi	a5,a5,767
    8000282c:	0047e993          	ori	s3,a5,4
      if((mem = kalloc()) == 0) {
    80002830:	c08fe0ef          	jal	80000c38 <kalloc>
    80002834:	8a2a                	mv	s4,a0
    80002836:	c91d                	beqz	a0,8000286c <usertrap+0x144>
      memmove(mem, (char*)pa, PGSIZE);
    80002838:	6605                	lui	a2,0x1
    8000283a:	85d6                	mv	a1,s5
    8000283c:	8552                	mv	a0,s4
    8000283e:	e2cfe0ef          	jal	80000e6a <memmove>
      uvmunmap(p->pagetable, va, 1, 0);
    80002842:	4681                	li	a3,0
    80002844:	4605                	li	a2,1
    80002846:	85ca                	mv	a1,s2
    80002848:	68a8                	ld	a0,80(s1)
    8000284a:	ab7fe0ef          	jal	80001300 <uvmunmap>
      kfree((void*)pa);
    8000284e:	8556                	mv	a0,s5
    80002850:	ab6fe0ef          	jal	80000b06 <kfree>
      if (mappages(p->pagetable, va, PGSIZE, (uint64)mem, flags) != 0) {
    80002854:	874e                	mv	a4,s3
    80002856:	86d2                	mv	a3,s4
    80002858:	6605                	lui	a2,0x1
    8000285a:	85ca                	mv	a1,s2
    8000285c:	68a8                	ld	a0,80(s1)
    8000285e:	8fdfe0ef          	jal	8000115a <mappages>
    80002862:	ed19                	bnez	a0,80002880 <usertrap+0x158>
    80002864:	69e2                	ld	s3,24(sp)
    80002866:	6a42                	ld	s4,16(sp)
    80002868:	6aa2                	ld	s5,8(sp)
    8000286a:	bf8d                	j	800027dc <usertrap+0xb4>
        printf("usertrap: kalloc is failed\n");
    8000286c:	00005517          	auipc	a0,0x5
    80002870:	b2450513          	addi	a0,a0,-1244 # 80007390 <etext+0x390>
    80002874:	c4ffd0ef          	jal	800004c2 <printf>
        setkilled(p);
    80002878:	8526                	mv	a0,s1
    8000287a:	a2fff0ef          	jal	800022a8 <setkilled>
    8000287e:	bf6d                	j	80002838 <usertrap+0x110>
        kfree(mem);
    80002880:	8552                	mv	a0,s4
    80002882:	a84fe0ef          	jal	80000b06 <kfree>
        panic("New page mapping failed\n");
    80002886:	00005517          	auipc	a0,0x5
    8000288a:	99250513          	addi	a0,a0,-1646 # 80007218 <etext+0x218>
    8000288e:	f07fd0ef          	jal	80000794 <panic>
  if(killed(p))
    80002892:	8526                	mv	a0,s1
    80002894:	a39ff0ef          	jal	800022cc <killed>
    80002898:	c511                	beqz	a0,800028a4 <usertrap+0x17c>
    8000289a:	a011                	j	8000289e <usertrap+0x176>
    8000289c:	4901                	li	s2,0
    exit(-1);
    8000289e:	557d                	li	a0,-1
    800028a0:	901ff0ef          	jal	800021a0 <exit>
  if(which_dev == 2)
    800028a4:	4789                	li	a5,2
    800028a6:	f2f91fe3          	bne	s2,a5,800027e4 <usertrap+0xbc>
    yield();
    800028aa:	fbeff0ef          	jal	80002068 <yield>
    800028ae:	bf1d                	j	800027e4 <usertrap+0xbc>

00000000800028b0 <kerneltrap>:
{
    800028b0:	7179                	addi	sp,sp,-48
    800028b2:	f406                	sd	ra,40(sp)
    800028b4:	f022                	sd	s0,32(sp)
    800028b6:	ec26                	sd	s1,24(sp)
    800028b8:	e84a                	sd	s2,16(sp)
    800028ba:	e44e                	sd	s3,8(sp)
    800028bc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800028be:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028c2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028c6:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    800028ca:	1004f793          	andi	a5,s1,256
    800028ce:	c795                	beqz	a5,800028fa <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800028d0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800028d4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    800028d6:	eb85                	bnez	a5,80002906 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    800028d8:	dddff0ef          	jal	800026b4 <devintr>
    800028dc:	c91d                	beqz	a0,80002912 <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    800028de:	4789                	li	a5,2
    800028e0:	04f50a63          	beq	a0,a5,80002934 <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    800028e4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800028e8:	10049073          	csrw	sstatus,s1
}
    800028ec:	70a2                	ld	ra,40(sp)
    800028ee:	7402                	ld	s0,32(sp)
    800028f0:	64e2                	ld	s1,24(sp)
    800028f2:	6942                	ld	s2,16(sp)
    800028f4:	69a2                	ld	s3,8(sp)
    800028f6:	6145                	addi	sp,sp,48
    800028f8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800028fa:	00005517          	auipc	a0,0x5
    800028fe:	ade50513          	addi	a0,a0,-1314 # 800073d8 <etext+0x3d8>
    80002902:	e93fd0ef          	jal	80000794 <panic>
    panic("kerneltrap: interrupts enabled");
    80002906:	00005517          	auipc	a0,0x5
    8000290a:	afa50513          	addi	a0,a0,-1286 # 80007400 <etext+0x400>
    8000290e:	e87fd0ef          	jal	80000794 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002912:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002916:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    8000291a:	85ce                	mv	a1,s3
    8000291c:	00005517          	auipc	a0,0x5
    80002920:	b0450513          	addi	a0,a0,-1276 # 80007420 <etext+0x420>
    80002924:	b9ffd0ef          	jal	800004c2 <printf>
    panic("kerneltrap");
    80002928:	00005517          	auipc	a0,0x5
    8000292c:	b2050513          	addi	a0,a0,-1248 # 80007448 <etext+0x448>
    80002930:	e65fd0ef          	jal	80000794 <panic>
  if(which_dev == 2 && myproc() != 0)
    80002934:	992ff0ef          	jal	80001ac6 <myproc>
    80002938:	d555                	beqz	a0,800028e4 <kerneltrap+0x34>
    yield();
    8000293a:	f2eff0ef          	jal	80002068 <yield>
    8000293e:	b75d                	j	800028e4 <kerneltrap+0x34>

0000000080002940 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002940:	1101                	addi	sp,sp,-32
    80002942:	ec06                	sd	ra,24(sp)
    80002944:	e822                	sd	s0,16(sp)
    80002946:	e426                	sd	s1,8(sp)
    80002948:	1000                	addi	s0,sp,32
    8000294a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000294c:	97aff0ef          	jal	80001ac6 <myproc>
  switch (n) {
    80002950:	4795                	li	a5,5
    80002952:	0497e163          	bltu	a5,s1,80002994 <argraw+0x54>
    80002956:	048a                	slli	s1,s1,0x2
    80002958:	00005717          	auipc	a4,0x5
    8000295c:	ee070713          	addi	a4,a4,-288 # 80007838 <states.0+0x30>
    80002960:	94ba                	add	s1,s1,a4
    80002962:	409c                	lw	a5,0(s1)
    80002964:	97ba                	add	a5,a5,a4
    80002966:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002968:	6d3c                	ld	a5,88(a0)
    8000296a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000296c:	60e2                	ld	ra,24(sp)
    8000296e:	6442                	ld	s0,16(sp)
    80002970:	64a2                	ld	s1,8(sp)
    80002972:	6105                	addi	sp,sp,32
    80002974:	8082                	ret
    return p->trapframe->a1;
    80002976:	6d3c                	ld	a5,88(a0)
    80002978:	7fa8                	ld	a0,120(a5)
    8000297a:	bfcd                	j	8000296c <argraw+0x2c>
    return p->trapframe->a2;
    8000297c:	6d3c                	ld	a5,88(a0)
    8000297e:	63c8                	ld	a0,128(a5)
    80002980:	b7f5                	j	8000296c <argraw+0x2c>
    return p->trapframe->a3;
    80002982:	6d3c                	ld	a5,88(a0)
    80002984:	67c8                	ld	a0,136(a5)
    80002986:	b7dd                	j	8000296c <argraw+0x2c>
    return p->trapframe->a4;
    80002988:	6d3c                	ld	a5,88(a0)
    8000298a:	6bc8                	ld	a0,144(a5)
    8000298c:	b7c5                	j	8000296c <argraw+0x2c>
    return p->trapframe->a5;
    8000298e:	6d3c                	ld	a5,88(a0)
    80002990:	6fc8                	ld	a0,152(a5)
    80002992:	bfe9                	j	8000296c <argraw+0x2c>
  panic("argraw");
    80002994:	00005517          	auipc	a0,0x5
    80002998:	ac450513          	addi	a0,a0,-1340 # 80007458 <etext+0x458>
    8000299c:	df9fd0ef          	jal	80000794 <panic>

00000000800029a0 <fetchaddr>:
{
    800029a0:	1101                	addi	sp,sp,-32
    800029a2:	ec06                	sd	ra,24(sp)
    800029a4:	e822                	sd	s0,16(sp)
    800029a6:	e426                	sd	s1,8(sp)
    800029a8:	e04a                	sd	s2,0(sp)
    800029aa:	1000                	addi	s0,sp,32
    800029ac:	84aa                	mv	s1,a0
    800029ae:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800029b0:	916ff0ef          	jal	80001ac6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800029b4:	653c                	ld	a5,72(a0)
    800029b6:	02f4f663          	bgeu	s1,a5,800029e2 <fetchaddr+0x42>
    800029ba:	00848713          	addi	a4,s1,8
    800029be:	02e7e463          	bltu	a5,a4,800029e6 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800029c2:	46a1                	li	a3,8
    800029c4:	8626                	mv	a2,s1
    800029c6:	85ca                	mv	a1,s2
    800029c8:	6928                	ld	a0,80(a0)
    800029ca:	e45fe0ef          	jal	8000180e <copyin>
    800029ce:	00a03533          	snez	a0,a0
    800029d2:	40a00533          	neg	a0,a0
}
    800029d6:	60e2                	ld	ra,24(sp)
    800029d8:	6442                	ld	s0,16(sp)
    800029da:	64a2                	ld	s1,8(sp)
    800029dc:	6902                	ld	s2,0(sp)
    800029de:	6105                	addi	sp,sp,32
    800029e0:	8082                	ret
    return -1;
    800029e2:	557d                	li	a0,-1
    800029e4:	bfcd                	j	800029d6 <fetchaddr+0x36>
    800029e6:	557d                	li	a0,-1
    800029e8:	b7fd                	j	800029d6 <fetchaddr+0x36>

00000000800029ea <fetchstr>:
{
    800029ea:	7179                	addi	sp,sp,-48
    800029ec:	f406                	sd	ra,40(sp)
    800029ee:	f022                	sd	s0,32(sp)
    800029f0:	ec26                	sd	s1,24(sp)
    800029f2:	e84a                	sd	s2,16(sp)
    800029f4:	e44e                	sd	s3,8(sp)
    800029f6:	1800                	addi	s0,sp,48
    800029f8:	892a                	mv	s2,a0
    800029fa:	84ae                	mv	s1,a1
    800029fc:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    800029fe:	8c8ff0ef          	jal	80001ac6 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002a02:	86ce                	mv	a3,s3
    80002a04:	864a                	mv	a2,s2
    80002a06:	85a6                	mv	a1,s1
    80002a08:	6928                	ld	a0,80(a0)
    80002a0a:	e8bfe0ef          	jal	80001894 <copyinstr>
    80002a0e:	00054c63          	bltz	a0,80002a26 <fetchstr+0x3c>
  return strlen(buf);
    80002a12:	8526                	mv	a0,s1
    80002a14:	d6afe0ef          	jal	80000f7e <strlen>
}
    80002a18:	70a2                	ld	ra,40(sp)
    80002a1a:	7402                	ld	s0,32(sp)
    80002a1c:	64e2                	ld	s1,24(sp)
    80002a1e:	6942                	ld	s2,16(sp)
    80002a20:	69a2                	ld	s3,8(sp)
    80002a22:	6145                	addi	sp,sp,48
    80002a24:	8082                	ret
    return -1;
    80002a26:	557d                	li	a0,-1
    80002a28:	bfc5                	j	80002a18 <fetchstr+0x2e>

0000000080002a2a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002a2a:	1101                	addi	sp,sp,-32
    80002a2c:	ec06                	sd	ra,24(sp)
    80002a2e:	e822                	sd	s0,16(sp)
    80002a30:	e426                	sd	s1,8(sp)
    80002a32:	1000                	addi	s0,sp,32
    80002a34:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a36:	f0bff0ef          	jal	80002940 <argraw>
    80002a3a:	c088                	sw	a0,0(s1)
}
    80002a3c:	60e2                	ld	ra,24(sp)
    80002a3e:	6442                	ld	s0,16(sp)
    80002a40:	64a2                	ld	s1,8(sp)
    80002a42:	6105                	addi	sp,sp,32
    80002a44:	8082                	ret

0000000080002a46 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002a46:	1101                	addi	sp,sp,-32
    80002a48:	ec06                	sd	ra,24(sp)
    80002a4a:	e822                	sd	s0,16(sp)
    80002a4c:	e426                	sd	s1,8(sp)
    80002a4e:	1000                	addi	s0,sp,32
    80002a50:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002a52:	eefff0ef          	jal	80002940 <argraw>
    80002a56:	e088                	sd	a0,0(s1)
}
    80002a58:	60e2                	ld	ra,24(sp)
    80002a5a:	6442                	ld	s0,16(sp)
    80002a5c:	64a2                	ld	s1,8(sp)
    80002a5e:	6105                	addi	sp,sp,32
    80002a60:	8082                	ret

0000000080002a62 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002a62:	7179                	addi	sp,sp,-48
    80002a64:	f406                	sd	ra,40(sp)
    80002a66:	f022                	sd	s0,32(sp)
    80002a68:	ec26                	sd	s1,24(sp)
    80002a6a:	e84a                	sd	s2,16(sp)
    80002a6c:	1800                	addi	s0,sp,48
    80002a6e:	84ae                	mv	s1,a1
    80002a70:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80002a72:	fd840593          	addi	a1,s0,-40
    80002a76:	fd1ff0ef          	jal	80002a46 <argaddr>
  return fetchstr(addr, buf, max);
    80002a7a:	864a                	mv	a2,s2
    80002a7c:	85a6                	mv	a1,s1
    80002a7e:	fd843503          	ld	a0,-40(s0)
    80002a82:	f69ff0ef          	jal	800029ea <fetchstr>
}
    80002a86:	70a2                	ld	ra,40(sp)
    80002a88:	7402                	ld	s0,32(sp)
    80002a8a:	64e2                	ld	s1,24(sp)
    80002a8c:	6942                	ld	s2,16(sp)
    80002a8e:	6145                	addi	sp,sp,48
    80002a90:	8082                	ret

0000000080002a92 <syscall>:
[SYS_symlink] sys_symlink,
};

void
syscall(void)
{
    80002a92:	1101                	addi	sp,sp,-32
    80002a94:	ec06                	sd	ra,24(sp)
    80002a96:	e822                	sd	s0,16(sp)
    80002a98:	e426                	sd	s1,8(sp)
    80002a9a:	e04a                	sd	s2,0(sp)
    80002a9c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002a9e:	828ff0ef          	jal	80001ac6 <myproc>
    80002aa2:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002aa4:	05853903          	ld	s2,88(a0)
    80002aa8:	0a893783          	ld	a5,168(s2)
    80002aac:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002ab0:	37fd                	addiw	a5,a5,-1
    80002ab2:	4755                	li	a4,21
    80002ab4:	00f76f63          	bltu	a4,a5,80002ad2 <syscall+0x40>
    80002ab8:	00369713          	slli	a4,a3,0x3
    80002abc:	00005797          	auipc	a5,0x5
    80002ac0:	d9478793          	addi	a5,a5,-620 # 80007850 <syscalls>
    80002ac4:	97ba                	add	a5,a5,a4
    80002ac6:	639c                	ld	a5,0(a5)
    80002ac8:	c789                	beqz	a5,80002ad2 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80002aca:	9782                	jalr	a5
    80002acc:	06a93823          	sd	a0,112(s2)
    80002ad0:	a829                	j	80002aea <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002ad2:	15848613          	addi	a2,s1,344
    80002ad6:	588c                	lw	a1,48(s1)
    80002ad8:	00005517          	auipc	a0,0x5
    80002adc:	98850513          	addi	a0,a0,-1656 # 80007460 <etext+0x460>
    80002ae0:	9e3fd0ef          	jal	800004c2 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002ae4:	6cbc                	ld	a5,88(s1)
    80002ae6:	577d                	li	a4,-1
    80002ae8:	fbb8                	sd	a4,112(a5)
  }
}
    80002aea:	60e2                	ld	ra,24(sp)
    80002aec:	6442                	ld	s0,16(sp)
    80002aee:	64a2                	ld	s1,8(sp)
    80002af0:	6902                	ld	s2,0(sp)
    80002af2:	6105                	addi	sp,sp,32
    80002af4:	8082                	ret

0000000080002af6 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002af6:	1101                	addi	sp,sp,-32
    80002af8:	ec06                	sd	ra,24(sp)
    80002afa:	e822                	sd	s0,16(sp)
    80002afc:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002afe:	fec40593          	addi	a1,s0,-20
    80002b02:	4501                	li	a0,0
    80002b04:	f27ff0ef          	jal	80002a2a <argint>
  exit(n);
    80002b08:	fec42503          	lw	a0,-20(s0)
    80002b0c:	e94ff0ef          	jal	800021a0 <exit>
  return 0;  // not reached
}
    80002b10:	4501                	li	a0,0
    80002b12:	60e2                	ld	ra,24(sp)
    80002b14:	6442                	ld	s0,16(sp)
    80002b16:	6105                	addi	sp,sp,32
    80002b18:	8082                	ret

0000000080002b1a <sys_getpid>:

uint64
sys_getpid(void)
{
    80002b1a:	1141                	addi	sp,sp,-16
    80002b1c:	e406                	sd	ra,8(sp)
    80002b1e:	e022                	sd	s0,0(sp)
    80002b20:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002b22:	fa5fe0ef          	jal	80001ac6 <myproc>
}
    80002b26:	5908                	lw	a0,48(a0)
    80002b28:	60a2                	ld	ra,8(sp)
    80002b2a:	6402                	ld	s0,0(sp)
    80002b2c:	0141                	addi	sp,sp,16
    80002b2e:	8082                	ret

0000000080002b30 <sys_fork>:

uint64
sys_fork(void)
{
    80002b30:	1141                	addi	sp,sp,-16
    80002b32:	e406                	sd	ra,8(sp)
    80002b34:	e022                	sd	s0,0(sp)
    80002b36:	0800                	addi	s0,sp,16
  return fork();
    80002b38:	ab4ff0ef          	jal	80001dec <fork>
}
    80002b3c:	60a2                	ld	ra,8(sp)
    80002b3e:	6402                	ld	s0,0(sp)
    80002b40:	0141                	addi	sp,sp,16
    80002b42:	8082                	ret

0000000080002b44 <sys_wait>:

uint64
sys_wait(void)
{
    80002b44:	1101                	addi	sp,sp,-32
    80002b46:	ec06                	sd	ra,24(sp)
    80002b48:	e822                	sd	s0,16(sp)
    80002b4a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002b4c:	fe840593          	addi	a1,s0,-24
    80002b50:	4501                	li	a0,0
    80002b52:	ef5ff0ef          	jal	80002a46 <argaddr>
  return wait(p);
    80002b56:	fe843503          	ld	a0,-24(s0)
    80002b5a:	f9cff0ef          	jal	800022f6 <wait>
}
    80002b5e:	60e2                	ld	ra,24(sp)
    80002b60:	6442                	ld	s0,16(sp)
    80002b62:	6105                	addi	sp,sp,32
    80002b64:	8082                	ret

0000000080002b66 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002b66:	7179                	addi	sp,sp,-48
    80002b68:	f406                	sd	ra,40(sp)
    80002b6a:	f022                	sd	s0,32(sp)
    80002b6c:	ec26                	sd	s1,24(sp)
    80002b6e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002b70:	fdc40593          	addi	a1,s0,-36
    80002b74:	4501                	li	a0,0
    80002b76:	eb5ff0ef          	jal	80002a2a <argint>
  addr = myproc()->sz;
    80002b7a:	f4dfe0ef          	jal	80001ac6 <myproc>
    80002b7e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002b80:	fdc42503          	lw	a0,-36(s0)
    80002b84:	a18ff0ef          	jal	80001d9c <growproc>
    80002b88:	00054863          	bltz	a0,80002b98 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80002b8c:	8526                	mv	a0,s1
    80002b8e:	70a2                	ld	ra,40(sp)
    80002b90:	7402                	ld	s0,32(sp)
    80002b92:	64e2                	ld	s1,24(sp)
    80002b94:	6145                	addi	sp,sp,48
    80002b96:	8082                	ret
    return -1;
    80002b98:	54fd                	li	s1,-1
    80002b9a:	bfcd                	j	80002b8c <sys_sbrk+0x26>

0000000080002b9c <sys_sleep>:

uint64
sys_sleep(void)
{
    80002b9c:	7139                	addi	sp,sp,-64
    80002b9e:	fc06                	sd	ra,56(sp)
    80002ba0:	f822                	sd	s0,48(sp)
    80002ba2:	f04a                	sd	s2,32(sp)
    80002ba4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002ba6:	fcc40593          	addi	a1,s0,-52
    80002baa:	4501                	li	a0,0
    80002bac:	e7fff0ef          	jal	80002a2a <argint>
  if(n < 0)
    80002bb0:	fcc42783          	lw	a5,-52(s0)
    80002bb4:	0607c763          	bltz	a5,80002c22 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80002bb8:	00456517          	auipc	a0,0x456
    80002bbc:	81050513          	addi	a0,a0,-2032 # 804583c8 <tickslock>
    80002bc0:	97afe0ef          	jal	80000d3a <acquire>
  ticks0 = ticks;
    80002bc4:	00008917          	auipc	s2,0x8
    80002bc8:	88c92903          	lw	s2,-1908(s2) # 8000a450 <ticks>
  while(ticks - ticks0 < n){
    80002bcc:	fcc42783          	lw	a5,-52(s0)
    80002bd0:	cf8d                	beqz	a5,80002c0a <sys_sleep+0x6e>
    80002bd2:	f426                	sd	s1,40(sp)
    80002bd4:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002bd6:	00455997          	auipc	s3,0x455
    80002bda:	7f298993          	addi	s3,s3,2034 # 804583c8 <tickslock>
    80002bde:	00008497          	auipc	s1,0x8
    80002be2:	87248493          	addi	s1,s1,-1934 # 8000a450 <ticks>
    if(killed(myproc())){
    80002be6:	ee1fe0ef          	jal	80001ac6 <myproc>
    80002bea:	ee2ff0ef          	jal	800022cc <killed>
    80002bee:	ed0d                	bnez	a0,80002c28 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80002bf0:	85ce                	mv	a1,s3
    80002bf2:	8526                	mv	a0,s1
    80002bf4:	ca0ff0ef          	jal	80002094 <sleep>
  while(ticks - ticks0 < n){
    80002bf8:	409c                	lw	a5,0(s1)
    80002bfa:	412787bb          	subw	a5,a5,s2
    80002bfe:	fcc42703          	lw	a4,-52(s0)
    80002c02:	fee7e2e3          	bltu	a5,a4,80002be6 <sys_sleep+0x4a>
    80002c06:	74a2                	ld	s1,40(sp)
    80002c08:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002c0a:	00455517          	auipc	a0,0x455
    80002c0e:	7be50513          	addi	a0,a0,1982 # 804583c8 <tickslock>
    80002c12:	9c0fe0ef          	jal	80000dd2 <release>
  return 0;
    80002c16:	4501                	li	a0,0
}
    80002c18:	70e2                	ld	ra,56(sp)
    80002c1a:	7442                	ld	s0,48(sp)
    80002c1c:	7902                	ld	s2,32(sp)
    80002c1e:	6121                	addi	sp,sp,64
    80002c20:	8082                	ret
    n = 0;
    80002c22:	fc042623          	sw	zero,-52(s0)
    80002c26:	bf49                	j	80002bb8 <sys_sleep+0x1c>
      release(&tickslock);
    80002c28:	00455517          	auipc	a0,0x455
    80002c2c:	7a050513          	addi	a0,a0,1952 # 804583c8 <tickslock>
    80002c30:	9a2fe0ef          	jal	80000dd2 <release>
      return -1;
    80002c34:	557d                	li	a0,-1
    80002c36:	74a2                	ld	s1,40(sp)
    80002c38:	69e2                	ld	s3,24(sp)
    80002c3a:	bff9                	j	80002c18 <sys_sleep+0x7c>

0000000080002c3c <sys_kill>:

uint64
sys_kill(void)
{
    80002c3c:	1101                	addi	sp,sp,-32
    80002c3e:	ec06                	sd	ra,24(sp)
    80002c40:	e822                	sd	s0,16(sp)
    80002c42:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002c44:	fec40593          	addi	a1,s0,-20
    80002c48:	4501                	li	a0,0
    80002c4a:	de1ff0ef          	jal	80002a2a <argint>
  return kill(pid);
    80002c4e:	fec42503          	lw	a0,-20(s0)
    80002c52:	df0ff0ef          	jal	80002242 <kill>
}
    80002c56:	60e2                	ld	ra,24(sp)
    80002c58:	6442                	ld	s0,16(sp)
    80002c5a:	6105                	addi	sp,sp,32
    80002c5c:	8082                	ret

0000000080002c5e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002c5e:	1101                	addi	sp,sp,-32
    80002c60:	ec06                	sd	ra,24(sp)
    80002c62:	e822                	sd	s0,16(sp)
    80002c64:	e426                	sd	s1,8(sp)
    80002c66:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002c68:	00455517          	auipc	a0,0x455
    80002c6c:	76050513          	addi	a0,a0,1888 # 804583c8 <tickslock>
    80002c70:	8cafe0ef          	jal	80000d3a <acquire>
  xticks = ticks;
    80002c74:	00007497          	auipc	s1,0x7
    80002c78:	7dc4a483          	lw	s1,2012(s1) # 8000a450 <ticks>
  release(&tickslock);
    80002c7c:	00455517          	auipc	a0,0x455
    80002c80:	74c50513          	addi	a0,a0,1868 # 804583c8 <tickslock>
    80002c84:	94efe0ef          	jal	80000dd2 <release>
  return xticks;
}
    80002c88:	02049513          	slli	a0,s1,0x20
    80002c8c:	9101                	srli	a0,a0,0x20
    80002c8e:	60e2                	ld	ra,24(sp)
    80002c90:	6442                	ld	s0,16(sp)
    80002c92:	64a2                	ld	s1,8(sp)
    80002c94:	6105                	addi	sp,sp,32
    80002c96:	8082                	ret

0000000080002c98 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002c98:	7179                	addi	sp,sp,-48
    80002c9a:	f406                	sd	ra,40(sp)
    80002c9c:	f022                	sd	s0,32(sp)
    80002c9e:	ec26                	sd	s1,24(sp)
    80002ca0:	e84a                	sd	s2,16(sp)
    80002ca2:	e44e                	sd	s3,8(sp)
    80002ca4:	e052                	sd	s4,0(sp)
    80002ca6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002ca8:	00004597          	auipc	a1,0x4
    80002cac:	7d858593          	addi	a1,a1,2008 # 80007480 <etext+0x480>
    80002cb0:	00455517          	auipc	a0,0x455
    80002cb4:	73050513          	addi	a0,a0,1840 # 804583e0 <bcache>
    80002cb8:	802fe0ef          	jal	80000cba <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002cbc:	0045d797          	auipc	a5,0x45d
    80002cc0:	72478793          	addi	a5,a5,1828 # 804603e0 <bcache+0x8000>
    80002cc4:	0045e717          	auipc	a4,0x45e
    80002cc8:	98470713          	addi	a4,a4,-1660 # 80460648 <bcache+0x8268>
    80002ccc:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002cd0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002cd4:	00455497          	auipc	s1,0x455
    80002cd8:	72448493          	addi	s1,s1,1828 # 804583f8 <bcache+0x18>
    b->next = bcache.head.next;
    80002cdc:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002cde:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002ce0:	00004a17          	auipc	s4,0x4
    80002ce4:	7a8a0a13          	addi	s4,s4,1960 # 80007488 <etext+0x488>
    b->next = bcache.head.next;
    80002ce8:	2b893783          	ld	a5,696(s2)
    80002cec:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002cee:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002cf2:	85d2                	mv	a1,s4
    80002cf4:	01048513          	addi	a0,s1,16
    80002cf8:	398010ef          	jal	80004090 <initsleeplock>
    bcache.head.next->prev = b;
    80002cfc:	2b893783          	ld	a5,696(s2)
    80002d00:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002d02:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002d06:	45848493          	addi	s1,s1,1112
    80002d0a:	fd349fe3          	bne	s1,s3,80002ce8 <binit+0x50>
  }
}
    80002d0e:	70a2                	ld	ra,40(sp)
    80002d10:	7402                	ld	s0,32(sp)
    80002d12:	64e2                	ld	s1,24(sp)
    80002d14:	6942                	ld	s2,16(sp)
    80002d16:	69a2                	ld	s3,8(sp)
    80002d18:	6a02                	ld	s4,0(sp)
    80002d1a:	6145                	addi	sp,sp,48
    80002d1c:	8082                	ret

0000000080002d1e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002d1e:	7179                	addi	sp,sp,-48
    80002d20:	f406                	sd	ra,40(sp)
    80002d22:	f022                	sd	s0,32(sp)
    80002d24:	ec26                	sd	s1,24(sp)
    80002d26:	e84a                	sd	s2,16(sp)
    80002d28:	e44e                	sd	s3,8(sp)
    80002d2a:	1800                	addi	s0,sp,48
    80002d2c:	892a                	mv	s2,a0
    80002d2e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002d30:	00455517          	auipc	a0,0x455
    80002d34:	6b050513          	addi	a0,a0,1712 # 804583e0 <bcache>
    80002d38:	802fe0ef          	jal	80000d3a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002d3c:	0045e497          	auipc	s1,0x45e
    80002d40:	95c4b483          	ld	s1,-1700(s1) # 80460698 <bcache+0x82b8>
    80002d44:	0045e797          	auipc	a5,0x45e
    80002d48:	90478793          	addi	a5,a5,-1788 # 80460648 <bcache+0x8268>
    80002d4c:	02f48b63          	beq	s1,a5,80002d82 <bread+0x64>
    80002d50:	873e                	mv	a4,a5
    80002d52:	a021                	j	80002d5a <bread+0x3c>
    80002d54:	68a4                	ld	s1,80(s1)
    80002d56:	02e48663          	beq	s1,a4,80002d82 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002d5a:	449c                	lw	a5,8(s1)
    80002d5c:	ff279ce3          	bne	a5,s2,80002d54 <bread+0x36>
    80002d60:	44dc                	lw	a5,12(s1)
    80002d62:	ff3799e3          	bne	a5,s3,80002d54 <bread+0x36>
      b->refcnt++;
    80002d66:	40bc                	lw	a5,64(s1)
    80002d68:	2785                	addiw	a5,a5,1
    80002d6a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d6c:	00455517          	auipc	a0,0x455
    80002d70:	67450513          	addi	a0,a0,1652 # 804583e0 <bcache>
    80002d74:	85efe0ef          	jal	80000dd2 <release>
      acquiresleep(&b->lock);
    80002d78:	01048513          	addi	a0,s1,16
    80002d7c:	34a010ef          	jal	800040c6 <acquiresleep>
      return b;
    80002d80:	a889                	j	80002dd2 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d82:	0045e497          	auipc	s1,0x45e
    80002d86:	90e4b483          	ld	s1,-1778(s1) # 80460690 <bcache+0x82b0>
    80002d8a:	0045e797          	auipc	a5,0x45e
    80002d8e:	8be78793          	addi	a5,a5,-1858 # 80460648 <bcache+0x8268>
    80002d92:	00f48863          	beq	s1,a5,80002da2 <bread+0x84>
    80002d96:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002d98:	40bc                	lw	a5,64(s1)
    80002d9a:	cb91                	beqz	a5,80002dae <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002d9c:	64a4                	ld	s1,72(s1)
    80002d9e:	fee49de3          	bne	s1,a4,80002d98 <bread+0x7a>
  panic("bget: no buffers");
    80002da2:	00004517          	auipc	a0,0x4
    80002da6:	6ee50513          	addi	a0,a0,1774 # 80007490 <etext+0x490>
    80002daa:	9ebfd0ef          	jal	80000794 <panic>
      b->dev = dev;
    80002dae:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002db2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002db6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002dba:	4785                	li	a5,1
    80002dbc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002dbe:	00455517          	auipc	a0,0x455
    80002dc2:	62250513          	addi	a0,a0,1570 # 804583e0 <bcache>
    80002dc6:	80cfe0ef          	jal	80000dd2 <release>
      acquiresleep(&b->lock);
    80002dca:	01048513          	addi	a0,s1,16
    80002dce:	2f8010ef          	jal	800040c6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002dd2:	409c                	lw	a5,0(s1)
    80002dd4:	cb89                	beqz	a5,80002de6 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002dd6:	8526                	mv	a0,s1
    80002dd8:	70a2                	ld	ra,40(sp)
    80002dda:	7402                	ld	s0,32(sp)
    80002ddc:	64e2                	ld	s1,24(sp)
    80002dde:	6942                	ld	s2,16(sp)
    80002de0:	69a2                	ld	s3,8(sp)
    80002de2:	6145                	addi	sp,sp,48
    80002de4:	8082                	ret
    virtio_disk_rw(b, 0);
    80002de6:	4581                	li	a1,0
    80002de8:	8526                	mv	a0,s1
    80002dea:	4a7020ef          	jal	80005a90 <virtio_disk_rw>
    b->valid = 1;
    80002dee:	4785                	li	a5,1
    80002df0:	c09c                	sw	a5,0(s1)
  return b;
    80002df2:	b7d5                	j	80002dd6 <bread+0xb8>

0000000080002df4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002df4:	1101                	addi	sp,sp,-32
    80002df6:	ec06                	sd	ra,24(sp)
    80002df8:	e822                	sd	s0,16(sp)
    80002dfa:	e426                	sd	s1,8(sp)
    80002dfc:	1000                	addi	s0,sp,32
    80002dfe:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002e00:	0541                	addi	a0,a0,16
    80002e02:	342010ef          	jal	80004144 <holdingsleep>
    80002e06:	c911                	beqz	a0,80002e1a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002e08:	4585                	li	a1,1
    80002e0a:	8526                	mv	a0,s1
    80002e0c:	485020ef          	jal	80005a90 <virtio_disk_rw>
}
    80002e10:	60e2                	ld	ra,24(sp)
    80002e12:	6442                	ld	s0,16(sp)
    80002e14:	64a2                	ld	s1,8(sp)
    80002e16:	6105                	addi	sp,sp,32
    80002e18:	8082                	ret
    panic("bwrite");
    80002e1a:	00004517          	auipc	a0,0x4
    80002e1e:	68e50513          	addi	a0,a0,1678 # 800074a8 <etext+0x4a8>
    80002e22:	973fd0ef          	jal	80000794 <panic>

0000000080002e26 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002e26:	1101                	addi	sp,sp,-32
    80002e28:	ec06                	sd	ra,24(sp)
    80002e2a:	e822                	sd	s0,16(sp)
    80002e2c:	e426                	sd	s1,8(sp)
    80002e2e:	e04a                	sd	s2,0(sp)
    80002e30:	1000                	addi	s0,sp,32
    80002e32:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002e34:	01050913          	addi	s2,a0,16
    80002e38:	854a                	mv	a0,s2
    80002e3a:	30a010ef          	jal	80004144 <holdingsleep>
    80002e3e:	c135                	beqz	a0,80002ea2 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80002e40:	854a                	mv	a0,s2
    80002e42:	2ca010ef          	jal	8000410c <releasesleep>

  acquire(&bcache.lock);
    80002e46:	00455517          	auipc	a0,0x455
    80002e4a:	59a50513          	addi	a0,a0,1434 # 804583e0 <bcache>
    80002e4e:	eedfd0ef          	jal	80000d3a <acquire>
  b->refcnt--;
    80002e52:	40bc                	lw	a5,64(s1)
    80002e54:	37fd                	addiw	a5,a5,-1
    80002e56:	0007871b          	sext.w	a4,a5
    80002e5a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002e5c:	e71d                	bnez	a4,80002e8a <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002e5e:	68b8                	ld	a4,80(s1)
    80002e60:	64bc                	ld	a5,72(s1)
    80002e62:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002e64:	68b8                	ld	a4,80(s1)
    80002e66:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002e68:	0045d797          	auipc	a5,0x45d
    80002e6c:	57878793          	addi	a5,a5,1400 # 804603e0 <bcache+0x8000>
    80002e70:	2b87b703          	ld	a4,696(a5)
    80002e74:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002e76:	0045d717          	auipc	a4,0x45d
    80002e7a:	7d270713          	addi	a4,a4,2002 # 80460648 <bcache+0x8268>
    80002e7e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002e80:	2b87b703          	ld	a4,696(a5)
    80002e84:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002e86:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002e8a:	00455517          	auipc	a0,0x455
    80002e8e:	55650513          	addi	a0,a0,1366 # 804583e0 <bcache>
    80002e92:	f41fd0ef          	jal	80000dd2 <release>
}
    80002e96:	60e2                	ld	ra,24(sp)
    80002e98:	6442                	ld	s0,16(sp)
    80002e9a:	64a2                	ld	s1,8(sp)
    80002e9c:	6902                	ld	s2,0(sp)
    80002e9e:	6105                	addi	sp,sp,32
    80002ea0:	8082                	ret
    panic("brelse");
    80002ea2:	00004517          	auipc	a0,0x4
    80002ea6:	60e50513          	addi	a0,a0,1550 # 800074b0 <etext+0x4b0>
    80002eaa:	8ebfd0ef          	jal	80000794 <panic>

0000000080002eae <bpin>:

void
bpin(struct buf *b) {
    80002eae:	1101                	addi	sp,sp,-32
    80002eb0:	ec06                	sd	ra,24(sp)
    80002eb2:	e822                	sd	s0,16(sp)
    80002eb4:	e426                	sd	s1,8(sp)
    80002eb6:	1000                	addi	s0,sp,32
    80002eb8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002eba:	00455517          	auipc	a0,0x455
    80002ebe:	52650513          	addi	a0,a0,1318 # 804583e0 <bcache>
    80002ec2:	e79fd0ef          	jal	80000d3a <acquire>
  b->refcnt++;
    80002ec6:	40bc                	lw	a5,64(s1)
    80002ec8:	2785                	addiw	a5,a5,1
    80002eca:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ecc:	00455517          	auipc	a0,0x455
    80002ed0:	51450513          	addi	a0,a0,1300 # 804583e0 <bcache>
    80002ed4:	efffd0ef          	jal	80000dd2 <release>
}
    80002ed8:	60e2                	ld	ra,24(sp)
    80002eda:	6442                	ld	s0,16(sp)
    80002edc:	64a2                	ld	s1,8(sp)
    80002ede:	6105                	addi	sp,sp,32
    80002ee0:	8082                	ret

0000000080002ee2 <bunpin>:

void
bunpin(struct buf *b) {
    80002ee2:	1101                	addi	sp,sp,-32
    80002ee4:	ec06                	sd	ra,24(sp)
    80002ee6:	e822                	sd	s0,16(sp)
    80002ee8:	e426                	sd	s1,8(sp)
    80002eea:	1000                	addi	s0,sp,32
    80002eec:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002eee:	00455517          	auipc	a0,0x455
    80002ef2:	4f250513          	addi	a0,a0,1266 # 804583e0 <bcache>
    80002ef6:	e45fd0ef          	jal	80000d3a <acquire>
  b->refcnt--;
    80002efa:	40bc                	lw	a5,64(s1)
    80002efc:	37fd                	addiw	a5,a5,-1
    80002efe:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002f00:	00455517          	auipc	a0,0x455
    80002f04:	4e050513          	addi	a0,a0,1248 # 804583e0 <bcache>
    80002f08:	ecbfd0ef          	jal	80000dd2 <release>
}
    80002f0c:	60e2                	ld	ra,24(sp)
    80002f0e:	6442                	ld	s0,16(sp)
    80002f10:	64a2                	ld	s1,8(sp)
    80002f12:	6105                	addi	sp,sp,32
    80002f14:	8082                	ret

0000000080002f16 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002f16:	1101                	addi	sp,sp,-32
    80002f18:	ec06                	sd	ra,24(sp)
    80002f1a:	e822                	sd	s0,16(sp)
    80002f1c:	e426                	sd	s1,8(sp)
    80002f1e:	e04a                	sd	s2,0(sp)
    80002f20:	1000                	addi	s0,sp,32
    80002f22:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002f24:	00d5d59b          	srliw	a1,a1,0xd
    80002f28:	0045e797          	auipc	a5,0x45e
    80002f2c:	b947a783          	lw	a5,-1132(a5) # 80460abc <sb+0x1c>
    80002f30:	9dbd                	addw	a1,a1,a5
    80002f32:	dedff0ef          	jal	80002d1e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002f36:	0074f713          	andi	a4,s1,7
    80002f3a:	4785                	li	a5,1
    80002f3c:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002f40:	14ce                	slli	s1,s1,0x33
    80002f42:	90d9                	srli	s1,s1,0x36
    80002f44:	00950733          	add	a4,a0,s1
    80002f48:	05874703          	lbu	a4,88(a4)
    80002f4c:	00e7f6b3          	and	a3,a5,a4
    80002f50:	c29d                	beqz	a3,80002f76 <bfree+0x60>
    80002f52:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002f54:	94aa                	add	s1,s1,a0
    80002f56:	fff7c793          	not	a5,a5
    80002f5a:	8f7d                	and	a4,a4,a5
    80002f5c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002f60:	060010ef          	jal	80003fc0 <log_write>
  brelse(bp);
    80002f64:	854a                	mv	a0,s2
    80002f66:	ec1ff0ef          	jal	80002e26 <brelse>
}
    80002f6a:	60e2                	ld	ra,24(sp)
    80002f6c:	6442                	ld	s0,16(sp)
    80002f6e:	64a2                	ld	s1,8(sp)
    80002f70:	6902                	ld	s2,0(sp)
    80002f72:	6105                	addi	sp,sp,32
    80002f74:	8082                	ret
    panic("freeing free block");
    80002f76:	00004517          	auipc	a0,0x4
    80002f7a:	54250513          	addi	a0,a0,1346 # 800074b8 <etext+0x4b8>
    80002f7e:	817fd0ef          	jal	80000794 <panic>

0000000080002f82 <balloc>:
{
    80002f82:	711d                	addi	sp,sp,-96
    80002f84:	ec86                	sd	ra,88(sp)
    80002f86:	e8a2                	sd	s0,80(sp)
    80002f88:	e4a6                	sd	s1,72(sp)
    80002f8a:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80002f8c:	0045e797          	auipc	a5,0x45e
    80002f90:	b187a783          	lw	a5,-1256(a5) # 80460aa4 <sb+0x4>
    80002f94:	0e078f63          	beqz	a5,80003092 <balloc+0x110>
    80002f98:	e0ca                	sd	s2,64(sp)
    80002f9a:	fc4e                	sd	s3,56(sp)
    80002f9c:	f852                	sd	s4,48(sp)
    80002f9e:	f456                	sd	s5,40(sp)
    80002fa0:	f05a                	sd	s6,32(sp)
    80002fa2:	ec5e                	sd	s7,24(sp)
    80002fa4:	e862                	sd	s8,16(sp)
    80002fa6:	e466                	sd	s9,8(sp)
    80002fa8:	8baa                	mv	s7,a0
    80002faa:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002fac:	0045eb17          	auipc	s6,0x45e
    80002fb0:	af4b0b13          	addi	s6,s6,-1292 # 80460aa0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fb4:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80002fb6:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002fb8:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002fba:	6c89                	lui	s9,0x2
    80002fbc:	a0b5                	j	80003028 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002fbe:	97ca                	add	a5,a5,s2
    80002fc0:	8e55                	or	a2,a2,a3
    80002fc2:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002fc6:	854a                	mv	a0,s2
    80002fc8:	7f9000ef          	jal	80003fc0 <log_write>
        brelse(bp);
    80002fcc:	854a                	mv	a0,s2
    80002fce:	e59ff0ef          	jal	80002e26 <brelse>
  bp = bread(dev, bno);
    80002fd2:	85a6                	mv	a1,s1
    80002fd4:	855e                	mv	a0,s7
    80002fd6:	d49ff0ef          	jal	80002d1e <bread>
    80002fda:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002fdc:	40000613          	li	a2,1024
    80002fe0:	4581                	li	a1,0
    80002fe2:	05850513          	addi	a0,a0,88
    80002fe6:	e29fd0ef          	jal	80000e0e <memset>
  log_write(bp);
    80002fea:	854a                	mv	a0,s2
    80002fec:	7d5000ef          	jal	80003fc0 <log_write>
  brelse(bp);
    80002ff0:	854a                	mv	a0,s2
    80002ff2:	e35ff0ef          	jal	80002e26 <brelse>
}
    80002ff6:	6906                	ld	s2,64(sp)
    80002ff8:	79e2                	ld	s3,56(sp)
    80002ffa:	7a42                	ld	s4,48(sp)
    80002ffc:	7aa2                	ld	s5,40(sp)
    80002ffe:	7b02                	ld	s6,32(sp)
    80003000:	6be2                	ld	s7,24(sp)
    80003002:	6c42                	ld	s8,16(sp)
    80003004:	6ca2                	ld	s9,8(sp)
}
    80003006:	8526                	mv	a0,s1
    80003008:	60e6                	ld	ra,88(sp)
    8000300a:	6446                	ld	s0,80(sp)
    8000300c:	64a6                	ld	s1,72(sp)
    8000300e:	6125                	addi	sp,sp,96
    80003010:	8082                	ret
    brelse(bp);
    80003012:	854a                	mv	a0,s2
    80003014:	e13ff0ef          	jal	80002e26 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003018:	015c87bb          	addw	a5,s9,s5
    8000301c:	00078a9b          	sext.w	s5,a5
    80003020:	004b2703          	lw	a4,4(s6)
    80003024:	04eaff63          	bgeu	s5,a4,80003082 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80003028:	41fad79b          	sraiw	a5,s5,0x1f
    8000302c:	0137d79b          	srliw	a5,a5,0x13
    80003030:	015787bb          	addw	a5,a5,s5
    80003034:	40d7d79b          	sraiw	a5,a5,0xd
    80003038:	01cb2583          	lw	a1,28(s6)
    8000303c:	9dbd                	addw	a1,a1,a5
    8000303e:	855e                	mv	a0,s7
    80003040:	cdfff0ef          	jal	80002d1e <bread>
    80003044:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003046:	004b2503          	lw	a0,4(s6)
    8000304a:	000a849b          	sext.w	s1,s5
    8000304e:	8762                	mv	a4,s8
    80003050:	fca4f1e3          	bgeu	s1,a0,80003012 <balloc+0x90>
      m = 1 << (bi % 8);
    80003054:	00777693          	andi	a3,a4,7
    80003058:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000305c:	41f7579b          	sraiw	a5,a4,0x1f
    80003060:	01d7d79b          	srliw	a5,a5,0x1d
    80003064:	9fb9                	addw	a5,a5,a4
    80003066:	4037d79b          	sraiw	a5,a5,0x3
    8000306a:	00f90633          	add	a2,s2,a5
    8000306e:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    80003072:	00c6f5b3          	and	a1,a3,a2
    80003076:	d5a1                	beqz	a1,80002fbe <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003078:	2705                	addiw	a4,a4,1
    8000307a:	2485                	addiw	s1,s1,1
    8000307c:	fd471ae3          	bne	a4,s4,80003050 <balloc+0xce>
    80003080:	bf49                	j	80003012 <balloc+0x90>
    80003082:	6906                	ld	s2,64(sp)
    80003084:	79e2                	ld	s3,56(sp)
    80003086:	7a42                	ld	s4,48(sp)
    80003088:	7aa2                	ld	s5,40(sp)
    8000308a:	7b02                	ld	s6,32(sp)
    8000308c:	6be2                	ld	s7,24(sp)
    8000308e:	6c42                	ld	s8,16(sp)
    80003090:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003092:	00004517          	auipc	a0,0x4
    80003096:	43e50513          	addi	a0,a0,1086 # 800074d0 <etext+0x4d0>
    8000309a:	c28fd0ef          	jal	800004c2 <printf>
  return 0;
    8000309e:	4481                	li	s1,0
    800030a0:	b79d                	j	80003006 <balloc+0x84>

00000000800030a2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800030a2:	7139                	addi	sp,sp,-64
    800030a4:	fc06                	sd	ra,56(sp)
    800030a6:	f822                	sd	s0,48(sp)
    800030a8:	f426                	sd	s1,40(sp)
    800030aa:	f04a                	sd	s2,32(sp)
    800030ac:	ec4e                	sd	s3,24(sp)
    800030ae:	0080                	addi	s0,sp,64
    800030b0:	89aa                	mv	s3,a0
  uint addr, addr1, addr2, addr3, *a, *a1, *a2;
  struct buf *bp, *bp1, *bp2;
  // bn이 Direct block 관련
  if(bn < NDIRECT){
    800030b2:	47a9                	li	a5,10
    800030b4:	02b7ee63          	bltu	a5,a1,800030f0 <bmap+0x4e>
    // block이 실제로 할당되지 않았다면
    if((addr = ip->addrs[bn]) == 0){
    800030b8:	02059793          	slli	a5,a1,0x20
    800030bc:	01e7d593          	srli	a1,a5,0x1e
    800030c0:	00b504b3          	add	s1,a0,a1
    800030c4:	0504a903          	lw	s2,80(s1)
    800030c8:	00090a63          	beqz	s2,800030dc <bmap+0x3a>

    return addr3;
  }

  panic("bmap: out of range");
}
    800030cc:	854a                	mv	a0,s2
    800030ce:	70e2                	ld	ra,56(sp)
    800030d0:	7442                	ld	s0,48(sp)
    800030d2:	74a2                	ld	s1,40(sp)
    800030d4:	7902                	ld	s2,32(sp)
    800030d6:	69e2                	ld	s3,24(sp)
    800030d8:	6121                	addi	sp,sp,64
    800030da:	8082                	ret
      addr = balloc(ip->dev);
    800030dc:	4108                	lw	a0,0(a0)
    800030de:	ea5ff0ef          	jal	80002f82 <balloc>
    800030e2:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800030e6:	fe0903e3          	beqz	s2,800030cc <bmap+0x2a>
      ip->addrs[bn] = addr;
    800030ea:	0524a823          	sw	s2,80(s1)
    800030ee:	bff9                	j	800030cc <bmap+0x2a>
  bn -= NDIRECT;
    800030f0:	ff55849b          	addiw	s1,a1,-11
    800030f4:	0004871b          	sext.w	a4,s1
  if(bn < NINDIRECT){
    800030f8:	0ff00793          	li	a5,255
    800030fc:	06e7e663          	bltu	a5,a4,80003168 <bmap+0xc6>
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003100:	07c52903          	lw	s2,124(a0)
    80003104:	00091d63          	bnez	s2,8000311e <bmap+0x7c>
      addr = balloc(ip->dev);
    80003108:	4108                	lw	a0,0(a0)
    8000310a:	e79ff0ef          	jal	80002f82 <balloc>
    8000310e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003112:	fa090de3          	beqz	s2,800030cc <bmap+0x2a>
    80003116:	e852                	sd	s4,16(sp)
      ip->addrs[NDIRECT] = addr;
    80003118:	0729ae23          	sw	s2,124(s3)
    8000311c:	a011                	j	80003120 <bmap+0x7e>
    8000311e:	e852                	sd	s4,16(sp)
    bp = bread(ip->dev, addr); // Block을 읽어서 메모리로 가져옴
    80003120:	85ca                	mv	a1,s2
    80003122:	0009a503          	lw	a0,0(s3)
    80003126:	bf9ff0ef          	jal	80002d1e <bread>
    8000312a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data; // bp의 data를 uint pointer 배열로 변환
    8000312c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){ // 실제 데이터에 해당하는 block이 비었다면
    80003130:	02049713          	slli	a4,s1,0x20
    80003134:	01e75493          	srli	s1,a4,0x1e
    80003138:	94be                	add	s1,s1,a5
    8000313a:	0004a903          	lw	s2,0(s1)
    8000313e:	00090763          	beqz	s2,8000314c <bmap+0xaa>
    brelse(bp);
    80003142:	8552                	mv	a0,s4
    80003144:	ce3ff0ef          	jal	80002e26 <brelse>
    return addr;
    80003148:	6a42                	ld	s4,16(sp)
    8000314a:	b749                	j	800030cc <bmap+0x2a>
      addr = balloc(ip->dev);
    8000314c:	0009a503          	lw	a0,0(s3)
    80003150:	e33ff0ef          	jal	80002f82 <balloc>
    80003154:	0005091b          	sext.w	s2,a0
      if(addr){
    80003158:	fe0905e3          	beqz	s2,80003142 <bmap+0xa0>
        a[bn] = addr;
    8000315c:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003160:	8552                	mv	a0,s4
    80003162:	65f000ef          	jal	80003fc0 <log_write>
    80003166:	bff1                	j	80003142 <bmap+0xa0>
  bn -= NINDIRECT; // single indirect block이 아닌 경우 double inderect를 확인해야함
    80003168:	ef55849b          	addiw	s1,a1,-267
    8000316c:	0004871b          	sext.w	a4,s1
  if(bn < NINDIRECT*NINDIRECT){
    80003170:	67c1                	lui	a5,0x10
    80003172:	0af77a63          	bgeu	a4,a5,80003226 <bmap+0x184>
    if((addr1 = ip->addrs[NDIRECT+1]) == 0){
    80003176:	08052903          	lw	s2,128(a0)
    8000317a:	00091e63          	bnez	s2,80003196 <bmap+0xf4>
      addr1 = balloc(ip->dev);
    8000317e:	4108                	lw	a0,0(a0)
    80003180:	e03ff0ef          	jal	80002f82 <balloc>
    80003184:	0005091b          	sext.w	s2,a0
      if(addr1 == 0)
    80003188:	f40902e3          	beqz	s2,800030cc <bmap+0x2a>
    8000318c:	e852                	sd	s4,16(sp)
    8000318e:	e456                	sd	s5,8(sp)
      ip->addrs[NDIRECT+1] = addr1;
    80003190:	0929a023          	sw	s2,128(s3)
    80003194:	a019                	j	8000319a <bmap+0xf8>
    80003196:	e852                	sd	s4,16(sp)
    80003198:	e456                	sd	s5,8(sp)
    bp1 = bread(ip->dev, addr1); // Block을 읽어서 메모리로 가져옴
    8000319a:	85ca                	mv	a1,s2
    8000319c:	0009a503          	lw	a0,0(s3)
    800031a0:	b7fff0ef          	jal	80002d1e <bread>
    800031a4:	892a                	mv	s2,a0
    a1 = (uint*)bp1->data; // bp의 data를 uint pointer 배열로 변환
    800031a6:	05850a93          	addi	s5,a0,88
    if((addr2 = a1[bn / NINDIRECT]) == 0){ // 첫 번째 indirect block 중 어디에 속하는지 확인
    800031aa:	0084d79b          	srliw	a5,s1,0x8
    800031ae:	078a                	slli	a5,a5,0x2
    800031b0:	9abe                	add	s5,s5,a5
    800031b2:	000aaa03          	lw	s4,0(s5)
    800031b6:	020a0c63          	beqz	s4,800031ee <bmap+0x14c>
    brelse(bp1);
    800031ba:	854a                	mv	a0,s2
    800031bc:	c6bff0ef          	jal	80002e26 <brelse>
    bp2 = bread(ip->dev, addr2); // Block을 읽어서 메모리로 가져옴
    800031c0:	85d2                	mv	a1,s4
    800031c2:	0009a503          	lw	a0,0(s3)
    800031c6:	b59ff0ef          	jal	80002d1e <bread>
    800031ca:	8a2a                	mv	s4,a0
    a2 = (uint*)bp2->data; // bp의 data를 uint pointer 배열로 변환
    800031cc:	05850793          	addi	a5,a0,88
    if((addr3 = a2[bn%NINDIRECT]) == 0){ // 두 번째 indirect block 중 어디에 속하는지 확인
    800031d0:	0ff4f593          	zext.b	a1,s1
    800031d4:	058a                	slli	a1,a1,0x2
    800031d6:	00b784b3          	add	s1,a5,a1
    800031da:	0004a903          	lw	s2,0(s1)
    800031de:	02090663          	beqz	s2,8000320a <bmap+0x168>
    brelse(bp2);
    800031e2:	8552                	mv	a0,s4
    800031e4:	c43ff0ef          	jal	80002e26 <brelse>
    return addr3;
    800031e8:	6a42                	ld	s4,16(sp)
    800031ea:	6aa2                	ld	s5,8(sp)
    800031ec:	b5c5                	j	800030cc <bmap+0x2a>
      addr2 = balloc(ip->dev);
    800031ee:	0009a503          	lw	a0,0(s3)
    800031f2:	d91ff0ef          	jal	80002f82 <balloc>
    800031f6:	00050a1b          	sext.w	s4,a0
      if(addr2){
    800031fa:	fc0a00e3          	beqz	s4,800031ba <bmap+0x118>
        a1[bn / NINDIRECT] = addr2;
    800031fe:	014aa023          	sw	s4,0(s5)
        log_write(bp1);
    80003202:	854a                	mv	a0,s2
    80003204:	5bd000ef          	jal	80003fc0 <log_write>
    80003208:	bf4d                	j	800031ba <bmap+0x118>
      addr3 = balloc(ip->dev);
    8000320a:	0009a503          	lw	a0,0(s3)
    8000320e:	d75ff0ef          	jal	80002f82 <balloc>
    80003212:	0005091b          	sext.w	s2,a0
      if(addr3){
    80003216:	fc0906e3          	beqz	s2,800031e2 <bmap+0x140>
        a2[bn%NINDIRECT] = addr3;
    8000321a:	0124a023          	sw	s2,0(s1)
        log_write(bp2);
    8000321e:	8552                	mv	a0,s4
    80003220:	5a1000ef          	jal	80003fc0 <log_write>
    80003224:	bf7d                	j	800031e2 <bmap+0x140>
    80003226:	e852                	sd	s4,16(sp)
    80003228:	e456                	sd	s5,8(sp)
  panic("bmap: out of range");
    8000322a:	00004517          	auipc	a0,0x4
    8000322e:	2be50513          	addi	a0,a0,702 # 800074e8 <etext+0x4e8>
    80003232:	d62fd0ef          	jal	80000794 <panic>

0000000080003236 <iget>:
{
    80003236:	7179                	addi	sp,sp,-48
    80003238:	f406                	sd	ra,40(sp)
    8000323a:	f022                	sd	s0,32(sp)
    8000323c:	ec26                	sd	s1,24(sp)
    8000323e:	e84a                	sd	s2,16(sp)
    80003240:	e44e                	sd	s3,8(sp)
    80003242:	e052                	sd	s4,0(sp)
    80003244:	1800                	addi	s0,sp,48
    80003246:	89aa                	mv	s3,a0
    80003248:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000324a:	0045e517          	auipc	a0,0x45e
    8000324e:	87650513          	addi	a0,a0,-1930 # 80460ac0 <itable>
    80003252:	ae9fd0ef          	jal	80000d3a <acquire>
  empty = 0;
    80003256:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003258:	0045e497          	auipc	s1,0x45e
    8000325c:	88048493          	addi	s1,s1,-1920 # 80460ad8 <itable+0x18>
    80003260:	0045f697          	auipc	a3,0x45f
    80003264:	30868693          	addi	a3,a3,776 # 80462568 <log>
    80003268:	a039                	j	80003276 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000326a:	02090963          	beqz	s2,8000329c <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000326e:	08848493          	addi	s1,s1,136
    80003272:	02d48863          	beq	s1,a3,800032a2 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003276:	449c                	lw	a5,8(s1)
    80003278:	fef059e3          	blez	a5,8000326a <iget+0x34>
    8000327c:	4098                	lw	a4,0(s1)
    8000327e:	ff3716e3          	bne	a4,s3,8000326a <iget+0x34>
    80003282:	40d8                	lw	a4,4(s1)
    80003284:	ff4713e3          	bne	a4,s4,8000326a <iget+0x34>
      ip->ref++;
    80003288:	2785                	addiw	a5,a5,1 # 10001 <_entry-0x7ffeffff>
    8000328a:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000328c:	0045e517          	auipc	a0,0x45e
    80003290:	83450513          	addi	a0,a0,-1996 # 80460ac0 <itable>
    80003294:	b3ffd0ef          	jal	80000dd2 <release>
      return ip;
    80003298:	8926                	mv	s2,s1
    8000329a:	a02d                	j	800032c4 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000329c:	fbe9                	bnez	a5,8000326e <iget+0x38>
      empty = ip;
    8000329e:	8926                	mv	s2,s1
    800032a0:	b7f9                	j	8000326e <iget+0x38>
  if(empty == 0)
    800032a2:	02090a63          	beqz	s2,800032d6 <iget+0xa0>
  ip->dev = dev;
    800032a6:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800032aa:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800032ae:	4785                	li	a5,1
    800032b0:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800032b4:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800032b8:	0045e517          	auipc	a0,0x45e
    800032bc:	80850513          	addi	a0,a0,-2040 # 80460ac0 <itable>
    800032c0:	b13fd0ef          	jal	80000dd2 <release>
}
    800032c4:	854a                	mv	a0,s2
    800032c6:	70a2                	ld	ra,40(sp)
    800032c8:	7402                	ld	s0,32(sp)
    800032ca:	64e2                	ld	s1,24(sp)
    800032cc:	6942                	ld	s2,16(sp)
    800032ce:	69a2                	ld	s3,8(sp)
    800032d0:	6a02                	ld	s4,0(sp)
    800032d2:	6145                	addi	sp,sp,48
    800032d4:	8082                	ret
    panic("iget: no inodes");
    800032d6:	00004517          	auipc	a0,0x4
    800032da:	22a50513          	addi	a0,a0,554 # 80007500 <etext+0x500>
    800032de:	cb6fd0ef          	jal	80000794 <panic>

00000000800032e2 <fsinit>:
fsinit(int dev) {
    800032e2:	7179                	addi	sp,sp,-48
    800032e4:	f406                	sd	ra,40(sp)
    800032e6:	f022                	sd	s0,32(sp)
    800032e8:	ec26                	sd	s1,24(sp)
    800032ea:	e84a                	sd	s2,16(sp)
    800032ec:	e44e                	sd	s3,8(sp)
    800032ee:	1800                	addi	s0,sp,48
    800032f0:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800032f2:	4585                	li	a1,1
    800032f4:	a2bff0ef          	jal	80002d1e <bread>
    800032f8:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800032fa:	0045d997          	auipc	s3,0x45d
    800032fe:	7a698993          	addi	s3,s3,1958 # 80460aa0 <sb>
    80003302:	02000613          	li	a2,32
    80003306:	05850593          	addi	a1,a0,88
    8000330a:	854e                	mv	a0,s3
    8000330c:	b5ffd0ef          	jal	80000e6a <memmove>
  brelse(bp);
    80003310:	8526                	mv	a0,s1
    80003312:	b15ff0ef          	jal	80002e26 <brelse>
  if(sb.magic != FSMAGIC)
    80003316:	0009a703          	lw	a4,0(s3)
    8000331a:	102037b7          	lui	a5,0x10203
    8000331e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003322:	02f71063          	bne	a4,a5,80003342 <fsinit+0x60>
  initlog(dev, &sb);
    80003326:	0045d597          	auipc	a1,0x45d
    8000332a:	77a58593          	addi	a1,a1,1914 # 80460aa0 <sb>
    8000332e:	854a                	mv	a0,s2
    80003330:	289000ef          	jal	80003db8 <initlog>
}
    80003334:	70a2                	ld	ra,40(sp)
    80003336:	7402                	ld	s0,32(sp)
    80003338:	64e2                	ld	s1,24(sp)
    8000333a:	6942                	ld	s2,16(sp)
    8000333c:	69a2                	ld	s3,8(sp)
    8000333e:	6145                	addi	sp,sp,48
    80003340:	8082                	ret
    panic("invalid file system");
    80003342:	00004517          	auipc	a0,0x4
    80003346:	1ce50513          	addi	a0,a0,462 # 80007510 <etext+0x510>
    8000334a:	c4afd0ef          	jal	80000794 <panic>

000000008000334e <iinit>:
{
    8000334e:	7179                	addi	sp,sp,-48
    80003350:	f406                	sd	ra,40(sp)
    80003352:	f022                	sd	s0,32(sp)
    80003354:	ec26                	sd	s1,24(sp)
    80003356:	e84a                	sd	s2,16(sp)
    80003358:	e44e                	sd	s3,8(sp)
    8000335a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000335c:	00004597          	auipc	a1,0x4
    80003360:	1cc58593          	addi	a1,a1,460 # 80007528 <etext+0x528>
    80003364:	0045d517          	auipc	a0,0x45d
    80003368:	75c50513          	addi	a0,a0,1884 # 80460ac0 <itable>
    8000336c:	94ffd0ef          	jal	80000cba <initlock>
  for(i = 0; i < NINODE; i++) {
    80003370:	0045d497          	auipc	s1,0x45d
    80003374:	77848493          	addi	s1,s1,1912 # 80460ae8 <itable+0x28>
    80003378:	0045f997          	auipc	s3,0x45f
    8000337c:	20098993          	addi	s3,s3,512 # 80462578 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003380:	00004917          	auipc	s2,0x4
    80003384:	1b090913          	addi	s2,s2,432 # 80007530 <etext+0x530>
    80003388:	85ca                	mv	a1,s2
    8000338a:	8526                	mv	a0,s1
    8000338c:	505000ef          	jal	80004090 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003390:	08848493          	addi	s1,s1,136
    80003394:	ff349ae3          	bne	s1,s3,80003388 <iinit+0x3a>
}
    80003398:	70a2                	ld	ra,40(sp)
    8000339a:	7402                	ld	s0,32(sp)
    8000339c:	64e2                	ld	s1,24(sp)
    8000339e:	6942                	ld	s2,16(sp)
    800033a0:	69a2                	ld	s3,8(sp)
    800033a2:	6145                	addi	sp,sp,48
    800033a4:	8082                	ret

00000000800033a6 <ialloc>:
{
    800033a6:	7139                	addi	sp,sp,-64
    800033a8:	fc06                	sd	ra,56(sp)
    800033aa:	f822                	sd	s0,48(sp)
    800033ac:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800033ae:	0045d717          	auipc	a4,0x45d
    800033b2:	6fe72703          	lw	a4,1790(a4) # 80460aac <sb+0xc>
    800033b6:	4785                	li	a5,1
    800033b8:	06e7f063          	bgeu	a5,a4,80003418 <ialloc+0x72>
    800033bc:	f426                	sd	s1,40(sp)
    800033be:	f04a                	sd	s2,32(sp)
    800033c0:	ec4e                	sd	s3,24(sp)
    800033c2:	e852                	sd	s4,16(sp)
    800033c4:	e456                	sd	s5,8(sp)
    800033c6:	e05a                	sd	s6,0(sp)
    800033c8:	8aaa                	mv	s5,a0
    800033ca:	8b2e                	mv	s6,a1
    800033cc:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    800033ce:	0045da17          	auipc	s4,0x45d
    800033d2:	6d2a0a13          	addi	s4,s4,1746 # 80460aa0 <sb>
    800033d6:	00495593          	srli	a1,s2,0x4
    800033da:	018a2783          	lw	a5,24(s4)
    800033de:	9dbd                	addw	a1,a1,a5
    800033e0:	8556                	mv	a0,s5
    800033e2:	93dff0ef          	jal	80002d1e <bread>
    800033e6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800033e8:	05850993          	addi	s3,a0,88
    800033ec:	00f97793          	andi	a5,s2,15
    800033f0:	079a                	slli	a5,a5,0x6
    800033f2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800033f4:	00099783          	lh	a5,0(s3)
    800033f8:	cb9d                	beqz	a5,8000342e <ialloc+0x88>
    brelse(bp);
    800033fa:	a2dff0ef          	jal	80002e26 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800033fe:	0905                	addi	s2,s2,1
    80003400:	00ca2703          	lw	a4,12(s4)
    80003404:	0009079b          	sext.w	a5,s2
    80003408:	fce7e7e3          	bltu	a5,a4,800033d6 <ialloc+0x30>
    8000340c:	74a2                	ld	s1,40(sp)
    8000340e:	7902                	ld	s2,32(sp)
    80003410:	69e2                	ld	s3,24(sp)
    80003412:	6a42                	ld	s4,16(sp)
    80003414:	6aa2                	ld	s5,8(sp)
    80003416:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003418:	00004517          	auipc	a0,0x4
    8000341c:	12050513          	addi	a0,a0,288 # 80007538 <etext+0x538>
    80003420:	8a2fd0ef          	jal	800004c2 <printf>
  return 0;
    80003424:	4501                	li	a0,0
}
    80003426:	70e2                	ld	ra,56(sp)
    80003428:	7442                	ld	s0,48(sp)
    8000342a:	6121                	addi	sp,sp,64
    8000342c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000342e:	04000613          	li	a2,64
    80003432:	4581                	li	a1,0
    80003434:	854e                	mv	a0,s3
    80003436:	9d9fd0ef          	jal	80000e0e <memset>
      dip->type = type;
    8000343a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000343e:	8526                	mv	a0,s1
    80003440:	381000ef          	jal	80003fc0 <log_write>
      brelse(bp);
    80003444:	8526                	mv	a0,s1
    80003446:	9e1ff0ef          	jal	80002e26 <brelse>
      return iget(dev, inum);
    8000344a:	0009059b          	sext.w	a1,s2
    8000344e:	8556                	mv	a0,s5
    80003450:	de7ff0ef          	jal	80003236 <iget>
    80003454:	74a2                	ld	s1,40(sp)
    80003456:	7902                	ld	s2,32(sp)
    80003458:	69e2                	ld	s3,24(sp)
    8000345a:	6a42                	ld	s4,16(sp)
    8000345c:	6aa2                	ld	s5,8(sp)
    8000345e:	6b02                	ld	s6,0(sp)
    80003460:	b7d9                	j	80003426 <ialloc+0x80>

0000000080003462 <iupdate>:
{
    80003462:	1101                	addi	sp,sp,-32
    80003464:	ec06                	sd	ra,24(sp)
    80003466:	e822                	sd	s0,16(sp)
    80003468:	e426                	sd	s1,8(sp)
    8000346a:	e04a                	sd	s2,0(sp)
    8000346c:	1000                	addi	s0,sp,32
    8000346e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003470:	415c                	lw	a5,4(a0)
    80003472:	0047d79b          	srliw	a5,a5,0x4
    80003476:	0045d597          	auipc	a1,0x45d
    8000347a:	6425a583          	lw	a1,1602(a1) # 80460ab8 <sb+0x18>
    8000347e:	9dbd                	addw	a1,a1,a5
    80003480:	4108                	lw	a0,0(a0)
    80003482:	89dff0ef          	jal	80002d1e <bread>
    80003486:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003488:	05850793          	addi	a5,a0,88
    8000348c:	40d8                	lw	a4,4(s1)
    8000348e:	8b3d                	andi	a4,a4,15
    80003490:	071a                	slli	a4,a4,0x6
    80003492:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003494:	04449703          	lh	a4,68(s1)
    80003498:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000349c:	04649703          	lh	a4,70(s1)
    800034a0:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800034a4:	04849703          	lh	a4,72(s1)
    800034a8:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800034ac:	04a49703          	lh	a4,74(s1)
    800034b0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800034b4:	44f8                	lw	a4,76(s1)
    800034b6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800034b8:	03400613          	li	a2,52
    800034bc:	05048593          	addi	a1,s1,80
    800034c0:	00c78513          	addi	a0,a5,12
    800034c4:	9a7fd0ef          	jal	80000e6a <memmove>
  log_write(bp);
    800034c8:	854a                	mv	a0,s2
    800034ca:	2f7000ef          	jal	80003fc0 <log_write>
  brelse(bp);
    800034ce:	854a                	mv	a0,s2
    800034d0:	957ff0ef          	jal	80002e26 <brelse>
}
    800034d4:	60e2                	ld	ra,24(sp)
    800034d6:	6442                	ld	s0,16(sp)
    800034d8:	64a2                	ld	s1,8(sp)
    800034da:	6902                	ld	s2,0(sp)
    800034dc:	6105                	addi	sp,sp,32
    800034de:	8082                	ret

00000000800034e0 <idup>:
{
    800034e0:	1101                	addi	sp,sp,-32
    800034e2:	ec06                	sd	ra,24(sp)
    800034e4:	e822                	sd	s0,16(sp)
    800034e6:	e426                	sd	s1,8(sp)
    800034e8:	1000                	addi	s0,sp,32
    800034ea:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800034ec:	0045d517          	auipc	a0,0x45d
    800034f0:	5d450513          	addi	a0,a0,1492 # 80460ac0 <itable>
    800034f4:	847fd0ef          	jal	80000d3a <acquire>
  ip->ref++;
    800034f8:	449c                	lw	a5,8(s1)
    800034fa:	2785                	addiw	a5,a5,1
    800034fc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800034fe:	0045d517          	auipc	a0,0x45d
    80003502:	5c250513          	addi	a0,a0,1474 # 80460ac0 <itable>
    80003506:	8cdfd0ef          	jal	80000dd2 <release>
}
    8000350a:	8526                	mv	a0,s1
    8000350c:	60e2                	ld	ra,24(sp)
    8000350e:	6442                	ld	s0,16(sp)
    80003510:	64a2                	ld	s1,8(sp)
    80003512:	6105                	addi	sp,sp,32
    80003514:	8082                	ret

0000000080003516 <ilock>:
{
    80003516:	1101                	addi	sp,sp,-32
    80003518:	ec06                	sd	ra,24(sp)
    8000351a:	e822                	sd	s0,16(sp)
    8000351c:	e426                	sd	s1,8(sp)
    8000351e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003520:	cd19                	beqz	a0,8000353e <ilock+0x28>
    80003522:	84aa                	mv	s1,a0
    80003524:	451c                	lw	a5,8(a0)
    80003526:	00f05c63          	blez	a5,8000353e <ilock+0x28>
  acquiresleep(&ip->lock);
    8000352a:	0541                	addi	a0,a0,16
    8000352c:	39b000ef          	jal	800040c6 <acquiresleep>
  if(ip->valid == 0){
    80003530:	40bc                	lw	a5,64(s1)
    80003532:	cf89                	beqz	a5,8000354c <ilock+0x36>
}
    80003534:	60e2                	ld	ra,24(sp)
    80003536:	6442                	ld	s0,16(sp)
    80003538:	64a2                	ld	s1,8(sp)
    8000353a:	6105                	addi	sp,sp,32
    8000353c:	8082                	ret
    8000353e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003540:	00004517          	auipc	a0,0x4
    80003544:	01050513          	addi	a0,a0,16 # 80007550 <etext+0x550>
    80003548:	a4cfd0ef          	jal	80000794 <panic>
    8000354c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000354e:	40dc                	lw	a5,4(s1)
    80003550:	0047d79b          	srliw	a5,a5,0x4
    80003554:	0045d597          	auipc	a1,0x45d
    80003558:	5645a583          	lw	a1,1380(a1) # 80460ab8 <sb+0x18>
    8000355c:	9dbd                	addw	a1,a1,a5
    8000355e:	4088                	lw	a0,0(s1)
    80003560:	fbeff0ef          	jal	80002d1e <bread>
    80003564:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003566:	05850593          	addi	a1,a0,88
    8000356a:	40dc                	lw	a5,4(s1)
    8000356c:	8bbd                	andi	a5,a5,15
    8000356e:	079a                	slli	a5,a5,0x6
    80003570:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003572:	00059783          	lh	a5,0(a1)
    80003576:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000357a:	00259783          	lh	a5,2(a1)
    8000357e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003582:	00459783          	lh	a5,4(a1)
    80003586:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000358a:	00659783          	lh	a5,6(a1)
    8000358e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003592:	459c                	lw	a5,8(a1)
    80003594:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003596:	03400613          	li	a2,52
    8000359a:	05b1                	addi	a1,a1,12
    8000359c:	05048513          	addi	a0,s1,80
    800035a0:	8cbfd0ef          	jal	80000e6a <memmove>
    brelse(bp);
    800035a4:	854a                	mv	a0,s2
    800035a6:	881ff0ef          	jal	80002e26 <brelse>
    ip->valid = 1;
    800035aa:	4785                	li	a5,1
    800035ac:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800035ae:	04449783          	lh	a5,68(s1)
    800035b2:	c399                	beqz	a5,800035b8 <ilock+0xa2>
    800035b4:	6902                	ld	s2,0(sp)
    800035b6:	bfbd                	j	80003534 <ilock+0x1e>
      panic("ilock: no type");
    800035b8:	00004517          	auipc	a0,0x4
    800035bc:	fa050513          	addi	a0,a0,-96 # 80007558 <etext+0x558>
    800035c0:	9d4fd0ef          	jal	80000794 <panic>

00000000800035c4 <iunlock>:
{
    800035c4:	1101                	addi	sp,sp,-32
    800035c6:	ec06                	sd	ra,24(sp)
    800035c8:	e822                	sd	s0,16(sp)
    800035ca:	e426                	sd	s1,8(sp)
    800035cc:	e04a                	sd	s2,0(sp)
    800035ce:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800035d0:	c505                	beqz	a0,800035f8 <iunlock+0x34>
    800035d2:	84aa                	mv	s1,a0
    800035d4:	01050913          	addi	s2,a0,16
    800035d8:	854a                	mv	a0,s2
    800035da:	36b000ef          	jal	80004144 <holdingsleep>
    800035de:	cd09                	beqz	a0,800035f8 <iunlock+0x34>
    800035e0:	449c                	lw	a5,8(s1)
    800035e2:	00f05b63          	blez	a5,800035f8 <iunlock+0x34>
  releasesleep(&ip->lock);
    800035e6:	854a                	mv	a0,s2
    800035e8:	325000ef          	jal	8000410c <releasesleep>
}
    800035ec:	60e2                	ld	ra,24(sp)
    800035ee:	6442                	ld	s0,16(sp)
    800035f0:	64a2                	ld	s1,8(sp)
    800035f2:	6902                	ld	s2,0(sp)
    800035f4:	6105                	addi	sp,sp,32
    800035f6:	8082                	ret
    panic("iunlock");
    800035f8:	00004517          	auipc	a0,0x4
    800035fc:	f7050513          	addi	a0,a0,-144 # 80007568 <etext+0x568>
    80003600:	994fd0ef          	jal	80000794 <panic>

0000000080003604 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003604:	715d                	addi	sp,sp,-80
    80003606:	e486                	sd	ra,72(sp)
    80003608:	e0a2                	sd	s0,64(sp)
    8000360a:	fc26                	sd	s1,56(sp)
    8000360c:	f84a                	sd	s2,48(sp)
    8000360e:	f44e                	sd	s3,40(sp)
    80003610:	0880                	addi	s0,sp,80
    80003612:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp, *bp1, *bp2;
  uint *a, *a1, *a2;
  // Direct block 할당 해제
  for(i = 0; i < NDIRECT; i++){
    80003614:	05050493          	addi	s1,a0,80
    80003618:	07c50913          	addi	s2,a0,124
    8000361c:	a021                	j	80003624 <itrunc+0x20>
    8000361e:	0491                	addi	s1,s1,4
    80003620:	01248b63          	beq	s1,s2,80003636 <itrunc+0x32>
    if(ip->addrs[i]){
    80003624:	408c                	lw	a1,0(s1)
    80003626:	dde5                	beqz	a1,8000361e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003628:	0009a503          	lw	a0,0(s3)
    8000362c:	8ebff0ef          	jal	80002f16 <bfree>
      ip->addrs[i] = 0;
    80003630:	0004a023          	sw	zero,0(s1)
    80003634:	b7ed                	j	8000361e <itrunc+0x1a>
    }
  }

  // Indirect block이 관리하는 block을 할당 해제
  if(ip->addrs[NDIRECT]){
    80003636:	07c9a583          	lw	a1,124(s3)
    8000363a:	e185                	bnez	a1,8000365a <itrunc+0x56>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  // Double - indirect block 할당 해제
  if (ip->addrs[NDIRECT+1]){
    8000363c:	0809a583          	lw	a1,128(s3)
    80003640:	edb9                	bnez	a1,8000369e <itrunc+0x9a>
    brelse(bp1);
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    ip->addrs[NDIRECT+1] = 0;
  }

  ip->size = 0;
    80003642:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003646:	854e                	mv	a0,s3
    80003648:	e1bff0ef          	jal	80003462 <iupdate>
}
    8000364c:	60a6                	ld	ra,72(sp)
    8000364e:	6406                	ld	s0,64(sp)
    80003650:	74e2                	ld	s1,56(sp)
    80003652:	7942                	ld	s2,48(sp)
    80003654:	79a2                	ld	s3,40(sp)
    80003656:	6161                	addi	sp,sp,80
    80003658:	8082                	ret
    8000365a:	f052                	sd	s4,32(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000365c:	0009a503          	lw	a0,0(s3)
    80003660:	ebeff0ef          	jal	80002d1e <bread>
    80003664:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003666:	05850493          	addi	s1,a0,88
    8000366a:	45850913          	addi	s2,a0,1112
    8000366e:	a021                	j	80003676 <itrunc+0x72>
    80003670:	0491                	addi	s1,s1,4
    80003672:	01248963          	beq	s1,s2,80003684 <itrunc+0x80>
      if(a[j])
    80003676:	408c                	lw	a1,0(s1)
    80003678:	dde5                	beqz	a1,80003670 <itrunc+0x6c>
        bfree(ip->dev, a[j]);
    8000367a:	0009a503          	lw	a0,0(s3)
    8000367e:	899ff0ef          	jal	80002f16 <bfree>
    80003682:	b7fd                	j	80003670 <itrunc+0x6c>
    brelse(bp);
    80003684:	8552                	mv	a0,s4
    80003686:	fa0ff0ef          	jal	80002e26 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000368a:	07c9a583          	lw	a1,124(s3)
    8000368e:	0009a503          	lw	a0,0(s3)
    80003692:	885ff0ef          	jal	80002f16 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003696:	0609ae23          	sw	zero,124(s3)
    8000369a:	7a02                	ld	s4,32(sp)
    8000369c:	b745                	j	8000363c <itrunc+0x38>
    8000369e:	f052                	sd	s4,32(sp)
    800036a0:	ec56                	sd	s5,24(sp)
    800036a2:	e85a                	sd	s6,16(sp)
    800036a4:	e45e                	sd	s7,8(sp)
    800036a6:	e062                	sd	s8,0(sp)
    bp1 = bread(ip->dev, ip->addrs[NDIRECT+1]);
    800036a8:	0009a503          	lw	a0,0(s3)
    800036ac:	e72ff0ef          	jal	80002d1e <bread>
    800036b0:	8c2a                	mv	s8,a0
    for (j = 0; j < NINDIRECT; j++) {
    800036b2:	05850a13          	addi	s4,a0,88
    800036b6:	45850b13          	addi	s6,a0,1112
    800036ba:	a03d                	j	800036e8 <itrunc+0xe4>
        for (int k = 0; k < NINDIRECT; k++) {
    800036bc:	0491                	addi	s1,s1,4
    800036be:	01248963          	beq	s1,s2,800036d0 <itrunc+0xcc>
          if (a2[k])
    800036c2:	408c                	lw	a1,0(s1)
    800036c4:	dde5                	beqz	a1,800036bc <itrunc+0xb8>
            bfree(ip->dev, a2[k]);
    800036c6:	0009a503          	lw	a0,0(s3)
    800036ca:	84dff0ef          	jal	80002f16 <bfree>
    800036ce:	b7fd                	j	800036bc <itrunc+0xb8>
        brelse(bp2);
    800036d0:	855e                	mv	a0,s7
    800036d2:	f54ff0ef          	jal	80002e26 <brelse>
        bfree(ip->dev, a1[j]);
    800036d6:	000aa583          	lw	a1,0(s5)
    800036da:	0009a503          	lw	a0,0(s3)
    800036de:	839ff0ef          	jal	80002f16 <bfree>
    for (j = 0; j < NINDIRECT; j++) {
    800036e2:	0a11                	addi	s4,s4,4
    800036e4:	036a0063          	beq	s4,s6,80003704 <itrunc+0x100>
      if(a1[j]) { // 두 번째 indirect block에서 가리키는 direct block 할당 해제
    800036e8:	8ad2                	mv	s5,s4
    800036ea:	000a2583          	lw	a1,0(s4)
    800036ee:	d9f5                	beqz	a1,800036e2 <itrunc+0xde>
        bp2 = bread(ip->dev, a1[j]);
    800036f0:	0009a503          	lw	a0,0(s3)
    800036f4:	e2aff0ef          	jal	80002d1e <bread>
    800036f8:	8baa                	mv	s7,a0
        for (int k = 0; k < NINDIRECT; k++) {
    800036fa:	05850493          	addi	s1,a0,88
    800036fe:	45850913          	addi	s2,a0,1112
    80003702:	b7c1                	j	800036c2 <itrunc+0xbe>
    brelse(bp1);
    80003704:	8562                	mv	a0,s8
    80003706:	f20ff0ef          	jal	80002e26 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    8000370a:	0809a583          	lw	a1,128(s3)
    8000370e:	0009a503          	lw	a0,0(s3)
    80003712:	805ff0ef          	jal	80002f16 <bfree>
    ip->addrs[NDIRECT+1] = 0;
    80003716:	0809a023          	sw	zero,128(s3)
    8000371a:	7a02                	ld	s4,32(sp)
    8000371c:	6ae2                	ld	s5,24(sp)
    8000371e:	6b42                	ld	s6,16(sp)
    80003720:	6ba2                	ld	s7,8(sp)
    80003722:	6c02                	ld	s8,0(sp)
    80003724:	bf39                	j	80003642 <itrunc+0x3e>

0000000080003726 <iput>:
{
    80003726:	1101                	addi	sp,sp,-32
    80003728:	ec06                	sd	ra,24(sp)
    8000372a:	e822                	sd	s0,16(sp)
    8000372c:	e426                	sd	s1,8(sp)
    8000372e:	1000                	addi	s0,sp,32
    80003730:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003732:	0045d517          	auipc	a0,0x45d
    80003736:	38e50513          	addi	a0,a0,910 # 80460ac0 <itable>
    8000373a:	e00fd0ef          	jal	80000d3a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000373e:	4498                	lw	a4,8(s1)
    80003740:	4785                	li	a5,1
    80003742:	02f70063          	beq	a4,a5,80003762 <iput+0x3c>
  ip->ref--;
    80003746:	449c                	lw	a5,8(s1)
    80003748:	37fd                	addiw	a5,a5,-1
    8000374a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000374c:	0045d517          	auipc	a0,0x45d
    80003750:	37450513          	addi	a0,a0,884 # 80460ac0 <itable>
    80003754:	e7efd0ef          	jal	80000dd2 <release>
}
    80003758:	60e2                	ld	ra,24(sp)
    8000375a:	6442                	ld	s0,16(sp)
    8000375c:	64a2                	ld	s1,8(sp)
    8000375e:	6105                	addi	sp,sp,32
    80003760:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003762:	40bc                	lw	a5,64(s1)
    80003764:	d3ed                	beqz	a5,80003746 <iput+0x20>
    80003766:	04a49783          	lh	a5,74(s1)
    8000376a:	fff1                	bnez	a5,80003746 <iput+0x20>
    8000376c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000376e:	01048913          	addi	s2,s1,16
    80003772:	854a                	mv	a0,s2
    80003774:	153000ef          	jal	800040c6 <acquiresleep>
    release(&itable.lock);
    80003778:	0045d517          	auipc	a0,0x45d
    8000377c:	34850513          	addi	a0,a0,840 # 80460ac0 <itable>
    80003780:	e52fd0ef          	jal	80000dd2 <release>
    itrunc(ip);
    80003784:	8526                	mv	a0,s1
    80003786:	e7fff0ef          	jal	80003604 <itrunc>
    ip->type = 0;
    8000378a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000378e:	8526                	mv	a0,s1
    80003790:	cd3ff0ef          	jal	80003462 <iupdate>
    ip->valid = 0;
    80003794:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003798:	854a                	mv	a0,s2
    8000379a:	173000ef          	jal	8000410c <releasesleep>
    acquire(&itable.lock);
    8000379e:	0045d517          	auipc	a0,0x45d
    800037a2:	32250513          	addi	a0,a0,802 # 80460ac0 <itable>
    800037a6:	d94fd0ef          	jal	80000d3a <acquire>
    800037aa:	6902                	ld	s2,0(sp)
    800037ac:	bf69                	j	80003746 <iput+0x20>

00000000800037ae <iunlockput>:
{
    800037ae:	1101                	addi	sp,sp,-32
    800037b0:	ec06                	sd	ra,24(sp)
    800037b2:	e822                	sd	s0,16(sp)
    800037b4:	e426                	sd	s1,8(sp)
    800037b6:	1000                	addi	s0,sp,32
    800037b8:	84aa                	mv	s1,a0
  iunlock(ip);
    800037ba:	e0bff0ef          	jal	800035c4 <iunlock>
  iput(ip);
    800037be:	8526                	mv	a0,s1
    800037c0:	f67ff0ef          	jal	80003726 <iput>
}
    800037c4:	60e2                	ld	ra,24(sp)
    800037c6:	6442                	ld	s0,16(sp)
    800037c8:	64a2                	ld	s1,8(sp)
    800037ca:	6105                	addi	sp,sp,32
    800037cc:	8082                	ret

00000000800037ce <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800037ce:	1141                	addi	sp,sp,-16
    800037d0:	e422                	sd	s0,8(sp)
    800037d2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800037d4:	411c                	lw	a5,0(a0)
    800037d6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800037d8:	415c                	lw	a5,4(a0)
    800037da:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800037dc:	04451783          	lh	a5,68(a0)
    800037e0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800037e4:	04a51783          	lh	a5,74(a0)
    800037e8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800037ec:	04c56783          	lwu	a5,76(a0)
    800037f0:	e99c                	sd	a5,16(a1)
}
    800037f2:	6422                	ld	s0,8(sp)
    800037f4:	0141                	addi	sp,sp,16
    800037f6:	8082                	ret

00000000800037f8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800037f8:	457c                	lw	a5,76(a0)
    800037fa:	0ed7eb63          	bltu	a5,a3,800038f0 <readi+0xf8>
{
    800037fe:	7159                	addi	sp,sp,-112
    80003800:	f486                	sd	ra,104(sp)
    80003802:	f0a2                	sd	s0,96(sp)
    80003804:	eca6                	sd	s1,88(sp)
    80003806:	e0d2                	sd	s4,64(sp)
    80003808:	fc56                	sd	s5,56(sp)
    8000380a:	f85a                	sd	s6,48(sp)
    8000380c:	f45e                	sd	s7,40(sp)
    8000380e:	1880                	addi	s0,sp,112
    80003810:	8b2a                	mv	s6,a0
    80003812:	8bae                	mv	s7,a1
    80003814:	8a32                	mv	s4,a2
    80003816:	84b6                	mv	s1,a3
    80003818:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000381a:	9f35                	addw	a4,a4,a3
    return 0;
    8000381c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000381e:	0cd76063          	bltu	a4,a3,800038de <readi+0xe6>
    80003822:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003824:	00e7f463          	bgeu	a5,a4,8000382c <readi+0x34>
    n = ip->size - off;
    80003828:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000382c:	080a8f63          	beqz	s5,800038ca <readi+0xd2>
    80003830:	e8ca                	sd	s2,80(sp)
    80003832:	f062                	sd	s8,32(sp)
    80003834:	ec66                	sd	s9,24(sp)
    80003836:	e86a                	sd	s10,16(sp)
    80003838:	e46e                	sd	s11,8(sp)
    8000383a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000383c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003840:	5c7d                	li	s8,-1
    80003842:	a80d                	j	80003874 <readi+0x7c>
    80003844:	020d1d93          	slli	s11,s10,0x20
    80003848:	020ddd93          	srli	s11,s11,0x20
    8000384c:	05890613          	addi	a2,s2,88
    80003850:	86ee                	mv	a3,s11
    80003852:	963a                	add	a2,a2,a4
    80003854:	85d2                	mv	a1,s4
    80003856:	855e                	mv	a0,s7
    80003858:	b99fe0ef          	jal	800023f0 <either_copyout>
    8000385c:	05850763          	beq	a0,s8,800038aa <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003860:	854a                	mv	a0,s2
    80003862:	dc4ff0ef          	jal	80002e26 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003866:	013d09bb          	addw	s3,s10,s3
    8000386a:	009d04bb          	addw	s1,s10,s1
    8000386e:	9a6e                	add	s4,s4,s11
    80003870:	0559f763          	bgeu	s3,s5,800038be <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80003874:	00a4d59b          	srliw	a1,s1,0xa
    80003878:	855a                	mv	a0,s6
    8000387a:	829ff0ef          	jal	800030a2 <bmap>
    8000387e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003882:	c5b1                	beqz	a1,800038ce <readi+0xd6>
    bp = bread(ip->dev, addr);
    80003884:	000b2503          	lw	a0,0(s6)
    80003888:	c96ff0ef          	jal	80002d1e <bread>
    8000388c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000388e:	3ff4f713          	andi	a4,s1,1023
    80003892:	40ec87bb          	subw	a5,s9,a4
    80003896:	413a86bb          	subw	a3,s5,s3
    8000389a:	8d3e                	mv	s10,a5
    8000389c:	2781                	sext.w	a5,a5
    8000389e:	0006861b          	sext.w	a2,a3
    800038a2:	faf671e3          	bgeu	a2,a5,80003844 <readi+0x4c>
    800038a6:	8d36                	mv	s10,a3
    800038a8:	bf71                	j	80003844 <readi+0x4c>
      brelse(bp);
    800038aa:	854a                	mv	a0,s2
    800038ac:	d7aff0ef          	jal	80002e26 <brelse>
      tot = -1;
    800038b0:	59fd                	li	s3,-1
      break;
    800038b2:	6946                	ld	s2,80(sp)
    800038b4:	7c02                	ld	s8,32(sp)
    800038b6:	6ce2                	ld	s9,24(sp)
    800038b8:	6d42                	ld	s10,16(sp)
    800038ba:	6da2                	ld	s11,8(sp)
    800038bc:	a831                	j	800038d8 <readi+0xe0>
    800038be:	6946                	ld	s2,80(sp)
    800038c0:	7c02                	ld	s8,32(sp)
    800038c2:	6ce2                	ld	s9,24(sp)
    800038c4:	6d42                	ld	s10,16(sp)
    800038c6:	6da2                	ld	s11,8(sp)
    800038c8:	a801                	j	800038d8 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800038ca:	89d6                	mv	s3,s5
    800038cc:	a031                	j	800038d8 <readi+0xe0>
    800038ce:	6946                	ld	s2,80(sp)
    800038d0:	7c02                	ld	s8,32(sp)
    800038d2:	6ce2                	ld	s9,24(sp)
    800038d4:	6d42                	ld	s10,16(sp)
    800038d6:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800038d8:	0009851b          	sext.w	a0,s3
    800038dc:	69a6                	ld	s3,72(sp)
}
    800038de:	70a6                	ld	ra,104(sp)
    800038e0:	7406                	ld	s0,96(sp)
    800038e2:	64e6                	ld	s1,88(sp)
    800038e4:	6a06                	ld	s4,64(sp)
    800038e6:	7ae2                	ld	s5,56(sp)
    800038e8:	7b42                	ld	s6,48(sp)
    800038ea:	7ba2                	ld	s7,40(sp)
    800038ec:	6165                	addi	sp,sp,112
    800038ee:	8082                	ret
    return 0;
    800038f0:	4501                	li	a0,0
}
    800038f2:	8082                	ret

00000000800038f4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800038f4:	457c                	lw	a5,76(a0)
    800038f6:	10d7e163          	bltu	a5,a3,800039f8 <writei+0x104>
{
    800038fa:	7159                	addi	sp,sp,-112
    800038fc:	f486                	sd	ra,104(sp)
    800038fe:	f0a2                	sd	s0,96(sp)
    80003900:	e8ca                	sd	s2,80(sp)
    80003902:	e0d2                	sd	s4,64(sp)
    80003904:	fc56                	sd	s5,56(sp)
    80003906:	f85a                	sd	s6,48(sp)
    80003908:	f45e                	sd	s7,40(sp)
    8000390a:	1880                	addi	s0,sp,112
    8000390c:	8aaa                	mv	s5,a0
    8000390e:	8bae                	mv	s7,a1
    80003910:	8a32                	mv	s4,a2
    80003912:	8936                	mv	s2,a3
    80003914:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003916:	9f35                	addw	a4,a4,a3
    80003918:	0ed76263          	bltu	a4,a3,800039fc <writei+0x108>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000391c:	040437b7          	lui	a5,0x4043
    80003920:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80003924:	0ce7ee63          	bltu	a5,a4,80003a00 <writei+0x10c>
    80003928:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000392a:	0a0b0f63          	beqz	s6,800039e8 <writei+0xf4>
    8000392e:	eca6                	sd	s1,88(sp)
    80003930:	f062                	sd	s8,32(sp)
    80003932:	ec66                	sd	s9,24(sp)
    80003934:	e86a                	sd	s10,16(sp)
    80003936:	e46e                	sd	s11,8(sp)
    80003938:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000393a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000393e:	5c7d                	li	s8,-1
    80003940:	a825                	j	80003978 <writei+0x84>
    80003942:	020d1d93          	slli	s11,s10,0x20
    80003946:	020ddd93          	srli	s11,s11,0x20
    8000394a:	05848513          	addi	a0,s1,88
    8000394e:	86ee                	mv	a3,s11
    80003950:	8652                	mv	a2,s4
    80003952:	85de                	mv	a1,s7
    80003954:	953a                	add	a0,a0,a4
    80003956:	ae5fe0ef          	jal	8000243a <either_copyin>
    8000395a:	05850a63          	beq	a0,s8,800039ae <writei+0xba>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000395e:	8526                	mv	a0,s1
    80003960:	660000ef          	jal	80003fc0 <log_write>
    brelse(bp);
    80003964:	8526                	mv	a0,s1
    80003966:	cc0ff0ef          	jal	80002e26 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000396a:	013d09bb          	addw	s3,s10,s3
    8000396e:	012d093b          	addw	s2,s10,s2
    80003972:	9a6e                	add	s4,s4,s11
    80003974:	0569f063          	bgeu	s3,s6,800039b4 <writei+0xc0>
    uint addr = bmap(ip, off/BSIZE);
    80003978:	00a9559b          	srliw	a1,s2,0xa
    8000397c:	8556                	mv	a0,s5
    8000397e:	f24ff0ef          	jal	800030a2 <bmap>
    80003982:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003986:	c59d                	beqz	a1,800039b4 <writei+0xc0>
    bp = bread(ip->dev, addr);
    80003988:	000aa503          	lw	a0,0(s5)
    8000398c:	b92ff0ef          	jal	80002d1e <bread>
    80003990:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003992:	3ff97713          	andi	a4,s2,1023
    80003996:	40ec87bb          	subw	a5,s9,a4
    8000399a:	413b06bb          	subw	a3,s6,s3
    8000399e:	8d3e                	mv	s10,a5
    800039a0:	2781                	sext.w	a5,a5
    800039a2:	0006861b          	sext.w	a2,a3
    800039a6:	f8f67ee3          	bgeu	a2,a5,80003942 <writei+0x4e>
    800039aa:	8d36                	mv	s10,a3
    800039ac:	bf59                	j	80003942 <writei+0x4e>
      brelse(bp);
    800039ae:	8526                	mv	a0,s1
    800039b0:	c76ff0ef          	jal	80002e26 <brelse>
  }

  if(off > ip->size)
    800039b4:	04caa783          	lw	a5,76(s5)
    800039b8:	0327fa63          	bgeu	a5,s2,800039ec <writei+0xf8>
    ip->size = off;
    800039bc:	052aa623          	sw	s2,76(s5)
    800039c0:	64e6                	ld	s1,88(sp)
    800039c2:	7c02                	ld	s8,32(sp)
    800039c4:	6ce2                	ld	s9,24(sp)
    800039c6:	6d42                	ld	s10,16(sp)
    800039c8:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800039ca:	8556                	mv	a0,s5
    800039cc:	a97ff0ef          	jal	80003462 <iupdate>

  return tot;
    800039d0:	0009851b          	sext.w	a0,s3
    800039d4:	69a6                	ld	s3,72(sp)
}
    800039d6:	70a6                	ld	ra,104(sp)
    800039d8:	7406                	ld	s0,96(sp)
    800039da:	6946                	ld	s2,80(sp)
    800039dc:	6a06                	ld	s4,64(sp)
    800039de:	7ae2                	ld	s5,56(sp)
    800039e0:	7b42                	ld	s6,48(sp)
    800039e2:	7ba2                	ld	s7,40(sp)
    800039e4:	6165                	addi	sp,sp,112
    800039e6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800039e8:	89da                	mv	s3,s6
    800039ea:	b7c5                	j	800039ca <writei+0xd6>
    800039ec:	64e6                	ld	s1,88(sp)
    800039ee:	7c02                	ld	s8,32(sp)
    800039f0:	6ce2                	ld	s9,24(sp)
    800039f2:	6d42                	ld	s10,16(sp)
    800039f4:	6da2                	ld	s11,8(sp)
    800039f6:	bfd1                	j	800039ca <writei+0xd6>
    return -1;
    800039f8:	557d                	li	a0,-1
}
    800039fa:	8082                	ret
    return -1;
    800039fc:	557d                	li	a0,-1
    800039fe:	bfe1                	j	800039d6 <writei+0xe2>
    return -1;
    80003a00:	557d                	li	a0,-1
    80003a02:	bfd1                	j	800039d6 <writei+0xe2>

0000000080003a04 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003a04:	1141                	addi	sp,sp,-16
    80003a06:	e406                	sd	ra,8(sp)
    80003a08:	e022                	sd	s0,0(sp)
    80003a0a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003a0c:	4639                	li	a2,14
    80003a0e:	cccfd0ef          	jal	80000eda <strncmp>
}
    80003a12:	60a2                	ld	ra,8(sp)
    80003a14:	6402                	ld	s0,0(sp)
    80003a16:	0141                	addi	sp,sp,16
    80003a18:	8082                	ret

0000000080003a1a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003a1a:	7139                	addi	sp,sp,-64
    80003a1c:	fc06                	sd	ra,56(sp)
    80003a1e:	f822                	sd	s0,48(sp)
    80003a20:	f426                	sd	s1,40(sp)
    80003a22:	f04a                	sd	s2,32(sp)
    80003a24:	ec4e                	sd	s3,24(sp)
    80003a26:	e852                	sd	s4,16(sp)
    80003a28:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003a2a:	04451703          	lh	a4,68(a0)
    80003a2e:	4785                	li	a5,1
    80003a30:	00f71a63          	bne	a4,a5,80003a44 <dirlookup+0x2a>
    80003a34:	892a                	mv	s2,a0
    80003a36:	89ae                	mv	s3,a1
    80003a38:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a3a:	457c                	lw	a5,76(a0)
    80003a3c:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003a3e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a40:	e39d                	bnez	a5,80003a66 <dirlookup+0x4c>
    80003a42:	a095                	j	80003aa6 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80003a44:	00004517          	auipc	a0,0x4
    80003a48:	b2c50513          	addi	a0,a0,-1236 # 80007570 <etext+0x570>
    80003a4c:	d49fc0ef          	jal	80000794 <panic>
      panic("dirlookup read");
    80003a50:	00004517          	auipc	a0,0x4
    80003a54:	b3850513          	addi	a0,a0,-1224 # 80007588 <etext+0x588>
    80003a58:	d3dfc0ef          	jal	80000794 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003a5c:	24c1                	addiw	s1,s1,16
    80003a5e:	04c92783          	lw	a5,76(s2)
    80003a62:	04f4f163          	bgeu	s1,a5,80003aa4 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a66:	4741                	li	a4,16
    80003a68:	86a6                	mv	a3,s1
    80003a6a:	fc040613          	addi	a2,s0,-64
    80003a6e:	4581                	li	a1,0
    80003a70:	854a                	mv	a0,s2
    80003a72:	d87ff0ef          	jal	800037f8 <readi>
    80003a76:	47c1                	li	a5,16
    80003a78:	fcf51ce3          	bne	a0,a5,80003a50 <dirlookup+0x36>
    if(de.inum == 0)
    80003a7c:	fc045783          	lhu	a5,-64(s0)
    80003a80:	dff1                	beqz	a5,80003a5c <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80003a82:	fc240593          	addi	a1,s0,-62
    80003a86:	854e                	mv	a0,s3
    80003a88:	f7dff0ef          	jal	80003a04 <namecmp>
    80003a8c:	f961                	bnez	a0,80003a5c <dirlookup+0x42>
      if(poff)
    80003a8e:	000a0463          	beqz	s4,80003a96 <dirlookup+0x7c>
        *poff = off;
    80003a92:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003a96:	fc045583          	lhu	a1,-64(s0)
    80003a9a:	00092503          	lw	a0,0(s2)
    80003a9e:	f98ff0ef          	jal	80003236 <iget>
    80003aa2:	a011                	j	80003aa6 <dirlookup+0x8c>
  return 0;
    80003aa4:	4501                	li	a0,0
}
    80003aa6:	70e2                	ld	ra,56(sp)
    80003aa8:	7442                	ld	s0,48(sp)
    80003aaa:	74a2                	ld	s1,40(sp)
    80003aac:	7902                	ld	s2,32(sp)
    80003aae:	69e2                	ld	s3,24(sp)
    80003ab0:	6a42                	ld	s4,16(sp)
    80003ab2:	6121                	addi	sp,sp,64
    80003ab4:	8082                	ret

0000000080003ab6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003ab6:	711d                	addi	sp,sp,-96
    80003ab8:	ec86                	sd	ra,88(sp)
    80003aba:	e8a2                	sd	s0,80(sp)
    80003abc:	e4a6                	sd	s1,72(sp)
    80003abe:	e0ca                	sd	s2,64(sp)
    80003ac0:	fc4e                	sd	s3,56(sp)
    80003ac2:	f852                	sd	s4,48(sp)
    80003ac4:	f456                	sd	s5,40(sp)
    80003ac6:	f05a                	sd	s6,32(sp)
    80003ac8:	ec5e                	sd	s7,24(sp)
    80003aca:	e862                	sd	s8,16(sp)
    80003acc:	e466                	sd	s9,8(sp)
    80003ace:	1080                	addi	s0,sp,96
    80003ad0:	84aa                	mv	s1,a0
    80003ad2:	8b2e                	mv	s6,a1
    80003ad4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/') // 절대 경로인 경우에 root directory부터 시작
    80003ad6:	00054703          	lbu	a4,0(a0)
    80003ada:	02f00793          	li	a5,47
    80003ade:	00f70e63          	beq	a4,a5,80003afa <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else // 상대 경로인 경우, 현재 diretory부터 시작
    ip = idup(myproc()->cwd);
    80003ae2:	fe5fd0ef          	jal	80001ac6 <myproc>
    80003ae6:	15053503          	ld	a0,336(a0)
    80003aea:	9f7ff0ef          	jal	800034e0 <idup>
    80003aee:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003af0:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80003af4:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    // inode가 directory인지 확인
    if(ip->type != T_DIR){
    80003af6:	4b85                	li	s7,1
    80003af8:	a871                	j	80003b94 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    80003afa:	4585                	li	a1,1
    80003afc:	4505                	li	a0,1
    80003afe:	f38ff0ef          	jal	80003236 <iget>
    80003b02:	8a2a                	mv	s4,a0
    80003b04:	b7f5                	j	80003af0 <namex+0x3a>
      iunlockput(ip);
    80003b06:	8552                	mv	a0,s4
    80003b08:	ca7ff0ef          	jal	800037ae <iunlockput>
      return 0;
    80003b0c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003b0e:	8552                	mv	a0,s4
    80003b10:	60e6                	ld	ra,88(sp)
    80003b12:	6446                	ld	s0,80(sp)
    80003b14:	64a6                	ld	s1,72(sp)
    80003b16:	6906                	ld	s2,64(sp)
    80003b18:	79e2                	ld	s3,56(sp)
    80003b1a:	7a42                	ld	s4,48(sp)
    80003b1c:	7aa2                	ld	s5,40(sp)
    80003b1e:	7b02                	ld	s6,32(sp)
    80003b20:	6be2                	ld	s7,24(sp)
    80003b22:	6c42                	ld	s8,16(sp)
    80003b24:	6ca2                	ld	s9,8(sp)
    80003b26:	6125                	addi	sp,sp,96
    80003b28:	8082                	ret
      iunlock(ip);
    80003b2a:	8552                	mv	a0,s4
    80003b2c:	a99ff0ef          	jal	800035c4 <iunlock>
      return ip;
    80003b30:	bff9                	j	80003b0e <namex+0x58>
      iunlockput(ip);
    80003b32:	8552                	mv	a0,s4
    80003b34:	c7bff0ef          	jal	800037ae <iunlockput>
      return 0;
    80003b38:	8a4e                	mv	s4,s3
    80003b3a:	bfd1                	j	80003b0e <namex+0x58>
  len = path - s;
    80003b3c:	40998633          	sub	a2,s3,s1
    80003b40:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80003b44:	099c5063          	bge	s8,s9,80003bc4 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80003b48:	4639                	li	a2,14
    80003b4a:	85a6                	mv	a1,s1
    80003b4c:	8556                	mv	a0,s5
    80003b4e:	b1cfd0ef          	jal	80000e6a <memmove>
    80003b52:	84ce                	mv	s1,s3
  while(*path == '/')
    80003b54:	0004c783          	lbu	a5,0(s1)
    80003b58:	01279763          	bne	a5,s2,80003b66 <namex+0xb0>
    path++;
    80003b5c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003b5e:	0004c783          	lbu	a5,0(s1)
    80003b62:	ff278de3          	beq	a5,s2,80003b5c <namex+0xa6>
    ilock(ip);
    80003b66:	8552                	mv	a0,s4
    80003b68:	9afff0ef          	jal	80003516 <ilock>
    if(ip->type != T_DIR){
    80003b6c:	044a1783          	lh	a5,68(s4)
    80003b70:	f9779be3          	bne	a5,s7,80003b06 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80003b74:	000b0563          	beqz	s6,80003b7e <namex+0xc8>
    80003b78:	0004c783          	lbu	a5,0(s1)
    80003b7c:	d7dd                	beqz	a5,80003b2a <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003b7e:	4601                	li	a2,0
    80003b80:	85d6                	mv	a1,s5
    80003b82:	8552                	mv	a0,s4
    80003b84:	e97ff0ef          	jal	80003a1a <dirlookup>
    80003b88:	89aa                	mv	s3,a0
    80003b8a:	d545                	beqz	a0,80003b32 <namex+0x7c>
    iunlockput(ip);
    80003b8c:	8552                	mv	a0,s4
    80003b8e:	c21ff0ef          	jal	800037ae <iunlockput>
    ip = next;
    80003b92:	8a4e                	mv	s4,s3
  while(*path == '/')
    80003b94:	0004c783          	lbu	a5,0(s1)
    80003b98:	01279763          	bne	a5,s2,80003ba6 <namex+0xf0>
    path++;
    80003b9c:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003b9e:	0004c783          	lbu	a5,0(s1)
    80003ba2:	ff278de3          	beq	a5,s2,80003b9c <namex+0xe6>
  if(*path == 0)
    80003ba6:	cb8d                	beqz	a5,80003bd8 <namex+0x122>
  while(*path != '/' && *path != 0)
    80003ba8:	0004c783          	lbu	a5,0(s1)
    80003bac:	89a6                	mv	s3,s1
  len = path - s;
    80003bae:	4c81                	li	s9,0
    80003bb0:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80003bb2:	01278963          	beq	a5,s2,80003bc4 <namex+0x10e>
    80003bb6:	d3d9                	beqz	a5,80003b3c <namex+0x86>
    path++;
    80003bb8:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80003bba:	0009c783          	lbu	a5,0(s3)
    80003bbe:	ff279ce3          	bne	a5,s2,80003bb6 <namex+0x100>
    80003bc2:	bfad                	j	80003b3c <namex+0x86>
    memmove(name, s, len);
    80003bc4:	2601                	sext.w	a2,a2
    80003bc6:	85a6                	mv	a1,s1
    80003bc8:	8556                	mv	a0,s5
    80003bca:	aa0fd0ef          	jal	80000e6a <memmove>
    name[len] = 0;
    80003bce:	9cd6                	add	s9,s9,s5
    80003bd0:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80003bd4:	84ce                	mv	s1,s3
    80003bd6:	bfbd                	j	80003b54 <namex+0x9e>
  if(nameiparent){
    80003bd8:	f20b0be3          	beqz	s6,80003b0e <namex+0x58>
    iput(ip);
    80003bdc:	8552                	mv	a0,s4
    80003bde:	b49ff0ef          	jal	80003726 <iput>
    return 0;
    80003be2:	4a01                	li	s4,0
    80003be4:	b72d                	j	80003b0e <namex+0x58>

0000000080003be6 <dirlink>:
{
    80003be6:	7139                	addi	sp,sp,-64
    80003be8:	fc06                	sd	ra,56(sp)
    80003bea:	f822                	sd	s0,48(sp)
    80003bec:	f04a                	sd	s2,32(sp)
    80003bee:	ec4e                	sd	s3,24(sp)
    80003bf0:	e852                	sd	s4,16(sp)
    80003bf2:	0080                	addi	s0,sp,64
    80003bf4:	892a                	mv	s2,a0
    80003bf6:	8a2e                	mv	s4,a1
    80003bf8:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003bfa:	4601                	li	a2,0
    80003bfc:	e1fff0ef          	jal	80003a1a <dirlookup>
    80003c00:	e535                	bnez	a0,80003c6c <dirlink+0x86>
    80003c02:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c04:	04c92483          	lw	s1,76(s2)
    80003c08:	c48d                	beqz	s1,80003c32 <dirlink+0x4c>
    80003c0a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c0c:	4741                	li	a4,16
    80003c0e:	86a6                	mv	a3,s1
    80003c10:	fc040613          	addi	a2,s0,-64
    80003c14:	4581                	li	a1,0
    80003c16:	854a                	mv	a0,s2
    80003c18:	be1ff0ef          	jal	800037f8 <readi>
    80003c1c:	47c1                	li	a5,16
    80003c1e:	04f51b63          	bne	a0,a5,80003c74 <dirlink+0x8e>
    if(de.inum == 0)
    80003c22:	fc045783          	lhu	a5,-64(s0)
    80003c26:	c791                	beqz	a5,80003c32 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003c28:	24c1                	addiw	s1,s1,16
    80003c2a:	04c92783          	lw	a5,76(s2)
    80003c2e:	fcf4efe3          	bltu	s1,a5,80003c0c <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80003c32:	4639                	li	a2,14
    80003c34:	85d2                	mv	a1,s4
    80003c36:	fc240513          	addi	a0,s0,-62
    80003c3a:	ad6fd0ef          	jal	80000f10 <strncpy>
  de.inum = inum;
    80003c3e:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003c42:	4741                	li	a4,16
    80003c44:	86a6                	mv	a3,s1
    80003c46:	fc040613          	addi	a2,s0,-64
    80003c4a:	4581                	li	a1,0
    80003c4c:	854a                	mv	a0,s2
    80003c4e:	ca7ff0ef          	jal	800038f4 <writei>
    80003c52:	1541                	addi	a0,a0,-16
    80003c54:	00a03533          	snez	a0,a0
    80003c58:	40a00533          	neg	a0,a0
    80003c5c:	74a2                	ld	s1,40(sp)
}
    80003c5e:	70e2                	ld	ra,56(sp)
    80003c60:	7442                	ld	s0,48(sp)
    80003c62:	7902                	ld	s2,32(sp)
    80003c64:	69e2                	ld	s3,24(sp)
    80003c66:	6a42                	ld	s4,16(sp)
    80003c68:	6121                	addi	sp,sp,64
    80003c6a:	8082                	ret
    iput(ip);
    80003c6c:	abbff0ef          	jal	80003726 <iput>
    return -1;
    80003c70:	557d                	li	a0,-1
    80003c72:	b7f5                	j	80003c5e <dirlink+0x78>
      panic("dirlink read");
    80003c74:	00004517          	auipc	a0,0x4
    80003c78:	92450513          	addi	a0,a0,-1756 # 80007598 <etext+0x598>
    80003c7c:	b19fc0ef          	jal	80000794 <panic>

0000000080003c80 <namei>:

struct inode*
namei(char *path)
{
    80003c80:	1101                	addi	sp,sp,-32
    80003c82:	ec06                	sd	ra,24(sp)
    80003c84:	e822                	sd	s0,16(sp)
    80003c86:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003c88:	fe040613          	addi	a2,s0,-32
    80003c8c:	4581                	li	a1,0
    80003c8e:	e29ff0ef          	jal	80003ab6 <namex>
}
    80003c92:	60e2                	ld	ra,24(sp)
    80003c94:	6442                	ld	s0,16(sp)
    80003c96:	6105                	addi	sp,sp,32
    80003c98:	8082                	ret

0000000080003c9a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80003c9a:	1141                	addi	sp,sp,-16
    80003c9c:	e406                	sd	ra,8(sp)
    80003c9e:	e022                	sd	s0,0(sp)
    80003ca0:	0800                	addi	s0,sp,16
    80003ca2:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003ca4:	4585                	li	a1,1
    80003ca6:	e11ff0ef          	jal	80003ab6 <namex>
}
    80003caa:	60a2                	ld	ra,8(sp)
    80003cac:	6402                	ld	s0,0(sp)
    80003cae:	0141                	addi	sp,sp,16
    80003cb0:	8082                	ret

0000000080003cb2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003cb2:	1101                	addi	sp,sp,-32
    80003cb4:	ec06                	sd	ra,24(sp)
    80003cb6:	e822                	sd	s0,16(sp)
    80003cb8:	e426                	sd	s1,8(sp)
    80003cba:	e04a                	sd	s2,0(sp)
    80003cbc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003cbe:	0045f917          	auipc	s2,0x45f
    80003cc2:	8aa90913          	addi	s2,s2,-1878 # 80462568 <log>
    80003cc6:	01892583          	lw	a1,24(s2)
    80003cca:	02892503          	lw	a0,40(s2)
    80003cce:	850ff0ef          	jal	80002d1e <bread>
    80003cd2:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003cd4:	02c92603          	lw	a2,44(s2)
    80003cd8:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003cda:	00c05f63          	blez	a2,80003cf8 <write_head+0x46>
    80003cde:	0045f717          	auipc	a4,0x45f
    80003ce2:	8ba70713          	addi	a4,a4,-1862 # 80462598 <log+0x30>
    80003ce6:	87aa                	mv	a5,a0
    80003ce8:	060a                	slli	a2,a2,0x2
    80003cea:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003cec:	4314                	lw	a3,0(a4)
    80003cee:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003cf0:	0711                	addi	a4,a4,4
    80003cf2:	0791                	addi	a5,a5,4
    80003cf4:	fec79ce3          	bne	a5,a2,80003cec <write_head+0x3a>
  }
  bwrite(buf);
    80003cf8:	8526                	mv	a0,s1
    80003cfa:	8faff0ef          	jal	80002df4 <bwrite>
  brelse(buf);
    80003cfe:	8526                	mv	a0,s1
    80003d00:	926ff0ef          	jal	80002e26 <brelse>
}
    80003d04:	60e2                	ld	ra,24(sp)
    80003d06:	6442                	ld	s0,16(sp)
    80003d08:	64a2                	ld	s1,8(sp)
    80003d0a:	6902                	ld	s2,0(sp)
    80003d0c:	6105                	addi	sp,sp,32
    80003d0e:	8082                	ret

0000000080003d10 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d10:	0045f797          	auipc	a5,0x45f
    80003d14:	8847a783          	lw	a5,-1916(a5) # 80462594 <log+0x2c>
    80003d18:	08f05f63          	blez	a5,80003db6 <install_trans+0xa6>
{
    80003d1c:	7139                	addi	sp,sp,-64
    80003d1e:	fc06                	sd	ra,56(sp)
    80003d20:	f822                	sd	s0,48(sp)
    80003d22:	f426                	sd	s1,40(sp)
    80003d24:	f04a                	sd	s2,32(sp)
    80003d26:	ec4e                	sd	s3,24(sp)
    80003d28:	e852                	sd	s4,16(sp)
    80003d2a:	e456                	sd	s5,8(sp)
    80003d2c:	e05a                	sd	s6,0(sp)
    80003d2e:	0080                	addi	s0,sp,64
    80003d30:	8b2a                	mv	s6,a0
    80003d32:	0045fa97          	auipc	s5,0x45f
    80003d36:	866a8a93          	addi	s5,s5,-1946 # 80462598 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d3a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003d3c:	0045f997          	auipc	s3,0x45f
    80003d40:	82c98993          	addi	s3,s3,-2004 # 80462568 <log>
    80003d44:	a829                	j	80003d5e <install_trans+0x4e>
    brelse(lbuf);
    80003d46:	854a                	mv	a0,s2
    80003d48:	8deff0ef          	jal	80002e26 <brelse>
    brelse(dbuf);
    80003d4c:	8526                	mv	a0,s1
    80003d4e:	8d8ff0ef          	jal	80002e26 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d52:	2a05                	addiw	s4,s4,1
    80003d54:	0a91                	addi	s5,s5,4
    80003d56:	02c9a783          	lw	a5,44(s3)
    80003d5a:	04fa5463          	bge	s4,a5,80003da2 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003d5e:	0189a583          	lw	a1,24(s3)
    80003d62:	014585bb          	addw	a1,a1,s4
    80003d66:	2585                	addiw	a1,a1,1
    80003d68:	0289a503          	lw	a0,40(s3)
    80003d6c:	fb3fe0ef          	jal	80002d1e <bread>
    80003d70:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003d72:	000aa583          	lw	a1,0(s5)
    80003d76:	0289a503          	lw	a0,40(s3)
    80003d7a:	fa5fe0ef          	jal	80002d1e <bread>
    80003d7e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003d80:	40000613          	li	a2,1024
    80003d84:	05890593          	addi	a1,s2,88
    80003d88:	05850513          	addi	a0,a0,88
    80003d8c:	8defd0ef          	jal	80000e6a <memmove>
    bwrite(dbuf);  // write dst to disk
    80003d90:	8526                	mv	a0,s1
    80003d92:	862ff0ef          	jal	80002df4 <bwrite>
    if(recovering == 0)
    80003d96:	fa0b18e3          	bnez	s6,80003d46 <install_trans+0x36>
      bunpin(dbuf);
    80003d9a:	8526                	mv	a0,s1
    80003d9c:	946ff0ef          	jal	80002ee2 <bunpin>
    80003da0:	b75d                	j	80003d46 <install_trans+0x36>
}
    80003da2:	70e2                	ld	ra,56(sp)
    80003da4:	7442                	ld	s0,48(sp)
    80003da6:	74a2                	ld	s1,40(sp)
    80003da8:	7902                	ld	s2,32(sp)
    80003daa:	69e2                	ld	s3,24(sp)
    80003dac:	6a42                	ld	s4,16(sp)
    80003dae:	6aa2                	ld	s5,8(sp)
    80003db0:	6b02                	ld	s6,0(sp)
    80003db2:	6121                	addi	sp,sp,64
    80003db4:	8082                	ret
    80003db6:	8082                	ret

0000000080003db8 <initlog>:
{
    80003db8:	7179                	addi	sp,sp,-48
    80003dba:	f406                	sd	ra,40(sp)
    80003dbc:	f022                	sd	s0,32(sp)
    80003dbe:	ec26                	sd	s1,24(sp)
    80003dc0:	e84a                	sd	s2,16(sp)
    80003dc2:	e44e                	sd	s3,8(sp)
    80003dc4:	1800                	addi	s0,sp,48
    80003dc6:	892a                	mv	s2,a0
    80003dc8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003dca:	0045e497          	auipc	s1,0x45e
    80003dce:	79e48493          	addi	s1,s1,1950 # 80462568 <log>
    80003dd2:	00003597          	auipc	a1,0x3
    80003dd6:	7d658593          	addi	a1,a1,2006 # 800075a8 <etext+0x5a8>
    80003dda:	8526                	mv	a0,s1
    80003ddc:	edffc0ef          	jal	80000cba <initlock>
  log.start = sb->logstart;
    80003de0:	0149a583          	lw	a1,20(s3)
    80003de4:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003de6:	0109a783          	lw	a5,16(s3)
    80003dea:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003dec:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003df0:	854a                	mv	a0,s2
    80003df2:	f2dfe0ef          	jal	80002d1e <bread>
  log.lh.n = lh->n;
    80003df6:	4d30                	lw	a2,88(a0)
    80003df8:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003dfa:	00c05f63          	blez	a2,80003e18 <initlog+0x60>
    80003dfe:	87aa                	mv	a5,a0
    80003e00:	0045e717          	auipc	a4,0x45e
    80003e04:	79870713          	addi	a4,a4,1944 # 80462598 <log+0x30>
    80003e08:	060a                	slli	a2,a2,0x2
    80003e0a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003e0c:	4ff4                	lw	a3,92(a5)
    80003e0e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003e10:	0791                	addi	a5,a5,4
    80003e12:	0711                	addi	a4,a4,4
    80003e14:	fec79ce3          	bne	a5,a2,80003e0c <initlog+0x54>
  brelse(buf);
    80003e18:	80eff0ef          	jal	80002e26 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003e1c:	4505                	li	a0,1
    80003e1e:	ef3ff0ef          	jal	80003d10 <install_trans>
  log.lh.n = 0;
    80003e22:	0045e797          	auipc	a5,0x45e
    80003e26:	7607a923          	sw	zero,1906(a5) # 80462594 <log+0x2c>
  write_head(); // clear the log
    80003e2a:	e89ff0ef          	jal	80003cb2 <write_head>
}
    80003e2e:	70a2                	ld	ra,40(sp)
    80003e30:	7402                	ld	s0,32(sp)
    80003e32:	64e2                	ld	s1,24(sp)
    80003e34:	6942                	ld	s2,16(sp)
    80003e36:	69a2                	ld	s3,8(sp)
    80003e38:	6145                	addi	sp,sp,48
    80003e3a:	8082                	ret

0000000080003e3c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003e3c:	1101                	addi	sp,sp,-32
    80003e3e:	ec06                	sd	ra,24(sp)
    80003e40:	e822                	sd	s0,16(sp)
    80003e42:	e426                	sd	s1,8(sp)
    80003e44:	e04a                	sd	s2,0(sp)
    80003e46:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003e48:	0045e517          	auipc	a0,0x45e
    80003e4c:	72050513          	addi	a0,a0,1824 # 80462568 <log>
    80003e50:	eebfc0ef          	jal	80000d3a <acquire>
  while(1){
    if(log.committing){
    80003e54:	0045e497          	auipc	s1,0x45e
    80003e58:	71448493          	addi	s1,s1,1812 # 80462568 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003e5c:	4979                	li	s2,30
    80003e5e:	a029                	j	80003e68 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003e60:	85a6                	mv	a1,s1
    80003e62:	8526                	mv	a0,s1
    80003e64:	a30fe0ef          	jal	80002094 <sleep>
    if(log.committing){
    80003e68:	50dc                	lw	a5,36(s1)
    80003e6a:	fbfd                	bnez	a5,80003e60 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003e6c:	5098                	lw	a4,32(s1)
    80003e6e:	2705                	addiw	a4,a4,1
    80003e70:	0027179b          	slliw	a5,a4,0x2
    80003e74:	9fb9                	addw	a5,a5,a4
    80003e76:	0017979b          	slliw	a5,a5,0x1
    80003e7a:	54d4                	lw	a3,44(s1)
    80003e7c:	9fb5                	addw	a5,a5,a3
    80003e7e:	00f95763          	bge	s2,a5,80003e8c <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003e82:	85a6                	mv	a1,s1
    80003e84:	8526                	mv	a0,s1
    80003e86:	a0efe0ef          	jal	80002094 <sleep>
    80003e8a:	bff9                	j	80003e68 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003e8c:	0045e517          	auipc	a0,0x45e
    80003e90:	6dc50513          	addi	a0,a0,1756 # 80462568 <log>
    80003e94:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80003e96:	f3dfc0ef          	jal	80000dd2 <release>
      break;
    }
  }
}
    80003e9a:	60e2                	ld	ra,24(sp)
    80003e9c:	6442                	ld	s0,16(sp)
    80003e9e:	64a2                	ld	s1,8(sp)
    80003ea0:	6902                	ld	s2,0(sp)
    80003ea2:	6105                	addi	sp,sp,32
    80003ea4:	8082                	ret

0000000080003ea6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003ea6:	7139                	addi	sp,sp,-64
    80003ea8:	fc06                	sd	ra,56(sp)
    80003eaa:	f822                	sd	s0,48(sp)
    80003eac:	f426                	sd	s1,40(sp)
    80003eae:	f04a                	sd	s2,32(sp)
    80003eb0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003eb2:	0045e497          	auipc	s1,0x45e
    80003eb6:	6b648493          	addi	s1,s1,1718 # 80462568 <log>
    80003eba:	8526                	mv	a0,s1
    80003ebc:	e7ffc0ef          	jal	80000d3a <acquire>
  log.outstanding -= 1;
    80003ec0:	509c                	lw	a5,32(s1)
    80003ec2:	37fd                	addiw	a5,a5,-1
    80003ec4:	0007891b          	sext.w	s2,a5
    80003ec8:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003eca:	50dc                	lw	a5,36(s1)
    80003ecc:	ef9d                	bnez	a5,80003f0a <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80003ece:	04091763          	bnez	s2,80003f1c <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003ed2:	0045e497          	auipc	s1,0x45e
    80003ed6:	69648493          	addi	s1,s1,1686 # 80462568 <log>
    80003eda:	4785                	li	a5,1
    80003edc:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003ede:	8526                	mv	a0,s1
    80003ee0:	ef3fc0ef          	jal	80000dd2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003ee4:	54dc                	lw	a5,44(s1)
    80003ee6:	04f04b63          	bgtz	a5,80003f3c <end_op+0x96>
    acquire(&log.lock);
    80003eea:	0045e497          	auipc	s1,0x45e
    80003eee:	67e48493          	addi	s1,s1,1662 # 80462568 <log>
    80003ef2:	8526                	mv	a0,s1
    80003ef4:	e47fc0ef          	jal	80000d3a <acquire>
    log.committing = 0;
    80003ef8:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003efc:	8526                	mv	a0,s1
    80003efe:	9e2fe0ef          	jal	800020e0 <wakeup>
    release(&log.lock);
    80003f02:	8526                	mv	a0,s1
    80003f04:	ecffc0ef          	jal	80000dd2 <release>
}
    80003f08:	a025                	j	80003f30 <end_op+0x8a>
    80003f0a:	ec4e                	sd	s3,24(sp)
    80003f0c:	e852                	sd	s4,16(sp)
    80003f0e:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003f10:	00003517          	auipc	a0,0x3
    80003f14:	6a050513          	addi	a0,a0,1696 # 800075b0 <etext+0x5b0>
    80003f18:	87dfc0ef          	jal	80000794 <panic>
    wakeup(&log);
    80003f1c:	0045e497          	auipc	s1,0x45e
    80003f20:	64c48493          	addi	s1,s1,1612 # 80462568 <log>
    80003f24:	8526                	mv	a0,s1
    80003f26:	9bafe0ef          	jal	800020e0 <wakeup>
  release(&log.lock);
    80003f2a:	8526                	mv	a0,s1
    80003f2c:	ea7fc0ef          	jal	80000dd2 <release>
}
    80003f30:	70e2                	ld	ra,56(sp)
    80003f32:	7442                	ld	s0,48(sp)
    80003f34:	74a2                	ld	s1,40(sp)
    80003f36:	7902                	ld	s2,32(sp)
    80003f38:	6121                	addi	sp,sp,64
    80003f3a:	8082                	ret
    80003f3c:	ec4e                	sd	s3,24(sp)
    80003f3e:	e852                	sd	s4,16(sp)
    80003f40:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f42:	0045ea97          	auipc	s5,0x45e
    80003f46:	656a8a93          	addi	s5,s5,1622 # 80462598 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003f4a:	0045ea17          	auipc	s4,0x45e
    80003f4e:	61ea0a13          	addi	s4,s4,1566 # 80462568 <log>
    80003f52:	018a2583          	lw	a1,24(s4)
    80003f56:	012585bb          	addw	a1,a1,s2
    80003f5a:	2585                	addiw	a1,a1,1
    80003f5c:	028a2503          	lw	a0,40(s4)
    80003f60:	dbffe0ef          	jal	80002d1e <bread>
    80003f64:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003f66:	000aa583          	lw	a1,0(s5)
    80003f6a:	028a2503          	lw	a0,40(s4)
    80003f6e:	db1fe0ef          	jal	80002d1e <bread>
    80003f72:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003f74:	40000613          	li	a2,1024
    80003f78:	05850593          	addi	a1,a0,88
    80003f7c:	05848513          	addi	a0,s1,88
    80003f80:	eebfc0ef          	jal	80000e6a <memmove>
    bwrite(to);  // write the log
    80003f84:	8526                	mv	a0,s1
    80003f86:	e6ffe0ef          	jal	80002df4 <bwrite>
    brelse(from);
    80003f8a:	854e                	mv	a0,s3
    80003f8c:	e9bfe0ef          	jal	80002e26 <brelse>
    brelse(to);
    80003f90:	8526                	mv	a0,s1
    80003f92:	e95fe0ef          	jal	80002e26 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f96:	2905                	addiw	s2,s2,1
    80003f98:	0a91                	addi	s5,s5,4
    80003f9a:	02ca2783          	lw	a5,44(s4)
    80003f9e:	faf94ae3          	blt	s2,a5,80003f52 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003fa2:	d11ff0ef          	jal	80003cb2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003fa6:	4501                	li	a0,0
    80003fa8:	d69ff0ef          	jal	80003d10 <install_trans>
    log.lh.n = 0;
    80003fac:	0045e797          	auipc	a5,0x45e
    80003fb0:	5e07a423          	sw	zero,1512(a5) # 80462594 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003fb4:	cffff0ef          	jal	80003cb2 <write_head>
    80003fb8:	69e2                	ld	s3,24(sp)
    80003fba:	6a42                	ld	s4,16(sp)
    80003fbc:	6aa2                	ld	s5,8(sp)
    80003fbe:	b735                	j	80003eea <end_op+0x44>

0000000080003fc0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003fc0:	1101                	addi	sp,sp,-32
    80003fc2:	ec06                	sd	ra,24(sp)
    80003fc4:	e822                	sd	s0,16(sp)
    80003fc6:	e426                	sd	s1,8(sp)
    80003fc8:	e04a                	sd	s2,0(sp)
    80003fca:	1000                	addi	s0,sp,32
    80003fcc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003fce:	0045e917          	auipc	s2,0x45e
    80003fd2:	59a90913          	addi	s2,s2,1434 # 80462568 <log>
    80003fd6:	854a                	mv	a0,s2
    80003fd8:	d63fc0ef          	jal	80000d3a <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003fdc:	02c92603          	lw	a2,44(s2)
    80003fe0:	47f5                	li	a5,29
    80003fe2:	06c7c363          	blt	a5,a2,80004048 <log_write+0x88>
    80003fe6:	0045e797          	auipc	a5,0x45e
    80003fea:	59e7a783          	lw	a5,1438(a5) # 80462584 <log+0x1c>
    80003fee:	37fd                	addiw	a5,a5,-1
    80003ff0:	04f65c63          	bge	a2,a5,80004048 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003ff4:	0045e797          	auipc	a5,0x45e
    80003ff8:	5947a783          	lw	a5,1428(a5) # 80462588 <log+0x20>
    80003ffc:	04f05c63          	blez	a5,80004054 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004000:	4781                	li	a5,0
    80004002:	04c05f63          	blez	a2,80004060 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004006:	44cc                	lw	a1,12(s1)
    80004008:	0045e717          	auipc	a4,0x45e
    8000400c:	59070713          	addi	a4,a4,1424 # 80462598 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004010:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004012:	4314                	lw	a3,0(a4)
    80004014:	04b68663          	beq	a3,a1,80004060 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80004018:	2785                	addiw	a5,a5,1
    8000401a:	0711                	addi	a4,a4,4
    8000401c:	fef61be3          	bne	a2,a5,80004012 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004020:	0621                	addi	a2,a2,8
    80004022:	060a                	slli	a2,a2,0x2
    80004024:	0045e797          	auipc	a5,0x45e
    80004028:	54478793          	addi	a5,a5,1348 # 80462568 <log>
    8000402c:	97b2                	add	a5,a5,a2
    8000402e:	44d8                	lw	a4,12(s1)
    80004030:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004032:	8526                	mv	a0,s1
    80004034:	e7bfe0ef          	jal	80002eae <bpin>
    log.lh.n++;
    80004038:	0045e717          	auipc	a4,0x45e
    8000403c:	53070713          	addi	a4,a4,1328 # 80462568 <log>
    80004040:	575c                	lw	a5,44(a4)
    80004042:	2785                	addiw	a5,a5,1
    80004044:	d75c                	sw	a5,44(a4)
    80004046:	a80d                	j	80004078 <log_write+0xb8>
    panic("too big a transaction");
    80004048:	00003517          	auipc	a0,0x3
    8000404c:	57850513          	addi	a0,a0,1400 # 800075c0 <etext+0x5c0>
    80004050:	f44fc0ef          	jal	80000794 <panic>
    panic("log_write outside of trans");
    80004054:	00003517          	auipc	a0,0x3
    80004058:	58450513          	addi	a0,a0,1412 # 800075d8 <etext+0x5d8>
    8000405c:	f38fc0ef          	jal	80000794 <panic>
  log.lh.block[i] = b->blockno;
    80004060:	00878693          	addi	a3,a5,8
    80004064:	068a                	slli	a3,a3,0x2
    80004066:	0045e717          	auipc	a4,0x45e
    8000406a:	50270713          	addi	a4,a4,1282 # 80462568 <log>
    8000406e:	9736                	add	a4,a4,a3
    80004070:	44d4                	lw	a3,12(s1)
    80004072:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004074:	faf60fe3          	beq	a2,a5,80004032 <log_write+0x72>
  }
  release(&log.lock);
    80004078:	0045e517          	auipc	a0,0x45e
    8000407c:	4f050513          	addi	a0,a0,1264 # 80462568 <log>
    80004080:	d53fc0ef          	jal	80000dd2 <release>
}
    80004084:	60e2                	ld	ra,24(sp)
    80004086:	6442                	ld	s0,16(sp)
    80004088:	64a2                	ld	s1,8(sp)
    8000408a:	6902                	ld	s2,0(sp)
    8000408c:	6105                	addi	sp,sp,32
    8000408e:	8082                	ret

0000000080004090 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004090:	1101                	addi	sp,sp,-32
    80004092:	ec06                	sd	ra,24(sp)
    80004094:	e822                	sd	s0,16(sp)
    80004096:	e426                	sd	s1,8(sp)
    80004098:	e04a                	sd	s2,0(sp)
    8000409a:	1000                	addi	s0,sp,32
    8000409c:	84aa                	mv	s1,a0
    8000409e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800040a0:	00003597          	auipc	a1,0x3
    800040a4:	55858593          	addi	a1,a1,1368 # 800075f8 <etext+0x5f8>
    800040a8:	0521                	addi	a0,a0,8
    800040aa:	c11fc0ef          	jal	80000cba <initlock>
  lk->name = name;
    800040ae:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800040b2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800040b6:	0204a423          	sw	zero,40(s1)
}
    800040ba:	60e2                	ld	ra,24(sp)
    800040bc:	6442                	ld	s0,16(sp)
    800040be:	64a2                	ld	s1,8(sp)
    800040c0:	6902                	ld	s2,0(sp)
    800040c2:	6105                	addi	sp,sp,32
    800040c4:	8082                	ret

00000000800040c6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800040c6:	1101                	addi	sp,sp,-32
    800040c8:	ec06                	sd	ra,24(sp)
    800040ca:	e822                	sd	s0,16(sp)
    800040cc:	e426                	sd	s1,8(sp)
    800040ce:	e04a                	sd	s2,0(sp)
    800040d0:	1000                	addi	s0,sp,32
    800040d2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800040d4:	00850913          	addi	s2,a0,8
    800040d8:	854a                	mv	a0,s2
    800040da:	c61fc0ef          	jal	80000d3a <acquire>
  while (lk->locked) {
    800040de:	409c                	lw	a5,0(s1)
    800040e0:	c799                	beqz	a5,800040ee <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800040e2:	85ca                	mv	a1,s2
    800040e4:	8526                	mv	a0,s1
    800040e6:	faffd0ef          	jal	80002094 <sleep>
  while (lk->locked) {
    800040ea:	409c                	lw	a5,0(s1)
    800040ec:	fbfd                	bnez	a5,800040e2 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800040ee:	4785                	li	a5,1
    800040f0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800040f2:	9d5fd0ef          	jal	80001ac6 <myproc>
    800040f6:	591c                	lw	a5,48(a0)
    800040f8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800040fa:	854a                	mv	a0,s2
    800040fc:	cd7fc0ef          	jal	80000dd2 <release>
}
    80004100:	60e2                	ld	ra,24(sp)
    80004102:	6442                	ld	s0,16(sp)
    80004104:	64a2                	ld	s1,8(sp)
    80004106:	6902                	ld	s2,0(sp)
    80004108:	6105                	addi	sp,sp,32
    8000410a:	8082                	ret

000000008000410c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000410c:	1101                	addi	sp,sp,-32
    8000410e:	ec06                	sd	ra,24(sp)
    80004110:	e822                	sd	s0,16(sp)
    80004112:	e426                	sd	s1,8(sp)
    80004114:	e04a                	sd	s2,0(sp)
    80004116:	1000                	addi	s0,sp,32
    80004118:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000411a:	00850913          	addi	s2,a0,8
    8000411e:	854a                	mv	a0,s2
    80004120:	c1bfc0ef          	jal	80000d3a <acquire>
  lk->locked = 0;
    80004124:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004128:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000412c:	8526                	mv	a0,s1
    8000412e:	fb3fd0ef          	jal	800020e0 <wakeup>
  release(&lk->lk);
    80004132:	854a                	mv	a0,s2
    80004134:	c9ffc0ef          	jal	80000dd2 <release>
}
    80004138:	60e2                	ld	ra,24(sp)
    8000413a:	6442                	ld	s0,16(sp)
    8000413c:	64a2                	ld	s1,8(sp)
    8000413e:	6902                	ld	s2,0(sp)
    80004140:	6105                	addi	sp,sp,32
    80004142:	8082                	ret

0000000080004144 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004144:	7179                	addi	sp,sp,-48
    80004146:	f406                	sd	ra,40(sp)
    80004148:	f022                	sd	s0,32(sp)
    8000414a:	ec26                	sd	s1,24(sp)
    8000414c:	e84a                	sd	s2,16(sp)
    8000414e:	1800                	addi	s0,sp,48
    80004150:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004152:	00850913          	addi	s2,a0,8
    80004156:	854a                	mv	a0,s2
    80004158:	be3fc0ef          	jal	80000d3a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000415c:	409c                	lw	a5,0(s1)
    8000415e:	ef81                	bnez	a5,80004176 <holdingsleep+0x32>
    80004160:	4481                	li	s1,0
  release(&lk->lk);
    80004162:	854a                	mv	a0,s2
    80004164:	c6ffc0ef          	jal	80000dd2 <release>
  return r;
}
    80004168:	8526                	mv	a0,s1
    8000416a:	70a2                	ld	ra,40(sp)
    8000416c:	7402                	ld	s0,32(sp)
    8000416e:	64e2                	ld	s1,24(sp)
    80004170:	6942                	ld	s2,16(sp)
    80004172:	6145                	addi	sp,sp,48
    80004174:	8082                	ret
    80004176:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004178:	0284a983          	lw	s3,40(s1)
    8000417c:	94bfd0ef          	jal	80001ac6 <myproc>
    80004180:	5904                	lw	s1,48(a0)
    80004182:	413484b3          	sub	s1,s1,s3
    80004186:	0014b493          	seqz	s1,s1
    8000418a:	69a2                	ld	s3,8(sp)
    8000418c:	bfd9                	j	80004162 <holdingsleep+0x1e>

000000008000418e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000418e:	1141                	addi	sp,sp,-16
    80004190:	e406                	sd	ra,8(sp)
    80004192:	e022                	sd	s0,0(sp)
    80004194:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004196:	00003597          	auipc	a1,0x3
    8000419a:	47258593          	addi	a1,a1,1138 # 80007608 <etext+0x608>
    8000419e:	0045e517          	auipc	a0,0x45e
    800041a2:	51250513          	addi	a0,a0,1298 # 804626b0 <ftable>
    800041a6:	b15fc0ef          	jal	80000cba <initlock>
}
    800041aa:	60a2                	ld	ra,8(sp)
    800041ac:	6402                	ld	s0,0(sp)
    800041ae:	0141                	addi	sp,sp,16
    800041b0:	8082                	ret

00000000800041b2 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800041b2:	1101                	addi	sp,sp,-32
    800041b4:	ec06                	sd	ra,24(sp)
    800041b6:	e822                	sd	s0,16(sp)
    800041b8:	e426                	sd	s1,8(sp)
    800041ba:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800041bc:	0045e517          	auipc	a0,0x45e
    800041c0:	4f450513          	addi	a0,a0,1268 # 804626b0 <ftable>
    800041c4:	b77fc0ef          	jal	80000d3a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800041c8:	0045e497          	auipc	s1,0x45e
    800041cc:	50048493          	addi	s1,s1,1280 # 804626c8 <ftable+0x18>
    800041d0:	0045f717          	auipc	a4,0x45f
    800041d4:	49870713          	addi	a4,a4,1176 # 80463668 <disk>
    if(f->ref == 0){
    800041d8:	40dc                	lw	a5,4(s1)
    800041da:	cf89                	beqz	a5,800041f4 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800041dc:	02848493          	addi	s1,s1,40
    800041e0:	fee49ce3          	bne	s1,a4,800041d8 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800041e4:	0045e517          	auipc	a0,0x45e
    800041e8:	4cc50513          	addi	a0,a0,1228 # 804626b0 <ftable>
    800041ec:	be7fc0ef          	jal	80000dd2 <release>
  return 0;
    800041f0:	4481                	li	s1,0
    800041f2:	a809                	j	80004204 <filealloc+0x52>
      f->ref = 1;
    800041f4:	4785                	li	a5,1
    800041f6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800041f8:	0045e517          	auipc	a0,0x45e
    800041fc:	4b850513          	addi	a0,a0,1208 # 804626b0 <ftable>
    80004200:	bd3fc0ef          	jal	80000dd2 <release>
}
    80004204:	8526                	mv	a0,s1
    80004206:	60e2                	ld	ra,24(sp)
    80004208:	6442                	ld	s0,16(sp)
    8000420a:	64a2                	ld	s1,8(sp)
    8000420c:	6105                	addi	sp,sp,32
    8000420e:	8082                	ret

0000000080004210 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004210:	1101                	addi	sp,sp,-32
    80004212:	ec06                	sd	ra,24(sp)
    80004214:	e822                	sd	s0,16(sp)
    80004216:	e426                	sd	s1,8(sp)
    80004218:	1000                	addi	s0,sp,32
    8000421a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000421c:	0045e517          	auipc	a0,0x45e
    80004220:	49450513          	addi	a0,a0,1172 # 804626b0 <ftable>
    80004224:	b17fc0ef          	jal	80000d3a <acquire>
  if(f->ref < 1)
    80004228:	40dc                	lw	a5,4(s1)
    8000422a:	02f05063          	blez	a5,8000424a <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000422e:	2785                	addiw	a5,a5,1
    80004230:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004232:	0045e517          	auipc	a0,0x45e
    80004236:	47e50513          	addi	a0,a0,1150 # 804626b0 <ftable>
    8000423a:	b99fc0ef          	jal	80000dd2 <release>
  return f;
}
    8000423e:	8526                	mv	a0,s1
    80004240:	60e2                	ld	ra,24(sp)
    80004242:	6442                	ld	s0,16(sp)
    80004244:	64a2                	ld	s1,8(sp)
    80004246:	6105                	addi	sp,sp,32
    80004248:	8082                	ret
    panic("filedup");
    8000424a:	00003517          	auipc	a0,0x3
    8000424e:	3c650513          	addi	a0,a0,966 # 80007610 <etext+0x610>
    80004252:	d42fc0ef          	jal	80000794 <panic>

0000000080004256 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004256:	7139                	addi	sp,sp,-64
    80004258:	fc06                	sd	ra,56(sp)
    8000425a:	f822                	sd	s0,48(sp)
    8000425c:	f426                	sd	s1,40(sp)
    8000425e:	0080                	addi	s0,sp,64
    80004260:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004262:	0045e517          	auipc	a0,0x45e
    80004266:	44e50513          	addi	a0,a0,1102 # 804626b0 <ftable>
    8000426a:	ad1fc0ef          	jal	80000d3a <acquire>
  if(f->ref < 1)
    8000426e:	40dc                	lw	a5,4(s1)
    80004270:	04f05a63          	blez	a5,800042c4 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004274:	37fd                	addiw	a5,a5,-1
    80004276:	0007871b          	sext.w	a4,a5
    8000427a:	c0dc                	sw	a5,4(s1)
    8000427c:	04e04e63          	bgtz	a4,800042d8 <fileclose+0x82>
    80004280:	f04a                	sd	s2,32(sp)
    80004282:	ec4e                	sd	s3,24(sp)
    80004284:	e852                	sd	s4,16(sp)
    80004286:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004288:	0004a903          	lw	s2,0(s1)
    8000428c:	0094ca83          	lbu	s5,9(s1)
    80004290:	0104ba03          	ld	s4,16(s1)
    80004294:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004298:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000429c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800042a0:	0045e517          	auipc	a0,0x45e
    800042a4:	41050513          	addi	a0,a0,1040 # 804626b0 <ftable>
    800042a8:	b2bfc0ef          	jal	80000dd2 <release>

  if(ff.type == FD_PIPE){
    800042ac:	4785                	li	a5,1
    800042ae:	04f90063          	beq	s2,a5,800042ee <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800042b2:	3979                	addiw	s2,s2,-2
    800042b4:	4785                	li	a5,1
    800042b6:	0527f563          	bgeu	a5,s2,80004300 <fileclose+0xaa>
    800042ba:	7902                	ld	s2,32(sp)
    800042bc:	69e2                	ld	s3,24(sp)
    800042be:	6a42                	ld	s4,16(sp)
    800042c0:	6aa2                	ld	s5,8(sp)
    800042c2:	a00d                	j	800042e4 <fileclose+0x8e>
    800042c4:	f04a                	sd	s2,32(sp)
    800042c6:	ec4e                	sd	s3,24(sp)
    800042c8:	e852                	sd	s4,16(sp)
    800042ca:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800042cc:	00003517          	auipc	a0,0x3
    800042d0:	34c50513          	addi	a0,a0,844 # 80007618 <etext+0x618>
    800042d4:	cc0fc0ef          	jal	80000794 <panic>
    release(&ftable.lock);
    800042d8:	0045e517          	auipc	a0,0x45e
    800042dc:	3d850513          	addi	a0,a0,984 # 804626b0 <ftable>
    800042e0:	af3fc0ef          	jal	80000dd2 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800042e4:	70e2                	ld	ra,56(sp)
    800042e6:	7442                	ld	s0,48(sp)
    800042e8:	74a2                	ld	s1,40(sp)
    800042ea:	6121                	addi	sp,sp,64
    800042ec:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800042ee:	85d6                	mv	a1,s5
    800042f0:	8552                	mv	a0,s4
    800042f2:	336000ef          	jal	80004628 <pipeclose>
    800042f6:	7902                	ld	s2,32(sp)
    800042f8:	69e2                	ld	s3,24(sp)
    800042fa:	6a42                	ld	s4,16(sp)
    800042fc:	6aa2                	ld	s5,8(sp)
    800042fe:	b7dd                	j	800042e4 <fileclose+0x8e>
    begin_op();
    80004300:	b3dff0ef          	jal	80003e3c <begin_op>
    iput(ff.ip);
    80004304:	854e                	mv	a0,s3
    80004306:	c20ff0ef          	jal	80003726 <iput>
    end_op();
    8000430a:	b9dff0ef          	jal	80003ea6 <end_op>
    8000430e:	7902                	ld	s2,32(sp)
    80004310:	69e2                	ld	s3,24(sp)
    80004312:	6a42                	ld	s4,16(sp)
    80004314:	6aa2                	ld	s5,8(sp)
    80004316:	b7f9                	j	800042e4 <fileclose+0x8e>

0000000080004318 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004318:	715d                	addi	sp,sp,-80
    8000431a:	e486                	sd	ra,72(sp)
    8000431c:	e0a2                	sd	s0,64(sp)
    8000431e:	fc26                	sd	s1,56(sp)
    80004320:	f44e                	sd	s3,40(sp)
    80004322:	0880                	addi	s0,sp,80
    80004324:	84aa                	mv	s1,a0
    80004326:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004328:	f9efd0ef          	jal	80001ac6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000432c:	409c                	lw	a5,0(s1)
    8000432e:	37f9                	addiw	a5,a5,-2
    80004330:	4705                	li	a4,1
    80004332:	04f76063          	bltu	a4,a5,80004372 <filestat+0x5a>
    80004336:	f84a                	sd	s2,48(sp)
    80004338:	892a                	mv	s2,a0
    ilock(f->ip);
    8000433a:	6c88                	ld	a0,24(s1)
    8000433c:	9daff0ef          	jal	80003516 <ilock>
    stati(f->ip, &st);
    80004340:	fb840593          	addi	a1,s0,-72
    80004344:	6c88                	ld	a0,24(s1)
    80004346:	c88ff0ef          	jal	800037ce <stati>
    iunlock(f->ip);
    8000434a:	6c88                	ld	a0,24(s1)
    8000434c:	a78ff0ef          	jal	800035c4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004350:	46e1                	li	a3,24
    80004352:	fb840613          	addi	a2,s0,-72
    80004356:	85ce                	mv	a1,s3
    80004358:	05093503          	ld	a0,80(s2)
    8000435c:	b3afd0ef          	jal	80001696 <copyout>
    80004360:	41f5551b          	sraiw	a0,a0,0x1f
    80004364:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004366:	60a6                	ld	ra,72(sp)
    80004368:	6406                	ld	s0,64(sp)
    8000436a:	74e2                	ld	s1,56(sp)
    8000436c:	79a2                	ld	s3,40(sp)
    8000436e:	6161                	addi	sp,sp,80
    80004370:	8082                	ret
  return -1;
    80004372:	557d                	li	a0,-1
    80004374:	bfcd                	j	80004366 <filestat+0x4e>

0000000080004376 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004376:	7179                	addi	sp,sp,-48
    80004378:	f406                	sd	ra,40(sp)
    8000437a:	f022                	sd	s0,32(sp)
    8000437c:	e84a                	sd	s2,16(sp)
    8000437e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004380:	00854783          	lbu	a5,8(a0)
    80004384:	cfd1                	beqz	a5,80004420 <fileread+0xaa>
    80004386:	ec26                	sd	s1,24(sp)
    80004388:	e44e                	sd	s3,8(sp)
    8000438a:	84aa                	mv	s1,a0
    8000438c:	89ae                	mv	s3,a1
    8000438e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004390:	411c                	lw	a5,0(a0)
    80004392:	4705                	li	a4,1
    80004394:	04e78363          	beq	a5,a4,800043da <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004398:	470d                	li	a4,3
    8000439a:	04e78763          	beq	a5,a4,800043e8 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000439e:	4709                	li	a4,2
    800043a0:	06e79a63          	bne	a5,a4,80004414 <fileread+0x9e>
    ilock(f->ip);
    800043a4:	6d08                	ld	a0,24(a0)
    800043a6:	970ff0ef          	jal	80003516 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800043aa:	874a                	mv	a4,s2
    800043ac:	5094                	lw	a3,32(s1)
    800043ae:	864e                	mv	a2,s3
    800043b0:	4585                	li	a1,1
    800043b2:	6c88                	ld	a0,24(s1)
    800043b4:	c44ff0ef          	jal	800037f8 <readi>
    800043b8:	892a                	mv	s2,a0
    800043ba:	00a05563          	blez	a0,800043c4 <fileread+0x4e>
      f->off += r;
    800043be:	509c                	lw	a5,32(s1)
    800043c0:	9fa9                	addw	a5,a5,a0
    800043c2:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800043c4:	6c88                	ld	a0,24(s1)
    800043c6:	9feff0ef          	jal	800035c4 <iunlock>
    800043ca:	64e2                	ld	s1,24(sp)
    800043cc:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800043ce:	854a                	mv	a0,s2
    800043d0:	70a2                	ld	ra,40(sp)
    800043d2:	7402                	ld	s0,32(sp)
    800043d4:	6942                	ld	s2,16(sp)
    800043d6:	6145                	addi	sp,sp,48
    800043d8:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800043da:	6908                	ld	a0,16(a0)
    800043dc:	388000ef          	jal	80004764 <piperead>
    800043e0:	892a                	mv	s2,a0
    800043e2:	64e2                	ld	s1,24(sp)
    800043e4:	69a2                	ld	s3,8(sp)
    800043e6:	b7e5                	j	800043ce <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800043e8:	02451783          	lh	a5,36(a0)
    800043ec:	03079693          	slli	a3,a5,0x30
    800043f0:	92c1                	srli	a3,a3,0x30
    800043f2:	4725                	li	a4,9
    800043f4:	02d76863          	bltu	a4,a3,80004424 <fileread+0xae>
    800043f8:	0792                	slli	a5,a5,0x4
    800043fa:	0045e717          	auipc	a4,0x45e
    800043fe:	21670713          	addi	a4,a4,534 # 80462610 <devsw>
    80004402:	97ba                	add	a5,a5,a4
    80004404:	639c                	ld	a5,0(a5)
    80004406:	c39d                	beqz	a5,8000442c <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004408:	4505                	li	a0,1
    8000440a:	9782                	jalr	a5
    8000440c:	892a                	mv	s2,a0
    8000440e:	64e2                	ld	s1,24(sp)
    80004410:	69a2                	ld	s3,8(sp)
    80004412:	bf75                	j	800043ce <fileread+0x58>
    panic("fileread");
    80004414:	00003517          	auipc	a0,0x3
    80004418:	21450513          	addi	a0,a0,532 # 80007628 <etext+0x628>
    8000441c:	b78fc0ef          	jal	80000794 <panic>
    return -1;
    80004420:	597d                	li	s2,-1
    80004422:	b775                	j	800043ce <fileread+0x58>
      return -1;
    80004424:	597d                	li	s2,-1
    80004426:	64e2                	ld	s1,24(sp)
    80004428:	69a2                	ld	s3,8(sp)
    8000442a:	b755                	j	800043ce <fileread+0x58>
    8000442c:	597d                	li	s2,-1
    8000442e:	64e2                	ld	s1,24(sp)
    80004430:	69a2                	ld	s3,8(sp)
    80004432:	bf71                	j	800043ce <fileread+0x58>

0000000080004434 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004434:	00954783          	lbu	a5,9(a0)
    80004438:	10078b63          	beqz	a5,8000454e <filewrite+0x11a>
{
    8000443c:	715d                	addi	sp,sp,-80
    8000443e:	e486                	sd	ra,72(sp)
    80004440:	e0a2                	sd	s0,64(sp)
    80004442:	f84a                	sd	s2,48(sp)
    80004444:	f052                	sd	s4,32(sp)
    80004446:	e85a                	sd	s6,16(sp)
    80004448:	0880                	addi	s0,sp,80
    8000444a:	892a                	mv	s2,a0
    8000444c:	8b2e                	mv	s6,a1
    8000444e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004450:	411c                	lw	a5,0(a0)
    80004452:	4705                	li	a4,1
    80004454:	02e78763          	beq	a5,a4,80004482 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004458:	470d                	li	a4,3
    8000445a:	02e78863          	beq	a5,a4,8000448a <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000445e:	4709                	li	a4,2
    80004460:	0ce79c63          	bne	a5,a4,80004538 <filewrite+0x104>
    80004464:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004466:	0ac05863          	blez	a2,80004516 <filewrite+0xe2>
    8000446a:	fc26                	sd	s1,56(sp)
    8000446c:	ec56                	sd	s5,24(sp)
    8000446e:	e45e                	sd	s7,8(sp)
    80004470:	e062                	sd	s8,0(sp)
    int i = 0;
    80004472:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004474:	6b85                	lui	s7,0x1
    80004476:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    8000447a:	6c05                	lui	s8,0x1
    8000447c:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004480:	a8b5                	j	800044fc <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004482:	6908                	ld	a0,16(a0)
    80004484:	1fc000ef          	jal	80004680 <pipewrite>
    80004488:	a04d                	j	8000452a <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000448a:	02451783          	lh	a5,36(a0)
    8000448e:	03079693          	slli	a3,a5,0x30
    80004492:	92c1                	srli	a3,a3,0x30
    80004494:	4725                	li	a4,9
    80004496:	0ad76e63          	bltu	a4,a3,80004552 <filewrite+0x11e>
    8000449a:	0792                	slli	a5,a5,0x4
    8000449c:	0045e717          	auipc	a4,0x45e
    800044a0:	17470713          	addi	a4,a4,372 # 80462610 <devsw>
    800044a4:	97ba                	add	a5,a5,a4
    800044a6:	679c                	ld	a5,8(a5)
    800044a8:	c7dd                	beqz	a5,80004556 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    800044aa:	4505                	li	a0,1
    800044ac:	9782                	jalr	a5
    800044ae:	a8b5                	j	8000452a <filewrite+0xf6>
      if(n1 > max)
    800044b0:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    800044b4:	989ff0ef          	jal	80003e3c <begin_op>
      ilock(f->ip);
    800044b8:	01893503          	ld	a0,24(s2)
    800044bc:	85aff0ef          	jal	80003516 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800044c0:	8756                	mv	a4,s5
    800044c2:	02092683          	lw	a3,32(s2)
    800044c6:	01698633          	add	a2,s3,s6
    800044ca:	4585                	li	a1,1
    800044cc:	01893503          	ld	a0,24(s2)
    800044d0:	c24ff0ef          	jal	800038f4 <writei>
    800044d4:	84aa                	mv	s1,a0
    800044d6:	00a05763          	blez	a0,800044e4 <filewrite+0xb0>
        f->off += r;
    800044da:	02092783          	lw	a5,32(s2)
    800044de:	9fa9                	addw	a5,a5,a0
    800044e0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800044e4:	01893503          	ld	a0,24(s2)
    800044e8:	8dcff0ef          	jal	800035c4 <iunlock>
      end_op();
    800044ec:	9bbff0ef          	jal	80003ea6 <end_op>

      if(r != n1){
    800044f0:	029a9563          	bne	s5,s1,8000451a <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    800044f4:	013489bb          	addw	s3,s1,s3
    while(i < n){
    800044f8:	0149da63          	bge	s3,s4,8000450c <filewrite+0xd8>
      int n1 = n - i;
    800044fc:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004500:	0004879b          	sext.w	a5,s1
    80004504:	fafbd6e3          	bge	s7,a5,800044b0 <filewrite+0x7c>
    80004508:	84e2                	mv	s1,s8
    8000450a:	b75d                	j	800044b0 <filewrite+0x7c>
    8000450c:	74e2                	ld	s1,56(sp)
    8000450e:	6ae2                	ld	s5,24(sp)
    80004510:	6ba2                	ld	s7,8(sp)
    80004512:	6c02                	ld	s8,0(sp)
    80004514:	a039                	j	80004522 <filewrite+0xee>
    int i = 0;
    80004516:	4981                	li	s3,0
    80004518:	a029                	j	80004522 <filewrite+0xee>
    8000451a:	74e2                	ld	s1,56(sp)
    8000451c:	6ae2                	ld	s5,24(sp)
    8000451e:	6ba2                	ld	s7,8(sp)
    80004520:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004522:	033a1c63          	bne	s4,s3,8000455a <filewrite+0x126>
    80004526:	8552                	mv	a0,s4
    80004528:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000452a:	60a6                	ld	ra,72(sp)
    8000452c:	6406                	ld	s0,64(sp)
    8000452e:	7942                	ld	s2,48(sp)
    80004530:	7a02                	ld	s4,32(sp)
    80004532:	6b42                	ld	s6,16(sp)
    80004534:	6161                	addi	sp,sp,80
    80004536:	8082                	ret
    80004538:	fc26                	sd	s1,56(sp)
    8000453a:	f44e                	sd	s3,40(sp)
    8000453c:	ec56                	sd	s5,24(sp)
    8000453e:	e45e                	sd	s7,8(sp)
    80004540:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004542:	00003517          	auipc	a0,0x3
    80004546:	0f650513          	addi	a0,a0,246 # 80007638 <etext+0x638>
    8000454a:	a4afc0ef          	jal	80000794 <panic>
    return -1;
    8000454e:	557d                	li	a0,-1
}
    80004550:	8082                	ret
      return -1;
    80004552:	557d                	li	a0,-1
    80004554:	bfd9                	j	8000452a <filewrite+0xf6>
    80004556:	557d                	li	a0,-1
    80004558:	bfc9                	j	8000452a <filewrite+0xf6>
    ret = (i == n ? n : -1);
    8000455a:	557d                	li	a0,-1
    8000455c:	79a2                	ld	s3,40(sp)
    8000455e:	b7f1                	j	8000452a <filewrite+0xf6>

0000000080004560 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004560:	7179                	addi	sp,sp,-48
    80004562:	f406                	sd	ra,40(sp)
    80004564:	f022                	sd	s0,32(sp)
    80004566:	ec26                	sd	s1,24(sp)
    80004568:	e052                	sd	s4,0(sp)
    8000456a:	1800                	addi	s0,sp,48
    8000456c:	84aa                	mv	s1,a0
    8000456e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004570:	0005b023          	sd	zero,0(a1)
    80004574:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004578:	c3bff0ef          	jal	800041b2 <filealloc>
    8000457c:	e088                	sd	a0,0(s1)
    8000457e:	c549                	beqz	a0,80004608 <pipealloc+0xa8>
    80004580:	c33ff0ef          	jal	800041b2 <filealloc>
    80004584:	00aa3023          	sd	a0,0(s4)
    80004588:	cd25                	beqz	a0,80004600 <pipealloc+0xa0>
    8000458a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000458c:	eacfc0ef          	jal	80000c38 <kalloc>
    80004590:	892a                	mv	s2,a0
    80004592:	c12d                	beqz	a0,800045f4 <pipealloc+0x94>
    80004594:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004596:	4985                	li	s3,1
    80004598:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000459c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800045a0:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800045a4:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800045a8:	00003597          	auipc	a1,0x3
    800045ac:	0a058593          	addi	a1,a1,160 # 80007648 <etext+0x648>
    800045b0:	f0afc0ef          	jal	80000cba <initlock>
  (*f0)->type = FD_PIPE;
    800045b4:	609c                	ld	a5,0(s1)
    800045b6:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800045ba:	609c                	ld	a5,0(s1)
    800045bc:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800045c0:	609c                	ld	a5,0(s1)
    800045c2:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800045c6:	609c                	ld	a5,0(s1)
    800045c8:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800045cc:	000a3783          	ld	a5,0(s4)
    800045d0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800045d4:	000a3783          	ld	a5,0(s4)
    800045d8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800045dc:	000a3783          	ld	a5,0(s4)
    800045e0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800045e4:	000a3783          	ld	a5,0(s4)
    800045e8:	0127b823          	sd	s2,16(a5)
  return 0;
    800045ec:	4501                	li	a0,0
    800045ee:	6942                	ld	s2,16(sp)
    800045f0:	69a2                	ld	s3,8(sp)
    800045f2:	a01d                	j	80004618 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800045f4:	6088                	ld	a0,0(s1)
    800045f6:	c119                	beqz	a0,800045fc <pipealloc+0x9c>
    800045f8:	6942                	ld	s2,16(sp)
    800045fa:	a029                	j	80004604 <pipealloc+0xa4>
    800045fc:	6942                	ld	s2,16(sp)
    800045fe:	a029                	j	80004608 <pipealloc+0xa8>
    80004600:	6088                	ld	a0,0(s1)
    80004602:	c10d                	beqz	a0,80004624 <pipealloc+0xc4>
    fileclose(*f0);
    80004604:	c53ff0ef          	jal	80004256 <fileclose>
  if(*f1)
    80004608:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000460c:	557d                	li	a0,-1
  if(*f1)
    8000460e:	c789                	beqz	a5,80004618 <pipealloc+0xb8>
    fileclose(*f1);
    80004610:	853e                	mv	a0,a5
    80004612:	c45ff0ef          	jal	80004256 <fileclose>
  return -1;
    80004616:	557d                	li	a0,-1
}
    80004618:	70a2                	ld	ra,40(sp)
    8000461a:	7402                	ld	s0,32(sp)
    8000461c:	64e2                	ld	s1,24(sp)
    8000461e:	6a02                	ld	s4,0(sp)
    80004620:	6145                	addi	sp,sp,48
    80004622:	8082                	ret
  return -1;
    80004624:	557d                	li	a0,-1
    80004626:	bfcd                	j	80004618 <pipealloc+0xb8>

0000000080004628 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004628:	1101                	addi	sp,sp,-32
    8000462a:	ec06                	sd	ra,24(sp)
    8000462c:	e822                	sd	s0,16(sp)
    8000462e:	e426                	sd	s1,8(sp)
    80004630:	e04a                	sd	s2,0(sp)
    80004632:	1000                	addi	s0,sp,32
    80004634:	84aa                	mv	s1,a0
    80004636:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004638:	f02fc0ef          	jal	80000d3a <acquire>
  if(writable){
    8000463c:	02090763          	beqz	s2,8000466a <pipeclose+0x42>
    pi->writeopen = 0;
    80004640:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004644:	21848513          	addi	a0,s1,536
    80004648:	a99fd0ef          	jal	800020e0 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000464c:	2204b783          	ld	a5,544(s1)
    80004650:	e785                	bnez	a5,80004678 <pipeclose+0x50>
    release(&pi->lock);
    80004652:	8526                	mv	a0,s1
    80004654:	f7efc0ef          	jal	80000dd2 <release>
    kfree((char*)pi);
    80004658:	8526                	mv	a0,s1
    8000465a:	cacfc0ef          	jal	80000b06 <kfree>
  } else
    release(&pi->lock);
}
    8000465e:	60e2                	ld	ra,24(sp)
    80004660:	6442                	ld	s0,16(sp)
    80004662:	64a2                	ld	s1,8(sp)
    80004664:	6902                	ld	s2,0(sp)
    80004666:	6105                	addi	sp,sp,32
    80004668:	8082                	ret
    pi->readopen = 0;
    8000466a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000466e:	21c48513          	addi	a0,s1,540
    80004672:	a6ffd0ef          	jal	800020e0 <wakeup>
    80004676:	bfd9                	j	8000464c <pipeclose+0x24>
    release(&pi->lock);
    80004678:	8526                	mv	a0,s1
    8000467a:	f58fc0ef          	jal	80000dd2 <release>
}
    8000467e:	b7c5                	j	8000465e <pipeclose+0x36>

0000000080004680 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004680:	711d                	addi	sp,sp,-96
    80004682:	ec86                	sd	ra,88(sp)
    80004684:	e8a2                	sd	s0,80(sp)
    80004686:	e4a6                	sd	s1,72(sp)
    80004688:	e0ca                	sd	s2,64(sp)
    8000468a:	fc4e                	sd	s3,56(sp)
    8000468c:	f852                	sd	s4,48(sp)
    8000468e:	f456                	sd	s5,40(sp)
    80004690:	1080                	addi	s0,sp,96
    80004692:	84aa                	mv	s1,a0
    80004694:	8aae                	mv	s5,a1
    80004696:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004698:	c2efd0ef          	jal	80001ac6 <myproc>
    8000469c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000469e:	8526                	mv	a0,s1
    800046a0:	e9afc0ef          	jal	80000d3a <acquire>
  while(i < n){
    800046a4:	0b405a63          	blez	s4,80004758 <pipewrite+0xd8>
    800046a8:	f05a                	sd	s6,32(sp)
    800046aa:	ec5e                	sd	s7,24(sp)
    800046ac:	e862                	sd	s8,16(sp)
  int i = 0;
    800046ae:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800046b0:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800046b2:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800046b6:	21c48b93          	addi	s7,s1,540
    800046ba:	a81d                	j	800046f0 <pipewrite+0x70>
      release(&pi->lock);
    800046bc:	8526                	mv	a0,s1
    800046be:	f14fc0ef          	jal	80000dd2 <release>
      return -1;
    800046c2:	597d                	li	s2,-1
    800046c4:	7b02                	ld	s6,32(sp)
    800046c6:	6be2                	ld	s7,24(sp)
    800046c8:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800046ca:	854a                	mv	a0,s2
    800046cc:	60e6                	ld	ra,88(sp)
    800046ce:	6446                	ld	s0,80(sp)
    800046d0:	64a6                	ld	s1,72(sp)
    800046d2:	6906                	ld	s2,64(sp)
    800046d4:	79e2                	ld	s3,56(sp)
    800046d6:	7a42                	ld	s4,48(sp)
    800046d8:	7aa2                	ld	s5,40(sp)
    800046da:	6125                	addi	sp,sp,96
    800046dc:	8082                	ret
      wakeup(&pi->nread);
    800046de:	8562                	mv	a0,s8
    800046e0:	a01fd0ef          	jal	800020e0 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800046e4:	85a6                	mv	a1,s1
    800046e6:	855e                	mv	a0,s7
    800046e8:	9adfd0ef          	jal	80002094 <sleep>
  while(i < n){
    800046ec:	05495b63          	bge	s2,s4,80004742 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800046f0:	2204a783          	lw	a5,544(s1)
    800046f4:	d7e1                	beqz	a5,800046bc <pipewrite+0x3c>
    800046f6:	854e                	mv	a0,s3
    800046f8:	bd5fd0ef          	jal	800022cc <killed>
    800046fc:	f161                	bnez	a0,800046bc <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800046fe:	2184a783          	lw	a5,536(s1)
    80004702:	21c4a703          	lw	a4,540(s1)
    80004706:	2007879b          	addiw	a5,a5,512
    8000470a:	fcf70ae3          	beq	a4,a5,800046de <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000470e:	4685                	li	a3,1
    80004710:	01590633          	add	a2,s2,s5
    80004714:	faf40593          	addi	a1,s0,-81
    80004718:	0509b503          	ld	a0,80(s3)
    8000471c:	8f2fd0ef          	jal	8000180e <copyin>
    80004720:	03650e63          	beq	a0,s6,8000475c <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004724:	21c4a783          	lw	a5,540(s1)
    80004728:	0017871b          	addiw	a4,a5,1
    8000472c:	20e4ae23          	sw	a4,540(s1)
    80004730:	1ff7f793          	andi	a5,a5,511
    80004734:	97a6                	add	a5,a5,s1
    80004736:	faf44703          	lbu	a4,-81(s0)
    8000473a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000473e:	2905                	addiw	s2,s2,1
    80004740:	b775                	j	800046ec <pipewrite+0x6c>
    80004742:	7b02                	ld	s6,32(sp)
    80004744:	6be2                	ld	s7,24(sp)
    80004746:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004748:	21848513          	addi	a0,s1,536
    8000474c:	995fd0ef          	jal	800020e0 <wakeup>
  release(&pi->lock);
    80004750:	8526                	mv	a0,s1
    80004752:	e80fc0ef          	jal	80000dd2 <release>
  return i;
    80004756:	bf95                	j	800046ca <pipewrite+0x4a>
  int i = 0;
    80004758:	4901                	li	s2,0
    8000475a:	b7fd                	j	80004748 <pipewrite+0xc8>
    8000475c:	7b02                	ld	s6,32(sp)
    8000475e:	6be2                	ld	s7,24(sp)
    80004760:	6c42                	ld	s8,16(sp)
    80004762:	b7dd                	j	80004748 <pipewrite+0xc8>

0000000080004764 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004764:	715d                	addi	sp,sp,-80
    80004766:	e486                	sd	ra,72(sp)
    80004768:	e0a2                	sd	s0,64(sp)
    8000476a:	fc26                	sd	s1,56(sp)
    8000476c:	f84a                	sd	s2,48(sp)
    8000476e:	f44e                	sd	s3,40(sp)
    80004770:	f052                	sd	s4,32(sp)
    80004772:	ec56                	sd	s5,24(sp)
    80004774:	0880                	addi	s0,sp,80
    80004776:	84aa                	mv	s1,a0
    80004778:	892e                	mv	s2,a1
    8000477a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000477c:	b4afd0ef          	jal	80001ac6 <myproc>
    80004780:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004782:	8526                	mv	a0,s1
    80004784:	db6fc0ef          	jal	80000d3a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004788:	2184a703          	lw	a4,536(s1)
    8000478c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004790:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004794:	02f71563          	bne	a4,a5,800047be <piperead+0x5a>
    80004798:	2244a783          	lw	a5,548(s1)
    8000479c:	cb85                	beqz	a5,800047cc <piperead+0x68>
    if(killed(pr)){
    8000479e:	8552                	mv	a0,s4
    800047a0:	b2dfd0ef          	jal	800022cc <killed>
    800047a4:	ed19                	bnez	a0,800047c2 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800047a6:	85a6                	mv	a1,s1
    800047a8:	854e                	mv	a0,s3
    800047aa:	8ebfd0ef          	jal	80002094 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800047ae:	2184a703          	lw	a4,536(s1)
    800047b2:	21c4a783          	lw	a5,540(s1)
    800047b6:	fef701e3          	beq	a4,a5,80004798 <piperead+0x34>
    800047ba:	e85a                	sd	s6,16(sp)
    800047bc:	a809                	j	800047ce <piperead+0x6a>
    800047be:	e85a                	sd	s6,16(sp)
    800047c0:	a039                	j	800047ce <piperead+0x6a>
      release(&pi->lock);
    800047c2:	8526                	mv	a0,s1
    800047c4:	e0efc0ef          	jal	80000dd2 <release>
      return -1;
    800047c8:	59fd                	li	s3,-1
    800047ca:	a8b1                	j	80004826 <piperead+0xc2>
    800047cc:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800047ce:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800047d0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800047d2:	05505263          	blez	s5,80004816 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800047d6:	2184a783          	lw	a5,536(s1)
    800047da:	21c4a703          	lw	a4,540(s1)
    800047de:	02f70c63          	beq	a4,a5,80004816 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800047e2:	0017871b          	addiw	a4,a5,1
    800047e6:	20e4ac23          	sw	a4,536(s1)
    800047ea:	1ff7f793          	andi	a5,a5,511
    800047ee:	97a6                	add	a5,a5,s1
    800047f0:	0187c783          	lbu	a5,24(a5)
    800047f4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800047f8:	4685                	li	a3,1
    800047fa:	fbf40613          	addi	a2,s0,-65
    800047fe:	85ca                	mv	a1,s2
    80004800:	050a3503          	ld	a0,80(s4)
    80004804:	e93fc0ef          	jal	80001696 <copyout>
    80004808:	01650763          	beq	a0,s6,80004816 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000480c:	2985                	addiw	s3,s3,1
    8000480e:	0905                	addi	s2,s2,1
    80004810:	fd3a93e3          	bne	s5,s3,800047d6 <piperead+0x72>
    80004814:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004816:	21c48513          	addi	a0,s1,540
    8000481a:	8c7fd0ef          	jal	800020e0 <wakeup>
  release(&pi->lock);
    8000481e:	8526                	mv	a0,s1
    80004820:	db2fc0ef          	jal	80000dd2 <release>
    80004824:	6b42                	ld	s6,16(sp)
  return i;
}
    80004826:	854e                	mv	a0,s3
    80004828:	60a6                	ld	ra,72(sp)
    8000482a:	6406                	ld	s0,64(sp)
    8000482c:	74e2                	ld	s1,56(sp)
    8000482e:	7942                	ld	s2,48(sp)
    80004830:	79a2                	ld	s3,40(sp)
    80004832:	7a02                	ld	s4,32(sp)
    80004834:	6ae2                	ld	s5,24(sp)
    80004836:	6161                	addi	sp,sp,80
    80004838:	8082                	ret

000000008000483a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000483a:	1141                	addi	sp,sp,-16
    8000483c:	e422                	sd	s0,8(sp)
    8000483e:	0800                	addi	s0,sp,16
    80004840:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004842:	8905                	andi	a0,a0,1
    80004844:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80004846:	8b89                	andi	a5,a5,2
    80004848:	c399                	beqz	a5,8000484e <flags2perm+0x14>
      perm |= PTE_W;
    8000484a:	00456513          	ori	a0,a0,4
    return perm;
}
    8000484e:	6422                	ld	s0,8(sp)
    80004850:	0141                	addi	sp,sp,16
    80004852:	8082                	ret

0000000080004854 <exec>:

int
exec(char *path, char **argv)
{
    80004854:	df010113          	addi	sp,sp,-528
    80004858:	20113423          	sd	ra,520(sp)
    8000485c:	20813023          	sd	s0,512(sp)
    80004860:	ffa6                	sd	s1,504(sp)
    80004862:	fbca                	sd	s2,496(sp)
    80004864:	0c00                	addi	s0,sp,528
    80004866:	892a                	mv	s2,a0
    80004868:	dea43c23          	sd	a0,-520(s0)
    8000486c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004870:	a56fd0ef          	jal	80001ac6 <myproc>
    80004874:	84aa                	mv	s1,a0

  begin_op();
    80004876:	dc6ff0ef          	jal	80003e3c <begin_op>

  if((ip = namei(path)) == 0){
    8000487a:	854a                	mv	a0,s2
    8000487c:	c04ff0ef          	jal	80003c80 <namei>
    80004880:	c931                	beqz	a0,800048d4 <exec+0x80>
    80004882:	f3d2                	sd	s4,480(sp)
    80004884:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004886:	c91fe0ef          	jal	80003516 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000488a:	04000713          	li	a4,64
    8000488e:	4681                	li	a3,0
    80004890:	e5040613          	addi	a2,s0,-432
    80004894:	4581                	li	a1,0
    80004896:	8552                	mv	a0,s4
    80004898:	f61fe0ef          	jal	800037f8 <readi>
    8000489c:	04000793          	li	a5,64
    800048a0:	00f51a63          	bne	a0,a5,800048b4 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800048a4:	e5042703          	lw	a4,-432(s0)
    800048a8:	464c47b7          	lui	a5,0x464c4
    800048ac:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800048b0:	02f70663          	beq	a4,a5,800048dc <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800048b4:	8552                	mv	a0,s4
    800048b6:	ef9fe0ef          	jal	800037ae <iunlockput>
    end_op();
    800048ba:	decff0ef          	jal	80003ea6 <end_op>
  }
  return -1;
    800048be:	557d                	li	a0,-1
    800048c0:	7a1e                	ld	s4,480(sp)
}
    800048c2:	20813083          	ld	ra,520(sp)
    800048c6:	20013403          	ld	s0,512(sp)
    800048ca:	74fe                	ld	s1,504(sp)
    800048cc:	795e                	ld	s2,496(sp)
    800048ce:	21010113          	addi	sp,sp,528
    800048d2:	8082                	ret
    end_op();
    800048d4:	dd2ff0ef          	jal	80003ea6 <end_op>
    return -1;
    800048d8:	557d                	li	a0,-1
    800048da:	b7e5                	j	800048c2 <exec+0x6e>
    800048dc:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800048de:	8526                	mv	a0,s1
    800048e0:	a8efd0ef          	jal	80001b6e <proc_pagetable>
    800048e4:	8b2a                	mv	s6,a0
    800048e6:	2c050b63          	beqz	a0,80004bbc <exec+0x368>
    800048ea:	f7ce                	sd	s3,488(sp)
    800048ec:	efd6                	sd	s5,472(sp)
    800048ee:	e7de                	sd	s7,456(sp)
    800048f0:	e3e2                	sd	s8,448(sp)
    800048f2:	ff66                	sd	s9,440(sp)
    800048f4:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800048f6:	e7042d03          	lw	s10,-400(s0)
    800048fa:	e8845783          	lhu	a5,-376(s0)
    800048fe:	12078963          	beqz	a5,80004a30 <exec+0x1dc>
    80004902:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004904:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004906:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80004908:	6c85                	lui	s9,0x1
    8000490a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000490e:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004912:	6a85                	lui	s5,0x1
    80004914:	a085                	j	80004974 <exec+0x120>
      panic("loadseg: address should exist");
    80004916:	00003517          	auipc	a0,0x3
    8000491a:	d3a50513          	addi	a0,a0,-710 # 80007650 <etext+0x650>
    8000491e:	e77fb0ef          	jal	80000794 <panic>
    if(sz - i < PGSIZE)
    80004922:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004924:	8726                	mv	a4,s1
    80004926:	012c06bb          	addw	a3,s8,s2
    8000492a:	4581                	li	a1,0
    8000492c:	8552                	mv	a0,s4
    8000492e:	ecbfe0ef          	jal	800037f8 <readi>
    80004932:	2501                	sext.w	a0,a0
    80004934:	24a49a63          	bne	s1,a0,80004b88 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80004938:	012a893b          	addw	s2,s5,s2
    8000493c:	03397363          	bgeu	s2,s3,80004962 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80004940:	02091593          	slli	a1,s2,0x20
    80004944:	9181                	srli	a1,a1,0x20
    80004946:	95de                	add	a1,a1,s7
    80004948:	855a                	mv	a0,s6
    8000494a:	fd2fc0ef          	jal	8000111c <walkaddr>
    8000494e:	862a                	mv	a2,a0
    if(pa == 0)
    80004950:	d179                	beqz	a0,80004916 <exec+0xc2>
    if(sz - i < PGSIZE)
    80004952:	412984bb          	subw	s1,s3,s2
    80004956:	0004879b          	sext.w	a5,s1
    8000495a:	fcfcf4e3          	bgeu	s9,a5,80004922 <exec+0xce>
    8000495e:	84d6                	mv	s1,s5
    80004960:	b7c9                	j	80004922 <exec+0xce>
    sz = sz1;
    80004962:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004966:	2d85                	addiw	s11,s11,1
    80004968:	038d0d1b          	addiw	s10,s10,56
    8000496c:	e8845783          	lhu	a5,-376(s0)
    80004970:	08fdd063          	bge	s11,a5,800049f0 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004974:	2d01                	sext.w	s10,s10
    80004976:	03800713          	li	a4,56
    8000497a:	86ea                	mv	a3,s10
    8000497c:	e1840613          	addi	a2,s0,-488
    80004980:	4581                	li	a1,0
    80004982:	8552                	mv	a0,s4
    80004984:	e75fe0ef          	jal	800037f8 <readi>
    80004988:	03800793          	li	a5,56
    8000498c:	1cf51663          	bne	a0,a5,80004b58 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80004990:	e1842783          	lw	a5,-488(s0)
    80004994:	4705                	li	a4,1
    80004996:	fce798e3          	bne	a5,a4,80004966 <exec+0x112>
    if(ph.memsz < ph.filesz)
    8000499a:	e4043483          	ld	s1,-448(s0)
    8000499e:	e3843783          	ld	a5,-456(s0)
    800049a2:	1af4ef63          	bltu	s1,a5,80004b60 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800049a6:	e2843783          	ld	a5,-472(s0)
    800049aa:	94be                	add	s1,s1,a5
    800049ac:	1af4ee63          	bltu	s1,a5,80004b68 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    800049b0:	df043703          	ld	a4,-528(s0)
    800049b4:	8ff9                	and	a5,a5,a4
    800049b6:	1a079d63          	bnez	a5,80004b70 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800049ba:	e1c42503          	lw	a0,-484(s0)
    800049be:	e7dff0ef          	jal	8000483a <flags2perm>
    800049c2:	86aa                	mv	a3,a0
    800049c4:	8626                	mv	a2,s1
    800049c6:	85ca                	mv	a1,s2
    800049c8:	855a                	mv	a0,s6
    800049ca:	abbfc0ef          	jal	80001484 <uvmalloc>
    800049ce:	e0a43423          	sd	a0,-504(s0)
    800049d2:	1a050363          	beqz	a0,80004b78 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800049d6:	e2843b83          	ld	s7,-472(s0)
    800049da:	e2042c03          	lw	s8,-480(s0)
    800049de:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800049e2:	00098463          	beqz	s3,800049ea <exec+0x196>
    800049e6:	4901                	li	s2,0
    800049e8:	bfa1                	j	80004940 <exec+0xec>
    sz = sz1;
    800049ea:	e0843903          	ld	s2,-504(s0)
    800049ee:	bfa5                	j	80004966 <exec+0x112>
    800049f0:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800049f2:	8552                	mv	a0,s4
    800049f4:	dbbfe0ef          	jal	800037ae <iunlockput>
  end_op();
    800049f8:	caeff0ef          	jal	80003ea6 <end_op>
  p = myproc();
    800049fc:	8cafd0ef          	jal	80001ac6 <myproc>
    80004a00:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004a02:	04853c83          	ld	s9,72(a0)
  sz = PGROUNDUP(sz);
    80004a06:	6985                	lui	s3,0x1
    80004a08:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004a0a:	99ca                	add	s3,s3,s2
    80004a0c:	77fd                	lui	a5,0xfffff
    80004a0e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004a12:	4691                	li	a3,4
    80004a14:	6609                	lui	a2,0x2
    80004a16:	964e                	add	a2,a2,s3
    80004a18:	85ce                	mv	a1,s3
    80004a1a:	855a                	mv	a0,s6
    80004a1c:	a69fc0ef          	jal	80001484 <uvmalloc>
    80004a20:	892a                	mv	s2,a0
    80004a22:	e0a43423          	sd	a0,-504(s0)
    80004a26:	e519                	bnez	a0,80004a34 <exec+0x1e0>
  if(pagetable)
    80004a28:	e1343423          	sd	s3,-504(s0)
    80004a2c:	4a01                	li	s4,0
    80004a2e:	aab1                	j	80004b8a <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004a30:	4901                	li	s2,0
    80004a32:	b7c1                	j	800049f2 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004a34:	75f9                	lui	a1,0xffffe
    80004a36:	95aa                	add	a1,a1,a0
    80004a38:	855a                	mv	a0,s6
    80004a3a:	c33fc0ef          	jal	8000166c <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004a3e:	7bfd                	lui	s7,0xfffff
    80004a40:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80004a42:	e0043783          	ld	a5,-512(s0)
    80004a46:	6388                	ld	a0,0(a5)
    80004a48:	cd39                	beqz	a0,80004aa6 <exec+0x252>
    80004a4a:	e9040993          	addi	s3,s0,-368
    80004a4e:	f9040c13          	addi	s8,s0,-112
    80004a52:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80004a54:	d2afc0ef          	jal	80000f7e <strlen>
    80004a58:	0015079b          	addiw	a5,a0,1
    80004a5c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004a60:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004a64:	11796e63          	bltu	s2,s7,80004b80 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004a68:	e0043d03          	ld	s10,-512(s0)
    80004a6c:	000d3a03          	ld	s4,0(s10)
    80004a70:	8552                	mv	a0,s4
    80004a72:	d0cfc0ef          	jal	80000f7e <strlen>
    80004a76:	0015069b          	addiw	a3,a0,1
    80004a7a:	8652                	mv	a2,s4
    80004a7c:	85ca                	mv	a1,s2
    80004a7e:	855a                	mv	a0,s6
    80004a80:	c17fc0ef          	jal	80001696 <copyout>
    80004a84:	10054063          	bltz	a0,80004b84 <exec+0x330>
    ustack[argc] = sp;
    80004a88:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004a8c:	0485                	addi	s1,s1,1
    80004a8e:	008d0793          	addi	a5,s10,8
    80004a92:	e0f43023          	sd	a5,-512(s0)
    80004a96:	008d3503          	ld	a0,8(s10)
    80004a9a:	c909                	beqz	a0,80004aac <exec+0x258>
    if(argc >= MAXARG)
    80004a9c:	09a1                	addi	s3,s3,8
    80004a9e:	fb899be3          	bne	s3,s8,80004a54 <exec+0x200>
  ip = 0;
    80004aa2:	4a01                	li	s4,0
    80004aa4:	a0dd                	j	80004b8a <exec+0x336>
  sp = sz;
    80004aa6:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80004aaa:	4481                	li	s1,0
  ustack[argc] = 0;
    80004aac:	00349793          	slli	a5,s1,0x3
    80004ab0:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7fb9b7e8>
    80004ab4:	97a2                	add	a5,a5,s0
    80004ab6:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004aba:	00148693          	addi	a3,s1,1
    80004abe:	068e                	slli	a3,a3,0x3
    80004ac0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004ac4:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004ac8:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80004acc:	f5796ee3          	bltu	s2,s7,80004a28 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004ad0:	e9040613          	addi	a2,s0,-368
    80004ad4:	85ca                	mv	a1,s2
    80004ad6:	855a                	mv	a0,s6
    80004ad8:	bbffc0ef          	jal	80001696 <copyout>
    80004adc:	0e054263          	bltz	a0,80004bc0 <exec+0x36c>
  p->trapframe->a1 = sp;
    80004ae0:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004ae4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004ae8:	df843783          	ld	a5,-520(s0)
    80004aec:	0007c703          	lbu	a4,0(a5)
    80004af0:	cf11                	beqz	a4,80004b0c <exec+0x2b8>
    80004af2:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004af4:	02f00693          	li	a3,47
    80004af8:	a039                	j	80004b06 <exec+0x2b2>
      last = s+1;
    80004afa:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004afe:	0785                	addi	a5,a5,1
    80004b00:	fff7c703          	lbu	a4,-1(a5)
    80004b04:	c701                	beqz	a4,80004b0c <exec+0x2b8>
    if(*s == '/')
    80004b06:	fed71ce3          	bne	a4,a3,80004afe <exec+0x2aa>
    80004b0a:	bfc5                	j	80004afa <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    80004b0c:	4641                	li	a2,16
    80004b0e:	df843583          	ld	a1,-520(s0)
    80004b12:	158a8513          	addi	a0,s5,344
    80004b16:	c36fc0ef          	jal	80000f4c <safestrcpy>
  oldpagetable = p->pagetable;
    80004b1a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004b1e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004b22:	e0843783          	ld	a5,-504(s0)
    80004b26:	04fab423          	sd	a5,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004b2a:	058ab783          	ld	a5,88(s5)
    80004b2e:	e6843703          	ld	a4,-408(s0)
    80004b32:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004b34:	058ab783          	ld	a5,88(s5)
    80004b38:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004b3c:	85e6                	mv	a1,s9
    80004b3e:	8b4fd0ef          	jal	80001bf2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004b42:	0004851b          	sext.w	a0,s1
    80004b46:	79be                	ld	s3,488(sp)
    80004b48:	7a1e                	ld	s4,480(sp)
    80004b4a:	6afe                	ld	s5,472(sp)
    80004b4c:	6b5e                	ld	s6,464(sp)
    80004b4e:	6bbe                	ld	s7,456(sp)
    80004b50:	6c1e                	ld	s8,448(sp)
    80004b52:	7cfa                	ld	s9,440(sp)
    80004b54:	7d5a                	ld	s10,432(sp)
    80004b56:	b3b5                	j	800048c2 <exec+0x6e>
    80004b58:	e1243423          	sd	s2,-504(s0)
    80004b5c:	7dba                	ld	s11,424(sp)
    80004b5e:	a035                	j	80004b8a <exec+0x336>
    80004b60:	e1243423          	sd	s2,-504(s0)
    80004b64:	7dba                	ld	s11,424(sp)
    80004b66:	a015                	j	80004b8a <exec+0x336>
    80004b68:	e1243423          	sd	s2,-504(s0)
    80004b6c:	7dba                	ld	s11,424(sp)
    80004b6e:	a831                	j	80004b8a <exec+0x336>
    80004b70:	e1243423          	sd	s2,-504(s0)
    80004b74:	7dba                	ld	s11,424(sp)
    80004b76:	a811                	j	80004b8a <exec+0x336>
    80004b78:	e1243423          	sd	s2,-504(s0)
    80004b7c:	7dba                	ld	s11,424(sp)
    80004b7e:	a031                	j	80004b8a <exec+0x336>
  ip = 0;
    80004b80:	4a01                	li	s4,0
    80004b82:	a021                	j	80004b8a <exec+0x336>
    80004b84:	4a01                	li	s4,0
  if(pagetable)
    80004b86:	a011                	j	80004b8a <exec+0x336>
    80004b88:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80004b8a:	e0843583          	ld	a1,-504(s0)
    80004b8e:	855a                	mv	a0,s6
    80004b90:	862fd0ef          	jal	80001bf2 <proc_freepagetable>
  return -1;
    80004b94:	557d                	li	a0,-1
  if(ip){
    80004b96:	000a1b63          	bnez	s4,80004bac <exec+0x358>
    80004b9a:	79be                	ld	s3,488(sp)
    80004b9c:	7a1e                	ld	s4,480(sp)
    80004b9e:	6afe                	ld	s5,472(sp)
    80004ba0:	6b5e                	ld	s6,464(sp)
    80004ba2:	6bbe                	ld	s7,456(sp)
    80004ba4:	6c1e                	ld	s8,448(sp)
    80004ba6:	7cfa                	ld	s9,440(sp)
    80004ba8:	7d5a                	ld	s10,432(sp)
    80004baa:	bb21                	j	800048c2 <exec+0x6e>
    80004bac:	79be                	ld	s3,488(sp)
    80004bae:	6afe                	ld	s5,472(sp)
    80004bb0:	6b5e                	ld	s6,464(sp)
    80004bb2:	6bbe                	ld	s7,456(sp)
    80004bb4:	6c1e                	ld	s8,448(sp)
    80004bb6:	7cfa                	ld	s9,440(sp)
    80004bb8:	7d5a                	ld	s10,432(sp)
    80004bba:	b9ed                	j	800048b4 <exec+0x60>
    80004bbc:	6b5e                	ld	s6,464(sp)
    80004bbe:	b9dd                	j	800048b4 <exec+0x60>
  sz = sz1;
    80004bc0:	e0843983          	ld	s3,-504(s0)
    80004bc4:	b595                	j	80004a28 <exec+0x1d4>

0000000080004bc6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004bc6:	7179                	addi	sp,sp,-48
    80004bc8:	f406                	sd	ra,40(sp)
    80004bca:	f022                	sd	s0,32(sp)
    80004bcc:	ec26                	sd	s1,24(sp)
    80004bce:	e84a                	sd	s2,16(sp)
    80004bd0:	1800                	addi	s0,sp,48
    80004bd2:	892e                	mv	s2,a1
    80004bd4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004bd6:	fdc40593          	addi	a1,s0,-36
    80004bda:	e51fd0ef          	jal	80002a2a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004bde:	fdc42703          	lw	a4,-36(s0)
    80004be2:	47bd                	li	a5,15
    80004be4:	02e7e963          	bltu	a5,a4,80004c16 <argfd+0x50>
    80004be8:	edffc0ef          	jal	80001ac6 <myproc>
    80004bec:	fdc42703          	lw	a4,-36(s0)
    80004bf0:	01a70793          	addi	a5,a4,26
    80004bf4:	078e                	slli	a5,a5,0x3
    80004bf6:	953e                	add	a0,a0,a5
    80004bf8:	611c                	ld	a5,0(a0)
    80004bfa:	c385                	beqz	a5,80004c1a <argfd+0x54>
    return -1;
  if(pfd)
    80004bfc:	00090463          	beqz	s2,80004c04 <argfd+0x3e>
    *pfd = fd;
    80004c00:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004c04:	4501                	li	a0,0
  if(pf)
    80004c06:	c091                	beqz	s1,80004c0a <argfd+0x44>
    *pf = f;
    80004c08:	e09c                	sd	a5,0(s1)
}
    80004c0a:	70a2                	ld	ra,40(sp)
    80004c0c:	7402                	ld	s0,32(sp)
    80004c0e:	64e2                	ld	s1,24(sp)
    80004c10:	6942                	ld	s2,16(sp)
    80004c12:	6145                	addi	sp,sp,48
    80004c14:	8082                	ret
    return -1;
    80004c16:	557d                	li	a0,-1
    80004c18:	bfcd                	j	80004c0a <argfd+0x44>
    80004c1a:	557d                	li	a0,-1
    80004c1c:	b7fd                	j	80004c0a <argfd+0x44>

0000000080004c1e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004c1e:	1101                	addi	sp,sp,-32
    80004c20:	ec06                	sd	ra,24(sp)
    80004c22:	e822                	sd	s0,16(sp)
    80004c24:	e426                	sd	s1,8(sp)
    80004c26:	1000                	addi	s0,sp,32
    80004c28:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004c2a:	e9dfc0ef          	jal	80001ac6 <myproc>
    80004c2e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004c30:	0d050793          	addi	a5,a0,208
    80004c34:	4501                	li	a0,0
    80004c36:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004c38:	6398                	ld	a4,0(a5)
    80004c3a:	cb19                	beqz	a4,80004c50 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004c3c:	2505                	addiw	a0,a0,1
    80004c3e:	07a1                	addi	a5,a5,8
    80004c40:	fed51ce3          	bne	a0,a3,80004c38 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004c44:	557d                	li	a0,-1
}
    80004c46:	60e2                	ld	ra,24(sp)
    80004c48:	6442                	ld	s0,16(sp)
    80004c4a:	64a2                	ld	s1,8(sp)
    80004c4c:	6105                	addi	sp,sp,32
    80004c4e:	8082                	ret
      p->ofile[fd] = f;
    80004c50:	01a50793          	addi	a5,a0,26
    80004c54:	078e                	slli	a5,a5,0x3
    80004c56:	963e                	add	a2,a2,a5
    80004c58:	e204                	sd	s1,0(a2)
      return fd;
    80004c5a:	b7f5                	j	80004c46 <fdalloc+0x28>

0000000080004c5c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004c5c:	715d                	addi	sp,sp,-80
    80004c5e:	e486                	sd	ra,72(sp)
    80004c60:	e0a2                	sd	s0,64(sp)
    80004c62:	fc26                	sd	s1,56(sp)
    80004c64:	f84a                	sd	s2,48(sp)
    80004c66:	f44e                	sd	s3,40(sp)
    80004c68:	ec56                	sd	s5,24(sp)
    80004c6a:	e85a                	sd	s6,16(sp)
    80004c6c:	0880                	addi	s0,sp,80
    80004c6e:	8b2e                	mv	s6,a1
    80004c70:	89b2                	mv	s3,a2
    80004c72:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  // path에 맞는 부모 directory를 가져옴
  if((dp = nameiparent(path, name)) == 0)
    80004c74:	fb040593          	addi	a1,s0,-80
    80004c78:	822ff0ef          	jal	80003c9a <nameiparent>
    80004c7c:	84aa                	mv	s1,a0
    80004c7e:	10050d63          	beqz	a0,80004d98 <create+0x13c>
    return 0;

  ilock(dp);
    80004c82:	895fe0ef          	jal	80003516 <ilock>
  // 부모 directory에 만들고자 하는 파일과 같은 이름을 가진 파일이 이미 존재하는지 확인
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004c86:	4601                	li	a2,0
    80004c88:	fb040593          	addi	a1,s0,-80
    80004c8c:	8526                	mv	a0,s1
    80004c8e:	d8dfe0ef          	jal	80003a1a <dirlookup>
    80004c92:	8aaa                	mv	s5,a0
    80004c94:	c521                	beqz	a0,80004cdc <create+0x80>
    iunlockput(dp);
    80004c96:	8526                	mv	a0,s1
    80004c98:	b17fe0ef          	jal	800037ae <iunlockput>
    ilock(ip);
    80004c9c:	8556                	mv	a0,s5
    80004c9e:	879fe0ef          	jal	80003516 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004ca2:	4789                	li	a5,2
    80004ca4:	00fb0f63          	beq	s6,a5,80004cc2 <create+0x66>
      return ip;
    // 이미 같은 이름의 symbolic link가 존재하는 경우
    if (type == T_SYMLINK) {
    80004ca8:	4791                	li	a5,4
    80004caa:	02fb1463          	bne	s6,a5,80004cd2 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004cae:	8556                	mv	a0,s5
    80004cb0:	60a6                	ld	ra,72(sp)
    80004cb2:	6406                	ld	s0,64(sp)
    80004cb4:	74e2                	ld	s1,56(sp)
    80004cb6:	7942                	ld	s2,48(sp)
    80004cb8:	79a2                	ld	s3,40(sp)
    80004cba:	6ae2                	ld	s5,24(sp)
    80004cbc:	6b42                	ld	s6,16(sp)
    80004cbe:	6161                	addi	sp,sp,80
    80004cc0:	8082                	ret
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004cc2:	044ad783          	lhu	a5,68(s5)
    80004cc6:	37f9                	addiw	a5,a5,-2
    80004cc8:	17c2                	slli	a5,a5,0x30
    80004cca:	93c1                	srli	a5,a5,0x30
    80004ccc:	4705                	li	a4,1
    80004cce:	fef770e3          	bgeu	a4,a5,80004cae <create+0x52>
    iunlockput(ip);
    80004cd2:	8556                	mv	a0,s5
    80004cd4:	adbfe0ef          	jal	800037ae <iunlockput>
    return 0;
    80004cd8:	4a81                	li	s5,0
    80004cda:	bfd1                	j	80004cae <create+0x52>
    80004cdc:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80004cde:	85da                	mv	a1,s6
    80004ce0:	4088                	lw	a0,0(s1)
    80004ce2:	ec4fe0ef          	jal	800033a6 <ialloc>
    80004ce6:	8a2a                	mv	s4,a0
    80004ce8:	cd15                	beqz	a0,80004d24 <create+0xc8>
  ilock(ip);
    80004cea:	82dfe0ef          	jal	80003516 <ilock>
  ip->major = major;
    80004cee:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80004cf2:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1; // 기본 Link
    80004cf6:	4905                	li	s2,1
    80004cf8:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80004cfc:	8552                	mv	a0,s4
    80004cfe:	f64fe0ef          	jal	80003462 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004d02:	032b0763          	beq	s6,s2,80004d30 <create+0xd4>
  if(dirlink(dp, name, ip->inum) < 0)
    80004d06:	004a2603          	lw	a2,4(s4)
    80004d0a:	fb040593          	addi	a1,s0,-80
    80004d0e:	8526                	mv	a0,s1
    80004d10:	ed7fe0ef          	jal	80003be6 <dirlink>
    80004d14:	06054563          	bltz	a0,80004d7e <create+0x122>
  iunlockput(dp);
    80004d18:	8526                	mv	a0,s1
    80004d1a:	a95fe0ef          	jal	800037ae <iunlockput>
  return ip;
    80004d1e:	8ad2                	mv	s5,s4
    80004d20:	7a02                	ld	s4,32(sp)
    80004d22:	b771                	j	80004cae <create+0x52>
    iunlockput(dp);
    80004d24:	8526                	mv	a0,s1
    80004d26:	a89fe0ef          	jal	800037ae <iunlockput>
    return 0;
    80004d2a:	8ad2                	mv	s5,s4
    80004d2c:	7a02                	ld	s4,32(sp)
    80004d2e:	b741                	j	80004cae <create+0x52>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004d30:	004a2603          	lw	a2,4(s4)
    80004d34:	00003597          	auipc	a1,0x3
    80004d38:	93c58593          	addi	a1,a1,-1732 # 80007670 <etext+0x670>
    80004d3c:	8552                	mv	a0,s4
    80004d3e:	ea9fe0ef          	jal	80003be6 <dirlink>
    80004d42:	02054e63          	bltz	a0,80004d7e <create+0x122>
    80004d46:	40d0                	lw	a2,4(s1)
    80004d48:	00003597          	auipc	a1,0x3
    80004d4c:	93058593          	addi	a1,a1,-1744 # 80007678 <etext+0x678>
    80004d50:	8552                	mv	a0,s4
    80004d52:	e95fe0ef          	jal	80003be6 <dirlink>
    80004d56:	02054463          	bltz	a0,80004d7e <create+0x122>
  if(dirlink(dp, name, ip->inum) < 0)
    80004d5a:	004a2603          	lw	a2,4(s4)
    80004d5e:	fb040593          	addi	a1,s0,-80
    80004d62:	8526                	mv	a0,s1
    80004d64:	e83fe0ef          	jal	80003be6 <dirlink>
    80004d68:	00054b63          	bltz	a0,80004d7e <create+0x122>
    dp->nlink++;  // for ".."
    80004d6c:	04a4d783          	lhu	a5,74(s1)
    80004d70:	2785                	addiw	a5,a5,1
    80004d72:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004d76:	8526                	mv	a0,s1
    80004d78:	eeafe0ef          	jal	80003462 <iupdate>
    80004d7c:	bf71                	j	80004d18 <create+0xbc>
  ip->nlink = 0;
    80004d7e:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004d82:	8552                	mv	a0,s4
    80004d84:	edefe0ef          	jal	80003462 <iupdate>
  iunlockput(ip);
    80004d88:	8552                	mv	a0,s4
    80004d8a:	a25fe0ef          	jal	800037ae <iunlockput>
  iunlockput(dp);
    80004d8e:	8526                	mv	a0,s1
    80004d90:	a1ffe0ef          	jal	800037ae <iunlockput>
  return 0;
    80004d94:	7a02                	ld	s4,32(sp)
    80004d96:	bf21                	j	80004cae <create+0x52>
    return 0;
    80004d98:	8aaa                	mv	s5,a0
    80004d9a:	bf11                	j	80004cae <create+0x52>

0000000080004d9c <sys_dup>:
{
    80004d9c:	7179                	addi	sp,sp,-48
    80004d9e:	f406                	sd	ra,40(sp)
    80004da0:	f022                	sd	s0,32(sp)
    80004da2:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004da4:	fd840613          	addi	a2,s0,-40
    80004da8:	4581                	li	a1,0
    80004daa:	4501                	li	a0,0
    80004dac:	e1bff0ef          	jal	80004bc6 <argfd>
    return -1;
    80004db0:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004db2:	02054363          	bltz	a0,80004dd8 <sys_dup+0x3c>
    80004db6:	ec26                	sd	s1,24(sp)
    80004db8:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004dba:	fd843903          	ld	s2,-40(s0)
    80004dbe:	854a                	mv	a0,s2
    80004dc0:	e5fff0ef          	jal	80004c1e <fdalloc>
    80004dc4:	84aa                	mv	s1,a0
    return -1;
    80004dc6:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004dc8:	00054d63          	bltz	a0,80004de2 <sys_dup+0x46>
  filedup(f);
    80004dcc:	854a                	mv	a0,s2
    80004dce:	c42ff0ef          	jal	80004210 <filedup>
  return fd;
    80004dd2:	87a6                	mv	a5,s1
    80004dd4:	64e2                	ld	s1,24(sp)
    80004dd6:	6942                	ld	s2,16(sp)
}
    80004dd8:	853e                	mv	a0,a5
    80004dda:	70a2                	ld	ra,40(sp)
    80004ddc:	7402                	ld	s0,32(sp)
    80004dde:	6145                	addi	sp,sp,48
    80004de0:	8082                	ret
    80004de2:	64e2                	ld	s1,24(sp)
    80004de4:	6942                	ld	s2,16(sp)
    80004de6:	bfcd                	j	80004dd8 <sys_dup+0x3c>

0000000080004de8 <sys_read>:
{
    80004de8:	7179                	addi	sp,sp,-48
    80004dea:	f406                	sd	ra,40(sp)
    80004dec:	f022                	sd	s0,32(sp)
    80004dee:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004df0:	fd840593          	addi	a1,s0,-40
    80004df4:	4505                	li	a0,1
    80004df6:	c51fd0ef          	jal	80002a46 <argaddr>
  argint(2, &n);
    80004dfa:	fe440593          	addi	a1,s0,-28
    80004dfe:	4509                	li	a0,2
    80004e00:	c2bfd0ef          	jal	80002a2a <argint>
  if(argfd(0, 0, &f) < 0)
    80004e04:	fe840613          	addi	a2,s0,-24
    80004e08:	4581                	li	a1,0
    80004e0a:	4501                	li	a0,0
    80004e0c:	dbbff0ef          	jal	80004bc6 <argfd>
    80004e10:	87aa                	mv	a5,a0
    return -1;
    80004e12:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e14:	0007ca63          	bltz	a5,80004e28 <sys_read+0x40>
  return fileread(f, p, n);
    80004e18:	fe442603          	lw	a2,-28(s0)
    80004e1c:	fd843583          	ld	a1,-40(s0)
    80004e20:	fe843503          	ld	a0,-24(s0)
    80004e24:	d52ff0ef          	jal	80004376 <fileread>
}
    80004e28:	70a2                	ld	ra,40(sp)
    80004e2a:	7402                	ld	s0,32(sp)
    80004e2c:	6145                	addi	sp,sp,48
    80004e2e:	8082                	ret

0000000080004e30 <sys_write>:
{
    80004e30:	7179                	addi	sp,sp,-48
    80004e32:	f406                	sd	ra,40(sp)
    80004e34:	f022                	sd	s0,32(sp)
    80004e36:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004e38:	fd840593          	addi	a1,s0,-40
    80004e3c:	4505                	li	a0,1
    80004e3e:	c09fd0ef          	jal	80002a46 <argaddr>
  argint(2, &n);
    80004e42:	fe440593          	addi	a1,s0,-28
    80004e46:	4509                	li	a0,2
    80004e48:	be3fd0ef          	jal	80002a2a <argint>
  if(argfd(0, 0, &f) < 0)
    80004e4c:	fe840613          	addi	a2,s0,-24
    80004e50:	4581                	li	a1,0
    80004e52:	4501                	li	a0,0
    80004e54:	d73ff0ef          	jal	80004bc6 <argfd>
    80004e58:	87aa                	mv	a5,a0
    return -1;
    80004e5a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004e5c:	0007ca63          	bltz	a5,80004e70 <sys_write+0x40>
  return filewrite(f, p, n);
    80004e60:	fe442603          	lw	a2,-28(s0)
    80004e64:	fd843583          	ld	a1,-40(s0)
    80004e68:	fe843503          	ld	a0,-24(s0)
    80004e6c:	dc8ff0ef          	jal	80004434 <filewrite>
}
    80004e70:	70a2                	ld	ra,40(sp)
    80004e72:	7402                	ld	s0,32(sp)
    80004e74:	6145                	addi	sp,sp,48
    80004e76:	8082                	ret

0000000080004e78 <sys_close>:
{
    80004e78:	1101                	addi	sp,sp,-32
    80004e7a:	ec06                	sd	ra,24(sp)
    80004e7c:	e822                	sd	s0,16(sp)
    80004e7e:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004e80:	fe040613          	addi	a2,s0,-32
    80004e84:	fec40593          	addi	a1,s0,-20
    80004e88:	4501                	li	a0,0
    80004e8a:	d3dff0ef          	jal	80004bc6 <argfd>
    return -1;
    80004e8e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004e90:	02054063          	bltz	a0,80004eb0 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004e94:	c33fc0ef          	jal	80001ac6 <myproc>
    80004e98:	fec42783          	lw	a5,-20(s0)
    80004e9c:	07e9                	addi	a5,a5,26
    80004e9e:	078e                	slli	a5,a5,0x3
    80004ea0:	953e                	add	a0,a0,a5
    80004ea2:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004ea6:	fe043503          	ld	a0,-32(s0)
    80004eaa:	bacff0ef          	jal	80004256 <fileclose>
  return 0;
    80004eae:	4781                	li	a5,0
}
    80004eb0:	853e                	mv	a0,a5
    80004eb2:	60e2                	ld	ra,24(sp)
    80004eb4:	6442                	ld	s0,16(sp)
    80004eb6:	6105                	addi	sp,sp,32
    80004eb8:	8082                	ret

0000000080004eba <sys_fstat>:
{
    80004eba:	1101                	addi	sp,sp,-32
    80004ebc:	ec06                	sd	ra,24(sp)
    80004ebe:	e822                	sd	s0,16(sp)
    80004ec0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004ec2:	fe040593          	addi	a1,s0,-32
    80004ec6:	4505                	li	a0,1
    80004ec8:	b7ffd0ef          	jal	80002a46 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004ecc:	fe840613          	addi	a2,s0,-24
    80004ed0:	4581                	li	a1,0
    80004ed2:	4501                	li	a0,0
    80004ed4:	cf3ff0ef          	jal	80004bc6 <argfd>
    80004ed8:	87aa                	mv	a5,a0
    return -1;
    80004eda:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004edc:	0007c863          	bltz	a5,80004eec <sys_fstat+0x32>
  return filestat(f, st);
    80004ee0:	fe043583          	ld	a1,-32(s0)
    80004ee4:	fe843503          	ld	a0,-24(s0)
    80004ee8:	c30ff0ef          	jal	80004318 <filestat>
}
    80004eec:	60e2                	ld	ra,24(sp)
    80004eee:	6442                	ld	s0,16(sp)
    80004ef0:	6105                	addi	sp,sp,32
    80004ef2:	8082                	ret

0000000080004ef4 <sys_link>:
{
    80004ef4:	7169                	addi	sp,sp,-304
    80004ef6:	f606                	sd	ra,296(sp)
    80004ef8:	f222                	sd	s0,288(sp)
    80004efa:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004efc:	08000613          	li	a2,128
    80004f00:	ed040593          	addi	a1,s0,-304
    80004f04:	4501                	li	a0,0
    80004f06:	b5dfd0ef          	jal	80002a62 <argstr>
    return -1;
    80004f0a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f0c:	0c054e63          	bltz	a0,80004fe8 <sys_link+0xf4>
    80004f10:	08000613          	li	a2,128
    80004f14:	f5040593          	addi	a1,s0,-176
    80004f18:	4505                	li	a0,1
    80004f1a:	b49fd0ef          	jal	80002a62 <argstr>
    return -1;
    80004f1e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004f20:	0c054463          	bltz	a0,80004fe8 <sys_link+0xf4>
    80004f24:	ee26                	sd	s1,280(sp)
  begin_op();
    80004f26:	f17fe0ef          	jal	80003e3c <begin_op>
  if((ip = namei(old)) == 0){
    80004f2a:	ed040513          	addi	a0,s0,-304
    80004f2e:	d53fe0ef          	jal	80003c80 <namei>
    80004f32:	84aa                	mv	s1,a0
    80004f34:	c53d                	beqz	a0,80004fa2 <sys_link+0xae>
  ilock(ip);
    80004f36:	de0fe0ef          	jal	80003516 <ilock>
  if(ip->type == T_DIR){
    80004f3a:	04449703          	lh	a4,68(s1)
    80004f3e:	4785                	li	a5,1
    80004f40:	06f70663          	beq	a4,a5,80004fac <sys_link+0xb8>
    80004f44:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004f46:	04a4d783          	lhu	a5,74(s1)
    80004f4a:	2785                	addiw	a5,a5,1
    80004f4c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004f50:	8526                	mv	a0,s1
    80004f52:	d10fe0ef          	jal	80003462 <iupdate>
  iunlock(ip);
    80004f56:	8526                	mv	a0,s1
    80004f58:	e6cfe0ef          	jal	800035c4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004f5c:	fd040593          	addi	a1,s0,-48
    80004f60:	f5040513          	addi	a0,s0,-176
    80004f64:	d37fe0ef          	jal	80003c9a <nameiparent>
    80004f68:	892a                	mv	s2,a0
    80004f6a:	cd21                	beqz	a0,80004fc2 <sys_link+0xce>
  ilock(dp);
    80004f6c:	daafe0ef          	jal	80003516 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004f70:	00092703          	lw	a4,0(s2)
    80004f74:	409c                	lw	a5,0(s1)
    80004f76:	04f71363          	bne	a4,a5,80004fbc <sys_link+0xc8>
    80004f7a:	40d0                	lw	a2,4(s1)
    80004f7c:	fd040593          	addi	a1,s0,-48
    80004f80:	854a                	mv	a0,s2
    80004f82:	c65fe0ef          	jal	80003be6 <dirlink>
    80004f86:	02054b63          	bltz	a0,80004fbc <sys_link+0xc8>
  iunlockput(dp);
    80004f8a:	854a                	mv	a0,s2
    80004f8c:	823fe0ef          	jal	800037ae <iunlockput>
  iput(ip);
    80004f90:	8526                	mv	a0,s1
    80004f92:	f94fe0ef          	jal	80003726 <iput>
  end_op();
    80004f96:	f11fe0ef          	jal	80003ea6 <end_op>
  return 0;
    80004f9a:	4781                	li	a5,0
    80004f9c:	64f2                	ld	s1,280(sp)
    80004f9e:	6952                	ld	s2,272(sp)
    80004fa0:	a0a1                	j	80004fe8 <sys_link+0xf4>
    end_op();
    80004fa2:	f05fe0ef          	jal	80003ea6 <end_op>
    return -1;
    80004fa6:	57fd                	li	a5,-1
    80004fa8:	64f2                	ld	s1,280(sp)
    80004faa:	a83d                	j	80004fe8 <sys_link+0xf4>
    iunlockput(ip);
    80004fac:	8526                	mv	a0,s1
    80004fae:	801fe0ef          	jal	800037ae <iunlockput>
    end_op();
    80004fb2:	ef5fe0ef          	jal	80003ea6 <end_op>
    return -1;
    80004fb6:	57fd                	li	a5,-1
    80004fb8:	64f2                	ld	s1,280(sp)
    80004fba:	a03d                	j	80004fe8 <sys_link+0xf4>
    iunlockput(dp);
    80004fbc:	854a                	mv	a0,s2
    80004fbe:	ff0fe0ef          	jal	800037ae <iunlockput>
  ilock(ip);
    80004fc2:	8526                	mv	a0,s1
    80004fc4:	d52fe0ef          	jal	80003516 <ilock>
  ip->nlink--;
    80004fc8:	04a4d783          	lhu	a5,74(s1)
    80004fcc:	37fd                	addiw	a5,a5,-1
    80004fce:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004fd2:	8526                	mv	a0,s1
    80004fd4:	c8efe0ef          	jal	80003462 <iupdate>
  iunlockput(ip);
    80004fd8:	8526                	mv	a0,s1
    80004fda:	fd4fe0ef          	jal	800037ae <iunlockput>
  end_op();
    80004fde:	ec9fe0ef          	jal	80003ea6 <end_op>
  return -1;
    80004fe2:	57fd                	li	a5,-1
    80004fe4:	64f2                	ld	s1,280(sp)
    80004fe6:	6952                	ld	s2,272(sp)
}
    80004fe8:	853e                	mv	a0,a5
    80004fea:	70b2                	ld	ra,296(sp)
    80004fec:	7412                	ld	s0,288(sp)
    80004fee:	6155                	addi	sp,sp,304
    80004ff0:	8082                	ret

0000000080004ff2 <sys_unlink>:
{
    80004ff2:	7151                	addi	sp,sp,-240
    80004ff4:	f586                	sd	ra,232(sp)
    80004ff6:	f1a2                	sd	s0,224(sp)
    80004ff8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004ffa:	08000613          	li	a2,128
    80004ffe:	f3040593          	addi	a1,s0,-208
    80005002:	4501                	li	a0,0
    80005004:	a5ffd0ef          	jal	80002a62 <argstr>
    80005008:	16054063          	bltz	a0,80005168 <sys_unlink+0x176>
    8000500c:	eda6                	sd	s1,216(sp)
  begin_op();
    8000500e:	e2ffe0ef          	jal	80003e3c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005012:	fb040593          	addi	a1,s0,-80
    80005016:	f3040513          	addi	a0,s0,-208
    8000501a:	c81fe0ef          	jal	80003c9a <nameiparent>
    8000501e:	84aa                	mv	s1,a0
    80005020:	c945                	beqz	a0,800050d0 <sys_unlink+0xde>
  ilock(dp);
    80005022:	cf4fe0ef          	jal	80003516 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005026:	00002597          	auipc	a1,0x2
    8000502a:	64a58593          	addi	a1,a1,1610 # 80007670 <etext+0x670>
    8000502e:	fb040513          	addi	a0,s0,-80
    80005032:	9d3fe0ef          	jal	80003a04 <namecmp>
    80005036:	10050e63          	beqz	a0,80005152 <sys_unlink+0x160>
    8000503a:	00002597          	auipc	a1,0x2
    8000503e:	63e58593          	addi	a1,a1,1598 # 80007678 <etext+0x678>
    80005042:	fb040513          	addi	a0,s0,-80
    80005046:	9bffe0ef          	jal	80003a04 <namecmp>
    8000504a:	10050463          	beqz	a0,80005152 <sys_unlink+0x160>
    8000504e:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005050:	f2c40613          	addi	a2,s0,-212
    80005054:	fb040593          	addi	a1,s0,-80
    80005058:	8526                	mv	a0,s1
    8000505a:	9c1fe0ef          	jal	80003a1a <dirlookup>
    8000505e:	892a                	mv	s2,a0
    80005060:	0e050863          	beqz	a0,80005150 <sys_unlink+0x15e>
  ilock(ip);
    80005064:	cb2fe0ef          	jal	80003516 <ilock>
  if(ip->nlink < 1)
    80005068:	04a91783          	lh	a5,74(s2)
    8000506c:	06f05763          	blez	a5,800050da <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005070:	04491703          	lh	a4,68(s2)
    80005074:	4785                	li	a5,1
    80005076:	06f70963          	beq	a4,a5,800050e8 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    8000507a:	4641                	li	a2,16
    8000507c:	4581                	li	a1,0
    8000507e:	fc040513          	addi	a0,s0,-64
    80005082:	d8dfb0ef          	jal	80000e0e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005086:	4741                	li	a4,16
    80005088:	f2c42683          	lw	a3,-212(s0)
    8000508c:	fc040613          	addi	a2,s0,-64
    80005090:	4581                	li	a1,0
    80005092:	8526                	mv	a0,s1
    80005094:	861fe0ef          	jal	800038f4 <writei>
    80005098:	47c1                	li	a5,16
    8000509a:	08f51b63          	bne	a0,a5,80005130 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    8000509e:	04491703          	lh	a4,68(s2)
    800050a2:	4785                	li	a5,1
    800050a4:	08f70d63          	beq	a4,a5,8000513e <sys_unlink+0x14c>
  iunlockput(dp);
    800050a8:	8526                	mv	a0,s1
    800050aa:	f04fe0ef          	jal	800037ae <iunlockput>
  ip->nlink--;
    800050ae:	04a95783          	lhu	a5,74(s2)
    800050b2:	37fd                	addiw	a5,a5,-1
    800050b4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800050b8:	854a                	mv	a0,s2
    800050ba:	ba8fe0ef          	jal	80003462 <iupdate>
  iunlockput(ip);
    800050be:	854a                	mv	a0,s2
    800050c0:	eeefe0ef          	jal	800037ae <iunlockput>
  end_op();
    800050c4:	de3fe0ef          	jal	80003ea6 <end_op>
  return 0;
    800050c8:	4501                	li	a0,0
    800050ca:	64ee                	ld	s1,216(sp)
    800050cc:	694e                	ld	s2,208(sp)
    800050ce:	a849                	j	80005160 <sys_unlink+0x16e>
    end_op();
    800050d0:	dd7fe0ef          	jal	80003ea6 <end_op>
    return -1;
    800050d4:	557d                	li	a0,-1
    800050d6:	64ee                	ld	s1,216(sp)
    800050d8:	a061                	j	80005160 <sys_unlink+0x16e>
    800050da:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    800050dc:	00002517          	auipc	a0,0x2
    800050e0:	5a450513          	addi	a0,a0,1444 # 80007680 <etext+0x680>
    800050e4:	eb0fb0ef          	jal	80000794 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800050e8:	04c92703          	lw	a4,76(s2)
    800050ec:	02000793          	li	a5,32
    800050f0:	f8e7f5e3          	bgeu	a5,a4,8000507a <sys_unlink+0x88>
    800050f4:	e5ce                	sd	s3,200(sp)
    800050f6:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800050fa:	4741                	li	a4,16
    800050fc:	86ce                	mv	a3,s3
    800050fe:	f1840613          	addi	a2,s0,-232
    80005102:	4581                	li	a1,0
    80005104:	854a                	mv	a0,s2
    80005106:	ef2fe0ef          	jal	800037f8 <readi>
    8000510a:	47c1                	li	a5,16
    8000510c:	00f51c63          	bne	a0,a5,80005124 <sys_unlink+0x132>
    if(de.inum != 0)
    80005110:	f1845783          	lhu	a5,-232(s0)
    80005114:	efa1                	bnez	a5,8000516c <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005116:	29c1                	addiw	s3,s3,16
    80005118:	04c92783          	lw	a5,76(s2)
    8000511c:	fcf9efe3          	bltu	s3,a5,800050fa <sys_unlink+0x108>
    80005120:	69ae                	ld	s3,200(sp)
    80005122:	bfa1                	j	8000507a <sys_unlink+0x88>
      panic("isdirempty: readi");
    80005124:	00002517          	auipc	a0,0x2
    80005128:	57450513          	addi	a0,a0,1396 # 80007698 <etext+0x698>
    8000512c:	e68fb0ef          	jal	80000794 <panic>
    80005130:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005132:	00002517          	auipc	a0,0x2
    80005136:	57e50513          	addi	a0,a0,1406 # 800076b0 <etext+0x6b0>
    8000513a:	e5afb0ef          	jal	80000794 <panic>
    dp->nlink--;
    8000513e:	04a4d783          	lhu	a5,74(s1)
    80005142:	37fd                	addiw	a5,a5,-1
    80005144:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005148:	8526                	mv	a0,s1
    8000514a:	b18fe0ef          	jal	80003462 <iupdate>
    8000514e:	bfa9                	j	800050a8 <sys_unlink+0xb6>
    80005150:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005152:	8526                	mv	a0,s1
    80005154:	e5afe0ef          	jal	800037ae <iunlockput>
  end_op();
    80005158:	d4ffe0ef          	jal	80003ea6 <end_op>
  return -1;
    8000515c:	557d                	li	a0,-1
    8000515e:	64ee                	ld	s1,216(sp)
}
    80005160:	70ae                	ld	ra,232(sp)
    80005162:	740e                	ld	s0,224(sp)
    80005164:	616d                	addi	sp,sp,240
    80005166:	8082                	ret
    return -1;
    80005168:	557d                	li	a0,-1
    8000516a:	bfdd                	j	80005160 <sys_unlink+0x16e>
    iunlockput(ip);
    8000516c:	854a                	mv	a0,s2
    8000516e:	e40fe0ef          	jal	800037ae <iunlockput>
    goto bad;
    80005172:	694e                	ld	s2,208(sp)
    80005174:	69ae                	ld	s3,200(sp)
    80005176:	bff1                	j	80005152 <sys_unlink+0x160>

0000000080005178 <sys_open>:

uint64
sys_open(void)
{
    80005178:	714d                	addi	sp,sp,-336
    8000517a:	e686                	sd	ra,328(sp)
    8000517c:	e2a2                	sd	s0,320(sp)
    8000517e:	0a80                	addi	s0,sp,336
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n, depth = 0;
  // 두 번째 argumnet로 omode
  argint(1, &omode);
    80005180:	ebc40593          	addi	a1,s0,-324
    80005184:	4505                	li	a0,1
    80005186:	8a5fd0ef          	jal	80002a2a <argint>
  // 첫 번째 argument로 path
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000518a:	08000613          	li	a2,128
    8000518e:	f4040593          	addi	a1,s0,-192
    80005192:	4501                	li	a0,0
    80005194:	8cffd0ef          	jal	80002a62 <argstr>
    80005198:	87aa                	mv	a5,a0
    return -1;
    8000519a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000519c:	0a07c863          	bltz	a5,8000524c <sys_open+0xd4>
    800051a0:	fe26                	sd	s1,312(sp)
    800051a2:	f64e                	sd	s3,296(sp)

  begin_op();
    800051a4:	c99fe0ef          	jal	80003e3c <begin_op>
  // O_CREATE가 있다면 해당 path에 새로운 file 생성
  if(omode & O_CREATE){
    800051a8:	ebc42783          	lw	a5,-324(s0)
    800051ac:	2007f793          	andi	a5,a5,512
    800051b0:	cbc5                	beqz	a5,80005260 <sys_open+0xe8>
    ip = create(path, T_FILE, 0, 0);
    800051b2:	4681                	li	a3,0
    800051b4:	4601                	li	a2,0
    800051b6:	4589                	li	a1,2
    800051b8:	f4040513          	addi	a0,s0,-192
    800051bc:	aa1ff0ef          	jal	80004c5c <create>
    800051c0:	84aa                	mv	s1,a0
    if(ip == 0){ // inode 생성 실패 시
    800051c2:	c949                	beqz	a0,80005254 <sys_open+0xdc>
      return -1;
    }
  }
  // symbolic link라면 path가 아닌 실제 inode를 찾아야 한다.
  // symbolic link를 타고 재귀적으로 찾아야 한다.
  if (ip->type == T_SYMLINK) {
    800051c4:	04449703          	lh	a4,68(s1)
    800051c8:	4791                	li	a5,4
    800051ca:	0cf70a63          	beq	a4,a5,8000529e <sys_open+0x126>
    }
  }

  // Device file: 외부 I/O device를 위한 파일
  // Device file인 경우 major가 유효한 지 확인 필요 
  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800051ce:	04449703          	lh	a4,68(s1)
    800051d2:	478d                	li	a5,3
    800051d4:	00f71763          	bne	a4,a5,800051e2 <sys_open+0x6a>
    800051d8:	0464d703          	lhu	a4,70(s1)
    800051dc:	47a5                	li	a5,9
    800051de:	16e7e263          	bltu	a5,a4,80005342 <sys_open+0x1ca>
    return -1;
  }

  // file 구조체와 file descriptor를 할당
  // 현재 file이 어떤 inode 구조체를 확인하고 있는지 표시한다.
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800051e2:	fd1fe0ef          	jal	800041b2 <filealloc>
    800051e6:	89aa                	mv	s3,a0
    800051e8:	16050a63          	beqz	a0,8000535c <sys_open+0x1e4>
    800051ec:	fa4a                	sd	s2,304(sp)
    800051ee:	a31ff0ef          	jal	80004c1e <fdalloc>
    800051f2:	892a                	mv	s2,a0
    800051f4:	16054063          	bltz	a0,80005354 <sys_open+0x1dc>
    iunlockput(ip);
    end_op();
    return -1;
  }
  // kernel의 file이 현재 실제 inode를 추적하기 위한 정보 제공
  if(ip->type == T_DEVICE){
    800051f8:	04449703          	lh	a4,68(s1)
    800051fc:	478d                	li	a5,3
    800051fe:	16f70863          	beq	a4,a5,8000536e <sys_open+0x1f6>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005202:	4789                	li	a5,2
    80005204:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80005208:	0209a023          	sw	zero,32(s3)
  }
  // 이 부분이 Hard link
  // 여러 file 구조체가 같은 inode를 가리키게 된다.
  f->ip = ip;
    8000520c:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80005210:	ebc42783          	lw	a5,-324(s0)
    80005214:	0017c713          	xori	a4,a5,1
    80005218:	8b05                	andi	a4,a4,1
    8000521a:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000521e:	0037f713          	andi	a4,a5,3
    80005222:	00e03733          	snez	a4,a4
    80005226:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000522a:	4007f793          	andi	a5,a5,1024
    8000522e:	c791                	beqz	a5,8000523a <sys_open+0xc2>
    80005230:	04449703          	lh	a4,68(s1)
    80005234:	4789                	li	a5,2
    80005236:	14f70363          	beq	a4,a5,8000537c <sys_open+0x204>
    itrunc(ip);
  }

  iunlock(ip);
    8000523a:	8526                	mv	a0,s1
    8000523c:	b88fe0ef          	jal	800035c4 <iunlock>
  end_op();
    80005240:	c67fe0ef          	jal	80003ea6 <end_op>

  return fd;
    80005244:	854a                	mv	a0,s2
    80005246:	74f2                	ld	s1,312(sp)
    80005248:	7952                	ld	s2,304(sp)
    8000524a:	79b2                	ld	s3,296(sp)
}
    8000524c:	60b6                	ld	ra,328(sp)
    8000524e:	6416                	ld	s0,320(sp)
    80005250:	6171                	addi	sp,sp,336
    80005252:	8082                	ret
      end_op();
    80005254:	c53fe0ef          	jal	80003ea6 <end_op>
      return -1;
    80005258:	557d                	li	a0,-1
    8000525a:	74f2                	ld	s1,312(sp)
    8000525c:	79b2                	ld	s3,296(sp)
    8000525e:	b7fd                	j	8000524c <sys_open+0xd4>
    if((ip = namei(path)) == 0){
    80005260:	f4040513          	addi	a0,s0,-192
    80005264:	a1dfe0ef          	jal	80003c80 <namei>
    80005268:	84aa                	mv	s1,a0
    8000526a:	c505                	beqz	a0,80005292 <sys_open+0x11a>
    ilock(ip);
    8000526c:	aaafe0ef          	jal	80003516 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005270:	04449703          	lh	a4,68(s1)
    80005274:	4785                	li	a5,1
    80005276:	f4f717e3          	bne	a4,a5,800051c4 <sys_open+0x4c>
    8000527a:	ebc42783          	lw	a5,-324(s0)
    8000527e:	d3b5                	beqz	a5,800051e2 <sys_open+0x6a>
      iunlockput(ip);
    80005280:	8526                	mv	a0,s1
    80005282:	d2cfe0ef          	jal	800037ae <iunlockput>
      end_op();
    80005286:	c21fe0ef          	jal	80003ea6 <end_op>
      return -1;
    8000528a:	557d                	li	a0,-1
    8000528c:	74f2                	ld	s1,312(sp)
    8000528e:	79b2                	ld	s3,296(sp)
    80005290:	bf75                	j	8000524c <sys_open+0xd4>
      end_op();
    80005292:	c15fe0ef          	jal	80003ea6 <end_op>
      return -1;
    80005296:	557d                	li	a0,-1
    80005298:	74f2                	ld	s1,312(sp)
    8000529a:	79b2                	ld	s3,296(sp)
    8000529c:	bf45                	j	8000524c <sys_open+0xd4>
    8000529e:	fa4a                	sd	s2,304(sp)
    800052a0:	f252                	sd	s4,288(sp)
    800052a2:	ee56                	sd	s5,280(sp)
  int n, depth = 0;
    800052a4:	4901                	li	s2,0
      if (ip->type != T_SYMLINK || (omode & O_NOFOLLOW) || depth >= 10) break;
    800052a6:	6985                	lui	s3,0x1
    800052a8:	4a29                	li	s4,10
    800052aa:	4a91                	li	s5,4
    800052ac:	ebc42783          	lw	a5,-324(s0)
    800052b0:	0137f7b3          	and	a5,a5,s3
    800052b4:	2781                	sext.w	a5,a5
    800052b6:	ef95                	bnez	a5,800052f2 <sys_open+0x17a>
    800052b8:	07490963          	beq	s2,s4,8000532a <sys_open+0x1b2>
      if(readi(ip, 0, (uint64)target, 0, MAXPATH) < 0) {
    800052bc:	08000713          	li	a4,128
    800052c0:	4681                	li	a3,0
    800052c2:	ec040613          	addi	a2,s0,-320
    800052c6:	4581                	li	a1,0
    800052c8:	8526                	mv	a0,s1
    800052ca:	d2efe0ef          	jal	800037f8 <readi>
    800052ce:	02054963          	bltz	a0,80005300 <sys_open+0x188>
      iunlockput(ip);
    800052d2:	8526                	mv	a0,s1
    800052d4:	cdafe0ef          	jal	800037ae <iunlockput>
      if ((ip = namei(target)) == 0) {
    800052d8:	ec040513          	addi	a0,s0,-320
    800052dc:	9a5fe0ef          	jal	80003c80 <namei>
    800052e0:	84aa                	mv	s1,a0
    800052e2:	c91d                	beqz	a0,80005318 <sys_open+0x1a0>
      depth ++;
    800052e4:	2905                	addiw	s2,s2,1
      ilock(ip);
    800052e6:	a30fe0ef          	jal	80003516 <ilock>
      if (ip->type != T_SYMLINK || (omode & O_NOFOLLOW) || depth >= 10) break;
    800052ea:	04449783          	lh	a5,68(s1)
    800052ee:	fb578fe3          	beq	a5,s5,800052ac <sys_open+0x134>
    if (depth >= 10) {
    800052f2:	47a5                	li	a5,9
    800052f4:	0327cb63          	blt	a5,s2,8000532a <sys_open+0x1b2>
    800052f8:	7952                	ld	s2,304(sp)
    800052fa:	7a12                	ld	s4,288(sp)
    800052fc:	6af2                	ld	s5,280(sp)
    800052fe:	bdc1                	j	800051ce <sys_open+0x56>
        iunlockput(ip);
    80005300:	8526                	mv	a0,s1
    80005302:	cacfe0ef          	jal	800037ae <iunlockput>
        end_op();
    80005306:	ba1fe0ef          	jal	80003ea6 <end_op>
        return -1;
    8000530a:	557d                	li	a0,-1
    8000530c:	74f2                	ld	s1,312(sp)
    8000530e:	7952                	ld	s2,304(sp)
    80005310:	79b2                	ld	s3,296(sp)
    80005312:	7a12                	ld	s4,288(sp)
    80005314:	6af2                	ld	s5,280(sp)
    80005316:	bf1d                	j	8000524c <sys_open+0xd4>
        end_op();
    80005318:	b8ffe0ef          	jal	80003ea6 <end_op>
        return -1;
    8000531c:	557d                	li	a0,-1
    8000531e:	74f2                	ld	s1,312(sp)
    80005320:	7952                	ld	s2,304(sp)
    80005322:	79b2                	ld	s3,296(sp)
    80005324:	7a12                	ld	s4,288(sp)
    80005326:	6af2                	ld	s5,280(sp)
    80005328:	b715                	j	8000524c <sys_open+0xd4>
      iunlockput(ip);
    8000532a:	8526                	mv	a0,s1
    8000532c:	c82fe0ef          	jal	800037ae <iunlockput>
      end_op();
    80005330:	b77fe0ef          	jal	80003ea6 <end_op>
      return -1;
    80005334:	557d                	li	a0,-1
    80005336:	74f2                	ld	s1,312(sp)
    80005338:	7952                	ld	s2,304(sp)
    8000533a:	79b2                	ld	s3,296(sp)
    8000533c:	7a12                	ld	s4,288(sp)
    8000533e:	6af2                	ld	s5,280(sp)
    80005340:	b731                	j	8000524c <sys_open+0xd4>
    iunlockput(ip);
    80005342:	8526                	mv	a0,s1
    80005344:	c6afe0ef          	jal	800037ae <iunlockput>
    end_op();
    80005348:	b5ffe0ef          	jal	80003ea6 <end_op>
    return -1;
    8000534c:	557d                	li	a0,-1
    8000534e:	74f2                	ld	s1,312(sp)
    80005350:	79b2                	ld	s3,296(sp)
    80005352:	bded                	j	8000524c <sys_open+0xd4>
      fileclose(f);
    80005354:	854e                	mv	a0,s3
    80005356:	f01fe0ef          	jal	80004256 <fileclose>
    8000535a:	7952                	ld	s2,304(sp)
    iunlockput(ip);
    8000535c:	8526                	mv	a0,s1
    8000535e:	c50fe0ef          	jal	800037ae <iunlockput>
    end_op();
    80005362:	b45fe0ef          	jal	80003ea6 <end_op>
    return -1;
    80005366:	557d                	li	a0,-1
    80005368:	74f2                	ld	s1,312(sp)
    8000536a:	79b2                	ld	s3,296(sp)
    8000536c:	b5c5                	j	8000524c <sys_open+0xd4>
    f->type = FD_DEVICE;
    8000536e:	00f9a023          	sw	a5,0(s3) # 1000 <_entry-0x7ffff000>
    f->major = ip->major;
    80005372:	04649783          	lh	a5,70(s1)
    80005376:	02f99223          	sh	a5,36(s3)
    8000537a:	bd49                	j	8000520c <sys_open+0x94>
    itrunc(ip);
    8000537c:	8526                	mv	a0,s1
    8000537e:	a86fe0ef          	jal	80003604 <itrunc>
    80005382:	bd65                	j	8000523a <sys_open+0xc2>

0000000080005384 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005384:	7175                	addi	sp,sp,-144
    80005386:	e506                	sd	ra,136(sp)
    80005388:	e122                	sd	s0,128(sp)
    8000538a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000538c:	ab1fe0ef          	jal	80003e3c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005390:	08000613          	li	a2,128
    80005394:	f7040593          	addi	a1,s0,-144
    80005398:	4501                	li	a0,0
    8000539a:	ec8fd0ef          	jal	80002a62 <argstr>
    8000539e:	02054363          	bltz	a0,800053c4 <sys_mkdir+0x40>
    800053a2:	4681                	li	a3,0
    800053a4:	4601                	li	a2,0
    800053a6:	4585                	li	a1,1
    800053a8:	f7040513          	addi	a0,s0,-144
    800053ac:	8b1ff0ef          	jal	80004c5c <create>
    800053b0:	c911                	beqz	a0,800053c4 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800053b2:	bfcfe0ef          	jal	800037ae <iunlockput>
  end_op();
    800053b6:	af1fe0ef          	jal	80003ea6 <end_op>
  return 0;
    800053ba:	4501                	li	a0,0
}
    800053bc:	60aa                	ld	ra,136(sp)
    800053be:	640a                	ld	s0,128(sp)
    800053c0:	6149                	addi	sp,sp,144
    800053c2:	8082                	ret
    end_op();
    800053c4:	ae3fe0ef          	jal	80003ea6 <end_op>
    return -1;
    800053c8:	557d                	li	a0,-1
    800053ca:	bfcd                	j	800053bc <sys_mkdir+0x38>

00000000800053cc <sys_mknod>:

uint64
sys_mknod(void)
{
    800053cc:	7135                	addi	sp,sp,-160
    800053ce:	ed06                	sd	ra,152(sp)
    800053d0:	e922                	sd	s0,144(sp)
    800053d2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800053d4:	a69fe0ef          	jal	80003e3c <begin_op>
  argint(1, &major);
    800053d8:	f6c40593          	addi	a1,s0,-148
    800053dc:	4505                	li	a0,1
    800053de:	e4cfd0ef          	jal	80002a2a <argint>
  argint(2, &minor);
    800053e2:	f6840593          	addi	a1,s0,-152
    800053e6:	4509                	li	a0,2
    800053e8:	e42fd0ef          	jal	80002a2a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800053ec:	08000613          	li	a2,128
    800053f0:	f7040593          	addi	a1,s0,-144
    800053f4:	4501                	li	a0,0
    800053f6:	e6cfd0ef          	jal	80002a62 <argstr>
    800053fa:	02054563          	bltz	a0,80005424 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800053fe:	f6841683          	lh	a3,-152(s0)
    80005402:	f6c41603          	lh	a2,-148(s0)
    80005406:	458d                	li	a1,3
    80005408:	f7040513          	addi	a0,s0,-144
    8000540c:	851ff0ef          	jal	80004c5c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005410:	c911                	beqz	a0,80005424 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005412:	b9cfe0ef          	jal	800037ae <iunlockput>
  end_op();
    80005416:	a91fe0ef          	jal	80003ea6 <end_op>
  return 0;
    8000541a:	4501                	li	a0,0
}
    8000541c:	60ea                	ld	ra,152(sp)
    8000541e:	644a                	ld	s0,144(sp)
    80005420:	610d                	addi	sp,sp,160
    80005422:	8082                	ret
    end_op();
    80005424:	a83fe0ef          	jal	80003ea6 <end_op>
    return -1;
    80005428:	557d                	li	a0,-1
    8000542a:	bfcd                	j	8000541c <sys_mknod+0x50>

000000008000542c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000542c:	7135                	addi	sp,sp,-160
    8000542e:	ed06                	sd	ra,152(sp)
    80005430:	e922                	sd	s0,144(sp)
    80005432:	e14a                	sd	s2,128(sp)
    80005434:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005436:	e90fc0ef          	jal	80001ac6 <myproc>
    8000543a:	892a                	mv	s2,a0
  
  begin_op();
    8000543c:	a01fe0ef          	jal	80003e3c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005440:	08000613          	li	a2,128
    80005444:	f6040593          	addi	a1,s0,-160
    80005448:	4501                	li	a0,0
    8000544a:	e18fd0ef          	jal	80002a62 <argstr>
    8000544e:	04054363          	bltz	a0,80005494 <sys_chdir+0x68>
    80005452:	e526                	sd	s1,136(sp)
    80005454:	f6040513          	addi	a0,s0,-160
    80005458:	829fe0ef          	jal	80003c80 <namei>
    8000545c:	84aa                	mv	s1,a0
    8000545e:	c915                	beqz	a0,80005492 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005460:	8b6fe0ef          	jal	80003516 <ilock>
  if(ip->type != T_DIR){
    80005464:	04449703          	lh	a4,68(s1)
    80005468:	4785                	li	a5,1
    8000546a:	02f71963          	bne	a4,a5,8000549c <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000546e:	8526                	mv	a0,s1
    80005470:	954fe0ef          	jal	800035c4 <iunlock>
  iput(p->cwd);
    80005474:	15093503          	ld	a0,336(s2)
    80005478:	aaefe0ef          	jal	80003726 <iput>
  end_op();
    8000547c:	a2bfe0ef          	jal	80003ea6 <end_op>
  p->cwd = ip;
    80005480:	14993823          	sd	s1,336(s2)
  return 0;
    80005484:	4501                	li	a0,0
    80005486:	64aa                	ld	s1,136(sp)
}
    80005488:	60ea                	ld	ra,152(sp)
    8000548a:	644a                	ld	s0,144(sp)
    8000548c:	690a                	ld	s2,128(sp)
    8000548e:	610d                	addi	sp,sp,160
    80005490:	8082                	ret
    80005492:	64aa                	ld	s1,136(sp)
    end_op();
    80005494:	a13fe0ef          	jal	80003ea6 <end_op>
    return -1;
    80005498:	557d                	li	a0,-1
    8000549a:	b7fd                	j	80005488 <sys_chdir+0x5c>
    iunlockput(ip);
    8000549c:	8526                	mv	a0,s1
    8000549e:	b10fe0ef          	jal	800037ae <iunlockput>
    end_op();
    800054a2:	a05fe0ef          	jal	80003ea6 <end_op>
    return -1;
    800054a6:	557d                	li	a0,-1
    800054a8:	64aa                	ld	s1,136(sp)
    800054aa:	bff9                	j	80005488 <sys_chdir+0x5c>

00000000800054ac <sys_exec>:

uint64
sys_exec(void)
{
    800054ac:	7121                	addi	sp,sp,-448
    800054ae:	ff06                	sd	ra,440(sp)
    800054b0:	fb22                	sd	s0,432(sp)
    800054b2:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800054b4:	e4840593          	addi	a1,s0,-440
    800054b8:	4505                	li	a0,1
    800054ba:	d8cfd0ef          	jal	80002a46 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800054be:	08000613          	li	a2,128
    800054c2:	f5040593          	addi	a1,s0,-176
    800054c6:	4501                	li	a0,0
    800054c8:	d9afd0ef          	jal	80002a62 <argstr>
    800054cc:	87aa                	mv	a5,a0
    return -1;
    800054ce:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800054d0:	0c07c463          	bltz	a5,80005598 <sys_exec+0xec>
    800054d4:	f726                	sd	s1,424(sp)
    800054d6:	f34a                	sd	s2,416(sp)
    800054d8:	ef4e                	sd	s3,408(sp)
    800054da:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800054dc:	10000613          	li	a2,256
    800054e0:	4581                	li	a1,0
    800054e2:	e5040513          	addi	a0,s0,-432
    800054e6:	929fb0ef          	jal	80000e0e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800054ea:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    800054ee:	89a6                	mv	s3,s1
    800054f0:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    800054f2:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800054f6:	00391513          	slli	a0,s2,0x3
    800054fa:	e4040593          	addi	a1,s0,-448
    800054fe:	e4843783          	ld	a5,-440(s0)
    80005502:	953e                	add	a0,a0,a5
    80005504:	c9cfd0ef          	jal	800029a0 <fetchaddr>
    80005508:	02054663          	bltz	a0,80005534 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    8000550c:	e4043783          	ld	a5,-448(s0)
    80005510:	c3a9                	beqz	a5,80005552 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005512:	f26fb0ef          	jal	80000c38 <kalloc>
    80005516:	85aa                	mv	a1,a0
    80005518:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000551c:	cd01                	beqz	a0,80005534 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000551e:	6605                	lui	a2,0x1
    80005520:	e4043503          	ld	a0,-448(s0)
    80005524:	cc6fd0ef          	jal	800029ea <fetchstr>
    80005528:	00054663          	bltz	a0,80005534 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    8000552c:	0905                	addi	s2,s2,1
    8000552e:	09a1                	addi	s3,s3,8
    80005530:	fd4913e3          	bne	s2,s4,800054f6 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005534:	f5040913          	addi	s2,s0,-176
    80005538:	6088                	ld	a0,0(s1)
    8000553a:	c931                	beqz	a0,8000558e <sys_exec+0xe2>
    kfree(argv[i]);
    8000553c:	dcafb0ef          	jal	80000b06 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005540:	04a1                	addi	s1,s1,8
    80005542:	ff249be3          	bne	s1,s2,80005538 <sys_exec+0x8c>
  return -1;
    80005546:	557d                	li	a0,-1
    80005548:	74ba                	ld	s1,424(sp)
    8000554a:	791a                	ld	s2,416(sp)
    8000554c:	69fa                	ld	s3,408(sp)
    8000554e:	6a5a                	ld	s4,400(sp)
    80005550:	a0a1                	j	80005598 <sys_exec+0xec>
      argv[i] = 0;
    80005552:	0009079b          	sext.w	a5,s2
    80005556:	078e                	slli	a5,a5,0x3
    80005558:	fd078793          	addi	a5,a5,-48
    8000555c:	97a2                	add	a5,a5,s0
    8000555e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005562:	e5040593          	addi	a1,s0,-432
    80005566:	f5040513          	addi	a0,s0,-176
    8000556a:	aeaff0ef          	jal	80004854 <exec>
    8000556e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005570:	f5040993          	addi	s3,s0,-176
    80005574:	6088                	ld	a0,0(s1)
    80005576:	c511                	beqz	a0,80005582 <sys_exec+0xd6>
    kfree(argv[i]);
    80005578:	d8efb0ef          	jal	80000b06 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000557c:	04a1                	addi	s1,s1,8
    8000557e:	ff349be3          	bne	s1,s3,80005574 <sys_exec+0xc8>
  return ret;
    80005582:	854a                	mv	a0,s2
    80005584:	74ba                	ld	s1,424(sp)
    80005586:	791a                	ld	s2,416(sp)
    80005588:	69fa                	ld	s3,408(sp)
    8000558a:	6a5a                	ld	s4,400(sp)
    8000558c:	a031                	j	80005598 <sys_exec+0xec>
  return -1;
    8000558e:	557d                	li	a0,-1
    80005590:	74ba                	ld	s1,424(sp)
    80005592:	791a                	ld	s2,416(sp)
    80005594:	69fa                	ld	s3,408(sp)
    80005596:	6a5a                	ld	s4,400(sp)
}
    80005598:	70fa                	ld	ra,440(sp)
    8000559a:	745a                	ld	s0,432(sp)
    8000559c:	6139                	addi	sp,sp,448
    8000559e:	8082                	ret

00000000800055a0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800055a0:	7139                	addi	sp,sp,-64
    800055a2:	fc06                	sd	ra,56(sp)
    800055a4:	f822                	sd	s0,48(sp)
    800055a6:	f426                	sd	s1,40(sp)
    800055a8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800055aa:	d1cfc0ef          	jal	80001ac6 <myproc>
    800055ae:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800055b0:	fd840593          	addi	a1,s0,-40
    800055b4:	4501                	li	a0,0
    800055b6:	c90fd0ef          	jal	80002a46 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800055ba:	fc840593          	addi	a1,s0,-56
    800055be:	fd040513          	addi	a0,s0,-48
    800055c2:	f9ffe0ef          	jal	80004560 <pipealloc>
    return -1;
    800055c6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800055c8:	0a054463          	bltz	a0,80005670 <sys_pipe+0xd0>
  fd0 = -1;
    800055cc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800055d0:	fd043503          	ld	a0,-48(s0)
    800055d4:	e4aff0ef          	jal	80004c1e <fdalloc>
    800055d8:	fca42223          	sw	a0,-60(s0)
    800055dc:	08054163          	bltz	a0,8000565e <sys_pipe+0xbe>
    800055e0:	fc843503          	ld	a0,-56(s0)
    800055e4:	e3aff0ef          	jal	80004c1e <fdalloc>
    800055e8:	fca42023          	sw	a0,-64(s0)
    800055ec:	06054063          	bltz	a0,8000564c <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800055f0:	4691                	li	a3,4
    800055f2:	fc440613          	addi	a2,s0,-60
    800055f6:	fd843583          	ld	a1,-40(s0)
    800055fa:	68a8                	ld	a0,80(s1)
    800055fc:	89afc0ef          	jal	80001696 <copyout>
    80005600:	00054e63          	bltz	a0,8000561c <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005604:	4691                	li	a3,4
    80005606:	fc040613          	addi	a2,s0,-64
    8000560a:	fd843583          	ld	a1,-40(s0)
    8000560e:	0591                	addi	a1,a1,4
    80005610:	68a8                	ld	a0,80(s1)
    80005612:	884fc0ef          	jal	80001696 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005616:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005618:	04055c63          	bgez	a0,80005670 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    8000561c:	fc442783          	lw	a5,-60(s0)
    80005620:	07e9                	addi	a5,a5,26
    80005622:	078e                	slli	a5,a5,0x3
    80005624:	97a6                	add	a5,a5,s1
    80005626:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000562a:	fc042783          	lw	a5,-64(s0)
    8000562e:	07e9                	addi	a5,a5,26
    80005630:	078e                	slli	a5,a5,0x3
    80005632:	94be                	add	s1,s1,a5
    80005634:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005638:	fd043503          	ld	a0,-48(s0)
    8000563c:	c1bfe0ef          	jal	80004256 <fileclose>
    fileclose(wf);
    80005640:	fc843503          	ld	a0,-56(s0)
    80005644:	c13fe0ef          	jal	80004256 <fileclose>
    return -1;
    80005648:	57fd                	li	a5,-1
    8000564a:	a01d                	j	80005670 <sys_pipe+0xd0>
    if(fd0 >= 0)
    8000564c:	fc442783          	lw	a5,-60(s0)
    80005650:	0007c763          	bltz	a5,8000565e <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005654:	07e9                	addi	a5,a5,26
    80005656:	078e                	slli	a5,a5,0x3
    80005658:	97a6                	add	a5,a5,s1
    8000565a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000565e:	fd043503          	ld	a0,-48(s0)
    80005662:	bf5fe0ef          	jal	80004256 <fileclose>
    fileclose(wf);
    80005666:	fc843503          	ld	a0,-56(s0)
    8000566a:	bedfe0ef          	jal	80004256 <fileclose>
    return -1;
    8000566e:	57fd                	li	a5,-1
}
    80005670:	853e                	mv	a0,a5
    80005672:	70e2                	ld	ra,56(sp)
    80005674:	7442                	ld	s0,48(sp)
    80005676:	74a2                	ld	s1,40(sp)
    80005678:	6121                	addi	sp,sp,64
    8000567a:	8082                	ret

000000008000567c <sys_symlink>:

uint64
sys_symlink(void)
{
    8000567c:	712d                	addi	sp,sp,-288
    8000567e:	ee06                	sd	ra,280(sp)
    80005680:	ea22                	sd	s0,272(sp)
    80005682:	1200                	addi	s0,sp,288
  char target[MAXPATH], path[MAXPATH];
  int n; // argument 정상적으로 받아오는지 확인용
  struct inode* ip;

  if((n = argstr(0, target, MAXPATH)) < 0)
    80005684:	08000613          	li	a2,128
    80005688:	f6040593          	addi	a1,s0,-160
    8000568c:	4501                	li	a0,0
    8000568e:	bd4fd0ef          	jal	80002a62 <argstr>
    return -1;
    80005692:	57fd                	li	a5,-1
  if((n = argstr(0, target, MAXPATH)) < 0)
    80005694:	04054b63          	bltz	a0,800056ea <sys_symlink+0x6e>

  if((n = argstr(1, path, MAXPATH)) < 0)
    80005698:	08000613          	li	a2,128
    8000569c:	ee040593          	addi	a1,s0,-288
    800056a0:	4505                	li	a0,1
    800056a2:	bc0fd0ef          	jal	80002a62 <argstr>
    return -1;
    800056a6:	57fd                	li	a5,-1
  if((n = argstr(1, path, MAXPATH)) < 0)
    800056a8:	04054163          	bltz	a0,800056ea <sys_symlink+0x6e>
    800056ac:	e626                	sd	s1,264(sp)

  begin_op();  
    800056ae:	f8efe0ef          	jal	80003e3c <begin_op>
  // symbolic link는 같은 path를 가리키는 새로운 파일을 만들어야한다.
  // 또는 같은 이름의 link 존재하면 그 link 사용
  // create 사용
  ip = create(path, T_SYMLINK, 0, 0);
    800056b2:	4681                	li	a3,0
    800056b4:	4601                	li	a2,0
    800056b6:	4591                	li	a1,4
    800056b8:	ee040513          	addi	a0,s0,-288
    800056bc:	da0ff0ef          	jal	80004c5c <create>
    800056c0:	84aa                	mv	s1,a0
  if (ip == 0) {
    800056c2:	c90d                	beqz	a0,800056f4 <sys_symlink+0x78>
  // path기반이므로 directory를 가리켜도 상관없다.

  // Symbolic link는 같은 file system인지는 확인하지 않아도 된다.
  // dirlink 대신 이 작업 수행
  // ip가 target path를 가리키도록 한다.
  if(writei(ip, 0, (uint64)target, 0, sizeof(target)) != sizeof(target)) {
    800056c4:	08000713          	li	a4,128
    800056c8:	4681                	li	a3,0
    800056ca:	f6040613          	addi	a2,s0,-160
    800056ce:	4581                	li	a1,0
    800056d0:	a24fe0ef          	jal	800038f4 <writei>
    800056d4:	08000793          	li	a5,128
    800056d8:	02f51963          	bne	a0,a5,8000570a <sys_symlink+0x8e>
    iunlockput(ip);
    end_op();
    return -1;  
  }

  iunlockput(ip);
    800056dc:	8526                	mv	a0,s1
    800056de:	8d0fe0ef          	jal	800037ae <iunlockput>
  end_op();
    800056e2:	fc4fe0ef          	jal	80003ea6 <end_op>
  return 0;
    800056e6:	4781                	li	a5,0
    800056e8:	64b2                	ld	s1,264(sp)
    800056ea:	853e                	mv	a0,a5
    800056ec:	60f2                	ld	ra,280(sp)
    800056ee:	6452                	ld	s0,272(sp)
    800056f0:	6115                	addi	sp,sp,288
    800056f2:	8082                	ret
    printf("create is failed\n");
    800056f4:	00002517          	auipc	a0,0x2
    800056f8:	fcc50513          	addi	a0,a0,-52 # 800076c0 <etext+0x6c0>
    800056fc:	dc7fa0ef          	jal	800004c2 <printf>
    end_op();
    80005700:	fa6fe0ef          	jal	80003ea6 <end_op>
    return -1;
    80005704:	57fd                	li	a5,-1
    80005706:	64b2                	ld	s1,264(sp)
    80005708:	b7cd                	j	800056ea <sys_symlink+0x6e>
    printf("writei is failed\n");
    8000570a:	00002517          	auipc	a0,0x2
    8000570e:	fce50513          	addi	a0,a0,-50 # 800076d8 <etext+0x6d8>
    80005712:	db1fa0ef          	jal	800004c2 <printf>
    iunlockput(ip);
    80005716:	8526                	mv	a0,s1
    80005718:	896fe0ef          	jal	800037ae <iunlockput>
    end_op();
    8000571c:	f8afe0ef          	jal	80003ea6 <end_op>
    return -1;  
    80005720:	57fd                	li	a5,-1
    80005722:	64b2                	ld	s1,264(sp)
    80005724:	b7d9                	j	800056ea <sys_symlink+0x6e>
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
    80005758:	958fd0ef          	jal	800028b0 <kerneltrap>
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
    800057b0:	aeafc0ef          	jal	80001a9a <cpuid>
  
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
    800057e4:	ab6fc0ef          	jal	80001a9a <cpuid>
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
    80005808:	a92fc0ef          	jal	80001a9a <cpuid>
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
    80005830:	0045e797          	auipc	a5,0x45e
    80005834:	e3878793          	addi	a5,a5,-456 # 80463668 <disk>
    80005838:	97aa                	add	a5,a5,a0
    8000583a:	0187c783          	lbu	a5,24(a5)
    8000583e:	e7b9                	bnez	a5,8000588c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005840:	00451693          	slli	a3,a0,0x4
    80005844:	0045e797          	auipc	a5,0x45e
    80005848:	e2478793          	addi	a5,a5,-476 # 80463668 <disk>
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
    8000586c:	0045e517          	auipc	a0,0x45e
    80005870:	e1450513          	addi	a0,a0,-492 # 80463680 <disk+0x18>
    80005874:	86dfc0ef          	jal	800020e0 <wakeup>
}
    80005878:	60a2                	ld	ra,8(sp)
    8000587a:	6402                	ld	s0,0(sp)
    8000587c:	0141                	addi	sp,sp,16
    8000587e:	8082                	ret
    panic("free_desc 1");
    80005880:	00002517          	auipc	a0,0x2
    80005884:	e7050513          	addi	a0,a0,-400 # 800076f0 <etext+0x6f0>
    80005888:	f0dfa0ef          	jal	80000794 <panic>
    panic("free_desc 2");
    8000588c:	00002517          	auipc	a0,0x2
    80005890:	e7450513          	addi	a0,a0,-396 # 80007700 <etext+0x700>
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
    800058a8:	e6c58593          	addi	a1,a1,-404 # 80007710 <etext+0x710>
    800058ac:	0045e517          	auipc	a0,0x45e
    800058b0:	ee450513          	addi	a0,a0,-284 # 80463790 <disk+0x128>
    800058b4:	c06fb0ef          	jal	80000cba <initlock>
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
    80005918:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47b9afb7>
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
    80005966:	ad2fb0ef          	jal	80000c38 <kalloc>
    8000596a:	0045e497          	auipc	s1,0x45e
    8000596e:	cfe48493          	addi	s1,s1,-770 # 80463668 <disk>
    80005972:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005974:	ac4fb0ef          	jal	80000c38 <kalloc>
    80005978:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000597a:	abefb0ef          	jal	80000c38 <kalloc>
    8000597e:	87aa                	mv	a5,a0
    80005980:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005982:	6088                	ld	a0,0(s1)
    80005984:	10050063          	beqz	a0,80005a84 <virtio_disk_init+0x1ec>
    80005988:	0045e717          	auipc	a4,0x45e
    8000598c:	ce873703          	ld	a4,-792(a4) # 80463670 <disk+0x8>
    80005990:	0e070a63          	beqz	a4,80005a84 <virtio_disk_init+0x1ec>
    80005994:	0e078863          	beqz	a5,80005a84 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005998:	6605                	lui	a2,0x1
    8000599a:	4581                	li	a1,0
    8000599c:	c72fb0ef          	jal	80000e0e <memset>
  memset(disk.avail, 0, PGSIZE);
    800059a0:	0045e497          	auipc	s1,0x45e
    800059a4:	cc848493          	addi	s1,s1,-824 # 80463668 <disk>
    800059a8:	6605                	lui	a2,0x1
    800059aa:	4581                	li	a1,0
    800059ac:	6488                	ld	a0,8(s1)
    800059ae:	c60fb0ef          	jal	80000e0e <memset>
  memset(disk.used, 0, PGSIZE);
    800059b2:	6605                	lui	a2,0x1
    800059b4:	4581                	li	a1,0
    800059b6:	6888                	ld	a0,16(s1)
    800059b8:	c56fb0ef          	jal	80000e0e <memset>
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
    80005a4c:	cd850513          	addi	a0,a0,-808 # 80007720 <etext+0x720>
    80005a50:	d45fa0ef          	jal	80000794 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005a54:	00002517          	auipc	a0,0x2
    80005a58:	cec50513          	addi	a0,a0,-788 # 80007740 <etext+0x740>
    80005a5c:	d39fa0ef          	jal	80000794 <panic>
    panic("virtio disk should not be ready");
    80005a60:	00002517          	auipc	a0,0x2
    80005a64:	d0050513          	addi	a0,a0,-768 # 80007760 <etext+0x760>
    80005a68:	d2dfa0ef          	jal	80000794 <panic>
    panic("virtio disk has no queue 0");
    80005a6c:	00002517          	auipc	a0,0x2
    80005a70:	d1450513          	addi	a0,a0,-748 # 80007780 <etext+0x780>
    80005a74:	d21fa0ef          	jal	80000794 <panic>
    panic("virtio disk max queue too short");
    80005a78:	00002517          	auipc	a0,0x2
    80005a7c:	d2850513          	addi	a0,a0,-728 # 800077a0 <etext+0x7a0>
    80005a80:	d15fa0ef          	jal	80000794 <panic>
    panic("virtio disk kalloc");
    80005a84:	00002517          	auipc	a0,0x2
    80005a88:	d3c50513          	addi	a0,a0,-708 # 800077c0 <etext+0x7c0>
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
    80005abc:	0045e517          	auipc	a0,0x45e
    80005ac0:	cd450513          	addi	a0,a0,-812 # 80463790 <disk+0x128>
    80005ac4:	a76fb0ef          	jal	80000d3a <acquire>
  for(int i = 0; i < 3; i++){
    80005ac8:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005aca:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005acc:	0045eb17          	auipc	s6,0x45e
    80005ad0:	b9cb0b13          	addi	s6,s6,-1124 # 80463668 <disk>
  for(int i = 0; i < 3; i++){
    80005ad4:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005ad6:	0045ec17          	auipc	s8,0x45e
    80005ada:	cbac0c13          	addi	s8,s8,-838 # 80463790 <disk+0x128>
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
    80005af8:	0045e717          	auipc	a4,0x45e
    80005afc:	b7070713          	addi	a4,a4,-1168 # 80463668 <disk>
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
    80005b30:	0045e517          	auipc	a0,0x45e
    80005b34:	b5050513          	addi	a0,a0,-1200 # 80463680 <disk+0x18>
    80005b38:	d5cfc0ef          	jal	80002094 <sleep>
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
    80005b4c:	0045e797          	auipc	a5,0x45e
    80005b50:	b1c78793          	addi	a5,a5,-1252 # 80463668 <disk>
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
    80005c22:	0045e917          	auipc	s2,0x45e
    80005c26:	b6e90913          	addi	s2,s2,-1170 # 80463790 <disk+0x128>
  while(b->disk == 1) {
    80005c2a:	4485                	li	s1,1
    80005c2c:	01079a63          	bne	a5,a6,80005c40 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005c30:	85ca                	mv	a1,s2
    80005c32:	8552                	mv	a0,s4
    80005c34:	c60fc0ef          	jal	80002094 <sleep>
  while(b->disk == 1) {
    80005c38:	004a2783          	lw	a5,4(s4)
    80005c3c:	fe978ae3          	beq	a5,s1,80005c30 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005c40:	f9042903          	lw	s2,-112(s0)
    80005c44:	00290713          	addi	a4,s2,2
    80005c48:	0712                	slli	a4,a4,0x4
    80005c4a:	0045e797          	auipc	a5,0x45e
    80005c4e:	a1e78793          	addi	a5,a5,-1506 # 80463668 <disk>
    80005c52:	97ba                	add	a5,a5,a4
    80005c54:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005c58:	0045e997          	auipc	s3,0x45e
    80005c5c:	a1098993          	addi	s3,s3,-1520 # 80463668 <disk>
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
    80005c7c:	0045e517          	auipc	a0,0x45e
    80005c80:	b1450513          	addi	a0,a0,-1260 # 80463790 <disk+0x128>
    80005c84:	94efb0ef          	jal	80000dd2 <release>
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
    80005cac:	0045e497          	auipc	s1,0x45e
    80005cb0:	9bc48493          	addi	s1,s1,-1604 # 80463668 <disk>
    80005cb4:	0045e517          	auipc	a0,0x45e
    80005cb8:	adc50513          	addi	a0,a0,-1316 # 80463790 <disk+0x128>
    80005cbc:	87efb0ef          	jal	80000d3a <acquire>
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
    80005d0c:	bd4fc0ef          	jal	800020e0 <wakeup>

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
    80005d28:	0045e517          	auipc	a0,0x45e
    80005d2c:	a6850513          	addi	a0,a0,-1432 # 80463790 <disk+0x128>
    80005d30:	8a2fb0ef          	jal	80000dd2 <release>
}
    80005d34:	60e2                	ld	ra,24(sp)
    80005d36:	6442                	ld	s0,16(sp)
    80005d38:	64a2                	ld	s1,8(sp)
    80005d3a:	6105                	addi	sp,sp,32
    80005d3c:	8082                	ret
      panic("virtio_disk_intr status");
    80005d3e:	00002517          	auipc	a0,0x2
    80005d42:	a9a50513          	addi	a0,a0,-1382 # 800077d8 <etext+0x7d8>
    80005d46:	a4ffa0ef          	jal	80000794 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
