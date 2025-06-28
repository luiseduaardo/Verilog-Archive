`timescale 1ns/1ps

module reg_tb();

	reg A_TB, CLK_TB;
	wire F_TB;

	blocking DUT(.F(S_TB), .A(A_TB), .Clock(CLK_TB));

	initial
		begin
			$dumpfile("reg_tb.vcd");
			$dumpvars(0,reg_tb);
		
				A_TB=0; CLK_TB=0;
			#1 	A_TB=0; CLK_TB=1;
			#1 	A_TB=1; CLK_TB=0;
			#1 	A_TB=1; CLK_TB=1;
			#1 	A_TB=0; CLK_TB=0;
			#1 	A_TB=0; CLK_TB=1;
			#1 	A_TB=0; CLK_TB=0;
			#1 	A_TB=0; CLK_TB=1;
		end
			
endmodule
