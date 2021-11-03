module ben_module(
    input logic Clk,
    input logic[15:0] BUS,
    input logic LD_CC, LD_BEN,
    input logic [2:0] IR11_9,
    output logic BEN
); 
    // FIXME: 2 register, both for ben and NZP? or just one 
    logic [2:0] NZP;
    logic n_out,z_out,p_out,ben_input;
    // FIXME: revise the reset pins
    uni_reg #(.N(1)) N(.Clk(Clk),.Load(LD_CC),.D(NZP[2]),.Data_Out(n_out));   
    uni_reg #(.N(1)) Z(.Clk(Clk),.Load(LD_CC),.D(NZP[1]),.Data_Out(z_out));
    uni_reg #(.N(1)) P(.Clk(Clk),.Load(LD_CC),.D(NZP[0]),.Data_Out(p_out));
    assign ben_input = IR11_9[2]&n_out | IR11_9[1]&z_out | IR11_9[0]&p_out;
    uni_reg #(.N(1)) Ben(.Clk(Clk),.Load(LD_BEN),.D(ben_input),.Data_Out(BEN));

endmodule