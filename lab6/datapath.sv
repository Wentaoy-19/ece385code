module datapath(
input logic Clk,
input logic Reset_ah, Continue_ah, Run_ah, 
input logic BEN,LD_MAR,LD_MDR,LD_IR,LD_BEN,LD_CC,LD_REG,LD_PC,LD_LED,
input logic GatePC, GateMDR, GateALU,GateMARMUX,
input logic[1:0] PCMUX,ADDR2MUX,ALUK,
input logic DRMUX, SR1MUX, SR2MUX, ADDR1MUX,
input logic MIO_EN,
input logic[15:0] MDR_In, MDR, IR, PC,Data_from_SRAM, Data_to_SRAM, 
output logic[15:0] MAR
); // TODO:input ? output? 

logic[15:0] BUS;
logic[15:0] MDR_input,MDR_mux,MDR_output, MAR_output, ALU_output, PC_output, MARMUX_output;
reg_parallel_16 MDR_unit(.Clk(Clk),.Load(LD_MDR),.D(MDR_mux),.Data_Out(MDR_output));
reg_parallel_16 MAR_unit(.Clk(Clk),.Load(LD_MAR),.D(BUS),.Data_Out(MAR_output));
BUS_select bus_select(.MDR2BUS(MDR_output), .ALU2BUS(ALU_output),.PC2BUS(PC_output),.MARMUX2BUS(MARMUX_output),.GateMDR(GateMDR),.GateALU(GateALU),.GatePC(GatePC),.GateMARMUX(GateMARMUX));
assign MDR = MDR_output;
assign MAR = MAR_output;



always_comb begin
    if(MIO_EN)
        MDR_input = BUS;
    else
        MDR_input = MDR_In;
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


module PC 