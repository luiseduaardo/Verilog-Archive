module fsm_semaforo_comportamental(output reg GRN, YLW, RED,
                                   input wire CAR, TIMEOUT, clk, res);


        localparam S_GRN = 2'b00; // apenas para facilitar. Assim, cada estado poderá ser definido com os nomes
        localparam S_YLW = 2'b01; // que utilizamos na questão, sem ter que chamá-los somente pelos seus valores binários
        localparam S_RED = 2'b10;


        reg[1:0] estado_atual; //os entradas que Q0 e Q1
        reg[1:0] proximo_estado; // os valores de Q0* e Q1* (os próximos).


    always @(*) begin //aqui será implementada uma lógica semelhante à combinacional. O "*" faz com que recalcule a lógica
                      // para qualquer mudança de sinais
        proximo_estado = estado_atual;


        case (estado_atual)
            S_GRN: begin // se estou no estado verde
                if (CAR == 1'b1) begin // e um carro chegou, ou seja, CAR foi ativado
                    proximo_estado = S_YLW; // vá para o estado amarelo
                end
                //se não, continua no verde (já definido no padrão)
            end


            S_YLW: begin //se estou no amarelo, vá para o vermelho sempre (na próxima mudança de se sinal detectada pelo *, ou seja, no próximo clock)
                proximo_estado = S_RED;
            end


            S_RED: begin//se estou no vermelho
                if (TIMEOUT == 1'b1) begin //e o tempo acabou (O timeout foi ativo)
                    proximo_estado = S_GRN; //volte para o Verde
                end
                //senão, continue no vermelho (também já definido no padrão)
            end
            default: begin //medida de segurança para caso tenha algum erro, como o estado ser = 11
                proximo_estado = S_GRN; //nesses casos, ele volta para o estado original
            end
        endcase
    end


    //agora, será implementada a lógica sequencial:
    always @(posedge clk, posedge res) begin //sempre na borda do clock ou do reset
        if (res) //o reset tem prioridade, sempre que ele for ativado volta para o estado inicial (o verde)
            estado_atual <= S_GRN;
        else //senão, na borda do clock ele irá fazer a mudança de estados do atual para o próximo, o qual foi calculado no bloco anterior
            estado_atual <= proximo_estado;
    end


    //por fim, será implementada a lógica da saída:
    always @(estado_atual) begin
        case (estado_atual) //baseado no estado atual
            S_GRN: begin //se estiver no estado verde, acende a luz verde
                GRN = 1'b1;
                YLW = 1'b0;
                RED = 1'b0;
            end
            S_YLW: begin //no estado amarelo, acende a luz amarela
                GRN = 1'b0;
                YLW = 1'b1;
                RED = 1'b0;
            end
            S_RED: begin //no estado vermelho, acende a luz vermelha
                GRN = 1'b0;
                YLW = 1'b0;
                RED = 1'b1;
            end
            default: begin //medida de segurança -> em caso de um estado inválido, apaga tudo
                GRN = 1'b0;
                YLW = 1'b0;
                RED = 1'b0;
            end
        endcase
    end
endmodule
