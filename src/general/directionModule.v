module test_direction(moveClock, directionIn, right, left);

	input [5:0] directionIn;
	input moveClock;
	input left, right;
	
	wire [5:0] directionOut;
	
	reg [5:0]dir;

	always@(posedge moveClock) begin
		dir <= directionOut;
	end
	
	directionModule u1(
			.directionIn(dir),
			.moveClock(moveClock),
			.right(right),
			.left(left),
			.directionOut(directionOut)
			); 
			
endmodule

module directionModule(directionIn, moveClock, right, left, directionOut);
	
	input[5:0] directionIn;
	input moveClock;
	input left, right;
	
	output reg [5:0] directionOut;

	always@(posedge moveClock)
	begin 
		if (right && !left) begin
		case(directionIn)
			//1st quadrant
			6'b000001: directionOut <= 6'b001011;
			6'b001011: directionOut <= 6'b001010;
			6'b001010: directionOut <= 6'b010011;
			6'b010011: directionOut <= 6'b001001;
			6'b001001: directionOut <= 6'b010001;
			6'b010001: directionOut <= 6'b011010;
			6'b011010: directionOut <= 6'b011001;
			6'b011001: directionOut <= 6'b001000;
			
			//second quadrant
			6'b101000: directionOut <= 6'b111001;
			6'b111001: directionOut <= 6'b111010;
			6'b111010: directionOut <= 6'b110001;
			6'b110001: directionOut <= 6'b101001;
			6'b101001: directionOut <= 6'b110011;
			6'b110011: directionOut <= 6'b101010;
			6'b101010: directionOut <= 6'b101011;
			6'b101011: directionOut <= 6'b000001;
			
			//3rd quadrant
			6'b000101: directionOut <= 6'b101111;
			6'b101111: directionOut <= 6'b101110;
			6'b101110: directionOut <= 6'b110111;
			6'b110111: directionOut <= 6'b101101;
			6'b101101: directionOut <= 6'b110101;
			6'b110101: directionOut <= 6'b111110;
			6'b111110: directionOut <= 6'b111101;
			6'b111101: directionOut <= 6'b101000;
			
			//4th quadrant
			6'b001000: directionOut <= 6'b011101;
			6'b011101: directionOut <= 6'b011110;
			6'b011110: directionOut <= 6'b010101;
			6'b010101: directionOut <= 6'b001101;
			6'b001101: directionOut <= 6'b010111;
			6'b010111: directionOut <= 6'b001110;
			6'b001110: directionOut <= 6'b001111;
			6'b001111: directionOut <= 6'b000101;
			default: directionOut <= 6'b000001;
		endcase
		
		end
		
		else if(left && !right) begin
			case (directionIn)
			6'b001011: directionOut <= 6'b000001;
			6'b001010: directionOut <= 6'b001011;
			6'b010011: directionOut <= 6'b001010;
			6'b001001: directionOut <= 6'b010011; 
			6'b010001: directionOut <= 6'b001001;
			6'b011010: directionOut <= 6'b010001; 
			6'b011001: directionOut <= 6'b011010;
			6'b001000: directionOut <= 6'b011001; 
			
			6'b111001: directionOut <= 6'b101000;
			6'b111010: directionOut <= 6'b111001;
			6'b110001: directionOut <= 6'b111010;
			6'b101001: directionOut <= 6'b110001; 
			6'b110011: directionOut <= 6'b101001;
			6'b101010: directionOut <= 6'b110011; 
			6'b101011: directionOut <= 6'b101010;
			6'b000001: directionOut <= 6'b101011; 
			
			6'b101111: directionOut <= 6'b000101;
			6'b101110: directionOut <= 6'b101111;
			6'b110111: directionOut <= 6'b101110;
			6'b101101: directionOut <= 6'b110111; 
			6'b110101: directionOut <= 6'b101101;
			6'b111110: directionOut <= 6'b110101; 
			6'b111101: directionOut <= 6'b111110; 
			6'b101000: directionOut <= 6'b111101;
			
			6'b011101: directionOut <= 6'b001000;
			6'b011110: directionOut <= 6'b011101;
			6'b010101: directionOut <= 6'b011110;
			6'b001101: directionOut <= 6'b010101;
			6'b010111: directionOut <= 6'b001101;
			6'b001110: directionOut <= 6'b010111;
			6'b001111: directionOut <= 6'b001110;
			6'b000101: directionOut <= 6'b001111;
			default: directionOut <= 6'b000001;
			endcase
		end
	end
endmodule
