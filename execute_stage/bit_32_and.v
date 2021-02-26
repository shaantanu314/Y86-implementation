`timescale 1ns / 1ps

module bit_32_and(a,b,y);
 
input [31:0]a;
input [31:0]b;
output [31:0]y; 

and (y[0],a[0],b[0]);
and (y[1],a[1],b[1]);
and (y[2],a[2],b[2]);
and (y[3],a[3],b[3]);
and (y[4],a[4],b[4]);
and (y[5],a[5],b[5]);
and (y[6],a[6],b[6]);
and (y[7],a[7],b[7]);
and (y[8],a[8],b[8]);
and (y[9],a[9],b[9]);
and (y[10],a[10],b[10]);
and (y[11],a[11],b[11]);
and (y[12],a[12],b[12]);
and (y[13],a[13],b[13]);
and (y[14],a[14],b[14]);
and (y[15],a[15],b[15]);
and (y[16],a[16],b[16]);
and (y[17],a[17],b[17]);
and (y[18],a[18],b[18]);
and (y[19],a[19],b[19]);
and (y[20],a[20],b[20]);
and (y[21],a[21],b[21]);
and (y[22],a[22],b[22]);
and (y[23],a[23],b[23]);
and (y[24],a[24],b[24]);
and (y[25],a[25],b[25]);
and (y[26],a[26],b[26]);
and (y[27],a[27],b[27]);
and (y[28],a[28],b[28]);
and (y[29],a[29],b[29]);
and (y[30],a[30],b[30]);
and (y[31],a[31],b[31]);

endmodule