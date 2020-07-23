`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.09.2019 00:44:10
// Design Name: 
// Module Name: test_Etapa4_MEM
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


module test_Etapa4_MEM;

    // Inputs
    reg Clk; 
    reg Reset;
    reg Latch_Ex_MEM_Zero;
    reg [2:0] Mem_FLAGS;
    reg [31:0] Latch_Ex_MEM_ALUOut;    
    reg [31:0] dirMem;                 
    reg memDebug;               
    reg [31:0]     Latch_Ex_MEM_ReadDataB;
	// Outputs
    wire [31:0] E4_DataOut;
    wire PCScr;
    
    // Instantiate the Unit Under Test (UUT)
    Etapa4_MEM uut (
        .Clk(Clk), 
        .Reset(Reset), 
        .Latch_Ex_MEM_Zero(Latch_Ex_MEM_Zero),
        .Mem_FLAGS(Mem_FLAGS),
        .Latch_Ex_MEM_ALUOut(Latch_Ex_MEM_ALUOut),
        .dirMem(dirMem),
        .memDebug(memDebug),
        .Latch_Ex_MEM_ReadDataB(Latch_Ex_MEM_ReadDataB),
        .E4_DataOut(E4_DataOut),
        .PCScr(PCScr)
    );
    
    initial begin
        // Initialize Inputs
        Clk = 1;
        Reset = 1;
        Latch_Ex_MEM_Zero=0;
        Mem_FLAGS= 3'b000;
        Latch_Ex_MEM_ALUOut = 32'h00000000;    
        dirMem = 32'h00000000;                 
        memDebug =0;               
        Latch_Ex_MEM_ReadDataB = 32'h00000000;          
    end

    always begin //clock de la placa 50Mhz
        #10 Clk=~Clk;
    end 

endmodule
