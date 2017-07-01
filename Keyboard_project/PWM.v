module pwm(clock,reset, out);
	input wire clock;
	input wire reset;
	output reg out;
	parameter N = 7;
	reg [N:0]count; //255

always @(posedge clock) begin
	if(!reset)
		count <= 0;
	else 
		count <= count + 1;
end 

always @* begin 
if (count < 50)
	out = 1;
else 
	out = 0;
end 
endmodule