`timescale 1ns / 1ps
module ram_test;

    reg [3:0] icode;
    wire [63:0] mem_addr;
    wire [63:0] mem_data;
    reg [63:0] valE;
    reg [63:0] valA;
    reg [63:0] valP;
    wire [63:0] valM;
    wire rd;
    wire wr;

    RAM ram1(.mem_addr(mem_addr),.mem_data(mem_data),.rd(rd),.wr(wr),.valM(valM));
    Mem_read Mr(.icode(icode),.rd(rd));
    Mem_write Mw(.icode(icode),.wr(wr));
    Mem_addr Ma(.icode(icode),.valA(valA),.valE(valE),.mem_addr(mem_addr));
    Mem_data Md(.icode(icode),.valA(valA),.valP(valP),.mem_data(mem_data));    

    
    integer k;
    parameter base_addr = 64'hFF;

    
    initial begin
    $dumpfile("ram_test.vcd");
    $dumpvars(0,ram_test);

    
    for(k=0;k<10;k++)
    begin
        icode <= 4'h4;
        valE  <= k + base_addr;
        valA  <= k+ $random;
        #10;
    end

    for(k=0;k<10;k++)
    begin
        icode <= 4'h5;
        valE  <= k + base_addr;
        #10;
    end

    #20 $finish;
        
    end

    
    


endmodule