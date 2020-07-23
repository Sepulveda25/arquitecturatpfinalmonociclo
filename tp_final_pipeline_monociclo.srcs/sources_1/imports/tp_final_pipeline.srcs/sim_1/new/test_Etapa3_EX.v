`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.09.2019 22:32:46
// Design Name: 
// Module Name: test_Etapa3_EX
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


module test_Etapa3_EX;

    // Inputs
    reg [3:0] Ex_FLAGS;
    reg [31:0] Latch_ID_Ex_Adder_Out; 
    reg [31:0] Latch_ID_Ex_ReadDataA;
    reg [31:0] Latch_ID_Ex_ReadDataB;
    reg [31:0] Latch_ID_Ex_SignExtendOut; 
    reg [4:0] Latch_ID_Ex_InstrOut_20_16_Rt; 
    reg [4:0] Latch_ID_Ex_InstrOut_15_11_Rd;
    reg [2:0] Latch_ID_Ex_InmCtrl;
    reg [31:0] Latch_Ex_MEM_ALUOut;    
    reg [31:0] Mux_WB;                   
    reg [1:0] ForwardA;                
    reg [1:0] ForwardB;            
	// Outputs
    wire [31:0] E3_Adder_Out; 
    wire [31:0] E3_ALUOut; 
    wire E3_ALU_Zero;
    wire [4:0] E3_MuxOut;
    wire [31:0] MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB;
    
    // Instantiate the Unit Under Test (UUT)
    Etapa3_EX uut (
        .Ex_FLAGS(Ex_FLAGS), 
        .Latch_ID_Ex_Adder_Out(Latch_ID_Ex_Adder_Out), 
        .Latch_ID_Ex_ReadDataA(Latch_ID_Ex_ReadDataA), 
        .Latch_ID_Ex_ReadDataB(Latch_ID_Ex_ReadDataB),
        .Latch_ID_Ex_SignExtendOut(Latch_ID_Ex_SignExtendOut), 
        .Latch_ID_Ex_InstrOut_20_16_Rt(Latch_ID_Ex_InstrOut_20_16_Rt), 
        .Latch_ID_Ex_InstrOut_15_11_Rd(Latch_ID_Ex_InstrOut_15_11_Rd),
        .Latch_ID_Ex_InmCtrl(Latch_ID_Ex_InmCtrl),
        .Latch_Ex_MEM_ALUOut(Latch_Ex_MEM_ALUOut),   
        .Mux_WB(Mux_WB),                    
        .ForwardA(ForwardA),                
        .ForwardB(ForwardB), 
        .E3_Adder_Out(E3_Adder_Out), 
        .E3_ALUOut(E3_ALUOut), 
        .E3_ALU_Zero(E3_ALU_Zero),
        .E3_MuxOut(E3_MuxOut),
        .MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB(MuxCortoB_to_MuxAULScr_Latch_EX_MEM_DataB)
    );
    
    initial begin
        // Initialize Inputs 
        Ex_FLAGS=4'b0000;
        Latch_ID_Ex_Adder_Out = 32'h00000000;
        Latch_ID_Ex_ReadDataA= 32'h00000000;
        Latch_ID_Ex_ReadDataB= 32'h00000000;
        Latch_ID_Ex_SignExtendOut= 32'h00000000; 
        Latch_ID_Ex_InstrOut_20_16_Rt= 5'b00000; 
        Latch_ID_Ex_InstrOut_15_11_Rd= 5'b00000;
        Latch_ID_Ex_InmCtrl=3'b000;
        Latch_Ex_MEM_ALUOut = 32'h00000000;    
        Mux_WB = 32'h00000000;                  
        ForwardA=2'b00;               
        ForwardB=2'b00;          
    end
    

endmodule
