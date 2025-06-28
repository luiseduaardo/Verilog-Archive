module half_adder1b(
    input wire A, B,
    output wire C0, S,
);

    assign S = A ^ B;
    assign C0 = A & B;

endmodule