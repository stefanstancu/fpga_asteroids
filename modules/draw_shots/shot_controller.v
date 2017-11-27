module shot_controller(
  input clk,
  input move_clk,
  input shoot,
  input reset_n,
  input [5:0] direction,
  input shot_count,
  input entity_bytes,
  input [9:0] xtip,
  input [9:0] ytip,

  //for deleting a shot
  input delete_shot,
  input shot_address,

  //reg output
  output [24:0] reg w_data [shot_count:0]
);

  wire delta_x, delta_y, sign_x, sign_y;

  movementmodule m0(
		.direction(direction),
		.reset_n(reset_n),
		.move_clk(move_clk),
		.clk(CLOCK_50),

		.delta_x(delta_x),
		.delta_y(delta_y),
		.sign_x(sign_x),
		.sign_y(sign_y)
	);

  //incremment existing shots
	always@(posedge clock)
	begin
		if (reset_n)
			for(i=0; i<=shot_count;i=i+1) begin
        w_data[shot_count]<= 25'd0;
      end
		else
      for(i=0; i<shot_count;i=i+1) begin
      if(sign_y)
        w_data[shot_count]<={[24] w_data[shot_count],([23:15]w_data[shot_count]-delta_y),[14:6] w_data[shot_count], [5:0]w_data[shot_count]};
      else if (~sign_y)
        w_data[shot_count]<={[24] w_data[shot_count],([23:15]w_data[shot_count]+delta_y),[14:6] w_data[shot_count], [5:0]w_data[shot_count]};
      if (sign_x)
        w_data[shot_count]<={[24] w_data[shot_count],([23:15]w_data[shot_count],([14:6] w_data[shot_count]-delta_x), [5:0]w_data[shot_count]};
      else if (~sign_x)
        w_data[shot_count]<={[24] w_data[shot_count],[23:15]w_data[shot_count],([14:6] w_data[shot_count]+delta_x), [5:0]w_data[shot_count]};
      end
	end

//create a new shot
  if (shoot) begin
    integer count_increment=0;
    while(w_data[count_increment]==25'd0 && count_increment<=shot_count) begin
      shot_count=shot_count+1;
      end
    if(count_increment==shot_count)
      //override the first shot int the array
      w_data[0] <= {1, xtip , ytip ,direction};
    else
      w_data[count_increment] <= {1, xtip , ytip ,direction};
  end

//delete a shot
if(delete_shot)
  w_data[shot_address]<= 25'd0;
