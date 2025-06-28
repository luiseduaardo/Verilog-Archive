// Porta NOT usando nand
module not_gate(
    output Y, 
    input A
);

    nand(Y, A, A); // A nand A == A' / not A
    
endmodule
