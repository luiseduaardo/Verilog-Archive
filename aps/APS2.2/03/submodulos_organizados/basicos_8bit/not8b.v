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
