#ifndef CPU_H
#define CPU_H


#include <stdint.h>
#include "ALU.h"
#include "RF.h"
#include "MEM.h"
#include "CTRL.h"
#include "globals.h"

class CPU {
public:
    CPU(); // Constructor
	void init(std::string inst_file);
    void initResource();
    uint32_t tick(); // Run simulation
    ALU alu;
    RF rf;
    CTRL ctrl;
	MEMORY mem;

	// Act like a storage element
	uint32_t PC;

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
    State states; 
    uint32_t program_size;
};

#endif // CPU_H

