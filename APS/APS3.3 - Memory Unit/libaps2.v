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
