module Pipeline_control_logic(clk,D_icode,d_srcA,d_srcB,E_icode,E_dstM,e_Cnd,M_icode,m_stat,W_stat,F_stall,D_stall,D_bubble,E_bubble,M_bubble,W_stall);
    input [3:0] D_icode;
    input [3:0] d_srcA;
    input [3:0] d_srcB;
    input [3:0] E_icode;
    input [3:0] E_dstM;
    input e_Cnd;
    input [3:0] M_icode;
    input [2:0] m_stat;
    input [2:0] W_stat;
    input clk;

    output reg F_stall;
    output reg D_stall;
    output reg D_bubble;
    output reg E_bubble;
    output reg M_bubble;
    output reg W_stall;

    parameter SAOK = 3'h1;
    parameter SHLT = 3'h2;
    parameter SADR = 3'h3;
    parameter SINS = 3'h4;

    initial
    begin
        F_stall <= 1'b0;
        D_stall <= 1'b0; 
        D_bubble <= 1'b0;
        E_bubble <= 1'b0;
        M_bubble <= 1'b0;
        W_stall <= 1'b0; 
    end

    always @(*)
    begin
        F_stall <= ( ((E_icode == 4'h5 || E_icode == 4'hB) && (E_dstM == d_srcA || E_dstM == d_srcB)) || (D_icode == 4'h9 || E_icode == 4'h9 || M_icode == 4'h9));
        D_bubble <= (( E_icode == 4'h7 && !e_Cnd ) || !(E_icode == 4'h5 || E_icode == 4'hB)  && (E_dstM == d_srcA || E_dstM== d_srcB)&& (D_icode == 4'h9 || E_icode == 4'h9 || M_icode == 4'h9));
        D_stall <= (E_icode == 4'h5 || E_icode == 4'hB) && (E_dstM == d_srcA || E_dstM == d_srcB);
        E_bubble <= (( E_icode == 4'h7 && !e_Cnd ) || (E_icode == 4'h5 || E_icode == 4'hB)  && (E_dstM == d_srcA || E_dstM== d_srcB));
        M_bubble <= (m_stat == SADR ||  m_stat == SHLT || m_stat == SINS) || (W_stat == SADR ||  W_stat == SHLT || W_stat == SINS);
        W_stall <= (W_stat == SADR ||  W_stat == SHLT || W_stat == SINS);
    
    end

endmodule