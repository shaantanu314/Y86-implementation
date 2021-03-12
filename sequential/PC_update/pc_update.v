`timescale 1ns / 1ps
module new_PC(icode,Cnd,valC,valM,valP,newPC);

    input[3:0] icode;
    input Cnd;
    input[63:0] valC;
    input[63:0] valM;
    input[63:0] valP;
    output reg[63:0] newPC;

    initial
    begin
        newPC <= 64'd0;
    end
    always @(*)
    begin
        newPC <= valP;
    end
    
    always @(icode,Cnd,valC,valM,valP)
    begin
        case (icode)
        4'h8:
            begin
                newPC <= valC;
            end
        4'h7:
            begin
                newPC <= Cnd?valC:valP;
            end
        4'h9:
            begin
                newPC <= valM;
            end
        default:    newPC <= valP;
    endcase

    end

endmodule
