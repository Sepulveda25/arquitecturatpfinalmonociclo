`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2019 01:49:02
// Design Name: 
// Module Name: Etapa3_EX
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


module Etapa3_EX(   //Inputs 12
                    input [3:0]		Ex_FLAGS,// {RegDst, ALUSrc, ALUOp1, ALUOp0} //ex [7:0]		Ex_FLAGS, // {JR , JALR, Jmp, JAL, RegDst, ALUSrc, ALUOp1, ALUOp0}
                    //input [31:0] 	Latch_ID_Ex_Adder_Out, 
                    input [31:0]    Latch_ID_Ex_ReadDataA, Latch_ID_Ex_ReadDataB,
                    input [31:0] 	Latch_ID_Ex_SignExtendOut, 
                    input [4:0]		Latch_ID_Ex_InstrOut_20_16_Rt, Latch_ID_Ex_InstrOut_15_11_Rd,
                    input [25:0]    Latch_ID_Ex_InstrOut_25_0_instr_index,
                    input [2:0]		Latch_ID_Ex_InmCtrl,
                    input [31:0]	Latch_Ex_MEM_ALUOut,	//Wire externo!! (del Latch "EX/MEM")
                    input [31:0]	Mux_WB,					//Wire externo!! (del Mux WB de la Etapa 5 "WB")
                    input [1:0]		ForwardA,				//Wire externo!! (de la Unidad de Cortocircuito)
                    input [1:0]		ForwardB,				//Wire externo!! (de la Unidad de Cortocircuito)
                    //Outputs 5
                    output [31:0]   E3_ALUOut,
                    output 			E3_ALU_Zero,
                    output [4:0] 	E3_MuxOut,
                    output [31:0] 	MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB
                );
                
//Variables
localparam ALUScr = 2;
localparam RegDst = 3;

//Cables de Interconexion
wire [5:0]  ALUControl_to_ALU;
wire [31:0] MUX_to_ALU;
//wire [31:0] Shift_to_Add;
//wire [31:0] E3_WriteDataB;
wire [4:0]  Shift_Ctrl_ALU;
//wire [5:0]  InmCtrlOut_ALU;
wire [31:0] Mux_CortoA_Out_to_ALU_DataA;
//wire [31:0] Mux_CortoB_Out_to_ALU_DataB;


MUX Mux_AluSrc( //Inputs 
                .InputA(MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB), 
                .InputB(Latch_ID_Ex_SignExtendOut),
                .SEL(Ex_FLAGS[ALUScr]), 
                //Output
                .Out(MUX_to_ALU)
                );

ALU_Control E3_ALU_Control( //Inputs     
                            .Ex_FLAGS_ALUOp(Ex_FLAGS[1:0]), 
                            .Func(Latch_ID_Ex_SignExtendOut[5:0]),
                            .ShiftIn(Latch_ID_Ex_SignExtendOut[10:6]), 
                            .InmCtrl(Latch_ID_Ex_InmCtrl),
                            //Output
                            .Shift(Shift_Ctrl_ALU), 
                            .ALU_Control_Out(ALUControl_to_ALU)                                
                          ); 
ALU E3_ALU( //Inputs
            .ALU_DataA(Mux_CortoA_Out_to_ALU_DataA), 
            .ALU_DataB(MUX_to_ALU), 
            .ALU_Control_Out(ALUControl_to_ALU),
            .Shift(Shift_Ctrl_ALU),
            //Outputs
            .ALU_Out(E3_ALUOut), 
            .Zero(E3_ALU_Zero)
            );

MUX #(.LEN(5)) Mux_RegDst(  //Inputs
                            .InputA(Latch_ID_Ex_InstrOut_20_16_Rt), 
                            .InputB(Latch_ID_Ex_InstrOut_15_11_Rd),
                            .SEL(Ex_FLAGS[RegDst]),
                            //Outputs
                            .Out(E3_MuxOut)
                         );
                             
Triple_MUX #(.LEN(32)) Mux_CortoA(   //Inputs
                                    .InputA(Latch_ID_Ex_ReadDataA),
                                    .InputB(Latch_Ex_MEM_ALUOut),           //Wire externo!! (del Latch "EX/MEM")
                                    .InputC(Mux_WB),                        //Wire externo!! (del Mux WB de la Etapa 5 "WB")
                                    .SEL(ForwardA),                         //Wire externo!! (de la Unidad de Cortocircuito)
                                    //Output
                                    .Out(Mux_CortoA_Out_to_ALU_DataA)                                            
                                );

Triple_MUX #(.LEN(32)) Mux_CortoB(   //Inputs
                                    .InputA(Latch_ID_Ex_ReadDataB),
                                    .InputB(Latch_Ex_MEM_ALUOut),               //Wire externo!! (del Latch "EX/MEM")
                                    .InputC(Mux_WB),                            //Wire externo!! (del Mux WB de la Etapa 5 "WB")
                                    .SEL(ForwardB),                             //Wire externo!! (de la Unidad de Cortocircuito)
                                    //Output
                                    .Out(MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB)                                            
                                );

                 
          
endmodule
