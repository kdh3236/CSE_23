`timescale 1ns / 1ps


module CPU_tb;
	integer i;
	integer FAILED;

    reg clk;
    reg rst;
    
	wire halt;

	// Have the reference register & mem
    reg [31:0] register_file [0:31];
	reg [31:0] memory [0:8191];

    CPU cpu (.clk(clk), .rst(rst), .halt(halt));

	initial begin : REF_INIT
		$readmemh("reference_mem.mem", memory);
		$readmemh("reference_reg.mem", register_file);
	end
    

    initial begin : CLOCK_GENERATOR
        clk = 1'b0;
        forever #5 clk = ~clk;
    end
    
    initial begin : Settings
		FAILED = 0;
        rst = 1;
        #15
        rst = 0;
		@(posedge halt);
		$display("Program Terminate\n");

		for (i = 0; i < 32; i = i + 1) begin
			if (cpu.rf.register_file[i] != register_file[i]) begin
				FAILED = 1;
			end
		end
		for (i = 0; i < 8192; i = i + 1) begin
			if (cpu.mem.memory[i] != memory[i]) begin
				FAILED = 1;
			end
		end

		if (FAILED) begin
			$display("Simulation failed.");
			for (i = 0; i < 32; i = i + 1) begin
				$display("index: %d, dat: %h, %h", i, cpu.rf.register_file[i], register_file[i]);
			end
		end
		else
			$display("Simulation success!!!");
		$finish();
    end

endmodule
