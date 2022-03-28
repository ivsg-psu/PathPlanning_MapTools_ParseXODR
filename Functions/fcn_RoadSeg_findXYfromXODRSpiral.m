function [x,y] = fcn_RoadSeg_findXYfromXODRSpiral(s,h0,x0,y0,K0,KF,varargin)
% Script to determine the X,Y coordinates along a segment of a road defined
% as a "spiral" segment in the XODR standard. The spiral is plotted if a
% figure handle is provided

% The path can be expressed in parametric integral form: 
% x = int_0^s cos((KF-K0)/sF*s^2/2 + K0*s + h0) ds + x0 
% y = int_0^s sin((KF-K0)/sF*s^2/2 + K0*s + h0) ds + y0

% where (KF-K0)/sF*s^2/2 + K0*s is the included angle of the spiral over
% length s, sF is the final distance along the path, and h0 is the initial
% angle. These integral expressions can be solved explicitly and a
% vectorized implementation of the calculations is formed, though the
% solution does depend on a numerical evaluation of the Fresnel integrals.

sF = s(end);
z1 = (KF-K0)/(sF*2);
x = x0 + (sqrt(pi/2)*(cos(K0^2/(4*z1) - h0)*(fresnelc((K0 + 2*z1*s(:))/(sqrt(z1)*sqrt(2*pi))) - fresnelc(K0/(sqrt(z1)*sqrt(2*pi)))) + sin(K0^2/(4*z1) - h0)*(fresnels((K0 + 2*z1*s(:))/(sqrt(z1)*sqrt(2*pi))) - fresnels(K0/(sqrt(z1)*sqrt(2*pi))))))/sqrt(z1);
y = y0 + (sqrt(pi/2)*(sin(K0^2/(4*z1) - h0)*(fresnelc(K0/(sqrt(z1)*sqrt(2*pi))) - fresnelc((K0 + 2*z1*s(:))/(sqrt(z1)*sqrt(2*pi)))) + cos(K0^2/(4*z1) - h0)*(fresnels((K0 + 2*z1*s(:))/(sqrt(z1)*sqrt(2*pi))) - fresnels(K0/(sqrt(z1)*sqrt(2*pi))))))/sqrt(z1);

% Check to see if the user has provided a figure handle to plot into. If
% so, add the X,Y points to the plot
if 7 == nargin && isgraphics(varargin{1})
  figure(varargin{1})
  % Determine the hold state of the figure
  holdState = ishold;
  % Turn on hold for the purposes of adding the clothoid segment
  hold on
  % Plot the clothoid segment with a medium gray dotted line
  plot(x,y,'*-.','color',0.4*[1 1 1])
  % Restore the original hold state of the plot as necessary
  if 0 == holdState
    hold off
  end
end