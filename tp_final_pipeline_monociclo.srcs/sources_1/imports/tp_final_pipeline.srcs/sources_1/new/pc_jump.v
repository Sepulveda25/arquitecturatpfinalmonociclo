`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2019 17:45:47
// Design Name: 
// Module Name: pc_jump
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

//Se concatena los 4 bit mas significativos del pc de jmp o jal con el valor de instr_index 
module pc_jump(
                input [3:0]		pc_31_28, 
                input [25:0]	instr_index,
                output [31:0]   pc_jmp_jal 
            );
reg [1:0] ceros=0;          
assign pc_jmp_jal ={pc_31_28,instr_index,ceros};                     
            
endmodule
