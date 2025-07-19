`include "jkflipflop.v"

module count8a(
    output [7:0] Q,
    input en,
    input clk,
    input res,
    input Preset
);

    wire [7:0] q_out;
    wire [7:0] qn_out;
    wire [7:0] t_signal;

    // Lógica em cascata do sinal de entrada do flip flop JK
    assign t_signal[0] = Enable;
    assign t_signal[1] = q_out[0] & Enable;
    assign t_signal[2] = t_signal[1] & q_out[1];
    assign t_signal[3] = t_signal[2] & q_out[2];
    assign t_signal[4] = t_signal[3] & q_out[3];
    assign t_signal[5] = t_signal[4] & q_out[4];
    assign t_signal[6] = t_signal[5] & q_out[5];
    assign t_signal[7] = t_signal[6] & q_out[6];

    // Instanciação dos flip flops JK
        // Devido à universalidade dos flip flops JK, essa construção tem mesmo resultado de um flip flop T
    jkflipflop FF1(.q(q_out[0]), .q_n(qn_out[0]), .j(t_signal[0]), .k(t_signal[0]), .Clock(Clock), .Reset(Reset), .Preset(Preset));
    jkflipflop FF2(.q(q_out[1]), .q_n(qn_out[1]), .j(t_signal[1]), .k(t_signal[1]), .Clock(Clock), .Reset(Reset), .Preset(Preset));
    jkflipflop FF3(.q(q_out[2]), .q_n(qn_out[2]), .j(t_signal[2]), .k(t_signal[2]), .Clock(Clock), .Reset(Reset), .Preset(Preset));
    jkflipflop FF4(.q(q_out[3]), .q_n(qn_out[3]), .j(t_signal[3]), .k(t_signal[3]), .Clock(Clock), .Reset(Reset), .Preset(Preset));
    jkflipflop FF5(.q(q_out[4]), .q_n(qn_out[4]), .j(t_signal[4]), .k(t_signal[4]), .Clock(Clock), .Reset(Reset), .Preset(Preset));
    jkflipflop FF6(.q(q_out[5]), .q_n(qn_out[5]), .j(t_signal[5]), .k(t_signal[5]), .Clock(Clock), .Reset(Reset), .Preset(Preset));
    jkflipflop FF7(.q(q_out[6]), .q_n(qn_out[6]), .j(t_signal[6]), .k(t_signal[6]), .Clock(Clock), .Reset(Reset), .Preset(Preset));
    jkflipflop FF8(.q(q_out[7]), .q_n(qn_out[7]), .j(t_signal[7]), .k(t_signal[7]), .Clock(Clock), .Reset(Reset), .Preset(Preset));

    assign Q = q_out;

endmodule