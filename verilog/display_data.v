`timescale 1ns / 1ps

module display_data(
	input clk,
	input [15:0] decimal_nybble,
	output reg [3:0] seg_an_reg,
   output reg [7:0] seg_cat_reg
   );
	integer slowdown;
	reg [1:0] state;
	//reg [3:0] seg_an_reg;
	//reg [7:0] seg_cat_reg;
	integer ID;
	integer digit;
	integer dig0;
	integer dig1;
	integer dig2;
	integer dig3;
	integer temp0;
	integer temp1;
	initial begin
		slowdown = 0;
		state = 0;
		digit = 0;
		dig0 = 0;
		dig1 = 0;
		dig2 = 0;
		dig3 = 0;
		ID = 0;
		seg_an_reg = 4'b0000;
		seg_cat_reg = 8'b00000000;
	end
	
	//assign seg_an = seg_an_reg;
	//assign seg_cat = seg_cat_reg;
	
	//TODO: Calculate digits from data
	always @(decimal_nybble) begin
		dig3 <= decimal_nybble[15:12];
		dig2 <= decimal_nybble[11:8];
		dig1 <= decimal_nybble[7:4];
		dig0 <= decimal_nybble[3:0];
	end
	
	always @(posedge clk) begin
		if(slowdown==200000) begin //only update once every 200000 clock cycles
			//seg_an_reg <= 4'b1111; //clear anodes (no digit active)
			case(state) //choose a new active digit
				2'd0: begin
					digit = dig0;
					seg_an_reg[0] <= 0;
					seg_an_reg[1] <= 1;
					seg_an_reg[2] <= 1;
					seg_an_reg[3] <= 1;
				end
				2'd1: begin
					digit = dig1;
					seg_an_reg[0] <= 1;
					seg_an_reg[1] <= 0;
					seg_an_reg[2] <= 1;
					seg_an_reg[3] <= 1;
				end
				2'd2: begin
					digit = dig2;
					seg_an_reg[0] <= 1;
					seg_an_reg[1] <= 1;
					seg_an_reg[2] <= 0;
					seg_an_reg[3] <= 1;
				end
				2'd3: begin
					digit = dig3;
					seg_an_reg[0] <= 1;
					seg_an_reg[1] <= 1;
					seg_an_reg[2] <= 1;
					seg_an_reg[3] <= 0;
				end
			endcase

			case(digit)
				'd0: begin
					seg_cat_reg[0] = 0;
					seg_cat_reg[1] = 0;
					seg_cat_reg[2] = 0;
					seg_cat_reg[3] = 0;
					seg_cat_reg[4] = 0;
					seg_cat_reg[5] = 0;
					seg_cat_reg[6] = 1;
					seg_cat_reg[7] = 1;
				end
				'd1: begin
					seg_cat_reg[0] = 1;
					seg_cat_reg[1] = 0;
					seg_cat_reg[2] = 0;
					seg_cat_reg[3] = 1;
					seg_cat_reg[4] = 1;
					seg_cat_reg[5] = 1;
					seg_cat_reg[6] = 1;
					seg_cat_reg[7] = 1;
				end
				'd2: begin
					seg_cat_reg[0] = 0;
					seg_cat_reg[1] = 0;
					seg_cat_reg[2] = 1;
					seg_cat_reg[3] = 0;
					seg_cat_reg[4] = 0;
					seg_cat_reg[5] = 1;
					seg_cat_reg[6] = 0;
					seg_cat_reg[7] = 1;
				end
				'd3: begin
					seg_cat_reg[0] = 0;
					seg_cat_reg[1] = 0;
					seg_cat_reg[2] = 0;
					seg_cat_reg[3] = 0;
					seg_cat_reg[4] = 1;
					seg_cat_reg[5] = 1;
					seg_cat_reg[6] = 0;
					seg_cat_reg[7] = 1;
				end
				'd4: begin
					seg_cat_reg[0] = 1;
					seg_cat_reg[1] = 0;
					seg_cat_reg[2] = 0;
					seg_cat_reg[3] = 1;
					seg_cat_reg[4] = 1;
					seg_cat_reg[5] = 0;
					seg_cat_reg[6] = 0;
					seg_cat_reg[7] = 1;
				end
				'd5: begin
					seg_cat_reg[0] = 0;
					seg_cat_reg[1] = 1;
					seg_cat_reg[2] = 0;
					seg_cat_reg[3] = 0;
					seg_cat_reg[4] = 1;
					seg_cat_reg[5] = 0;
					seg_cat_reg[6] = 0;
					seg_cat_reg[7] = 1;
				end
				'd6: begin
					seg_cat_reg[0] = 0;
					seg_cat_reg[1] = 1;
					seg_cat_reg[2] = 0;
					seg_cat_reg[3] = 0;
					seg_cat_reg[4] = 0;
					seg_cat_reg[5] = 0;
					seg_cat_reg[6] = 0;
					seg_cat_reg[7] = 1;
				end
				'd7: begin
					seg_cat_reg[0] = 0;
					seg_cat_reg[1] = 0;
					seg_cat_reg[2] = 0;
					seg_cat_reg[3] = 1;
					seg_cat_reg[4] = 1;
					seg_cat_reg[5] = 1;
					seg_cat_reg[6] = 1;
					seg_cat_reg[7] = 1;
				end
				'd8: begin
					seg_cat_reg[0] = 0;
					seg_cat_reg[1] = 0;
					seg_cat_reg[2] = 0;
					seg_cat_reg[3] = 0;
					seg_cat_reg[4] = 0;
					seg_cat_reg[5] = 0;
					seg_cat_reg[6] = 0;
					seg_cat_reg[7] = 1;
				end
				'd9: begin
					seg_cat_reg[0] = 0;
					seg_cat_reg[1] = 0;
					seg_cat_reg[2] = 0;
					seg_cat_reg[3] = 0;
					seg_cat_reg[4] = 1;
					seg_cat_reg[5] = 0;
					seg_cat_reg[6] = 0;
					seg_cat_reg[7] = 1;
				end
			endcase
			
			case(state)
				2'd3: state <= 0;
				default: state <= state + 1;
			endcase

			slowdown <= 0;
		end else slowdown <= slowdown + 1;
	end

endmodule
