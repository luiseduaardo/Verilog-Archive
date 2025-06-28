`timescale 1ns/1ps

module mux_2t1_tb;

  // Inputs
  reg A_TB, B_TB, Sel_TB;

  // Outputs
  wire F_sys1, F_sys2;

  // Instancia os dois módulos
  mux_2t1a DUT(.F(F_sys1), .A(A_TB), .B(B_TB), .Sel(Sel_TB));  // Estrutural (com NANDs)
  mux_2t1b REF(.F(F_sys2), .A(A_TB), .B(B_TB), .Sel(Sel_TB));  // Comportamental (referência)

  // Estímulos
  initial begin
    $display("A B | Sel | F - Test");

    // Teste 0
    A_TB = 0; B_TB = 0; Sel_TB = 0;
    #2;
    $write("%b %b |  %b  | %b", A_TB, B_TB, Sel_TB, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" - FAIL");

    // Teste 1
    A_TB = 0; B_TB = 0; Sel_TB = 1;
    #2;
    $write("%b %b |  %b  | %b", A_TB, B_TB, Sel_TB, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" - FAIL");

    // Teste 2
    A_TB = 0; B_TB = 1; Sel_TB = 0;
    #2;
    $write("%b %b |  %b  | %b", A_TB, B_TB, Sel_TB, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" - FAIL");

    // Teste 3
    A_TB = 0; B_TB = 1; Sel_TB = 1;
    #2;
    $write("%b %b |  %b  | %b", A_TB, B_TB, Sel_TB, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" - FAIL");

    // Teste 4
    A_TB = 1; B_TB = 0; Sel_TB = 0;
    #2;
    $write("%b %b |  %b  | %b", A_TB, B_TB, Sel_TB, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" - FAIL");

    // Teste 5
    A_TB = 1; B_TB = 0; Sel_TB = 1;
    #2;
    $write("%b %b |  %b  | %b", A_TB, B_TB, Sel_TB, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" - FAIL");

    // Teste 6
    A_TB = 1; B_TB = 1; Sel_TB = 0;
    #2;
    $write("%b %b |  %b  | %b", A_TB, B_TB, Sel_TB, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" - FAIL");

    // Teste 7
    A_TB = 1; B_TB = 1; Sel_TB = 1;
    #2;
    $write("%b %b |  %b  | %b", A_TB, B_TB, Sel_TB, F_sys1);
    if(F_sys1 == F_sys2) $display(" - PASS"); else $display(" - FAIL");

    $finish;
  end

endmodule
