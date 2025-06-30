module or_gate(
    output Y, 
    input A, B
);

    wire w1, w2;
    
    nand(w1, A, A);
    nand(w2, B, B);
    nand(Y, w1, w2);

endmodule