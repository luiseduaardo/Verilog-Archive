`timescale 1ns / 1ps

module comportamental_tb;

    reg CAR;
    reg TIMEOUT;
    reg clk;
    reg res;
    wire GRN;
    wire YLW;
    wire RED;
    reg [8*10:1] estado_legivel;

    fsm_semaforo_comportamental dut (
        .GRN(GRN), .YLW(YLW), .RED(RED),
        .CAR(CAR), .TIMEOUT(TIMEOUT), .clk(clk), .res(res)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    always @(GRN or YLW or RED) begin
        if (GRN == 1'b1)      estado_legivel = "VERDE";
        else if (YLW == 1'b1) estado_legivel = "AMARELO";
        else if (RED == 1'b1) estado_legivel = "VERMELHO";
        else                  estado_legivel = "APAGADO";
    end

    // Task para impressao em formato de tabela
    task print_status;
        begin
            $display("--------------------------------------------------------------------");
            $display("| Tempo      | Reset | Carro | Timeout | Estado     | Saidas (R Y G) |");
            $display("| %-10t | %-5b | %-5b | %-7b | %-10s |      %b %b %b     |",
                     $time, res, CAR, TIMEOUT, estado_legivel, RED, YLW, GRN);
            $display("--------------------------------------------------------------------\n");
        end
    endtask

    initial begin
        $dumpfile("comportamental.vcd");
        $dumpvars(0, comportamental_tb);

        $display("\n\n>>> Inicio da simulacao da abordagem COMPORTAMENTAL");
        #20;

        // Teste 1: Estado inicial e Reset
        $display("\n>>> [TESTE 1] Ativando o Reset...");
        res = 1; CAR = 0; TIMEOUT = 0;
        #15;
        print_status();

        // Teste 2: Liberar o Reset
        $display(">>> [TESTE 2] Liberando o Reset. Deve permanecer em VERDE.");
        res = 0;
        #1;
        print_status();
        #19;

        // Teste 3: Transicao de VERDE -> AMARELO
        $display(">>> [TESTE 3] Detectando um carro. Transicao para AMARELO.");
        CAR = 1;
        #1; print_status();
        #9;
        print_status();
        
        CAR = 0;

        // Teste 4: Transicao de AMARELO -> VERMELHO
        $display(">>> [TESTE 4] Transicao automatica para VERMELHO.");
        #10;
        print_status();

        // Teste 5: Permanecer no VERMELHO
        $display(">>> [TESTE 5] Permanecendo no VERMELHO (sem timeout).");
        #30;
        print_status();

        // Teste 6: Transicao de VERMELHO -> VERDE
        $display(">>> [TESTE 6] Ocorreu o TIMEOUT. Transicao para VERDE.");
        TIMEOUT = 1;
        #1; print_status();
        #9;
        print_status();

        TIMEOUT = 0;

        $display(">>> Simulacao concluida com sucesso!");
        #20;
        $finish;
    end

endmodule