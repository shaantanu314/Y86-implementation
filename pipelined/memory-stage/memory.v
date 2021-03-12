`timescale 1ns / 1ps
module RAM(clk,mem_addr,M_valA,rd,wr,m_valM,dmem_error);

    input [63:0] mem_addr;
    input [63:0] M_valA;
    input rd;
    input wr;
    input clk;
    output reg[63:0] m_valM;
    output reg dmem_error;
    reg [63:0] mem [8191:0];

    initial
    begin
        dmem_error <= 0;
        $readmemh("./data.mem", mem);
        $display("initialized memory");
    end

    always @ (wr,rd,M_valA,mem_addr)
    begin 
        if (rd && !wr) 
        m_valM = mem[mem_addr];
        $writememh("./data_out.mem", mem);
    end
    always @(posedge clk)
    begin
    if (wr && !rd) 
        mem[mem_addr] = M_valA;
    end
    
endmodule

module Mem_read(M_icode,rd);
    input[3:0] M_icode;
    output reg rd;
 

    always @(M_icode)
    begin
        case(M_icode)
            4'h5,4'hB,4'h9:
                rd <= 1'b1;
            default: rd <= 1'b0;
        endcase
    end
endmodule

module Mem_write(M_icode,wr);
    input[3:0] M_icode;
    output reg wr;


    always @(M_icode)
    begin
        case(M_icode)
            4'h4,4'hA,4'h8:
                wr <= 1'b1;
            default: wr <= 1'b0;
        endcase
    end
endmodule

module Mem_addr(M_icode,M_valE,M_valA,mem_addr);
    input[3:0] M_icode;
    output reg[63:0] mem_addr;
    input[63:0] M_valE;
    input[63:0] M_valA;

    always @(M_icode,M_valA,M_valE)
    begin
        case(M_icode)
            4'h4,4'h5,4'h8,4'hA:
                mem_addr <= M_valE;
            4'h9,4'hB:
                mem_addr <= M_valA;
        endcase
    end
endmodule

module mem_Stat(M_stat,dmem_error,m_stat);
    input [2:0]M_stat;
    input   dmem_error;
    output reg[2:0]m_stat;
    parameter SADR = 3'h3;
    parameter SAOK = 3'h1;

    initial
    begin
        m_stat <= SAOK;
    end

    always @(*)
        m_stat <= (dmem_error) ? SADR : M_stat;
endmodule

module M_pipelined_reg(clk,M_stat,E_stat,E_icode,e_Cnd,e_valE,E_valA,e_dstE,E_dstM,M_icode,M_Cnd,M_valE,M_valA,M_dstE,M_dstM,M_bubble);
    input [3:0] E_icode;
    input [63:0] e_valE;
    input [63:0] E_valA;
    input [3:0] e_dstE;
    input [3:0] E_dstM;
    input  e_Cnd;
    input [2:0] E_stat;
    input clk;

    input M_bubble;

    output reg[3:0] M_icode;
    output reg[63:0] M_valE;
    output reg[63:0] M_valA;
    output reg[3:0] M_dstE;
    output reg[3:0] M_dstM;
    output  reg M_Cnd;
    output reg[2:0] M_stat;

    initial
    begin
        M_icode <= 4'h1;
        M_valE <= 0;
        M_valA <= 0;
        M_dstE <= 4'hF;
        M_dstM <= 4'hF;
        M_Cnd <= 0;
        M_stat <= 3'h1;
    end
    always @(posedge clk)
    begin
        if(!M_bubble)
        begin
            M_icode <= E_icode;
            M_Cnd   <= e_Cnd;
            M_valE  <= e_valE;
            M_valA  <= E_valA;
            M_dstE  <= e_dstE;
            M_dstM  <= E_dstM;
            M_stat  <= E_stat;
        end
        else
        begin
            M_icode <= 4'h1;
            M_Cnd   <= e_Cnd;
            M_dstE  <= 4'hF;
            M_dstM  <= 4'hF;
        end
        

    end
endmodule

module W_pipelined_reg(clk,W_stat,m_stat,M_icode,M_valE,m_valM,M_dstE,M_dstM,W_icode,W_valE,W_valM,W_dstE,W_dstM,W_stall);
    input [3:0] M_icode;
    input [63:0] M_valE;
    input [63:0] m_valM;
    input [3:0] M_dstE;
    input [3:0] M_dstM;
    input [2:0] m_stat;
    input clk;
    input W_stall;

    output reg[3:0] W_icode;
    output reg[63:0] W_valE;
    output reg[63:0] W_valM;
    output reg[3:0] W_dstE;
    output reg[3:0] W_dstM;
    output reg[2:0] W_stat;

    initial
    begin
    W_icode <= 4'h1;
    W_valE <=0;
    W_valM <=0;
    W_dstE <= 4'hF;
    W_dstM <= 4'hF;
    W_stat <= 3'h1;

    end
    always @(posedge clk)
    begin
        if (!W_stall)
        begin
            W_icode <= M_icode;
            W_valE  <= M_valE;
            W_valM  <= m_valM;
            W_dstE  <= M_dstE;
            W_dstM  <= M_dstM;
            W_stat  <= m_stat; 
        end
    end
endmodule

module Final_Stat(W_stat,w_stat);
    input [2:0] W_stat;
    output reg[2:0] w_stat;
    
    always @(*)
        w_stat <= W_stat;
endmodule