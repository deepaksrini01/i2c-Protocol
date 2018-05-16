module step_1(clk,rst,sda,scl);
	
	input	wire clk,rst;
	output	wire scl;
	output	reg  sda;
	
	localparam idle    = 0,
				start  = 1,
				addr_state   = 2,
				rw     = 3,
				wack   = 4,
				data_state   = 5,
				wack_2 = 6,
				stop   = 7;
	
	reg [3:0] 	state;
	reg [6:0]	addr;
	reg [7:0]	count;
	reg [7:0]	data;
	reg 		scl_en = 0;
	
	assign scl = (scl_en == 0) ? 1 : !clk;
	
	always@(negedge clk)
	begin : SCL_CLK
		if (rst == 1) begin
			//scl <= 1;
			//sda <= 1;
			scl_en <= 0;
		end else 
			begin
				if((state == idle) || (state == start) || (state == stop) || (state == wack_2)) begin
				//scl <= 1;
				//sda <= 1;
				scl_en <= 0;
				end
			else begin //else if((state == wack) || (state == addr_state) || (state == data_state) || (state == rw)) begin
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
			addr  <= 7'h1a;
			count <= 8'b0;
			data  <= 8'b01010101;
			end
			
		else begin
			sda   <= 1;
			case(state)
			
			idle:begin
				sda   <= 1;
				state <= start;
				end
			start:begin
				sda   <= 0;
				state <= addr_state;
				count <= 6;
				end
			addr_state:begin
				sda <= addr[count];
				if(count == 0)
				state <= rw;
				else
				count <= count - 1;
				//sda <= 0;
				end
			rw:begin
				sda   <= 0;
				state <= wack;
				end
			wack:begin
				state <= data_state;
				sda   <= 1;
				count <= 7;
				end
			data_state:begin
				sda <= data[count];
				if(count == 0)begin
				scl_en<= 0;
				state <= wack_2;
				end
				else
				count <= count - 1;
				end
			wack_2:begin
				state <= stop;
				sda   <= 1;
				//scl_en<= 0;
				end
			stop:begin
				sda   <= 1;
				state <= idle;
				end
			endcase
		end
	end
endmodule
	
				
				
			