module full_adder1b_comp(
    output wire [1:0] S,
    output wire Cout,
    input wire [1:0] A, B
);

    assign {Cout, S} = A + B;

endmodule