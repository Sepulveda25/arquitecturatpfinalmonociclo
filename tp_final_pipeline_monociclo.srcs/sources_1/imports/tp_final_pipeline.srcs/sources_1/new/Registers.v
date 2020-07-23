`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 19:43:53
// Design Name: 
// Module Name: Registers
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


module Registers(   input Clk, 
                    input Reset, 
                    input [4:0] ReadRegisterA, 
                    input [4:0] ReadRegisterB, 
					input [4:0] WriteRegister, 
					input [31:0] WriteData, 
					input RegWrite,
					output [31:0] ReadDataA, 
					output [31:0] ReadDataB
					);

//Lista de 32 registros de 32 bits c/u
reg [31:0] array[31:0];

// Variables
integer j;

//Si ocurre un Reset, se vuelven todos los valores de array a sus valores iniciales (0)
//Sino si llega el FLAG de RegWrite (de la Unidad de Control) entonces se guarda en el array el resultado (WriteData)
always@(posedge Clk) begin
	if(Reset) 			begin		for(j = 0; j < 32; j = j+1)	array[j] <= 0;	end 
	else begin
		if(RegWrite) 	begin 	array[WriteRegister] <= WriteData; 				end
	end
end

//Siempre se redirecciona a ReadDataA y ReadDataB lo que hay en el 
//array apuntado por sus respectivos punteros (ReadRegisterA y ReadRegisterB)
assign ReadDataA = array[ReadRegisterA];
assign ReadDataB = array[ReadRegisterB];
					

endmodule
