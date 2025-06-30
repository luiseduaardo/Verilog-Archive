`timescale 1ns/1ns

module arithmetic_unit_tb;

    reg [7:0] A_TB, B_TB;
    reg [1:0] Sel_TB;
    wire [7:0] Result_TB;
    wire [3:0] NZVC_TB;

    // Instanciando o DUT (Device Under Test)
    arithmetic_unit DUT (
        .A(A_TB),
        .B(B_TB),
        .ALU_Sel(Sel_TB),
        .Result(Result_TB),
        .NZVC(NZVC_TB)
    );

    initial begin
        $dumpfile("arithmetic_unit.vcd");
        $dumpvars(0, arithmetic_unit_tb);

        $display("-------------------------------------------------------------------------------");
        $display("     A    |     B     Sel |  Result  | NZVC | Operation");
        $display("-------------------------------------------------------------------------------");

        // Caso 1
        A_TB = 8'b00001111; B_TB = 8'b00000001;

        // Full Adder
        Sel_TB = 2'b00; #10;
        $display(" %b | %b | %b | %b | %b | Full Adder (A+B)", A_TB, B_TB, Sel_TB, Result_TB, NZVC_TB);

        // Incrementador
        Sel_TB = 2'b01; #10;
        $display(" %b | %b | %b | %b | %b | Incrementador (A+1)", A_TB, B_TB, Sel_TB, Result_TB, NZVC_TB);

        // Subtrator
        Sel_TB = 2'b10; #10;
        $display(" %b | %b | %b | %b | %b | Subtrator (A-B)", A_TB, B_TB, Sel_TB, Result_TB, NZVC_TB);

        // Decrementador
        Sel_TB = 2'b11; #10;
        $display(" %b | %b | %b | %b | %b | Decrementador (A-1)", A_TB, B_TB, Sel_TB, Result_TB, NZVC_TB);

        // Caso 2 - Valores maiores
        A_TB = 8'b11111111; B_TB = 8'b00000001;

        Sel_TB = 2'b00; #10;
        $display(" %b | %b | %b | %b | %b | Full Adder (A+B)", A_TB, B_TB, Sel_TB, Result_TB, NZVC_TB);

        Sel_TB = 2'b01; #10;
        $display(" %b | %b | %b | %b | %b | Incrementador (A+1)", A_TB, B_TB, Sel_TB, Result_TB, NZVC_TB);

        Sel_TB = 2'b10; #10;
        $display(" %b | %b | %b | %b | %b | Subtrator (A-B)", A_TB, B_TB, Sel_TB, Result_TB, NZVC_TB);

        Sel_TB = 2'b11; #10;
        $display(" %b | %b | %b | %b | %b | Decrementador (A-1)", A_TB, B_TB, Sel_TB, Result_TB, NZVC_TB);

        $finish;
    end

endmodule
