#include <iostream>
#include <cstdlib>
#include <iomanip>
#include <fstream>
#include <bitset>
#include "globals.h"
#include "CPU.h"

using namespace std;

Status status = CONTINUE;

int main(int argc, char* argv[]) {
	
	// Generate initial reg/mem
	ofstream fout_reg;
	ofstream fout_reg_ref;
	ofstream fout_mem;
	ofstream fout_mem_ref;

	fout_reg.open("initial_reg.mem");
	fout_mem.open("initial_mem.mem");
	fout_reg_ref.open("reference_reg.mem");
	fout_mem_ref.open("reference_mem.mem");

	char cmd;

	if (argc != 2)
	{
		cerr << "Missing instruction file" << endl;
		return 0;
	}
    cout << "Loading instruction memory..." << endl;
	string filename = argv[1];

    CPU cpu;
	cpu.init(filename);
	for (int i = 0; i < REGSIZE; i++)
		fout_reg << setw(8) << setfill('0') << hex << cpu.rf.register_files[i] << endl;
	for (int i = 0; i < MEMSIZE; i++)
		fout_mem << setw(8) << setfill('0') << hex << cpu.mem.memory[i] << endl;

    cout << "Starting CPU simulation..." << endl;

	// There are four commands
	// 1) s: step a single instruction
	// 2) r: print the register files
	// 3) c: continue until the last
	// 4) q: quit (early exit)
	while(status == Status::CONTINUE) {
		cin.get(cmd);
		switch(cmd) {
			case 's':
				cpu.tick();
				break;
			case 'r':
				cpu.rf.dump();
				break;
			case 'c':
				while (status == Status::CONTINUE) cpu.tick();
				break;
			case 'q':
				status = Status::QUIT;
				break;
		}
	}

	switch (status) {
		case Status::TERMINATE:
    		cout << "Simulation done successfully." << endl;
			break;
		case Status::QUIT:
    		cout << "Simulation early exit." << endl;
			break;
		case Status::IMEM_OVERFLOW:
			cout << "Instruction memory overflow" << endl;
			break;
		case Status::DMEM_OVERFLOW:
			cout << "Out of bound data memory access" << endl;
			break;
		case Status::MEM_UNALIGNED:
			cout << "Unaligned memory access" << endl;
			break;
		case Status::INVALID_INST:
			cout << "Invalid Opcode" << endl;
			break;
		case Status::UNSUPPORTED_ALU:
			cout << "Unsupported alu operation" << endl;
			break;
		default:
			cerr << "Unintended exit status" << endl;
			break;
	}

	cout << "RF states after the program execution" << endl;
	cpu.rf.dump();
	for (int i = 0; i < REGSIZE; i++)
		fout_reg_ref << setw(8) << setfill('0') << hex << cpu.rf.register_files[i] << endl;
	for (int i = 0; i < MEMSIZE; i++)
		fout_mem_ref << setw(8) << setfill('0') << hex << cpu.mem.memory[i] << endl;
    return 0;
}
