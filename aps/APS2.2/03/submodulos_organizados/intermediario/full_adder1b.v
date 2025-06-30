`include "xor_gate.v"
`include "or_gate.v"
`include "and_gate.v"
`include "not_gate.v"

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