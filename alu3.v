module register (D, Clock, Resetn, Q);

	input [2:0] D;
	input Clock, Resetn;
	output reg [2:0] Q;
	
	always @(posedge Clock, negedge Resetn)
		if (Resetn == 0)
			Q <= 3'b000;
		else
			Q <= D;
		
endmodule

module hex7seg (hex, led);

	input [3:0]hex;
	output reg [0:6]led;
	
	always @(hex)
		case(hex)
			4'b0000: led = 7'b1000000; //all of these 7 bit leds are read in reverse
			4'b0001: led = 7'b1111001;
			4'b0010: led = 7'b0100100;
			4'b0011: led = 7'b0110000;
			4'b0100: led = 7'b0011001;
			4'b0101: led = 7'b0010010;
			4'b0110: led = 7'b0000010;
			4'b0111: led = 7'b1111000;
			4'b1000: led = 7'b0000000;
			4'b1001: led = 7'b0011000;
			4'b1010: led = 7'b0001000;
			4'b1011: led = 7'b0000011;
			4'b1100: led = 7'b1000110;
			4'b1101: led = 7'b0100001;
			4'b1110: led = 7'b0000110;
			4'b1111: led = 7'b0001110;
		endcase
		
endmodule

module fulladder (carryin, x, y, sum, carryout);

	input carryin, x, y;
	output sum, carryout;
	
	assign sum = x ^ y ^ carryin;
	assign carryout = (x & y) | (x & carryin) | (y & carryin);
	
endmodule

module adder3 (carryin, carrycheck, x, y, sum, carrytemp);
	
	input carryin, carrycheck;
	input [2:0] x; 
	input [2:0] y;
	output [2:0] sum;
	output carrytemp;
	wire [2:0] w;
	
	fulladder (carryin, x[0], y[0], sum[0], w[0]);
	fulladder (w[0], x[1], y[1], sum[1], w[1]);
	fulladder (w[1], x[2], y[2], sum[2], w[2]);
	
	assign carrytemp = carrycheck | w[2];
	
endmodule

module alu3(Clock, Resetn, hex, led);

	input Clock, Resetn;
	input [2:0] hex;
	output [6:0] led;
	wire [2:0] Q1;
	wire [2:0] Q2;
	wire [2:0] sum;
	wire carrytemp;
	wire carryin;
	reg carryout;
	
	initial carryout = 0;
	
	always @(negedge Clock, negedge Resetn)
		if (Resetn == 0)
			carryout <= 0;
		else
			carryout <= carrytemp;
	
	register (hex, Clock, Resetn, Q1);
	adder3 (carryin, carryout, Q1, Q2, sum, carrytemp);
	register (sum, Clock, Resetn, Q2);
	
	wire [3:0] a;
	assign a[0] = sum[0];
	assign a[1] = sum[1];
	assign a[2] = sum[2];
	assign a[3] = carrytemp;
	hex7seg (a, led);
	
endmodule 