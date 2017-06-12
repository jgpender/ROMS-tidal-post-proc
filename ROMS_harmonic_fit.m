function  [amp,pha]=harmonic_fit(time,y,omega)
%function [amp,pha]=harmonic_fit(time,y,omega)
% written by Harper Simmons based on a clever tip independently provided  by Luc Rainville & Steve Jayne, April 2012
% added mean + trend fit May 2014
% sample call:
% O1   = 1./0.0387307;K1   =1./0.0417807; M2   =1./0.0805114;  S2   =1./0.0833333;  
% omega = [1/S2 1/M2 1/O1 1/K1];                  % [cycles per hour]
% dat is an array that is dimensioned (nobs x nstations),  time is in hours
% [amp,pha]=harmonic_fit(time,dat,omega);
%-------------------------------------------------
%     G = [(1+0*time) time sin(2*pi*time*omega) cos(2*pi*time*omega)];  
    G = [(1+0*time) time cos(2*pi*time*omega) sin(2*pi*time*omega)];  
%   G = [                sin(2*pi*time*omega) cos(2*pi*time*omega)];  
    m = (transpose(G)*G)\(transpose(G)*y);
%%
%    keyboard
%%
for idx = 3:length(omega)+2 % first two indices are mean + trend
%for idx = 1:length(omega) % first two indices are mean + trend
		amp(idx-2,:) =   sqrt(m(idx,:).^2+m(idx+length(omega),:).^2);
		pha(idx-2,:) = atan2(-m(idx,:),m(idx+length(omega),:));
end
