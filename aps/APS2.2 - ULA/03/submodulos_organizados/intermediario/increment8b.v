`include "full_adder8b.v"

module incrementer8b(
    output [7:0] S,
    output Cout,
    input  [7:0] A
);

    full_adder8b FA8B (
        .A(A),
        .B(8'b00000000),  // B = 0
        .Cin(1'b1),       // Incrementar com carry in = 1
        .S(S),
        .Cout(Cout)
    );

endmodule
