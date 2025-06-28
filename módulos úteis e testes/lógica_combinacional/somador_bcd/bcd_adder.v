module bcd_adder(
    output wire [3:0] Sum, Sum2,
    output wire Cout, Cout2,
    input wire [3:0] A, B
);

    wire w1;
    wire [3:0] w2;

    assign {Cout, Sum} = A + B;

    assign w1 = Cout | (Sum[3] & Sum[2]) | (Sum[3] & Sum[1]);

    assign w2 = (w1) ? 4'b0110 : 4'b0000;

    assign {Cout2, Sum2} = Sum + w2;

endmodule