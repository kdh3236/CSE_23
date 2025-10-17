#include <fstream>
#include <bitset>
#include <iomanip>
#include "TOP.h"
#include "globals.h"

using namespace std;

TOP::TOP() {
	rf.init(true);
	std::ofstream fout_reg;
	fout_reg.open("initial_reg.mem");
	for (int i = 0; i < REGSIZE; i++)
		fout_reg << setw(8) << setfill('0') << hex << rf.register_files[i] << endl;
}

void TOP::tick(uint32_t rd_addr1, uint32_t rd_addr2,
		uint32_t wr_addr, uint32_t shamt, uint32_t aluop, uint32_t RegWrite,
		uint32_t *rd_data1, uint32_t *rd_data2, uint32_t *wr_data) {
	rf.read(rd_addr1, rd_addr2, rd_data1, rd_data2);
	alu.compute(*rd_data1, *rd_data2, shamt, aluop, wr_data);
	rf.write(wr_addr, *wr_data, RegWrite);
}

