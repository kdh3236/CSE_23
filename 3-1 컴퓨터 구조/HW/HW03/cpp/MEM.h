#ifndef MEM_H
#define MEM_H

#include <stdint.h>
#include <string>

#define TEXTSTART	(0)
#define TEXTEND		(4096 >> 2)

// Define the start address of the data region (global data)
#define DATASTART	(4096 >> 2)
#define DATAEND		(32768 >> 2)
#define MEMSIZE		(32768 >> 2)

class MEM {
public:
    MEM();
	void load(std::string inst_file);
	void imemAccess(uint32_t addr, uint32_t *inst);
	void dmemAccess(uint32_t addr, uint32_t *read_data, uint32_t write_data, uint32_t MemRead, uint32_t MemWrite);
	uint32_t memory[MEMSIZE];
};

#endif // MEM_H
