`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2019 17:35:08
// Design Name: 
// Module Name: test_latch_ID_EX
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
module test_Latch_ID_EX;

	// Inputs
    reg Clk;
    reg Reset;
    reg [31:0] Latch_IF_ID_Adder_Out; 
    reg [8:0] ControlFLAGS;
    reg [31:0] ReadDataA; 
    reg [31:0] ReadDataB; 
    reg [31:0] SignExtendOut; 
    reg [4:0] Latch_IF_ID_InstrOut_25_21_Rs;
    reg [4:0] Latch_IF_ID_InstrOut_20_16_Rt;
    reg [4:0] Latch_IF_ID_InstrOut_15_11_Rd; 
    reg [2:0] E2_InmCtrl;
    reg enable;
	// Outputs
    wire [1:0] WriteBack_FLAGS; 
    wire [2:0] Mem_FLAGS; 
    wire [3:0] Ex_FLAGS;
    wire [31:0] Latch_ID_Ex_Adder_Out;
    wire [31:0] Latch_ID_Ex_ReadDataA;
    wire [31:0] Latch_ID_Ex_ReadDataB;
    wire [31:0] Latch_ID_Ex_SignExtendOut; 
    wire [4:0] Latch_ID_Ex_InstrOut_25_21_Rs;
    wire [4:0] Latch_ID_Ex_InstrOut_20_16_Rt;
    wire [4:0] Latch_ID_Ex_InstrOut_15_11_Rd;
    wire [2:0] Latch_ID_Ex_InmCtrl;

	// Instantiate the Unit Under Test (UUT)
	Latch_ID_EX uut (
		.Clk(Clk), 
		.Reset(Reset),
		.Latch_IF_ID_Adder_Out(Latch_IF_ID_Adder_Out), 
        .ControlFLAGS(ControlFLAGS),
        .ReadDataA(ReadDataA), 
        .ReadDataB(ReadDataB), 
        .SignExtendOut(SignExtendOut), 
        .Latch_IF_ID_InstrOut_25_21_Rs(Latch_IF_ID_InstrOut_25_21_Rs),
        .Latch_IF_ID_InstrOut_20_16_Rt(Latch_IF_ID_InstrOut_20_16_Rt),
        .Latch_IF_ID_InstrOut_15_11_Rd(Latch_IF_ID_InstrOut_15_11_Rd), 
        .E2_InmCtrl(E2_InmCtrl),
        .enable(enable),
        .WriteBack_FLAGS(WriteBack_FLAGS), 
        .Mem_FLAGS(Mem_FLAGS), 
        .Ex_FLAGS(Ex_FLAGS),
        .Latch_ID_Ex_Adder_Out(Latch_ID_Ex_Adder_Out),
        .Latch_ID_Ex_ReadDataA(Latch_ID_Ex_ReadDataA),
        .Latch_ID_Ex_ReadDataB(Latch_ID_Ex_ReadDataB),
        .Latch_ID_Ex_SignExtendOut(Latch_ID_Ex_SignExtendOut), 
        .Latch_ID_Ex_InstrOut_25_21_Rs(Latch_ID_Ex_InstrOut_25_21_Rs),
        .Latch_ID_Ex_InstrOut_20_16_Rt(Latch_ID_Ex_InstrOut_20_16_Rt),
        .Latch_ID_Ex_InstrOut_15_11_Rd(Latch_ID_Ex_InstrOut_15_11_Rd),
        .Latch_ID_Ex_InmCtrl(Latch_ID_Ex_InmCtrl)
		
	);
// OPCODE out tipo-R
//   8 RegDst 		<=	1;
//   7 ALUSrc 		<=	0;
//   6 MemtoReg 	<=	0;
//   5 RegWrite 	<=	1;
//   4 MemRead 		<=	0;
//   3 MemWrite 	<=	0;
//   2 Branch 		<=	0;
//   1 ALUOp1 		<=	1;
//   0 ALUOp0 		<=  0; 
//    InmCtrl		<=	0;
//    Jmp			<= 0;
   
   
	initial begin
		// Initialize Inputs
		Clk = 1;
		Reset=1;
		// add r1 r2 r3
		// Binary: 0000.0000.0100.0011.0000.1000.0010.0000
        // Hex: 0x00430820
		Latch_IF_ID_Adder_Out=32'h00000004; 
        ControlFLAGS=9'b100100010;
        ReadDataA=32'h00000003; 
        ReadDataB=32'h00000002; 
        SignExtendOut=32'h00000820; 
        Latch_IF_ID_InstrOut_25_21_Rs=5'b00010;
        Latch_IF_ID_InstrOut_20_16_Rt=5'b00011;
        Latch_IF_ID_InstrOut_15_11_Rd=5'b00001; 
        E2_InmCtrl=3'b000;
        enable=0;
        #20;
        Reset=0;
        // add r1 r2 r3
        // Binary: 0000.0000.0100.0011.0000.1000.0010.0000
        // Hex: 0x00430820
        Latch_IF_ID_Adder_Out=32'h00000004; 
        ControlFLAGS=9'b100100010;
        ReadDataA=32'h00000003; 
        ReadDataB=32'h00000002; 
        SignExtendOut=32'h00000820; 
        Latch_IF_ID_InstrOut_25_21_Rs=5'b00010;
        Latch_IF_ID_InstrOut_20_16_Rt=5'b00011;
        Latch_IF_ID_InstrOut_15_11_Rd=5'b00001; 
        E2_InmCtrl=3'b000;
        enable=0;
        #20;
        Reset=0;
        // add r1 r2 r3
        // Binary: 0000.0000.0100.0011.0000.1000.0010.0000
        // Hex: 0x00430820
        Latch_IF_ID_Adder_Out=32'h00000004; 
        ControlFLAGS=9'b100100010;
        ReadDataA=32'h00000003; 
        ReadDataB=32'h00000002; 
        SignExtendOut=32'h00000820; 
        Latch_IF_ID_InstrOut_25_21_Rs=5'b00010;
        Latch_IF_ID_InstrOut_20_16_Rt=5'b00011;
        Latch_IF_ID_InstrOut_15_11_Rd=5'b00001; 
        E2_InmCtrl=3'b000;
        enable=1;
        // Salida
//        WriteBack_FLAGS <= 2'b10; 
//        Mem_FLAGS <= 3'b000;
//        Ex_FLAGS <= 4'b1010;
//        Latch_ID_Ex_Adder_Out <= 32'h00000004;
//        Latch_ID_Ex_ReadDataA <= 32'h00000003;
//        Latch_ID_Ex_ReadDataB <= 32'h00000002;
//        Latch_ID_Ex_SignExtendOut <= 32'h00000820;
//        Latch_ID_Ex_InstrOut_25_21_Rs <= 5'b00010;
//        Latch_ID_Ex_InstrOut_20_16_Rt <= 5'b00011;
//        Latch_ID_Ex_InstrOut_15_11_Rd <= 5'b00001;
//        Latch_ID_Ex_InmCtrl    <= 3'b000;
        
		
	end
	
   always begin //clock de la placa 50Mhz
		#10 Clk=~Clk;
	end      
   
endmodule
