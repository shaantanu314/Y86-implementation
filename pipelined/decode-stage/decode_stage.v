`timescale 1ns / 1ps
module register_file(clk,W_dstE, W_dstM, d_srcA , d_srcB , d_rvalA , d_rvalB , W_valM, W_valE);
    input clk;
    input [ 3:0] d_dstE;
    input [63:0] W_valE;
    input [ 3:0] d_dstM;
    input [63:0] W_valM;
    input [ 3:0] d_srcA;
    input [3:0] W_dstE;
    input [3:0] W_dstM;
    output reg[63:0] d_rvalA;
    input [ 3:0] d_srcB;
    output reg[63:0] d_rvalB;

    integer i,fd;
    parameter RAX = 4'h0;
    parameter RCX = 4'h1;
    parameter RDX = 4'h2;
    parameter RBX = 4'h3;
    parameter RSP = 4'h4;
    parameter RBP = 4'h5;
    parameter RSI = 4'h6;
    parameter RDI = 4'h7;
    parameter R8  = 4'h8;
    parameter R9  = 4'h9;
    parameter R10 = 4'ha;
    parameter R11 = 4'hb;
    parameter R12 = 4'hc;
    parameter R13 = 4'hd;
    parameter R14 = 4'he;
    parameter RNONE = 4'hf;

    reg [63:0] reg_mem [14:0];

    // initialize registers with 0's
    initial
    begin
    reg_mem[4'h0] <= 64'h0;
    reg_mem[4'h1] <= 64'h0;
    reg_mem[4'h2] <= 64'h0;
    reg_mem[4'h3] <= 64'h0;
    reg_mem[4'h4] <= 64'h0;
    reg_mem[4'h5] <= 64'h0;
    reg_mem[4'h6] <= 64'h0;
    reg_mem[4'h7] <= 64'h0;
    reg_mem[4'h8] <= 64'h0;
    reg_mem[4'h9] <= 64'h0;
    reg_mem[4'hA] <= 64'h0;
    reg_mem[4'hB] <= 64'h0;
    reg_mem[4'hC] <= 64'h0;
    reg_mem[4'hD] <= 64'h0;
    reg_mem[4'hE] <= 64'h0;
    end


    always @ (*)
    begin
        if(d_srcA!=RNONE)
        begin
            d_rvalA <= reg_mem[d_srcA] ;
        end
        
        if(d_srcB!=RNONE)
        begin
            d_rvalB <= reg_mem[d_srcB] ;
        end

    end
    always @(posedge clk)
    begin   
        
        if(W_dstE!=RNONE)
        begin
            reg_mem[W_dstE] <= W_valE;
            
        end
        
        if(W_dstM!=RNONE)
        begin
            reg_mem[W_dstM] <= W_valM;
        end

       
        $display("Current register status: \n");
        $display("rax : %d   rsp: %d   r8  : %d  r12 : %d \n",reg_mem[0],reg_mem[4],reg_mem[8],reg_mem[12]);
        $display("rcx : %d   rbp: %d   r9  : %d  r13 : %d \n",reg_mem[1],reg_mem[5],reg_mem[9],reg_mem[13]);
        $display("rdx : %d   rsi: %d   r10 : %d  r14 : %d \n",reg_mem[2],reg_mem[6],reg_mem[10],reg_mem[14]);
        $display("rbx : %d   rdi: %d   r11 : %d  F   : XX \n",reg_mem[3],reg_mem[7],reg_mem[11]);
        $display("\n\n");
        

    end


endmodule

module dstE_logic(D_icode,D_rB,d_dstE);

    parameter RBX = 4'h3;
    parameter RSP = 4'h4;
    parameter RNONE = 4'hf;

    input[3:0] D_icode;
    input[3:0] D_rB;
    output reg [3:0] d_dstE;
    input[3:0] D_ifun;

    always @(D_icode,D_rB)
    begin
        
        case (D_icode)
        4'h3 , 4'h6 ,4'h2:
            begin
                d_dstE <= D_rB;
            end
        4'hA , 4'hB , 4'h8 , 4'h9 :
            begin
                d_dstE <= RSP;
            end
        default: d_dstE <= RNONE; // 4'hF;
        endcase

    end 
endmodule

module srcA_logic(D_icode,D_rA,d_srcA);

    parameter RSP = 4'h4;
    parameter RNONE = 4'hf;

    input[3:0] D_icode;
    input[3:0] D_rA;
    output reg[3:0] d_srcA;
    initial 
    begin
        d_srcA <=4'hF;
    end
    always @(D_icode,D_rA)
    begin
        
        case (D_icode)
        4'h2 , 4'h4 , 4'h6 , 4'hA:
            begin
                d_srcA <= D_rA;
            end
        4'hB , 4'h9  :
            begin
                d_srcA <= RSP;
            end
        default: d_srcA <= RNONE;
        endcase

    end 
endmodule


module dstM_logic(D_icode,D_rA,d_dstM);

    parameter RBX = 4'h3;
    parameter RSP = 4'h4;
    parameter RNONE = 4'hf;

    input[3:0] D_icode;
    input[3:0] D_rA;
    output reg[3:0] d_dstM;

    always @(D_icode,D_rA)
    begin
        
        case (D_icode)
        4'h5 , 4'hB:
            begin
                d_dstM <= D_rA;
            end
        default: d_dstM <= RNONE;
        endcase

    end 
endmodule

module srcB_logic(D_icode,D_rB,d_srcB);

    parameter RSP = 4'h4;
    parameter RNONE = 4'hf;

    input[3:0] D_icode;
    input[3:0] D_rB;
    output reg[3:0] d_srcB;
    initial 
    begin
        d_srcB <=4'hF;
    end
    always @(D_icode,D_rB)
    begin
        
        case (D_icode)
        4'h4 , 4'h5 , 4'h6:
            begin
                d_srcB <= D_rB;
            end
        4'h8 , 4'h9 ,4'hA , 4'hB:
            begin
                d_srcB <= RSP;
            end
        default: d_srcB <= RNONE;
        endcase

    end 
endmodule


module Sel_Fwd_A(D_icode,D_valP,d_rvalA,d_srcA,W_valE,W_dstE,W_valM,W_dstM,m_valM,M_dstM,M_valE,M_dstE,e_valE,e_dstE,d_valA);
    input [63:0] D_valP;
    input [63:0] d_rvalA;
    input [63:0] W_valE;
    input [63:0] W_valM;
    input [63:0] m_valM;
    input [63:0] M_valE;
    input [63:0] e_valE;
    
    input [3:0] D_icode;

    input [3:0] d_srcA;
    input [3:0] W_dstE;
    input [3:0] W_dstM;
    input [3:0] M_dstE;
    input [3:0] M_dstM;
    input [3:0] e_dstE;

    output reg[63:0] d_valA;

    always @(*)
    begin
        if(D_icode == 4'h7 || D_icode == 4'h8)
            d_valA <= D_valP;
        else
        begin
            case(d_srcA)

                e_dstE: d_valA <= e_valE;
                M_dstM: d_valA <= m_valM;
                M_dstE: d_valA <= M_valE;
                W_dstM: d_valA <= W_valM;
                W_dstE: d_valA <= W_valE;
                default : d_valA <= d_rvalA;

            endcase
        end
    end

endmodule


module Fwd_B(d_rvalB,d_srcB,W_valE,W_dstE,W_valM,W_dstM,m_valM,M_dstM,M_valE,M_dstE,e_valE,e_dstE,d_valB);
    input [63:0] d_rvalB;
    input [63:0] W_valE;
    input [63:0] W_valM;
    input [63:0] m_valM;
    input [63:0] M_valE;
    input [63:0] e_valE;
    
    input [3:0] d_srcB;
    input [3:0] W_dstE;
    input [3:0] W_dstM;
    input [3:0] M_dstE;
    input [3:0] M_dstM;
    input [3:0] e_dstE;

    output reg[63:0] d_valB;

    always @(*)
    begin
        case(d_srcB)

            e_dstE: d_valB = e_valE;
            M_dstM: d_valB = m_valM;
            M_dstE: d_valB = M_valE;
            W_dstM: d_valB = W_valM;
            W_dstE: d_valB = W_valE;
            default : d_valB = d_rvalB;


        endcase
    end

endmodule

module D_pipelined_reg(clk,f_stat,D_stat,f_icode,f_ifun,f_rA,f_rB,f_valC,f_valP,D_icode,D_ifun,D_rA,D_rB,D_valC,D_valP,D_bubble,D_stall);
    input [3:0] f_icode;
    input [3:0] f_ifun;
    input [3:0] f_rA;
    input [3:0] f_rB;
    input [63:0] f_valC;
    input [63:0] f_valP;
    input D_bubble;
    input D_stall;
    input [2:0] f_stat;
    input clk;

    output reg[3:0] D_icode;
    output reg[3:0] D_ifun;
    output reg[3:0] D_rA;
    output reg[3:0] D_rB;
    output reg[63:0] D_valC;
    output reg[63:0] D_valP;
    output reg[2:0] D_stat;

    initial
    begin
        D_icode <= 4'h1;
        D_ifun <=0;
        D_rA <=0;
        D_rB <=0;
        D_valC <=0;
        D_valP <=0;
        D_stat <=0;
    end

    always @(posedge clk)
    begin
        if((D_stall === 1'bX )|| (D_bubble === 1'bX))
            D_icode <= 4'h1;
        else
            begin
            if (!D_stall && !D_bubble)
            begin
                D_icode <= f_icode;
                D_ifun  <= f_ifun;
                D_rA    <= f_rA;
                D_rB    <= f_rB;
                D_valC  <= f_valC;
                D_valP  <= f_valP;
                D_stat  <= f_stat;
            end
            else if(!D_stall & D_bubble)
            begin
                D_icode <= 4'h1; // NOP
                D_ifun  <= 4'h0;
                D_rA    <= 4'hF;
                D_rB    <= 4'hF;
                D_stat  <= f_stat;
            end
        end
    end
    

endmodule