`timescale 1ns / 1ps

module ALU(ALU_A,ALU_B,ALU_fun,cf,valE);
 
input [31:0]ALU_A;
input [31:0]ALU_B;
input [1:0]ALU_fun;
output [31:0]valE; 
output cf;

wire co1;
wire co2;


wire [31:0]y0;
wire [31:0]y1;
wire [31:0]y2;
wire [31:0]y3;

wire ci0 ;
assign ci0 = 0;
wire ci1 ;
assign ci1 = 1;


bit_32_addsub add1(.co(co1),.ci(ci0) ,.a(ALU_A), .b(ALU_B), .s(y0) );
bit_32_addsub sub1(.co(co2),.ci(ci1) ,.a(ALU_A), .b(~ALU_B), .s(y1) );
bit_32_and and1(.a(ALU_A), .b(ALU_B), .y(y2) );
bit_32_xor xor1(.a(ALU_A), .b(ALU_B), .y(y3) );

mux_41 mux(ALU_fun,co1,co2,y0,y1,y2,y3,cf,valE);

endmodule

module ALU_A_logic(icode,valA,valC,ALU_A)

    input [3:0] icode;
    input [31:0] valA;
    input [31:0] valC;
    output[31:0] ALU_A;
    
    always @ (icode , valA ,valC )
    begin
        case (icode)
        4'h2 , 4'h6 :
            begin
                assign ALU_A = valA;
            end
        4'h3 , 4'h4 , 4'h5  :
            begin
                assign ALU_A = valC;
            end
        4'h9 , 4'hB  :
            begin
                assign ALU_A = 32'd8;
            end
        4'h8 , 4'hA:
            begin
                assign ALU_A = 32'hFFFFFFF8;
            end
        endcase
    end

endmodule


module ALU_B_logic(icode,valB,ALU_B)

    input [3:0] icode;
    input [31:0] valB;
    output[31:0] ALU_B;
    
    always @ (icode , valB )
    begin
        case (icode)
        4'h2 , 4'h4 :
            begin
                assign ALU_B = 32'd0;
            end
        4'h3 , 4'h5 , 4'h6 ,4'h8 ,4'h9 , 4'hA ,4'hB  :
            begin
                assign ALU_A = valB;
            end
        endcase
    end

endmodule
