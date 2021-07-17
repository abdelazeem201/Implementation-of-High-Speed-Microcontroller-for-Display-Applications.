module true_dpram_sclk #(
parameter ADDR_W = 14,
parameter DATA_W = 3
)
(
	input [DATA_W-1:0] data_a, data_b,
	input [ADDR_W-1:0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [DATA_W-1:0] q_a, q_b
);
	// Declare the RAM variable
	reg [DATA_W-1:0] ram[2**ADDR_W-1:0] /* synthesis ramstyle = "M9K" */;
	
	initial begin
	ram[0] = 72;
	ram[1] = 69;
	ram[2] = 76;
	ram[3] = 76;
	ram[4] = 79;
	ram[5] = 105;
	
	
	end
	
	// Port A
	always @ (posedge clk)
	begin
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
		end
		else 
		begin
			q_a <= ram[addr_a];
		end
	end
	
	// Port B
	always @ (posedge clk)
	begin
		if (we_b)
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else
		begin
			q_b <= ram[addr_b];
		end
	end
	
endmodule
