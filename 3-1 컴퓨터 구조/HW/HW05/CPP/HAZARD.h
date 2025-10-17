#ifndef HAZARD_H
#define HAZARD_H

#include <stdint.h>
#include "CTRL.h"

class HAZARD {
public:
    HAZARD();
    
    int check_data_hazard(uint32_t rs, uint32_t rt, uint32_t use_rs, uint32_t use_rt, uint32_t write_addr, uint32_t regWrite);
    int check_control_hazard(uint32_t Jump, uint32_t JR, uint32_t SavePc, uint32_t Branch, uint32_t Zero);
};


#endif // HAZARD.H
