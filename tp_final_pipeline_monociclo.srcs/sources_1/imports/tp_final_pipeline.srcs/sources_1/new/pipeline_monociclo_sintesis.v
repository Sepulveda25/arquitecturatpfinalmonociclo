`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2020 22:15:57
// Design Name: 
// Module Name: pipeline_monociclo_sintesis
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


module pipeline_monociclo_sintesis(
                                    //Inputs
                                    input Clk,
                                    input Latch_Reset,
                                    input Latch_enable,
                                    input Etapa_IF_pc_reset, 
                                    //Contador de ciclos
                                    output [15:0] count

    );

//-------------------------------    Variables    -----------------------------------------------------------------------
//Señales WB
localparam RegWrite        = 1;
localparam MemtoReg        = 0;
//Señal MEM
localparam MemRead         = 1;
    
//-----------------------     Cables de Interconexion     ---------------------------------------------------------------
    
// Outputs de Etapa 1, y entran en los inputs del Latch "IF/ID"
wire [31:0] E1_AddOut;
wire [31:0] E1_InstrOut;
//wire [31:0] PC_Out;
wire stall_or_halt;
//Unidad halt
wire halt;
//Outputs del Latch "IF/ID"
//wire [31:0] Latch_IF_ID_Adder_Out;
//wire [31:0] Latch_IF_ID_InstrOut;
//wire Latch_IF_ID_halt;

//-----------------------------------------------------------------

//Outputs de Etapa 2, y entran en los inputs del Latch "ID/Ex"
wire [31:0] E2_ReadDataA;    
wire [31:0] E2_ReadDataB;
wire [7:0]  ControlFLAGS;
wire [31:0] SignExtendOut;  
wire [2:0]     E2_InmCtrl;
wire [5:0]  flags_branch_jump;
wire [31:0] ADDER_E2_PC_JALR_JAL;
wire [4:0]  E2_Rd_mux;
wire [31:0] E2_PC_salto;
wire        E2_salto;
////Outputs del Latch "ID/EX"
//wire [1:0]      Latch_ID_Ex_WriteBack_FLAGS; //{RegWrite, MemtoReg}
//wire [1:0]      Latch_ID_Ex_Mem_FLAGS; 
//wire [3:0]      Latch_ID_Ex_FLAGS; 
//wire [31:0]     Latch_ID_Ex_PC_JALR_JAL;
//wire [31:0]     Latch_ID_Ex_ReadDataA, Latch_ID_Ex_ReadDataB;
//wire [31:0]     Latch_ID_Ex_SignExtendOut; 
//wire [4:0]      Latch_ID_Ex_InstrOut_25_21_Rs, Latch_ID_Ex_InstrOut_20_16_Rt, Latch_ID_Ex_InstrOut_15_11_Rd;
//wire [25:0]     Latch_ID_Ex_InstrOut_25_0_instr_index;
//wire [2:0]      Latch_ID_Ex_InmCtrl;
//wire [1:0]      Latch_ID_Ex_flags_JALR_JAL;
//wire            Latch_ID_Ex_halt;
//-----------------------------------------------------------------

//Output de Etapa 3, y que entran en los inputs del Latch "Ex/MEM"
//wire [31:0]    E3_Adder_Out;
//wire         E3_ALU_Zero;
wire [31:0]     E3_ALUOut;
wire [4:0]      E3_MuxOut;
wire [31:0] MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB;
//Output del Latch "Ex/MEM"
//wire [1:0]     Latch_Ex_MEM_Mem_FLAGS_Out; //{MemRead, MemWrite} 
//wire [31:0]   Latch_Ex_MEM_PC_JALR_JAL;
//wire [31:0]    Latch_Ex_MEM_ReadDataB;
//wire [1:0]      Latch_Ex_MEM_WriteBack_FLAGS_Out; //{RegWrite, MemtoReg }
//wire [4:0]      Latch_Ex_MEM_Mux;
//wire [31:0]     Latch_Ex_MEM_E3_ALUOut;
//wire [1:0]      Latch_Ex_MEM_flags_JALR_JAL;
//wire            Latch_Ex_MEM_halt;

//-----------------------------------------------------------------
 
//Outputs de Etapa 4, y que entran en los inputs del Latch "MEM/WB"
wire [31:0]    E4_DataOut_to_Latch_MEM_WB;
//Outputs del Latch MEM/WB
//wire [31:0]    Latch_MEM_WB_DataOut;
//wire [31:0]    Latch_MEM_WB_ALUOut;
//wire [4:0]    Latch_MEM_WB_Mux;
//wire [1:0]    Latch_MEM_WB_WriteBack_FLAGS_Out; //{RegWrite, MemtoReg}
//wire [1:0]    Latch_MEM_WB_flags_JALR_JAL;// {JALR,JAL}
//wire [31:0]   Latch_MEM_WB_PC_JALR_JAL;
//wire           Latch_MEM_WB_halt;
//wire [31:0]   Latch_MEM_WB_InstrOut;
//-----------------------------------------------------------------

//Output de la Etapa 5 "WB"
wire [31:0] Mux_WB;
wire [31:0] Mux_WB_JALR_JAL; 
wire JALR_or_JAL;
//-----------------------------------------------------------------

//Outputs de la Unidad de Cortocircuito
//wire [1:0] ForwardA, ForwardB;
//-----------------------------------------------------------------

//Output de la Unidad de Deteccion de Riesgos
//wire Stall;
//-----------------------------------------------------------------
// Contador clock
wire Latch_MEM_WB_halt_and_enable_count;
//-----------------------------------------------------------------
//Clock wiz
wire Clk_50Mhz;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


//---------------------------------       Etapa 1 "IF" + Latch IF/ID   --------------------------------------------------
reg Etapa_IF_Reset=0;
reg Etapa_IF_enable_sel=1;
//reg Etapa_IF_Instr_in=0;
reg Etapa_IF_enable_mem=1;
//reg Etapa_IF_write_enable=0;
//reg Etapa_IF_Addr_Instr=0;
reg Etapa_IF_Addr_Src=0;

Etapa1_IF E1_IF(    //Inputs 13
                    .Clk(Clk_50Mhz), 
                    .Reset(Etapa_IF_Reset), 
                    .InputB_MUX(E2_PC_salto), 
                    .PCScr(E2_salto), 
                    .Stall(stall_or_halt),// detiene el PC si es 1
                    .enable_pc(Latch_enable),//.enable_pc(Etapa_IF_enable_pc),
                    .enable_sel(Etapa_IF_enable_sel),
                    .Instr_in(0),//.Instr_in(Etapa_IF_Instr_in), //ingreso de instrucciones
                    .enable_mem(Etapa_IF_enable_mem),
                    .write_enable(0),//.write_enable(Etapa_IF_write_enable),
                    .Addr_Instr(0),//.Addr_Instr(Etapa_IF_Addr_Instr), //ingreso de direccion de instrucciones
                    .Addr_Src(Etapa_IF_Addr_Src),
                    .pc_reset(Etapa_IF_pc_reset),
                    //Outputs 2
                    .E1_AddOut(E1_AddOut), 
                    .E1_InstrOut(E1_InstrOut)
//                    .PC_Out(PC_Out)
                    );
// Unidad que se encarga de detectar la instruccion halt y detener el avance PC. Tambien la señal va viajando por cada etapa de pipeline
// y cuando llega a la etapa WB indica que ya se termino de ejecutar todas las instrucciones de previas al Halt el pipe ya se encotraria vacio                         
//reg halt_reset=0;
Unidad_halt E1_Halt (
                    //Inputs
                    .E1_InstrOut(E1_InstrOut),
                    .Reset(Latch_Reset),//.Reset(halt_reset),
                    //Output
                    .halt(halt)
                    );

//Se hace un OR entre Stall y halt                      
assign stall_or_halt = halt;

//Latch_IF_ID IF_ID(  .Clk(Clk_50Mhz), 
//                    .Reset(Latch_Reset), 
//                    .Adder_Out(E1_AddOut), 
//                    .Instruction_In(E1_InstrOut),
//                    .halt(halt), 
//                    .Stall(Stall),
//                    .enable(Latch_enable),
//                    //Outputs 
//                    .Latch_IF_ID_Adder_Out(Latch_IF_ID_Adder_Out), 
//                    .Latch_IF_ID_InstrOut(Latch_IF_ID_InstrOut),
//                    .Latch_IF_ID_halt(Latch_IF_ID_halt)
//                    );
                    
//---------------------------------    Etapa 2 "ID" + Latch ID/Ex      --------------------------------------------------
//reg Etapa_ID_Reset=0;
//reg Etapa_ID_posReg=0;
reg Etapa_ID_posSel=0;
reg Stall=0; // no hay burbujas
                  
Etapa2_ID E2_ID(    //Inputs 9
                    .Clk(Clk_50Mhz), 
                    .Reset(Latch_Reset),//.Reset(Etapa_ID_Reset), 
                    .Stall(Stall),
                    .Latch_IF_ID_InstrOut(E1_InstrOut),//.Latch_IF_ID_InstrOut(Latch_IF_ID_InstrOut),
                    .posReg(0), //.posReg(Etapa_ID_posReg), 
                    .posSel(Etapa_ID_posSel),
                    .Latch_MEM_WB_Mux(E3_MuxOut),//.Latch_MEM_WB_Mux(Latch_MEM_WB_Mux), //dato que se va a escribir en los registros
                    .Mux_WB(Mux_WB_JALR_JAL),//.Mux_WB(Mux_WB), 
                    .Latch_MEM_WB_RegWrite(ControlFLAGS[7]),//.Latch_MEM_WB_RegWrite(Latch_MEM_WB_WriteBack_FLAGS_Out[RegWrite]),
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
Adder #(.LEN(32)) adder_ID_JALR_JAL (   .InputA(E1_AddOut), //.InputA(Latch_IF_ID_Adder_Out), 
                                        .InputB(InputB_Adder), 
                                        .Out(ADDER_E2_PC_JALR_JAL));
//Este mux es para seleccionar la direccion rd en caso que la instruccion sea JAL 
MUX #(.LEN(5)) mux_JAL(  //Inputs
                            .InputA(E1_InstrOut[15:11]),//.InputA(Latch_IF_ID_InstrOut[15:11]), // 0
                            .InputB(JAL_RD_31), // 1
                            .SEL(flags_branch_jump[0]), //flag JAL
                            //Outputs
                            .Out(E2_Rd_mux)
                         );

Etapa2_ID_Modulo_Saltos E2_ID_Modulo_Saltos(
                                 .Clk(Clk_50Mhz),
                                 .E2_ReadDataA(E2_ReadDataA),  
                                 .E2_ReadDataB(E2_ReadDataB),
                                 .Latch_IF_ID_Adder_Out(E1_AddOut), //.Latch_IF_ID_Adder_Out(Latch_IF_ID_Adder_Out),//PC+4
                                 .Latch_IF_ID_InstrOut_25_0(E1_InstrOut[25:0]),//.Latch_IF_ID_InstrOut_25_0(Latch_IF_ID_InstrOut[25:0]),
                                 .flags_branch_jump(flags_branch_jump), //{BranchEQ, BranchNE, JR , JALR, Jmp, JAL}
                                 .PC_salto(E2_PC_salto), // Valor de PC para saltos
                                 .salto(E2_salto)// si es 1 indica que el salto va a ser tomado

    );

//Latch_ID_EX ID_EX(  //Inputs 14
//                    .Clk(Clk_50Mhz), 
//                    .Reset(Latch_Reset), 
//                    .ADDER_E2_PC_JALR_JAL(ADDER_E2_PC_JALR_JAL),
//                    .ControlFLAGS(ControlFLAGS), 
//                    .ReadDataA(E2_ReadDataA), 
//                    .ReadDataB(E2_ReadDataB), 
//                    .SignExtendOut(SignExtendOut),
//                    .Latch_IF_ID_InstrOut_25_21_Rs(Latch_IF_ID_InstrOut[25:21]), 
//                    .Latch_IF_ID_InstrOut_20_16_Rt(Latch_IF_ID_InstrOut[20:16]), 
//                    .Latch_IF_ID_InstrOut_15_11_Rd(E2_Rd_mux),//ex .Latch_IF_ID_InstrOut_15_11_Rd(Latch_IF_ID_InstrOut[15:11]),
//                    .Latch_IF_ID_InstrOut_25_0_instr_index(Latch_IF_ID_InstrOut[25:0]), 
//                    .E2_InmCtrl(E2_InmCtrl),
//                    .flags_JALR_JAL({flags_branch_jump[2],flags_branch_jump[0]}),// {JALR,JAL}
//                    .Latch_IF_ID_halt(Latch_IF_ID_halt),
//                    .enable(Latch_enable),
//                    //Outputs 13
//                    .WriteBack_FLAGS(Latch_ID_Ex_WriteBack_FLAGS), //{RegWrite, MemtoReg}
//                    .Mem_FLAGS(Latch_ID_Ex_Mem_FLAGS), //{MemRead, MemWrite} 
//                    .Ex_FLAGS(Latch_ID_Ex_FLAGS), //{RegDst, ALUSrc, ALUOp1, ALUOp0} 
//                    .Latch_ID_Ex_PC_JALR_JAL(Latch_ID_Ex_PC_JALR_JAL),// ex .Latch_ID_Ex_Adder_Out(Latch_ID_Ex_Adder_Out), 
//                    .Latch_ID_Ex_ReadDataA(Latch_ID_Ex_ReadDataA), 
//                    .Latch_ID_Ex_ReadDataB(Latch_ID_Ex_ReadDataB), 
//                    .Latch_ID_Ex_SignExtendOut(Latch_ID_Ex_SignExtendOut),
//                    .Latch_ID_Ex_InstrOut_25_21_Rs(Latch_ID_Ex_InstrOut_25_21_Rs),    //Rs
//                    .Latch_ID_Ex_InstrOut_20_16_Rt(Latch_ID_Ex_InstrOut_20_16_Rt), //Rt
//                    .Latch_ID_Ex_InstrOut_15_11_Rd(Latch_ID_Ex_InstrOut_15_11_Rd),    //Rd
//                    .Latch_ID_Ex_InstrOut_25_0_instr_index(Latch_ID_Ex_InstrOut_25_0_instr_index),
//                    .Latch_ID_Ex_InmCtrl(Latch_ID_Ex_InmCtrl),
//                    .Latch_ID_Ex_flags_JALR_JAL(Latch_ID_Ex_flags_JALR_JAL),// {JALR,JAL}
//                    .Latch_ID_Ex_halt(Latch_ID_Ex_halt)
//                    );  
                    
//---------------------------------  Etapa 3 "EX" + Latch EX/MEM    --------------------------------------------------
                      
Etapa3_EX E3_EX(    //Inputs 12
                    .Clk(Clk_50Mhz),
                    .Ex_FLAGS(ControlFLAGS[3:0]),//.Ex_FLAGS(Latch_ID_Ex_FLAGS),//{RegDst, ALUSrc, ALUOp1, ALUOp0} 
                    .Latch_ID_Ex_ReadDataA(E2_ReadDataA), //.Latch_ID_Ex_ReadDataA(Latch_ID_Ex_ReadDataA), 
                    .Latch_ID_Ex_ReadDataB(E2_ReadDataB),//.Latch_ID_Ex_ReadDataB(Latch_ID_Ex_ReadDataB),
                    .Latch_ID_Ex_SignExtendOut(SignExtendOut),//.Latch_ID_Ex_SignExtendOut(Latch_ID_Ex_SignExtendOut), 
                    .Latch_ID_Ex_InstrOut_20_16_Rt(E1_InstrOut[20:16]),//.Latch_ID_Ex_InstrOut_20_16_Rt(Latch_ID_Ex_InstrOut_20_16_Rt),
                    .Latch_ID_Ex_InstrOut_15_11_Rd(E2_Rd_mux),//.Latch_ID_Ex_InstrOut_15_11_Rd(Latch_ID_Ex_InstrOut_15_11_Rd),
                    .Latch_ID_Ex_InstrOut_25_0_instr_index(E1_InstrOut[25:0]),//.Latch_ID_Ex_InstrOut_25_0_instr_index(Latch_ID_Ex_InstrOut_25_0_instr_index),
                    .Latch_ID_Ex_InmCtrl(E2_InmCtrl),//.Latch_ID_Ex_InmCtrl(Latch_ID_Ex_InmCtrl),
                    .Latch_Ex_MEM_ALUOut(E3_ALUOut),//.Latch_Ex_MEM_ALUOut(Latch_Ex_MEM_E3_ALUOut),
                    .Mux_WB(Mux_WB_JALR_JAL),//ex .Mux_WB(Mux_WB),
                    .ForwardA(0),//NO hay unidad de corto
                    .ForwardB(0),//NO hay unidad de corto
                    //Outputs 4
                    .E3_ALUOut(E3_ALUOut), 
                    .E3_MuxOut(E3_MuxOut), //salida de E3_MuxOut
                    .MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB(MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB)
                );
                    

//Latch_EX_MEM EX_MEM(    //Inputs 13
//                        .Clk(Clk_50Mhz), 
//                        .Reset(Latch_Reset),
//                        .WriteBack_FLAGS_In(Latch_ID_Ex_WriteBack_FLAGS), //{RegWrite, MemtoReg}
//                        .Mem_FLAGS_In(Latch_ID_Ex_Mem_FLAGS),//{MemRead, MemWrite} //ex {MemRead, MemWrite, BranchEQ, BranchNE}
//                        .Latch_ID_Ex_PC_JALR_JAL(Latch_ID_Ex_PC_JALR_JAL),
//                        .E3_ALUOut(E3_ALUOut),
//                        .Latch_ID_Ex_ReadDataB(MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB),
//                        .E3_MuxOut(E3_MuxOut), //salida de E3_MuxOut
//                        .enable(Latch_enable),
//                        .Latch_ID_Ex_flags_JALR_JAL(Latch_ID_Ex_flags_JALR_JAL),// {JALR,JAL}
//                        .Latch_ID_Ex_halt(Latch_ID_Ex_halt),
//                        //Outputs 9
//                        .WriteBack_FLAGS_Out(Latch_Ex_MEM_WriteBack_FLAGS_Out), //{RegWrite, MemtoReg}
//                        .Mem_FLAGS_Out(Latch_Ex_MEM_Mem_FLAGS_Out), //{MemRead, MemWrite} 
//                        .Latch_Ex_MEM_PC_JALR_JAL(Latch_Ex_MEM_PC_JALR_JAL),
//                        .Latch_Ex_MEM_E3_ALUOut(Latch_Ex_MEM_E3_ALUOut), //Addr a DataMem 
//                        .Latch_Ex_MEM_ReadDataB(Latch_Ex_MEM_ReadDataB), //DataIn a DataMem
//                        .Latch_Ex_MEM_Mux(Latch_Ex_MEM_Mux),
//                        .Latch_Ex_MEM_flags_JALR_JAL(Latch_Ex_MEM_flags_JALR_JAL),// {JALR,JAL}
//                        .Latch_Ex_MEM_halt(Latch_Ex_MEM_halt)              
//                     );
                     
//---------------------------------    Etapa 4 "MEM" + Latch MEM/WB    -----------------------------------------------
reg Etapa_MEM_Reset=0;
reg Latch_Ex_MEM_Zero=0;
//reg dirMem=0;
reg memDebug=0;// no es modo debug

               
Etapa4_MEM E4_MEM(   //Inputs
                     .Clk(Clk_50Mhz), 
                     .Reset(Etapa_MEM_Reset), 
                     .Latch_Ex_MEM_Zero(Latch_Ex_MEM_Zero),
                     .Mem_FLAGS(ControlFLAGS[5:4]),//.Mem_FLAGS(Latch_Ex_MEM_Mem_FLAGS_Out),//{MemRead, MemWrite} 
                     .Latch_Ex_MEM_ALUOut(E3_ALUOut),//.Latch_Ex_MEM_ALUOut(Latch_Ex_MEM_E3_ALUOut),
                     .dirMem(0), //.dirMem(dirMem), 
                     .memDebug(memDebug),
                     .Latch_Ex_MEM_ReadDataB(MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB),//.Latch_Ex_MEM_ReadDataB(Latch_Ex_MEM_ReadDataB),
                     //Outputs
                     .E4_DataOut(E4_DataOut_to_Latch_MEM_WB)  
                 );
                         
// Latch_MEM_WB MEM_WB(    //Inputs
//                         .Clk(Clk_50Mhz), 
//                         .Reset(Latch_Reset),
//                         .WriteBack_FLAGS_In(Latch_Ex_MEM_WriteBack_FLAGS_Out), 
//                         .E4_DataOut(E4_DataOut_to_Latch_MEM_WB),
//                         .Latch_Ex_MEM_ALUOut(Latch_Ex_MEM_E3_ALUOut),
//                         .Latch_Ex_MEM_Mux(Latch_Ex_MEM_Mux),
//                         .enable(Latch_enable),
//                         .Latch_Ex_MEM_flags_JALR_JAL(Latch_Ex_MEM_flags_JALR_JAL),
//                         .Latch_Ex_MEM_PC_JALR_JAL(Latch_Ex_MEM_PC_JALR_JAL),
//                         .Latch_Ex_MEM_halt(Latch_Ex_MEM_halt),
//                         //Outputs
//                         .Latch_MEM_WB_DataOut(Latch_MEM_WB_DataOut),
//                         .Latch_MEM_WB_ALUOut(Latch_MEM_WB_ALUOut),
//                         .Latch_MEM_WB_Mux(Latch_MEM_WB_Mux),
//                         .WriteBack_FLAGS_Out(Latch_MEM_WB_WriteBack_FLAGS_Out),
//                         .Latch_MEM_WB_flags_JALR_JAL(Latch_MEM_WB_flags_JALR_JAL),
//                         .Latch_MEM_WB_PC_JALR_JAL(Latch_MEM_WB_PC_JALR_JAL),//PC+8 para retorno 
//                         .Latch_MEM_WB_halt(Latch_MEM_WB_halt),
//                         .Latch_MEM_WB_InstrOut(Latch_MEM_WB_InstrOut)
//                      );                    

//--------------------------------    Etapa 5 "WB"    ----------------------------------------------------------------

//MUX #(.LEN(32)) E5_WB(    //Inputs
//                        .InputA(E3_ALUOut),//.InputA(Latch_MEM_WB_ALUOut), //0
//                        .InputB(E4_DataOut_to_Latch_MEM_WB),//.InputB(Latch_MEM_WB_DataOut),//1 
//                        .SEL(ControlFLAGS[6]),//.SEL(Latch_MEM_WB_WriteBack_FLAGS_Out[MemtoReg]), 
//                        //Output
//                        .Out(Mux_WB)
//                     );
                     
//Se hace un OR entre los dos flags JALR y JAL                      
//assign JALR_or_JAL = Latch_MEM_WB_flags_JALR_JAL[1] | Latch_MEM_WB_flags_JALR_JAL[0];
assign JALR_or_JAL = flags_branch_jump[2] | flags_branch_jump[0];

// Si la instruccion es JALR o JAL se selecciona la salida de PC_JALR_JAL para grabarlo en el regitro dado por 
//MUX #(.LEN(32)) mux_WB_JALR_JAL_PC(    //Inputs
//                                    .InputA(Mux_WB), //0
//                                    .InputB(ADDER_E2_PC_JALR_JAL),//.InputB(Latch_MEM_WB_PC_JALR_JAL),//1 
//                                    .SEL(JALR_or_JAL), 
//                                    //Output
//                                    .Out(Mux_WB_JALR_JAL)
//                                   );

Triple_MUX #(.LEN(32)) Mux_WB_JALR_JAL_PC(   //Inputs
                                   .InputA(E3_ALUOut),//00
                                   .InputB(ADDER_E2_PC_JALR_JAL),//10                
                                   .InputC(E4_DataOut_to_Latch_MEM_WB),//01                         
                                   .SEL({JALR_or_JAL,ControlFLAGS[6]}),                             
                                   //Output
                                   .Out(Mux_WB_JALR_JAL)                                            
                               );

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//-------------------------        Unidad de CortoCircuito       ------------------------------------------------------
//unidad_de_cortocircuito UnidadCorto(//Inputs
//                                    .Latch_ID_EX_RS(Latch_ID_Ex_InstrOut_25_21_Rs),
//                                    .Latch_ID_EX_RT(Latch_ID_Ex_InstrOut_20_16_Rt),
//                                    .Latch_EX_MEM_MUX(Latch_Ex_MEM_Mux),
//                                    .Latch_MEM_WB_MUX(Latch_MEM_WB_Mux),
//                                    .Latch_Ex_MEM_WriteBack_FLAGS_Out(Latch_Ex_MEM_WriteBack_FLAGS_Out[RegWrite]),
//                                    .Latch_MEM_WB_WriteBack_FLAGS_Out(Latch_MEM_WB_WriteBack_FLAGS_Out[RegWrite]),
//                                    //Outputs
//                                    .ForwardA(ForwardA),
//                                    .ForwardB(ForwardB)
//                                    );
                                                
//----------------------       Unidad de Deteccion de Riesgos     -----------------------------------------------------
//unidad_de_deteccion_de_riesgos UnidadRiesgos(    //Inputs
//                                                .Latch_ID_Ex_Mem_FLAGS_MemRead(Latch_ID_Ex_Mem_FLAGS[MemRead]),
//                                                .Latch_ID_Ex_InstrOut_20_16_Rt(Latch_ID_Ex_InstrOut_20_16_Rt),
//                                                .Latch_IF_ID_RS(Latch_IF_ID_InstrOut[25:21]),
//                                                .Latch_IF_ID_RT(Latch_IF_ID_InstrOut[20:16]),
//                                                //Output
//                                                .Stall(Stall)
//                                             );
//----------------------       Contador de ciclos     -----------------------------------------------------
contador_clk #(.LEN(16)) Contador_Clk(//input
                                    .clk(Clk_50Mhz), 
                                    .reset(Latch_Reset),//.reset(reset_contador_clk),
                                    .enable(Latch_MEM_WB_halt_and_enable_count),
                                    //output
                                    .count(count)
    );
    
reg enable_count=1;
//Se hace un OR entre los dos flags JALR y JAL                      
//assign Latch_MEM_WB_halt_and_enable_count = (~Latch_MEM_WB_halt) & enable_count; // OJO la señal de latch entra negada
assign Latch_MEM_WB_halt_and_enable_count = (~halt) & enable_count; // OJO la señal de latch entra negada

/// clock 
clk_wiz_0 clk_50M
(
    // Clock in ports
    .clk_in100Mhz(Clk),
    // Clock out ports  
    .clk_out50Mhz(Clk_50Mhz)
);
    
    
endmodule
