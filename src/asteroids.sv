// ECE241 Final Project
// Stefan Stancu 1003153026
// Bianca Esanu 1003082139
// *
// * ASTEROIDS *
// *

module asteroids(
    input CLOCK_50,
    input [5:0] SW,
    input [3:0] KEY,

    // VGA ouputs
    output VGA_CLK,   						//	VGA Clock
    output VGA_HS,							//	VGA H_SYNC
    output VGA_VS,							//	VGA V_SYNC
    output VGA_BLANK_N,						//	VGA BLANK
    output VGA_SYNC_N,						//	VGA SYNC
    output [7:0] VGA_R,   					//	VGA Red[9:0]
    output [7:0] VGA_G,	 					//	VGA Green[9:0]
    output [7:0] VGA_B  					//	VGA Blue[9:0]
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

    // Logic Constants
    localparam ENTITY_SIZE = 34;
    // Set Counts Parameters
    localparam MAX_SHIPS        = 1,
               MAX_ASTEROIDS    = 3,
               MAX_SHOTS        = 3;

    // Entity registers
    reg [ENTITY_SIZE-1:0] ship = 34'b1000000000000000000000000000000001;
    reg [MAX_ASTEROIDS-1:0][ENTITY_SIZE-1:0] asteroids;
    reg [MAX_SHOTS-1:0][ENTITY_SIZE-1:0] shots;

    assign asteroids[0] = 34'b1_000_00_00_0000110010_0000000000_000001;
    assign asteroids[1] = 34'b1_000_00_00_0001100110_0001100110_000001;
    assign asteroids[2] = 0;

    wire [5:0] w_ship_direction;
    wire [MAX_SHOTS-1:0][ENTITY_SIZE-1:0] shots_data;

	rate_divider #(.rate(24'd2000000)) mv_div(
		.clk(CLOCK_50),
		.reset_n(reset_n),

		.q(move_clk)
	);

    // rotation to direction decoder
    directionModule dirmod(
        .moveClock(move_clk),
        .directionIn(ship[5:0]),
        .right(KEY[1]),
        .left(KEY[3]),

        .directionOut(w_ship_direction)
    );

    // Ship movement module
	movementmodule m0(
		.direction(ship[5:0]),
		.reset_n(reset_n),
		.move_clk(move_clk),
		.clk(CLOCK_50),

		.delta_x(delta_x),
		.delta_y(delta_y),
		.sign_x(sign_x),
		.sign_y(sign_y)
	);

    // Shot controller
    shot_controller sc(
        .clk(move_clk),
        .shoot(~KEY[2]),
        .reset_n(reset_n),
        .delete_shot(1'b0),
        .shot_address(1'b0),
        .entity_byte(3'b000),
        .direction({ship[2:0], ship[5:3]}),
        .xtip(ship[15:6]),
        .ytip(ship[25:16]),

        .shots_data(shots_data)
    );

    // Draw controller for all entities
    draw_controller #(
        .ENTITY_SIZE(ENTITY_SIZE),
        .MAX_SHIPS(MAX_SHIPS),
        .MAX_SHOTS(MAX_SHOTS),
        .MAX_ASTEROIDS(MAX_ASTEROIDS)
    )dc(
        .clk(CLOCK_50),
        .ship(ship),
        .asteroids(asteroids),
        .shots(shots),

        .x(x),
        .y(y),
        .color(color),
        .plot(writeEn)
    );
    
/*
    draw_ship test_draw_ship(
        .clk(CLOCK_50),
        .x_pos(ship[15:6]),
        .y_pos(ship[25:16]),
        .plot(1'b1),
        .reset_n(reset_n),
        .direction(ship[5:0]),

        .x(x),
        .y(y),
        .writeEn(writeEn),
        .color(color)
    );
    */

	always @ (posedge move_clk or posedge reset_n) begin
		if (reset_n) begin
			ship[15:6] <= 10'd0;
			ship[25:16] <= 10'd0;
            ship[5:0] <= 6'b000001;
		end
		else if (delta_x) begin
			if (sign_x)
				ship[15:6] <= ship[15:6] - 1;
			else
				ship[15:6] <= ship[15:6] + 1;
		end
		else if (delta_y) begin
			if (sign_y)
				ship[25:16] <= ship[25:16] - 1;
			else
				ship[25:16] <= ship[25:16] + 1;
		end
        ship[5:0] <= w_ship_direction;
        shots <= shots_data;
	end
endmodule
