module xora(
    output F, 
    input A, B
);

    wire w1, w2, w3;

    nand(w1, A, B);
    nand(w2, A, w1);
    nand(w3, B, w1);
    nand(F, w2, w3);

endmodule