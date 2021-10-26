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
			else if (select == 2'b11)
				Dout = Din4;
		end
endmodule


module PC (
		input logic Clk,
		input logic LD_PC,
		input logic GatePC,
		input logic [1:0] PCMUX,
		input logic [15:0] Data_from_BUS,
		input logic [15:0] Data_from_addrmux_to_PC,
		output logic [15:0] Data_to_BUS,
		output logic [15:0] Data_to_MARMUX
);
	logic [15:0] Data_from_PCMUX;	
	reg_parallel_16 REG_PC(.Clk(Clk), .Load(LD_PC), .D(Data_from_PCMUX), .Data_Out(Data_from_addrmux_to_PC));
	
	
	
	
	
	
	