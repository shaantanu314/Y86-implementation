`timescale 1ns / 1ps
module new_pc(icode,Cnd,valC,valM,valP,PC);

    input[3:0] icode;
    input Cnd;
    input[31:0] valC;
    input[31:0] valM;
    input[31:0] valP;
    output[31:0] PC;

    always @(icode,Cnd,valC,valM,valP)
    begin
        case (icode)
        4'h8:
            begin
                assign PC = valC;
            end
        4'h7:
            begin
                assign PC = Cnd?valC:valP;
            end
        4'h9:
            begin
                assign PC = valM;
            end
        default: assign PC = valP;
    endcase

    end

endmodule
