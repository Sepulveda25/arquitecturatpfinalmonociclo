`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.09.2019 01:53:42
// Design Name: 
// Module Name: ALU
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


module ALU#(parameter LEN = 32)
            (//Inputs
            input [LEN-1:0] ALU_DataA, 
            input [LEN-1:0] ALU_DataB, 
            input [5:0] ALU_Control_Out, 
            input [4:0] Shift,
            //Outputs
            output reg [LEN-1:0] ALU_Out, 
            output Zero
            );
assign Zero = (ALU_Out == 0); //se fija si es 0

always@*
begin
    case (ALU_Control_Out)
        
        6'b100000://ADD 100000
             ALU_Out = $signed(ALU_DataA) + $signed(ALU_DataB);
        6'b100010://SUB 100010
             ALU_Out = $signed(ALU_DataA) - $signed(ALU_DataB);
        6'b100100://AND 100100
             ALU_Out = ALU_DataA & ALU_DataB;
        6'b100101://OR 100101
             ALU_Out = ALU_DataA | ALU_DataB;
        6'b100110://XOR 100110
             ALU_Out = ALU_DataA ^ ALU_DataB;
        6'b100111://NOR 100111
             ALU_Out = ~(ALU_DataA | ALU_DataB);
        
        //------------------- UNSIGNED --------------------------------------
        6'b100001://ADDU (Add Unsigned Word) 100001
            ALU_Out = ALU_DataA + ALU_DataB;	
        6'b100011://SUBU (Subtract Unsigned Word) 100011	
            ALU_Out = ALU_DataA - ALU_DataB;   
        
        //------------------- SHIFTS ----------------------------------------		
        6'b000011://SRA (Shift Word Right Aritmetic) 000011
            ALU_Out = $signed(ALU_DataB) >>> Shift;
        6'b000010://SRL (Shift Word Right Logical) 000010
            ALU_Out = ALU_DataB >> Shift;
        6'b000000://SLL (Shift Word Left Logical) 000000
            ALU_Out = ALU_DataB << Shift;
        6'b000100://SLLV (Shift Word Left Logical Variable) 000100
            ALU_Out = ALU_DataB << ALU_DataA;	
        6'b000110://SRLV (Shift Word Right Logical Variable) 000110
            ALU_Out = ALU_DataB >> ALU_DataA;
        6'b000111://SRAV (Shift Word Right Aritmetic Variable) 000111
            ALU_Out = $signed(ALU_DataB) >>> ALU_DataA;
                
        //------------------- SETS -------------------------------------------
        6'b101010://SLT (Set On Less Than) 101010
        begin
            if($signed(ALU_DataA) < $signed(ALU_DataB)) ALU_Out = 1;
            else ALU_Out = 0;
        end
         
        6'b101011://SLTI (Set On Less Than Unsigned) 101011   
        begin
            if(ALU_DataA < ALU_DataB) ALU_Out = 1;
            else ALU_Out = 0;
        end
       
        //------------------- Default ----------------------------------------
        default:  
            ALU_Out = 0;
    endcase	        
end
	
endmodule
