`timescale 1ns / 1ps
module register_file(clk,dstE, dstM, srcA , srcB , valA , valB , valM, valE);
    input clk;
    input [ 3:0] dstE;
    input [63:0] valE;
    input [ 3:0] dstM;
    input [63:0] valM;
    input [ 3:0] srcA;
    output reg[63:0] valA;
    input [ 3:0] srcB;
    output reg[63:0] valB;

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
        if(srcA!=RNONE)
        begin
            valA <= reg_mem[srcA] ;
        end
        
        if(srcB!=RNONE)
        begin
            valB <= reg_mem[srcB] ;
        end

    end
    always @(posedge clk)
    begin   
        
        if(dstE!=RNONE)
        begin
            reg_mem[dstE] <= valE;
            
        end
        
        if(dstM!=RNONE)
        begin
            reg_mem[dstM] <= valM;
        end

       
        $display("Current register status: \n");
        $display("rax : %d   rsp: %d   r8  : %d  r12 : %d \n",reg_mem[0],reg_mem[4],reg_mem[8],reg_mem[12]);
        $display("rcx : %d   rbp: %d   r9  : %d  r13 : %d \n",reg_mem[1],reg_mem[5],reg_mem[9],reg_mem[13]);
        $display("rdx : %d   rsi: %d   r10 : %d  r14 : %d \n",reg_mem[2],reg_mem[6],reg_mem[10],reg_mem[14]);
        $display("rbx : %d   rdi: %d   r11 : %d  F   : XX \n",reg_mem[3],reg_mem[7],reg_mem[11]);
        $display("\n\n");
        

    end


endmodule

module dstE_logic(icode,rB,dstE,Cnd,ifun);

    parameter RBX = 4'h3;
    parameter RSP = 4'h4;
    parameter RNONE = 4'hf;

    input[3:0] icode;
    input[3:0] rB;
    output reg [3:0] dstE;
    input Cnd;
    input[3:0] ifun;

    always @(icode,rB,ifun,Cnd)
    begin
        
        case (icode)
        4'h2:
            begin
                if(ifun == 4'h0)
                    dstE <= rB;
                else
                    begin
                        if(Cnd==1'b1)
                            dstE <= rB;
                        else
                            dstE <= 4'hF;
                    end           
            end
        4'h3 , 4'h6:
            begin
                dstE <= rB;
            end
        4'hA , 4'hB , 4'h8 , 4'h9 :
            begin
                dstE <= RSP;
            end
        default: dstE <= RNONE; // 4'hF;
        endcase

    end 
endmodule

module srcA_logic(icode,rA,srcA);

    parameter RSP = 4'h4;
    parameter RNONE = 4'hf;

    input[3:0] icode;
    input[3:0] rA;
    output reg[3:0] srcA;

    always @(icode,rA)
    begin
        
        case (icode)
        4'h2 , 4'h3 , 4'h6 , 4'hA:
            begin
                srcA <= rA;
            end
        4'hB , 4'h9  :
            begin
                srcA <= RSP;
            end
        default: srcA <= RNONE;
        endcase

    end 
endmodule


module dstM_logic(icode,rA,dstM);

    parameter RBX = 4'h3;
    parameter RSP = 4'h4;
    parameter RNONE = 4'hf;

    input[3:0] icode;
    input[3:0] rA;
    output reg[3:0] dstM;

    always @(icode,rA)
    begin
        
        case (icode)
        4'h5 , 4'hB:
            begin
                dstM <= rA;
            end
        default: dstM <= RNONE;
        endcase

    end 
endmodule

module srcB_logic(icode,rB,srcB);

    parameter RSP = 4'h4;
    parameter RNONE = 4'hf;

    input[3:0] icode;
    input[3:0] rB;
    output reg[3:0] srcB;

    always @(icode,rB)
    begin
        
        case (icode)
        4'h4 , 4'h5 , 4'h6:
            begin
                srcB <= rB;
            end
        4'h8 , 4'h9 ,4'hA , 4'hB:
            begin
                srcB <= RSP;
            end
        default: srcB <= RNONE;
        endcase

    end 
endmodule