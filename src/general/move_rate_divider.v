module move_rate_divider(
    input clk,
    input reset_n,

    output reg q
    );

    reg [23:0] count;
    localparam  division_rate = 24'd2000000;

    always @ (posedge clk) begin
        if(reset_n) begin
            count <= division_rate;
        end
        if (count > 0)
            count <= count - 1;
        else if (count == 0)
            count <= division_rate;
    end

    always @ ( * ) begin
        if (count == 0)
            q <= 1'b1;
        else
            q <= 1'b0;
    end
endmodule
