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


module bit_32_addsub(a,b,ci,co,s);
 
input [31:0]a;
 
input [31:0]b;
 
input ci;

output [31:0]s;
output co;
wire [31:0]c;


 
full_adder fa1(a[0],b[0],ci,s[0],c[0]);
full_adder fa2(a[1],b[1],c[0],s[1],c[1]);
full_adder fa3(a[2],b[2],c[1],s[2],c[2]);
full_adder fa4(a[3],b[3],c[2],s[3],c[3]);
full_adder fa5(a[4],b[4],c[3],s[4],c[4]);
full_adder fa6(a[5],b[5],c[4],s[5],c[5]);
full_adder fa7(a[6],b[6],c[5],s[6],c[6]);
full_adder fa8(a[7],b[7],c[6],s[7],c[7]);
full_adder fa9(a[8],b[8],c[7],s[8],c[8]);
full_adder fa10(a[9],b[9],c[8],s[9],c[9]);
full_adder fa11(a[10],b[10],c[9],s[10],c[10]);
full_adder fa12(a[11],b[11],c[10],s[11],c[11]);
full_adder fa13(a[12],b[12],c[11],s[12],c[12]);
full_adder fa14(a[13],b[13],c[12],s[13],c[13]);
full_adder fa15(a[14],b[14],c[13],s[14],c[14]);
full_adder fa16(a[15],b[15],c[14],s[15],c[15]);
full_adder fa17(a[16],b[16],c[15],s[16],c[16]);
full_adder fa18(a[17],b[17],c[16],s[17],c[17]);
full_adder fa19(a[18],b[18],c[17],s[18],c[18]);
full_adder fa20(a[19],b[19],c[18],s[19],c[19]);
full_adder fa21(a[20],b[20],c[19],s[20],c[20]);
full_adder fa22(a[21],b[21],c[20],s[21],c[21]);
full_adder fa23(a[22],b[22],c[21],s[22],c[22]);
full_adder fa24(a[23],b[23],c[22],s[23],c[23]);
full_adder fa25(a[24],b[24],c[23],s[24],c[24]);
full_adder fa26(a[25],b[25],c[24],s[25],c[25]);
full_adder fa27(a[26],b[26],c[25],s[26],c[26]);
full_adder fa28(a[27],b[27],c[26],s[27],c[27]);
full_adder fa29(a[28],b[28],c[27],s[28],c[28]);
full_adder fa30(a[29],b[29],c[28],s[29],c[29]);
full_adder fa31(a[30],b[30],c[29],s[30],c[30]);
full_adder fa32(a[31],b[31],c[30],s[31],c[31]);

assign co = c[31];
 
endmodule