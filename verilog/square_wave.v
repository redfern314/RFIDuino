`timescale 1ns / 1ps

module square_wave(
    input clk,
    output reg sqwv_out
    );
	integer counter;
	initial counter=0;
	initial sqwv_out=0;

	always @(posedge clk) begin
		if(counter==399) begin
			sqwv_out<=~sqwv_out;
			counter <= 0;
		end else begin
			counter<=counter+1;
		end
	end

endmodule
