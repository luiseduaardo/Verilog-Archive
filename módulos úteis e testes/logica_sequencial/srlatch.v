module srlatch(
    input S, R,
    output Q, Qn
);

    wire Q_w, Qn_w;

    nor(Q_w, Qn_w, R);
    nor(Qn_w, Q_w, S);

    assign Q = Q_w;
    assign Qn = Qn_w;

endmodule