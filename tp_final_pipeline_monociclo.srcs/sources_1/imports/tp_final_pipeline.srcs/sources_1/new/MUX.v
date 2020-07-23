`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2019 10:35:15
// Design Name: 
// Module Name: MUX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Multiplexor de 2 entradas y una salida (bus parametrizable, por defecto de 32 de bits)
// 
//////////////////////////////////////////////////////////////////////////////////


module MUX #(parameter LEN = 32)(input [LEN-1:0] InputA, input [LEN-1:0] InputB, input SEL, output [LEN-1:0] Out);

assign Out = (SEL) ? InputB:InputA; //Si SEL es igual a 1 entonces Out sera igual a InputB

endmodule
