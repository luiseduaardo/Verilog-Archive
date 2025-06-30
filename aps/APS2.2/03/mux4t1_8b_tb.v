`timescale 1ns/1ns

module mux4t1_8b_tb;

    reg [7:0] A_TB, B_TB, C_TB, D_TB;
    reg [1:0] Sel_TB;
    wire [7:0] F_TB;

    mux4t1_8b DUT (
        .F(F_TB),
        .A(A_TB),
        .B(B_TB),
        .C(C_TB),
        .D(D_TB),
        .Sel(Sel_TB)
    );

    initial begin
        $dumpfile("mux4t1_8b.vcd");
        $dumpvars(0, mux4t1_8b_tb);

        $display("--------------------------------------------------------------------------------");
        $display("   A      |   B      |   C      |   D      | Sel |     F");
        $display("--------------------------------------------------------------------------------");

        A_TB = 8'b00000001;
        B_TB = 8'b00000010;
        C_TB = 8'b00000100;
        D_TB = 8'b00001000;

        // Teste Sel = 00 -> Saída deve ser A
        Sel_TB = 2'b00; #10;
        $display(" %b | %b | %b | %b | %b  | %b", A_TB, B_TB, C_TB, D_TB, Sel_TB, F_TB);

        // Teste Sel = 01 -> Saída deve ser B
        Sel_TB = 2'b01; #10;
        $display(" %b | %b | %b | %b | %b  | %b", A_TB, B_TB, C_TB, D_TB, Sel_TB, F_TB);

        // Teste Sel = 10 -> Saída deve ser C
        Sel_TB = 2'b10; #10;
        $display(" %b | %b | %b | %b | %b  | %b", A_TB, B_TB, C_TB, D_TB, Sel_TB, F_TB);

        // Teste Sel = 11 -> Saída deve ser D
        Sel_TB = 2'b11; #10;
        $display(" %b | %b | %b | %b | %b  | %b", A_TB, B_TB, C_TB, D_TB, Sel_TB, F_TB);

        $finish;
    end

endmodule
