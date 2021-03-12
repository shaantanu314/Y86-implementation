`timescale 1ns / 1ps

module split(f_ibyte,f_icode,f_ifun,imem_error);
    input [7:0] f_ibyte;
    input imem_error;
    output reg[3:0] f_icode;
    output reg[3:0] f_ifun;
    initial
    begin
        f_icode <= 4'h1;
    end
    always @ (*)
    begin
    f_icode <= imem_error ? 4'h1: f_ibyte[7:4];
    f_ifun <= f_ibyte[3:0];
    end
endmodule

module align(f_ibytes,f_need_regids,f_rA, f_rB,f_valC);
    input [71:0] f_ibytes;
    input f_need_regids;
    output [ 3:0] f_rA;
    output [ 3:0] f_rB;
    output [63:0] f_valC;
    assign f_rA =  f_ibytes[71:68] ;
    assign f_rB = f_ibytes[67:64];
    assign f_valC = f_need_regids ? f_ibytes[63:0] : f_ibytes[71:8];
endmodule

module PC_increment(f_pc,f_need_regids,f_need_valC,f_valP);
    input [63:0] f_pc;
    input f_need_regids;
    input f_need_valC;
    output reg[63:0] f_valP;
    initial
    begin
        f_valP <= 64'd1;
    end
    always @(*)
    begin
        f_valP <= f_pc + 1 + 8*f_need_valC + f_need_regids;
    end
endmodule

module need_block(f_icode,f_need_regids,f_need_valC);
    input [3:0] f_icode;
    output reg f_need_regids;
    output reg f_need_valC;

    always @(f_icode)
    begin
    case (f_icode)
        4'h0:
            begin
                assign f_need_regids = 1'b0;
                assign f_need_valC = 1'b0;
            end
        4'h1:
            begin
                assign f_need_regids = 1'b0;
                assign f_need_valC = 1'b0;
            end
        4'h2:
            begin
                assign f_need_regids = 1'b1;
                assign f_need_valC = 1'b0;
            end
        4'h3:
            begin
                assign f_need_regids = 1'b1;
                assign f_need_valC = 1'b1;
            end
        4'h4:
            begin
                assign f_need_regids = 1'b1;
                assign f_need_valC = 1'b1;
            end
        4'h5:
            begin
                assign f_need_regids = 1'b1;
                assign f_need_valC = 1'b1;
            end
        4'h6:
            begin
                assign f_need_regids = 1'b1;
                assign f_need_valC = 1'b0;
            end
        4'h7:
            begin
                assign f_need_regids = 1'b0;
                assign f_need_valC = 1'b1;
            end
        4'h8:
            begin
                assign f_need_regids = 1'b0;
                assign f_need_valC = 1'b1;
            end
        4'h9:
            begin
                assign f_need_regids = 1'b0;
                assign f_need_valC = 1'b0;
            end
        4'hA:
            begin
                assign f_need_regids = 1'b1;
                assign f_need_valC = 1'b0;
            end
        4'hB:
            begin
                assign f_need_regids = 1'b1;
                assign f_need_valC = 1'b0;
            end
    endcase
    end

endmodule

module Predict_PC(f_icode,f_valP,f_valC,f_predPC);
    input [63:0] f_valC;
    input [63:0] f_valP;
    input [3:0] f_icode;
    output reg[63:0] f_predPC;
    always @(f_icode,f_valC,f_valP)
    begin
        case(f_icode)

            4'h7,4'h8:
                f_predPC <= f_valC;
            default: f_predPC <= f_valP;
        endcase
    end
    
endmodule

module SelectPC(clk,F_predPC,M_icode,M_Cnd,M_valA,W_icode,W_valM,f_pc);
    input [3:0] M_icode;
    input [3:0] W_icode;
    input M_Cnd;
    input [63:0] M_valA;
    input [63:0] W_valM;
    input [63:0] F_predPC;
    output reg[63:0] f_pc;
    input clk;
    
    initial
    begin
        f_pc <=0;
    end
    always @( *)
    begin
    if(M_icode == 4'h7 && !M_Cnd) 
        f_pc <= M_valA;
    else if( W_icode == 4'h9 )
        f_pc <= W_valM;
    else
        f_pc <= F_predPC;
    end

endmodule

module InstructionMemory(f_pc,f_ibyte,f_ibytes,imem_error);
    input [63:0] f_pc;
    output reg[7:0] f_ibyte;
    output reg[71:0] f_ibytes;
    output reg imem_error;

    reg [7:0] instruction_mem [2047:0];

    initial 
        begin
            $readmemh("./rom.mem", instruction_mem);
            $display("init");
        end
    always @(f_pc)
    begin
        $display(instruction_mem[f_pc]);
        f_ibyte <= instruction_mem[f_pc];
        f_ibytes[71:64] <= instruction_mem[f_pc+1];
        f_ibytes[63:56] <= instruction_mem[f_pc+2];
        f_ibytes[55:48] <= instruction_mem[f_pc+3];
        f_ibytes[47:40] <= instruction_mem[f_pc+4];
        f_ibytes[39:32] <= instruction_mem[f_pc+5];
        f_ibytes[31:24] <= instruction_mem[f_pc+6];
        f_ibytes[23:16] <= instruction_mem[f_pc+7];
        f_ibytes[15:8] <= instruction_mem[f_pc+8];
        f_ibytes[7:0] <= instruction_mem[f_pc+9];

        imem_error <= (f_pc < 64'd0 || f_pc > 64'd2047 ) ? 1'b1:1'b0;
     
    end

endmodule

module Stat(f_icode,imem_error,f_stat);
    input [3:0] f_icode;
    input imem_error;
    reg instr_valid;
    output reg[2:0] f_stat;

    parameter SAOK = 3'h1;
    parameter SHLT = 3'h2;
    parameter SADR = 3'h3;
    parameter SINS = 3'h4;

    always @(*)
    begin
        instr_valid <= (f_icode< 4'h0 || f_icode> 4'hB) ? 1'b0:1'b1; 
        if(imem_error) 
            f_stat <= SADR;
        else if (!instr_valid)
            f_stat <= SINS;
        else if (f_icode == 4'h0)
            f_stat <= SHLT;
        else f_stat <= SAOK;
    end

endmodule

module F_pipelined_reg(clk,F_stall,f_predPC,F_predPC);
    input F_stall;
    input [63:0] f_predPC;
    input clk;
    output reg[63:0] F_predPC;
    initial
    begin
        F_predPC <= 64'd0;
    end
    always @ (posedge clk)
    begin
        if (!F_stall)
            F_predPC <= f_predPC;
    end
endmodule