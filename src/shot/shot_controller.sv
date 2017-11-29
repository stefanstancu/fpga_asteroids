//`define MAX_SHOTS 10
/*
module test_shots #(parameter MAX_SHOTS = 10,
            ENTITY_SIZE = 34)
				(input clk, output [MAX_SHOTS-1:0][ENTITY_SIZE-1:0] w_data);


	shot_controller u1(
      .shoot(shoot),
      .direction(6'b00001),
      .reset_n(reset_n),
      .clk(clk),
      .xtip(10'b0000010000),
      .ytip(10'b0000011111),
		.entity_byte(3'b000),


      .delete_shot(1'b0),
      .shot_address(shot_address),
		.shots_data(w_data)
    );
endmodule
*/
module shot_controller
#(parameter MAX_SHOTS = 10,
            ENTITY_SIZE = 34,
            SHOT_RATE = 40000000)
(
  input clk,
  input move_clk,
  input shoot,
  input reset_n,
  input delete_shot,
  input [9:0] shot_address,
  input [2:0] entity_byte,
  input [5:0] direction,
  input [9:0] xtip,
  input [9:0] ytip,

  output reg [MAX_SHOTS-1:0][ENTITY_SIZE-1:0] shots_data
);

    wire can_shoot;

    shoot_enabler enabler(
        .clk(clk),
        .reset_n(reset_n),
        .shoot(shoot),
        .can_shoot(can_shoot)
    );

	always@(posedge clk) begin

		if (reset_n) begin
			shots_data <= (MAX_SHOTS)*34'd0;
		end

		if (delete_shot) begin
			shots_data[shot_address]<=0;
		end

		if (can_shoot) begin
			integer i;
			for(i=0; i<MAX_SHOTS;i=i+1) begin

				if(shots_data[i][33]==1'b0) begin
					shots_data[i]<={1'b1, entity_byte [2:0], direction [4:3], direction [1:0], ytip [9:0], xtip [9:0], direction [5:0]};
					break;
				end
			end
		end

		for(integer i=0; i<MAX_SHOTS;i=i+1) begin

			if (shots_data[i][33]==1'b1) begin

				//if both x and y are 0
				if(shots_data[i][27:26]==2'b0 && shots_data[i][29:28]==2'b0) begin
					shots_data[i][27:26]<=shots_data[i][1:0];
					shots_data[i][29:28]<=shots_data[i][4:3];
				end

				//if x_que is not 0
				if(shots_data[i][27:26]!=2'b0) begin

					if(shots_data[i][2])
						shots_data[i][15:6]<=shots_data[i][15:6]-1;

					else
						shots_data[i][15:6]<=shots_data[i][15:6]+1;

					shots_data[i][27:26]<=shots_data[i][27:26]-1;
					end

				//if y is not 0
				else if (shots_data[i][29:28]!=2'b0)begin

					if(shots_data[i][5])
						shots_data[i][25:16]<=shots_data[i][25:16]-1;

					else
						shots_data[i][25:16]<=shots_data[i][25:16]+1;

					shots_data[i][29:28]<=shots_data[i][29:28]-1;
			    end
			end
		end
	end

endmodule

module shoot_enabler(
    input clk,
    input reset_n,
    input shoot,

    output can_shoot
);

    localparam S_WAIT_FOR_SHOOT         = 0,
               S_CAN_SHOOT              = 1,
               S_WAIT_FOR_SHOOT_RELEASE = 2;

    reg [2:0] current_state, next_state;

    always @ (*) begin: state_table
        case (current_state)
            S_WAIT_FOR_SHOOT: begin
                next_state <= shoot? S_CAN_SHOOT : S_WAIT_FOR_SHOOT;
            end
            S_CAN_SHOOT: begin
                next_state <= shoot ? S_WAIT_FOR_SHOOT_RELEASE : S_WAIT_FOR_SHOOT;
            end
            S_WAIT_FOR_SHOOT_RELEASE: begin
                next_state <= shoot ? S_WAIT_FOR_SHOOT_RELEASE : S_WAIT_FOR_SHOOT;
            end
        endcase
    end // state_table

    always @ (*) begin: data_out
        case(current_state)
            S_WAIT_FOR_SHOOT: can_shoot <= 1'b0;
            S_CAN_SHOOT: can_shoot <= 1'b1;
            S_WAIT_FOR_SHOOT_RELEASE: can_shoot <= 1'b0;
        endcase
    end // data

    always @ (posedge clk) begin
        if (reset_n)
            current_state <= S_WAIT_FOR_SHOOT;
        else
            current_state <= next_state;
    end
endmodule
