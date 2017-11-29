<<<<<<< HEAD
module test_asteroids #(parameter ASTEROID_COUNT = 4,
            ENTITY_SIZE = 34)

(   input clk,
    output [ASTEROID_COUNT-1:0][ENTITY_SIZE-1:0] w_data
=======
module test_asteroids #(parameter SHOT_COUNT = 10, 
            ENTITY_SIZE = 34)

(   input clk,
    output [SHOT_COUNT-1:0][ENTITY_SIZE-1:0] w_data
>>>>>>> asteroids_controller
    );


	asteroids_controller u1(
<<<<<<< HEAD
      .reset_n(reset_n),
      .clk(clk),
		.entity_byte(3'b000),
      .delete_asteroid(1'b0),
      .asteroid_address(asteroid_address),
		 .asteroids_data(w_data)
=======
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
>>>>>>> asteroids_controller
    );

endmodule

module asteroids_controller
<<<<<<< HEAD
#(parameter ASTEROID_COUNT = 4,
=======
#(parameter SHOT_COUNT = 10,
>>>>>>> asteroids_controller
            ENTITY_SIZE = 34)
(
  input clk,
  input shoot,
  input reset_n,
<<<<<<< HEAD
  input delete_asteroid,
  input asteroid_address,
  input [2:0] entity_byte,

  output reg [ASTEROID_COUNT-1:0][ENTITY_SIZE-1:0] asteroids_data
);
  reg [9:0] x_pos;
  reg [9:0] y_pos;
  reg [5:0] slope;
  reg [3:0][25:0] spawns;


//assign spawns[x],={(10 bits of y direction),(10 bits of x direction),(5 bits of slope)};
   assign spawns[0]={10'd0, 10'd50, 6'b111000};
	assign spawns[1]={10'd120,10'd50, 6'b101000};
	assign spawns[2]={10'd50, 10'd320, 6'b000101};
   assign spawns[3]={10'd50, 10'd0, 6'b000001};
=======
  input delete_shot,
  input shot_address,
  input [2:0] entity_byte,
  input [5:0] direction,
  input [9:0] xtip,
  input [9:0] ytip,

  output reg [SHOT_COUNT-1:0][ENTITY_SIZE-1:0] shots_data
);
>>>>>>> asteroids_controller

	always@(posedge clk)
	begin

		if (reset_n) begin
<<<<<<< HEAD
			asteroids_data <= (ASTEROID_COUNT)*34'd0;

			x_pos<=spawns[0][25:16];
			y_pos<=spawns[0][15:6];
			slope<=spawns[0][5:0];
		end

		if (delete_asteroid) begin
			asteroids_data[asteroid_address]<=0;
		end

		else begina
			integer j;
			for(j=0; j<4;j=j+1) begin
			//integer i;
            //for(i=0; i<ASTEROID_COUNT;i=i+1) begin
				  if(asteroids_data[j][33]==1'b0) begin
							x_pos = spawns[j][25:16];
							y_pos = spawns[j][15:6];
							slope = spawns[j][5:0];
					      asteroids_data[j]<={1'b1, entity_byte [2:0], slope [4:3], slope[1:0], y_pos, x_pos, slope};
							break;
              end

             // else if (asteroids_data[i][33]!=1'b0 && i==(ASTEROID_COUNT-1))
                  //asteroids_data[0]<={1'b1, entity_byte [2:0], slope [4:3], slope[1:0], y_pos [9:0], x_pos [9:0], slope [5:0]};
				 // end
			end
		end

		for(integer i=0; i<ASTEROID_COUNT;i=i+1) begin
				//if both x and y are 0
				if(asteroids_data[i][27:26]==2'b0 && asteroids_data[i][29:28]==2'b0) begin
					asteroids_data[i][27:26]<=asteroids_data[i][1:0];
					asteroids_data[i][29:28]<=asteroids_data[i][4:3];
				end

				//if x_que is not 0
				if(asteroids_data[i][27:26]!=2'b0) begin

					if(asteroids_data[i][2])
						asteroids_data[i][15:6]<=asteroids_data[i][15:6]-1;

					else
						asteroids_data[i][15:6]<=asteroids_data[i][15:6]+1;

					asteroids_data[i][27:26]<=asteroids_data[i][27:26]-1;
=======
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
>>>>>>> asteroids_controller

					end

				//if y is not 0
<<<<<<< HEAD
				else if (asteroids_data[i][29:28]!=2'b0)begin

					if(asteroids_data[i][5])
						asteroids_data[i][25:16]<=asteroids_data[i][25:16]-1;

					else
						asteroids_data[i][25:16]<=asteroids_data[i][25:16]+1;

					asteroids_data[i][29:28]<=asteroids_data[i][29:28]-1;
=======
				else if (shots_data[i][29:28]!=2'b0)begin

					if(shots_data[i][5])
						shots_data[i][25:16]<=shots_data[i][25:16]-1;

					else
						shots_data[i][25:16]<=shots_data[i][25:16]+1;

					shots_data[i][29:28]<=shots_data[i][29:28]-1;
>>>>>>> asteroids_controller
			    end
		end
	end

endmodule
