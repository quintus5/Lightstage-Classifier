% ard setup
% only need to do once
clc;clear;

% init arduino
ard = arduino('COM3', 'Uno', 'Libraries', 'ShiftRegister');
% port on the connector to shift register
%{ 
   c l g   d 5
  |l|a|n| |a|v|
  |k|t|d| |t| |
  |_|_|_|_|_|_|
%}
% set it on arduino
latch = 'D10';
clk = 'D11';
data = 'D9';
reset = 'D12';
reg = shiftRegister(ard,'74HC595',data,clk,latch,reset);
