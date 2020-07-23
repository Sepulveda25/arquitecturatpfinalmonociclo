`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.11.2019 17:51:54
// Design Name: 
// Module Name: Jump_Branch_PCSrc
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


module Jump_Branch_PCSrc(
                            input Latch_Ex_MEM_JR_or_JALR_flag,//nuevo
                            input Latch_Ex_MEM_J_or_JAL_flag, //nuevo
                            input Branch,
                            output reg [1:0] PCScr
                        );
                        
always@* begin
     case ({Latch_Ex_MEM_JR_or_JALR_flag,Latch_Ex_MEM_J_or_JAL_flag,Branch})
     
     3'b001://Branch
        PCScr =2'b01;
     3'b010://Jump o JAL
        PCScr =2'b10;
     3'b100://JR o JALR
        PCScr =2'b11;
     default:// no es ni jump ni branch
        PCScr =2'b00;
     
     endcase
    
end

endmodule
