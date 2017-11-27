module draw_controller(
    input draw_done,
    input [29:0]ship_reg,
    input [MAX_ASTEROIDS:0][29:0] asteroid_reg,
    input [MAX_SHOT:0][29:0] shot_reg,

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

    // State Table
    always@(*) begin: state_table
        case(current_state)
            S_DRAW: begin
                next_state = S_DRAW_WAIT;
            end
            S_DRAW: begin
                if (draw_done)
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
    end

    // State Transitions
    always@(posedge clk) begin: state_FFs
        if(reset_n)
            current_state <= S_RESET;
        else
            current_state <= next_state;
    end
endmodule

