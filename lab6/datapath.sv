module datapath(
input logic Clk,
input logic Reset_ah, Continue_ah, Run_ah, 
input logic BEN,LD_MAR,LD_MDR,LD_IR,LD_BEN,LD_CC,LD_REG,LD_PC,LD_LED,
input logic GatePC, GateMDR, GateALU,GateMARMUX,
input logic[1:0] PCMUX,ADDR2MUX,ALUK,
input logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
input logic MIO_EN,
input logic[15:0] MDR_In, MAR, MDR, IR, PC,Data_from_SRAM, Data_to_SRAM
); // TODO:input ? output? 
always_ff @(posedge Clk) begin
    if(LD_MDR)
        
end

endmodule

module reg_parallel_16 (
				  input  logic Clk, Load,
              input  logic [15:0]  D,
              output logic [15:0]  Data_Out);

    always_ff @ (posedge Clk)
    begin
		 if (Load)
		 
			  Data_Out <= D;
		 
    end
	 
endmodule

module mux4to1bit16 (
		input [15:0] Din1,
		input [15:0] Din2,
		input [15:0] Din3,
		input [15:0] Din4,
		input [3:0] select,
		output logic [15:0] Dout);
	
	always_comb
		begin
			if (select == 2'b00)
				Dout = Din1;
			else if (select == 2'b01)
				Dout = Din2;
			else if (select == 2'b10)
				Dout = Din3;
			else
				Dout = Din4;
		end
endmodule



module mux2to1bit16 (
		input [15:0] Din1,
		input [15:0] Din2,
		input select,
		output logic [15:0] Dout);
	
	always_comb
		begin
			if (select == 1'b0)
				Dout = Din1;
			else
				Dout = Din2;
		end
endmodule



module counter16bit (
		input [15:0] Din,
		input logic Clk,
		output logic [15:0] Dout);
		
	always_ff (posedge Clk)
		begin
			Dout[0] <= Din[0] ^ 1'b1;
			Dout[1] <= Din[1] ^ Din[0];
			Dout[2] <= Din[1] & Din[0] ^ Din[2];
			Dout[6] <= Din[0]& Din[1]& Din[2]^ Din[3];
			Dout[4] <= Din[0]& Din[1]& Din[2]& Din[3]^ Din[4];
			Dout[5] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]^ Din[5];
			Dout[6] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]^ Din[6];
			Dout[7] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]^ Din[7];
			Dout[8] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]^ Din[8];
			Dout[9] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]^ Din[9];
			Dout[10] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]& Din[9]^ Din[10];
			Dout[11] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]& Din[9]& Din[10]^ Din[11];
			Dout[12] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]& Din[9]& Din[10]& Din[11]^ Din[12];
			Dout[13] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]& Din[9]& Din[10]& Din[11]& Din[12]^ Din[13];
			Dout[14] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]& Din[9]& Din[10]& Din[11]& Din[12]& Din[13]^ Din[14];
			Dout[15] <= Din[0]& Din[1]& Din[2]& Din[3]& Din[4]& Din[5]& Din[6]& Din[7]& Din[8]& Din[9]& Din[10]& Din[11]& Din[12]& Din[13]& Din[14] ^ Din[15];
		end
	endmodule
			

	
	
module PC (
		input logic Clk,
		input logic LD_PC,
		input logic GatePC,
		input logic [1:0] PCMUX,
		input logic [15:0] Data_from_BUS,
		input logic [15:0] Data_from_addrmux_to_PC,
		output logic [15:0] DataOut
);

	logic [15:0] Data_from_PCMUX, PCplus1;	
	
	reg_parallel_16 REG_PC(.Clk(Clk), .Load(LD_PC), .D(Data_from_PCMUX), .Data_Out(DataOut));
	
	mux4to1bit16 PCmultiplexer(.Din1(PCplus1), .Din2(Data_from_addrmux_to_PC), .Din3(Data_from_BUS), .Dout(DataOut));
	
	counter16bit counter(.Din(DataOut), .Dout(PCplus1))
	
endmodule
	
	
			
	
	
	
	
	