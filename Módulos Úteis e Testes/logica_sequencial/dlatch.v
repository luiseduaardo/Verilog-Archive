`include "srlatch.v"

module dlatch(
    input D, St,
    output Q, Qn
);

    wire s_input, r_input;
    wire d_inverted;

    not(d_inverted, D);
    and(s_input, St, D);
    and(r_input, St, d_inverted);

    srlatch srlatch_instance (s_input, r_input, Q, Qn);

endmodule