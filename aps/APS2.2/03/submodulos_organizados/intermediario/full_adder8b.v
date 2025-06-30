`include "full_adder1b.v"

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
