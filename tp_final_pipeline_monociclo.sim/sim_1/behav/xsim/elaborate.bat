@echo off
REM ****************************************************************************
REM Vivado (TM) v2017.3 (64-bit)
REM
REM Filename    : elaborate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for elaborating the compiled design
REM
REM Generated by Vivado on Mon Jul 27 03:39:24 -0300 2020
REM SW Build 2018833 on Wed Oct  4 19:58:22 MDT 2017
REM
REM Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
REM
REM usage: elaborate.bat
REM
REM ****************************************************************************
call xelab  -wto 6a88cdf21b404479a82043049bcd4216 --incr --debug typical --relax --mt 2 -L xil_defaultlib -L blk_mem_gen_v8_4_0 -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot test_pipeline_monociclo_behav xil_defaultlib.test_pipeline_monociclo xil_defaultlib.glbl -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
