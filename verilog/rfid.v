`timescale 1ns / 1ps

module rfid(
    input clk,
	 input dataIn,
	 input manual,
	 output square_wave,
	 output freqOut,
	 output [3:0] seg_an_main,
	 output [7:0] seg_cat_main,
	 output reg [7:0] led,
	 output fsk_out,
	 output fsk_out_trigger
	);
	wire iface_done;
	wire mchester_done;
	wire [44:0] decoded;
	wire [15:0] iddecimal4;
	
	always @(posedge square_wave) begin
		led[7:4] = iface_done;
		led[3:0] = mchester_done;
	end

	freq_decode F_DECODE(clk,square_wave,dataIn,manual,freqOut);
	fsk_iface_mchester FSK_IFACE_MCHESTER(square_wave,freqOut,manual,fsk_out,fsk_out_trigger,iface_done);
	mchester_decode MCHESTER_DECODE(square_wave,fsk_out_trigger,fsk_out,manual,decoded,mchester_done);
	getID_4digits GETID_4DIGITS(square_wave,decoded,iddecimal4);
	//manchester_decode M_DECODE(fsk_out_good,fsk_out,decoded);
	square_wave SQ_WV(clk,square_wave);
	//record_data RECORD(clk,square_wave,decoded,pattern);
	display_data DISP_DATA(clk,iddecimal4,seg_an_main,seg_cat_main);

endmodule
