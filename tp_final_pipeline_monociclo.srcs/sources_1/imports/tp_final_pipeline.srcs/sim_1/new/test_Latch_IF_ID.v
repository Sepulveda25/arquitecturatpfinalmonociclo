`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.08.2019 16:41:17
// Design Name: 
// Module Name: test_Latch_IF_ID
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
module test_Latch_IF_ID;

	// Inputs
	reg Clk; 
    reg Reset; 
    reg [31:0] Adder_Out; 
    reg [31:0] Instruction_In; 
    reg Stall; 
    reg enable;
	// Outputs
	wire [31:0] Latch_IF_ID_Adder_Out; 
    wire [31:0] Latch_IF_ID_InstrOut;

	// Instantiate the Unit Under Test (UUT)
	Latch_IF_ID uut (
		.Clk(Clk), 
		.Reset(Reset),
		.Adder_Out(Adder_Out),
		.Instruction_In(Instruction_In),
		.Stall(Stall),
		.enable(enable),
		.Latch_IF_ID_Adder_Out(Latch_IF_ID_Adder_Out),
		.Latch_IF_ID_InstrOut(Latch_IF_ID_InstrOut)
	);

   
	initial begin
		// Initialize Inputs
		Clk = 1;
		Reset=1;
		Adder_Out=32'h00000004; // pc=4
		Instruction_In=32'h00430820; // add r1 r2 r3
        Stall=1;
        enable=0;
		#20;
		Reset=0;
        Adder_Out=32'h00000004; // pc=4
        Instruction_In=32'h00430820; // add r1 r2 r3
        Stall=1;
        enable=0;
        #20;
        Reset=0;
        Adder_Out=32'h00000004; // pc=4
        Instruction_In=32'h00430820; // add r1 r2 r3
        Stall=0;
        enable=1;
        #20;
        Reset=0;
        Adder_Out=32'h00000004; // pc=4
        Instruction_In=32'h000430822; // add r1 r2 r3
        Stall=0;
        enable=1;
	end
	
   always begin //clock de la placa 50Mhz
		#10 Clk=~Clk;
	end      
   
endmodule

