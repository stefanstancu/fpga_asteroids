module poly_entity_dc(
);

endmodule

module pedc_controller(
    input draw_done
);

    // Parameters
    parameter MAX_ASTEROIDS     = 5,
              MAX_SHOTS         = 10,
              MAX_SHIPS         = 1;

    // Counters
    reg [4:0] ship_counter, asteroid_counter, shot_counter;

    reg [2:0] current_state, next_state, entity_state;

    localparam S_ROUTE      = 0,
               S_DRAW       = 1,
               S_INC_SHIP   = 2,
               S_INC_ASTR   = 3,
               S_INC_SHOT   = 4,
               S_RESET      = 5;

    // State Table
    always@(*) begin: state_table
        case(current_state)
            S_ROUTE: begin
                if(ship_counter < MAX_SHIPS)
                else if(asteroid_counter < MAX)
                else if()
                else
            end
            S_DRAW: begin
            end
            S_INC_SHIP: begin
            end
            S_INC_ASTR: begin
            end
            S_INC_SHOT: begin
            end
            S_RESET: begin
            end
            default: current_state <= S_RESET;
    end // state_table
endmodule

module pedc_datapath(
);

endmodule
