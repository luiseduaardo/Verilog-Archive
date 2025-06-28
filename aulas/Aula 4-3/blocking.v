module blocking (output reg F,
                 input wire A,
                 input wire Clock);
                 
	reg B;
	
	always @(posedge Clock)
	begin
		B = A;
		F = B;
	end 
	
endmodule