/** 
 * Registro de 4 bits com reset assíncrono.
 */
module REG4 (
    output reg  [3:0] reg_out,

    input  wire [3:0] reg_in,

    input  wire       enable,
                      clk,
                      reset
);
    
    always @ (posedge clk or negedge reset) 
        begin
            if (!reset)
                reg_out <= 4'h0;
            else if (enable)
                reg_out <= reg_in;
        end

endmodule


/**
 * Registro de 8 bits com reset assíncrono.
 */
module REG8 (
    output reg  [7:0] reg_out,

    input  wire [7:0] reg_in,

    input  wire       enable,
                      clk,
                      reset
);
    
    always @ (posedge clk or negedge reset) 
        begin
            if (!reset)
                reg_out <= 8'h00;
            else if (enable)
                reg_out <= reg_in;
        end

endmodule