`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:08:44 11/30/2017 
// Design Name: 
// Module Name:    contador_clk 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module contador_clk #(parameter LEN = 32)(
	 input wire clk, 
	 input wire reset,
	 input wire enable,
    output reg [LEN-1:0] count
    );

reg [LEN-1:0] count_reg=1, count_next=1;


 always @(negedge clk,posedge reset)
	if(reset) 
		count_reg <= 0;
	else 
		count_reg <= count_next;

always @ *
	if (enable)
		count_next = count_reg + 1;
	else
		count_next = count_reg;
always @ *
	count=count_reg;

endmodule
