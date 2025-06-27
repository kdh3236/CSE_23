`timescale 1ns / 1ps
`include "GLOBAL.v"

module CTRL(
	// input opcode and funct
	input [5:0] opcode,
	input [5:0] funct,

	// output various ports
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
		RegDst = 0;
		Jump = 0;
		Branch = 0;
		JR = 0;
		MemRead = 0;
		MemtoReg = 0;
		MemWrite = 0;
		ALUSrc = 0;
		SignExtend = 1;
		RegWrite = 0;
		SavePC = 0;
		ALUOp = 4'b1111;

		if (opcode == 6'd0) begin  // R-type
			RegDst = 1;
			RegWrite = 1; // JR 제외

			case (funct)
				6'd0:  ALUOp = 4'd4;  // SLL
				6'd2:  ALUOp = 4'd6;  // SRL
				6'd3:  ALUOp = 4'd5;  // SRA
				6'd8: begin JR = 1; Jump = 1; RegWrite = 1; end  // JR
				6'd33: ALUOp = 4'd0;  // ADDU
				6'd35: ALUOp = 4'd7;  // SUBU
				6'd36: ALUOp = 4'd1;  // AND
				6'd37: ALUOp = 4'd3;  // OR
				6'd38: ALUOp = 4'd8;  // XOR
				6'd39: ALUOp = 4'd2;  // NOR
				6'd42: ALUOp = 4'd9;  // SLT
				6'd43: ALUOp = 4'd10; // SLTU
			endcase
		end
		else begin
			case (opcode)
				6'd2: Jump = 1;                    // J
				6'd3: begin Jump = 1; RegWrite = 1; SavePC = 1; end // JAL
				6'd4: begin ALUOp = 4'd11; Branch = 1; end  // BEQ
				6'd5: begin ALUOp = 4'd12; Branch = 1; end  // BNE
				6'd9: begin ALUOp = 4'd0; ALUSrc = 1; RegWrite = 1; end // ADDIU
				6'd10: begin ALUOp = 4'd9; ALUSrc = 1; RegWrite = 1; end // SLTI
				6'd11: begin ALUOp = 4'd10; ALUSrc = 1; RegWrite = 1; end // SLTIU
				6'd12: begin ALUOp = 4'd1; ALUSrc = 1; RegWrite = 1; SignExtend = 0; end // ANDI
				6'd13: begin ALUOp = 4'd3; ALUSrc = 1; RegWrite = 1; SignExtend = 0; end // ORI
				6'd14: begin ALUOp = 4'd8; ALUSrc = 1; RegWrite = 1; SignExtend = 0; end // XORI
				6'd15: begin ALUOp = 4'd13; RegWrite = 1; end // LUI
				6'd35: begin ALUOp = 4'd0; MemRead = 1; ALUSrc = 1; MemtoReg = 1; RegWrite = 1; end // LW
				6'd43: begin ALUOp = 4'd0; MemWrite = 1; ALUSrc = 1; end // SW
			endcase
		end
	end
endmodule
