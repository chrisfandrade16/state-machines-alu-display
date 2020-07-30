module moore (Clock, sin, sout);
	input Clock, sin;
	output sout;
	reg [1:0]bits, tempstate;
	parameter A = 2'b00, B = 2'b01, C = 2'b10;
	
	always @(sin, bits)
	begin
		case(bits)
			A: if (sin == 0) tempstate = A;
				else tempstate = B;
			B: if (sin == 0) tempstate = A;
				else tempstate = C;
			C: if (sin == 0) tempstate = A;
				else tempstate = C;
			default tempstate = 2'bxx;
		endcase
	end
	
	always @(posedge Clock)
	begin
		bits <= tempstate;
	end
	
	assign sout = (bits == B);
endmodule 