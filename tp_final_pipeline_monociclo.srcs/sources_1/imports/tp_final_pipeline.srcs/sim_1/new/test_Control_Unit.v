`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.08.2019 20:23:53
// Design Name: 
// Module Name: test_Control_Unit
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


module test_Control_Unit;

    // Inputs
    reg [5:0] OpCode;
    
	// Outputs
    wire [8:0] ControlFLAGS;
    wire [2:0] InmCtrl;
    wire  Jmp;

	// Instantiate the Unit Under Test (UUT)
	Control_Unit uut (
		.OpCode(OpCode), 
		.ControlFLAGS(ControlFLAGS),
		.InmCtrl(InmCtrl),
		.Jmp(Jmp)
	);


 initial begin
        // Initialize Inputs
       OpCode=6'b000000; //R-Format
       #20;
       OpCode=6'b100011; //LoadW
       #20;
       OpCode=6'b101011; //StoreW
       #20;
       OpCode=6'b000100; //BranchEQ 
       #20;
       OpCode=6'b000010; //Jump 
       #20;
       OpCode=6'b001000; //Immediate Operations 
          
    end
endmodule
