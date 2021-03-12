`timescale 1ns / 1ps
module cpu;


    // Fetch-stage wires    
    wire [7:0] f_ibyte;
    wire imem_error;
    wire [3:0] f_icode;
    wire [3:0] f_ifun;
    wire [71:0] f_ibytes;
    wire f_need_regids;
    wire [ 3:0] f_rA;
    wire [ 3:0] f_rB;
    wire [63:0] f_valC;
    wire [63:0] f_valP;
    wire reg f_need_valC;
    wire [63:0] f_predPC;
    wire [63:0] F_predPC;
    wire [63:0] f_pc;
    wire instr_valid;
    wire reg[2:0] f_stat;
    wire F_stall;

    // Decode-stage wires
    wire [ 3:0] d_dstE;
    wire [ 3:0] d_dstM;
    wire [ 3:0] d_srcA;
    wire [63:0] d_rvalA;
    wire [ 3:0] d_srcB;
    wire [63:0] d_valA;
    wire [63:0] d_valB;
    wire [63:0] d_rvalB;
    wire[3:0] D_icode;
    wire[3:0] D_rB;
    wire[3:0] D_ifun;
    wire[3:0] D_rA;
    wire [63:0] D_valP;
    wire [63:0] D_valC;
    wire [2:0] D_stat;
    wire D_bubble;
    wire D_stall;

    // Execute-stage wires
    wire [63:0]ALU_A;
    wire [63:0]ALU_B;
    wire [3:0]ALU_fun;
    wire  [63:0] e_valE; 
    wire  [2:0]cf;
    wire [3:0] E_icode;
    wire [63:0] E_valA;
    wire [63:0] E_valC;
    wire [63:0] E_valB;
    wire [3:0] E_ifun;
    wire [2:0] outf;
    wire e_Cnd;
    wire [3:0] E_dstE;
    wire [3:0] e_dstE;
    wire E_bubble;
    wire [3:0] E_dstM;
    wire [3:0] E_srcA;
    wire [3:0] E_srcB;
    wire [2:0] E_stat;

    // Memory-writeback-stage wires
    wire [63:0] mem_addr;
    wire rd;
    wire wr;
    wire [63:0] m_valM;
    wire dmem_error;
    wire [2:0] m_stat;
    wire [3:0] M_icode;
    wire [63:0] M_valE;
    wire [63:0] M_valA;
    wire [3:0] M_dstE;
    wire [3:0] M_dstM;
    wire  M_Cnd;
    wire [2:0] M_stat;
    wire [3:0] W_icode;
    wire [63:0] W_valE;
    wire [63:0] W_valM;
    wire [3:0] W_dstE;
    wire [3:0] W_dstM;
    wire [2:0] W_stat;
    wire [2:0] w_stat;
  
   

    // clock signal
    reg clk = 1'b1;

  
    
    // FETCH stage

    split splt(.f_ibyte(f_ibyte),.f_icode(f_icode),.f_ifun(f_ifun),.imem_error(imem_error));
    align algn(.f_ibytes(f_ibytes),.f_need_regids(f_need_regids),.f_rA(f_rA),.f_rB(f_rB),.f_valC(f_valC));
    PC_increment pc_i(.f_pc(f_pc),.f_need_regids(f_need_regids),.f_need_valC(f_need_valC),.f_valP(f_valP));
    need_block need_blk(.f_icode(f_icode),.f_need_regids(f_need_regids),.f_need_valC(f_need_valC));
    Predict_PC predpc(.f_icode(f_icode),.f_valP(f_valP),.f_valC(f_valC),.f_predPC(f_predPC));
    InstructionMemory Instr_m(.f_pc(f_pc),.f_ibyte(f_ibyte),.f_ibytes(f_ibytes),.imem_error(imem_error));
    Stat stt(.f_icode(f_icode),.imem_error(imem_error),.f_stat(f_stat));
    F_pipelined_reg Fpr(.clk(clk),.F_stall(F_stall),.f_predPC(f_predPC),.F_predPC(F_predPC));
    SelectPC Selpc(.clk(clk),.F_predPC(F_predPC),.M_icode(M_icode),.M_Cnd(M_Cnd),.M_valA(M_valA),.W_icode(W_icode),.W_valM(W_valM),.f_pc(f_pc));


    // DECODE stage

    register_file regfile(.clk(clk),.W_dstE(W_dstE),.W_dstM(W_dstM),.d_srcA(d_srcA),.d_srcB(d_srcB),.d_rvalA(d_rvalA),.d_rvalB(d_rvalB),.W_valM(W_valM),.W_valE(W_valE));
    dstE_logic dstEl(.D_icode(D_icode),.D_rB(D_rB),.d_dstE(d_dstE));
    srcA_logic scrAl(.D_icode(D_icode),.D_rA(D_rA),.d_srcA(d_srcA));
    dstM_logic dstMl(.D_icode(D_icode),.D_rA(D_rA),.d_dstM(d_dstM));
    srcB_logic srcBl(.D_icode(D_icode),.D_rB(D_rB),.d_srcB(d_srcB));
    Sel_Fwd_A SelFwdA(.D_icode(D_icode),.D_valP(D_valP),.d_rvalA(d_rvalA),.d_srcA(d_srcA),.W_valE(W_valE),.W_dstE(W_dstE),.W_valM(W_valM),.W_dstM(W_dstM),.m_valM(m_valM),.M_dstM(M_dstM),.M_valE(M_valE),.M_dstE(M_dstE),.e_valE(e_valE),.e_dstE(e_dstE),.d_valA(d_valA));
    Fwd_B FwdB(.d_rvalB(d_rvalB),.d_srcB(d_srcB),.W_valE(W_valE),.W_dstE(W_dstE),.W_valM(W_valM),.W_dstM(W_dstM),.m_valM(m_valM),.M_dstM(M_dstM),.M_valE(M_valE),.M_dstE(M_dstE),.e_valE(e_valE),.e_dstE(e_dstE),.d_valB(d_valB));
    D_pipelined_reg Dpr(.clk(clk),.f_stat(f_stat),.D_stat(D_stat),.f_icode(f_icode),.f_ifun(f_ifun),.f_rA(f_rA),.f_rB(f_rB),.f_valC(f_valC),.f_valP(f_valP),.D_icode(D_icode),.D_ifun(D_ifun),.D_rA(D_rA),.D_rB(D_rB),.D_valC(D_valC),.D_valP(D_valP),.D_bubble(D_bubble),.D_stall(D_stall));

    // EXECUTE stage

    ALU alu(.ALU_A(ALU_A),.ALU_B(ALU_B),.ALU_fun(ALU_fun),.cf(cf),.e_valE(e_valE));
    ALU_A_logic aluA(.E_icode(E_icode),.E_valA(E_valA),.E_valC(E_valC),.ALU_A(ALU_A));
    ALU_B_logic aluB(.E_icode(E_icode),.E_valB(E_valB),.ALU_B(ALU_B));
    ALU_FUN aluF(.E_icode(E_icode),.E_ifun(E_ifun),.ALU_fun(ALU_fun));
    CC carry(.clk(clk),.E_icode(E_icode),.cf(cf),.outf(outf),.m_stat(m_stat),.W_stat(W_stat));
    Cond cond_reg(.E_ifun(E_ifun),.outf(outf),.e_Cnd(e_Cnd));
    exe_dstE dstE_exe(.E_bubble(E_bubble),.E_icode(E_icode),.E_dstE(E_dstE),.e_Cnd(e_Cnd),.e_dstE(e_dstE));
    E_pipelined_reg Epr(.clk(clk),.D_stat(D_stat),.E_stat(E_stat),.D_icode(D_icode),.D_ifun(D_ifun),.D_valC(D_valC),.d_dstE(d_dstE),.d_dstM(d_dstM),.d_srcA(d_srcA),.d_srcB(d_srcB),.d_valA(d_valA),.d_valB(d_valB),.E_icode(E_icode),.E_ifun(E_ifun),.E_valC(E_valC),.E_valA(E_valA),.E_valB(E_valB),.E_dstE(E_dstE),.E_dstM(E_dstM),.E_srcA(E_srcA),.E_srcB(E_srcB),.E_bubble(E_bubble));

    // MEMORY  AND WRTE-BACK stage

    RAM ram(.clk(clk),.mem_addr(mem_addr),.M_valA(M_valA),.rd(rd),.wr(wr),.m_valM(m_valM),.dmem_error(dmem_error));
    Mem_read memr(.M_icode(M_icode),.rd(rd));
    Mem_write memw(.M_icode(M_icode),.wr(wr));
    Mem_addr memadd(.M_icode(M_icode),.M_valE(M_valE),.M_valA(M_valA),.mem_addr(mem_addr));
    mem_Stat memst(.M_stat(M_stat),.dmem_error(dmem_error),.m_stat(m_stat));
    M_pipelined_reg Mpr(.clk(clk),.M_stat(M_stat),.E_stat(E_stat),.E_icode(E_icode),.e_Cnd(e_Cnd),.e_valE(e_valE),.E_valA(E_valA),.e_dstE(e_dstE),.E_dstM(E_dstM),.M_icode(M_icode),.M_Cnd(M_Cnd),.M_valE(M_valE),.M_valA(M_valA),.M_dstE(M_dstE),.M_dstM(M_dstM),.M_bubble(M_bubble));
    W_pipelined_reg Wpr(.clk(clk),.W_stat(W_stat),.m_stat(m_stat),.M_icode(M_icode),.M_valE(M_valE),.m_valM(m_valM),.M_dstE(M_dstE),.M_dstM(M_dstM),.W_icode(W_icode),.W_valE(W_valE),.W_valM(W_valM),.W_dstE(W_dstE),.W_dstM(W_dstM),.W_stall(W_stall));
    Final_Stat Fin_st(.W_stat(W_stat),.w_stat(w_stat));

    // Pipeline_control_logic
    Pipeline_control_logic PCL(.clk(clk),.D_icode(D_icode),.d_srcA(d_srcA),.d_srcB(d_srcB),.E_icode(E_icode),.E_dstM(E_dstM),.e_Cnd(e_Cnd),.M_icode(M_icode),.m_stat(m_stat),.W_stat(W_stat),.F_stall(F_stall),.D_stall(D_stall),.D_bubble(D_bubble),.E_bubble(E_bubble),.M_bubble(M_bubble),.W_stall(W_stall));

    integer k=0;
    initial begin

    $dumpfile("cpu.vcd");
    $dumpvars(0,cpu);

    end
    
    always @(posedge clk)
      begin    

        if(w_stat == 3'h2)
          $finish;
        

      end

    
    

    
    
    always #10 clk = ~clk;

endmodule