function [x,y] = fcn_RoadSeg_findXYfromST(geomType,x0,y0,h0,s0,l0,s,t,varargin)


switch geomType
  case 'line'
    if nargin > 8
      warning('Ignoring extra arguments for line geometry')
    end
    
    % Add together the contribution to the x position of the initial x,y
    % coordinate, the travel down the road line, and the offset from the
    % centerline of the line (defined as the heading + pi/2) given the s,t
    % coordinate system
    x = (s(:)-s0).*cos(h0) + t(:).*cos(h0+pi/2) + x0;
    y = (s(:)-s0).*sin(h0) + t(:).*sin(h0+pi/2) + y0;
    
  case 'arc'
    if nargin < 9
      error('Not enough input arguments to define arc geometry')
    elseif nargin > 9
      warning('Ignoring extra arguments for arc geometry')
    else
      K0 = varargin{1};
    end
    
    % Find the point along the path with t = 0
    [x,y] = fcn_RoadSeg_findXYfromXODRArc(s(:)-s0,h0,x0,y0,K0);
    % Compute the heading at the specified points
    h = K0*(s(:)-s0) + h0;
    % Offset the x and y coordinates by the projection along t (which is
    % aligned at the heading plus pi/2)
    x = x + t(:)*cos(h+pi/2);
    y = y + t(:)*sin(h+pi/2);
    
  case 'spiral'
    if nargin < 10
      error('Not enough input arguments to define spiral geometry')
    elseif nargin > 10
      warning('Ignoring extra arguments for spiral geometry')
    else
      K0 = varargin{1};
      KF = varargin{2};
      
      % Find the point along the path with t = 0
      [x,y] = fcn_RoadSeg_findXYfromXODRSpiral(s(:)-s0,l0,h0,x0,y0,K0,KF);
      % Compute the heading at the specified points
      h = (KF-K0)/l0*(s(:)-s0).^2/2 + K0*s + h0;
      % Offset the x and y coordinates by the projection along t (which is
      % aligned at the heading plus pi/2)
      x = x + t(:)*cos(h+pi/2);
      y = y + t(:)*sin(h+pi/2);
    
    end
end

end