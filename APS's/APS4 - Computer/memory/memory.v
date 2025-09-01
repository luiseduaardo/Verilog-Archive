`include "../lib/port_out8_sync.v"
`include "../lib/rom_128x8_sync.v"
`include "../lib/rw_96x8_sync.v"

/**
 * Módulo de memória externa com 256 endereços de 8 bits.
 *
 * Endereçamento (em hexadecimal):
 * 00-7F --> memória read-only, síncrona
 * 80-DF --> memória read-write, síncrona
 * E0-EF --> portas de output, síncronas
 * F0-FF --> portas de input, assíncronas
 */
module memory(
    output wire [7:0] port_out_00,
                      port_out_01,
                      port_out_02,
                      port_out_03,
                      port_out_04,
                      port_out_05,
                      port_out_06,
                      port_out_07,
                      port_out_08,
                      port_out_09,
                      port_out_10,
                      port_out_11,
                      port_out_12,
                      port_out_13,
                      port_out_14,
                      port_out_15,

    output reg  [7:0] data_out,

    input  wire [7:0] port_in_00,
                      port_in_01,
                      port_in_02,
                      port_in_03,
                      port_in_04,
                      port_in_05,
                      port_in_06,
                      port_in_07,
                      port_in_08,
                      port_in_09,
                      port_in_10,
                      port_in_11,
                      port_in_12,
                      port_in_13,
                      port_in_14,
                      port_in_15,

    input  wire [7:0] data_in, address,

    input  wire       clk, 
                      reset,
                      write
);
    
    wire [7:0] rom_out, rwm_out;

    rom_128x8_sync ROM (
        .data_out(rom_out),
        
        .address(address),

        .clk(clk)
    );

    rw_96x8_sync RWM (
        .data_out(rwm_out),
        
        .address(address),
        .data_in(data_in),

        .WE(write),
        .clk(clk)
    );

    port_out8_sync OUT (
        .port_out_00(port_out_00),
        .port_out_01(port_out_01),
        .port_out_02(port_out_02),
        .port_out_03(port_out_03),
        .port_out_04(port_out_04),
        .port_out_05(port_out_05),
        .port_out_06(port_out_06),
        .port_out_07(port_out_07),
        .port_out_08(port_out_08),
        .port_out_09(port_out_09),
        .port_out_10(port_out_10),
        .port_out_11(port_out_11),
        .port_out_12(port_out_12),
        .port_out_13(port_out_13),
        .port_out_14(port_out_14),
        .port_out_15(port_out_15),

        .address(address),
        .data_in(data_in),

        .write(write),
        .clk(clk),
        .reset(reset)
    );

    always @ (port_in_00, port_in_01, port_in_02, port_in_03,
              port_in_04, port_in_05, port_in_06, port_in_07,
              port_in_08, port_in_09, port_in_10, port_in_11,
              port_in_12, port_in_13, port_in_14, port_in_15,
              address,    rom_out,    rwm_out)
        begin: MUX
            case (address)
                8'hF0  : data_out = port_in_00;
                8'hF1  : data_out = port_in_01;
                8'hF2  : data_out = port_in_02;
                8'hF3  : data_out = port_in_03;
                8'hF4  : data_out = port_in_04;
                8'hF5  : data_out = port_in_05;
                8'hF6  : data_out = port_in_06;
                8'hF7  : data_out = port_in_07;
                8'hF8  : data_out = port_in_08;
                8'hF9  : data_out = port_in_09;
                8'hFA  : data_out = port_in_10;
                8'hFB  : data_out = port_in_11;
                8'hFC  : data_out = port_in_12;
                8'hFD  : data_out = port_in_13;
                8'hFE  : data_out = port_in_14;
                8'hFF  : data_out = port_in_15;
                default: data_out = address <= 127 ? rom_out : rwm_out;
            endcase
        end

endmodule