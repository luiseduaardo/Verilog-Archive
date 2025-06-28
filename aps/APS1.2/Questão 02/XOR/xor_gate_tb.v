`timescale 1ns/1ns
`include "xor_gate.v"

module xor_gate_tb();

    reg A_TB, B_TB;
    wire F_TB;

    xor_gate DUT(.A(A_TB), .B(B_TB), .Y(F_TB));

    initial begin
        $dumpfile("xor_gate.vcd");
        $dumpvars(0, xor_gate_tb);

            A_TB = 0; B_TB = 0;
        #10 A_TB = 0; B_TB = 1;
        #10 A_TB = 1; B_TB = 0;
        #10 A_TB = 1; B_TB = 1;
        #10 

        $finish;

    end

endmodule