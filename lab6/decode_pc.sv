module ADDRMUX(
    input logic [15:0] IR,
    input logic [1:0] ADDR2MUX,
    input logic ADDR1MUX,
    input logic [15:0] data_from_SR1OUT, data_from_PC,
    output logic [15:0] Data_out, SEXT,
	 output logic [3:0] Data_to_controller,
	 output logic [2:0] Data_to_BEN
);
	
	logic [15:0] MUXOUT4to1, MUXOUT2to1, ZERO, offset6, offset9, offset11;

	ripple_adder adder(.A(MUXOUT4to1), .B(MUXOUT2to1), .Sum(Data_Out), .CO());
	mux2to1bit16 MUX1(.Din1(data_from_PC), .Din2(data_from_SR1OUT), .select(ADDR1MUX), .Dout(MUXOUT2to1));
	mux4to1bit16 MUX2(.Din1(ZERO), .Din2(offset6), .Din3(offset9), .Din4(offset11), .select(ADDR2MUX), .Dout(MUXOUT4to1));
	
	assign ZERO = 16'b0;
	
	always_comb
		begin
			if (IR[5] == 1'b0)
				offset6 = {10'b0, IR[5:0]};
			else
				offset6 = {10'b1, IR[5:0]};
		end
		
	always_comb
		begin
			if (IR[8] == 1'b0)
				offset9 = {7'b0, IR[8:0]};
			else
				offset9 = {7'b1, IR[8:0]};
		end
		
	always_comb
		begin
			if (IR[10] == 1'b0)
				offset11 = {5'b0, IR[10:0]};
			else
				offset11 = {5'b1, IR[10:0]};
		end
		
	always_comb
		begin
			if (IR[4] == 1'b0)
				SEXT = {11'b0, IR[4:0]};
			else
				SEXT = {11'b1, IR[4:0]};
		end
		
	assign Data_to_controller = IR[15:12];
	assign Data_to_BEN = IR[11:9];

endmodule
