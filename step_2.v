`default_nettype none

module step_2(clk,addr,data,start,ready,rst,sda,scl);
	
	input	wire clk,rst;
	input	wire [6:0]addr;
	input	wire [7:0]data;
	input	wire start;
	output	wire scl;
	output	reg  sda;
	output	wire ready;
	
	localparam  idle         = 0,
				start_state  = 1,
				addr_state   = 2,
				rw           = 3,
				wack         = 4,
				data_state   = 5,
				wack_2       = 6,
				stop         = 7;
	
	reg [3:0] 	state;
	reg [6:0]	addr_reg;
	reg [7:0]	count;
	reg [7:0]	data_reg;
	reg 		scl_en = 0;
	
	assign scl   = (scl_en == 0) ? 1 : !clk;
	assign ready = ((rst == 0)&&(state == idle)) ? 1 : 0; 
	
	always@(negedge clk)
	begin : SCL_CLK
		if (rst == 1) begin
			//scl <= 1;
			//sda <= 1;
			scl_en <= 0;
		end else 
			begin
				if((state == idle) || (state == start_state) || (state == stop) || (state == wack_2)) begin
				//scl <= 1;
				//sda <= 1;
				scl_en <= 0;
				end
			else begin
				scl_en <= 1;
				end
			end
		end
		
		
	always@(posedge clk)
		begin:SEQ_OUT_LOGIC
		if(rst == 1) begin
			state <= idle;
			sda   <= 1;
			//scl   <= 1;
			//addr  <= 8'h1a;
			count <= 0;
			//data  <= 8'b01010101;
			end
			
		else begin
			sda   <= 1;
			case(state)
			
			idle:begin
				sda   <= 1;
				if(start) begin
					state    <= start_state;
					addr_reg <= addr;
					data_reg <= data;
				  end
					else state <= idle;
				end
			start_state:begin
				sda   <= 0;
				state <= addr_state;
				count <= 6;
				end
			addr_state:begin
				sda <= addr_reg[count];
				if(count == 0)
				state <= rw;
				else
				count <= count - 1;
				//sda <= 0;
				end
			rw:begin
				sda   <= 1;
				state <= wack;
				end
			wack:begin
				state <= data_state;
				sda <= 0;
				count <= 7;
				end
			data_state:begin
				sda <= data_reg[count];
				if(count == 0)
				state <= wack_2;
				else
				count <= count - 1;
				end
			wack_2:begin
				state <= stop;
				sda   <= 1;
				end
			stop:begin
				sda   <= 1;
				state <= idle;
				end
			endcase
		end
	end
endmodule
	
				
				
			