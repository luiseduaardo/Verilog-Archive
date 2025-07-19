`include "xor_gate.v"

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