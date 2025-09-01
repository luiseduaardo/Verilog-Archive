`timescale 1ns/1ps

module tb_memory;

    reg clk, reset, write;
    reg [7:0] data_in, address;

    // Portas de entrada simuladas
    reg [7:0] port_in_00, port_in_01, port_in_02, port_in_03;
    reg [7:0] port_in_04, port_in_05, port_in_06, port_in_07;
    reg [7:0] port_in_08, port_in_09, port_in_10, port_in_11;
    reg [7:0] port_in_12, port_in_13, port_in_14, port_in_15;

    // Portas de saída
    wire [7:0] port_out_00, port_out_01, port_out_02, port_out_03;
    wire [7:0] port_out_04, port_out_05, port_out_06, port_out_07;
    wire [7:0] port_out_08, port_out_09, port_out_10, port_out_11;
    wire [7:0] port_out_12, port_out_13, port_out_14, port_out_15;

    // Saída de dados
    wire [7:0] data_out;

    // Instância do módulo de memória
    memory dut (
        .port_out_00(port_out_00), .port_out_01(port_out_01),
        .port_out_02(port_out_02), .port_out_03(port_out_03),
        .port_out_04(port_out_04), .port_out_05(port_out_05),
        .port_out_06(port_out_06), .port_out_07(port_out_07),
        .port_out_08(port_out_08), .port_out_09(port_out_09),
        .port_out_10(port_out_10), .port_out_11(port_out_11),
        .port_out_12(port_out_12), .port_out_13(port_out_13),
        .port_out_14(port_out_14), .port_out_15(port_out_15),

        .data_out(data_out),

        .port_in_00(port_in_00), .port_in_01(port_in_01),
        .port_in_02(port_in_02), .port_in_03(port_in_03),
        .port_in_04(port_in_04), .port_in_05(port_in_05),
        .port_in_06(port_in_06), .port_in_07(port_in_07),
        .port_in_08(port_in_08), .port_in_09(port_in_09),
        .port_in_10(port_in_10), .port_in_11(port_in_11),
        .port_in_12(port_in_12), .port_in_13(port_in_13),
        .port_in_14(port_in_14), .port_in_15(port_in_15),

        .data_in(data_in),
        .address(address),
        .clk(clk),
        .reset(reset),
        .write(write)
    );

    // Clock de 10ns
    always #5 clk = ~clk;

    initial begin
        $dumpfile("memory.vcd");
        $dumpvars(0, tb_memory);

        clk = 0;
        reset = 0;
        write = 0;
        data_in = 0;
        address = 0;

        // Valores fixos nas portas de entrada
        port_in_00 = 8'hAA;
        port_in_01 = 8'hBB;
        port_in_02 = 8'hCC;
        port_in_03 = 8'hDD;
        port_in_04 = 8'h11;
        port_in_05 = 8'h22;
        port_in_06 = 8'h33;
        port_in_07 = 8'h44;
        port_in_08 = 8'h55;
        port_in_09 = 8'h66;
        port_in_10 = 8'h77;
        port_in_11 = 8'h88;
        port_in_12 = 8'h99;
        port_in_13 = 8'hAB;
        port_in_14 = 8'hCD;
        port_in_15 = 8'hEF;

        // Reset ativo
        #5 reset = 0;
        #5 reset = 1;

        // ====== TESTE 1: Escrita e leitura na RAM ======
        @(negedge clk);
        address = 8'h80;  // Endereço RAM
        data_in = 8'h5A;
        write = 1;        // Escrever
        @(negedge clk);
        write = 0;        // Ler
        @(posedge clk);

        // ====== TESTE 2: Escrita nas portas de saída ======
        @(negedge clk);
        address = 8'hE0;  // Port_out_00
        data_in = 8'hF1;
        write = 1;
        @(negedge clk);
        write = 0;

        @(negedge clk);
        address = 8'hE1;  // Port_out_01
        data_in = 8'hF2;
        write = 1;
        @(negedge clk);
        write = 0;

        // ====== TESTE 3: Leitura da ROM ======
        @(negedge clk);
        address = 8'h00;  // Primeira posição da ROM
        write = 0;
        @(posedge clk);

        // ====== TESTE 4: Leitura de portas de entrada ======
        @(negedge clk);
        address = 8'hF0;  // Deve retornar 8'hAA
        @(negedge clk);
        address = 8'hF1;  // Deve retornar 8'hBB
        @(posedge clk);

        // Encerrar simulação
        #20 $finish;
    end

endmodule
