`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.08.2019 23:06:10
// Design Name: 
// Module Name: latch_MEM_WB
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


module Latch_MEM_WB(	//Inputs
                        input Clk, Reset,
                        input [1:0] 	WriteBack_FLAGS_In, 	// {RegWrite, MemtoReg}
                        input [31:0]	E4_DataOut,
                        input [31:0]	Latch_Ex_MEM_ALUOut,
                        input [4:0]		Latch_Ex_MEM_Mux,
                        input			enable,
                        input [1:0]     Latch_Ex_MEM_flags_JALR_JAL, // {JALR,JAL}
                        input [31:0]    Latch_Ex_MEM_PC_JALR_JAL, // nuevo
                        input           Latch_Ex_MEM_halt,
                        input [31:0]    Latch_Ex_MEM_InstrOut,
                        //Outputs
                        output reg	[31:0]  Latch_MEM_WB_DataOut,
                        output reg	[31:0]	Latch_MEM_WB_ALUOut,  
                        output reg	[4:0]	Latch_MEM_WB_Mux, 
                        output reg	[1:0]	WriteBack_FLAGS_Out,	// {RegWrite, MemtoReg}
                        output reg	[1:0]	Latch_MEM_WB_flags_JALR_JAL, // {JALR,JAL}
                        output reg  [31:0]  Latch_MEM_WB_PC_JALR_JAL, //nuevo
                        output reg          Latch_MEM_WB_halt,
                        output reg [31:0]   Latch_MEM_WB_InstrOut
                     );

always@(negedge Clk) begin
	if(Reset) begin
		WriteBack_FLAGS_Out 	         <= 0;
		Latch_MEM_WB_DataOut	         <= 0;
		Latch_MEM_WB_ALUOut	             <= 0;
		Latch_MEM_WB_Mux		         <= 0;
		Latch_MEM_WB_flags_JALR_JAL      <= 0;
		Latch_MEM_WB_PC_JALR_JAL         <= 0;
		Latch_MEM_WB_halt                <= 0;
		Latch_MEM_WB_InstrOut            <= 0;
	end
	else if (enable) begin
		WriteBack_FLAGS_Out 	         <= WriteBack_FLAGS_In;
		Latch_MEM_WB_DataOut	         <= E4_DataOut;
		Latch_MEM_WB_ALUOut	             <= Latch_Ex_MEM_ALUOut;
		Latch_MEM_WB_Mux		         <= Latch_Ex_MEM_Mux;
		Latch_MEM_WB_flags_JALR_JAL      <= Latch_Ex_MEM_flags_JALR_JAL;
		Latch_MEM_WB_PC_JALR_JAL         <= Latch_Ex_MEM_PC_JALR_JAL;
		Latch_MEM_WB_halt                <= Latch_Ex_MEM_halt;
		Latch_MEM_WB_InstrOut            <= Latch_Ex_MEM_InstrOut;
	end
end


endmodule
