`timescale 1ns/1ns
`include "../03/all_modules.v"

module ALUa(
    input wire [7:0] A,
    input wire [7:0] B,
    input wire [2:0] Sel,
    output wire [7:0] Result,
    output wire [3:0] NZVC
);

    // Fios internos
    wire [7:0] logic_result;
    wire [7:0] arith_result;
    wire [3:0] logic_NZVC;
    wire [3:0] arith_NZVC;

    // Unidade lógica
    logic_unit LOGIC (
        .A(A),
        .B(B),
        .Sel(Sel[1:0]),   // Sel1 e Sel0 para lógica
        .F(logic_result)
    );

    // Unidade aritmética
    arithmetic_unit ARITH (
        .A(A),
        .B(B),
        .ALU_Sel(Sel[1:0]), // Sel1 e Sel0 para aritmética
        .Result(arith_result),
        .NZVC(arith_NZVC)
    );

    // Cálculo de NZVC
    wire logic_N = logic_result[7];
    wire logic_Z;
    zero_flag_8b ZERO_LOGIC (
        .in(logic_result),
        .Z(logic_Z)
    );
    assign logic_NZVC = {logic_N, logic_Z, 1'b0, 1'b0};

    // MUX para selecionar resultado entre Logic e Arithmetic
    mux2t1_8b MUX_RESULT (
        .A(logic_result),   // Sel2 = 0 → logic
        .B(arith_result),   // Sel2 = 1 → arithmetic
        .Sel(Sel[2]),
        .F(Result)
    );

    // MUX para selecionar NZVC entre Logic e Arithmetic
    mux2t1_8b MUX_NZVC (
        .A({logic_NZVC}),   // Sel2 = 0 → logic
        .B({arith_NZVC}),   // Sel2 = 1 → arithmetic
        .Sel(Sel[2]),
        .F(NZVC)
    );

endmodule
