`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2019 17:24:32
// Design Name: 
// Module Name: latch_ID_EX
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
// Inputs: 	- Bus ControlFLAGS 					(14 bits)
//			- Latch_IF_ID_Adder_Out				(1 bit)
//			- ReadDataA							(32 bits)
//			- ReadDataB							(32 bits)
//			- SignExtendOut						(32 bits)
//			- Latch_IF_ID_InstrOut_20_16_Rt		(5 bits)
//			- Latch_IF_ID_InstrOut_15_11_Rd		(5 bits)
// Outputs:	- WriteBack_FLAGS					(2 bits) --> {RegWrite, MemtoReg}
//			- Mem_FLAGS							(2 bits) --> {MemRead, MemWrite}
//			- Ex_FLAGS							(4 bits) --> {RegDst, ALUSrc, ALUOp1, ALUOp0}
//			- Latch_ID_Ex_Adder_Out				(32 bits)
//			- Latch_ID_Ex_ReadDataA				(32 bits)
//			- Latch_ID_Ex_ReadDataB				(32 bits)
//			- Latch_ID_Ex_SignExtendOut		    (32 bits)
//			- Latch_ID_Ex_InstrOut_20_16_Rt		(5 bits)
//			- Latch_ID_Ex_InstrOut_15_11_Rd		(5 bits)
//			- Latch_ID_Ex_InmCtrl				(3 bits)
// Sincronizado a Clk y Reset Sincrono. 
// Almacena Instruciones, ControlFlags, Registros, PC+4 desde Adder, Operador desde SignExtend
//
//////////////////////////////////////////////////////////////////////////////////


module Latch_ID_EX(	//Inputs 14
                    input Clk, Reset,
                    input [31:0] ADDER_E2_PC_JALR_JAL,// ex Latch_IF_ID_Adder_Out, 
                    input [7:0] ControlFLAGS, //ex [13:0] ControlFLAGS,
                    input [31:0] ReadDataA, ReadDataB, SignExtendOut,  
                    input [4:0] Latch_IF_ID_InstrOut_25_21_Rs, Latch_IF_ID_InstrOut_20_16_Rt, Latch_IF_ID_InstrOut_15_11_Rd, 
                    input [25:0] Latch_IF_ID_InstrOut_25_0_instr_index,
                    input [2:0] E2_InmCtrl,
                    input [1:0] flags_JALR_JAL,// {JALR,JAL}
                    input Latch_IF_ID_halt,
                    input enable,
                    input [31:0] Latch_IF_ID_InstrOut,
                    //Outputs 12
                    output reg	[1:0] WriteBack_FLAGS, 
                    output reg	[1:0] Mem_FLAGS, //ex [3:0] Mem_FLAGS
                    output reg	[3:0] Ex_FLAGS,  //ex [7:0] Ex_FLAGS,
                    output reg	[31:0] Latch_ID_Ex_PC_JALR_JAL, //ex Latch_ID_Ex_Adder_Out, 
                    output reg	[31:0] Latch_ID_Ex_ReadDataA, Latch_ID_Ex_ReadDataB, Latch_ID_Ex_SignExtendOut,
                    output reg	[4:0] Latch_ID_Ex_InstrOut_25_21_Rs, Latch_ID_Ex_InstrOut_20_16_Rt, Latch_ID_Ex_InstrOut_15_11_Rd,
                    output reg	[25:0] Latch_ID_Ex_InstrOut_25_0_instr_index,
                    output reg 	[2:0] Latch_ID_Ex_InmCtrl,
                    output reg 	[1:0] Latch_ID_Ex_flags_JALR_JAL, // {JALR,JAL}              
					output reg        Latch_ID_Ex_halt,
					output reg  [31:0] Latch_ID_Ex_InstrOut
					);

//WB
localparam RegWrite	= 7; //ex localparam RegWrite	= 13;
localparam MemtoReg	= 6; //ex localparam MemtoReg	= 12;
//MEM
localparam MemRead = 5; //ex localparam MemRead = 11;
localparam MemWrite	= 4; // ex localparam MemWrite	= 10;
//EX
localparam RegDst = 3;
localparam ALUSrc = 2;
localparam ALUOp1 = 1;
localparam ALUOp0 = 0;

always@(negedge Clk) begin
	if(Reset) begin //Si se resetea, se vuelven las 2 salidas a sus valores iniciales
		WriteBack_FLAGS <= 0; 
		Mem_FLAGS <= 0;
		Ex_FLAGS <= 0;
		Latch_ID_Ex_PC_JALR_JAL <= 0;
		Latch_ID_Ex_ReadDataA <= 0;
		Latch_ID_Ex_ReadDataB <= 0;
		Latch_ID_Ex_SignExtendOut <= 0;
		Latch_ID_Ex_InstrOut_25_21_Rs <= 0;
		Latch_ID_Ex_InstrOut_20_16_Rt <= 0;
		Latch_ID_Ex_InstrOut_15_11_Rd <= 0;
		Latch_ID_Ex_InstrOut_25_0_instr_index <= 0;
		Latch_ID_Ex_InmCtrl	<= 0;
		Latch_ID_Ex_flags_JALR_JAL <=0;
		Latch_ID_Ex_halt<=0;
		Latch_ID_Ex_InstrOut<=0;
	end
	else begin		//Sino, los valores de entrada se asignan a la salida	
		if (enable)
			begin
				WriteBack_FLAGS <= {    ControlFLAGS[RegWrite], // bit 7
				                        ControlFLAGS[MemtoReg]}; // bit 6
				Mem_FLAGS <={   ControlFLAGS[MemRead], // bit 5
				                ControlFLAGS[MemWrite] // bit 4
				                }; 
				Ex_FLAGS <= {   ControlFLAGS[RegDst],// bit 3
				                ControlFLAGS[ALUSrc],// bit 2
				                ControlFLAGS[ALUOp1],// bit 1 
				                ControlFLAGS[ALUOp0]};// bit 0
				Latch_ID_Ex_PC_JALR_JAL <= ADDER_E2_PC_JALR_JAL;
				Latch_ID_Ex_ReadDataA <= ReadDataA;
				Latch_ID_Ex_ReadDataB <= ReadDataB;
				Latch_ID_Ex_SignExtendOut <= SignExtendOut;
				Latch_ID_Ex_InstrOut_25_21_Rs <= Latch_IF_ID_InstrOut_25_21_Rs;
				Latch_ID_Ex_InstrOut_20_16_Rt <= Latch_IF_ID_InstrOut_20_16_Rt;
				Latch_ID_Ex_InstrOut_15_11_Rd <= Latch_IF_ID_InstrOut_15_11_Rd;
				Latch_ID_Ex_InstrOut_25_0_instr_index <= Latch_IF_ID_InstrOut_25_0_instr_index;
				Latch_ID_Ex_InmCtrl	<= E2_InmCtrl;
				Latch_ID_Ex_flags_JALR_JAL <= flags_JALR_JAL;
				Latch_ID_Ex_halt<=Latch_IF_ID_halt;
				Latch_ID_Ex_InstrOut<=Latch_IF_ID_InstrOut;
			end
	    end
end

endmodule
