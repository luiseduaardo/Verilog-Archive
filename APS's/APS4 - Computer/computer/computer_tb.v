`include "computer.v"

module computer_tb;
    parameter PERIODO_CLK = 10;
    parameter VALOR_ENTRADA_FUNCAO = 2;
    parameter RESULTADO_ESPERADO = 15;

    reg clk;
    reg reset;

    reg [7:0] port_in_00 = 8'h00;
    reg [7:0] port_in_01 = 8'h00;
    reg [7:0] port_in_02 = 8'h00;
    reg [7:0] port_in_03 = 8'h00;
    reg [7:0] port_in_04 = 8'h00;
    reg [7:0] port_in_05 = 8'h00;
    reg [7:0] port_in_06 = 8'h00;
    reg [7:0] port_in_07 = 8'h00;
    reg [7:0] port_in_08 = 8'h00;
    reg [7:0] port_in_09 = 8'h00;
    reg [7:0] port_in_10 = 8'h00;
    reg [7:0] port_in_11 = 8'h00;
    reg [7:0] port_in_12 = 8'h00;
    reg [7:0] port_in_13 = 8'h00;
    reg [7:0] port_in_14 = 8'h00;
    reg [7:0] port_in_15 = 8'h00;

    wire [7:0] port_out_00, port_out_01, port_out_02, port_out_03;
    wire [7:0] port_out_04, port_out_05, port_out_06, port_out_07;
    wire [7:0] port_out_08, port_out_09, port_out_10, port_out_11;
    wire [7:0] port_out_12, port_out_13, port_out_14, port_out_15;

    computer dut (
        .port_in_00(port_in_00), .port_in_01(port_in_01),
        .port_in_02(port_in_02), .port_in_03(port_in_03),
        .port_in_04(port_in_04), .port_in_05(port_in_05),
        .port_in_06(port_in_06), .port_in_07(port_in_07),
        .port_in_08(port_in_08), .port_in_09(port_in_09),
        .port_in_10(port_in_10), .port_in_11(port_in_11),
        .port_in_12(port_in_12), .port_in_13(port_in_13),
        .port_in_14(port_in_14), .port_in_15(port_in_15),

        .port_out_00(port_out_00), .port_out_01(),
        .port_out_02(), .port_out_03(),
        .port_out_04(), .port_out_05(),
        .port_out_06(), .port_out_07(),
        .port_out_08(), .port_out_09(),
        .port_out_10(), .port_out_11(),
        .port_out_12(), .port_out_13(),
        .port_out_14(), .port_out_15(),

        .clk(clk),
        .reset(reset)
    );

    always #(PERIODO_CLK/2) clk = ~clk;

    initial begin
        $dumpfile("computer_run.vcd");
        $dumpvars(0, computer_tb);

        clk = 0;
        reset = 0;
        port_in_00 = VALOR_ENTRADA_FUNCAO;
        $display("t = %0t ns: Testbench iniciado. Reset ativo.", $time);

        #(PERIODO_CLK * 2);
        reset = 1;
        $display("t = %0t ns: Reset liberado. CPU executando o programa fixo da ROM.", $time);
        
        #5000;
        
        $display("--------------------------------------------------");
        $display("t = %0t ns: Verificacao final.", $time);
        $display("Valor na porta de saida 0xE0: %h", port_out_00);

        if (port_out_00 === RESULTADO_ESPERADO) begin
            $display("\nSUCESSO: O resultado 0x%h, ou %d decimal, esta correto!", port_out_00, port_out_00);
        end else begin
            $display("\nFALHA: Esperado 0x%h, ou %d decimal, mas o resultado foi 0x%h, ou %d decimal", RESULTADO_ESPERADO, RESULTADO_ESPERADO, port_out_00, port_out_00);
        end
        $display("--------------------------------------------------");
        
        $finish;
    end

endmodule