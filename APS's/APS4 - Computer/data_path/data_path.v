`include "../lib/counter.v"
`include "../lib/register.v"
`include "../lib/alu.v"

/**
 * Módulo do "data path" interno à CPU, com registros internos e "data bus" de 8 bits.
 *
 * Possui 6 elementos:
 * - Registro de Instruções (IR)
 * - Registro de Endereços de Memória (MAR)
 * - Contador de Programas (PC)
 * - Registros A e B, usados para rapidamente guardar dados intermediários
 * - Unidade Aritmética-Lógica (ALU)
 * - Registro de Código de Condições (CCR)
 */
module data_path (
    output reg  [7:0] to_memory,

    output wire [7:0] address,
                      IR_out,

	output wire [3:0] CCR_Result,

    input  wire [7:0] from_memory,
    
    input  wire [2:0] ALU_Sel,

	input  wire [1:0] Bus1_Sel,
                      Bus2_Sel,

	input  wire       IR_Load, 
                      MAR_Load,
                      PC_Load,
                      PC_Inc,
                      A_Load,
                      B_Load,
                      CCR_Load,

                      clk, 
                      reset
);

    reg [7:0] bus_1, bus_2;
    
    wire [3:0] NZVC;

    wire [7:0] PC_out, 
               A_out, 
               B_out,
               ALU_Result;

    REG8 IR (
        .reg_out(IR_out), 
        .reg_in(bus_2),

        .enable(IR_Load),
        .clk(clk),
        .reset(reset)
    );

    REG8 MAR (
        .reg_out(address), 
        .reg_in(bus_2),

        .enable(MAR_Load),
        .clk(clk),
        .reset(reset)
    );

    CNT8 PC (
        .count(PC_out),

        .count_in(bus_2),

        .load(PC_Load),
        .enable(PC_Inc),
        .clk(clk),
        .reset(reset)
    );

    REG8 A (
        .reg_out(A_out), 
        .reg_in(bus_2),

        .enable(A_Load),
        .clk(clk),
        .reset(reset)
    );

    REG8 B (
        .reg_out(B_out), 
        .reg_in(bus_2),

        .enable(B_Load),
        .clk(clk),
        .reset(reset)
    );

    REG4 CCR (
        .reg_out(CCR_Result), 
        .reg_in(NZVC),

        .enable(CCR_Load),
        .clk(clk),
        .reset(reset)
    );

    ALU8 ALU (
        .result(ALU_Result),
        
        .n(NZVC[3]),
        .z(NZVC[2]),
        .v(NZVC[1]),
        .c(NZVC[0]),

        .a(A_out),
        .b(bus_1),
        .operation(ALU_Sel)
    );

    always @ (Bus1_Sel, PC_out, A_out, B_out) 
     	begin: MUX_BUS1
            case (Bus1_Sel)
                2'b00   : bus_1 = PC_out;
				2'b01   : bus_1 = A_out;
				2'b10   : bus_1 = B_out; 
				default : bus_1 = 8'hXX;
            endcase
		end

    always @ (Bus2_Sel, ALU_Result, bus_1, from_memory) 
		begin: MUX_BUS2
			case (Bus2_Sel)
				2'b00   : bus_2 = ALU_Result;
				2'b01   : bus_2 = bus_1;
				2'b10   : bus_2 = from_memory; 
				default : bus_2 = 8'hXX;
			endcase 
		end
    
    always @ (bus_1) 
	 	begin
			to_memory = bus_1;
		end

endmodule