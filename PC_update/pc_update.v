`timescale 1ns / 1ps
module new_PC(icode,Cnd,valC,valM,valP,newPC);

    input[3:0] icode;
    input Cnd;
    input[31:0] valC;
    input[31:0] valM;
    input[31:0] valP;
    output[31:0] newPC;

    always @(icode,Cnd,valC,valM,valP)
    begin
        case (icode)
        4'h8:
            begin
                assign newPC = valC;
            end
        4'h7:
            begin
                assign newPC = Cnd?valC:valP;
            end
        4'h9:
            begin
                assign newPC = valM;
            end
        default: assign newPC = valP;
    endcase

    end

endmodule
