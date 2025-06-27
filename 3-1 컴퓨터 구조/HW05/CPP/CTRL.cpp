#include <iostream>
#include "CTRL.h"
#include "ALU.h"
#include "globals.h"


CTRL::CTRL() {}

void CTRL::controlSignal(uint32_t opcode, uint32_t funct, Controls_ID *controls_id, 
					     Controls_EX *controls_ex, Controls_MEM *controls_mem, Controls_WB *controls_wb) {
	// Initialize
	controls_id->use_rs = 0;
	controls_id->use_rt = 0;
	controls_id->SignExtend = 1;
	controls_id->Jump = 0;

	controls_ex->RegDst = 0;
	controls_ex->Jump = 0;
	controls_ex->JR = 0;
	controls_ex->ALUSrc = 0;
	controls_ex->ALUOp = 0b1111;
	controls_ex->SavePC = 0;

	controls_mem->Branch = 0;
	controls_mem->MemRead = 0;
	controls_mem->MemWrite = 0;

	controls_wb->MemtoReg = 0;
	controls_wb->RegWrite = 0;
	
	if (opcode == 0) {
		controls_id->use_rs = 1;
		controls_id->use_rt = (funct != FUNCT_JR) ? 1 : 0;
		
		controls_ex->RegDst = 1;
		controls_ex->RegWrite = (funct != FUNCT_JR) ? 1 : 0;
		controls_mem->RegWrite = (funct != FUNCT_JR) ? 1 : 0;
		controls_wb->RegWrite = (funct != FUNCT_JR) ? 1 : 0; 
		// ALUOP
		switch (funct) 
		{
			case FUNCT_SLL:
				controls_ex->ALUOp = ALU_SLL;
				break;
			case FUNCT_SRL:
				controls_ex->ALUOp = ALU_SRL;
				break;
			case FUNCT_SRA: 
				controls_ex->ALUOp = ALU_SRA;
				break;
			case FUNCT_JR:
				controls_ex->JR = 1;
				controls_ex->Jump = 1;
				break;
			case FUNCT_ADDU:
				controls_ex->ALUOp = ALU_ADDU;
				break;
			case FUNCT_SUBU:
				controls_ex->ALUOp = ALU_SUBU;
				break; 
			case FUNCT_AND:
				controls_ex->ALUOp = ALU_AND;
				break; 
			case FUNCT_OR: 
				controls_ex->ALUOp = ALU_OR;
				break;
			case FUNCT_XOR:
				controls_ex->ALUOp = ALU_XOR;
				break;
			case FUNCT_NOR:
				controls_ex->ALUOp = ALU_NOR;
				break; 
			case FUNCT_SLT:
				controls_ex->ALUOp = ALU_SLT;
				break; 
			case FUNCT_SLTU:
				controls_ex->ALUOp = ALU_SLTU;
				break; 	
			default:
				break;
		} 
	}
	else if (opcode == 2) {
		controls_id->Jump = 1;
	}
	else if (opcode == 3) { // Jal
		controls_ex->Jump = 1;
		controls_ex->RegWrite = 1;
		controls_ex->SavePC = 1;

		controls_mem->RegWrite = 1;
		controls_wb->RegWrite = 1;
	}
	else if (opcode == 4) {
		controls_id->use_rs = 1;
		controls_id->use_rt = 1;
		controls_ex->ALUOp = ALU_EQ;
		controls_mem->Branch = 1;
	}
	else if (opcode == 5) {
		controls_id->use_rs = 1;
		controls_id->use_rt = 1;
		controls_ex->ALUOp = ALU_NEQ;
		controls_mem->Branch = 1;
	}
	else if (opcode == 9) {
		controls_id->use_rs = 1;
		controls_id->use_rt = 1;
		controls_ex->ALUOp = ALU_ADDU;
		controls_ex->ALUSrc = 1;
		controls_ex->RegWrite = 1;
		controls_mem->RegWrite = 1;
		controls_wb->RegWrite = 1;
	}
	else if (opcode == 10) {
		controls_id->use_rs = 1;
		controls_id->use_rt = 1;
		controls_ex->ALUOp = ALU_SLT;
		controls_ex->ALUSrc = 1;
		controls_ex->RegWrite = 1;
		controls_mem->RegWrite = 1;
		controls_wb->RegWrite = 1;
	}
	else if (opcode == 11) {
		controls_id->use_rs = 1;
		controls_id->use_rt = 1;
		controls_ex->ALUOp = ALU_SLTU;
		controls_ex->ALUSrc = 1;
		controls_ex->RegWrite = 1;
		controls_mem->RegWrite = 1;
		controls_wb->RegWrite = 1;
	}
	else if (opcode == 12) {
		controls_id->use_rs = 1;
		controls_id->use_rt = 1;
		controls_ex->ALUOp = ALU_AND;
		controls_ex->ALUSrc = 1;
		controls_ex->RegWrite = 1;
		controls_mem->RegWrite = 1;
		controls_wb->RegWrite = 1;
		controls_id->SignExtend = 0;
	}
	else if (opcode == 13) {
		controls_id->use_rs = 1;
		controls_id->use_rt = 1;
		controls_ex->ALUOp = ALU_OR;
		controls_ex->ALUSrc = 1;
		controls_ex->RegWrite = 1;
		controls_mem->RegWrite = 1;
		controls_wb->RegWrite = 1;
		controls_id->SignExtend = 0;
	}
	else if (opcode == 14) {
		controls_id->use_rs = 1;
		controls_id->use_rt = 1;
		controls_ex->ALUOp = ALU_XOR;
		controls_ex->ALUSrc = 1;
		controls_ex->RegWrite = 1;
		controls_mem->RegWrite = 1;
		controls_wb->RegWrite = 1;
		controls_id->SignExtend = 0;
	}
	else if (opcode == 15) {
		controls_id->use_rs = 1;
		controls_id->use_rt = 1;
		controls_ex->ALUOp = ALU_LUI;
		controls_ex->RegWrite = 1;
		controls_mem->RegWrite = 1;
		controls_wb->RegWrite = 1;
	}
	else if (opcode == 35) {
		controls_id->use_rs = 1;
		controls_id->use_rt = 1;
		controls_ex->ALUOp = ALU_ADDU;
		controls_mem->MemRead = 1;
		controls_ex->ALUSrc = 1;
		controls_wb->MemtoReg = 1;
		controls_ex->RegWrite = 1;
		controls_mem->RegWrite = 1;
		controls_wb->RegWrite = 1;
	}
	else if (opcode == 43) {
		controls_id->use_rs = 1;
		controls_id->use_rt = 1;
		controls_ex->ALUOp = ALU_ADDU;
		controls_mem->MemWrite = 1;
		controls_ex->ALUSrc = 1;
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
