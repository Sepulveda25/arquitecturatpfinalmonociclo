`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.09.2019 18:49:31
// Design Name: 
// Module Name: pipeline
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


module pipeline(    //Inputs
                    input Clk,
                    input Latch_Reset,
                    input Latch_enable,
                    //Etapa IF
                    input Etapa_IF_Reset,
                    input Etapa_IF_enable_pc,
                    input Etapa_IF_enable_sel,
                    input [31:0] Etapa_IF_Instr_in,
                    input Etapa_IF_enable_mem,
                    input [3:0] Etapa_IF_write_enable,
                    input [31:0] Etapa_IF_Addr_Instr,
                    input Etapa_IF_Addr_Src,
                    input Etapa_IF_pc_reset,
                    input halt_reset,
                    //Etapa ID
                    input Etapa_ID_Reset,
                    input [4:0] Etapa_ID_posReg, // address para leer registros en modo debug
                    input Etapa_ID_posSel, // selecion de address para Register
                    //Etapa MEM
                    input Etapa_MEM_Reset,
                    input [31:0] dirMem, 			    //Addr a Mux, luego a DataMem
                    input memDebug,                //Selector de los 3 Mux
                    //Contador de ciclos
                    input enable_count,
                    input reset_contador_clk,
                    //Outputs
                    //Etapa IF
                    output [31:0] E1_AddOut,
                    output [31:0] E1_InstrOut,
                    output [31:0] PC_Out,
                    output halt,
                    output stall_or_halt,
                    //Outputs del Latch "IF/ID"
                    output [31:0] Latch_IF_ID_Adder_Out,
                    output [31:0] Latch_IF_ID_InstrOut,
                    output        Latch_IF_ID_halt,
                    //Etapa ID
                    output [31:0] E2_ReadDataA,	
                    output [31:0] E2_ReadDataB,
                    output [7:0]  ControlFLAGS,// ex [13:0] ControlFLAGS, 
                    output [31:0] SignExtendOut,
                    output [2:0]  E2_InmCtrl,
                    output [5:0]  flags_branch_jump, //nuevo 
                    output [31:0] ADDER_E2_PC_JALR_JAL, //nuevo
                    output [4:0]  E2_Rd_mux,
                    output [31:0] E2_PC_salto, // Valor de PC para saltos
                    output        E2_salto, //si es 1 indica que el salto va a ser tomado
                    //Outputs del Latch "ID/EX"
                    output [1:0]    Latch_ID_Ex_WriteBack_FLAGS, //2 bits
                    output [1:0]    Latch_ID_Ex_Mem_FLAGS, // 2 bits //ex[3:0]     Latch_ID_Ex_Mem_FLAGS, // 4 bits
                    output [3:0]    Latch_ID_Ex_FLAGS, //4 bits //ex [7:0]    Latch_ID_Ex_FLAGS, //8 bits
                    output [31:0]   Latch_ID_Ex_PC_JALR_JAL, //ex Latch_ID_Ex_Adder_Out,
                    output [31:0]   Latch_ID_Ex_ReadDataA, Latch_ID_Ex_ReadDataB,
                    output [31:0]   Latch_ID_Ex_SignExtendOut,
                    output [4:0]    Latch_ID_Ex_InstrOut_25_21_Rs, Latch_ID_Ex_InstrOut_20_16_Rt, Latch_ID_Ex_InstrOut_15_11_Rd,  
                    output [25:0]	Latch_ID_Ex_InstrOut_25_0_instr_index, 
                    output [2:0]    Latch_ID_Ex_InmCtrl,
                    output [1:0]    Latch_ID_Ex_flags_JALR_JAL, // {JALR,JAL}
                    output          Latch_ID_Ex_halt,
                    output [31:0]   Latch_ID_Ex_InstrOut, //para testeo
                    //Etapa EX
                    output [31:0]   E3_Adder_Out,
                    output          E3_ALU_Zero,
                    output [31:0]   E3_ALUOut, 
                    output [4:0]    E3_MuxOut,
                    output [31:0]   MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB,
                    //Output del Latch "Ex/MEM"
                    output [1:0]    Latch_Ex_MEM_Mem_FLAGS_Out, // ex [3:0]     Latch_Ex_MEM_Mem_FLAGS_Out,
                    output [31:0]   Latch_Ex_MEM_ReadDataA,
                    output [31:0]   Latch_Ex_MEM_ReadDataB,
                    output [31:0]   Latch_Ex_MEM_PC_JALR_JAL, //ex Latch_Ex_MEM_E3_Adder_Out,
                    output          Latch_Ex_MEM_Zero,
                    output [1:0]    Latch_Ex_MEM_WriteBack_FLAGS_Out,
                    output [4:0]    Latch_Ex_MEM_Mux,
                    output [31:0]   Latch_Ex_MEM_E3_ALUOut,
                    output [1:0]    Latch_Ex_MEM_flags_JALR_JAL, // {JALR,JAL}
                    output          Latch_Ex_MEM_halt,
                    output [31:0]   Latch_Ex_MEM_InstrOut, //para testeo
                    //Etapa MEM
                    output [31:0] E4_DataOut_to_Latch_MEM_WB,
//                    output        Branch, //ex PCScr,
                    //Outputs del Latch MEM/WB
                    output [31:0]    Latch_MEM_WB_DataOut,
                    output [31:0]    Latch_MEM_WB_ALUOut,
                    output [4:0]     Latch_MEM_WB_Mux,
                    output [1:0]    Latch_MEM_WB_WriteBack_FLAGS_Out,
                    output [1:0]    Latch_MEM_WB_flags_JALR_JAL,// {JALR,JAL}
                    output [31:0]   Latch_MEM_WB_PC_JALR_JAL,
                    output          Latch_MEM_WB_halt,
                    output [31:0]   Latch_MEM_WB_InstrOut, //para testeo
                    //Etapa WB
                    output [31:0] Mux_WB,
                    output JALR_or_JAL,
                    output [31:0] Mux_WB_JALR_JAL,
                    //Outputs de la Unidad de Cortocircuito
                    output [1:0] ForwardA, ForwardB,
                    //Output de la Unidad de Deteccion de Riesgos
                    output Stall,
                    //Output de la Unidad de Deteccion de Riesgos
                    output [1:0] PCScr,
                    //Contador de ciclos
                    output [31:0] count,
                    output Latch_MEM_WB_halt_and_enable_count
    );

//-------------------------------    Variables    -----------------------------------------------------------------------
//Señales WB
localparam RegWrite		= 1;
localparam MemtoReg		= 0;
//Señal MEM
localparam MemRead 		= 1;
    
//-----------------------     Cables de Interconexion     ---------------------------------------------------------------
    
// Outputs de Etapa 1, y entran en los inputs del Latch "IF/ID"
//wire [31:0] E1_AddOut;
//wire [31:0] E1_InstrOut;
//wire [31:0] PC_Out;
//Outputs del Latch "IF/ID"
//wire [31:0] Latch_IF_ID_Adder_Out;
//wire [31:0] Latch_IF_ID_InstrOut;
//-----------------------------------------------------------------

//Outputs de Etapa 2, y entran en los inputs del Latch "ID/Ex"
//wire [31:0] E2_ReadDataA;	
//wire [31:0] E2_ReadDataB;
//wire [7:0] 	ControlFLAGS; // ex [13:0] 	ControlFLAGS; 
//wire [31:0] SignExtendOut;  
//wire [2:0] 	E2_InmCtrl;
//wire [5:0]  flags_branch_jump;
////Outputs del Latch "ID/EX"
//wire [1:0] 	Latch_ID_Ex_WriteBack_FLAGS; {RegWrite, MemtoReg}
//wire [1:0] 	Latch_ID_Ex_Mem_FLAGS; //ex [3:0] 	Latch_ID_Ex_Mem_FLAGS; {MemRead, MemWrite, BranchEQ, BranchNE}
//wire [3:0]	Latch_ID_Ex_FLAGS; //ex [7:0]	Latch_ID_Ex_FLAGS; //{JR , JALR, Jmp, JAL, RegDst, ALUSrc, ALUOp1, ALUOp0}
//wire [31:0]	Latch_ID_Ex_Adder_Out;
//wire [31:0]	Latch_ID_Ex_ReadDataA, Latch_ID_Ex_ReadDataB;
//wire [31:0]	Latch_ID_Ex_SignExtendOut; 
//wire [4:0]	Latch_ID_Ex_InstrOut_25_21_Rs, Latch_ID_Ex_InstrOut_20_16_Rt, Latch_ID_Ex_InstrOut_15_11_Rd;
//wire [25:0]	Latch_ID_Ex_InstrOut_25_0_instr_index;
//wire [2:0]	Latch_ID_Ex_InmCtrl;
//-----------------------------------------------------------------

//Output de Etapa 3, y que entran en los inputs del Latch "Ex/MEM"
//wire [31:0]	E3_Adder_Out;
//wire 		E3_ALU_Zero;
//wire [31:0]	E3_ALUOut;
//wire [4:0]	E3_MuxOut;
//wire [31:0] MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB;
//Output del Latch "Ex/MEM"
//wire [1:0] 	Latch_Ex_MEM_Mem_FLAGS_Out; //{MemRead, MemWrite} //ex [3:0] 	Latch_Ex_MEM_Mem_FLAGS_Out; {MemRead, MemWrite, BranchEQ, BranchNE}
//wire [31:0]   Latch_Ex_MEM_ReadDataA;
//wire [31:0]	Latch_Ex_MEM_ReadDataB;
//wire [31:0]	Latch_Ex_MEM_E3_Adder_Out;
//wire        Latch_Ex_MEM_Zero;
//wire [1:0]	Latch_Ex_MEM_WriteBack_FLAGS_Out; {RegWrite, MemtoReg }
//wire [4:0]	Latch_Ex_MEM_Mux; 
//wire [31:0]	Latch_Ex_MEM_E3_ALUOut;
//wire [31:0]   Latch_Ex_MEM_pc_jmp_jal; //nuevo
//wire          Latch_Ex_MEM_JR_or_JALR_flag;//nuevo
//wire          Latch_Ex_MEM_J_or_JAL_flag; //nuevo
//-----------------------------------------------------------------
 
//Outputs de Etapa 4, y que entran en los inputs del Latch "MEM/WB"
//wire [31:0]	E4_DataOut_to_Latch_MEM_WB;
//Outputs del Latch MEM/WB
//wire [31:0]	Latch_MEM_WB_DataOut;
//wire [31:0]	Latch_MEM_WB_ALUOut;
//wire [4:0]	Latch_MEM_WB_Mux;
//wire [1:0]	Latch_MEM_WB_WriteBack_FLAGS_Out; {RegWrite, MemtoReg}
//-----------------------------------------------------------------

//Output de la Etapa 5 "WB"
//wire [31:0] Mux_WB;
//-----------------------------------------------------------------

//Outputs de la Unidad de Cortocircuito
//wire [1:0] ForwardA, ForwardB;
//-----------------------------------------------------------------

//Output de la Unidad de Deteccion de Riesgos
//wire Stall;
//-----------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//---------------------------------   	Etapa 1 "IF" + Latch IF/ID   --------------------------------------------------

Etapa1_IF E1_IF(	//Inputs 13
                    .Clk(Clk), 
                    .Reset(Etapa_IF_Reset), 
                    .InputB_MUX(E2_PC_salto), 
                    .PCScr(E2_salto), 
                    .Stall(stall_or_halt),// detiene el PC si es 1
                    .enable_pc(Latch_enable),//.enable_pc(Etapa_IF_enable_pc),
                    .enable_sel(Etapa_IF_enable_sel),
                    .Instr_in(Etapa_IF_Instr_in),
                    .enable_mem(Etapa_IF_enable_mem),
                    .write_enable(Etapa_IF_write_enable),
                    .Addr_Instr(Etapa_IF_Addr_Instr),
                    .Addr_Src(Etapa_IF_Addr_Src),
                    .pc_reset(Etapa_IF_pc_reset),
                    //Outputs 3
					.E1_AddOut(E1_AddOut), 
					.E1_InstrOut(E1_InstrOut), 
					.PC_Out(PC_Out)
					);
// Unidad que se encarga de detectar la instruccion halt y detener el avance PC. Tambien la señal va viajando por cada etapa de pipeline
// y cuando llega a la etapa WB indica que ya se termino de ejecutar todas las instrucciones de previas al Halt el pipe ya se encotraria vacio 						
Unidad_halt E1_Halt (
                    .E1_InstrOut(E1_InstrOut),
                    .Reset(halt_reset), 
                    .halt(halt)
                    );

//Se hace un OR entre Stall y halt                      
assign stall_or_halt = Stall | halt;

Latch_IF_ID IF_ID(	.Clk(Clk), 
                    .Reset(Latch_Reset), 
                    .Adder_Out(E1_AddOut), 
                    .Instruction_In(E1_InstrOut),
                    .halt(halt), 
                    .Stall(Stall),
					.enable(Latch_enable),
					//Outputs 
					.Latch_IF_ID_Adder_Out(Latch_IF_ID_Adder_Out), 
					.Latch_IF_ID_InstrOut(Latch_IF_ID_InstrOut),
					.Latch_IF_ID_halt(Latch_IF_ID_halt)
                    );
                    
//---------------------------------    Etapa 2 "ID" + Latch ID/Ex	  --------------------------------------------------
                    
Etapa2_ID E2_ID(    //Inputs 9
                    .Clk(Clk), 
                    .Reset(Etapa_ID_Reset), 
                    .Stall(Stall),
                    .Latch_IF_ID_InstrOut(Latch_IF_ID_InstrOut),
                    .posReg(Etapa_ID_posReg), 
                    .posSel(Etapa_ID_posSel),
                    .Latch_MEM_WB_Mux(Latch_MEM_WB_Mux), 
                    .Mux_WB(Mux_WB_JALR_JAL),//.Mux_WB(Mux_WB), 
                    .Latch_MEM_WB_RegWrite(Latch_MEM_WB_WriteBack_FLAGS_Out[RegWrite]),
                    //Outputs 6
                    .E2_ReadDataA(E2_ReadDataA), 
                    .E2_ReadDataB(E2_ReadDataB),
                    .Mux_ControlFLAGS_Out(ControlFLAGS), 
                    .SignExtendOut(SignExtendOut),
                    .E2_InmCtrl(E2_InmCtrl),
                    .flags_branch_jump(flags_branch_jump)//{BranchEQ, BranchNE, JR , JALR, Jmp, JAL}
                );

//variable
reg [31:0] InputB_Adder=4;
reg [4:0] JAL_RD_31=31;
//Adder de la etapa 2: Suma 4 en al PC para calcula direccion de retorno de las instrucciones JALR y JAL"
Adder #(.LEN(32)) adder_ID_JALR_JAL (.InputA(Latch_IF_ID_Adder_Out), .InputB(InputB_Adder), .Out(ADDER_E2_PC_JALR_JAL));
//Este mux es para seleccionar la direccion rd en caso que la instruccion sea JAL 
MUX #(.LEN(5)) mux_JAL(  //Inputs
                            .InputA(Latch_IF_ID_InstrOut[15:11]), // 0
                            .InputB(JAL_RD_31), // 1
                            .SEL(flags_branch_jump[0]), //flag JAL
                            //Outputs
                            .Out(E2_Rd_mux)
                         );

Etapa2_ID_Modulo_Saltos E2_ID_Modulo_Saltos(
                                 .Clk(Clk),
                                 .E2_ReadDataA(E2_ReadDataA),  
                                 .E2_ReadDataB(E2_ReadDataB),
                                 .Latch_IF_ID_Adder_Out(Latch_IF_ID_Adder_Out),//PC+4
                                 .Latch_IF_ID_InstrOut_25_0(Latch_IF_ID_InstrOut[25:0]),
                                 .flags_branch_jump(flags_branch_jump), //{BranchEQ, BranchNE, JR , JALR, Jmp, JAL}
                                 .PC_salto(E2_PC_salto), // Valor de PC para saltos
                                 .salto(E2_salto)// si es 1 indica que el salto va a ser tomado

    );

Latch_ID_EX ID_EX(  //Inputs 14
                    .Clk(Clk), 
                    .Reset(Latch_Reset), 
                    .ADDER_E2_PC_JALR_JAL(ADDER_E2_PC_JALR_JAL),//.Latch_IF_ID_Adder_Out(Latch_IF_ID_Adder_Out), 
                    .ControlFLAGS(ControlFLAGS), 
                    .ReadDataA(E2_ReadDataA), 
                    .ReadDataB(E2_ReadDataB), 
                    .SignExtendOut(SignExtendOut),
                    .Latch_IF_ID_InstrOut_25_21_Rs(Latch_IF_ID_InstrOut[25:21]), 
                    .Latch_IF_ID_InstrOut_20_16_Rt(Latch_IF_ID_InstrOut[20:16]), 
                    .Latch_IF_ID_InstrOut_15_11_Rd(E2_Rd_mux),//ex .Latch_IF_ID_InstrOut_15_11_Rd(Latch_IF_ID_InstrOut[15:11]),
                    .Latch_IF_ID_InstrOut_25_0_instr_index(Latch_IF_ID_InstrOut[25:0]), 
                    .E2_InmCtrl(E2_InmCtrl),
                    .flags_JALR_JAL({flags_branch_jump[2],flags_branch_jump[0]}),// {JALR,JAL}
                    .Latch_IF_ID_halt(Latch_IF_ID_halt),
                    .enable(Latch_enable),
                    .Latch_IF_ID_InstrOut(Latch_IF_ID_InstrOut),
                    //Outputs 13
                    .WriteBack_FLAGS(Latch_ID_Ex_WriteBack_FLAGS), //{RegWrite, MemtoReg}
                    .Mem_FLAGS(Latch_ID_Ex_Mem_FLAGS), //{MemRead, MemWrite} // ex {MemRead, MemWrite, BranchEQ, BranchNE}
                    .Ex_FLAGS(Latch_ID_Ex_FLAGS), //{RegDst, ALUSrc, ALUOp1, ALUOp0} // ex {JR , JALR, Jmp, JAL, RegDst, ALUSrc, ALUOp1, ALUOp0}
                    .Latch_ID_Ex_PC_JALR_JAL(Latch_ID_Ex_PC_JALR_JAL),// ex .Latch_ID_Ex_Adder_Out(Latch_ID_Ex_Adder_Out), 
                    .Latch_ID_Ex_ReadDataA(Latch_ID_Ex_ReadDataA), 
                    .Latch_ID_Ex_ReadDataB(Latch_ID_Ex_ReadDataB), 
                    .Latch_ID_Ex_SignExtendOut(Latch_ID_Ex_SignExtendOut),
                    .Latch_ID_Ex_InstrOut_25_21_Rs(Latch_ID_Ex_InstrOut_25_21_Rs),    //Rs
                    .Latch_ID_Ex_InstrOut_20_16_Rt(Latch_ID_Ex_InstrOut_20_16_Rt), //Rt
                    .Latch_ID_Ex_InstrOut_15_11_Rd(Latch_ID_Ex_InstrOut_15_11_Rd),    //Rd
                    .Latch_ID_Ex_InstrOut_25_0_instr_index(Latch_ID_Ex_InstrOut_25_0_instr_index),
                    .Latch_ID_Ex_InmCtrl(Latch_ID_Ex_InmCtrl),
                    .Latch_ID_Ex_flags_JALR_JAL(Latch_ID_Ex_flags_JALR_JAL),// {JALR,JAL}
                    .Latch_ID_Ex_halt(Latch_ID_Ex_halt),
                    .Latch_ID_Ex_InstrOut(Latch_ID_Ex_InstrOut)
                    );  
                    
//---------------------------------  Etapa 3 "EX" + Latch EX/MEM    --------------------------------------------------
                      
Etapa3_EX E3_EX(    //Inputs 11
                    .Ex_FLAGS(Latch_ID_Ex_FLAGS),//{RegDst, ALUSrc, ALUOp1, ALUOp0} // ex {JR , JALR, Jmp, JAL, RegDst, ALUSrc, ALUOp1, ALUOp0}
                    //.Latch_ID_Ex_Adder_Out(Latch_ID_Ex_Adder_Out),
                    .Latch_ID_Ex_ReadDataA(Latch_ID_Ex_ReadDataA), 
                    .Latch_ID_Ex_ReadDataB(Latch_ID_Ex_ReadDataB),
                    .Latch_ID_Ex_SignExtendOut(Latch_ID_Ex_SignExtendOut), 
                    .Latch_ID_Ex_InstrOut_20_16_Rt(Latch_ID_Ex_InstrOut_20_16_Rt),
                    .Latch_ID_Ex_InstrOut_15_11_Rd(Latch_ID_Ex_InstrOut_15_11_Rd),
                    .Latch_ID_Ex_InstrOut_25_0_instr_index(Latch_ID_Ex_InstrOut_25_0_instr_index),
                    .Latch_ID_Ex_InmCtrl(Latch_ID_Ex_InmCtrl),
                    .Latch_Ex_MEM_ALUOut(Latch_Ex_MEM_E3_ALUOut),
                    .Mux_WB(Mux_WB_JALR_JAL),//ex .Mux_WB(Mux_WB),
                    .ForwardA(ForwardA),
                    .ForwardB(ForwardB),
                    //Outputs 4
                    //.E3_Adder_Out(E3_Adder_Out), 
                    .E3_ALUOut(E3_ALUOut),
                    .E3_ALU_Zero(E3_ALU_Zero),    
                    .E3_MuxOut(E3_MuxOut), //salida de E3_MuxOut
                    .MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB(MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB)
                );
                    

Latch_EX_MEM EX_MEM(    //Inputs 13
                        .Clk(Clk), 
                        .Reset(Latch_Reset),
                        .WriteBack_FLAGS_In(Latch_ID_Ex_WriteBack_FLAGS), //{RegWrite, MemtoReg}
                        .Mem_FLAGS_In(Latch_ID_Ex_Mem_FLAGS),//{MemRead, MemWrite} //ex {MemRead, MemWrite, BranchEQ, BranchNE}
                        .Latch_ID_Ex_PC_JALR_JAL(Latch_ID_Ex_PC_JALR_JAL),//ex .E3_Adder_Out(E3_Adder_Out), 
                        .E3_ALU_Zero(E3_ALU_Zero), 
                        .E3_ALUOut(E3_ALUOut),
                        .Latch_ID_Ex_ReadDataB(MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB),
                        .E3_MuxOut(E3_MuxOut), //salida de E3_MuxOut
                        .enable(Latch_enable),
                        .Latch_ID_Ex_flags_JALR_JAL(Latch_ID_Ex_flags_JALR_JAL),// {JALR,JAL}
                        .Latch_ID_Ex_halt(Latch_ID_Ex_halt),
                        .Latch_ID_Ex_InstrOut(Latch_ID_Ex_InstrOut),
                        //Outputs 9
                        .WriteBack_FLAGS_Out(Latch_Ex_MEM_WriteBack_FLAGS_Out), //{RegWrite, MemtoReg}
                        .Mem_FLAGS_Out(Latch_Ex_MEM_Mem_FLAGS_Out), //{MemRead, MemWrite} //ex {MemRead, MemWrite, BranchEQ, BranchNE}
                        .Latch_Ex_MEM_PC_JALR_JAL(Latch_Ex_MEM_PC_JALR_JAL),//ex .Latch_Ex_MEM_E3_Adder_Out(Latch_Ex_MEM_E3_Adder_Out),
                        .Latch_Ex_MEM_Zero(Latch_Ex_MEM_Zero),
                        .Latch_Ex_MEM_E3_ALUOut(Latch_Ex_MEM_E3_ALUOut), //Addr a DataMem 
                        .Latch_Ex_MEM_ReadDataB(Latch_Ex_MEM_ReadDataB), //DataIn a DataMem
                        .Latch_Ex_MEM_Mux(Latch_Ex_MEM_Mux),
                        .Latch_Ex_MEM_flags_JALR_JAL(Latch_Ex_MEM_flags_JALR_JAL),// {JALR,JAL}
                        .Latch_Ex_MEM_halt(Latch_Ex_MEM_halt),
                        .Latch_Ex_MEM_InstrOut(Latch_Ex_MEM_InstrOut)                   
                     );
                     
//---------------------------------    Etapa 4 "MEM" + Latch MEM/WB    -----------------------------------------------
                     
Etapa4_MEM E4_MEM(   //Inputs
                     .Clk(Clk), 
                     .Reset(Etapa_MEM_Reset), 
                     .Latch_Ex_MEM_Zero(Latch_Ex_MEM_Zero),
                     .Mem_FLAGS(Latch_Ex_MEM_Mem_FLAGS_Out),//{MemRead, MemWrite} //ex {MemRead, MemWrite, BranchEQ, BranchNE}
                     .Latch_Ex_MEM_ALUOut(Latch_Ex_MEM_E3_ALUOut),
                     .dirMem(dirMem), 
                     .memDebug(memDebug),
                     .Latch_Ex_MEM_ReadDataB(Latch_Ex_MEM_ReadDataB),
                     //Outputs
                     .E4_DataOut(E4_DataOut_to_Latch_MEM_WB)  
                 );
                         
 Latch_MEM_WB MEM_WB(    //Inputs
                         .Clk(Clk), 
                         .Reset(Latch_Reset),
                         .WriteBack_FLAGS_In(Latch_Ex_MEM_WriteBack_FLAGS_Out), 
                         .E4_DataOut(E4_DataOut_to_Latch_MEM_WB),
                         .Latch_Ex_MEM_ALUOut(Latch_Ex_MEM_E3_ALUOut),
                         .Latch_Ex_MEM_Mux(Latch_Ex_MEM_Mux),
                         .enable(Latch_enable),
                         .Latch_Ex_MEM_flags_JALR_JAL(Latch_Ex_MEM_flags_JALR_JAL),
                         .Latch_Ex_MEM_PC_JALR_JAL(Latch_Ex_MEM_PC_JALR_JAL),
                         .Latch_Ex_MEM_halt(Latch_Ex_MEM_halt),
                         .Latch_Ex_MEM_InstrOut(Latch_Ex_MEM_InstrOut),
                         //Outputs
                         .Latch_MEM_WB_DataOut(Latch_MEM_WB_DataOut),
                         .Latch_MEM_WB_ALUOut(Latch_MEM_WB_ALUOut),
                         .Latch_MEM_WB_Mux(Latch_MEM_WB_Mux),
                         .WriteBack_FLAGS_Out(Latch_MEM_WB_WriteBack_FLAGS_Out),
                         .Latch_MEM_WB_flags_JALR_JAL(Latch_MEM_WB_flags_JALR_JAL),
                         .Latch_MEM_WB_PC_JALR_JAL(Latch_MEM_WB_PC_JALR_JAL),//PC+8 para retorno 
                         .Latch_MEM_WB_halt(Latch_MEM_WB_halt),
                         .Latch_MEM_WB_InstrOut(Latch_MEM_WB_InstrOut)
                      );                    

//--------------------------------    Etapa 5 "WB"    ----------------------------------------------------------------

MUX #(.LEN(32)) E5_WB(	//Inputs
                        .InputA(Latch_MEM_WB_ALUOut), //0
                        .InputB(Latch_MEM_WB_DataOut),//1 
                        .SEL(Latch_MEM_WB_WriteBack_FLAGS_Out[MemtoReg]), 
                        //Output
                        .Out(Mux_WB)
                     );
                     
//Se hace un OR entre los dos flags JALR y JAL                      
assign JALR_or_JAL = Latch_MEM_WB_flags_JALR_JAL[1] | Latch_MEM_WB_flags_JALR_JAL[0];

// Si la instruccion es JALR o JAL se selecciona la salida de PC_JALR_JAL para grabarlo en el regitro dado por 
MUX #(.LEN(32)) mux_WB_JALR_JAL_PC(	//Inputs
                                    .InputA(Mux_WB), //0
                                    .InputB(Latch_MEM_WB_PC_JALR_JAL),//1 
                                    .SEL(JALR_or_JAL), 
                                    //Output
                                    .Out(Mux_WB_JALR_JAL)
                                   );

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-------------------------        Unidad de CortoCircuito       ------------------------------------------------------
unidad_de_cortocircuito UnidadCorto(//Inputs
                                    .Latch_ID_EX_RS(Latch_ID_Ex_InstrOut_25_21_Rs),
                                    .Latch_ID_EX_RT(Latch_ID_Ex_InstrOut_20_16_Rt),
                                    .Latch_EX_MEM_MUX(Latch_Ex_MEM_Mux),
                                    .Latch_MEM_WB_MUX(Latch_MEM_WB_Mux),
                                    .Latch_Ex_MEM_WriteBack_FLAGS_Out(Latch_Ex_MEM_WriteBack_FLAGS_Out[RegWrite]),
                                    .Latch_MEM_WB_WriteBack_FLAGS_Out(Latch_MEM_WB_WriteBack_FLAGS_Out[RegWrite]),
                                    //Outputs
                                    .ForwardA(ForwardA),
                                    .ForwardB(ForwardB)
                                    );
												
//----------------------       Unidad de Deteccion de Riesgos     -----------------------------------------------------
unidad_de_deteccion_de_riesgos UnidadRiesgos(	//Inputs
                                                .Latch_ID_Ex_Mem_FLAGS_MemRead(Latch_ID_Ex_Mem_FLAGS[MemRead]),
                                                .Latch_ID_Ex_InstrOut_20_16_Rt(Latch_ID_Ex_InstrOut_20_16_Rt),
                                                .Latch_IF_ID_RS(Latch_IF_ID_InstrOut[25:21]),
                                                .Latch_IF_ID_RT(Latch_IF_ID_InstrOut[20:16]),
                                                //Output
                                                .Stall(Stall)
                                             );
//----------------------       Contador de ciclos     -----------------------------------------------------
contador_clk #(.LEN(32)) Contador_Clk(//input
                                    .clk(Clk), 
                                    .reset(reset_contador_clk),
                                    .enable(Latch_MEM_WB_halt_and_enable_count),
                                    //output
                                    .count(count)
    );

//Se hace un OR entre los dos flags JALR y JAL                      
assign Latch_MEM_WB_halt_and_enable_count = (~Latch_MEM_WB_halt) & enable_count; // OJO la señal de latch entra negada

endmodule
