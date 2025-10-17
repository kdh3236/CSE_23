`timescale 1ns / 1ps
`include "GLOBAL.v"

module CTRL(
    input  [5:0] opcode,
    input  [5:0] funct,
    output reg RegDst,
    output reg Jump,
    output reg Branch,
    output reg JR,
    output reg MemRead,
    output reg MemtoReg,
    output reg MemWrite,
    output reg ALUSrc,
    output reg SignExtend,
    output reg RegWrite,
    output reg [3:0] ALUOp,
    output reg SavePC
);

    always @(*) begin
        RegDst      = 0;
        Jump        = 0;
        Branch      = 0;
        JR          = 0;
        MemRead     = 0;
        MemtoReg    = 0;
        MemWrite    = 0;
        ALUSrc      = 0;
        SignExtend  = 1;
        RegWrite    = 0;
        ALUOp       = 4'b1111;
        SavePC      = 0;

        if (opcode == `OP_RTYPE) begin
            RegDst = 1;
            RegWrite = (funct != `FUNCT_JR);
            case (funct)
                `FUNCT_SLL:  ALUOp = `ALU_SLL;
                `FUNCT_SRL:  ALUOp = `ALU_SRL;
                `FUNCT_SRA:  ALUOp = `ALU_SRA;
                `FUNCT_JR: begin
                    JR = 1;
                    Jump = 1;
                end
                `FUNCT_ADDU: ALUOp = `ALU_ADDU;
                `FUNCT_SUBU: ALUOp = `ALU_SUBU;
                `FUNCT_AND:  ALUOp = `ALU_AND;
                `FUNCT_OR:   ALUOp = `ALU_OR;
                `FUNCT_XOR:  ALUOp = `ALU_XOR;
                `FUNCT_NOR:  ALUOp = `ALU_NOR;
                `FUNCT_SLT:  ALUOp = `ALU_SLT;
                `FUNCT_SLTU: ALUOp = `ALU_SLTU;
                default: ;
            endcase
        end
        else if (opcode == `OP_J) begin
            Jump = 1;
        end
        else if (opcode == `OP_JAL) begin
            Jump = 1;
            RegWrite = 1;
            SavePC = 1;
        end
        else if (opcode == `OP_BEQ) begin
            ALUOp = `ALU_EQ;
            Branch = 1;
        end
        else if (opcode == `OP_BNE) begin
            ALUOp = `ALU_NEQ;
            Branch = 1;
        end
        else if (opcode == `OP_ADDIU) begin
            ALUOp = `ALU_ADDU;
            ALUSrc = 1;
            RegWrite = 1;
        end
        else if (opcode == `OP_SLTI) begin
            ALUOp = `ALU_SLT;
            ALUSrc = 1;
            RegWrite = 1;
        end
        else if (opcode == `OP_SLTIU) begin
            ALUOp = `ALU_SLTU;
            ALUSrc = 1;
            RegWrite = 1;
        end
        else if (opcode == `OP_ANDI) begin
            ALUOp = `ALU_AND;
            ALUSrc = 1;
            RegWrite = 1;
            SignExtend = 0;
        end
        else if (opcode == `OP_ORI) begin
            ALUOp = `ALU_OR;
            ALUSrc = 1;
            RegWrite = 1;
            SignExtend = 0;
        end
        else if (opcode == `OP_XORI) begin
            ALUOp = `ALU_XOR;
            ALUSrc = 1;
            RegWrite = 1;
            SignExtend = 0;
        end
        else if (opcode == `OP_LUI) begin
            ALUOp = `ALU_LUI;
            RegWrite = 1;
        end
        else if (opcode == `OP_LW) begin
            ALUOp = `ALU_ADDU;
            MemRead = 1;
            ALUSrc = 1;
            MemtoReg = 1;
            RegWrite = 1;
        end
        else if (opcode == `OP_SW) begin
            ALUOp = `ALU_ADDU;
            MemWrite = 1;
            ALUSrc = 1;
        end
    end

endmodule
