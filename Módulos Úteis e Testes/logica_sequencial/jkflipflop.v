`include "../components_new.v"

module jkflipflop (
    output q, q_n,
    input  j, k,
    input  Clock,
    input  Reset, Preset  // active-low
);

    wire d_input;
    wire not_k;
    wire term1;
    wire term2;

    not (not_k, k);
    and (term1, j, q_n);
    and (term2, not_k, q);

    or (d_input, term1, term2);

    dflipflop dff_core_instance (
        .Q(q),
        .Qn(q_n),
        .Clock(Clock),
        .Reset(Reset),
        .Preset(Preset),
        .D(d_input)
    );

endmodule