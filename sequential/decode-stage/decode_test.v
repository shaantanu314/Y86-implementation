`timescale 1ns / 1ps

module decode_test;
    integer k;

    reg [63:0] valE;
    reg [3:0] rA; 
    reg [3:0] rB;
    reg [3:0] icode;
    wire [3:0] dstE;
    wire [3:0] dstM;
    wire [3:0] srcA;
    wire [3:0] srcB;
    wire [63:0] valA;
    wire [63:0] valB;
    reg [63:0] valM;
    wire Cnd;
    reg [3:0] ifun;
    reg clk;

    

    register_file reg_f(.clk(clk),.dstE(dstE), .dstM(dstM), .srcA(srcA) , .srcB(srcB) , .valA(valA) , .valB(valB) , .valM(valM), .valE(valE));
    dstE_logic dE_l(.icode(icode),.rB(rB),.dstE(dstE),.Cnd(Cnd),.ifun(ifun));
    srcA_logic sA_l(.icode(icode),.rA(rA),.srcA(srcA));
    srcB_logic sB_l(.icode(icode),.rB(rB),.srcB(srcB));
    dstM_logic dM_l(.icode(icode),.rA(rA),.dstM(dstM));

   

    
    initial begin
    clk <= 1'b0;
        $dumpfile("decode_test.vcd");
        $dumpvars(0,decode_test);
        #10;
        // irmovq
        icode <= 4'h3;
        ifun  <= 4'h0;
        rA <= 4'h0;
        rB <= 4'h3;
        valE <= 64'd525;
        valM <= 64'd300;
        #20;

        // moved 64'd525 to register rbx;

        icode <= 4'h3;
        ifun  <= 4'h0;
        rA <= 4'h3;
        rB <= 4'h0;
        valE <= 64'd300;
        valM <= 64'd300;
        #20;

        // moved 64'd300 to register rax;


        icode <= 4'h6;
        ifun  <= 4'h2;
        rA <= 4'h3;
        rB <= 4'h0;
        valE <= 64'd251;
        valM <= 64'd300;
        #20;

        icode <= 4'h6;
        ifun  <= 4'h2;
        rA <= 4'h3;
        rB <= 4'h0;
        valE <= 64'd252;
        valM <= 64'd300;
        #20;
        icode <= 4'h6;
        ifun  <= 4'h2;
        rA <= 4'h3;
        rB <= 4'h0;
        valE <= 64'd253;
        valM <= 64'd300;
        #20;

        //check memory to reg
        icode <= 4'h5;
        ifun  <= 4'h2;
        rA <= 4'h0;
        rB <= 4'h3;
        valE <= 64'd999;
        valM <= 64'd999;
       
        #20;
        icode <= 4'h6;
        ifun  <= 4'h2;
        rA <= 4'h0;
        rB <= 4'h3;
        valE <= 64'd253;
        valM <= 64'd300;
        
        #20 $finish;
        
   end
   always #10 clk = ~clk;
    
endmodule