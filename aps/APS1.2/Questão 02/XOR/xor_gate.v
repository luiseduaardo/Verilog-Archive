// Porta XOR usando nand
module xor_gate(
    output Y, 
    input A, B
);

    wire w1, w2, w3;

    nand(w1, A, B); // A nand B
    nand(w2, A, w1); // A nand (A nand B)
    nand(w3, B, w1); // B nand (B nand A)
    nand(Y, w2, w3); // (A nand (A nand B)) nand (B nand (A nand B))

endmodule