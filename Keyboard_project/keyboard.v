module keyboard(column, row, clock, reset, out);
	input wire [2:0] column;
	input wire reset;
	output reg [3:0] row;
	input wire clock;
	reg [1:0] dout;
	output reg [11:0] out;

always @(posedge clock) begin 
	if (reset)
		dout<=0;
	else 
		dout <= dout + 1;
	end 

always @* begin
	row[3:0] = 0;
case (dout)
	2'b00: row[0] = 1;
	2'b01: row[1] = 1;
	2'b10: row[2] = 1;
	2'b11: row[3] = 1;
endcase
end 

always @(posedge clock) begin

if (reset)
	out<=0;
else case (dout)
	2'b00: out[2:0] <= column;
	2'b01: out[5:3] <= column;
	2'b10: out[8:6] <= column;
	2'b11: out[11:9] <= column;
endcase
end 
endmodule






