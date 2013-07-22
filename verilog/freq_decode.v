`timescale 1ns / 1ps

module freq_decode(
    input clk,
    input sq_wv,
    input data_in,
	 input manual,
    output reg data_out
	 );

	integer pulse_count;
	reg last_sq;
	reg last_data;
	
	initial begin
		pulse_count = 0;
		last_sq = 0;
		last_data = 0;
		data_out = 0;
	end
	
	always @(posedge sq_wv) begin
		pulse_count = pulse_count + 1;
		if (manual == 1) data_out <= 0;
		if(last_data<data_in) begin
			if(pulse_count==8) data_out<=0;
			/*else if(pulse_count==9) begin
				data_out<=data_out;
				end*/
			else if(pulse_count==10) data_out<=1;
			else data_out<=data_out;
			pulse_count = 0;
		end
		last_data <= data_in;
	end

endmodule
