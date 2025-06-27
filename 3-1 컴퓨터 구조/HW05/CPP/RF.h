#ifndef RF_H
#define RF_H

#include <stdint.h>
#define REGSIZE 32

class RF {
public:
    RF();
	void init(bool random);
    void read(uint32_t rd_addr1, uint32_t rd_addr2, uint32_t *rd_data1, uint32_t *rd_data2);
    void write(uint32_t wr_addr, uint32_t wr_data, uint32_t RegWrite);
	void dump();
	uint32_t register_files[REGSIZE];
};

#endif // RF_H
