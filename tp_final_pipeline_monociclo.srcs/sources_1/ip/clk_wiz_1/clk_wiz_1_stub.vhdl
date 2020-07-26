-- Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2017.3 (win64) Build 2018833 Wed Oct  4 19:58:22 MDT 2017
-- Date        : Sun Jul 26 02:18:02 2020
-- Host        : DESKTOP-I9AG1Q0 running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub {e:/Facultad/Arquitectura de Computadoras/Practicos
--               Vivado/tp_final_pipeline_monociclo/arquitecturatpfinalmonociclo/tp_final_pipeline_monociclo.srcs/sources_1/ip/clk_wiz_1/clk_wiz_1_stub.vhdl}
-- Design      : clk_wiz_1
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a35tcpg236-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clk_wiz_1 is
  Port ( 
    clk_out1 : out STD_LOGIC;
    clk_in1 : in STD_LOGIC
  );

end clk_wiz_1;

architecture stub of clk_wiz_1 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "clk_out1,clk_in1";
begin
end;
