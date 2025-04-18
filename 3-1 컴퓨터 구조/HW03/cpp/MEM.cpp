#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include "MEM.h"
#include "globals.h"

using namespace std;

MEM::MEM() {}

void MEM::load(string inst_file) {
	for (int i = 0; i < MEMSIZE; i++)
		memory[i] = 0;

	// Open files and read
	ifstream inst_f(inst_file);
	if (!inst_f)
		cerr << "Error: No instruction file!" << endl;
	
	
	uint32_t inst_id = 0;
	string line;
	while (getline(inst_f, line)) {
        if (line.empty()) continue;

        uint32_t inst = 0;
        stringstream ss;

        ss << hex << line;
        ss >> inst;
		memory[inst_id++] = inst;
    }

	// Check overflow
	if (inst_id >= TEXTEND)
		status = IMEM_OVERFLOW;
	else
		status = CONTINUE;
}

void MEM::imemAccess(uint32_t addr, uint32_t *inst) {
	// Check alignment + instruction memory capacity
	if (addr % 4 == 0) {
		addr = addr >> 2;
		if (addr >= TEXTEND) {
			status = IMEM_OVERFLOW; return;
		}
	}
	else {
		status = MEM_UNALIGNED; return;
	}

	*inst = memory[addr];

	// Instruction finished
	if (*inst == 0)
		status = TERMINATE;
}

void MEM::dmemAccess(uint32_t addr, uint32_t *read_data, uint32_t write_data, uint32_t MemRead, uint32_t MemWrite) {
	// Do not change the status is not intended to read or write
	if (!MemRead && !MemWrite) return;
	// Check alignment + data memory capacity
	if (addr % 4 == 0) {
		addr = addr >> 2;
		if (addr < DATASTART || addr >= DATAEND) {
			status = DMEM_OVERFLOW; return;
		}
	}
	else {
		status = MEM_UNALIGNED; return;
	}

	if (MemWrite)
		memory[addr] = write_data;
	else if (MemRead)
		*read_data = memory[addr];
}
