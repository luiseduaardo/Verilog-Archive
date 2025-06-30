module and_gate(
    output Y, 
    input A, B
);

    wire w1;
    
    nand(w1, A, B);
    nand(Y, w1, w1);

endmodule