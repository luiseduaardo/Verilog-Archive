`include "full_adder8b.v"
`include "not8b.v"

module decrementer8b(
    output wire [7:0] D,
    output wire Borrow,
    input wire [7:0] A
);

    wire [7:0] one_not;
    wire cout;

    wire [7:0] one = 8'b00000001;

    not8b inverter(.F(one_not), .A(one));

    full_adder8b FA (
        .S(D),
        .Cout(cout),
        .A(A),
        .B(one_not),
        .Cin(1'b1)
    );

    assign Borrow = ~cout;

endmodule
