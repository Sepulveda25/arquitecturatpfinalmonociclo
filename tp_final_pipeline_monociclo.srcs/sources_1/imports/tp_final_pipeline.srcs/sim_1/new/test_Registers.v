`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.08.2019 19:55:55
// Design Name: 
// Module Name: test_Registers
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


module test_Registers;

    // Inputs
    reg Clk;
    reg Reset;
    reg [4:0] ReadRegisterA; 
    reg [4:0] ReadRegisterB; 
    reg [4:0] WriteRegister; 
    reg [31:0] WriteData; 
    reg RegWrite;
	// Outputs
    wire [31:0] ReadDataA; 
    wire [31:0] ReadDataB;
    
     // Instantiate the Unit Under Test (UUT)
    Registers uut (
       .Clk(Clk), 
       .Reset(Reset),
       .ReadRegisterA(ReadRegisterA),
       .ReadRegisterB(ReadRegisterB),
       .WriteRegister(WriteRegister),
       .WriteData(WriteData),
       .RegWrite(RegWrite),
       .ReadDataA(ReadDataA),
       .ReadDataB(ReadDataB)
    );
  integer j;
    
    initial begin
        // Initialize Inputs
        Clk=1;
        Reset=1;
        ReadRegisterA=5'b00000; 
        ReadRegisterB=5'b00000; 
        WriteRegister=5'b00000; 
        WriteData=32'h00000000; 
        RegWrite=0;
        #20;//comprobando si todos los reg son igual a cero
        Reset=0;
        for(j = 0; j < 32; j = j+1)
            begin	
                ReadRegisterA = j;
                ReadRegisterB = j;
                #20;
            end
        // Se comienza a grabar
        RegWrite=1;
        for(j = 0; j < 32; j = j+1)
            begin    
                WriteRegister = j;
                WriteData = j; // se carga con 
                #20;
            end
        // Se verifica los datos grabados
        RegWrite=0;
        for(j = 0; j < 32; j = j+1)
            begin    
                ReadRegisterA = j;
                ReadRegisterB = j;
                #20;
            end
    end
    
   always begin //clock de la placa 50Mhz
        #10 Clk=~Clk;
    end 

endmodule
