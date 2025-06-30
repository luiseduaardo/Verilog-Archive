module not_gate(
    output Y, 
    input A
);

    nand(Y, A, A);
    
endmodule