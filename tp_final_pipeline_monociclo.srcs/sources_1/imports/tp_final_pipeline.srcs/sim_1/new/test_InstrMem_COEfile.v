`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.09.2019 18:04:20
// Design Name: 
// Module Name: test_InstrMem_COEfile
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


module test_InstrMem_COEfile;

    // Inputs
    reg [31:0] addra; 
	reg clka;
	reg [31:0] dina; 
    reg ena;
    reg rsta; 
    reg [3:0] wea; 
	// Outputs
	wire [31:0] douta;

	// Instantiate the Unit Under Test (UUT)
	Instruction_memory uut (
		.addra(addra), 
		.clka(clka),
		.dina(dina),
		.ena(ena),
		.rsta(rsta),
		.wea(wea),
		.douta(douta)
	);
 
  integer j;   
    initial begin
        // Initialize Inputs
        clka = 1;
        addra = 32'h00000000; 
        dina = 32'h00000000; 
        ena = 1;
        rsta = 0; 
        wea = 4'b0000;
        #20;//comprobando si todos los reg son igual a cero
        rsta=0;
        for(j = 0; j < 32; j = j+4)//con (+1) se comprueba que la memoria solo lee de a 4
            begin    
                addra = j;
                #20;
            end
             
    end
    
   always begin //clock de la placa 50Mhz
        #10 clka=~clka;
    end   

endmodule
