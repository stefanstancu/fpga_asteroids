/*
* Contains an instance of draw_sprite and all the ROMs + sprite mux to
* draw the ship.
*/

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
    output [2:0] color,
    output draw_done,
    output [2:0] state
);

    wire [9:0] w_address;
    wire [2:0] w_data [0:23];

    reg [2:0] sprite_data;

    draw_sprite #(.sprite_size(31)) ds(
        .clk(clk),
        .reset_n(reset_n),
        .plot(plot),
        .x_pos(x_pos),
        .y_pos(y_pos),
        .sprite_pixel_data(sprite_data),
        
        .plot_out(writeEn),
        .x_pix(x),
        .y_pix(y),
        .address_out(w_address),
        .color(color),
        .draw_done(draw_done),
        .state_out(state)
    );

    sprite_mem32x32 mem0(
        .clock(clk),
        .address(w_address),
        .q(w_data[0])
    );
    defparam mem0.init_file = "../ship/sprite_mifs/0.mif";

    sprite_mem32x32 mem1(
        .clock(clk),
        .address(w_address),
        .q(w_data[1])
    );
    defparam mem1.init_file = "../ship/sprite_mifs/1.mif";

    sprite_mem32x32 mem2(
        .clock(clk),
        .address(w_address),
        .q(w_data[2])
    );
    defparam mem2.init_file = "../ship/sprite_mifs/2.mif";

    sprite_mem32x32 mem3(
        .clock(clk),
        .address(w_address),
        .q(w_data[3])
    );
    defparam mem3.init_file = "../ship/sprite_mifs/3.mif";

    sprite_mem32x32 mem4(
        .clock(clk),
        .address(w_address),
        .q(w_data[4])
    );
    defparam mem4.init_file = "../ship/sprite_mifs/4.mif";

    sprite_mem32x32 mem5(
        .clock(clk),
        .address(w_address),
        .q(w_data[5])
    );
    defparam mem5.init_file = "../ship/sprite_mifs/5.mif";

    sprite_mem32x32 mem6(
        .clock(clk),
        .address(w_address),
        .q(w_data[6])
    );
    defparam mem6.init_file = "../ship/sprite_mifs/0_90.mif";

    sprite_mem32x32 mem7(
        .clock(clk),
        .address(w_address),
        .q(w_data[7])
    );
    defparam mem7.init_file = "../ship/sprite_mifs/1_90.mif";

    sprite_mem32x32 mem8(
        .clock(clk),
        .address(w_address),
        .q(w_data[8])
    );
    defparam mem8.init_file = "../ship/sprite_mifs/2_90.mif";

    sprite_mem32x32 mem9(
        .clock(clk),
        .address(w_address),
        .q(w_data[9])
    );
    defparam mem9.init_file = "../ship/sprite_mifs/3_90.mif";

    sprite_mem32x32 mem10(
        .clock(clk),
        .address(w_address),
        .q(w_data[10])
    );
    defparam mem10.init_file = "../ship/sprite_mifs/4_90.mif";

    sprite_mem32x32 mem11(
        .clock(clk),
        .address(w_address),
        .q(w_data[11])
    );
    defparam mem11.init_file = "../ship/sprite_mifs/5_90.mif";

    sprite_mem32x32 mem12(
        .clock(clk),
        .address(w_address),
        .q(w_data[12])
    );
    defparam mem12.init_file = "../ship/sprite_mifs/0_180.mif";

    sprite_mem32x32 mem13(
        .clock(clk),
        .address(w_address),
        .q(w_data[13])
    );
    defparam mem13.init_file = "../ship/sprite_mifs/1_180.mif";

    sprite_mem32x32 mem14(
        .clock(clk),
        .address(w_address),
        .q(w_data[14])
    );
    defparam mem14.init_file = "../ship/sprite_mifs/2_180.mif";

    sprite_mem32x32 mem15(
        .clock(clk),
        .address(w_address),
        .q(w_data[15])
    );
    defparam mem15.init_file = "../ship/sprite_mifs/3_180.mif";

    sprite_mem32x32 mem16(
        .clock(clk),
        .address(w_address),
        .q(w_data[16])
    );
    defparam mem16.init_file = "../ship/sprite_mifs/4_180.mif";

    sprite_mem32x32 mem17(
        .clock(clk),
        .address(w_address),
        .q(w_data[17])
    );
    defparam mem17.init_file = "../ship/sprite_mifs/5_180.mif";

    sprite_mem32x32 mem18(
        .clock(clk),
        .address(w_address),
        .q(w_data[18])
    );
    defparam mem18.init_file = "../ship/sprite_mifs/0_270.mif";

    sprite_mem32x32 mem19(
        .clock(clk),
        .address(w_address),
        .q(w_data[19])
    );
    defparam mem19.init_file = "../ship/sprite_mifs/1_270.mif";

    sprite_mem32x32 mem20(
        .clock(clk),
        .address(w_address),
        .q(w_data[20])
    );
    defparam mem20.init_file = "../ship/sprite_mifs/2_270.mif";

    sprite_mem32x32 mem21(
        .clock(clk),
        .address(w_address),
        .q(w_data[21])
    );
    defparam mem21.init_file = "../ship/sprite_mifs/3_270.mif";

    sprite_mem32x32 mem22(
        .clock(clk),
        .address(w_address),
        .q(w_data[22])
    );
    defparam mem22.init_file = "../ship/sprite_mifs/4_270.mif";

    sprite_mem32x32 mem23(
        .clock(clk),
        .address(w_address),
        .q(w_data[23])
    );
    defparam mem23.init_file = "../ship/sprite_mifs/5_270.mif";

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
                    // 23 deg
                    4'b0110: sprite_data <= w_data[2];
                    // 33 deg
                    4'b1011: sprite_data <= w_data[2];
                    // 45 deg
                    4'b0101: sprite_data <= w_data[3];
                    4'b1010: sprite_data <= w_data[3];
                    4'b1111: sprite_data <= w_data[3];
                    // 56 deg
                    4'b1110: sprite_data <= w_data[4];
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
                    // 33 deg
                    4'b1011: sprite_data <= w_data[8];
                    // 45 deg
                    4'b0101: sprite_data <= w_data[9];
                    4'b1010: sprite_data <= w_data[9];
                    4'b1111: sprite_data <= w_data[9];
                    // 56 deg
                    4'b1110: sprite_data <= w_data[8];
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
                    // 33 deg
                    4'b1011: sprite_data <= w_data[20];
                    // 45 deg
                    4'b0101: sprite_data <= w_data[21];
                    4'b1010: sprite_data <= w_data[21];
                    4'b1111: sprite_data <= w_data[21];
                    // 53 deg
                    4'b1110: sprite_data <= w_data[22];
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
                    // 26 deg
                    4'b1011: sprite_data <= w_data[14];
                    // 45 deg
                    4'b0101: sprite_data <= w_data[15];
                    4'b1010: sprite_data <= w_data[15];
                    4'b1111: sprite_data <= w_data[15];
                    // 63 deg
                    4'b1110: sprite_data <= w_data[16];
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

