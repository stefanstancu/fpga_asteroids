module entity_controller(clk, reset_n, draw_done, ship_reg, asteroid_reg, shot_reg, entity, entity_state_out, state
);
    // Parameters
    parameter ENTITY_SIZE       = 34,
              MAX_ASTEROIDS     = 5,
              MAX_SHOTS         = 10,
              MAX_SHIPS         = 1;

    input clk;
    input reset_n;
    input draw_done;
    input [ENTITY_SIZE-1:0]ship_reg;
    input [MAX_ASTEROIDS-1:0][ENTITY_SIZE-1:0] asteroid_reg;
    input [MAX_SHOTS-1:0][ENTITY_SIZE-1:0] shot_reg;

    output reg [ENTITY_SIZE-1:0] entity;
    output [2:0] entity_state_out;
    output [2:0] state;

    // Counters
    integer ship_counter = 0,
            asteroid_counter = 0,
            shot_counter = 0;

    reg [2:0] current_state, next_state, entity_state;

    // Output assignments
    assign entity_state_out = entity_state;
    assign state = current_state;

    localparam S_DRAW       = 3'd0,
               S_DRAW_WAIT  = 3'd1,
               S_INC        = 3'd2,
               S_RESET      = 3'd3;

    localparam D_SHIP       = 3'b100,
               D_ASTEROID   = 3'b010,
               D_SHOT       = 3'b001;

    // State Table
    always@(*) begin: state_table
        case(current_state)
            S_DRAW: begin
                next_state = S_DRAW_WAIT;
            end
            S_DRAW_WAIT: begin
                if (draw_done)
                    next_state = S_INC;
                else
                    next_state = S_DRAW_WAIT;
            end
            S_INC: begin
                if (shot_counter >= MAX_SHOTS)
                    next_state = S_RESET;
                else
                    next_state = S_DRAW;
            end
            S_RESET: begin
                next_state = S_DRAW;
            end
            default: next_state = S_RESET;
        endcase
    end // state_table

    // Output Logic
    always@(*) begin: signals
        
        // Set entity_state based on counter
        if (ship_counter < MAX_SHIPS)
            entity_state <= D_SHIP;
        else if (asteroid_counter < MAX_ASTEROIDS)
            entity_state <= D_ASTEROID;
        else if (shot_counter < MAX_SHOTS)
            entity_state <= D_SHOT;
        else
            entity_state <= 3'b000;

        case(entity_state)
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
       // case(entity_state)
       //     D_SHIP: e_state = 2;
       //     D_ASTEROID: e_state = 1;
       //     D_SHOT: e_state = 0;
       // endcase
    end

    always@(posedge clk) begin: state_FFs
        // State Transitions
        if(reset_n)
            current_state <= S_RESET;
        else
            current_state <= next_state;

        // Counters
        case(current_state)
            S_DRAW: begin
                
            end
            S_DRAW_WAIT: begin
                
            end
            S_INC: begin
                if (ship_counter < MAX_SHIPS)
                    ship_counter = ship_counter + 1;
                else if (asteroid_counter < MAX_ASTEROIDS)
                    asteroid_counter = asteroid_counter + 1; 
                else if (shot_counter < MAX_SHOTS)
                    shot_counter = shot_counter + 1;
            end
            S_RESET: begin
                ship_counter = 0;
                asteroid_counter = 0;
                shot_counter = 0;
            end
        endcase
    end
endmodule
