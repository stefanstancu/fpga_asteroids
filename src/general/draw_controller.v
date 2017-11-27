/*
* Controller for all drawing operations
*/

module draw_controller(
    input clk,
    input [ENTITY_SIZE-1:0]ship_reg,
    input [MAX_ASTEROIDS-1:0][ENTITY_SIZE-1:0] asteroid_reg,
    input [MAX_SHOT-1:0][ENTITY_SIZE-1:0] shot_reg,

    output reg [9:0] x,
    output reg [9:0] y,
    output reg [2:0] color,
    output reg plot
);

    // Parameters
    parameter ENTITY_SIZE       = 34,
              MAX_ASTEROIDS     = 5,
              MAX_SHOTS         = 10,
              MAX_SHIPS         = 1;

    // Wires
    wire [2:0][9:0] w_x, w_y;
    wire [2:0][2:0] w_color;
    wire [2:0] w_writeEn, w_draw_done;
    wire [ENTITY_SIZE-1:0] w_entity;
    wire [2:0] w_entity_state;

    // entity controller
    entity_controller ec(
        .draw_done(w_draw_done),
        .ship_reg(ship_reg),
        .asteroid_reg(asteroid_reg),
        .shot_reg(shot_reg),

        .entity(w_entity),
        .entity_state_out(w_entity_state)
    );
    
    // The sprite_drawing modules
    draw_ship d_ship(
        .clk(clk),
        .x_pos(w_entity[15:6]),
        .y_pos(w_entity[25:6]),
        .plot(w_entity_state[33]),
        .reset_n(reset_n),
        .direction(w_entity[5:0]),

        .x(w_x[2]),
        .y(w_y[2]),
        .writeEn(w_writeEn[2]),
        .color(w_color[2]),
        .draw_done(w_draw_done[2])
    );

    draw_asteroid d_asteroid(
        .clk(clk),
        .x_pos(w_entity[15:6]),
        .y_pos(w_entity[25:6]),
        .plot(w_entity[33]),
        .reset_n(reset_n),
        .sprite_sel(w_entity[32:30]),

        .x(w_x[1]),
        .y(w_y[1]),
        .writEn(w_writeEn[1]),
        .color(w_color[1]),
        .draw_done(w_draw_done[1])
    );

    // Draw shot
    // Module to be added

    // Mux behaviour
    always@(*) begin
        case(entity_state)
            D_SHIP:begin
                x <= w_x[2];
                y <= w_y[2];
                color <= w_color[2];
                writeEn <= w_writeEn[2];
            end
            D_ASTEROID:begin
                x <= w_x[1];
                y <= w_y[1];
                color <= w_color[1];
                writeEn <= w_writeEn[1];
            end
            D_SHOT: begin
                x <= w_x[0];
                y <= w_y[0];
                color <= w_color[0];
                writeEn <= w_writeEn[0];
            end
        endcase
    end

endmodule

module entity_controller(
    input [2:0] draw_done,
    input [29:0]ship_reg,
    input [MAX_ASTEROIDS-1:0][29:0] asteroid_reg,
    input [MAX_SHOT-1:0][29:0] shot_reg,

    output [29:0] entity,
    output [2:0] entity_state_out
);

    // Parameters
    parameter MAX_ASTEROIDS     = 5,
              MAX_SHOTS         = 10,
              MAX_SHIPS         = 1;

    // Counters
    integer ship_counter = 0,
            asteroid_counter = 0,
            shot_counter = 0;

    reg [2:0] current_state, next_state, entity_state;

    // Output assignments
    assign entity_state_out = entity_state;

    localparam S_DRAW       = 0,
               S_DRAW_WAIT  = 1,
               S_INC_ASTR   = 2,
               S_RESET      = 3;

    localparam D_SHIP       = 3'b100,
               D_ASTEROID   = 3'b010,
               D_SHOT       = 3'b001;

    integer e_state = 0;

    // State Table
    always@(*) begin: state_table
        case(current_state)
            S_DRAW: begin
                next_state = S_DRAW_WAIT;
            end
            S_DRAW: begin
                if (draw_done[e_state])
                    next_state = S_DRAW_INC_ASTR;
                else
                    next_state = S_DRAW_WAIT;
            end
            S_INC_ASTR: begin
                if (shot_counter >= MAX_SHOTS)
                    next_state = S_RESET;
                else
                    next_state = S_DRAW;
            end
            S_RESET: begin
                next_state = S_DRAW;
            end
            default: current_state <= S_RESET;
    end // state_table

    // Output Logic
    always@(*) begin: signals
        
        // Set entity_state based on counter
        if (ship_counter < MAX_SHIPS)
            entity_state <= D_SHIP;
        else if (asteroid_counter < MAX_ASTEROIDS)
            entity_state <= D_ASTEROID;
        else if (shot < MAX_SHOTS)
            entity_state <= D_SHOT;
        else
            entity_state <= 3'b000;

        case(entity_state):
            D_SHIP: begin
                entity <= ship_reg;
            end
            D_ASTEROID: begin
                entity <= asteroid_reg[asteroid_counter];
            end
            D_SHOT: begin
                entity <= shot_reg[shot_counter];
            end
            default: entity <= 30'd0;
        endcase

        // entity_state to index decoder
        case(entity_state):
            D_SHIP: e_state = 2;
            D_ASTEROID: e_state = 1;
            D_SHOT: e_state = 0;
        endcase
    end

    // State Transitions
    always@(posedge clk) begin: state_FFs
        if(reset_n)
            current_state <= S_RESET;
        else
            current_state <= next_state;
    end
endmodule

