#include <iomanip>
#include <iostream>
#include "CPU.h"
#include "globals.h"

#define VERBOSE 0

using namespace std;

CPU::CPU() {}

// Reset stateful modules
void CPU::init(string inst_file) {
	// Initialize the register file
	rf.init(false);
	// Load the instructions from the memory
	mem.load(inst_file);
	// Reset the program counter
	PC = 0;

	// Set the debugging status
	status = CONTINUE;
}

// This is a cycle-accurate simulation
uint32_t CPU::tick() {
	// These are just one of the implementations ...

	// wire for instruction
	uint32_t inst;

	// parsed & control signals (wire)
	CTRL::ParsedInst parsed_inst;
	CTRL::Controls controls;
	uint32_t ext_imm;

	// Default wires and control signals
	uint32_t rs_data, rt_data;
	uint32_t wr_addr;
	uint32_t wr_data;
	uint32_t operand1;
	uint32_t operand2;
	uint32_t alu_result;

	// PC_next
	uint32_t PC_next;

	// You can declare your own wires (if you want ...)
	uint32_t mem_data;

	// Access the instruction memory
	mem.imemAccess(PC, &inst);
	if (status != CONTINUE) return 0;
	
	// IF state
	// Split the instruction & set the control signals
	ctrl.splitInst(inst, &parsed_inst);
	ctrl.controlSignal(parsed_inst.opcode, parsed_inst.funct, &controls);
	ctrl.signExtend(parsed_inst.immi, controls.SignExtend, &ext_imm);
	if (status != CONTINUE) return 0;

	// ID state
	rf.read(parsed_inst.rs, parsed_inst.rt, &rs_data, &rt_data);

	operand1 = rs_data;
	operand2 = (controls.ALUSrc == 1 || controls.ALUOp == 13) ? ext_imm : rt_data;

	// EX state
	alu.compute(operand1, operand2, parsed_inst.shamt, controls.ALUOp, &alu_result);
	if (status != CONTINUE) return 0;

	// MEM (+PC Update)
	mem.dmemAccess(alu_result, &mem_data, rt_data, controls.MemRead, controls.MemWrite);
	if (status != CONTINUE) return 0;

	// Update the PC
	if (controls.JR) {
		PC_next = rs_data;
	} else if (controls.Jump) {
		PC_next = ((PC + 4) & 0xF0000000) | (parsed_inst.immj << 2);
	} else if (controls.Branch && alu_result) {
		PC_next = (PC + 4) + (ext_imm << 2);
	} else {
		PC_next = PC + 4;
	}

	// WB
	if (controls.RegDst) { 
		wr_addr = parsed_inst.rd;
	} else if (controls.SavePC) {
		wr_addr = 31;
	} else {
		wr_addr = parsed_inst.rt;
	}

	if (controls.SavePC) {
		wr_data = PC + 4;
	} else if (controls.MemtoReg) {
		wr_data = mem_data;
	} else {
		wr_data = alu_result;
	}

	rf.write(wr_addr, wr_data, controls.RegWrite);
	if (status != CONTINUE) return 0;
	
	// Update the PC register last ...
	PC = PC_next;

	return 1;
}

