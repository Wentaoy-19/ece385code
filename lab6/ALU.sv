module ALU(
    input logic [15:0] SR1OUT, SR2OUT,IMME,
    input logic sr2mux, 
    input logic [1:0] ALUK,
    output logic [15:0] OUT
);
    logic [15:0] B, out_add,out_and,out_not;
    ripple_adder adder(.A(SR1OUT),.B(B),.Sum(out_add),.CO()); 
    assign B = sr2mux ? IMME : SR2OUT ; 
    assign out_and = B & SR1OUT; 
    assign out_not = ~SR1OUT; 

    always_comb 
    begin
        unique case (ALUK)
            3'b00:  OUT = out_add; 
            3'b01:  OUT = out_and;
            3'b10:  OUT = out_not;
            3'b11:  OUT = SR1OUT;
        endcase
    end
    
endmodule