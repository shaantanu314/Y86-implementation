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

        

 


        #10 $finish;
   end
    
endmodule