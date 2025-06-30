`timescale 1ns/1ns

module decrementer8b_tb;

    reg [7:0] A_TB;
    wire [7:0] D_TB;
    wire Borrow_TB;

    decrementer8b DUT (
        .A(A_TB),
        .D(D_TB),
        .Borrow(Borrow_TB)
    );

    initial begin
        $dumpfile("decrementer.vcd");
        $dumpvars(0, decrementer8b_tb);

        $display("---------------------------------------------");
        $display("      A         |      S         | Borrow ");
        $display("---------------------------------------------");

        A_TB = 8'd0; #10;
        $display(" %b (%0d)   | %b (%0d) | %b", A_TB, A_TB, D_TB, D_TB, Borrow_TB);

        A_TB = 8'd1; #10;
        $display(" %b (%0d)   | %b (%0d)   | %b", A_TB, A_TB, D_TB, D_TB, Borrow_TB);

        A_TB = 8'd10; #10;
        $display(" %b (%0d)  | %b (%0d)   | %b", A_TB, A_TB, D_TB, D_TB, Borrow_TB);

        A_TB = 8'd255; #10;
        $display(" %b (%0d) | %b (%0d) | %b", A_TB, A_TB, D_TB, D_TB, Borrow_TB);

        $finish;
    end

endmodule
