`timescale 1ns / 1ps

module split(ibyte, icode, ifun);
    input [7:0] ibyte;
    output [3:0] icode;
    output [3:0] ifun;
    assign icode = ibyte[7:4];
    assign ifun = ibyte[3:0];
endmodule

module align(ibytes, need_regids, rA, rB, valC);
    input [71:0] ibytes;
    input need_regids;
    output [ 3:0] rA;
    output [ 3:0] rB;
    output [63:0] valC;
    assign rA =  ibytes[71:68] ;
    assign rB = ibytes[67:64];
    assign valC = need_regids ? ibytes[63:0] : ibytes[71:8];
endmodule

module pc_increment(pc, need_regids, need_valC, valP);
    input [63:0] pc;
    input need_regids;
    input need_valC;
    output [63:0] valP;
    assign valP = pc + 1 + 8*need_valC + need_regids;
endmodule

module need_block(icode,need_regids,need_valC);
    input [3:0] icode;
    output reg need_regids;
    output reg need_valC;

    always @(icode)
    begin
    case (icode)
        4'h0:
            begin
                assign need_regids = 1'b0;
                assign need_valC = 1'b0;
            end
        4'h1:
            begin
                assign need_regids = 1'b0;
                assign need_valC = 1'b0;
            end
        4'h2:
            begin
                assign need_regids = 1'b1;
                assign need_valC = 1'b0;
            end
        4'h3:
            begin
                assign need_regids = 1'b1;
                assign need_valC = 1'b1;
            end
        4'h4:
            begin
                assign need_regids = 1'b1;
                assign need_valC = 1'b1;
            end
        4'h5:
            begin
                assign need_regids = 1'b1;
                assign need_valC = 1'b1;
            end
        4'h6:
            begin
                assign need_regids = 1'b1;
                assign need_valC = 1'b0;
            end
        4'h7:
            begin
                assign need_regids = 1'b0;
                assign need_valC = 1'b1;
            end
        4'h8:
            begin
                assign need_regids = 1'b0;
                assign need_valC = 1'b1;
            end
        4'h9:
            begin
                assign need_regids = 1'b0;
                assign need_valC = 1'b0;
            end
        4'hA:
            begin
                assign need_regids = 1'b1;
                assign need_valC = 1'b0;
            end
        4'hB:
            begin
                assign need_regids = 1'b1;
                assign need_valC = 1'b0;
            end
    endcase
    end

endmodule