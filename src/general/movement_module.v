module test(
	input [5:0] direction,
	input reset_n,
	input clk,

	output reg [8:0] pos_x, pos_y
	);

	wire move_clk;
	wire delta_x, delta_y, sign_x, sign_y;

	move_rate_divider mv_div(
		.clk(clk),
		.reset_n(reset_n),

		.q(move_clk)
	);

	movementmodule m0(
		.direction(direction),
		.reset_n(reset_n),
		.move_clk(move_clk),
		.clk(clk),

		.delta_x(delta_x),
		.delta_y(delta_y),
		.sign_x(sign_x),
		.sign_y(sign_y)
	);



	always @ (posedge move_clk or posedge reset_n) begin
		if (reset_n) begin
			pos_x <= 9'd0;
			pos_y <= 9'd0;
		end
		else if (delta_x) begin
			if (sign_x)
				pos_x <= pos_x - 1;
			else
				pos_x <= pos_x + 1;
		end
		else if (delta_y) begin
			if (sign_y)
				pos_y <= pos_y - 1;
			else
				pos_y <= pos_y + 1;
		end
	end

endmodule

module movementmodule(
	input [5:0] direction,
	input reset_n,
	input move_clk,
	input clk,

	output delta_x, delta_y, sign_x, sign_y
	);

	wire [1:0] x_que, y_que;
	wire ld_que, dlt_x, dlt_y;
	wire [1:0] state;

	assign delta_x = dlt_x;
	assign delta_y = dlt_y;

    control C0(
 		.clk(clk),
		.move_clk(move_clk),
		.reset_n(reset_n),
		.x_que(x_que),
		.y_que(y_que),

		.ld_que(ld_que),
		.dlt_x(dlt_x),
		.dlt_y(dlt_y),

		// debug
		.state(state)
    );

    datapath D0(
		.clk(clk),
		.move_clk(move_clk),
		.reset_n(reset_n),
		.direction(direction),
	    .load_que(ld_que),
	    .dlt_x(dlt_x),
		.dlt_y(dlt_y),

		.x_que_out(x_que),
		.y_que_out(y_que),
		.sign_x(sign_x),
		.sign_y(sign_y)
    );
 endmodule

 module control(
	input clk,
    input move_clk,
    input reset_n,
	input [1:0] x_que, y_que,

    output reg ld_que,
	output reg dlt_x, dlt_y,
	output [1:0] state
    );

    reg [1:0] current_state, next_state;

	assign state = current_state;

    // The state list
    localparam 	S_WAIT		= 2'd0,
				S_DELTA_X   = 2'd1,
            	S_DELTA_Y  	= 2'd2,
            	S_RESET    	= 2'd3;

    // Next state logic aka our state table
    always@(*)
    begin: state_table
        case (current_state)
			S_WAIT: begin
				if(x_que == 0 && y_que == 0)
					next_state <= S_WAIT;
				else if(x_que != 0)
					next_state <= S_DELTA_X;
				else
					next_state <= S_DELTA_Y;
			end
			S_DELTA_X: begin
				if(x_que != 0)
					next_state <= S_DELTA_X;
				else
					next_state <= S_DELTA_Y;
			end
			S_DELTA_Y: begin
			    if(y_que != 0)
					next_state <= S_DELTA_Y;
				else
					next_state <= S_RESET;
			end
			S_RESET: begin
				next_state <= S_WAIT;
			end
            default: next_state <= S_WAIT;
        endcase
    end // state_table

    // Output logic aka all of our datapath control signals
    always @(*)
        begin: enable_signals
        // By default make all our signals 0
		ld_que = 1'b0;
	  	dlt_x = 1'b0;
		dlt_y = 1'b0;

		case (current_state)
			S_WAIT:begin
				ld_que = 1'b1;
			end
            S_DELTA_X: begin
                dlt_x = 1'b1;
            end
			S_DELTA_Y: begin
				dlt_y = 1'b1;
			end
			S_RESET: begin
				ld_que = 1'b1;
			end
       endcase
    end // enable_signals

    // current_state registers
    always@(posedge clk)
    begin: state_FFs
        if(reset_n)
            current_state <= S_WAIT;
        else
            current_state <= next_state;
    end // state_FFS
endmodule

module datapath(
    input clk,
	input move_clk,
    input reset_n,
    input load_que,
	input [5:0] direction,
    input dlt_x, dlt_y,

	output [1:0] x_que_out, y_que_out,
	output sign_x, sign_y
);

	reg [1:0] x_que, y_que;

	assign x_que_out = x_que;
	assign y_que_out = y_que;
	assign sign_x = direction[5];
	assign sign_y = direction[2];

	// Operations between controller and datapath
    always@(posedge clk) begin
        if(reset_n) begin
            x_que <= 2'd0;
			y_que <= 2'd0;
        end
        else if (load_que) begin
            x_que <= direction[4:3];
            y_que <= direction[1:0];
        end
        else if (move_clk) begin
            if(dlt_x)
                x_que <= x_que - 1;
            if(dlt_y)
                y_que <= y_que - 1;
        end 
    end
endmodule
