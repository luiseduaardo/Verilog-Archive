`timescale 1ns/1ps
`include "data_path.v"

module data_path_tb;
    reg  [7:0] from_memory;
    reg  [2:0] ALU_Sel;
    reg  [1:0] Bus1_Sel, Bus2_Sel;
    reg        IR_Load, MAR_Load, PC_Load, PC_Inc, A_Load, B_Load, CCR_Load;
    reg        clk, reset;

    wire [7:0] to_memory;
    wire [7:0] address, IR_out;
    wire [3:0] CCR_Result;

    // DUT
    data_path dut (
        .to_memory(to_memory),
        .address(address),
        .IR_out(IR_out),
        .CCR_Result(CCR_Result),
        .from_memory(from_memory),
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
        .clk(clk),
        .reset(reset)
    );

    // Clock
    always #5 clk = ~clk;

    // Task para reset
    task reset_dut;
    begin
        reset = 0;
        #10;
        reset = 1;
    end
    endtask

    initial begin
        $dumpfile("data_path.vcd");
        $dumpvars(0, data_path_tb);

        clk = 0;
        reset_dut();

        // ================================
        // (i) Carregar registros from_memory
        // ================================
        from_memory = 8'hAA;
        Bus2_Sel = 2'b10; // from_memory -> bus2
        IR_Load = 1; #10; IR_Load = 0;   // Carrega IR
        MAR_Load = 1; #10; MAR_Load = 0; // Carrega MAR
        A_Load = 1; #10; A_Load = 0;     // Carrega A
        B_Load = 1; #10; B_Load = 0;     // Carrega B
        PC_Inc = 1; PC_Load = 1; #10; PC_Load = 0; PC_Inc = 0;   // Carrega PC

        // ================================
        // (ii) PC, A ou B -> to_memory via Bus1
        // ================================
        Bus1_Sel = 2'b00; #10; // PC -> to_memory
        Bus1_Sel = 2'b01; #10; // A -> to_memory
        Bus1_Sel = 2'b10; #10; // B -> to_memory

        // ================================
        // (iii) ALU operações
        // ================================
        Bus2_Sel = 2'b10; from_memory = 8'h05; A_Load = 1; #10; A_Load = 0; // A=0x05
        from_memory = 8'h03; B_Load = 1; #10; B_Load = 0; // B=0x03

        Bus2_Sel = 2'b00; // ALU -> bus2
        ALU_Sel = 3'b000; CCR_Load = 1; #10; // ADD
        ALU_Sel = 3'b010; #10; // SUB
        ALU_Sel = 3'b100; #10; // AND
        ALU_Sel = 3'b101; #10; // OR
        CCR_Load = 0;

        // ================================
        // (iv) MAR carregado e visível em address
        // ================================
        from_memory = 8'h55;
        Bus2_Sel = 2'b10; MAR_Load = 1; #10; MAR_Load = 0;

        #50;
        $finish;
    end
endmodule
