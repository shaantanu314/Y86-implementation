`timescale 1ns / 1ps

module ALU(ALU_A,ALU_B,ALU_fun,cf,valE);
 
input [63:0]ALU_A;
input [63:0]ALU_B;
input [3:0]ALU_fun;
output  [63:0]valE; 
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
bit_64_addsub sub1(.co(co2),.ci(ci1) ,.a(ALU_A), .b(~ALU_B), .s(y1) );
bit_64_and and1(.a(ALU_A), .b(ALU_B), .y(y2) ,.co(co3));
bit_64_xor xor1(.a(ALU_A), .b(ALU_B), .y(y3) ,.co(co4));

mux_41 mux(ALU_fun,co1,co2,co3,co4,y0,y1,y2,y3,cf,valE);

endmodule

module ALU_A_logic(icode,valA,valC,ALU_A);

    input [3:0] icode;
    input [63:0] valA;
    input [63:0] valC;
    output reg [63:0] ALU_A;
    
    always @ (icode , valA ,valC )
    begin
        case (icode)
        4'h2 , 4'h6 :
            begin
                ALU_A <= valA;
            end
        4'h3 , 4'h4 , 4'h5  :
            begin
                ALU_A <= valC;
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


module ALU_B_logic(icode,valB,ALU_B);

    input [3:0] icode;
    input [63:0] valB;
    output reg [63:0] ALU_B;
    
    always @ (icode , valB )
    begin
        case (icode)
        4'h2 , 4'h3 :
            begin
                ALU_B <= 64'd0;
            end
        4'h4 , 4'h5 , 4'h6 ,4'h8 ,4'h9 , 4'hA ,4'hB  :
            begin
                ALU_B <= valB;
            end
        endcase
    end

endmodule

module ALU_FUN(icode,ifun,ALU_fun);

    input [3:0] icode;
    input [3:0] ifun;
    output reg [3:0] ALU_fun;

    parameter ADDQ = 4'h0;
    
    always @ (icode,ifun)
    begin
        case (icode)
        4'h6:
            begin
                ALU_fun <= ifun;
            end
        default :
            begin
                ALU_fun <= ADDQ;
            end
        endcase
    end
endmodule

module CC(icode,cf,outf);

    input [3:0] icode;
    input [2:0]cf;
    output reg[2:0] outf;

    always @ (icode,cf)
    begin
        if( icode == 4'h6)
            outf <= cf;  
    end

endmodule

module CND(ifun,outf,Cnd);
    
    input[3:0] ifun;
    input[2:0] outf;
    output reg Cnd;

    always @(ifun,outf)
    begin
        case(ifun)
        4'h0: Cnd <= 1'b1;

        4'h1:
        begin
            if((outf[1]^outf[0])|outf[2]) 
            Cnd <= 1'b1;
            else
            Cnd <= 1'b0;
        end

        4'h2:
        begin
            if(outf[1]^outf[0]) 
            Cnd <= 1'b1;
            else
            Cnd <= 1'b0;
        end
        
        4'h3:
        begin
            if(outf[2]) 
            Cnd <= 1'b1;
            else
            Cnd <= 1'b0;
        end 
        
        4'h4:
        begin
            if(outf[1]) 
            Cnd <= 1'b1;
            else
            Cnd <= 1'b0;
        end
        
        4'h5:
        begin
            if(~(outf[1]^outf[0])) 
            Cnd <= 1'b1;
            else
            Cnd <= 1'b0;
        end
        
        4'h6:
        begin
            if(~(outf[1]^outf[0]) & ~outf[2]) 
            Cnd <= 1'b1;
            else
            Cnd <= 1'b0;
        end
        endcase
        
    end

endmodule


