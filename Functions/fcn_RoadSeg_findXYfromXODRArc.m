function [x,y] = fcn_RoadSeg_findXYfromXODRArc(s,h0,x0,y0,K0,varargin)
% Script to determine the X,Y coordinates along a segment of a road defined
% as an "arc" segment in the XODR standard. The arc is plotted if a figure
% handle is provided

% The path can be expressed in parametric integral form:
% x = int_0^s cos(K0*s + h0) ds + x0
% y = int_0^s sin(K0*s + h0) ds + y0
% where K0*s is the included angle of the arc length s, h0 is the initial
% angle. These integral expressions can be solved explicitly and a
% vectorized implementation of the calculations is easily formed.
if nargin < 5
  error('Not enough input arguments to determine the arc segment geometry');
elseif nargin > 6
  warning('Extra arguments ignored in determining arc segment geometry');
else
  x = (sin(K0*s(:) + h0) - sin(h0))/K0 + x0;
  y = (-cos(K0*s(:) + h0) + cos(h0))/K0 + y0;
end

% Check to see if the user has provided a figure handle to plot into. If
% so, add the X,Y points to the plot
if 6 == nargin && isgraphics(varargin{1})
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