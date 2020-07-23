`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10.07.2020 00:45:37
// Design Name: 
// Module Name: test_datos_de_archivo_a_memoria
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


module test_datos_de_archivo_a_memoria;
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

    integer  file, status,j=0;
    reg [31:0] data; 
    reg [31:0] aux; 
    
    initial begin
        clka = 1;
        addra = 32'h00000000; 
        dina = 32'h00000000; 
        ena = 1;
        rsta = 0;
        wea = 4'b1111;
        file = $fopen("E:/Facultad/Arquitectura de Computadoras/Practicos Vivado/tp_final_pipeline/test_lectura_hex.txt","r");
        if (file == 0) $error("E:\Facultad\Arquitectura de Computadoras\Practicos Vivado\tp_final_pipeline\test_lectura_hex.txt not opened");
        #20;
        //escritura en memoria
        while(!$feof(file)) begin
            status = $fscanf(file,"%h",data);
            aux = data;
            addra = j; 
            dina = aux;           
            $display("Dato: %h ; Direccion %h",dina,addra,"; Tiempo simulacion (ns)",$time);
            j = j+4;
            #20;  
        end
        $fclose(file);
        ena = 0;//deshabilita la memoria
        wea = 4'b0000; //deshabilita la escritura en memoria
        addra = 0;
        dina=0;
        #20; 
        ena = 1; //habilita la escritura en memoria
        for(j = 0; j <= 32; j = j+4)//se leen 8 direcciones
            begin    
                addra = j;
                #20;
                $display("Dato salida: %h ; Direccion %h",douta,addra,"; Tiempo simulacion (ns)",$time);
            end
    end
    
    
    always begin //clock de la placa 50Mhz
            #10 clka=~clka;
    end     
endmodule
