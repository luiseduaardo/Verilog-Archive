`timescale 1ns/1ns

module full_adder1b_tb;

    reg A_TB, B_TB, Cin_TB;
    wire S_TB, Cout_TB;

    full_adder1b DUT (.A(A_TB), .B(B_TB), .Cin(Cin_TB), .S(S_TB), .Cout(Cout_TB));

    initial begin
        $dumpfile("full_adder1b.vcd");
        $dumpvars(0, full_adder1b_tb);

        $display("--------------------------------");
        $display(" A  B  Cin | S  Cout");
        $display("--------------------------------");

        // Teste 000
        {A_TB, B_TB, Cin_TB} = 3'b000; #10;
        $display(" %b  %b   %b  | %b    %b", A_TB, B_TB, Cin_TB, S_TB, Cout_TB);

        // Teste 001
        {A_TB, B_TB, Cin_TB} = 3'b001; #10;
        $display(" %b  %b   %b  | %b    %b", A_TB, B_TB, Cin_TB, S_TB, Cout_TB);

        // Teste 010
        {A_TB, B_TB, Cin_TB} = 3'b010; #10;
        $display(" %b  %b   %b  | %b    %b", A_TB, B_TB, Cin_TB, S_TB, Cout_TB);

        // Teste 011
        {A_TB, B_TB, Cin_TB} = 3'b011; #10;
        $display(" %b  %b   %b  | %b    %b", A_TB, B_TB, Cin_TB, S_TB, Cout_TB);

        // Teste 100
        {A_TB, B_TB, Cin_TB} = 3'b100; #10;
        $display(" %b  %b   %b  | %b    %b", A_TB, B_TB, Cin_TB, S_TB, Cout_TB);

        // Teste 101
        {A_TB, B_TB, Cin_TB} = 3'b101; #10;
        $display(" %b  %b   %b  | %b    %b", A_TB, B_TB, Cin_TB, S_TB, Cout_TB);

        // Teste 110
        {A_TB, B_TB, Cin_TB} = 3'b110; #10;
        $display(" %b  %b   %b  | %b    %b", A_TB, B_TB, Cin_TB, S_TB, Cout_TB);

        // Teste 111
        {A_TB, B_TB, Cin_TB} = 3'b111; #10;
        $display(" %b  %b   %b  | %b    %b", A_TB, B_TB, Cin_TB, S_TB, Cout_TB);

        $finish;
    end

endmodule
