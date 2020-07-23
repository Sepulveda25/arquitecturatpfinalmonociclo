`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2019 21:53:47
// Design Name: 
// Module Name: Shift_Left
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


module Shift_Left(  input [31:0] Latch_ID_Ex_SignExtendOut , 
                    output [31:0] Shift_Left_Out);

assign Shift_Left_Out = Latch_ID_Ex_SignExtendOut << 2; 

endmodule
