`timescale 1ns/1ns
`include "not_gate.v"

module not_gate_tb();

    reg A_TB;
    wire F_TB;

    not_gate DUT(.Y(F_TB), .A(A_TB));

    initial
        begin
            $dumpfile("not_gate.vcd");
            $dumpvars(0, not_gate_tb);

            A_TB = 0;
        #10 A_TB = 1;
        #10 
        
        $finish;
        end

endmodule