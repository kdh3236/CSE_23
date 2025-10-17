#ifndef CTRL_H
#define CTRL_H

#include <stdint.h>

class CTRL {
public:
    CTRL();
	// You can fix these if you want ...
	struct Controls {
		uint32_t RegDst;
		uint32_t MemRead;
		uint32_t MemtoReg;
		uint32_t MemWrite;
		uint32_t SignExtend;
		uint32_t RegWrite;
		uint32_t ALUOp;
		uint32_t SavePC; // jal 에서 $r31에 pc+4 저장하기 위한 용도
		uint32_t IorD; // IR vs MEM
		uint32_t IRWrite; // IR에 저장 여부
		uint32_t PCWrite; // PCWrite 가능한지
		uint32_t PCWriteCond; 
		uint32_t ALUSrcA;
		uint32_t ALUSrcB;
		uint32_t PCSource;
	};
	struct ParsedInst {
		uint32_t opcode;
		uint32_t rs;
		uint32_t rt;
		uint32_t rd;
		uint32_t shamt;
		uint32_t funct;
		uint32_t immi;
		uint32_t immj;
	};
	void controlSignal(uint32_t opcode, uint32_t funct, uint32_t states, Controls *controls);
	void splitInst(uint32_t inst, ParsedInst *parsed_inst);
	void signExtend(uint32_t immi, uint32_t SignExtend, uint32_t *ext_imm);
	void controlInitialize(Controls *controls);
};

#endif // CTRL_H
