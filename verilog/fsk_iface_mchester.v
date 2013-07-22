`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:54:43 12/16/2012 
// Design Name: 
// Module Name:    fsk_iface_mchester 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module fsk_iface_mchester(
    input sqwv,
    input fsk_in,
	 input manual,
    output reg fsk_out,
	 output reg fsk_out_trigger,
	 output reg done
    );
	
	integer count_0s, count_0secs, count_1s, count_all;
	reg [2:0] occurence;
	reg ready_or_not;
	reg [1:0] ready_preamble_stage;
	// 6ths are actually 6 7 6 6
	
	initial begin
		ready_or_not = 0;
		ready_preamble_stage = 0;
		count_0s = 0;
		count_1s = 0;
		count_all = 0;
		fsk_out_trigger = 0;
		fsk_out = 0;
		occurence = 0;
		done = 0;
	 end

	always @(posedge sqwv) begin
		//preamble
		if (manual == 1) begin
			ready_or_not <= 0;
			ready_preamble_stage <= 0;
			count_0s <= 0;
			count_1s <= 0;
			count_all <= 0;
			fsk_out <= 0;
			fsk_out_trigger <= 0;
			occurence <= 0;
			done <= 0;
		end
		else if (ready_or_not == 0) begin
			if (ready_preamble_stage == 0 && fsk_in == 1) begin
				  count_1s <= count_1s + 1;
				  ready_preamble_stage <= 1;
			end
			else if (ready_preamble_stage == 1) begin
				if (fsk_in == 1) begin
					count_1s <= count_1s + 1;
					if (count_1s == 150) begin
					  count_0s <= 0;
					  ready_preamble_stage <= 2;
					end
				end
				else begin
					count_1s <= 0;
					ready_preamble_stage <= 0;
				end
			end
			else if (ready_preamble_stage == 2) begin
				if (fsk_in == 0) begin
					count_0s <= count_0s + 1;
					if (count_0s == 152) begin
					  count_1s <= 0;
					  ready_preamble_stage <= 3;
					end
				end
				else begin
					count_0s <= 0;
					ready_preamble_stage <= 2;
				end
			end
			else if (ready_preamble_stage == 3) begin
				if (fsk_in == 1) begin
					count_1s <= count_1s + 1;
					if (count_1s == 150) begin
					  count_1s <= 0; count_0s <= 0; count_all <= 0;
					  ready_preamble_stage <= 0; ready_or_not <= 1;
					end
				end
				else if (fsk_in == 0 && count_1s == 0);
				else begin
					count_1s <= 0;
					ready_preamble_stage <= 0;
				end
			end
		end
		//postamble
		else if (ready_or_not == 1 && count_0secs == 152) begin
			ready_or_not <= 0;
			ready_preamble_stage <= 0;
			count_1s <= 0;
			count_0s <= 0;
			count_0secs <= 0;
			count_all <= 0;
			
			done <= 1;
		end
		
		//meat
		else begin
		if (fsk_in == 1) begin
		  count_1s <= count_1s + 1;
		  count_0secs <= 0;
		  count_all <= count_all + 1;
		  end
		else begin
		  count_0s <= count_0s + 1;
		  count_0secs <= count_0secs + 1;
		  count_all <= count_all + 1;
		  end
 
		  if (((count_all == 48-1) && (count_0s > count_1s) && (occurence % 4 != 1)) ||
		  ((count_all == 56-1) && (count_0s > count_1s) && (occurence % 4 == 1))) begin
			occurence <= (occurence + 1) % 4;
			fsk_out <= 0;
			fsk_out_trigger <= ~fsk_out_trigger;
			count_0s <= 0;
			count_1s <= 0;
			count_all <= 0;
			end
		  else if ((count_all == 50-1) && (count_1s > count_0s)) begin
			fsk_out <= 1;
			fsk_out_trigger <= ~fsk_out_trigger;
			count_0s <= 0;
			count_1s <= 0;
			count_all <= 0;
			end
		end
	end
endmodule
