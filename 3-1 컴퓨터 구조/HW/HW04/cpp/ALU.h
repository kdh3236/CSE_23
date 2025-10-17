#ifndef ALU_H
#define ALU_H

#include <stdint.h>

class ALU {
public:
    ALU(); // Constructor
    void compute(uint32_t operand1, uint32_t operand2,
			uint32_t shamt, uint32_t aluop, uint32_t *alu_result); // Example function
};

#endif // ALU_H
