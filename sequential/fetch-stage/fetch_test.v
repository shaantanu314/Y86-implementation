`timescale 1ns / 1ps
module fetch_test;
    reg [31:0] pc;

    integer k;

    wire [3:0] icode;
    wire [3:0] ifun;
    wire [3:0] rA;
    wire [3:0] rB;
    wire [63:0] valC;
    wire need_regids;
    wire need_valC;
    wire [31:0] valP;

    reg [7:0] ibyte;
    reg [71:0] ibytes;

    reg clk = 1'b0;

    reg [7:0] instruction_mem [2047:0];
    
    split sp(.ibyte(ibyte),.icode(icode),.ifun(ifun));
    align al(.ibytes(ibytes),.need_regids(need_regids),.rA(rA),.rB(rB),.valC(valC));
    pc_increment pc_i(.pc(pc),.need_regids(need_regids),.need_valC(need_valC),.valP(valP));
    need_block nrb(.icode(icode),.need_regids(need_regids),.need_valC(need_valC));

    initial begin
    $dumpfile("fetch_test.vcd");
    $dumpvars(0,fetch_test);

    pc  = 31'd0;
    $readmemh("rom.mem", instruction_mem);
   
    repeat (20)
        begin
        ibyte = instruction_mem[pc];
        ibytes[71:64] = instruction_mem[pc+1];
        ibytes[63:56] = instruction_mem[pc+2];
        ibytes[55:48] = instruction_mem[pc+3];
        ibytes[47:40] = instruction_mem[pc+4];
        ibytes[39:32] = instruction_mem[pc+5];
        ibytes[31:24] = instruction_mem[pc+6];
        ibytes[23:16] = instruction_mem[pc+7];
        ibytes[15:8] = instruction_mem[pc+8];
        ibytes[7:0] = instruction_mem[pc+9];
        
        @( clk)
            begin
                pc = valP;
            end

        end
    
    #20 $finish;
        
    end

    
    
    always #10 clk = ~clk;

endmodule