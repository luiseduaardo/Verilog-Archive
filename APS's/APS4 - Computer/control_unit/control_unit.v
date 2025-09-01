module control_unit (
    output reg  [2:0] ALU_Sel,
    output reg  [1:0] Bus1_Sel, 
                      Bus2_Sel,
    output reg        IR_Load,
                      MAR_Load,
                      PC_Load, PC_Inc,
                      A_Load, B_Load,
                      CCR_Load,
                      write,

    input  wire [7:0] IR,
    input  wire [3:0] CCR_Result,
    input  wire       clk, 
                      reset
);

	// Operações da ALU
	parameter ADD = 3'b000;
    parameter INC = 3'b001;
    parameter SUB = 3'b010;
    parameter DEC = 3'b011;
    parameter AND = 3'b100;
    parameter OR  = 3'b101;
    parameter XOR = 3'b110;
    parameter NOT = 3'b111;

    // Códigos de operação (opcodes)
    // Loads and Stores
    parameter LDA_IMM = 8'h86; // Carregar registrador A (endereçamento imediato)
    parameter LDA_DIR = 8'h87; // Carregar registrador A da memória (endereçamento direto)
    parameter LDB_IMM = 8'h88; // Carregar registrador B (endereçamento imediato)
    parameter LDB_DIR = 8'h89; // Carregar registrador B da memória (endereçamento direto)
    parameter STA_DIR = 8'h96; // Armazenar registrador A na memória (endereçamento direto)
    parameter STB_DIR = 8'h97; // Armazenar registrador B na memória (endereçamento direto)
     
    // Operações de manipulação de dados
    parameter ADD_AB  = 8'h42; // A <= A + B
    parameter SUB_AB  = 8'h43; // A <= A - B
    parameter AND_AB  = 8'h44; // A <= A & B
    parameter OR_AB   = 8'h45; // A <= A | B
    parameter INCA    = 8'h46; // A <= A + 1
    parameter INCB    = 8'h47; // B <= B + 1
    parameter DECA    = 8'h48; // A <= A - 1
    parameter DECB    = 8'h49; // B <= B - 1
    parameter XOR_AB  = 8'h4A; // A <= A ^ B
    parameter NOTA    = 8'h4B; // A <= ~A
    parameter NOTB    = 8'h4C; // B <= ~B
     
    // Instruções de desvio (branches)
    parameter BRA     = 8'h20; // Desvio incondicional
    parameter BMI     = 8'h21; // Desvio se N == 1
    parameter BPL     = 8'h22; // Desvio se N == 0
    parameter BEQ     = 8'h23; // Desvio se Z == 1
    parameter BNE     = 8'h24; // Desvio se Z == 0
    parameter BVS     = 8'h25; // Desvio se V == 1
    parameter BVC     = 8'h26; // Desvio se V == 0
    parameter BCS     = 8'h27; // Desvio se C == 1
    parameter BCC     = 8'h28; // Desvio se C == 0

    // Definição dos microestados
    parameter FETCH_0 = 0,
              FETCH_1 = 1,
              FETCH_2 = 2,
              DECODE  = 3,

              /* LDA_IMM */
              LDA_IMM_0 = 4,
              LDA_IMM_1 = 5,
              LDA_IMM_2 = 6,
              LDB_IMM_0 = 104,
              LDB_IMM_1 = 105,
              LDB_IMM_2 = 106,

              /* LDA_DIR */
              LDA_DIR_0 = 7,
              LDA_DIR_1 = 8,
              LDA_DIR_2 = 9,
              LDA_DIR_3 = 10,
              LDA_DIR_4 = 11,
              LDB_DIR_0 = 107,
              LDB_DIR_1 = 108,
              LDB_DIR_2 = 109,
              LDB_DIR_3 = 110,
              LDB_DIR_4 = 111,

              /* STA_DIR */
              STA_DIR_0 = 12,
              STA_DIR_1 = 13,
              STA_DIR_2 = 14,
              STA_DIR_3 = 15,
              STB_DIR_0 = 112,
              STB_DIR_1 = 113,
              STB_DIR_2 = 114,
              STB_DIR_3 = 115,

              /* ALU */
              ADD_0     = 16,
              ADD_1     = 17,

			  INC_0     = 18,
              INC_1     = 19,

			  INC_B     = 20,

              SUB_0     = 23,
              SUB_1     = 24,

			  DEC_0     = 25,
              DEC_1     = 26,

			  DEC_B     = 27,

			  AND_0     = 30,
              AND_1     = 31,

			  OR_0      = 32,
              OR_1      = 33,

			  XOR_0     = 34,
              XOR_1     = 35,

			  NOT_0     = 36,
              NOT_1     = 37,

			  NOT_B     = 38,

			  /* BRA */
              BRA_0 = 39,
              BRA_1 = 40,
              BRA_2 = 140,

			  /* BMI */
              BMI_0 = 41,
              BMI_1 = 42,
              BMI_2 = 142,

			  /* BPL */
              BPL_0 = 43,
              BPL_1 = 44,
              BPL_2 = 144,

			  /* BEQ */
              BEQ_0 = 45,
              BEQ_1 = 46,
              BEQ_2 = 146,

			  /* BNE */
              BNE_0 = 49,
              BNE_1 = 50,
              BNE_2 = 150,

			  /* BVS */
              BVS_0 = 51,
              BVS_1 = 52,
              BVS_2 = 152,
			  
			  /* BVC */
              BVC_0 = 53,
              BVC_1 = 54,
              BVC_2 = 154,

			  /* BCS */
              BCS_0 = 55,
              BCS_1 = 56,
              BCS_2 = 156,

			  /* BCC */
              BCC_0 = 57,
              BCC_1 = 58,
              BCC_2 = 158;
              // Os estados para outras instruções (LDB, STB, AND, OR, NOT, Branches)
              // precisariam ser adicionados aqui se fossem implementados.

    reg [7:0] current_state, next_state; // Registradores para o estado atual e próximo

    // Estado inicial e valores padrão
    initial
    begin: INITIAL_STATE
        current_state = FETCH_0;
        next_state = FETCH_0;
        // Reinicia todos os sinais de controle para um estado seguro
        IR_Load = 0;
        MAR_Load = 1; // MAR inicialmente carregado com PC (para FETCH_0)
        PC_Load = 0;
        PC_Inc = 0;
        A_Load = 0;
        B_Load = 0;
        CCR_Load = 0;
        ALU_Sel = 3'b000; // Seleção padrão para ALU
        Bus1_Sel = 2'b00; // PC no Bus1 por padrão (para FETCH_0)
        Bus2_Sel = 2'b01; // Bus2 do ALU por padrão (não usado em FETCH_0 diretamente)
        write = 0;
    end

    // Memória de estados (registrador de estado)
    // Atualiza o estado atual no flanco de subida do clock ou no reset assíncrono
    always @ (posedge clk or negedge reset)
    begin: STATE_MEMORY
        if (!reset) // Reset assíncrono (ativo em nível baixo)
            current_state <= FETCH_0;
        else
            current_state <= next_state; // Transita para o próximo estado
    end

    // Lógica de próximo estado (sequenciador de microinstruções)
    // Determina o próximo estado com base no estado atual e no opcode (IR)
    always @ (current_state or IR)
    begin: NEXT_STATE_LOGIC
        case (current_state)
            // Sequência de busca do opcode
            FETCH_0   : next_state = FETCH_1; // PC -> MAR
            FETCH_1   : next_state = FETCH_2; // Incrementa PC
            FETCH_2   : next_state = DECODE;  // Memória -> IR

            // Decodificação da instrução
            DECODE    : begin
                            case (IR)
                                LDA_IMM: next_state = LDA_IMM_0; // Carregar imediato em A
                                LDA_DIR: next_state = LDA_DIR_0; // Carregar direto em A
                                LDB_IMM: next_state = LDB_IMM_0; // LDB_IMM pode reutilizar a sequência de LDA_IMM se o hardware for genérico
                                LDB_DIR: next_state = LDB_DIR_0; // LDB_DIR pode reutilizar a sequência de LDA_DIR
                                STA_DIR: next_state = STA_DIR_0; // Armazenar A direto
                                STB_DIR: next_state = STB_DIR_0; // STB_DIR pode reutilizar a sequência de STA_DIR
                                ADD_AB : next_state = ADD_0;     // Somar A e B
                                SUB_AB : next_state = SUB_0;     // Subtrair A e B
                                AND_AB : next_state = AND_0;     // Reutilizar estados de operação (assumindo hardware semelhante)
                                OR_AB  : next_state = OR_0;
                                INCA   : next_state = INC_0;     // INCA/INCB pode ser feito com ADD_AB com um operando sendo 1
                                INCB   : next_state = INC_B;
                                DECA   : next_state = DEC_0;     // DECA/DECB pode ser feito com SUB_AB com um operando sendo 1
                                DECB   : next_state = DEC_B;
                                XOR_AB : next_state = XOR_0;
                                NOTA   : next_state = NOT_0;     // NOTA/NOTB pode ser feito com uma operação ALU dedicada
                                NOTB   : next_state = NOT_B;
                                BRA    : next_state = BRA_0; // Desvio incondicional (carrega endereço no PC)
                                BMI    : next_state = BMI_0; // Desvio condicional (precisa de lógica no OUTPUT_LOGIC para verificar CCR_Result)
                                BPL    : next_state = BPL_0;
                                BEQ    : next_state = BEQ_0;
                                BNE    : next_state = BNE_0;
                                BVS    : next_state = BVS_0;
                                BVC    : next_state = BVC_0;
                                BCS    : next_state = BCS_0;
                                BCC    : next_state = BCC_0;
                                default: next_state = FETCH_0;   // Se a instrução não for reconhecida, volta para busca
                            endcase
                        end

            /* LDA_IMM: carregar imediato em A */
            LDA_IMM_0 : next_state = LDA_IMM_1; // Colocar PC no MAR para buscar operando
            LDA_IMM_1 : next_state = LDA_IMM_2; // Incrementar PC
            LDA_IMM_2 : next_state = FETCH_0;   // Carregar dado e voltar para busca

            /* LDA_DIR: buscar endereço e depois dado da memória */
            LDA_DIR_0 : next_state = LDA_DIR_1; // PC -> MAR para buscar byte de endereço
            LDA_DIR_1 : next_state = LDA_DIR_2; // Incrementar PC
            LDA_DIR_2 : next_state = LDA_DIR_3; // Carregar byte de endereço no MAR
            LDA_DIR_3 : next_state = LDA_DIR_4; // Ler memória no endereço final para A
            LDA_DIR_4 : next_state = FETCH_0;   // Voltar para busca

            /* STA_DIR: buscar endereço e gravar A na memória */
            STA_DIR_0 : next_state = STA_DIR_1; // PC -> MAR (endereço para buscar o endereço de destino)
            STA_DIR_1 : next_state = STA_DIR_2; // Incrementar PC
            STA_DIR_2 : next_state = STA_DIR_3; // Dado do Bus2 (endereço) -> MAR
            STA_DIR_3 : next_state = FETCH_0;   // Gravar A na memória e voltar para busca

            /* LDB_IMM: carregar imediato em B */
            LDB_IMM_0 : next_state = LDB_IMM_1; // Colocar PC no MBR para buscar operando
            LDB_IMM_1 : next_state = LDB_IMM_2; // Incrementar PC
            LDB_IMM_2 : next_state = FETCH_0;   // Carregar dado e voltar para busca

            /* LDB_DIR: buscar endereço e depois dado da memória */
            LDB_DIR_0 : next_state = LDB_DIR_1; // PC -> MBR para buscar byte de endereço
            LDB_DIR_1 : next_state = LDB_DIR_2; // Incrementar PC
            LDB_DIR_2 : next_state = LDB_DIR_3; // Carregar byte de endereço no MBR
            LDB_DIR_3 : next_state = LDB_DIR_4; // Ler memória no endereço final para B
            LDB_DIR_4 : next_state = FETCH_0;   // Voltar para busca

            /* STB_DIR: buscar endereço e gravar B na memória */
            STB_DIR_0 : next_state = STB_DIR_1; // PC -> MBR (endereço para buscar o endereço de destino)
            STB_DIR_1 : next_state = STB_DIR_2; // Incrementar PC
            STB_DIR_2 : next_state = STB_DIR_3; // Dado do Bus2 (endereço) -> MBR
            STB_DIR_3 : next_state = FETCH_0;   // Gravar B na memória e voltar para busca

            /* ADD */
            ADD_0     : next_state = ADD_1;     // Realizar operação
            ADD_1     : next_state = FETCH_0;   // Carregar resultado e flags, voltar para busca

			/* INC */
            INC_0     : next_state = INC_1;
            INC_1     : next_state = FETCH_0;
			INC_B     : next_state = INC_0;

            /* SUB */
            SUB_0     : next_state = SUB_1;
            SUB_1     : next_state = FETCH_0;

			/* DEC */
            DEC_0     : next_state = DEC_1;
            DEC_1     : next_state = FETCH_0;
			DEC_B     : next_state = DEC_0;
			
			/* ADD */
            AND_0     : next_state = AND_1;
            AND_1     : next_state = FETCH_0;
			
			/* OR */
            OR_0      : next_state = OR_1;
            OR_1      : next_state = FETCH_0;
			
			/* XOR */
            XOR_0     : next_state = XOR_1;
            XOR_1     : next_state = FETCH_0;
			
			/* NOT */
            NOT_0     : next_state = NOT_1;
            NOT_1     : next_state = FETCH_0;
			NOT_B     : next_state = NOT_0;

			/* BRA */
            BRA_0     : next_state = BRA_1;     // Fazer pulo
            BRA_1     : next_state = BRA_2;     // Carregar resultado e flags
            BRA_2     : next_state = FETCH_0;   // voltar para busca

			/* BMI */
            BMI_0     : next_state = BMI_1;
            BMI_1     : next_state = BMI_2;
            BMI_2     : next_state = FETCH_0;

			/* BPL */
            BPL_0     : next_state = BPL_1;
            BPL_1     : next_state = BPL_2;
            BPL_2     : next_state = FETCH_0;

			/* BEQ */
            BEQ_0     : next_state = BEQ_1;
            BEQ_1     : next_state = BEQ_2;
            BEQ_2     : next_state = FETCH_0;
			
			/* BNE */
            BNE_0     : next_state = BNE_1;
            BNE_1     : next_state = BNE_2;
            BNE_2     : next_state = FETCH_0;

			/* BVS */
            BVS_0     : next_state = BVS_1;
            BVS_1     : next_state = BVS_2;
            BVS_2     : next_state = FETCH_0;

			/* BVC */
            BVC_0     : next_state = BVC_1;
            BVC_1     : next_state = BVC_2;
            BVC_2     : next_state = FETCH_0;

			/* BCS */
            BCS_0     : next_state = BCS_1;
            BCS_1     : next_state = BCS_2;
            BCS_2     : next_state = FETCH_0;

			/* BCC */
            BCC_0     : next_state = BCC_1;
            BCC_1     : next_state = BCC_2;
            BCC_2     : next_state = FETCH_0;

            default   : next_state = FETCH_0;   // Estado padrão, volta para busca
        endcase
    end

    // Lógica de saída (micro-operações para cada estado)
    // Ativa os sinais de controle com base no estado atual e nas condições (CCR_Result)
    always @ (current_state or CCR_Result or IR)
            begin: OUTPUT_LOGIC
                // Valores padrão (seguros): desativa todos os sinais de controle
                IR_Load = 0;
                MAR_Load = 0;
                PC_Load = 0;
                PC_Inc = 0;
                A_Load = 0;
                B_Load = 0;
                CCR_Load = 0;
                write = 0;

                case (current_state)

                    /* FETCH 0: Colocar PC no MAR (endereço da instrução) */
                    FETCH_0 : 
                        begin
                            MAR_Load = 1;      // Habilita o carregamento do MAR
                            ALU_Sel = 3'b000;  // Nenhuma operação ALU por padrão
                            Bus1_Sel = 2'b00;  // Seleciona o PC para o Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    /* FETCH 1: Incrementar PC */
                    FETCH_1 : 
                        begin
                            PC_Inc = 1;        // Habilita o incremento do PC
                        end

                    /* FETCH 2: Ler memória no MAR para IR (opcode) */
                    FETCH_2 :
                        begin
                            IR_Load = 1;       // Habilita o carregamento do IR
                            Bus2_Sel = 2'b10;  // Seleciona a saída da memória para o Bus2
                        end

                    /* DECODE: nenhuma ação explícita aqui, apenas transição de estado */
                    DECODE :
                        begin
                            Bus1_Sel = 2'b00;
                            Bus2_Sel = 2'b00;
                            // A lógica de controle para DECODE é principalmente na transição do next_state
                        end

                    /* LDA_IMM: carregar imediato em A */
                    LDA_IMM_0 :
                        begin
                            MAR_Load = 1;      // PC -> MAR (para buscar o operando)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    LDA_IMM_1 :
                        begin
                            PC_Inc = 1;        // Incrementar PC para a próxima instrução
                        end

                    LDA_IMM_2 :
                        begin
                            A_Load = 1;        // Carregar dado da memória em A
                            Bus2_Sel = 2'b10;  // Selecionar a saída da memória para o Bus2
                        end

                    /* LDA_DIR: endereçamento direto */
                    LDA_DIR_0 :
                        begin
                            MAR_Load = 1;      // PC -> MAR (endereço do operando, que é o endereço do dado)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    LDA_DIR_1 :
                        begin
                            PC_Inc = 1;        // Incrementa PC
                            
                        end

                    LDA_DIR_2 :
                        begin
                            MAR_Load = 1;      // Conteúdo da memória (endereço real do dado) -> MAR
                            Bus2_Sel = 2'b10;  // Seleciona a saída da memória para o Bus2
                        end

                    LDA_DIR_3 :
                        begin
                            // Esperando saída do MAR ser lida na memória e sua saída ser atualizada
                        end

                    LDA_DIR_4 :
                        begin
							A_Load = 1;        // Carrega dado da memória (endereço real) em A
                            Bus2_Sel = 2'b10;  // Seleciona a saída da memória para o Bus2
                        end

                    /* STA_DIR: armazenar A */
                    STA_DIR_0 :
                        begin
                            MAR_Load = 1;      // PC -> MAR (endereço para buscar o endereço de destino)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    STA_DIR_1 :
                        begin
                            PC_Inc = 1;        // Incrementar PC
                        end

                    STA_DIR_2 :
                        begin
                            MAR_Load = 1;      // Dado da memória (endereço de destino) -> MAR
                            Bus2_Sel = 2'b10;  // Seleciona a saída da memória para o Bus2
                        end

                    STA_DIR_3 :
                        begin
                            write = 1;         // Habilita a escrita na memória
                            Bus1_Sel = 2'b01;  // Registrador A no Bus1 para ser gravado
                        end

                    /* LDB_IMM: carregar imediato em B */
                    LDB_IMM_0 :
                        begin
                            MAR_Load = 1;      // PC -> MBR (para buscar o operando)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    LDB_IMM_1 :
                        begin
                            PC_Inc = 1;        // Incrementar PC para a próxima instrução
                        end

                    LDB_IMM_2 :
                        begin
                            B_Load = 1;        // Carregar dado da memória em B
                            Bus2_Sel = 2'b10;  // Selecionar a saída da memória para o Bus2
                        end

                    /* LDB_DIR: endereçamento direto */
                    LDB_DIR_0 :
                        begin
                            MAR_Load = 1;      // PC -> MBR (endereço do operando, que é o endereço do dado)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    LDB_DIR_1 :
                        begin
                            PC_Inc = 1;        // Incrementa PC
                        end

                    LDB_DIR_2 :
                        begin
                            MAR_Load = 1;      // Conteúdo da memória (endereço real do dado) -> MBR
                            Bus2_Sel = 2'b10;  // Seleciona a saída da memória para o Bus2
                        end

                    LDB_DIR_3 :
                        begin
                            // Esperando saída do MBR ser lida na memória e sua saída ser atualizada
                        end

                    LDB_DIR_4 :
                        begin
							B_Load = 1;        // Carrega dado da memória (endereço real) em B
                            Bus2_Sel = 2'b10;  // Seleciona a saída da memória para o Bus2
                        end

                    /* STB_DIR: armazenar B */
                    STB_DIR_0 :
                        begin
                            MAR_Load = 1;      // PC -> MBR (endereço para buscar o endereço de destino)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    STB_DIR_1 :
                        begin
                            PC_Inc = 1;        // Incrementar PC
                        end

                    STB_DIR_2 :
                        begin
                            MAR_Load = 1;      // Dado da memória (endereço de destino) -> MBR
                            Bus2_Sel = 2'b10;  // Seleciona a saída da memória para o Bus2
                        end

                    STB_DIR_3 :
                        begin
                            write = 1;         // Habilita a escrita na memória
                            Bus1_Sel = 2'b01;  // Registrador B no Bus1 para ser gravado
                        end

                    /* ADD_AB */
                    ADD_0 :
                        begin
                            ALU_Sel = ADD;     // Seleciona a operação de ADIÇÃO na ALU
                            Bus1_Sel = 2'b10;  // Registrador B no Bus1 -- o registrador A já está conectado à entrada A da ALU conforme nosso data_path
                        end

                    ADD_1 :
                        begin
							Bus2_Sel = 2'b00;  // Saída da ALU no Bus2
                            A_Load = 1;        // Carrega o resultado da ALU (A+B) em A
                            CCR_Load = 1;      // Carrega o resultado da ALU no CCR
                        end

					/* INC_A */
                    INC_0 :
                        begin
                            ALU_Sel = INC;     // Seleciona a operação de INCREMENTO na ALU
                        end

                    INC_1 :
                        begin
							Bus2_Sel = 2'b00;  // Saída da ALU no Bus2
                            A_Load = 1;        // Carrega o resultado da ALU (A+1) em A
                            CCR_Load = 1;      // Carrega o resultado da ALU no CCR
                        end

					/* INC_B */
                    INC_B :
                        begin
							A_Load = 1;		   // Transfere o valor de B para o registrador A
                            Bus1_Sel = 2'b10;  // Registrador B no Bus1
							Bus2_Sel = 2'b01;  // Bus1 em Bus2
							// Depois disso, faz os passos de INC_A
                        end

                    /* SUB_AB */
                    SUB_0 :
                        begin
                            ALU_Sel = SUB;     // Seleciona a operação de SUBTRAÇÃO na ALU
                            Bus1_Sel = 2'b10;  // Registrador B no Bus1 -- o registrador A já está conectado à entrada A da ALU conforme nosso data_path
                        end

                    SUB_1 :
                        begin
                            Bus2_Sel = 2'b00;  // Saída da ALU no Bus2
                            A_Load = 1;        // Carrega o resultado da ALU (A-B) em A
                            CCR_Load = 1;      // Carrega o resultado da ALU no CCR
                        end

					/* DEC_A */
                    DEC_0 :
                        begin
                            ALU_Sel = DEC;     // Seleciona a operação de DECREMENTO na ALU
                        end

                    DEC_1 :
                        begin
							Bus2_Sel = 2'b00;  // Saída da ALU no Bus2
                            A_Load = 1;        // Carrega o resultado da ALU (A-1) em A
                            CCR_Load = 1;      // Carrega o resultado da ALU no CCR
                        end

					/* DEC_B */
                    DEC_B :
                        begin
							A_Load = 1;		   // Transfere o valor de B para o registrador A
                            Bus1_Sel = 2'b10;  // Registrador B no Bus1
							Bus2_Sel = 2'b01;  // Bus1 em Bus2
							// Depois disso, faz os passos de DEC_A
                        end

					/* AND_AB */
                    AND_0 :
                        begin
                            ALU_Sel = AND;     // Seleciona a operação de AND na ALU
                            Bus1_Sel = 2'b10;  // Registrador B no Bus1 -- o registrador A já está conectado à entrada A da ALU conforme nosso data_path
                        end

                    AND_1 :
                        begin
							Bus2_Sel = 2'b00;  // Saída da ALU no Bus2
                            A_Load = 1;        // Carrega o resultado da ALU (A*B) em A
                            CCR_Load = 1;      // Carrega o resultado da ALU no CCR
                        end

					/* OR_AB */
                    OR_0  :
                        begin
                            ALU_Sel = OR;      // Seleciona a operação de OR na ALU
                            Bus1_Sel = 2'b10;  // Registrador B no Bus1 -- o registrador A já está conectado à entrada A da ALU conforme nosso data_path
                        end

                    OR_1  :
                        begin
							Bus2_Sel = 2'b00;  // Saída da ALU no Bus2
                            A_Load = 1;        // Carrega o resultado da ALU (A|B) em A
                            CCR_Load = 1;      // Carrega o resultado da ALU no CCR
                        end

					/* XOR_AB */
                    XOR_0  :
                        begin
                            ALU_Sel = XOR;     // Seleciona a operação de XOR na ALU
                            Bus1_Sel = 2'b10;  // Registrador B no Bus1 -- o registrador A já está conectado à entrada A da ALU conforme nosso data_path
                        end

                    XOR_1  :
                        begin
							Bus2_Sel = 2'b00;  // Saída da ALU no Bus2
                            A_Load = 1;        // Carrega o resultado da ALU (A^B) em A
                            CCR_Load = 1;      // Carrega o resultado da ALU no CCR
                        end

					/* NOT_A */
                    NOT_0 :
                        begin
                            ALU_Sel = NOT;     // Seleciona a operação de NOT na ALU
                        end

                    NOT_1 :
                        begin
							Bus2_Sel = 2'b00;  // Saída da ALU no Bus2
                            A_Load = 1;        // Carrega o resultado da ALU (!A) em A
                            CCR_Load = 1;      // Carrega o resultado da ALU no CCR
                        end

					/* NOT_B */
                    NOT_B :
                        begin
							A_Load = 1;		   // Transfere o valor de B para o registrador A
                            Bus1_Sel = 2'b10;  // Registrador B no Bus1
							Bus2_Sel = 2'b01;  // Bus1 em Bus2
							// Depois disso, faz os passos de NOT_A
                        end

					/* BRANCH ALWAYS */
                    BRA_0 :
                        begin
                            MAR_Load = 1;      // PC -> MAR (endereço do operando, que é o novo valor do PC)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    BRA_1 :
                        begin
                            //...
                        end
                        
                    BRA_2 :
                        begin
                            PC_Load = 1;
                            PC_Inc = 1;
                            Bus2_Sel = 2'b10;  // Seleciona a saída da memória para o Bus2
                        end

					/* BRANCH IF N == 1 */
                    BMI_0 :
                        begin
                            MAR_Load = 1;      // PC -> MAR (endereço do operando, que é o novo valor do PC)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end
                        
                    BMI_1 :
                        begin
                            // Esperando
                        end

                    BMI_2 :
                        begin
                            PC_Inc = 1;

							if (CCR_Result[3] == 1) // N == 1
								PC_Load = 1;        // Conteúdo da memória (novo valor do PC) -> PC
                            	Bus2_Sel = 2'b10;   // Seleciona a saída da memória para o Bus2
                        end

					/* BRANCH IF N == 0 */
                    BPL_0 :
                        begin
                            MAR_Load = 1;      // PC -> MAR (endereço do operando, que é o novo valor do PC)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    BPL_1 :
                        begin
                            // Esperando
                        end

                    BPL_2 :
                        begin
                            PC_Inc = 1;

							if (CCR_Result[3] == 0) // N == 0
								PC_Load = 1;        // Conteúdo da memória (novo valor do PC) -> PC
                            	Bus2_Sel = 2'b10;   // Seleciona a saída da memória para o Bus2
                        end
					
					/* BRANCH IF Z == 1 */
                    BEQ_0 :
                        begin
                            MAR_Load = 1;      // PC -> MAR (endereço do operando, que é o novo valor do PC)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    BEQ_1 :
                        begin
                            // Esperando
                        end

                    BEQ_2 :
                        begin
                            PC_Inc = 1;

							if (CCR_Result[2] == 1) // Z == 1
								PC_Load = 1;        // Conteúdo da memória (novo valor do PC) -> PC
                            	Bus2_Sel = 2'b10;   // Seleciona a saída da memória para o Bus2
                        end
					
					/* BRANCH IF Z == 0 */
                    BNE_0 :
                        begin
                            MAR_Load = 1;      // PC -> MAR (endereço do operando, que é o novo valor do PC)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    BNE_1 :
                        begin
                            // Esperando
                        end

                    BNE_2 :
                        begin
                            PC_Inc = 1;

							if (CCR_Result[2] == 0) // Z == 0
								PC_Load = 1;        // Conteúdo da memória (novo valor do PC) -> PC
                            	Bus2_Sel = 2'b10;   // Seleciona a saída da memória para o Bus2
                        end
					
					/* BRANCH IF V == 1 */
                    BVS_0 :
                        begin
                            MAR_Load = 1;      // PC -> MAR (endereço do operando, que é o novo valor do PC)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    BVS_1 :
                        begin
                            // Esperando
                        end
                        
                    BVS_2 :
                        begin
                            PC_Inc = 1;

							if (CCR_Result[1] == 1) // V == 1
								PC_Load = 1;        // Conteúdo da memória (novo valor do PC) -> PC
                            	Bus2_Sel = 2'b10;   // Seleciona a saída da memória para o Bus2
                        end
					
					/* BRANCH IF V == 0 */
                    BVC_0 :
                        begin
                            MAR_Load = 1;      // PC -> MAR (endereço do operando, que é o novo valor do PC)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    BVC_1 :
                        begin
                            // Esperando
                        end

                    BVC_2 :
                        begin
                            PC_Inc = 1;

							if (CCR_Result[1] == 0) // V == 0
								PC_Load = 1;        // Conteúdo da memória (novo valor do PC) -> PC
                            	Bus2_Sel = 2'b10;   // Seleciona a saída da memória para o Bus2
                        end
					
					/* BRANCH IF C == 1 */
                    BCS_0 :
                        begin
                            MAR_Load = 1;      // PC -> MAR (endereço do operando, que é o novo valor do PC)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end
                    
                    BCS_1 :
                        begin
                            // Esperando
                        end

                    BCS_2 :
                        begin
                            PC_Inc = 1;

							if (CCR_Result[0] == 1) // C == 1
								PC_Load = 1;        // Conteúdo da memória (novo valor do PC) -> PC
                            	Bus2_Sel = 2'b10;   // Seleciona a saída da memória para o Bus2
                        end
					
					/* BRANCH IF C == 0 */
                    BCC_0 :
                        begin
                            MAR_Load = 1;      // PC -> MAR (endereço do operando, que é o novo valor do PC)
                            Bus1_Sel = 2'b00;  // PC no Bus1
							Bus2_Sel = 2'b01;  // Seleciona o Bus1 para o Bus2
                        end

                    BCC_1 :
                        begin
                            // Esperando
                        end

                    BCC_2 :
                        begin
                            PC_Inc = 1;

							if (CCR_Result[0] == 0) // C == 0
								PC_Load = 1;        // Conteúdo da memória (novo valor do PC) -> PC
                            	Bus2_Sel = 2'b10;   // Seleciona a saída da memória para o Bus2
                        end

                    default: begin
                                    // Estado inválido, garante que todos os sinais de controle estejam desativados
                             end
                endcase
            end

endmodule