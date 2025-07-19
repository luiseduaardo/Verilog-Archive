// Porta OR usando nand
module or_gate(
    output Y, 
    input A, B
);

    wire w1, w2;
    
    nand(w1, A, A); // A nand A == A'
    nand(w2, B, B); // B nand B == B'
    nand(Y, w1, w2); // A' nand B' = A or B

endmodule