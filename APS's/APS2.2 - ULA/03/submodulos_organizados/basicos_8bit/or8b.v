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