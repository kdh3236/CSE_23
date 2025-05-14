
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000c117          	auipc	sp,0xc
    80000004:	83013103          	ld	sp,-2000(sp) # 8000b830 <_GLOBAL_OFFSET_TABLE_+0x8>
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
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd8fb7>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	e1478793          	addi	a5,a5,-492 # 80000e94 <main>
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
consolewrite(int user_src, uint64 src, int n) // spinlock -> console 출력이 끊기지 않도록 한다.
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	fc26                	sd	s1,56(sp)
    800000d8:	f84a                	sd	s2,48(sp)
    800000da:	f44e                	sd	s3,40(sp)
    800000dc:	f052                	sd	s4,32(sp)
    800000de:	0880                	addi	s0,sp,80
    800000e0:	8a2a                	mv	s4,a0
    800000e2:	84ae                	mv	s1,a1
    800000e4:	89b2                	mv	s3,a2
  int i;

  acquire(&prlock);
    800000e6:	00013517          	auipc	a0,0x13
    800000ea:	7aa50513          	addi	a0,a0,1962 # 80013890 <prlock>
    800000ee:	339000ef          	jal	80000c26 <acquire>

  for(i = 0; i < n; i++){
    800000f2:	03305963          	blez	s3,80000124 <consolewrite+0x54>
    800000f6:	ec56                	sd	s5,24(sp)
    800000f8:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000fa:	5afd                	li	s5,-1
    800000fc:	4685                	li	a3,1
    800000fe:	8626                	mv	a2,s1
    80000100:	85d2                	mv	a1,s4
    80000102:	fbf40513          	addi	a0,s0,-65
    80000106:	79c020ef          	jal	800028a2 <either_copyin>
    8000010a:	01550f63          	beq	a0,s5,80000128 <consolewrite+0x58>
      break;
    uartputc(c);
    8000010e:	fbf44503          	lbu	a0,-65(s0)
    80000112:	05b000ef          	jal	8000096c <uartputc>
  for(i = 0; i < n; i++){
    80000116:	2905                	addiw	s2,s2,1
    80000118:	0485                	addi	s1,s1,1
    8000011a:	ff2991e3          	bne	s3,s2,800000fc <consolewrite+0x2c>
    8000011e:	894e                	mv	s2,s3
    80000120:	6ae2                	ld	s5,24(sp)
    80000122:	a021                	j	8000012a <consolewrite+0x5a>
    80000124:	4901                	li	s2,0
    80000126:	a011                	j	8000012a <consolewrite+0x5a>
    80000128:	6ae2                	ld	s5,24(sp)
  }

  release(&prlock);
    8000012a:	00013517          	auipc	a0,0x13
    8000012e:	76650513          	addi	a0,a0,1894 # 80013890 <prlock>
    80000132:	38d000ef          	jal	80000cbe <release>
  return i;
}
    80000136:	854a                	mv	a0,s2
    80000138:	60a6                	ld	ra,72(sp)
    8000013a:	6406                	ld	s0,64(sp)
    8000013c:	74e2                	ld	s1,56(sp)
    8000013e:	7942                	ld	s2,48(sp)
    80000140:	79a2                	ld	s3,40(sp)
    80000142:	7a02                	ld	s4,32(sp)
    80000144:	6161                	addi	sp,sp,80
    80000146:	8082                	ret

0000000080000148 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000148:	711d                	addi	sp,sp,-96
    8000014a:	ec86                	sd	ra,88(sp)
    8000014c:	e8a2                	sd	s0,80(sp)
    8000014e:	e4a6                	sd	s1,72(sp)
    80000150:	e0ca                	sd	s2,64(sp)
    80000152:	fc4e                	sd	s3,56(sp)
    80000154:	f852                	sd	s4,48(sp)
    80000156:	f456                	sd	s5,40(sp)
    80000158:	f05a                	sd	s6,32(sp)
    8000015a:	ec5e                	sd	s7,24(sp)
    8000015c:	1080                	addi	s0,sp,96
    8000015e:	8b2a                	mv	s6,a0
    80000160:	8aae                	mv	s5,a1
    80000162:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000164:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80000168:	00013517          	auipc	a0,0x13
    8000016c:	74050513          	addi	a0,a0,1856 # 800138a8 <cons>
    80000170:	2b7000ef          	jal	80000c26 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000174:	00013497          	auipc	s1,0x13
    80000178:	71c48493          	addi	s1,s1,1820 # 80013890 <prlock>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000017c:	00013997          	auipc	s3,0x13
    80000180:	72c98993          	addi	s3,s3,1836 # 800138a8 <cons>
    80000184:	00013917          	auipc	s2,0x13
    80000188:	7bc90913          	addi	s2,s2,1980 # 80013940 <cons+0x98>
  while(n > 0){
    8000018c:	0b405e63          	blez	s4,80000248 <consoleread+0x100>
    while(cons.r == cons.w){
    80000190:	0b04a783          	lw	a5,176(s1)
    80000194:	0b44a703          	lw	a4,180(s1)
    80000198:	0af71363          	bne	a4,a5,8000023e <consoleread+0xf6>
      if(killed(myproc())){
    8000019c:	28b010ef          	jal	80001c26 <myproc>
    800001a0:	594020ef          	jal	80002734 <killed>
    800001a4:	e12d                	bnez	a0,80000206 <consoleread+0xbe>
      sleep(&cons.r, &cons.lock);
    800001a6:	85ce                	mv	a1,s3
    800001a8:	854a                	mv	a0,s2
    800001aa:	2c4020ef          	jal	8000246e <sleep>
    while(cons.r == cons.w){
    800001ae:	0b04a783          	lw	a5,176(s1)
    800001b2:	0b44a703          	lw	a4,180(s1)
    800001b6:	fef703e3          	beq	a4,a5,8000019c <consoleread+0x54>
    800001ba:	e862                	sd	s8,16(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001bc:	00013717          	auipc	a4,0x13
    800001c0:	6d470713          	addi	a4,a4,1748 # 80013890 <prlock>
    800001c4:	0017869b          	addiw	a3,a5,1
    800001c8:	0ad72823          	sw	a3,176(a4)
    800001cc:	07f7f693          	andi	a3,a5,127
    800001d0:	9736                	add	a4,a4,a3
    800001d2:	03074703          	lbu	a4,48(a4)
    800001d6:	00070c1b          	sext.w	s8,a4

    if(c == C('D')){  // end-of-file
    800001da:	4691                	li	a3,4
    800001dc:	04dc0763          	beq	s8,a3,8000022a <consoleread+0xe2>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001e0:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001e4:	4685                	li	a3,1
    800001e6:	faf40613          	addi	a2,s0,-81
    800001ea:	85d6                	mv	a1,s5
    800001ec:	855a                	mv	a0,s6
    800001ee:	66a020ef          	jal	80002858 <either_copyout>
    800001f2:	57fd                	li	a5,-1
    800001f4:	04f50963          	beq	a0,a5,80000246 <consoleread+0xfe>
      break;

    dst++;
    800001f8:	0a85                	addi	s5,s5,1
    --n;
    800001fa:	3a7d                	addiw	s4,s4,-1

    if(c == '\n'){
    800001fc:	47a9                	li	a5,10
    800001fe:	04fc0e63          	beq	s8,a5,8000025a <consoleread+0x112>
    80000202:	6c42                	ld	s8,16(sp)
    80000204:	b761                	j	8000018c <consoleread+0x44>
        release(&cons.lock);
    80000206:	00013517          	auipc	a0,0x13
    8000020a:	6a250513          	addi	a0,a0,1698 # 800138a8 <cons>
    8000020e:	2b1000ef          	jal	80000cbe <release>
        return -1;
    80000212:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000214:	60e6                	ld	ra,88(sp)
    80000216:	6446                	ld	s0,80(sp)
    80000218:	64a6                	ld	s1,72(sp)
    8000021a:	6906                	ld	s2,64(sp)
    8000021c:	79e2                	ld	s3,56(sp)
    8000021e:	7a42                	ld	s4,48(sp)
    80000220:	7aa2                	ld	s5,40(sp)
    80000222:	7b02                	ld	s6,32(sp)
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	6125                	addi	sp,sp,96
    80000228:	8082                	ret
      if(n < target){
    8000022a:	000a071b          	sext.w	a4,s4
    8000022e:	01777a63          	bgeu	a4,s7,80000242 <consoleread+0xfa>
        cons.r--;
    80000232:	00013717          	auipc	a4,0x13
    80000236:	70f72723          	sw	a5,1806(a4) # 80013940 <cons+0x98>
    8000023a:	6c42                	ld	s8,16(sp)
    8000023c:	a031                	j	80000248 <consoleread+0x100>
    8000023e:	e862                	sd	s8,16(sp)
    80000240:	bfb5                	j	800001bc <consoleread+0x74>
    80000242:	6c42                	ld	s8,16(sp)
    80000244:	a011                	j	80000248 <consoleread+0x100>
    80000246:	6c42                	ld	s8,16(sp)
  release(&cons.lock);
    80000248:	00013517          	auipc	a0,0x13
    8000024c:	66050513          	addi	a0,a0,1632 # 800138a8 <cons>
    80000250:	26f000ef          	jal	80000cbe <release>
  return target - n;
    80000254:	414b853b          	subw	a0,s7,s4
    80000258:	bf75                	j	80000214 <consoleread+0xcc>
    8000025a:	6c42                	ld	s8,16(sp)
    8000025c:	b7f5                	j	80000248 <consoleread+0x100>

000000008000025e <consputc>:
{
    8000025e:	1141                	addi	sp,sp,-16
    80000260:	e406                	sd	ra,8(sp)
    80000262:	e022                	sd	s0,0(sp)
    80000264:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000266:	10000793          	li	a5,256
    8000026a:	00f50863          	beq	a0,a5,8000027a <consputc+0x1c>
    uartputc_sync(c);
    8000026e:	618000ef          	jal	80000886 <uartputc_sync>
}
    80000272:	60a2                	ld	ra,8(sp)
    80000274:	6402                	ld	s0,0(sp)
    80000276:	0141                	addi	sp,sp,16
    80000278:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000027a:	4521                	li	a0,8
    8000027c:	60a000ef          	jal	80000886 <uartputc_sync>
    80000280:	02000513          	li	a0,32
    80000284:	602000ef          	jal	80000886 <uartputc_sync>
    80000288:	4521                	li	a0,8
    8000028a:	5fc000ef          	jal	80000886 <uartputc_sync>
    8000028e:	b7d5                	j	80000272 <consputc+0x14>

0000000080000290 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000290:	1101                	addi	sp,sp,-32
    80000292:	ec06                	sd	ra,24(sp)
    80000294:	e822                	sd	s0,16(sp)
    80000296:	e426                	sd	s1,8(sp)
    80000298:	1000                	addi	s0,sp,32
    8000029a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000029c:	00013517          	auipc	a0,0x13
    800002a0:	60c50513          	addi	a0,a0,1548 # 800138a8 <cons>
    800002a4:	183000ef          	jal	80000c26 <acquire>

  switch(c){
    800002a8:	47d5                	li	a5,21
    800002aa:	08f48f63          	beq	s1,a5,80000348 <consoleintr+0xb8>
    800002ae:	0297c563          	blt	a5,s1,800002d8 <consoleintr+0x48>
    800002b2:	47a1                	li	a5,8
    800002b4:	0ef48463          	beq	s1,a5,8000039c <consoleintr+0x10c>
    800002b8:	47c1                	li	a5,16
    800002ba:	10f49563          	bne	s1,a5,800003c4 <consoleintr+0x134>
  case C('P'):  // Print process list.
    procdump();
    800002be:	62e020ef          	jal	800028ec <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800002c2:	00013517          	auipc	a0,0x13
    800002c6:	5e650513          	addi	a0,a0,1510 # 800138a8 <cons>
    800002ca:	1f5000ef          	jal	80000cbe <release>
}
    800002ce:	60e2                	ld	ra,24(sp)
    800002d0:	6442                	ld	s0,16(sp)
    800002d2:	64a2                	ld	s1,8(sp)
    800002d4:	6105                	addi	sp,sp,32
    800002d6:	8082                	ret
  switch(c){
    800002d8:	07f00793          	li	a5,127
    800002dc:	0cf48063          	beq	s1,a5,8000039c <consoleintr+0x10c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800002e0:	00013717          	auipc	a4,0x13
    800002e4:	5b070713          	addi	a4,a4,1456 # 80013890 <prlock>
    800002e8:	0b872783          	lw	a5,184(a4)
    800002ec:	0b072703          	lw	a4,176(a4)
    800002f0:	9f99                	subw	a5,a5,a4
    800002f2:	07f00713          	li	a4,127
    800002f6:	fcf766e3          	bltu	a4,a5,800002c2 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800002fa:	47b5                	li	a5,13
    800002fc:	0cf48763          	beq	s1,a5,800003ca <consoleintr+0x13a>
      consputc(c);
    80000300:	8526                	mv	a0,s1
    80000302:	f5dff0ef          	jal	8000025e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000306:	00013797          	auipc	a5,0x13
    8000030a:	58a78793          	addi	a5,a5,1418 # 80013890 <prlock>
    8000030e:	0b87a683          	lw	a3,184(a5)
    80000312:	0016871b          	addiw	a4,a3,1
    80000316:	0007061b          	sext.w	a2,a4
    8000031a:	0ae7ac23          	sw	a4,184(a5)
    8000031e:	07f6f693          	andi	a3,a3,127
    80000322:	97b6                	add	a5,a5,a3
    80000324:	02978823          	sb	s1,48(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000328:	47a9                	li	a5,10
    8000032a:	0cf48563          	beq	s1,a5,800003f4 <consoleintr+0x164>
    8000032e:	4791                	li	a5,4
    80000330:	0cf48263          	beq	s1,a5,800003f4 <consoleintr+0x164>
    80000334:	00013797          	auipc	a5,0x13
    80000338:	60c7a783          	lw	a5,1548(a5) # 80013940 <cons+0x98>
    8000033c:	9f1d                	subw	a4,a4,a5
    8000033e:	08000793          	li	a5,128
    80000342:	f8f710e3          	bne	a4,a5,800002c2 <consoleintr+0x32>
    80000346:	a07d                	j	800003f4 <consoleintr+0x164>
    80000348:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    8000034a:	00013717          	auipc	a4,0x13
    8000034e:	54670713          	addi	a4,a4,1350 # 80013890 <prlock>
    80000352:	0b872783          	lw	a5,184(a4)
    80000356:	0b472703          	lw	a4,180(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000035a:	00013497          	auipc	s1,0x13
    8000035e:	53648493          	addi	s1,s1,1334 # 80013890 <prlock>
    while(cons.e != cons.w &&
    80000362:	4929                	li	s2,10
    80000364:	02f70863          	beq	a4,a5,80000394 <consoleintr+0x104>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000368:	37fd                	addiw	a5,a5,-1
    8000036a:	07f7f713          	andi	a4,a5,127
    8000036e:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000370:	03074703          	lbu	a4,48(a4)
    80000374:	03270263          	beq	a4,s2,80000398 <consoleintr+0x108>
      cons.e--;
    80000378:	0af4ac23          	sw	a5,184(s1)
      consputc(BACKSPACE);
    8000037c:	10000513          	li	a0,256
    80000380:	edfff0ef          	jal	8000025e <consputc>
    while(cons.e != cons.w &&
    80000384:	0b84a783          	lw	a5,184(s1)
    80000388:	0b44a703          	lw	a4,180(s1)
    8000038c:	fcf71ee3          	bne	a4,a5,80000368 <consoleintr+0xd8>
    80000390:	6902                	ld	s2,0(sp)
    80000392:	bf05                	j	800002c2 <consoleintr+0x32>
    80000394:	6902                	ld	s2,0(sp)
    80000396:	b735                	j	800002c2 <consoleintr+0x32>
    80000398:	6902                	ld	s2,0(sp)
    8000039a:	b725                	j	800002c2 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000039c:	00013717          	auipc	a4,0x13
    800003a0:	4f470713          	addi	a4,a4,1268 # 80013890 <prlock>
    800003a4:	0b872783          	lw	a5,184(a4)
    800003a8:	0b472703          	lw	a4,180(a4)
    800003ac:	f0f70be3          	beq	a4,a5,800002c2 <consoleintr+0x32>
      cons.e--;
    800003b0:	37fd                	addiw	a5,a5,-1
    800003b2:	00013717          	auipc	a4,0x13
    800003b6:	58f72b23          	sw	a5,1430(a4) # 80013948 <cons+0xa0>
      consputc(BACKSPACE);
    800003ba:	10000513          	li	a0,256
    800003be:	ea1ff0ef          	jal	8000025e <consputc>
    800003c2:	b701                	j	800002c2 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800003c4:	ee048fe3          	beqz	s1,800002c2 <consoleintr+0x32>
    800003c8:	bf21                	j	800002e0 <consoleintr+0x50>
      consputc(c);
    800003ca:	4529                	li	a0,10
    800003cc:	e93ff0ef          	jal	8000025e <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003d0:	00013797          	auipc	a5,0x13
    800003d4:	4c078793          	addi	a5,a5,1216 # 80013890 <prlock>
    800003d8:	0b87a703          	lw	a4,184(a5)
    800003dc:	0017069b          	addiw	a3,a4,1
    800003e0:	0006861b          	sext.w	a2,a3
    800003e4:	0ad7ac23          	sw	a3,184(a5)
    800003e8:	07f77713          	andi	a4,a4,127
    800003ec:	97ba                	add	a5,a5,a4
    800003ee:	4729                	li	a4,10
    800003f0:	02e78823          	sb	a4,48(a5)
        cons.w = cons.e;
    800003f4:	00013797          	auipc	a5,0x13
    800003f8:	54c7a823          	sw	a2,1360(a5) # 80013944 <cons+0x9c>
        wakeup(&cons.r);
    800003fc:	00013517          	auipc	a0,0x13
    80000400:	54450513          	addi	a0,a0,1348 # 80013940 <cons+0x98>
    80000404:	0b6020ef          	jal	800024ba <wakeup>
    80000408:	bd6d                	j	800002c2 <consoleintr+0x32>

000000008000040a <consoleinit>:

void
consoleinit(void)
{
    8000040a:	1141                	addi	sp,sp,-16
    8000040c:	e406                	sd	ra,8(sp)
    8000040e:	e022                	sd	s0,0(sp)
    80000410:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000412:	00008597          	auipc	a1,0x8
    80000416:	bee58593          	addi	a1,a1,-1042 # 80008000 <etext>
    8000041a:	00013517          	auipc	a0,0x13
    8000041e:	48e50513          	addi	a0,a0,1166 # 800138a8 <cons>
    80000422:	784000ef          	jal	80000ba6 <initlock>
  initlock(&prlock, "prlock");
    80000426:	00008597          	auipc	a1,0x8
    8000042a:	bea58593          	addi	a1,a1,-1046 # 80008010 <etext+0x10>
    8000042e:	00013517          	auipc	a0,0x13
    80000432:	46250513          	addi	a0,a0,1122 # 80013890 <prlock>
    80000436:	770000ef          	jal	80000ba6 <initlock>

  uartinit();
    8000043a:	3f4000ef          	jal	8000082e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000043e:	00024797          	auipc	a5,0x24
    80000442:	27278793          	addi	a5,a5,626 # 800246b0 <devsw>
    80000446:	00000717          	auipc	a4,0x0
    8000044a:	d0270713          	addi	a4,a4,-766 # 80000148 <consoleread>
    8000044e:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000450:	00000717          	auipc	a4,0x0
    80000454:	c8070713          	addi	a4,a4,-896 # 800000d0 <consolewrite>
    80000458:	ef98                	sd	a4,24(a5)
}
    8000045a:	60a2                	ld	ra,8(sp)
    8000045c:	6402                	ld	s0,0(sp)
    8000045e:	0141                	addi	sp,sp,16
    80000460:	8082                	ret

0000000080000462 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000462:	7179                	addi	sp,sp,-48
    80000464:	f406                	sd	ra,40(sp)
    80000466:	f022                	sd	s0,32(sp)
    80000468:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000046a:	c219                	beqz	a2,80000470 <printint+0xe>
    8000046c:	08054063          	bltz	a0,800004ec <printint+0x8a>
    x = -xx;
  else
    x = xx;
    80000470:	4881                	li	a7,0
    80000472:	fd040693          	addi	a3,s0,-48

  i = 0;
    80000476:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80000478:	00008617          	auipc	a2,0x8
    8000047c:	38860613          	addi	a2,a2,904 # 80008800 <digits>
    80000480:	883e                	mv	a6,a5
    80000482:	2785                	addiw	a5,a5,1
    80000484:	02b57733          	remu	a4,a0,a1
    80000488:	9732                	add	a4,a4,a2
    8000048a:	00074703          	lbu	a4,0(a4)
    8000048e:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80000492:	872a                	mv	a4,a0
    80000494:	02b55533          	divu	a0,a0,a1
    80000498:	0685                	addi	a3,a3,1
    8000049a:	feb773e3          	bgeu	a4,a1,80000480 <printint+0x1e>

  if(sign)
    8000049e:	00088a63          	beqz	a7,800004b2 <printint+0x50>
    buf[i++] = '-';
    800004a2:	1781                	addi	a5,a5,-32
    800004a4:	97a2                	add	a5,a5,s0
    800004a6:	02d00713          	li	a4,45
    800004aa:	fee78823          	sb	a4,-16(a5)
    800004ae:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800004b2:	02f05963          	blez	a5,800004e4 <printint+0x82>
    800004b6:	ec26                	sd	s1,24(sp)
    800004b8:	e84a                	sd	s2,16(sp)
    800004ba:	fd040713          	addi	a4,s0,-48
    800004be:	00f704b3          	add	s1,a4,a5
    800004c2:	fff70913          	addi	s2,a4,-1
    800004c6:	993e                	add	s2,s2,a5
    800004c8:	37fd                	addiw	a5,a5,-1
    800004ca:	1782                	slli	a5,a5,0x20
    800004cc:	9381                	srli	a5,a5,0x20
    800004ce:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    800004d2:	fff4c503          	lbu	a0,-1(s1)
    800004d6:	d89ff0ef          	jal	8000025e <consputc>
  while(--i >= 0)
    800004da:	14fd                	addi	s1,s1,-1
    800004dc:	ff249be3          	bne	s1,s2,800004d2 <printint+0x70>
    800004e0:	64e2                	ld	s1,24(sp)
    800004e2:	6942                	ld	s2,16(sp)
}
    800004e4:	70a2                	ld	ra,40(sp)
    800004e6:	7402                	ld	s0,32(sp)
    800004e8:	6145                	addi	sp,sp,48
    800004ea:	8082                	ret
    x = -xx;
    800004ec:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800004f0:	4885                	li	a7,1
    x = -xx;
    800004f2:	b741                	j	80000472 <printint+0x10>

00000000800004f4 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800004f4:	7155                	addi	sp,sp,-208
    800004f6:	e506                	sd	ra,136(sp)
    800004f8:	e122                	sd	s0,128(sp)
    800004fa:	f0d2                	sd	s4,96(sp)
    800004fc:	0900                	addi	s0,sp,144
    800004fe:	8a2a                	mv	s4,a0
    80000500:	e40c                	sd	a1,8(s0)
    80000502:	e810                	sd	a2,16(s0)
    80000504:	ec14                	sd	a3,24(s0)
    80000506:	f018                	sd	a4,32(s0)
    80000508:	f41c                	sd	a5,40(s0)
    8000050a:	03043823          	sd	a6,48(s0)
    8000050e:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80000512:	00013797          	auipc	a5,0x13
    80000516:	4567a783          	lw	a5,1110(a5) # 80013968 <pr+0x18>
    8000051a:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    8000051e:	e3a1                	bnez	a5,8000055e <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000520:	00840793          	addi	a5,s0,8
    80000524:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000528:	00054503          	lbu	a0,0(a0)
    8000052c:	26050763          	beqz	a0,8000079a <printf+0x2a6>
    80000530:	fca6                	sd	s1,120(sp)
    80000532:	f8ca                	sd	s2,112(sp)
    80000534:	f4ce                	sd	s3,104(sp)
    80000536:	ecd6                	sd	s5,88(sp)
    80000538:	e8da                	sd	s6,80(sp)
    8000053a:	e0e2                	sd	s8,64(sp)
    8000053c:	fc66                	sd	s9,56(sp)
    8000053e:	f86a                	sd	s10,48(sp)
    80000540:	f46e                	sd	s11,40(sp)
    80000542:	4981                	li	s3,0
    if(cx != '%'){
    80000544:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    80000548:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000054c:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000550:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000554:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80000558:	07000d93          	li	s11,112
    8000055c:	a815                	j	80000590 <printf+0x9c>
    acquire(&pr.lock);
    8000055e:	00013517          	auipc	a0,0x13
    80000562:	3f250513          	addi	a0,a0,1010 # 80013950 <pr>
    80000566:	6c0000ef          	jal	80000c26 <acquire>
  va_start(ap, fmt);
    8000056a:	00840793          	addi	a5,s0,8
    8000056e:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000572:	000a4503          	lbu	a0,0(s4)
    80000576:	fd4d                	bnez	a0,80000530 <printf+0x3c>
    80000578:	a481                	j	800007b8 <printf+0x2c4>
      consputc(cx);
    8000057a:	ce5ff0ef          	jal	8000025e <consputc>
      continue;
    8000057e:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80000580:	0014899b          	addiw	s3,s1,1
    80000584:	013a07b3          	add	a5,s4,s3
    80000588:	0007c503          	lbu	a0,0(a5)
    8000058c:	1e050b63          	beqz	a0,80000782 <printf+0x28e>
    if(cx != '%'){
    80000590:	ff5515e3          	bne	a0,s5,8000057a <printf+0x86>
    i++;
    80000594:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    80000598:	009a07b3          	add	a5,s4,s1
    8000059c:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800005a0:	1e090163          	beqz	s2,80000782 <printf+0x28e>
    800005a4:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800005a8:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800005aa:	c789                	beqz	a5,800005b4 <printf+0xc0>
    800005ac:	009a0733          	add	a4,s4,s1
    800005b0:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800005b4:	03690763          	beq	s2,s6,800005e2 <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    800005b8:	05890163          	beq	s2,s8,800005fa <printf+0x106>
    } else if(c0 == 'u'){
    800005bc:	0d990b63          	beq	s2,s9,80000692 <printf+0x19e>
    } else if(c0 == 'x'){
    800005c0:	13a90163          	beq	s2,s10,800006e2 <printf+0x1ee>
    } else if(c0 == 'p'){
    800005c4:	13b90b63          	beq	s2,s11,800006fa <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800005c8:	07300793          	li	a5,115
    800005cc:	16f90a63          	beq	s2,a5,80000740 <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800005d0:	1b590463          	beq	s2,s5,80000778 <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800005d4:	8556                	mv	a0,s5
    800005d6:	c89ff0ef          	jal	8000025e <consputc>
      consputc(c0);
    800005da:	854a                	mv	a0,s2
    800005dc:	c83ff0ef          	jal	8000025e <consputc>
    800005e0:	b745                	j	80000580 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800005e2:	f8843783          	ld	a5,-120(s0)
    800005e6:	00878713          	addi	a4,a5,8
    800005ea:	f8e43423          	sd	a4,-120(s0)
    800005ee:	4605                	li	a2,1
    800005f0:	45a9                	li	a1,10
    800005f2:	4388                	lw	a0,0(a5)
    800005f4:	e6fff0ef          	jal	80000462 <printint>
    800005f8:	b761                	j	80000580 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800005fa:	03678663          	beq	a5,s6,80000626 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800005fe:	05878263          	beq	a5,s8,80000642 <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    80000602:	0b978463          	beq	a5,s9,800006aa <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80000606:	fda797e3          	bne	a5,s10,800005d4 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    8000060a:	f8843783          	ld	a5,-120(s0)
    8000060e:	00878713          	addi	a4,a5,8
    80000612:	f8e43423          	sd	a4,-120(s0)
    80000616:	4601                	li	a2,0
    80000618:	45c1                	li	a1,16
    8000061a:	6388                	ld	a0,0(a5)
    8000061c:	e47ff0ef          	jal	80000462 <printint>
      i += 1;
    80000620:	0029849b          	addiw	s1,s3,2
    80000624:	bfb1                	j	80000580 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000626:	f8843783          	ld	a5,-120(s0)
    8000062a:	00878713          	addi	a4,a5,8
    8000062e:	f8e43423          	sd	a4,-120(s0)
    80000632:	4605                	li	a2,1
    80000634:	45a9                	li	a1,10
    80000636:	6388                	ld	a0,0(a5)
    80000638:	e2bff0ef          	jal	80000462 <printint>
      i += 1;
    8000063c:	0029849b          	addiw	s1,s3,2
    80000640:	b781                	j	80000580 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000642:	06400793          	li	a5,100
    80000646:	02f68863          	beq	a3,a5,80000676 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000064a:	07500793          	li	a5,117
    8000064e:	06f68c63          	beq	a3,a5,800006c6 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000652:	07800793          	li	a5,120
    80000656:	f6f69fe3          	bne	a3,a5,800005d4 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    8000065a:	f8843783          	ld	a5,-120(s0)
    8000065e:	00878713          	addi	a4,a5,8
    80000662:	f8e43423          	sd	a4,-120(s0)
    80000666:	4601                	li	a2,0
    80000668:	45c1                	li	a1,16
    8000066a:	6388                	ld	a0,0(a5)
    8000066c:	df7ff0ef          	jal	80000462 <printint>
      i += 2;
    80000670:	0039849b          	addiw	s1,s3,3
    80000674:	b731                	j	80000580 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000676:	f8843783          	ld	a5,-120(s0)
    8000067a:	00878713          	addi	a4,a5,8
    8000067e:	f8e43423          	sd	a4,-120(s0)
    80000682:	4605                	li	a2,1
    80000684:	45a9                	li	a1,10
    80000686:	6388                	ld	a0,0(a5)
    80000688:	ddbff0ef          	jal	80000462 <printint>
      i += 2;
    8000068c:	0039849b          	addiw	s1,s3,3
    80000690:	bdc5                	j	80000580 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80000692:	f8843783          	ld	a5,-120(s0)
    80000696:	00878713          	addi	a4,a5,8
    8000069a:	f8e43423          	sd	a4,-120(s0)
    8000069e:	4601                	li	a2,0
    800006a0:	45a9                	li	a1,10
    800006a2:	4388                	lw	a0,0(a5)
    800006a4:	dbfff0ef          	jal	80000462 <printint>
    800006a8:	bde1                	j	80000580 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800006aa:	f8843783          	ld	a5,-120(s0)
    800006ae:	00878713          	addi	a4,a5,8
    800006b2:	f8e43423          	sd	a4,-120(s0)
    800006b6:	4601                	li	a2,0
    800006b8:	45a9                	li	a1,10
    800006ba:	6388                	ld	a0,0(a5)
    800006bc:	da7ff0ef          	jal	80000462 <printint>
      i += 1;
    800006c0:	0029849b          	addiw	s1,s3,2
    800006c4:	bd75                	j	80000580 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800006c6:	f8843783          	ld	a5,-120(s0)
    800006ca:	00878713          	addi	a4,a5,8
    800006ce:	f8e43423          	sd	a4,-120(s0)
    800006d2:	4601                	li	a2,0
    800006d4:	45a9                	li	a1,10
    800006d6:	6388                	ld	a0,0(a5)
    800006d8:	d8bff0ef          	jal	80000462 <printint>
      i += 2;
    800006dc:	0039849b          	addiw	s1,s3,3
    800006e0:	b545                	j	80000580 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800006e2:	f8843783          	ld	a5,-120(s0)
    800006e6:	00878713          	addi	a4,a5,8
    800006ea:	f8e43423          	sd	a4,-120(s0)
    800006ee:	4601                	li	a2,0
    800006f0:	45c1                	li	a1,16
    800006f2:	4388                	lw	a0,0(a5)
    800006f4:	d6fff0ef          	jal	80000462 <printint>
    800006f8:	b561                	j	80000580 <printf+0x8c>
    800006fa:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800006fc:	f8843783          	ld	a5,-120(s0)
    80000700:	00878713          	addi	a4,a5,8
    80000704:	f8e43423          	sd	a4,-120(s0)
    80000708:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000070c:	03000513          	li	a0,48
    80000710:	b4fff0ef          	jal	8000025e <consputc>
  consputc('x');
    80000714:	07800513          	li	a0,120
    80000718:	b47ff0ef          	jal	8000025e <consputc>
    8000071c:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000071e:	00008b97          	auipc	s7,0x8
    80000722:	0e2b8b93          	addi	s7,s7,226 # 80008800 <digits>
    80000726:	03c9d793          	srli	a5,s3,0x3c
    8000072a:	97de                	add	a5,a5,s7
    8000072c:	0007c503          	lbu	a0,0(a5)
    80000730:	b2fff0ef          	jal	8000025e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000734:	0992                	slli	s3,s3,0x4
    80000736:	397d                	addiw	s2,s2,-1
    80000738:	fe0917e3          	bnez	s2,80000726 <printf+0x232>
    8000073c:	6ba6                	ld	s7,72(sp)
    8000073e:	b589                	j	80000580 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80000740:	f8843783          	ld	a5,-120(s0)
    80000744:	00878713          	addi	a4,a5,8
    80000748:	f8e43423          	sd	a4,-120(s0)
    8000074c:	0007b903          	ld	s2,0(a5)
    80000750:	00090d63          	beqz	s2,8000076a <printf+0x276>
      for(; *s; s++)
    80000754:	00094503          	lbu	a0,0(s2)
    80000758:	e20504e3          	beqz	a0,80000580 <printf+0x8c>
        consputc(*s);
    8000075c:	b03ff0ef          	jal	8000025e <consputc>
      for(; *s; s++)
    80000760:	0905                	addi	s2,s2,1
    80000762:	00094503          	lbu	a0,0(s2)
    80000766:	f97d                	bnez	a0,8000075c <printf+0x268>
    80000768:	bd21                	j	80000580 <printf+0x8c>
        s = "(null)";
    8000076a:	00008917          	auipc	s2,0x8
    8000076e:	8ae90913          	addi	s2,s2,-1874 # 80008018 <etext+0x18>
      for(; *s; s++)
    80000772:	02800513          	li	a0,40
    80000776:	b7dd                	j	8000075c <printf+0x268>
      consputc('%');
    80000778:	02500513          	li	a0,37
    8000077c:	ae3ff0ef          	jal	8000025e <consputc>
    80000780:	b501                	j	80000580 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80000782:	f7843783          	ld	a5,-136(s0)
    80000786:	e385                	bnez	a5,800007a6 <printf+0x2b2>
    80000788:	74e6                	ld	s1,120(sp)
    8000078a:	7946                	ld	s2,112(sp)
    8000078c:	79a6                	ld	s3,104(sp)
    8000078e:	6ae6                	ld	s5,88(sp)
    80000790:	6b46                	ld	s6,80(sp)
    80000792:	6c06                	ld	s8,64(sp)
    80000794:	7ce2                	ld	s9,56(sp)
    80000796:	7d42                	ld	s10,48(sp)
    80000798:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    8000079a:	4501                	li	a0,0
    8000079c:	60aa                	ld	ra,136(sp)
    8000079e:	640a                	ld	s0,128(sp)
    800007a0:	7a06                	ld	s4,96(sp)
    800007a2:	6169                	addi	sp,sp,208
    800007a4:	8082                	ret
    800007a6:	74e6                	ld	s1,120(sp)
    800007a8:	7946                	ld	s2,112(sp)
    800007aa:	79a6                	ld	s3,104(sp)
    800007ac:	6ae6                	ld	s5,88(sp)
    800007ae:	6b46                	ld	s6,80(sp)
    800007b0:	6c06                	ld	s8,64(sp)
    800007b2:	7ce2                	ld	s9,56(sp)
    800007b4:	7d42                	ld	s10,48(sp)
    800007b6:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800007b8:	00013517          	auipc	a0,0x13
    800007bc:	19850513          	addi	a0,a0,408 # 80013950 <pr>
    800007c0:	4fe000ef          	jal	80000cbe <release>
    800007c4:	bfd9                	j	8000079a <printf+0x2a6>

00000000800007c6 <panic>:

void
panic(char *s)
{
    800007c6:	1101                	addi	sp,sp,-32
    800007c8:	ec06                	sd	ra,24(sp)
    800007ca:	e822                	sd	s0,16(sp)
    800007cc:	e426                	sd	s1,8(sp)
    800007ce:	1000                	addi	s0,sp,32
    800007d0:	84aa                	mv	s1,a0
  pr.locking = 0;
    800007d2:	00013797          	auipc	a5,0x13
    800007d6:	1807ab23          	sw	zero,406(a5) # 80013968 <pr+0x18>
  printf("panic: ");
    800007da:	00008517          	auipc	a0,0x8
    800007de:	84650513          	addi	a0,a0,-1978 # 80008020 <etext+0x20>
    800007e2:	d13ff0ef          	jal	800004f4 <printf>
  printf("%s\n", s);
    800007e6:	85a6                	mv	a1,s1
    800007e8:	00008517          	auipc	a0,0x8
    800007ec:	84050513          	addi	a0,a0,-1984 # 80008028 <etext+0x28>
    800007f0:	d05ff0ef          	jal	800004f4 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800007f4:	4785                	li	a5,1
    800007f6:	0000b717          	auipc	a4,0xb
    800007fa:	04f72d23          	sw	a5,90(a4) # 8000b850 <panicked>
  for(;;)
    800007fe:	a001                	j	800007fe <panic+0x38>

0000000080000800 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000800:	1101                	addi	sp,sp,-32
    80000802:	ec06                	sd	ra,24(sp)
    80000804:	e822                	sd	s0,16(sp)
    80000806:	e426                	sd	s1,8(sp)
    80000808:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000080a:	00013497          	auipc	s1,0x13
    8000080e:	14648493          	addi	s1,s1,326 # 80013950 <pr>
    80000812:	00008597          	auipc	a1,0x8
    80000816:	81e58593          	addi	a1,a1,-2018 # 80008030 <etext+0x30>
    8000081a:	8526                	mv	a0,s1
    8000081c:	38a000ef          	jal	80000ba6 <initlock>
  pr.locking = 1;
    80000820:	4785                	li	a5,1
    80000822:	cc9c                	sw	a5,24(s1)
}
    80000824:	60e2                	ld	ra,24(sp)
    80000826:	6442                	ld	s0,16(sp)
    80000828:	64a2                	ld	s1,8(sp)
    8000082a:	6105                	addi	sp,sp,32
    8000082c:	8082                	ret

000000008000082e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000082e:	1141                	addi	sp,sp,-16
    80000830:	e406                	sd	ra,8(sp)
    80000832:	e022                	sd	s0,0(sp)
    80000834:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000836:	100007b7          	lui	a5,0x10000
    8000083a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000083e:	10000737          	lui	a4,0x10000
    80000842:	f8000693          	li	a3,-128
    80000846:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000084a:	468d                	li	a3,3
    8000084c:	10000637          	lui	a2,0x10000
    80000850:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000854:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000858:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000085c:	10000737          	lui	a4,0x10000
    80000860:	461d                	li	a2,7
    80000862:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000866:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000086a:	00007597          	auipc	a1,0x7
    8000086e:	7ce58593          	addi	a1,a1,1998 # 80008038 <etext+0x38>
    80000872:	00013517          	auipc	a0,0x13
    80000876:	0fe50513          	addi	a0,a0,254 # 80013970 <uart_tx_lock>
    8000087a:	32c000ef          	jal	80000ba6 <initlock>
}
    8000087e:	60a2                	ld	ra,8(sp)
    80000880:	6402                	ld	s0,0(sp)
    80000882:	0141                	addi	sp,sp,16
    80000884:	8082                	ret

0000000080000886 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000886:	1101                	addi	sp,sp,-32
    80000888:	ec06                	sd	ra,24(sp)
    8000088a:	e822                	sd	s0,16(sp)
    8000088c:	e426                	sd	s1,8(sp)
    8000088e:	1000                	addi	s0,sp,32
    80000890:	84aa                	mv	s1,a0
  push_off();
    80000892:	354000ef          	jal	80000be6 <push_off>

  if(panicked){
    80000896:	0000b797          	auipc	a5,0xb
    8000089a:	fba7a783          	lw	a5,-70(a5) # 8000b850 <panicked>
    8000089e:	e795                	bnez	a5,800008ca <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800008a0:	10000737          	lui	a4,0x10000
    800008a4:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800008a6:	00074783          	lbu	a5,0(a4)
    800008aa:	0207f793          	andi	a5,a5,32
    800008ae:	dfe5                	beqz	a5,800008a6 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800008b0:	0ff4f513          	zext.b	a0,s1
    800008b4:	100007b7          	lui	a5,0x10000
    800008b8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800008bc:	3ae000ef          	jal	80000c6a <pop_off>
}
    800008c0:	60e2                	ld	ra,24(sp)
    800008c2:	6442                	ld	s0,16(sp)
    800008c4:	64a2                	ld	s1,8(sp)
    800008c6:	6105                	addi	sp,sp,32
    800008c8:	8082                	ret
    for(;;)
    800008ca:	a001                	j	800008ca <uartputc_sync+0x44>

00000000800008cc <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008cc:	0000b797          	auipc	a5,0xb
    800008d0:	f8c7b783          	ld	a5,-116(a5) # 8000b858 <uart_tx_r>
    800008d4:	0000b717          	auipc	a4,0xb
    800008d8:	f8c73703          	ld	a4,-116(a4) # 8000b860 <uart_tx_w>
    800008dc:	08f70263          	beq	a4,a5,80000960 <uartstart+0x94>
{
    800008e0:	7139                	addi	sp,sp,-64
    800008e2:	fc06                	sd	ra,56(sp)
    800008e4:	f822                	sd	s0,48(sp)
    800008e6:	f426                	sd	s1,40(sp)
    800008e8:	f04a                	sd	s2,32(sp)
    800008ea:	ec4e                	sd	s3,24(sp)
    800008ec:	e852                	sd	s4,16(sp)
    800008ee:	e456                	sd	s5,8(sp)
    800008f0:	e05a                	sd	s6,0(sp)
    800008f2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008f4:	10000937          	lui	s2,0x10000
    800008f8:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008fa:	00013a97          	auipc	s5,0x13
    800008fe:	076a8a93          	addi	s5,s5,118 # 80013970 <uart_tx_lock>
    uart_tx_r += 1;
    80000902:	0000b497          	auipc	s1,0xb
    80000906:	f5648493          	addi	s1,s1,-170 # 8000b858 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    8000090a:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    8000090e:	0000b997          	auipc	s3,0xb
    80000912:	f5298993          	addi	s3,s3,-174 # 8000b860 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000916:	00094703          	lbu	a4,0(s2)
    8000091a:	02077713          	andi	a4,a4,32
    8000091e:	c71d                	beqz	a4,8000094c <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000920:	01f7f713          	andi	a4,a5,31
    80000924:	9756                	add	a4,a4,s5
    80000926:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    8000092a:	0785                	addi	a5,a5,1
    8000092c:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000092e:	8526                	mv	a0,s1
    80000930:	38b010ef          	jal	800024ba <wakeup>
    WriteReg(THR, c);
    80000934:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000938:	609c                	ld	a5,0(s1)
    8000093a:	0009b703          	ld	a4,0(s3)
    8000093e:	fcf71ce3          	bne	a4,a5,80000916 <uartstart+0x4a>
      ReadReg(ISR);
    80000942:	100007b7          	lui	a5,0x10000
    80000946:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000948:	0007c783          	lbu	a5,0(a5)
  }
}
    8000094c:	70e2                	ld	ra,56(sp)
    8000094e:	7442                	ld	s0,48(sp)
    80000950:	74a2                	ld	s1,40(sp)
    80000952:	7902                	ld	s2,32(sp)
    80000954:	69e2                	ld	s3,24(sp)
    80000956:	6a42                	ld	s4,16(sp)
    80000958:	6aa2                	ld	s5,8(sp)
    8000095a:	6b02                	ld	s6,0(sp)
    8000095c:	6121                	addi	sp,sp,64
    8000095e:	8082                	ret
      ReadReg(ISR);
    80000960:	100007b7          	lui	a5,0x10000
    80000964:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000966:	0007c783          	lbu	a5,0(a5)
      return;
    8000096a:	8082                	ret

000000008000096c <uartputc>:
{
    8000096c:	7179                	addi	sp,sp,-48
    8000096e:	f406                	sd	ra,40(sp)
    80000970:	f022                	sd	s0,32(sp)
    80000972:	ec26                	sd	s1,24(sp)
    80000974:	e84a                	sd	s2,16(sp)
    80000976:	e44e                	sd	s3,8(sp)
    80000978:	e052                	sd	s4,0(sp)
    8000097a:	1800                	addi	s0,sp,48
    8000097c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000097e:	00013517          	auipc	a0,0x13
    80000982:	ff250513          	addi	a0,a0,-14 # 80013970 <uart_tx_lock>
    80000986:	2a0000ef          	jal	80000c26 <acquire>
  if(panicked){
    8000098a:	0000b797          	auipc	a5,0xb
    8000098e:	ec67a783          	lw	a5,-314(a5) # 8000b850 <panicked>
    80000992:	efbd                	bnez	a5,80000a10 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000994:	0000b717          	auipc	a4,0xb
    80000998:	ecc73703          	ld	a4,-308(a4) # 8000b860 <uart_tx_w>
    8000099c:	0000b797          	auipc	a5,0xb
    800009a0:	ebc7b783          	ld	a5,-324(a5) # 8000b858 <uart_tx_r>
    800009a4:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800009a8:	00013997          	auipc	s3,0x13
    800009ac:	fc898993          	addi	s3,s3,-56 # 80013970 <uart_tx_lock>
    800009b0:	0000b497          	auipc	s1,0xb
    800009b4:	ea848493          	addi	s1,s1,-344 # 8000b858 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009b8:	0000b917          	auipc	s2,0xb
    800009bc:	ea890913          	addi	s2,s2,-344 # 8000b860 <uart_tx_w>
    800009c0:	00e79d63          	bne	a5,a4,800009da <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800009c4:	85ce                	mv	a1,s3
    800009c6:	8526                	mv	a0,s1
    800009c8:	2a7010ef          	jal	8000246e <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009cc:	00093703          	ld	a4,0(s2)
    800009d0:	609c                	ld	a5,0(s1)
    800009d2:	02078793          	addi	a5,a5,32
    800009d6:	fee787e3          	beq	a5,a4,800009c4 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009da:	00013497          	auipc	s1,0x13
    800009de:	f9648493          	addi	s1,s1,-106 # 80013970 <uart_tx_lock>
    800009e2:	01f77793          	andi	a5,a4,31
    800009e6:	97a6                	add	a5,a5,s1
    800009e8:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ec:	0705                	addi	a4,a4,1
    800009ee:	0000b797          	auipc	a5,0xb
    800009f2:	e6e7b923          	sd	a4,-398(a5) # 8000b860 <uart_tx_w>
  uartstart();
    800009f6:	ed7ff0ef          	jal	800008cc <uartstart>
  release(&uart_tx_lock);
    800009fa:	8526                	mv	a0,s1
    800009fc:	2c2000ef          	jal	80000cbe <release>
}
    80000a00:	70a2                	ld	ra,40(sp)
    80000a02:	7402                	ld	s0,32(sp)
    80000a04:	64e2                	ld	s1,24(sp)
    80000a06:	6942                	ld	s2,16(sp)
    80000a08:	69a2                	ld	s3,8(sp)
    80000a0a:	6a02                	ld	s4,0(sp)
    80000a0c:	6145                	addi	sp,sp,48
    80000a0e:	8082                	ret
    for(;;)
    80000a10:	a001                	j	80000a10 <uartputc+0xa4>

0000000080000a12 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000a12:	1141                	addi	sp,sp,-16
    80000a14:	e422                	sd	s0,8(sp)
    80000a16:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000a18:	100007b7          	lui	a5,0x10000
    80000a1c:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000a1e:	0007c783          	lbu	a5,0(a5)
    80000a22:	8b85                	andi	a5,a5,1
    80000a24:	cb81                	beqz	a5,80000a34 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80000a26:	100007b7          	lui	a5,0x10000
    80000a2a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a2e:	6422                	ld	s0,8(sp)
    80000a30:	0141                	addi	sp,sp,16
    80000a32:	8082                	ret
    return -1;
    80000a34:	557d                	li	a0,-1
    80000a36:	bfe5                	j	80000a2e <uartgetc+0x1c>

0000000080000a38 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a38:	1101                	addi	sp,sp,-32
    80000a3a:	ec06                	sd	ra,24(sp)
    80000a3c:	e822                	sd	s0,16(sp)
    80000a3e:	e426                	sd	s1,8(sp)
    80000a40:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a42:	54fd                	li	s1,-1
    80000a44:	a019                	j	80000a4a <uartintr+0x12>
      break;
    consoleintr(c);
    80000a46:	84bff0ef          	jal	80000290 <consoleintr>
    int c = uartgetc();
    80000a4a:	fc9ff0ef          	jal	80000a12 <uartgetc>
    if(c == -1)
    80000a4e:	fe951ce3          	bne	a0,s1,80000a46 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a52:	00013497          	auipc	s1,0x13
    80000a56:	f1e48493          	addi	s1,s1,-226 # 80013970 <uart_tx_lock>
    80000a5a:	8526                	mv	a0,s1
    80000a5c:	1ca000ef          	jal	80000c26 <acquire>
  uartstart();
    80000a60:	e6dff0ef          	jal	800008cc <uartstart>
  release(&uart_tx_lock);
    80000a64:	8526                	mv	a0,s1
    80000a66:	258000ef          	jal	80000cbe <release>
}
    80000a6a:	60e2                	ld	ra,24(sp)
    80000a6c:	6442                	ld	s0,16(sp)
    80000a6e:	64a2                	ld	s1,8(sp)
    80000a70:	6105                	addi	sp,sp,32
    80000a72:	8082                	ret

0000000080000a74 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a74:	1101                	addi	sp,sp,-32
    80000a76:	ec06                	sd	ra,24(sp)
    80000a78:	e822                	sd	s0,16(sp)
    80000a7a:	e426                	sd	s1,8(sp)
    80000a7c:	e04a                	sd	s2,0(sp)
    80000a7e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a80:	03451793          	slli	a5,a0,0x34
    80000a84:	e7a9                	bnez	a5,80000ace <kfree+0x5a>
    80000a86:	84aa                	mv	s1,a0
    80000a88:	00025797          	auipc	a5,0x25
    80000a8c:	dc078793          	addi	a5,a5,-576 # 80025848 <end>
    80000a90:	02f56f63          	bltu	a0,a5,80000ace <kfree+0x5a>
    80000a94:	47c5                	li	a5,17
    80000a96:	07ee                	slli	a5,a5,0x1b
    80000a98:	02f57b63          	bgeu	a0,a5,80000ace <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a9c:	6605                	lui	a2,0x1
    80000a9e:	4585                	li	a1,1
    80000aa0:	25a000ef          	jal	80000cfa <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000aa4:	00013917          	auipc	s2,0x13
    80000aa8:	f0490913          	addi	s2,s2,-252 # 800139a8 <kmem>
    80000aac:	854a                	mv	a0,s2
    80000aae:	178000ef          	jal	80000c26 <acquire>
  r->next = kmem.freelist;
    80000ab2:	01893783          	ld	a5,24(s2)
    80000ab6:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000ab8:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000abc:	854a                	mv	a0,s2
    80000abe:	200000ef          	jal	80000cbe <release>
}
    80000ac2:	60e2                	ld	ra,24(sp)
    80000ac4:	6442                	ld	s0,16(sp)
    80000ac6:	64a2                	ld	s1,8(sp)
    80000ac8:	6902                	ld	s2,0(sp)
    80000aca:	6105                	addi	sp,sp,32
    80000acc:	8082                	ret
    panic("kfree");
    80000ace:	00007517          	auipc	a0,0x7
    80000ad2:	57250513          	addi	a0,a0,1394 # 80008040 <etext+0x40>
    80000ad6:	cf1ff0ef          	jal	800007c6 <panic>

0000000080000ada <freerange>:
{
    80000ada:	7179                	addi	sp,sp,-48
    80000adc:	f406                	sd	ra,40(sp)
    80000ade:	f022                	sd	s0,32(sp)
    80000ae0:	ec26                	sd	s1,24(sp)
    80000ae2:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ae4:	6785                	lui	a5,0x1
    80000ae6:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000aea:	00e504b3          	add	s1,a0,a4
    80000aee:	777d                	lui	a4,0xfffff
    80000af0:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af2:	94be                	add	s1,s1,a5
    80000af4:	0295e263          	bltu	a1,s1,80000b18 <freerange+0x3e>
    80000af8:	e84a                	sd	s2,16(sp)
    80000afa:	e44e                	sd	s3,8(sp)
    80000afc:	e052                	sd	s4,0(sp)
    80000afe:	892e                	mv	s2,a1
    kfree(p);
    80000b00:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b02:	6985                	lui	s3,0x1
    kfree(p);
    80000b04:	01448533          	add	a0,s1,s4
    80000b08:	f6dff0ef          	jal	80000a74 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b0c:	94ce                	add	s1,s1,s3
    80000b0e:	fe997be3          	bgeu	s2,s1,80000b04 <freerange+0x2a>
    80000b12:	6942                	ld	s2,16(sp)
    80000b14:	69a2                	ld	s3,8(sp)
    80000b16:	6a02                	ld	s4,0(sp)
}
    80000b18:	70a2                	ld	ra,40(sp)
    80000b1a:	7402                	ld	s0,32(sp)
    80000b1c:	64e2                	ld	s1,24(sp)
    80000b1e:	6145                	addi	sp,sp,48
    80000b20:	8082                	ret

0000000080000b22 <kinit>:
{
    80000b22:	1141                	addi	sp,sp,-16
    80000b24:	e406                	sd	ra,8(sp)
    80000b26:	e022                	sd	s0,0(sp)
    80000b28:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b2a:	00007597          	auipc	a1,0x7
    80000b2e:	51e58593          	addi	a1,a1,1310 # 80008048 <etext+0x48>
    80000b32:	00013517          	auipc	a0,0x13
    80000b36:	e7650513          	addi	a0,a0,-394 # 800139a8 <kmem>
    80000b3a:	06c000ef          	jal	80000ba6 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b3e:	45c5                	li	a1,17
    80000b40:	05ee                	slli	a1,a1,0x1b
    80000b42:	00025517          	auipc	a0,0x25
    80000b46:	d0650513          	addi	a0,a0,-762 # 80025848 <end>
    80000b4a:	f91ff0ef          	jal	80000ada <freerange>
}
    80000b4e:	60a2                	ld	ra,8(sp)
    80000b50:	6402                	ld	s0,0(sp)
    80000b52:	0141                	addi	sp,sp,16
    80000b54:	8082                	ret

0000000080000b56 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b56:	1101                	addi	sp,sp,-32
    80000b58:	ec06                	sd	ra,24(sp)
    80000b5a:	e822                	sd	s0,16(sp)
    80000b5c:	e426                	sd	s1,8(sp)
    80000b5e:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b60:	00013497          	auipc	s1,0x13
    80000b64:	e4848493          	addi	s1,s1,-440 # 800139a8 <kmem>
    80000b68:	8526                	mv	a0,s1
    80000b6a:	0bc000ef          	jal	80000c26 <acquire>
  r = kmem.freelist;
    80000b6e:	6c84                	ld	s1,24(s1)
  if(r)
    80000b70:	c485                	beqz	s1,80000b98 <kalloc+0x42>
    kmem.freelist = r->next;
    80000b72:	609c                	ld	a5,0(s1)
    80000b74:	00013517          	auipc	a0,0x13
    80000b78:	e3450513          	addi	a0,a0,-460 # 800139a8 <kmem>
    80000b7c:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000b7e:	140000ef          	jal	80000cbe <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b82:	6605                	lui	a2,0x1
    80000b84:	4595                	li	a1,5
    80000b86:	8526                	mv	a0,s1
    80000b88:	172000ef          	jal	80000cfa <memset>
  return (void*)r;
}
    80000b8c:	8526                	mv	a0,s1
    80000b8e:	60e2                	ld	ra,24(sp)
    80000b90:	6442                	ld	s0,16(sp)
    80000b92:	64a2                	ld	s1,8(sp)
    80000b94:	6105                	addi	sp,sp,32
    80000b96:	8082                	ret
  release(&kmem.lock);
    80000b98:	00013517          	auipc	a0,0x13
    80000b9c:	e1050513          	addi	a0,a0,-496 # 800139a8 <kmem>
    80000ba0:	11e000ef          	jal	80000cbe <release>
  if(r)
    80000ba4:	b7e5                	j	80000b8c <kalloc+0x36>

0000000080000ba6 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name) // lock 초기화
{
    80000ba6:	1141                	addi	sp,sp,-16
    80000ba8:	e422                	sd	s0,8(sp)
    80000baa:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bac:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bae:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bb2:	00053823          	sd	zero,16(a0)
}
    80000bb6:	6422                	ld	s0,8(sp)
    80000bb8:	0141                	addi	sp,sp,16
    80000bba:	8082                	ret

0000000080000bbc <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bbc:	411c                	lw	a5,0(a0)
    80000bbe:	e399                	bnez	a5,80000bc4 <holding+0x8>
    80000bc0:	4501                	li	a0,0
  return r;
}
    80000bc2:	8082                	ret
{
    80000bc4:	1101                	addi	sp,sp,-32
    80000bc6:	ec06                	sd	ra,24(sp)
    80000bc8:	e822                	sd	s0,16(sp)
    80000bca:	e426                	sd	s1,8(sp)
    80000bcc:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bce:	6904                	ld	s1,16(a0)
    80000bd0:	03a010ef          	jal	80001c0a <mycpu>
    80000bd4:	40a48533          	sub	a0,s1,a0
    80000bd8:	00153513          	seqz	a0,a0
}
    80000bdc:	60e2                	ld	ra,24(sp)
    80000bde:	6442                	ld	s0,16(sp)
    80000be0:	64a2                	ld	s1,8(sp)
    80000be2:	6105                	addi	sp,sp,32
    80000be4:	8082                	ret

0000000080000be6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000be6:	1101                	addi	sp,sp,-32
    80000be8:	ec06                	sd	ra,24(sp)
    80000bea:	e822                	sd	s0,16(sp)
    80000bec:	e426                	sd	s1,8(sp)
    80000bee:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000bf0:	100024f3          	csrr	s1,sstatus
    80000bf4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000bf8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000bfa:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000bfe:	00c010ef          	jal	80001c0a <mycpu>
    80000c02:	5d3c                	lw	a5,120(a0)
    80000c04:	cb99                	beqz	a5,80000c1a <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c06:	004010ef          	jal	80001c0a <mycpu>
    80000c0a:	5d3c                	lw	a5,120(a0)
    80000c0c:	2785                	addiw	a5,a5,1
    80000c0e:	dd3c                	sw	a5,120(a0)
}
    80000c10:	60e2                	ld	ra,24(sp)
    80000c12:	6442                	ld	s0,16(sp)
    80000c14:	64a2                	ld	s1,8(sp)
    80000c16:	6105                	addi	sp,sp,32
    80000c18:	8082                	ret
    mycpu()->intena = old;
    80000c1a:	7f1000ef          	jal	80001c0a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c1e:	8085                	srli	s1,s1,0x1
    80000c20:	8885                	andi	s1,s1,1
    80000c22:	dd64                	sw	s1,124(a0)
    80000c24:	b7cd                	j	80000c06 <push_off+0x20>

0000000080000c26 <acquire>:
{
    80000c26:	1101                	addi	sp,sp,-32
    80000c28:	ec06                	sd	ra,24(sp)
    80000c2a:	e822                	sd	s0,16(sp)
    80000c2c:	e426                	sd	s1,8(sp)
    80000c2e:	1000                	addi	s0,sp,32
    80000c30:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c32:	fb5ff0ef          	jal	80000be6 <push_off>
  if(holding(lk))
    80000c36:	8526                	mv	a0,s1
    80000c38:	f85ff0ef          	jal	80000bbc <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c3c:	4705                	li	a4,1
  if(holding(lk))
    80000c3e:	e105                	bnez	a0,80000c5e <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c40:	87ba                	mv	a5,a4
    80000c42:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c46:	2781                	sext.w	a5,a5
    80000c48:	ffe5                	bnez	a5,80000c40 <acquire+0x1a>
  __sync_synchronize();
    80000c4a:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c4e:	7bd000ef          	jal	80001c0a <mycpu>
    80000c52:	e888                	sd	a0,16(s1)
}
    80000c54:	60e2                	ld	ra,24(sp)
    80000c56:	6442                	ld	s0,16(sp)
    80000c58:	64a2                	ld	s1,8(sp)
    80000c5a:	6105                	addi	sp,sp,32
    80000c5c:	8082                	ret
    panic("acquire");
    80000c5e:	00007517          	auipc	a0,0x7
    80000c62:	3f250513          	addi	a0,a0,1010 # 80008050 <etext+0x50>
    80000c66:	b61ff0ef          	jal	800007c6 <panic>

0000000080000c6a <pop_off>:

void
pop_off(void)
{
    80000c6a:	1141                	addi	sp,sp,-16
    80000c6c:	e406                	sd	ra,8(sp)
    80000c6e:	e022                	sd	s0,0(sp)
    80000c70:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c72:	799000ef          	jal	80001c0a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c76:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c7a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000c7c:	e78d                	bnez	a5,80000ca6 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000c7e:	5d3c                	lw	a5,120(a0)
    80000c80:	02f05963          	blez	a5,80000cb2 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000c84:	37fd                	addiw	a5,a5,-1
    80000c86:	0007871b          	sext.w	a4,a5
    80000c8a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000c8c:	eb09                	bnez	a4,80000c9e <pop_off+0x34>
    80000c8e:	5d7c                	lw	a5,124(a0)
    80000c90:	c799                	beqz	a5,80000c9e <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c92:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000c96:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c9a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000c9e:	60a2                	ld	ra,8(sp)
    80000ca0:	6402                	ld	s0,0(sp)
    80000ca2:	0141                	addi	sp,sp,16
    80000ca4:	8082                	ret
    panic("pop_off - interruptible");
    80000ca6:	00007517          	auipc	a0,0x7
    80000caa:	3b250513          	addi	a0,a0,946 # 80008058 <etext+0x58>
    80000cae:	b19ff0ef          	jal	800007c6 <panic>
    panic("pop_off");
    80000cb2:	00007517          	auipc	a0,0x7
    80000cb6:	3be50513          	addi	a0,a0,958 # 80008070 <etext+0x70>
    80000cba:	b0dff0ef          	jal	800007c6 <panic>

0000000080000cbe <release>:
{
    80000cbe:	1101                	addi	sp,sp,-32
    80000cc0:	ec06                	sd	ra,24(sp)
    80000cc2:	e822                	sd	s0,16(sp)
    80000cc4:	e426                	sd	s1,8(sp)
    80000cc6:	1000                	addi	s0,sp,32
    80000cc8:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cca:	ef3ff0ef          	jal	80000bbc <holding>
    80000cce:	c105                	beqz	a0,80000cee <release+0x30>
  lk->cpu = 0;
    80000cd0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000cd4:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000cd8:	0310000f          	fence	rw,w
    80000cdc:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000ce0:	f8bff0ef          	jal	80000c6a <pop_off>
}
    80000ce4:	60e2                	ld	ra,24(sp)
    80000ce6:	6442                	ld	s0,16(sp)
    80000ce8:	64a2                	ld	s1,8(sp)
    80000cea:	6105                	addi	sp,sp,32
    80000cec:	8082                	ret
    panic("release");
    80000cee:	00007517          	auipc	a0,0x7
    80000cf2:	38a50513          	addi	a0,a0,906 # 80008078 <etext+0x78>
    80000cf6:	ad1ff0ef          	jal	800007c6 <panic>

0000000080000cfa <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000cfa:	1141                	addi	sp,sp,-16
    80000cfc:	e422                	sd	s0,8(sp)
    80000cfe:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d00:	ca19                	beqz	a2,80000d16 <memset+0x1c>
    80000d02:	87aa                	mv	a5,a0
    80000d04:	1602                	slli	a2,a2,0x20
    80000d06:	9201                	srli	a2,a2,0x20
    80000d08:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d0c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d10:	0785                	addi	a5,a5,1
    80000d12:	fee79de3          	bne	a5,a4,80000d0c <memset+0x12>
  }
  return dst;
}
    80000d16:	6422                	ld	s0,8(sp)
    80000d18:	0141                	addi	sp,sp,16
    80000d1a:	8082                	ret

0000000080000d1c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d1c:	1141                	addi	sp,sp,-16
    80000d1e:	e422                	sd	s0,8(sp)
    80000d20:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d22:	ca05                	beqz	a2,80000d52 <memcmp+0x36>
    80000d24:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d28:	1682                	slli	a3,a3,0x20
    80000d2a:	9281                	srli	a3,a3,0x20
    80000d2c:	0685                	addi	a3,a3,1
    80000d2e:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d30:	00054783          	lbu	a5,0(a0)
    80000d34:	0005c703          	lbu	a4,0(a1)
    80000d38:	00e79863          	bne	a5,a4,80000d48 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d3c:	0505                	addi	a0,a0,1
    80000d3e:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d40:	fed518e3          	bne	a0,a3,80000d30 <memcmp+0x14>
  }

  return 0;
    80000d44:	4501                	li	a0,0
    80000d46:	a019                	j	80000d4c <memcmp+0x30>
      return *s1 - *s2;
    80000d48:	40e7853b          	subw	a0,a5,a4
}
    80000d4c:	6422                	ld	s0,8(sp)
    80000d4e:	0141                	addi	sp,sp,16
    80000d50:	8082                	ret
  return 0;
    80000d52:	4501                	li	a0,0
    80000d54:	bfe5                	j	80000d4c <memcmp+0x30>

0000000080000d56 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d56:	1141                	addi	sp,sp,-16
    80000d58:	e422                	sd	s0,8(sp)
    80000d5a:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d5c:	c205                	beqz	a2,80000d7c <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d5e:	02a5e263          	bltu	a1,a0,80000d82 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d62:	1602                	slli	a2,a2,0x20
    80000d64:	9201                	srli	a2,a2,0x20
    80000d66:	00c587b3          	add	a5,a1,a2
{
    80000d6a:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d6c:	0585                	addi	a1,a1,1
    80000d6e:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd97b9>
    80000d70:	fff5c683          	lbu	a3,-1(a1)
    80000d74:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000d78:	feb79ae3          	bne	a5,a1,80000d6c <memmove+0x16>

  return dst;
}
    80000d7c:	6422                	ld	s0,8(sp)
    80000d7e:	0141                	addi	sp,sp,16
    80000d80:	8082                	ret
  if(s < d && s + n > d){
    80000d82:	02061693          	slli	a3,a2,0x20
    80000d86:	9281                	srli	a3,a3,0x20
    80000d88:	00d58733          	add	a4,a1,a3
    80000d8c:	fce57be3          	bgeu	a0,a4,80000d62 <memmove+0xc>
    d += n;
    80000d90:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000d92:	fff6079b          	addiw	a5,a2,-1
    80000d96:	1782                	slli	a5,a5,0x20
    80000d98:	9381                	srli	a5,a5,0x20
    80000d9a:	fff7c793          	not	a5,a5
    80000d9e:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000da0:	177d                	addi	a4,a4,-1
    80000da2:	16fd                	addi	a3,a3,-1
    80000da4:	00074603          	lbu	a2,0(a4)
    80000da8:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000dac:	fef71ae3          	bne	a4,a5,80000da0 <memmove+0x4a>
    80000db0:	b7f1                	j	80000d7c <memmove+0x26>

0000000080000db2 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000db2:	1141                	addi	sp,sp,-16
    80000db4:	e406                	sd	ra,8(sp)
    80000db6:	e022                	sd	s0,0(sp)
    80000db8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dba:	f9dff0ef          	jal	80000d56 <memmove>
}
    80000dbe:	60a2                	ld	ra,8(sp)
    80000dc0:	6402                	ld	s0,0(sp)
    80000dc2:	0141                	addi	sp,sp,16
    80000dc4:	8082                	ret

0000000080000dc6 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000dc6:	1141                	addi	sp,sp,-16
    80000dc8:	e422                	sd	s0,8(sp)
    80000dca:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dcc:	ce11                	beqz	a2,80000de8 <strncmp+0x22>
    80000dce:	00054783          	lbu	a5,0(a0)
    80000dd2:	cf89                	beqz	a5,80000dec <strncmp+0x26>
    80000dd4:	0005c703          	lbu	a4,0(a1)
    80000dd8:	00f71a63          	bne	a4,a5,80000dec <strncmp+0x26>
    n--, p++, q++;
    80000ddc:	367d                	addiw	a2,a2,-1
    80000dde:	0505                	addi	a0,a0,1
    80000de0:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000de2:	f675                	bnez	a2,80000dce <strncmp+0x8>
  if(n == 0)
    return 0;
    80000de4:	4501                	li	a0,0
    80000de6:	a801                	j	80000df6 <strncmp+0x30>
    80000de8:	4501                	li	a0,0
    80000dea:	a031                	j	80000df6 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000dec:	00054503          	lbu	a0,0(a0)
    80000df0:	0005c783          	lbu	a5,0(a1)
    80000df4:	9d1d                	subw	a0,a0,a5
}
    80000df6:	6422                	ld	s0,8(sp)
    80000df8:	0141                	addi	sp,sp,16
    80000dfa:	8082                	ret

0000000080000dfc <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000dfc:	1141                	addi	sp,sp,-16
    80000dfe:	e422                	sd	s0,8(sp)
    80000e00:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e02:	87aa                	mv	a5,a0
    80000e04:	86b2                	mv	a3,a2
    80000e06:	367d                	addiw	a2,a2,-1
    80000e08:	02d05563          	blez	a3,80000e32 <strncpy+0x36>
    80000e0c:	0785                	addi	a5,a5,1
    80000e0e:	0005c703          	lbu	a4,0(a1)
    80000e12:	fee78fa3          	sb	a4,-1(a5)
    80000e16:	0585                	addi	a1,a1,1
    80000e18:	f775                	bnez	a4,80000e04 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e1a:	873e                	mv	a4,a5
    80000e1c:	9fb5                	addw	a5,a5,a3
    80000e1e:	37fd                	addiw	a5,a5,-1
    80000e20:	00c05963          	blez	a2,80000e32 <strncpy+0x36>
    *s++ = 0;
    80000e24:	0705                	addi	a4,a4,1
    80000e26:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e2a:	40e786bb          	subw	a3,a5,a4
    80000e2e:	fed04be3          	bgtz	a3,80000e24 <strncpy+0x28>
  return os;
}
    80000e32:	6422                	ld	s0,8(sp)
    80000e34:	0141                	addi	sp,sp,16
    80000e36:	8082                	ret

0000000080000e38 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e38:	1141                	addi	sp,sp,-16
    80000e3a:	e422                	sd	s0,8(sp)
    80000e3c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e3e:	02c05363          	blez	a2,80000e64 <safestrcpy+0x2c>
    80000e42:	fff6069b          	addiw	a3,a2,-1
    80000e46:	1682                	slli	a3,a3,0x20
    80000e48:	9281                	srli	a3,a3,0x20
    80000e4a:	96ae                	add	a3,a3,a1
    80000e4c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e4e:	00d58963          	beq	a1,a3,80000e60 <safestrcpy+0x28>
    80000e52:	0585                	addi	a1,a1,1
    80000e54:	0785                	addi	a5,a5,1
    80000e56:	fff5c703          	lbu	a4,-1(a1)
    80000e5a:	fee78fa3          	sb	a4,-1(a5)
    80000e5e:	fb65                	bnez	a4,80000e4e <safestrcpy+0x16>
    ;
  *s = 0;
    80000e60:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e64:	6422                	ld	s0,8(sp)
    80000e66:	0141                	addi	sp,sp,16
    80000e68:	8082                	ret

0000000080000e6a <strlen>:

int
strlen(const char *s)
{
    80000e6a:	1141                	addi	sp,sp,-16
    80000e6c:	e422                	sd	s0,8(sp)
    80000e6e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000e70:	00054783          	lbu	a5,0(a0)
    80000e74:	cf91                	beqz	a5,80000e90 <strlen+0x26>
    80000e76:	0505                	addi	a0,a0,1
    80000e78:	87aa                	mv	a5,a0
    80000e7a:	86be                	mv	a3,a5
    80000e7c:	0785                	addi	a5,a5,1
    80000e7e:	fff7c703          	lbu	a4,-1(a5)
    80000e82:	ff65                	bnez	a4,80000e7a <strlen+0x10>
    80000e84:	40a6853b          	subw	a0,a3,a0
    80000e88:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000e8a:	6422                	ld	s0,8(sp)
    80000e8c:	0141                	addi	sp,sp,16
    80000e8e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000e90:	4501                	li	a0,0
    80000e92:	bfe5                	j	80000e8a <strlen+0x20>

0000000080000e94 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e94:	1141                	addi	sp,sp,-16
    80000e96:	e406                	sd	ra,8(sp)
    80000e98:	e022                	sd	s0,0(sp)
    80000e9a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000e9c:	55f000ef          	jal	80001bfa <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ea0:	0000b717          	auipc	a4,0xb
    80000ea4:	9c870713          	addi	a4,a4,-1592 # 8000b868 <started>
  if(cpuid() == 0){
    80000ea8:	c51d                	beqz	a0,80000ed6 <main+0x42>
    while(started == 0)
    80000eaa:	431c                	lw	a5,0(a4)
    80000eac:	2781                	sext.w	a5,a5
    80000eae:	dff5                	beqz	a5,80000eaa <main+0x16>
      ;
    __sync_synchronize();
    80000eb0:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000eb4:	547000ef          	jal	80001bfa <cpuid>
    80000eb8:	85aa                	mv	a1,a0
    80000eba:	00007517          	auipc	a0,0x7
    80000ebe:	1e650513          	addi	a0,a0,486 # 800080a0 <etext+0xa0>
    80000ec2:	e32ff0ef          	jal	800004f4 <printf>
    kvminithart();    // turn on paging
    80000ec6:	080000ef          	jal	80000f46 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000eca:	7e7010ef          	jal	80002eb0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000ece:	15a050ef          	jal	80006028 <plicinithart>
  }

  scheduler();        
    80000ed2:	21a010ef          	jal	800020ec <scheduler>
    consoleinit();
    80000ed6:	d34ff0ef          	jal	8000040a <consoleinit>
    printfinit();
    80000eda:	927ff0ef          	jal	80000800 <printfinit>
    printf("\n");
    80000ede:	00007517          	auipc	a0,0x7
    80000ee2:	1a250513          	addi	a0,a0,418 # 80008080 <etext+0x80>
    80000ee6:	e0eff0ef          	jal	800004f4 <printf>
    printf("xv6 kernel is booting\n");
    80000eea:	00007517          	auipc	a0,0x7
    80000eee:	19e50513          	addi	a0,a0,414 # 80008088 <etext+0x88>
    80000ef2:	e02ff0ef          	jal	800004f4 <printf>
    printf("\n");
    80000ef6:	00007517          	auipc	a0,0x7
    80000efa:	18a50513          	addi	a0,a0,394 # 80008080 <etext+0x80>
    80000efe:	df6ff0ef          	jal	800004f4 <printf>
    kinit();         // physical page allocator
    80000f02:	c21ff0ef          	jal	80000b22 <kinit>
    kvminit();       // create kernel page table
    80000f06:	2ca000ef          	jal	800011d0 <kvminit>
    kvminithart();   // turn on paging
    80000f0a:	03c000ef          	jal	80000f46 <kvminithart>
    procinit();      // process table
    80000f0e:	40f000ef          	jal	80001b1c <procinit>
    trapinit();      // trap vectors
    80000f12:	77b010ef          	jal	80002e8c <trapinit>
    trapinithart();  // install kernel trap vector
    80000f16:	79b010ef          	jal	80002eb0 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f1a:	0f4050ef          	jal	8000600e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f1e:	10a050ef          	jal	80006028 <plicinithart>
    binit();         // buffer cache
    80000f22:	0b5020ef          	jal	800037d6 <binit>
    iinit();         // inode table
    80000f26:	6a7020ef          	jal	80003dcc <iinit>
    fileinit();      // file table
    80000f2a:	453030ef          	jal	80004b7c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f2e:	1ea050ef          	jal	80006118 <virtio_disk_init>
    userinit();      // first user process
    80000f32:	783000ef          	jal	80001eb4 <userinit>
    __sync_synchronize();
    80000f36:	0330000f          	fence	rw,rw
    started = 1;
    80000f3a:	4785                	li	a5,1
    80000f3c:	0000b717          	auipc	a4,0xb
    80000f40:	92f72623          	sw	a5,-1748(a4) # 8000b868 <started>
    80000f44:	b779                	j	80000ed2 <main+0x3e>

0000000080000f46 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80000f46:	1141                	addi	sp,sp,-16
    80000f48:	e422                	sd	s0,8(sp)
    80000f4a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f4c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f50:	0000b797          	auipc	a5,0xb
    80000f54:	9207b783          	ld	a5,-1760(a5) # 8000b870 <kernel_pagetable>
    80000f58:	83b1                	srli	a5,a5,0xc
    80000f5a:	577d                	li	a4,-1
    80000f5c:	177e                	slli	a4,a4,0x3f
    80000f5e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000f60:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f64:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f68:	6422                	ld	s0,8(sp)
    80000f6a:	0141                	addi	sp,sp,16
    80000f6c:	8082                	ret

0000000080000f6e <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f6e:	7139                	addi	sp,sp,-64
    80000f70:	fc06                	sd	ra,56(sp)
    80000f72:	f822                	sd	s0,48(sp)
    80000f74:	f426                	sd	s1,40(sp)
    80000f76:	f04a                	sd	s2,32(sp)
    80000f78:	ec4e                	sd	s3,24(sp)
    80000f7a:	e852                	sd	s4,16(sp)
    80000f7c:	e456                	sd	s5,8(sp)
    80000f7e:	e05a                	sd	s6,0(sp)
    80000f80:	0080                	addi	s0,sp,64
    80000f82:	84aa                	mv	s1,a0
    80000f84:	89ae                	mv	s3,a1
    80000f86:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80000f88:	57fd                	li	a5,-1
    80000f8a:	83e9                	srli	a5,a5,0x1a
    80000f8c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000f8e:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000f90:	02b7fc63          	bgeu	a5,a1,80000fc8 <walk+0x5a>
    panic("walk");
    80000f94:	00007517          	auipc	a0,0x7
    80000f98:	12450513          	addi	a0,a0,292 # 800080b8 <etext+0xb8>
    80000f9c:	82bff0ef          	jal	800007c6 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000fa0:	060a8263          	beqz	s5,80001004 <walk+0x96>
    80000fa4:	bb3ff0ef          	jal	80000b56 <kalloc>
    80000fa8:	84aa                	mv	s1,a0
    80000faa:	c139                	beqz	a0,80000ff0 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000fac:	6605                	lui	a2,0x1
    80000fae:	4581                	li	a1,0
    80000fb0:	d4bff0ef          	jal	80000cfa <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fb4:	00c4d793          	srli	a5,s1,0xc
    80000fb8:	07aa                	slli	a5,a5,0xa
    80000fba:	0017e793          	ori	a5,a5,1
    80000fbe:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    80000fc2:	3a5d                	addiw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffd97af>
    80000fc4:	036a0063          	beq	s4,s6,80000fe4 <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    80000fc8:	0149d933          	srl	s2,s3,s4
    80000fcc:	1ff97913          	andi	s2,s2,511
    80000fd0:	090e                	slli	s2,s2,0x3
    80000fd2:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000fd4:	00093483          	ld	s1,0(s2)
    80000fd8:	0014f793          	andi	a5,s1,1
    80000fdc:	d3f1                	beqz	a5,80000fa0 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000fde:	80a9                	srli	s1,s1,0xa
    80000fe0:	04b2                	slli	s1,s1,0xc
    80000fe2:	b7c5                	j	80000fc2 <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    80000fe4:	00c9d513          	srli	a0,s3,0xc
    80000fe8:	1ff57513          	andi	a0,a0,511
    80000fec:	050e                	slli	a0,a0,0x3
    80000fee:	9526                	add	a0,a0,s1
}
    80000ff0:	70e2                	ld	ra,56(sp)
    80000ff2:	7442                	ld	s0,48(sp)
    80000ff4:	74a2                	ld	s1,40(sp)
    80000ff6:	7902                	ld	s2,32(sp)
    80000ff8:	69e2                	ld	s3,24(sp)
    80000ffa:	6a42                	ld	s4,16(sp)
    80000ffc:	6aa2                	ld	s5,8(sp)
    80000ffe:	6b02                	ld	s6,0(sp)
    80001000:	6121                	addi	sp,sp,64
    80001002:	8082                	ret
        return 0;
    80001004:	4501                	li	a0,0
    80001006:	b7ed                	j	80000ff0 <walk+0x82>

0000000080001008 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001008:	57fd                	li	a5,-1
    8000100a:	83e9                	srli	a5,a5,0x1a
    8000100c:	00b7f463          	bgeu	a5,a1,80001014 <walkaddr+0xc>
    return 0;
    80001010:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001012:	8082                	ret
{
    80001014:	1141                	addi	sp,sp,-16
    80001016:	e406                	sd	ra,8(sp)
    80001018:	e022                	sd	s0,0(sp)
    8000101a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000101c:	4601                	li	a2,0
    8000101e:	f51ff0ef          	jal	80000f6e <walk>
  if(pte == 0)
    80001022:	c105                	beqz	a0,80001042 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80001024:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001026:	0117f693          	andi	a3,a5,17
    8000102a:	4745                	li	a4,17
    return 0;
    8000102c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000102e:	00e68663          	beq	a3,a4,8000103a <walkaddr+0x32>
}
    80001032:	60a2                	ld	ra,8(sp)
    80001034:	6402                	ld	s0,0(sp)
    80001036:	0141                	addi	sp,sp,16
    80001038:	8082                	ret
  pa = PTE2PA(*pte);
    8000103a:	83a9                	srli	a5,a5,0xa
    8000103c:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001040:	bfcd                	j	80001032 <walkaddr+0x2a>
    return 0;
    80001042:	4501                	li	a0,0
    80001044:	b7fd                	j	80001032 <walkaddr+0x2a>

0000000080001046 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001046:	715d                	addi	sp,sp,-80
    80001048:	e486                	sd	ra,72(sp)
    8000104a:	e0a2                	sd	s0,64(sp)
    8000104c:	fc26                	sd	s1,56(sp)
    8000104e:	f84a                	sd	s2,48(sp)
    80001050:	f44e                	sd	s3,40(sp)
    80001052:	f052                	sd	s4,32(sp)
    80001054:	ec56                	sd	s5,24(sp)
    80001056:	e85a                	sd	s6,16(sp)
    80001058:	e45e                	sd	s7,8(sp)
    8000105a:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000105c:	03459793          	slli	a5,a1,0x34
    80001060:	e7a9                	bnez	a5,800010aa <mappages+0x64>
    80001062:	8aaa                	mv	s5,a0
    80001064:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80001066:	03461793          	slli	a5,a2,0x34
    8000106a:	e7b1                	bnez	a5,800010b6 <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    8000106c:	ca39                	beqz	a2,800010c2 <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000106e:	77fd                	lui	a5,0xfffff
    80001070:	963e                	add	a2,a2,a5
    80001072:	00b609b3          	add	s3,a2,a1
  a = va;
    80001076:	892e                	mv	s2,a1
    80001078:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000107c:	6b85                	lui	s7,0x1
    8000107e:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001082:	4605                	li	a2,1
    80001084:	85ca                	mv	a1,s2
    80001086:	8556                	mv	a0,s5
    80001088:	ee7ff0ef          	jal	80000f6e <walk>
    8000108c:	c539                	beqz	a0,800010da <mappages+0x94>
    if(*pte & PTE_V)
    8000108e:	611c                	ld	a5,0(a0)
    80001090:	8b85                	andi	a5,a5,1
    80001092:	ef95                	bnez	a5,800010ce <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001094:	80b1                	srli	s1,s1,0xc
    80001096:	04aa                	slli	s1,s1,0xa
    80001098:	0164e4b3          	or	s1,s1,s6
    8000109c:	0014e493          	ori	s1,s1,1
    800010a0:	e104                	sd	s1,0(a0)
    if(a == last)
    800010a2:	05390863          	beq	s2,s3,800010f2 <mappages+0xac>
    a += PGSIZE;
    800010a6:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800010a8:	bfd9                	j	8000107e <mappages+0x38>
    panic("mappages: va not aligned");
    800010aa:	00007517          	auipc	a0,0x7
    800010ae:	01650513          	addi	a0,a0,22 # 800080c0 <etext+0xc0>
    800010b2:	f14ff0ef          	jal	800007c6 <panic>
    panic("mappages: size not aligned");
    800010b6:	00007517          	auipc	a0,0x7
    800010ba:	02a50513          	addi	a0,a0,42 # 800080e0 <etext+0xe0>
    800010be:	f08ff0ef          	jal	800007c6 <panic>
    panic("mappages: size");
    800010c2:	00007517          	auipc	a0,0x7
    800010c6:	03e50513          	addi	a0,a0,62 # 80008100 <etext+0x100>
    800010ca:	efcff0ef          	jal	800007c6 <panic>
      panic("mappages: remap");
    800010ce:	00007517          	auipc	a0,0x7
    800010d2:	04250513          	addi	a0,a0,66 # 80008110 <etext+0x110>
    800010d6:	ef0ff0ef          	jal	800007c6 <panic>
      return -1;
    800010da:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010dc:	60a6                	ld	ra,72(sp)
    800010de:	6406                	ld	s0,64(sp)
    800010e0:	74e2                	ld	s1,56(sp)
    800010e2:	7942                	ld	s2,48(sp)
    800010e4:	79a2                	ld	s3,40(sp)
    800010e6:	7a02                	ld	s4,32(sp)
    800010e8:	6ae2                	ld	s5,24(sp)
    800010ea:	6b42                	ld	s6,16(sp)
    800010ec:	6ba2                	ld	s7,8(sp)
    800010ee:	6161                	addi	sp,sp,80
    800010f0:	8082                	ret
  return 0;
    800010f2:	4501                	li	a0,0
    800010f4:	b7e5                	j	800010dc <mappages+0x96>

00000000800010f6 <kvmmap>:
{
    800010f6:	1141                	addi	sp,sp,-16
    800010f8:	e406                	sd	ra,8(sp)
    800010fa:	e022                	sd	s0,0(sp)
    800010fc:	0800                	addi	s0,sp,16
    800010fe:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80001100:	86b2                	mv	a3,a2
    80001102:	863e                	mv	a2,a5
    80001104:	f43ff0ef          	jal	80001046 <mappages>
    80001108:	e509                	bnez	a0,80001112 <kvmmap+0x1c>
}
    8000110a:	60a2                	ld	ra,8(sp)
    8000110c:	6402                	ld	s0,0(sp)
    8000110e:	0141                	addi	sp,sp,16
    80001110:	8082                	ret
    panic("kvmmap");
    80001112:	00007517          	auipc	a0,0x7
    80001116:	00e50513          	addi	a0,a0,14 # 80008120 <etext+0x120>
    8000111a:	eacff0ef          	jal	800007c6 <panic>

000000008000111e <kvmmake>:
{
    8000111e:	1101                	addi	sp,sp,-32
    80001120:	ec06                	sd	ra,24(sp)
    80001122:	e822                	sd	s0,16(sp)
    80001124:	e426                	sd	s1,8(sp)
    80001126:	e04a                	sd	s2,0(sp)
    80001128:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000112a:	a2dff0ef          	jal	80000b56 <kalloc>
    8000112e:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001130:	6605                	lui	a2,0x1
    80001132:	4581                	li	a1,0
    80001134:	bc7ff0ef          	jal	80000cfa <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001138:	4719                	li	a4,6
    8000113a:	6685                	lui	a3,0x1
    8000113c:	10000637          	lui	a2,0x10000
    80001140:	100005b7          	lui	a1,0x10000
    80001144:	8526                	mv	a0,s1
    80001146:	fb1ff0ef          	jal	800010f6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000114a:	4719                	li	a4,6
    8000114c:	6685                	lui	a3,0x1
    8000114e:	10001637          	lui	a2,0x10001
    80001152:	100015b7          	lui	a1,0x10001
    80001156:	8526                	mv	a0,s1
    80001158:	f9fff0ef          	jal	800010f6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000115c:	4719                	li	a4,6
    8000115e:	040006b7          	lui	a3,0x4000
    80001162:	0c000637          	lui	a2,0xc000
    80001166:	0c0005b7          	lui	a1,0xc000
    8000116a:	8526                	mv	a0,s1
    8000116c:	f8bff0ef          	jal	800010f6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001170:	00007917          	auipc	s2,0x7
    80001174:	e9090913          	addi	s2,s2,-368 # 80008000 <etext>
    80001178:	4729                	li	a4,10
    8000117a:	80007697          	auipc	a3,0x80007
    8000117e:	e8668693          	addi	a3,a3,-378 # 8000 <_entry-0x7fff8000>
    80001182:	4605                	li	a2,1
    80001184:	067e                	slli	a2,a2,0x1f
    80001186:	85b2                	mv	a1,a2
    80001188:	8526                	mv	a0,s1
    8000118a:	f6dff0ef          	jal	800010f6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000118e:	46c5                	li	a3,17
    80001190:	06ee                	slli	a3,a3,0x1b
    80001192:	4719                	li	a4,6
    80001194:	412686b3          	sub	a3,a3,s2
    80001198:	864a                	mv	a2,s2
    8000119a:	85ca                	mv	a1,s2
    8000119c:	8526                	mv	a0,s1
    8000119e:	f59ff0ef          	jal	800010f6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800011a2:	4729                	li	a4,10
    800011a4:	6685                	lui	a3,0x1
    800011a6:	00006617          	auipc	a2,0x6
    800011aa:	e5a60613          	addi	a2,a2,-422 # 80007000 <_trampoline>
    800011ae:	040005b7          	lui	a1,0x4000
    800011b2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011b4:	05b2                	slli	a1,a1,0xc
    800011b6:	8526                	mv	a0,s1
    800011b8:	f3fff0ef          	jal	800010f6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011bc:	8526                	mv	a0,s1
    800011be:	0c7000ef          	jal	80001a84 <proc_mapstacks>
}
    800011c2:	8526                	mv	a0,s1
    800011c4:	60e2                	ld	ra,24(sp)
    800011c6:	6442                	ld	s0,16(sp)
    800011c8:	64a2                	ld	s1,8(sp)
    800011ca:	6902                	ld	s2,0(sp)
    800011cc:	6105                	addi	sp,sp,32
    800011ce:	8082                	ret

00000000800011d0 <kvminit>:
{
    800011d0:	1141                	addi	sp,sp,-16
    800011d2:	e406                	sd	ra,8(sp)
    800011d4:	e022                	sd	s0,0(sp)
    800011d6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011d8:	f47ff0ef          	jal	8000111e <kvmmake>
    800011dc:	0000a797          	auipc	a5,0xa
    800011e0:	68a7ba23          	sd	a0,1684(a5) # 8000b870 <kernel_pagetable>
}
    800011e4:	60a2                	ld	ra,8(sp)
    800011e6:	6402                	ld	s0,0(sp)
    800011e8:	0141                	addi	sp,sp,16
    800011ea:	8082                	ret

00000000800011ec <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011ec:	715d                	addi	sp,sp,-80
    800011ee:	e486                	sd	ra,72(sp)
    800011f0:	e0a2                	sd	s0,64(sp)
    800011f2:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800011f4:	03459793          	slli	a5,a1,0x34
    800011f8:	e39d                	bnez	a5,8000121e <uvmunmap+0x32>
    800011fa:	f84a                	sd	s2,48(sp)
    800011fc:	f44e                	sd	s3,40(sp)
    800011fe:	f052                	sd	s4,32(sp)
    80001200:	ec56                	sd	s5,24(sp)
    80001202:	e85a                	sd	s6,16(sp)
    80001204:	e45e                	sd	s7,8(sp)
    80001206:	8a2a                	mv	s4,a0
    80001208:	892e                	mv	s2,a1
    8000120a:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000120c:	0632                	slli	a2,a2,0xc
    8000120e:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001212:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001214:	6b05                	lui	s6,0x1
    80001216:	0735ff63          	bgeu	a1,s3,80001294 <uvmunmap+0xa8>
    8000121a:	fc26                	sd	s1,56(sp)
    8000121c:	a0a9                	j	80001266 <uvmunmap+0x7a>
    8000121e:	fc26                	sd	s1,56(sp)
    80001220:	f84a                	sd	s2,48(sp)
    80001222:	f44e                	sd	s3,40(sp)
    80001224:	f052                	sd	s4,32(sp)
    80001226:	ec56                	sd	s5,24(sp)
    80001228:	e85a                	sd	s6,16(sp)
    8000122a:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000122c:	00007517          	auipc	a0,0x7
    80001230:	efc50513          	addi	a0,a0,-260 # 80008128 <etext+0x128>
    80001234:	d92ff0ef          	jal	800007c6 <panic>
      panic("uvmunmap: walk");
    80001238:	00007517          	auipc	a0,0x7
    8000123c:	f0850513          	addi	a0,a0,-248 # 80008140 <etext+0x140>
    80001240:	d86ff0ef          	jal	800007c6 <panic>
      panic("uvmunmap: not mapped");
    80001244:	00007517          	auipc	a0,0x7
    80001248:	f0c50513          	addi	a0,a0,-244 # 80008150 <etext+0x150>
    8000124c:	d7aff0ef          	jal	800007c6 <panic>
      panic("uvmunmap: not a leaf");
    80001250:	00007517          	auipc	a0,0x7
    80001254:	f1850513          	addi	a0,a0,-232 # 80008168 <etext+0x168>
    80001258:	d6eff0ef          	jal	800007c6 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000125c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001260:	995a                	add	s2,s2,s6
    80001262:	03397863          	bgeu	s2,s3,80001292 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001266:	4601                	li	a2,0
    80001268:	85ca                	mv	a1,s2
    8000126a:	8552                	mv	a0,s4
    8000126c:	d03ff0ef          	jal	80000f6e <walk>
    80001270:	84aa                	mv	s1,a0
    80001272:	d179                	beqz	a0,80001238 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    80001274:	6108                	ld	a0,0(a0)
    80001276:	00157793          	andi	a5,a0,1
    8000127a:	d7e9                	beqz	a5,80001244 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000127c:	3ff57793          	andi	a5,a0,1023
    80001280:	fd7788e3          	beq	a5,s7,80001250 <uvmunmap+0x64>
    if(do_free){
    80001284:	fc0a8ce3          	beqz	s5,8000125c <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001288:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    8000128a:	0532                	slli	a0,a0,0xc
    8000128c:	fe8ff0ef          	jal	80000a74 <kfree>
    80001290:	b7f1                	j	8000125c <uvmunmap+0x70>
    80001292:	74e2                	ld	s1,56(sp)
    80001294:	7942                	ld	s2,48(sp)
    80001296:	79a2                	ld	s3,40(sp)
    80001298:	7a02                	ld	s4,32(sp)
    8000129a:	6ae2                	ld	s5,24(sp)
    8000129c:	6b42                	ld	s6,16(sp)
    8000129e:	6ba2                	ld	s7,8(sp)
  }
}
    800012a0:	60a6                	ld	ra,72(sp)
    800012a2:	6406                	ld	s0,64(sp)
    800012a4:	6161                	addi	sp,sp,80
    800012a6:	8082                	ret

00000000800012a8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800012a8:	1101                	addi	sp,sp,-32
    800012aa:	ec06                	sd	ra,24(sp)
    800012ac:	e822                	sd	s0,16(sp)
    800012ae:	e426                	sd	s1,8(sp)
    800012b0:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800012b2:	8a5ff0ef          	jal	80000b56 <kalloc>
    800012b6:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800012b8:	c509                	beqz	a0,800012c2 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800012ba:	6605                	lui	a2,0x1
    800012bc:	4581                	li	a1,0
    800012be:	a3dff0ef          	jal	80000cfa <memset>
  return pagetable;
}
    800012c2:	8526                	mv	a0,s1
    800012c4:	60e2                	ld	ra,24(sp)
    800012c6:	6442                	ld	s0,16(sp)
    800012c8:	64a2                	ld	s1,8(sp)
    800012ca:	6105                	addi	sp,sp,32
    800012cc:	8082                	ret

00000000800012ce <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800012ce:	7179                	addi	sp,sp,-48
    800012d0:	f406                	sd	ra,40(sp)
    800012d2:	f022                	sd	s0,32(sp)
    800012d4:	ec26                	sd	s1,24(sp)
    800012d6:	e84a                	sd	s2,16(sp)
    800012d8:	e44e                	sd	s3,8(sp)
    800012da:	e052                	sd	s4,0(sp)
    800012dc:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800012de:	6785                	lui	a5,0x1
    800012e0:	04f67063          	bgeu	a2,a5,80001320 <uvmfirst+0x52>
    800012e4:	8a2a                	mv	s4,a0
    800012e6:	89ae                	mv	s3,a1
    800012e8:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800012ea:	86dff0ef          	jal	80000b56 <kalloc>
    800012ee:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800012f0:	6605                	lui	a2,0x1
    800012f2:	4581                	li	a1,0
    800012f4:	a07ff0ef          	jal	80000cfa <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800012f8:	4779                	li	a4,30
    800012fa:	86ca                	mv	a3,s2
    800012fc:	6605                	lui	a2,0x1
    800012fe:	4581                	li	a1,0
    80001300:	8552                	mv	a0,s4
    80001302:	d45ff0ef          	jal	80001046 <mappages>
  memmove(mem, src, sz);
    80001306:	8626                	mv	a2,s1
    80001308:	85ce                	mv	a1,s3
    8000130a:	854a                	mv	a0,s2
    8000130c:	a4bff0ef          	jal	80000d56 <memmove>
}
    80001310:	70a2                	ld	ra,40(sp)
    80001312:	7402                	ld	s0,32(sp)
    80001314:	64e2                	ld	s1,24(sp)
    80001316:	6942                	ld	s2,16(sp)
    80001318:	69a2                	ld	s3,8(sp)
    8000131a:	6a02                	ld	s4,0(sp)
    8000131c:	6145                	addi	sp,sp,48
    8000131e:	8082                	ret
    panic("uvmfirst: more than a page");
    80001320:	00007517          	auipc	a0,0x7
    80001324:	e6050513          	addi	a0,a0,-416 # 80008180 <etext+0x180>
    80001328:	c9eff0ef          	jal	800007c6 <panic>

000000008000132c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000132c:	1101                	addi	sp,sp,-32
    8000132e:	ec06                	sd	ra,24(sp)
    80001330:	e822                	sd	s0,16(sp)
    80001332:	e426                	sd	s1,8(sp)
    80001334:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001336:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001338:	00b67d63          	bgeu	a2,a1,80001352 <uvmdealloc+0x26>
    8000133c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000133e:	6785                	lui	a5,0x1
    80001340:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001342:	00f60733          	add	a4,a2,a5
    80001346:	76fd                	lui	a3,0xfffff
    80001348:	8f75                	and	a4,a4,a3
    8000134a:	97ae                	add	a5,a5,a1
    8000134c:	8ff5                	and	a5,a5,a3
    8000134e:	00f76863          	bltu	a4,a5,8000135e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001352:	8526                	mv	a0,s1
    80001354:	60e2                	ld	ra,24(sp)
    80001356:	6442                	ld	s0,16(sp)
    80001358:	64a2                	ld	s1,8(sp)
    8000135a:	6105                	addi	sp,sp,32
    8000135c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000135e:	8f99                	sub	a5,a5,a4
    80001360:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001362:	4685                	li	a3,1
    80001364:	0007861b          	sext.w	a2,a5
    80001368:	85ba                	mv	a1,a4
    8000136a:	e83ff0ef          	jal	800011ec <uvmunmap>
    8000136e:	b7d5                	j	80001352 <uvmdealloc+0x26>

0000000080001370 <uvmalloc>:
  if(newsz < oldsz)
    80001370:	08b66f63          	bltu	a2,a1,8000140e <uvmalloc+0x9e>
{
    80001374:	7139                	addi	sp,sp,-64
    80001376:	fc06                	sd	ra,56(sp)
    80001378:	f822                	sd	s0,48(sp)
    8000137a:	ec4e                	sd	s3,24(sp)
    8000137c:	e852                	sd	s4,16(sp)
    8000137e:	e456                	sd	s5,8(sp)
    80001380:	0080                	addi	s0,sp,64
    80001382:	8aaa                	mv	s5,a0
    80001384:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001386:	6785                	lui	a5,0x1
    80001388:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000138a:	95be                	add	a1,a1,a5
    8000138c:	77fd                	lui	a5,0xfffff
    8000138e:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001392:	08c9f063          	bgeu	s3,a2,80001412 <uvmalloc+0xa2>
    80001396:	f426                	sd	s1,40(sp)
    80001398:	f04a                	sd	s2,32(sp)
    8000139a:	e05a                	sd	s6,0(sp)
    8000139c:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000139e:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800013a2:	fb4ff0ef          	jal	80000b56 <kalloc>
    800013a6:	84aa                	mv	s1,a0
    if(mem == 0){
    800013a8:	c515                	beqz	a0,800013d4 <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    800013aa:	6605                	lui	a2,0x1
    800013ac:	4581                	li	a1,0
    800013ae:	94dff0ef          	jal	80000cfa <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800013b2:	875a                	mv	a4,s6
    800013b4:	86a6                	mv	a3,s1
    800013b6:	6605                	lui	a2,0x1
    800013b8:	85ca                	mv	a1,s2
    800013ba:	8556                	mv	a0,s5
    800013bc:	c8bff0ef          	jal	80001046 <mappages>
    800013c0:	e915                	bnez	a0,800013f4 <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800013c2:	6785                	lui	a5,0x1
    800013c4:	993e                	add	s2,s2,a5
    800013c6:	fd496ee3          	bltu	s2,s4,800013a2 <uvmalloc+0x32>
  return newsz;
    800013ca:	8552                	mv	a0,s4
    800013cc:	74a2                	ld	s1,40(sp)
    800013ce:	7902                	ld	s2,32(sp)
    800013d0:	6b02                	ld	s6,0(sp)
    800013d2:	a811                	j	800013e6 <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    800013d4:	864e                	mv	a2,s3
    800013d6:	85ca                	mv	a1,s2
    800013d8:	8556                	mv	a0,s5
    800013da:	f53ff0ef          	jal	8000132c <uvmdealloc>
      return 0;
    800013de:	4501                	li	a0,0
    800013e0:	74a2                	ld	s1,40(sp)
    800013e2:	7902                	ld	s2,32(sp)
    800013e4:	6b02                	ld	s6,0(sp)
}
    800013e6:	70e2                	ld	ra,56(sp)
    800013e8:	7442                	ld	s0,48(sp)
    800013ea:	69e2                	ld	s3,24(sp)
    800013ec:	6a42                	ld	s4,16(sp)
    800013ee:	6aa2                	ld	s5,8(sp)
    800013f0:	6121                	addi	sp,sp,64
    800013f2:	8082                	ret
      kfree(mem);
    800013f4:	8526                	mv	a0,s1
    800013f6:	e7eff0ef          	jal	80000a74 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800013fa:	864e                	mv	a2,s3
    800013fc:	85ca                	mv	a1,s2
    800013fe:	8556                	mv	a0,s5
    80001400:	f2dff0ef          	jal	8000132c <uvmdealloc>
      return 0;
    80001404:	4501                	li	a0,0
    80001406:	74a2                	ld	s1,40(sp)
    80001408:	7902                	ld	s2,32(sp)
    8000140a:	6b02                	ld	s6,0(sp)
    8000140c:	bfe9                	j	800013e6 <uvmalloc+0x76>
    return oldsz;
    8000140e:	852e                	mv	a0,a1
}
    80001410:	8082                	ret
  return newsz;
    80001412:	8532                	mv	a0,a2
    80001414:	bfc9                	j	800013e6 <uvmalloc+0x76>

0000000080001416 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001416:	7179                	addi	sp,sp,-48
    80001418:	f406                	sd	ra,40(sp)
    8000141a:	f022                	sd	s0,32(sp)
    8000141c:	ec26                	sd	s1,24(sp)
    8000141e:	e84a                	sd	s2,16(sp)
    80001420:	e44e                	sd	s3,8(sp)
    80001422:	e052                	sd	s4,0(sp)
    80001424:	1800                	addi	s0,sp,48
    80001426:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001428:	84aa                	mv	s1,a0
    8000142a:	6905                	lui	s2,0x1
    8000142c:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000142e:	4985                	li	s3,1
    80001430:	a819                	j	80001446 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001432:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001434:	00c79513          	slli	a0,a5,0xc
    80001438:	fdfff0ef          	jal	80001416 <freewalk>
      pagetable[i] = 0;
    8000143c:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001440:	04a1                	addi	s1,s1,8
    80001442:	01248f63          	beq	s1,s2,80001460 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001446:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001448:	00f7f713          	andi	a4,a5,15
    8000144c:	ff3703e3          	beq	a4,s3,80001432 <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001450:	8b85                	andi	a5,a5,1
    80001452:	d7fd                	beqz	a5,80001440 <freewalk+0x2a>
      panic("freewalk: leaf");
    80001454:	00007517          	auipc	a0,0x7
    80001458:	d4c50513          	addi	a0,a0,-692 # 800081a0 <etext+0x1a0>
    8000145c:	b6aff0ef          	jal	800007c6 <panic>
    }
  }
  kfree((void*)pagetable);
    80001460:	8552                	mv	a0,s4
    80001462:	e12ff0ef          	jal	80000a74 <kfree>
}
    80001466:	70a2                	ld	ra,40(sp)
    80001468:	7402                	ld	s0,32(sp)
    8000146a:	64e2                	ld	s1,24(sp)
    8000146c:	6942                	ld	s2,16(sp)
    8000146e:	69a2                	ld	s3,8(sp)
    80001470:	6a02                	ld	s4,0(sp)
    80001472:	6145                	addi	sp,sp,48
    80001474:	8082                	ret

0000000080001476 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001476:	1101                	addi	sp,sp,-32
    80001478:	ec06                	sd	ra,24(sp)
    8000147a:	e822                	sd	s0,16(sp)
    8000147c:	e426                	sd	s1,8(sp)
    8000147e:	1000                	addi	s0,sp,32
    80001480:	84aa                	mv	s1,a0
  if(sz > 0)
    80001482:	e989                	bnez	a1,80001494 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001484:	8526                	mv	a0,s1
    80001486:	f91ff0ef          	jal	80001416 <freewalk>
}
    8000148a:	60e2                	ld	ra,24(sp)
    8000148c:	6442                	ld	s0,16(sp)
    8000148e:	64a2                	ld	s1,8(sp)
    80001490:	6105                	addi	sp,sp,32
    80001492:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001494:	6785                	lui	a5,0x1
    80001496:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001498:	95be                	add	a1,a1,a5
    8000149a:	4685                	li	a3,1
    8000149c:	00c5d613          	srli	a2,a1,0xc
    800014a0:	4581                	li	a1,0
    800014a2:	d4bff0ef          	jal	800011ec <uvmunmap>
    800014a6:	bff9                	j	80001484 <uvmfree+0xe>

00000000800014a8 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    800014a8:	c65d                	beqz	a2,80001556 <uvmcopy+0xae>
{
    800014aa:	715d                	addi	sp,sp,-80
    800014ac:	e486                	sd	ra,72(sp)
    800014ae:	e0a2                	sd	s0,64(sp)
    800014b0:	fc26                	sd	s1,56(sp)
    800014b2:	f84a                	sd	s2,48(sp)
    800014b4:	f44e                	sd	s3,40(sp)
    800014b6:	f052                	sd	s4,32(sp)
    800014b8:	ec56                	sd	s5,24(sp)
    800014ba:	e85a                	sd	s6,16(sp)
    800014bc:	e45e                	sd	s7,8(sp)
    800014be:	0880                	addi	s0,sp,80
    800014c0:	8b2a                	mv	s6,a0
    800014c2:	8aae                	mv	s5,a1
    800014c4:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    800014c6:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    800014c8:	4601                	li	a2,0
    800014ca:	85ce                	mv	a1,s3
    800014cc:	855a                	mv	a0,s6
    800014ce:	aa1ff0ef          	jal	80000f6e <walk>
    800014d2:	c121                	beqz	a0,80001512 <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    800014d4:	6118                	ld	a4,0(a0)
    800014d6:	00177793          	andi	a5,a4,1
    800014da:	c3b1                	beqz	a5,8000151e <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    800014dc:	00a75593          	srli	a1,a4,0xa
    800014e0:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    800014e4:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    800014e8:	e6eff0ef          	jal	80000b56 <kalloc>
    800014ec:	892a                	mv	s2,a0
    800014ee:	c129                	beqz	a0,80001530 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800014f0:	6605                	lui	a2,0x1
    800014f2:	85de                	mv	a1,s7
    800014f4:	863ff0ef          	jal	80000d56 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800014f8:	8726                	mv	a4,s1
    800014fa:	86ca                	mv	a3,s2
    800014fc:	6605                	lui	a2,0x1
    800014fe:	85ce                	mv	a1,s3
    80001500:	8556                	mv	a0,s5
    80001502:	b45ff0ef          	jal	80001046 <mappages>
    80001506:	e115                	bnez	a0,8000152a <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    80001508:	6785                	lui	a5,0x1
    8000150a:	99be                	add	s3,s3,a5
    8000150c:	fb49eee3          	bltu	s3,s4,800014c8 <uvmcopy+0x20>
    80001510:	a805                	j	80001540 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80001512:	00007517          	auipc	a0,0x7
    80001516:	c9e50513          	addi	a0,a0,-866 # 800081b0 <etext+0x1b0>
    8000151a:	aacff0ef          	jal	800007c6 <panic>
      panic("uvmcopy: page not present");
    8000151e:	00007517          	auipc	a0,0x7
    80001522:	cb250513          	addi	a0,a0,-846 # 800081d0 <etext+0x1d0>
    80001526:	aa0ff0ef          	jal	800007c6 <panic>
      kfree(mem);
    8000152a:	854a                	mv	a0,s2
    8000152c:	d48ff0ef          	jal	80000a74 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001530:	4685                	li	a3,1
    80001532:	00c9d613          	srli	a2,s3,0xc
    80001536:	4581                	li	a1,0
    80001538:	8556                	mv	a0,s5
    8000153a:	cb3ff0ef          	jal	800011ec <uvmunmap>
  return -1;
    8000153e:	557d                	li	a0,-1
}
    80001540:	60a6                	ld	ra,72(sp)
    80001542:	6406                	ld	s0,64(sp)
    80001544:	74e2                	ld	s1,56(sp)
    80001546:	7942                	ld	s2,48(sp)
    80001548:	79a2                	ld	s3,40(sp)
    8000154a:	7a02                	ld	s4,32(sp)
    8000154c:	6ae2                	ld	s5,24(sp)
    8000154e:	6b42                	ld	s6,16(sp)
    80001550:	6ba2                	ld	s7,8(sp)
    80001552:	6161                	addi	sp,sp,80
    80001554:	8082                	ret
  return 0;
    80001556:	4501                	li	a0,0
}
    80001558:	8082                	ret

000000008000155a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000155a:	1141                	addi	sp,sp,-16
    8000155c:	e406                	sd	ra,8(sp)
    8000155e:	e022                	sd	s0,0(sp)
    80001560:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001562:	4601                	li	a2,0
    80001564:	a0bff0ef          	jal	80000f6e <walk>
  if(pte == 0)
    80001568:	c901                	beqz	a0,80001578 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000156a:	611c                	ld	a5,0(a0)
    8000156c:	9bbd                	andi	a5,a5,-17
    8000156e:	e11c                	sd	a5,0(a0)
}
    80001570:	60a2                	ld	ra,8(sp)
    80001572:	6402                	ld	s0,0(sp)
    80001574:	0141                	addi	sp,sp,16
    80001576:	8082                	ret
    panic("uvmclear");
    80001578:	00007517          	auipc	a0,0x7
    8000157c:	c7850513          	addi	a0,a0,-904 # 800081f0 <etext+0x1f0>
    80001580:	a46ff0ef          	jal	800007c6 <panic>

0000000080001584 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001584:	cad1                	beqz	a3,80001618 <copyout+0x94>
{
    80001586:	711d                	addi	sp,sp,-96
    80001588:	ec86                	sd	ra,88(sp)
    8000158a:	e8a2                	sd	s0,80(sp)
    8000158c:	e4a6                	sd	s1,72(sp)
    8000158e:	fc4e                	sd	s3,56(sp)
    80001590:	f456                	sd	s5,40(sp)
    80001592:	f05a                	sd	s6,32(sp)
    80001594:	ec5e                	sd	s7,24(sp)
    80001596:	1080                	addi	s0,sp,96
    80001598:	8baa                	mv	s7,a0
    8000159a:	8aae                	mv	s5,a1
    8000159c:	8b32                	mv	s6,a2
    8000159e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    800015a0:	74fd                	lui	s1,0xfffff
    800015a2:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    800015a4:	57fd                	li	a5,-1
    800015a6:	83e9                	srli	a5,a5,0x1a
    800015a8:	0697ea63          	bltu	a5,s1,8000161c <copyout+0x98>
    800015ac:	e0ca                	sd	s2,64(sp)
    800015ae:	f852                	sd	s4,48(sp)
    800015b0:	e862                	sd	s8,16(sp)
    800015b2:	e466                	sd	s9,8(sp)
    800015b4:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015b6:	4cd5                	li	s9,21
    800015b8:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    800015ba:	8c3e                	mv	s8,a5
    800015bc:	a025                	j	800015e4 <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    800015be:	83a9                	srli	a5,a5,0xa
    800015c0:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    800015c2:	409a8533          	sub	a0,s5,s1
    800015c6:	0009061b          	sext.w	a2,s2
    800015ca:	85da                	mv	a1,s6
    800015cc:	953e                	add	a0,a0,a5
    800015ce:	f88ff0ef          	jal	80000d56 <memmove>

    len -= n;
    800015d2:	412989b3          	sub	s3,s3,s2
    src += n;
    800015d6:	9b4a                	add	s6,s6,s2
  while(len > 0){
    800015d8:	02098963          	beqz	s3,8000160a <copyout+0x86>
    if(va0 >= MAXVA)
    800015dc:	054c6263          	bltu	s8,s4,80001620 <copyout+0x9c>
    800015e0:	84d2                	mv	s1,s4
    800015e2:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    800015e4:	4601                	li	a2,0
    800015e6:	85a6                	mv	a1,s1
    800015e8:	855e                	mv	a0,s7
    800015ea:	985ff0ef          	jal	80000f6e <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    800015ee:	c121                	beqz	a0,8000162e <copyout+0xaa>
    800015f0:	611c                	ld	a5,0(a0)
    800015f2:	0157f713          	andi	a4,a5,21
    800015f6:	05971b63          	bne	a4,s9,8000164c <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    800015fa:	01a48a33          	add	s4,s1,s10
    800015fe:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80001602:	fb29fee3          	bgeu	s3,s2,800015be <copyout+0x3a>
    80001606:	894e                	mv	s2,s3
    80001608:	bf5d                	j	800015be <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    8000160a:	4501                	li	a0,0
    8000160c:	6906                	ld	s2,64(sp)
    8000160e:	7a42                	ld	s4,48(sp)
    80001610:	6c42                	ld	s8,16(sp)
    80001612:	6ca2                	ld	s9,8(sp)
    80001614:	6d02                	ld	s10,0(sp)
    80001616:	a015                	j	8000163a <copyout+0xb6>
    80001618:	4501                	li	a0,0
}
    8000161a:	8082                	ret
      return -1;
    8000161c:	557d                	li	a0,-1
    8000161e:	a831                	j	8000163a <copyout+0xb6>
    80001620:	557d                	li	a0,-1
    80001622:	6906                	ld	s2,64(sp)
    80001624:	7a42                	ld	s4,48(sp)
    80001626:	6c42                	ld	s8,16(sp)
    80001628:	6ca2                	ld	s9,8(sp)
    8000162a:	6d02                	ld	s10,0(sp)
    8000162c:	a039                	j	8000163a <copyout+0xb6>
      return -1;
    8000162e:	557d                	li	a0,-1
    80001630:	6906                	ld	s2,64(sp)
    80001632:	7a42                	ld	s4,48(sp)
    80001634:	6c42                	ld	s8,16(sp)
    80001636:	6ca2                	ld	s9,8(sp)
    80001638:	6d02                	ld	s10,0(sp)
}
    8000163a:	60e6                	ld	ra,88(sp)
    8000163c:	6446                	ld	s0,80(sp)
    8000163e:	64a6                	ld	s1,72(sp)
    80001640:	79e2                	ld	s3,56(sp)
    80001642:	7aa2                	ld	s5,40(sp)
    80001644:	7b02                	ld	s6,32(sp)
    80001646:	6be2                	ld	s7,24(sp)
    80001648:	6125                	addi	sp,sp,96
    8000164a:	8082                	ret
      return -1;
    8000164c:	557d                	li	a0,-1
    8000164e:	6906                	ld	s2,64(sp)
    80001650:	7a42                	ld	s4,48(sp)
    80001652:	6c42                	ld	s8,16(sp)
    80001654:	6ca2                	ld	s9,8(sp)
    80001656:	6d02                	ld	s10,0(sp)
    80001658:	b7cd                	j	8000163a <copyout+0xb6>

000000008000165a <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000165a:	c6a5                	beqz	a3,800016c2 <copyin+0x68>
{
    8000165c:	715d                	addi	sp,sp,-80
    8000165e:	e486                	sd	ra,72(sp)
    80001660:	e0a2                	sd	s0,64(sp)
    80001662:	fc26                	sd	s1,56(sp)
    80001664:	f84a                	sd	s2,48(sp)
    80001666:	f44e                	sd	s3,40(sp)
    80001668:	f052                	sd	s4,32(sp)
    8000166a:	ec56                	sd	s5,24(sp)
    8000166c:	e85a                	sd	s6,16(sp)
    8000166e:	e45e                	sd	s7,8(sp)
    80001670:	e062                	sd	s8,0(sp)
    80001672:	0880                	addi	s0,sp,80
    80001674:	8b2a                	mv	s6,a0
    80001676:	8a2e                	mv	s4,a1
    80001678:	8c32                	mv	s8,a2
    8000167a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000167c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000167e:	6a85                	lui	s5,0x1
    80001680:	a00d                	j	800016a2 <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001682:	018505b3          	add	a1,a0,s8
    80001686:	0004861b          	sext.w	a2,s1
    8000168a:	412585b3          	sub	a1,a1,s2
    8000168e:	8552                	mv	a0,s4
    80001690:	ec6ff0ef          	jal	80000d56 <memmove>

    len -= n;
    80001694:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001698:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    8000169a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000169e:	02098063          	beqz	s3,800016be <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    800016a2:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800016a6:	85ca                	mv	a1,s2
    800016a8:	855a                	mv	a0,s6
    800016aa:	95fff0ef          	jal	80001008 <walkaddr>
    if(pa0 == 0)
    800016ae:	cd01                	beqz	a0,800016c6 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    800016b0:	418904b3          	sub	s1,s2,s8
    800016b4:	94d6                	add	s1,s1,s5
    if(n > len)
    800016b6:	fc99f6e3          	bgeu	s3,s1,80001682 <copyin+0x28>
    800016ba:	84ce                	mv	s1,s3
    800016bc:	b7d9                	j	80001682 <copyin+0x28>
  }
  return 0;
    800016be:	4501                	li	a0,0
    800016c0:	a021                	j	800016c8 <copyin+0x6e>
    800016c2:	4501                	li	a0,0
}
    800016c4:	8082                	ret
      return -1;
    800016c6:	557d                	li	a0,-1
}
    800016c8:	60a6                	ld	ra,72(sp)
    800016ca:	6406                	ld	s0,64(sp)
    800016cc:	74e2                	ld	s1,56(sp)
    800016ce:	7942                	ld	s2,48(sp)
    800016d0:	79a2                	ld	s3,40(sp)
    800016d2:	7a02                	ld	s4,32(sp)
    800016d4:	6ae2                	ld	s5,24(sp)
    800016d6:	6b42                	ld	s6,16(sp)
    800016d8:	6ba2                	ld	s7,8(sp)
    800016da:	6c02                	ld	s8,0(sp)
    800016dc:	6161                	addi	sp,sp,80
    800016de:	8082                	ret

00000000800016e0 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800016e0:	c6dd                	beqz	a3,8000178e <copyinstr+0xae>
{
    800016e2:	715d                	addi	sp,sp,-80
    800016e4:	e486                	sd	ra,72(sp)
    800016e6:	e0a2                	sd	s0,64(sp)
    800016e8:	fc26                	sd	s1,56(sp)
    800016ea:	f84a                	sd	s2,48(sp)
    800016ec:	f44e                	sd	s3,40(sp)
    800016ee:	f052                	sd	s4,32(sp)
    800016f0:	ec56                	sd	s5,24(sp)
    800016f2:	e85a                	sd	s6,16(sp)
    800016f4:	e45e                	sd	s7,8(sp)
    800016f6:	0880                	addi	s0,sp,80
    800016f8:	8a2a                	mv	s4,a0
    800016fa:	8b2e                	mv	s6,a1
    800016fc:	8bb2                	mv	s7,a2
    800016fe:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80001700:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001702:	6985                	lui	s3,0x1
    80001704:	a825                	j	8000173c <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001706:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000170a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000170c:	37fd                	addiw	a5,a5,-1
    8000170e:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001712:	60a6                	ld	ra,72(sp)
    80001714:	6406                	ld	s0,64(sp)
    80001716:	74e2                	ld	s1,56(sp)
    80001718:	7942                	ld	s2,48(sp)
    8000171a:	79a2                	ld	s3,40(sp)
    8000171c:	7a02                	ld	s4,32(sp)
    8000171e:	6ae2                	ld	s5,24(sp)
    80001720:	6b42                	ld	s6,16(sp)
    80001722:	6ba2                	ld	s7,8(sp)
    80001724:	6161                	addi	sp,sp,80
    80001726:	8082                	ret
    80001728:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    8000172c:	9742                	add	a4,a4,a6
      --max;
    8000172e:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001732:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001736:	04e58463          	beq	a1,a4,8000177e <copyinstr+0x9e>
{
    8000173a:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    8000173c:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001740:	85a6                	mv	a1,s1
    80001742:	8552                	mv	a0,s4
    80001744:	8c5ff0ef          	jal	80001008 <walkaddr>
    if(pa0 == 0)
    80001748:	cd0d                	beqz	a0,80001782 <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    8000174a:	417486b3          	sub	a3,s1,s7
    8000174e:	96ce                	add	a3,a3,s3
    if(n > max)
    80001750:	00d97363          	bgeu	s2,a3,80001756 <copyinstr+0x76>
    80001754:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001756:	955e                	add	a0,a0,s7
    80001758:	8d05                	sub	a0,a0,s1
    while(n > 0){
    8000175a:	c695                	beqz	a3,80001786 <copyinstr+0xa6>
    8000175c:	87da                	mv	a5,s6
    8000175e:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001760:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001764:	96da                	add	a3,a3,s6
    80001766:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001768:	00f60733          	add	a4,a2,a5
    8000176c:	00074703          	lbu	a4,0(a4)
    80001770:	db59                	beqz	a4,80001706 <copyinstr+0x26>
        *dst = *p;
    80001772:	00e78023          	sb	a4,0(a5)
      dst++;
    80001776:	0785                	addi	a5,a5,1
    while(n > 0){
    80001778:	fed797e3          	bne	a5,a3,80001766 <copyinstr+0x86>
    8000177c:	b775                	j	80001728 <copyinstr+0x48>
    8000177e:	4781                	li	a5,0
    80001780:	b771                	j	8000170c <copyinstr+0x2c>
      return -1;
    80001782:	557d                	li	a0,-1
    80001784:	b779                	j	80001712 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001786:	6b85                	lui	s7,0x1
    80001788:	9ba6                	add	s7,s7,s1
    8000178a:	87da                	mv	a5,s6
    8000178c:	b77d                	j	8000173a <copyinstr+0x5a>
  int got_null = 0;
    8000178e:	4781                	li	a5,0
  if(got_null){
    80001790:	37fd                	addiw	a5,a5,-1
    80001792:	0007851b          	sext.w	a0,a5
}
    80001796:	8082                	ret

0000000080001798 <queue_init>:
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void queue_init(struct queue* q) {
    80001798:	1101                	addi	sp,sp,-32
    8000179a:	ec06                	sd	ra,24(sp)
    8000179c:	e822                	sd	s0,16(sp)
    8000179e:	e426                	sd	s1,8(sp)
    800017a0:	1000                	addi	s0,sp,32
    800017a2:	84aa                	mv	s1,a0
  acquire(&queuelock);
    800017a4:	00012517          	auipc	a0,0x12
    800017a8:	22450513          	addi	a0,a0,548 # 800139c8 <queuelock>
    800017ac:	c7aff0ef          	jal	80000c26 <acquire>
  q->front = 0;
    800017b0:	2004a023          	sw	zero,512(s1) # fffffffffffff200 <end+0xffffffff7ffd99b8>
  q->rear = 0;
    800017b4:	2004a223          	sw	zero,516(s1)
  q->num = 0;
    800017b8:	2004a423          	sw	zero,520(s1)

  for (int i = 0; i < NPROC; i++) { // queue 초기화
    800017bc:	87a6                	mv	a5,s1
    800017be:	20048713          	addi	a4,s1,512
    q->q[i] = 0;  
    800017c2:	0007b023          	sd	zero,0(a5)
  for (int i = 0; i < NPROC; i++) { // queue 초기화
    800017c6:	07a1                	addi	a5,a5,8
    800017c8:	fee79de3          	bne	a5,a4,800017c2 <queue_init+0x2a>
  }
  release(&queuelock);
    800017cc:	00012517          	auipc	a0,0x12
    800017d0:	1fc50513          	addi	a0,a0,508 # 800139c8 <queuelock>
    800017d4:	ceaff0ef          	jal	80000cbe <release>
}
    800017d8:	60e2                	ld	ra,24(sp)
    800017da:	6442                	ld	s0,16(sp)
    800017dc:	64a2                	ld	s1,8(sp)
    800017de:	6105                	addi	sp,sp,32
    800017e0:	8082                	ret

00000000800017e2 <queue_full>:

int queue_full(struct queue* q) {
    800017e2:	1101                	addi	sp,sp,-32
    800017e4:	ec06                	sd	ra,24(sp)
    800017e6:	e822                	sd	s0,16(sp)
    800017e8:	e426                	sd	s1,8(sp)
    800017ea:	e04a                	sd	s2,0(sp)
    800017ec:	1000                	addi	s0,sp,32
    800017ee:	84aa                	mv	s1,a0
  int result = 0;
  acquire(&queuelock);
    800017f0:	00012917          	auipc	s2,0x12
    800017f4:	1d890913          	addi	s2,s2,472 # 800139c8 <queuelock>
    800017f8:	854a                	mv	a0,s2
    800017fa:	c2cff0ef          	jal	80000c26 <acquire>
  if (q->num == NPROC) result = 1;
    800017fe:	2084a483          	lw	s1,520(s1)
    80001802:	fc048493          	addi	s1,s1,-64
    80001806:	0014b493          	seqz	s1,s1
  release(&queuelock);
    8000180a:	854a                	mv	a0,s2
    8000180c:	cb2ff0ef          	jal	80000cbe <release>
  return result;
}
    80001810:	8526                	mv	a0,s1
    80001812:	60e2                	ld	ra,24(sp)
    80001814:	6442                	ld	s0,16(sp)
    80001816:	64a2                	ld	s1,8(sp)
    80001818:	6902                	ld	s2,0(sp)
    8000181a:	6105                	addi	sp,sp,32
    8000181c:	8082                	ret

000000008000181e <queue_empty>:

int queue_empty(struct queue* q) {
    8000181e:	1101                	addi	sp,sp,-32
    80001820:	ec06                	sd	ra,24(sp)
    80001822:	e822                	sd	s0,16(sp)
    80001824:	e426                	sd	s1,8(sp)
    80001826:	e04a                	sd	s2,0(sp)
    80001828:	1000                	addi	s0,sp,32
    8000182a:	84aa                	mv	s1,a0
  int result = 0;
  acquire(&queuelock);
    8000182c:	00012917          	auipc	s2,0x12
    80001830:	19c90913          	addi	s2,s2,412 # 800139c8 <queuelock>
    80001834:	854a                	mv	a0,s2
    80001836:	bf0ff0ef          	jal	80000c26 <acquire>
  if (q->num == 0) result = 1;
    8000183a:	2084a483          	lw	s1,520(s1)
    8000183e:	0014b493          	seqz	s1,s1
  release(&queuelock);
    80001842:	854a                	mv	a0,s2
    80001844:	c7aff0ef          	jal	80000cbe <release>
  return result;
}
    80001848:	8526                	mv	a0,s1
    8000184a:	60e2                	ld	ra,24(sp)
    8000184c:	6442                	ld	s0,16(sp)
    8000184e:	64a2                	ld	s1,8(sp)
    80001850:	6902                	ld	s2,0(sp)
    80001852:	6105                	addi	sp,sp,32
    80001854:	8082                	ret

0000000080001856 <queue_pop>:

struct proc* queue_pop(struct queue* q) {
    80001856:	7179                	addi	sp,sp,-48
    80001858:	f406                	sd	ra,40(sp)
    8000185a:	f022                	sd	s0,32(sp)
    8000185c:	ec26                	sd	s1,24(sp)
    8000185e:	e84a                	sd	s2,16(sp)
    80001860:	e44e                	sd	s3,8(sp)
    80001862:	1800                	addi	s0,sp,48
    80001864:	84aa                	mv	s1,a0
  acquire(&queuelock);
    80001866:	00012997          	auipc	s3,0x12
    8000186a:	16298993          	addi	s3,s3,354 # 800139c8 <queuelock>
    8000186e:	854e                	mv	a0,s3
    80001870:	bb6ff0ef          	jal	80000c26 <acquire>
  int temp = q->front;
    80001874:	2004a903          	lw	s2,512(s1)
  q->front = (q->front + 1) % NPROC;
    80001878:	0019079b          	addiw	a5,s2,1
    8000187c:	41f7d71b          	sraiw	a4,a5,0x1f
    80001880:	01a7571b          	srliw	a4,a4,0x1a
    80001884:	9fb9                	addw	a5,a5,a4
    80001886:	03f7f793          	andi	a5,a5,63
    8000188a:	9f99                	subw	a5,a5,a4
    8000188c:	20f4a023          	sw	a5,512(s1)
  q->num--;
    80001890:	2084a783          	lw	a5,520(s1)
    80001894:	37fd                	addiw	a5,a5,-1
    80001896:	20f4a423          	sw	a5,520(s1)
  release(&queuelock);
    8000189a:	854e                	mv	a0,s3
    8000189c:	c22ff0ef          	jal	80000cbe <release>

  return q->q[temp];  
    800018a0:	090e                	slli	s2,s2,0x3
    800018a2:	94ca                	add	s1,s1,s2
}
    800018a4:	6088                	ld	a0,0(s1)
    800018a6:	70a2                	ld	ra,40(sp)
    800018a8:	7402                	ld	s0,32(sp)
    800018aa:	64e2                	ld	s1,24(sp)
    800018ac:	6942                	ld	s2,16(sp)
    800018ae:	69a2                	ld	s3,8(sp)
    800018b0:	6145                	addi	sp,sp,48
    800018b2:	8082                	ret

00000000800018b4 <queue_push>:

void queue_push(struct queue* q, struct proc* p) {
    800018b4:	7179                	addi	sp,sp,-48
    800018b6:	f406                	sd	ra,40(sp)
    800018b8:	f022                	sd	s0,32(sp)
    800018ba:	ec26                	sd	s1,24(sp)
    800018bc:	e84a                	sd	s2,16(sp)
    800018be:	e44e                	sd	s3,8(sp)
    800018c0:	1800                	addi	s0,sp,48
    800018c2:	84aa                	mv	s1,a0
    800018c4:	89ae                	mv	s3,a1
  acquire(&queuelock);
    800018c6:	00012917          	auipc	s2,0x12
    800018ca:	10290913          	addi	s2,s2,258 # 800139c8 <queuelock>
    800018ce:	854a                	mv	a0,s2
    800018d0:	b56ff0ef          	jal	80000c26 <acquire>
  q->q[q->rear] = p;
    800018d4:	2044a783          	lw	a5,516(s1)
    800018d8:	00379713          	slli	a4,a5,0x3
    800018dc:	9726                	add	a4,a4,s1
    800018de:	01373023          	sd	s3,0(a4)
  q->num++;
    800018e2:	2084a703          	lw	a4,520(s1)
    800018e6:	2705                	addiw	a4,a4,1
    800018e8:	20e4a423          	sw	a4,520(s1)
  q->rear = (q->rear + 1) % NPROC;
    800018ec:	2785                	addiw	a5,a5,1
    800018ee:	41f7d71b          	sraiw	a4,a5,0x1f
    800018f2:	01a7571b          	srliw	a4,a4,0x1a
    800018f6:	9fb9                	addw	a5,a5,a4
    800018f8:	03f7f793          	andi	a5,a5,63
    800018fc:	9f99                	subw	a5,a5,a4
    800018fe:	20f4a223          	sw	a5,516(s1)
  release(&queuelock);
    80001902:	854a                	mv	a0,s2
    80001904:	bbaff0ef          	jal	80000cbe <release>
} 
    80001908:	70a2                	ld	ra,40(sp)
    8000190a:	7402                	ld	s0,32(sp)
    8000190c:	64e2                	ld	s1,24(sp)
    8000190e:	6942                	ld	s2,16(sp)
    80001910:	69a2                	ld	s3,8(sp)
    80001912:	6145                	addi	sp,sp,48
    80001914:	8082                	ret

0000000080001916 <fcfs_init>:

void fcfs_init(void) {
    80001916:	1141                	addi	sp,sp,-16
    80001918:	e406                	sd	ra,8(sp)
    8000191a:	e022                	sd	s0,0(sp)
    8000191c:	0800                	addi	s0,sp,16
  queue_init(&fcfs.entry);
    8000191e:	00012517          	auipc	a0,0x12
    80001922:	0c250513          	addi	a0,a0,194 # 800139e0 <fcfs>
    80001926:	e73ff0ef          	jal	80001798 <queue_init>
}
    8000192a:	60a2                	ld	ra,8(sp)
    8000192c:	6402                	ld	s0,0(sp)
    8000192e:	0141                	addi	sp,sp,16
    80001930:	8082                	ret

0000000080001932 <fcfs_full>:

int fcfs_full(void) {
    80001932:	1141                	addi	sp,sp,-16
    80001934:	e406                	sd	ra,8(sp)
    80001936:	e022                	sd	s0,0(sp)
    80001938:	0800                	addi	s0,sp,16
  return queue_full(&fcfs.entry);
    8000193a:	00012517          	auipc	a0,0x12
    8000193e:	0a650513          	addi	a0,a0,166 # 800139e0 <fcfs>
    80001942:	ea1ff0ef          	jal	800017e2 <queue_full>
}
    80001946:	60a2                	ld	ra,8(sp)
    80001948:	6402                	ld	s0,0(sp)
    8000194a:	0141                	addi	sp,sp,16
    8000194c:	8082                	ret

000000008000194e <fcfs_empty>:

int fcfs_empty(void) {
    8000194e:	1141                	addi	sp,sp,-16
    80001950:	e406                	sd	ra,8(sp)
    80001952:	e022                	sd	s0,0(sp)
    80001954:	0800                	addi	s0,sp,16
  return queue_empty(&fcfs.entry);
    80001956:	00012517          	auipc	a0,0x12
    8000195a:	08a50513          	addi	a0,a0,138 # 800139e0 <fcfs>
    8000195e:	ec1ff0ef          	jal	8000181e <queue_empty>
}
    80001962:	60a2                	ld	ra,8(sp)
    80001964:	6402                	ld	s0,0(sp)
    80001966:	0141                	addi	sp,sp,16
    80001968:	8082                	ret

000000008000196a <fcfs_pop>:

struct proc* fcfs_pop(void) {
    8000196a:	1141                	addi	sp,sp,-16
    8000196c:	e406                	sd	ra,8(sp)
    8000196e:	e022                	sd	s0,0(sp)
    80001970:	0800                	addi	s0,sp,16
  return queue_pop(&fcfs.entry);
    80001972:	00012517          	auipc	a0,0x12
    80001976:	06e50513          	addi	a0,a0,110 # 800139e0 <fcfs>
    8000197a:	eddff0ef          	jal	80001856 <queue_pop>
}
    8000197e:	60a2                	ld	ra,8(sp)
    80001980:	6402                	ld	s0,0(sp)
    80001982:	0141                	addi	sp,sp,16
    80001984:	8082                	ret

0000000080001986 <fcfs_push>:

void fcfs_push(struct proc* p) {
  if (p->state == RUNNABLE) queue_push(&fcfs.entry, p);
    80001986:	4d18                	lw	a4,24(a0)
    80001988:	478d                	li	a5,3
    8000198a:	00f70363          	beq	a4,a5,80001990 <fcfs_push+0xa>
    8000198e:	8082                	ret
void fcfs_push(struct proc* p) {
    80001990:	1141                	addi	sp,sp,-16
    80001992:	e406                	sd	ra,8(sp)
    80001994:	e022                	sd	s0,0(sp)
    80001996:	0800                	addi	s0,sp,16
  if (p->state == RUNNABLE) queue_push(&fcfs.entry, p);
    80001998:	85aa                	mv	a1,a0
    8000199a:	00012517          	auipc	a0,0x12
    8000199e:	04650513          	addi	a0,a0,70 # 800139e0 <fcfs>
    800019a2:	f13ff0ef          	jal	800018b4 <queue_push>
}
    800019a6:	60a2                	ld	ra,8(sp)
    800019a8:	6402                	ld	s0,0(sp)
    800019aa:	0141                	addi	sp,sp,16
    800019ac:	8082                	ret

00000000800019ae <mlfq_init>:

void mlfq_init(void) {
    800019ae:	1141                	addi	sp,sp,-16
    800019b0:	e406                	sd	ra,8(sp)
    800019b2:	e022                	sd	s0,0(sp)
    800019b4:	0800                	addi	s0,sp,16
  for (int i = 0; i < 3; i++) {
    queue_init(&mlfq.entry[i]);
    800019b6:	00012517          	auipc	a0,0x12
    800019ba:	23a50513          	addi	a0,a0,570 # 80013bf0 <mlfq>
    800019be:	ddbff0ef          	jal	80001798 <queue_init>
    800019c2:	00012517          	auipc	a0,0x12
    800019c6:	43e50513          	addi	a0,a0,1086 # 80013e00 <mlfq+0x210>
    800019ca:	dcfff0ef          	jal	80001798 <queue_init>
    800019ce:	00012517          	auipc	a0,0x12
    800019d2:	64250513          	addi	a0,a0,1602 # 80014010 <mlfq+0x420>
    800019d6:	dc3ff0ef          	jal	80001798 <queue_init>
  }
}
    800019da:	60a2                	ld	ra,8(sp)
    800019dc:	6402                	ld	s0,0(sp)
    800019de:	0141                	addi	sp,sp,16
    800019e0:	8082                	ret

00000000800019e2 <mlfq_full>:

int mlfq_full(int level) {
    800019e2:	1141                	addi	sp,sp,-16
    800019e4:	e406                	sd	ra,8(sp)
    800019e6:	e022                	sd	s0,0(sp)
    800019e8:	0800                	addi	s0,sp,16
  return queue_full(&mlfq.entry[level]);
    800019ea:	00551793          	slli	a5,a0,0x5
    800019ee:	97aa                	add	a5,a5,a0
    800019f0:	0792                	slli	a5,a5,0x4
    800019f2:	00012517          	auipc	a0,0x12
    800019f6:	1fe50513          	addi	a0,a0,510 # 80013bf0 <mlfq>
    800019fa:	953e                	add	a0,a0,a5
    800019fc:	de7ff0ef          	jal	800017e2 <queue_full>
}
    80001a00:	60a2                	ld	ra,8(sp)
    80001a02:	6402                	ld	s0,0(sp)
    80001a04:	0141                	addi	sp,sp,16
    80001a06:	8082                	ret

0000000080001a08 <mlfq_empty>:

int mlfq_empty(int level) {
    80001a08:	1141                	addi	sp,sp,-16
    80001a0a:	e406                	sd	ra,8(sp)
    80001a0c:	e022                	sd	s0,0(sp)
    80001a0e:	0800                	addi	s0,sp,16
  return queue_empty(&mlfq.entry[level]);
    80001a10:	00551793          	slli	a5,a0,0x5
    80001a14:	97aa                	add	a5,a5,a0
    80001a16:	0792                	slli	a5,a5,0x4
    80001a18:	00012517          	auipc	a0,0x12
    80001a1c:	1d850513          	addi	a0,a0,472 # 80013bf0 <mlfq>
    80001a20:	953e                	add	a0,a0,a5
    80001a22:	dfdff0ef          	jal	8000181e <queue_empty>
}
    80001a26:	60a2                	ld	ra,8(sp)
    80001a28:	6402                	ld	s0,0(sp)
    80001a2a:	0141                	addi	sp,sp,16
    80001a2c:	8082                	ret

0000000080001a2e <mlfq_pop>:

struct proc* mlfq_pop(int level) {
    80001a2e:	1141                	addi	sp,sp,-16
    80001a30:	e406                	sd	ra,8(sp)
    80001a32:	e022                	sd	s0,0(sp)
    80001a34:	0800                	addi	s0,sp,16
  return queue_pop(&mlfq.entry[level]);
    80001a36:	00551793          	slli	a5,a0,0x5
    80001a3a:	97aa                	add	a5,a5,a0
    80001a3c:	0792                	slli	a5,a5,0x4
    80001a3e:	00012517          	auipc	a0,0x12
    80001a42:	1b250513          	addi	a0,a0,434 # 80013bf0 <mlfq>
    80001a46:	953e                	add	a0,a0,a5
    80001a48:	e0fff0ef          	jal	80001856 <queue_pop>
}
    80001a4c:	60a2                	ld	ra,8(sp)
    80001a4e:	6402                	ld	s0,0(sp)
    80001a50:	0141                	addi	sp,sp,16
    80001a52:	8082                	ret

0000000080001a54 <mlfq_push>:

void mlfq_push(int level, struct proc* p) {
  if (p->state == RUNNABLE) queue_push(&mlfq.entry[level], p);
    80001a54:	4d98                	lw	a4,24(a1)
    80001a56:	478d                	li	a5,3
    80001a58:	00f70363          	beq	a4,a5,80001a5e <mlfq_push+0xa>
    80001a5c:	8082                	ret
void mlfq_push(int level, struct proc* p) {
    80001a5e:	1141                	addi	sp,sp,-16
    80001a60:	e406                	sd	ra,8(sp)
    80001a62:	e022                	sd	s0,0(sp)
    80001a64:	0800                	addi	s0,sp,16
  if (p->state == RUNNABLE) queue_push(&mlfq.entry[level], p);
    80001a66:	00551793          	slli	a5,a0,0x5
    80001a6a:	97aa                	add	a5,a5,a0
    80001a6c:	0792                	slli	a5,a5,0x4
    80001a6e:	00012517          	auipc	a0,0x12
    80001a72:	18250513          	addi	a0,a0,386 # 80013bf0 <mlfq>
    80001a76:	953e                	add	a0,a0,a5
    80001a78:	e3dff0ef          	jal	800018b4 <queue_push>
}
    80001a7c:	60a2                	ld	ra,8(sp)
    80001a7e:	6402                	ld	s0,0(sp)
    80001a80:	0141                	addi	sp,sp,16
    80001a82:	8082                	ret

0000000080001a84 <proc_mapstacks>:

void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001a84:	7139                	addi	sp,sp,-64
    80001a86:	fc06                	sd	ra,56(sp)
    80001a88:	f822                	sd	s0,48(sp)
    80001a8a:	f426                	sd	s1,40(sp)
    80001a8c:	f04a                	sd	s2,32(sp)
    80001a8e:	ec4e                	sd	s3,24(sp)
    80001a90:	e852                	sd	s4,16(sp)
    80001a92:	e456                	sd	s5,8(sp)
    80001a94:	e05a                	sd	s6,0(sp)
    80001a96:	0080                	addi	s0,sp,64
    80001a98:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a9a:	00013497          	auipc	s1,0x13
    80001a9e:	bce48493          	addi	s1,s1,-1074 # 80014668 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001aa2:	8b26                	mv	s6,s1
    80001aa4:	00a36937          	lui	s2,0xa36
    80001aa8:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    80001aac:	0932                	slli	s2,s2,0xc
    80001aae:	46d90913          	addi	s2,s2,1133
    80001ab2:	0936                	slli	s2,s2,0xd
    80001ab4:	df590913          	addi	s2,s2,-523
    80001ab8:	093a                	slli	s2,s2,0xe
    80001aba:	6cf90913          	addi	s2,s2,1743
    80001abe:	040009b7          	lui	s3,0x4000
    80001ac2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001ac4:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ac6:	00019a97          	auipc	s5,0x19
    80001aca:	9a2a8a93          	addi	s5,s5,-1630 # 8001a468 <tickslock>
    char *pa = kalloc();
    80001ace:	888ff0ef          	jal	80000b56 <kalloc>
    80001ad2:	862a                	mv	a2,a0
    if(pa == 0)
    80001ad4:	cd15                	beqz	a0,80001b10 <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80001ad6:	416485b3          	sub	a1,s1,s6
    80001ada:	858d                	srai	a1,a1,0x3
    80001adc:	032585b3          	mul	a1,a1,s2
    80001ae0:	2585                	addiw	a1,a1,1
    80001ae2:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001ae6:	4719                	li	a4,6
    80001ae8:	6685                	lui	a3,0x1
    80001aea:	40b985b3          	sub	a1,s3,a1
    80001aee:	8552                	mv	a0,s4
    80001af0:	e06ff0ef          	jal	800010f6 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001af4:	17848493          	addi	s1,s1,376
    80001af8:	fd549be3          	bne	s1,s5,80001ace <proc_mapstacks+0x4a>
  }
}
    80001afc:	70e2                	ld	ra,56(sp)
    80001afe:	7442                	ld	s0,48(sp)
    80001b00:	74a2                	ld	s1,40(sp)
    80001b02:	7902                	ld	s2,32(sp)
    80001b04:	69e2                	ld	s3,24(sp)
    80001b06:	6a42                	ld	s4,16(sp)
    80001b08:	6aa2                	ld	s5,8(sp)
    80001b0a:	6b02                	ld	s6,0(sp)
    80001b0c:	6121                	addi	sp,sp,64
    80001b0e:	8082                	ret
      panic("kalloc");
    80001b10:	00006517          	auipc	a0,0x6
    80001b14:	6f050513          	addi	a0,a0,1776 # 80008200 <etext+0x200>
    80001b18:	caffe0ef          	jal	800007c6 <panic>

0000000080001b1c <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001b1c:	7139                	addi	sp,sp,-64
    80001b1e:	fc06                	sd	ra,56(sp)
    80001b20:	f822                	sd	s0,48(sp)
    80001b22:	f426                	sd	s1,40(sp)
    80001b24:	f04a                	sd	s2,32(sp)
    80001b26:	ec4e                	sd	s3,24(sp)
    80001b28:	e852                	sd	s4,16(sp)
    80001b2a:	e456                	sd	s5,8(sp)
    80001b2c:	e05a                	sd	s6,0(sp)
    80001b2e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001b30:	00006597          	auipc	a1,0x6
    80001b34:	6d858593          	addi	a1,a1,1752 # 80008208 <etext+0x208>
    80001b38:	00012517          	auipc	a0,0x12
    80001b3c:	6e850513          	addi	a0,a0,1768 # 80014220 <pid_lock>
    80001b40:	866ff0ef          	jal	80000ba6 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001b44:	00006597          	auipc	a1,0x6
    80001b48:	6cc58593          	addi	a1,a1,1740 # 80008210 <etext+0x210>
    80001b4c:	00012517          	auipc	a0,0x12
    80001b50:	6ec50513          	addi	a0,a0,1772 # 80014238 <wait_lock>
    80001b54:	852ff0ef          	jal	80000ba6 <initlock>
  initlock(&queuelock, "queue_lock"); // 처음에 한번만 호출되도록
    80001b58:	00006597          	auipc	a1,0x6
    80001b5c:	6c858593          	addi	a1,a1,1736 # 80008220 <etext+0x220>
    80001b60:	00012517          	auipc	a0,0x12
    80001b64:	e6850513          	addi	a0,a0,-408 # 800139c8 <queuelock>
    80001b68:	83eff0ef          	jal	80000ba6 <initlock>
  initlock(&modelock, "modelock");
    80001b6c:	00006597          	auipc	a1,0x6
    80001b70:	6c458593          	addi	a1,a1,1732 # 80008230 <etext+0x230>
    80001b74:	00012517          	auipc	a0,0x12
    80001b78:	6dc50513          	addi	a0,a0,1756 # 80014250 <modelock>
    80001b7c:	82aff0ef          	jal	80000ba6 <initlock>

  for(p = proc; p < &proc[NPROC]; p++) {
    80001b80:	00013497          	auipc	s1,0x13
    80001b84:	ae848493          	addi	s1,s1,-1304 # 80014668 <proc>
      initlock(&p->lock, "proc");
    80001b88:	00006b17          	auipc	s6,0x6
    80001b8c:	6b8b0b13          	addi	s6,s6,1720 # 80008240 <etext+0x240>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001b90:	8aa6                	mv	s5,s1
    80001b92:	00a36937          	lui	s2,0xa36
    80001b96:	77d90913          	addi	s2,s2,1917 # a3677d <_entry-0x7f5c9883>
    80001b9a:	0932                	slli	s2,s2,0xc
    80001b9c:	46d90913          	addi	s2,s2,1133
    80001ba0:	0936                	slli	s2,s2,0xd
    80001ba2:	df590913          	addi	s2,s2,-523
    80001ba6:	093a                	slli	s2,s2,0xe
    80001ba8:	6cf90913          	addi	s2,s2,1743
    80001bac:	040009b7          	lui	s3,0x4000
    80001bb0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001bb2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bb4:	00019a17          	auipc	s4,0x19
    80001bb8:	8b4a0a13          	addi	s4,s4,-1868 # 8001a468 <tickslock>
      initlock(&p->lock, "proc");
    80001bbc:	85da                	mv	a1,s6
    80001bbe:	8526                	mv	a0,s1
    80001bc0:	fe7fe0ef          	jal	80000ba6 <initlock>
      p->state = UNUSED;
    80001bc4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001bc8:	415487b3          	sub	a5,s1,s5
    80001bcc:	878d                	srai	a5,a5,0x3
    80001bce:	032787b3          	mul	a5,a5,s2
    80001bd2:	2785                	addiw	a5,a5,1
    80001bd4:	00d7979b          	slliw	a5,a5,0xd
    80001bd8:	40f987b3          	sub	a5,s3,a5
    80001bdc:	e8bc                	sd	a5,80(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001bde:	17848493          	addi	s1,s1,376
    80001be2:	fd449de3          	bne	s1,s4,80001bbc <procinit+0xa0>
  }
}
    80001be6:	70e2                	ld	ra,56(sp)
    80001be8:	7442                	ld	s0,48(sp)
    80001bea:	74a2                	ld	s1,40(sp)
    80001bec:	7902                	ld	s2,32(sp)
    80001bee:	69e2                	ld	s3,24(sp)
    80001bf0:	6a42                	ld	s4,16(sp)
    80001bf2:	6aa2                	ld	s5,8(sp)
    80001bf4:	6b02                	ld	s6,0(sp)
    80001bf6:	6121                	addi	sp,sp,64
    80001bf8:	8082                	ret

0000000080001bfa <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80001bfa:	1141                	addi	sp,sp,-16
    80001bfc:	e422                	sd	s0,8(sp)
    80001bfe:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001c00:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001c02:	2501                	sext.w	a0,a0
    80001c04:	6422                	ld	s0,8(sp)
    80001c06:	0141                	addi	sp,sp,16
    80001c08:	8082                	ret

0000000080001c0a <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001c0a:	1141                	addi	sp,sp,-16
    80001c0c:	e422                	sd	s0,8(sp)
    80001c0e:	0800                	addi	s0,sp,16
    80001c10:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001c12:	2781                	sext.w	a5,a5
    80001c14:	079e                	slli	a5,a5,0x7
  return c;
}
    80001c16:	00012517          	auipc	a0,0x12
    80001c1a:	65250513          	addi	a0,a0,1618 # 80014268 <cpus>
    80001c1e:	953e                	add	a0,a0,a5
    80001c20:	6422                	ld	s0,8(sp)
    80001c22:	0141                	addi	sp,sp,16
    80001c24:	8082                	ret

0000000080001c26 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001c26:	1101                	addi	sp,sp,-32
    80001c28:	ec06                	sd	ra,24(sp)
    80001c2a:	e822                	sd	s0,16(sp)
    80001c2c:	e426                	sd	s1,8(sp)
    80001c2e:	1000                	addi	s0,sp,32
  push_off();
    80001c30:	fb7fe0ef          	jal	80000be6 <push_off>
    80001c34:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001c36:	2781                	sext.w	a5,a5
    80001c38:	079e                	slli	a5,a5,0x7
    80001c3a:	00013717          	auipc	a4,0x13
    80001c3e:	d8e70713          	addi	a4,a4,-626 # 800149c8 <proc+0x360>
    80001c42:	97ba                	add	a5,a5,a4
    80001c44:	8a07b483          	ld	s1,-1888(a5)
  pop_off();
    80001c48:	822ff0ef          	jal	80000c6a <pop_off>
  return p;
}
    80001c4c:	8526                	mv	a0,s1
    80001c4e:	60e2                	ld	ra,24(sp)
    80001c50:	6442                	ld	s0,16(sp)
    80001c52:	64a2                	ld	s1,8(sp)
    80001c54:	6105                	addi	sp,sp,32
    80001c56:	8082                	ret

0000000080001c58 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001c58:	1141                	addi	sp,sp,-16
    80001c5a:	e406                	sd	ra,8(sp)
    80001c5c:	e022                	sd	s0,0(sp)
    80001c5e:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80001c60:	fc7ff0ef          	jal	80001c26 <myproc>
    80001c64:	85aff0ef          	jal	80000cbe <release>

  if (first) {
    80001c68:	0000a797          	auipc	a5,0xa
    80001c6c:	b787a783          	lw	a5,-1160(a5) # 8000b7e0 <first.1>
    80001c70:	e799                	bnez	a5,80001c7e <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80001c72:	256010ef          	jal	80002ec8 <usertrapret>
}
    80001c76:	60a2                	ld	ra,8(sp)
    80001c78:	6402                	ld	s0,0(sp)
    80001c7a:	0141                	addi	sp,sp,16
    80001c7c:	8082                	ret
    fsinit(ROOTDEV);
    80001c7e:	4505                	li	a0,1
    80001c80:	0e0020ef          	jal	80003d60 <fsinit>
    first = 0;
    80001c84:	0000a797          	auipc	a5,0xa
    80001c88:	b407ae23          	sw	zero,-1188(a5) # 8000b7e0 <first.1>
    __sync_synchronize();
    80001c8c:	0330000f          	fence	rw,rw
    80001c90:	b7cd                	j	80001c72 <forkret+0x1a>

0000000080001c92 <allocpid>:
{
    80001c92:	1101                	addi	sp,sp,-32
    80001c94:	ec06                	sd	ra,24(sp)
    80001c96:	e822                	sd	s0,16(sp)
    80001c98:	e426                	sd	s1,8(sp)
    80001c9a:	e04a                	sd	s2,0(sp)
    80001c9c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001c9e:	00012917          	auipc	s2,0x12
    80001ca2:	58290913          	addi	s2,s2,1410 # 80014220 <pid_lock>
    80001ca6:	854a                	mv	a0,s2
    80001ca8:	f7ffe0ef          	jal	80000c26 <acquire>
  pid = nextpid;
    80001cac:	0000a797          	auipc	a5,0xa
    80001cb0:	b3878793          	addi	a5,a5,-1224 # 8000b7e4 <nextpid>
    80001cb4:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001cb6:	0014871b          	addiw	a4,s1,1
    80001cba:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001cbc:	854a                	mv	a0,s2
    80001cbe:	800ff0ef          	jal	80000cbe <release>
}
    80001cc2:	8526                	mv	a0,s1
    80001cc4:	60e2                	ld	ra,24(sp)
    80001cc6:	6442                	ld	s0,16(sp)
    80001cc8:	64a2                	ld	s1,8(sp)
    80001cca:	6902                	ld	s2,0(sp)
    80001ccc:	6105                	addi	sp,sp,32
    80001cce:	8082                	ret

0000000080001cd0 <proc_pagetable>:
{
    80001cd0:	1101                	addi	sp,sp,-32
    80001cd2:	ec06                	sd	ra,24(sp)
    80001cd4:	e822                	sd	s0,16(sp)
    80001cd6:	e426                	sd	s1,8(sp)
    80001cd8:	e04a                	sd	s2,0(sp)
    80001cda:	1000                	addi	s0,sp,32
    80001cdc:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001cde:	dcaff0ef          	jal	800012a8 <uvmcreate>
    80001ce2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001ce4:	cd05                	beqz	a0,80001d1c <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001ce6:	4729                	li	a4,10
    80001ce8:	00005697          	auipc	a3,0x5
    80001cec:	31868693          	addi	a3,a3,792 # 80007000 <_trampoline>
    80001cf0:	6605                	lui	a2,0x1
    80001cf2:	040005b7          	lui	a1,0x4000
    80001cf6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001cf8:	05b2                	slli	a1,a1,0xc
    80001cfa:	b4cff0ef          	jal	80001046 <mappages>
    80001cfe:	02054663          	bltz	a0,80001d2a <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001d02:	4719                	li	a4,6
    80001d04:	06893683          	ld	a3,104(s2)
    80001d08:	6605                	lui	a2,0x1
    80001d0a:	020005b7          	lui	a1,0x2000
    80001d0e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001d10:	05b6                	slli	a1,a1,0xd
    80001d12:	8526                	mv	a0,s1
    80001d14:	b32ff0ef          	jal	80001046 <mappages>
    80001d18:	00054f63          	bltz	a0,80001d36 <proc_pagetable+0x66>
}
    80001d1c:	8526                	mv	a0,s1
    80001d1e:	60e2                	ld	ra,24(sp)
    80001d20:	6442                	ld	s0,16(sp)
    80001d22:	64a2                	ld	s1,8(sp)
    80001d24:	6902                	ld	s2,0(sp)
    80001d26:	6105                	addi	sp,sp,32
    80001d28:	8082                	ret
    uvmfree(pagetable, 0);
    80001d2a:	4581                	li	a1,0
    80001d2c:	8526                	mv	a0,s1
    80001d2e:	f48ff0ef          	jal	80001476 <uvmfree>
    return 0;
    80001d32:	4481                	li	s1,0
    80001d34:	b7e5                	j	80001d1c <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d36:	4681                	li	a3,0
    80001d38:	4605                	li	a2,1
    80001d3a:	040005b7          	lui	a1,0x4000
    80001d3e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d40:	05b2                	slli	a1,a1,0xc
    80001d42:	8526                	mv	a0,s1
    80001d44:	ca8ff0ef          	jal	800011ec <uvmunmap>
    uvmfree(pagetable, 0);
    80001d48:	4581                	li	a1,0
    80001d4a:	8526                	mv	a0,s1
    80001d4c:	f2aff0ef          	jal	80001476 <uvmfree>
    return 0;
    80001d50:	4481                	li	s1,0
    80001d52:	b7e9                	j	80001d1c <proc_pagetable+0x4c>

0000000080001d54 <proc_freepagetable>:
{
    80001d54:	1101                	addi	sp,sp,-32
    80001d56:	ec06                	sd	ra,24(sp)
    80001d58:	e822                	sd	s0,16(sp)
    80001d5a:	e426                	sd	s1,8(sp)
    80001d5c:	e04a                	sd	s2,0(sp)
    80001d5e:	1000                	addi	s0,sp,32
    80001d60:	84aa                	mv	s1,a0
    80001d62:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001d64:	4681                	li	a3,0
    80001d66:	4605                	li	a2,1
    80001d68:	040005b7          	lui	a1,0x4000
    80001d6c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001d6e:	05b2                	slli	a1,a1,0xc
    80001d70:	c7cff0ef          	jal	800011ec <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001d74:	4681                	li	a3,0
    80001d76:	4605                	li	a2,1
    80001d78:	020005b7          	lui	a1,0x2000
    80001d7c:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001d7e:	05b6                	slli	a1,a1,0xd
    80001d80:	8526                	mv	a0,s1
    80001d82:	c6aff0ef          	jal	800011ec <uvmunmap>
  uvmfree(pagetable, sz);
    80001d86:	85ca                	mv	a1,s2
    80001d88:	8526                	mv	a0,s1
    80001d8a:	eecff0ef          	jal	80001476 <uvmfree>
}
    80001d8e:	60e2                	ld	ra,24(sp)
    80001d90:	6442                	ld	s0,16(sp)
    80001d92:	64a2                	ld	s1,8(sp)
    80001d94:	6902                	ld	s2,0(sp)
    80001d96:	6105                	addi	sp,sp,32
    80001d98:	8082                	ret

0000000080001d9a <freeproc>:
{
    80001d9a:	1101                	addi	sp,sp,-32
    80001d9c:	ec06                	sd	ra,24(sp)
    80001d9e:	e822                	sd	s0,16(sp)
    80001da0:	e426                	sd	s1,8(sp)
    80001da2:	1000                	addi	s0,sp,32
    80001da4:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001da6:	7528                	ld	a0,104(a0)
    80001da8:	c119                	beqz	a0,80001dae <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001daa:	ccbfe0ef          	jal	80000a74 <kfree>
  p->trapframe = 0;
    80001dae:	0604b423          	sd	zero,104(s1)
  if(p->pagetable)
    80001db2:	70a8                	ld	a0,96(s1)
    80001db4:	c501                	beqz	a0,80001dbc <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001db6:	6cac                	ld	a1,88(s1)
    80001db8:	f9dff0ef          	jal	80001d54 <proc_freepagetable>
  p->pagetable = 0;
    80001dbc:	0604b023          	sd	zero,96(s1)
  p->sz = 0;
    80001dc0:	0404bc23          	sd	zero,88(s1)
  p->pid = 0;
    80001dc4:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001dc8:	0404b423          	sd	zero,72(s1)
  p->name[0] = 0;
    80001dcc:	16048423          	sb	zero,360(s1)
  p->chan = 0;
    80001dd0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001dd4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001dd8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001ddc:	0004ac23          	sw	zero,24(s1)
}
    80001de0:	60e2                	ld	ra,24(sp)
    80001de2:	6442                	ld	s0,16(sp)
    80001de4:	64a2                	ld	s1,8(sp)
    80001de6:	6105                	addi	sp,sp,32
    80001de8:	8082                	ret

0000000080001dea <allocproc>:
{
    80001dea:	1101                	addi	sp,sp,-32
    80001dec:	ec06                	sd	ra,24(sp)
    80001dee:	e822                	sd	s0,16(sp)
    80001df0:	e426                	sd	s1,8(sp)
    80001df2:	e04a                	sd	s2,0(sp)
    80001df4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001df6:	00013497          	auipc	s1,0x13
    80001dfa:	87248493          	addi	s1,s1,-1934 # 80014668 <proc>
    80001dfe:	00018917          	auipc	s2,0x18
    80001e02:	66a90913          	addi	s2,s2,1642 # 8001a468 <tickslock>
    acquire(&p->lock);
    80001e06:	8526                	mv	a0,s1
    80001e08:	e1ffe0ef          	jal	80000c26 <acquire>
    if(p->state == UNUSED) {
    80001e0c:	4c9c                	lw	a5,24(s1)
    80001e0e:	cb91                	beqz	a5,80001e22 <allocproc+0x38>
      release(&p->lock);
    80001e10:	8526                	mv	a0,s1
    80001e12:	eadfe0ef          	jal	80000cbe <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001e16:	17848493          	addi	s1,s1,376
    80001e1a:	ff2496e3          	bne	s1,s2,80001e06 <allocproc+0x1c>
  return 0;
    80001e1e:	4481                	li	s1,0
    80001e20:	a09d                	j	80001e86 <allocproc+0x9c>
  p->pid = allocpid();
    80001e22:	e71ff0ef          	jal	80001c92 <allocpid>
    80001e26:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001e28:	4785                	li	a5,1
    80001e2a:	cc9c                	sw	a5,24(s1)
  if (checkmode == 0) { // FCFS
    80001e2c:	0000a797          	auipc	a5,0xa
    80001e30:	a507a783          	lw	a5,-1456(a5) # 8000b87c <checkmode>
    80001e34:	cb91                	beqz	a5,80001e48 <allocproc+0x5e>
    p->level = 0; // L0
    80001e36:	0204aa23          	sw	zero,52(s1)
    p->priority = 3; // 3 - Highest value
    80001e3a:	478d                	li	a5,3
    80001e3c:	dc9c                	sw	a5,56(s1)
    p->time_quantum = 0;
    80001e3e:	0204ae23          	sw	zero,60(s1)
    p->limits = 1; // L0의 time quantum은 1
    80001e42:	4785                	li	a5,1
    80001e44:	c0bc                	sw	a5,64(s1)
    80001e46:	a029                	j	80001e50 <allocproc+0x66>
    p->priority = -1;     
    80001e48:	57fd                	li	a5,-1
    80001e4a:	dc9c                	sw	a5,56(s1)
    p->level = -1;
    80001e4c:	d8dc                	sw	a5,52(s1)
    p->time_quantum = -1;
    80001e4e:	dcdc                	sw	a5,60(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001e50:	d07fe0ef          	jal	80000b56 <kalloc>
    80001e54:	892a                	mv	s2,a0
    80001e56:	f4a8                	sd	a0,104(s1)
    80001e58:	cd15                	beqz	a0,80001e94 <allocproc+0xaa>
  p->pagetable = proc_pagetable(p);
    80001e5a:	8526                	mv	a0,s1
    80001e5c:	e75ff0ef          	jal	80001cd0 <proc_pagetable>
    80001e60:	892a                	mv	s2,a0
    80001e62:	f0a8                	sd	a0,96(s1)
  if(p->pagetable == 0){
    80001e64:	c121                	beqz	a0,80001ea4 <allocproc+0xba>
  memset(&p->context, 0, sizeof(p->context));
    80001e66:	07000613          	li	a2,112
    80001e6a:	4581                	li	a1,0
    80001e6c:	07048513          	addi	a0,s1,112
    80001e70:	e8bfe0ef          	jal	80000cfa <memset>
  p->context.ra = (uint64)forkret;
    80001e74:	00000797          	auipc	a5,0x0
    80001e78:	de478793          	addi	a5,a5,-540 # 80001c58 <forkret>
    80001e7c:	f8bc                	sd	a5,112(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001e7e:	68bc                	ld	a5,80(s1)
    80001e80:	6705                	lui	a4,0x1
    80001e82:	97ba                	add	a5,a5,a4
    80001e84:	fcbc                	sd	a5,120(s1)
}
    80001e86:	8526                	mv	a0,s1
    80001e88:	60e2                	ld	ra,24(sp)
    80001e8a:	6442                	ld	s0,16(sp)
    80001e8c:	64a2                	ld	s1,8(sp)
    80001e8e:	6902                	ld	s2,0(sp)
    80001e90:	6105                	addi	sp,sp,32
    80001e92:	8082                	ret
    freeproc(p);
    80001e94:	8526                	mv	a0,s1
    80001e96:	f05ff0ef          	jal	80001d9a <freeproc>
    release(&p->lock);
    80001e9a:	8526                	mv	a0,s1
    80001e9c:	e23fe0ef          	jal	80000cbe <release>
    return 0;
    80001ea0:	84ca                	mv	s1,s2
    80001ea2:	b7d5                	j	80001e86 <allocproc+0x9c>
    freeproc(p);
    80001ea4:	8526                	mv	a0,s1
    80001ea6:	ef5ff0ef          	jal	80001d9a <freeproc>
    release(&p->lock);
    80001eaa:	8526                	mv	a0,s1
    80001eac:	e13fe0ef          	jal	80000cbe <release>
    return 0;
    80001eb0:	84ca                	mv	s1,s2
    80001eb2:	bfd1                	j	80001e86 <allocproc+0x9c>

0000000080001eb4 <userinit>:
{
    80001eb4:	1101                	addi	sp,sp,-32
    80001eb6:	ec06                	sd	ra,24(sp)
    80001eb8:	e822                	sd	s0,16(sp)
    80001eba:	e426                	sd	s1,8(sp)
    80001ebc:	1000                	addi	s0,sp,32
  p = allocproc();
    80001ebe:	f2dff0ef          	jal	80001dea <allocproc>
    80001ec2:	84aa                	mv	s1,a0
  initproc = p;
    80001ec4:	0000a797          	auipc	a5,0xa
    80001ec8:	9aa7be23          	sd	a0,-1604(a5) # 8000b880 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001ecc:	03400613          	li	a2,52
    80001ed0:	0000a597          	auipc	a1,0xa
    80001ed4:	92058593          	addi	a1,a1,-1760 # 8000b7f0 <initcode>
    80001ed8:	7128                	ld	a0,96(a0)
    80001eda:	bf4ff0ef          	jal	800012ce <uvmfirst>
  p->sz = PGSIZE;
    80001ede:	6785                	lui	a5,0x1
    80001ee0:	ecbc                	sd	a5,88(s1)
  p->trapframe->epc = 0;      // user program counter
    80001ee2:	74b8                	ld	a4,104(s1)
    80001ee4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80001ee8:	74b8                	ld	a4,104(s1)
    80001eea:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001eec:	4641                	li	a2,16
    80001eee:	00006597          	auipc	a1,0x6
    80001ef2:	35a58593          	addi	a1,a1,858 # 80008248 <etext+0x248>
    80001ef6:	16848513          	addi	a0,s1,360
    80001efa:	f3ffe0ef          	jal	80000e38 <safestrcpy>
  p->cwd = namei("/");
    80001efe:	00006517          	auipc	a0,0x6
    80001f02:	35a50513          	addi	a0,a0,858 # 80008258 <etext+0x258>
    80001f06:	768020ef          	jal	8000466e <namei>
    80001f0a:	16a4b023          	sd	a0,352(s1)
  p->state = RUNNABLE;
    80001f0e:	478d                	li	a5,3
    80001f10:	cc9c                	sw	a5,24(s1)
  if (checkmode == 0) fcfs_push(p);
    80001f12:	0000a797          	auipc	a5,0xa
    80001f16:	96a7a783          	lw	a5,-1686(a5) # 8000b87c <checkmode>
    80001f1a:	e78d                	bnez	a5,80001f44 <userinit+0x90>
    80001f1c:	8526                	mv	a0,s1
    80001f1e:	a69ff0ef          	jal	80001986 <fcfs_push>
  if (checkmode == 0) { // FCFS
    80001f22:	0000a797          	auipc	a5,0xa
    80001f26:	95a7a783          	lw	a5,-1702(a5) # 8000b87c <checkmode>
    80001f2a:	e395                	bnez	a5,80001f4e <userinit+0x9a>
    p->priority = -1;     
    80001f2c:	57fd                	li	a5,-1
    80001f2e:	dc9c                	sw	a5,56(s1)
    p->level = -1;
    80001f30:	d8dc                	sw	a5,52(s1)
    p->time_quantum = -1;
    80001f32:	dcdc                	sw	a5,60(s1)
  release(&p->lock);
    80001f34:	8526                	mv	a0,s1
    80001f36:	d89fe0ef          	jal	80000cbe <release>
}
    80001f3a:	60e2                	ld	ra,24(sp)
    80001f3c:	6442                	ld	s0,16(sp)
    80001f3e:	64a2                	ld	s1,8(sp)
    80001f40:	6105                	addi	sp,sp,32
    80001f42:	8082                	ret
  else mlfq_push(0, p);
    80001f44:	85a6                	mv	a1,s1
    80001f46:	4501                	li	a0,0
    80001f48:	b0dff0ef          	jal	80001a54 <mlfq_push>
    80001f4c:	bfd9                	j	80001f22 <userinit+0x6e>
    p->level = 0; // L0
    80001f4e:	0204aa23          	sw	zero,52(s1)
    p->priority = 3; // 3 - Highest value
    80001f52:	478d                	li	a5,3
    80001f54:	dc9c                	sw	a5,56(s1)
    p->time_quantum = 0;
    80001f56:	0204ae23          	sw	zero,60(s1)
    p->limits = 1; // L0의 time quantum은 1
    80001f5a:	4785                	li	a5,1
    80001f5c:	c0bc                	sw	a5,64(s1)
    80001f5e:	bfd9                	j	80001f34 <userinit+0x80>

0000000080001f60 <growproc>:
{
    80001f60:	1101                	addi	sp,sp,-32
    80001f62:	ec06                	sd	ra,24(sp)
    80001f64:	e822                	sd	s0,16(sp)
    80001f66:	e426                	sd	s1,8(sp)
    80001f68:	e04a                	sd	s2,0(sp)
    80001f6a:	1000                	addi	s0,sp,32
    80001f6c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001f6e:	cb9ff0ef          	jal	80001c26 <myproc>
    80001f72:	84aa                	mv	s1,a0
  sz = p->sz;
    80001f74:	6d2c                	ld	a1,88(a0)
  if(n > 0){
    80001f76:	01204c63          	bgtz	s2,80001f8e <growproc+0x2e>
  } else if(n < 0){
    80001f7a:	02094463          	bltz	s2,80001fa2 <growproc+0x42>
  p->sz = sz;
    80001f7e:	ecac                	sd	a1,88(s1)
  return 0;
    80001f80:	4501                	li	a0,0
}
    80001f82:	60e2                	ld	ra,24(sp)
    80001f84:	6442                	ld	s0,16(sp)
    80001f86:	64a2                	ld	s1,8(sp)
    80001f88:	6902                	ld	s2,0(sp)
    80001f8a:	6105                	addi	sp,sp,32
    80001f8c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001f8e:	4691                	li	a3,4
    80001f90:	00b90633          	add	a2,s2,a1
    80001f94:	7128                	ld	a0,96(a0)
    80001f96:	bdaff0ef          	jal	80001370 <uvmalloc>
    80001f9a:	85aa                	mv	a1,a0
    80001f9c:	f16d                	bnez	a0,80001f7e <growproc+0x1e>
      return -1;
    80001f9e:	557d                	li	a0,-1
    80001fa0:	b7cd                	j	80001f82 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001fa2:	00b90633          	add	a2,s2,a1
    80001fa6:	7128                	ld	a0,96(a0)
    80001fa8:	b84ff0ef          	jal	8000132c <uvmdealloc>
    80001fac:	85aa                	mv	a1,a0
    80001fae:	bfc1                	j	80001f7e <growproc+0x1e>

0000000080001fb0 <fork>:
{
    80001fb0:	7139                	addi	sp,sp,-64
    80001fb2:	fc06                	sd	ra,56(sp)
    80001fb4:	f822                	sd	s0,48(sp)
    80001fb6:	f426                	sd	s1,40(sp)
    80001fb8:	e456                	sd	s5,8(sp)
    80001fba:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001fbc:	c6bff0ef          	jal	80001c26 <myproc>
    80001fc0:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001fc2:	e29ff0ef          	jal	80001dea <allocproc>
    80001fc6:	12050163          	beqz	a0,800020e8 <fork+0x138>
    80001fca:	ec4e                	sd	s3,24(sp)
    80001fcc:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001fce:	058ab603          	ld	a2,88(s5)
    80001fd2:	712c                	ld	a1,96(a0)
    80001fd4:	060ab503          	ld	a0,96(s5)
    80001fd8:	cd0ff0ef          	jal	800014a8 <uvmcopy>
    80001fdc:	04054a63          	bltz	a0,80002030 <fork+0x80>
    80001fe0:	f04a                	sd	s2,32(sp)
    80001fe2:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001fe4:	058ab783          	ld	a5,88(s5)
    80001fe8:	04f9bc23          	sd	a5,88(s3)
  *(np->trapframe) = *(p->trapframe);
    80001fec:	068ab683          	ld	a3,104(s5)
    80001ff0:	87b6                	mv	a5,a3
    80001ff2:	0689b703          	ld	a4,104(s3)
    80001ff6:	12068693          	addi	a3,a3,288
    80001ffa:	0007b803          	ld	a6,0(a5)
    80001ffe:	6788                	ld	a0,8(a5)
    80002000:	6b8c                	ld	a1,16(a5)
    80002002:	6f90                	ld	a2,24(a5)
    80002004:	01073023          	sd	a6,0(a4)
    80002008:	e708                	sd	a0,8(a4)
    8000200a:	eb0c                	sd	a1,16(a4)
    8000200c:	ef10                	sd	a2,24(a4)
    8000200e:	02078793          	addi	a5,a5,32
    80002012:	02070713          	addi	a4,a4,32
    80002016:	fed792e3          	bne	a5,a3,80001ffa <fork+0x4a>
  np->trapframe->a0 = 0;
    8000201a:	0689b783          	ld	a5,104(s3)
    8000201e:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002022:	0e0a8493          	addi	s1,s5,224
    80002026:	0e098913          	addi	s2,s3,224
    8000202a:	160a8a13          	addi	s4,s5,352
    8000202e:	a831                	j	8000204a <fork+0x9a>
    freeproc(np);
    80002030:	854e                	mv	a0,s3
    80002032:	d69ff0ef          	jal	80001d9a <freeproc>
    release(&np->lock);
    80002036:	854e                	mv	a0,s3
    80002038:	c87fe0ef          	jal	80000cbe <release>
    return -1;
    8000203c:	54fd                	li	s1,-1
    8000203e:	69e2                	ld	s3,24(sp)
    80002040:	a061                	j	800020c8 <fork+0x118>
  for(i = 0; i < NOFILE; i++)
    80002042:	04a1                	addi	s1,s1,8
    80002044:	0921                	addi	s2,s2,8
    80002046:	01448963          	beq	s1,s4,80002058 <fork+0xa8>
    if(p->ofile[i])
    8000204a:	6088                	ld	a0,0(s1)
    8000204c:	d97d                	beqz	a0,80002042 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000204e:	3b1020ef          	jal	80004bfe <filedup>
    80002052:	00a93023          	sd	a0,0(s2)
    80002056:	b7f5                	j	80002042 <fork+0x92>
  np->cwd = idup(p->cwd);
    80002058:	160ab503          	ld	a0,352(s5)
    8000205c:	703010ef          	jal	80003f5e <idup>
    80002060:	16a9b023          	sd	a0,352(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002064:	4641                	li	a2,16
    80002066:	168a8593          	addi	a1,s5,360
    8000206a:	16898513          	addi	a0,s3,360
    8000206e:	dcbfe0ef          	jal	80000e38 <safestrcpy>
  pid = np->pid;
    80002072:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    80002076:	854e                	mv	a0,s3
    80002078:	c47fe0ef          	jal	80000cbe <release>
  acquire(&np->lock);
    8000207c:	854e                	mv	a0,s3
    8000207e:	ba9fe0ef          	jal	80000c26 <acquire>
  np->parent = p;
    80002082:	0559b423          	sd	s5,72(s3)
  np->state = RUNNABLE;
    80002086:	478d                	li	a5,3
    80002088:	00f9ac23          	sw	a5,24(s3)
  if (checkmode == 0)
    8000208c:	00009797          	auipc	a5,0x9
    80002090:	7f07a783          	lw	a5,2032(a5) # 8000b87c <checkmode>
    80002094:	e3a9                	bnez	a5,800020d6 <fork+0x126>
    fcfs_push(np);
    80002096:	854e                	mv	a0,s3
    80002098:	8efff0ef          	jal	80001986 <fcfs_push>
  if (checkmode == 0) {
    8000209c:	00009797          	auipc	a5,0x9
    800020a0:	7e07a783          	lw	a5,2016(a5) # 8000b87c <checkmode>
    800020a4:	cf95                	beqz	a5,800020e0 <fork+0x130>
    800020a6:	468d                	li	a3,3
    800020a8:	4781                	li	a5,0
    800020aa:	4705                	li	a4,1
    np->level = -1;
    800020ac:	02f9aa23          	sw	a5,52(s3)
    np->priority = -1;
    800020b0:	02d9ac23          	sw	a3,56(s3)
    np->time_quantum = -1;
    800020b4:	02f9ae23          	sw	a5,60(s3)
    np->limits = -1;
    800020b8:	04e9a023          	sw	a4,64(s3)
  release(&np->lock);
    800020bc:	854e                	mv	a0,s3
    800020be:	c01fe0ef          	jal	80000cbe <release>
  return pid;
    800020c2:	7902                	ld	s2,32(sp)
    800020c4:	69e2                	ld	s3,24(sp)
    800020c6:	6a42                	ld	s4,16(sp)
}
    800020c8:	8526                	mv	a0,s1
    800020ca:	70e2                	ld	ra,56(sp)
    800020cc:	7442                	ld	s0,48(sp)
    800020ce:	74a2                	ld	s1,40(sp)
    800020d0:	6aa2                	ld	s5,8(sp)
    800020d2:	6121                	addi	sp,sp,64
    800020d4:	8082                	ret
    mlfq_push(0, np);
    800020d6:	85ce                	mv	a1,s3
    800020d8:	4501                	li	a0,0
    800020da:	97bff0ef          	jal	80001a54 <mlfq_push>
    800020de:	bf7d                	j	8000209c <fork+0xec>
    800020e0:	56fd                	li	a3,-1
    800020e2:	57fd                	li	a5,-1
    800020e4:	577d                	li	a4,-1
    800020e6:	b7d9                	j	800020ac <fork+0xfc>
    return -1;
    800020e8:	54fd                	li	s1,-1
    800020ea:	bff9                	j	800020c8 <fork+0x118>

00000000800020ec <scheduler>:
{
    800020ec:	7119                	addi	sp,sp,-128
    800020ee:	fc86                	sd	ra,120(sp)
    800020f0:	f8a2                	sd	s0,112(sp)
    800020f2:	f4a6                	sd	s1,104(sp)
    800020f4:	f0ca                	sd	s2,96(sp)
    800020f6:	ecce                	sd	s3,88(sp)
    800020f8:	e8d2                	sd	s4,80(sp)
    800020fa:	e4d6                	sd	s5,72(sp)
    800020fc:	e0da                	sd	s6,64(sp)
    800020fe:	fc5e                	sd	s7,56(sp)
    80002100:	f862                	sd	s8,48(sp)
    80002102:	f466                	sd	s9,40(sp)
    80002104:	f06a                	sd	s10,32(sp)
    80002106:	ec6e                	sd	s11,24(sp)
    80002108:	0100                	addi	s0,sp,128
    8000210a:	8792                	mv	a5,tp
  int id = r_tp();
    8000210c:	0007871b          	sext.w	a4,a5
    80002110:	f8e43423          	sd	a4,-120(s0)
  c->proc = 0;
    80002114:	00771d13          	slli	s10,a4,0x7
    80002118:	00013797          	auipc	a5,0x13
    8000211c:	8b078793          	addi	a5,a5,-1872 # 800149c8 <proc+0x360>
    80002120:	97ea                	add	a5,a5,s10
    80002122:	8a07b023          	sd	zero,-1888(a5)
        swtch(&c->context, &p->context);
    80002126:	00012797          	auipc	a5,0x12
    8000212a:	14a78793          	addi	a5,a5,330 # 80014270 <cpus+0x8>
    8000212e:	9d3e                	add	s10,s10,a5
    if (checkmode == 0 && !fcfs_empty()) { // FCFS 경우 + FCFS가 비어있지 않으면
    80002130:	00009497          	auipc	s1,0x9
    80002134:	74c48493          	addi	s1,s1,1868 # 8000b87c <checkmode>
  return queue_empty(&mlfq.entry[level]);
    80002138:	00012a17          	auipc	s4,0x12
    8000213c:	ab8a0a13          	addi	s4,s4,-1352 # 80013bf0 <mlfq>
    80002140:	00012b97          	auipc	s7,0x12
    80002144:	cc0b8b93          	addi	s7,s7,-832 # 80013e00 <mlfq+0x210>
        for (int i = 0; i < mlfq.entry[2].num; i++) {
    80002148:	00013a97          	auipc	s5,0x13
    8000214c:	880a8a93          	addi	s5,s5,-1920 # 800149c8 <proc+0x360>
        c->proc = p;
    80002150:	00771793          	slli	a5,a4,0x7
    80002154:	00013c97          	auipc	s9,0x13
    80002158:	874c8c93          	addi	s9,s9,-1932 # 800149c8 <proc+0x360>
    8000215c:	9cbe                	add	s9,s9,a5
    8000215e:	a81d                	j	80002194 <scheduler+0xa8>
        p->state = RUNNING;
    80002160:	4791                	li	a5,4
    80002162:	00f9ac23          	sw	a5,24(s3)
        c->proc = p;
    80002166:	8b3cb023          	sd	s3,-1888(s9)
        swtch(&c->context, &p->context);
    8000216a:	07098593          	addi	a1,s3,112
    8000216e:	856a                	mv	a0,s10
    80002170:	4b3000ef          	jal	80002e22 <swtch>
        c->proc = 0;
    80002174:	8a0cb023          	sd	zero,-1888(s9)
        found = 1;
    80002178:	4905                	li	s2,1
    8000217a:	a0b1                	j	800021c6 <scheduler+0xda>
    else if (checkmode == 1) { // MLFQ
    8000217c:	4098                	lw	a4,0(s1)
    8000217e:	4785                	li	a5,1
    80002180:	04f70963          	beq	a4,a5,800021d2 <scheduler+0xe6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002184:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002188:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000218c:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002190:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002194:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002198:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000219c:	10079073          	csrw	sstatus,a5
    if (checkmode == 0 && !fcfs_empty()) { // FCFS 경우 + FCFS가 비어있지 않으면
    800021a0:	409c                	lw	a5,0(s1)
    800021a2:	ffe9                	bnez	a5,8000217c <scheduler+0x90>
    800021a4:	faaff0ef          	jal	8000194e <fcfs_empty>
    800021a8:	892a                	mv	s2,a0
    800021aa:	f969                	bnez	a0,8000217c <scheduler+0x90>
      p = fcfs_pop();
    800021ac:	fbeff0ef          	jal	8000196a <fcfs_pop>
    800021b0:	89aa                	mv	s3,a0
      acquire(&p->lock);
    800021b2:	a75fe0ef          	jal	80000c26 <acquire>
      if(p->state == RUNNABLE) { // 더블 체크
    800021b6:	0189a703          	lw	a4,24(s3)
    800021ba:	478d                	li	a5,3
    800021bc:	faf702e3          	beq	a4,a5,80002160 <scheduler+0x74>
        fcfs_push(p);
    800021c0:	854e                	mv	a0,s3
    800021c2:	fc4ff0ef          	jal	80001986 <fcfs_push>
      release(&p->lock);
    800021c6:	854e                	mv	a0,s3
    800021c8:	af7fe0ef          	jal	80000cbe <release>
    if(found == 0) {
    800021cc:	fc0914e3          	bnez	s2,80002194 <scheduler+0xa8>
    800021d0:	bf55                	j	80002184 <scheduler+0x98>
  return queue_empty(&mlfq.entry[level]);
    800021d2:	8552                	mv	a0,s4
    800021d4:	e4aff0ef          	jal	8000181e <queue_empty>
      if (!mlfq_empty(0)) {
    800021d8:	e11d                	bnez	a0,800021fe <scheduler+0x112>
  return queue_pop(&mlfq.entry[level]);
    800021da:	8552                	mv	a0,s4
    800021dc:	e7aff0ef          	jal	80001856 <queue_pop>
    800021e0:	892a                	mv	s2,a0
      if (p != 0 && found == 1) { // p를 확실히 가져올 수 있는 상황이라면 p를 가져온다.
    800021e2:	d94d                	beqz	a0,80002194 <scheduler+0xa8>
        acquire(&p->lock);
    800021e4:	89ca                	mv	s3,s2
    800021e6:	854a                	mv	a0,s2
    800021e8:	a3ffe0ef          	jal	80000c26 <acquire>
        if (p->state == RUNNABLE) {
    800021ec:	01892703          	lw	a4,24(s2)
    800021f0:	478d                	li	a5,3
    800021f2:	14f70a63          	beq	a4,a5,80002346 <scheduler+0x25a>
        release(&p->lock);
    800021f6:	854e                	mv	a0,s3
    800021f8:	ac7fe0ef          	jal	80000cbe <release>
    if(found == 0) {
    800021fc:	bf61                	j	80002194 <scheduler+0xa8>
  return queue_empty(&mlfq.entry[level]);
    800021fe:	855e                	mv	a0,s7
    80002200:	e1eff0ef          	jal	8000181e <queue_empty>
      else if (!mlfq_empty(1)) {
    80002204:	e901                	bnez	a0,80002214 <scheduler+0x128>
  return queue_pop(&mlfq.entry[level]);
    80002206:	855e                	mv	a0,s7
    80002208:	e4eff0ef          	jal	80001856 <queue_pop>
    8000220c:	892a                	mv	s2,a0
      if (p != 0 && found == 1) { // p를 확실히 가져올 수 있는 상황이라면 p를 가져온다.
    8000220e:	fc091be3          	bnez	s2,800021e4 <scheduler+0xf8>
    80002212:	b749                	j	80002194 <scheduler+0xa8>
  return queue_empty(&mlfq.entry[level]);
    80002214:	00012517          	auipc	a0,0x12
    80002218:	dfc50513          	addi	a0,a0,-516 # 80014010 <mlfq+0x420>
    8000221c:	e02ff0ef          	jal	8000181e <queue_empty>
    80002220:	892a                	mv	s2,a0
      else if (!mlfq_empty(2)) {
    80002222:	f12d                	bnez	a0,80002184 <scheduler+0x98>
        for (int i = 0; i < mlfq.entry[2].num; i++) {
    80002224:	850aa783          	lw	a5,-1968(s5)
    80002228:	f4f05ee3          	blez	a5,80002184 <scheduler+0x98>
        int index = -1;
    8000222c:	5dfd                	li	s11,-1
        int max = -1; // Max priority를 찾기 위함
    8000222e:	5b7d                	li	s6,-1
          temp = mlfq.entry[2].q[(mlfq.entry[2].front + i) % NPROC];
    80002230:	00011c17          	auipc	s8,0x11
    80002234:	798c0c13          	addi	s8,s8,1944 # 800139c8 <queuelock>
    80002238:	a809                	j	8000224a <scheduler+0x15e>
          release(&temp->lock);
    8000223a:	854e                	mv	a0,s3
    8000223c:	a83fe0ef          	jal	80000cbe <release>
        for (int i = 0; i < mlfq.entry[2].num; i++) {
    80002240:	2905                	addiw	s2,s2,1
    80002242:	850aa783          	lw	a5,-1968(s5)
    80002246:	02f95e63          	bge	s2,a5,80002282 <scheduler+0x196>
          temp = mlfq.entry[2].q[(mlfq.entry[2].front + i) % NPROC];
    8000224a:	848aa783          	lw	a5,-1976(s5)
    8000224e:	012787bb          	addw	a5,a5,s2
    80002252:	41f7d71b          	sraiw	a4,a5,0x1f
    80002256:	01a7571b          	srliw	a4,a4,0x1a
    8000225a:	9fb9                	addw	a5,a5,a4
    8000225c:	03f7f793          	andi	a5,a5,63
    80002260:	9f99                	subw	a5,a5,a4
    80002262:	08478793          	addi	a5,a5,132
    80002266:	078e                	slli	a5,a5,0x3
    80002268:	97e2                	add	a5,a5,s8
    8000226a:	2287b983          	ld	s3,552(a5)
          acquire(&temp->lock);
    8000226e:	854e                	mv	a0,s3
    80002270:	9b7fe0ef          	jal	80000c26 <acquire>
          if (temp->priority > max) {
    80002274:	0389a783          	lw	a5,56(s3)
    80002278:	fcfb51e3          	bge	s6,a5,8000223a <scheduler+0x14e>
            index = i;
    8000227c:	8dca                	mv	s11,s2
            max = temp->priority;
    8000227e:	8b3e                	mv	s6,a5
    80002280:	bf6d                	j	8000223a <scheduler+0x14e>
        if (index != -1) { // index == -1 이면 없는 것
    80002282:	57fd                	li	a5,-1
    80002284:	f0fd80e3          	beq	s11,a5,80002184 <scheduler+0x98>
          acquire(&queuelock);
    80002288:	00011917          	auipc	s2,0x11
    8000228c:	74090913          	addi	s2,s2,1856 # 800139c8 <queuelock>
    80002290:	854a                	mv	a0,s2
    80002292:	995fe0ef          	jal	80000c26 <acquire>
          p = mlfq.entry[2].q[(mlfq.entry[2].front + index) % NPROC];
    80002296:	00012697          	auipc	a3,0x12
    8000229a:	73268693          	addi	a3,a3,1842 # 800149c8 <proc+0x360>
    8000229e:	8486a503          	lw	a0,-1976(a3)
    800022a2:	01b5073b          	addw	a4,a0,s11
    800022a6:	04000793          	li	a5,64
    800022aa:	02f767bb          	remw	a5,a4,a5
    800022ae:	08478793          	addi	a5,a5,132
    800022b2:	078e                	slli	a5,a5,0x3
    800022b4:	993e                	add	s2,s2,a5
    800022b6:	22893903          	ld	s2,552(s2)
          for (int i = index; i < mlfq.entry[2].num; i++) {
    800022ba:	8506a583          	lw	a1,-1968(a3)
    800022be:	04bddc63          	bge	s11,a1,80002316 <scheduler+0x22a>
    800022c2:	2705                	addiw	a4,a4,1
    800022c4:	9d2d                	addw	a0,a0,a1
            mlfq.entry[2].q[new] = mlfq.entry[2].q[past];
    800022c6:	00011617          	auipc	a2,0x11
    800022ca:	70260613          	addi	a2,a2,1794 # 800139c8 <queuelock>
            int past = (mlfq.entry[2].front + i + 1) % NPROC; // 이전 위치
    800022ce:	41f7569b          	sraiw	a3,a4,0x1f
    800022d2:	01a6d69b          	srliw	a3,a3,0x1a
    800022d6:	00e687bb          	addw	a5,a3,a4
    800022da:	03f7f793          	andi	a5,a5,63
            mlfq.entry[2].q[new] = mlfq.entry[2].q[past];
    800022de:	9f95                	subw	a5,a5,a3
    800022e0:	08478793          	addi	a5,a5,132
    800022e4:	078e                	slli	a5,a5,0x3
    800022e6:	97b2                	add	a5,a5,a2
    800022e8:	2287b803          	ld	a6,552(a5)
            int past = (mlfq.entry[2].front + i + 1) % NPROC; // 이전 위치
    800022ec:	fff7079b          	addiw	a5,a4,-1
            int new = (mlfq.entry[2].front + i) % NPROC; // 새로운 위치
    800022f0:	41f7d69b          	sraiw	a3,a5,0x1f
    800022f4:	01a6d69b          	srliw	a3,a3,0x1a
    800022f8:	9fb5                	addw	a5,a5,a3
    800022fa:	03f7f793          	andi	a5,a5,63
            mlfq.entry[2].q[new] = mlfq.entry[2].q[past];
    800022fe:	9f95                	subw	a5,a5,a3
    80002300:	08478793          	addi	a5,a5,132
    80002304:	078e                	slli	a5,a5,0x3
    80002306:	97b2                	add	a5,a5,a2
    80002308:	2307b423          	sd	a6,552(a5)
          for (int i = index; i < mlfq.entry[2].num; i++) {
    8000230c:	0007079b          	sext.w	a5,a4
    80002310:	2705                	addiw	a4,a4,1
    80002312:	faa79ee3          	bne	a5,a0,800022ce <scheduler+0x1e2>
          mlfq.entry[2].rear = (mlfq.entry[2].rear + NPROC - 1) % NPROC; // 음수가 되는 것을 방지해 NPROC를 더함
    80002316:	00012717          	auipc	a4,0x12
    8000231a:	6b270713          	addi	a4,a4,1714 # 800149c8 <proc+0x360>
    8000231e:	84c72783          	lw	a5,-1972(a4)
    80002322:	03f7879b          	addiw	a5,a5,63
    80002326:	04000693          	li	a3,64
    8000232a:	02d7e7bb          	remw	a5,a5,a3
    8000232e:	84f72623          	sw	a5,-1972(a4)
          mlfq.entry[2].num--;
    80002332:	35fd                	addiw	a1,a1,-1
    80002334:	84b72823          	sw	a1,-1968(a4)
          release(&queuelock);
    80002338:	00011517          	auipc	a0,0x11
    8000233c:	69050513          	addi	a0,a0,1680 # 800139c8 <queuelock>
    80002340:	97ffe0ef          	jal	80000cbe <release>
          found = 1;
    80002344:	b5e9                	j	8000220e <scheduler+0x122>
          p->state = RUNNING;
    80002346:	4791                	li	a5,4
    80002348:	00f92c23          	sw	a5,24(s2)
          c->proc = p;
    8000234c:	f8843783          	ld	a5,-120(s0)
    80002350:	079e                	slli	a5,a5,0x7
    80002352:	00012b17          	auipc	s6,0x12
    80002356:	676b0b13          	addi	s6,s6,1654 # 800149c8 <proc+0x360>
    8000235a:	9b3e                	add	s6,s6,a5
    8000235c:	8b2b3023          	sd	s2,-1888(s6)
          swtch(&c->context, &p->context);
    80002360:	07090593          	addi	a1,s2,112
    80002364:	856a                	mv	a0,s10
    80002366:	2bd000ef          	jal	80002e22 <swtch>
          c->proc = 0;
    8000236a:	8a0b3023          	sd	zero,-1888(s6)
    8000236e:	b561                	j	800021f6 <scheduler+0x10a>

0000000080002370 <sched>:
{
    80002370:	7179                	addi	sp,sp,-48
    80002372:	f406                	sd	ra,40(sp)
    80002374:	f022                	sd	s0,32(sp)
    80002376:	ec26                	sd	s1,24(sp)
    80002378:	e84a                	sd	s2,16(sp)
    8000237a:	e44e                	sd	s3,8(sp)
    8000237c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000237e:	8a9ff0ef          	jal	80001c26 <myproc>
    80002382:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002384:	839fe0ef          	jal	80000bbc <holding>
    80002388:	c92d                	beqz	a0,800023fa <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000238a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000238c:	2781                	sext.w	a5,a5
    8000238e:	079e                	slli	a5,a5,0x7
    80002390:	00012717          	auipc	a4,0x12
    80002394:	63870713          	addi	a4,a4,1592 # 800149c8 <proc+0x360>
    80002398:	97ba                	add	a5,a5,a4
    8000239a:	9187a703          	lw	a4,-1768(a5)
    8000239e:	4785                	li	a5,1
    800023a0:	06f71363          	bne	a4,a5,80002406 <sched+0x96>
  if(p->state == RUNNING)
    800023a4:	4c98                	lw	a4,24(s1)
    800023a6:	4791                	li	a5,4
    800023a8:	06f70563          	beq	a4,a5,80002412 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800023ac:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800023b0:	8b89                	andi	a5,a5,2
  if(intr_get())
    800023b2:	e7b5                	bnez	a5,8000241e <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    800023b4:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800023b6:	00012917          	auipc	s2,0x12
    800023ba:	61290913          	addi	s2,s2,1554 # 800149c8 <proc+0x360>
    800023be:	2781                	sext.w	a5,a5
    800023c0:	079e                	slli	a5,a5,0x7
    800023c2:	97ca                	add	a5,a5,s2
    800023c4:	91c7a983          	lw	s3,-1764(a5)
    800023c8:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800023ca:	2781                	sext.w	a5,a5
    800023cc:	079e                	slli	a5,a5,0x7
    800023ce:	00012597          	auipc	a1,0x12
    800023d2:	ea258593          	addi	a1,a1,-350 # 80014270 <cpus+0x8>
    800023d6:	95be                	add	a1,a1,a5
    800023d8:	07048513          	addi	a0,s1,112
    800023dc:	247000ef          	jal	80002e22 <swtch>
    800023e0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800023e2:	2781                	sext.w	a5,a5
    800023e4:	079e                	slli	a5,a5,0x7
    800023e6:	993e                	add	s2,s2,a5
    800023e8:	91392e23          	sw	s3,-1764(s2)
}
    800023ec:	70a2                	ld	ra,40(sp)
    800023ee:	7402                	ld	s0,32(sp)
    800023f0:	64e2                	ld	s1,24(sp)
    800023f2:	6942                	ld	s2,16(sp)
    800023f4:	69a2                	ld	s3,8(sp)
    800023f6:	6145                	addi	sp,sp,48
    800023f8:	8082                	ret
    panic("sched p->lock");
    800023fa:	00006517          	auipc	a0,0x6
    800023fe:	e6650513          	addi	a0,a0,-410 # 80008260 <etext+0x260>
    80002402:	bc4fe0ef          	jal	800007c6 <panic>
    panic("sched locks");
    80002406:	00006517          	auipc	a0,0x6
    8000240a:	e6a50513          	addi	a0,a0,-406 # 80008270 <etext+0x270>
    8000240e:	bb8fe0ef          	jal	800007c6 <panic>
    panic("sched running");
    80002412:	00006517          	auipc	a0,0x6
    80002416:	e6e50513          	addi	a0,a0,-402 # 80008280 <etext+0x280>
    8000241a:	bacfe0ef          	jal	800007c6 <panic>
    panic("sched interruptible");
    8000241e:	00006517          	auipc	a0,0x6
    80002422:	e7250513          	addi	a0,a0,-398 # 80008290 <etext+0x290>
    80002426:	ba0fe0ef          	jal	800007c6 <panic>

000000008000242a <yield>:
  if (checkmode == 1) { // MLFQ 일때만 yield
    8000242a:	00009717          	auipc	a4,0x9
    8000242e:	45272703          	lw	a4,1106(a4) # 8000b87c <checkmode>
    80002432:	4785                	li	a5,1
    80002434:	00f70363          	beq	a4,a5,8000243a <yield+0x10>
    80002438:	8082                	ret
{
    8000243a:	1101                	addi	sp,sp,-32
    8000243c:	ec06                	sd	ra,24(sp)
    8000243e:	e822                	sd	s0,16(sp)
    80002440:	e426                	sd	s1,8(sp)
    80002442:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80002444:	fe2ff0ef          	jal	80001c26 <myproc>
    80002448:	84aa                	mv	s1,a0
    acquire(&p->lock);        
    8000244a:	fdcfe0ef          	jal	80000c26 <acquire>
    p->state = RUNNABLE;
    8000244e:	478d                	li	a5,3
    80002450:	cc9c                	sw	a5,24(s1)
    mlfq_push(p->level, p); // level에 맞는 queue 뒤에 넣는다.
    80002452:	85a6                	mv	a1,s1
    80002454:	58c8                	lw	a0,52(s1)
    80002456:	dfeff0ef          	jal	80001a54 <mlfq_push>
    sched();
    8000245a:	f17ff0ef          	jal	80002370 <sched>
    release(&p->lock);
    8000245e:	8526                	mv	a0,s1
    80002460:	85ffe0ef          	jal	80000cbe <release>
}
    80002464:	60e2                	ld	ra,24(sp)
    80002466:	6442                	ld	s0,16(sp)
    80002468:	64a2                	ld	s1,8(sp)
    8000246a:	6105                	addi	sp,sp,32
    8000246c:	8082                	ret

000000008000246e <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000246e:	7179                	addi	sp,sp,-48
    80002470:	f406                	sd	ra,40(sp)
    80002472:	f022                	sd	s0,32(sp)
    80002474:	ec26                	sd	s1,24(sp)
    80002476:	e84a                	sd	s2,16(sp)
    80002478:	e44e                	sd	s3,8(sp)
    8000247a:	1800                	addi	s0,sp,48
    8000247c:	89aa                	mv	s3,a0
    8000247e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002480:	fa6ff0ef          	jal	80001c26 <myproc>
    80002484:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002486:	fa0fe0ef          	jal	80000c26 <acquire>
  release(lk);
    8000248a:	854a                	mv	a0,s2
    8000248c:	833fe0ef          	jal	80000cbe <release>

  // Go to sleep.
  p->chan = chan;
    80002490:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80002494:	4789                	li	a5,2
    80002496:	cc9c                	sw	a5,24(s1)

  sched();
    80002498:	ed9ff0ef          	jal	80002370 <sched>

  // Tidy up.
  p->chan = 0;
    8000249c:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800024a0:	8526                	mv	a0,s1
    800024a2:	81dfe0ef          	jal	80000cbe <release>
  acquire(lk);
    800024a6:	854a                	mv	a0,s2
    800024a8:	f7efe0ef          	jal	80000c26 <acquire>
}
    800024ac:	70a2                	ld	ra,40(sp)
    800024ae:	7402                	ld	s0,32(sp)
    800024b0:	64e2                	ld	s1,24(sp)
    800024b2:	6942                	ld	s2,16(sp)
    800024b4:	69a2                	ld	s3,8(sp)
    800024b6:	6145                	addi	sp,sp,48
    800024b8:	8082                	ret

00000000800024ba <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    800024ba:	715d                	addi	sp,sp,-80
    800024bc:	e486                	sd	ra,72(sp)
    800024be:	e0a2                	sd	s0,64(sp)
    800024c0:	fc26                	sd	s1,56(sp)
    800024c2:	f84a                	sd	s2,48(sp)
    800024c4:	f44e                	sd	s3,40(sp)
    800024c6:	f052                	sd	s4,32(sp)
    800024c8:	ec56                	sd	s5,24(sp)
    800024ca:	e85a                	sd	s6,16(sp)
    800024cc:	e45e                	sd	s7,8(sp)
    800024ce:	e062                	sd	s8,0(sp)
    800024d0:	0880                	addi	s0,sp,80
    800024d2:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800024d4:	00012497          	auipc	s1,0x12
    800024d8:	19448493          	addi	s1,s1,404 # 80014668 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800024dc:	4989                	li	s3,2
        p->state = RUNNABLE;
    800024de:	4b0d                	li	s6,3
        if (checkmode == 0) fcfs_push(p);
    800024e0:	00009a97          	auipc	s5,0x9
    800024e4:	39ca8a93          	addi	s5,s5,924 # 8000b87c <checkmode>
        } 
        else { // MLFQ
          p->level = 0; // L0
          p->priority = 3; // 3 - Highest value
          p->time_quantum = 0;
          p->limits = 1; // L0의 time quantum은 1
    800024e8:	4c05                	li	s8,1
          p->priority = -1;     
    800024ea:	5bfd                	li	s7,-1
  for(p = proc; p < &proc[NPROC]; p++) {
    800024ec:	00018917          	auipc	s2,0x18
    800024f0:	f7c90913          	addi	s2,s2,-132 # 8001a468 <tickslock>
    800024f4:	a02d                	j	8000251e <wakeup+0x64>
        else mlfq_push(0, p);
    800024f6:	85a6                	mv	a1,s1
    800024f8:	4501                	li	a0,0
    800024fa:	d5aff0ef          	jal	80001a54 <mlfq_push>
    800024fe:	a0a9                	j	80002548 <wakeup+0x8e>
          p->level = 0; // L0
    80002500:	0204aa23          	sw	zero,52(s1)
          p->priority = 3; // 3 - Highest value
    80002504:	0364ac23          	sw	s6,56(s1)
          p->time_quantum = 0;
    80002508:	0204ae23          	sw	zero,60(s1)
          p->limits = 1; // L0의 time quantum은 1
    8000250c:	0584a023          	sw	s8,64(s1)
  }
      }
      release(&p->lock);
    80002510:	8526                	mv	a0,s1
    80002512:	facfe0ef          	jal	80000cbe <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002516:	17848493          	addi	s1,s1,376
    8000251a:	05248163          	beq	s1,s2,8000255c <wakeup+0xa2>
    if(p != myproc()){
    8000251e:	f08ff0ef          	jal	80001c26 <myproc>
    80002522:	fea48ae3          	beq	s1,a0,80002516 <wakeup+0x5c>
      acquire(&p->lock);
    80002526:	8526                	mv	a0,s1
    80002528:	efefe0ef          	jal	80000c26 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000252c:	4c9c                	lw	a5,24(s1)
    8000252e:	ff3791e3          	bne	a5,s3,80002510 <wakeup+0x56>
    80002532:	709c                	ld	a5,32(s1)
    80002534:	fd479ee3          	bne	a5,s4,80002510 <wakeup+0x56>
        p->state = RUNNABLE;
    80002538:	0164ac23          	sw	s6,24(s1)
        if (checkmode == 0) fcfs_push(p);
    8000253c:	000aa783          	lw	a5,0(s5)
    80002540:	fbdd                	bnez	a5,800024f6 <wakeup+0x3c>
    80002542:	8526                	mv	a0,s1
    80002544:	c42ff0ef          	jal	80001986 <fcfs_push>
        if (checkmode == 0) { // FCFS
    80002548:	000aa783          	lw	a5,0(s5)
    8000254c:	fbd5                	bnez	a5,80002500 <wakeup+0x46>
          p->priority = -1;     
    8000254e:	0374ac23          	sw	s7,56(s1)
          p->level = -1;
    80002552:	0374aa23          	sw	s7,52(s1)
          p->time_quantum = -1;
    80002556:	0374ae23          	sw	s7,60(s1)
    8000255a:	bf5d                	j	80002510 <wakeup+0x56>
    }
  }
}
    8000255c:	60a6                	ld	ra,72(sp)
    8000255e:	6406                	ld	s0,64(sp)
    80002560:	74e2                	ld	s1,56(sp)
    80002562:	7942                	ld	s2,48(sp)
    80002564:	79a2                	ld	s3,40(sp)
    80002566:	7a02                	ld	s4,32(sp)
    80002568:	6ae2                	ld	s5,24(sp)
    8000256a:	6b42                	ld	s6,16(sp)
    8000256c:	6ba2                	ld	s7,8(sp)
    8000256e:	6c02                	ld	s8,0(sp)
    80002570:	6161                	addi	sp,sp,80
    80002572:	8082                	ret

0000000080002574 <reparent>:
{
    80002574:	7179                	addi	sp,sp,-48
    80002576:	f406                	sd	ra,40(sp)
    80002578:	f022                	sd	s0,32(sp)
    8000257a:	ec26                	sd	s1,24(sp)
    8000257c:	e84a                	sd	s2,16(sp)
    8000257e:	e44e                	sd	s3,8(sp)
    80002580:	e052                	sd	s4,0(sp)
    80002582:	1800                	addi	s0,sp,48
    80002584:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002586:	00012497          	auipc	s1,0x12
    8000258a:	0e248493          	addi	s1,s1,226 # 80014668 <proc>
      pp->parent = initproc;
    8000258e:	00009a17          	auipc	s4,0x9
    80002592:	2f2a0a13          	addi	s4,s4,754 # 8000b880 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80002596:	00018997          	auipc	s3,0x18
    8000259a:	ed298993          	addi	s3,s3,-302 # 8001a468 <tickslock>
    8000259e:	a029                	j	800025a8 <reparent+0x34>
    800025a0:	17848493          	addi	s1,s1,376
    800025a4:	01348b63          	beq	s1,s3,800025ba <reparent+0x46>
    if(pp->parent == p){
    800025a8:	64bc                	ld	a5,72(s1)
    800025aa:	ff279be3          	bne	a5,s2,800025a0 <reparent+0x2c>
      pp->parent = initproc;
    800025ae:	000a3503          	ld	a0,0(s4)
    800025b2:	e4a8                	sd	a0,72(s1)
      wakeup(initproc);
    800025b4:	f07ff0ef          	jal	800024ba <wakeup>
    800025b8:	b7e5                	j	800025a0 <reparent+0x2c>
}
    800025ba:	70a2                	ld	ra,40(sp)
    800025bc:	7402                	ld	s0,32(sp)
    800025be:	64e2                	ld	s1,24(sp)
    800025c0:	6942                	ld	s2,16(sp)
    800025c2:	69a2                	ld	s3,8(sp)
    800025c4:	6a02                	ld	s4,0(sp)
    800025c6:	6145                	addi	sp,sp,48
    800025c8:	8082                	ret

00000000800025ca <exit>:
{
    800025ca:	7179                	addi	sp,sp,-48
    800025cc:	f406                	sd	ra,40(sp)
    800025ce:	f022                	sd	s0,32(sp)
    800025d0:	ec26                	sd	s1,24(sp)
    800025d2:	e84a                	sd	s2,16(sp)
    800025d4:	e44e                	sd	s3,8(sp)
    800025d6:	e052                	sd	s4,0(sp)
    800025d8:	1800                	addi	s0,sp,48
    800025da:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800025dc:	e4aff0ef          	jal	80001c26 <myproc>
    800025e0:	89aa                	mv	s3,a0
  if(p == initproc)
    800025e2:	00009797          	auipc	a5,0x9
    800025e6:	29e7b783          	ld	a5,670(a5) # 8000b880 <initproc>
    800025ea:	0e050493          	addi	s1,a0,224
    800025ee:	16050913          	addi	s2,a0,352
    800025f2:	00a79f63          	bne	a5,a0,80002610 <exit+0x46>
    panic("init exiting");
    800025f6:	00006517          	auipc	a0,0x6
    800025fa:	cb250513          	addi	a0,a0,-846 # 800082a8 <etext+0x2a8>
    800025fe:	9c8fe0ef          	jal	800007c6 <panic>
      fileclose(f);
    80002602:	642020ef          	jal	80004c44 <fileclose>
      p->ofile[fd] = 0;
    80002606:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    8000260a:	04a1                	addi	s1,s1,8
    8000260c:	01248563          	beq	s1,s2,80002616 <exit+0x4c>
    if(p->ofile[fd]){
    80002610:	6088                	ld	a0,0(s1)
    80002612:	f965                	bnez	a0,80002602 <exit+0x38>
    80002614:	bfdd                	j	8000260a <exit+0x40>
  begin_op();
    80002616:	214020ef          	jal	8000482a <begin_op>
  iput(p->cwd);
    8000261a:	1609b503          	ld	a0,352(s3)
    8000261e:	2f9010ef          	jal	80004116 <iput>
  end_op();
    80002622:	272020ef          	jal	80004894 <end_op>
  p->cwd = 0;
    80002626:	1609b023          	sd	zero,352(s3)
  acquire(&wait_lock);
    8000262a:	00012497          	auipc	s1,0x12
    8000262e:	c0e48493          	addi	s1,s1,-1010 # 80014238 <wait_lock>
    80002632:	8526                	mv	a0,s1
    80002634:	df2fe0ef          	jal	80000c26 <acquire>
  reparent(p);
    80002638:	854e                	mv	a0,s3
    8000263a:	f3bff0ef          	jal	80002574 <reparent>
  wakeup(p->parent);
    8000263e:	0489b503          	ld	a0,72(s3)
    80002642:	e79ff0ef          	jal	800024ba <wakeup>
  acquire(&p->lock);
    80002646:	854e                	mv	a0,s3
    80002648:	ddefe0ef          	jal	80000c26 <acquire>
  p->xstate = status;
    8000264c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002650:	4795                	li	a5,5
    80002652:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002656:	8526                	mv	a0,s1
    80002658:	e66fe0ef          	jal	80000cbe <release>
  sched();
    8000265c:	d15ff0ef          	jal	80002370 <sched>
  panic("zombie exit");
    80002660:	00006517          	auipc	a0,0x6
    80002664:	c5850513          	addi	a0,a0,-936 # 800082b8 <etext+0x2b8>
    80002668:	95efe0ef          	jal	800007c6 <panic>

000000008000266c <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    8000266c:	7179                	addi	sp,sp,-48
    8000266e:	f406                	sd	ra,40(sp)
    80002670:	f022                	sd	s0,32(sp)
    80002672:	ec26                	sd	s1,24(sp)
    80002674:	e84a                	sd	s2,16(sp)
    80002676:	e44e                	sd	s3,8(sp)
    80002678:	1800                	addi	s0,sp,48
    8000267a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000267c:	00012497          	auipc	s1,0x12
    80002680:	fec48493          	addi	s1,s1,-20 # 80014668 <proc>
    80002684:	00018997          	auipc	s3,0x18
    80002688:	de498993          	addi	s3,s3,-540 # 8001a468 <tickslock>
    acquire(&p->lock);
    8000268c:	8526                	mv	a0,s1
    8000268e:	d98fe0ef          	jal	80000c26 <acquire>
    if(p->pid == pid){
    80002692:	589c                	lw	a5,48(s1)
    80002694:	01278b63          	beq	a5,s2,800026aa <kill+0x3e>
        }
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002698:	8526                	mv	a0,s1
    8000269a:	e24fe0ef          	jal	80000cbe <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000269e:	17848493          	addi	s1,s1,376
    800026a2:	ff3495e3          	bne	s1,s3,8000268c <kill+0x20>
  }
  return -1;
    800026a6:	557d                	li	a0,-1
    800026a8:	a819                	j	800026be <kill+0x52>
      p->killed = 1;
    800026aa:	4785                	li	a5,1
    800026ac:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800026ae:	4c98                	lw	a4,24(s1)
    800026b0:	4789                	li	a5,2
    800026b2:	00f70d63          	beq	a4,a5,800026cc <kill+0x60>
      release(&p->lock);
    800026b6:	8526                	mv	a0,s1
    800026b8:	e06fe0ef          	jal	80000cbe <release>
      return 0;
    800026bc:	4501                	li	a0,0
}
    800026be:	70a2                	ld	ra,40(sp)
    800026c0:	7402                	ld	s0,32(sp)
    800026c2:	64e2                	ld	s1,24(sp)
    800026c4:	6942                	ld	s2,16(sp)
    800026c6:	69a2                	ld	s3,8(sp)
    800026c8:	6145                	addi	sp,sp,48
    800026ca:	8082                	ret
        p->state = RUNNABLE;
    800026cc:	478d                	li	a5,3
    800026ce:	cc9c                	sw	a5,24(s1)
        if (checkmode == 0) fcfs_push(p);
    800026d0:	00009797          	auipc	a5,0x9
    800026d4:	1ac7a783          	lw	a5,428(a5) # 8000b87c <checkmode>
    800026d8:	ef91                	bnez	a5,800026f4 <kill+0x88>
    800026da:	8526                	mv	a0,s1
    800026dc:	aaaff0ef          	jal	80001986 <fcfs_push>
        if (checkmode == 0) { // FCFS
    800026e0:	00009797          	auipc	a5,0x9
    800026e4:	19c7a783          	lw	a5,412(a5) # 8000b87c <checkmode>
    800026e8:	eb99                	bnez	a5,800026fe <kill+0x92>
          p->priority = -1;     
    800026ea:	57fd                	li	a5,-1
    800026ec:	dc9c                	sw	a5,56(s1)
          p->level = -1;
    800026ee:	d8dc                	sw	a5,52(s1)
          p->time_quantum = -1;
    800026f0:	dcdc                	sw	a5,60(s1)
    800026f2:	b7d1                	j	800026b6 <kill+0x4a>
        else mlfq_push(0, p);
    800026f4:	85a6                	mv	a1,s1
    800026f6:	4501                	li	a0,0
    800026f8:	b5cff0ef          	jal	80001a54 <mlfq_push>
    800026fc:	b7d5                	j	800026e0 <kill+0x74>
          p->level = 0; // L0
    800026fe:	0204aa23          	sw	zero,52(s1)
          p->priority = 3; // 3 - Highest value
    80002702:	478d                	li	a5,3
    80002704:	dc9c                	sw	a5,56(s1)
          p->time_quantum = 0;
    80002706:	0204ae23          	sw	zero,60(s1)
          p->limits = 1; // L0의 time quantum은 1
    8000270a:	4785                	li	a5,1
    8000270c:	c0bc                	sw	a5,64(s1)
    8000270e:	b765                	j	800026b6 <kill+0x4a>

0000000080002710 <setkilled>:

void
setkilled(struct proc *p)
{
    80002710:	1101                	addi	sp,sp,-32
    80002712:	ec06                	sd	ra,24(sp)
    80002714:	e822                	sd	s0,16(sp)
    80002716:	e426                	sd	s1,8(sp)
    80002718:	1000                	addi	s0,sp,32
    8000271a:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000271c:	d0afe0ef          	jal	80000c26 <acquire>
  p->killed = 1;
    80002720:	4785                	li	a5,1
    80002722:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002724:	8526                	mv	a0,s1
    80002726:	d98fe0ef          	jal	80000cbe <release>
}
    8000272a:	60e2                	ld	ra,24(sp)
    8000272c:	6442                	ld	s0,16(sp)
    8000272e:	64a2                	ld	s1,8(sp)
    80002730:	6105                	addi	sp,sp,32
    80002732:	8082                	ret

0000000080002734 <killed>:

int
killed(struct proc *p)
{
    80002734:	1101                	addi	sp,sp,-32
    80002736:	ec06                	sd	ra,24(sp)
    80002738:	e822                	sd	s0,16(sp)
    8000273a:	e426                	sd	s1,8(sp)
    8000273c:	e04a                	sd	s2,0(sp)
    8000273e:	1000                	addi	s0,sp,32
    80002740:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80002742:	ce4fe0ef          	jal	80000c26 <acquire>
  k = p->killed;
    80002746:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000274a:	8526                	mv	a0,s1
    8000274c:	d72fe0ef          	jal	80000cbe <release>
  return k;
}
    80002750:	854a                	mv	a0,s2
    80002752:	60e2                	ld	ra,24(sp)
    80002754:	6442                	ld	s0,16(sp)
    80002756:	64a2                	ld	s1,8(sp)
    80002758:	6902                	ld	s2,0(sp)
    8000275a:	6105                	addi	sp,sp,32
    8000275c:	8082                	ret

000000008000275e <wait>:
{
    8000275e:	715d                	addi	sp,sp,-80
    80002760:	e486                	sd	ra,72(sp)
    80002762:	e0a2                	sd	s0,64(sp)
    80002764:	fc26                	sd	s1,56(sp)
    80002766:	f84a                	sd	s2,48(sp)
    80002768:	f44e                	sd	s3,40(sp)
    8000276a:	f052                	sd	s4,32(sp)
    8000276c:	ec56                	sd	s5,24(sp)
    8000276e:	e85a                	sd	s6,16(sp)
    80002770:	e45e                	sd	s7,8(sp)
    80002772:	e062                	sd	s8,0(sp)
    80002774:	0880                	addi	s0,sp,80
    80002776:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002778:	caeff0ef          	jal	80001c26 <myproc>
    8000277c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000277e:	00012517          	auipc	a0,0x12
    80002782:	aba50513          	addi	a0,a0,-1350 # 80014238 <wait_lock>
    80002786:	ca0fe0ef          	jal	80000c26 <acquire>
    havekids = 0;
    8000278a:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    8000278c:	4a15                	li	s4,5
        havekids = 1;
    8000278e:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002790:	00018997          	auipc	s3,0x18
    80002794:	cd898993          	addi	s3,s3,-808 # 8001a468 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002798:	00012c17          	auipc	s8,0x12
    8000279c:	aa0c0c13          	addi	s8,s8,-1376 # 80014238 <wait_lock>
    800027a0:	a871                	j	8000283c <wait+0xde>
          pid = pp->pid;
    800027a2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800027a6:	000b0c63          	beqz	s6,800027be <wait+0x60>
    800027aa:	4691                	li	a3,4
    800027ac:	02c48613          	addi	a2,s1,44
    800027b0:	85da                	mv	a1,s6
    800027b2:	06093503          	ld	a0,96(s2)
    800027b6:	dcffe0ef          	jal	80001584 <copyout>
    800027ba:	02054b63          	bltz	a0,800027f0 <wait+0x92>
          freeproc(pp);
    800027be:	8526                	mv	a0,s1
    800027c0:	ddaff0ef          	jal	80001d9a <freeproc>
          release(&pp->lock);
    800027c4:	8526                	mv	a0,s1
    800027c6:	cf8fe0ef          	jal	80000cbe <release>
          release(&wait_lock);
    800027ca:	00012517          	auipc	a0,0x12
    800027ce:	a6e50513          	addi	a0,a0,-1426 # 80014238 <wait_lock>
    800027d2:	cecfe0ef          	jal	80000cbe <release>
}
    800027d6:	854e                	mv	a0,s3
    800027d8:	60a6                	ld	ra,72(sp)
    800027da:	6406                	ld	s0,64(sp)
    800027dc:	74e2                	ld	s1,56(sp)
    800027de:	7942                	ld	s2,48(sp)
    800027e0:	79a2                	ld	s3,40(sp)
    800027e2:	7a02                	ld	s4,32(sp)
    800027e4:	6ae2                	ld	s5,24(sp)
    800027e6:	6b42                	ld	s6,16(sp)
    800027e8:	6ba2                	ld	s7,8(sp)
    800027ea:	6c02                	ld	s8,0(sp)
    800027ec:	6161                	addi	sp,sp,80
    800027ee:	8082                	ret
            release(&pp->lock);
    800027f0:	8526                	mv	a0,s1
    800027f2:	cccfe0ef          	jal	80000cbe <release>
            release(&wait_lock);
    800027f6:	00012517          	auipc	a0,0x12
    800027fa:	a4250513          	addi	a0,a0,-1470 # 80014238 <wait_lock>
    800027fe:	cc0fe0ef          	jal	80000cbe <release>
            return -1;
    80002802:	59fd                	li	s3,-1
    80002804:	bfc9                	j	800027d6 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002806:	17848493          	addi	s1,s1,376
    8000280a:	03348063          	beq	s1,s3,8000282a <wait+0xcc>
      if(pp->parent == p){
    8000280e:	64bc                	ld	a5,72(s1)
    80002810:	ff279be3          	bne	a5,s2,80002806 <wait+0xa8>
        acquire(&pp->lock);
    80002814:	8526                	mv	a0,s1
    80002816:	c10fe0ef          	jal	80000c26 <acquire>
        if(pp->state == ZOMBIE){
    8000281a:	4c9c                	lw	a5,24(s1)
    8000281c:	f94783e3          	beq	a5,s4,800027a2 <wait+0x44>
        release(&pp->lock);
    80002820:	8526                	mv	a0,s1
    80002822:	c9cfe0ef          	jal	80000cbe <release>
        havekids = 1;
    80002826:	8756                	mv	a4,s5
    80002828:	bff9                	j	80002806 <wait+0xa8>
    if(!havekids || killed(p)){
    8000282a:	cf19                	beqz	a4,80002848 <wait+0xea>
    8000282c:	854a                	mv	a0,s2
    8000282e:	f07ff0ef          	jal	80002734 <killed>
    80002832:	e919                	bnez	a0,80002848 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002834:	85e2                	mv	a1,s8
    80002836:	854a                	mv	a0,s2
    80002838:	c37ff0ef          	jal	8000246e <sleep>
    havekids = 0;
    8000283c:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000283e:	00012497          	auipc	s1,0x12
    80002842:	e2a48493          	addi	s1,s1,-470 # 80014668 <proc>
    80002846:	b7e1                	j	8000280e <wait+0xb0>
      release(&wait_lock);
    80002848:	00012517          	auipc	a0,0x12
    8000284c:	9f050513          	addi	a0,a0,-1552 # 80014238 <wait_lock>
    80002850:	c6efe0ef          	jal	80000cbe <release>
      return -1;
    80002854:	59fd                	li	s3,-1
    80002856:	b741                	j	800027d6 <wait+0x78>

0000000080002858 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002858:	7179                	addi	sp,sp,-48
    8000285a:	f406                	sd	ra,40(sp)
    8000285c:	f022                	sd	s0,32(sp)
    8000285e:	ec26                	sd	s1,24(sp)
    80002860:	e84a                	sd	s2,16(sp)
    80002862:	e44e                	sd	s3,8(sp)
    80002864:	e052                	sd	s4,0(sp)
    80002866:	1800                	addi	s0,sp,48
    80002868:	84aa                	mv	s1,a0
    8000286a:	892e                	mv	s2,a1
    8000286c:	89b2                	mv	s3,a2
    8000286e:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80002870:	bb6ff0ef          	jal	80001c26 <myproc>
  if(user_dst){
    80002874:	cc99                	beqz	s1,80002892 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002876:	86d2                	mv	a3,s4
    80002878:	864e                	mv	a2,s3
    8000287a:	85ca                	mv	a1,s2
    8000287c:	7128                	ld	a0,96(a0)
    8000287e:	d07fe0ef          	jal	80001584 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002882:	70a2                	ld	ra,40(sp)
    80002884:	7402                	ld	s0,32(sp)
    80002886:	64e2                	ld	s1,24(sp)
    80002888:	6942                	ld	s2,16(sp)
    8000288a:	69a2                	ld	s3,8(sp)
    8000288c:	6a02                	ld	s4,0(sp)
    8000288e:	6145                	addi	sp,sp,48
    80002890:	8082                	ret
    memmove((char *)dst, src, len);
    80002892:	000a061b          	sext.w	a2,s4
    80002896:	85ce                	mv	a1,s3
    80002898:	854a                	mv	a0,s2
    8000289a:	cbcfe0ef          	jal	80000d56 <memmove>
    return 0;
    8000289e:	8526                	mv	a0,s1
    800028a0:	b7cd                	j	80002882 <either_copyout+0x2a>

00000000800028a2 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800028a2:	7179                	addi	sp,sp,-48
    800028a4:	f406                	sd	ra,40(sp)
    800028a6:	f022                	sd	s0,32(sp)
    800028a8:	ec26                	sd	s1,24(sp)
    800028aa:	e84a                	sd	s2,16(sp)
    800028ac:	e44e                	sd	s3,8(sp)
    800028ae:	e052                	sd	s4,0(sp)
    800028b0:	1800                	addi	s0,sp,48
    800028b2:	892a                	mv	s2,a0
    800028b4:	84ae                	mv	s1,a1
    800028b6:	89b2                	mv	s3,a2
    800028b8:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800028ba:	b6cff0ef          	jal	80001c26 <myproc>
  if(user_src){
    800028be:	cc99                	beqz	s1,800028dc <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800028c0:	86d2                	mv	a3,s4
    800028c2:	864e                	mv	a2,s3
    800028c4:	85ca                	mv	a1,s2
    800028c6:	7128                	ld	a0,96(a0)
    800028c8:	d93fe0ef          	jal	8000165a <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800028cc:	70a2                	ld	ra,40(sp)
    800028ce:	7402                	ld	s0,32(sp)
    800028d0:	64e2                	ld	s1,24(sp)
    800028d2:	6942                	ld	s2,16(sp)
    800028d4:	69a2                	ld	s3,8(sp)
    800028d6:	6a02                	ld	s4,0(sp)
    800028d8:	6145                	addi	sp,sp,48
    800028da:	8082                	ret
    memmove(dst, (char*)src, len);
    800028dc:	000a061b          	sext.w	a2,s4
    800028e0:	85ce                	mv	a1,s3
    800028e2:	854a                	mv	a0,s2
    800028e4:	c72fe0ef          	jal	80000d56 <memmove>
    return 0;
    800028e8:	8526                	mv	a0,s1
    800028ea:	b7cd                	j	800028cc <either_copyin+0x2a>

00000000800028ec <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800028ec:	715d                	addi	sp,sp,-80
    800028ee:	e486                	sd	ra,72(sp)
    800028f0:	e0a2                	sd	s0,64(sp)
    800028f2:	fc26                	sd	s1,56(sp)
    800028f4:	f84a                	sd	s2,48(sp)
    800028f6:	f44e                	sd	s3,40(sp)
    800028f8:	f052                	sd	s4,32(sp)
    800028fa:	ec56                	sd	s5,24(sp)
    800028fc:	e85a                	sd	s6,16(sp)
    800028fe:	e45e                	sd	s7,8(sp)
    80002900:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002902:	00005517          	auipc	a0,0x5
    80002906:	77e50513          	addi	a0,a0,1918 # 80008080 <etext+0x80>
    8000290a:	bebfd0ef          	jal	800004f4 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000290e:	00012497          	auipc	s1,0x12
    80002912:	ec248493          	addi	s1,s1,-318 # 800147d0 <proc+0x168>
    80002916:	00018917          	auipc	s2,0x18
    8000291a:	cba90913          	addi	s2,s2,-838 # 8001a5d0 <bcache+0x150>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000291e:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002920:	00006997          	auipc	s3,0x6
    80002924:	9a898993          	addi	s3,s3,-1624 # 800082c8 <etext+0x2c8>
    printf("%d %s %s", p->pid, state, p->name);
    80002928:	00006a97          	auipc	s5,0x6
    8000292c:	9a8a8a93          	addi	s5,s5,-1624 # 800082d0 <etext+0x2d0>
    printf("\n");
    80002930:	00005a17          	auipc	s4,0x5
    80002934:	750a0a13          	addi	s4,s4,1872 # 80008080 <etext+0x80>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002938:	00006b97          	auipc	s7,0x6
    8000293c:	ee0b8b93          	addi	s7,s7,-288 # 80008818 <states.0>
    80002940:	a829                	j	8000295a <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002942:	ec86a583          	lw	a1,-312(a3)
    80002946:	8556                	mv	a0,s5
    80002948:	badfd0ef          	jal	800004f4 <printf>
    printf("\n");
    8000294c:	8552                	mv	a0,s4
    8000294e:	ba7fd0ef          	jal	800004f4 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002952:	17848493          	addi	s1,s1,376
    80002956:	03248263          	beq	s1,s2,8000297a <procdump+0x8e>
    if(p->state == UNUSED)
    8000295a:	86a6                	mv	a3,s1
    8000295c:	eb04a783          	lw	a5,-336(s1)
    80002960:	dbed                	beqz	a5,80002952 <procdump+0x66>
      state = "???";
    80002962:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002964:	fcfb6fe3          	bltu	s6,a5,80002942 <procdump+0x56>
    80002968:	02079713          	slli	a4,a5,0x20
    8000296c:	01d75793          	srli	a5,a4,0x1d
    80002970:	97de                	add	a5,a5,s7
    80002972:	6390                	ld	a2,0(a5)
    80002974:	f679                	bnez	a2,80002942 <procdump+0x56>
      state = "???";
    80002976:	864e                	mv	a2,s3
    80002978:	b7e9                	j	80002942 <procdump+0x56>
  }
}
    8000297a:	60a6                	ld	ra,72(sp)
    8000297c:	6406                	ld	s0,64(sp)
    8000297e:	74e2                	ld	s1,56(sp)
    80002980:	7942                	ld	s2,48(sp)
    80002982:	79a2                	ld	s3,40(sp)
    80002984:	7a02                	ld	s4,32(sp)
    80002986:	6ae2                	ld	s5,24(sp)
    80002988:	6b42                	ld	s6,16(sp)
    8000298a:	6ba2                	ld	s7,8(sp)
    8000298c:	6161                	addi	sp,sp,80
    8000298e:	8082                	ret

0000000080002990 <getlev>:

int 
getlev(void)
{
    80002990:	1101                	addi	sp,sp,-32
    80002992:	ec06                	sd	ra,24(sp)
    80002994:	e822                	sd	s0,16(sp)
    80002996:	e426                	sd	s1,8(sp)
    80002998:	1000                	addi	s0,sp,32
  if (checkmode == 0) return 99;
    8000299a:	00009797          	auipc	a5,0x9
    8000299e:	ee27a783          	lw	a5,-286(a5) # 8000b87c <checkmode>
    800029a2:	06300493          	li	s1,99
    800029a6:	e799                	bnez	a5,800029b4 <getlev+0x24>
    acquire(&p->lock);
    int l = p->level;
    release(&p->lock);
    return l;
  }
} 
    800029a8:	8526                	mv	a0,s1
    800029aa:	60e2                	ld	ra,24(sp)
    800029ac:	6442                	ld	s0,16(sp)
    800029ae:	64a2                	ld	s1,8(sp)
    800029b0:	6105                	addi	sp,sp,32
    800029b2:	8082                	ret
    800029b4:	e04a                	sd	s2,0(sp)
    struct proc *p = myproc();
    800029b6:	a70ff0ef          	jal	80001c26 <myproc>
    800029ba:	892a                	mv	s2,a0
    acquire(&p->lock);
    800029bc:	a6afe0ef          	jal	80000c26 <acquire>
    int l = p->level;
    800029c0:	03492483          	lw	s1,52(s2)
    release(&p->lock);
    800029c4:	854a                	mv	a0,s2
    800029c6:	af8fe0ef          	jal	80000cbe <release>
    800029ca:	6902                	ld	s2,0(sp)
    return l;
    800029cc:	bff1                	j	800029a8 <getlev+0x18>

00000000800029ce <setpriority>:

int 
setpriority(int pid, int priority) 
{
  if (priority < 0 || priority > 3) return -2;
    800029ce:	478d                	li	a5,3
    800029d0:	06b7e163          	bltu	a5,a1,80002a32 <setpriority+0x64>
{
    800029d4:	7179                	addi	sp,sp,-48
    800029d6:	f406                	sd	ra,40(sp)
    800029d8:	f022                	sd	s0,32(sp)
    800029da:	ec26                	sd	s1,24(sp)
    800029dc:	e84a                	sd	s2,16(sp)
    800029de:	e44e                	sd	s3,8(sp)
    800029e0:	e052                	sd	s4,0(sp)
    800029e2:	1800                	addi	s0,sp,48
    800029e4:	892a                	mv	s2,a0
    800029e6:	8a2e                	mv	s4,a1

  for (struct proc *p = proc; p < &proc[NPROC]; p++) {
    800029e8:	00012497          	auipc	s1,0x12
    800029ec:	c8048493          	addi	s1,s1,-896 # 80014668 <proc>
    800029f0:	00018997          	auipc	s3,0x18
    800029f4:	a7898993          	addi	s3,s3,-1416 # 8001a468 <tickslock>
    acquire(&p->lock);
    800029f8:	8526                	mv	a0,s1
    800029fa:	a2cfe0ef          	jal	80000c26 <acquire>
    if (p->pid == pid) {
    800029fe:	589c                	lw	a5,48(s1)
    80002a00:	01278b63          	beq	a5,s2,80002a16 <setpriority+0x48>
      p->priority = priority;
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002a04:	8526                	mv	a0,s1
    80002a06:	ab8fe0ef          	jal	80000cbe <release>
  for (struct proc *p = proc; p < &proc[NPROC]; p++) {
    80002a0a:	17848493          	addi	s1,s1,376
    80002a0e:	ff3495e3          	bne	s1,s3,800029f8 <setpriority+0x2a>
  }
  
  return -1;  
    80002a12:	557d                	li	a0,-1
    80002a14:	a039                	j	80002a22 <setpriority+0x54>
      p->priority = priority;
    80002a16:	0344ac23          	sw	s4,56(s1)
      release(&p->lock);
    80002a1a:	8526                	mv	a0,s1
    80002a1c:	aa2fe0ef          	jal	80000cbe <release>
      return 0;
    80002a20:	4501                	li	a0,0
}
    80002a22:	70a2                	ld	ra,40(sp)
    80002a24:	7402                	ld	s0,32(sp)
    80002a26:	64e2                	ld	s1,24(sp)
    80002a28:	6942                	ld	s2,16(sp)
    80002a2a:	69a2                	ld	s3,8(sp)
    80002a2c:	6a02                	ld	s4,0(sp)
    80002a2e:	6145                	addi	sp,sp,48
    80002a30:	8082                	ret
  if (priority < 0 || priority > 3) return -2;
    80002a32:	5579                	li	a0,-2
}
    80002a34:	8082                	ret

0000000080002a36 <mlfqmode>:

int 
mlfqmode (void)
{
  if (checkmode == 1) { // 이미 MLFQ mode인지 확인
    80002a36:	00009717          	auipc	a4,0x9
    80002a3a:	e4672703          	lw	a4,-442(a4) # 8000b87c <checkmode>
    80002a3e:	4785                	li	a5,1
    80002a40:	0af70b63          	beq	a4,a5,80002af6 <mlfqmode+0xc0>
{
    80002a44:	7179                	addi	sp,sp,-48
    80002a46:	f406                	sd	ra,40(sp)
    80002a48:	f022                	sd	s0,32(sp)
    80002a4a:	ec26                	sd	s1,24(sp)
    80002a4c:	e84a                	sd	s2,16(sp)
    80002a4e:	e44e                	sd	s3,8(sp)
    80002a50:	1800                	addi	s0,sp,48
    //printf("no changes are made\n"); - testcase에서 출력
    return -1;
  }

  acquire(&modelock);
    80002a52:	00011517          	auipc	a0,0x11
    80002a56:	7fe50513          	addi	a0,a0,2046 # 80014250 <modelock>
    80002a5a:	9ccfe0ef          	jal	80000c26 <acquire>

  checkmode = 1;
    80002a5e:	4785                	li	a5,1
    80002a60:	00009717          	auipc	a4,0x9
    80002a64:	e0f72e23          	sw	a5,-484(a4) # 8000b87c <checkmode>
  global_tick_count = 0;
    80002a68:	00009797          	auipc	a5,0x9
    80002a6c:	e007a823          	sw	zero,-496(a5) # 8000b878 <global_tick_count>
  // FCFS 큐에 있던 프로세스를 모두 L0으로 이동
  while (!fcfs_empty()) {
    struct proc *p = fcfs_pop();

    acquire(&p->lock);
    if (p->state == RUNNABLE) {
    80002a70:	490d                	li	s2,3
      p->level = 0;
      p->priority = 3;
      p->time_quantum = 0;
      p->limits = 1;
    80002a72:	4985                	li	s3,1
  while (!fcfs_empty()) {
    80002a74:	a021                	j	80002a7c <mlfqmode+0x46>
      mlfq_push(0, p);
    }
    release(&p->lock);
    80002a76:	8526                	mv	a0,s1
    80002a78:	a46fe0ef          	jal	80000cbe <release>
  while (!fcfs_empty()) {
    80002a7c:	ed3fe0ef          	jal	8000194e <fcfs_empty>
    80002a80:	e515                	bnez	a0,80002aac <mlfqmode+0x76>
    struct proc *p = fcfs_pop();
    80002a82:	ee9fe0ef          	jal	8000196a <fcfs_pop>
    80002a86:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002a88:	99efe0ef          	jal	80000c26 <acquire>
    if (p->state == RUNNABLE) {
    80002a8c:	4c9c                	lw	a5,24(s1)
    80002a8e:	ff2794e3          	bne	a5,s2,80002a76 <mlfqmode+0x40>
      p->level = 0;
    80002a92:	0204aa23          	sw	zero,52(s1)
      p->priority = 3;
    80002a96:	0324ac23          	sw	s2,56(s1)
      p->time_quantum = 0;
    80002a9a:	0204ae23          	sw	zero,60(s1)
      p->limits = 1;
    80002a9e:	0534a023          	sw	s3,64(s1)
      mlfq_push(0, p);
    80002aa2:	85a6                	mv	a1,s1
    80002aa4:	4501                	li	a0,0
    80002aa6:	faffe0ef          	jal	80001a54 <mlfq_push>
    80002aaa:	b7f1                	j	80002a76 <mlfqmode+0x40>
  }

  // 현재 실행 중인 프로세스를 L0으로 초기화
  // 계속 실행은 되도록 한다.
  struct proc *now = myproc();
    80002aac:	97aff0ef          	jal	80001c26 <myproc>
    80002ab0:	84aa                	mv	s1,a0
  acquire(&now->lock);
    80002ab2:	974fe0ef          	jal	80000c26 <acquire>
  if (now->state == RUNNING) {
    80002ab6:	4c98                	lw	a4,24(s1)
    80002ab8:	4791                	li	a5,4
    80002aba:	02f70563          	beq	a4,a5,80002ae4 <mlfqmode+0xae>
    now->level = 0;
    now->priority = 3;
    now->time_quantum = 0;
    now->limits = 1;
  }
  release(&now->lock);
    80002abe:	8526                	mv	a0,s1
    80002ac0:	9fefe0ef          	jal	80000cbe <release>
  
  fcfs_init();
    80002ac4:	e53fe0ef          	jal	80001916 <fcfs_init>
  release(&modelock);
    80002ac8:	00011517          	auipc	a0,0x11
    80002acc:	78850513          	addi	a0,a0,1928 # 80014250 <modelock>
    80002ad0:	9eefe0ef          	jal	80000cbe <release>
  return 0;
    80002ad4:	4501                	li	a0,0
}
    80002ad6:	70a2                	ld	ra,40(sp)
    80002ad8:	7402                	ld	s0,32(sp)
    80002ada:	64e2                	ld	s1,24(sp)
    80002adc:	6942                	ld	s2,16(sp)
    80002ade:	69a2                	ld	s3,8(sp)
    80002ae0:	6145                	addi	sp,sp,48
    80002ae2:	8082                	ret
    now->level = 0;
    80002ae4:	0204aa23          	sw	zero,52(s1)
    now->priority = 3;
    80002ae8:	478d                	li	a5,3
    80002aea:	dc9c                	sw	a5,56(s1)
    now->time_quantum = 0;
    80002aec:	0204ae23          	sw	zero,60(s1)
    now->limits = 1;
    80002af0:	4785                	li	a5,1
    80002af2:	c0bc                	sw	a5,64(s1)
    80002af4:	b7e9                	j	80002abe <mlfqmode+0x88>
    return -1;
    80002af6:	557d                	li	a0,-1
}
    80002af8:	8082                	ret

0000000080002afa <fcfsmode>:

int 
fcfsmode (void)
{ 
  if (checkmode == 0) { // 이미 FCFS인지 확인
    80002afa:	00009797          	auipc	a5,0x9
    80002afe:	d827a783          	lw	a5,-638(a5) # 8000b87c <checkmode>
    80002b02:	18078663          	beqz	a5,80002c8e <fcfsmode+0x194>
{ 
    80002b06:	db010113          	addi	sp,sp,-592
    80002b0a:	24113423          	sd	ra,584(sp)
    80002b0e:	24813023          	sd	s0,576(sp)
    80002b12:	22913c23          	sd	s1,568(sp)
    80002b16:	23213823          	sd	s2,560(sp)
    80002b1a:	23313423          	sd	s3,552(sp)
    80002b1e:	23413023          	sd	s4,544(sp)
    80002b22:	21513c23          	sd	s5,536(sp)
    80002b26:	21613823          	sd	s6,528(sp)
    80002b2a:	21713423          	sd	s7,520(sp)
    80002b2e:	0c80                	addi	s0,sp,592
    // printf("no changes are made\n"); - testcase에서 출력 
    return -1;
  } 

  acquire(&modelock);
    80002b30:	00011517          	auipc	a0,0x11
    80002b34:	72050513          	addi	a0,a0,1824 # 80014250 <modelock>
    80002b38:	8eefe0ef          	jal	80000c26 <acquire>

  checkmode = 0;
    80002b3c:	00009797          	auipc	a5,0x9
    80002b40:	d407a023          	sw	zero,-704(a5) # 8000b87c <checkmode>
  global_tick_count = 0;
    80002b44:	00009797          	auipc	a5,0x9
    80002b48:	d207aa23          	sw	zero,-716(a5) # 8000b878 <global_tick_count>
 
  int index = 0;
  struct proc* temp; // 임시 저장 용
  struct proc* runnable_proc[NPROC];

  for (int i = 0; i < 3; i++) {
    80002b4c:	00011b17          	auipc	s6,0x11
    80002b50:	0a4b0b13          	addi	s6,s6,164 # 80013bf0 <mlfq>
    80002b54:	00011b97          	auipc	s7,0x11
    80002b58:	6ccb8b93          	addi	s7,s7,1740 # 80014220 <pid_lock>
  int index = 0;
    80002b5c:	4901                	li	s2,0
    while (!mlfq_empty(i)) {
      temp = mlfq_pop(i);

      acquire(&temp->lock);
      if (temp->state == RUNNABLE) {
    80002b5e:	4a8d                	li	s5,3
        temp->level = -1;
    80002b60:	5a7d                	li	s4,-1
    80002b62:	a0b1                	j	80002bae <fcfsmode+0xb4>
        temp->priority = -1;
        temp->time_quantum = -1;
        temp->limits = -1;
        runnable_proc[index++] = temp;
      }
      release(&temp->lock);
    80002b64:	8526                	mv	a0,s1
    80002b66:	958fe0ef          	jal	80000cbe <release>
  return queue_empty(&mlfq.entry[level]);
    80002b6a:	854e                	mv	a0,s3
    80002b6c:	cb3fe0ef          	jal	8000181e <queue_empty>
    while (!mlfq_empty(i)) {
    80002b70:	e91d                	bnez	a0,80002ba6 <fcfsmode+0xac>
  return queue_pop(&mlfq.entry[level]);
    80002b72:	854e                	mv	a0,s3
    80002b74:	ce3fe0ef          	jal	80001856 <queue_pop>
    80002b78:	84aa                	mv	s1,a0
      acquire(&temp->lock);
    80002b7a:	8acfe0ef          	jal	80000c26 <acquire>
      if (temp->state == RUNNABLE) {
    80002b7e:	4c9c                	lw	a5,24(s1)
    80002b80:	ff5792e3          	bne	a5,s5,80002b64 <fcfsmode+0x6a>
        temp->level = -1;
    80002b84:	0344aa23          	sw	s4,52(s1)
        temp->priority = -1;
    80002b88:	0344ac23          	sw	s4,56(s1)
        temp->time_quantum = -1;
    80002b8c:	0344ae23          	sw	s4,60(s1)
        temp->limits = -1;
    80002b90:	0544a023          	sw	s4,64(s1)
        runnable_proc[index++] = temp;
    80002b94:	00391793          	slli	a5,s2,0x3
    80002b98:	fb078793          	addi	a5,a5,-80
    80002b9c:	97a2                	add	a5,a5,s0
    80002b9e:	e097b023          	sd	s1,-512(a5)
    80002ba2:	2905                	addiw	s2,s2,1
    80002ba4:	b7c1                	j	80002b64 <fcfsmode+0x6a>
  for (int i = 0; i < 3; i++) {
    80002ba6:	210b0b13          	addi	s6,s6,528
    80002baa:	017b0463          	beq	s6,s7,80002bb2 <fcfsmode+0xb8>
  return queue_empty(&mlfq.entry[level]);
    80002bae:	89da                	mv	s3,s6
    80002bb0:	bf6d                	j	80002b6a <fcfsmode+0x70>
    }
  }

  // 현재 실행 중인 프로세스를를 FCFS으로 초기화
  // 계속 실행은 되도록 한다.
  struct proc *now = myproc();
    80002bb2:	874ff0ef          	jal	80001c26 <myproc>
    80002bb6:	84aa                	mv	s1,a0
  acquire(&now->lock);
    80002bb8:	86efe0ef          	jal	80000c26 <acquire>
  if (now->state == RUNNING) {
    80002bbc:	4c98                	lw	a4,24(s1)
    80002bbe:	4791                	li	a5,4
    80002bc0:	02f70263          	beq	a4,a5,80002be4 <fcfsmode+0xea>
    now->level = -1;
    now->priority = -1;
    now->time_quantum = -1;
    now->limits = -1;
  }
  release(&now->lock);
    80002bc4:	8526                	mv	a0,s1
    80002bc6:	8f8fe0ef          	jal	80000cbe <release>

  // Bubble sort로 pid 작은 순대로 정렬
  for (int i = 0; i < index - 1; i++) {
    80002bca:	4785                	li	a5,1
    80002bcc:	0727d563          	bge	a5,s2,80002c36 <fcfsmode+0x13c>
    80002bd0:	db840813          	addi	a6,s0,-584
    80002bd4:	02091313          	slli	t1,s2,0x20
    80002bd8:	02035313          	srli	t1,t1,0x20
    80002bdc:	4885                	li	a7,1
    80002bde:	fff90e1b          	addiw	t3,s2,-1
    80002be2:	a80d                	j	80002c14 <fcfsmode+0x11a>
    now->level = -1;
    80002be4:	57fd                	li	a5,-1
    80002be6:	d8dc                	sw	a5,52(s1)
    now->priority = -1;
    80002be8:	dc9c                	sw	a5,56(s1)
    now->time_quantum = -1;
    80002bea:	dcdc                	sw	a5,60(s1)
    now->limits = -1;
    80002bec:	c0bc                	sw	a5,64(s1)
    80002bee:	bfd9                	j	80002bc4 <fcfsmode+0xca>
    for (int j = i + 1; j < index; j++) {
    80002bf0:	07a1                	addi	a5,a5,8
    80002bf2:	00c78d63          	beq	a5,a2,80002c0c <fcfsmode+0x112>
      if (runnable_proc[i]->pid > runnable_proc[j]->pid) {
    80002bf6:	ff883703          	ld	a4,-8(a6)
    80002bfa:	6394                	ld	a3,0(a5)
    80002bfc:	5b08                	lw	a0,48(a4)
    80002bfe:	5a8c                	lw	a1,48(a3)
    80002c00:	fea5d8e3          	bge	a1,a0,80002bf0 <fcfsmode+0xf6>
        temp = runnable_proc[i];
        runnable_proc[i] = runnable_proc[j];
    80002c04:	fed83c23          	sd	a3,-8(a6)
        runnable_proc[j] = temp;
    80002c08:	e398                	sd	a4,0(a5)
    80002c0a:	b7dd                	j	80002bf0 <fcfsmode+0xf6>
  for (int i = 0; i < index - 1; i++) {
    80002c0c:	0885                	addi	a7,a7,1
    80002c0e:	0821                	addi	a6,a6,8
    80002c10:	02688563          	beq	a7,t1,80002c3a <fcfsmode+0x140>
    for (int j = i + 1; j < index; j++) {
    80002c14:	0008879b          	sext.w	a5,a7
    80002c18:	ff27dae3          	bge	a5,s2,80002c0c <fcfsmode+0x112>
    80002c1c:	40fe063b          	subw	a2,t3,a5
    80002c20:	1602                	slli	a2,a2,0x20
    80002c22:	9201                	srli	a2,a2,0x20
    80002c24:	fff88793          	addi	a5,a7,-1
    80002c28:	963e                	add	a2,a2,a5
    80002c2a:	060e                	slli	a2,a2,0x3
    80002c2c:	dc040793          	addi	a5,s0,-576
    80002c30:	963e                	add	a2,a2,a5
    80002c32:	87c2                	mv	a5,a6
    80002c34:	b7c9                	j	80002bf6 <fcfsmode+0xfc>
      }
    }
  }

  for (int i = 0; i < index; i++) {
    80002c36:	01205e63          	blez	s2,80002c52 <fcfsmode+0x158>
    80002c3a:	db040993          	addi	s3,s0,-592
    80002c3e:	00391493          	slli	s1,s2,0x3
    80002c42:	94ce                	add	s1,s1,s3
    fcfs_push(runnable_proc[i]);
    80002c44:	0009b503          	ld	a0,0(s3)
    80002c48:	d3ffe0ef          	jal	80001986 <fcfs_push>
  for (int i = 0; i < index; i++) {
    80002c4c:	09a1                	addi	s3,s3,8
    80002c4e:	fe999be3          	bne	s3,s1,80002c44 <fcfsmode+0x14a>
  }

  mlfq_init(); // queue를 초기화
    80002c52:	d5dfe0ef          	jal	800019ae <mlfq_init>

  release(&modelock);
    80002c56:	00011517          	auipc	a0,0x11
    80002c5a:	5fa50513          	addi	a0,a0,1530 # 80014250 <modelock>
    80002c5e:	860fe0ef          	jal	80000cbe <release>
  return 0;
    80002c62:	4501                	li	a0,0
}
    80002c64:	24813083          	ld	ra,584(sp)
    80002c68:	24013403          	ld	s0,576(sp)
    80002c6c:	23813483          	ld	s1,568(sp)
    80002c70:	23013903          	ld	s2,560(sp)
    80002c74:	22813983          	ld	s3,552(sp)
    80002c78:	22013a03          	ld	s4,544(sp)
    80002c7c:	21813a83          	ld	s5,536(sp)
    80002c80:	21013b03          	ld	s6,528(sp)
    80002c84:	20813b83          	ld	s7,520(sp)
    80002c88:	25010113          	addi	sp,sp,592
    80002c8c:	8082                	ret
    return -1;
    80002c8e:	557d                	li	a0,-1
}
    80002c90:	8082                	ret

0000000080002c92 <showfcfs>:

// Debuggiingng용으로 FCFS queue와 MLFQ를 출력
int 
showfcfs(void)
{
    80002c92:	7179                	addi	sp,sp,-48
    80002c94:	f406                	sd	ra,40(sp)
    80002c96:	f022                	sd	s0,32(sp)
    80002c98:	ec26                	sd	s1,24(sp)
    80002c9a:	1800                	addi	s0,sp,48
  acquire(&queuelock);
    80002c9c:	00011497          	auipc	s1,0x11
    80002ca0:	d2c48493          	addi	s1,s1,-724 # 800139c8 <queuelock>
    80002ca4:	8526                	mv	a0,s1
    80002ca6:	f81fd0ef          	jal	80000c26 <acquire>
  printf(">>> FCFS queue [%d procs]: ", fcfs.entry.num);
    80002caa:	2204a583          	lw	a1,544(s1)
    80002cae:	00005517          	auipc	a0,0x5
    80002cb2:	63250513          	addi	a0,a0,1586 # 800082e0 <etext+0x2e0>
    80002cb6:	83ffd0ef          	jal	800004f4 <printf>
  for(int i = 0; i < fcfs.entry.num; i++){
    80002cba:	2204a783          	lw	a5,544(s1)
    80002cbe:	04f05963          	blez	a5,80002d10 <showfcfs+0x7e>
    80002cc2:	e84a                	sd	s2,16(sp)
    80002cc4:	e44e                	sd	s3,8(sp)
    80002cc6:	4481                	li	s1,0
    int index = (fcfs.entry.front + i) % NPROC;
    struct proc *p = fcfs.entry.q[index];
    80002cc8:	00011917          	auipc	s2,0x11
    80002ccc:	d0090913          	addi	s2,s2,-768 # 800139c8 <queuelock>
    if(p) printf("%d ", p->pid);
    80002cd0:	00005997          	auipc	s3,0x5
    80002cd4:	63098993          	addi	s3,s3,1584 # 80008300 <etext+0x300>
    80002cd8:	a031                	j	80002ce4 <showfcfs+0x52>
  for(int i = 0; i < fcfs.entry.num; i++){
    80002cda:	2485                	addiw	s1,s1,1
    80002cdc:	22092783          	lw	a5,544(s2)
    80002ce0:	02f4d663          	bge	s1,a5,80002d0c <showfcfs+0x7a>
    int index = (fcfs.entry.front + i) % NPROC;
    80002ce4:	21892783          	lw	a5,536(s2)
    80002ce8:	9fa5                	addw	a5,a5,s1
    80002cea:	41f7d71b          	sraiw	a4,a5,0x1f
    80002cee:	01a7571b          	srliw	a4,a4,0x1a
    80002cf2:	9fb9                	addw	a5,a5,a4
    80002cf4:	03f7f793          	andi	a5,a5,63
    struct proc *p = fcfs.entry.q[index];
    80002cf8:	9f99                	subw	a5,a5,a4
    80002cfa:	078e                	slli	a5,a5,0x3
    80002cfc:	97ca                	add	a5,a5,s2
    80002cfe:	6f9c                	ld	a5,24(a5)
    if(p) printf("%d ", p->pid);
    80002d00:	dfe9                	beqz	a5,80002cda <showfcfs+0x48>
    80002d02:	5b8c                	lw	a1,48(a5)
    80002d04:	854e                	mv	a0,s3
    80002d06:	feefd0ef          	jal	800004f4 <printf>
    80002d0a:	bfc1                	j	80002cda <showfcfs+0x48>
    80002d0c:	6942                	ld	s2,16(sp)
    80002d0e:	69a2                	ld	s3,8(sp)
  }
  printf("\n");
    80002d10:	00005517          	auipc	a0,0x5
    80002d14:	37050513          	addi	a0,a0,880 # 80008080 <etext+0x80>
    80002d18:	fdcfd0ef          	jal	800004f4 <printf>
  release(&queuelock);
    80002d1c:	00011517          	auipc	a0,0x11
    80002d20:	cac50513          	addi	a0,a0,-852 # 800139c8 <queuelock>
    80002d24:	f9bfd0ef          	jal	80000cbe <release>

  return 0;
}
    80002d28:	4501                	li	a0,0
    80002d2a:	70a2                	ld	ra,40(sp)
    80002d2c:	7402                	ld	s0,32(sp)
    80002d2e:	64e2                	ld	s1,24(sp)
    80002d30:	6145                	addi	sp,sp,48
    80002d32:	8082                	ret

0000000080002d34 <showmlfq>:

// 각 MLFQ queue에 들어있는 process를 level 0부터 출력
int
showmlfq(void)
{
    80002d34:	7159                	addi	sp,sp,-112
    80002d36:	f486                	sd	ra,104(sp)
    80002d38:	f0a2                	sd	s0,96(sp)
    80002d3a:	eca6                	sd	s1,88(sp)
    80002d3c:	e8ca                	sd	s2,80(sp)
    80002d3e:	e4ce                	sd	s3,72(sp)
    80002d40:	e0d2                	sd	s4,64(sp)
    80002d42:	fc56                	sd	s5,56(sp)
    80002d44:	f85a                	sd	s6,48(sp)
    80002d46:	f45e                	sd	s7,40(sp)
    80002d48:	f062                	sd	s8,32(sp)
    80002d4a:	ec66                	sd	s9,24(sp)
    80002d4c:	e86a                	sd	s10,16(sp)
    80002d4e:	e46e                	sd	s11,8(sp)
    80002d50:	1880                	addi	s0,sp,112
  acquire(&queuelock);
    80002d52:	00011517          	auipc	a0,0x11
    80002d56:	c7650513          	addi	a0,a0,-906 # 800139c8 <queuelock>
    80002d5a:	ecdfd0ef          	jal	80000c26 <acquire>
  for(int l = 0; l < 3; l++){
    80002d5e:	00011b17          	auipc	s6,0x11
    80002d62:	e92b0b13          	addi	s6,s6,-366 # 80013bf0 <mlfq>
    80002d66:	4a81                	li	s5,0
    struct queue *q = &mlfq.entry[l];
    printf(">>> MLFQ L%d queue [%d procs]: ", l, q->num);
    80002d68:	00005d17          	auipc	s10,0x5
    80002d6c:	5a0d0d13          	addi	s10,s10,1440 # 80008308 <etext+0x308>
    for(int i = 0; i < q->num; i++){
    80002d70:	4d81                	li	s11,0
      int index = (q->front + i) % NPROC;
      struct proc *p = q->q[index];
    80002d72:	00011a17          	auipc	s4,0x11
    80002d76:	c56a0a13          	addi	s4,s4,-938 # 800139c8 <queuelock>
      if(p) printf("%d ", p->pid);
    80002d7a:	00005b97          	auipc	s7,0x5
    80002d7e:	586b8b93          	addi	s7,s7,1414 # 80008300 <etext+0x300>
    }
    printf("\n");
    80002d82:	00005c97          	auipc	s9,0x5
    80002d86:	2fec8c93          	addi	s9,s9,766 # 80008080 <etext+0x80>
  for(int l = 0; l < 3; l++){
    80002d8a:	4c0d                	li	s8,3
    80002d8c:	a0a1                	j	80002dd4 <showmlfq+0xa0>
    for(int i = 0; i < q->num; i++){
    80002d8e:	2485                	addiw	s1,s1,1
    80002d90:	20892783          	lw	a5,520(s2)
    80002d94:	02f4d863          	bge	s1,a5,80002dc4 <showmlfq+0x90>
      int index = (q->front + i) % NPROC;
    80002d98:	20092783          	lw	a5,512(s2)
    80002d9c:	9fa5                	addw	a5,a5,s1
    80002d9e:	41f7d71b          	sraiw	a4,a5,0x1f
    80002da2:	01a7571b          	srliw	a4,a4,0x1a
    80002da6:	9fb9                	addw	a5,a5,a4
    80002da8:	03f7f793          	andi	a5,a5,63
      struct proc *p = q->q[index];
    80002dac:	9f99                	subw	a5,a5,a4
    80002dae:	97ce                	add	a5,a5,s3
    80002db0:	078e                	slli	a5,a5,0x3
    80002db2:	97d2                	add	a5,a5,s4
    80002db4:	2287b783          	ld	a5,552(a5)
      if(p) printf("%d ", p->pid);
    80002db8:	dbf9                	beqz	a5,80002d8e <showmlfq+0x5a>
    80002dba:	5b8c                	lw	a1,48(a5)
    80002dbc:	855e                	mv	a0,s7
    80002dbe:	f36fd0ef          	jal	800004f4 <printf>
    80002dc2:	b7f1                	j	80002d8e <showmlfq+0x5a>
    printf("\n");
    80002dc4:	8566                	mv	a0,s9
    80002dc6:	f2efd0ef          	jal	800004f4 <printf>
  for(int l = 0; l < 3; l++){
    80002dca:	2a85                	addiw	s5,s5,1
    80002dcc:	210b0b13          	addi	s6,s6,528
    80002dd0:	038a8363          	beq	s5,s8,80002df6 <showmlfq+0xc2>
    printf(">>> MLFQ L%d queue [%d procs]: ", l, q->num);
    80002dd4:	895a                	mv	s2,s6
    80002dd6:	208b2603          	lw	a2,520(s6)
    80002dda:	85d6                	mv	a1,s5
    80002ddc:	856a                	mv	a0,s10
    80002dde:	f16fd0ef          	jal	800004f4 <printf>
    for(int i = 0; i < q->num; i++){
    80002de2:	208b2783          	lw	a5,520(s6)
    80002de6:	fcf05fe3          	blez	a5,80002dc4 <showmlfq+0x90>
    80002dea:	84ee                	mv	s1,s11
      struct proc *p = q->q[index];
    80002dec:	005a9993          	slli	s3,s5,0x5
    80002df0:	99d6                	add	s3,s3,s5
    80002df2:	0986                	slli	s3,s3,0x1
    80002df4:	b755                	j	80002d98 <showmlfq+0x64>
  }
  release(&queuelock);
    80002df6:	00011517          	auipc	a0,0x11
    80002dfa:	bd250513          	addi	a0,a0,-1070 # 800139c8 <queuelock>
    80002dfe:	ec1fd0ef          	jal	80000cbe <release>
  return 0;
    80002e02:	4501                	li	a0,0
    80002e04:	70a6                	ld	ra,104(sp)
    80002e06:	7406                	ld	s0,96(sp)
    80002e08:	64e6                	ld	s1,88(sp)
    80002e0a:	6946                	ld	s2,80(sp)
    80002e0c:	69a6                	ld	s3,72(sp)
    80002e0e:	6a06                	ld	s4,64(sp)
    80002e10:	7ae2                	ld	s5,56(sp)
    80002e12:	7b42                	ld	s6,48(sp)
    80002e14:	7ba2                	ld	s7,40(sp)
    80002e16:	7c02                	ld	s8,32(sp)
    80002e18:	6ce2                	ld	s9,24(sp)
    80002e1a:	6d42                	ld	s10,16(sp)
    80002e1c:	6da2                	ld	s11,8(sp)
    80002e1e:	6165                	addi	sp,sp,112
    80002e20:	8082                	ret

0000000080002e22 <swtch>:
    80002e22:	00153023          	sd	ra,0(a0)
    80002e26:	00253423          	sd	sp,8(a0)
    80002e2a:	e900                	sd	s0,16(a0)
    80002e2c:	ed04                	sd	s1,24(a0)
    80002e2e:	03253023          	sd	s2,32(a0)
    80002e32:	03353423          	sd	s3,40(a0)
    80002e36:	03453823          	sd	s4,48(a0)
    80002e3a:	03553c23          	sd	s5,56(a0)
    80002e3e:	05653023          	sd	s6,64(a0)
    80002e42:	05753423          	sd	s7,72(a0)
    80002e46:	05853823          	sd	s8,80(a0)
    80002e4a:	05953c23          	sd	s9,88(a0)
    80002e4e:	07a53023          	sd	s10,96(a0)
    80002e52:	07b53423          	sd	s11,104(a0)
    80002e56:	0005b083          	ld	ra,0(a1)
    80002e5a:	0085b103          	ld	sp,8(a1)
    80002e5e:	6980                	ld	s0,16(a1)
    80002e60:	6d84                	ld	s1,24(a1)
    80002e62:	0205b903          	ld	s2,32(a1)
    80002e66:	0285b983          	ld	s3,40(a1)
    80002e6a:	0305ba03          	ld	s4,48(a1)
    80002e6e:	0385ba83          	ld	s5,56(a1)
    80002e72:	0405bb03          	ld	s6,64(a1)
    80002e76:	0485bb83          	ld	s7,72(a1)
    80002e7a:	0505bc03          	ld	s8,80(a1)
    80002e7e:	0585bc83          	ld	s9,88(a1)
    80002e82:	0605bd03          	ld	s10,96(a1)
    80002e86:	0685bd83          	ld	s11,104(a1)
    80002e8a:	8082                	ret

0000000080002e8c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002e8c:	1141                	addi	sp,sp,-16
    80002e8e:	e406                	sd	ra,8(sp)
    80002e90:	e022                	sd	s0,0(sp)
    80002e92:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002e94:	00005597          	auipc	a1,0x5
    80002e98:	4c458593          	addi	a1,a1,1220 # 80008358 <etext+0x358>
    80002e9c:	00017517          	auipc	a0,0x17
    80002ea0:	5cc50513          	addi	a0,a0,1484 # 8001a468 <tickslock>
    80002ea4:	d03fd0ef          	jal	80000ba6 <initlock>
}
    80002ea8:	60a2                	ld	ra,8(sp)
    80002eaa:	6402                	ld	s0,0(sp)
    80002eac:	0141                	addi	sp,sp,16
    80002eae:	8082                	ret

0000000080002eb0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002eb0:	1141                	addi	sp,sp,-16
    80002eb2:	e422                	sd	s0,8(sp)
    80002eb4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002eb6:	00003797          	auipc	a5,0x3
    80002eba:	0fa78793          	addi	a5,a5,250 # 80005fb0 <kernelvec>
    80002ebe:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002ec2:	6422                	ld	s0,8(sp)
    80002ec4:	0141                	addi	sp,sp,16
    80002ec6:	8082                	ret

0000000080002ec8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002ec8:	1141                	addi	sp,sp,-16
    80002eca:	e406                	sd	ra,8(sp)
    80002ecc:	e022                	sd	s0,0(sp)
    80002ece:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002ed0:	d57fe0ef          	jal	80001c26 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ed4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002ed8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002eda:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002ede:	00004697          	auipc	a3,0x4
    80002ee2:	12268693          	addi	a3,a3,290 # 80007000 <_trampoline>
    80002ee6:	00004717          	auipc	a4,0x4
    80002eea:	11a70713          	addi	a4,a4,282 # 80007000 <_trampoline>
    80002eee:	8f15                	sub	a4,a4,a3
    80002ef0:	040007b7          	lui	a5,0x4000
    80002ef4:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002ef6:	07b2                	slli	a5,a5,0xc
    80002ef8:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002efa:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002efe:	7538                	ld	a4,104(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002f00:	18002673          	csrr	a2,satp
    80002f04:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002f06:	7530                	ld	a2,104(a0)
    80002f08:	6938                	ld	a4,80(a0)
    80002f0a:	6585                	lui	a1,0x1
    80002f0c:	972e                	add	a4,a4,a1
    80002f0e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002f10:	7538                	ld	a4,104(a0)
    80002f12:	00000617          	auipc	a2,0x0
    80002f16:	33860613          	addi	a2,a2,824 # 8000324a <usertrap>
    80002f1a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002f1c:	7538                	ld	a4,104(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002f1e:	8612                	mv	a2,tp
    80002f20:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f22:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002f26:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002f2a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f2e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002f32:	7538                	ld	a4,104(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002f34:	6f18                	ld	a4,24(a4)
    80002f36:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002f3a:	7128                	ld	a0,96(a0)
    80002f3c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002f3e:	00004717          	auipc	a4,0x4
    80002f42:	15e70713          	addi	a4,a4,350 # 8000709c <userret>
    80002f46:	8f15                	sub	a4,a4,a3
    80002f48:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002f4a:	577d                	li	a4,-1
    80002f4c:	177e                	slli	a4,a4,0x3f
    80002f4e:	8d59                	or	a0,a0,a4
    80002f50:	9782                	jalr	a5
}
    80002f52:	60a2                	ld	ra,8(sp)
    80002f54:	6402                	ld	s0,0(sp)
    80002f56:	0141                	addi	sp,sp,16
    80002f58:	8082                	ret

0000000080002f5a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002f5a:	7179                	addi	sp,sp,-48
    80002f5c:	f406                	sd	ra,40(sp)
    80002f5e:	f022                	sd	s0,32(sp)
    80002f60:	1800                	addi	s0,sp,48
  if(cpuid() == 0){
    80002f62:	c99fe0ef          	jal	80001bfa <cpuid>
    80002f66:	c11d                	beqz	a0,80002f8c <clockintr+0x32>
    }
    if (checkyield == 1) yield(); // yield 가능하면 yield
  }

  // Starvation 방지 - Prioirty boosting
  if (global_tick_count >= 50 && checkmode == 1) {
    80002f68:	00009717          	auipc	a4,0x9
    80002f6c:	91072703          	lw	a4,-1776(a4) # 8000b878 <global_tick_count>
    80002f70:	03100793          	li	a5,49
    80002f74:	04e7db63          	bge	a5,a4,80002fca <clockintr+0x70>
    80002f78:	e84a                	sd	s2,16(sp)
    80002f7a:	00009917          	auipc	s2,0x9
    80002f7e:	90292903          	lw	s2,-1790(s2) # 8000b87c <checkmode>
    80002f82:	4785                	li	a5,1
    80002f84:	1af90d63          	beq	s2,a5,8000313e <clockintr+0x1e4>
    80002f88:	6942                	ld	s2,16(sp)
    80002f8a:	a081                	j	80002fca <clockintr+0x70>
    80002f8c:	ec26                	sd	s1,24(sp)
    80002f8e:	e84a                	sd	s2,16(sp)
    80002f90:	84aa                	mv	s1,a0
    acquire(&tickslock);
    80002f92:	00017917          	auipc	s2,0x17
    80002f96:	4d690913          	addi	s2,s2,1238 # 8001a468 <tickslock>
    80002f9a:	854a                	mv	a0,s2
    80002f9c:	c8bfd0ef          	jal	80000c26 <acquire>
    ticks++;
    80002fa0:	00009517          	auipc	a0,0x9
    80002fa4:	8e850513          	addi	a0,a0,-1816 # 8000b888 <ticks>
    80002fa8:	411c                	lw	a5,0(a0)
    80002faa:	2785                	addiw	a5,a5,1
    80002fac:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002fae:	d0cff0ef          	jal	800024ba <wakeup>
    release(&tickslock);
    80002fb2:	854a                	mv	a0,s2
    80002fb4:	d0bfd0ef          	jal	80000cbe <release>
    if (checkmode == 1) { // MLFQ
    80002fb8:	00009917          	auipc	s2,0x9
    80002fbc:	8c492903          	lw	s2,-1852(s2) # 8000b87c <checkmode>
    80002fc0:	4785                	li	a5,1
    80002fc2:	02f90163          	beq	s2,a5,80002fe4 <clockintr+0x8a>
    80002fc6:	64e2                	ld	s1,24(sp)
    80002fc8:	6942                	ld	s2,16(sp)
  asm volatile("csrr %0, time" : "=r" (x) );
    80002fca:	c01027f3          	rdtime	a5
  
  } 
  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002fce:	000f4737          	lui	a4,0xf4
    80002fd2:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002fd6:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002fd8:	14d79073          	csrw	stimecmp,a5
}
    80002fdc:	70a2                	ld	ra,40(sp)
    80002fde:	7402                	ld	s0,32(sp)
    80002fe0:	6145                	addi	sp,sp,48
    80002fe2:	8082                	ret
    80002fe4:	e44e                	sd	s3,8(sp)
      struct proc *p = myproc();
    80002fe6:	c41fe0ef          	jal	80001c26 <myproc>
    80002fea:	89aa                	mv	s3,a0
      global_tick_count++;
    80002fec:	00009717          	auipc	a4,0x9
    80002ff0:	88c70713          	addi	a4,a4,-1908 # 8000b878 <global_tick_count>
    80002ff4:	431c                	lw	a5,0(a4)
    80002ff6:	2785                	addiw	a5,a5,1
    80002ff8:	c31c                	sw	a5,0(a4)
      if (p && p->state == RUNNING) {
    80002ffa:	12050e63          	beqz	a0,80003136 <clockintr+0x1dc>
    80002ffe:	4d18                	lw	a4,24(a0)
    80003000:	4791                	li	a5,4
    80003002:	00f70663          	beq	a4,a5,8000300e <clockintr+0xb4>
    80003006:	64e2                	ld	s1,24(sp)
    80003008:	6942                	ld	s2,16(sp)
    8000300a:	69a2                	ld	s3,8(sp)
    8000300c:	bfb1                	j	80002f68 <clockintr+0xe>
        acquire(&p->lock);
    8000300e:	c19fd0ef          	jal	80000c26 <acquire>
        p->time_quantum++;
    80003012:	03c9a783          	lw	a5,60(s3)
    80003016:	2785                	addiw	a5,a5,1
    80003018:	0007871b          	sext.w	a4,a5
    8000301c:	02f9ae23          	sw	a5,60(s3)
        if (p->time_quantum >= p->limits) { // 주어진 time quantum을 전부 사용했을 경우
    80003020:	0409a783          	lw	a5,64(s3)
    80003024:	04f74e63          	blt	a4,a5,80003080 <clockintr+0x126>
          p->time_quantum = 0; // time quantum을 초기화
    80003028:	0209ae23          	sw	zero,60(s3)
          if (p->level == 0) { // Demoted to L1
    8000302c:	0349a783          	lw	a5,52(s3)
    80003030:	e39d                	bnez	a5,80003056 <clockintr+0xfc>
            p->level = 1;
    80003032:	4785                	li	a5,1
    80003034:	02f9aa23          	sw	a5,52(s3)
            p->limits = 3;
    80003038:	478d                	li	a5,3
    8000303a:	04f9a023          	sw	a5,64(s3)
          p->state = RUNNABLE;
    8000303e:	478d                	li	a5,3
    80003040:	00f9ac23          	sw	a5,24(s3)
          release(&p->lock);
    80003044:	854e                	mv	a0,s3
    80003046:	c79fd0ef          	jal	80000cbe <release>
    if (checkyield == 1) yield(); // yield 가능하면 yield
    8000304a:	be0ff0ef          	jal	8000242a <yield>
    8000304e:	64e2                	ld	s1,24(sp)
    80003050:	6942                	ld	s2,16(sp)
    80003052:	69a2                	ld	s3,8(sp)
    80003054:	bf11                	j	80002f68 <clockintr+0xe>
          else if (p->level == 1) { // Demoted to L2
    80003056:	4705                	li	a4,1
    80003058:	00e78d63          	beq	a5,a4,80003072 <clockintr+0x118>
          else if (p->level == 2) {
    8000305c:	4709                	li	a4,2
    8000305e:	fee790e3          	bne	a5,a4,8000303e <clockintr+0xe4>
            if (p->priority > 0) p->priority --;
    80003062:	0389a783          	lw	a5,56(s3)
    80003066:	fcf05ce3          	blez	a5,8000303e <clockintr+0xe4>
    8000306a:	37fd                	addiw	a5,a5,-1
    8000306c:	02f9ac23          	sw	a5,56(s3)
    80003070:	b7f9                	j	8000303e <clockintr+0xe4>
            p->level = 2;
    80003072:	4789                	li	a5,2
    80003074:	02f9aa23          	sw	a5,52(s3)
            p->limits = 5;
    80003078:	4795                	li	a5,5
    8000307a:	04f9a023          	sw	a5,64(s3)
    8000307e:	b7c1                	j	8000303e <clockintr+0xe4>
          if (p->level == 1) {
    80003080:	0349a783          	lw	a5,52(s3)
    80003084:	4705                	li	a4,1
    80003086:	00e78963          	beq	a5,a4,80003098 <clockintr+0x13e>
          else if (p->level == 2) { // priority 방식
    8000308a:	4709                	li	a4,2
    8000308c:	02e78163          	beq	a5,a4,800030ae <clockintr+0x154>
    80003090:	64e2                	ld	s1,24(sp)
    80003092:	6942                	ld	s2,16(sp)
    80003094:	69a2                	ld	s3,8(sp)
    80003096:	bdc9                	j	80002f68 <clockintr+0xe>
            release(&p->lock);
    80003098:	854e                	mv	a0,s3
    8000309a:	c25fd0ef          	jal	80000cbe <release>
            if (!mlfq_empty(0)) checkyield = 1; // L0, L1에서 yield 가능
    8000309e:	4501                	li	a0,0
    800030a0:	969fe0ef          	jal	80001a08 <mlfq_empty>
    800030a4:	d15d                	beqz	a0,8000304a <clockintr+0xf0>
    800030a6:	64e2                	ld	s1,24(sp)
    800030a8:	6942                	ld	s2,16(sp)
    800030aa:	69a2                	ld	s3,8(sp)
    800030ac:	bd75                	j	80002f68 <clockintr+0xe>
            if (!mlfq_empty(0) || !mlfq_empty(1)) {
    800030ae:	4501                	li	a0,0
    800030b0:	959fe0ef          	jal	80001a08 <mlfq_empty>
    800030b4:	c511                	beqz	a0,800030c0 <clockintr+0x166>
    800030b6:	4505                	li	a0,1
    800030b8:	951fe0ef          	jal	80001a08 <mlfq_empty>
    800030bc:	10051563          	bnez	a0,800031c6 <clockintr+0x26c>
              release(&p->lock);
    800030c0:	854e                	mv	a0,s3
    800030c2:	bfdfd0ef          	jal	80000cbe <release>
            for (int i = 0; i < mlfq.entry[2].num; i++) {
    800030c6:	00011797          	auipc	a5,0x11
    800030ca:	1527a783          	lw	a5,338(a5) # 80014218 <mlfq+0x628>
    800030ce:	f6f05ee3          	blez	a5,8000304a <clockintr+0xf0>
              if (temp->priority > p->priority && temp->state == RUNNABLE) {
    800030d2:	0389a503          	lw	a0,56(s3)
    800030d6:	00011717          	auipc	a4,0x11
    800030da:	13a72703          	lw	a4,314(a4) # 80014210 <mlfq+0x620>
    800030de:	00e7863b          	addw	a2,a5,a4
              struct proc *temp = mlfq.entry[2].q[(mlfq.entry[2].front + i) % NPROC];
    800030e2:	00011597          	auipc	a1,0x11
    800030e6:	b0e58593          	addi	a1,a1,-1266 # 80013bf0 <mlfq>
              if (temp->priority > p->priority && temp->state == RUNNABLE) {
    800030ea:	480d                	li	a6,3
    800030ec:	a021                	j	800030f4 <clockintr+0x19a>
            for (int i = 0; i < mlfq.entry[2].num; i++) {
    800030ee:	2705                	addiw	a4,a4,1
    800030f0:	02e60a63          	beq	a2,a4,80003124 <clockintr+0x1ca>
              struct proc *temp = mlfq.entry[2].q[(mlfq.entry[2].front + i) % NPROC];
    800030f4:	41f7569b          	sraiw	a3,a4,0x1f
    800030f8:	01a6d69b          	srliw	a3,a3,0x1a
    800030fc:	00e687bb          	addw	a5,a3,a4
    80003100:	03f7f793          	andi	a5,a5,63
    80003104:	9f95                	subw	a5,a5,a3
    80003106:	08478793          	addi	a5,a5,132
    8000310a:	078e                	slli	a5,a5,0x3
    8000310c:	97ae                	add	a5,a5,a1
    8000310e:	639c                	ld	a5,0(a5)
              if (temp->priority > p->priority && temp->state == RUNNABLE) {
    80003110:	5f94                	lw	a3,56(a5)
    80003112:	fcd55ee3          	bge	a0,a3,800030ee <clockintr+0x194>
    80003116:	4f9c                	lw	a5,24(a5)
    80003118:	fd079be3          	bne	a5,a6,800030ee <clockintr+0x194>
                release(&p->lock);
    8000311c:	854e                	mv	a0,s3
    8000311e:	ba1fd0ef          	jal	80000cbe <release>
            if (checkyield == 0) release(&p->lock);
    80003122:	b725                	j	8000304a <clockintr+0xf0>
    80003124:	f20913e3          	bnez	s2,8000304a <clockintr+0xf0>
    80003128:	854e                	mv	a0,s3
    8000312a:	b95fd0ef          	jal	80000cbe <release>
    if (checkyield == 1) yield(); // yield 가능하면 yield
    8000312e:	64e2                	ld	s1,24(sp)
    80003130:	6942                	ld	s2,16(sp)
    80003132:	69a2                	ld	s3,8(sp)
    80003134:	bd15                	j	80002f68 <clockintr+0xe>
    80003136:	64e2                	ld	s1,24(sp)
    80003138:	6942                	ld	s2,16(sp)
    8000313a:	69a2                	ld	s3,8(sp)
    8000313c:	b535                	j	80002f68 <clockintr+0xe>
    8000313e:	ec26                	sd	s1,24(sp)
    80003140:	e44e                	sd	s3,8(sp)
    80003142:	e052                	sd	s4,0(sp)
          temp->priority = 3;
    80003144:	498d                	li	s3,3
          temp->limits = 1;
    80003146:	4a05                	li	s4,1
    80003148:	a021                	j	80003150 <clockintr+0x1f6>
        release(&temp->lock);
    8000314a:	8526                	mv	a0,s1
    8000314c:	b73fd0ef          	jal	80000cbe <release>
      while (!mlfq_empty(level)) {
    80003150:	854a                	mv	a0,s2
    80003152:	8b7fe0ef          	jal	80001a08 <mlfq_empty>
    80003156:	e515                	bnez	a0,80003182 <clockintr+0x228>
        struct proc *temp = mlfq_pop(level);
    80003158:	854a                	mv	a0,s2
    8000315a:	8d5fe0ef          	jal	80001a2e <mlfq_pop>
    8000315e:	84aa                	mv	s1,a0
        acquire(&temp->lock);
    80003160:	ac7fd0ef          	jal	80000c26 <acquire>
        if (temp->state != UNUSED) {
    80003164:	4c9c                	lw	a5,24(s1)
    80003166:	d3f5                	beqz	a5,8000314a <clockintr+0x1f0>
          temp->level = 0;
    80003168:	0204aa23          	sw	zero,52(s1)
          temp->priority = 3;
    8000316c:	0334ac23          	sw	s3,56(s1)
          temp->time_quantum = 0;
    80003170:	0204ae23          	sw	zero,60(s1)
          temp->limits = 1;
    80003174:	0544a023          	sw	s4,64(s1)
          mlfq_push(0, temp); // L0 큐에 다시 push
    80003178:	85a6                	mv	a1,s1
    8000317a:	4501                	li	a0,0
    8000317c:	8d9fe0ef          	jal	80001a54 <mlfq_push>
    80003180:	b7e9                	j	8000314a <clockintr+0x1f0>
    for (int level = 1; level <= 2; level++) {
    80003182:	2905                	addiw	s2,s2,1
    80003184:	fd3916e3          	bne	s2,s3,80003150 <clockintr+0x1f6>
    struct proc *me = myproc();
    80003188:	a9ffe0ef          	jal	80001c26 <myproc>
    8000318c:	84aa                	mv	s1,a0
    if (me != 0) {
    8000318e:	c911                	beqz	a0,800031a2 <clockintr+0x248>
      acquire(&me->lock);
    80003190:	a97fd0ef          	jal	80000c26 <acquire>
      if (me->state == RUNNING) {
    80003194:	4c98                	lw	a4,24(s1)
    80003196:	4791                	li	a5,4
    80003198:	00f70e63          	beq	a4,a5,800031b4 <clockintr+0x25a>
      release(&me->lock);
    8000319c:	8526                	mv	a0,s1
    8000319e:	b21fd0ef          	jal	80000cbe <release>
    global_tick_count = 0;
    800031a2:	00008797          	auipc	a5,0x8
    800031a6:	6c07ab23          	sw	zero,1750(a5) # 8000b878 <global_tick_count>
    800031aa:	64e2                	ld	s1,24(sp)
    800031ac:	6942                	ld	s2,16(sp)
    800031ae:	69a2                	ld	s3,8(sp)
    800031b0:	6a02                	ld	s4,0(sp)
    800031b2:	bd21                	j	80002fca <clockintr+0x70>
        me->level = 0;
    800031b4:	0204aa23          	sw	zero,52(s1)
        me->priority = 3;
    800031b8:	478d                	li	a5,3
    800031ba:	dc9c                	sw	a5,56(s1)
        me->time_quantum = 0;
    800031bc:	0204ae23          	sw	zero,60(s1)
        me->limits = 1;
    800031c0:	4785                	li	a5,1
    800031c2:	c0bc                	sw	a5,64(s1)
    800031c4:	bfe1                	j	8000319c <clockintr+0x242>
            for (int i = 0; i < mlfq.entry[2].num; i++) {
    800031c6:	00011797          	auipc	a5,0x11
    800031ca:	0527a783          	lw	a5,82(a5) # 80014218 <mlfq+0x628>
    int checkyield = 0; //yield 가능 여부
    800031ce:	8926                	mv	s2,s1
            for (int i = 0; i < mlfq.entry[2].num; i++) {
    800031d0:	f0f041e3          	bgtz	a5,800030d2 <clockintr+0x178>
    800031d4:	bf91                	j	80003128 <clockintr+0x1ce>

00000000800031d6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800031d6:	1101                	addi	sp,sp,-32
    800031d8:	ec06                	sd	ra,24(sp)
    800031da:	e822                	sd	s0,16(sp)
    800031dc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800031de:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800031e2:	57fd                	li	a5,-1
    800031e4:	17fe                	slli	a5,a5,0x3f
    800031e6:	07a5                	addi	a5,a5,9
    800031e8:	00f70c63          	beq	a4,a5,80003200 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800031ec:	57fd                	li	a5,-1
    800031ee:	17fe                	slli	a5,a5,0x3f
    800031f0:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800031f2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800031f4:	04f70763          	beq	a4,a5,80003242 <devintr+0x6c>
  }
}
    800031f8:	60e2                	ld	ra,24(sp)
    800031fa:	6442                	ld	s0,16(sp)
    800031fc:	6105                	addi	sp,sp,32
    800031fe:	8082                	ret
    80003200:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80003202:	65b020ef          	jal	8000605c <plic_claim>
    80003206:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80003208:	47a9                	li	a5,10
    8000320a:	00f50963          	beq	a0,a5,8000321c <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    8000320e:	4785                	li	a5,1
    80003210:	00f50963          	beq	a0,a5,80003222 <devintr+0x4c>
    return 1;
    80003214:	4505                	li	a0,1
    } else if(irq){
    80003216:	e889                	bnez	s1,80003228 <devintr+0x52>
    80003218:	64a2                	ld	s1,8(sp)
    8000321a:	bff9                	j	800031f8 <devintr+0x22>
      uartintr();
    8000321c:	81dfd0ef          	jal	80000a38 <uartintr>
    if(irq)
    80003220:	a819                	j	80003236 <devintr+0x60>
      virtio_disk_intr();
    80003222:	300030ef          	jal	80006522 <virtio_disk_intr>
    if(irq)
    80003226:	a801                	j	80003236 <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80003228:	85a6                	mv	a1,s1
    8000322a:	00005517          	auipc	a0,0x5
    8000322e:	13650513          	addi	a0,a0,310 # 80008360 <etext+0x360>
    80003232:	ac2fd0ef          	jal	800004f4 <printf>
      plic_complete(irq);
    80003236:	8526                	mv	a0,s1
    80003238:	645020ef          	jal	8000607c <plic_complete>
    return 1;
    8000323c:	4505                	li	a0,1
    8000323e:	64a2                	ld	s1,8(sp)
    80003240:	bf65                	j	800031f8 <devintr+0x22>
    clockintr();
    80003242:	d19ff0ef          	jal	80002f5a <clockintr>
    return 2;
    80003246:	4509                	li	a0,2
    80003248:	bf45                	j	800031f8 <devintr+0x22>

000000008000324a <usertrap>:
{
    8000324a:	1101                	addi	sp,sp,-32
    8000324c:	ec06                	sd	ra,24(sp)
    8000324e:	e822                	sd	s0,16(sp)
    80003250:	e426                	sd	s1,8(sp)
    80003252:	e04a                	sd	s2,0(sp)
    80003254:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003256:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    8000325a:	1007f793          	andi	a5,a5,256
    8000325e:	ef85                	bnez	a5,80003296 <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003260:	00003797          	auipc	a5,0x3
    80003264:	d5078793          	addi	a5,a5,-688 # 80005fb0 <kernelvec>
    80003268:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    8000326c:	9bbfe0ef          	jal	80001c26 <myproc>
    80003270:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80003272:	753c                	ld	a5,104(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003274:	14102773          	csrr	a4,sepc
    80003278:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000327a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000327e:	47a1                	li	a5,8
    80003280:	02f70163          	beq	a4,a5,800032a2 <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    80003284:	f53ff0ef          	jal	800031d6 <devintr>
    80003288:	892a                	mv	s2,a0
    8000328a:	c939                	beqz	a0,800032e0 <usertrap+0x96>
  if(killed(p))
    8000328c:	8526                	mv	a0,s1
    8000328e:	ca6ff0ef          	jal	80002734 <killed>
    80003292:	c949                	beqz	a0,80003324 <usertrap+0xda>
    80003294:	a069                	j	8000331e <usertrap+0xd4>
    panic("usertrap: not from user mode");
    80003296:	00005517          	auipc	a0,0x5
    8000329a:	0ea50513          	addi	a0,a0,234 # 80008380 <etext+0x380>
    8000329e:	d28fd0ef          	jal	800007c6 <panic>
    if(killed(p))
    800032a2:	c92ff0ef          	jal	80002734 <killed>
    800032a6:	e90d                	bnez	a0,800032d8 <usertrap+0x8e>
    p->trapframe->epc += 4;
    800032a8:	74b8                	ld	a4,104(s1)
    800032aa:	6f1c                	ld	a5,24(a4)
    800032ac:	0791                	addi	a5,a5,4
    800032ae:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800032b0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800032b4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800032b8:	10079073          	csrw	sstatus,a5
    syscall();
    800032bc:	26a000ef          	jal	80003526 <syscall>
  if(killed(p))
    800032c0:	8526                	mv	a0,s1
    800032c2:	c72ff0ef          	jal	80002734 <killed>
    800032c6:	e939                	bnez	a0,8000331c <usertrap+0xd2>
  usertrapret(); 
    800032c8:	c01ff0ef          	jal	80002ec8 <usertrapret>
}
    800032cc:	60e2                	ld	ra,24(sp)
    800032ce:	6442                	ld	s0,16(sp)
    800032d0:	64a2                	ld	s1,8(sp)
    800032d2:	6902                	ld	s2,0(sp)
    800032d4:	6105                	addi	sp,sp,32
    800032d6:	8082                	ret
      exit(-1);
    800032d8:	557d                	li	a0,-1
    800032da:	af0ff0ef          	jal	800025ca <exit>
    800032de:	b7e9                	j	800032a8 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800032e0:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800032e4:	5890                	lw	a2,48(s1)
    800032e6:	00005517          	auipc	a0,0x5
    800032ea:	0ba50513          	addi	a0,a0,186 # 800083a0 <etext+0x3a0>
    800032ee:	a06fd0ef          	jal	800004f4 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800032f2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800032f6:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800032fa:	00005517          	auipc	a0,0x5
    800032fe:	0d650513          	addi	a0,a0,214 # 800083d0 <etext+0x3d0>
    80003302:	9f2fd0ef          	jal	800004f4 <printf>
    setkilled(p);
    80003306:	8526                	mv	a0,s1
    80003308:	c08ff0ef          	jal	80002710 <setkilled>
    printf("Process %d Forced termination\n", p->pid);
    8000330c:	588c                	lw	a1,48(s1)
    8000330e:	00005517          	auipc	a0,0x5
    80003312:	0ea50513          	addi	a0,a0,234 # 800083f8 <etext+0x3f8>
    80003316:	9defd0ef          	jal	800004f4 <printf>
    8000331a:	b75d                	j	800032c0 <usertrap+0x76>
  if(killed(p))
    8000331c:	4901                	li	s2,0
    exit(-1);
    8000331e:	557d                	li	a0,-1
    80003320:	aaaff0ef          	jal	800025ca <exit>
  if(which_dev == 2) {
    80003324:	4789                	li	a5,2
    80003326:	faf911e3          	bne	s2,a5,800032c8 <usertrap+0x7e>
    if (checkmode == 0) yield(); // FCFS면 그냥 yield
    8000332a:	00008797          	auipc	a5,0x8
    8000332e:	5527a783          	lw	a5,1362(a5) # 8000b87c <checkmode>
    80003332:	fbd9                	bnez	a5,800032c8 <usertrap+0x7e>
    80003334:	8f6ff0ef          	jal	8000242a <yield>
    80003338:	bf41                	j	800032c8 <usertrap+0x7e>

000000008000333a <kerneltrap>:
{
    8000333a:	7179                	addi	sp,sp,-48
    8000333c:	f406                	sd	ra,40(sp)
    8000333e:	f022                	sd	s0,32(sp)
    80003340:	ec26                	sd	s1,24(sp)
    80003342:	e84a                	sd	s2,16(sp)
    80003344:	e44e                	sd	s3,8(sp)
    80003346:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003348:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000334c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003350:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80003354:	1004f793          	andi	a5,s1,256
    80003358:	c795                	beqz	a5,80003384 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000335a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000335e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80003360:	eb85                	bnez	a5,80003390 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80003362:	e75ff0ef          	jal	800031d6 <devintr>
    80003366:	c91d                	beqz	a0,8000339c <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0) {
    80003368:	4789                	li	a5,2
    8000336a:	04f50a63          	beq	a0,a5,800033be <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000336e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003372:	10049073          	csrw	sstatus,s1
}
    80003376:	70a2                	ld	ra,40(sp)
    80003378:	7402                	ld	s0,32(sp)
    8000337a:	64e2                	ld	s1,24(sp)
    8000337c:	6942                	ld	s2,16(sp)
    8000337e:	69a2                	ld	s3,8(sp)
    80003380:	6145                	addi	sp,sp,48
    80003382:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80003384:	00005517          	auipc	a0,0x5
    80003388:	09450513          	addi	a0,a0,148 # 80008418 <etext+0x418>
    8000338c:	c3afd0ef          	jal	800007c6 <panic>
    panic("kerneltrap: interrupts enabled");
    80003390:	00005517          	auipc	a0,0x5
    80003394:	0b050513          	addi	a0,a0,176 # 80008440 <etext+0x440>
    80003398:	c2efd0ef          	jal	800007c6 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000339c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800033a0:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800033a4:	85ce                	mv	a1,s3
    800033a6:	00005517          	auipc	a0,0x5
    800033aa:	0ba50513          	addi	a0,a0,186 # 80008460 <etext+0x460>
    800033ae:	946fd0ef          	jal	800004f4 <printf>
    panic("kerneltrap");
    800033b2:	00005517          	auipc	a0,0x5
    800033b6:	0d650513          	addi	a0,a0,214 # 80008488 <etext+0x488>
    800033ba:	c0cfd0ef          	jal	800007c6 <panic>
  if(which_dev == 2 && myproc() != 0) {
    800033be:	869fe0ef          	jal	80001c26 <myproc>
    800033c2:	d555                	beqz	a0,8000336e <kerneltrap+0x34>
    if (checkmode == 0) yield(); // FCFS면 그냥 yield
    800033c4:	00008797          	auipc	a5,0x8
    800033c8:	4b87a783          	lw	a5,1208(a5) # 8000b87c <checkmode>
    800033cc:	f3cd                	bnez	a5,8000336e <kerneltrap+0x34>
    800033ce:	85cff0ef          	jal	8000242a <yield>
    800033d2:	bf71                	j	8000336e <kerneltrap+0x34>

00000000800033d4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800033d4:	1101                	addi	sp,sp,-32
    800033d6:	ec06                	sd	ra,24(sp)
    800033d8:	e822                	sd	s0,16(sp)
    800033da:	e426                	sd	s1,8(sp)
    800033dc:	1000                	addi	s0,sp,32
    800033de:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800033e0:	847fe0ef          	jal	80001c26 <myproc>
  switch (n) {
    800033e4:	4795                	li	a5,5
    800033e6:	0497e163          	bltu	a5,s1,80003428 <argraw+0x54>
    800033ea:	048a                	slli	s1,s1,0x2
    800033ec:	00005717          	auipc	a4,0x5
    800033f0:	45c70713          	addi	a4,a4,1116 # 80008848 <states.0+0x30>
    800033f4:	94ba                	add	s1,s1,a4
    800033f6:	409c                	lw	a5,0(s1)
    800033f8:	97ba                	add	a5,a5,a4
    800033fa:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800033fc:	753c                	ld	a5,104(a0)
    800033fe:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003400:	60e2                	ld	ra,24(sp)
    80003402:	6442                	ld	s0,16(sp)
    80003404:	64a2                	ld	s1,8(sp)
    80003406:	6105                	addi	sp,sp,32
    80003408:	8082                	ret
    return p->trapframe->a1;
    8000340a:	753c                	ld	a5,104(a0)
    8000340c:	7fa8                	ld	a0,120(a5)
    8000340e:	bfcd                	j	80003400 <argraw+0x2c>
    return p->trapframe->a2;
    80003410:	753c                	ld	a5,104(a0)
    80003412:	63c8                	ld	a0,128(a5)
    80003414:	b7f5                	j	80003400 <argraw+0x2c>
    return p->trapframe->a3;
    80003416:	753c                	ld	a5,104(a0)
    80003418:	67c8                	ld	a0,136(a5)
    8000341a:	b7dd                	j	80003400 <argraw+0x2c>
    return p->trapframe->a4;
    8000341c:	753c                	ld	a5,104(a0)
    8000341e:	6bc8                	ld	a0,144(a5)
    80003420:	b7c5                	j	80003400 <argraw+0x2c>
    return p->trapframe->a5;
    80003422:	753c                	ld	a5,104(a0)
    80003424:	6fc8                	ld	a0,152(a5)
    80003426:	bfe9                	j	80003400 <argraw+0x2c>
  panic("argraw");
    80003428:	00005517          	auipc	a0,0x5
    8000342c:	07050513          	addi	a0,a0,112 # 80008498 <etext+0x498>
    80003430:	b96fd0ef          	jal	800007c6 <panic>

0000000080003434 <fetchaddr>:
{
    80003434:	1101                	addi	sp,sp,-32
    80003436:	ec06                	sd	ra,24(sp)
    80003438:	e822                	sd	s0,16(sp)
    8000343a:	e426                	sd	s1,8(sp)
    8000343c:	e04a                	sd	s2,0(sp)
    8000343e:	1000                	addi	s0,sp,32
    80003440:	84aa                	mv	s1,a0
    80003442:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003444:	fe2fe0ef          	jal	80001c26 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003448:	6d3c                	ld	a5,88(a0)
    8000344a:	02f4f663          	bgeu	s1,a5,80003476 <fetchaddr+0x42>
    8000344e:	00848713          	addi	a4,s1,8
    80003452:	02e7e463          	bltu	a5,a4,8000347a <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003456:	46a1                	li	a3,8
    80003458:	8626                	mv	a2,s1
    8000345a:	85ca                	mv	a1,s2
    8000345c:	7128                	ld	a0,96(a0)
    8000345e:	9fcfe0ef          	jal	8000165a <copyin>
    80003462:	00a03533          	snez	a0,a0
    80003466:	40a00533          	neg	a0,a0
}
    8000346a:	60e2                	ld	ra,24(sp)
    8000346c:	6442                	ld	s0,16(sp)
    8000346e:	64a2                	ld	s1,8(sp)
    80003470:	6902                	ld	s2,0(sp)
    80003472:	6105                	addi	sp,sp,32
    80003474:	8082                	ret
    return -1;
    80003476:	557d                	li	a0,-1
    80003478:	bfcd                	j	8000346a <fetchaddr+0x36>
    8000347a:	557d                	li	a0,-1
    8000347c:	b7fd                	j	8000346a <fetchaddr+0x36>

000000008000347e <fetchstr>:
{
    8000347e:	7179                	addi	sp,sp,-48
    80003480:	f406                	sd	ra,40(sp)
    80003482:	f022                	sd	s0,32(sp)
    80003484:	ec26                	sd	s1,24(sp)
    80003486:	e84a                	sd	s2,16(sp)
    80003488:	e44e                	sd	s3,8(sp)
    8000348a:	1800                	addi	s0,sp,48
    8000348c:	892a                	mv	s2,a0
    8000348e:	84ae                	mv	s1,a1
    80003490:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003492:	f94fe0ef          	jal	80001c26 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003496:	86ce                	mv	a3,s3
    80003498:	864a                	mv	a2,s2
    8000349a:	85a6                	mv	a1,s1
    8000349c:	7128                	ld	a0,96(a0)
    8000349e:	a42fe0ef          	jal	800016e0 <copyinstr>
    800034a2:	00054c63          	bltz	a0,800034ba <fetchstr+0x3c>
  return strlen(buf);
    800034a6:	8526                	mv	a0,s1
    800034a8:	9c3fd0ef          	jal	80000e6a <strlen>
}
    800034ac:	70a2                	ld	ra,40(sp)
    800034ae:	7402                	ld	s0,32(sp)
    800034b0:	64e2                	ld	s1,24(sp)
    800034b2:	6942                	ld	s2,16(sp)
    800034b4:	69a2                	ld	s3,8(sp)
    800034b6:	6145                	addi	sp,sp,48
    800034b8:	8082                	ret
    return -1;
    800034ba:	557d                	li	a0,-1
    800034bc:	bfc5                	j	800034ac <fetchstr+0x2e>

00000000800034be <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800034be:	1101                	addi	sp,sp,-32
    800034c0:	ec06                	sd	ra,24(sp)
    800034c2:	e822                	sd	s0,16(sp)
    800034c4:	e426                	sd	s1,8(sp)
    800034c6:	1000                	addi	s0,sp,32
    800034c8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800034ca:	f0bff0ef          	jal	800033d4 <argraw>
    800034ce:	c088                	sw	a0,0(s1)
}
    800034d0:	60e2                	ld	ra,24(sp)
    800034d2:	6442                	ld	s0,16(sp)
    800034d4:	64a2                	ld	s1,8(sp)
    800034d6:	6105                	addi	sp,sp,32
    800034d8:	8082                	ret

00000000800034da <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800034da:	1101                	addi	sp,sp,-32
    800034dc:	ec06                	sd	ra,24(sp)
    800034de:	e822                	sd	s0,16(sp)
    800034e0:	e426                	sd	s1,8(sp)
    800034e2:	1000                	addi	s0,sp,32
    800034e4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800034e6:	eefff0ef          	jal	800033d4 <argraw>
    800034ea:	e088                	sd	a0,0(s1)
}
    800034ec:	60e2                	ld	ra,24(sp)
    800034ee:	6442                	ld	s0,16(sp)
    800034f0:	64a2                	ld	s1,8(sp)
    800034f2:	6105                	addi	sp,sp,32
    800034f4:	8082                	ret

00000000800034f6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800034f6:	7179                	addi	sp,sp,-48
    800034f8:	f406                	sd	ra,40(sp)
    800034fa:	f022                	sd	s0,32(sp)
    800034fc:	ec26                	sd	s1,24(sp)
    800034fe:	e84a                	sd	s2,16(sp)
    80003500:	1800                	addi	s0,sp,48
    80003502:	84ae                	mv	s1,a1
    80003504:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80003506:	fd840593          	addi	a1,s0,-40
    8000350a:	fd1ff0ef          	jal	800034da <argaddr>
  return fetchstr(addr, buf, max);
    8000350e:	864a                	mv	a2,s2
    80003510:	85a6                	mv	a1,s1
    80003512:	fd843503          	ld	a0,-40(s0)
    80003516:	f69ff0ef          	jal	8000347e <fetchstr>
}
    8000351a:	70a2                	ld	ra,40(sp)
    8000351c:	7402                	ld	s0,32(sp)
    8000351e:	64e2                	ld	s1,24(sp)
    80003520:	6942                	ld	s2,16(sp)
    80003522:	6145                	addi	sp,sp,48
    80003524:	8082                	ret

0000000080003526 <syscall>:
[SYS_showmlfq]   sys_showmlfq
};

void
syscall(void)
{
    80003526:	1101                	addi	sp,sp,-32
    80003528:	ec06                	sd	ra,24(sp)
    8000352a:	e822                	sd	s0,16(sp)
    8000352c:	e426                	sd	s1,8(sp)
    8000352e:	e04a                	sd	s2,0(sp)
    80003530:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003532:	ef4fe0ef          	jal	80001c26 <myproc>
    80003536:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003538:	06853903          	ld	s2,104(a0)
    8000353c:	0a893783          	ld	a5,168(s2)
    80003540:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003544:	37fd                	addiw	a5,a5,-1
    80003546:	476d                	li	a4,27
    80003548:	00f76f63          	bltu	a4,a5,80003566 <syscall+0x40>
    8000354c:	00369713          	slli	a4,a3,0x3
    80003550:	00005797          	auipc	a5,0x5
    80003554:	31078793          	addi	a5,a5,784 # 80008860 <syscalls>
    80003558:	97ba                	add	a5,a5,a4
    8000355a:	639c                	ld	a5,0(a5)
    8000355c:	c789                	beqz	a5,80003566 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000355e:	9782                	jalr	a5
    80003560:	06a93823          	sd	a0,112(s2)
    80003564:	a829                	j	8000357e <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003566:	16848613          	addi	a2,s1,360
    8000356a:	588c                	lw	a1,48(s1)
    8000356c:	00005517          	auipc	a0,0x5
    80003570:	f3450513          	addi	a0,a0,-204 # 800084a0 <etext+0x4a0>
    80003574:	f81fc0ef          	jal	800004f4 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003578:	74bc                	ld	a5,104(s1)
    8000357a:	577d                	li	a4,-1
    8000357c:	fbb8                	sd	a4,112(a5)
  }
}
    8000357e:	60e2                	ld	ra,24(sp)
    80003580:	6442                	ld	s0,16(sp)
    80003582:	64a2                	ld	s1,8(sp)
    80003584:	6902                	ld	s2,0(sp)
    80003586:	6105                	addi	sp,sp,32
    80003588:	8082                	ret

000000008000358a <sys_exit>:

extern int global_tick_count;

uint64
sys_exit(void)
{
    8000358a:	1101                	addi	sp,sp,-32
    8000358c:	ec06                	sd	ra,24(sp)
    8000358e:	e822                	sd	s0,16(sp)
    80003590:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80003592:	fec40593          	addi	a1,s0,-20
    80003596:	4501                	li	a0,0
    80003598:	f27ff0ef          	jal	800034be <argint>
  exit(n);
    8000359c:	fec42503          	lw	a0,-20(s0)
    800035a0:	82aff0ef          	jal	800025ca <exit>
  return 0;  // not reached
}
    800035a4:	4501                	li	a0,0
    800035a6:	60e2                	ld	ra,24(sp)
    800035a8:	6442                	ld	s0,16(sp)
    800035aa:	6105                	addi	sp,sp,32
    800035ac:	8082                	ret

00000000800035ae <sys_getpid>:

uint64
sys_getpid(void)
{
    800035ae:	1141                	addi	sp,sp,-16
    800035b0:	e406                	sd	ra,8(sp)
    800035b2:	e022                	sd	s0,0(sp)
    800035b4:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800035b6:	e70fe0ef          	jal	80001c26 <myproc>
}
    800035ba:	5908                	lw	a0,48(a0)
    800035bc:	60a2                	ld	ra,8(sp)
    800035be:	6402                	ld	s0,0(sp)
    800035c0:	0141                	addi	sp,sp,16
    800035c2:	8082                	ret

00000000800035c4 <sys_fork>:

uint64
sys_fork(void)
{
    800035c4:	1141                	addi	sp,sp,-16
    800035c6:	e406                	sd	ra,8(sp)
    800035c8:	e022                	sd	s0,0(sp)
    800035ca:	0800                	addi	s0,sp,16
  return fork();
    800035cc:	9e5fe0ef          	jal	80001fb0 <fork>
}
    800035d0:	60a2                	ld	ra,8(sp)
    800035d2:	6402                	ld	s0,0(sp)
    800035d4:	0141                	addi	sp,sp,16
    800035d6:	8082                	ret

00000000800035d8 <sys_wait>:

uint64
sys_wait(void)
{
    800035d8:	1101                	addi	sp,sp,-32
    800035da:	ec06                	sd	ra,24(sp)
    800035dc:	e822                	sd	s0,16(sp)
    800035de:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800035e0:	fe840593          	addi	a1,s0,-24
    800035e4:	4501                	li	a0,0
    800035e6:	ef5ff0ef          	jal	800034da <argaddr>
  return wait(p);
    800035ea:	fe843503          	ld	a0,-24(s0)
    800035ee:	970ff0ef          	jal	8000275e <wait>
}
    800035f2:	60e2                	ld	ra,24(sp)
    800035f4:	6442                	ld	s0,16(sp)
    800035f6:	6105                	addi	sp,sp,32
    800035f8:	8082                	ret

00000000800035fa <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800035fa:	7179                	addi	sp,sp,-48
    800035fc:	f406                	sd	ra,40(sp)
    800035fe:	f022                	sd	s0,32(sp)
    80003600:	ec26                	sd	s1,24(sp)
    80003602:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80003604:	fdc40593          	addi	a1,s0,-36
    80003608:	4501                	li	a0,0
    8000360a:	eb5ff0ef          	jal	800034be <argint>
  addr = myproc()->sz;
    8000360e:	e18fe0ef          	jal	80001c26 <myproc>
    80003612:	6d24                	ld	s1,88(a0)
  if(growproc(n) < 0)
    80003614:	fdc42503          	lw	a0,-36(s0)
    80003618:	949fe0ef          	jal	80001f60 <growproc>
    8000361c:	00054863          	bltz	a0,8000362c <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80003620:	8526                	mv	a0,s1
    80003622:	70a2                	ld	ra,40(sp)
    80003624:	7402                	ld	s0,32(sp)
    80003626:	64e2                	ld	s1,24(sp)
    80003628:	6145                	addi	sp,sp,48
    8000362a:	8082                	ret
    return -1;
    8000362c:	54fd                	li	s1,-1
    8000362e:	bfcd                	j	80003620 <sys_sbrk+0x26>

0000000080003630 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003630:	7139                	addi	sp,sp,-64
    80003632:	fc06                	sd	ra,56(sp)
    80003634:	f822                	sd	s0,48(sp)
    80003636:	f04a                	sd	s2,32(sp)
    80003638:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000363a:	fcc40593          	addi	a1,s0,-52
    8000363e:	4501                	li	a0,0
    80003640:	e7fff0ef          	jal	800034be <argint>
  if(n < 0)
    80003644:	fcc42783          	lw	a5,-52(s0)
    80003648:	0607c763          	bltz	a5,800036b6 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    8000364c:	00017517          	auipc	a0,0x17
    80003650:	e1c50513          	addi	a0,a0,-484 # 8001a468 <tickslock>
    80003654:	dd2fd0ef          	jal	80000c26 <acquire>
  ticks0 = ticks;
    80003658:	00008917          	auipc	s2,0x8
    8000365c:	23092903          	lw	s2,560(s2) # 8000b888 <ticks>
  while(ticks - ticks0 < n){
    80003660:	fcc42783          	lw	a5,-52(s0)
    80003664:	cf8d                	beqz	a5,8000369e <sys_sleep+0x6e>
    80003666:	f426                	sd	s1,40(sp)
    80003668:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000366a:	00017997          	auipc	s3,0x17
    8000366e:	dfe98993          	addi	s3,s3,-514 # 8001a468 <tickslock>
    80003672:	00008497          	auipc	s1,0x8
    80003676:	21648493          	addi	s1,s1,534 # 8000b888 <ticks>
    if(killed(myproc())){
    8000367a:	dacfe0ef          	jal	80001c26 <myproc>
    8000367e:	8b6ff0ef          	jal	80002734 <killed>
    80003682:	ed0d                	bnez	a0,800036bc <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80003684:	85ce                	mv	a1,s3
    80003686:	8526                	mv	a0,s1
    80003688:	de7fe0ef          	jal	8000246e <sleep>
  while(ticks - ticks0 < n){
    8000368c:	409c                	lw	a5,0(s1)
    8000368e:	412787bb          	subw	a5,a5,s2
    80003692:	fcc42703          	lw	a4,-52(s0)
    80003696:	fee7e2e3          	bltu	a5,a4,8000367a <sys_sleep+0x4a>
    8000369a:	74a2                	ld	s1,40(sp)
    8000369c:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    8000369e:	00017517          	auipc	a0,0x17
    800036a2:	dca50513          	addi	a0,a0,-566 # 8001a468 <tickslock>
    800036a6:	e18fd0ef          	jal	80000cbe <release>
  return 0;
    800036aa:	4501                	li	a0,0
}
    800036ac:	70e2                	ld	ra,56(sp)
    800036ae:	7442                	ld	s0,48(sp)
    800036b0:	7902                	ld	s2,32(sp)
    800036b2:	6121                	addi	sp,sp,64
    800036b4:	8082                	ret
    n = 0;
    800036b6:	fc042623          	sw	zero,-52(s0)
    800036ba:	bf49                	j	8000364c <sys_sleep+0x1c>
      release(&tickslock);
    800036bc:	00017517          	auipc	a0,0x17
    800036c0:	dac50513          	addi	a0,a0,-596 # 8001a468 <tickslock>
    800036c4:	dfafd0ef          	jal	80000cbe <release>
      return -1;
    800036c8:	557d                	li	a0,-1
    800036ca:	74a2                	ld	s1,40(sp)
    800036cc:	69e2                	ld	s3,24(sp)
    800036ce:	bff9                	j	800036ac <sys_sleep+0x7c>

00000000800036d0 <sys_kill>:

uint64
sys_kill(void)
{
    800036d0:	1101                	addi	sp,sp,-32
    800036d2:	ec06                	sd	ra,24(sp)
    800036d4:	e822                	sd	s0,16(sp)
    800036d6:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800036d8:	fec40593          	addi	a1,s0,-20
    800036dc:	4501                	li	a0,0
    800036de:	de1ff0ef          	jal	800034be <argint>
  return kill(pid);
    800036e2:	fec42503          	lw	a0,-20(s0)
    800036e6:	f87fe0ef          	jal	8000266c <kill>
}
    800036ea:	60e2                	ld	ra,24(sp)
    800036ec:	6442                	ld	s0,16(sp)
    800036ee:	6105                	addi	sp,sp,32
    800036f0:	8082                	ret

00000000800036f2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800036f2:	1101                	addi	sp,sp,-32
    800036f4:	ec06                	sd	ra,24(sp)
    800036f6:	e822                	sd	s0,16(sp)
    800036f8:	e426                	sd	s1,8(sp)
    800036fa:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800036fc:	00017517          	auipc	a0,0x17
    80003700:	d6c50513          	addi	a0,a0,-660 # 8001a468 <tickslock>
    80003704:	d22fd0ef          	jal	80000c26 <acquire>
  xticks = ticks;
    80003708:	00008497          	auipc	s1,0x8
    8000370c:	1804a483          	lw	s1,384(s1) # 8000b888 <ticks>
  release(&tickslock);
    80003710:	00017517          	auipc	a0,0x17
    80003714:	d5850513          	addi	a0,a0,-680 # 8001a468 <tickslock>
    80003718:	da6fd0ef          	jal	80000cbe <release>
  return xticks;
}
    8000371c:	02049513          	slli	a0,s1,0x20
    80003720:	9101                	srli	a0,a0,0x20
    80003722:	60e2                	ld	ra,24(sp)
    80003724:	6442                	ld	s0,16(sp)
    80003726:	64a2                	ld	s1,8(sp)
    80003728:	6105                	addi	sp,sp,32
    8000372a:	8082                	ret

000000008000372c <sys_yield>:

uint64
sys_yield(void)
{
    8000372c:	1141                	addi	sp,sp,-16
    8000372e:	e406                	sd	ra,8(sp)
    80003730:	e022                	sd	s0,0(sp)
    80003732:	0800                	addi	s0,sp,16
  yield();
    80003734:	cf7fe0ef          	jal	8000242a <yield>
  return 0;
}
    80003738:	4501                	li	a0,0
    8000373a:	60a2                	ld	ra,8(sp)
    8000373c:	6402                	ld	s0,0(sp)
    8000373e:	0141                	addi	sp,sp,16
    80003740:	8082                	ret

0000000080003742 <sys_getlev>:

uint64
sys_getlev(void) 
{
    80003742:	1141                	addi	sp,sp,-16
    80003744:	e406                	sd	ra,8(sp)
    80003746:	e022                	sd	s0,0(sp)
    80003748:	0800                	addi	s0,sp,16
  return getlev();
    8000374a:	a46ff0ef          	jal	80002990 <getlev>
}
    8000374e:	60a2                	ld	ra,8(sp)
    80003750:	6402                	ld	s0,0(sp)
    80003752:	0141                	addi	sp,sp,16
    80003754:	8082                	ret

0000000080003756 <sys_setpriority>:

uint64
sys_setpriority(void) // sys call argument는 sys call number를 제외하고 없다.
{
    80003756:	1101                	addi	sp,sp,-32
    80003758:	ec06                	sd	ra,24(sp)
    8000375a:	e822                	sd	s0,16(sp)
    8000375c:	1000                	addi	s0,sp,32
  int pid;
  int priority;

  argint(0, &pid); // 직접 가지고 와야한다.
    8000375e:	fec40593          	addi	a1,s0,-20
    80003762:	4501                	li	a0,0
    80003764:	d5bff0ef          	jal	800034be <argint>
  argint(1, &priority);
    80003768:	fe840593          	addi	a1,s0,-24
    8000376c:	4505                	li	a0,1
    8000376e:	d51ff0ef          	jal	800034be <argint>

  return setpriority(pid, priority);
    80003772:	fe842583          	lw	a1,-24(s0)
    80003776:	fec42503          	lw	a0,-20(s0)
    8000377a:	a54ff0ef          	jal	800029ce <setpriority>
}
    8000377e:	60e2                	ld	ra,24(sp)
    80003780:	6442                	ld	s0,16(sp)
    80003782:	6105                	addi	sp,sp,32
    80003784:	8082                	ret

0000000080003786 <sys_mlfqmode>:

uint64
sys_mlfqmode(void) 
{
    80003786:	1141                	addi	sp,sp,-16
    80003788:	e406                	sd	ra,8(sp)
    8000378a:	e022                	sd	s0,0(sp)
    8000378c:	0800                	addi	s0,sp,16
  return mlfqmode();
    8000378e:	aa8ff0ef          	jal	80002a36 <mlfqmode>
}
    80003792:	60a2                	ld	ra,8(sp)
    80003794:	6402                	ld	s0,0(sp)
    80003796:	0141                	addi	sp,sp,16
    80003798:	8082                	ret

000000008000379a <sys_fcfsmode>:

uint64
sys_fcfsmode(void) 
{
    8000379a:	1141                	addi	sp,sp,-16
    8000379c:	e406                	sd	ra,8(sp)
    8000379e:	e022                	sd	s0,0(sp)
    800037a0:	0800                	addi	s0,sp,16
  return fcfsmode();
    800037a2:	b58ff0ef          	jal	80002afa <fcfsmode>
}
    800037a6:	60a2                	ld	ra,8(sp)
    800037a8:	6402                	ld	s0,0(sp)
    800037aa:	0141                	addi	sp,sp,16
    800037ac:	8082                	ret

00000000800037ae <sys_showfcfs>:

uint64
sys_showfcfs(void)
{
    800037ae:	1141                	addi	sp,sp,-16
    800037b0:	e406                	sd	ra,8(sp)
    800037b2:	e022                	sd	s0,0(sp)
    800037b4:	0800                	addi	s0,sp,16
  return showfcfs();
    800037b6:	cdcff0ef          	jal	80002c92 <showfcfs>
}
    800037ba:	60a2                	ld	ra,8(sp)
    800037bc:	6402                	ld	s0,0(sp)
    800037be:	0141                	addi	sp,sp,16
    800037c0:	8082                	ret

00000000800037c2 <sys_showmlfq>:

uint64
sys_showmlfq(void)
{
    800037c2:	1141                	addi	sp,sp,-16
    800037c4:	e406                	sd	ra,8(sp)
    800037c6:	e022                	sd	s0,0(sp)
    800037c8:	0800                	addi	s0,sp,16
  return showmlfq();
    800037ca:	d6aff0ef          	jal	80002d34 <showmlfq>
    800037ce:	60a2                	ld	ra,8(sp)
    800037d0:	6402                	ld	s0,0(sp)
    800037d2:	0141                	addi	sp,sp,16
    800037d4:	8082                	ret

00000000800037d6 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800037d6:	7179                	addi	sp,sp,-48
    800037d8:	f406                	sd	ra,40(sp)
    800037da:	f022                	sd	s0,32(sp)
    800037dc:	ec26                	sd	s1,24(sp)
    800037de:	e84a                	sd	s2,16(sp)
    800037e0:	e44e                	sd	s3,8(sp)
    800037e2:	e052                	sd	s4,0(sp)
    800037e4:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800037e6:	00005597          	auipc	a1,0x5
    800037ea:	cda58593          	addi	a1,a1,-806 # 800084c0 <etext+0x4c0>
    800037ee:	00017517          	auipc	a0,0x17
    800037f2:	c9250513          	addi	a0,a0,-878 # 8001a480 <bcache>
    800037f6:	bb0fd0ef          	jal	80000ba6 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800037fa:	0001f797          	auipc	a5,0x1f
    800037fe:	c8678793          	addi	a5,a5,-890 # 80022480 <bcache+0x8000>
    80003802:	0001f717          	auipc	a4,0x1f
    80003806:	ee670713          	addi	a4,a4,-282 # 800226e8 <bcache+0x8268>
    8000380a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000380e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003812:	00017497          	auipc	s1,0x17
    80003816:	c8648493          	addi	s1,s1,-890 # 8001a498 <bcache+0x18>
    b->next = bcache.head.next;
    8000381a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000381c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000381e:	00005a17          	auipc	s4,0x5
    80003822:	caaa0a13          	addi	s4,s4,-854 # 800084c8 <etext+0x4c8>
    b->next = bcache.head.next;
    80003826:	2b893783          	ld	a5,696(s2)
    8000382a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000382c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003830:	85d2                	mv	a1,s4
    80003832:	01048513          	addi	a0,s1,16
    80003836:	248010ef          	jal	80004a7e <initsleeplock>
    bcache.head.next->prev = b;
    8000383a:	2b893783          	ld	a5,696(s2)
    8000383e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003840:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003844:	45848493          	addi	s1,s1,1112
    80003848:	fd349fe3          	bne	s1,s3,80003826 <binit+0x50>
  }
}
    8000384c:	70a2                	ld	ra,40(sp)
    8000384e:	7402                	ld	s0,32(sp)
    80003850:	64e2                	ld	s1,24(sp)
    80003852:	6942                	ld	s2,16(sp)
    80003854:	69a2                	ld	s3,8(sp)
    80003856:	6a02                	ld	s4,0(sp)
    80003858:	6145                	addi	sp,sp,48
    8000385a:	8082                	ret

000000008000385c <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000385c:	7179                	addi	sp,sp,-48
    8000385e:	f406                	sd	ra,40(sp)
    80003860:	f022                	sd	s0,32(sp)
    80003862:	ec26                	sd	s1,24(sp)
    80003864:	e84a                	sd	s2,16(sp)
    80003866:	e44e                	sd	s3,8(sp)
    80003868:	1800                	addi	s0,sp,48
    8000386a:	892a                	mv	s2,a0
    8000386c:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000386e:	00017517          	auipc	a0,0x17
    80003872:	c1250513          	addi	a0,a0,-1006 # 8001a480 <bcache>
    80003876:	bb0fd0ef          	jal	80000c26 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000387a:	0001f497          	auipc	s1,0x1f
    8000387e:	ebe4b483          	ld	s1,-322(s1) # 80022738 <bcache+0x82b8>
    80003882:	0001f797          	auipc	a5,0x1f
    80003886:	e6678793          	addi	a5,a5,-410 # 800226e8 <bcache+0x8268>
    8000388a:	02f48b63          	beq	s1,a5,800038c0 <bread+0x64>
    8000388e:	873e                	mv	a4,a5
    80003890:	a021                	j	80003898 <bread+0x3c>
    80003892:	68a4                	ld	s1,80(s1)
    80003894:	02e48663          	beq	s1,a4,800038c0 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80003898:	449c                	lw	a5,8(s1)
    8000389a:	ff279ce3          	bne	a5,s2,80003892 <bread+0x36>
    8000389e:	44dc                	lw	a5,12(s1)
    800038a0:	ff3799e3          	bne	a5,s3,80003892 <bread+0x36>
      b->refcnt++;
    800038a4:	40bc                	lw	a5,64(s1)
    800038a6:	2785                	addiw	a5,a5,1
    800038a8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800038aa:	00017517          	auipc	a0,0x17
    800038ae:	bd650513          	addi	a0,a0,-1066 # 8001a480 <bcache>
    800038b2:	c0cfd0ef          	jal	80000cbe <release>
      acquiresleep(&b->lock);
    800038b6:	01048513          	addi	a0,s1,16
    800038ba:	1fa010ef          	jal	80004ab4 <acquiresleep>
      return b;
    800038be:	a889                	j	80003910 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800038c0:	0001f497          	auipc	s1,0x1f
    800038c4:	e704b483          	ld	s1,-400(s1) # 80022730 <bcache+0x82b0>
    800038c8:	0001f797          	auipc	a5,0x1f
    800038cc:	e2078793          	addi	a5,a5,-480 # 800226e8 <bcache+0x8268>
    800038d0:	00f48863          	beq	s1,a5,800038e0 <bread+0x84>
    800038d4:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800038d6:	40bc                	lw	a5,64(s1)
    800038d8:	cb91                	beqz	a5,800038ec <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800038da:	64a4                	ld	s1,72(s1)
    800038dc:	fee49de3          	bne	s1,a4,800038d6 <bread+0x7a>
  panic("bget: no buffers");
    800038e0:	00005517          	auipc	a0,0x5
    800038e4:	bf050513          	addi	a0,a0,-1040 # 800084d0 <etext+0x4d0>
    800038e8:	edffc0ef          	jal	800007c6 <panic>
      b->dev = dev;
    800038ec:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800038f0:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800038f4:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800038f8:	4785                	li	a5,1
    800038fa:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800038fc:	00017517          	auipc	a0,0x17
    80003900:	b8450513          	addi	a0,a0,-1148 # 8001a480 <bcache>
    80003904:	bbafd0ef          	jal	80000cbe <release>
      acquiresleep(&b->lock);
    80003908:	01048513          	addi	a0,s1,16
    8000390c:	1a8010ef          	jal	80004ab4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80003910:	409c                	lw	a5,0(s1)
    80003912:	cb89                	beqz	a5,80003924 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003914:	8526                	mv	a0,s1
    80003916:	70a2                	ld	ra,40(sp)
    80003918:	7402                	ld	s0,32(sp)
    8000391a:	64e2                	ld	s1,24(sp)
    8000391c:	6942                	ld	s2,16(sp)
    8000391e:	69a2                	ld	s3,8(sp)
    80003920:	6145                	addi	sp,sp,48
    80003922:	8082                	ret
    virtio_disk_rw(b, 0);
    80003924:	4581                	li	a1,0
    80003926:	8526                	mv	a0,s1
    80003928:	1e9020ef          	jal	80006310 <virtio_disk_rw>
    b->valid = 1;
    8000392c:	4785                	li	a5,1
    8000392e:	c09c                	sw	a5,0(s1)
  return b;
    80003930:	b7d5                	j	80003914 <bread+0xb8>

0000000080003932 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003932:	1101                	addi	sp,sp,-32
    80003934:	ec06                	sd	ra,24(sp)
    80003936:	e822                	sd	s0,16(sp)
    80003938:	e426                	sd	s1,8(sp)
    8000393a:	1000                	addi	s0,sp,32
    8000393c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000393e:	0541                	addi	a0,a0,16
    80003940:	1f2010ef          	jal	80004b32 <holdingsleep>
    80003944:	c911                	beqz	a0,80003958 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003946:	4585                	li	a1,1
    80003948:	8526                	mv	a0,s1
    8000394a:	1c7020ef          	jal	80006310 <virtio_disk_rw>
}
    8000394e:	60e2                	ld	ra,24(sp)
    80003950:	6442                	ld	s0,16(sp)
    80003952:	64a2                	ld	s1,8(sp)
    80003954:	6105                	addi	sp,sp,32
    80003956:	8082                	ret
    panic("bwrite");
    80003958:	00005517          	auipc	a0,0x5
    8000395c:	b9050513          	addi	a0,a0,-1136 # 800084e8 <etext+0x4e8>
    80003960:	e67fc0ef          	jal	800007c6 <panic>

0000000080003964 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80003964:	1101                	addi	sp,sp,-32
    80003966:	ec06                	sd	ra,24(sp)
    80003968:	e822                	sd	s0,16(sp)
    8000396a:	e426                	sd	s1,8(sp)
    8000396c:	e04a                	sd	s2,0(sp)
    8000396e:	1000                	addi	s0,sp,32
    80003970:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003972:	01050913          	addi	s2,a0,16
    80003976:	854a                	mv	a0,s2
    80003978:	1ba010ef          	jal	80004b32 <holdingsleep>
    8000397c:	c135                	beqz	a0,800039e0 <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    8000397e:	854a                	mv	a0,s2
    80003980:	17a010ef          	jal	80004afa <releasesleep>

  acquire(&bcache.lock);
    80003984:	00017517          	auipc	a0,0x17
    80003988:	afc50513          	addi	a0,a0,-1284 # 8001a480 <bcache>
    8000398c:	a9afd0ef          	jal	80000c26 <acquire>
  b->refcnt--;
    80003990:	40bc                	lw	a5,64(s1)
    80003992:	37fd                	addiw	a5,a5,-1
    80003994:	0007871b          	sext.w	a4,a5
    80003998:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000399a:	e71d                	bnez	a4,800039c8 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000399c:	68b8                	ld	a4,80(s1)
    8000399e:	64bc                	ld	a5,72(s1)
    800039a0:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800039a2:	68b8                	ld	a4,80(s1)
    800039a4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800039a6:	0001f797          	auipc	a5,0x1f
    800039aa:	ada78793          	addi	a5,a5,-1318 # 80022480 <bcache+0x8000>
    800039ae:	2b87b703          	ld	a4,696(a5)
    800039b2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800039b4:	0001f717          	auipc	a4,0x1f
    800039b8:	d3470713          	addi	a4,a4,-716 # 800226e8 <bcache+0x8268>
    800039bc:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800039be:	2b87b703          	ld	a4,696(a5)
    800039c2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800039c4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800039c8:	00017517          	auipc	a0,0x17
    800039cc:	ab850513          	addi	a0,a0,-1352 # 8001a480 <bcache>
    800039d0:	aeefd0ef          	jal	80000cbe <release>
}
    800039d4:	60e2                	ld	ra,24(sp)
    800039d6:	6442                	ld	s0,16(sp)
    800039d8:	64a2                	ld	s1,8(sp)
    800039da:	6902                	ld	s2,0(sp)
    800039dc:	6105                	addi	sp,sp,32
    800039de:	8082                	ret
    panic("brelse");
    800039e0:	00005517          	auipc	a0,0x5
    800039e4:	b1050513          	addi	a0,a0,-1264 # 800084f0 <etext+0x4f0>
    800039e8:	ddffc0ef          	jal	800007c6 <panic>

00000000800039ec <bpin>:

void
bpin(struct buf *b) {
    800039ec:	1101                	addi	sp,sp,-32
    800039ee:	ec06                	sd	ra,24(sp)
    800039f0:	e822                	sd	s0,16(sp)
    800039f2:	e426                	sd	s1,8(sp)
    800039f4:	1000                	addi	s0,sp,32
    800039f6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800039f8:	00017517          	auipc	a0,0x17
    800039fc:	a8850513          	addi	a0,a0,-1400 # 8001a480 <bcache>
    80003a00:	a26fd0ef          	jal	80000c26 <acquire>
  b->refcnt++;
    80003a04:	40bc                	lw	a5,64(s1)
    80003a06:	2785                	addiw	a5,a5,1
    80003a08:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003a0a:	00017517          	auipc	a0,0x17
    80003a0e:	a7650513          	addi	a0,a0,-1418 # 8001a480 <bcache>
    80003a12:	aacfd0ef          	jal	80000cbe <release>
}
    80003a16:	60e2                	ld	ra,24(sp)
    80003a18:	6442                	ld	s0,16(sp)
    80003a1a:	64a2                	ld	s1,8(sp)
    80003a1c:	6105                	addi	sp,sp,32
    80003a1e:	8082                	ret

0000000080003a20 <bunpin>:

void
bunpin(struct buf *b) {
    80003a20:	1101                	addi	sp,sp,-32
    80003a22:	ec06                	sd	ra,24(sp)
    80003a24:	e822                	sd	s0,16(sp)
    80003a26:	e426                	sd	s1,8(sp)
    80003a28:	1000                	addi	s0,sp,32
    80003a2a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003a2c:	00017517          	auipc	a0,0x17
    80003a30:	a5450513          	addi	a0,a0,-1452 # 8001a480 <bcache>
    80003a34:	9f2fd0ef          	jal	80000c26 <acquire>
  b->refcnt--;
    80003a38:	40bc                	lw	a5,64(s1)
    80003a3a:	37fd                	addiw	a5,a5,-1
    80003a3c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003a3e:	00017517          	auipc	a0,0x17
    80003a42:	a4250513          	addi	a0,a0,-1470 # 8001a480 <bcache>
    80003a46:	a78fd0ef          	jal	80000cbe <release>
}
    80003a4a:	60e2                	ld	ra,24(sp)
    80003a4c:	6442                	ld	s0,16(sp)
    80003a4e:	64a2                	ld	s1,8(sp)
    80003a50:	6105                	addi	sp,sp,32
    80003a52:	8082                	ret

0000000080003a54 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003a54:	1101                	addi	sp,sp,-32
    80003a56:	ec06                	sd	ra,24(sp)
    80003a58:	e822                	sd	s0,16(sp)
    80003a5a:	e426                	sd	s1,8(sp)
    80003a5c:	e04a                	sd	s2,0(sp)
    80003a5e:	1000                	addi	s0,sp,32
    80003a60:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80003a62:	00d5d59b          	srliw	a1,a1,0xd
    80003a66:	0001f797          	auipc	a5,0x1f
    80003a6a:	0f67a783          	lw	a5,246(a5) # 80022b5c <sb+0x1c>
    80003a6e:	9dbd                	addw	a1,a1,a5
    80003a70:	dedff0ef          	jal	8000385c <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003a74:	0074f713          	andi	a4,s1,7
    80003a78:	4785                	li	a5,1
    80003a7a:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003a7e:	14ce                	slli	s1,s1,0x33
    80003a80:	90d9                	srli	s1,s1,0x36
    80003a82:	00950733          	add	a4,a0,s1
    80003a86:	05874703          	lbu	a4,88(a4)
    80003a8a:	00e7f6b3          	and	a3,a5,a4
    80003a8e:	c29d                	beqz	a3,80003ab4 <bfree+0x60>
    80003a90:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003a92:	94aa                	add	s1,s1,a0
    80003a94:	fff7c793          	not	a5,a5
    80003a98:	8f7d                	and	a4,a4,a5
    80003a9a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003a9e:	711000ef          	jal	800049ae <log_write>
  brelse(bp);
    80003aa2:	854a                	mv	a0,s2
    80003aa4:	ec1ff0ef          	jal	80003964 <brelse>
}
    80003aa8:	60e2                	ld	ra,24(sp)
    80003aaa:	6442                	ld	s0,16(sp)
    80003aac:	64a2                	ld	s1,8(sp)
    80003aae:	6902                	ld	s2,0(sp)
    80003ab0:	6105                	addi	sp,sp,32
    80003ab2:	8082                	ret
    panic("freeing free block");
    80003ab4:	00005517          	auipc	a0,0x5
    80003ab8:	a4450513          	addi	a0,a0,-1468 # 800084f8 <etext+0x4f8>
    80003abc:	d0bfc0ef          	jal	800007c6 <panic>

0000000080003ac0 <balloc>:
{
    80003ac0:	711d                	addi	sp,sp,-96
    80003ac2:	ec86                	sd	ra,88(sp)
    80003ac4:	e8a2                	sd	s0,80(sp)
    80003ac6:	e4a6                	sd	s1,72(sp)
    80003ac8:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    80003aca:	0001f797          	auipc	a5,0x1f
    80003ace:	07a7a783          	lw	a5,122(a5) # 80022b44 <sb+0x4>
    80003ad2:	0e078f63          	beqz	a5,80003bd0 <balloc+0x110>
    80003ad6:	e0ca                	sd	s2,64(sp)
    80003ad8:	fc4e                	sd	s3,56(sp)
    80003ada:	f852                	sd	s4,48(sp)
    80003adc:	f456                	sd	s5,40(sp)
    80003ade:	f05a                	sd	s6,32(sp)
    80003ae0:	ec5e                	sd	s7,24(sp)
    80003ae2:	e862                	sd	s8,16(sp)
    80003ae4:	e466                	sd	s9,8(sp)
    80003ae6:	8baa                	mv	s7,a0
    80003ae8:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003aea:	0001fb17          	auipc	s6,0x1f
    80003aee:	056b0b13          	addi	s6,s6,86 # 80022b40 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003af2:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003af4:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003af6:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003af8:	6c89                	lui	s9,0x2
    80003afa:	a0b5                	j	80003b66 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003afc:	97ca                	add	a5,a5,s2
    80003afe:	8e55                	or	a2,a2,a3
    80003b00:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003b04:	854a                	mv	a0,s2
    80003b06:	6a9000ef          	jal	800049ae <log_write>
        brelse(bp);
    80003b0a:	854a                	mv	a0,s2
    80003b0c:	e59ff0ef          	jal	80003964 <brelse>
  bp = bread(dev, bno);
    80003b10:	85a6                	mv	a1,s1
    80003b12:	855e                	mv	a0,s7
    80003b14:	d49ff0ef          	jal	8000385c <bread>
    80003b18:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003b1a:	40000613          	li	a2,1024
    80003b1e:	4581                	li	a1,0
    80003b20:	05850513          	addi	a0,a0,88
    80003b24:	9d6fd0ef          	jal	80000cfa <memset>
  log_write(bp);
    80003b28:	854a                	mv	a0,s2
    80003b2a:	685000ef          	jal	800049ae <log_write>
  brelse(bp);
    80003b2e:	854a                	mv	a0,s2
    80003b30:	e35ff0ef          	jal	80003964 <brelse>
}
    80003b34:	6906                	ld	s2,64(sp)
    80003b36:	79e2                	ld	s3,56(sp)
    80003b38:	7a42                	ld	s4,48(sp)
    80003b3a:	7aa2                	ld	s5,40(sp)
    80003b3c:	7b02                	ld	s6,32(sp)
    80003b3e:	6be2                	ld	s7,24(sp)
    80003b40:	6c42                	ld	s8,16(sp)
    80003b42:	6ca2                	ld	s9,8(sp)
}
    80003b44:	8526                	mv	a0,s1
    80003b46:	60e6                	ld	ra,88(sp)
    80003b48:	6446                	ld	s0,80(sp)
    80003b4a:	64a6                	ld	s1,72(sp)
    80003b4c:	6125                	addi	sp,sp,96
    80003b4e:	8082                	ret
    brelse(bp);
    80003b50:	854a                	mv	a0,s2
    80003b52:	e13ff0ef          	jal	80003964 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003b56:	015c87bb          	addw	a5,s9,s5
    80003b5a:	00078a9b          	sext.w	s5,a5
    80003b5e:	004b2703          	lw	a4,4(s6)
    80003b62:	04eaff63          	bgeu	s5,a4,80003bc0 <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80003b66:	41fad79b          	sraiw	a5,s5,0x1f
    80003b6a:	0137d79b          	srliw	a5,a5,0x13
    80003b6e:	015787bb          	addw	a5,a5,s5
    80003b72:	40d7d79b          	sraiw	a5,a5,0xd
    80003b76:	01cb2583          	lw	a1,28(s6)
    80003b7a:	9dbd                	addw	a1,a1,a5
    80003b7c:	855e                	mv	a0,s7
    80003b7e:	cdfff0ef          	jal	8000385c <bread>
    80003b82:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003b84:	004b2503          	lw	a0,4(s6)
    80003b88:	000a849b          	sext.w	s1,s5
    80003b8c:	8762                	mv	a4,s8
    80003b8e:	fca4f1e3          	bgeu	s1,a0,80003b50 <balloc+0x90>
      m = 1 << (bi % 8);
    80003b92:	00777693          	andi	a3,a4,7
    80003b96:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003b9a:	41f7579b          	sraiw	a5,a4,0x1f
    80003b9e:	01d7d79b          	srliw	a5,a5,0x1d
    80003ba2:	9fb9                	addw	a5,a5,a4
    80003ba4:	4037d79b          	sraiw	a5,a5,0x3
    80003ba8:	00f90633          	add	a2,s2,a5
    80003bac:	05864603          	lbu	a2,88(a2)
    80003bb0:	00c6f5b3          	and	a1,a3,a2
    80003bb4:	d5a1                	beqz	a1,80003afc <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003bb6:	2705                	addiw	a4,a4,1
    80003bb8:	2485                	addiw	s1,s1,1
    80003bba:	fd471ae3          	bne	a4,s4,80003b8e <balloc+0xce>
    80003bbe:	bf49                	j	80003b50 <balloc+0x90>
    80003bc0:	6906                	ld	s2,64(sp)
    80003bc2:	79e2                	ld	s3,56(sp)
    80003bc4:	7a42                	ld	s4,48(sp)
    80003bc6:	7aa2                	ld	s5,40(sp)
    80003bc8:	7b02                	ld	s6,32(sp)
    80003bca:	6be2                	ld	s7,24(sp)
    80003bcc:	6c42                	ld	s8,16(sp)
    80003bce:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    80003bd0:	00005517          	auipc	a0,0x5
    80003bd4:	94050513          	addi	a0,a0,-1728 # 80008510 <etext+0x510>
    80003bd8:	91dfc0ef          	jal	800004f4 <printf>
  return 0;
    80003bdc:	4481                	li	s1,0
    80003bde:	b79d                	j	80003b44 <balloc+0x84>

0000000080003be0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003be0:	7179                	addi	sp,sp,-48
    80003be2:	f406                	sd	ra,40(sp)
    80003be4:	f022                	sd	s0,32(sp)
    80003be6:	ec26                	sd	s1,24(sp)
    80003be8:	e84a                	sd	s2,16(sp)
    80003bea:	e44e                	sd	s3,8(sp)
    80003bec:	1800                	addi	s0,sp,48
    80003bee:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003bf0:	47ad                	li	a5,11
    80003bf2:	02b7e663          	bltu	a5,a1,80003c1e <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    80003bf6:	02059793          	slli	a5,a1,0x20
    80003bfa:	01e7d593          	srli	a1,a5,0x1e
    80003bfe:	00b504b3          	add	s1,a0,a1
    80003c02:	0504a903          	lw	s2,80(s1)
    80003c06:	06091a63          	bnez	s2,80003c7a <bmap+0x9a>
      addr = balloc(ip->dev);
    80003c0a:	4108                	lw	a0,0(a0)
    80003c0c:	eb5ff0ef          	jal	80003ac0 <balloc>
    80003c10:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003c14:	06090363          	beqz	s2,80003c7a <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003c18:	0524a823          	sw	s2,80(s1)
    80003c1c:	a8b9                	j	80003c7a <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003c1e:	ff45849b          	addiw	s1,a1,-12
    80003c22:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003c26:	0ff00793          	li	a5,255
    80003c2a:	06e7ee63          	bltu	a5,a4,80003ca6 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003c2e:	08052903          	lw	s2,128(a0)
    80003c32:	00091d63          	bnez	s2,80003c4c <bmap+0x6c>
      addr = balloc(ip->dev);
    80003c36:	4108                	lw	a0,0(a0)
    80003c38:	e89ff0ef          	jal	80003ac0 <balloc>
    80003c3c:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003c40:	02090d63          	beqz	s2,80003c7a <bmap+0x9a>
    80003c44:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003c46:	0929a023          	sw	s2,128(s3)
    80003c4a:	a011                	j	80003c4e <bmap+0x6e>
    80003c4c:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003c4e:	85ca                	mv	a1,s2
    80003c50:	0009a503          	lw	a0,0(s3)
    80003c54:	c09ff0ef          	jal	8000385c <bread>
    80003c58:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003c5a:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003c5e:	02049713          	slli	a4,s1,0x20
    80003c62:	01e75593          	srli	a1,a4,0x1e
    80003c66:	00b784b3          	add	s1,a5,a1
    80003c6a:	0004a903          	lw	s2,0(s1)
    80003c6e:	00090e63          	beqz	s2,80003c8a <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003c72:	8552                	mv	a0,s4
    80003c74:	cf1ff0ef          	jal	80003964 <brelse>
    return addr;
    80003c78:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003c7a:	854a                	mv	a0,s2
    80003c7c:	70a2                	ld	ra,40(sp)
    80003c7e:	7402                	ld	s0,32(sp)
    80003c80:	64e2                	ld	s1,24(sp)
    80003c82:	6942                	ld	s2,16(sp)
    80003c84:	69a2                	ld	s3,8(sp)
    80003c86:	6145                	addi	sp,sp,48
    80003c88:	8082                	ret
      addr = balloc(ip->dev);
    80003c8a:	0009a503          	lw	a0,0(s3)
    80003c8e:	e33ff0ef          	jal	80003ac0 <balloc>
    80003c92:	0005091b          	sext.w	s2,a0
      if(addr){
    80003c96:	fc090ee3          	beqz	s2,80003c72 <bmap+0x92>
        a[bn] = addr;
    80003c9a:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003c9e:	8552                	mv	a0,s4
    80003ca0:	50f000ef          	jal	800049ae <log_write>
    80003ca4:	b7f9                	j	80003c72 <bmap+0x92>
    80003ca6:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003ca8:	00005517          	auipc	a0,0x5
    80003cac:	88050513          	addi	a0,a0,-1920 # 80008528 <etext+0x528>
    80003cb0:	b17fc0ef          	jal	800007c6 <panic>

0000000080003cb4 <iget>:
{
    80003cb4:	7179                	addi	sp,sp,-48
    80003cb6:	f406                	sd	ra,40(sp)
    80003cb8:	f022                	sd	s0,32(sp)
    80003cba:	ec26                	sd	s1,24(sp)
    80003cbc:	e84a                	sd	s2,16(sp)
    80003cbe:	e44e                	sd	s3,8(sp)
    80003cc0:	e052                	sd	s4,0(sp)
    80003cc2:	1800                	addi	s0,sp,48
    80003cc4:	89aa                	mv	s3,a0
    80003cc6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003cc8:	0001f517          	auipc	a0,0x1f
    80003ccc:	e9850513          	addi	a0,a0,-360 # 80022b60 <itable>
    80003cd0:	f57fc0ef          	jal	80000c26 <acquire>
  empty = 0;
    80003cd4:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003cd6:	0001f497          	auipc	s1,0x1f
    80003cda:	ea248493          	addi	s1,s1,-350 # 80022b78 <itable+0x18>
    80003cde:	00021697          	auipc	a3,0x21
    80003ce2:	92a68693          	addi	a3,a3,-1750 # 80024608 <log>
    80003ce6:	a039                	j	80003cf4 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003ce8:	02090963          	beqz	s2,80003d1a <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003cec:	08848493          	addi	s1,s1,136
    80003cf0:	02d48863          	beq	s1,a3,80003d20 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003cf4:	449c                	lw	a5,8(s1)
    80003cf6:	fef059e3          	blez	a5,80003ce8 <iget+0x34>
    80003cfa:	4098                	lw	a4,0(s1)
    80003cfc:	ff3716e3          	bne	a4,s3,80003ce8 <iget+0x34>
    80003d00:	40d8                	lw	a4,4(s1)
    80003d02:	ff4713e3          	bne	a4,s4,80003ce8 <iget+0x34>
      ip->ref++;
    80003d06:	2785                	addiw	a5,a5,1
    80003d08:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003d0a:	0001f517          	auipc	a0,0x1f
    80003d0e:	e5650513          	addi	a0,a0,-426 # 80022b60 <itable>
    80003d12:	fadfc0ef          	jal	80000cbe <release>
      return ip;
    80003d16:	8926                	mv	s2,s1
    80003d18:	a02d                	j	80003d42 <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003d1a:	fbe9                	bnez	a5,80003cec <iget+0x38>
      empty = ip;
    80003d1c:	8926                	mv	s2,s1
    80003d1e:	b7f9                	j	80003cec <iget+0x38>
  if(empty == 0)
    80003d20:	02090a63          	beqz	s2,80003d54 <iget+0xa0>
  ip->dev = dev;
    80003d24:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003d28:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003d2c:	4785                	li	a5,1
    80003d2e:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003d32:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003d36:	0001f517          	auipc	a0,0x1f
    80003d3a:	e2a50513          	addi	a0,a0,-470 # 80022b60 <itable>
    80003d3e:	f81fc0ef          	jal	80000cbe <release>
}
    80003d42:	854a                	mv	a0,s2
    80003d44:	70a2                	ld	ra,40(sp)
    80003d46:	7402                	ld	s0,32(sp)
    80003d48:	64e2                	ld	s1,24(sp)
    80003d4a:	6942                	ld	s2,16(sp)
    80003d4c:	69a2                	ld	s3,8(sp)
    80003d4e:	6a02                	ld	s4,0(sp)
    80003d50:	6145                	addi	sp,sp,48
    80003d52:	8082                	ret
    panic("iget: no inodes");
    80003d54:	00004517          	auipc	a0,0x4
    80003d58:	7ec50513          	addi	a0,a0,2028 # 80008540 <etext+0x540>
    80003d5c:	a6bfc0ef          	jal	800007c6 <panic>

0000000080003d60 <fsinit>:
fsinit(int dev) {
    80003d60:	7179                	addi	sp,sp,-48
    80003d62:	f406                	sd	ra,40(sp)
    80003d64:	f022                	sd	s0,32(sp)
    80003d66:	ec26                	sd	s1,24(sp)
    80003d68:	e84a                	sd	s2,16(sp)
    80003d6a:	e44e                	sd	s3,8(sp)
    80003d6c:	1800                	addi	s0,sp,48
    80003d6e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003d70:	4585                	li	a1,1
    80003d72:	aebff0ef          	jal	8000385c <bread>
    80003d76:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003d78:	0001f997          	auipc	s3,0x1f
    80003d7c:	dc898993          	addi	s3,s3,-568 # 80022b40 <sb>
    80003d80:	02000613          	li	a2,32
    80003d84:	05850593          	addi	a1,a0,88
    80003d88:	854e                	mv	a0,s3
    80003d8a:	fcdfc0ef          	jal	80000d56 <memmove>
  brelse(bp);
    80003d8e:	8526                	mv	a0,s1
    80003d90:	bd5ff0ef          	jal	80003964 <brelse>
  if(sb.magic != FSMAGIC)
    80003d94:	0009a703          	lw	a4,0(s3)
    80003d98:	102037b7          	lui	a5,0x10203
    80003d9c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003da0:	02f71063          	bne	a4,a5,80003dc0 <fsinit+0x60>
  initlog(dev, &sb);
    80003da4:	0001f597          	auipc	a1,0x1f
    80003da8:	d9c58593          	addi	a1,a1,-612 # 80022b40 <sb>
    80003dac:	854a                	mv	a0,s2
    80003dae:	1f9000ef          	jal	800047a6 <initlog>
}
    80003db2:	70a2                	ld	ra,40(sp)
    80003db4:	7402                	ld	s0,32(sp)
    80003db6:	64e2                	ld	s1,24(sp)
    80003db8:	6942                	ld	s2,16(sp)
    80003dba:	69a2                	ld	s3,8(sp)
    80003dbc:	6145                	addi	sp,sp,48
    80003dbe:	8082                	ret
    panic("invalid file system");
    80003dc0:	00004517          	auipc	a0,0x4
    80003dc4:	79050513          	addi	a0,a0,1936 # 80008550 <etext+0x550>
    80003dc8:	9fffc0ef          	jal	800007c6 <panic>

0000000080003dcc <iinit>:
{
    80003dcc:	7179                	addi	sp,sp,-48
    80003dce:	f406                	sd	ra,40(sp)
    80003dd0:	f022                	sd	s0,32(sp)
    80003dd2:	ec26                	sd	s1,24(sp)
    80003dd4:	e84a                	sd	s2,16(sp)
    80003dd6:	e44e                	sd	s3,8(sp)
    80003dd8:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003dda:	00004597          	auipc	a1,0x4
    80003dde:	78e58593          	addi	a1,a1,1934 # 80008568 <etext+0x568>
    80003de2:	0001f517          	auipc	a0,0x1f
    80003de6:	d7e50513          	addi	a0,a0,-642 # 80022b60 <itable>
    80003dea:	dbdfc0ef          	jal	80000ba6 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003dee:	0001f497          	auipc	s1,0x1f
    80003df2:	d9a48493          	addi	s1,s1,-614 # 80022b88 <itable+0x28>
    80003df6:	00021997          	auipc	s3,0x21
    80003dfa:	82298993          	addi	s3,s3,-2014 # 80024618 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003dfe:	00004917          	auipc	s2,0x4
    80003e02:	77290913          	addi	s2,s2,1906 # 80008570 <etext+0x570>
    80003e06:	85ca                	mv	a1,s2
    80003e08:	8526                	mv	a0,s1
    80003e0a:	475000ef          	jal	80004a7e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003e0e:	08848493          	addi	s1,s1,136
    80003e12:	ff349ae3          	bne	s1,s3,80003e06 <iinit+0x3a>
}
    80003e16:	70a2                	ld	ra,40(sp)
    80003e18:	7402                	ld	s0,32(sp)
    80003e1a:	64e2                	ld	s1,24(sp)
    80003e1c:	6942                	ld	s2,16(sp)
    80003e1e:	69a2                	ld	s3,8(sp)
    80003e20:	6145                	addi	sp,sp,48
    80003e22:	8082                	ret

0000000080003e24 <ialloc>:
{
    80003e24:	7139                	addi	sp,sp,-64
    80003e26:	fc06                	sd	ra,56(sp)
    80003e28:	f822                	sd	s0,48(sp)
    80003e2a:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003e2c:	0001f717          	auipc	a4,0x1f
    80003e30:	d2072703          	lw	a4,-736(a4) # 80022b4c <sb+0xc>
    80003e34:	4785                	li	a5,1
    80003e36:	06e7f063          	bgeu	a5,a4,80003e96 <ialloc+0x72>
    80003e3a:	f426                	sd	s1,40(sp)
    80003e3c:	f04a                	sd	s2,32(sp)
    80003e3e:	ec4e                	sd	s3,24(sp)
    80003e40:	e852                	sd	s4,16(sp)
    80003e42:	e456                	sd	s5,8(sp)
    80003e44:	e05a                	sd	s6,0(sp)
    80003e46:	8aaa                	mv	s5,a0
    80003e48:	8b2e                	mv	s6,a1
    80003e4a:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003e4c:	0001fa17          	auipc	s4,0x1f
    80003e50:	cf4a0a13          	addi	s4,s4,-780 # 80022b40 <sb>
    80003e54:	00495593          	srli	a1,s2,0x4
    80003e58:	018a2783          	lw	a5,24(s4)
    80003e5c:	9dbd                	addw	a1,a1,a5
    80003e5e:	8556                	mv	a0,s5
    80003e60:	9fdff0ef          	jal	8000385c <bread>
    80003e64:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003e66:	05850993          	addi	s3,a0,88
    80003e6a:	00f97793          	andi	a5,s2,15
    80003e6e:	079a                	slli	a5,a5,0x6
    80003e70:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003e72:	00099783          	lh	a5,0(s3)
    80003e76:	cb9d                	beqz	a5,80003eac <ialloc+0x88>
    brelse(bp);
    80003e78:	aedff0ef          	jal	80003964 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003e7c:	0905                	addi	s2,s2,1
    80003e7e:	00ca2703          	lw	a4,12(s4)
    80003e82:	0009079b          	sext.w	a5,s2
    80003e86:	fce7e7e3          	bltu	a5,a4,80003e54 <ialloc+0x30>
    80003e8a:	74a2                	ld	s1,40(sp)
    80003e8c:	7902                	ld	s2,32(sp)
    80003e8e:	69e2                	ld	s3,24(sp)
    80003e90:	6a42                	ld	s4,16(sp)
    80003e92:	6aa2                	ld	s5,8(sp)
    80003e94:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003e96:	00004517          	auipc	a0,0x4
    80003e9a:	6e250513          	addi	a0,a0,1762 # 80008578 <etext+0x578>
    80003e9e:	e56fc0ef          	jal	800004f4 <printf>
  return 0;
    80003ea2:	4501                	li	a0,0
}
    80003ea4:	70e2                	ld	ra,56(sp)
    80003ea6:	7442                	ld	s0,48(sp)
    80003ea8:	6121                	addi	sp,sp,64
    80003eaa:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003eac:	04000613          	li	a2,64
    80003eb0:	4581                	li	a1,0
    80003eb2:	854e                	mv	a0,s3
    80003eb4:	e47fc0ef          	jal	80000cfa <memset>
      dip->type = type;
    80003eb8:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003ebc:	8526                	mv	a0,s1
    80003ebe:	2f1000ef          	jal	800049ae <log_write>
      brelse(bp);
    80003ec2:	8526                	mv	a0,s1
    80003ec4:	aa1ff0ef          	jal	80003964 <brelse>
      return iget(dev, inum);
    80003ec8:	0009059b          	sext.w	a1,s2
    80003ecc:	8556                	mv	a0,s5
    80003ece:	de7ff0ef          	jal	80003cb4 <iget>
    80003ed2:	74a2                	ld	s1,40(sp)
    80003ed4:	7902                	ld	s2,32(sp)
    80003ed6:	69e2                	ld	s3,24(sp)
    80003ed8:	6a42                	ld	s4,16(sp)
    80003eda:	6aa2                	ld	s5,8(sp)
    80003edc:	6b02                	ld	s6,0(sp)
    80003ede:	b7d9                	j	80003ea4 <ialloc+0x80>

0000000080003ee0 <iupdate>:
{
    80003ee0:	1101                	addi	sp,sp,-32
    80003ee2:	ec06                	sd	ra,24(sp)
    80003ee4:	e822                	sd	s0,16(sp)
    80003ee6:	e426                	sd	s1,8(sp)
    80003ee8:	e04a                	sd	s2,0(sp)
    80003eea:	1000                	addi	s0,sp,32
    80003eec:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003eee:	415c                	lw	a5,4(a0)
    80003ef0:	0047d79b          	srliw	a5,a5,0x4
    80003ef4:	0001f597          	auipc	a1,0x1f
    80003ef8:	c645a583          	lw	a1,-924(a1) # 80022b58 <sb+0x18>
    80003efc:	9dbd                	addw	a1,a1,a5
    80003efe:	4108                	lw	a0,0(a0)
    80003f00:	95dff0ef          	jal	8000385c <bread>
    80003f04:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003f06:	05850793          	addi	a5,a0,88
    80003f0a:	40d8                	lw	a4,4(s1)
    80003f0c:	8b3d                	andi	a4,a4,15
    80003f0e:	071a                	slli	a4,a4,0x6
    80003f10:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003f12:	04449703          	lh	a4,68(s1)
    80003f16:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003f1a:	04649703          	lh	a4,70(s1)
    80003f1e:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003f22:	04849703          	lh	a4,72(s1)
    80003f26:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003f2a:	04a49703          	lh	a4,74(s1)
    80003f2e:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003f32:	44f8                	lw	a4,76(s1)
    80003f34:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003f36:	03400613          	li	a2,52
    80003f3a:	05048593          	addi	a1,s1,80
    80003f3e:	00c78513          	addi	a0,a5,12
    80003f42:	e15fc0ef          	jal	80000d56 <memmove>
  log_write(bp);
    80003f46:	854a                	mv	a0,s2
    80003f48:	267000ef          	jal	800049ae <log_write>
  brelse(bp);
    80003f4c:	854a                	mv	a0,s2
    80003f4e:	a17ff0ef          	jal	80003964 <brelse>
}
    80003f52:	60e2                	ld	ra,24(sp)
    80003f54:	6442                	ld	s0,16(sp)
    80003f56:	64a2                	ld	s1,8(sp)
    80003f58:	6902                	ld	s2,0(sp)
    80003f5a:	6105                	addi	sp,sp,32
    80003f5c:	8082                	ret

0000000080003f5e <idup>:
{
    80003f5e:	1101                	addi	sp,sp,-32
    80003f60:	ec06                	sd	ra,24(sp)
    80003f62:	e822                	sd	s0,16(sp)
    80003f64:	e426                	sd	s1,8(sp)
    80003f66:	1000                	addi	s0,sp,32
    80003f68:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003f6a:	0001f517          	auipc	a0,0x1f
    80003f6e:	bf650513          	addi	a0,a0,-1034 # 80022b60 <itable>
    80003f72:	cb5fc0ef          	jal	80000c26 <acquire>
  ip->ref++;
    80003f76:	449c                	lw	a5,8(s1)
    80003f78:	2785                	addiw	a5,a5,1
    80003f7a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003f7c:	0001f517          	auipc	a0,0x1f
    80003f80:	be450513          	addi	a0,a0,-1052 # 80022b60 <itable>
    80003f84:	d3bfc0ef          	jal	80000cbe <release>
}
    80003f88:	8526                	mv	a0,s1
    80003f8a:	60e2                	ld	ra,24(sp)
    80003f8c:	6442                	ld	s0,16(sp)
    80003f8e:	64a2                	ld	s1,8(sp)
    80003f90:	6105                	addi	sp,sp,32
    80003f92:	8082                	ret

0000000080003f94 <ilock>:
{
    80003f94:	1101                	addi	sp,sp,-32
    80003f96:	ec06                	sd	ra,24(sp)
    80003f98:	e822                	sd	s0,16(sp)
    80003f9a:	e426                	sd	s1,8(sp)
    80003f9c:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003f9e:	cd19                	beqz	a0,80003fbc <ilock+0x28>
    80003fa0:	84aa                	mv	s1,a0
    80003fa2:	451c                	lw	a5,8(a0)
    80003fa4:	00f05c63          	blez	a5,80003fbc <ilock+0x28>
  acquiresleep(&ip->lock);
    80003fa8:	0541                	addi	a0,a0,16
    80003faa:	30b000ef          	jal	80004ab4 <acquiresleep>
  if(ip->valid == 0){
    80003fae:	40bc                	lw	a5,64(s1)
    80003fb0:	cf89                	beqz	a5,80003fca <ilock+0x36>
}
    80003fb2:	60e2                	ld	ra,24(sp)
    80003fb4:	6442                	ld	s0,16(sp)
    80003fb6:	64a2                	ld	s1,8(sp)
    80003fb8:	6105                	addi	sp,sp,32
    80003fba:	8082                	ret
    80003fbc:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003fbe:	00004517          	auipc	a0,0x4
    80003fc2:	5d250513          	addi	a0,a0,1490 # 80008590 <etext+0x590>
    80003fc6:	801fc0ef          	jal	800007c6 <panic>
    80003fca:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003fcc:	40dc                	lw	a5,4(s1)
    80003fce:	0047d79b          	srliw	a5,a5,0x4
    80003fd2:	0001f597          	auipc	a1,0x1f
    80003fd6:	b865a583          	lw	a1,-1146(a1) # 80022b58 <sb+0x18>
    80003fda:	9dbd                	addw	a1,a1,a5
    80003fdc:	4088                	lw	a0,0(s1)
    80003fde:	87fff0ef          	jal	8000385c <bread>
    80003fe2:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003fe4:	05850593          	addi	a1,a0,88
    80003fe8:	40dc                	lw	a5,4(s1)
    80003fea:	8bbd                	andi	a5,a5,15
    80003fec:	079a                	slli	a5,a5,0x6
    80003fee:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003ff0:	00059783          	lh	a5,0(a1)
    80003ff4:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003ff8:	00259783          	lh	a5,2(a1)
    80003ffc:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80004000:	00459783          	lh	a5,4(a1)
    80004004:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80004008:	00659783          	lh	a5,6(a1)
    8000400c:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80004010:	459c                	lw	a5,8(a1)
    80004012:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004014:	03400613          	li	a2,52
    80004018:	05b1                	addi	a1,a1,12
    8000401a:	05048513          	addi	a0,s1,80
    8000401e:	d39fc0ef          	jal	80000d56 <memmove>
    brelse(bp);
    80004022:	854a                	mv	a0,s2
    80004024:	941ff0ef          	jal	80003964 <brelse>
    ip->valid = 1;
    80004028:	4785                	li	a5,1
    8000402a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000402c:	04449783          	lh	a5,68(s1)
    80004030:	c399                	beqz	a5,80004036 <ilock+0xa2>
    80004032:	6902                	ld	s2,0(sp)
    80004034:	bfbd                	j	80003fb2 <ilock+0x1e>
      panic("ilock: no type");
    80004036:	00004517          	auipc	a0,0x4
    8000403a:	56250513          	addi	a0,a0,1378 # 80008598 <etext+0x598>
    8000403e:	f88fc0ef          	jal	800007c6 <panic>

0000000080004042 <iunlock>:
{
    80004042:	1101                	addi	sp,sp,-32
    80004044:	ec06                	sd	ra,24(sp)
    80004046:	e822                	sd	s0,16(sp)
    80004048:	e426                	sd	s1,8(sp)
    8000404a:	e04a                	sd	s2,0(sp)
    8000404c:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000404e:	c505                	beqz	a0,80004076 <iunlock+0x34>
    80004050:	84aa                	mv	s1,a0
    80004052:	01050913          	addi	s2,a0,16
    80004056:	854a                	mv	a0,s2
    80004058:	2db000ef          	jal	80004b32 <holdingsleep>
    8000405c:	cd09                	beqz	a0,80004076 <iunlock+0x34>
    8000405e:	449c                	lw	a5,8(s1)
    80004060:	00f05b63          	blez	a5,80004076 <iunlock+0x34>
  releasesleep(&ip->lock);
    80004064:	854a                	mv	a0,s2
    80004066:	295000ef          	jal	80004afa <releasesleep>
}
    8000406a:	60e2                	ld	ra,24(sp)
    8000406c:	6442                	ld	s0,16(sp)
    8000406e:	64a2                	ld	s1,8(sp)
    80004070:	6902                	ld	s2,0(sp)
    80004072:	6105                	addi	sp,sp,32
    80004074:	8082                	ret
    panic("iunlock");
    80004076:	00004517          	auipc	a0,0x4
    8000407a:	53250513          	addi	a0,a0,1330 # 800085a8 <etext+0x5a8>
    8000407e:	f48fc0ef          	jal	800007c6 <panic>

0000000080004082 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80004082:	7179                	addi	sp,sp,-48
    80004084:	f406                	sd	ra,40(sp)
    80004086:	f022                	sd	s0,32(sp)
    80004088:	ec26                	sd	s1,24(sp)
    8000408a:	e84a                	sd	s2,16(sp)
    8000408c:	e44e                	sd	s3,8(sp)
    8000408e:	1800                	addi	s0,sp,48
    80004090:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004092:	05050493          	addi	s1,a0,80
    80004096:	08050913          	addi	s2,a0,128
    8000409a:	a021                	j	800040a2 <itrunc+0x20>
    8000409c:	0491                	addi	s1,s1,4
    8000409e:	01248b63          	beq	s1,s2,800040b4 <itrunc+0x32>
    if(ip->addrs[i]){
    800040a2:	408c                	lw	a1,0(s1)
    800040a4:	dde5                	beqz	a1,8000409c <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800040a6:	0009a503          	lw	a0,0(s3)
    800040aa:	9abff0ef          	jal	80003a54 <bfree>
      ip->addrs[i] = 0;
    800040ae:	0004a023          	sw	zero,0(s1)
    800040b2:	b7ed                	j	8000409c <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800040b4:	0809a583          	lw	a1,128(s3)
    800040b8:	ed89                	bnez	a1,800040d2 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800040ba:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800040be:	854e                	mv	a0,s3
    800040c0:	e21ff0ef          	jal	80003ee0 <iupdate>
}
    800040c4:	70a2                	ld	ra,40(sp)
    800040c6:	7402                	ld	s0,32(sp)
    800040c8:	64e2                	ld	s1,24(sp)
    800040ca:	6942                	ld	s2,16(sp)
    800040cc:	69a2                	ld	s3,8(sp)
    800040ce:	6145                	addi	sp,sp,48
    800040d0:	8082                	ret
    800040d2:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800040d4:	0009a503          	lw	a0,0(s3)
    800040d8:	f84ff0ef          	jal	8000385c <bread>
    800040dc:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800040de:	05850493          	addi	s1,a0,88
    800040e2:	45850913          	addi	s2,a0,1112
    800040e6:	a021                	j	800040ee <itrunc+0x6c>
    800040e8:	0491                	addi	s1,s1,4
    800040ea:	01248963          	beq	s1,s2,800040fc <itrunc+0x7a>
      if(a[j])
    800040ee:	408c                	lw	a1,0(s1)
    800040f0:	dde5                	beqz	a1,800040e8 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800040f2:	0009a503          	lw	a0,0(s3)
    800040f6:	95fff0ef          	jal	80003a54 <bfree>
    800040fa:	b7fd                	j	800040e8 <itrunc+0x66>
    brelse(bp);
    800040fc:	8552                	mv	a0,s4
    800040fe:	867ff0ef          	jal	80003964 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004102:	0809a583          	lw	a1,128(s3)
    80004106:	0009a503          	lw	a0,0(s3)
    8000410a:	94bff0ef          	jal	80003a54 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000410e:	0809a023          	sw	zero,128(s3)
    80004112:	6a02                	ld	s4,0(sp)
    80004114:	b75d                	j	800040ba <itrunc+0x38>

0000000080004116 <iput>:
{
    80004116:	1101                	addi	sp,sp,-32
    80004118:	ec06                	sd	ra,24(sp)
    8000411a:	e822                	sd	s0,16(sp)
    8000411c:	e426                	sd	s1,8(sp)
    8000411e:	1000                	addi	s0,sp,32
    80004120:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004122:	0001f517          	auipc	a0,0x1f
    80004126:	a3e50513          	addi	a0,a0,-1474 # 80022b60 <itable>
    8000412a:	afdfc0ef          	jal	80000c26 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000412e:	4498                	lw	a4,8(s1)
    80004130:	4785                	li	a5,1
    80004132:	02f70063          	beq	a4,a5,80004152 <iput+0x3c>
  ip->ref--;
    80004136:	449c                	lw	a5,8(s1)
    80004138:	37fd                	addiw	a5,a5,-1
    8000413a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000413c:	0001f517          	auipc	a0,0x1f
    80004140:	a2450513          	addi	a0,a0,-1500 # 80022b60 <itable>
    80004144:	b7bfc0ef          	jal	80000cbe <release>
}
    80004148:	60e2                	ld	ra,24(sp)
    8000414a:	6442                	ld	s0,16(sp)
    8000414c:	64a2                	ld	s1,8(sp)
    8000414e:	6105                	addi	sp,sp,32
    80004150:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004152:	40bc                	lw	a5,64(s1)
    80004154:	d3ed                	beqz	a5,80004136 <iput+0x20>
    80004156:	04a49783          	lh	a5,74(s1)
    8000415a:	fff1                	bnez	a5,80004136 <iput+0x20>
    8000415c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000415e:	01048913          	addi	s2,s1,16
    80004162:	854a                	mv	a0,s2
    80004164:	151000ef          	jal	80004ab4 <acquiresleep>
    release(&itable.lock);
    80004168:	0001f517          	auipc	a0,0x1f
    8000416c:	9f850513          	addi	a0,a0,-1544 # 80022b60 <itable>
    80004170:	b4ffc0ef          	jal	80000cbe <release>
    itrunc(ip);
    80004174:	8526                	mv	a0,s1
    80004176:	f0dff0ef          	jal	80004082 <itrunc>
    ip->type = 0;
    8000417a:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000417e:	8526                	mv	a0,s1
    80004180:	d61ff0ef          	jal	80003ee0 <iupdate>
    ip->valid = 0;
    80004184:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004188:	854a                	mv	a0,s2
    8000418a:	171000ef          	jal	80004afa <releasesleep>
    acquire(&itable.lock);
    8000418e:	0001f517          	auipc	a0,0x1f
    80004192:	9d250513          	addi	a0,a0,-1582 # 80022b60 <itable>
    80004196:	a91fc0ef          	jal	80000c26 <acquire>
    8000419a:	6902                	ld	s2,0(sp)
    8000419c:	bf69                	j	80004136 <iput+0x20>

000000008000419e <iunlockput>:
{
    8000419e:	1101                	addi	sp,sp,-32
    800041a0:	ec06                	sd	ra,24(sp)
    800041a2:	e822                	sd	s0,16(sp)
    800041a4:	e426                	sd	s1,8(sp)
    800041a6:	1000                	addi	s0,sp,32
    800041a8:	84aa                	mv	s1,a0
  iunlock(ip);
    800041aa:	e99ff0ef          	jal	80004042 <iunlock>
  iput(ip);
    800041ae:	8526                	mv	a0,s1
    800041b0:	f67ff0ef          	jal	80004116 <iput>
}
    800041b4:	60e2                	ld	ra,24(sp)
    800041b6:	6442                	ld	s0,16(sp)
    800041b8:	64a2                	ld	s1,8(sp)
    800041ba:	6105                	addi	sp,sp,32
    800041bc:	8082                	ret

00000000800041be <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800041be:	1141                	addi	sp,sp,-16
    800041c0:	e422                	sd	s0,8(sp)
    800041c2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800041c4:	411c                	lw	a5,0(a0)
    800041c6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800041c8:	415c                	lw	a5,4(a0)
    800041ca:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800041cc:	04451783          	lh	a5,68(a0)
    800041d0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800041d4:	04a51783          	lh	a5,74(a0)
    800041d8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800041dc:	04c56783          	lwu	a5,76(a0)
    800041e0:	e99c                	sd	a5,16(a1)
}
    800041e2:	6422                	ld	s0,8(sp)
    800041e4:	0141                	addi	sp,sp,16
    800041e6:	8082                	ret

00000000800041e8 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800041e8:	457c                	lw	a5,76(a0)
    800041ea:	0ed7eb63          	bltu	a5,a3,800042e0 <readi+0xf8>
{
    800041ee:	7159                	addi	sp,sp,-112
    800041f0:	f486                	sd	ra,104(sp)
    800041f2:	f0a2                	sd	s0,96(sp)
    800041f4:	eca6                	sd	s1,88(sp)
    800041f6:	e0d2                	sd	s4,64(sp)
    800041f8:	fc56                	sd	s5,56(sp)
    800041fa:	f85a                	sd	s6,48(sp)
    800041fc:	f45e                	sd	s7,40(sp)
    800041fe:	1880                	addi	s0,sp,112
    80004200:	8b2a                	mv	s6,a0
    80004202:	8bae                	mv	s7,a1
    80004204:	8a32                	mv	s4,a2
    80004206:	84b6                	mv	s1,a3
    80004208:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000420a:	9f35                	addw	a4,a4,a3
    return 0;
    8000420c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000420e:	0cd76063          	bltu	a4,a3,800042ce <readi+0xe6>
    80004212:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80004214:	00e7f463          	bgeu	a5,a4,8000421c <readi+0x34>
    n = ip->size - off;
    80004218:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000421c:	080a8f63          	beqz	s5,800042ba <readi+0xd2>
    80004220:	e8ca                	sd	s2,80(sp)
    80004222:	f062                	sd	s8,32(sp)
    80004224:	ec66                	sd	s9,24(sp)
    80004226:	e86a                	sd	s10,16(sp)
    80004228:	e46e                	sd	s11,8(sp)
    8000422a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000422c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004230:	5c7d                	li	s8,-1
    80004232:	a80d                	j	80004264 <readi+0x7c>
    80004234:	020d1d93          	slli	s11,s10,0x20
    80004238:	020ddd93          	srli	s11,s11,0x20
    8000423c:	05890613          	addi	a2,s2,88
    80004240:	86ee                	mv	a3,s11
    80004242:	963a                	add	a2,a2,a4
    80004244:	85d2                	mv	a1,s4
    80004246:	855e                	mv	a0,s7
    80004248:	e10fe0ef          	jal	80002858 <either_copyout>
    8000424c:	05850763          	beq	a0,s8,8000429a <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004250:	854a                	mv	a0,s2
    80004252:	f12ff0ef          	jal	80003964 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004256:	013d09bb          	addw	s3,s10,s3
    8000425a:	009d04bb          	addw	s1,s10,s1
    8000425e:	9a6e                	add	s4,s4,s11
    80004260:	0559f763          	bgeu	s3,s5,800042ae <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    80004264:	00a4d59b          	srliw	a1,s1,0xa
    80004268:	855a                	mv	a0,s6
    8000426a:	977ff0ef          	jal	80003be0 <bmap>
    8000426e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004272:	c5b1                	beqz	a1,800042be <readi+0xd6>
    bp = bread(ip->dev, addr);
    80004274:	000b2503          	lw	a0,0(s6)
    80004278:	de4ff0ef          	jal	8000385c <bread>
    8000427c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000427e:	3ff4f713          	andi	a4,s1,1023
    80004282:	40ec87bb          	subw	a5,s9,a4
    80004286:	413a86bb          	subw	a3,s5,s3
    8000428a:	8d3e                	mv	s10,a5
    8000428c:	2781                	sext.w	a5,a5
    8000428e:	0006861b          	sext.w	a2,a3
    80004292:	faf671e3          	bgeu	a2,a5,80004234 <readi+0x4c>
    80004296:	8d36                	mv	s10,a3
    80004298:	bf71                	j	80004234 <readi+0x4c>
      brelse(bp);
    8000429a:	854a                	mv	a0,s2
    8000429c:	ec8ff0ef          	jal	80003964 <brelse>
      tot = -1;
    800042a0:	59fd                	li	s3,-1
      break;
    800042a2:	6946                	ld	s2,80(sp)
    800042a4:	7c02                	ld	s8,32(sp)
    800042a6:	6ce2                	ld	s9,24(sp)
    800042a8:	6d42                	ld	s10,16(sp)
    800042aa:	6da2                	ld	s11,8(sp)
    800042ac:	a831                	j	800042c8 <readi+0xe0>
    800042ae:	6946                	ld	s2,80(sp)
    800042b0:	7c02                	ld	s8,32(sp)
    800042b2:	6ce2                	ld	s9,24(sp)
    800042b4:	6d42                	ld	s10,16(sp)
    800042b6:	6da2                	ld	s11,8(sp)
    800042b8:	a801                	j	800042c8 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800042ba:	89d6                	mv	s3,s5
    800042bc:	a031                	j	800042c8 <readi+0xe0>
    800042be:	6946                	ld	s2,80(sp)
    800042c0:	7c02                	ld	s8,32(sp)
    800042c2:	6ce2                	ld	s9,24(sp)
    800042c4:	6d42                	ld	s10,16(sp)
    800042c6:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800042c8:	0009851b          	sext.w	a0,s3
    800042cc:	69a6                	ld	s3,72(sp)
}
    800042ce:	70a6                	ld	ra,104(sp)
    800042d0:	7406                	ld	s0,96(sp)
    800042d2:	64e6                	ld	s1,88(sp)
    800042d4:	6a06                	ld	s4,64(sp)
    800042d6:	7ae2                	ld	s5,56(sp)
    800042d8:	7b42                	ld	s6,48(sp)
    800042da:	7ba2                	ld	s7,40(sp)
    800042dc:	6165                	addi	sp,sp,112
    800042de:	8082                	ret
    return 0;
    800042e0:	4501                	li	a0,0
}
    800042e2:	8082                	ret

00000000800042e4 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800042e4:	457c                	lw	a5,76(a0)
    800042e6:	10d7e063          	bltu	a5,a3,800043e6 <writei+0x102>
{
    800042ea:	7159                	addi	sp,sp,-112
    800042ec:	f486                	sd	ra,104(sp)
    800042ee:	f0a2                	sd	s0,96(sp)
    800042f0:	e8ca                	sd	s2,80(sp)
    800042f2:	e0d2                	sd	s4,64(sp)
    800042f4:	fc56                	sd	s5,56(sp)
    800042f6:	f85a                	sd	s6,48(sp)
    800042f8:	f45e                	sd	s7,40(sp)
    800042fa:	1880                	addi	s0,sp,112
    800042fc:	8aaa                	mv	s5,a0
    800042fe:	8bae                	mv	s7,a1
    80004300:	8a32                	mv	s4,a2
    80004302:	8936                	mv	s2,a3
    80004304:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004306:	00e687bb          	addw	a5,a3,a4
    8000430a:	0ed7e063          	bltu	a5,a3,800043ea <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000430e:	00043737          	lui	a4,0x43
    80004312:	0cf76e63          	bltu	a4,a5,800043ee <writei+0x10a>
    80004316:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004318:	0a0b0f63          	beqz	s6,800043d6 <writei+0xf2>
    8000431c:	eca6                	sd	s1,88(sp)
    8000431e:	f062                	sd	s8,32(sp)
    80004320:	ec66                	sd	s9,24(sp)
    80004322:	e86a                	sd	s10,16(sp)
    80004324:	e46e                	sd	s11,8(sp)
    80004326:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004328:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000432c:	5c7d                	li	s8,-1
    8000432e:	a825                	j	80004366 <writei+0x82>
    80004330:	020d1d93          	slli	s11,s10,0x20
    80004334:	020ddd93          	srli	s11,s11,0x20
    80004338:	05848513          	addi	a0,s1,88
    8000433c:	86ee                	mv	a3,s11
    8000433e:	8652                	mv	a2,s4
    80004340:	85de                	mv	a1,s7
    80004342:	953a                	add	a0,a0,a4
    80004344:	d5efe0ef          	jal	800028a2 <either_copyin>
    80004348:	05850a63          	beq	a0,s8,8000439c <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000434c:	8526                	mv	a0,s1
    8000434e:	660000ef          	jal	800049ae <log_write>
    brelse(bp);
    80004352:	8526                	mv	a0,s1
    80004354:	e10ff0ef          	jal	80003964 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004358:	013d09bb          	addw	s3,s10,s3
    8000435c:	012d093b          	addw	s2,s10,s2
    80004360:	9a6e                	add	s4,s4,s11
    80004362:	0569f063          	bgeu	s3,s6,800043a2 <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80004366:	00a9559b          	srliw	a1,s2,0xa
    8000436a:	8556                	mv	a0,s5
    8000436c:	875ff0ef          	jal	80003be0 <bmap>
    80004370:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80004374:	c59d                	beqz	a1,800043a2 <writei+0xbe>
    bp = bread(ip->dev, addr);
    80004376:	000aa503          	lw	a0,0(s5)
    8000437a:	ce2ff0ef          	jal	8000385c <bread>
    8000437e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004380:	3ff97713          	andi	a4,s2,1023
    80004384:	40ec87bb          	subw	a5,s9,a4
    80004388:	413b06bb          	subw	a3,s6,s3
    8000438c:	8d3e                	mv	s10,a5
    8000438e:	2781                	sext.w	a5,a5
    80004390:	0006861b          	sext.w	a2,a3
    80004394:	f8f67ee3          	bgeu	a2,a5,80004330 <writei+0x4c>
    80004398:	8d36                	mv	s10,a3
    8000439a:	bf59                	j	80004330 <writei+0x4c>
      brelse(bp);
    8000439c:	8526                	mv	a0,s1
    8000439e:	dc6ff0ef          	jal	80003964 <brelse>
  }

  if(off > ip->size)
    800043a2:	04caa783          	lw	a5,76(s5)
    800043a6:	0327fa63          	bgeu	a5,s2,800043da <writei+0xf6>
    ip->size = off;
    800043aa:	052aa623          	sw	s2,76(s5)
    800043ae:	64e6                	ld	s1,88(sp)
    800043b0:	7c02                	ld	s8,32(sp)
    800043b2:	6ce2                	ld	s9,24(sp)
    800043b4:	6d42                	ld	s10,16(sp)
    800043b6:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800043b8:	8556                	mv	a0,s5
    800043ba:	b27ff0ef          	jal	80003ee0 <iupdate>

  return tot;
    800043be:	0009851b          	sext.w	a0,s3
    800043c2:	69a6                	ld	s3,72(sp)
}
    800043c4:	70a6                	ld	ra,104(sp)
    800043c6:	7406                	ld	s0,96(sp)
    800043c8:	6946                	ld	s2,80(sp)
    800043ca:	6a06                	ld	s4,64(sp)
    800043cc:	7ae2                	ld	s5,56(sp)
    800043ce:	7b42                	ld	s6,48(sp)
    800043d0:	7ba2                	ld	s7,40(sp)
    800043d2:	6165                	addi	sp,sp,112
    800043d4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800043d6:	89da                	mv	s3,s6
    800043d8:	b7c5                	j	800043b8 <writei+0xd4>
    800043da:	64e6                	ld	s1,88(sp)
    800043dc:	7c02                	ld	s8,32(sp)
    800043de:	6ce2                	ld	s9,24(sp)
    800043e0:	6d42                	ld	s10,16(sp)
    800043e2:	6da2                	ld	s11,8(sp)
    800043e4:	bfd1                	j	800043b8 <writei+0xd4>
    return -1;
    800043e6:	557d                	li	a0,-1
}
    800043e8:	8082                	ret
    return -1;
    800043ea:	557d                	li	a0,-1
    800043ec:	bfe1                	j	800043c4 <writei+0xe0>
    return -1;
    800043ee:	557d                	li	a0,-1
    800043f0:	bfd1                	j	800043c4 <writei+0xe0>

00000000800043f2 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800043f2:	1141                	addi	sp,sp,-16
    800043f4:	e406                	sd	ra,8(sp)
    800043f6:	e022                	sd	s0,0(sp)
    800043f8:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800043fa:	4639                	li	a2,14
    800043fc:	9cbfc0ef          	jal	80000dc6 <strncmp>
}
    80004400:	60a2                	ld	ra,8(sp)
    80004402:	6402                	ld	s0,0(sp)
    80004404:	0141                	addi	sp,sp,16
    80004406:	8082                	ret

0000000080004408 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004408:	7139                	addi	sp,sp,-64
    8000440a:	fc06                	sd	ra,56(sp)
    8000440c:	f822                	sd	s0,48(sp)
    8000440e:	f426                	sd	s1,40(sp)
    80004410:	f04a                	sd	s2,32(sp)
    80004412:	ec4e                	sd	s3,24(sp)
    80004414:	e852                	sd	s4,16(sp)
    80004416:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80004418:	04451703          	lh	a4,68(a0)
    8000441c:	4785                	li	a5,1
    8000441e:	00f71a63          	bne	a4,a5,80004432 <dirlookup+0x2a>
    80004422:	892a                	mv	s2,a0
    80004424:	89ae                	mv	s3,a1
    80004426:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004428:	457c                	lw	a5,76(a0)
    8000442a:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000442c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000442e:	e39d                	bnez	a5,80004454 <dirlookup+0x4c>
    80004430:	a095                	j	80004494 <dirlookup+0x8c>
    panic("dirlookup not DIR");
    80004432:	00004517          	auipc	a0,0x4
    80004436:	17e50513          	addi	a0,a0,382 # 800085b0 <etext+0x5b0>
    8000443a:	b8cfc0ef          	jal	800007c6 <panic>
      panic("dirlookup read");
    8000443e:	00004517          	auipc	a0,0x4
    80004442:	18a50513          	addi	a0,a0,394 # 800085c8 <etext+0x5c8>
    80004446:	b80fc0ef          	jal	800007c6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000444a:	24c1                	addiw	s1,s1,16
    8000444c:	04c92783          	lw	a5,76(s2)
    80004450:	04f4f163          	bgeu	s1,a5,80004492 <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004454:	4741                	li	a4,16
    80004456:	86a6                	mv	a3,s1
    80004458:	fc040613          	addi	a2,s0,-64
    8000445c:	4581                	li	a1,0
    8000445e:	854a                	mv	a0,s2
    80004460:	d89ff0ef          	jal	800041e8 <readi>
    80004464:	47c1                	li	a5,16
    80004466:	fcf51ce3          	bne	a0,a5,8000443e <dirlookup+0x36>
    if(de.inum == 0)
    8000446a:	fc045783          	lhu	a5,-64(s0)
    8000446e:	dff1                	beqz	a5,8000444a <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    80004470:	fc240593          	addi	a1,s0,-62
    80004474:	854e                	mv	a0,s3
    80004476:	f7dff0ef          	jal	800043f2 <namecmp>
    8000447a:	f961                	bnez	a0,8000444a <dirlookup+0x42>
      if(poff)
    8000447c:	000a0463          	beqz	s4,80004484 <dirlookup+0x7c>
        *poff = off;
    80004480:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80004484:	fc045583          	lhu	a1,-64(s0)
    80004488:	00092503          	lw	a0,0(s2)
    8000448c:	829ff0ef          	jal	80003cb4 <iget>
    80004490:	a011                	j	80004494 <dirlookup+0x8c>
  return 0;
    80004492:	4501                	li	a0,0
}
    80004494:	70e2                	ld	ra,56(sp)
    80004496:	7442                	ld	s0,48(sp)
    80004498:	74a2                	ld	s1,40(sp)
    8000449a:	7902                	ld	s2,32(sp)
    8000449c:	69e2                	ld	s3,24(sp)
    8000449e:	6a42                	ld	s4,16(sp)
    800044a0:	6121                	addi	sp,sp,64
    800044a2:	8082                	ret

00000000800044a4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800044a4:	711d                	addi	sp,sp,-96
    800044a6:	ec86                	sd	ra,88(sp)
    800044a8:	e8a2                	sd	s0,80(sp)
    800044aa:	e4a6                	sd	s1,72(sp)
    800044ac:	e0ca                	sd	s2,64(sp)
    800044ae:	fc4e                	sd	s3,56(sp)
    800044b0:	f852                	sd	s4,48(sp)
    800044b2:	f456                	sd	s5,40(sp)
    800044b4:	f05a                	sd	s6,32(sp)
    800044b6:	ec5e                	sd	s7,24(sp)
    800044b8:	e862                	sd	s8,16(sp)
    800044ba:	e466                	sd	s9,8(sp)
    800044bc:	1080                	addi	s0,sp,96
    800044be:	84aa                	mv	s1,a0
    800044c0:	8b2e                	mv	s6,a1
    800044c2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800044c4:	00054703          	lbu	a4,0(a0)
    800044c8:	02f00793          	li	a5,47
    800044cc:	00f70e63          	beq	a4,a5,800044e8 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800044d0:	f56fd0ef          	jal	80001c26 <myproc>
    800044d4:	16053503          	ld	a0,352(a0)
    800044d8:	a87ff0ef          	jal	80003f5e <idup>
    800044dc:	8a2a                	mv	s4,a0
  while(*path == '/')
    800044de:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800044e2:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800044e4:	4b85                	li	s7,1
    800044e6:	a871                	j	80004582 <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    800044e8:	4585                	li	a1,1
    800044ea:	4505                	li	a0,1
    800044ec:	fc8ff0ef          	jal	80003cb4 <iget>
    800044f0:	8a2a                	mv	s4,a0
    800044f2:	b7f5                	j	800044de <namex+0x3a>
      iunlockput(ip);
    800044f4:	8552                	mv	a0,s4
    800044f6:	ca9ff0ef          	jal	8000419e <iunlockput>
      return 0;
    800044fa:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800044fc:	8552                	mv	a0,s4
    800044fe:	60e6                	ld	ra,88(sp)
    80004500:	6446                	ld	s0,80(sp)
    80004502:	64a6                	ld	s1,72(sp)
    80004504:	6906                	ld	s2,64(sp)
    80004506:	79e2                	ld	s3,56(sp)
    80004508:	7a42                	ld	s4,48(sp)
    8000450a:	7aa2                	ld	s5,40(sp)
    8000450c:	7b02                	ld	s6,32(sp)
    8000450e:	6be2                	ld	s7,24(sp)
    80004510:	6c42                	ld	s8,16(sp)
    80004512:	6ca2                	ld	s9,8(sp)
    80004514:	6125                	addi	sp,sp,96
    80004516:	8082                	ret
      iunlock(ip);
    80004518:	8552                	mv	a0,s4
    8000451a:	b29ff0ef          	jal	80004042 <iunlock>
      return ip;
    8000451e:	bff9                	j	800044fc <namex+0x58>
      iunlockput(ip);
    80004520:	8552                	mv	a0,s4
    80004522:	c7dff0ef          	jal	8000419e <iunlockput>
      return 0;
    80004526:	8a4e                	mv	s4,s3
    80004528:	bfd1                	j	800044fc <namex+0x58>
  len = path - s;
    8000452a:	40998633          	sub	a2,s3,s1
    8000452e:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    80004532:	099c5063          	bge	s8,s9,800045b2 <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80004536:	4639                	li	a2,14
    80004538:	85a6                	mv	a1,s1
    8000453a:	8556                	mv	a0,s5
    8000453c:	81bfc0ef          	jal	80000d56 <memmove>
    80004540:	84ce                	mv	s1,s3
  while(*path == '/')
    80004542:	0004c783          	lbu	a5,0(s1)
    80004546:	01279763          	bne	a5,s2,80004554 <namex+0xb0>
    path++;
    8000454a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000454c:	0004c783          	lbu	a5,0(s1)
    80004550:	ff278de3          	beq	a5,s2,8000454a <namex+0xa6>
    ilock(ip);
    80004554:	8552                	mv	a0,s4
    80004556:	a3fff0ef          	jal	80003f94 <ilock>
    if(ip->type != T_DIR){
    8000455a:	044a1783          	lh	a5,68(s4)
    8000455e:	f9779be3          	bne	a5,s7,800044f4 <namex+0x50>
    if(nameiparent && *path == '\0'){
    80004562:	000b0563          	beqz	s6,8000456c <namex+0xc8>
    80004566:	0004c783          	lbu	a5,0(s1)
    8000456a:	d7dd                	beqz	a5,80004518 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000456c:	4601                	li	a2,0
    8000456e:	85d6                	mv	a1,s5
    80004570:	8552                	mv	a0,s4
    80004572:	e97ff0ef          	jal	80004408 <dirlookup>
    80004576:	89aa                	mv	s3,a0
    80004578:	d545                	beqz	a0,80004520 <namex+0x7c>
    iunlockput(ip);
    8000457a:	8552                	mv	a0,s4
    8000457c:	c23ff0ef          	jal	8000419e <iunlockput>
    ip = next;
    80004580:	8a4e                	mv	s4,s3
  while(*path == '/')
    80004582:	0004c783          	lbu	a5,0(s1)
    80004586:	01279763          	bne	a5,s2,80004594 <namex+0xf0>
    path++;
    8000458a:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000458c:	0004c783          	lbu	a5,0(s1)
    80004590:	ff278de3          	beq	a5,s2,8000458a <namex+0xe6>
  if(*path == 0)
    80004594:	cb8d                	beqz	a5,800045c6 <namex+0x122>
  while(*path != '/' && *path != 0)
    80004596:	0004c783          	lbu	a5,0(s1)
    8000459a:	89a6                	mv	s3,s1
  len = path - s;
    8000459c:	4c81                	li	s9,0
    8000459e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800045a0:	01278963          	beq	a5,s2,800045b2 <namex+0x10e>
    800045a4:	d3d9                	beqz	a5,8000452a <namex+0x86>
    path++;
    800045a6:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    800045a8:	0009c783          	lbu	a5,0(s3)
    800045ac:	ff279ce3          	bne	a5,s2,800045a4 <namex+0x100>
    800045b0:	bfad                	j	8000452a <namex+0x86>
    memmove(name, s, len);
    800045b2:	2601                	sext.w	a2,a2
    800045b4:	85a6                	mv	a1,s1
    800045b6:	8556                	mv	a0,s5
    800045b8:	f9efc0ef          	jal	80000d56 <memmove>
    name[len] = 0;
    800045bc:	9cd6                	add	s9,s9,s5
    800045be:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    800045c2:	84ce                	mv	s1,s3
    800045c4:	bfbd                	j	80004542 <namex+0x9e>
  if(nameiparent){
    800045c6:	f20b0be3          	beqz	s6,800044fc <namex+0x58>
    iput(ip);
    800045ca:	8552                	mv	a0,s4
    800045cc:	b4bff0ef          	jal	80004116 <iput>
    return 0;
    800045d0:	4a01                	li	s4,0
    800045d2:	b72d                	j	800044fc <namex+0x58>

00000000800045d4 <dirlink>:
{
    800045d4:	7139                	addi	sp,sp,-64
    800045d6:	fc06                	sd	ra,56(sp)
    800045d8:	f822                	sd	s0,48(sp)
    800045da:	f04a                	sd	s2,32(sp)
    800045dc:	ec4e                	sd	s3,24(sp)
    800045de:	e852                	sd	s4,16(sp)
    800045e0:	0080                	addi	s0,sp,64
    800045e2:	892a                	mv	s2,a0
    800045e4:	8a2e                	mv	s4,a1
    800045e6:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800045e8:	4601                	li	a2,0
    800045ea:	e1fff0ef          	jal	80004408 <dirlookup>
    800045ee:	e535                	bnez	a0,8000465a <dirlink+0x86>
    800045f0:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800045f2:	04c92483          	lw	s1,76(s2)
    800045f6:	c48d                	beqz	s1,80004620 <dirlink+0x4c>
    800045f8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045fa:	4741                	li	a4,16
    800045fc:	86a6                	mv	a3,s1
    800045fe:	fc040613          	addi	a2,s0,-64
    80004602:	4581                	li	a1,0
    80004604:	854a                	mv	a0,s2
    80004606:	be3ff0ef          	jal	800041e8 <readi>
    8000460a:	47c1                	li	a5,16
    8000460c:	04f51b63          	bne	a0,a5,80004662 <dirlink+0x8e>
    if(de.inum == 0)
    80004610:	fc045783          	lhu	a5,-64(s0)
    80004614:	c791                	beqz	a5,80004620 <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004616:	24c1                	addiw	s1,s1,16
    80004618:	04c92783          	lw	a5,76(s2)
    8000461c:	fcf4efe3          	bltu	s1,a5,800045fa <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    80004620:	4639                	li	a2,14
    80004622:	85d2                	mv	a1,s4
    80004624:	fc240513          	addi	a0,s0,-62
    80004628:	fd4fc0ef          	jal	80000dfc <strncpy>
  de.inum = inum;
    8000462c:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004630:	4741                	li	a4,16
    80004632:	86a6                	mv	a3,s1
    80004634:	fc040613          	addi	a2,s0,-64
    80004638:	4581                	li	a1,0
    8000463a:	854a                	mv	a0,s2
    8000463c:	ca9ff0ef          	jal	800042e4 <writei>
    80004640:	1541                	addi	a0,a0,-16
    80004642:	00a03533          	snez	a0,a0
    80004646:	40a00533          	neg	a0,a0
    8000464a:	74a2                	ld	s1,40(sp)
}
    8000464c:	70e2                	ld	ra,56(sp)
    8000464e:	7442                	ld	s0,48(sp)
    80004650:	7902                	ld	s2,32(sp)
    80004652:	69e2                	ld	s3,24(sp)
    80004654:	6a42                	ld	s4,16(sp)
    80004656:	6121                	addi	sp,sp,64
    80004658:	8082                	ret
    iput(ip);
    8000465a:	abdff0ef          	jal	80004116 <iput>
    return -1;
    8000465e:	557d                	li	a0,-1
    80004660:	b7f5                	j	8000464c <dirlink+0x78>
      panic("dirlink read");
    80004662:	00004517          	auipc	a0,0x4
    80004666:	f7650513          	addi	a0,a0,-138 # 800085d8 <etext+0x5d8>
    8000466a:	95cfc0ef          	jal	800007c6 <panic>

000000008000466e <namei>:

struct inode*
namei(char *path)
{
    8000466e:	1101                	addi	sp,sp,-32
    80004670:	ec06                	sd	ra,24(sp)
    80004672:	e822                	sd	s0,16(sp)
    80004674:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004676:	fe040613          	addi	a2,s0,-32
    8000467a:	4581                	li	a1,0
    8000467c:	e29ff0ef          	jal	800044a4 <namex>
}
    80004680:	60e2                	ld	ra,24(sp)
    80004682:	6442                	ld	s0,16(sp)
    80004684:	6105                	addi	sp,sp,32
    80004686:	8082                	ret

0000000080004688 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004688:	1141                	addi	sp,sp,-16
    8000468a:	e406                	sd	ra,8(sp)
    8000468c:	e022                	sd	s0,0(sp)
    8000468e:	0800                	addi	s0,sp,16
    80004690:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004692:	4585                	li	a1,1
    80004694:	e11ff0ef          	jal	800044a4 <namex>
}
    80004698:	60a2                	ld	ra,8(sp)
    8000469a:	6402                	ld	s0,0(sp)
    8000469c:	0141                	addi	sp,sp,16
    8000469e:	8082                	ret

00000000800046a0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800046a0:	1101                	addi	sp,sp,-32
    800046a2:	ec06                	sd	ra,24(sp)
    800046a4:	e822                	sd	s0,16(sp)
    800046a6:	e426                	sd	s1,8(sp)
    800046a8:	e04a                	sd	s2,0(sp)
    800046aa:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800046ac:	00020917          	auipc	s2,0x20
    800046b0:	f5c90913          	addi	s2,s2,-164 # 80024608 <log>
    800046b4:	01892583          	lw	a1,24(s2)
    800046b8:	02892503          	lw	a0,40(s2)
    800046bc:	9a0ff0ef          	jal	8000385c <bread>
    800046c0:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800046c2:	02c92603          	lw	a2,44(s2)
    800046c6:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800046c8:	00c05f63          	blez	a2,800046e6 <write_head+0x46>
    800046cc:	00020717          	auipc	a4,0x20
    800046d0:	f6c70713          	addi	a4,a4,-148 # 80024638 <log+0x30>
    800046d4:	87aa                	mv	a5,a0
    800046d6:	060a                	slli	a2,a2,0x2
    800046d8:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800046da:	4314                	lw	a3,0(a4)
    800046dc:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800046de:	0711                	addi	a4,a4,4
    800046e0:	0791                	addi	a5,a5,4
    800046e2:	fec79ce3          	bne	a5,a2,800046da <write_head+0x3a>
  }
  bwrite(buf);
    800046e6:	8526                	mv	a0,s1
    800046e8:	a4aff0ef          	jal	80003932 <bwrite>
  brelse(buf);
    800046ec:	8526                	mv	a0,s1
    800046ee:	a76ff0ef          	jal	80003964 <brelse>
}
    800046f2:	60e2                	ld	ra,24(sp)
    800046f4:	6442                	ld	s0,16(sp)
    800046f6:	64a2                	ld	s1,8(sp)
    800046f8:	6902                	ld	s2,0(sp)
    800046fa:	6105                	addi	sp,sp,32
    800046fc:	8082                	ret

00000000800046fe <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800046fe:	00020797          	auipc	a5,0x20
    80004702:	f367a783          	lw	a5,-202(a5) # 80024634 <log+0x2c>
    80004706:	08f05f63          	blez	a5,800047a4 <install_trans+0xa6>
{
    8000470a:	7139                	addi	sp,sp,-64
    8000470c:	fc06                	sd	ra,56(sp)
    8000470e:	f822                	sd	s0,48(sp)
    80004710:	f426                	sd	s1,40(sp)
    80004712:	f04a                	sd	s2,32(sp)
    80004714:	ec4e                	sd	s3,24(sp)
    80004716:	e852                	sd	s4,16(sp)
    80004718:	e456                	sd	s5,8(sp)
    8000471a:	e05a                	sd	s6,0(sp)
    8000471c:	0080                	addi	s0,sp,64
    8000471e:	8b2a                	mv	s6,a0
    80004720:	00020a97          	auipc	s5,0x20
    80004724:	f18a8a93          	addi	s5,s5,-232 # 80024638 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004728:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000472a:	00020997          	auipc	s3,0x20
    8000472e:	ede98993          	addi	s3,s3,-290 # 80024608 <log>
    80004732:	a829                	j	8000474c <install_trans+0x4e>
    brelse(lbuf);
    80004734:	854a                	mv	a0,s2
    80004736:	a2eff0ef          	jal	80003964 <brelse>
    brelse(dbuf);
    8000473a:	8526                	mv	a0,s1
    8000473c:	a28ff0ef          	jal	80003964 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004740:	2a05                	addiw	s4,s4,1
    80004742:	0a91                	addi	s5,s5,4
    80004744:	02c9a783          	lw	a5,44(s3)
    80004748:	04fa5463          	bge	s4,a5,80004790 <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000474c:	0189a583          	lw	a1,24(s3)
    80004750:	014585bb          	addw	a1,a1,s4
    80004754:	2585                	addiw	a1,a1,1
    80004756:	0289a503          	lw	a0,40(s3)
    8000475a:	902ff0ef          	jal	8000385c <bread>
    8000475e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004760:	000aa583          	lw	a1,0(s5)
    80004764:	0289a503          	lw	a0,40(s3)
    80004768:	8f4ff0ef          	jal	8000385c <bread>
    8000476c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000476e:	40000613          	li	a2,1024
    80004772:	05890593          	addi	a1,s2,88
    80004776:	05850513          	addi	a0,a0,88
    8000477a:	ddcfc0ef          	jal	80000d56 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000477e:	8526                	mv	a0,s1
    80004780:	9b2ff0ef          	jal	80003932 <bwrite>
    if(recovering == 0)
    80004784:	fa0b18e3          	bnez	s6,80004734 <install_trans+0x36>
      bunpin(dbuf);
    80004788:	8526                	mv	a0,s1
    8000478a:	a96ff0ef          	jal	80003a20 <bunpin>
    8000478e:	b75d                	j	80004734 <install_trans+0x36>
}
    80004790:	70e2                	ld	ra,56(sp)
    80004792:	7442                	ld	s0,48(sp)
    80004794:	74a2                	ld	s1,40(sp)
    80004796:	7902                	ld	s2,32(sp)
    80004798:	69e2                	ld	s3,24(sp)
    8000479a:	6a42                	ld	s4,16(sp)
    8000479c:	6aa2                	ld	s5,8(sp)
    8000479e:	6b02                	ld	s6,0(sp)
    800047a0:	6121                	addi	sp,sp,64
    800047a2:	8082                	ret
    800047a4:	8082                	ret

00000000800047a6 <initlog>:
{
    800047a6:	7179                	addi	sp,sp,-48
    800047a8:	f406                	sd	ra,40(sp)
    800047aa:	f022                	sd	s0,32(sp)
    800047ac:	ec26                	sd	s1,24(sp)
    800047ae:	e84a                	sd	s2,16(sp)
    800047b0:	e44e                	sd	s3,8(sp)
    800047b2:	1800                	addi	s0,sp,48
    800047b4:	892a                	mv	s2,a0
    800047b6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800047b8:	00020497          	auipc	s1,0x20
    800047bc:	e5048493          	addi	s1,s1,-432 # 80024608 <log>
    800047c0:	00004597          	auipc	a1,0x4
    800047c4:	e2858593          	addi	a1,a1,-472 # 800085e8 <etext+0x5e8>
    800047c8:	8526                	mv	a0,s1
    800047ca:	bdcfc0ef          	jal	80000ba6 <initlock>
  log.start = sb->logstart;
    800047ce:	0149a583          	lw	a1,20(s3)
    800047d2:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800047d4:	0109a783          	lw	a5,16(s3)
    800047d8:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800047da:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800047de:	854a                	mv	a0,s2
    800047e0:	87cff0ef          	jal	8000385c <bread>
  log.lh.n = lh->n;
    800047e4:	4d30                	lw	a2,88(a0)
    800047e6:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800047e8:	00c05f63          	blez	a2,80004806 <initlog+0x60>
    800047ec:	87aa                	mv	a5,a0
    800047ee:	00020717          	auipc	a4,0x20
    800047f2:	e4a70713          	addi	a4,a4,-438 # 80024638 <log+0x30>
    800047f6:	060a                	slli	a2,a2,0x2
    800047f8:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800047fa:	4ff4                	lw	a3,92(a5)
    800047fc:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800047fe:	0791                	addi	a5,a5,4
    80004800:	0711                	addi	a4,a4,4
    80004802:	fec79ce3          	bne	a5,a2,800047fa <initlog+0x54>
  brelse(buf);
    80004806:	95eff0ef          	jal	80003964 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000480a:	4505                	li	a0,1
    8000480c:	ef3ff0ef          	jal	800046fe <install_trans>
  log.lh.n = 0;
    80004810:	00020797          	auipc	a5,0x20
    80004814:	e207a223          	sw	zero,-476(a5) # 80024634 <log+0x2c>
  write_head(); // clear the log
    80004818:	e89ff0ef          	jal	800046a0 <write_head>
}
    8000481c:	70a2                	ld	ra,40(sp)
    8000481e:	7402                	ld	s0,32(sp)
    80004820:	64e2                	ld	s1,24(sp)
    80004822:	6942                	ld	s2,16(sp)
    80004824:	69a2                	ld	s3,8(sp)
    80004826:	6145                	addi	sp,sp,48
    80004828:	8082                	ret

000000008000482a <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000482a:	1101                	addi	sp,sp,-32
    8000482c:	ec06                	sd	ra,24(sp)
    8000482e:	e822                	sd	s0,16(sp)
    80004830:	e426                	sd	s1,8(sp)
    80004832:	e04a                	sd	s2,0(sp)
    80004834:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004836:	00020517          	auipc	a0,0x20
    8000483a:	dd250513          	addi	a0,a0,-558 # 80024608 <log>
    8000483e:	be8fc0ef          	jal	80000c26 <acquire>
  while(1){
    if(log.committing){
    80004842:	00020497          	auipc	s1,0x20
    80004846:	dc648493          	addi	s1,s1,-570 # 80024608 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000484a:	4979                	li	s2,30
    8000484c:	a029                	j	80004856 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000484e:	85a6                	mv	a1,s1
    80004850:	8526                	mv	a0,s1
    80004852:	c1dfd0ef          	jal	8000246e <sleep>
    if(log.committing){
    80004856:	50dc                	lw	a5,36(s1)
    80004858:	fbfd                	bnez	a5,8000484e <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000485a:	5098                	lw	a4,32(s1)
    8000485c:	2705                	addiw	a4,a4,1
    8000485e:	0027179b          	slliw	a5,a4,0x2
    80004862:	9fb9                	addw	a5,a5,a4
    80004864:	0017979b          	slliw	a5,a5,0x1
    80004868:	54d4                	lw	a3,44(s1)
    8000486a:	9fb5                	addw	a5,a5,a3
    8000486c:	00f95763          	bge	s2,a5,8000487a <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80004870:	85a6                	mv	a1,s1
    80004872:	8526                	mv	a0,s1
    80004874:	bfbfd0ef          	jal	8000246e <sleep>
    80004878:	bff9                	j	80004856 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000487a:	00020517          	auipc	a0,0x20
    8000487e:	d8e50513          	addi	a0,a0,-626 # 80024608 <log>
    80004882:	d118                	sw	a4,32(a0)
      release(&log.lock);
    80004884:	c3afc0ef          	jal	80000cbe <release>
      break;
    }
  }
}
    80004888:	60e2                	ld	ra,24(sp)
    8000488a:	6442                	ld	s0,16(sp)
    8000488c:	64a2                	ld	s1,8(sp)
    8000488e:	6902                	ld	s2,0(sp)
    80004890:	6105                	addi	sp,sp,32
    80004892:	8082                	ret

0000000080004894 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004894:	7139                	addi	sp,sp,-64
    80004896:	fc06                	sd	ra,56(sp)
    80004898:	f822                	sd	s0,48(sp)
    8000489a:	f426                	sd	s1,40(sp)
    8000489c:	f04a                	sd	s2,32(sp)
    8000489e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800048a0:	00020497          	auipc	s1,0x20
    800048a4:	d6848493          	addi	s1,s1,-664 # 80024608 <log>
    800048a8:	8526                	mv	a0,s1
    800048aa:	b7cfc0ef          	jal	80000c26 <acquire>
  log.outstanding -= 1;
    800048ae:	509c                	lw	a5,32(s1)
    800048b0:	37fd                	addiw	a5,a5,-1
    800048b2:	0007891b          	sext.w	s2,a5
    800048b6:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800048b8:	50dc                	lw	a5,36(s1)
    800048ba:	ef9d                	bnez	a5,800048f8 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    800048bc:	04091763          	bnez	s2,8000490a <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    800048c0:	00020497          	auipc	s1,0x20
    800048c4:	d4848493          	addi	s1,s1,-696 # 80024608 <log>
    800048c8:	4785                	li	a5,1
    800048ca:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800048cc:	8526                	mv	a0,s1
    800048ce:	bf0fc0ef          	jal	80000cbe <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800048d2:	54dc                	lw	a5,44(s1)
    800048d4:	04f04b63          	bgtz	a5,8000492a <end_op+0x96>
    acquire(&log.lock);
    800048d8:	00020497          	auipc	s1,0x20
    800048dc:	d3048493          	addi	s1,s1,-720 # 80024608 <log>
    800048e0:	8526                	mv	a0,s1
    800048e2:	b44fc0ef          	jal	80000c26 <acquire>
    log.committing = 0;
    800048e6:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800048ea:	8526                	mv	a0,s1
    800048ec:	bcffd0ef          	jal	800024ba <wakeup>
    release(&log.lock);
    800048f0:	8526                	mv	a0,s1
    800048f2:	bccfc0ef          	jal	80000cbe <release>
}
    800048f6:	a025                	j	8000491e <end_op+0x8a>
    800048f8:	ec4e                	sd	s3,24(sp)
    800048fa:	e852                	sd	s4,16(sp)
    800048fc:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800048fe:	00004517          	auipc	a0,0x4
    80004902:	cf250513          	addi	a0,a0,-782 # 800085f0 <etext+0x5f0>
    80004906:	ec1fb0ef          	jal	800007c6 <panic>
    wakeup(&log);
    8000490a:	00020497          	auipc	s1,0x20
    8000490e:	cfe48493          	addi	s1,s1,-770 # 80024608 <log>
    80004912:	8526                	mv	a0,s1
    80004914:	ba7fd0ef          	jal	800024ba <wakeup>
  release(&log.lock);
    80004918:	8526                	mv	a0,s1
    8000491a:	ba4fc0ef          	jal	80000cbe <release>
}
    8000491e:	70e2                	ld	ra,56(sp)
    80004920:	7442                	ld	s0,48(sp)
    80004922:	74a2                	ld	s1,40(sp)
    80004924:	7902                	ld	s2,32(sp)
    80004926:	6121                	addi	sp,sp,64
    80004928:	8082                	ret
    8000492a:	ec4e                	sd	s3,24(sp)
    8000492c:	e852                	sd	s4,16(sp)
    8000492e:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004930:	00020a97          	auipc	s5,0x20
    80004934:	d08a8a93          	addi	s5,s5,-760 # 80024638 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004938:	00020a17          	auipc	s4,0x20
    8000493c:	cd0a0a13          	addi	s4,s4,-816 # 80024608 <log>
    80004940:	018a2583          	lw	a1,24(s4)
    80004944:	012585bb          	addw	a1,a1,s2
    80004948:	2585                	addiw	a1,a1,1
    8000494a:	028a2503          	lw	a0,40(s4)
    8000494e:	f0ffe0ef          	jal	8000385c <bread>
    80004952:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004954:	000aa583          	lw	a1,0(s5)
    80004958:	028a2503          	lw	a0,40(s4)
    8000495c:	f01fe0ef          	jal	8000385c <bread>
    80004960:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004962:	40000613          	li	a2,1024
    80004966:	05850593          	addi	a1,a0,88
    8000496a:	05848513          	addi	a0,s1,88
    8000496e:	be8fc0ef          	jal	80000d56 <memmove>
    bwrite(to);  // write the log
    80004972:	8526                	mv	a0,s1
    80004974:	fbffe0ef          	jal	80003932 <bwrite>
    brelse(from);
    80004978:	854e                	mv	a0,s3
    8000497a:	febfe0ef          	jal	80003964 <brelse>
    brelse(to);
    8000497e:	8526                	mv	a0,s1
    80004980:	fe5fe0ef          	jal	80003964 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004984:	2905                	addiw	s2,s2,1
    80004986:	0a91                	addi	s5,s5,4
    80004988:	02ca2783          	lw	a5,44(s4)
    8000498c:	faf94ae3          	blt	s2,a5,80004940 <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004990:	d11ff0ef          	jal	800046a0 <write_head>
    install_trans(0); // Now install writes to home locations
    80004994:	4501                	li	a0,0
    80004996:	d69ff0ef          	jal	800046fe <install_trans>
    log.lh.n = 0;
    8000499a:	00020797          	auipc	a5,0x20
    8000499e:	c807ad23          	sw	zero,-870(a5) # 80024634 <log+0x2c>
    write_head();    // Erase the transaction from the log
    800049a2:	cffff0ef          	jal	800046a0 <write_head>
    800049a6:	69e2                	ld	s3,24(sp)
    800049a8:	6a42                	ld	s4,16(sp)
    800049aa:	6aa2                	ld	s5,8(sp)
    800049ac:	b735                	j	800048d8 <end_op+0x44>

00000000800049ae <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800049ae:	1101                	addi	sp,sp,-32
    800049b0:	ec06                	sd	ra,24(sp)
    800049b2:	e822                	sd	s0,16(sp)
    800049b4:	e426                	sd	s1,8(sp)
    800049b6:	e04a                	sd	s2,0(sp)
    800049b8:	1000                	addi	s0,sp,32
    800049ba:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800049bc:	00020917          	auipc	s2,0x20
    800049c0:	c4c90913          	addi	s2,s2,-948 # 80024608 <log>
    800049c4:	854a                	mv	a0,s2
    800049c6:	a60fc0ef          	jal	80000c26 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800049ca:	02c92603          	lw	a2,44(s2)
    800049ce:	47f5                	li	a5,29
    800049d0:	06c7c363          	blt	a5,a2,80004a36 <log_write+0x88>
    800049d4:	00020797          	auipc	a5,0x20
    800049d8:	c507a783          	lw	a5,-944(a5) # 80024624 <log+0x1c>
    800049dc:	37fd                	addiw	a5,a5,-1
    800049de:	04f65c63          	bge	a2,a5,80004a36 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800049e2:	00020797          	auipc	a5,0x20
    800049e6:	c467a783          	lw	a5,-954(a5) # 80024628 <log+0x20>
    800049ea:	04f05c63          	blez	a5,80004a42 <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800049ee:	4781                	li	a5,0
    800049f0:	04c05f63          	blez	a2,80004a4e <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800049f4:	44cc                	lw	a1,12(s1)
    800049f6:	00020717          	auipc	a4,0x20
    800049fa:	c4270713          	addi	a4,a4,-958 # 80024638 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800049fe:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004a00:	4314                	lw	a3,0(a4)
    80004a02:	04b68663          	beq	a3,a1,80004a4e <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    80004a06:	2785                	addiw	a5,a5,1
    80004a08:	0711                	addi	a4,a4,4
    80004a0a:	fef61be3          	bne	a2,a5,80004a00 <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004a0e:	0621                	addi	a2,a2,8
    80004a10:	060a                	slli	a2,a2,0x2
    80004a12:	00020797          	auipc	a5,0x20
    80004a16:	bf678793          	addi	a5,a5,-1034 # 80024608 <log>
    80004a1a:	97b2                	add	a5,a5,a2
    80004a1c:	44d8                	lw	a4,12(s1)
    80004a1e:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004a20:	8526                	mv	a0,s1
    80004a22:	fcbfe0ef          	jal	800039ec <bpin>
    log.lh.n++;
    80004a26:	00020717          	auipc	a4,0x20
    80004a2a:	be270713          	addi	a4,a4,-1054 # 80024608 <log>
    80004a2e:	575c                	lw	a5,44(a4)
    80004a30:	2785                	addiw	a5,a5,1
    80004a32:	d75c                	sw	a5,44(a4)
    80004a34:	a80d                	j	80004a66 <log_write+0xb8>
    panic("too big a transaction");
    80004a36:	00004517          	auipc	a0,0x4
    80004a3a:	bca50513          	addi	a0,a0,-1078 # 80008600 <etext+0x600>
    80004a3e:	d89fb0ef          	jal	800007c6 <panic>
    panic("log_write outside of trans");
    80004a42:	00004517          	auipc	a0,0x4
    80004a46:	bd650513          	addi	a0,a0,-1066 # 80008618 <etext+0x618>
    80004a4a:	d7dfb0ef          	jal	800007c6 <panic>
  log.lh.block[i] = b->blockno;
    80004a4e:	00878693          	addi	a3,a5,8
    80004a52:	068a                	slli	a3,a3,0x2
    80004a54:	00020717          	auipc	a4,0x20
    80004a58:	bb470713          	addi	a4,a4,-1100 # 80024608 <log>
    80004a5c:	9736                	add	a4,a4,a3
    80004a5e:	44d4                	lw	a3,12(s1)
    80004a60:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004a62:	faf60fe3          	beq	a2,a5,80004a20 <log_write+0x72>
  }
  release(&log.lock);
    80004a66:	00020517          	auipc	a0,0x20
    80004a6a:	ba250513          	addi	a0,a0,-1118 # 80024608 <log>
    80004a6e:	a50fc0ef          	jal	80000cbe <release>
}
    80004a72:	60e2                	ld	ra,24(sp)
    80004a74:	6442                	ld	s0,16(sp)
    80004a76:	64a2                	ld	s1,8(sp)
    80004a78:	6902                	ld	s2,0(sp)
    80004a7a:	6105                	addi	sp,sp,32
    80004a7c:	8082                	ret

0000000080004a7e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004a7e:	1101                	addi	sp,sp,-32
    80004a80:	ec06                	sd	ra,24(sp)
    80004a82:	e822                	sd	s0,16(sp)
    80004a84:	e426                	sd	s1,8(sp)
    80004a86:	e04a                	sd	s2,0(sp)
    80004a88:	1000                	addi	s0,sp,32
    80004a8a:	84aa                	mv	s1,a0
    80004a8c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004a8e:	00004597          	auipc	a1,0x4
    80004a92:	baa58593          	addi	a1,a1,-1110 # 80008638 <etext+0x638>
    80004a96:	0521                	addi	a0,a0,8
    80004a98:	90efc0ef          	jal	80000ba6 <initlock>
  lk->name = name;
    80004a9c:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004aa0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004aa4:	0204a423          	sw	zero,40(s1)
}
    80004aa8:	60e2                	ld	ra,24(sp)
    80004aaa:	6442                	ld	s0,16(sp)
    80004aac:	64a2                	ld	s1,8(sp)
    80004aae:	6902                	ld	s2,0(sp)
    80004ab0:	6105                	addi	sp,sp,32
    80004ab2:	8082                	ret

0000000080004ab4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004ab4:	1101                	addi	sp,sp,-32
    80004ab6:	ec06                	sd	ra,24(sp)
    80004ab8:	e822                	sd	s0,16(sp)
    80004aba:	e426                	sd	s1,8(sp)
    80004abc:	e04a                	sd	s2,0(sp)
    80004abe:	1000                	addi	s0,sp,32
    80004ac0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004ac2:	00850913          	addi	s2,a0,8
    80004ac6:	854a                	mv	a0,s2
    80004ac8:	95efc0ef          	jal	80000c26 <acquire>
  while (lk->locked) {
    80004acc:	409c                	lw	a5,0(s1)
    80004ace:	c799                	beqz	a5,80004adc <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80004ad0:	85ca                	mv	a1,s2
    80004ad2:	8526                	mv	a0,s1
    80004ad4:	99bfd0ef          	jal	8000246e <sleep>
  while (lk->locked) {
    80004ad8:	409c                	lw	a5,0(s1)
    80004ada:	fbfd                	bnez	a5,80004ad0 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004adc:	4785                	li	a5,1
    80004ade:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004ae0:	946fd0ef          	jal	80001c26 <myproc>
    80004ae4:	591c                	lw	a5,48(a0)
    80004ae6:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004ae8:	854a                	mv	a0,s2
    80004aea:	9d4fc0ef          	jal	80000cbe <release>
}
    80004aee:	60e2                	ld	ra,24(sp)
    80004af0:	6442                	ld	s0,16(sp)
    80004af2:	64a2                	ld	s1,8(sp)
    80004af4:	6902                	ld	s2,0(sp)
    80004af6:	6105                	addi	sp,sp,32
    80004af8:	8082                	ret

0000000080004afa <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004afa:	1101                	addi	sp,sp,-32
    80004afc:	ec06                	sd	ra,24(sp)
    80004afe:	e822                	sd	s0,16(sp)
    80004b00:	e426                	sd	s1,8(sp)
    80004b02:	e04a                	sd	s2,0(sp)
    80004b04:	1000                	addi	s0,sp,32
    80004b06:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004b08:	00850913          	addi	s2,a0,8
    80004b0c:	854a                	mv	a0,s2
    80004b0e:	918fc0ef          	jal	80000c26 <acquire>
  lk->locked = 0;
    80004b12:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004b16:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	99ffd0ef          	jal	800024ba <wakeup>
  release(&lk->lk);
    80004b20:	854a                	mv	a0,s2
    80004b22:	99cfc0ef          	jal	80000cbe <release>
}
    80004b26:	60e2                	ld	ra,24(sp)
    80004b28:	6442                	ld	s0,16(sp)
    80004b2a:	64a2                	ld	s1,8(sp)
    80004b2c:	6902                	ld	s2,0(sp)
    80004b2e:	6105                	addi	sp,sp,32
    80004b30:	8082                	ret

0000000080004b32 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004b32:	7179                	addi	sp,sp,-48
    80004b34:	f406                	sd	ra,40(sp)
    80004b36:	f022                	sd	s0,32(sp)
    80004b38:	ec26                	sd	s1,24(sp)
    80004b3a:	e84a                	sd	s2,16(sp)
    80004b3c:	1800                	addi	s0,sp,48
    80004b3e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004b40:	00850913          	addi	s2,a0,8
    80004b44:	854a                	mv	a0,s2
    80004b46:	8e0fc0ef          	jal	80000c26 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004b4a:	409c                	lw	a5,0(s1)
    80004b4c:	ef81                	bnez	a5,80004b64 <holdingsleep+0x32>
    80004b4e:	4481                	li	s1,0
  release(&lk->lk);
    80004b50:	854a                	mv	a0,s2
    80004b52:	96cfc0ef          	jal	80000cbe <release>
  return r;
}
    80004b56:	8526                	mv	a0,s1
    80004b58:	70a2                	ld	ra,40(sp)
    80004b5a:	7402                	ld	s0,32(sp)
    80004b5c:	64e2                	ld	s1,24(sp)
    80004b5e:	6942                	ld	s2,16(sp)
    80004b60:	6145                	addi	sp,sp,48
    80004b62:	8082                	ret
    80004b64:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004b66:	0284a983          	lw	s3,40(s1)
    80004b6a:	8bcfd0ef          	jal	80001c26 <myproc>
    80004b6e:	5904                	lw	s1,48(a0)
    80004b70:	413484b3          	sub	s1,s1,s3
    80004b74:	0014b493          	seqz	s1,s1
    80004b78:	69a2                	ld	s3,8(sp)
    80004b7a:	bfd9                	j	80004b50 <holdingsleep+0x1e>

0000000080004b7c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004b7c:	1141                	addi	sp,sp,-16
    80004b7e:	e406                	sd	ra,8(sp)
    80004b80:	e022                	sd	s0,0(sp)
    80004b82:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004b84:	00004597          	auipc	a1,0x4
    80004b88:	ac458593          	addi	a1,a1,-1340 # 80008648 <etext+0x648>
    80004b8c:	00020517          	auipc	a0,0x20
    80004b90:	bc450513          	addi	a0,a0,-1084 # 80024750 <ftable>
    80004b94:	812fc0ef          	jal	80000ba6 <initlock>
}
    80004b98:	60a2                	ld	ra,8(sp)
    80004b9a:	6402                	ld	s0,0(sp)
    80004b9c:	0141                	addi	sp,sp,16
    80004b9e:	8082                	ret

0000000080004ba0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004ba0:	1101                	addi	sp,sp,-32
    80004ba2:	ec06                	sd	ra,24(sp)
    80004ba4:	e822                	sd	s0,16(sp)
    80004ba6:	e426                	sd	s1,8(sp)
    80004ba8:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004baa:	00020517          	auipc	a0,0x20
    80004bae:	ba650513          	addi	a0,a0,-1114 # 80024750 <ftable>
    80004bb2:	874fc0ef          	jal	80000c26 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004bb6:	00020497          	auipc	s1,0x20
    80004bba:	bb248493          	addi	s1,s1,-1102 # 80024768 <ftable+0x18>
    80004bbe:	00021717          	auipc	a4,0x21
    80004bc2:	b4a70713          	addi	a4,a4,-1206 # 80025708 <disk>
    if(f->ref == 0){
    80004bc6:	40dc                	lw	a5,4(s1)
    80004bc8:	cf89                	beqz	a5,80004be2 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004bca:	02848493          	addi	s1,s1,40
    80004bce:	fee49ce3          	bne	s1,a4,80004bc6 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004bd2:	00020517          	auipc	a0,0x20
    80004bd6:	b7e50513          	addi	a0,a0,-1154 # 80024750 <ftable>
    80004bda:	8e4fc0ef          	jal	80000cbe <release>
  return 0;
    80004bde:	4481                	li	s1,0
    80004be0:	a809                	j	80004bf2 <filealloc+0x52>
      f->ref = 1;
    80004be2:	4785                	li	a5,1
    80004be4:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004be6:	00020517          	auipc	a0,0x20
    80004bea:	b6a50513          	addi	a0,a0,-1174 # 80024750 <ftable>
    80004bee:	8d0fc0ef          	jal	80000cbe <release>
}
    80004bf2:	8526                	mv	a0,s1
    80004bf4:	60e2                	ld	ra,24(sp)
    80004bf6:	6442                	ld	s0,16(sp)
    80004bf8:	64a2                	ld	s1,8(sp)
    80004bfa:	6105                	addi	sp,sp,32
    80004bfc:	8082                	ret

0000000080004bfe <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004bfe:	1101                	addi	sp,sp,-32
    80004c00:	ec06                	sd	ra,24(sp)
    80004c02:	e822                	sd	s0,16(sp)
    80004c04:	e426                	sd	s1,8(sp)
    80004c06:	1000                	addi	s0,sp,32
    80004c08:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004c0a:	00020517          	auipc	a0,0x20
    80004c0e:	b4650513          	addi	a0,a0,-1210 # 80024750 <ftable>
    80004c12:	814fc0ef          	jal	80000c26 <acquire>
  if(f->ref < 1)
    80004c16:	40dc                	lw	a5,4(s1)
    80004c18:	02f05063          	blez	a5,80004c38 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004c1c:	2785                	addiw	a5,a5,1
    80004c1e:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004c20:	00020517          	auipc	a0,0x20
    80004c24:	b3050513          	addi	a0,a0,-1232 # 80024750 <ftable>
    80004c28:	896fc0ef          	jal	80000cbe <release>
  return f;
}
    80004c2c:	8526                	mv	a0,s1
    80004c2e:	60e2                	ld	ra,24(sp)
    80004c30:	6442                	ld	s0,16(sp)
    80004c32:	64a2                	ld	s1,8(sp)
    80004c34:	6105                	addi	sp,sp,32
    80004c36:	8082                	ret
    panic("filedup");
    80004c38:	00004517          	auipc	a0,0x4
    80004c3c:	a1850513          	addi	a0,a0,-1512 # 80008650 <etext+0x650>
    80004c40:	b87fb0ef          	jal	800007c6 <panic>

0000000080004c44 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004c44:	7139                	addi	sp,sp,-64
    80004c46:	fc06                	sd	ra,56(sp)
    80004c48:	f822                	sd	s0,48(sp)
    80004c4a:	f426                	sd	s1,40(sp)
    80004c4c:	0080                	addi	s0,sp,64
    80004c4e:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004c50:	00020517          	auipc	a0,0x20
    80004c54:	b0050513          	addi	a0,a0,-1280 # 80024750 <ftable>
    80004c58:	fcffb0ef          	jal	80000c26 <acquire>
  if(f->ref < 1)
    80004c5c:	40dc                	lw	a5,4(s1)
    80004c5e:	04f05a63          	blez	a5,80004cb2 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004c62:	37fd                	addiw	a5,a5,-1
    80004c64:	0007871b          	sext.w	a4,a5
    80004c68:	c0dc                	sw	a5,4(s1)
    80004c6a:	04e04e63          	bgtz	a4,80004cc6 <fileclose+0x82>
    80004c6e:	f04a                	sd	s2,32(sp)
    80004c70:	ec4e                	sd	s3,24(sp)
    80004c72:	e852                	sd	s4,16(sp)
    80004c74:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004c76:	0004a903          	lw	s2,0(s1)
    80004c7a:	0094ca83          	lbu	s5,9(s1)
    80004c7e:	0104ba03          	ld	s4,16(s1)
    80004c82:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004c86:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004c8a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004c8e:	00020517          	auipc	a0,0x20
    80004c92:	ac250513          	addi	a0,a0,-1342 # 80024750 <ftable>
    80004c96:	828fc0ef          	jal	80000cbe <release>

  if(ff.type == FD_PIPE){
    80004c9a:	4785                	li	a5,1
    80004c9c:	04f90063          	beq	s2,a5,80004cdc <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004ca0:	3979                	addiw	s2,s2,-2
    80004ca2:	4785                	li	a5,1
    80004ca4:	0527f563          	bgeu	a5,s2,80004cee <fileclose+0xaa>
    80004ca8:	7902                	ld	s2,32(sp)
    80004caa:	69e2                	ld	s3,24(sp)
    80004cac:	6a42                	ld	s4,16(sp)
    80004cae:	6aa2                	ld	s5,8(sp)
    80004cb0:	a00d                	j	80004cd2 <fileclose+0x8e>
    80004cb2:	f04a                	sd	s2,32(sp)
    80004cb4:	ec4e                	sd	s3,24(sp)
    80004cb6:	e852                	sd	s4,16(sp)
    80004cb8:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004cba:	00004517          	auipc	a0,0x4
    80004cbe:	99e50513          	addi	a0,a0,-1634 # 80008658 <etext+0x658>
    80004cc2:	b05fb0ef          	jal	800007c6 <panic>
    release(&ftable.lock);
    80004cc6:	00020517          	auipc	a0,0x20
    80004cca:	a8a50513          	addi	a0,a0,-1398 # 80024750 <ftable>
    80004cce:	ff1fb0ef          	jal	80000cbe <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004cd2:	70e2                	ld	ra,56(sp)
    80004cd4:	7442                	ld	s0,48(sp)
    80004cd6:	74a2                	ld	s1,40(sp)
    80004cd8:	6121                	addi	sp,sp,64
    80004cda:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004cdc:	85d6                	mv	a1,s5
    80004cde:	8552                	mv	a0,s4
    80004ce0:	336000ef          	jal	80005016 <pipeclose>
    80004ce4:	7902                	ld	s2,32(sp)
    80004ce6:	69e2                	ld	s3,24(sp)
    80004ce8:	6a42                	ld	s4,16(sp)
    80004cea:	6aa2                	ld	s5,8(sp)
    80004cec:	b7dd                	j	80004cd2 <fileclose+0x8e>
    begin_op();
    80004cee:	b3dff0ef          	jal	8000482a <begin_op>
    iput(ff.ip);
    80004cf2:	854e                	mv	a0,s3
    80004cf4:	c22ff0ef          	jal	80004116 <iput>
    end_op();
    80004cf8:	b9dff0ef          	jal	80004894 <end_op>
    80004cfc:	7902                	ld	s2,32(sp)
    80004cfe:	69e2                	ld	s3,24(sp)
    80004d00:	6a42                	ld	s4,16(sp)
    80004d02:	6aa2                	ld	s5,8(sp)
    80004d04:	b7f9                	j	80004cd2 <fileclose+0x8e>

0000000080004d06 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004d06:	715d                	addi	sp,sp,-80
    80004d08:	e486                	sd	ra,72(sp)
    80004d0a:	e0a2                	sd	s0,64(sp)
    80004d0c:	fc26                	sd	s1,56(sp)
    80004d0e:	f44e                	sd	s3,40(sp)
    80004d10:	0880                	addi	s0,sp,80
    80004d12:	84aa                	mv	s1,a0
    80004d14:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004d16:	f11fc0ef          	jal	80001c26 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004d1a:	409c                	lw	a5,0(s1)
    80004d1c:	37f9                	addiw	a5,a5,-2
    80004d1e:	4705                	li	a4,1
    80004d20:	04f76063          	bltu	a4,a5,80004d60 <filestat+0x5a>
    80004d24:	f84a                	sd	s2,48(sp)
    80004d26:	892a                	mv	s2,a0
    ilock(f->ip);
    80004d28:	6c88                	ld	a0,24(s1)
    80004d2a:	a6aff0ef          	jal	80003f94 <ilock>
    stati(f->ip, &st);
    80004d2e:	fb840593          	addi	a1,s0,-72
    80004d32:	6c88                	ld	a0,24(s1)
    80004d34:	c8aff0ef          	jal	800041be <stati>
    iunlock(f->ip);
    80004d38:	6c88                	ld	a0,24(s1)
    80004d3a:	b08ff0ef          	jal	80004042 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004d3e:	46e1                	li	a3,24
    80004d40:	fb840613          	addi	a2,s0,-72
    80004d44:	85ce                	mv	a1,s3
    80004d46:	06093503          	ld	a0,96(s2)
    80004d4a:	83bfc0ef          	jal	80001584 <copyout>
    80004d4e:	41f5551b          	sraiw	a0,a0,0x1f
    80004d52:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004d54:	60a6                	ld	ra,72(sp)
    80004d56:	6406                	ld	s0,64(sp)
    80004d58:	74e2                	ld	s1,56(sp)
    80004d5a:	79a2                	ld	s3,40(sp)
    80004d5c:	6161                	addi	sp,sp,80
    80004d5e:	8082                	ret
  return -1;
    80004d60:	557d                	li	a0,-1
    80004d62:	bfcd                	j	80004d54 <filestat+0x4e>

0000000080004d64 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004d64:	7179                	addi	sp,sp,-48
    80004d66:	f406                	sd	ra,40(sp)
    80004d68:	f022                	sd	s0,32(sp)
    80004d6a:	e84a                	sd	s2,16(sp)
    80004d6c:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004d6e:	00854783          	lbu	a5,8(a0)
    80004d72:	cfd1                	beqz	a5,80004e0e <fileread+0xaa>
    80004d74:	ec26                	sd	s1,24(sp)
    80004d76:	e44e                	sd	s3,8(sp)
    80004d78:	84aa                	mv	s1,a0
    80004d7a:	89ae                	mv	s3,a1
    80004d7c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d7e:	411c                	lw	a5,0(a0)
    80004d80:	4705                	li	a4,1
    80004d82:	04e78363          	beq	a5,a4,80004dc8 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d86:	470d                	li	a4,3
    80004d88:	04e78763          	beq	a5,a4,80004dd6 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d8c:	4709                	li	a4,2
    80004d8e:	06e79a63          	bne	a5,a4,80004e02 <fileread+0x9e>
    ilock(f->ip);
    80004d92:	6d08                	ld	a0,24(a0)
    80004d94:	a00ff0ef          	jal	80003f94 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004d98:	874a                	mv	a4,s2
    80004d9a:	5094                	lw	a3,32(s1)
    80004d9c:	864e                	mv	a2,s3
    80004d9e:	4585                	li	a1,1
    80004da0:	6c88                	ld	a0,24(s1)
    80004da2:	c46ff0ef          	jal	800041e8 <readi>
    80004da6:	892a                	mv	s2,a0
    80004da8:	00a05563          	blez	a0,80004db2 <fileread+0x4e>
      f->off += r;
    80004dac:	509c                	lw	a5,32(s1)
    80004dae:	9fa9                	addw	a5,a5,a0
    80004db0:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004db2:	6c88                	ld	a0,24(s1)
    80004db4:	a8eff0ef          	jal	80004042 <iunlock>
    80004db8:	64e2                	ld	s1,24(sp)
    80004dba:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004dbc:	854a                	mv	a0,s2
    80004dbe:	70a2                	ld	ra,40(sp)
    80004dc0:	7402                	ld	s0,32(sp)
    80004dc2:	6942                	ld	s2,16(sp)
    80004dc4:	6145                	addi	sp,sp,48
    80004dc6:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004dc8:	6908                	ld	a0,16(a0)
    80004dca:	388000ef          	jal	80005152 <piperead>
    80004dce:	892a                	mv	s2,a0
    80004dd0:	64e2                	ld	s1,24(sp)
    80004dd2:	69a2                	ld	s3,8(sp)
    80004dd4:	b7e5                	j	80004dbc <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004dd6:	02451783          	lh	a5,36(a0)
    80004dda:	03079693          	slli	a3,a5,0x30
    80004dde:	92c1                	srli	a3,a3,0x30
    80004de0:	4725                	li	a4,9
    80004de2:	02d76863          	bltu	a4,a3,80004e12 <fileread+0xae>
    80004de6:	0792                	slli	a5,a5,0x4
    80004de8:	00020717          	auipc	a4,0x20
    80004dec:	8c870713          	addi	a4,a4,-1848 # 800246b0 <devsw>
    80004df0:	97ba                	add	a5,a5,a4
    80004df2:	639c                	ld	a5,0(a5)
    80004df4:	c39d                	beqz	a5,80004e1a <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004df6:	4505                	li	a0,1
    80004df8:	9782                	jalr	a5
    80004dfa:	892a                	mv	s2,a0
    80004dfc:	64e2                	ld	s1,24(sp)
    80004dfe:	69a2                	ld	s3,8(sp)
    80004e00:	bf75                	j	80004dbc <fileread+0x58>
    panic("fileread");
    80004e02:	00004517          	auipc	a0,0x4
    80004e06:	86650513          	addi	a0,a0,-1946 # 80008668 <etext+0x668>
    80004e0a:	9bdfb0ef          	jal	800007c6 <panic>
    return -1;
    80004e0e:	597d                	li	s2,-1
    80004e10:	b775                	j	80004dbc <fileread+0x58>
      return -1;
    80004e12:	597d                	li	s2,-1
    80004e14:	64e2                	ld	s1,24(sp)
    80004e16:	69a2                	ld	s3,8(sp)
    80004e18:	b755                	j	80004dbc <fileread+0x58>
    80004e1a:	597d                	li	s2,-1
    80004e1c:	64e2                	ld	s1,24(sp)
    80004e1e:	69a2                	ld	s3,8(sp)
    80004e20:	bf71                	j	80004dbc <fileread+0x58>

0000000080004e22 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004e22:	00954783          	lbu	a5,9(a0)
    80004e26:	10078b63          	beqz	a5,80004f3c <filewrite+0x11a>
{
    80004e2a:	715d                	addi	sp,sp,-80
    80004e2c:	e486                	sd	ra,72(sp)
    80004e2e:	e0a2                	sd	s0,64(sp)
    80004e30:	f84a                	sd	s2,48(sp)
    80004e32:	f052                	sd	s4,32(sp)
    80004e34:	e85a                	sd	s6,16(sp)
    80004e36:	0880                	addi	s0,sp,80
    80004e38:	892a                	mv	s2,a0
    80004e3a:	8b2e                	mv	s6,a1
    80004e3c:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004e3e:	411c                	lw	a5,0(a0)
    80004e40:	4705                	li	a4,1
    80004e42:	02e78763          	beq	a5,a4,80004e70 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004e46:	470d                	li	a4,3
    80004e48:	02e78863          	beq	a5,a4,80004e78 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004e4c:	4709                	li	a4,2
    80004e4e:	0ce79c63          	bne	a5,a4,80004f26 <filewrite+0x104>
    80004e52:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004e54:	0ac05863          	blez	a2,80004f04 <filewrite+0xe2>
    80004e58:	fc26                	sd	s1,56(sp)
    80004e5a:	ec56                	sd	s5,24(sp)
    80004e5c:	e45e                	sd	s7,8(sp)
    80004e5e:	e062                	sd	s8,0(sp)
    int i = 0;
    80004e60:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004e62:	6b85                	lui	s7,0x1
    80004e64:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004e68:	6c05                	lui	s8,0x1
    80004e6a:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004e6e:	a8b5                	j	80004eea <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004e70:	6908                	ld	a0,16(a0)
    80004e72:	1fc000ef          	jal	8000506e <pipewrite>
    80004e76:	a04d                	j	80004f18 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004e78:	02451783          	lh	a5,36(a0)
    80004e7c:	03079693          	slli	a3,a5,0x30
    80004e80:	92c1                	srli	a3,a3,0x30
    80004e82:	4725                	li	a4,9
    80004e84:	0ad76e63          	bltu	a4,a3,80004f40 <filewrite+0x11e>
    80004e88:	0792                	slli	a5,a5,0x4
    80004e8a:	00020717          	auipc	a4,0x20
    80004e8e:	82670713          	addi	a4,a4,-2010 # 800246b0 <devsw>
    80004e92:	97ba                	add	a5,a5,a4
    80004e94:	679c                	ld	a5,8(a5)
    80004e96:	c7dd                	beqz	a5,80004f44 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80004e98:	4505                	li	a0,1
    80004e9a:	9782                	jalr	a5
    80004e9c:	a8b5                	j	80004f18 <filewrite+0xf6>
      if(n1 > max)
    80004e9e:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004ea2:	989ff0ef          	jal	8000482a <begin_op>
      ilock(f->ip);
    80004ea6:	01893503          	ld	a0,24(s2)
    80004eaa:	8eaff0ef          	jal	80003f94 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004eae:	8756                	mv	a4,s5
    80004eb0:	02092683          	lw	a3,32(s2)
    80004eb4:	01698633          	add	a2,s3,s6
    80004eb8:	4585                	li	a1,1
    80004eba:	01893503          	ld	a0,24(s2)
    80004ebe:	c26ff0ef          	jal	800042e4 <writei>
    80004ec2:	84aa                	mv	s1,a0
    80004ec4:	00a05763          	blez	a0,80004ed2 <filewrite+0xb0>
        f->off += r;
    80004ec8:	02092783          	lw	a5,32(s2)
    80004ecc:	9fa9                	addw	a5,a5,a0
    80004ece:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004ed2:	01893503          	ld	a0,24(s2)
    80004ed6:	96cff0ef          	jal	80004042 <iunlock>
      end_op();
    80004eda:	9bbff0ef          	jal	80004894 <end_op>

      if(r != n1){
    80004ede:	029a9563          	bne	s5,s1,80004f08 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004ee2:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004ee6:	0149da63          	bge	s3,s4,80004efa <filewrite+0xd8>
      int n1 = n - i;
    80004eea:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004eee:	0004879b          	sext.w	a5,s1
    80004ef2:	fafbd6e3          	bge	s7,a5,80004e9e <filewrite+0x7c>
    80004ef6:	84e2                	mv	s1,s8
    80004ef8:	b75d                	j	80004e9e <filewrite+0x7c>
    80004efa:	74e2                	ld	s1,56(sp)
    80004efc:	6ae2                	ld	s5,24(sp)
    80004efe:	6ba2                	ld	s7,8(sp)
    80004f00:	6c02                	ld	s8,0(sp)
    80004f02:	a039                	j	80004f10 <filewrite+0xee>
    int i = 0;
    80004f04:	4981                	li	s3,0
    80004f06:	a029                	j	80004f10 <filewrite+0xee>
    80004f08:	74e2                	ld	s1,56(sp)
    80004f0a:	6ae2                	ld	s5,24(sp)
    80004f0c:	6ba2                	ld	s7,8(sp)
    80004f0e:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004f10:	033a1c63          	bne	s4,s3,80004f48 <filewrite+0x126>
    80004f14:	8552                	mv	a0,s4
    80004f16:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004f18:	60a6                	ld	ra,72(sp)
    80004f1a:	6406                	ld	s0,64(sp)
    80004f1c:	7942                	ld	s2,48(sp)
    80004f1e:	7a02                	ld	s4,32(sp)
    80004f20:	6b42                	ld	s6,16(sp)
    80004f22:	6161                	addi	sp,sp,80
    80004f24:	8082                	ret
    80004f26:	fc26                	sd	s1,56(sp)
    80004f28:	f44e                	sd	s3,40(sp)
    80004f2a:	ec56                	sd	s5,24(sp)
    80004f2c:	e45e                	sd	s7,8(sp)
    80004f2e:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004f30:	00003517          	auipc	a0,0x3
    80004f34:	74850513          	addi	a0,a0,1864 # 80008678 <etext+0x678>
    80004f38:	88ffb0ef          	jal	800007c6 <panic>
    return -1;
    80004f3c:	557d                	li	a0,-1
}
    80004f3e:	8082                	ret
      return -1;
    80004f40:	557d                	li	a0,-1
    80004f42:	bfd9                	j	80004f18 <filewrite+0xf6>
    80004f44:	557d                	li	a0,-1
    80004f46:	bfc9                	j	80004f18 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004f48:	557d                	li	a0,-1
    80004f4a:	79a2                	ld	s3,40(sp)
    80004f4c:	b7f1                	j	80004f18 <filewrite+0xf6>

0000000080004f4e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004f4e:	7179                	addi	sp,sp,-48
    80004f50:	f406                	sd	ra,40(sp)
    80004f52:	f022                	sd	s0,32(sp)
    80004f54:	ec26                	sd	s1,24(sp)
    80004f56:	e052                	sd	s4,0(sp)
    80004f58:	1800                	addi	s0,sp,48
    80004f5a:	84aa                	mv	s1,a0
    80004f5c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004f5e:	0005b023          	sd	zero,0(a1)
    80004f62:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004f66:	c3bff0ef          	jal	80004ba0 <filealloc>
    80004f6a:	e088                	sd	a0,0(s1)
    80004f6c:	c549                	beqz	a0,80004ff6 <pipealloc+0xa8>
    80004f6e:	c33ff0ef          	jal	80004ba0 <filealloc>
    80004f72:	00aa3023          	sd	a0,0(s4)
    80004f76:	cd25                	beqz	a0,80004fee <pipealloc+0xa0>
    80004f78:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004f7a:	bddfb0ef          	jal	80000b56 <kalloc>
    80004f7e:	892a                	mv	s2,a0
    80004f80:	c12d                	beqz	a0,80004fe2 <pipealloc+0x94>
    80004f82:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004f84:	4985                	li	s3,1
    80004f86:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004f8a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004f8e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004f92:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004f96:	00003597          	auipc	a1,0x3
    80004f9a:	6f258593          	addi	a1,a1,1778 # 80008688 <etext+0x688>
    80004f9e:	c09fb0ef          	jal	80000ba6 <initlock>
  (*f0)->type = FD_PIPE;
    80004fa2:	609c                	ld	a5,0(s1)
    80004fa4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004fa8:	609c                	ld	a5,0(s1)
    80004faa:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004fae:	609c                	ld	a5,0(s1)
    80004fb0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004fb4:	609c                	ld	a5,0(s1)
    80004fb6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004fba:	000a3783          	ld	a5,0(s4)
    80004fbe:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004fc2:	000a3783          	ld	a5,0(s4)
    80004fc6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004fca:	000a3783          	ld	a5,0(s4)
    80004fce:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004fd2:	000a3783          	ld	a5,0(s4)
    80004fd6:	0127b823          	sd	s2,16(a5)
  return 0;
    80004fda:	4501                	li	a0,0
    80004fdc:	6942                	ld	s2,16(sp)
    80004fde:	69a2                	ld	s3,8(sp)
    80004fe0:	a01d                	j	80005006 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004fe2:	6088                	ld	a0,0(s1)
    80004fe4:	c119                	beqz	a0,80004fea <pipealloc+0x9c>
    80004fe6:	6942                	ld	s2,16(sp)
    80004fe8:	a029                	j	80004ff2 <pipealloc+0xa4>
    80004fea:	6942                	ld	s2,16(sp)
    80004fec:	a029                	j	80004ff6 <pipealloc+0xa8>
    80004fee:	6088                	ld	a0,0(s1)
    80004ff0:	c10d                	beqz	a0,80005012 <pipealloc+0xc4>
    fileclose(*f0);
    80004ff2:	c53ff0ef          	jal	80004c44 <fileclose>
  if(*f1)
    80004ff6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004ffa:	557d                	li	a0,-1
  if(*f1)
    80004ffc:	c789                	beqz	a5,80005006 <pipealloc+0xb8>
    fileclose(*f1);
    80004ffe:	853e                	mv	a0,a5
    80005000:	c45ff0ef          	jal	80004c44 <fileclose>
  return -1;
    80005004:	557d                	li	a0,-1
}
    80005006:	70a2                	ld	ra,40(sp)
    80005008:	7402                	ld	s0,32(sp)
    8000500a:	64e2                	ld	s1,24(sp)
    8000500c:	6a02                	ld	s4,0(sp)
    8000500e:	6145                	addi	sp,sp,48
    80005010:	8082                	ret
  return -1;
    80005012:	557d                	li	a0,-1
    80005014:	bfcd                	j	80005006 <pipealloc+0xb8>

0000000080005016 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80005016:	1101                	addi	sp,sp,-32
    80005018:	ec06                	sd	ra,24(sp)
    8000501a:	e822                	sd	s0,16(sp)
    8000501c:	e426                	sd	s1,8(sp)
    8000501e:	e04a                	sd	s2,0(sp)
    80005020:	1000                	addi	s0,sp,32
    80005022:	84aa                	mv	s1,a0
    80005024:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005026:	c01fb0ef          	jal	80000c26 <acquire>
  if(writable){
    8000502a:	02090763          	beqz	s2,80005058 <pipeclose+0x42>
    pi->writeopen = 0;
    8000502e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005032:	21848513          	addi	a0,s1,536
    80005036:	c84fd0ef          	jal	800024ba <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000503a:	2204b783          	ld	a5,544(s1)
    8000503e:	e785                	bnez	a5,80005066 <pipeclose+0x50>
    release(&pi->lock);
    80005040:	8526                	mv	a0,s1
    80005042:	c7dfb0ef          	jal	80000cbe <release>
    kfree((char*)pi);
    80005046:	8526                	mv	a0,s1
    80005048:	a2dfb0ef          	jal	80000a74 <kfree>
  } else
    release(&pi->lock);
}
    8000504c:	60e2                	ld	ra,24(sp)
    8000504e:	6442                	ld	s0,16(sp)
    80005050:	64a2                	ld	s1,8(sp)
    80005052:	6902                	ld	s2,0(sp)
    80005054:	6105                	addi	sp,sp,32
    80005056:	8082                	ret
    pi->readopen = 0;
    80005058:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000505c:	21c48513          	addi	a0,s1,540
    80005060:	c5afd0ef          	jal	800024ba <wakeup>
    80005064:	bfd9                	j	8000503a <pipeclose+0x24>
    release(&pi->lock);
    80005066:	8526                	mv	a0,s1
    80005068:	c57fb0ef          	jal	80000cbe <release>
}
    8000506c:	b7c5                	j	8000504c <pipeclose+0x36>

000000008000506e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000506e:	711d                	addi	sp,sp,-96
    80005070:	ec86                	sd	ra,88(sp)
    80005072:	e8a2                	sd	s0,80(sp)
    80005074:	e4a6                	sd	s1,72(sp)
    80005076:	e0ca                	sd	s2,64(sp)
    80005078:	fc4e                	sd	s3,56(sp)
    8000507a:	f852                	sd	s4,48(sp)
    8000507c:	f456                	sd	s5,40(sp)
    8000507e:	1080                	addi	s0,sp,96
    80005080:	84aa                	mv	s1,a0
    80005082:	8aae                	mv	s5,a1
    80005084:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005086:	ba1fc0ef          	jal	80001c26 <myproc>
    8000508a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000508c:	8526                	mv	a0,s1
    8000508e:	b99fb0ef          	jal	80000c26 <acquire>
  while(i < n){
    80005092:	0b405a63          	blez	s4,80005146 <pipewrite+0xd8>
    80005096:	f05a                	sd	s6,32(sp)
    80005098:	ec5e                	sd	s7,24(sp)
    8000509a:	e862                	sd	s8,16(sp)
  int i = 0;
    8000509c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000509e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800050a0:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800050a4:	21c48b93          	addi	s7,s1,540
    800050a8:	a81d                	j	800050de <pipewrite+0x70>
      release(&pi->lock);
    800050aa:	8526                	mv	a0,s1
    800050ac:	c13fb0ef          	jal	80000cbe <release>
      return -1;
    800050b0:	597d                	li	s2,-1
    800050b2:	7b02                	ld	s6,32(sp)
    800050b4:	6be2                	ld	s7,24(sp)
    800050b6:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800050b8:	854a                	mv	a0,s2
    800050ba:	60e6                	ld	ra,88(sp)
    800050bc:	6446                	ld	s0,80(sp)
    800050be:	64a6                	ld	s1,72(sp)
    800050c0:	6906                	ld	s2,64(sp)
    800050c2:	79e2                	ld	s3,56(sp)
    800050c4:	7a42                	ld	s4,48(sp)
    800050c6:	7aa2                	ld	s5,40(sp)
    800050c8:	6125                	addi	sp,sp,96
    800050ca:	8082                	ret
      wakeup(&pi->nread);
    800050cc:	8562                	mv	a0,s8
    800050ce:	becfd0ef          	jal	800024ba <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800050d2:	85a6                	mv	a1,s1
    800050d4:	855e                	mv	a0,s7
    800050d6:	b98fd0ef          	jal	8000246e <sleep>
  while(i < n){
    800050da:	05495b63          	bge	s2,s4,80005130 <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    800050de:	2204a783          	lw	a5,544(s1)
    800050e2:	d7e1                	beqz	a5,800050aa <pipewrite+0x3c>
    800050e4:	854e                	mv	a0,s3
    800050e6:	e4efd0ef          	jal	80002734 <killed>
    800050ea:	f161                	bnez	a0,800050aa <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800050ec:	2184a783          	lw	a5,536(s1)
    800050f0:	21c4a703          	lw	a4,540(s1)
    800050f4:	2007879b          	addiw	a5,a5,512
    800050f8:	fcf70ae3          	beq	a4,a5,800050cc <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800050fc:	4685                	li	a3,1
    800050fe:	01590633          	add	a2,s2,s5
    80005102:	faf40593          	addi	a1,s0,-81
    80005106:	0609b503          	ld	a0,96(s3)
    8000510a:	d50fc0ef          	jal	8000165a <copyin>
    8000510e:	03650e63          	beq	a0,s6,8000514a <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005112:	21c4a783          	lw	a5,540(s1)
    80005116:	0017871b          	addiw	a4,a5,1
    8000511a:	20e4ae23          	sw	a4,540(s1)
    8000511e:	1ff7f793          	andi	a5,a5,511
    80005122:	97a6                	add	a5,a5,s1
    80005124:	faf44703          	lbu	a4,-81(s0)
    80005128:	00e78c23          	sb	a4,24(a5)
      i++;
    8000512c:	2905                	addiw	s2,s2,1
    8000512e:	b775                	j	800050da <pipewrite+0x6c>
    80005130:	7b02                	ld	s6,32(sp)
    80005132:	6be2                	ld	s7,24(sp)
    80005134:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80005136:	21848513          	addi	a0,s1,536
    8000513a:	b80fd0ef          	jal	800024ba <wakeup>
  release(&pi->lock);
    8000513e:	8526                	mv	a0,s1
    80005140:	b7ffb0ef          	jal	80000cbe <release>
  return i;
    80005144:	bf95                	j	800050b8 <pipewrite+0x4a>
  int i = 0;
    80005146:	4901                	li	s2,0
    80005148:	b7fd                	j	80005136 <pipewrite+0xc8>
    8000514a:	7b02                	ld	s6,32(sp)
    8000514c:	6be2                	ld	s7,24(sp)
    8000514e:	6c42                	ld	s8,16(sp)
    80005150:	b7dd                	j	80005136 <pipewrite+0xc8>

0000000080005152 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005152:	715d                	addi	sp,sp,-80
    80005154:	e486                	sd	ra,72(sp)
    80005156:	e0a2                	sd	s0,64(sp)
    80005158:	fc26                	sd	s1,56(sp)
    8000515a:	f84a                	sd	s2,48(sp)
    8000515c:	f44e                	sd	s3,40(sp)
    8000515e:	f052                	sd	s4,32(sp)
    80005160:	ec56                	sd	s5,24(sp)
    80005162:	0880                	addi	s0,sp,80
    80005164:	84aa                	mv	s1,a0
    80005166:	892e                	mv	s2,a1
    80005168:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000516a:	abdfc0ef          	jal	80001c26 <myproc>
    8000516e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005170:	8526                	mv	a0,s1
    80005172:	ab5fb0ef          	jal	80000c26 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005176:	2184a703          	lw	a4,536(s1)
    8000517a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000517e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005182:	02f71563          	bne	a4,a5,800051ac <piperead+0x5a>
    80005186:	2244a783          	lw	a5,548(s1)
    8000518a:	cb85                	beqz	a5,800051ba <piperead+0x68>
    if(killed(pr)){
    8000518c:	8552                	mv	a0,s4
    8000518e:	da6fd0ef          	jal	80002734 <killed>
    80005192:	ed19                	bnez	a0,800051b0 <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005194:	85a6                	mv	a1,s1
    80005196:	854e                	mv	a0,s3
    80005198:	ad6fd0ef          	jal	8000246e <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000519c:	2184a703          	lw	a4,536(s1)
    800051a0:	21c4a783          	lw	a5,540(s1)
    800051a4:	fef701e3          	beq	a4,a5,80005186 <piperead+0x34>
    800051a8:	e85a                	sd	s6,16(sp)
    800051aa:	a809                	j	800051bc <piperead+0x6a>
    800051ac:	e85a                	sd	s6,16(sp)
    800051ae:	a039                	j	800051bc <piperead+0x6a>
      release(&pi->lock);
    800051b0:	8526                	mv	a0,s1
    800051b2:	b0dfb0ef          	jal	80000cbe <release>
      return -1;
    800051b6:	59fd                	li	s3,-1
    800051b8:	a8b1                	j	80005214 <piperead+0xc2>
    800051ba:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051bc:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051be:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051c0:	05505263          	blez	s5,80005204 <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    800051c4:	2184a783          	lw	a5,536(s1)
    800051c8:	21c4a703          	lw	a4,540(s1)
    800051cc:	02f70c63          	beq	a4,a5,80005204 <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800051d0:	0017871b          	addiw	a4,a5,1
    800051d4:	20e4ac23          	sw	a4,536(s1)
    800051d8:	1ff7f793          	andi	a5,a5,511
    800051dc:	97a6                	add	a5,a5,s1
    800051de:	0187c783          	lbu	a5,24(a5)
    800051e2:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800051e6:	4685                	li	a3,1
    800051e8:	fbf40613          	addi	a2,s0,-65
    800051ec:	85ca                	mv	a1,s2
    800051ee:	060a3503          	ld	a0,96(s4)
    800051f2:	b92fc0ef          	jal	80001584 <copyout>
    800051f6:	01650763          	beq	a0,s6,80005204 <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800051fa:	2985                	addiw	s3,s3,1
    800051fc:	0905                	addi	s2,s2,1
    800051fe:	fd3a93e3          	bne	s5,s3,800051c4 <piperead+0x72>
    80005202:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80005204:	21c48513          	addi	a0,s1,540
    80005208:	ab2fd0ef          	jal	800024ba <wakeup>
  release(&pi->lock);
    8000520c:	8526                	mv	a0,s1
    8000520e:	ab1fb0ef          	jal	80000cbe <release>
    80005212:	6b42                	ld	s6,16(sp)
  return i;
}
    80005214:	854e                	mv	a0,s3
    80005216:	60a6                	ld	ra,72(sp)
    80005218:	6406                	ld	s0,64(sp)
    8000521a:	74e2                	ld	s1,56(sp)
    8000521c:	7942                	ld	s2,48(sp)
    8000521e:	79a2                	ld	s3,40(sp)
    80005220:	7a02                	ld	s4,32(sp)
    80005222:	6ae2                	ld	s5,24(sp)
    80005224:	6161                	addi	sp,sp,80
    80005226:	8082                	ret

0000000080005228 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005228:	1141                	addi	sp,sp,-16
    8000522a:	e422                	sd	s0,8(sp)
    8000522c:	0800                	addi	s0,sp,16
    8000522e:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005230:	8905                	andi	a0,a0,1
    80005232:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    80005234:	8b89                	andi	a5,a5,2
    80005236:	c399                	beqz	a5,8000523c <flags2perm+0x14>
      perm |= PTE_W;
    80005238:	00456513          	ori	a0,a0,4
    return perm;
}
    8000523c:	6422                	ld	s0,8(sp)
    8000523e:	0141                	addi	sp,sp,16
    80005240:	8082                	ret

0000000080005242 <exec>:

int
exec(char *path, char **argv)
{
    80005242:	df010113          	addi	sp,sp,-528
    80005246:	20113423          	sd	ra,520(sp)
    8000524a:	20813023          	sd	s0,512(sp)
    8000524e:	ffa6                	sd	s1,504(sp)
    80005250:	fbca                	sd	s2,496(sp)
    80005252:	0c00                	addi	s0,sp,528
    80005254:	892a                	mv	s2,a0
    80005256:	dea43c23          	sd	a0,-520(s0)
    8000525a:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000525e:	9c9fc0ef          	jal	80001c26 <myproc>
    80005262:	84aa                	mv	s1,a0

  begin_op();
    80005264:	dc6ff0ef          	jal	8000482a <begin_op>

  if((ip = namei(path)) == 0){
    80005268:	854a                	mv	a0,s2
    8000526a:	c04ff0ef          	jal	8000466e <namei>
    8000526e:	c931                	beqz	a0,800052c2 <exec+0x80>
    80005270:	f3d2                	sd	s4,480(sp)
    80005272:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80005274:	d21fe0ef          	jal	80003f94 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005278:	04000713          	li	a4,64
    8000527c:	4681                	li	a3,0
    8000527e:	e5040613          	addi	a2,s0,-432
    80005282:	4581                	li	a1,0
    80005284:	8552                	mv	a0,s4
    80005286:	f63fe0ef          	jal	800041e8 <readi>
    8000528a:	04000793          	li	a5,64
    8000528e:	00f51a63          	bne	a0,a5,800052a2 <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005292:	e5042703          	lw	a4,-432(s0)
    80005296:	464c47b7          	lui	a5,0x464c4
    8000529a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000529e:	02f70663          	beq	a4,a5,800052ca <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800052a2:	8552                	mv	a0,s4
    800052a4:	efbfe0ef          	jal	8000419e <iunlockput>
    end_op();
    800052a8:	decff0ef          	jal	80004894 <end_op>
  }
  return -1;
    800052ac:	557d                	li	a0,-1
    800052ae:	7a1e                	ld	s4,480(sp)
}
    800052b0:	20813083          	ld	ra,520(sp)
    800052b4:	20013403          	ld	s0,512(sp)
    800052b8:	74fe                	ld	s1,504(sp)
    800052ba:	795e                	ld	s2,496(sp)
    800052bc:	21010113          	addi	sp,sp,528
    800052c0:	8082                	ret
    end_op();
    800052c2:	dd2ff0ef          	jal	80004894 <end_op>
    return -1;
    800052c6:	557d                	li	a0,-1
    800052c8:	b7e5                	j	800052b0 <exec+0x6e>
    800052ca:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800052cc:	8526                	mv	a0,s1
    800052ce:	a03fc0ef          	jal	80001cd0 <proc_pagetable>
    800052d2:	8b2a                	mv	s6,a0
    800052d4:	2c050b63          	beqz	a0,800055aa <exec+0x368>
    800052d8:	f7ce                	sd	s3,488(sp)
    800052da:	efd6                	sd	s5,472(sp)
    800052dc:	e7de                	sd	s7,456(sp)
    800052de:	e3e2                	sd	s8,448(sp)
    800052e0:	ff66                	sd	s9,440(sp)
    800052e2:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052e4:	e7042d03          	lw	s10,-400(s0)
    800052e8:	e8845783          	lhu	a5,-376(s0)
    800052ec:	12078963          	beqz	a5,8000541e <exec+0x1dc>
    800052f0:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800052f2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800052f4:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800052f6:	6c85                	lui	s9,0x1
    800052f8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800052fc:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005300:	6a85                	lui	s5,0x1
    80005302:	a085                	j	80005362 <exec+0x120>
      panic("loadseg: address should exist");
    80005304:	00003517          	auipc	a0,0x3
    80005308:	38c50513          	addi	a0,a0,908 # 80008690 <etext+0x690>
    8000530c:	cbafb0ef          	jal	800007c6 <panic>
    if(sz - i < PGSIZE)
    80005310:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005312:	8726                	mv	a4,s1
    80005314:	012c06bb          	addw	a3,s8,s2
    80005318:	4581                	li	a1,0
    8000531a:	8552                	mv	a0,s4
    8000531c:	ecdfe0ef          	jal	800041e8 <readi>
    80005320:	2501                	sext.w	a0,a0
    80005322:	24a49a63          	bne	s1,a0,80005576 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80005326:	012a893b          	addw	s2,s5,s2
    8000532a:	03397363          	bgeu	s2,s3,80005350 <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    8000532e:	02091593          	slli	a1,s2,0x20
    80005332:	9181                	srli	a1,a1,0x20
    80005334:	95de                	add	a1,a1,s7
    80005336:	855a                	mv	a0,s6
    80005338:	cd1fb0ef          	jal	80001008 <walkaddr>
    8000533c:	862a                	mv	a2,a0
    if(pa == 0)
    8000533e:	d179                	beqz	a0,80005304 <exec+0xc2>
    if(sz - i < PGSIZE)
    80005340:	412984bb          	subw	s1,s3,s2
    80005344:	0004879b          	sext.w	a5,s1
    80005348:	fcfcf4e3          	bgeu	s9,a5,80005310 <exec+0xce>
    8000534c:	84d6                	mv	s1,s5
    8000534e:	b7c9                	j	80005310 <exec+0xce>
    sz = sz1;
    80005350:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005354:	2d85                	addiw	s11,s11,1
    80005356:	038d0d1b          	addiw	s10,s10,56
    8000535a:	e8845783          	lhu	a5,-376(s0)
    8000535e:	08fdd063          	bge	s11,a5,800053de <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005362:	2d01                	sext.w	s10,s10
    80005364:	03800713          	li	a4,56
    80005368:	86ea                	mv	a3,s10
    8000536a:	e1840613          	addi	a2,s0,-488
    8000536e:	4581                	li	a1,0
    80005370:	8552                	mv	a0,s4
    80005372:	e77fe0ef          	jal	800041e8 <readi>
    80005376:	03800793          	li	a5,56
    8000537a:	1cf51663          	bne	a0,a5,80005546 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    8000537e:	e1842783          	lw	a5,-488(s0)
    80005382:	4705                	li	a4,1
    80005384:	fce798e3          	bne	a5,a4,80005354 <exec+0x112>
    if(ph.memsz < ph.filesz)
    80005388:	e4043483          	ld	s1,-448(s0)
    8000538c:	e3843783          	ld	a5,-456(s0)
    80005390:	1af4ef63          	bltu	s1,a5,8000554e <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005394:	e2843783          	ld	a5,-472(s0)
    80005398:	94be                	add	s1,s1,a5
    8000539a:	1af4ee63          	bltu	s1,a5,80005556 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    8000539e:	df043703          	ld	a4,-528(s0)
    800053a2:	8ff9                	and	a5,a5,a4
    800053a4:	1a079d63          	bnez	a5,8000555e <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800053a8:	e1c42503          	lw	a0,-484(s0)
    800053ac:	e7dff0ef          	jal	80005228 <flags2perm>
    800053b0:	86aa                	mv	a3,a0
    800053b2:	8626                	mv	a2,s1
    800053b4:	85ca                	mv	a1,s2
    800053b6:	855a                	mv	a0,s6
    800053b8:	fb9fb0ef          	jal	80001370 <uvmalloc>
    800053bc:	e0a43423          	sd	a0,-504(s0)
    800053c0:	1a050363          	beqz	a0,80005566 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800053c4:	e2843b83          	ld	s7,-472(s0)
    800053c8:	e2042c03          	lw	s8,-480(s0)
    800053cc:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800053d0:	00098463          	beqz	s3,800053d8 <exec+0x196>
    800053d4:	4901                	li	s2,0
    800053d6:	bfa1                	j	8000532e <exec+0xec>
    sz = sz1;
    800053d8:	e0843903          	ld	s2,-504(s0)
    800053dc:	bfa5                	j	80005354 <exec+0x112>
    800053de:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800053e0:	8552                	mv	a0,s4
    800053e2:	dbdfe0ef          	jal	8000419e <iunlockput>
  end_op();
    800053e6:	caeff0ef          	jal	80004894 <end_op>
  p = myproc();
    800053ea:	83dfc0ef          	jal	80001c26 <myproc>
    800053ee:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800053f0:	05853c83          	ld	s9,88(a0)
  sz = PGROUNDUP(sz);
    800053f4:	6985                	lui	s3,0x1
    800053f6:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800053f8:	99ca                	add	s3,s3,s2
    800053fa:	77fd                	lui	a5,0xfffff
    800053fc:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80005400:	4691                	li	a3,4
    80005402:	6609                	lui	a2,0x2
    80005404:	964e                	add	a2,a2,s3
    80005406:	85ce                	mv	a1,s3
    80005408:	855a                	mv	a0,s6
    8000540a:	f67fb0ef          	jal	80001370 <uvmalloc>
    8000540e:	892a                	mv	s2,a0
    80005410:	e0a43423          	sd	a0,-504(s0)
    80005414:	e519                	bnez	a0,80005422 <exec+0x1e0>
  if(pagetable)
    80005416:	e1343423          	sd	s3,-504(s0)
    8000541a:	4a01                	li	s4,0
    8000541c:	aab1                	j	80005578 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000541e:	4901                	li	s2,0
    80005420:	b7c1                	j	800053e0 <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80005422:	75f9                	lui	a1,0xffffe
    80005424:	95aa                	add	a1,a1,a0
    80005426:	855a                	mv	a0,s6
    80005428:	932fc0ef          	jal	8000155a <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    8000542c:	7bfd                	lui	s7,0xfffff
    8000542e:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    80005430:	e0043783          	ld	a5,-512(s0)
    80005434:	6388                	ld	a0,0(a5)
    80005436:	cd39                	beqz	a0,80005494 <exec+0x252>
    80005438:	e9040993          	addi	s3,s0,-368
    8000543c:	f9040c13          	addi	s8,s0,-112
    80005440:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    80005442:	a29fb0ef          	jal	80000e6a <strlen>
    80005446:	0015079b          	addiw	a5,a0,1
    8000544a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000544e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80005452:	11796e63          	bltu	s2,s7,8000556e <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005456:	e0043d03          	ld	s10,-512(s0)
    8000545a:	000d3a03          	ld	s4,0(s10)
    8000545e:	8552                	mv	a0,s4
    80005460:	a0bfb0ef          	jal	80000e6a <strlen>
    80005464:	0015069b          	addiw	a3,a0,1
    80005468:	8652                	mv	a2,s4
    8000546a:	85ca                	mv	a1,s2
    8000546c:	855a                	mv	a0,s6
    8000546e:	916fc0ef          	jal	80001584 <copyout>
    80005472:	10054063          	bltz	a0,80005572 <exec+0x330>
    ustack[argc] = sp;
    80005476:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000547a:	0485                	addi	s1,s1,1
    8000547c:	008d0793          	addi	a5,s10,8
    80005480:	e0f43023          	sd	a5,-512(s0)
    80005484:	008d3503          	ld	a0,8(s10)
    80005488:	c909                	beqz	a0,8000549a <exec+0x258>
    if(argc >= MAXARG)
    8000548a:	09a1                	addi	s3,s3,8
    8000548c:	fb899be3          	bne	s3,s8,80005442 <exec+0x200>
  ip = 0;
    80005490:	4a01                	li	s4,0
    80005492:	a0dd                	j	80005578 <exec+0x336>
  sp = sz;
    80005494:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005498:	4481                	li	s1,0
  ustack[argc] = 0;
    8000549a:	00349793          	slli	a5,s1,0x3
    8000549e:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffd9748>
    800054a2:	97a2                	add	a5,a5,s0
    800054a4:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800054a8:	00148693          	addi	a3,s1,1
    800054ac:	068e                	slli	a3,a3,0x3
    800054ae:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800054b2:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800054b6:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    800054ba:	f5796ee3          	bltu	s2,s7,80005416 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800054be:	e9040613          	addi	a2,s0,-368
    800054c2:	85ca                	mv	a1,s2
    800054c4:	855a                	mv	a0,s6
    800054c6:	8befc0ef          	jal	80001584 <copyout>
    800054ca:	0e054263          	bltz	a0,800055ae <exec+0x36c>
  p->trapframe->a1 = sp;
    800054ce:	068ab783          	ld	a5,104(s5) # 1068 <_entry-0x7fffef98>
    800054d2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800054d6:	df843783          	ld	a5,-520(s0)
    800054da:	0007c703          	lbu	a4,0(a5)
    800054de:	cf11                	beqz	a4,800054fa <exec+0x2b8>
    800054e0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800054e2:	02f00693          	li	a3,47
    800054e6:	a039                	j	800054f4 <exec+0x2b2>
      last = s+1;
    800054e8:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800054ec:	0785                	addi	a5,a5,1
    800054ee:	fff7c703          	lbu	a4,-1(a5)
    800054f2:	c701                	beqz	a4,800054fa <exec+0x2b8>
    if(*s == '/')
    800054f4:	fed71ce3          	bne	a4,a3,800054ec <exec+0x2aa>
    800054f8:	bfc5                	j	800054e8 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    800054fa:	4641                	li	a2,16
    800054fc:	df843583          	ld	a1,-520(s0)
    80005500:	168a8513          	addi	a0,s5,360
    80005504:	935fb0ef          	jal	80000e38 <safestrcpy>
  oldpagetable = p->pagetable;
    80005508:	060ab503          	ld	a0,96(s5)
  p->pagetable = pagetable;
    8000550c:	076ab023          	sd	s6,96(s5)
  p->sz = sz;
    80005510:	e0843783          	ld	a5,-504(s0)
    80005514:	04fabc23          	sd	a5,88(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005518:	068ab783          	ld	a5,104(s5)
    8000551c:	e6843703          	ld	a4,-408(s0)
    80005520:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005522:	068ab783          	ld	a5,104(s5)
    80005526:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000552a:	85e6                	mv	a1,s9
    8000552c:	829fc0ef          	jal	80001d54 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005530:	0004851b          	sext.w	a0,s1
    80005534:	79be                	ld	s3,488(sp)
    80005536:	7a1e                	ld	s4,480(sp)
    80005538:	6afe                	ld	s5,472(sp)
    8000553a:	6b5e                	ld	s6,464(sp)
    8000553c:	6bbe                	ld	s7,456(sp)
    8000553e:	6c1e                	ld	s8,448(sp)
    80005540:	7cfa                	ld	s9,440(sp)
    80005542:	7d5a                	ld	s10,432(sp)
    80005544:	b3b5                	j	800052b0 <exec+0x6e>
    80005546:	e1243423          	sd	s2,-504(s0)
    8000554a:	7dba                	ld	s11,424(sp)
    8000554c:	a035                	j	80005578 <exec+0x336>
    8000554e:	e1243423          	sd	s2,-504(s0)
    80005552:	7dba                	ld	s11,424(sp)
    80005554:	a015                	j	80005578 <exec+0x336>
    80005556:	e1243423          	sd	s2,-504(s0)
    8000555a:	7dba                	ld	s11,424(sp)
    8000555c:	a831                	j	80005578 <exec+0x336>
    8000555e:	e1243423          	sd	s2,-504(s0)
    80005562:	7dba                	ld	s11,424(sp)
    80005564:	a811                	j	80005578 <exec+0x336>
    80005566:	e1243423          	sd	s2,-504(s0)
    8000556a:	7dba                	ld	s11,424(sp)
    8000556c:	a031                	j	80005578 <exec+0x336>
  ip = 0;
    8000556e:	4a01                	li	s4,0
    80005570:	a021                	j	80005578 <exec+0x336>
    80005572:	4a01                	li	s4,0
  if(pagetable)
    80005574:	a011                	j	80005578 <exec+0x336>
    80005576:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80005578:	e0843583          	ld	a1,-504(s0)
    8000557c:	855a                	mv	a0,s6
    8000557e:	fd6fc0ef          	jal	80001d54 <proc_freepagetable>
  return -1;
    80005582:	557d                	li	a0,-1
  if(ip){
    80005584:	000a1b63          	bnez	s4,8000559a <exec+0x358>
    80005588:	79be                	ld	s3,488(sp)
    8000558a:	7a1e                	ld	s4,480(sp)
    8000558c:	6afe                	ld	s5,472(sp)
    8000558e:	6b5e                	ld	s6,464(sp)
    80005590:	6bbe                	ld	s7,456(sp)
    80005592:	6c1e                	ld	s8,448(sp)
    80005594:	7cfa                	ld	s9,440(sp)
    80005596:	7d5a                	ld	s10,432(sp)
    80005598:	bb21                	j	800052b0 <exec+0x6e>
    8000559a:	79be                	ld	s3,488(sp)
    8000559c:	6afe                	ld	s5,472(sp)
    8000559e:	6b5e                	ld	s6,464(sp)
    800055a0:	6bbe                	ld	s7,456(sp)
    800055a2:	6c1e                	ld	s8,448(sp)
    800055a4:	7cfa                	ld	s9,440(sp)
    800055a6:	7d5a                	ld	s10,432(sp)
    800055a8:	b9ed                	j	800052a2 <exec+0x60>
    800055aa:	6b5e                	ld	s6,464(sp)
    800055ac:	b9dd                	j	800052a2 <exec+0x60>
  sz = sz1;
    800055ae:	e0843983          	ld	s3,-504(s0)
    800055b2:	b595                	j	80005416 <exec+0x1d4>

00000000800055b4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800055b4:	7179                	addi	sp,sp,-48
    800055b6:	f406                	sd	ra,40(sp)
    800055b8:	f022                	sd	s0,32(sp)
    800055ba:	ec26                	sd	s1,24(sp)
    800055bc:	e84a                	sd	s2,16(sp)
    800055be:	1800                	addi	s0,sp,48
    800055c0:	892e                	mv	s2,a1
    800055c2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800055c4:	fdc40593          	addi	a1,s0,-36
    800055c8:	ef7fd0ef          	jal	800034be <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800055cc:	fdc42703          	lw	a4,-36(s0)
    800055d0:	47bd                	li	a5,15
    800055d2:	02e7e963          	bltu	a5,a4,80005604 <argfd+0x50>
    800055d6:	e50fc0ef          	jal	80001c26 <myproc>
    800055da:	fdc42703          	lw	a4,-36(s0)
    800055de:	01c70793          	addi	a5,a4,28
    800055e2:	078e                	slli	a5,a5,0x3
    800055e4:	953e                	add	a0,a0,a5
    800055e6:	611c                	ld	a5,0(a0)
    800055e8:	c385                	beqz	a5,80005608 <argfd+0x54>
    return -1;
  if(pfd)
    800055ea:	00090463          	beqz	s2,800055f2 <argfd+0x3e>
    *pfd = fd;
    800055ee:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800055f2:	4501                	li	a0,0
  if(pf)
    800055f4:	c091                	beqz	s1,800055f8 <argfd+0x44>
    *pf = f;
    800055f6:	e09c                	sd	a5,0(s1)
}
    800055f8:	70a2                	ld	ra,40(sp)
    800055fa:	7402                	ld	s0,32(sp)
    800055fc:	64e2                	ld	s1,24(sp)
    800055fe:	6942                	ld	s2,16(sp)
    80005600:	6145                	addi	sp,sp,48
    80005602:	8082                	ret
    return -1;
    80005604:	557d                	li	a0,-1
    80005606:	bfcd                	j	800055f8 <argfd+0x44>
    80005608:	557d                	li	a0,-1
    8000560a:	b7fd                	j	800055f8 <argfd+0x44>

000000008000560c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000560c:	1101                	addi	sp,sp,-32
    8000560e:	ec06                	sd	ra,24(sp)
    80005610:	e822                	sd	s0,16(sp)
    80005612:	e426                	sd	s1,8(sp)
    80005614:	1000                	addi	s0,sp,32
    80005616:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005618:	e0efc0ef          	jal	80001c26 <myproc>
    8000561c:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000561e:	0e050793          	addi	a5,a0,224
    80005622:	4501                	li	a0,0
    80005624:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005626:	6398                	ld	a4,0(a5)
    80005628:	cb19                	beqz	a4,8000563e <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000562a:	2505                	addiw	a0,a0,1
    8000562c:	07a1                	addi	a5,a5,8
    8000562e:	fed51ce3          	bne	a0,a3,80005626 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005632:	557d                	li	a0,-1
}
    80005634:	60e2                	ld	ra,24(sp)
    80005636:	6442                	ld	s0,16(sp)
    80005638:	64a2                	ld	s1,8(sp)
    8000563a:	6105                	addi	sp,sp,32
    8000563c:	8082                	ret
      p->ofile[fd] = f;
    8000563e:	01c50793          	addi	a5,a0,28
    80005642:	078e                	slli	a5,a5,0x3
    80005644:	963e                	add	a2,a2,a5
    80005646:	e204                	sd	s1,0(a2)
      return fd;
    80005648:	b7f5                	j	80005634 <fdalloc+0x28>

000000008000564a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000564a:	715d                	addi	sp,sp,-80
    8000564c:	e486                	sd	ra,72(sp)
    8000564e:	e0a2                	sd	s0,64(sp)
    80005650:	fc26                	sd	s1,56(sp)
    80005652:	f84a                	sd	s2,48(sp)
    80005654:	f44e                	sd	s3,40(sp)
    80005656:	ec56                	sd	s5,24(sp)
    80005658:	e85a                	sd	s6,16(sp)
    8000565a:	0880                	addi	s0,sp,80
    8000565c:	8b2e                	mv	s6,a1
    8000565e:	89b2                	mv	s3,a2
    80005660:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005662:	fb040593          	addi	a1,s0,-80
    80005666:	822ff0ef          	jal	80004688 <nameiparent>
    8000566a:	84aa                	mv	s1,a0
    8000566c:	10050a63          	beqz	a0,80005780 <create+0x136>
    return 0;

  ilock(dp);
    80005670:	925fe0ef          	jal	80003f94 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005674:	4601                	li	a2,0
    80005676:	fb040593          	addi	a1,s0,-80
    8000567a:	8526                	mv	a0,s1
    8000567c:	d8dfe0ef          	jal	80004408 <dirlookup>
    80005680:	8aaa                	mv	s5,a0
    80005682:	c129                	beqz	a0,800056c4 <create+0x7a>
    iunlockput(dp);
    80005684:	8526                	mv	a0,s1
    80005686:	b19fe0ef          	jal	8000419e <iunlockput>
    ilock(ip);
    8000568a:	8556                	mv	a0,s5
    8000568c:	909fe0ef          	jal	80003f94 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80005690:	4789                	li	a5,2
    80005692:	02fb1463          	bne	s6,a5,800056ba <create+0x70>
    80005696:	044ad783          	lhu	a5,68(s5)
    8000569a:	37f9                	addiw	a5,a5,-2
    8000569c:	17c2                	slli	a5,a5,0x30
    8000569e:	93c1                	srli	a5,a5,0x30
    800056a0:	4705                	li	a4,1
    800056a2:	00f76c63          	bltu	a4,a5,800056ba <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800056a6:	8556                	mv	a0,s5
    800056a8:	60a6                	ld	ra,72(sp)
    800056aa:	6406                	ld	s0,64(sp)
    800056ac:	74e2                	ld	s1,56(sp)
    800056ae:	7942                	ld	s2,48(sp)
    800056b0:	79a2                	ld	s3,40(sp)
    800056b2:	6ae2                	ld	s5,24(sp)
    800056b4:	6b42                	ld	s6,16(sp)
    800056b6:	6161                	addi	sp,sp,80
    800056b8:	8082                	ret
    iunlockput(ip);
    800056ba:	8556                	mv	a0,s5
    800056bc:	ae3fe0ef          	jal	8000419e <iunlockput>
    return 0;
    800056c0:	4a81                	li	s5,0
    800056c2:	b7d5                	j	800056a6 <create+0x5c>
    800056c4:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800056c6:	85da                	mv	a1,s6
    800056c8:	4088                	lw	a0,0(s1)
    800056ca:	f5afe0ef          	jal	80003e24 <ialloc>
    800056ce:	8a2a                	mv	s4,a0
    800056d0:	cd15                	beqz	a0,8000570c <create+0xc2>
  ilock(ip);
    800056d2:	8c3fe0ef          	jal	80003f94 <ilock>
  ip->major = major;
    800056d6:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800056da:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800056de:	4905                	li	s2,1
    800056e0:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800056e4:	8552                	mv	a0,s4
    800056e6:	ffafe0ef          	jal	80003ee0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800056ea:	032b0763          	beq	s6,s2,80005718 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800056ee:	004a2603          	lw	a2,4(s4)
    800056f2:	fb040593          	addi	a1,s0,-80
    800056f6:	8526                	mv	a0,s1
    800056f8:	eddfe0ef          	jal	800045d4 <dirlink>
    800056fc:	06054563          	bltz	a0,80005766 <create+0x11c>
  iunlockput(dp);
    80005700:	8526                	mv	a0,s1
    80005702:	a9dfe0ef          	jal	8000419e <iunlockput>
  return ip;
    80005706:	8ad2                	mv	s5,s4
    80005708:	7a02                	ld	s4,32(sp)
    8000570a:	bf71                	j	800056a6 <create+0x5c>
    iunlockput(dp);
    8000570c:	8526                	mv	a0,s1
    8000570e:	a91fe0ef          	jal	8000419e <iunlockput>
    return 0;
    80005712:	8ad2                	mv	s5,s4
    80005714:	7a02                	ld	s4,32(sp)
    80005716:	bf41                	j	800056a6 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005718:	004a2603          	lw	a2,4(s4)
    8000571c:	00003597          	auipc	a1,0x3
    80005720:	f9458593          	addi	a1,a1,-108 # 800086b0 <etext+0x6b0>
    80005724:	8552                	mv	a0,s4
    80005726:	eaffe0ef          	jal	800045d4 <dirlink>
    8000572a:	02054e63          	bltz	a0,80005766 <create+0x11c>
    8000572e:	40d0                	lw	a2,4(s1)
    80005730:	00003597          	auipc	a1,0x3
    80005734:	f8858593          	addi	a1,a1,-120 # 800086b8 <etext+0x6b8>
    80005738:	8552                	mv	a0,s4
    8000573a:	e9bfe0ef          	jal	800045d4 <dirlink>
    8000573e:	02054463          	bltz	a0,80005766 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005742:	004a2603          	lw	a2,4(s4)
    80005746:	fb040593          	addi	a1,s0,-80
    8000574a:	8526                	mv	a0,s1
    8000574c:	e89fe0ef          	jal	800045d4 <dirlink>
    80005750:	00054b63          	bltz	a0,80005766 <create+0x11c>
    dp->nlink++;  // for ".."
    80005754:	04a4d783          	lhu	a5,74(s1)
    80005758:	2785                	addiw	a5,a5,1
    8000575a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000575e:	8526                	mv	a0,s1
    80005760:	f80fe0ef          	jal	80003ee0 <iupdate>
    80005764:	bf71                	j	80005700 <create+0xb6>
  ip->nlink = 0;
    80005766:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000576a:	8552                	mv	a0,s4
    8000576c:	f74fe0ef          	jal	80003ee0 <iupdate>
  iunlockput(ip);
    80005770:	8552                	mv	a0,s4
    80005772:	a2dfe0ef          	jal	8000419e <iunlockput>
  iunlockput(dp);
    80005776:	8526                	mv	a0,s1
    80005778:	a27fe0ef          	jal	8000419e <iunlockput>
  return 0;
    8000577c:	7a02                	ld	s4,32(sp)
    8000577e:	b725                	j	800056a6 <create+0x5c>
    return 0;
    80005780:	8aaa                	mv	s5,a0
    80005782:	b715                	j	800056a6 <create+0x5c>

0000000080005784 <sys_dup>:
{
    80005784:	7179                	addi	sp,sp,-48
    80005786:	f406                	sd	ra,40(sp)
    80005788:	f022                	sd	s0,32(sp)
    8000578a:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000578c:	fd840613          	addi	a2,s0,-40
    80005790:	4581                	li	a1,0
    80005792:	4501                	li	a0,0
    80005794:	e21ff0ef          	jal	800055b4 <argfd>
    return -1;
    80005798:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000579a:	02054363          	bltz	a0,800057c0 <sys_dup+0x3c>
    8000579e:	ec26                	sd	s1,24(sp)
    800057a0:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800057a2:	fd843903          	ld	s2,-40(s0)
    800057a6:	854a                	mv	a0,s2
    800057a8:	e65ff0ef          	jal	8000560c <fdalloc>
    800057ac:	84aa                	mv	s1,a0
    return -1;
    800057ae:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800057b0:	00054d63          	bltz	a0,800057ca <sys_dup+0x46>
  filedup(f);
    800057b4:	854a                	mv	a0,s2
    800057b6:	c48ff0ef          	jal	80004bfe <filedup>
  return fd;
    800057ba:	87a6                	mv	a5,s1
    800057bc:	64e2                	ld	s1,24(sp)
    800057be:	6942                	ld	s2,16(sp)
}
    800057c0:	853e                	mv	a0,a5
    800057c2:	70a2                	ld	ra,40(sp)
    800057c4:	7402                	ld	s0,32(sp)
    800057c6:	6145                	addi	sp,sp,48
    800057c8:	8082                	ret
    800057ca:	64e2                	ld	s1,24(sp)
    800057cc:	6942                	ld	s2,16(sp)
    800057ce:	bfcd                	j	800057c0 <sys_dup+0x3c>

00000000800057d0 <sys_read>:
{
    800057d0:	7179                	addi	sp,sp,-48
    800057d2:	f406                	sd	ra,40(sp)
    800057d4:	f022                	sd	s0,32(sp)
    800057d6:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800057d8:	fd840593          	addi	a1,s0,-40
    800057dc:	4505                	li	a0,1
    800057de:	cfdfd0ef          	jal	800034da <argaddr>
  argint(2, &n);
    800057e2:	fe440593          	addi	a1,s0,-28
    800057e6:	4509                	li	a0,2
    800057e8:	cd7fd0ef          	jal	800034be <argint>
  if(argfd(0, 0, &f) < 0)
    800057ec:	fe840613          	addi	a2,s0,-24
    800057f0:	4581                	li	a1,0
    800057f2:	4501                	li	a0,0
    800057f4:	dc1ff0ef          	jal	800055b4 <argfd>
    800057f8:	87aa                	mv	a5,a0
    return -1;
    800057fa:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800057fc:	0007ca63          	bltz	a5,80005810 <sys_read+0x40>
  return fileread(f, p, n);
    80005800:	fe442603          	lw	a2,-28(s0)
    80005804:	fd843583          	ld	a1,-40(s0)
    80005808:	fe843503          	ld	a0,-24(s0)
    8000580c:	d58ff0ef          	jal	80004d64 <fileread>
}
    80005810:	70a2                	ld	ra,40(sp)
    80005812:	7402                	ld	s0,32(sp)
    80005814:	6145                	addi	sp,sp,48
    80005816:	8082                	ret

0000000080005818 <sys_write>:
{
    80005818:	7179                	addi	sp,sp,-48
    8000581a:	f406                	sd	ra,40(sp)
    8000581c:	f022                	sd	s0,32(sp)
    8000581e:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005820:	fd840593          	addi	a1,s0,-40
    80005824:	4505                	li	a0,1
    80005826:	cb5fd0ef          	jal	800034da <argaddr>
  argint(2, &n);
    8000582a:	fe440593          	addi	a1,s0,-28
    8000582e:	4509                	li	a0,2
    80005830:	c8ffd0ef          	jal	800034be <argint>
  if(argfd(0, 0, &f) < 0)
    80005834:	fe840613          	addi	a2,s0,-24
    80005838:	4581                	li	a1,0
    8000583a:	4501                	li	a0,0
    8000583c:	d79ff0ef          	jal	800055b4 <argfd>
    80005840:	87aa                	mv	a5,a0
    return -1;
    80005842:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005844:	0007ca63          	bltz	a5,80005858 <sys_write+0x40>
  return filewrite(f, p, n);
    80005848:	fe442603          	lw	a2,-28(s0)
    8000584c:	fd843583          	ld	a1,-40(s0)
    80005850:	fe843503          	ld	a0,-24(s0)
    80005854:	dceff0ef          	jal	80004e22 <filewrite>
}
    80005858:	70a2                	ld	ra,40(sp)
    8000585a:	7402                	ld	s0,32(sp)
    8000585c:	6145                	addi	sp,sp,48
    8000585e:	8082                	ret

0000000080005860 <sys_close>:
{
    80005860:	1101                	addi	sp,sp,-32
    80005862:	ec06                	sd	ra,24(sp)
    80005864:	e822                	sd	s0,16(sp)
    80005866:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005868:	fe040613          	addi	a2,s0,-32
    8000586c:	fec40593          	addi	a1,s0,-20
    80005870:	4501                	li	a0,0
    80005872:	d43ff0ef          	jal	800055b4 <argfd>
    return -1;
    80005876:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005878:	02054063          	bltz	a0,80005898 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    8000587c:	baafc0ef          	jal	80001c26 <myproc>
    80005880:	fec42783          	lw	a5,-20(s0)
    80005884:	07f1                	addi	a5,a5,28
    80005886:	078e                	slli	a5,a5,0x3
    80005888:	953e                	add	a0,a0,a5
    8000588a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000588e:	fe043503          	ld	a0,-32(s0)
    80005892:	bb2ff0ef          	jal	80004c44 <fileclose>
  return 0;
    80005896:	4781                	li	a5,0
}
    80005898:	853e                	mv	a0,a5
    8000589a:	60e2                	ld	ra,24(sp)
    8000589c:	6442                	ld	s0,16(sp)
    8000589e:	6105                	addi	sp,sp,32
    800058a0:	8082                	ret

00000000800058a2 <sys_fstat>:
{
    800058a2:	1101                	addi	sp,sp,-32
    800058a4:	ec06                	sd	ra,24(sp)
    800058a6:	e822                	sd	s0,16(sp)
    800058a8:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800058aa:	fe040593          	addi	a1,s0,-32
    800058ae:	4505                	li	a0,1
    800058b0:	c2bfd0ef          	jal	800034da <argaddr>
  if(argfd(0, 0, &f) < 0)
    800058b4:	fe840613          	addi	a2,s0,-24
    800058b8:	4581                	li	a1,0
    800058ba:	4501                	li	a0,0
    800058bc:	cf9ff0ef          	jal	800055b4 <argfd>
    800058c0:	87aa                	mv	a5,a0
    return -1;
    800058c2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800058c4:	0007c863          	bltz	a5,800058d4 <sys_fstat+0x32>
  return filestat(f, st);
    800058c8:	fe043583          	ld	a1,-32(s0)
    800058cc:	fe843503          	ld	a0,-24(s0)
    800058d0:	c36ff0ef          	jal	80004d06 <filestat>
}
    800058d4:	60e2                	ld	ra,24(sp)
    800058d6:	6442                	ld	s0,16(sp)
    800058d8:	6105                	addi	sp,sp,32
    800058da:	8082                	ret

00000000800058dc <sys_link>:
{
    800058dc:	7169                	addi	sp,sp,-304
    800058de:	f606                	sd	ra,296(sp)
    800058e0:	f222                	sd	s0,288(sp)
    800058e2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800058e4:	08000613          	li	a2,128
    800058e8:	ed040593          	addi	a1,s0,-304
    800058ec:	4501                	li	a0,0
    800058ee:	c09fd0ef          	jal	800034f6 <argstr>
    return -1;
    800058f2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800058f4:	0c054e63          	bltz	a0,800059d0 <sys_link+0xf4>
    800058f8:	08000613          	li	a2,128
    800058fc:	f5040593          	addi	a1,s0,-176
    80005900:	4505                	li	a0,1
    80005902:	bf5fd0ef          	jal	800034f6 <argstr>
    return -1;
    80005906:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005908:	0c054463          	bltz	a0,800059d0 <sys_link+0xf4>
    8000590c:	ee26                	sd	s1,280(sp)
  begin_op();
    8000590e:	f1dfe0ef          	jal	8000482a <begin_op>
  if((ip = namei(old)) == 0){
    80005912:	ed040513          	addi	a0,s0,-304
    80005916:	d59fe0ef          	jal	8000466e <namei>
    8000591a:	84aa                	mv	s1,a0
    8000591c:	c53d                	beqz	a0,8000598a <sys_link+0xae>
  ilock(ip);
    8000591e:	e76fe0ef          	jal	80003f94 <ilock>
  if(ip->type == T_DIR){
    80005922:	04449703          	lh	a4,68(s1)
    80005926:	4785                	li	a5,1
    80005928:	06f70663          	beq	a4,a5,80005994 <sys_link+0xb8>
    8000592c:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000592e:	04a4d783          	lhu	a5,74(s1)
    80005932:	2785                	addiw	a5,a5,1
    80005934:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005938:	8526                	mv	a0,s1
    8000593a:	da6fe0ef          	jal	80003ee0 <iupdate>
  iunlock(ip);
    8000593e:	8526                	mv	a0,s1
    80005940:	f02fe0ef          	jal	80004042 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005944:	fd040593          	addi	a1,s0,-48
    80005948:	f5040513          	addi	a0,s0,-176
    8000594c:	d3dfe0ef          	jal	80004688 <nameiparent>
    80005950:	892a                	mv	s2,a0
    80005952:	cd21                	beqz	a0,800059aa <sys_link+0xce>
  ilock(dp);
    80005954:	e40fe0ef          	jal	80003f94 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005958:	00092703          	lw	a4,0(s2)
    8000595c:	409c                	lw	a5,0(s1)
    8000595e:	04f71363          	bne	a4,a5,800059a4 <sys_link+0xc8>
    80005962:	40d0                	lw	a2,4(s1)
    80005964:	fd040593          	addi	a1,s0,-48
    80005968:	854a                	mv	a0,s2
    8000596a:	c6bfe0ef          	jal	800045d4 <dirlink>
    8000596e:	02054b63          	bltz	a0,800059a4 <sys_link+0xc8>
  iunlockput(dp);
    80005972:	854a                	mv	a0,s2
    80005974:	82bfe0ef          	jal	8000419e <iunlockput>
  iput(ip);
    80005978:	8526                	mv	a0,s1
    8000597a:	f9cfe0ef          	jal	80004116 <iput>
  end_op();
    8000597e:	f17fe0ef          	jal	80004894 <end_op>
  return 0;
    80005982:	4781                	li	a5,0
    80005984:	64f2                	ld	s1,280(sp)
    80005986:	6952                	ld	s2,272(sp)
    80005988:	a0a1                	j	800059d0 <sys_link+0xf4>
    end_op();
    8000598a:	f0bfe0ef          	jal	80004894 <end_op>
    return -1;
    8000598e:	57fd                	li	a5,-1
    80005990:	64f2                	ld	s1,280(sp)
    80005992:	a83d                	j	800059d0 <sys_link+0xf4>
    iunlockput(ip);
    80005994:	8526                	mv	a0,s1
    80005996:	809fe0ef          	jal	8000419e <iunlockput>
    end_op();
    8000599a:	efbfe0ef          	jal	80004894 <end_op>
    return -1;
    8000599e:	57fd                	li	a5,-1
    800059a0:	64f2                	ld	s1,280(sp)
    800059a2:	a03d                	j	800059d0 <sys_link+0xf4>
    iunlockput(dp);
    800059a4:	854a                	mv	a0,s2
    800059a6:	ff8fe0ef          	jal	8000419e <iunlockput>
  ilock(ip);
    800059aa:	8526                	mv	a0,s1
    800059ac:	de8fe0ef          	jal	80003f94 <ilock>
  ip->nlink--;
    800059b0:	04a4d783          	lhu	a5,74(s1)
    800059b4:	37fd                	addiw	a5,a5,-1
    800059b6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800059ba:	8526                	mv	a0,s1
    800059bc:	d24fe0ef          	jal	80003ee0 <iupdate>
  iunlockput(ip);
    800059c0:	8526                	mv	a0,s1
    800059c2:	fdcfe0ef          	jal	8000419e <iunlockput>
  end_op();
    800059c6:	ecffe0ef          	jal	80004894 <end_op>
  return -1;
    800059ca:	57fd                	li	a5,-1
    800059cc:	64f2                	ld	s1,280(sp)
    800059ce:	6952                	ld	s2,272(sp)
}
    800059d0:	853e                	mv	a0,a5
    800059d2:	70b2                	ld	ra,296(sp)
    800059d4:	7412                	ld	s0,288(sp)
    800059d6:	6155                	addi	sp,sp,304
    800059d8:	8082                	ret

00000000800059da <sys_unlink>:
{
    800059da:	7151                	addi	sp,sp,-240
    800059dc:	f586                	sd	ra,232(sp)
    800059de:	f1a2                	sd	s0,224(sp)
    800059e0:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800059e2:	08000613          	li	a2,128
    800059e6:	f3040593          	addi	a1,s0,-208
    800059ea:	4501                	li	a0,0
    800059ec:	b0bfd0ef          	jal	800034f6 <argstr>
    800059f0:	16054063          	bltz	a0,80005b50 <sys_unlink+0x176>
    800059f4:	eda6                	sd	s1,216(sp)
  begin_op();
    800059f6:	e35fe0ef          	jal	8000482a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800059fa:	fb040593          	addi	a1,s0,-80
    800059fe:	f3040513          	addi	a0,s0,-208
    80005a02:	c87fe0ef          	jal	80004688 <nameiparent>
    80005a06:	84aa                	mv	s1,a0
    80005a08:	c945                	beqz	a0,80005ab8 <sys_unlink+0xde>
  ilock(dp);
    80005a0a:	d8afe0ef          	jal	80003f94 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005a0e:	00003597          	auipc	a1,0x3
    80005a12:	ca258593          	addi	a1,a1,-862 # 800086b0 <etext+0x6b0>
    80005a16:	fb040513          	addi	a0,s0,-80
    80005a1a:	9d9fe0ef          	jal	800043f2 <namecmp>
    80005a1e:	10050e63          	beqz	a0,80005b3a <sys_unlink+0x160>
    80005a22:	00003597          	auipc	a1,0x3
    80005a26:	c9658593          	addi	a1,a1,-874 # 800086b8 <etext+0x6b8>
    80005a2a:	fb040513          	addi	a0,s0,-80
    80005a2e:	9c5fe0ef          	jal	800043f2 <namecmp>
    80005a32:	10050463          	beqz	a0,80005b3a <sys_unlink+0x160>
    80005a36:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005a38:	f2c40613          	addi	a2,s0,-212
    80005a3c:	fb040593          	addi	a1,s0,-80
    80005a40:	8526                	mv	a0,s1
    80005a42:	9c7fe0ef          	jal	80004408 <dirlookup>
    80005a46:	892a                	mv	s2,a0
    80005a48:	0e050863          	beqz	a0,80005b38 <sys_unlink+0x15e>
  ilock(ip);
    80005a4c:	d48fe0ef          	jal	80003f94 <ilock>
  if(ip->nlink < 1)
    80005a50:	04a91783          	lh	a5,74(s2)
    80005a54:	06f05763          	blez	a5,80005ac2 <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005a58:	04491703          	lh	a4,68(s2)
    80005a5c:	4785                	li	a5,1
    80005a5e:	06f70963          	beq	a4,a5,80005ad0 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80005a62:	4641                	li	a2,16
    80005a64:	4581                	li	a1,0
    80005a66:	fc040513          	addi	a0,s0,-64
    80005a6a:	a90fb0ef          	jal	80000cfa <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005a6e:	4741                	li	a4,16
    80005a70:	f2c42683          	lw	a3,-212(s0)
    80005a74:	fc040613          	addi	a2,s0,-64
    80005a78:	4581                	li	a1,0
    80005a7a:	8526                	mv	a0,s1
    80005a7c:	869fe0ef          	jal	800042e4 <writei>
    80005a80:	47c1                	li	a5,16
    80005a82:	08f51b63          	bne	a0,a5,80005b18 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80005a86:	04491703          	lh	a4,68(s2)
    80005a8a:	4785                	li	a5,1
    80005a8c:	08f70d63          	beq	a4,a5,80005b26 <sys_unlink+0x14c>
  iunlockput(dp);
    80005a90:	8526                	mv	a0,s1
    80005a92:	f0cfe0ef          	jal	8000419e <iunlockput>
  ip->nlink--;
    80005a96:	04a95783          	lhu	a5,74(s2)
    80005a9a:	37fd                	addiw	a5,a5,-1
    80005a9c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005aa0:	854a                	mv	a0,s2
    80005aa2:	c3efe0ef          	jal	80003ee0 <iupdate>
  iunlockput(ip);
    80005aa6:	854a                	mv	a0,s2
    80005aa8:	ef6fe0ef          	jal	8000419e <iunlockput>
  end_op();
    80005aac:	de9fe0ef          	jal	80004894 <end_op>
  return 0;
    80005ab0:	4501                	li	a0,0
    80005ab2:	64ee                	ld	s1,216(sp)
    80005ab4:	694e                	ld	s2,208(sp)
    80005ab6:	a849                	j	80005b48 <sys_unlink+0x16e>
    end_op();
    80005ab8:	dddfe0ef          	jal	80004894 <end_op>
    return -1;
    80005abc:	557d                	li	a0,-1
    80005abe:	64ee                	ld	s1,216(sp)
    80005ac0:	a061                	j	80005b48 <sys_unlink+0x16e>
    80005ac2:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80005ac4:	00003517          	auipc	a0,0x3
    80005ac8:	bfc50513          	addi	a0,a0,-1028 # 800086c0 <etext+0x6c0>
    80005acc:	cfbfa0ef          	jal	800007c6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005ad0:	04c92703          	lw	a4,76(s2)
    80005ad4:	02000793          	li	a5,32
    80005ad8:	f8e7f5e3          	bgeu	a5,a4,80005a62 <sys_unlink+0x88>
    80005adc:	e5ce                	sd	s3,200(sp)
    80005ade:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005ae2:	4741                	li	a4,16
    80005ae4:	86ce                	mv	a3,s3
    80005ae6:	f1840613          	addi	a2,s0,-232
    80005aea:	4581                	li	a1,0
    80005aec:	854a                	mv	a0,s2
    80005aee:	efafe0ef          	jal	800041e8 <readi>
    80005af2:	47c1                	li	a5,16
    80005af4:	00f51c63          	bne	a0,a5,80005b0c <sys_unlink+0x132>
    if(de.inum != 0)
    80005af8:	f1845783          	lhu	a5,-232(s0)
    80005afc:	efa1                	bnez	a5,80005b54 <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005afe:	29c1                	addiw	s3,s3,16
    80005b00:	04c92783          	lw	a5,76(s2)
    80005b04:	fcf9efe3          	bltu	s3,a5,80005ae2 <sys_unlink+0x108>
    80005b08:	69ae                	ld	s3,200(sp)
    80005b0a:	bfa1                	j	80005a62 <sys_unlink+0x88>
      panic("isdirempty: readi");
    80005b0c:	00003517          	auipc	a0,0x3
    80005b10:	bcc50513          	addi	a0,a0,-1076 # 800086d8 <etext+0x6d8>
    80005b14:	cb3fa0ef          	jal	800007c6 <panic>
    80005b18:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80005b1a:	00003517          	auipc	a0,0x3
    80005b1e:	bd650513          	addi	a0,a0,-1066 # 800086f0 <etext+0x6f0>
    80005b22:	ca5fa0ef          	jal	800007c6 <panic>
    dp->nlink--;
    80005b26:	04a4d783          	lhu	a5,74(s1)
    80005b2a:	37fd                	addiw	a5,a5,-1
    80005b2c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005b30:	8526                	mv	a0,s1
    80005b32:	baefe0ef          	jal	80003ee0 <iupdate>
    80005b36:	bfa9                	j	80005a90 <sys_unlink+0xb6>
    80005b38:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005b3a:	8526                	mv	a0,s1
    80005b3c:	e62fe0ef          	jal	8000419e <iunlockput>
  end_op();
    80005b40:	d55fe0ef          	jal	80004894 <end_op>
  return -1;
    80005b44:	557d                	li	a0,-1
    80005b46:	64ee                	ld	s1,216(sp)
}
    80005b48:	70ae                	ld	ra,232(sp)
    80005b4a:	740e                	ld	s0,224(sp)
    80005b4c:	616d                	addi	sp,sp,240
    80005b4e:	8082                	ret
    return -1;
    80005b50:	557d                	li	a0,-1
    80005b52:	bfdd                	j	80005b48 <sys_unlink+0x16e>
    iunlockput(ip);
    80005b54:	854a                	mv	a0,s2
    80005b56:	e48fe0ef          	jal	8000419e <iunlockput>
    goto bad;
    80005b5a:	694e                	ld	s2,208(sp)
    80005b5c:	69ae                	ld	s3,200(sp)
    80005b5e:	bff1                	j	80005b3a <sys_unlink+0x160>

0000000080005b60 <sys_open>:

uint64
sys_open(void)
{
    80005b60:	7131                	addi	sp,sp,-192
    80005b62:	fd06                	sd	ra,184(sp)
    80005b64:	f922                	sd	s0,176(sp)
    80005b66:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005b68:	f4c40593          	addi	a1,s0,-180
    80005b6c:	4505                	li	a0,1
    80005b6e:	951fd0ef          	jal	800034be <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005b72:	08000613          	li	a2,128
    80005b76:	f5040593          	addi	a1,s0,-176
    80005b7a:	4501                	li	a0,0
    80005b7c:	97bfd0ef          	jal	800034f6 <argstr>
    80005b80:	87aa                	mv	a5,a0
    return -1;
    80005b82:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005b84:	0a07c263          	bltz	a5,80005c28 <sys_open+0xc8>
    80005b88:	f526                	sd	s1,168(sp)

  begin_op();
    80005b8a:	ca1fe0ef          	jal	8000482a <begin_op>

  if(omode & O_CREATE){
    80005b8e:	f4c42783          	lw	a5,-180(s0)
    80005b92:	2007f793          	andi	a5,a5,512
    80005b96:	c3d5                	beqz	a5,80005c3a <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80005b98:	4681                	li	a3,0
    80005b9a:	4601                	li	a2,0
    80005b9c:	4589                	li	a1,2
    80005b9e:	f5040513          	addi	a0,s0,-176
    80005ba2:	aa9ff0ef          	jal	8000564a <create>
    80005ba6:	84aa                	mv	s1,a0
    if(ip == 0){
    80005ba8:	c541                	beqz	a0,80005c30 <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005baa:	04449703          	lh	a4,68(s1)
    80005bae:	478d                	li	a5,3
    80005bb0:	00f71763          	bne	a4,a5,80005bbe <sys_open+0x5e>
    80005bb4:	0464d703          	lhu	a4,70(s1)
    80005bb8:	47a5                	li	a5,9
    80005bba:	0ae7ed63          	bltu	a5,a4,80005c74 <sys_open+0x114>
    80005bbe:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005bc0:	fe1fe0ef          	jal	80004ba0 <filealloc>
    80005bc4:	892a                	mv	s2,a0
    80005bc6:	c179                	beqz	a0,80005c8c <sys_open+0x12c>
    80005bc8:	ed4e                	sd	s3,152(sp)
    80005bca:	a43ff0ef          	jal	8000560c <fdalloc>
    80005bce:	89aa                	mv	s3,a0
    80005bd0:	0a054a63          	bltz	a0,80005c84 <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005bd4:	04449703          	lh	a4,68(s1)
    80005bd8:	478d                	li	a5,3
    80005bda:	0cf70263          	beq	a4,a5,80005c9e <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005bde:	4789                	li	a5,2
    80005be0:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005be4:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005be8:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005bec:	f4c42783          	lw	a5,-180(s0)
    80005bf0:	0017c713          	xori	a4,a5,1
    80005bf4:	8b05                	andi	a4,a4,1
    80005bf6:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005bfa:	0037f713          	andi	a4,a5,3
    80005bfe:	00e03733          	snez	a4,a4
    80005c02:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005c06:	4007f793          	andi	a5,a5,1024
    80005c0a:	c791                	beqz	a5,80005c16 <sys_open+0xb6>
    80005c0c:	04449703          	lh	a4,68(s1)
    80005c10:	4789                	li	a5,2
    80005c12:	08f70d63          	beq	a4,a5,80005cac <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    80005c16:	8526                	mv	a0,s1
    80005c18:	c2afe0ef          	jal	80004042 <iunlock>
  end_op();
    80005c1c:	c79fe0ef          	jal	80004894 <end_op>

  return fd;
    80005c20:	854e                	mv	a0,s3
    80005c22:	74aa                	ld	s1,168(sp)
    80005c24:	790a                	ld	s2,160(sp)
    80005c26:	69ea                	ld	s3,152(sp)
}
    80005c28:	70ea                	ld	ra,184(sp)
    80005c2a:	744a                	ld	s0,176(sp)
    80005c2c:	6129                	addi	sp,sp,192
    80005c2e:	8082                	ret
      end_op();
    80005c30:	c65fe0ef          	jal	80004894 <end_op>
      return -1;
    80005c34:	557d                	li	a0,-1
    80005c36:	74aa                	ld	s1,168(sp)
    80005c38:	bfc5                	j	80005c28 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80005c3a:	f5040513          	addi	a0,s0,-176
    80005c3e:	a31fe0ef          	jal	8000466e <namei>
    80005c42:	84aa                	mv	s1,a0
    80005c44:	c11d                	beqz	a0,80005c6a <sys_open+0x10a>
    ilock(ip);
    80005c46:	b4efe0ef          	jal	80003f94 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005c4a:	04449703          	lh	a4,68(s1)
    80005c4e:	4785                	li	a5,1
    80005c50:	f4f71de3          	bne	a4,a5,80005baa <sys_open+0x4a>
    80005c54:	f4c42783          	lw	a5,-180(s0)
    80005c58:	d3bd                	beqz	a5,80005bbe <sys_open+0x5e>
      iunlockput(ip);
    80005c5a:	8526                	mv	a0,s1
    80005c5c:	d42fe0ef          	jal	8000419e <iunlockput>
      end_op();
    80005c60:	c35fe0ef          	jal	80004894 <end_op>
      return -1;
    80005c64:	557d                	li	a0,-1
    80005c66:	74aa                	ld	s1,168(sp)
    80005c68:	b7c1                	j	80005c28 <sys_open+0xc8>
      end_op();
    80005c6a:	c2bfe0ef          	jal	80004894 <end_op>
      return -1;
    80005c6e:	557d                	li	a0,-1
    80005c70:	74aa                	ld	s1,168(sp)
    80005c72:	bf5d                	j	80005c28 <sys_open+0xc8>
    iunlockput(ip);
    80005c74:	8526                	mv	a0,s1
    80005c76:	d28fe0ef          	jal	8000419e <iunlockput>
    end_op();
    80005c7a:	c1bfe0ef          	jal	80004894 <end_op>
    return -1;
    80005c7e:	557d                	li	a0,-1
    80005c80:	74aa                	ld	s1,168(sp)
    80005c82:	b75d                	j	80005c28 <sys_open+0xc8>
      fileclose(f);
    80005c84:	854a                	mv	a0,s2
    80005c86:	fbffe0ef          	jal	80004c44 <fileclose>
    80005c8a:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005c8c:	8526                	mv	a0,s1
    80005c8e:	d10fe0ef          	jal	8000419e <iunlockput>
    end_op();
    80005c92:	c03fe0ef          	jal	80004894 <end_op>
    return -1;
    80005c96:	557d                	li	a0,-1
    80005c98:	74aa                	ld	s1,168(sp)
    80005c9a:	790a                	ld	s2,160(sp)
    80005c9c:	b771                	j	80005c28 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80005c9e:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005ca2:	04649783          	lh	a5,70(s1)
    80005ca6:	02f91223          	sh	a5,36(s2)
    80005caa:	bf3d                	j	80005be8 <sys_open+0x88>
    itrunc(ip);
    80005cac:	8526                	mv	a0,s1
    80005cae:	bd4fe0ef          	jal	80004082 <itrunc>
    80005cb2:	b795                	j	80005c16 <sys_open+0xb6>

0000000080005cb4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005cb4:	7175                	addi	sp,sp,-144
    80005cb6:	e506                	sd	ra,136(sp)
    80005cb8:	e122                	sd	s0,128(sp)
    80005cba:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005cbc:	b6ffe0ef          	jal	8000482a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005cc0:	08000613          	li	a2,128
    80005cc4:	f7040593          	addi	a1,s0,-144
    80005cc8:	4501                	li	a0,0
    80005cca:	82dfd0ef          	jal	800034f6 <argstr>
    80005cce:	02054363          	bltz	a0,80005cf4 <sys_mkdir+0x40>
    80005cd2:	4681                	li	a3,0
    80005cd4:	4601                	li	a2,0
    80005cd6:	4585                	li	a1,1
    80005cd8:	f7040513          	addi	a0,s0,-144
    80005cdc:	96fff0ef          	jal	8000564a <create>
    80005ce0:	c911                	beqz	a0,80005cf4 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005ce2:	cbcfe0ef          	jal	8000419e <iunlockput>
  end_op();
    80005ce6:	baffe0ef          	jal	80004894 <end_op>
  return 0;
    80005cea:	4501                	li	a0,0
}
    80005cec:	60aa                	ld	ra,136(sp)
    80005cee:	640a                	ld	s0,128(sp)
    80005cf0:	6149                	addi	sp,sp,144
    80005cf2:	8082                	ret
    end_op();
    80005cf4:	ba1fe0ef          	jal	80004894 <end_op>
    return -1;
    80005cf8:	557d                	li	a0,-1
    80005cfa:	bfcd                	j	80005cec <sys_mkdir+0x38>

0000000080005cfc <sys_mknod>:

uint64
sys_mknod(void)
{
    80005cfc:	7135                	addi	sp,sp,-160
    80005cfe:	ed06                	sd	ra,152(sp)
    80005d00:	e922                	sd	s0,144(sp)
    80005d02:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005d04:	b27fe0ef          	jal	8000482a <begin_op>
  argint(1, &major);
    80005d08:	f6c40593          	addi	a1,s0,-148
    80005d0c:	4505                	li	a0,1
    80005d0e:	fb0fd0ef          	jal	800034be <argint>
  argint(2, &minor);
    80005d12:	f6840593          	addi	a1,s0,-152
    80005d16:	4509                	li	a0,2
    80005d18:	fa6fd0ef          	jal	800034be <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d1c:	08000613          	li	a2,128
    80005d20:	f7040593          	addi	a1,s0,-144
    80005d24:	4501                	li	a0,0
    80005d26:	fd0fd0ef          	jal	800034f6 <argstr>
    80005d2a:	02054563          	bltz	a0,80005d54 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005d2e:	f6841683          	lh	a3,-152(s0)
    80005d32:	f6c41603          	lh	a2,-148(s0)
    80005d36:	458d                	li	a1,3
    80005d38:	f7040513          	addi	a0,s0,-144
    80005d3c:	90fff0ef          	jal	8000564a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005d40:	c911                	beqz	a0,80005d54 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005d42:	c5cfe0ef          	jal	8000419e <iunlockput>
  end_op();
    80005d46:	b4ffe0ef          	jal	80004894 <end_op>
  return 0;
    80005d4a:	4501                	li	a0,0
}
    80005d4c:	60ea                	ld	ra,152(sp)
    80005d4e:	644a                	ld	s0,144(sp)
    80005d50:	610d                	addi	sp,sp,160
    80005d52:	8082                	ret
    end_op();
    80005d54:	b41fe0ef          	jal	80004894 <end_op>
    return -1;
    80005d58:	557d                	li	a0,-1
    80005d5a:	bfcd                	j	80005d4c <sys_mknod+0x50>

0000000080005d5c <sys_chdir>:

uint64
sys_chdir(void)
{
    80005d5c:	7135                	addi	sp,sp,-160
    80005d5e:	ed06                	sd	ra,152(sp)
    80005d60:	e922                	sd	s0,144(sp)
    80005d62:	e14a                	sd	s2,128(sp)
    80005d64:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005d66:	ec1fb0ef          	jal	80001c26 <myproc>
    80005d6a:	892a                	mv	s2,a0
  
  begin_op();
    80005d6c:	abffe0ef          	jal	8000482a <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005d70:	08000613          	li	a2,128
    80005d74:	f6040593          	addi	a1,s0,-160
    80005d78:	4501                	li	a0,0
    80005d7a:	f7cfd0ef          	jal	800034f6 <argstr>
    80005d7e:	04054363          	bltz	a0,80005dc4 <sys_chdir+0x68>
    80005d82:	e526                	sd	s1,136(sp)
    80005d84:	f6040513          	addi	a0,s0,-160
    80005d88:	8e7fe0ef          	jal	8000466e <namei>
    80005d8c:	84aa                	mv	s1,a0
    80005d8e:	c915                	beqz	a0,80005dc2 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005d90:	a04fe0ef          	jal	80003f94 <ilock>
  if(ip->type != T_DIR){
    80005d94:	04449703          	lh	a4,68(s1)
    80005d98:	4785                	li	a5,1
    80005d9a:	02f71963          	bne	a4,a5,80005dcc <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005d9e:	8526                	mv	a0,s1
    80005da0:	aa2fe0ef          	jal	80004042 <iunlock>
  iput(p->cwd);
    80005da4:	16093503          	ld	a0,352(s2)
    80005da8:	b6efe0ef          	jal	80004116 <iput>
  end_op();
    80005dac:	ae9fe0ef          	jal	80004894 <end_op>
  p->cwd = ip;
    80005db0:	16993023          	sd	s1,352(s2)
  return 0;
    80005db4:	4501                	li	a0,0
    80005db6:	64aa                	ld	s1,136(sp)
}
    80005db8:	60ea                	ld	ra,152(sp)
    80005dba:	644a                	ld	s0,144(sp)
    80005dbc:	690a                	ld	s2,128(sp)
    80005dbe:	610d                	addi	sp,sp,160
    80005dc0:	8082                	ret
    80005dc2:	64aa                	ld	s1,136(sp)
    end_op();
    80005dc4:	ad1fe0ef          	jal	80004894 <end_op>
    return -1;
    80005dc8:	557d                	li	a0,-1
    80005dca:	b7fd                	j	80005db8 <sys_chdir+0x5c>
    iunlockput(ip);
    80005dcc:	8526                	mv	a0,s1
    80005dce:	bd0fe0ef          	jal	8000419e <iunlockput>
    end_op();
    80005dd2:	ac3fe0ef          	jal	80004894 <end_op>
    return -1;
    80005dd6:	557d                	li	a0,-1
    80005dd8:	64aa                	ld	s1,136(sp)
    80005dda:	bff9                	j	80005db8 <sys_chdir+0x5c>

0000000080005ddc <sys_exec>:

uint64
sys_exec(void)
{
    80005ddc:	7121                	addi	sp,sp,-448
    80005dde:	ff06                	sd	ra,440(sp)
    80005de0:	fb22                	sd	s0,432(sp)
    80005de2:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005de4:	e4840593          	addi	a1,s0,-440
    80005de8:	4505                	li	a0,1
    80005dea:	ef0fd0ef          	jal	800034da <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005dee:	08000613          	li	a2,128
    80005df2:	f5040593          	addi	a1,s0,-176
    80005df6:	4501                	li	a0,0
    80005df8:	efefd0ef          	jal	800034f6 <argstr>
    80005dfc:	87aa                	mv	a5,a0
    return -1;
    80005dfe:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005e00:	0c07c463          	bltz	a5,80005ec8 <sys_exec+0xec>
    80005e04:	f726                	sd	s1,424(sp)
    80005e06:	f34a                	sd	s2,416(sp)
    80005e08:	ef4e                	sd	s3,408(sp)
    80005e0a:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005e0c:	10000613          	li	a2,256
    80005e10:	4581                	li	a1,0
    80005e12:	e5040513          	addi	a0,s0,-432
    80005e16:	ee5fa0ef          	jal	80000cfa <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005e1a:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005e1e:	89a6                	mv	s3,s1
    80005e20:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005e22:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005e26:	00391513          	slli	a0,s2,0x3
    80005e2a:	e4040593          	addi	a1,s0,-448
    80005e2e:	e4843783          	ld	a5,-440(s0)
    80005e32:	953e                	add	a0,a0,a5
    80005e34:	e00fd0ef          	jal	80003434 <fetchaddr>
    80005e38:	02054663          	bltz	a0,80005e64 <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005e3c:	e4043783          	ld	a5,-448(s0)
    80005e40:	c3a9                	beqz	a5,80005e82 <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005e42:	d15fa0ef          	jal	80000b56 <kalloc>
    80005e46:	85aa                	mv	a1,a0
    80005e48:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005e4c:	cd01                	beqz	a0,80005e64 <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005e4e:	6605                	lui	a2,0x1
    80005e50:	e4043503          	ld	a0,-448(s0)
    80005e54:	e2afd0ef          	jal	8000347e <fetchstr>
    80005e58:	00054663          	bltz	a0,80005e64 <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80005e5c:	0905                	addi	s2,s2,1
    80005e5e:	09a1                	addi	s3,s3,8
    80005e60:	fd4913e3          	bne	s2,s4,80005e26 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e64:	f5040913          	addi	s2,s0,-176
    80005e68:	6088                	ld	a0,0(s1)
    80005e6a:	c931                	beqz	a0,80005ebe <sys_exec+0xe2>
    kfree(argv[i]);
    80005e6c:	c09fa0ef          	jal	80000a74 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005e70:	04a1                	addi	s1,s1,8
    80005e72:	ff249be3          	bne	s1,s2,80005e68 <sys_exec+0x8c>
  return -1;
    80005e76:	557d                	li	a0,-1
    80005e78:	74ba                	ld	s1,424(sp)
    80005e7a:	791a                	ld	s2,416(sp)
    80005e7c:	69fa                	ld	s3,408(sp)
    80005e7e:	6a5a                	ld	s4,400(sp)
    80005e80:	a0a1                	j	80005ec8 <sys_exec+0xec>
      argv[i] = 0;
    80005e82:	0009079b          	sext.w	a5,s2
    80005e86:	078e                	slli	a5,a5,0x3
    80005e88:	fd078793          	addi	a5,a5,-48
    80005e8c:	97a2                	add	a5,a5,s0
    80005e8e:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005e92:	e5040593          	addi	a1,s0,-432
    80005e96:	f5040513          	addi	a0,s0,-176
    80005e9a:	ba8ff0ef          	jal	80005242 <exec>
    80005e9e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ea0:	f5040993          	addi	s3,s0,-176
    80005ea4:	6088                	ld	a0,0(s1)
    80005ea6:	c511                	beqz	a0,80005eb2 <sys_exec+0xd6>
    kfree(argv[i]);
    80005ea8:	bcdfa0ef          	jal	80000a74 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005eac:	04a1                	addi	s1,s1,8
    80005eae:	ff349be3          	bne	s1,s3,80005ea4 <sys_exec+0xc8>
  return ret;
    80005eb2:	854a                	mv	a0,s2
    80005eb4:	74ba                	ld	s1,424(sp)
    80005eb6:	791a                	ld	s2,416(sp)
    80005eb8:	69fa                	ld	s3,408(sp)
    80005eba:	6a5a                	ld	s4,400(sp)
    80005ebc:	a031                	j	80005ec8 <sys_exec+0xec>
  return -1;
    80005ebe:	557d                	li	a0,-1
    80005ec0:	74ba                	ld	s1,424(sp)
    80005ec2:	791a                	ld	s2,416(sp)
    80005ec4:	69fa                	ld	s3,408(sp)
    80005ec6:	6a5a                	ld	s4,400(sp)
}
    80005ec8:	70fa                	ld	ra,440(sp)
    80005eca:	745a                	ld	s0,432(sp)
    80005ecc:	6139                	addi	sp,sp,448
    80005ece:	8082                	ret

0000000080005ed0 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005ed0:	7139                	addi	sp,sp,-64
    80005ed2:	fc06                	sd	ra,56(sp)
    80005ed4:	f822                	sd	s0,48(sp)
    80005ed6:	f426                	sd	s1,40(sp)
    80005ed8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005eda:	d4dfb0ef          	jal	80001c26 <myproc>
    80005ede:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005ee0:	fd840593          	addi	a1,s0,-40
    80005ee4:	4501                	li	a0,0
    80005ee6:	df4fd0ef          	jal	800034da <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005eea:	fc840593          	addi	a1,s0,-56
    80005eee:	fd040513          	addi	a0,s0,-48
    80005ef2:	85cff0ef          	jal	80004f4e <pipealloc>
    return -1;
    80005ef6:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005ef8:	0a054463          	bltz	a0,80005fa0 <sys_pipe+0xd0>
  fd0 = -1;
    80005efc:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005f00:	fd043503          	ld	a0,-48(s0)
    80005f04:	f08ff0ef          	jal	8000560c <fdalloc>
    80005f08:	fca42223          	sw	a0,-60(s0)
    80005f0c:	08054163          	bltz	a0,80005f8e <sys_pipe+0xbe>
    80005f10:	fc843503          	ld	a0,-56(s0)
    80005f14:	ef8ff0ef          	jal	8000560c <fdalloc>
    80005f18:	fca42023          	sw	a0,-64(s0)
    80005f1c:	06054063          	bltz	a0,80005f7c <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005f20:	4691                	li	a3,4
    80005f22:	fc440613          	addi	a2,s0,-60
    80005f26:	fd843583          	ld	a1,-40(s0)
    80005f2a:	70a8                	ld	a0,96(s1)
    80005f2c:	e58fb0ef          	jal	80001584 <copyout>
    80005f30:	00054e63          	bltz	a0,80005f4c <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005f34:	4691                	li	a3,4
    80005f36:	fc040613          	addi	a2,s0,-64
    80005f3a:	fd843583          	ld	a1,-40(s0)
    80005f3e:	0591                	addi	a1,a1,4
    80005f40:	70a8                	ld	a0,96(s1)
    80005f42:	e42fb0ef          	jal	80001584 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005f46:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005f48:	04055c63          	bgez	a0,80005fa0 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005f4c:	fc442783          	lw	a5,-60(s0)
    80005f50:	07f1                	addi	a5,a5,28
    80005f52:	078e                	slli	a5,a5,0x3
    80005f54:	97a6                	add	a5,a5,s1
    80005f56:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80005f5a:	fc042783          	lw	a5,-64(s0)
    80005f5e:	07f1                	addi	a5,a5,28
    80005f60:	078e                	slli	a5,a5,0x3
    80005f62:	94be                	add	s1,s1,a5
    80005f64:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005f68:	fd043503          	ld	a0,-48(s0)
    80005f6c:	cd9fe0ef          	jal	80004c44 <fileclose>
    fileclose(wf);
    80005f70:	fc843503          	ld	a0,-56(s0)
    80005f74:	cd1fe0ef          	jal	80004c44 <fileclose>
    return -1;
    80005f78:	57fd                	li	a5,-1
    80005f7a:	a01d                	j	80005fa0 <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005f7c:	fc442783          	lw	a5,-60(s0)
    80005f80:	0007c763          	bltz	a5,80005f8e <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005f84:	07f1                	addi	a5,a5,28
    80005f86:	078e                	slli	a5,a5,0x3
    80005f88:	97a6                	add	a5,a5,s1
    80005f8a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80005f8e:	fd043503          	ld	a0,-48(s0)
    80005f92:	cb3fe0ef          	jal	80004c44 <fileclose>
    fileclose(wf);
    80005f96:	fc843503          	ld	a0,-56(s0)
    80005f9a:	cabfe0ef          	jal	80004c44 <fileclose>
    return -1;
    80005f9e:	57fd                	li	a5,-1
}
    80005fa0:	853e                	mv	a0,a5
    80005fa2:	70e2                	ld	ra,56(sp)
    80005fa4:	7442                	ld	s0,48(sp)
    80005fa6:	74a2                	ld	s1,40(sp)
    80005fa8:	6121                	addi	sp,sp,64
    80005faa:	8082                	ret
    80005fac:	0000                	unimp
	...

0000000080005fb0 <kernelvec>:
    80005fb0:	7111                	addi	sp,sp,-256
    80005fb2:	e006                	sd	ra,0(sp)
    80005fb4:	e40a                	sd	sp,8(sp)
    80005fb6:	e80e                	sd	gp,16(sp)
    80005fb8:	ec12                	sd	tp,24(sp)
    80005fba:	f016                	sd	t0,32(sp)
    80005fbc:	f41a                	sd	t1,40(sp)
    80005fbe:	f81e                	sd	t2,48(sp)
    80005fc0:	e4aa                	sd	a0,72(sp)
    80005fc2:	e8ae                	sd	a1,80(sp)
    80005fc4:	ecb2                	sd	a2,88(sp)
    80005fc6:	f0b6                	sd	a3,96(sp)
    80005fc8:	f4ba                	sd	a4,104(sp)
    80005fca:	f8be                	sd	a5,112(sp)
    80005fcc:	fcc2                	sd	a6,120(sp)
    80005fce:	e146                	sd	a7,128(sp)
    80005fd0:	edf2                	sd	t3,216(sp)
    80005fd2:	f1f6                	sd	t4,224(sp)
    80005fd4:	f5fa                	sd	t5,232(sp)
    80005fd6:	f9fe                	sd	t6,240(sp)
    80005fd8:	b62fd0ef          	jal	8000333a <kerneltrap>
    80005fdc:	6082                	ld	ra,0(sp)
    80005fde:	6122                	ld	sp,8(sp)
    80005fe0:	61c2                	ld	gp,16(sp)
    80005fe2:	7282                	ld	t0,32(sp)
    80005fe4:	7322                	ld	t1,40(sp)
    80005fe6:	73c2                	ld	t2,48(sp)
    80005fe8:	6526                	ld	a0,72(sp)
    80005fea:	65c6                	ld	a1,80(sp)
    80005fec:	6666                	ld	a2,88(sp)
    80005fee:	7686                	ld	a3,96(sp)
    80005ff0:	7726                	ld	a4,104(sp)
    80005ff2:	77c6                	ld	a5,112(sp)
    80005ff4:	7866                	ld	a6,120(sp)
    80005ff6:	688a                	ld	a7,128(sp)
    80005ff8:	6e6e                	ld	t3,216(sp)
    80005ffa:	7e8e                	ld	t4,224(sp)
    80005ffc:	7f2e                	ld	t5,232(sp)
    80005ffe:	7fce                	ld	t6,240(sp)
    80006000:	6111                	addi	sp,sp,256
    80006002:	10200073          	sret
	...

000000008000600e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000600e:	1141                	addi	sp,sp,-16
    80006010:	e422                	sd	s0,8(sp)
    80006012:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006014:	0c0007b7          	lui	a5,0xc000
    80006018:	4705                	li	a4,1
    8000601a:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000601c:	0c0007b7          	lui	a5,0xc000
    80006020:	c3d8                	sw	a4,4(a5)
}
    80006022:	6422                	ld	s0,8(sp)
    80006024:	0141                	addi	sp,sp,16
    80006026:	8082                	ret

0000000080006028 <plicinithart>:

void
plicinithart(void)
{
    80006028:	1141                	addi	sp,sp,-16
    8000602a:	e406                	sd	ra,8(sp)
    8000602c:	e022                	sd	s0,0(sp)
    8000602e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006030:	bcbfb0ef          	jal	80001bfa <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006034:	0085171b          	slliw	a4,a0,0x8
    80006038:	0c0027b7          	lui	a5,0xc002
    8000603c:	97ba                	add	a5,a5,a4
    8000603e:	40200713          	li	a4,1026
    80006042:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006046:	00d5151b          	slliw	a0,a0,0xd
    8000604a:	0c2017b7          	lui	a5,0xc201
    8000604e:	97aa                	add	a5,a5,a0
    80006050:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006054:	60a2                	ld	ra,8(sp)
    80006056:	6402                	ld	s0,0(sp)
    80006058:	0141                	addi	sp,sp,16
    8000605a:	8082                	ret

000000008000605c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000605c:	1141                	addi	sp,sp,-16
    8000605e:	e406                	sd	ra,8(sp)
    80006060:	e022                	sd	s0,0(sp)
    80006062:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006064:	b97fb0ef          	jal	80001bfa <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80006068:	00d5151b          	slliw	a0,a0,0xd
    8000606c:	0c2017b7          	lui	a5,0xc201
    80006070:	97aa                	add	a5,a5,a0
  return irq;
}
    80006072:	43c8                	lw	a0,4(a5)
    80006074:	60a2                	ld	ra,8(sp)
    80006076:	6402                	ld	s0,0(sp)
    80006078:	0141                	addi	sp,sp,16
    8000607a:	8082                	ret

000000008000607c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000607c:	1101                	addi	sp,sp,-32
    8000607e:	ec06                	sd	ra,24(sp)
    80006080:	e822                	sd	s0,16(sp)
    80006082:	e426                	sd	s1,8(sp)
    80006084:	1000                	addi	s0,sp,32
    80006086:	84aa                	mv	s1,a0
  int hart = cpuid();
    80006088:	b73fb0ef          	jal	80001bfa <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000608c:	00d5151b          	slliw	a0,a0,0xd
    80006090:	0c2017b7          	lui	a5,0xc201
    80006094:	97aa                	add	a5,a5,a0
    80006096:	c3c4                	sw	s1,4(a5)
}
    80006098:	60e2                	ld	ra,24(sp)
    8000609a:	6442                	ld	s0,16(sp)
    8000609c:	64a2                	ld	s1,8(sp)
    8000609e:	6105                	addi	sp,sp,32
    800060a0:	8082                	ret

00000000800060a2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800060a2:	1141                	addi	sp,sp,-16
    800060a4:	e406                	sd	ra,8(sp)
    800060a6:	e022                	sd	s0,0(sp)
    800060a8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800060aa:	479d                	li	a5,7
    800060ac:	04a7ca63          	blt	a5,a0,80006100 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800060b0:	0001f797          	auipc	a5,0x1f
    800060b4:	65878793          	addi	a5,a5,1624 # 80025708 <disk>
    800060b8:	97aa                	add	a5,a5,a0
    800060ba:	0187c783          	lbu	a5,24(a5)
    800060be:	e7b9                	bnez	a5,8000610c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800060c0:	00451693          	slli	a3,a0,0x4
    800060c4:	0001f797          	auipc	a5,0x1f
    800060c8:	64478793          	addi	a5,a5,1604 # 80025708 <disk>
    800060cc:	6398                	ld	a4,0(a5)
    800060ce:	9736                	add	a4,a4,a3
    800060d0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    800060d4:	6398                	ld	a4,0(a5)
    800060d6:	9736                	add	a4,a4,a3
    800060d8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800060dc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800060e0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800060e4:	97aa                	add	a5,a5,a0
    800060e6:	4705                	li	a4,1
    800060e8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800060ec:	0001f517          	auipc	a0,0x1f
    800060f0:	63450513          	addi	a0,a0,1588 # 80025720 <disk+0x18>
    800060f4:	bc6fc0ef          	jal	800024ba <wakeup>
}
    800060f8:	60a2                	ld	ra,8(sp)
    800060fa:	6402                	ld	s0,0(sp)
    800060fc:	0141                	addi	sp,sp,16
    800060fe:	8082                	ret
    panic("free_desc 1");
    80006100:	00002517          	auipc	a0,0x2
    80006104:	60050513          	addi	a0,a0,1536 # 80008700 <etext+0x700>
    80006108:	ebefa0ef          	jal	800007c6 <panic>
    panic("free_desc 2");
    8000610c:	00002517          	auipc	a0,0x2
    80006110:	60450513          	addi	a0,a0,1540 # 80008710 <etext+0x710>
    80006114:	eb2fa0ef          	jal	800007c6 <panic>

0000000080006118 <virtio_disk_init>:
{
    80006118:	1101                	addi	sp,sp,-32
    8000611a:	ec06                	sd	ra,24(sp)
    8000611c:	e822                	sd	s0,16(sp)
    8000611e:	e426                	sd	s1,8(sp)
    80006120:	e04a                	sd	s2,0(sp)
    80006122:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006124:	00002597          	auipc	a1,0x2
    80006128:	5fc58593          	addi	a1,a1,1532 # 80008720 <etext+0x720>
    8000612c:	0001f517          	auipc	a0,0x1f
    80006130:	70450513          	addi	a0,a0,1796 # 80025830 <disk+0x128>
    80006134:	a73fa0ef          	jal	80000ba6 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006138:	100017b7          	lui	a5,0x10001
    8000613c:	4398                	lw	a4,0(a5)
    8000613e:	2701                	sext.w	a4,a4
    80006140:	747277b7          	lui	a5,0x74727
    80006144:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006148:	18f71063          	bne	a4,a5,800062c8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000614c:	100017b7          	lui	a5,0x10001
    80006150:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80006152:	439c                	lw	a5,0(a5)
    80006154:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006156:	4709                	li	a4,2
    80006158:	16e79863          	bne	a5,a4,800062c8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000615c:	100017b7          	lui	a5,0x10001
    80006160:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80006162:	439c                	lw	a5,0(a5)
    80006164:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006166:	16e79163          	bne	a5,a4,800062c8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000616a:	100017b7          	lui	a5,0x10001
    8000616e:	47d8                	lw	a4,12(a5)
    80006170:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006172:	554d47b7          	lui	a5,0x554d4
    80006176:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000617a:	14f71763          	bne	a4,a5,800062c8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000617e:	100017b7          	lui	a5,0x10001
    80006182:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006186:	4705                	li	a4,1
    80006188:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000618a:	470d                	li	a4,3
    8000618c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000618e:	10001737          	lui	a4,0x10001
    80006192:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006194:	c7ffe737          	lui	a4,0xc7ffe
    80006198:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd8f17>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000619c:	8ef9                	and	a3,a3,a4
    8000619e:	10001737          	lui	a4,0x10001
    800061a2:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061a4:	472d                	li	a4,11
    800061a6:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800061a8:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800061ac:	439c                	lw	a5,0(a5)
    800061ae:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800061b2:	8ba1                	andi	a5,a5,8
    800061b4:	12078063          	beqz	a5,800062d4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800061b8:	100017b7          	lui	a5,0x10001
    800061bc:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800061c0:	100017b7          	lui	a5,0x10001
    800061c4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    800061c8:	439c                	lw	a5,0(a5)
    800061ca:	2781                	sext.w	a5,a5
    800061cc:	10079a63          	bnez	a5,800062e0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800061d0:	100017b7          	lui	a5,0x10001
    800061d4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    800061d8:	439c                	lw	a5,0(a5)
    800061da:	2781                	sext.w	a5,a5
  if(max == 0)
    800061dc:	10078863          	beqz	a5,800062ec <virtio_disk_init+0x1d4>
  if(max < NUM)
    800061e0:	471d                	li	a4,7
    800061e2:	10f77b63          	bgeu	a4,a5,800062f8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    800061e6:	971fa0ef          	jal	80000b56 <kalloc>
    800061ea:	0001f497          	auipc	s1,0x1f
    800061ee:	51e48493          	addi	s1,s1,1310 # 80025708 <disk>
    800061f2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800061f4:	963fa0ef          	jal	80000b56 <kalloc>
    800061f8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800061fa:	95dfa0ef          	jal	80000b56 <kalloc>
    800061fe:	87aa                	mv	a5,a0
    80006200:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006202:	6088                	ld	a0,0(s1)
    80006204:	10050063          	beqz	a0,80006304 <virtio_disk_init+0x1ec>
    80006208:	0001f717          	auipc	a4,0x1f
    8000620c:	50873703          	ld	a4,1288(a4) # 80025710 <disk+0x8>
    80006210:	0e070a63          	beqz	a4,80006304 <virtio_disk_init+0x1ec>
    80006214:	0e078863          	beqz	a5,80006304 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006218:	6605                	lui	a2,0x1
    8000621a:	4581                	li	a1,0
    8000621c:	adffa0ef          	jal	80000cfa <memset>
  memset(disk.avail, 0, PGSIZE);
    80006220:	0001f497          	auipc	s1,0x1f
    80006224:	4e848493          	addi	s1,s1,1256 # 80025708 <disk>
    80006228:	6605                	lui	a2,0x1
    8000622a:	4581                	li	a1,0
    8000622c:	6488                	ld	a0,8(s1)
    8000622e:	acdfa0ef          	jal	80000cfa <memset>
  memset(disk.used, 0, PGSIZE);
    80006232:	6605                	lui	a2,0x1
    80006234:	4581                	li	a1,0
    80006236:	6888                	ld	a0,16(s1)
    80006238:	ac3fa0ef          	jal	80000cfa <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000623c:	100017b7          	lui	a5,0x10001
    80006240:	4721                	li	a4,8
    80006242:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006244:	4098                	lw	a4,0(s1)
    80006246:	100017b7          	lui	a5,0x10001
    8000624a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000624e:	40d8                	lw	a4,4(s1)
    80006250:	100017b7          	lui	a5,0x10001
    80006254:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006258:	649c                	ld	a5,8(s1)
    8000625a:	0007869b          	sext.w	a3,a5
    8000625e:	10001737          	lui	a4,0x10001
    80006262:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006266:	9781                	srai	a5,a5,0x20
    80006268:	10001737          	lui	a4,0x10001
    8000626c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006270:	689c                	ld	a5,16(s1)
    80006272:	0007869b          	sext.w	a3,a5
    80006276:	10001737          	lui	a4,0x10001
    8000627a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000627e:	9781                	srai	a5,a5,0x20
    80006280:	10001737          	lui	a4,0x10001
    80006284:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006288:	10001737          	lui	a4,0x10001
    8000628c:	4785                	li	a5,1
    8000628e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006290:	00f48c23          	sb	a5,24(s1)
    80006294:	00f48ca3          	sb	a5,25(s1)
    80006298:	00f48d23          	sb	a5,26(s1)
    8000629c:	00f48da3          	sb	a5,27(s1)
    800062a0:	00f48e23          	sb	a5,28(s1)
    800062a4:	00f48ea3          	sb	a5,29(s1)
    800062a8:	00f48f23          	sb	a5,30(s1)
    800062ac:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800062b0:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800062b4:	100017b7          	lui	a5,0x10001
    800062b8:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    800062bc:	60e2                	ld	ra,24(sp)
    800062be:	6442                	ld	s0,16(sp)
    800062c0:	64a2                	ld	s1,8(sp)
    800062c2:	6902                	ld	s2,0(sp)
    800062c4:	6105                	addi	sp,sp,32
    800062c6:	8082                	ret
    panic("could not find virtio disk");
    800062c8:	00002517          	auipc	a0,0x2
    800062cc:	46850513          	addi	a0,a0,1128 # 80008730 <etext+0x730>
    800062d0:	cf6fa0ef          	jal	800007c6 <panic>
    panic("virtio disk FEATURES_OK unset");
    800062d4:	00002517          	auipc	a0,0x2
    800062d8:	47c50513          	addi	a0,a0,1148 # 80008750 <etext+0x750>
    800062dc:	ceafa0ef          	jal	800007c6 <panic>
    panic("virtio disk should not be ready");
    800062e0:	00002517          	auipc	a0,0x2
    800062e4:	49050513          	addi	a0,a0,1168 # 80008770 <etext+0x770>
    800062e8:	cdefa0ef          	jal	800007c6 <panic>
    panic("virtio disk has no queue 0");
    800062ec:	00002517          	auipc	a0,0x2
    800062f0:	4a450513          	addi	a0,a0,1188 # 80008790 <etext+0x790>
    800062f4:	cd2fa0ef          	jal	800007c6 <panic>
    panic("virtio disk max queue too short");
    800062f8:	00002517          	auipc	a0,0x2
    800062fc:	4b850513          	addi	a0,a0,1208 # 800087b0 <etext+0x7b0>
    80006300:	cc6fa0ef          	jal	800007c6 <panic>
    panic("virtio disk kalloc");
    80006304:	00002517          	auipc	a0,0x2
    80006308:	4cc50513          	addi	a0,a0,1228 # 800087d0 <etext+0x7d0>
    8000630c:	cbafa0ef          	jal	800007c6 <panic>

0000000080006310 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006310:	7159                	addi	sp,sp,-112
    80006312:	f486                	sd	ra,104(sp)
    80006314:	f0a2                	sd	s0,96(sp)
    80006316:	eca6                	sd	s1,88(sp)
    80006318:	e8ca                	sd	s2,80(sp)
    8000631a:	e4ce                	sd	s3,72(sp)
    8000631c:	e0d2                	sd	s4,64(sp)
    8000631e:	fc56                	sd	s5,56(sp)
    80006320:	f85a                	sd	s6,48(sp)
    80006322:	f45e                	sd	s7,40(sp)
    80006324:	f062                	sd	s8,32(sp)
    80006326:	ec66                	sd	s9,24(sp)
    80006328:	1880                	addi	s0,sp,112
    8000632a:	8a2a                	mv	s4,a0
    8000632c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000632e:	00c52c83          	lw	s9,12(a0)
    80006332:	001c9c9b          	slliw	s9,s9,0x1
    80006336:	1c82                	slli	s9,s9,0x20
    80006338:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000633c:	0001f517          	auipc	a0,0x1f
    80006340:	4f450513          	addi	a0,a0,1268 # 80025830 <disk+0x128>
    80006344:	8e3fa0ef          	jal	80000c26 <acquire>
  for(int i = 0; i < 3; i++){
    80006348:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000634a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000634c:	0001fb17          	auipc	s6,0x1f
    80006350:	3bcb0b13          	addi	s6,s6,956 # 80025708 <disk>
  for(int i = 0; i < 3; i++){
    80006354:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006356:	0001fc17          	auipc	s8,0x1f
    8000635a:	4dac0c13          	addi	s8,s8,1242 # 80025830 <disk+0x128>
    8000635e:	a8b9                	j	800063bc <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80006360:	00fb0733          	add	a4,s6,a5
    80006364:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80006368:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000636a:	0207c563          	bltz	a5,80006394 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000636e:	2905                	addiw	s2,s2,1
    80006370:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006372:	05590963          	beq	s2,s5,800063c4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80006376:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006378:	0001f717          	auipc	a4,0x1f
    8000637c:	39070713          	addi	a4,a4,912 # 80025708 <disk>
    80006380:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006382:	01874683          	lbu	a3,24(a4)
    80006386:	fee9                	bnez	a3,80006360 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80006388:	2785                	addiw	a5,a5,1
    8000638a:	0705                	addi	a4,a4,1
    8000638c:	fe979be3          	bne	a5,s1,80006382 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80006390:	57fd                	li	a5,-1
    80006392:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006394:	01205d63          	blez	s2,800063ae <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80006398:	f9042503          	lw	a0,-112(s0)
    8000639c:	d07ff0ef          	jal	800060a2 <free_desc>
      for(int j = 0; j < i; j++)
    800063a0:	4785                	li	a5,1
    800063a2:	0127d663          	bge	a5,s2,800063ae <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    800063a6:	f9442503          	lw	a0,-108(s0)
    800063aa:	cf9ff0ef          	jal	800060a2 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800063ae:	85e2                	mv	a1,s8
    800063b0:	0001f517          	auipc	a0,0x1f
    800063b4:	37050513          	addi	a0,a0,880 # 80025720 <disk+0x18>
    800063b8:	8b6fc0ef          	jal	8000246e <sleep>
  for(int i = 0; i < 3; i++){
    800063bc:	f9040613          	addi	a2,s0,-112
    800063c0:	894e                	mv	s2,s3
    800063c2:	bf55                	j	80006376 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800063c4:	f9042503          	lw	a0,-112(s0)
    800063c8:	00451693          	slli	a3,a0,0x4

  if(write)
    800063cc:	0001f797          	auipc	a5,0x1f
    800063d0:	33c78793          	addi	a5,a5,828 # 80025708 <disk>
    800063d4:	00a50713          	addi	a4,a0,10
    800063d8:	0712                	slli	a4,a4,0x4
    800063da:	973e                	add	a4,a4,a5
    800063dc:	01703633          	snez	a2,s7
    800063e0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800063e2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800063e6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800063ea:	6398                	ld	a4,0(a5)
    800063ec:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800063ee:	0a868613          	addi	a2,a3,168
    800063f2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800063f4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800063f6:	6390                	ld	a2,0(a5)
    800063f8:	00d605b3          	add	a1,a2,a3
    800063fc:	4741                	li	a4,16
    800063fe:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006400:	4805                	li	a6,1
    80006402:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80006406:	f9442703          	lw	a4,-108(s0)
    8000640a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000640e:	0712                	slli	a4,a4,0x4
    80006410:	963a                	add	a2,a2,a4
    80006412:	058a0593          	addi	a1,s4,88
    80006416:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006418:	0007b883          	ld	a7,0(a5)
    8000641c:	9746                	add	a4,a4,a7
    8000641e:	40000613          	li	a2,1024
    80006422:	c710                	sw	a2,8(a4)
  if(write)
    80006424:	001bb613          	seqz	a2,s7
    80006428:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000642c:	00166613          	ori	a2,a2,1
    80006430:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006434:	f9842583          	lw	a1,-104(s0)
    80006438:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000643c:	00250613          	addi	a2,a0,2
    80006440:	0612                	slli	a2,a2,0x4
    80006442:	963e                	add	a2,a2,a5
    80006444:	577d                	li	a4,-1
    80006446:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000644a:	0592                	slli	a1,a1,0x4
    8000644c:	98ae                	add	a7,a7,a1
    8000644e:	03068713          	addi	a4,a3,48
    80006452:	973e                	add	a4,a4,a5
    80006454:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006458:	6398                	ld	a4,0(a5)
    8000645a:	972e                	add	a4,a4,a1
    8000645c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006460:	4689                	li	a3,2
    80006462:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006466:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000646a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000646e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006472:	6794                	ld	a3,8(a5)
    80006474:	0026d703          	lhu	a4,2(a3)
    80006478:	8b1d                	andi	a4,a4,7
    8000647a:	0706                	slli	a4,a4,0x1
    8000647c:	96ba                	add	a3,a3,a4
    8000647e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006482:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006486:	6798                	ld	a4,8(a5)
    80006488:	00275783          	lhu	a5,2(a4)
    8000648c:	2785                	addiw	a5,a5,1
    8000648e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006492:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006496:	100017b7          	lui	a5,0x10001
    8000649a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000649e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    800064a2:	0001f917          	auipc	s2,0x1f
    800064a6:	38e90913          	addi	s2,s2,910 # 80025830 <disk+0x128>
  while(b->disk == 1) {
    800064aa:	4485                	li	s1,1
    800064ac:	01079a63          	bne	a5,a6,800064c0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    800064b0:	85ca                	mv	a1,s2
    800064b2:	8552                	mv	a0,s4
    800064b4:	fbbfb0ef          	jal	8000246e <sleep>
  while(b->disk == 1) {
    800064b8:	004a2783          	lw	a5,4(s4)
    800064bc:	fe978ae3          	beq	a5,s1,800064b0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    800064c0:	f9042903          	lw	s2,-112(s0)
    800064c4:	00290713          	addi	a4,s2,2
    800064c8:	0712                	slli	a4,a4,0x4
    800064ca:	0001f797          	auipc	a5,0x1f
    800064ce:	23e78793          	addi	a5,a5,574 # 80025708 <disk>
    800064d2:	97ba                	add	a5,a5,a4
    800064d4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800064d8:	0001f997          	auipc	s3,0x1f
    800064dc:	23098993          	addi	s3,s3,560 # 80025708 <disk>
    800064e0:	00491713          	slli	a4,s2,0x4
    800064e4:	0009b783          	ld	a5,0(s3)
    800064e8:	97ba                	add	a5,a5,a4
    800064ea:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800064ee:	854a                	mv	a0,s2
    800064f0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800064f4:	bafff0ef          	jal	800060a2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800064f8:	8885                	andi	s1,s1,1
    800064fa:	f0fd                	bnez	s1,800064e0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800064fc:	0001f517          	auipc	a0,0x1f
    80006500:	33450513          	addi	a0,a0,820 # 80025830 <disk+0x128>
    80006504:	fbafa0ef          	jal	80000cbe <release>
}
    80006508:	70a6                	ld	ra,104(sp)
    8000650a:	7406                	ld	s0,96(sp)
    8000650c:	64e6                	ld	s1,88(sp)
    8000650e:	6946                	ld	s2,80(sp)
    80006510:	69a6                	ld	s3,72(sp)
    80006512:	6a06                	ld	s4,64(sp)
    80006514:	7ae2                	ld	s5,56(sp)
    80006516:	7b42                	ld	s6,48(sp)
    80006518:	7ba2                	ld	s7,40(sp)
    8000651a:	7c02                	ld	s8,32(sp)
    8000651c:	6ce2                	ld	s9,24(sp)
    8000651e:	6165                	addi	sp,sp,112
    80006520:	8082                	ret

0000000080006522 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006522:	1101                	addi	sp,sp,-32
    80006524:	ec06                	sd	ra,24(sp)
    80006526:	e822                	sd	s0,16(sp)
    80006528:	e426                	sd	s1,8(sp)
    8000652a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000652c:	0001f497          	auipc	s1,0x1f
    80006530:	1dc48493          	addi	s1,s1,476 # 80025708 <disk>
    80006534:	0001f517          	auipc	a0,0x1f
    80006538:	2fc50513          	addi	a0,a0,764 # 80025830 <disk+0x128>
    8000653c:	eeafa0ef          	jal	80000c26 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006540:	100017b7          	lui	a5,0x10001
    80006544:	53b8                	lw	a4,96(a5)
    80006546:	8b0d                	andi	a4,a4,3
    80006548:	100017b7          	lui	a5,0x10001
    8000654c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000654e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006552:	689c                	ld	a5,16(s1)
    80006554:	0204d703          	lhu	a4,32(s1)
    80006558:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000655c:	04f70663          	beq	a4,a5,800065a8 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80006560:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006564:	6898                	ld	a4,16(s1)
    80006566:	0204d783          	lhu	a5,32(s1)
    8000656a:	8b9d                	andi	a5,a5,7
    8000656c:	078e                	slli	a5,a5,0x3
    8000656e:	97ba                	add	a5,a5,a4
    80006570:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006572:	00278713          	addi	a4,a5,2
    80006576:	0712                	slli	a4,a4,0x4
    80006578:	9726                	add	a4,a4,s1
    8000657a:	01074703          	lbu	a4,16(a4)
    8000657e:	e321                	bnez	a4,800065be <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006580:	0789                	addi	a5,a5,2
    80006582:	0792                	slli	a5,a5,0x4
    80006584:	97a6                	add	a5,a5,s1
    80006586:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006588:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000658c:	f2ffb0ef          	jal	800024ba <wakeup>

    disk.used_idx += 1;
    80006590:	0204d783          	lhu	a5,32(s1)
    80006594:	2785                	addiw	a5,a5,1
    80006596:	17c2                	slli	a5,a5,0x30
    80006598:	93c1                	srli	a5,a5,0x30
    8000659a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000659e:	6898                	ld	a4,16(s1)
    800065a0:	00275703          	lhu	a4,2(a4)
    800065a4:	faf71ee3          	bne	a4,a5,80006560 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800065a8:	0001f517          	auipc	a0,0x1f
    800065ac:	28850513          	addi	a0,a0,648 # 80025830 <disk+0x128>
    800065b0:	f0efa0ef          	jal	80000cbe <release>
}
    800065b4:	60e2                	ld	ra,24(sp)
    800065b6:	6442                	ld	s0,16(sp)
    800065b8:	64a2                	ld	s1,8(sp)
    800065ba:	6105                	addi	sp,sp,32
    800065bc:	8082                	ret
      panic("virtio_disk_intr status");
    800065be:	00002517          	auipc	a0,0x2
    800065c2:	22a50513          	addi	a0,a0,554 # 800087e8 <etext+0x7e8>
    800065c6:	a00fa0ef          	jal	800007c6 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
