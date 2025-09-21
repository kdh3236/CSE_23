/*
 * bitXor - x^y using only ~ and &
 *   Example: bitXor(4, 5) = 1
 *   Legal ops: ~ &
 *   Max ops: 14
 *   Rating: 1
 */
int bitXor(int x, int y) {
  int var1 = ((~x) & y);
  int var2 = (x & (~y));
  int var3 = ((~var1) & (~var2));
  int var4 = (~var3);
  return var4;
}
/*
 * tmin - return minimum two's complement integer
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 4
 *   Rating: 1
 */
int tmin(void) {
  return 1 << 31;
}
//2
/*
 * isTmax - returns 1 if x is the maximum, two's complement number,
 *     and 0 otherwise
 *   Legal ops: ! ~ & ^ | +
 *   Max ops: 10
 *   Rating: 1
 */
int isTmax(int x) {
  return !(((x+1)^(~x))|!(~x));
}
/*
 * allOddBits - return 1 if all odd-numbered bits in word set to 1
 *   where bits are numbered from 0 (least significant) to 31 (most significant)
 *   Examples allOddBits(0xFFFFFFFD) = 0, allOddBits(0xAAAAAAAA) = 1
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 2
 */
int allOddBits(int x) {
  int var1 = (0xAA<<8)|0xAA;
  int var2 = (var1<<16)|var1;
  return !((x&var2)^var2);
}
/*
 * negate - return -x
 *   Example: negate(1) = -1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 5
 *   Rating: 2
 */
int negate(int x) {
  return (~x)+1;
}
/*
 * isAsciiDigit - return 1 if 0x30 <= x <= 0x39 (ASCII codes for characters '0' to '9')
 *   Example: isAsciiDigit(0x35) = 1.
 *            isAsciiDigit(0x3a) = 0.
 *            isAsciiDigit(0x05) = 0.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 15
 *   Rating: 3
 */
int isAsciiDigit(int x) {
  int low_var = x + (~0x30 + 1);  //x-0x30
  int up_var = 0x39 + (~x + 1);  //0x39-x

  return !((low_var >> 31) | (up_var >> 31));
}


/*
 * conditional - same as x ? y : z
 *   Example: conditional(2,4,5) = 4
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 16
 *   Rating: 3
 */
int conditional(int x, int y, int z) {
  int var = !x+~0;
  return (~var&z)|(var&y);
}
/*
 * isLessOrEqual - if x <= y  then return 1, else return 0
 *   Example: isLessOrEqual(4,5) = 1.
 *   Legal ops: ! ~ & ^ | + << >>
 *   Max ops: 24
 *   Rating: 3
 */
int isLessOrEqual(int x, int y){
  int var1 = (x>>31);
  int var2 = (y>>31);
  int var3 = var1^var2; //부호 같은지 확인
  int low_var = (y + (~x+1)) >> 31; //y-x
  return (var3&var1)|(!(low_var|var3));
}
//4
/*
 * logicalNeg - implement the ! operator, using all of
 *              the legal operators except !
 *   Examples: logicalNeg(3) = 0, logicalNeg(0) = 1
 *   Legal ops: ~ & ^ | + << >>
 *   Max ops: 12
 *   Rating: 4
 */
int logicalNeg(int x) {
  return (((x|(~x+1))>>31)&1)^1;
}
/* howManyBits - return the minimum number of bits required to r
epresent x in
 *             two's complement
 *  Examples: howManyBits(12) = 5
 *            howManyBits(298) = 10
 *            howManyBits(-5) = 4
 *            howManyBits(0)  = 1
 *            howManyBits(-1) = 1
 *            howManyBits(0x80000000) = 32
 *  Legal ops: ! ~ & ^ | + << >>
 *  Max ops: 90
 *  Rating: 4
 */
int howManyBits(int x) {
  int s = x >> 31;
  int var = (s&(~x))|((~s)&x);

  int var1 = (!!(var>>16))<<4;
  int var2 = (!!(var>>(var1+8)))<<3;
  int var3 = var1|var2;
  int var4 = (!!(var>>(var3+4)))<<2;
  int var5 = var3|var4;
  int var6 = (!!(var>>(var5+2)))<<1;
  int var7 = var5|var6;
  int var8 = (var>>(var7+1));
  int var9 = var7|var8;

  int var10 = !(var);
  return var9+3+(~var10);
}
//float
/*
 * floatScale2 - Return bit-level equivalent of expression 2*f for
 *   floating point argument f.
 *   Both the argument and result are passed as unsigned int's, but
 *   they are to be interpreted as the bit-level representation of
 *   single-precision floating point values.
 *   When argument is NaN, return argument
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */

unsigned floatScale2(unsigned uf) {
  unsigned int s = uf >> 31;
  unsigned int exp = (uf >> 23) & 0xFF;
  unsigned int frac = uf&0x7FFFFF;

  if(uf == 0) {
    return 0;
  } else if (exp == 0xFF) {
    return uf;
  } else if (exp == 0){
    frac <<= 1;
    return (s << 31)|frac;
  } else{
    exp += 1;
    return (s << 31)|(exp << 23)|frac;
  }
}
/*
 * floatFloat2Int - Return bit-level equivalent of expression (int) f
 *   for floating point argument f.
 *   Argument is passed as unsigned int, but
 *   it is to be interpreted as the bit-level representation of a
 *   single-precision floating point value.
 *   Anything out of range (including NaN and infinity) should return
 *   0x80000000u.
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. also if, while
 *   Max ops: 30
 *   Rating: 4
 */

int floatFloat2Int(unsigned uf) {
  unsigned s = uf>>31;
  unsigned exp = (uf>>23)&0xFF;
  unsigned frac = uf&0x7FFFFF;
  int e = exp-127;

  if (exp == 0){
     return 0;
  }
  if (exp == 255){
     return 0x80000000u;
  }
  frac = frac|0x800000;
  if (e < 0){
     return 0;
  }
  if (e >= 31){
     return 0x80000000u;
  }


  if (e > 23){
     frac = frac << (e - 23);
  }else{
     frac = frac >> (23 - e);
  }

  if (frac >> 31){
     return 0x80000000u;
  }

  if (s){
     return -frac;
  }else{
     return frac;
  }
}
/*
 * floatPower2 - Return bit-level equivalent of the expression 2.0^x
 *   (2.0 raised to the power x) for any 32-bit integer x.
 *
 *   The unsigned value that is returned should have the identical bit
 *   representation as the single-precision floating-point number 2.0^x.
 *   If the result is too small to be represented as a denorm, return
 *   0. If too large, return +INF.
 *
 *   Legal ops: Any integer/unsigned operations incl. ||, &&. Also if, while
 *   Max ops: 30
 *   Rating: 4
 */
unsigned floatPower2(int x) {
    x += 127;

    if (x >= 255) {
        return 0xFF<<23;
    } else if (x > 0) {
        return x<<23;
    } else if (x > -23) {
        return 1<<-x;
    } else {
        return 0;
    }
}
