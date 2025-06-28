`timescale 1ns/1ps

module bcd_adder_tb;

    // Entradas
    reg [3:0] A, B;

    // Saídas
    wire [3:0] Sum, Sum2;
    wire Cout, Cout2;

    // Instanciação do módulo sob teste (DUT)
    bcd_adder DUT (
        .Sum(Sum),
        .Sum2(Sum2),
        .Cout(Cout),
        .Cout2(Cout2),
        .A(A),
        .B(B)
    );

    initial begin
        // Exibição no terminal
        $display("Time | A  + B  | BinSum Cout | Corrigido Sum2 Cout2");
        $display("----------------------------------------------------");
        $monitor("%4d | %d + %d | %b%b%b%b %b | --> %b%b%b%b %b",
            $time, A, B,
            Sum[3], Sum[2], Sum[1], Sum[0], Cout,
            Sum2[3], Sum2[2], Sum2[1], Sum2[0], Cout2
        );

        // Testes
        A = 4'd2; B = 4'd3; #10;   // 2 + 3 = 5 (válido)
        A = 4'd4; B = 4'd5; #10;   // 4 + 5 = 9 (válido)
        A = 4'd6; B = 4'd7; #10;   // 6 + 7 = 13 (corrige para 3 + carry)
        A = 4'd9; B = 4'd9; #10;   // 9 + 9 = 18 (corrige para 8 + carry)
        A = 4'd5; B = 4'd8; #10;   // 5 + 8 = 13 (corrige)
        A = 4'd0; B = 4'd0; #10;   // 0 + 0 = 0 (válido)
        A = 4'd9; B = 4'd1; #10;   // 9 + 1 = 10 (corrige)

        $finish;
    end

endmodule
