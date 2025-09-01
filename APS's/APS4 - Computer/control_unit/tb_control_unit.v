`include "control_unit.v"
`timescale 1ns/1ps

module tb_control_unit;
    reg clk;
    reg reset;
    reg [7:0] IR;
    reg [3:0] CCR_Result;
    wire [2:0] ALU_Sel;
    wire [1:0] Bus1_Sel, Bus2_Sel;
    wire IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load, write;

    // Instanciar o controlador
    control_unit dut (
        .ALU_Sel(ALU_Sel),
        .Bus1_Sel(Bus1_Sel),
        .Bus2_Sel(Bus2_Sel),
        .IR_Load(IR_Load),
        .MAR_Load(MAR_Load),
        .PC_Load(PC_Load),
        .PC_Inc(PC_Inc),
        .A_Load(A_Load),
        .B_Load(B_Load),
        .CCR_Load(CCR_Load),
        .write(write),
        .IR(IR),
        .CCR_Result(CCR_Result),
        .clk(clk),
        .reset(reset)
    );

    // Constantes dos opcodes para facilitar a leitura
    localparam LDA_IMM = 8'h86, LDA_DIR = 8'h87, STA_DIR = 8'h96;
    localparam ADD_AB  = 8'h42, DECA    = 8'h48, BNE     = 8'h24;

    // Geração de Clock (período de 10ns)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // --- Lógica Principal do Teste ---
    initial begin
        $dumpfile("control_unit.vcd");
        $dumpvars(0, tb_control_unit);
        // =======================================================

        // --- Teste 1: Instrução LDA_IMM ---
        $display("\n--- Testando LDA_IMM (A <= dado_imediato) ---");
        reset = 0; #12; reset = 1;
        @(posedge clk);
        IR <= LDA_IMM;
        #60;

        // --- Teste 2: Instrução STA_DIR ---
        $display("\n--- Testando STA_DIR (M[addr] <= A) ---");
        reset = 0; #12; reset = 1;
        @(posedge clk);
        IR <= STA_DIR;
        #80;

        // --- Teste 3: Instrução BNE (Branch if Not Equal) ---
        $display("\n--- Testando BNE (condicao Z=0, deve pular) ---");
        reset = 0; #12; reset = 1;
        @(posedge clk);
        IR <= BNE;
        CCR_Result <= 4'b0000;
        #60;

        $display("\n--- Testando BNE (condicao Z=1, nao deve pular) ---");
        reset = 0; #12; reset = 1;
        @(posedge clk);
        IR <= BNE;
        CCR_Result <= 4'b0100;
        #60;

        $display("\nTodos os testes concluidos. Finalizando simulacao.");
        #20 $finish;
    end

endmodule