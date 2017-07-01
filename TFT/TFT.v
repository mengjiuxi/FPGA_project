module tft(dclk, vs, hs, de, clock, reset, x, y, disp
	);//vs vertical sync input
	  //hs horizontal sync input
	  //data input enable
// output wire used in combinational output, where all the output
// comes out at the same time
// use minimum value in the datasheet if typ not given
input wire clock;
input wire reset;
//input wire redin[7:0];
//input wire greenin[7:0];
//input wire bluein[7:0];
//output reg red[7:0];//reg used in sequential output
//output reg green[7:0];
//output reg blue[7:0];
output reg vs;
output reg hs;
output wire de;
output wire dclk; 
output reg disp;
output reg [9:0]x;
output reg [8:0]y;

localparam one = 3'b001, two = 3'b010, three = 3'b011, four = 3'b100;

assign dclk = clock;
reg [9:0]counth;
reg [9:0]countv;
reg [2:0]state;
reg [2:0]next;
// reg [9:0]countx;
// reg [8:0]county;

//thpw = 20*dclk
// counth and tick as the input of the state machine
//assign tick  = 0;
assign de = 0;
// always @(posedge dclk) beginh <=0;
// 	end
// end 

//Hrizontal input timing 
always @(posedge dclk, negedge reset) begin
	if(!reset)
		counth <=0;	
	else
	begin
		if (counth == 0)
			hs <= 0;
		else hs <=1;
		if (counth > 45 && counth < 846 )
			begin
			x <= counth - 46;
			end
		if ( counth == 862)// RGB output enable
			counth <= 0;
		else
			counth <= counth + 1;
	end
end

// typedef enum {one, two, three, four} state, next;
always @(posedge hs, negedge reset) begin 
	if (!reset)//normally pull high
		begin
		state <= one;
		countv <= 0;
		end
	else
		begin 
		state <= next;
		if (countv == 513)
			countv <=0;
		else
			begin
			
			if (countv < 23 || countv > 503)
				y <= 0;
			else
				y <= countv - 23;
			countv <= countv + 1;
			end
		end
	
end

always@ (*) begin
	vs = 1;
	//no need to use else when state stays still
	case (state)
		one: begin
			if(countv < 1)
				begin
					next = one;
					vs = 0;
				end
				else
					next = two;
		end

		two: begin
			if(countv > 1 && countv < 23)
				begin
					next = two;
					vs = 1;
				end
			else
				next = three;
		end

		three: begin
				if(countv > 23 && countv < 503)
					begin
						next = three;
						vs = 1;
					end
				else
					next = four;
		end

		four: begin
				if(countv > 503 && countv < 513)
					begin 
						next = four;
						vs = 1;
					end
				else
					next = one;
		end

		default: next = one;
	endcase // state
end
endmodule // tft