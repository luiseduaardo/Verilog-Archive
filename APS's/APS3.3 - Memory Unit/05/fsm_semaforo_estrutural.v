`include "../components_new.v"
`include "../libaps2.v"

module fsm_semaforo_estrutural(output wire GRN, YLW, RED,
                               input wire CAR, TIMEOUT, clk, res);


        wire Q0, Q1, Q0_n, Q1_n, D0, D1; //as entradas e saídas utilizadas nos flip-flops


    //aqui, os flip-flops são instanciados (assim como já foi feito anteriormente na implementação do registrador de 8 bits)
    dflipflop DFF0 ( //primeiro é estabelecida a lógica do DFF0
        .D(D0), //entrada D correspondente ao flip flop D 0
        .Clock(clk),
        .Reset(res),
        .Preset(1'b1), //manter o preset desligado para o funcionamento contínuo
        .Q(Q0), //as saídas correspondetes do dff0
        .Qn(Q0_n)
    );


    dflipflop DFF1 ( //aplica-se a lógica também ao DFF1
        .D(D1),
        .Clock(clk),
        .Reset(res),
        .Preset(1'b1),
        .Q(Q1),
        .Qn(Q1_n)
    );
 
    //agora iremos partir para a lógica combinacional correspondente a cada saída
    //como já fizemos o cálculo no mapa de karnaugh na questão 9, basta implementarmos as funções para as saídas correspondentes


    //Lógica combinacional do D0:
    and_gate AND_for_D0 (D0, Q1_n, Q0_n, CAR); //D0=Q1' . Q0' . CAR


    //Lógica combinacional do D1:
    wire timeout_n; //por não termos o timeout negado (como tempos o Q0_n e Q1_n), é necessário negá-lo pela porta NOT, então, cria-se um fio para isso
    wire and_d1; //assim como, cria-se um fio intermediário para a lógica do AND da equação
    not_gate NOT_for_timeout (timeout_n, TIMEOUT);
    and_gate AND_for_D1 (and_d1, Q1, Q0_n, timeout_n); //D1=Q0 + Q1 . Q0' . TIMEOUT'
    or_gate OR_for_D1 (D1, Q0, and_d1);


    //Lógica de saída das luzes:
    and_gate AND_for_GRN (GRN, Q1_n, Q0_n);// GRN = Q1' & Q0'
    and_gate AND_for_YLW (YLW, Q1_n, Q0);// YLW = Q1' & Q0
    and_gate AND_for_RED (RED, Q1, Q0_n);// RED = Q1 & Q0'


endmodule
