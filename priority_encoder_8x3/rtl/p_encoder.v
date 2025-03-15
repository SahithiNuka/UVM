module p_encoder(in,out);
	input [7:0]in;
	output reg [2:0]out;
	
	always @(in)
		begin
			if(in[0])
				out = 0;
			else if(in[1])
				out = 1;
			else if(in[2])
				out = 2;
			else if(in[3])
				out = 3;
			else if(in[4])
				out = 4;
			else if(in[5])
				out = 5;
			else if(in[6])
				out = 6;
			else if(in[7])
				out = 7;
		end
endmodule

/*module p_encoder(in,out);
	input [7:0]in;
	output reg[2:0]out;

	always@(in)
		begin
			casex(in)
				8'b1xxx_xxxx: out = 3'b111;
				8'b01xx_xxxx: out = 3'b110;
				8'b001x_xxxx: out = 3'b101;
				8'b0001_xxxx: out = 3'b100;
				8'b0000_1xxx: out = 3'b011;
				8'b0000_01xx: out = 3'b010;
				8'b0000_001x: out = 3'b001;
				8'b0000_0001: out = 3'b001;
			endcase
		end
endmodule*/
