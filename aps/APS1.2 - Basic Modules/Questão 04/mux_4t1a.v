module mux_4t1a (
    output F,
    input A, B, C, D,
    input [1:0] Sel
);
    wire not_s0, not_s1;
    wire t1a, t1b, m1;
    wire t2a, t2b, m2;
    wire t3a, t3b;

    // Inversores
    nand(not_s0, Sel[0], Sel[0]); // Seletor 0 invertido
    nand(not_s1, Sel[1], Sel[1]); // Seletor 1 invertido

    // Primeiro mux 2:1 → inputs: A e B; output: M1
    nand(t1a, A, not_s0);
    nand(t1b, B, Sel[0]);
    nand(m1, t1a, t1b);

    // Segundo mux 2:1 → inputs: C e D; output: M2 
    nand(t2a, C, not_s0);
    nand(t2b, D, Sel[0]);
    nand(m2, t2a, t2b);

    // Terceiro mux 2:1 → inputs: M1 e M2; output F
    nand(t3a, m1, not_s1);
    nand(t3b, m2, Sel[1]);
    nand(F, t3a, t3b);

endmodule
