`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2019 16:28:17
// Design Name: 
// Module Name: latch_IF_ID
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
// 2 Inputs: 	- Adder_out
//				- Instruction
// 2 Outputs:	- Latch_IF_ID_Adder_Out
//			    - Latch_IF_ID_InstrOut
//
//////////////////////////////////////////////////////////////////////////////////


module Latch_IF_ID(	//Inputs
                    input Clk, 
                    input Reset, 
                    input [31:0] Adder_Out, 
					input [31:0] Instruction_In,
					input halt,
					input Stall, 
					input enable,
					//Outputs
					output reg [31:0] Latch_IF_ID_Adder_Out, 
					output reg [31:0] Latch_IF_ID_InstrOut,
					output reg Latch_IF_ID_halt);


always@(negedge Clk) begin
	if(Reset) begin //Si se resetea, se vuelven las 2 salidas a sus valores iniciales
		Latch_IF_ID_Adder_Out <= 0;
		Latch_IF_ID_InstrOut <= 32'h00000000; 
		Latch_IF_ID_halt<=0;
	end
	else begin		//Sino, los valores de entrada se asignan a la salida
		if(!Stall && enable) begin
			Latch_IF_ID_Adder_Out <= Adder_Out; 
			Latch_IF_ID_InstrOut <= Instruction_In;
			Latch_IF_ID_halt <= halt;
		end // Si Stall es 1 los valores no cambian
	end
end

endmodule

