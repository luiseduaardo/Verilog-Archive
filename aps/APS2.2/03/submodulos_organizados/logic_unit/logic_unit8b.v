`include "and8b.v"
`include "or8b.v"
`include "xor8b.v"
`include "not8b.v"
`include "mux4t1_8b.v"

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
