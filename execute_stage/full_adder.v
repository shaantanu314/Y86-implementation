`timescale 1ns / 1ps
module full_adder(a,b,ci,s,co);
input a,b,ci;
output co,s;

xor (y1,a,b);
xor (s,y1,ci);

and (y2,a,b);
and (y3,y1,ci);

or (co,y2,y3);

endmodule



