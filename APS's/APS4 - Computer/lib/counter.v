/** Contador de 8 bits com reset assíncrono. */
module CNT8 (
    output reg  [7:0] count,

    input  wire [7:0] count_in,

    input  wire       load,
                      enable,
                      clk,
                      reset
);

    initial 
        begin
            count = 8'h00;
        end

    always @ (posedge clk or negedge reset) 
        begin
            if (!reset)
                count <= 8'h00;
            else if (enable)
                count <= load ? count_in : count + 1;
        end

endmodule