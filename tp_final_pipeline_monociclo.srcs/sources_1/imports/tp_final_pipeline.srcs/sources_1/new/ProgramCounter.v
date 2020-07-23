`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2019 10:29:56
// Design Name: 
// Module Name: ProgramCounter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Contador de Programa (PC) de 32 bits. Sincronizado con CLK y con Reset Asincrono
// 
//////////////////////////////////////////////////////////////////////////////////


module ProgramCounter(  input Clk, 
                        input Reset, 
                        input enable,
                        input [31:0] In, 
                        output reg [31:0] Out);


//always@(posedge Clk) begin
always@(negedge Clk) begin
	if(Reset) begin	
	    Out <= 0;		//Si hay un reset, PC = 0
    end
	else begin 
	   if (enable) begin Out <= In;	end 
    end
end

endmodule
