`timescale 1ns/1ns
`include "example_syn.v"

module example_syn_tb();

    reg A_TB, B_TB, C_TB;
    wire F_TB;

    example_syn DUT (.F(F_TB), .A(A_TB), .B(B_TB), .C(C_TB));

    initial 
        begin
            $dumpfile("example_syn.vcd");
            $dumpvars(0, example_syn_tb);

                A_TB = 0; B_TB = 0; C_TB = 0;
            #10 A_TB = 0; B_TB = 0; C_TB = 1;
            #10 A_TB = 0; B_TB = 1; C_TB = 0;
            #10 A_TB = 0; B_TB = 1; C_TB = 1;
            #10 A_TB = 1; B_TB = 0; C_TB = 0;
            #10 A_TB = 1; B_TB = 0; C_TB = 1;
            #10 A_TB = 1; B_TB = 1; C_TB = 0;
            #10 A_TB = 1; B_TB = 1; C_TB = 1;

            $finish;
        end

endmodule