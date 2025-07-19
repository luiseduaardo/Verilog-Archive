`timescale 1ns/1ns

module full_adder8b_tb;

    reg [7:0] A_TB, B_TB;
    reg Cin_TB;
    wire [7:0] S_TB;
    wire Cout_TB;

    full_adder8b DUT (.A(A_TB), .B(B_TB), .Cin(Cin_TB), .S(S_TB), .Cout(Cout_TB));

    initial begin
        $dumpfile("full_adder8b.vcd");
        $dumpvars(0, full_adder8b_tb);

        $display("--------------------------------------------------------------");
        $display("   A       B       Cin |     S       Cout");
        $display("--------------------------------------------------------------");

        // Teste 1
        A_TB = 8'b00000000; B_TB = 8'b00000000; Cin_TB = 0; #10;
        $display(" %b %b  %b  | %b   %b", A_TB, B_TB, Cin_TB, S_TB, Cout_TB);

        // Teste 2
        A_TB = 8'b11111111; B_TB = 8'b00000001; Cin_TB = 0; #10;
        $display(" %b %b  %b  | %b   %b", A_TB, B_TB, Cin_TB, S_TB, Cout_TB);

        // Teste 3
        A_TB = 8'b10101010; B_TB = 8'b01010101; Cin_TB = 1; #10;
        $display(" %b %b  %b  | %b   %b", A_TB, B_TB, Cin_TB, S_TB, Cout_TB);

        // Teste 4
        A_TB = 8'b11110000; B_TB = 8'b00001111; Cin_TB = 0; #10;
        $display(" %b %b  %b  | %b   %b", A_TB, B_TB, Cin_TB, S_TB, Cout_TB);

        // Teste 5 - Overflow
        A_TB = 8'b11111111; B_TB = 8'b11111111; Cin_TB = 1; #10;
        $display(" %b %b  %b  | %b   %b", A_TB, B_TB, Cin_TB, S_TB, Cout_TB);

        $finish;
    end

endmodule
