`timescale 1ns / 1ps

module ALU(ALU_A,ALU_B,ALU_fun,cf,valE);
 
input [63:0]ALU_A;
input [63:0]ALU_B;
input [3:0]ALU_fun;
output [63:0]valE; 
output [2:0]cf;

wire co1;
wire co2;


wire [63:0]y0;
wire [63:0]y1;
wire [63:0]y2;
wire [63:0]y3;

wire ci0 ;
assign ci0 = 0;
wire ci1 ;
assign ci1 = 1;


bit_64_addsub add1(.co(co1),.ci(ci0) ,.a(ALU_A), .b(ALU_B), .s(y0) );
bit_64_addsub sub1(.co(co2),.ci(ci1) ,.a(ALU_A), .b(~ALU_B), .s(y1) );
bit_64_and and1(.a(ALU_A), .b(ALU_B), .y(y2) );
bit_64_xor xor1(.a(ALU_A), .b(ALU_B), .y(y3) );

mux_41 mux(ALU_fun,co1,co2,y0,y1,y2,y3,cf,valE);

endmodule

module ALU_A_logic(icode,valA,valC,ALU_A)

    input [3:0] icode;
    input [63:0] valA;
    input [63:0] valC;
    output[63:0] ALU_A;
    
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
    input [63:0] valB;
    output[63:0] ALU_B;
    
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

module ALU_FUN(icode,ifun,ALU_fun)

    input [3:0] icode;
    input [3:0] ifun;
    output [3:0] ALU_fun;

    parameter ADDQ = 2’h0;
    
    always @ (icode,ifun)
    begin
        case (icode)
        4'h6:
            begin
                assign ALU_fun = ifun;
            end
        default :
            begin
                assign ALU_fun = ADDQ;
            end
        endcase
    end
endmodule

module CC(icode,cf,outf)

    input [3:0] icode;
    input [2:0]cf;
    output reg[2:0] outf;

    always @ (icode,cf)
    begin
        if( icode == 4'h6)
            outf = cf;  
    end

endmodule

module CND(ifun,outf,Cnd)
    
    input[3:0] ifun;
    input[2:0] outf;
    output Cnd;

    always @(ifun,outf)
    begin
        case(ifun)
        4'h0: assign Cnd = 1b'1;

        4'h1:
        begin
            if((outf[1]^outf[0])|outf[2]) 
            assign Cnd = 1b'1;
            else
            assign Cnd = 1b'0;
        end

        4'h2:
        begin
            if(outf[1]^outf[0]) 
            assign Cnd = 1b'1;
            else
            assign Cnd = 1b'0;
        end
        
        4'h3:
        begin
            if(outf[2]) 
            assign Cnd = 1b'1;
            else
            assign Cnd = 1b'0;
        end 
        
        4'h4:
        begin
            if(outf[1]) 
            assign Cnd = 1b'1;
            else
            assign Cnd = 1b'0;
        end
        
        4'h5:
        begin
            if(~(outf[1]^outf[0])) 
            assign Cnd = 1b'1;
            else
            assign Cnd = 1b'0;
        end
        
        4'h6:
        begin
            if(~(outf[1]^outf[0]) & ~outf[2]) 
            assign Cnd = 1b'1;
            else
            assign Cnd = 1b'0;
        end
        endcase
        
    end

endmodule