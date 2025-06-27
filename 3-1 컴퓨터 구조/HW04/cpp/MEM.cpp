#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include "MEM.h"
#include "globals.h"

using namespace std;

MEMORY::MEMORY() {}

uint32_t MEMORY::load(string inst_file) { // 명령어 파일
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
		status = DMEM_OVERFLOW;
	else
		status = CONTINUE;

	return inst_id;
}

// wirte 면 write_data를 memory에 저장
// read 면 memory에서 read_data에 저장
void MEMORY::memAccess(uint32_t addr, uint32_t *read_data, uint32_t write_data, uint32_t MemRead, uint32_t MemWrite, u_int32_t IorD) {
	// Do not change the status is not intended to read or write
	if (!MemRead && !MemWrite) return;
	// Check alignment + data memory capacity
	if (addr % 4 == 0) { // Allinment okay
		addr = addr >> 2;
		if (addr >= DATAEND && IorD == 1) {
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
