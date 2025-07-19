`include "../components_new.v"
`include "../libaps2.v"

module count8a(
    output [7:0] CNT,
    input  [7:0] CNT_In,
    input        clk,
    input        res,
    input        EN,
    input        load
);

    wire [7:0] q_out;
    wire [7:0] qn_out;
    wire [7:0] t_signal;
    wire [7:0] d_toggle;
    wire [7:0] d_final;
    wire w_aux; 
    wire [7:0] w_aux2;

    // Aqui calculamos quando cada bit do contador deve fazer a inversão (toggle)
        // Análogo a um ripple carry, já que um bit só pode inverter se todos os bits anteriores a ele estiverem em nível lógico alto
        // A porta AND verifica a condição do bit anterior para permitir o toggle do próximo
        // Obs: esse bloco não faz o toggle em si, apenas verifica as condições e se já é possível fazer isso
    assign t_signal[0] = EN;
    and_gate instance_and0 (t_signal[1], t_signal[0], q_out[0]);
    and_gate instance_and1 (t_signal[2], t_signal[1], q_out[1]);
    and_gate instance_and2 (t_signal[3], t_signal[2], q_out[2]);
    and_gate instance_and3 (t_signal[4], t_signal[3], q_out[3]);
    and_gate instance_and4 (t_signal[5], t_signal[4], q_out[4]);
    and_gate instance_and5 (t_signal[6], t_signal[5], q_out[5]);
    and_gate instance_and6 (t_signal[7], t_signal[6], q_out[6]);

    // Usamos as portas XOR para simular um Flip-Flop tipo T (D = T ⊕ Q) e complementar a lógica anterior:
        // Se t_signal[i] for de nível lógico alto, o bit q_out[i] é invertido
        // Se t_signal[i] for de nível lógico baixo, o bit q_out[i] é mantido
    xor_gate instance_XOR0 (d_toggle[0], t_signal[0], q_out[0]);
    xor_gate instance_XOR1 (d_toggle[1], t_signal[1], q_out[1]);
    xor_gate instance_XOR2 (d_toggle[2], t_signal[2], q_out[2]);
    xor_gate instance_XOR3 (d_toggle[3], t_signal[3], q_out[3]);
    xor_gate instance_XOR4 (d_toggle[4], t_signal[4], q_out[4]);
    xor_gate instance_XOR5 (d_toggle[5], t_signal[5], q_out[5]);
    xor_gate instance_XOR6 (d_toggle[6], t_signal[6], q_out[6]);
    xor_gate instance_XOR7 (d_toggle[7], t_signal[7], q_out[7]);

    // Assim como no registrador da questão anterior, esses multiplexadores vão definir que dado vai ser enviado para o flip-flop usando como seletor um load
        // Se EN = 0, o MUX seleciona o dado atual (Reg_Out)
        // Se EN = 1, o MUX seleciona o novo dado (Reg_In)
    mux2t1_1b instance_MUX0 (.F(d_final[0]), .A(d_toggle[0]), .B(CNT_In[0]), .Sel(load));
    mux2t1_1b instance_MUX1 (.F(d_final[1]), .A(d_toggle[1]), .B(CNT_In[1]), .Sel(load));
    mux2t1_1b instance_MUX2 (.F(d_final[2]), .A(d_toggle[2]), .B(CNT_In[2]), .Sel(load));
    mux2t1_1b instance_MUX3 (.F(d_final[3]), .A(d_toggle[3]), .B(CNT_In[3]), .Sel(load));
    mux2t1_1b instance_MUX4 (.F(d_final[4]), .A(d_toggle[4]), .B(CNT_In[4]), .Sel(load));
    mux2t1_1b instance_MUX5 (.F(d_final[5]), .A(d_toggle[5]), .B(CNT_In[5]), .Sel(load));
    mux2t1_1b instance_MUX6 (.F(d_final[6]), .A(d_toggle[6]), .B(CNT_In[6]), .Sel(load));
    mux2t1_1b instance_MUX7 (.F(d_final[7]), .A(d_toggle[7]), .B(CNT_In[7]), .Sel(load));

    // Aqui também armazenamos os dados usando flip-flops do tipo D, cedidos pelo arquiteto (professor)
        // O sinal 'Preset' está desativado (conectado ao nível lógico alto)
        // Na borda de subida do clock, eles capturam o valor de d_final
    dflipflop instance_DFF0 (.Q(q_out[0]), .Qn(qn_out[0]), .D(d_final[0]), .Clock(clk), .Reset(res), .Preset(1'b1));
    dflipflop instance_DFF1 (.Q(q_out[1]), .Qn(qn_out[1]), .D(d_final[1]), .Clock(clk), .Reset(res), .Preset(1'b1));
    dflipflop instance_DFF2 (.Q(q_out[2]), .Qn(qn_out[2]), .D(d_final[2]), .Clock(clk), .Reset(res), .Preset(1'b1));
    dflipflop instance_DFF3 (.Q(q_out[3]), .Qn(qn_out[3]), .D(d_final[3]), .Clock(clk), .Reset(res), .Preset(1'b1));
    dflipflop instance_DFF4 (.Q(q_out[4]), .Qn(qn_out[4]), .D(d_final[4]), .Clock(clk), .Reset(res), .Preset(1'b1));
    dflipflop instance_DFF5 (.Q(q_out[5]), .Qn(qn_out[5]), .D(d_final[5]), .Clock(clk), .Reset(res), .Preset(1'b1));
    dflipflop instance_DFF6 (.Q(q_out[6]), .Qn(qn_out[6]), .D(d_final[6]), .Clock(clk), .Reset(res), .Preset(1'b1));
    dflipflop instance_DFF7 (.Q(q_out[7]), .Qn(qn_out[7]), .D(d_final[7]), .Clock(clk), .Reset(res), .Preset(1'b1));

    // Saída final do contador
    assign CNT = q_out;

endmodule