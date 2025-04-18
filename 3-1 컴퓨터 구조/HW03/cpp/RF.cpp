#include "RF.h"
#include "globals.h"
#include <iostream>
#include <cstdlib>
#include <iomanip>
#include <fstream>
#include <bitset>
#include <cstring>

using namespace std;

RF::RF() {}

void RF::init(bool random) {
	// generate random initial values and write the values to the file
	if (random) {
		for (int i = 0; i < REGSIZE; i++)
			register_files[i] = (rand() << 1) + rand();
	}
	else {
		for (int i = 0; i < REGSIZE; i++)
			register_files[i] = 0;
		// Set default $gp: global pointer 
		register_files[28] = 0x1800;
		// Set default $sp: stack pointer
		register_files[29] = 0x3ffc;
	}
}

void RF::read(uint32_t rd_addr1, uint32_t rd_addr2, uint32_t *rd_data1, uint32_t *rd_data2) {
	*rd_data1 = register_files[rd_addr1];
	*rd_data2 = register_files[rd_addr2];
}

void RF::write(uint32_t wr_addr, uint32_t wr_data, uint32_t RegWrite) {
	if (RegWrite == 1) {
		register_files[wr_addr] = wr_data;
	}
}

void RF::dump() {
	int i;
	const char reg_name[REGSIZE][6] = {
		"$zero", "$at", "$v0", "$v1", "$a0", "$a1", "$a2", "$a3",
		"$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7", 
		"$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7", 
		"$t8", "$t9", "$k0", "$k1", "$gp", "$sp", "$fp", "$ra"
	};
	char bb[] = "     ";

	for (i = 0; i < REGSIZE; i++)
	{
		fprintf(stdout, "%s%s %08x\n",
			reg_name[i], bb + strlen(reg_name[i]) * sizeof(char),
			register_files[i]);
	}
}
