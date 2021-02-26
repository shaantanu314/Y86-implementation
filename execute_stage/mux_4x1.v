module mux_41(c,ci1,ci2,y0,y1,y2,y3,co,y);

input [1:0]c;
output reg[31:0]y;

input [31:0]y0;
input [31:0]y1;
input [31:0]y2;
input [31:0]y3;
input ci1;
input ci2;
output reg[0:0]co;

always @(*)
begin
case(c)
2'b00 : begin
		 y<=y0;
		 co<=ci1;
		end
2'b01 : begin
		 y<=y1;
		 co<=ci2;
		end

2'b10 : begin
         y<=y2;
		 co<=0;
        end
2'b11 : begin
         y<=y3;
		 co<=0;
         end
endcase

end
endmodule