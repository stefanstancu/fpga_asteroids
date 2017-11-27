/*
*   Contains an instance of draw_sprite and a ROM with a single sprite
*/

module draw_asteroid(
    input clk,
    input [9:0] x_pos,
    input [9:0] y_pos,
    input plot,
    input reset_n,
    input [2:0] sprite_sel,

    output [9:0] x,
    output [9:0] y,
    output writeEn,
    output [2:0] color,
    output draw_done
);

    wire [9:0] w_address;
    wire [2:0] w_data;

    draw_sprite #(.sprite_size(31)) ds(
        .clk(clk),
        .reset_n(reset_n),
        .plot(plot),
        .x_pos(x_pos),
        .y_pos(y_pos),
        .sprite_pixel_data(w_data),

        .plot_out(writeEn),
        .x_pix(x),
        .y_pix(y),
        .address_out(address),
        .color(color),
        .draw_done(draw_done)
    );

    sprite_mem32x32 #(.init_file("../asteroid/sprites/asteroid.mif")) mem0(
        .clock(clk),
        .address(w_address),
        .q(w_data)
    );

endmodule
