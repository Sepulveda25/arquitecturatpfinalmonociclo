`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2020 02:37:07
// Design Name: 
// Module Name: Unidad_halt
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


module Unidad_halt #(parameter LEN = 32)(
                                        input [LEN-1:0] E1_InstrOut,
                                        input           Reset,
                                        output reg      halt                                                  
 );
    
 
    always@*begin
        if (E1_InstrOut == 32'haaaaaaaa) begin // instruccion halt
          halt = 1;
        end 
        if (Reset == 1) halt = 0;   
    end
 
endmodule
