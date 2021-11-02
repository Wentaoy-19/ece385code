module reg_file(
    input logic Clk,
    input logic [15:0] BUS,
    input logic [2:0] IR11_9,IR8_6,SR2
    input logic DR,SR1,LD_REG,
    output logic [15:0] SR1OUT, SR2OUT
);
    logic [2:0] drmux_out, sr1mux_out;
    logic [7:0] reg_ld;
    logic outr0, outr1,outr2,outr3,outr4,outr5,outr6,outr7;

    assign drmux_out = DR ? IR11_9 : 3'b111;    //TODO: check what DR,SR1 means
    assign sr1mux_out = SR1 ? IR8_6 : IR11_9;

    reg_parallel_16 reg0(.Clk(Clk),.Load(LD_REG&reg_ld[0]),.D(BUS),.Data_Out(outr0));
    reg_parallel_16 reg1(.Clk(Clk),.Load(LD_REG&reg_ld[1]),.D(BUS),.Data_Out(outr1));
    reg_parallel_16 reg2(.Clk(Clk),.Load(LD_REG&reg_ld[2]),.D(BUS),.Data_Out(outr2));
    reg_parallel_16 reg3(.Clk(Clk),.Load(LD_REG&reg_ld[3]),.D(BUS),.Data_Out(outr3));
    reg_parallel_16 reg4(.Clk(Clk),.Load(LD_REG&reg_ld[4]),.D(BUS),.Data_Out(outr4));
    reg_parallel_16 reg5(.Clk(Clk),.Load(LD_REG&reg_ld[5]),.D(BUS),.Data_Out(outr5));
    reg_parallel_16 reg6(.Clk(Clk),.Load(LD_REG&reg_ld[6]),.D(BUS),.Data_Out(outr6));
    reg_parallel_16 reg7(.Clk(Clk),.Load(LD_REG&reg_ld[7]),.D(BUS),.Data_Out(outr7));

    always_comb 
    begin
        unique case (drmux_out)
            3'b000 :    reg_ld = 8'b00000001; 
            3'b001 :    reg_ld = 8'b00000010;
            3'b010 :    reg_ld = 8'b00000100; 
            3'b011 :    reg_ld = 8'b00001000; 
            3'b100 :    reg_ld = 8'b00010000; 
            3'b101 :    reg_ld = 8'b00100000; 
            3'b110 :    reg_ld = 8'b01000000; 
            3'b111 :    reg_ld = 8'b10000000; 
        endcase

        unique case(SR2)
            3'b000 :    SR2OUT = outr0; 
            3'b001 :    SR2OUT = outr1;
            3'b010 :    SR2OUT = outr2;
            3'b011 :    SR2OUT = outr3; 
            3'b100 :    SR2OUT = outr4; 
            3'b101 :    SR2OUT = outr5;
            3'b110 :    SR2OUT = outr6;
            3'b111 :    SR2OUT = outr7;
        endcase 

        unique case(sr1mux_out)
            3'b000 :    SR1OUT = outr0; 
            3'b001 :    SR1OUT = outr1;
            3'b010 :    SR1OUT = outr2;
            3'b011 :    SR1OUT = outr3; 
            3'b100 :    SR1OUT = outr4; 
            3'b101 :    SR1OUT = outr5;
            3'b110 :    SR1OUT = outr6;
            3'b111 :    SR1OUT = outr7;
        endcase 
    end

endmodule