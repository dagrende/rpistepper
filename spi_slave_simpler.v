module spi_slave_simpler(clk, cs, mosi, miso, sck, done, din, dout);
	parameter bc=8;	// bit count
	
	input clk;
	input cs;
	input mosi;
	output reg miso;
	input sck;
	output reg done;
	input [bc-1:0] din;
	output reg [bc-1:0] dout;
	
	reg [bc-1:0] shift_reg;
	reg prev_cs, prev_sck;
	reg [3:0]shift_count;
	
//	assign miso = shift_reg[bc-1];

	always @(*) begin
		if (~cs) begin
			// enabled
			miso = shift_reg[bc-1];
		end
	end

	always @(posedge clk) begin
		if (~cs) begin
			if (prev_cs) begin
				// falling cs edge - start spi transfer
				done <= 0;
				shift_reg[bc-1:0] <= din[bc-1:0];
				shift_count <= bc;
			end
			if (~done && sck && ~prev_sck) begin
					// rising sck edge - shift in/out one bit
					shift_reg[bc-1:0] <= {shift_reg[bc-2:0], mosi};
					shift_count <= shift_count - 1'b1;
					if (shift_count == 1'b0) begin
						dout <= shift_reg;
						done <= 1;
					end
			end
		end else begin
			done <= 1;
		end
		prev_cs <= cs;
		prev_sck <= sck;
	end
endmodule
