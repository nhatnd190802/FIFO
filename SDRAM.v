module SDPRAM#(
    parameter DWIDTH = 32,
    parameter AWIDTH =  5)(
    /*================ Port A ================*/
    input  wire CLKA,
    input  wire ENA,
    input  wire WEA,
    input  wire [(AWIDTH - 1):0] ADDRA,
    input  wire [(DWIDTH - 1):0] DINA,
    /*================ Port B ================*/
    input  wire CLKB,
    input  wire ENB,
    input  wire [(AWIDTH - 1):0] ADDRB,
    output wire [(DWIDTH - 1):0] DOUTB
    );

    reg     [(DWIDTH - 1):0] memory[((1 << AWIDTH) - 1):0];
    reg     [(DWIDTH - 1):0] b_reg;
    integer                  i;

    assign DOUTB = b_reg;

    initial begin
        for(i = 0;i < (1 << AWIDTH); i = i + 1)
            memory[i] <= {DWIDTH{1'h0}};
        b_reg <= {DWIDTH{1'h0}};
    end

    always @(posedge CLKA) begin
        if (ENA) begin
            if (WEA) memory[ADDRA] <= DINA;
        end
    end

    always @(posedge CLKB) begin
        if (ENB) b_reg <= memory[ADDRB];
    end

endmodule
