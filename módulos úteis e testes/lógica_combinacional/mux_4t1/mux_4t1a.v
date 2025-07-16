// Modelagem comportamental

module mux_4t1a (
    input wire I0, I1, I2, I3,
    input wire [1:0] Sel,
    output wire S);

    assign S = (Sel == 2'b00) ? I0 :
               (Sel == 2'b01) ? I1 :
               (Sel == 2'b10) ? I2 :
               (Sel == 2'b11) ? I3 :
               1'bx;

endmodule
