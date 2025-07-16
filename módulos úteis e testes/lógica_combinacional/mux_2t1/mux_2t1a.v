module mux_2t1a(
    output F,
    input A, B,
    input Sel
);

    wire nSel;
    wire w1, w2;

    nand(nSel, Sel, Sel);
    nand(w1, A, nSel);
    nand(w2, B, Sel);
    nand(F, w1, w2);
    
endmodule
