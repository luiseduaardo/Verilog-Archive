`include "not8b.v"
`include "full_adder8b.v"

module subtractor8b(
    output wire [7:0] S,
    output wire Borrow,
    input wire [7:0] A,
    input wire [7:0] B
);

    wire [7:0] notB;
    wire cout;

    // Faz o NOT bit a bit usando o módulo not8b (Bitwise NOT de B)
    not8b inverter(.F(notB), .A(B));

    full_adder8b FA (
        .S(S),
        .Cout(cout),
        .A(A),
        .B(notB),
        .Cin(1'b1) // Soma 1 para finalizar o complemento de 2 do B
    );

    // Borrow = ~cout (se cout=0, teve borrow)
    assign Borrow = ~cout;

endmodule
