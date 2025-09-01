// -----------------------------------
// MÓDULOS BÁSICOS - 1 BIT
// -----------------------------------

module not_gate(
    output Y, 
    input A
);

    nand(Y, A, A);
    
endmodule

module and_gate(
    output Y, 
    input A, B
);

    wire w1;
    
    nand(w1, A, B);
    nand(Y, w1, w1);

endmodule

module or_gate(
    output Y, 
    input A, B
);

    wire w1, w2;
    
    nand(w1, A, A);
    nand(w2, B, B);
    nand(Y, w1, w2);

endmodule

module xor_gate(
    output Y, 
    input A, B
);

    wire w1, w2, w3;

    nand(w1, A, B);
    nand(w2, A, w1);
    nand(w3, B, w1);
    nand(Y, w2, w3);

endmodule

// -----------------------------------
// MÓDULOS BÁSICOS - 8 BITS
// -----------------------------------

module not8b(
    output wire [7:0] F,
    input wire [7:0] A
);

    not_gate ng0(F[0], A[0]);
    not_gate ng1(F[1], A[1]);
    not_gate ng2(F[2], A[2]);
    not_gate ng3(F[3], A[3]);
    not_gate ng4(F[4], A[4]);
    not_gate ng5(F[5], A[5]);
    not_gate ng6(F[6], A[6]);
    not_gate ng7(F[7], A[7]);

endmodule

module and8b(
    output wire [7:0] F,
    input wire [7:0] A,
    input wire [7:0] B
);

    and_gate g0(F[0], A[0], B[0]);
    and_gate g1(F[1], A[1], B[1]);
    and_gate g2(F[2], A[2], B[2]);
    and_gate g3(F[3], A[3], B[3]);
    and_gate g4(F[4], A[4], B[4]);
    and_gate g5(F[5], A[5], B[5]);
    and_gate g6(F[6], A[6], B[6]);
    and_gate g7(F[7], A[7], B[7]);

endmodule

module or8b(
    output wire [7:0] F,
    input wire [7:0] A,
    input wire [7:0] B
);

    or_gate g0(F[0], A[0], B[0]);
    or_gate g1(F[1], A[1], B[1]);
    or_gate g2(F[2], A[2], B[2]);
    or_gate g3(F[3], A[3], B[3]);
    or_gate g4(F[4], A[4], B[4]);
    or_gate g5(F[5], A[5], B[5]);
    or_gate g6(F[6], A[6], B[6]);
    or_gate g7(F[7], A[7], B[7]);

endmodule

module xor8b(
    output wire [7:0] F,
    input wire [7:0] A,
    input wire [7:0] B
);

    xor_gate g0(F[0], A[0], B[0]);
    xor_gate g1(F[1], A[1], B[1]);
    xor_gate g2(F[2], A[2], B[2]);
    xor_gate g3(F[3], A[3], B[3]);
    xor_gate g4(F[4], A[4], B[4]);
    xor_gate g5(F[5], A[5], B[5]);
    xor_gate g6(F[6], A[6], B[6]);
    xor_gate g7(F[7], A[7], B[7]);

endmodule

// -----------------------------------
// MÓDULOS INTERMEDIÁRIOS
// -----------------------------------

module full_adder1b(
    output S, Cout,
    input A, B, Cin
);

    wire xor_temp, and1_temp, and2_temp, and3_temp, or1_temp;

    // Soma = A XOR B XOR Cin
    xor_gate xor1 (xor_temp, A, B);
    xor_gate xor2 (S, xor_temp, Cin);

    // Carry-out = (B AND Cin) OR (A AND B) OR (A AND Cin)
    and_gate and1 (and1_temp, B, Cin);
    and_gate and2 (and2_temp, A, B);
    and_gate and3 (and3_temp, A, Cin);
    or_gate or1 (or1_temp, and1_temp, and2_temp);
    or_gate or2 (Cout, or1_temp, and3_temp);

endmodule

