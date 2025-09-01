// Conteúdo para rom_128x8_sync.v
module rom_128x8_sync (
    output reg [7:0] data_out,
    input wire [7:0] address,
    input wire clk
);
    reg[7:0] ROM[0:127];
    reg EN;
    
    // Loads and Stores
	parameter LDA_IMM = 8'h86; // Load Register A (Immediate Addressing)
	parameter LDA_DIR = 8'h87; // Load Register A from memory (RAM or IO) (Direct Addressing)
	parameter LDB_IMM = 8'h88; // Load Register B (Immediate Addressing)
	parameter LDB_DIR = 8'h89; // Load Register B from memory (RAM or IO) (Direct Addressing)
	parameter STA_DIR = 8'h96; // Store Register A to memory (RAM or IO)
	parameter STB_DIR = 8'h97; // Store Register B to memory (RAM or IO)
	 
	// Data Manipulations
	parameter ADD_AB  = 8'h42; // A <= A + B
	parameter SUB_AB  = 8'h43; // A <= A - B
	parameter AND_AB  = 8'h44; // A <= A & B
	parameter OR_AB   = 8'h45; // A <= A | B
	parameter INCA    = 8'h46; // A <= A + 1
	parameter INCB    = 8'h47; // B <= B + 1
	parameter DECA	   = 8'h48; // A <= A - 1
	parameter DECB    = 8'h49; // B <= B - 1
	parameter XOR_AB  = 8'h4A; // A <= A ^ B
	parameter NOTA	   = 8'h4B; // A <= ~A
	parameter NOTB    = 8'h4C; // B <= ~B
	 
	// Branches
	parameter BRA     = 8'h20; // Branch Always    to (ROM) Address
	parameter BMI     = 8'h21; // Branch if N == 1 to (ROM) Address
	parameter BPL     = 8'h22; // Branch if N == 0 to (ROM) Address
	parameter BEQ     = 8'h23; // Branch if Z == 1 to (ROM) Address
	parameter BNE	   = 8'h24; // Branch if Z == 0 to (ROM) Address
	parameter BVS	   = 8'h25; // Branch if V == 1 to (ROM) Address 
	parameter BVC     = 8'h26; // Branch if V == 0 to (ROM) Address
	parameter BCS     = 8'h27; // Branch if C == 1 to (ROM) Address
	parameter BCC     = 8'h28; // Branch if C == 0 to (ROM) Address

    initial begin // Subtrai X de 15 repetidamente até A < 0. Repete do começo após isso
        ROM[0] = LDA_IMM; // Carregamento imediato
        ROM[1] = 15;

		ROM[2] = LDB_DIR; // Carregamento direto
        ROM[3] = 8'hF0;
		
		ROM[4] = STA_DIR; // Armazenamento
		ROM[5] = 8'hE0;
        ROM[6] = SUB_AB; // Operação ALU -- manipulação

        ROM[7] = BMI; 	// Branch
        ROM[8] = 8'h00;

        ROM[9] = BRA; // Branch
        ROM[10] = 8'h04;
    end
    
    always @ (address) begin
        if (address <= 127) EN = 1'b1;
        else EN = 1'b0;
    end
    
    always @ (posedge clk) begin
        if (EN) data_out = ROM[address];
    end
endmodule