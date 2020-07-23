`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.07.2020 20:51:00
// Design Name: 
// Module Name: test_leer_archivo
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


module test_leer_archivo;
    
    integer  file, status;
    reg [31:0] data; 
    reg [31:0] aux; 
    initial begin
        file = $fopen("E:/Facultad/Arquitectura de Computadoras/Practicos Vivado/tp_final_pipeline/test_lectura_hex.txt","r");
//        file = $fopenr("E:/Facultad/Arquitectura de Computadoras/Practicos Vivado/tp_final_pipeline/test_lectura_hex.txt");
        if (file == 0) $error("E:\Facultad\Arquitectura de Computadoras\Practicos Vivado\tp_final_pipeline\test_lectura_hex.txt not opened");
        while(!$feof(file)) begin
          status = $fscanf(file,"%h",data);
          aux = data;
//          #20;
          $display("Salida de aux: %h",aux);  
        end
     status = $fcloser(file);
//     $stop;    
       
    end  
     
endmodule
