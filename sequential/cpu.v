`timescale 1ns / 1ps
module cpu;
    
    // Program counter
    reg [63:0] pc;

    wire [3:0] icode;
    wire [3:0] ifun;
    wire [3:0] rA;
    wire [3:0] rB;
    wire [63:0] valC;
    wire need_regids;
    wire need_valC;
    wire [63:0] valP;
    wire [63:0] valE;
    wire [3:0] dstE;
    wire [3:0] dstM;
    wire [3:0] srcA;
    wire [3:0] srcB;
    wire [63:0] valA;
    wire [63:0] valB;
    wire [63:0] valM;
    wire Cnd;
    wire [63:0] ALU_A;
    wire [63:0] ALU_B;
    wire [3:0] ALU_fun;
    wire [2:0] cf;
    wire [2:0] outf;
    wire [63:0] mem_addr;
    wire [63:0] mem_data;
    wire rd;
    wire wr;
    wire [63:0] newPC;


    reg [7:0] ibyte;
    reg [71:0] ibytes;


    // clock signal
    reg clk = 1'b1;
    integer k=0;
  
    
    // FETCH stage
    reg [7:0] instruction_mem [2047:0];
    split sp(.ibyte(ibyte),.icode(icode),.ifun(ifun));
    align al(.ibytes(ibytes),.need_regids(need_regids),.rA(rA),.rB(rB),.valC(valC));
    pc_increment pc_i(.pc(pc),.need_regids(need_regids),.need_valC(need_valC),.valP(valP));
    need_block nrb(.icode(icode),.need_regids(need_regids),.need_valC(need_valC)); 

    // DECODE stage
    register_file reg_f(.clk(clk),.dstE(dstE), .dstM(dstM), .srcA(srcA) , .srcB(srcB) , .valA(valA) , .valB(valB) , .valM(valM), .valE(valE));
    dstE_logic dE_l(.icode(icode),.rB(rB),.dstE(dstE),.Cnd(Cnd),.ifun(ifun));
    srcA_logic sA_l(.icode(icode),.rA(rA),.srcA(srcA));
    srcB_logic sB_l(.icode(icode),.rB(rB),.srcB(srcB));
    dstM_logic dM_l(.icode(icode),.rA(rA),.dstM(dstM));

    // EXECUTE stage
    ALU alu(.ALU_A(ALU_A),.ALU_B(ALU_B),.ALU_fun(ALU_fun),.cf(cf),.valE(valE));
    ALU_A_logic alu_a(.icode(icode),.valA(valA),.valC(valC),.ALU_A(ALU_A));
    ALU_B_logic alu_b(.icode(icode),.valB(valB),.ALU_B(ALU_B));
    ALU_FUN alu_fun(.icode(icode),.ifun(ifun),.ALU_fun(ALU_fun));
    CC cc(.icode(icode),.cf(cf),.outf(outf));
    CND cnd(.ifun(ifun),.outf(outf),.Cnd(Cnd));

    // MEMORY stage
    RAM ram1(.mem_addr(mem_addr),.mem_data(mem_data),.rd(rd),.wr(wr),.valM(valM));
    Mem_read Mr(.icode(icode),.rd(rd));
    Mem_write Mw(.icode(icode),.wr(wr));
    Mem_addr Ma(.icode(icode),.valA(valA),.valE(valE),.mem_addr(mem_addr));
    Mem_data Md(.icode(icode),.valA(valA),.valP(valP),.mem_data(mem_data)); 

    // PC update stage
    new_PC npc(.icode(icode),.Cnd(Cnd),.valC(valC),.valM(valM),.valP(valP),.newPC(newPC));



    initial begin

    $dumpfile("cpu.vcd");
    $dumpvars(0,cpu);
    $readmemh("rom.mem", instruction_mem);


    end
    
    always @(posedge clk)
      begin    
        pc <= newPC;
        

      end
    always @(pc)
    begin
      ibyte <= instruction_mem[pc];
      ibytes[71:64] <= instruction_mem[pc+1];
      ibytes[63:56] <= instruction_mem[pc+2];
      ibytes[55:48] <= instruction_mem[pc+3];
      ibytes[47:40] <= instruction_mem[pc+4];
      ibytes[39:32] <= instruction_mem[pc+5];
      ibytes[31:24] <= instruction_mem[pc+6];
      ibytes[23:16] <= instruction_mem[pc+7];
      ibytes[15:8] <= instruction_mem[pc+8];
      ibytes[7:0] <= instruction_mem[pc+9];
      if( icode == 4'h0)
        $finish;

    end
    
    

    
    
    always #10 clk = ~clk;

endmodule