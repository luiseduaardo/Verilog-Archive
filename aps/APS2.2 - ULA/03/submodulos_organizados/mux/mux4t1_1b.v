`include "mux2t1_1b.v"

module mux4t1_1b(
    output wire F,
    input wire A, B, C, D,
    input wire [1:0] Sel
);

    wire w0, w1;

    mux2t1_1b mux0(w0, A, B, Sel[0]);
    mux2t1_1b mux1(w1, C, D, Sel[0]);
    mux2t1_1b mux2(F, w0, w1, Sel[1]);

endmodule
