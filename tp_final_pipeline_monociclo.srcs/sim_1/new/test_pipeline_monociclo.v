`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2020 20:17:18
// Design Name: 
// Module Name: test_pipeline_monociclo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module test_pipeline_monociclo;
// Inputs
    reg Clk;
    reg Latch_Reset;
    reg Latch_enable;
    //Etapa IF
    reg Etapa_IF_pc_reset;

	// Outputs
    //Contador de ciclos
    wire [15:0] count;
    
    // Instantiate the Unit Under Test (UUT)
    pipeline_monociclo_sintesis uut (
        //Inputs
        .Clk(Clk), 
        .Latch_Reset(Latch_Reset),
        .Latch_enable(Latch_enable),
        //Etapa IF
        .Etapa_IF_pc_reset(Etapa_IF_pc_reset),
        //Outputs
        //Contador de ciclos
        .count(count)
    );
    

//    integer  file, status=0,addr_instruccion=0;
//    reg [31:0] data=0;
//    //flag de Branch/Jump
//    localparam BranchEQ = 5;
//    localparam BranchNE = 4;
//    localparam JR = 3;
//    localparam JALR = 2;
//    localparam Jmp = 1; 
//    localparam JAL = 0;
//    //Señal EX
//    localparam RegDst=3;
//    localparam ALUSrc=2; 
//    localparam ALUOp1=1; 
//    localparam ALUOp0=0;
//    //Señal MEM
//    localparam MemRead = 1;
//    localparam MemWrite =0;
//    //Señales WB
//    localparam MemtoReg = 0;
//    localparam RegWrite = 1;
    
    initial begin
        // Initialize Inputs
        Clk = 0;
        // Puesta a punto inicial 
        Latch_Reset = 1; // se reinicia todos los latch
        Latch_enable = 0; // se deshabilita los latch
        //Etapa IF
        Etapa_IF_pc_reset = 1; //<= ############# No se reinicia la memoria ya arranca en 0
           
        #395;// arranca la ejecucion
        Etapa_IF_pc_reset = 0;
        Latch_Reset = 0; //  no se reinicia todos los latch
        Latch_enable = 1; // se habilita PC 
    end
    
    
    always begin //clock de la placa 100Mhz
        #5 Clk=~Clk;
    end 

endmodule
