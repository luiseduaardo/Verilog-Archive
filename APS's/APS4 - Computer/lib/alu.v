/**
 * Unidade aritmética lógica de 8 bits com 2 entradas.
 *
 * É capaz de executar 4 tipos de operações aritméticas:
 * - a + b (soma)
 * - a + 1 (incremento)
 * - a - b (subtração)
 * - a - 1 (decremento)
 *
 * Também pode executar 4 tipos de operações lógicas:
 * - a and b
 * - a or b
 * - a xor b
 * - not a
 *
 * Retorna um resultado e 4 bit flags:
 * - N, indica quando o resultado representa um inteiro negativo
 * - Z, indica quando o resultado é zero
 * - V, indica se houve overflow e o resultado deve ser descartado (apenas para aritmética)
 * - C, indica o valor do carry-out de operações aritméticas
 */
module ALU8 (
    output  reg [7:0] result,
    output  reg       n, z, v, c,

    input  wire [7:0] a, b,
    input  wire [2:0] operation
);

    parameter ADD = 3'b000;
    parameter INC = 3'b001;
    parameter SUB = 3'b010;
    parameter DEC = 3'b011;
    parameter AND = 3'b100;
    parameter OR  = 3'b101;
    parameter XOR = 3'b110;
    parameter NOT = 3'b111;


    always @ (a, b, operation)
		begin
			case (operation)
				ADD: begin
							{c, result} = a + b;
							n = result[7];
							if (result==0)
								z = 1;
							else
								z = 0;
							if (a[7]==0 && b[7]==0 && result[7]==1) 
								v = 1;
							else if (a[7]==1 && b[7]==1 && result[7]==0)
								v = 1;
							else
								v = 0;
						end
				3'b001: begin
							{c, result} = a + 1;
							n = result[7];
							if (result==0)
								z = 1;
							else
								z = 0;
							if (a[7]==0 && result[7]==1) 
								v = 1;
							else
								v = 0;
						end	
				3'b010: begin
							{c, result} = a - b;
							n = result[7];
							if (result==0)
								z = 1;
							else
								z = 0;
							if (a[7]==0 && b[7]==1 && result[7]==1) 
								v = 1;
							else if (a[7]==1 && b[7]==0 && result[7]==0)
								v = 1;
							else 
								v = 0;
						end
				3'b011: begin
							{c, result} = a - 1;
							n = result[7];
							if (result==0)
								z = 1;
							else
								z = 0;
							if (a[7]==1 && result[7]==0) 
								v = 1;
							else 
								v = 0;          
						end	
				3'b100: begin
							result = a & b;
							n = result[7];
							if (result==0)
								z = 1;
							else
								z = 0;
							v = 0;
							c = 0;
						end
				3'b101: begin
							result = a | b;
							n = result[7];
							if (result==0)
								z = 1;
							else
								z = 0;
							v = 0;
							c = 0;
						end
				3'b110: begin
							result = a ^ b;
							n = result[7];
							if (result==0)
								z = 1;
							else
								z = 0;
							v = 0;
							c = 0;
						end
				3'b111: begin
							result = ~a;
							n = result[7];
							if (result==0)
								z = 1;
							else
								z = 0;
							v = 0;
							c = 0;
						end	
				default: begin
							result = 8'hXX;
							{n, z, v, c} = 4'hX; 
						end
				endcase	
		end	
    
endmodule