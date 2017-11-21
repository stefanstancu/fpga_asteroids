// ECE241 Final Project
// Stefan Stancu 1003153026
// Bianca Esanu
// *
// * ASTEROIDS *
// *

module asteroids(
    input CLOCK_50,
    input [5:0] SW,
    input [0:0] KEY,

    // VGA ouputs
    output VGA_CLK,   						//	VGA Clock
    output VGA_HS,							//	VGA H_SYNC
    output VGA_VS,							//	VGA V_SYNC
    output VGA_BLANK_N,						//	VGA BLANK
    output VGA_SYNC_N,						//	VGA SYNC
    output [7:0] VGA_R,   						//	VGA Red[9:0]
    output [7:0] VGA_G,	 						//	VGA Green[9:0]
    output [7:0] VGA_B  						//	VGA Blue[9:0]
);

    wire reset_n;
    assign reset_n = ~KEY[0];

    wire [2:0] color;
	wire [9:0] x;
	wire [9:0] y;
	wire writeEn;

    wire move_clk;
    wire delta_x, delta_y, sign_x, sign_y;

    vga_adapter VGA(
			.resetn(~reset_n),
			.clock(CLOCK_50),
			.colour(color),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));

    defparam VGA.RESOLUTION = "320x240";
    defparam VGA.MONOCHROME = "FALSE";
    defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
    defparam VGA.BACKGROUND_IMAGE = "black.mif";

    reg [8:0] pos_x, pos_y;

	move_rate_divider mv_div(
		.clk(CLOCK_50),
		.reset_n(reset_n),

		.q(move_clk)
	);

    // Ship movement module
	movementmodule m0(
		.direction(SW[5:0]),
		.reset_n(reset_n),
		.move_clk(move_clk),
		.clk(CLOCK_50),

		.delta_x(delta_x),
		.delta_y(delta_y),
		.sign_x(sign_x),
		.sign_y(sign_y)
	);

    //Draw ship module
    draw_ship ds(
        .clk(CLOCK_50),
        .x_pos(pos_x),
        .y_pos(pos_y),
        .plot(1'b1),
        .reset_n(reset_n),
        .direction(SW[5:0]),

        .x(x),
        .y(y),
        .writeEn(writeEn),
        .color(color)
    );

	always @ (posedge move_clk or posedge reset_n) begin
		if (reset_n) begin
			pos_x <= 9'd0;
			pos_y <= 9'd0;
		end
		else if (delta_x) begin
			if (sign_x)
				pos_x <= pos_x - 1;
			else
				pos_x <= pos_x + 1;
		end
		else if (delta_y) begin
			if (sign_y)
				pos_y <= pos_y - 1;
			else
				pos_y <= pos_y + 1;
		end
	end
endmodule