module full_adder8b(
    output wire [7:0] S,
    output wire Cout,
    input wire [7:0] A,
    input wire [7:0] B,
    input wire Cin
);

    wire [6:0] carry; // Carries intermediários

    full_adder1b FA0(S[0], carry[0], A[0], B[0], Cin);
    full_adder1b FA1(S[1], carry[1], A[1], B[1], carry[0]);
    full_adder1b FA2(S[2], carry[2], A[2], B[2], carry[1]);
    full_adder1b FA3(S[3], carry[3], A[3], B[3], carry[2]);
    full_adder1b FA4(S[4], carry[4], A[4], B[4], carry[3]);
    full_adder1b FA5(S[5], carry[5], A[5], B[5], carry[4]);
    full_adder1b FA6(S[6], carry[6], A[6], B[6], carry[5]);
    full_adder1b FA7(S[7], Cout,     A[7], B[7], carry[6]);

endmodule

module incrementer8b(
    output [7:0] S,
    output Cout,
    input  [7:0] A
);

    full_adder8b FA8B (
        .A(A),
        .B(8'b00000000),  // B = 0
        .Cin(1'b1),       // Incrementar com carry in = 1
        .S(S),
        .Cout(Cout)
    );

endmodule

module subtractor8b(
    output wire [7:0] S,
    output wire Borrow,
    input wire [7:0] A,
    input wire [7:0] B
);

    wire [7:0] notB;
    wire cout;

    // Faz o NOT bit a bit usando o módulo not8b (Bitwise NOT de B)
    not8b inverter(.F(notB), .A(B));

    full_adder8b FA (
        .S(S),
        .Cout(cout),
        .A(A),
        .B(notB),
        .Cin(1'b1) // Soma 1 para finalizar o complemento de 2 do B
    );

    // Borrow = ~cout (se cout=0, teve borrow)
    assign Borrow = ~cout;

endmodule

module decrementer8b(
    output wire [7:0] D,
    output wire Borrow,
    input wire [7:0] A
);

    wire [7:0] one_not;
    wire cout;

    wire [7:0] one = 8'b00000001;

    not8b inverter(.F(one_not), .A(one));

    full_adder8b FA (
        .S(D),
        .Cout(cout),
        .A(A),
        .B(one_not),
        .Cin(1'b1)
    );

    assign Borrow = ~cout;

endmodule

// -----------------------------------
// MULTIPLEXADORES
// -----------------------------------

module mux2t1_1b(
    output wire F,
    input wire A, B,
    input wire Sel
);

    wire not_sel, and0, and1;

    not_gate n0(not_sel, Sel);
    and_gate a0(and0, A, not_sel);
    and_gate a1(and1, B, Sel);
    or_gate  o1(F, and0, and1);

endmodule

module mux2t1_8b(
    output wire [7:0] F,
    input wire [7:0] A,
    input wire [7:0] B,
    input wire Sel
);

    mux2t1_1b m0(F[0], A[0], B[0], Sel);
    mux2t1_1b m1(F[1], A[1], B[1], Sel);
    mux2t1_1b m2(F[2], A[2], B[2], Sel);
    mux2t1_1b m3(F[3], A[3], B[3], Sel);
    mux2t1_1b m4(F[4], A[4], B[4], Sel);
    mux2t1_1b m5(F[5], A[5], B[5], Sel);
    mux2t1_1b m6(F[6], A[6], B[6], Sel);
    mux2t1_1b m7(F[7], A[7], B[7], Sel);

endmodule

module mux4t1_1b(
    output wire F,
    input wire A, B, C, D,
    input wire [1:0] Sel
);

    wire w0, w1;

    mux2t1_1b mux0(w0, A, B, Sel[0]);
    mux2t1_1b mux1(w1, C, D, Sel[0]);
    mux2t1_1b mux2(F, w0, w1, Sel[1]);

endmodule

module mux4t1_8b(
    output wire [7:0] F,
    input wire [7:0] A, B, C, D,
    input wire [1:0] Sel
);

    mux4t1_1b m0(F[0], A[0], B[0], C[0], D[0], Sel);
    mux4t1_1b m1(F[1], A[1], B[1], C[1], D[1], Sel);
    mux4t1_1b m2(F[2], A[2], B[2], C[2], D[2], Sel);
    mux4t1_1b m3(F[3], A[3], B[3], C[3], D[3], Sel);
    mux4t1_1b m4(F[4], A[4], B[4], C[4], D[4], Sel);
    mux4t1_1b m5(F[5], A[5], B[5], C[5], D[5], Sel);
    mux4t1_1b m6(F[6], A[6], B[6], C[6], D[6], Sel);
    mux4t1_1b m7(F[7], A[7], B[7], C[7], D[7], Sel);

endmodule

// -----------------------------------
// LOGIC UNIT
// -----------------------------------

module logic_unit(
    output wire [7:0] F,
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [1:0] Sel
);

    wire [7:0] and_out, or_out, xor_out, not_out;

    and8b u_and (and_out, A, B);
    or8b  u_or  (or_out, A, B);
    xor8b u_xor (xor_out, A, B);
    not8b u_not (not_out, A);

    mux4t1_8b mux_logic (
        .F(F),
        .A(and_out),    // Sel = 00 → AND
        .B(or_out),     // Sel = 01 → OR
        .C(xor_out),    // Sel = 10 → XOR
        .D(not_out),    // Sel = 11 → NOT A
        .Sel(Sel)
    );

endmodule

// -----------------------------------
// ARITHMETIC UNIT
// -----------------------------------

// Calcula zero flag (Z)
module zero_flag_8b(
    input wire [7:0] in,
    output wire Z
);
    // Z = 1 se todos bits forem 0
    // operação NOR (todos os bits zero -> bitwise or = 0 -> not or = 1 -> Z = 1)
    wire [6:0] nor_chain;
    nor nor0(nor_chain[0], in[0], in[1]);
    nor nor1(nor_chain[1], in[2], in[3]);
    nor nor2(nor_chain[2], in[4], in[5]);
    nor nor3(nor_chain[3], in[6], in[7]);

    nor nor4(nor_chain[4], nor_chain[0], nor_chain[1]);
    nor nor5(nor_chain[5], nor_chain[2], nor_chain[3]);

    nor nor6(Z, nor_chain[4], nor_chain[5]);
endmodule

module arithmetic_unit(
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [1:0] ALU_Sel,  // seletor das operações
    output wire [7:0] Result,
    output wire [3:0] NZVC
);

    wire [7:0] add_res, inc_res, sub_res, dec_res;
    wire cout_add, cout_inc, borrow_sub, borrow_dec;

    // Instanciando os módulos aritméticos
    full_adder8b ADD(.A(A), .B(B), .Cin(1'b0), .S(add_res), .Cout(cout_add));
    incrementer8b INC(.A(A), .S(inc_res));
    subtractor8b SUB(.A(A), .B(B), .S(sub_res), .Borrow(borrow_sub));
    decrementer8b DEC(.A(A), .D(dec_res));

    // Mux 4x1 para selecionar o resultado
    mux4t1_8b MUX(.A(add_res), .B(inc_res), .C(sub_res), .D(dec_res), .Sel(ALU_Sel), .F(Result));

    // Flags
    wire Z;
    zero_flag_8b ZERO(.in(Result), .Z(Z));
    wire N = Result[7];  // MSB como negativo

    // V flag: overflow do somador (somente usado na operação add)
    wire V = cout_add ^ add_res[7] ^ A[7] ^ B[7];

    // C flag: carry / borrow
    wire C;
    assign C = (ALU_Sel == 2'b00) ? cout_add :
               (ALU_Sel == 2'b01) ? 1'b0 :  // incrementador não terá carry
               (ALU_Sel == 2'b10) ? ~borrow_sub :
               (ALU_Sel == 2'b11) ? 1'b0 :  // decrementador não terá borrow
               1'b0;

    assign NZVC = {N, Z, V, C};

endmodule

// -----------------------------------
// LÓGICA SEQUENCIAL
// -----------------------------------

module dlatch (output reg Q,Qn, 
               input wire C,D);
  
  always @ (C or D)
  	begin
  		if (C==1'b1)
  			begin
  				Q <= D;
  				Qn <= ~D;
  	    	end
  	end
  
endmodule

module dflipflop (output reg Q,Qn, 
                  input wire Clock, Reset, Preset, D);
  
  always @ (posedge Clock or negedge Reset or negedge Preset)
  	begin
	  	if (!Reset)
  			begin
  				Q <= 1'b0;
  				Qn <= 1'b1;
  			end
  		else if (!Preset)
  			begin
  				Q <= 1'b1;
  				Qn <= 1'b0;
  			end
  		else
  			begin
  				Q <= D;
  				Qn <= ~D;
  			end
  	end
endmodule