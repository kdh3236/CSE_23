`timescale 1ns / 1ps


module TOP_tb;
	parameter TEST_SIZE = 10000;
    
    reg clk;
    reg rst;
    reg [4:0] rd_addr1;
    reg [4:0] rd_addr2;
    
    reg RegWrite;
    reg [4:0] wr_addr;
    
    reg [4:0] shamt;
    reg [3:0] funct;
    
	// List of output signals from the RF
    wire [31:0] rd_data1; 
    wire [31:0] rd_data2; 
    wire [31:0] wr_data;  

	reg [4:0]	rd_addr1_mem [0:TEST_SIZE-1];
	reg [4:0]	rd_addr2_mem [0:TEST_SIZE-1];
	reg [4:0]	wr_addr_mem [0:TEST_SIZE-1];
	reg [4:0]	shamt_mem [0:TEST_SIZE-1];
	reg [3:0]  	funct_mem [0:TEST_SIZE-1];
	reg 		RegWrite_mem [0:TEST_SIZE-1];
	reg [31:0] 	rd_data1_mem [0:TEST_SIZE-1];
	reg [31:0] 	rd_data2_mem [0:TEST_SIZE-1];
	reg [31:0] 	wr_data_mem [0:TEST_SIZE-1];

	// Load the data from the memory
	initial begin
		$readmemb("rd_addr1.mem", rd_addr1_mem);
		$readmemb("rd_addr2.mem", rd_addr2_mem);
		$readmemb("wr_addr.mem", wr_addr_mem);
		$readmemb("shamt.mem", shamt_mem);
		$readmemb("funct.mem", funct_mem);
		$readmemb("regwr.mem", RegWrite_mem);
		$readmemh("rd_data1.mem", rd_data1_mem);
		$readmemh("rd_data2.mem", rd_data2_mem);
		$readmemh("wr_data.mem", wr_data_mem);
	end

    TOP top_u (.clk(clk), .rst(rst),
        .rd_addr1(rd_addr1),
		.rd_addr2(rd_addr2),
        .RegWrite(RegWrite),
        .wr_addr(wr_addr),
        .shamt(shamt),
        .funct(funct),
        .rd_data1(rd_data1),
        .rd_data2(rd_data2),
        .wr_data(wr_data)
    );
    
    integer PASSED;
    integer FAILED;
     
    task Test; 
        input [4:0] rd_addr1_in;
        input [4:0] rd_addr2_in;
        input [4:0] wr_addr_in;
        input [4:0] shamt_in;
        input [5:0] funct_in;
        input RegWrite_in;
        input [31:0] rd_data1_in;
        input [31:0] rd_data2_in;
        input [31:0] wr_data_in;
    begin
        #1;
        rd_addr1 = rd_addr1_in;
        rd_addr2 = rd_addr2_in;
        wr_addr = wr_addr_in;
        shamt = shamt_in;
        funct = funct_in;
        RegWrite = RegWrite_in;
        
        #1;
        if (rd_data1 == rd_data1_in &&
			rd_data2 == rd_data2_in &&
			wr_data == wr_data_in) begin
                $display("PASSED");
                PASSED = PASSED + 1;
        end
        else begin
                $display("FAILED");
                $display("rd_addr1 = %d ", rd_addr1);
                $display("rd_data1 = %h (Ans : %h) ", rd_data1, rd_data1_in,
						 "rd_data2 = %h (Ans : %h) ", rd_data2, rd_data2_in,
						 "wr_data = %h (Ans : %h)", wr_data, wr_data_in);
                FAILED = FAILED + 1;
        end
        // Check prepare for the next cycle
        #8;
    end
    endtask
    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
	integer i;
    initial begin
		i = 0;
        PASSED = 0;
        FAILED = 0;
        rst = 1;
        RegWrite = 0;
        #15
        rst = 0;
        #10

		for (i = 0; i < TEST_SIZE; i = i + 1) begin
			Test(rd_addr1_mem[i], rd_addr2_mem[i], wr_addr_mem[i],
				shamt_mem[i], funct_mem[i], RegWrite_mem[i],
				rd_data1_mem[i], rd_data2_mem[i], wr_data_mem[i]);
		end

        #10
        $display("PASSED = %0d, FAILED = %0d", PASSED, FAILED);
        $finish;
    end

endmodule
