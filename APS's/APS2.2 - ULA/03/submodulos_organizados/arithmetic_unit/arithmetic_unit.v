`include "full_adder8b.v"
`include "increment8b.v"
`include "subtractor8b.v"
`include "decrementer8b.v"
`include "mux4t1_8b.v"

// Módulo para calcular Zero flag (Z)
module zero_flag_8b(
    input wire [7:0] in,
    output wire Z
);
    // Z = 1 se todos bits forem 0
    // operação NOR (todos os bits zero -> bitwise or = 0 -> not or = 1 -> Z = 1)
    wire [6:0] nor_chain;
    nor nor0(nor_chain[0], in[0], in[1]);
    nor nor1(nor_chain[1], in[2], in[3]);
    nor nor2(nor_chain[2], in[4], in[5]);
    nor nor3(nor_chain[3], in[6], in[7]);

    nor nor4(nor_chain[4], nor_chain[0], nor_chain[1]);
    nor nor5(nor_chain[5], nor_chain[2], nor_chain[3]);

    nor nor6(Z, nor_chain[4], nor_chain[5]);
endmodule

// Módulo principal da unidade aritmética estrutural
module arithmetic_unit(
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [1:0] ALU_Sel,  // seletor das operações
    output wire [7:0] Result,
    output wire [3:0] NZVC
);

    wire [7:0] add_res, inc_res, sub_res, dec_res;
    wire cout_add, cout_inc, borrow_sub, borrow_dec;

    // Instanciando os módulos aritméticos
    full_adder8b ADD(.A(A), .B(B), .Cin(1'b0), .S(add_res), .Cout(cout_add));
    incrementer8b INC(.A(A), .F(inc_res));
    subtractor8b SUB(.A(A), .B(B), .S(sub_res), .Borrow(borrow_sub));
    decrementer8b DEC(.A(A), .F(dec_res));

    // Mux 4x1 para selecionar o resultado
    mux4t1_8b MUX(.A(add_res), .B(inc_res), .C(sub_res), .D(dec_res), .Sel(ALU_Sel), .F(Result));

    // Flags
    wire Z;
    zero_flag_8b ZERO(.in(Result), .Z(Z));
    wire N = Result[7];  // MSB como negativo

    // V flag: overflow do somador (somente usado na operação add)
    wire V = cout_add ^ add_res[7] ^ A[7] ^ B[7];

    // C flag: carry / borrow
    wire C;
    assign C = (ALU_Sel == 2'b00) ? cout_add :
               (ALU_Sel == 2'b01) ? 1'b0 :  // incrementador não terá carry
               (ALU_Sel == 2'b10) ? ~borrow_sub :
               (ALU_Sel == 2'b11) ? 1'b0 :  // decrementador não terá borrow
               1'b0;

    assign NZVC = {N, Z, V, C};

endmodule
