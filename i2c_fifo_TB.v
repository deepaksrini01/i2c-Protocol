`timescale 1ns / 1ps



module i2c_fifo_TB;

		reg	    clk,rst,wr_en,rd_en;
		reg 	addr_data;
	    wire	data_out;
		wire	empty,full;
	
	i2c_fifo uut_1 (
		.clk(clk), 
		.rst(rst),  
		.wr_en(wr_en),
		.rd_en(rd_en),
		.addr_data(addr_data),
		.data_out(data_out)
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
		#10 rst = 1;
		#20 rst = 0;
			
		#10 addr_data =0;
		#10 addr_data =0;
		#10 addr_data =0;
		#10 addr_data =1;
		#10 addr_data =1;
		#10 addr_data =0;
		#10 addr_data =0;
		#10 addr_data =0;
		#10 addr_data =0;
		#10 addr_data =1;
		#10 addr_data =0;
		#10 addr_data =1;
		#10 addr_data =0;
		#10 addr_data =1;
		#10 addr_data =0;
		#10 wr_en = 1;
		#100 wr_en = 0;
		
		#50 rd_en = 1;
		#100 rd_en = 0;
		
		#500 $finish;
		// Add stimulus here

	end
      
endmodule

