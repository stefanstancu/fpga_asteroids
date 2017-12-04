/*
* Controller for all drawing operations
*/

module draw_controller(clk, reset_n, ship, asteroids, shots, x, y, color, plot, state, draw_done, draw_ship_state, entity_state, color_out, ec_entity, mif_data, mif_address
);
    parameter ENTITY_SIZE       = 34,
              MAX_ASTEROIDS     = 5,
              MAX_SHOTS         = 10,
              MAX_SHIPS         = 1;

    input clk;
    input reset_n;

    input [ENTITY_SIZE-1:0]ship;
    input [MAX_ASTEROIDS-1:0][ENTITY_SIZE-1:0] asteroids;
    input [MAX_SHOTS-1:0][ENTITY_SIZE-1:0] shots;

    output reg [9:0] x;
    output reg [9:0] y;
    output reg [2:0] color;
    output reg plot;

    // debugging
    output [2:0] state;
    output [2:0] draw_ship_state;
    output [2:0] draw_done;
    output [2:0] entity_state;
    output [2:0][2:0] color_out;
    output [ENTITY_SIZE-1:0] ec_entity;
    output [23:0][2:0] mif_data;
    output [9:0] mif_address;

    // Parameters
    localparam D_SHIP       = 3'b100,
               D_ASTEROID   = 3'b010,
               D_SHOT       = 3'b001;


    // Wires
    wire [2:0][9:0] w_x, w_y;
    wire [2:0][2:0] w_color;
    wire [2:0] w_writeEn, w_draw_done;
    wire [ENTITY_SIZE-1:0] w_entity;
    wire [2:0] w_entity_state;
    reg w_draw_entity_done;

    assign draw_done = w_draw_done;
    assign entity_state = w_entity_state;
    
    assign color_out = w_color;
    assign ec_entity = w_entity;

    // entity controller
    entity_controller #(
        .ENTITY_SIZE(ENTITY_SIZE),
        .MAX_ASTEROIDS(MAX_ASTEROIDS),
        .MAX_SHIPS(MAX_SHIPS),
        .MAX_SHOTS(MAX_SHOTS)
    )
    ec(
        .clk(clk),
        .reset_n(reset_n),
        .draw_done(w_draw_entity_done),
        .ship_reg(ship),
        .asteroid_reg(asteroids),
        .shot_reg(shots),

        .entity(w_entity),
        .entity_state_out(w_entity_state),
        .state(state)
    );
    
    // The sprite_drawing modules
    draw_ship d_ship(
        .clk(clk),
        .x_pos(ship[15:6]),
        .y_pos(ship[25:16]),
        .plot(ship[33]),
        .reset_n(reset_n),
        .direction(ship[5:0]),

        .x(w_x[2]),
        .y(w_y[2]),
        .writeEn(w_writeEn[2]),
        .color(w_color[2]),
        
        // debugging
        .draw_done(w_draw_done[2]),
        .state(draw_ship_state),
        .mif_address(mif_address)
    );

    draw_asteroid d_asteroid(
        .clk(clk),
        .x_pos(w_entity[15:6]),
        .y_pos(w_entity[25:16]),
        .plot(w_entity[33]),
        .reset_n(reset_n),
        .sprite_sel(w_entity[32:30]),

        .x(w_x[1]),
        .y(w_y[1]),
        .writeEn(w_writeEn[1]),
        .color(w_color[1]),
        .draw_done(w_draw_done[1])
    );

    // Draw shot
    draw_shot d_shot(
        .clk(clk),
        .x_pos(w_entity[15:6]),
        .y_pos(w_entity[25:16]),
        .plot(w_entity[33]),
        .reset_n(reset_n),
        .sprite_sel(w_entity[32:30]),

        .x(w_x[0]),
        .y(w_y[0]),
        .writeEn(w_writeEn[0]),
        .color(w_color[0]),
        .draw_done(w_draw_done[0])
    );

    // Mux behaviour
    always@(*) begin
        case(w_entity_state)
            D_SHIP:begin
                x <= w_x[2];
                y <= w_y[2];
                color <= w_color[2];
                plot <= w_writeEn[2];
                w_draw_entity_done <= w_draw_done[2];
            end
            D_ASTEROID:begin
                x <= w_x[1];
                y <= w_y[1];
                color <= w_color[1];
                plot <= w_writeEn[1];
                w_draw_entity_done <= w_draw_done[1];
            end
            D_SHOT: begin
                x <= w_x[0];
                y <= w_y[0];
                color <= w_color[0];
                plot <= w_writeEn[0];
                w_draw_entity_done <= w_draw_done[0];
            end
            default: begin
                x <= w_x[2];
                y <= w_y[2];
                color <= w_color[2];
                plot <= w_writeEn[2];
                w_draw_entity_done <= w_draw_done[2];
            end
        endcase
    end

endmodule

module test_draw_controller(
    input clk,
    input reset_n,

    output [9:0] x,
    output [9:0] y,
    output [2:0] color,
    output writeOut
);
    parameter ENTITY_SIZE = 34,
              MAX_ASTEROIDS = 3,
              MAX_SHOTS = 3,
              MAX_SHIPS = 1;

    wire [2:0] w_state, w_draw_done, w_draw_ship_state, w_entity_state;
    wire [ENTITY_SIZE-1:0] w_ec_entity;
    wire [2:0][2:0] w_color;
    wire [23:0][2:0] w_mif_data;
    wire [9:0] w_mif_address;

    reg [ENTITY_SIZE-1:0] ship = 34'b1000000000000000000000000000000001;
    reg [MAX_ASTEROIDS-1:0][ENTITY_SIZE-1:0] asteroids;
    reg [MAX_SHOTS-1:0][ENTITY_SIZE-1:0] shots;

    assign asteroids[0] = 34'b1_000_00_00_0000110010_0000000000_000001;
    assign asteroids[1] = 34'b1_000_00_00_0001100110_0001100110_000001;
    assign asteroids[2] = 0;

    assign shots[0] = 34'b1_000_00_00_0000000000_0001100110_000001;
    assign shots[1] = 34'b1_000_00_00_0001100110_0000000000_000001;
    assign shots[2] = 0;

    draw_controller #(
        .ENTITY_SIZE(ENTITY_SIZE),
        .MAX_ASTEROIDS(MAX_ASTEROIDS),
        .MAX_SHOTS(MAX_SHOTS),
        .MAX_SHIPS(MAX_SHIPS)
    ) dc(
        .clk(clk),
        .reset_n(reset_n),
        .ship(ship),
        .asteroids(asteroids),
        .shots(shots),

        .x(x),
        .y(y),
        .color(color),
        .plot(writeOut),
        .state(w_state),
        .draw_done(w_draw_done),
        .draw_ship_state(w_draw_ship_state),
        .entity_state(w_entity_state),
        .color_out(w_color),
        .ec_entity(w_ec_entity),
        .mif_data(w_mif_data),
        .mif_address(w_mif_address)
    );
    
endmodule
