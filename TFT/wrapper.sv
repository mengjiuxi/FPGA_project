module wrapper (
	input logic CLOCK_50,
	input logic [1:0] KEY,
	input logic [3:0] SW,
	output logic [7:0] LED,
	
	output logic [12:0] DRAM_ADDR,
	output logic [1:0] DRAM_BA, DRAM_DQM,
	output logic DRAM_CKE, DRAM_CLK,
	output logic DRAM_CS_N, DRAM_RAS_N, DRAM_CAS_N, DRAM_WE_N,
	inout wire [15:0] DRAM_DQ,
	
	inout logic I2C_SCLK, I2C_SDAT,
	
	output logic G_SENSOR_CS_N,
	input logic G_SENSOR_INT,
	
	output logic ADC_CS_N, ADC_SADDR, ADC_SCLK,
	input logic ADC_SDAT,
	
	inout logic [33:0] GPIO_0,
	input logic [1:0] GPIO_0_IN,
	inout logic [33:0] GPIO_1,
	input logic [1:0] GPIO_1_IN,
	inout logic [12:0] GPIO_2,
	input logic [2:0] GPIO_2_IN
);

assign LED[0] = 1;
assign LED[2] = 1;
logic [3:0] cnt;
always_ff @(posedge CLOCK_50)
	cnt <= cnt + 1;
logic clock33M;

//assign LED[7:0] = 8'b11111101;
// reg [11:0] keyout;
// assign LED[7:0] = keyout[11:4];
// keyboard keyboard(
// .clock(cnt[3]),
// .reset(!KEY[1]),
// .column({GPIO_1[6], GPIO_1[7], GPIO_1[4]}),
// .row({GPIO_1[3:0]}),
// .out(keyout)
// );

logic [9:0] tft_x, tft_y;
logic [23:0]tft_rgb;

tft_clock tft_clock1(
.c0(clock33M),
.inclk0(CLOCK_50),
.areset(1'b0)
);

tft tft1(
.clock(clock33M),
.dclk(GPIO_0[25]),
.vs(GPIO_0[28]),
.hs(GPIO_0[27]),
.de(GPIO_0[29]),
.x(tft_x),
.y(tft_y),
.reset(KEY[1]),
.disp(GPIO_0[26])
);
assign GPIO_0[23:0] = {tft_rgb[7:0], tft_rgb[15:8], tft_rgb[23:16]};
assign tft_rgb = {tft_y[7:0], tft_x[7:0], 8'h00};
//red green blue
endmodule
