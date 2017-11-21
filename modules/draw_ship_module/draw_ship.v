`timescale 1ps / 1ps

module draw_ship(
    input clk,
    input [9:0] x_pos,
    input [9:0] y_pos,
    input plot,
    input reset_n,
    input [5:0] direction,

    output [9:0] x,
    output [9:0] y,
    output writeEn,
    output [9:0] address,
    output [2:0] color
);

    wire [4:0] w_x_count, w_y_count;
    wire w_sub_x, w_sub_y, w_reset_x, w_reset_y;

    wire [9:0] w_address;
    wire [2:0] w_data [0:23];
    reg [2:0] sprite_data;

    wire w_plot;

    // debug
    wire [2:0] state;

    ship_draw_controller c0(
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
        .plot_out(w_plot),

        .state(state)
    );

    ship_draw_datapath d0(
        .clk(clk),
        .reset_n(reset_n),
        .x(x_pos),
        .y(y_pos),
        .sub_x(w_sub_x),
        .sub_y(w_sub_y),
        .reset_x(w_reset_x),
        .reset_y(w_reset_y),
        .data(sprite_data),
        .plot(w_plot),
        
        .x_count(w_x_count),
        .y_count(w_y_count),
        .address_out(w_address),
        
        .plot_out(writeEn),
        .x_pix(x),
        .y_pix(y),
        .color(color)
    );

    sprite_mem32x32 #("sprite_mifs/0.mif") mem0(
        .clock(clk),
        .address(w_address),
        .q(w_data[0])
    );

    sprite_mem32x32 mem1(
        .clock(clk),
        .address(w_address),
        .q(w_data[1])
    );
    defparam mem1.init_file = "sprite_mifs/1.mif";

    sprite_mem32x32 mem2(
        .clock(clk),
        .address(w_address),
        .q(w_data[2])
    );
    defparam mem2.init_file = "sprite_mifs/2.mif";

    sprite_mem32x32 mem3(
        .clock(clk),
        .address(w_address),
        .q(w_data[3])
    );
    defparam mem3.init_file = "sprite_mifs/3.mif";

    sprite_mem32x32 mem4(
        .clock(clk),
        .address(w_address),
        .q(w_data[4])
    );
    defparam mem4.init_file = "sprite_mifs/4.mif";

    sprite_mem32x32 mem5(
        .clock(clk),
        .address(w_address),
        .q(w_data[5])
    );
    defparam mem5.init_file = "sprite_mifs/5.mif";

    sprite_mem32x32 mem6(
        .clock(clk),
        .address(w_address),
        .q(w_data[6])
    );
    defparam mem6.init_file = "sprite_mifs/0_90.mif";

    sprite_mem32x32 mem7(
        .clock(clk),
        .address(w_address),
        .q(w_data[7])
    );
    defparam mem7.init_file = "sprite_mifs/1_90.mif";

    sprite_mem32x32 mem8(
        .clock(clk),
        .address(w_address),
        .q(w_data[8])
    );
    defparam mem8.init_file = "sprite_mifs/2_90.mif";

    sprite_mem32x32 mem9(
        .clock(clk),
        .address(w_address),
        .q(w_data[9])
    );
    defparam mem9.init_file = "sprite_mifs/3_90.mif";

    sprite_mem32x32 mem10(
        .clock(clk),
        .address(w_address),
        .q(w_data[10])
    );
    defparam mem10.init_file = "sprite_mifs/4_90.mif";

    sprite_mem32x32 mem11(
        .clock(clk),
        .address(w_address),
        .q(w_data[11])
    );
    defparam mem11.init_file = "sprite_mifs/5_90.mif";

    sprite_mem32x32 mem12(
        .clock(clk),
        .address(w_address),
        .q(w_data[12])
    );
    defparam mem12.init_file = "sprite_mifs/0_180.mif";

    sprite_mem32x32 mem13(
        .clock(clk),
        .address(w_address),
        .q(w_data[13])
    );
    defparam mem13.init_file = "sprite_mifs/1_180.mif";

    sprite_mem32x32 mem14(
        .clock(clk),
        .address(w_address),
        .q(w_data[14])
    );
    defparam mem14.init_file = "sprite_mifs/2_180.mif";

    sprite_mem32x32 mem15(
        .clock(clk),
        .address(w_address),
        .q(w_data[15])
    );
    defparam mem15.init_file = "sprite_mifs/3_180.mif";

    sprite_mem32x32 mem16(
        .clock(clk),
        .address(w_address),
        .q(w_data[16])
    );
    defparam mem16.init_file = "sprite_mifs/4_180.mif";

    sprite_mem32x32 mem17(
        .clock(clk),
        .address(w_address),
        .q(w_data[17])
    );
    defparam mem17.init_file = "sprite_mifs/5_180.mif";

    sprite_mem32x32 mem18(
        .clock(clk),
        .address(w_address),
        .q(w_data[18])
    );
    defparam mem18.init_file = "sprite_mifs/0_270.mif";

    sprite_mem32x32 mem19(
        .clock(clk),
        .address(w_address),
        .q(w_data[19])
    );
    defparam mem19.init_file = "sprite_mifs/1_270.mif";

    sprite_mem32x32 mem20(
        .clock(clk),
        .address(w_address),
        .q(w_data[20])
    );
    defparam mem20.init_file = "sprite_mifs/2_270.mif";

    sprite_mem32x32 mem21(
        .clock(clk),
        .address(w_address),
        .q(w_data[21])
    );
    defparam mem21.init_file = "sprite_mifs/3_270.mif";

    sprite_mem32x32 mem22(
        .clock(clk),
        .address(w_address),
        .q(w_data[22])
    );
    defparam mem22.init_file = "sprite_mifs/4_270.mif";

    sprite_mem32x32 mem23(
        .clock(clk),
        .address(w_address),
        .q(w_data[23])
    );
    defparam mem23.init_file = "sprite_mifs/5_270.mif";

    always@(*) begin
        if (!direction[5]) begin
            if(direction[2]) begin
                // 1st quadrant
                case({direction[4:3], direction[1:0]})
                    // Up
                    4'b0001: sprite_data <= w_data[0];
                    4'b0010: sprite_data <= w_data[0];
                    4'b0011: sprite_data <= w_data[0];
                    // 18 deg
                    4'b0111: sprite_data <= w_data[1];
                    // 26 deg
                    4'b0110: sprite_data <= w_data[2];
                    // 45 deg
                    4'b0101: sprite_data <= w_data[3];
                    4'b1010: sprite_data <= w_data[3];
                    4'b1111: sprite_data <= w_data[3];
                    // 63 deg
                    4'b1001: sprite_data <= w_data[4];
                    // 72 deg
                    4'b1101: sprite_data <= w_data[5];
                    // 90 deg
                    4'b0100: sprite_data <= w_data[6];
                    4'b1100: sprite_data <= w_data[6];
                    4'b1000: sprite_data <= w_data[6];
                    default: sprite_data <= 3'b100;
                endcase
            end
            else begin
                // 4th quadrant
                case({direction[4:3], direction[1:0]})
                    // Down
                    4'b0001: sprite_data <= w_data[12];
                    4'b0010: sprite_data <= w_data[12];
                    4'b0011: sprite_data <= w_data[12];
                    // 18 deg
                    4'b0111: sprite_data <= w_data[11];
                    // 26 deg
                    4'b0110: sprite_data <= w_data[8];
                    // 45 deg
                    4'b0101: sprite_data <= w_data[9];
                    4'b1010: sprite_data <= w_data[9];
                    4'b1111: sprite_data <= w_data[9];
                    // 63 deg
                    4'b1001: sprite_data <= w_data[8];
                    // 72 deg
                    4'b1101: sprite_data <= w_data[7];
                    // 90 deg
                    4'b0100: sprite_data <= w_data[6];
                    4'b1100: sprite_data <= w_data[6];
                    4'b1000: sprite_data <= w_data[6];
                    default: sprite_data <= 3'b100;
                endcase
            end
        end
        else begin
            if (direction[2]) begin
                // 2nd quadrant
                case({direction[4:3], direction[1:0]})
                    // Up
                    4'b0001: sprite_data <= w_data[0];
                    4'b0010: sprite_data <= w_data[0];
                    4'b0011: sprite_data <= w_data[0];
                    // 18 deg
                    4'b0111: sprite_data <= w_data[19];
                    // 26 deg
                    4'b0110: sprite_data <= w_data[20];
                    // 45 deg
                    4'b0101: sprite_data <= w_data[21];
                    4'b1010: sprite_data <= w_data[21];
                    4'b1111: sprite_data <= w_data[21];
                    // 63 deg
                    4'b1001: sprite_data <= w_data[22];
                    // 72 deg
                    4'b1101: sprite_data <= w_data[23];
                    // 90 deg
                    4'b0100: sprite_data <= w_data[18];
                    4'b1100: sprite_data <= w_data[18];
                    4'b1000: sprite_data <= w_data[18];
                    default: sprite_data <= 3'b100;
                endcase
            end
            else begin
                // 3rd quadrant
                case({direction[4:3], direction[1:0]})
                    // Up
                    4'b0001: sprite_data <= w_data[12];
                    4'b0010: sprite_data <= w_data[12];
                    4'b0011: sprite_data <= w_data[12];
                    // 18 deg
                    4'b0111: sprite_data <= w_data[13];
                    // 26 deg
                    4'b0110: sprite_data <= w_data[14];
                    // 45 deg
                    4'b0101: sprite_data <= w_data[15];
                    4'b1010: sprite_data <= w_data[15];
                    4'b1111: sprite_data <= w_data[15];
                    // 63 deg
                    4'b1001: sprite_data <= w_data[16];
                    // 72 deg
                    4'b1101: sprite_data <= w_data[17];
                    // 90 deg
                    4'b0100: sprite_data <= w_data[18];
                    4'b1100: sprite_data <= w_data[18];
                    4'b1000: sprite_data <= w_data[18];
                    default: sprite_data <= 3'b100;
                endcase
            end
        end
    end
endmodule

module ship_draw_controller(
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
               S_RELEASE    = 1,
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
            S_RESET: next_state = S_PLOT;
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

module ship_draw_datapath(
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
            x_counter <= 5'd31;
            y_counter <= 5'd31;
            address <= 0;
        end
        else begin
            if(sub_x)
                x_counter <= x_counter - 1;
            if(sub_y)
                y_counter <= y_counter - 1;
            if(reset_x)
                x_counter <= 5'd31;
            if(reset_y)
                y_counter <= 5'd31;
            if(plot)
                address <= address + 1;
            if (reset_x && reset_y)
                address <= 0;
        end
    end

    // position calculator
    always@(*) begin
        x_pix <= x + (31 - x_counter);
        y_pix <= y + (31 - y_counter);
    end
endmodule
