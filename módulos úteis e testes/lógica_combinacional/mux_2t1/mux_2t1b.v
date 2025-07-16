module mux_2t1b (
    input A,
    input B,
    input Sel,
    output reg F
);

    always @(*) begin
        if (Sel == 1'b0)
            F = A;
        else
            F = B;
    end

endmodule
