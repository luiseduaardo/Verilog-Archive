`timescale 1ns/1ps

module comp_tb;

  // Inputs
  reg I0_TB, I1_TB, I2_TB, I3_TB;
  reg [1:0] Sel_TB;
  reg A_TB, B_TB;

  // Outputs
  wire S_sys1;  // saída mux_4t1a (com seletor vetor)
  wire S_sys2;  // saída mux_4t1b (com seletor bits separados)

  // Instanciando a modelagem comportamental (seletor vetor)
  mux_4t1a DUT (
    .I0(I0_TB), .I1(I1_TB), .I2(I2_TB), .I3(I3_TB),
    .Sel(Sel_TB),
    .S(S_sys1)
  );

  // Instanciando a modelagem estrutural (seletor bits separados)
  mux_4t1b REF (
    .I0(I0_TB), .I1(I1_TB), .I2(I2_TB), .I3(I3_TB),
    .A(A_TB), .B(B_TB),
    .S(S_sys2)
  );
  
  // Geração dos estímulos
  initial begin
    $display("I0 I1 I2 I3 | Sel1 Sel0 | S_sys1 S_sys2 | Resultado");
    
    // Inicializa entradas
    I0_TB = 0; I1_TB = 1; I2_TB = 0; I3_TB = 1;

    // Teste seletor 00
    Sel_TB = 2'b00; A_TB = 0; B_TB = 0;
    #4;
    $write("%b  %b  %b  %b |  %b    %b   |   %b     %b   | ", I0_TB, I1_TB, I2_TB, I3_TB, Sel_TB[1], Sel_TB[0], S_sys1, S_sys2);
    if (S_sys1 == S_sys2) $display("PASS"); else $display("FAIL");

    // Teste seletor 01
    Sel_TB = 2'b01; A_TB = 0; B_TB = 1;
    #4;
    $write("%b  %b  %b  %b |  %b    %b   |   %b     %b   | ", I0_TB, I1_TB, I2_TB, I3_TB, Sel_TB[1], Sel_TB[0], S_sys1, S_sys2);
    if (S_sys1 == S_sys2) $display("PASS"); else $display("FAIL");

    // Teste seletor 10
    Sel_TB = 2'b10; A_TB = 1; B_TB = 0;
    #4;
    $write("%b  %b  %b  %b |  %b    %b   |   %b     %b   | ", I0_TB, I1_TB, I2_TB, I3_TB, Sel_TB[1], Sel_TB[0], S_sys1, S_sys2);
    if (S_sys1 == S_sys2) $display("PASS"); else $display("FAIL");

    // Teste seletor 11
    Sel_TB = 2'b11; A_TB = 1; B_TB = 1;
    #4;
    $write("%b  %b  %b  %b |  %b    %b   |   %b     %b   | ", I0_TB, I1_TB, I2_TB, I3_TB, Sel_TB[1], Sel_TB[0], S_sys1, S_sys2);
    if (S_sys1 == S_sys2) $display("PASS"); else $display("FAIL");

    $finish;
  end

endmodule
