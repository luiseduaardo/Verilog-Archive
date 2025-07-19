`timescale 1ns/1ns

module subtractor8b_tb;

    reg [7:0] A_TB, B_TB;
    wire [7:0] S_TB;
    wire Borrow_TB;

    subtractor8b DUT (
        .A(A_TB),
        .B(B_TB),
        .S(S_TB),
        .Borrow(Borrow_TB)
    );

    initial begin
        $dumpfile("subtractor.vcd");
        $dumpvars(0, subtractor8b_tb);

        $display("-----------------------------------------------");
        $display("    A     |    B       |     S      | Borrow");
        $display("-----------------------------------------------");

        A_TB = 8'd10; B_TB = 8'd3; #10;   // 10 - 3 = 7
        $display(" %3b | %3b   |  %3b  | %b", A_TB, B_TB, S_TB, Borrow_TB);

        A_TB = 8'd5; B_TB = 8'd10; #10;   // 5 - 10 = -5
        $display(" %3b | %3b   |  %3b  | %b", A_TB, B_TB, S_TB, Borrow_TB);

        A_TB = 8'd255; B_TB = 8'd1; #10;  // 255 - 1 = 254
        $display(" %3b | %3b   |  %3b  | %b", A_TB, B_TB, S_TB, Borrow_TB);

        A_TB = 8'd0; B_TB = 8'd0; #10;    // 0 - 0 = 0
        $display(" %3b | %3b   |  %3b  | %b", A_TB, B_TB, S_TB, Borrow_TB);

        A_TB = 8'd100; B_TB = 8'd100; #10; // 100 - 100
        $display(" %3b | %3b   |  %3b  | %b", A_TB, B_TB, S_TB, Borrow_TB);

        $finish;
    end

endmodule
