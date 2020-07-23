`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01.09.2019 21:55:59
// Design Name: 
// Module Name: Sign_Extend
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


module Sign_Extend #(parameter LEN_output = 32,LEN_input=16)
                    (   input  [LEN_input-1:0] SignExtendIn, 
                        output [LEN_output-1:0] SignExtendOut
                    );
//Variable auxiliar con signo
reg signed [LEN_output-1:0] aux;

always@* begin
    aux[LEN_output-1:LEN_output-LEN_input] = SignExtendIn; 
end

//mueve a la derecha (LEN_output-LEN_input) veces, manteniendo signo
assign SignExtendOut = aux >>> (LEN_output-LEN_input); 

endmodule
