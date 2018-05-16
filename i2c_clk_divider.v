module i2c_clk_divider(rst,ref_clk,i2c_clk);
	input wire rst,ref_clk;
	output reg i2c_clk;
	
	reg[9:0] count = 0;
	parameter ref_clk_freq = 1000;
	
	initial i2c_clk = 0;
	
	always@(posedge ref_clk)
		//begin
			//if(rst == 1)begin
			//i2c_clk <= 0;
			//count <= 0;
			//end
			
			//else begin
				if(count == ((ref_clk_freq/2)-1))begin
				i2c_clk <= !i2c_clk;
				count <= 0;
				end
				
				else begin
				count <= count + 1;
				end
			//end
		//end
endmodule