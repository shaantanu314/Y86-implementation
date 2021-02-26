`timescale 1ns / 1ps

module bit_32_xor(a,b,y);
 
input [31:0]a;
input [31:0]b;
output [31:0]y; 

xor (y[0],a[0],b[0]);
xor (y[1],a[1],b[1]);
xor (y[2],a[2],b[2]);
xor (y[3],a[3],b[3]);
xor (y[4],a[4],b[4]);
xor (y[5],a[5],b[5]);
xor (y[6],a[6],b[6]);
xor (y[7],a[7],b[7]);
xor (y[8],a[8],b[8]);
xor (y[9],a[9],b[9]);
xor (y[10],a[10],b[10]);
xor (y[11],a[11],b[11]);
xor (y[12],a[12],b[12]);
xor (y[13],a[13],b[13]);
xor (y[14],a[14],b[14]);
xor (y[15],a[15],b[15]);
xor (y[16],a[16],b[16]);
xor (y[17],a[17],b[17]);
xor (y[18],a[18],b[18]);
xor (y[19],a[19],b[19]);
xor (y[20],a[20],b[20]);
xor (y[21],a[21],b[21]);
xor (y[22],a[22],b[22]);
xor (y[23],a[23],b[23]);
xor (y[24],a[24],b[24]);
xor (y[25],a[25],b[25]);
xor (y[26],a[26],b[26]);
xor (y[27],a[27],b[27]);
xor (y[28],a[28],b[28]);
xor (y[29],a[29],b[29]);
xor (y[30],a[30],b[30]);
xor (y[31],a[31],b[31]);

endmodule