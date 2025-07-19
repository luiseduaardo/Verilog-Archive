`timescale 1ns/1ns
`include "and_gate.v"

module and_gate_tb();

    reg A_TB, B_TB;
    wire F_TB;

    and_gate DUT(.Y(F_TB), .A(A_TB), .B(B_TB));

    initial begin
        $dumpfile("and_gate.vcd");
        $dumpvars(0, and_gate_tb);

            A_TB = 0; B_TB = 0;
        #10 A_TB = 0; B_TB = 1;
        #10 A_TB = 1; B_TB = 0;
        #10 A_TB = 1; B_TB = 1;
        #10 
        
        $finish;

    end

endmodule