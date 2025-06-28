module blocking (output reg S,
                 input wire A,B,C);
                 
	reg n1;
	
	always @(A,B,C)
	begin
		n1 = A ^ B;
		S = n1 ^ C;
	end 
	
endmodule