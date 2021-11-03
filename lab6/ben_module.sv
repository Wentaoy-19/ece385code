module ben_module(
    input logic Clk,reset,
    input logic[15:0] BUS,
    input logic LD_CC, LD_BEN,
    input logic [2:0] IR11_9,
    output logic BEN
); 
    logic [2:0] NZP;
    logic n_out,z_out,p_out,ben_input;
    uni_reg #(.N(1)) N(.Clk(Clk),.Load(LD_CC),.reset(reset),.D(NZP[2]),.Data_Out(n_out));   
    uni_reg #(.N(1)) Z(.Clk(Clk),.Load(LD_CC),.reset(reset),.D(NZP[1]),.Data_Out(z_out));
    uni_reg #(.N(1)) P(.Clk(Clk),.Load(LD_CC),.reset(reset),.D(NZP[0]),.Data_Out(p_out));
    assign ben_input = IR11_9[2]&n_out | IR11_9[1]&z_out | IR11_9[0]&p_out;
    uni_reg #(.N(1)) Ben(.Clk(Clk),.Load(LD_BEN),.reset(reset),.D(ben_input),.Data_Out(BEN)); 
	 
	 always_comb
	 begin
		if(BUS == 16'b0)
			NZP =  3'b010;
		else if(BUS[15] == 1'b1)
			NZP = 3'b100;
		else
			NZP = 3'b001;
	 end

endmodule