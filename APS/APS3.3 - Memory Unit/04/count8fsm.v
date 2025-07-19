module count8fsm(
    output [7:0] CNT,
    input  [7:0] CNT_In,
    input        clk,
    input        res,
    input        EN,
    input        load
);

    // Declaração dos registradores de estado
    reg [7:0] current_count; // Armazena o estado atual do contador
    reg [7:0] next_count;    // Armazena o estado futuro do contador

    // Bloco 01: Registrador de estado
        // Atualiza o estado atual na borda do clock
    always @(posedge clk or negedge res) begin
        if (!res) begin
            current_count <= 8'h00;
        end
        else begin
            current_count <= next_count;
        end
    end

    // Bloco 02: Lógica de estado próximo
        // Calcula o próximo estado com base no estado atual e nas entradas
    always @(*) begin
        if (load) begin
            next_count = CNT_In;
        end
        else if (EN) begin
            next_count = current_count + 1;
        end
        else begin
            next_count = current_count;
        end
    end

    // Bloco 03: Lógica de saída
        // A saída do contador é o seu estado atual (Modelo Moore).
    assign CNT = current_count;

endmodule
