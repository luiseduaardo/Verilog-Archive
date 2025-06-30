`timescale 1ns/1ps

module not8b
	(output wire [7:0] F,
	input wire [7:0] A);

	assign F = ~A;
	
endmodule

module or8bitwb
	(output wire F,
	input wire [7:0] A);

	assign F = |A;
	
endmodule

module and8b // and 8b
	(output wire [7:0] F,
	input wire [7:0] A,B);

	assign F = A & B;
	
endmodule

module or8b // or8b
	(output wire [7:0] F,
	input wire [7:0] A,B);

	assign F = A | B;
	
endmodule

module xor8b // xor 8b
	(output wire [7:0] F,
	input wire [7:0] A,B);

	assign F = A ^ B;
	
endmodule

module mux8b 
	(output wire [7:0] F,
	input wire [7:0] A, B,
	input wire Sel);

	assign F = (Sel == 1'b0) ? A :
			   (Sel == 2'b1) ? B :
			   8'bX;
endmodule

module mux8_4to1b // mux 4-1
	(output wire [7:0] F,
	input wire [7:0] A, B, C, D,
	input wire [1:0] Sel);

	assign F = (Sel == 2'b00) ? A :
			   (Sel == 2'b01) ? B :
			   (Sel == 2'b10) ? C :
			   (Sel == 2'b11) ? D :
			   8'bX;
endmodule

module dmux8b // demux 
	(output wire [7:0] F,G,
	 input wire [7:0] A,
	 input wire Sel);

	assign F = (Sel == 1'b0) ? A : 8'h00;
	assign G = (Sel == 1'b1) ? A : 8'h00;
	
endmodule

module dmux8_1to4b // demux 1-4
	(output wire [7:0] W,X,Y,Z,
	 input wire [7:0] A,
	 input wire [1:0] Sel);

	assign W = (Sel == 2'b00) ? A : 8'h00;
	assign X = (Sel == 2'b01) ? A : 8'h00;
	assign Y = (Sel == 2'b10) ? A : 8'h00;
	assign Z = (Sel == 2'b11) ? A : 8'h00;
	
endmodule

module hab // half adder
	(output wire S, C,
	input wire A, B);

	assign C = ((A==1'b1) && (B==1'b1)) ? 1'b1 : 1'b0;
	assign S = ((A==1'b0) && (B==1'b1)) ? 1'b1 :
			   ((A==1'b1) && (B==1'b0)) ? 1'b1 :
			   1'b0;
	
endmodule

module fab // full adder
	(output wire S, Cout,
	 input wire A, B, Cin);

	assign Cout = ((Cin==1'b0) && (A==1'b1) && (B==1'b1)) ? 1'b1 :
				  ((Cin==1'b1) && (A==1'b0) && (B==1'b1)) ? 1'b1 :
				  ((Cin==1'b1) && (A==1'b1) && (B==1'b0)) ? 1'b1 :
				  ((Cin==1'b1) && (A==1'b1) && (B==1'b1)) ? 1'b1 :
				  1'b0;
				  
	assign S = ((Cin==1'b0) && (A==1'b0) && (B==1'b1)) ? 1'b1 :
			   ((Cin==1'b0) && (A==1'b1) && (B==1'b0)) ? 1'b1 :
			   ((Cin==1'b1) && (A==1'b0) && (B==1'b0)) ? 1'b1 :
			   ((Cin==1'b1) && (A==1'b1) && (B==1'b1)) ? 1'b1 :
			   1'b0;
	
endmodule

module adder8b // adder de 8 bits
	(output wire [7:0] S, 
	 output wire Cout,
	input wire [7:0] A, B);

	assign {Cout, S} = A + B;
	
endmodule

