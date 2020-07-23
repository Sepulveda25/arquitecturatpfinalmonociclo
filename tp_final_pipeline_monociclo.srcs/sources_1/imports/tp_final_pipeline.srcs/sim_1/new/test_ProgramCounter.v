`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.08.2019 11:58:06
// Design Name: 
// Module Name: test_ProgramCounter
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


module test_ProgramCounter;

    // Inputs
	reg Clk;
    reg Reset;
    reg enable;
    reg [31:0] In; 
	// Outputs
	wire [31:0] Out;

	// Instantiate the Unit Under Test (UUT)
	ProgramCounter uut (
		.Clk(Clk), 
        .Reset(Reset), 
        .enable(enable),
        .In(In), 
        .Out(Out)
	);
    
    initial begin
        // Initialize Inputs
        Clk = 1;
        Reset = 1;
        enable = 0;
        In = 32'h00430820; // add r1 r2 r3;
        #20; 
        Reset = 0;
        enable = 0;
        In = 32'h00430820; // add r1 r2 r3;
        #20; 
        Reset = 0;
        enable = 1;
        In = 32'h00430820; // add r1 r2 r3;
        #20; 
        Reset = 0;
        enable = 0;
        In = 32'h00430822; // sub r1 r2 r3
    end
    
   always begin //clock de la placa 50Mhz
        #10 Clk=~Clk;
    end   


endmodule
