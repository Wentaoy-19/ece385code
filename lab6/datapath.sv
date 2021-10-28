module datapath(
	input logic Clk,
	input logic Reset_ah, Continue_ah, Run_ah, 
	input logic BEN,LD_MAR,LD_MDR,LD_IR,LD_BEN,LD_CC,LD_REG,LD_PC,LD_LED,
	input logic GatePC, GateMDR, GateALU,GateMARMUX,
	input logic[1:0] PCMUX,ADDR2MUX,ALUK,
	input logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
	input logic MIO_EN,
	input logic[15:0] MDR_In,
	output logic[15:0] MAR,IR,MDR, PC
); // TODO:input ? output? 

logic[15:0] BUS;
logic[15:0] MDR_input,MDR_output, MAR_output, ALU_output, PC_output, MARMUX_output,IR_output,IR_input; 


reg_parallel_16 MDR_unit(.Clk(Clk),.Load(LD_MDR),.D(MDR_input),.Data_Out(MDR_output));
reg_parallel_16 MAR_unit(.Clk(Clk),.Load(LD_MAR),.D(BUS),.Data_Out(MAR_output));
reg_parallel_16 IR_unit(.Clk(Clk),.Load(LD_IR|Reset_ah),.D(IR_input),.Data_Out(IR_output));

BUS_select bus_select(.MDR2BUS(MDR_output), .ALU2BUS(ALU_output),.PC2BUS(PC_output),.MARMUX2BUS(MARMUX_output),.GateMDR(GateMDR),.GateALU(GateALU),.GatePC(GatePC),.GateMARMUX(GateMARMUX),.BUS(BUS));
PC_module PC_unit(	.Clk(Clk), .LD_PC(LD_PC),.PCMUX(PCMUX),.Data_from_BUS(BUS),.Data_from_addrmux_to_PC(),.DataOut(PC_output),.reset(Reset_ah));
assign MDR = MDR_output;
assign MAR = MAR_output;
assign PC = PC_output;
assign IR_input = Reset_ah ? 16'b0 : BUS;
assign IR = IR_output;
	


always_comb begin
    if(MIO_EN)
        MDR_input = MDR_In;
    else
        MDR_input = BUS;
		  
end
endmodule





module BUS_select(
    input logic[15:0] MDR2BUS, ALU2BUS, PC2BUS, MARMUX2BUS,
    input logic GateMDR, GateALU, GatePC, GateMARMUX,
    output logic[15:0] BUS
);
    always_comb begin
        if(GateMDR)
            BUS = MDR2BUS;
        else if (GateALU)
            BUS = ALU2BUS;
        else if (GatePC)
            BUS = PC2BUS;
        else if (GateMARMUX)
            BUS = MARMUX2BUS; 
        else  
            BUS = 16'b0;      
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
         else 
            Data_Out <= Data_Out;		 
    end
	 
endmodule

module mux4to1bit16 (
		input [15:0] Din1,
		input [15:0] Din2,
		input [15:0] Din3,
		input [15:0] Din4,
		input [1:0] select,
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
		
	always_ff @ (posedge Clk)
		begin
			Dout[0] <= Din[0] ^ 1'b1;
			Dout[1] <= Din[1] ^ Din[0];
			Dout[2] <= Din[1] & Din[0] ^ Din[2];
			Dout[3] <= Din[0]& Din[1]& Din[2]^ Din[3];
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
			

	
	
module PC_module (
		input logic Clk,
		input logic LD_PC,
		input logic reset,
		input logic [1:0] PCMUX,
		input logic [15:0] Data_from_BUS,
		input logic [15:0] Data_from_addrmux_to_PC,
		output logic [15:0] DataOut
);

	logic [15:0] Data_from_PCMUX, PCplus1,dataout_mid;	
	
	reg_parallel_16 REG_PC(.Clk(Clk), .Load(LD_PC | reset), .D(Data_from_PCMUX), .Data_Out(DataOut));
	
	mux4to1bit16 PCmultiplexer(.Din1(PCplus1), .Din2(Data_from_BUS), .Din3(Data_from_addrmux_to_PC),.Din4(),.select(PCMUX), .Dout(dataout_mid));
	
	counter16bit counter(.Clk(Clk),.Din(DataOut), .Dout(PCplus1));
	
	always_comb
		begin
			if(reset)
				Data_from_PCMUX = 16'b0;
			else
				Data_from_PCMUX = dataout_mid;
		end
		
	
endmodule
	
	
	
	
	
	
	