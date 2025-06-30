`include "mux2t1_1b.v"

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
