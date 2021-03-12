`timescale 1ns / 1ps

module ALU(ALU_A,ALU_B,ALU_fun,cf,e_valE);
 
input [63:0]ALU_A;
input [63:0]ALU_B;
input [3:0]ALU_fun;
output  [63:0]e_valE; 
output  [2:0]cf;

wire [2:0]co1;
wire [2:0]co2;
wire [2:0]co3;
wire [2:0]co4;

wire [63:0]y0;
wire [63:0]y1;
wire [63:0]y2;
wire [63:0]y3;

wire ci0 ;
assign ci0 = 0;
wire ci1 ;
assign ci1 = 1;


bit_64_addsub add1(.co(co1),.ci(ci0) ,.a(ALU_A), .b(ALU_B), .s(y0) );
bit_64_addsub sub1(.co(co2),.ci(ci1) ,.a(ALU_B), .b(~ALU_A), .s(y1) );
bit_64_and and1(.a(ALU_A), .b(ALU_B), .y(y2) ,.co(co3));
bit_64_xor xor1(.a(ALU_A), .b(ALU_B), .y(y3) ,.co(co4));

mux_41 mux(ALU_fun,co1,co2,co3,co4,y0,y1,y2,y3,cf,e_valE);

endmodule

module ALU_A_logic(E_icode,E_valA,E_valC,ALU_A);

    input [3:0] E_icode;
    input [63:0] E_valA;
    input [63:0] E_valC;
    output reg [63:0] ALU_A;
    
    always @ (E_icode , E_valA ,E_valC )
    begin
        case (E_icode)
        4'h2 , 4'h6 :
            begin
                ALU_A <= E_valA;
            end
        4'h3 , 4'h4 , 4'h5  :
            begin
                ALU_A <= E_valC;
            end
        4'h9 , 4'hB  :
            begin
                ALU_A <= 64'd8;
            end
        4'h8 , 4'hA:
            begin
                ALU_A <= 64'hFFFFFFFFFFFFFFF8;
            end
        endcase
    end

endmodule


module ALU_B_logic(E_icode,E_valB,ALU_B);

    input [3:0] E_icode;
    input [63:0] E_valB;
    output reg [63:0] ALU_B;
    
    always @ (E_icode , E_valB )
    begin
        case (E_icode)
        4'h2 , 4'h3 :
            begin
                ALU_B <= 64'd0;
            end
        4'h4 , 4'h5 , 4'h6 ,4'h8 ,4'h9 , 4'hA ,4'hB  :
            begin
                ALU_B <= E_valB;
            end
        endcase
    end

endmodule

module ALU_FUN(E_icode,E_ifun,ALU_fun);

    input [3:0] E_icode;
    input [3:0] E_ifun;
    output reg [3:0] ALU_fun;

    parameter ADDQ = 4'h0;
    
    always @ (E_icode,E_ifun)
    begin
        case (E_icode)
        4'h6:
            begin
                ALU_fun <= E_ifun;
            end
        default :
            begin
                ALU_fun <= ADDQ;
            end
        endcase
    end
endmodule

module CC(clk,E_icode,cf,outf,m_stat,W_stat);

    input [3:0] E_icode;
    input [2:0]cf;
    output reg[2:0] outf;
    input [2:0] m_stat;
    input [2:0] W_stat; 
    input clk;

    initial
    begin
        outf <=0;
    end

    parameter SAOK = 3'h1;
    parameter SHLT = 3'h2;
    parameter SADR = 3'h3;
    parameter SINS = 3'h4;

    always @ (E_icode,cf)
    begin

        if(( E_icode == 4'h6) && !(m_stat==SADR | m_stat ==SINS | m_stat ==SHLT) & !(W_stat==SADR | W_stat==SINS | W_stat==SHLT))
        begin 
            outf <= cf;  
        end
    end

endmodule

module Cond(E_ifun,outf,e_Cnd);
    
    input[3:0] E_ifun;
    input[2:0] outf;
    output reg e_Cnd;
    initial
    begin
        e_Cnd <=0;
    end
    always @(E_ifun,outf)
    begin
        case(E_ifun)
        4'h0: e_Cnd <= 1'b1;

        4'h1:
        begin
            if((outf[1]^outf[0])|outf[2]) 
            e_Cnd <= 1'b1;
            else
            e_Cnd <= 1'b0;
        end

        4'h2:
        begin
            if(outf[1]^outf[0]) 
            e_Cnd <= 1'b1;
            else
            e_Cnd <= 1'b0;
        end
        
        4'h3:
        begin
            if(outf[2]) 
            e_Cnd <= 1'b1;
            else
            e_Cnd <= 1'b0;
        end 
        
        4'h4:
        begin
            if(~outf[2]) 
            e_Cnd <= 1'b1;
            else
            e_Cnd <= 1'b0;
        end
        
        4'h5:
        begin
            if(~(outf[1]^outf[0])) 
            e_Cnd <= 1'b1;
            else
            e_Cnd <= 1'b0;
        end
        
        4'h6:
        begin
            if(~(outf[1]^outf[0]) & ~outf[2]) 
            e_Cnd <= 1'b1;
            else
            e_Cnd <= 1'b0;
        end
        endcase
        
    end

endmodule

module exe_dstE(E_bubble,E_icode,E_dstE,e_Cnd,e_dstE);
    input [3:0] E_icode;
    input [3:0] E_dstE;
    input e_Cnd;
    input E_bubble;
    output reg[3:0] e_dstE;

    always @(*)
    begin

        e_dstE <= ((E_icode == 4'h2) & !e_Cnd) ? 4'hF:E_dstE ;
    end

endmodule

module E_pipelined_reg(clk,D_stat,E_stat,D_icode,D_ifun,D_valC,d_dstE,d_dstM,d_srcA,d_srcB,d_valA,d_valB,E_icode,E_ifun,E_valC,E_valA,E_valB,E_dstE,E_dstM,E_srcA,E_srcB,E_bubble);
    input [3:0] D_icode;
    input [3:0] D_ifun;
    input [63:0] D_valC;
    input [63:0] d_valA;
    input [63:0] d_valB;
    input [3:0] d_dstE;
    input [3:0] d_dstM;
    input [3:0] d_srcA;
    input [3:0] d_srcB;
    input [2:0] D_stat;
    input clk;

    input E_bubble;

    output reg[3:0] E_icode;
    output reg[3:0] E_ifun;
    output reg[63:0] E_valC;
    output reg[63:0] E_valA;
    output reg[63:0] E_valB;
    output reg[3:0] E_dstE;
    output reg[3:0] E_dstM;
    output reg[3:0] E_srcA;
    output reg[3:0] E_srcB;
    output reg[2:0] E_stat;

    initial
    begin
    E_icode <= 4'h1;
    E_ifun <=0;
    E_valC <=0;
    E_valA <=0;
    E_valB <=0;
    E_dstE <= 4'hF;
    E_dstM <= 4'hF;
    E_srcA <=0;
    E_srcB <=0;
    E_stat <=0;
    end
    always @(posedge clk)
    begin
        if(!E_bubble)
        begin
            E_icode <= D_icode;
            E_ifun  <= D_ifun;
            E_valC  <= D_valC;
            E_valA  <= d_valA;
            E_valB  <= d_valB;
            E_dstE  <= d_dstE;
            E_dstM  <= d_dstM;
            E_srcA  <= d_srcA;
            E_srcB  <= d_srcB;
            E_stat  <= D_stat;
        end

        else
        begin
            E_icode <= 4'h1;
            E_ifun  <= 4'h0;
            E_dstE  <= 4'hF;
            E_dstM  <= 4'hF;
            E_srcA  <= 4'hF;
            E_srcB  <= 4'hF;
        end
    end
    

endmodule