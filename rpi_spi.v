module rpi_spi (
	input clk,
	input cs,
	input mosi,
	output miso,
	input sck,
	output done,
	input sw,
	output [15:0] dout);

	wire [15:0] in = {15'b000000000000000, sw};

	wire rst = 0;
	spi_slave #(16, 6) spi(clk, rst, cs, mosi, miso, sck, done, in, dout);
//	spi_slave_simpler2 #(8) spi(clk, cs, mosi, miso, sck, done, in, dout);

endmodule
