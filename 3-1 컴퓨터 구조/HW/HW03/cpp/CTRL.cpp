#include <iostream>
#include "CTRL.h"
#include "ALU.h"
#include "globals.h"


CTRL::CTRL() {}

void CTRL::controlSignal(uint32_t opcode, uint32_t funct, Controls *controls) {
	controls->RegDst = 0;
	controls->Jump = 0;
	controls->Branch = 0;
	controls->JR = 0;
	controls->MemRead = 0;
	controls->MemtoReg = 0;
	controls->MemWrite = 0;
	controls->ALUSrc = 0;
	controls->SignExtend = 1;
	controls->RegWrite = 0;
	controls->ALUOp = 0b1111;
	controls->SavePC = 0;

	if (opcode == 0) {
		controls->RegDst = 1;
		controls->RegWrite = (funct != FUNCT_JR) ? 1 : 0; // R-type 중 JR만 따로

		switch (funct) // ALUOP
		{
			case FUNCT_SLL:
				controls->ALUOp = ALU_SLL;
				break;
			case FUNCT_SRL:
				controls->ALUOp = ALU_SRL;
				break;
			case FUNCT_SRA: 
				controls->ALUOp = ALU_SRA;
				break;
			case FUNCT_JR:
				controls->JR = 1;
				controls->Jump = 1;
				break;
			case FUNCT_ADDU:
				controls->ALUOp = ALU_ADDU;
				break;
			case FUNCT_SUBU:
				controls->ALUOp = ALU_SUBU;
				break; 
			case FUNCT_AND:
				controls->ALUOp = ALU_AND;
				break; 
			case FUNCT_OR: 
				controls->ALUOp = ALU_OR;
				break;
			case FUNCT_XOR:
				controls->ALUOp = ALU_XOR;
				break;
			case FUNCT_NOR:
				controls->ALUOp = ALU_NOR;
				break; 
			case FUNCT_SLT:
				controls->ALUOp = ALU_SLT;
				break; 
			case FUNCT_SLTU:
				controls->ALUOp = ALU_SLTU;
				break; 	
			default:
				break;
		} 
	}
	else if (opcode == 2) {
		controls->Jump = 1;
	}
	else if (opcode == 3) { // Jal
		controls->Jump = 1;
		controls->RegWrite = 1;
		controls->SavePC = 1;
	}
	else if (opcode == 4) {
		controls->ALUOp = ALU_EQ;
		controls->Branch = 1;
	}
	else if (opcode == 5) {
		controls->ALUOp = ALU_NEQ;
		controls->Branch = 1;
	}
	else if (opcode == 9) {
		controls->ALUOp = ALU_ADDU;
		controls->ALUSrc = 1;
		controls->RegWrite = 1;
	}
	else if (opcode == 10) {
		controls->ALUOp = ALU_SLT;
		controls->ALUSrc = 1;
		controls->RegWrite = 1;
	}
	else if (opcode == 11) {
		controls->ALUOp = ALU_SLTU;
		controls->ALUSrc = 1;
		controls->RegWrite = 1;
	}
	else if (opcode == 12) {
		controls->ALUOp = ALU_AND;
		controls->ALUSrc = 1;
		controls->RegWrite = 1;
		controls->SignExtend = 0;
	}
	else if (opcode == 13) {
		controls->ALUOp = ALU_OR;
		controls->ALUSrc = 1;
		controls->RegWrite = 1;
		controls->SignExtend = 0;
	}
	else if (opcode == 14) {
		controls->ALUOp = ALU_XOR;
		controls->ALUSrc = 1;
		controls->RegWrite = 1;
		controls->SignExtend = 0;
	}
	else if (opcode == 15) {
		controls->ALUOp = ALU_LUI;
		controls->RegWrite = 1;
	}
	else if (opcode == 35) {
		controls->ALUOp = ALU_ADDU;
		controls->MemRead = 1;
		controls->ALUSrc = 1;
		controls->MemtoReg = 1;
		controls->RegWrite = 1;
	}
	else if (opcode == 43) {
		controls->ALUOp = ALU_ADDU;
		controls->MemWrite = 1;
		controls->ALUSrc = 1;
	}
}

void CTRL::splitInst(uint32_t inst, ParsedInst *parsed_inst) {
	parsed_inst->opcode = (inst >> 26) & 0x3F;
	parsed_inst->rs = (inst >> 21) & 0x1F;
	parsed_inst->rt = (inst >> 16) & 0x1F;
	parsed_inst->rd = (inst >> 11) & 0x1F;
	parsed_inst->shamt  = (inst >> 6)  & 0x1F;
	parsed_inst->funct  = inst & 0x3F;
	parsed_inst->immi = inst & 0xFFFF;
	parsed_inst->immj = inst & 0x3FFFFFF;
			
}

void CTRL::signExtend(uint32_t immi, uint32_t SignExtend, uint32_t *ext_imm) {
	if (SignExtend) {
        *ext_imm = static_cast<int32_t>(immi << 16) >> 16;
    } 
	else {
        *ext_imm = immi;
    }
}
