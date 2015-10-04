module spi_slave_simpler2(clk, cs, mosi, miso, sck, done, din, dout);
	parameter bc=8;	// bit count
	
	input clk;
	input cs;	// active low
	input mosi;
	output miso;
	input sck;
	output reg done;
	input [bc-1:0] din;
	output reg [bc-1:0] dout;
	
	reg [bc-1:0] shift_reg;
	reg prev_cs, prev_sck;
	reg mosi_sample;
	reg [7:0] shift_count;
	
	assign miso = shift_reg[bc-1];

	always @(posedge clk) begin
		if (~cs) begin
			if (prev_cs) begin
				// falling cs edge - start spi transfer
				done <= 0;
				shift_reg[bc-1:0] <= 8'h23; //din[bc-1:0];
				shift_count <= 0;
			end else begin
				if (~prev_sck && sck) begin
					// rising sck edge - sample mosi
					mosi_sample <= mosi;
					if (shift_count == bc-1) begin
						dout <= {shift_reg[bc-2:0], mosi};
						done <= 1;
					end
				end 
				if (prev_sck && ~sck) begin
					// falling sck edge - shift in/out one bit
					shift_reg[bc-1:0] <= {shift_reg[bc-2:0], mosi_sample};
					shift_count <= shift_count + 1;
				end
			end
		end else begin
			done <= 1;
		end
		prev_cs <= cs;
		prev_sck <= sck;
	end
endmodule
