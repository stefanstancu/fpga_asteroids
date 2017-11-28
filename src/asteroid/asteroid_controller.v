module test_asteroids #(parameter SHOT_COUNT = 10, 
            ENTITY_SIZE = 34)

(   input clk,
    output [SHOT_COUNT-1:0][ENTITY_SIZE-1:0] w_data
    );


	asteroids_controller u1(
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

module asteroids_controller
#(parameter SHOT_COUNT = 10,
            ENTITY_SIZE = 34)
(
  input clk,
  input shoot,
  input reset_n,
  input delete_shot,
  input shot_address,
  input [2:0] entity_byte,
  input [5:0] direction,
  input [9:0] xtip,
  input [9:0] ytip,

  output reg [SHOT_COUNT-1:0][ENTITY_SIZE-1:0] shots_data
);

	always@(posedge clk)
	begin

		if (reset_n) begin
			shots_data <= (SHOT_COUNT)*34'd0;
		end

		if (delete_shot) begin
			shots_data[shot_address]<=0;
		end

		if (shoot) begin
			integer i;
			for(i=0; i<SHOT_COUNT;i=i+1) begin

				if(shots_data[i][33]==1'b0)
					shots_data[i]<={1'b1, entity_byte [2:0], direction [4:3], direction [1:0], ytip [9:0], xtip [9:0], direction [5:0]};
					break;
			end

		end

		for(integer i=0; i<SHOT_COUNT;i=i+1) begin

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

endmodule
