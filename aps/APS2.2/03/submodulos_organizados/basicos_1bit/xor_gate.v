module xor_gate(
    output Y, 
    input A, B
);

    wire w1, w2, w3;

    nand(w1, A, B);
    nand(w2, A, w1);
    nand(w3, B, w1);
    nand(Y, w2, w3);

endmodule