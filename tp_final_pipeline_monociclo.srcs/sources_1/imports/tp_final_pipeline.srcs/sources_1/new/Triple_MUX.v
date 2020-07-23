`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2019 21:58:41
// Design Name: 
// Module Name: Triple_MUX
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


module Triple_MUX   #(parameter LEN = 32)
                    (   input [LEN-1:0] InputA, 
                        input [LEN-1:0] InputB, 
                        input [LEN-1:0] InputC, 
                        input [1:0] SEL,
                        output reg [LEN-1:0] Out
                     );
                     
always@* begin
     case (SEL)
         2'b00:    Out <= InputA;
         2'b10:    Out <= InputB;
         2'b01:    Out <= InputC;
         default:  Out <= 0;
     endcase
end

endmodule
