`include "../components_new.v"
`include "../libaps2.v"

module reg8a(
    output [7:0] Reg_Out, Qn,
    input [7:0] Reg_In,
    input clk, res, EN
);

    wire [7:0] d_para_ffs;

    // Bloco de Lógica de Enable (Multiplexadores)
        // Se EN = 0, o MUX seleciona o dado atual (Reg_Out)
        // Se EN = 1, o MUX seleciona o novo dado (Reg_In)
    mux2t1_1b instance_mux0 (.F(d_para_ffs[0]), .A(Reg_Out[0]), .B(Reg_In[0]), .Sel(EN));
    mux2t1_1b instance_mux1 (.F(d_para_ffs[1]), .A(Reg_Out[1]), .B(Reg_In[1]), .Sel(EN));
    mux2t1_1b instance_mux2 (.F(d_para_ffs[2]), .A(Reg_Out[2]), .B(Reg_In[2]), .Sel(EN));
    mux2t1_1b instance_mux3 (.F(d_para_ffs[3]), .A(Reg_Out[3]), .B(Reg_In[3]), .Sel(EN));
    mux2t1_1b instance_mux4 (.F(d_para_ffs[4]), .A(Reg_Out[4]), .B(Reg_In[4]), .Sel(EN));
    mux2t1_1b instance_mux5 (.F(d_para_ffs[5]), .A(Reg_Out[5]), .B(Reg_In[5]), .Sel(EN));
    mux2t1_1b instance_mux6 (.F(d_para_ffs[6]), .A(Reg_Out[6]), .B(Reg_In[6]), .Sel(EN));
    mux2t1_1b instance_mux7 (.F(d_para_ffs[7]), .A(Reg_Out[7]), .B(Reg_In[7]), .Sel(EN));

    // Armazenamos os dados usando flip-flops do tipo D, cedidos pelo arquiteto (professor)
        // O sinal 'Preset' está desativado (conectado ao nível lógico alto)
    dflipflop instance_dff0 (.D(d_para_ffs[0]), .Clock(clk), .Reset(res), .Preset(1'b1), .Q(Reg_Out[0]), .Qn(Qn[0]));
    dflipflop instance_dff1 (.D(d_para_ffs[1]), .Clock(clk), .Reset(res), .Preset(1'b1), .Q(Reg_Out[1]), .Qn(Qn[1]));
    dflipflop instance_dff2 (.D(d_para_ffs[2]), .Clock(clk), .Reset(res), .Preset(1'b1), .Q(Reg_Out[2]), .Qn(Qn[2]));
    dflipflop instance_dff3 (.D(d_para_ffs[3]), .Clock(clk), .Reset(res), .Preset(1'b1), .Q(Reg_Out[3]), .Qn(Qn[3]));
    dflipflop instance_dff4 (.D(d_para_ffs[4]), .Clock(clk), .Reset(res), .Preset(1'b1), .Q(Reg_Out[4]), .Qn(Qn[4]));
    dflipflop instance_dff5 (.D(d_para_ffs[5]), .Clock(clk), .Reset(res), .Preset(1'b1), .Q(Reg_Out[5]), .Qn(Qn[5]));
    dflipflop instance_dff6 (.D(d_para_ffs[6]), .Clock(clk), .Reset(res), .Preset(1'b1), .Q(Reg_Out[6]), .Qn(Qn[6]));
    dflipflop instance_dff7 (.D(d_para_ffs[7]), .Clock(clk), .Reset(res), .Preset(1'b1), .Q(Reg_Out[7]), .Qn(Qn[7]));

endmodule
