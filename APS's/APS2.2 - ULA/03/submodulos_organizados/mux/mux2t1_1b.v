`include "not_gate.v"
`include "and_gate.v"
`include "or_gate.v"

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
