module collision_controller #(parameter
                              MAX_SHOTS        = 3,
                              ENTITY_SIZE      = 34,
                              MAX_ASTEROIDS    = 3,
                              MAX_SHIPS        = 1)
(
	input clk,
	input reset_n,
	input reg [ENTITY_SIZE-1:0] ship = 34'b1000000000000000000000000000000001,
  input reg [MAX_ASTEROIDS-1:0][ENTITY_SIZE-1:0] asteroids,
  input reg [MAX_SHOTS-1:0][ENTITY_SIZE-1:0] shots,

  output delete_shot,
  output delete_asteroid,
  output [9:0] asteroid_address,
  output [9:0] shot_address
);
  integer i,j;
	always @(posedge clk) begin

    //if ship+asteroid
    for(i=0; i<MAX_ASTEROIDS;i=i+1) begin
      if(asteroids[i][15:6]+10'd22 + 10'd5 > 10'd22
        && asteroids[i][15:6]+5'd5 < ship [15:6] + 10'd5 + 10'd22
        && asteroids[i][25:16]+10'd22 + 10'd5 > 10'd22
        && asteroids[i][25:16]+5'd5 < ship [25:16] + 10'd5 + 10'd22) begin
        /*lose life*/
      end
    end

    //if asteroid+shot
    for(i=0; i<MAX_ASTEROIDS;i=i+1) begin
      for(j=0; j<MAX_SHOTS;j=j+1) begin
      if(asteroids[i][15:6]+10'd2 + 10'd5 > 10'd2
        && asteroids[i][15:6]+5'd5 < ship [15:6] + 10'd5 + 10'd2
        && asteroids[i][25:16]+10'd2 + 10'd5 > 10'd2
        && asteroids[i][25:16]+5'd5 < ship [25:16] + 10'd5 + 10'd2) begin
          delete_shot = 1'b1;
          shot_address = j;
          delete_asteroid = 1'b1;
          asteroid_address = i;
          end
      end
    end

    //shot out of bounds
    for(i=0; i<MAX_SHOTS;i=i+1) begin
        //out of x bounds
        if(shots[i][15:6]<10'd0 || shots[i][15:6]>10'd320) begin
          delete_shot = 1'b1;
          shot_address = i;
        end
        //out of bounds y
        if(shots[i][25:16]<10'd0 || shots[i][25:16]>10'd240) begin
          delete_shot = 1'b1;
          shot_address = i;
        end
    end
	end

endmodule

//0-320 x min and max
//0-240 y min and max

//add 5 to ship

//32x32
22
