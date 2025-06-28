`timescale 1ns/1ps

module xor_tb();

	reg A_TB, B_TB, C_TB;
	wire S_TB;

	blocking DUT(.S(S_TB), .A(A_TB), .B(B_TB), .C(C_TB));

	initial
		begin
			$dumpfile("xor_tb.vcd");
			$dumpvars(0,xor_tb);
		
				A_TB=0; B_TB=0; C_TB=0;
			#1 	A_TB=0; B_TB=0; C_TB=1;
			#1 	A_TB=0; B_TB=1; C_TB=0;
			#1 	A_TB=0; B_TB=1; C_TB=1;
			#1 	A_TB=1; B_TB=0; C_TB=0;
			#1 	A_TB=1; B_TB=0; C_TB=1;
			#1 	A_TB=1; B_TB=1; C_TB=0;
			#1 	A_TB=1; B_TB=1; C_TB=1;
		end
			
endmodule






