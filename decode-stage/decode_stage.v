`timescale 1ns / 1ps
module register_file(clk,dstE, dstM, srcA , srcB , valA , valB , valM, valE);
    input clk;
    input [ 3:0] dstE;
    input [31:0] valE;
    input [ 3:0] dstM;
    input [31:0] valM;
    input [ 3:0] srcA;
    output [31:0] valA;
    input [ 3:0] srcB;
    output [31:0] valB;

    parameter RAX = 4’h0;
    parameter RCX = 4’h1;
    parameter RDX = 4’h2;
    parameter RBX = 4’h3;
    parameter RSP = 4’h4;
    parameter RBP = 4’h5;
    parameter RSI = 4’h6;
    parameter RDI = 4’h7;
    parameter R8  = 4’h8;
    parameter R9  = 4’h9;
    parameter R10 = 4’ha;
    parameter R11 = 4’hb;
    parameter R12 = 4’hc;
    parameter R13 = 4’hd;
    parameter R14 = 4’he;
    parameter RNONE = 4’hf;

    reg [31:0] reg_mem [14:0];


    always @(posedg clk)
    begin   
        if(dstE!=RNONE)
        begin
            reg_mem[dstE] = valE;
        end
        
        if(dstM!=RNONE)
        begin
            reg_mem[dstM] = valM;
        end

        if(srcA!=RNONE)
        begin
            assign valA = reg_mem[srcA] ;
        end
        
        if(srcB!=RNONE)
        begin
            assign valB = reg_mem[srcB] ;
        end

    end


endmodule

module dstE_logic(icode,rB,dstE,Cnd,ifun)

    parameter RBX = 4’h3;
    parameter RSP = 4’h4;
    parameter RNONE = 4’hf;

    input[3:0] icode;
    input[3:0] rB;
    output[3:0] dstE;
    input Cnd;
    input[3:0] ifun;

    always @(icode,rB,ifun,Cnd)
    begin
        
        case (icode)
        4'h2:
            begin
                if(ifun == 4h'0)
                    assign dstE = rB;
                else
                    begin
                        if(Cnd==1'b1)
                            assign dstE = rB;
                        else
                            assign dstE = 4'hF;
                    end           
            end
        4'h3 , 4'h6:
            begin
                assign dstE = rB;
            end
        4'hA , 4'hB , 4'h8 , 4'h9 :
            begin
                assign dstE = RSP;
            end
        default: assign dstE = RNONE;
        endcase

    end 
endmodule

module srcA_logic(icode,rA,srcA)

    parameter RSP = 4’h4;
    parameter RNONE = 4’hf;

    input[3:0] icode;
    input[3:0] rA;
    output[3:0] srcA;

    always @(icode,rA)
    begin
        
        case (icode)
        4'h2 , 4'h3 , 4'h6 , 4'hA:
            begin
                assign srcA = rA;
            end
        4'hB , 4'h9  :
            begin
                assign srcA = RSP;
            end
        default: assign srcA = RNONE;
        endcase

    end 
endmodule


module dstM_logic(icode,rA,dstM)

    parameter RBX = 4’h3;
    parameter RSP = 4’h4;
    parameter RNONE = 4’hf;

    input[3:0] icode;
    input[3:0] rA;
    output[3:0] dstM;

    always @(icode,rA)
    begin
        
        case (icode)
        4'h5 , 4'hB:
            begin
                assign dstM = rA;
            end
        default: assign dstM = RNONE;
        endcase

    end 
endmodule

module srcB_logic(icode,rB,srcB)

    parameter RSP = 4’h4;
    parameter RNONE = 4’hf;

    input[3:0] icode;
    input[3:0] rB;
    output[3:0] srcB;

    always @(icode,rB)
    begin
        
        case (icode)
        4'h4 , 4'h5 , 4'h6:
            begin
                assign srcB = rB;
            end
        4'h8 , 4'h9 ,4'hA , 4'hB:
            begin
                assign srcB = RSP;
            end
        default: assign srcB = RNONE;
        endcase

    end 
endmodule