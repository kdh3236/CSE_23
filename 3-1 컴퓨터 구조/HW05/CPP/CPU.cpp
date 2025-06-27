#include <iomanip>
#include <iostream>
#include "CPU.h"
#include "globals.h"
#include "CTRL.h"
#include "HAZARD.h"

using namespace std;

CPU::CPU() {}

void CPU::init(string inst_file) {
    rf.init(false);
    mem.load(inst_file);

    // Initialize latch
    if_id.inst = 0;
    if_id.nextPC = 0;

    id_ex.immi = 0;
    id_ex.jump_addr = 0;
    id_ex.nextPC = 0;
    id_ex.rd_value = 0;
    id_ex.read_data1 = 0;
    id_ex.read_data2 = 0;
    id_ex.rt_value = 0;
    id_ex.shamt = 0;

    id_ex.control_ex.ALUOp = 0;
    id_ex.control_ex.ALUSrc = 0;
    id_ex.control_ex.JR = 0;
    id_ex.control_ex.Jump = 0;
    id_ex.control_ex.RegDst = 0;
    id_ex.control_ex.RegWrite = 0;
    id_ex.control_ex.SavePC = 0;
    id_ex.control_mem.Branch = 0;
    id_ex.control_mem.MemRead = 0;
    id_ex.control_mem.MemWrite = 0;
    id_ex.control_mem.RegWrite = 0;
    id_ex.control_wb.MemtoReg = 0;
    id_ex.control_wb.RegWrite = 0;

    ex_mem.branch_target_addr = 0;
    ex_mem.mem_write_data = 0;
    ex_mem.regWrite_or_mem_addr = 0;
    ex_mem.wb_addr = 0;
    ex_mem.zero = 0;
    ex_mem.control_mem.Branch = 0;
    ex_mem.control_mem.MemRead = 0;
    ex_mem.control_mem.MemWrite = 0;
    ex_mem.control_mem.RegWrite = 0;
    ex_mem.control_wb.MemtoReg = 0;
    ex_mem.control_wb.RegWrite = 0;

    mem_wb.mem_data = 0;
    mem_wb.regWrite_data = 0;
    mem_wb.wb_addr = 0;

    mem_wb.control_wb.MemtoReg = 0;
    mem_wb.control_wb.RegWrite = 0;

    PC = 0;
    PCSource = 0;
    isStall = 0;
    isHazard = 0; 
    stallCount = 0;

    status = CONTINUE;
}

