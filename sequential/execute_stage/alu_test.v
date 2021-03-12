`timescale 1ns / 1ps

module alu_test;
    integer k;

    wire [63:0] ALU_A;
    wire [63:0] ALU_B;
    wire [3:0] ALU_fun;
    wire [2:0] cf;
    wire [63:0] valE;
    reg [63:0] valA; 
    reg [63:0] valB;
    reg [63:0] valC;
    reg [3:0] icode;
    reg [3:0] ifun;
    wire [2:0] outf;
    wire Cnd;

    ALU alu(.ALU_A(ALU_A),.ALU_B(ALU_B),.ALU_fun(ALU_fun),.cf(cf),.valE(valE));
    ALU_A_logic alu_a(.icode(icode),.valA(valA),.valC(valC),.ALU_A(ALU_A));
    ALU_B_logic alu_b(.icode(icode),.valB(valB),.ALU_B(ALU_B));
    ALU_FUN alu_fun(.icode(icode),.ifun(ifun),.ALU_fun(ALU_fun));
    CC cc(.icode(icode),.cf(cf),.outf(outf));
    CND cnd(.ifun(ifun),.outf(outf),.Cnd(Cnd));
    

    
    initial begin
        $dumpfile("alu_test.vcd");
        $dumpvars(0,alu_test);
        
        // OpXX rA rB
        icode <= 4'h6;
        ifun  <= 4'h0;
        valA  <= 64'd30;
        valB  <= 64'd50;
        #10;
        icode <= 4'h6;
        ifun  <= 4'h1;
        valA  <= 64'd30;
        valB  <= 64'd50;
        #10;
        icode <= 4'h6;
        ifun  <= 4'h2;
        valA  <= 64'd30;
        valB  <= 64'd50;
        #10;
        icode <= 4'h6;
        ifun  <= 4'h3;
        valA  <= 64'd30;
        valB  <= 64'd50;
        #10;

        // move instructions
        icode <= 4'h3;
        ifun  <= 4'h0;
        valA  <= 64'd30;
        valB  <= 64'd50;
        valC  <= 64'd20;
        #10;
        icode <= 4'h4;
        ifun  <= 4'h0;
        valA  <= 64'd30;
        valB  <= 64'd50;
        valC  <= 64'd35;
        #10;
        icode <= 4'h5;
        ifun  <= 4'h0;
        valA  <= 64'd30;
        valB  <= 64'd50;
        valC  <= 64'd70;
        #10;

        // push pop instructions
        icode <= 4'hA;
        ifun  <= 4'h0;
        valA  <= 64'd30;
        valB  <= 64'd50;
        valC  <= 64'd20;
        #10;
        icode <= 4'hB;
        ifun  <= 4'h0;
        valA  <= 64'd30;
        valB  <= 64'd50;
        valC  <= 64'd20;
        #10;

        
        #10 $finish;
   end
    
endmodule