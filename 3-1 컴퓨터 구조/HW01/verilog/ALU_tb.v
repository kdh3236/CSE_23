`timescale 1ns / 100ps

module ALU_tb;
	// FIXME (Set the number of tests)
	// Depending on the number of testcases you generate in the CPP code
	parameter TEST_SIZE = 1000;

	reg [31:0] operand1;
	reg [31:0] operand2;
	reg [4:0] shamt;
	reg [3:0] funct;
	
	wire [31:0] alu_result;

	reg [31:0] operand1_mem [0:TEST_SIZE-1];
	reg [31:0] operand2_mem [0:TEST_SIZE-1];
	reg [4:0]  shamt_mem [0:TEST_SIZE-1];
	reg [3:0]  funct_mem [0:TEST_SIZE-1];
	reg [31:0] alu_result_mem [0:TEST_SIZE-1];

	integer PASSED;
	integer FAILED;
	integer i;
	
	ALU alu_top (.operand1(operand1), .operand2(operand2),
				.shamt(shamt), .funct(funct), .alu_result(alu_result));
	
	task Test; 
		input [31:0] operand1_in;
		input [31:0] operand2_in;
		input [4:0] shamt_in;
		input [3:0] funct_in;
		input [31:0] alu_result_in;
	begin  
		operand1 = operand1_in;
		operand2 = operand2_in;
		shamt = shamt_in;
		funct = funct_in;
		$display("TEST CTRL Sig: %h :", funct);
		#1;
		if (alu_result == alu_result_in) begin
			$display("PASSED");
			PASSED = PASSED + 1;
		end
		else begin
			$display("FAILED");
			$display("funct: %d, operand1 = %d, operand2 = %d, shamt = %d, result = %h (Ans : %h)",
						funct, operand1, operand2, shamt, alu_result, alu_result_in);
			FAILED = FAILED + 1;
		end	
	end
	endtask

	// Load the data from the memory
	initial begin
		$readmemh("operand1.mem", operand1_mem);
		$readmemh("operand2.mem", operand2_mem);
		$readmemb("shamt.mem", shamt_mem);
		$readmemb("funct.mem", funct_mem);
		$readmemh("alu_result.mem", alu_result_mem);
	end
	
	
	initial begin
		i = 0;
		PASSED = 0;
		FAILED = 0;
		#10
		
		for (i = 0; i < TEST_SIZE; i = i + 1) begin
			Test(operand1_mem[i], operand2_mem[i], shamt_mem[i], funct_mem[i], alu_result_mem[i]);
		end
		
		#10
		$display("PASSED = %d, FAILED = %d", PASSED, FAILED);
		$finish;
	end
endmodule
