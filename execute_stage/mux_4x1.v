module mux_41(c,ci1,ci2,ci3,ci4,y0,y1,y2,y3,co,y);

parameter ADDQ = 4'h0;
parameter SUBQ = 4'h1;
parameter ANDQ = 4'h2;
parameter XORQ = 4'h3;

input [3:0]c;
output reg[63:0]y;

input [63:0]y0;
input [63:0]y1;
input [63:0]y2;
input [63:0]y3;
input [2:0]ci1;
input [2:0]ci2;
input [2:0]ci3;
input [2:0]ci4;
output reg[2:0]co;

always @(c,y0,y1,y2,y3,ci1,ci2,ci3,ci4)
begin
case(c)
ADDQ : begin
		 y<=y0;
		 co<=ci1;
		end
SUBQ : begin
		 y<=y1;
		 co<=ci2;
		end

ANDQ : begin
         y<=y2;
		 co<=ci3;
        end
XORQ : begin
         y<=y3;
		 co<=ci4;
         end
endcase

end
endmodule