module i2c_fifo(clk,rst,addr_data,data_out,empty,full,wr_en,rd_en);
	input	wire 	clk,rst,wr_en,rd_en;
	input	wire 	addr_data;
	output	reg		data_out;
	output	reg		empty,full;
	
	
	reg     [14:0]	fifo_bank;
	reg		[2:0]	wr_state;
	reg		[2:0]	rd_state;
	reg		[14:0]	count;
	
	parameter 	idle      = 2'b00,
				start     = 2'b01,
				wr_data   = 2'b10,
				stop      = 2'b11;
	
	parameter 	idle_1    = 2'b00,
				start_1   = 2'b01,
				rd_data_1 = 2'b10,
				stop_1    = 2'b11;
					
	
	
	always@(posedge clk)
		begin
			if(rst == 1)begin
			fifo_bank <= 0;
			wr_state  <= idle;
			rd_state  <= idle_1;
			end
			
			else begin
			wr_state <= start;
			rd_state <= start_1;
			end
		end
	
	always@(posedge clk)
		begin:WRITE
			case (wr_state)
			
			idle:begin
					wr_state <= start;
				end
			start:begin
					if(wr_en == 1)begin
						wr_state <= wr_data;
						count <= 14;
					end
					else if((wr_en == 1) && (rd_en == 1))begin
							wr_state <= wr_data;
							end
					else wr_state <= idle;
				end
			wr_data:begin
					fifo_bank[count] <= addr_data;
						if(count == 0)
							wr_state <= stop;
						else
						count <= count - 1;
					end
				stop:begin
					data_out <= 0;
					wr_state    <= idle;
					end
			endcase	
		end	
					
		always@(posedge clk)
		begin:READ
			case (rd_state)
		
			idle_1:begin
					rd_state <= start_1;
				end
			start_1:begin
					if(rd_en == 1)begin
						rd_state <= rd_data_1;
						count <= 14;
					end
					else if((wr_en == 1) && (rd_en == 1))begin
							rd_state <= rd_data_1;
							end
					else rd_state <= idle_1;
				end
			rd_data_1:begin
					data_out <= fifo_bank[count];
						if(count == 0)
							rd_state <= stop_1;
						else
						count <= count - 1;
					end
			stop_1:begin
					data_out <= 0;
					rd_state <= idle_1;
				end
			endcase
		end
			
endmodule			
				
				
				
				
				
				
				
				
				
				
				
				
				
					
						
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			