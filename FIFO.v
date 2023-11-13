//////////////////////////////////////////////////////////////////////////////////
// University: University of Information Technology
// Student: Nguyen Dinh Nhat
// Module Name: FIFO
// Project Name: CRYSTALS_Kyber512
// Description: FIFO (First-In First-Out) uses Simple Dual Port RAM
//////////////////////////////////////////////////////////////////////////////////
module FIFO#(
    parameter DWIDTH = 32,
    parameter ADEPTH =  5)(
    input  wire                  CLK,
    input  wire                  RST,
    /*================ Port Write ================*/
    input  wire                  WR_EN,
    input  wire [(DWIDTH - 1):0] DIN,
    output wire                  FULL,
    /*================ Port Read ================*/
    input  wire                  RD_EN,
    output wire [(DWIDTH - 1):0] DOUT,
    output wire                  EMPTY
    );

    reg [ADEPTH:0] wr_ptr, rd_ptr;
    wire wrap_around, comp;

    assign wrap_around = wr_ptr[ADEPTH] ^ rd_ptr[ADEPTH];
    assign comp  = (wr_ptr[(ADEPTH - 1):0] == rd_ptr[(ADEPTH - 1):0]) ? 1'h1 : 1'h0;
    assign FULL = comp & wrap_around;
    assign EMPTY = (wr_ptr == rd_ptr) ? 1'h1 : 1'h0;
    
    SDPRAM#(
        .DWIDTH(DWIDTH),
        .AWIDTH(ADEPTH)) 
    SDPRAM(
    /*================ Port A ================*/
        .CLKA  (CLK),
        .ENA   (~FULL),
        .WEA   (WR_EN),
        .ADDRA (wr_ptr[(ADEPTH - 1):0]),
        .DINA  (DIN),
    /*================ Port B ================*/
        .CLKB  (CLK),
        .ENB   (~EMPTY),
        .ADDRB (rd_ptr[(ADEPTH - 1):0]),
        .DOUTB (DOUT)
    );

    always @(posedge CLK or negedge RST) begin
        if (~RST) wr_ptr <= {(ADEPTH + 1){1'h0}};
        else      wr_ptr <= (WR_EN & (~FULL)) ? (wr_ptr + 1'h1) : wr_ptr;
    end
    always @(posedge CLK or negedge RST) begin
        if (~RST) rd_ptr <= {(ADEPTH + 1){1'h0}};
        else      rd_ptr <= (RD_EN & (~EMPTY)) ? (rd_ptr + 1'h1) : rd_ptr;
    end

endmodule
