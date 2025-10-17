#ifndef GLOBALS_H
#define GLOBALS_H

enum Status {
	CONTINUE = 0,
	TERMINATE = 1,
	QUIT = 2,
	IMEM_OVERFLOW = 3,
	DMEM_OVERFLOW = 4,
	MEM_UNALIGNED = 5,
	INVALID_INST = 6,
	UNSUPPORTED_ALU = 7
};

enum ALUOp {
	ALU_ADDU = 0, 
	ALU_AND = 1, 
	ALU_NOR = 2, 
	ALU_OR = 3, 
	ALU_SLL = 4, 
	ALU_SRA = 5, 
	ALU_SRL = 6, 
	ALU_SUBU = 7,
	ALU_XOR = 8,
	ALU_SLT = 9,
	ALU_SLTU = 10,
	ALU_EQ = 11,
	ALU_NEQ = 12,
	ALU_LUI = 13
};

enum Funct {
	FUNCT_SLL = 0,
	FUNCT_SRL = 2,
	FUNCT_SRA = 3,
	FUNCT_JR = 8,
	FUNCT_ADDU = 33,
	FUNCT_SUBU = 35,
	FUNCT_AND = 36,
	FUNCT_OR = 37,
	FUNCT_XOR = 38,
	FUNCT_NOR = 39,
	FUNCT_SLT = 42,
	FUNCT_SLTU = 43,
};

enum Opcode {
	OP_RTYPE = 0,
	OP_J = 2,
	OP_JAL = 3,
	OP_BEQ = 4,
	OP_BNE = 5,
	OP_ADDIU = 9,
	OP_SLTI = 10,
	OP_SLTIU = 11,
	OP_ANDI = 12,
	OP_ORI = 13,
	OP_XORI = 14,
	OP_LUI = 15,
	OP_LW = 35,
	OP_SW = 43
};

enum State {
	IF = 0,
	ID = 1,
	EX = 2,
	MEM = 3,
	WB = 4
};

extern Status status;

#endif // GLOBALS_H