`include "../data_path/data_path.v"
`include "../control_unit/control_unit.v"

module cpu (
    output wire [7:0] address,
	                  to_memory,

	output wire       write,

	input  wire [7:0] from_memory,

    input  wire       clk, 
                      reset
);

    wire enIR, enMAR, 
         loadPC, enPC,
         loadA, loadB,
         enCCR;
        
    wire [7:0] outIR;

    wire [3:0] outCCR;

    wire [2:0] selALU;

    wire [1:0] selBUS1, selBUS2;

  	data_path DataPath (
        .to_memory(to_memory),
        .address(address),

        .IR_out(outIR),
        .CCR_Result(outCCR),

        .from_memory(from_memory),
        
        .ALU_Sel(selALU),

        .Bus1_Sel(selBUS1),
        .Bus2_Sel(selBUS2),

        .IR_Load(enIR),
        .MAR_Load(enMAR),
        .PC_Load(loadPC),
        .PC_Inc(enPC),
        .A_Load(loadA),
        .B_Load(loadB),
        .CCR_Load(enCCR),

        .clk(clk),
        .reset(reset)
    );

    control_unit ControlUnit (
        .ALU_Sel(selALU),

        .Bus1_Sel(selBUS1),
        .Bus2_Sel(selBUS2),

        .IR_Load(enIR),
        .MAR_Load(enMAR),
        .PC_Load(loadPC),
        .PC_Inc(enPC),
        .A_Load(loadA),
        .B_Load(loadB),
        .CCR_Load(enCCR),
        .write(write),

        .IR(outIR),
        .CCR_Result(outCCR),
        
        .clk(clk),
        .reset(reset)
    );

endmodule


