module mux_4t1b(
    input I0, I1, I2, I3,
    input A, B,
    output S
);

    wire An, Bn;
    wire w0, w1, w2, w3;

    nand(An, A, A);
    nand(Bn, B, B);
    
    nand(w0, I0, An, Bn);
    nand(w1, I1, An, B);
    nand(w2, I2, A, Bn);
    nand(w3, I3, A, B);

    nand(S, w0, w1, w2, w3);

endmodule