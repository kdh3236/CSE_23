#ifndef TOP_H
#define TOP_H

#include <stdint.h>
#include "RF.h"
#include "ALU.h"

class TOP {
public:
    TOP();
	void tick(uint32_t rd_addr1, uint32_t rd_addr2,
		uint32_t wr_addr, uint32_t shamt, uint32_t aluop, uint32_t RegWrite,
		uint32_t *rd_data1, uint32_t *rd_data2, uint32_t *wr_data);

private:
    ALU alu;
	RF rf;
};

#endif // TOP_H
