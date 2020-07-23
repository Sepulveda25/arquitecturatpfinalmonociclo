`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2019 10:40:04
// Design Name: 
// Module Name: Adder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Sumador parametrizable
// 
//////////////////////////////////////////////////////////////////////////////////


module Adder #(parameter LEN = 32) (input [LEN-1:0] InputA, input [LEN-1:0] InputB, output [LEN-1:0] Out);

assign Out = InputA + InputB;

endmodule
