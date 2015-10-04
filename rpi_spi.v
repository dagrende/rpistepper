module rpi_spi (
	input clk, 
	input cs,
	input mosi,
	output miso,
	input sck,
	output done,
	input sw,
	output [7:0] dout);
	
	wire [7:0] in = {7'b0000000, sw};
		
	wire rst = 0;
	spi_slave spi(clk, rst, cs, mosi, miso, sck, done, in, dout);
//	spi_slave_simpler2 #(8) spi(clk, cs, mosi, miso, sck, done, in, dout);
	
endmodule
