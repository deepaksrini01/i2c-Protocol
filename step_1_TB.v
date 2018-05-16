`timescale 1ns / 1ps



module step_1_TB;

	// Inputs
	reg clk;
	reg rst;
	reg ref_clk;
	// Outputs
	wire sda;
	wire scl;
	wire i2c_clk;
	
	i2c_clk_divider uut_1 (
		.ref_clk(clk), 
		.rst(rst),  
		.i2c_clk(i2c_clk)
	);
	// Instantiate the Unit Under Test (UUT)
	step_1 uut_2 (
		.clk(i2c_clk), 
		.rst(rst), 
		.sda(sda), 
		.scl(scl)
	);

	
	initial begin
		// Initialize Inputs
		clk = 0;
		rst = 0;
		forever begin
			#5 clk = !clk;
		end
	end

	initial
		begin// Wait 100 ns for global reset to finish
		#50000 rst = 1;
		#50000 rst = 0;
        
		// Add stimulus here

	end
      
endmodule

