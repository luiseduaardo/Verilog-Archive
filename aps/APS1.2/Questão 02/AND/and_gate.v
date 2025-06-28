// Porta AND usando nand
module and_gate(
    output Y, 
    input A, B
);

    wire w1;
    
    nand(w1, A, B); // A nand B
    nand(Y, w1, w1); // (A nand B) nand (A nand B) == A and B

endmodule