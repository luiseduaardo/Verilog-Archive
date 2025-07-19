module adder4bit(
    output wire [3:0] Sum,
    output wire Cout,
    input wire [3:0] A, B
);

    assign {Cout, Sum} = A + B;

endmodule