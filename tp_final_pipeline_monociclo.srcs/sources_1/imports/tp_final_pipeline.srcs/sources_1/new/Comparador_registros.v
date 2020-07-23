`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2020 20:08:38
// Design Name: 
// Module Name: Comparador_registros
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


module Comparador_registros #(parameter LEN = 32)(
                               input [LEN-1:0] 	  E2_ReadDataA,  
                               input [LEN-1:0]    E2_ReadDataB,
                               output             es_igual,
                               output             no_igual
);

assign  es_igual = (E2_ReadDataA==E2_ReadDataB)? 1'b1:1'b0;
assign  no_igual = !(es_igual);
    
endmodule
