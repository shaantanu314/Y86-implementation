`timescale 1ns / 1ps
module ram(addr,data_in,clk,rd,wr,data_out);

    input [9:0] addr;
    input [31:0] data_in;
    input clk;
    input rd;
    input wr;
    output reg[31:0] data_out;
    reg [31:0] mem [1023:0];

    always @ (posedge clk)
        if (wr && !rd) mem[addr] = data_in;
    
    always @ (posedge clk)
        if (rd && !wr) data_out = mem[addr];
endmodule

