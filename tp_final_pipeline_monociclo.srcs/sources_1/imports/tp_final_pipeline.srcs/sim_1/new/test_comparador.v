`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.07.2020 20:19:10
// Design Name: 
// Module Name: test_comparador
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


module test_comparador;
    //input
    reg [31:0] 	 E2_ReadDataA;  
    reg [31:0]   E2_ReadDataB;
    // Outputs
    wire  es_igual;
    wire  no_igual;
    
    // Instantiate the Unit Under Test (UUT)
    Comparador_registros uut (
        .E2_ReadDataA(E2_ReadDataA), 
        .E2_ReadDataB(E2_ReadDataB),
        .es_igual(es_igual),
        .no_igual(no_igual)
    );
   
   initial begin
   #20;
   E2_ReadDataA=4;
   E2_ReadDataB=9;
   #20;
   E2_ReadDataA=10;
   E2_ReadDataB=10;
   end 
endmodule
