`timescale 1ns / 100ps

module RF (
		input clk,
		input rst,
		// Read-related ports
		input [4:0] rd_addr1,
		input [4:0] rd_addr2,
		output reg [31:0] rd_data1,
		output reg [31:0] rd_data2,
		// Write-related ports
		input RegWrite,
		input [4:0] wr_addr,
		input [31:0] wr_data
	);

    reg [31:0] register_file [0:31];
	
	// FIXME (Perform Read Operation)
	always @(*) begin
		rd_data1 = register_file[rd_addr1];
		rd_data2 = register_file[rd_addr2]; 
	end
    
	always @(posedge clk) begin
		// Reset the regsiter file to pre-defined values
		if (rst) begin
        	$readmemh("initial_reg.mem", register_file);
		end
		else begin
			if (RegWrite) begin
		   		register_file[wr_addr] <= wr_data;
			end
		end
	end

endmodule
