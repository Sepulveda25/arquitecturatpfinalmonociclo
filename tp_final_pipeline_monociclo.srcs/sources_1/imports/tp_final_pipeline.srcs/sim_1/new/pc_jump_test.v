`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.10.2019 18:03:27
// Design Name: 
// Module Name: pc_jump_test
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


module pc_jump_test;
    // Inputs
    reg [3:0]  pc_31_28;   
    reg [25:0] instr_index;
    // Outputs
    wire [31:0] pc_jmp_jal;

    // Instantiate the Unit Under Test (UUT)
    pc_jump uut (
        .pc_31_28(pc_31_28), 
        .instr_index(instr_index),
        .pc_jmp_jal(pc_jmp_jal)
    );
    
    initial begin
        pc_31_28=4'b1111;
        instr_index=26'b00110011001100110011001100;
    end

endmodule
