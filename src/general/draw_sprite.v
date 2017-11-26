/*
*   Wrapper for drawing a sprite
*   Parameters:
*       sprite_size : the size of the sprite in pixels - 1
*                     assumes square sprite
*/

module draw_sprite(
    // Functional signals
    input clk,
    input reset_n,
    input plot,

    // Data inputs
    input [9:0] x_pos,
    input [9:0] y_pos,
    input [2:0] sprite_pixel_data,

    // Functional outputs
    output plot_out,
    output draw_done,

    // Data outputs
    output [9:0] x_pix,
    output [9:0] y_pix,
    output [9:0] address_out,
    output [2:0] color
);

    // Parameters
    parameter sprite_size = 31;

    // Wires
    wire [4:0] w_x_count, w_y_count;
    wire w_sub_x, w_sub_y, w_reset_x, w_reset_y, w_plot;

    draw_controller controller(
        .clk(clk),
        .x_pos(x_pos),
        .y_pos(y_pos),
        .x_count(w_x_count),
        .y_count(w_y_count),
        .plot(plot),
        .reset_n(reset_n),

        .sub_x(w_sub_x),
        .sub_y(w_sub_y),
        .reset_x(w_reset_x),
        .reset_y(w_reset_y),
        .plot_out(w_plot)
    );

    draw_datapath datapath(
        .clk(clk),
        .reset_n(reset_n),
        .x(x_pos),
        .y(y_pos),
        .sub_x(w_sub_x),
        .sub_y(w_sub_y),
        .reset_x(w_reset_x),
        .reset_y(w_reset_y),
        .data(sprite_pixel_data),
        .plot(w_plot),

        .x_count(w_x_count),
        .y_count(w_y_count),
        .address_out(address_out),
        .plot_out(plot_out),
        .draw_done(),
        .x_pix(x_pix),
        .y_pix(y_pix),
        .color(color)
    );

endmodule

module draw_controller(
    input clk,
    input [9:0] x_pos,
    input [9:0] y_pos,
    input [4:0] x_count,
    input [4:0] y_count,
    input plot,
    input reset_n,

    output reg sub_x,
    output reg sub_y,
    output reg reset_x,
    output reg reset_y,
    output reg plot_out,

    // debug
    output [2:0] state
);

    reg [2:0] current_state, next_state;
    
    //debug
    assign state = current_state;

    localparam S_WAIT       = 0,
               S_PLOT       = 2,
               S_X          = 3,
               S_Y          = 4,
               S_RESET      = 5;

    // State Table
    always@(*)
    begin: state_table
        case(current_state)
            S_PLOT: next_state = S_X;
            S_X: begin
                if (x_count == 0)
                    next_state = S_Y;
                else
                    next_state = S_PLOT;
            end
            S_Y: begin
                if (y_count == 0)
                    next_state = S_RESET;
                else
                    next_state = S_PLOT;
            end
            S_RESET: begin
                next_state = plot ? S_PLOT : S_RESET;
            end
        endcase
    end //state_table

    // Output logic
    always@(*)
    begin: enable_signals
        // Make all the signals 0 by default
        sub_x = 1'b0;
        sub_y = 1'b0;
        reset_x = 1'b0;
        reset_y = 1'b0;
        plot_out = 1'b0;
        draw_done = 1'b0;

        case(current_state)
            S_PLOT: begin
                plot_out = 1'b1;
            end
            S_X: begin
                sub_x = 1'b1;
            end
            S_Y: begin
                sub_y = 1'b1;
                reset_x = 1'b1;
            end
            S_RESET:begin
                reset_x = 1'b1;
                reset_y = 1'b1;
                draw_done = 1'b1;
            end
        endcase
    end

    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(reset_n)
            current_state <= S_WAIT;
        else
            current_state <= next_state;
    end // state_FFs
endmodule

module draw_datapath(
    input clk,
    input reset_n,
    input [9:0] x,
    input [9:0] y,
    input sub_x,
    input sub_y,
    input reset_x,
    input reset_y,
    input [2:0] data,
    input plot,

    output [4:0] x_count,
    output [4:0] y_count,
    output [9:0] address_out,

    output plot_out,
    output reg [9:0] x_pix,
    output reg [9:0] y_pix,
    output [2:0] color
);
    
    parameter sprite_size = 5'd31;

    // counter registers
    reg [4:0] x_counter, y_counter;
    reg [9:0] address;

    assign x_count = x_counter;
    assign y_count = y_counter;
    assign color = data;
    assign plot_out = plot;
    assign address_out = address;

    // register logic
    always@(posedge clk) begin
        if(reset_n) begin
            x_counter <= sprite_size;
            y_counter <= sprite_size;
            address <= 0;
        end
        else begin
            if(sub_x)
                x_counter <= x_counter - 1;
            if(sub_y)
                y_counter <= y_counter - 1;
            if(reset_x)
                x_counter <= sprite_size;
            if(reset_y)
                y_counter <= sprite_size;
            if(plot)
                address <= address + 1;
            if (reset_x && reset_y)
                address <= 0;
        end
    end

    // position calculator
    always@(*) begin
        x_pix <= x + (sprite_size - x_counter);
        y_pix <= y + (sprite_size - y_counter);
    end
endmodule
