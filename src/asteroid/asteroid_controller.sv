module asteroid_controller
#(parameter ASTEROID_COUNT = 4,
            ENTITY_SIZE = 34)
(
  input clk,
  input shoot,
  input reset_n,
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
    assign spawns[0] = {10'd0, 10'd50, 6'b111000};
    assign spawns[1] = {10'd120,10'd50, 6'b101000};
    assign spawns[2] = {10'd50, 10'd220, 6'b000101};
    assign spawns[3] = {10'd50, 10'd0, 6'b000001};

	always@(posedge clk)
	begin

		if (reset_n) begin
			asteroids_data <= (ASTEROID_COUNT)*34'd0;

			x_pos<=spawns[0][25:16];
			y_pos<=spawns[0][15:6];
			slope<=spawns[0][5:0];
		end

		if (delete_asteroid) begin
			asteroids_data[asteroid_address]<=0;
		end

		else begin
			integer j;
			for(j=0; j<4;j=j+1) begin
			//integer i;
            //for(i=0; i<ASTEROID_COUNT;i=i+1) begin
				  if(asteroids_data[j][33]==1'b0) begin
							x_pos <= spawns[j][25:16];
							y_pos <= spawns[j][15:6];
							slope <= spawns[j][5:0];
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

					end

				//if y is not 0
				else if (asteroids_data[i][29:28]!=2'b0)begin

					if(asteroids_data[i][5])
						asteroids_data[i][25:16]<=asteroids_data[i][25:16]-1;

					else
						asteroids_data[i][25:16]<=asteroids_data[i][25:16]+1;

					asteroids_data[i][29:28]<=asteroids_data[i][29:28]-1;
			    end
		end
	end

endmodule
