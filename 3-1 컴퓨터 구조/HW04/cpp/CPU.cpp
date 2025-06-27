#include <iomanip>
#include <iostream>
#include "CPU.h"
#include "globals.h"

#define VERBOSE 0

using namespace std;

CPU::CPU() {}

// These are just one of the implementations ...
// Reset stateful modules
void CPU::init(string inst_file) {
	// Initialize the register file
	rf.init(false);
	// Load the instructions from the memory
	program_size = mem.load(inst_file);
	// Reset the program counter
	PC = 0;

	states = IF;

	// Set the debugging status
	status = CONTINUE;
}

void CPU::initResource() {
    inst = 0;

    // parsed & control signals (wire)
    parsed_inst = CTRL::ParsedInst{};
    controls = CTRL::Controls{};
    ext_imm = 0;

    // Default wires and control signals
    rs_data = 0;
	rt_data = 0;
    wr_addr = 0;
    wr_data = 0;
    operand1 = 0;
    operand2 = 0;
    alu_result = 0;

    // PC_next
    PC_next = 0;

    // You can declare your own wires (if you want ...)
    mem_data = 0;
    states = IF;
} 

// This is a cycle-accurate simulation
uint32_t CPU::tick() {
	if (PC / 4 > program_size) {
		status = TERMINATE;
		return 0;
	}

	switch (states) {
		case IF:
			// Initialize all Resources
			initResource();
			// Fixed control signal in IF
			controls.IorD = 0;
			controls.MemRead = 1;
			controls.MemWrite = 0;
			controls.IRWrite = 1;
			controls.ALUSrcA = 0;
			controls.ALUSrcB = 1;
			// Access the instruction memory
			if (controls.IRWrite && controls.IorD == 0) mem.memAccess(PC, &inst, 0, controls.MemRead, controls.MemWrite, 0); //inst가 IR 역할
			if (status != CONTINUE) return 0;

			operand1 = PC;
			operand2 = 4;
			// ALU operation for PC + 4
			alu.compute(operand1, operand2, parsed_inst.shamt, controls.ALUOp, &alu_result);
			if (status != CONTINUE) return 0;
			PC_next = alu_result;

			states = ID; // 항상 ID로 이동
			return 1;
			break;
		case ID:
			controls.ALUOp = ALU_ADDU;
			controls.SignExtend = 1;
			controls.PCSource = 0;
			controls.PCWrite = 1;
			
			/// Split the instruction & set the control signals
			ctrl.splitInst(inst, &parsed_inst);
			ctrl.controlSignal(parsed_inst.opcode, parsed_inst.funct, states, &controls);
			ctrl.signExtend(parsed_inst.immi, controls.SignExtend, &ext_imm);
			if (status != CONTINUE) return 0;

			// Next state 결정
			if (parsed_inst.opcode == OP_J || parsed_inst.opcode == OP_JAL) {
				if (parsed_inst.opcode == OP_JAL) states = WB;
				else states = IF; 
			} 
			else { 
				states = EX;
			}

			if (parsed_inst.opcode == OP_BEQ || parsed_inst.opcode == OP_BNE) {
				if (controls.ALUSrcA == 0) operand1 = PC_next;
				if (controls.ALUSrcB == 3)	operand2 = ext_imm << 2;

				alu.compute(operand1, operand2, parsed_inst.shamt, controls.ALUOp, &alu_result);
				if (status != CONTINUE) return 0;
			}

			// Next PC 결정	
			if (controls.PCSource == 0) PC_next = PC_next; // IF 에서 계산한 것 이용
			else if (controls.PCSource == 1) PC_next = alu_result;
			else if (controls.PCSource == 2) PC_next = ((PC_next) & 0xF0000000) | (parsed_inst.immj << 2);

			if (controls.PCWrite) PC = PC_next;

			rf.read(parsed_inst.rs, parsed_inst.rt, &rs_data, &rt_data);
			
			return 1;
			break;
		case EX:
			ctrl.controlSignal(parsed_inst.opcode, parsed_inst.funct, states, &controls);
			if (status != CONTINUE) return 0;
			// Operand1
			if (controls.ALUSrcA == 0) operand1 = PC;
			else if (controls.ALUSrcA == 1) operand1 = rs_data;

			// Operand2
			if (controls.ALUSrcB == 0) operand2 = rt_data;
			else if (controls.ALUSrcB == 1) operand2 = 4;
			else if (controls.ALUSrcB == 2) operand2 = ext_imm;
			else if (controls.ALUSrcB == 3)	operand2 = ext_imm << 2;

			// ALU operation
			alu.compute(operand1, operand2, parsed_inst.shamt, controls.ALUOp, &alu_result);
			if (status != CONTINUE) return 0;

			// Branch면 명령어 종료 
			if (parsed_inst.opcode == OP_BEQ || parsed_inst.opcode == OP_BNE) states = IF; 
			// LW, SW면 MEM으로 이동
			else if (parsed_inst.opcode == OP_LW || parsed_inst.opcode == OP_SW) states = MEM;
			// R type, I type은 WB로 이동
			else states = WB;
		
			// Branch와 JR의 경우 EX에서 PC 업데이트
			if (controls.PCWriteCond && alu_result) PC = PC_next;
			else if (controls.PCWriteCond && alu_result == 0) PC = PC + 4;
			else if (parsed_inst.funct == FUNCT_JR && controls.PCWrite) PC = rs_data;

			return 1;
			break;
		case MEM: // MEM
			ctrl.controlSignal(parsed_inst.opcode, parsed_inst.funct, states, &controls);
			if (status != CONTINUE) return 0;

			if (controls.IorD == 1) mem.memAccess(alu_result, &mem_data, rt_data, controls.MemRead, controls.MemWrite, 1);
			if (status != CONTINUE) return 0;

			if (parsed_inst.opcode == OP_LW) {
				states = WB;
				return 1;
			} 
			else if (parsed_inst.opcode == OP_SW) {
				states = IF; // SW 종료
				return 1;
			} 

			return 1;
			break;
		case WB:
			ctrl.controlSignal(parsed_inst.opcode, parsed_inst.funct, states, &controls);
			if (status != CONTINUE) return 0;
			// Write address
			if (controls.RegDst) { // R type
				wr_addr = parsed_inst.rd;
			} else if (controls.SavePC) { // Jal
				wr_addr = 31;
			} else { // LW
				wr_addr = parsed_inst.rt;
			}
			// Write data
			if (controls.SavePC) { // Jal
				wr_data = PC_next;
			} else if (controls.MemtoReg) { // LW
				wr_data = mem_data;
			} else { // R type
				wr_data = alu_result;
			}

			rf.write(wr_addr, wr_data, controls.RegWrite);
			if (status != CONTINUE) return 0;

			// Jal은 WB에서 PC 업데이트
			if (controls.PCSource == 2 && controls.PCWrite && controls.SavePC) {
				PC = ((PC_next) & 0xF0000000) | (parsed_inst.immj << 2);
			}
			

			states = IF; 
			return 1;
			break;
		default:
			return 1;
			break; 
	}

	return 0;
}