// This is a cycle-accurate simulation
uint32_t CPU::tick() {
    // These are just one of the implementations ...
    // parsed & control signals (wire)
    CTRL::ParsedInst parsed_inst;
    CTRL::Controls_ID id_control;
    CTRL::Controls_EX ex_control;
    CTRL::Controls_MEM mem_control;
    CTRL::Controls_WB wb_control;

    uint32_t inst_if = 0;

    uint32_t jump_target_id = 0;
    uint32_t rs_data_id = 0;
    uint32_t rt_data_id = 0;
    uint32_t ext_imm_id = 0;
    uint32_t wr_addr_id = 0;

    uint32_t operand1_ex = 0;
    uint32_t operand2_ex = 0;
    uint32_t alu_result_ex = 0;
    uint32_t branch_addr_ex = 0;
    uint32_t write_data_or_mem_addr_ex = 0;
    uint32_t wr_addr_ex = 0;

    uint32_t wr_addr_mem = 0;
    uint32_t mem_data_mem = 0;

    uint32_t wr_addr_wb = 0;
    uint32_t wr_data_wb = 0;

    // PC 값 업데이트를 위한 wires
    uint32_t PC_4 = 0;
    uint32_t PC_Branch = 0;
    uint32_t PC_Jump = 0;
    uint32_t PC_JR = 0;

    // PC값을 하나만 업데이트 하기 위해 PC_next는 따로 설정
    PCSource = 0;

    // IF
    // isStall일 때 PC를 갱신하지 않고 현재 명령어를 다시 fetch 시도.
    // next_if_id 래치에 현재 if_id 래치 내용을 유지시켜 PC가 바뀌지 않도록 함.
    if (isStall) {
        cout << "[IF] not operate due to stall. Left Stall cycle:" << stallCount << endl;
        next_if_id.nextPC = if_id.nextPC; // PC가 증가하지 않도록 현재 nextPC 유지
        next_if_id.inst = if_id.inst;     // 현재 명령어 유지
    } else {
        // Access the instruction memory
        mem.imemAccess(PC, &inst_if);
        if (status != CONTINUE) return 0;
        PC_4 = PC + 4;

        // Latch 관리
        next_if_id.nextPC = PC_4;
        next_if_id.inst = inst_if;

        cout << "[IF] PC is 0x" << hex << PC << " inst is 0x" << inst_if << endl;
    }
    cout << endl;


    // ID stage는 IF/ID 래치로부터 명령어를 가져와 처리함.
    // isStall인 경우, ID/EX latch를 flush
    if (isStall) {

        next_id_ex.immi = 0;
        next_id_ex.jump_addr = 0;
        next_id_ex.nextPC = 0;
        next_id_ex.rd_value = 0;
        next_id_ex.read_data1 = 0;
        next_id_ex.read_data2 = 0;
        next_id_ex.rt_value = 0;
        next_id_ex.shamt = 0;
        next_id_ex.control_ex.ALUOp = 0;
        next_id_ex.control_ex.ALUSrc = 0;
        next_id_ex.control_ex.JR = 0;
        next_id_ex.control_ex.Jump = 0;
        next_id_ex.control_ex.RegDst = 0;
        next_id_ex.control_ex.RegWrite = 0;
        next_id_ex.control_ex.SavePC = 0;

        next_id_ex.control_mem.Branch = 0;
        next_id_ex.control_mem.MemRead = 0;
        next_id_ex.control_mem.MemWrite = 0;
        next_id_ex.control_mem.RegWrite = 0; 

        next_id_ex.control_wb.MemtoReg = 0;
        next_id_ex.control_wb.RegWrite = 0; 

    } else {
        cout << "[ID] Inst is 0x" << hex << if_id.inst << endl;
        ctrl.splitInst(if_id.inst, &parsed_inst);

        rf.read(parsed_inst.rs, parsed_inst.rt, &rs_data_id, &rt_data_id);
        ctrl.controlSignal(parsed_inst.opcode, parsed_inst.funct, &id_control, &ex_control,
                            &mem_control, &wb_control);

        ctrl.signExtend(parsed_inst.immi, id_control.SignExtend, &ext_imm_id);
        if (status != CONTINUE) return 0;

        jump_target_id = (if_id.nextPC & 0xF0000000) | (parsed_inst.immj << 2);
        if (id_control.Jump) {
            PC_Jump = jump_target_id;
            PCSource = 2;
        }

        // control hazard check 
        if (hazard.check_control_hazard(id_control.Jump, 0, 0, 0, 0)) {
            cout << "[ID] control hazard detected, Jump: " << id_control.Jump << endl;
            // IF FLUSH
            next_if_id.inst = 0;
            next_if_id.nextPC = 0;
        }

        // Data hazard check
        wr_addr_id = (id_ex.control_wb.RegWrite || id_ex.control_mem.RegWrite || id_ex.control_ex.RegWrite) ?
                     (id_ex.control_ex.SavePC ? 31 : (id_ex.control_ex.RegDst ? id_ex.rd_value : id_ex.rt_value)) : 0; 

        bool stall_3_cycle = hazard.check_data_hazard(parsed_inst.rs, parsed_inst.rt, id_control.use_rs, id_control.use_rt, wr_addr_id, id_ex.control_ex.RegWrite);
        bool stall_2_cycle = hazard.check_data_hazard(parsed_inst.rs, parsed_inst.rt, id_control.use_rs, id_control.use_rt, ex_mem.wb_addr, ex_mem.control_mem.RegWrite);
        bool stall_1_cycle = hazard.check_data_hazard(parsed_inst.rs, parsed_inst.rt, id_control.use_rs, id_control.use_rt, mem_wb.wb_addr, mem_wb.control_wb.RegWrite);

        if (stall_3_cycle || stall_2_cycle || stall_1_cycle) {
            isStall = 1;
            if (stall_3_cycle) {
                stallCount = 3;
                cout << "[ID] 3 cycle stall detected" << endl;
            } else if (stall_2_cycle) {
                stallCount = 2;
                cout << "[ID] 2 cycle stall detected" << endl;
            } else {
                stallCount = 1;
                cout << "[ID] 1 cycle stall detected" << endl;
            }
            
            // 3 cycle인 경우 id/ex를 flush 해버리면 다음에 실행될 ex stage의 명령어가 사라짐짐
			if ((!stall_3_cycle && stall_2_cycle) || (!stall_3_cycle && stall_1_cycle)) {
				next_id_ex.immi = 0;
				next_id_ex.jump_addr = 0;
				next_id_ex.nextPC = 0;
				next_id_ex.rd_value = 0;
				next_id_ex.read_data1 = 0;
				next_id_ex.read_data2 = 0;
				next_id_ex.rt_value = 0;
				next_id_ex.shamt = 0;
				next_id_ex.control_ex.ALUOp = 0;
				next_id_ex.control_ex.ALUSrc = 0;
				next_id_ex.control_ex.JR = 0;
				next_id_ex.control_ex.Jump = 0;
				next_id_ex.control_ex.RegDst = 0;
				next_id_ex.control_ex.RegWrite = 0;
				next_id_ex.control_ex.SavePC = 0;

				next_id_ex.control_mem.Branch = 0;
				next_id_ex.control_mem.MemRead = 0;
				next_id_ex.control_mem.MemWrite = 0;
				next_id_ex.control_mem.RegWrite = 0;

				next_id_ex.control_wb.MemtoReg = 0;
				next_id_ex.control_wb.RegWrite = 0;
			}
        } else { // Not stall
            next_id_ex.control_ex = ex_control;
            next_id_ex.control_mem = mem_control;
            next_id_ex.control_wb = wb_control;
            next_id_ex.jump_addr = jump_target_id;
            next_id_ex.nextPC = if_id.nextPC;
            next_id_ex.read_data1 = rs_data_id;
            next_id_ex.read_data2 = rt_data_id;
            next_id_ex.shamt = parsed_inst.shamt;
            next_id_ex.immi = ext_imm_id; 
            next_id_ex.rt_value = parsed_inst.rt;
            next_id_ex.rd_value = parsed_inst.rd;
        }

        cout << "[ID] rs: $" << dec << parsed_inst.rs << ", rt: $" << parsed_inst.rt
             << ", rd: $" << parsed_inst.rd << ", imm: 0x" << hex << parsed_inst.immi << endl;
        cout << "[ID] control: Jump=" << id_control.Jump
             << ", Sign extend=" << id_control.SignExtend << endl;
        cout << endl;
    }

    // EX 
    operand1_ex = id_ex.read_data1;
    operand2_ex = id_ex.control_ex.ALUSrc ? id_ex.immi : id_ex.read_data2;
    cout << "[EX] operand1 = 0x" << hex << operand1_ex << ", operand2 = 0x" << operand2_ex << endl;
    alu.compute(operand1_ex, operand2_ex, id_ex.shamt, id_ex.control_ex.ALUOp, &alu_result_ex);
    if (status != CONTINUE) return 0;
    wr_addr_ex = id_ex.control_ex.SavePC ? 31 : (id_ex.control_ex.RegDst ? id_ex.rd_value : id_ex.rt_value);


    cout << "[EX] ALU operation: result = 0x" << hex << alu_result_ex << ", write addr = $" << dec << wr_addr_ex << endl;
    cout << endl;

    if (id_ex.control_ex.JR && id_ex.control_ex.Jump) { // JR
        PCSource = 3;
        PC_JR = id_ex.read_data1; 
    } else if (id_ex.control_ex.Jump && !id_ex.control_ex.JR) {
        // JAL은 jump_addr 사용
        PCSource = 2;
        PC_Jump = id_ex.jump_addr;
    }

    branch_addr_ex = id_ex.nextPC + (id_ex.immi << 2);
    // JAL 명령어일 경우 $ra에 저장될 값은 id_ex.nextPC (PC+4)
    write_data_or_mem_addr_ex = id_ex.control_ex.SavePC ? id_ex.nextPC : alu_result_ex;

    // Latch
    next_ex_mem.control_mem = id_ex.control_mem;
    next_ex_mem.control_wb = id_ex.control_wb;
    next_ex_mem.branch_target_addr = branch_addr_ex;
    next_ex_mem.zero = (alu_result_ex == 0) ? 1 : 0; 
    next_ex_mem.regWrite_or_mem_addr = write_data_or_mem_addr_ex;
    next_ex_mem.mem_write_data = id_ex.read_data2;
    next_ex_mem.wb_addr = wr_addr_ex;

    // control hazard check 
    if (hazard.check_control_hazard(id_ex.control_ex.Jump, id_ex.control_ex.JR, id_ex.control_ex.SavePC, 0, 0)) {
        cout << "[EX] control hazard detected, Jump: " << id_ex.control_ex.Jump << " , JR: "
             << id_ex.control_ex.JR << " , Jal: " << id_ex.control_ex.SavePC << endl;
        next_if_id.inst = 0;
        next_if_id.nextPC = 0;

        next_id_ex.immi = 0;
        next_id_ex.jump_addr = 0;
        next_id_ex.nextPC = 0;
        next_id_ex.rd_value = 0;
        next_id_ex.read_data1 = 0;
        next_id_ex.read_data2 = 0;
        next_id_ex.rt_value = 0;
        next_id_ex.shamt = 0;
        next_id_ex.control_ex.ALUOp = 0;
        next_id_ex.control_ex.ALUSrc = 0;
        next_id_ex.control_ex.JR = 0;
        next_id_ex.control_ex.Jump = 0;
        next_id_ex.control_ex.RegDst = 0;
        next_id_ex.control_ex.RegWrite = 0;
        next_id_ex.control_ex.SavePC = 0;
        next_id_ex.control_mem.Branch = 0;
        next_id_ex.control_mem.MemRead = 0;
        next_id_ex.control_mem.MemWrite = 0;
        next_id_ex.control_mem.RegWrite = 0;
        next_id_ex.control_wb.MemtoReg = 0;
        next_id_ex.control_wb.RegWrite = 0;
    }

    // MEM
    wr_addr_mem = ex_mem.wb_addr;
    cout << "[MEM] mem addr: 0x" << hex << ex_mem.regWrite_or_mem_addr << ", write_data: " << ex_mem.mem_write_data << endl;
    cout << "[MEM] memRead: " << ex_mem.control_mem.MemRead << ", memWrite: " << ex_mem.control_mem.MemWrite << endl;
    mem.dmemAccess(ex_mem.regWrite_or_mem_addr, &mem_data_mem, ex_mem.mem_write_data, ex_mem.control_mem.MemRead, ex_mem.control_mem.MemWrite);
    if (status != CONTINUE) return 0;

    // Branch 
    if (ex_mem.control_mem.Branch && ex_mem.zero) {
        PCSource = 1;
        PC_Branch = ex_mem.branch_target_addr;
    }

    next_mem_wb.control_wb = ex_mem.control_wb;
    cout << "[DEBUG] mem data mem: " << mem_data_mem << endl;
    next_mem_wb.mem_data = mem_data_mem;
    next_mem_wb.regWrite_data = ex_mem.regWrite_or_mem_addr;
    next_mem_wb.wb_addr = wr_addr_mem;

    // control hazard check 
    if (hazard.check_control_hazard(0, 0, 0, ex_mem.control_mem.Branch, ex_mem.zero)) {
        cout << "[MEM] control hazard detected, Branch: " << ex_mem.control_mem.Branch << " , Zero: " << ex_mem.zero << endl;
        next_if_id.inst = 0;
        next_if_id.nextPC = 0;

        next_id_ex.immi = 0;
        next_id_ex.jump_addr = 0;
        next_id_ex.nextPC = 0;
        next_id_ex.rd_value = 0;
        next_id_ex.read_data1 = 0;
        next_id_ex.read_data2 = 0;
        next_id_ex.rt_value = 0;
        next_id_ex.shamt = 0;
        next_id_ex.control_ex.ALUOp = 0;
        next_id_ex.control_ex.ALUSrc = 0;
        next_id_ex.control_ex.JR = 0;
        next_id_ex.control_ex.Jump = 0;
        next_id_ex.control_ex.RegDst = 0;
        next_id_ex.control_ex.RegWrite = 0;
        next_id_ex.control_ex.SavePC = 0;
        next_id_ex.control_mem.Branch = 0;
        next_id_ex.control_mem.MemRead = 0;
        next_id_ex.control_mem.MemWrite = 0;
        next_id_ex.control_mem.RegWrite = 0;
        next_id_ex.control_wb.MemtoReg = 0;
        next_id_ex.control_wb.RegWrite = 0;

        next_ex_mem.branch_target_addr = 0;
        next_ex_mem.mem_write_data = 0;
        next_ex_mem.regWrite_or_mem_addr = 0;
        next_ex_mem.wb_addr = 0;
        next_ex_mem.zero = 0;
        next_ex_mem.control_mem.Branch = 0;
        next_ex_mem.control_mem.MemRead = 0;
        next_ex_mem.control_mem.MemWrite = 0;
        next_ex_mem.control_mem.RegWrite = 0;
        next_ex_mem.control_wb.MemtoReg = 0;
        next_ex_mem.control_wb.RegWrite = 0;
    }
    cout << "[MEM] dmemAccess - addr: 0x" << hex << ex_mem.regWrite_or_mem_addr
         << ", writeData: 0x" << ex_mem.mem_write_data
         << ", MemRead=" << ex_mem.control_mem.MemRead
         << ", MemWrite=" << ex_mem.control_mem.MemWrite << endl;
    cout << endl;

    // WB
    wr_addr_wb = mem_wb.wb_addr;
    // MemtoReg 
    wr_data_wb = mem_wb.control_wb.MemtoReg ? mem_wb.mem_data : mem_wb.regWrite_data;


    cout << "[WB] MemtoReg: " << mem_wb.control_wb.MemtoReg << ", regWrite_data: "
         << mem_wb.regWrite_data << ", mem_data: " << mem_wb.mem_data << endl;
    cout << "[WB] WriteBack - addr: $" << dec << wr_addr_wb
         << ", data: 0x" << hex << wr_data_wb
         << ", RegWrite=" << mem_wb.control_wb.RegWrite << endl;
    cout << endl;

    rf.write(wr_addr_wb, wr_data_wb, mem_wb.control_wb.RegWrite);
    if (status != CONTINUE) return 0;

    // Latch update
    if_id = next_if_id;
    id_ex = next_id_ex;
    ex_mem = next_ex_mem;
    mem_wb = next_mem_wb;

    // PC update
    if (!isStall) {
        if (PCSource == 0) PC = PC_4;
        else if (PCSource == 1) PC = PC_Branch;
        else if (PCSource == 2) PC = PC_Jump;
        else if (PCSource == 3) PC = PC_JR;
    } else {
        // Stall이라면 count만 감소하고 다른 행동 x
        stallCount--;
        if (stallCount == 0) {
            isStall = 0; 
        }
    }

    return 1;
}