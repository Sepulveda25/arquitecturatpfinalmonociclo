`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2020 03:13:11
// Design Name: 
// Module Name: test_unidad_halt
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


module test_unidad_halt;
    //input
    reg [31:0] E1_InstrOut;
    reg           Reset;
    //output
    wire         halt; 
    
    Unidad_halt uut (
        .E1_InstrOut(E1_InstrOut),
        .Reset(Reset),
        .halt(halt) 
        );
    
    initial begin
    E1_InstrOut=0;
    Reset=1;
    #20;
    E1_InstrOut=32'hb1b1b1b1;
    Reset=0;
//    #20;
//    E1_InstrOut=32'hafafafaf; //se activa señal de halt
//    Reset=0;
    #20;
    E1_InstrOut=32'hafafafaf; //se activa señal de halt
    Reset=1;
//    #20;
//    E1_InstrOut=32'he2e2e2e2; //se activa señal de halt
//    Reset=0;
    end
endmodule
