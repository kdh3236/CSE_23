#ifndef CTRL_H
#define CTRL_H

#include <stdint.h>

class CTRL {
public:
    CTRL();
	// You can fix these if you want ...
	// control signal
	struct Controls_ID {
		uint32_t use_rs;
		uint32_t use_rt;
		uint32_t SignExtend;
		uint32_t Jump;
	};

	struct Controls_WB {
		uint32_t MemtoReg;
		uint32_t RegWrite; 
	};

	struct Controls_MEM {
		uint32_t Branch;
		uint32_t MemRead;
		uint32_t MemWrite;
		uint32_t RegWrite; // For data hazard detection 
	};

	struct Controls_EX {
		uint32_t RegDst;
		uint32_t Jump;
		uint32_t JR;
		uint32_t ALUSrc;
		uint32_t ALUOp;
		uint32_t SavePC;
		uint32_t RegWrite; // For data hazard detection 
	};

	// Parsing instruction
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

	// Functions
	void controlSignal(uint32_t opcode, uint32_t funct, Controls_ID *controls_id, 
					   Controls_EX *controls_ex, Controls_MEM *controls_mem, Controls_WB *controls_wb);
	void splitInst(uint32_t inst, ParsedInst *parsed_inst);
	void signExtend(uint32_t immi, uint32_t SignExtend, uint32_t *ext_imm);
};

#endif // CTRL_H
