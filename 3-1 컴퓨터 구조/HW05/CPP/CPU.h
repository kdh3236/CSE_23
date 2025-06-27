#ifndef CPU_H
#define CPU_H

#include <stdint.h>
#include "ALU.h"
#include "RF.h"
#include "MEM.h"
#include "CTRL.h"
#include "HAZARD.h"

struct IF_ID {
    uint32_t nextPC; // pc+4
    uint32_t inst;
};

struct ID_EX {
    CTRL::Controls_WB control_wb;
    CTRL::Controls_MEM control_mem;
    CTRL::Controls_EX control_ex;

    uint32_t jump_addr;
    uint32_t nextPC; // pc+4 for branch target address 

    uint32_t read_data1;
    uint32_t read_data2;
    uint32_t shamt;
    uint32_t immi; // sign extend 여부 신경써야함

    // WB address
    uint32_t rt_value; // for WB
    uint32_t rd_value; 
};

struct EX_MEM {
    CTRL::Controls_WB control_wb;
    CTRL::Controls_MEM control_mem;

    uint32_t branch_target_addr;

    uint32_t zero; // Branch에서 EQ, NEQ가 0이면 1로 세팅

    uint32_t regWrite_or_mem_addr;   
    uint32_t mem_write_data;

    uint32_t wb_addr;
};

struct MEM_WB {
    CTRL::Controls_WB control_wb;

    uint32_t mem_data;
    uint32_t regWrite_data;

    uint32_t wb_addr;
};

class CPU {
public:
    CPU(); // Constructor
	void init(std::string inst_file);
    uint32_t tick(); // Run simulation
    ALU alu;
    RF rf;
    CTRL ctrl;
	MEMORY mem;
    HAZARD hazard;

    // Latch
    struct IF_ID if_id;
    struct ID_EX id_ex;
    struct EX_MEM ex_mem;
    struct MEM_WB mem_wb;

    // latch 임시 저장용
    struct IF_ID next_if_id;
    struct ID_EX next_id_ex;
    struct EX_MEM next_ex_mem;
    struct MEM_WB next_mem_wb;

	// Act like a storage element
	uint32_t PC;
    uint32_t PCSource;
    uint32_t isStall;
    uint32_t stallCount;
    uint32_t isHazard;
};

#endif // CPU_H
