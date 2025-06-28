module full_adder1b(
    input wire A, B, Ci,
    output wire S0, Co
);

    wire w1, w2, w3;

    assign w1 = A & B;
    assign w2 = A & Ci;
    assign w3 = B & Ci;
    assign Co = w1 | w2 | w3;

    assign S0 = A ^ B ^ Ci;

endmodule
