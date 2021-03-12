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


module bit_64_addsub(a,b,ci,co,s);
 
input [63:0]a;
 
input [63:0]b;
 
input ci;

output [63:0]s;
output reg [2:0]co;
wire [63:0]c;


 
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
full_adder fa33(a[32],b[32],c[31],s[32],c[32]);
full_adder fa34(a[33],b[33],c[32],s[33],c[33]);
full_adder fa35(a[34],b[34],c[33],s[34],c[34]);
full_adder fa36(a[35],b[35],c[34],s[35],c[35]);
full_adder fa37(a[36],b[36],c[35],s[36],c[36]);
full_adder fa38(a[37],b[37],c[36],s[37],c[37]);
full_adder fa39(a[38],b[38],c[37],s[38],c[38]);
full_adder fa40(a[39],b[39],c[38],s[39],c[39]);
full_adder fa41(a[40],b[40],c[39],s[40],c[40]);
full_adder fa42(a[41],b[41],c[40],s[41],c[41]);
full_adder fa43(a[42],b[42],c[41],s[42],c[42]);
full_adder fa44(a[43],b[43],c[42],s[43],c[43]);
full_adder fa45(a[44],b[44],c[43],s[44],c[44]);
full_adder fa46(a[45],b[45],c[44],s[45],c[45]);
full_adder fa47(a[46],b[46],c[45],s[46],c[46]);
full_adder fa48(a[47],b[47],c[46],s[47],c[47]);
full_adder fa49(a[48],b[48],c[47],s[48],c[48]);
full_adder fa50(a[49],b[49],c[48],s[49],c[49]);
full_adder fa51(a[50],b[50],c[49],s[50],c[50]);
full_adder fa52(a[51],b[51],c[50],s[51],c[51]);
full_adder fa53(a[52],b[52],c[51],s[52],c[52]);
full_adder fa54(a[53],b[53],c[52],s[53],c[53]);
full_adder fa55(a[54],b[54],c[53],s[54],c[54]);
full_adder fa56(a[55],b[55],c[54],s[55],c[55]);
full_adder fa57(a[56],b[56],c[55],s[56],c[56]);
full_adder fa58(a[57],b[57],c[56],s[57],c[57]);
full_adder fa59(a[58],b[58],c[57],s[58],c[58]);
full_adder fa60(a[59],b[59],c[58],s[59],c[59]);
full_adder fa61(a[60],b[60],c[59],s[60],c[60]);
full_adder fa62(a[61],b[61],c[60],s[61],c[61]);
full_adder fa63(a[62],b[62],c[61],s[62],c[62]);
full_adder fa64(a[63],b[63],c[62],s[63],c[63]);

always @(s,a,b)
begin
    // Checking for zero 
    if(s == 64'd0)
        co[2] <= 1'b1; 
    else
        co[2] <= 1'b0;

    // Checking for sign
        co[1] <= s[63];

    // Checking for overflow

    if( ( a[63] && b[63])  || ( !a[63] && !b[63] ) )
        co[0] <= 1'b1; 
    else
        co[0] <= 1'b0;


end
 
endmodule