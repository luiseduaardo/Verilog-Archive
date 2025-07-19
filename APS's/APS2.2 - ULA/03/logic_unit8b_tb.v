`timescale 1ns/1ns

module logic_unit_tb;

    reg [7:0] A_TB, B_TB;
    reg [1:0] Sel_TB;
    wire [7:0] F_TB;

    logic_unit DUT (
        .F(F_TB),
        .A(A_TB),
        .B(B_TB),
        .Sel(Sel_TB)
    );

    initial begin
        $dumpfile("logic_unit.vcd");
        $dumpvars(0, logic_unit_tb);

        $display("---------------------------------------------------------------");
        $display("   A      | B         | Sel |     F    | Operation");
        $display("---------------------------------------------------------------");

        // Teste AND (Sel = 00)
        A_TB = 8'b11001100; B_TB = 8'b10101010; Sel_TB = 2'b00; #10;
        $display(" %b | %b  | %b  | %b | AND", A_TB, B_TB, Sel_TB, F_TB);

        // Teste OR (Sel = 01)
        Sel_TB = 2'b01; #10;
        $display(" %b | %b  | %b  | %b | OR ", A_TB, B_TB, Sel_TB, F_TB);

        // Teste XOR (Sel = 10)
        Sel_TB = 2'b10; #10;
        $display(" %b | %b  | %b  | %b | XOR", A_TB, B_TB, Sel_TB, F_TB);

        // Teste NOT A (Sel = 11) -> B não é considerado
        Sel_TB = 2'b11; #10;
        $display(" %b | %b  | %b  | %b | NOT", A_TB, B_TB, Sel_TB, F_TB);

        // Outro conjunto de entradas
        A_TB = 8'b00001111; B_TB = 8'b11110000;

        // AND
        Sel_TB = 2'b00; #10;
        $display(" %b | %b  | %b  | %b | AND", A_TB, B_TB, Sel_TB, F_TB);

        // OR
        Sel_TB = 2'b01; #10;
        $display(" %b | %b  | %b  | %b | OR ", A_TB, B_TB, Sel_TB, F_TB);

        // XOR
        Sel_TB = 2'b10; #10;
        $display(" %b | %b  | %b  | %b | XOR", A_TB, B_TB, Sel_TB, F_TB);

        // NOT
        Sel_TB = 2'b11; #10;
        $display(" %b | %b  | %b  | %b | NOT", A_TB, B_TB, Sel_TB, F_TB);

        $finish;
    end

endmodule
