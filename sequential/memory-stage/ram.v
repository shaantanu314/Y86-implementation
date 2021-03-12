`timescale 1ns / 1ps
module RAM(mem_addr,mem_data,rd,wr,valM);

    input [63:0] mem_addr;
    input [63:0] mem_data;
    input rd;
    input wr;
    output reg[63:0] valM;
    reg [63:0] mem [8191:0];

    always @ (wr,rd,mem_data,mem_addr)
    begin
        if (wr && !rd) mem[mem_addr] = mem_data;
        if (rd && !wr) valM = mem[mem_addr];
    end
endmodule

module Mem_read(icode,rd);
    input[3:0] icode;
    output reg rd;

    always @(icode)
    begin
        case(icode)
            4'h5,4'hB,4'h9:
                rd <= 1'b1;
            default: rd <= 1'b0;
        endcase
    end
endmodule

module Mem_write(icode,wr);
    input[3:0] icode;
    output reg wr;

    always @(icode)
    begin
        case(icode)
            4'h4,4'hA,4'h8:
                wr <= 1'b1;
            default: wr <= 1'b0;
        endcase
    end
endmodule

module Mem_addr(icode,valE,valA,mem_addr);
    input[3:0] icode;
    output reg[63:0] mem_addr;
    input[63:0] valE;
    input[63:0] valA;

    always @(icode,valA,valE)
    begin
        case(icode)
            4'h4,4'h5,4'h8,4'hA:
                mem_addr <= valE;
            4'h9,4'hB:
                mem_addr <= valA;
        endcase
    end
endmodule

module Mem_data(icode,valA,valP,mem_data);
    input[3:0] icode;
    output reg[63:0] mem_data;
    input[63:0] valP;
    input[63:0] valA;

    always @(icode,valA,valP)
    begin
        case(icode)
            4'h4,4'hA:
                mem_data <= valA;
            4'h8:
                mem_data <= valP;
        endcase
    end
endmodule
