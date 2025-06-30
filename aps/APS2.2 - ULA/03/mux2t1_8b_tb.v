`timescale 1ns/1ns

module mux2t1_8b_tb;

    reg [7:0] A_TB, B_TB;
    reg Sel_TB;
    wire [7:0] F_TB;

    mux2t1_8b DUT (
        .F(F_TB),
        .A(A_TB),
        .B(B_TB),
        .Sel(Sel_TB)
    );

    initial begin
        $dumpfile("mux2t1_8b.vcd");
        $dumpvars(0, mux2t1_8b_tb);

        $display("-----------------------------------------------------------");
        $display("   A      |    B     | Sel |     F");
        $display("-----------------------------------------------------------");

        // Teste Sel = 0 -> Saída deve ser A
        A_TB = 8'b10101010;
        B_TB = 8'b01010101;
        Sel_TB = 0;
        #10;
        $display(" %b | %b |  %b  | %b", A_TB, B_TB, Sel_TB, F_TB);

        // Teste Sel = 1 -> Saída deve ser B
        Sel_TB = 1;
        #10;
        $display(" %b | %b |  %b  | %b", A_TB, B_TB, Sel_TB, F_TB);

        // Outro teste com dados diferentes
        A_TB = 8'b11110000;
        B_TB = 8'b00001111;
        Sel_TB = 0;
        #10;
        $display(" %b | %b |  %b  | %b", A_TB, B_TB, Sel_TB, F_TB);

        Sel_TB = 1;
        #10;
        $display(" %b | %b |  %b  | %b", A_TB, B_TB, Sel_TB, F_TB);

        $finish;
    end

endmodule
