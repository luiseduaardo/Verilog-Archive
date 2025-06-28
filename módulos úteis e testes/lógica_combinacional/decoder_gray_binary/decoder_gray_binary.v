module decoder_gray_binary(
    input wire G2, G1, G0,
    output wire B2, B1, B0
);

    assign B2 = G2;
    assign B1 = G2 ^ G1;
    assign B0 = B1 ^ G0;

endmodule