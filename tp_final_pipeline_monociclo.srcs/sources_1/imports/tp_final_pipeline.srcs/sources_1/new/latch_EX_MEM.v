`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2019 22:57:58
// Design Name: 
// Module Name: latch_EX_MEM
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

module Latch_EX_MEM(	//Inputs 11
                        input Clk, Reset,
                        input [1:0] 	WriteBack_FLAGS_In, 	// {RegWrite, MemtoReg}
                        input [1:0]		Mem_FLAGS_In,//{MemRead, MemWrite}
                        input [31:0]	Latch_ID_Ex_PC_JALR_JAL,
                        input			E3_ALU_Zero,
                        input [31:0]	E3_ALUOut, 
                        input [31:0]	Latch_ID_Ex_ReadDataB,
                        input [4:0]		E3_MuxOut, 
                        input			enable,
                        input [1:0]     Latch_ID_Ex_flags_JALR_JAL,// {JALR,JAL}
                        input           Latch_ID_Ex_halt,
                        input [31:0]    Latch_ID_Ex_InstrOut, 

                        //Outputs 8
                        output reg 	[1:0] 	WriteBack_FLAGS_Out, 		// {RegWrite, MemtoReg}
                        output reg	[1:0]	Mem_FLAGS_Out,//{MemRead, MemWrite} 
                        output reg	[31:0]	Latch_Ex_MEM_PC_JALR_JAL,
                        output reg			Latch_Ex_MEM_Zero,
                        output reg	[31:0]	Latch_Ex_MEM_E3_ALUOut, 	//Addr a DataMem 
                        output reg	[31:0] 	Latch_Ex_MEM_ReadDataB,		//DataIn a DataMem
                        output reg	[4:0]	Latch_Ex_MEM_Mux,
                        output reg	[1:0]	Latch_Ex_MEM_flags_JALR_JAL, // {JALR,JAL}  
                        output reg          Latch_Ex_MEM_halt,
                        output reg [31:0]   Latch_Ex_MEM_InstrOut  
                     );
 					 

always@(negedge Clk) begin
	if(Reset) begin
		WriteBack_FLAGS_Out			    <= 0;
		Mem_FLAGS_Out				    <= 0;
		Latch_Ex_MEM_PC_JALR_JAL	    <= 0;
		Latch_Ex_MEM_Zero			    <= 0;
		Latch_Ex_MEM_E3_ALUOut	        <= 0;
		Latch_Ex_MEM_ReadDataB		    <= 0;
		Latch_Ex_MEM_Mux		        <= 0;
		Latch_Ex_MEM_flags_JALR_JAL     <= 0;
		Latch_Ex_MEM_halt               <= 0;
		Latch_Ex_MEM_InstrOut           <= 0;
	end
	else if(enable) begin
		WriteBack_FLAGS_Out			    <= WriteBack_FLAGS_In;
		Mem_FLAGS_Out				    <= Mem_FLAGS_In;
		Latch_Ex_MEM_PC_JALR_JAL	    <= Latch_ID_Ex_PC_JALR_JAL;
		Latch_Ex_MEM_Zero			    <= E3_ALU_Zero; 
		Latch_Ex_MEM_E3_ALUOut	        <= E3_ALUOut; //Addr a DataMem 
		Latch_Ex_MEM_ReadDataB		    <= Latch_ID_Ex_ReadDataB;
		Latch_Ex_MEM_Mux	            <= E3_MuxOut;
		Latch_Ex_MEM_flags_JALR_JAL     <= Latch_ID_Ex_flags_JALR_JAL; // {JALR,JAL}
		Latch_Ex_MEM_halt               <= Latch_ID_Ex_halt;
		Latch_Ex_MEM_InstrOut           <= Latch_ID_Ex_InstrOut;
	end
end

endmodule
