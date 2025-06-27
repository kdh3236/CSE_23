#include "globals.h"
#include "HAZARD.h"

HAZARD::HAZARD() {}

int HAZARD::check_data_hazard(uint32_t rs, uint32_t rt, uint32_t use_rs, uint32_t use_rt, uint32_t write_addr, uint32_t regWrite) {
    if (use_rs && (rs == write_addr) && regWrite) {
        return 1; 
    }

    if (use_rt && (rt == write_addr) && regWrite) {
        return 1; 
    }

    return 0;
}

int HAZARD::check_control_hazard(uint32_t Jump, uint32_t JR, uint32_t SavePc, uint32_t Branch, uint32_t Zero) {
    if (Jump) { 
        return 1;
    }
    else if (JR || SavePc) { 
        return 1;
    }

    else if (Branch && Zero) { 
        return 1; 
    }
    
    return 0;
}