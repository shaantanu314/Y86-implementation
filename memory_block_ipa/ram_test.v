`timescale 1ns / 1ps
module ram_test;
    reg [9:0] addr;
    wire [31:0] data_out;
    reg [31:0] data_in;
    reg write, read;
    integer k;
    reg clk = 1'b0;

    ram  ram_1(.addr(addr),.data_in(data_in),.data_out(data_out),.clk(clk),.rd(read),.wr(write));

    initial begin
    $dumpfile("ram_test.vcd");
    $dumpvars(0,ram_test);

    for (k=0;k<=1023;k=k+1)
        begin
            data_in = (k+k)%256;
            read = 0;
            write = 1;
            addr = k;
            #20;
        end
    write = 0;
    repeat (20)
        begin
        addr = $random % 1024;
        read = 1;
        write = 0;
        # 20;
        end
        #20 $finish;
        
    end

    always #10 clk = ~clk;
    
    


endmodule