#include <iostream>
#include "CTRL.h"
#include "ALU.h"
#include "globals.h"

CTRL::CTRL() {}

void CTRL::controlSignal(uint32_t opcode, uint32_t funct, uint32_t states, Controls *controls) {
	if (opcode == OP_RTYPE) {
		switch (states)
		{
		case IF:
			break;
		case ID:
			if (funct == FUNCT_JR) {
				controls->PCWrite = 0;
			}
			break;
		case EX:
			controlInitialize(controls);
			controls->ALUSrcA = 1;
			controls->ALUSrcB = 0;
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
					controls->PCWrite = 1;
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
			break;
		case MEM:
			controlInitialize(controls);
			break;
		case WB:
			controlInitialize(controls);
			controls->RegDst = 1;
			controls->RegWrite = (funct != FUNCT_JR) ? 1 : 0; // R-type 중 JR만 따로
		default:
			break;
		}
	}
	else if (opcode == OP_J) {
		if (states == ID) {
			controls->PCSource = 2;
			controls->PCWrite = 1;
		}
	}
	else if (opcode == OP_JAL) { // Jal
		if (states == ID) {
			controls->PCWrite = 0;
		}
		else if (states == WB) {
			controlInitialize(controls);
			controls->PCSource = 2;
			controls->PCWrite = 1;
			controls->RegWrite = 1;
			controls->SavePC = 1;
		}
	}
	else if (opcode == OP_BEQ) {
		switch (states) {
			case IF:
				break;
			case ID:
				controls->ALUSrcA = 0;
				controls->ALUSrcB = 3;
				controls->PCSource = 1;
				controls->PCWrite = 0;
				break;
			case EX:
				controlInitialize(controls);
				controls->ALUOp = ALU_EQ;
				controls->ALUSrcA = 1;
				controls->ALUSrcB = 0;
				controls->PCWriteCond = 1;
				break;
			default:
				break; 
		}
	}
	else if (opcode == OP_BNE) {
		switch (states) {
			case IF:
				break;
			case ID:
				controls->ALUSrcA = 0;
				controls->ALUSrcB = 3;
				controls->PCSource = 1;
				controls->PCWrite = 0;
				break;
			case EX:
				controlInitialize(controls);
				controls->ALUOp = ALU_NEQ;
				controls->ALUSrcA = 1;
				controls->ALUSrcB = 0;
				controls->PCWriteCond = 1;
				break;
			default:
				break; 
		}
	}
	else if (opcode == OP_ADDIU) {
		switch (states)
		{
		case IF:
			break;
		case ID:
			break;
		case EX:
			controlInitialize(controls);
			controls->ALUSrcA = 1;
			controls->ALUSrcB = 2;
			controls->ALUOp = ALU_ADDU;
			break;
		case MEM:
			controlInitialize(controls);
			break;
		case WB:
			controlInitialize(controls);
			controls->RegWrite = 1;
			controls->RegDst = 0;
			break;
		default:
			break;
		}
	}
	else if (opcode == OP_SLTI) {
		switch (states)
		{
		case IF:
			break;
		case ID:
			break;
		case EX:
			controlInitialize(controls);
			controls->ALUSrcA = 1;
			controls->ALUSrcB = 2;
			controls->ALUOp = ALU_SLT;
			break;
		case MEM:
			controlInitialize(controls);
			break;
		case WB:
			controlInitialize(controls);
			controls->RegWrite = 1;
			controls->RegDst = 0;
			break;
		default:
			break;
		}
	}
	else if (opcode == OP_SLTIU) {
		switch (states)
		{
		case IF:
			break;
		case ID:
			break;
		case EX:
			controlInitialize(controls);
			controls->ALUSrcA = 1;
			controls->ALUSrcB = 2;
			controls->ALUOp = ALU_SLTU;
			break;
		case MEM:
			controlInitialize(controls);
			break;
		case WB:
			controlInitialize(controls);
			controls->RegWrite = 1;
			controls->RegDst = 0;
			break;
		default:
			break;
		}
	}
	else if (opcode == OP_ANDI) {
		switch (states)
		{
		case IF:
			break;
		case ID:
			controls->SignExtend = 0;
			break;
		case EX:
			controlInitialize(controls);
			controls->ALUSrcA = 1;
			controls->ALUSrcB = 2;
			controls->ALUOp = ALU_AND;
			break;
		case MEM:
			controlInitialize(controls);
			break;
		case WB:
			controlInitialize(controls);
			controls->RegWrite = 1;
			controls->RegDst = 0;
			break;
		default:
			break;
		}
	}
	else if (opcode == OP_ORI) {
		switch (states)
		{
		case IF:
			break;
		case ID:
			controls->SignExtend = 0;
			break;
		case EX:
			controlInitialize(controls);
			controls->ALUSrcA = 1;
			controls->ALUSrcB = 2;
			controls->ALUOp = ALU_OR;
			break;
		case MEM:
			controlInitialize(controls);
			break;
		case WB:
			controlInitialize(controls);
			controls->RegWrite = 1;
			controls->RegDst = 0;
			break;
		default:
			break;
		}
	}
	else if (opcode == OP_XORI) {
		switch (states)
		{
		case IF:
			break;
		case ID:
			controls->SignExtend = 0;
			break;
		case EX:
			controlInitialize(controls);
			controls->ALUSrcA = 1;
			controls->ALUSrcB = 2;
			controls->ALUOp = ALU_XOR;
			break;
		case MEM:
			controlInitialize(controls);
			break;
		case WB:
			controlInitialize(controls);
			controls->RegWrite = 1;
			controls->RegDst = 0;
			break;
		default:
			break;
		}
	}
	else if (opcode == OP_LUI) {
		switch (states)
		{
		case IF:
			break;
		case ID:
			break;
		case EX:
			controlInitialize(controls);
			controls->ALUSrcA = 1;
			controls->ALUSrcB = 2;
			controls->ALUOp = ALU_LUI;
			break;
		case MEM:
			controlInitialize(controls);
			break;
		case WB:
			controlInitialize(controls);
			controls->RegWrite = 1;
			controls->RegDst = 0;
			break;
		default:
			break;
		}
	}
	else if (opcode == OP_LW) { // LW
		switch (states) 
		{
		case IF:
			break;
		case ID:
			break;
		case EX:
			controlInitialize(controls);
			controls->ALUSrcA = 1;
			controls->ALUSrcB = 2;
			controls->ALUOp = ALU_ADDU;
			break;
		case MEM:
			controlInitialize(controls);
			controls->MemRead = 1;
			controls->MemWrite = 0;
			controls->IorD = 1;
			break;
		case WB:
			controlInitialize(controls);
			controls->RegWrite = 1;
			controls->MemtoReg = 1;
			controls->RegDst = 0;
			break;
		default:
			break;
		}
	}
	else if (opcode == OP_SW) { // SW
		switch (states) 
		{
		case IF:
			break;
		case ID:
			break;
		case EX:
			controlInitialize(controls);
			controls->ALUSrcA = 1;
			controls->ALUSrcB = 2;
			controls->ALUOp = ALU_ADDU;
			break;
		case MEM:
			controlInitialize(controls);
			controls->MemWrite = 1;
			controls->MemRead = 0;
			controls->IorD = 1;
			break;
		case WB:
			controlInitialize(controls);
			break;
		default:
			break;
		}
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
    uint32_t imm16 = immi & 0xFFFF;  

    if (SignExtend) {
        if (imm16 & 0x8000) {
            *ext_imm = 0xFFFF0000 | imm16;
        } else {
            *ext_imm = imm16;
        }
    } else {
        *ext_imm = imm16;
    }
}


void CTRL::controlInitialize(Controls *controls) {
	controls->RegDst = 0;
	controls->MemRead = 0;
	controls->MemtoReg = 0;
	controls->MemWrite = 0;
	controls->SignExtend = 1;
	controls->RegWrite = 0;
	controls->ALUOp = 0b1111;
	controls->IorD = 0; 
	controls->IRWrite = 0;
	controls->PCWrite = 0; 
	controls->PCWriteCond = 0; 
	controls->ALUSrcA = 0;
	controls->ALUSrcB = 0;
	controls->PCSource = 0;
}
