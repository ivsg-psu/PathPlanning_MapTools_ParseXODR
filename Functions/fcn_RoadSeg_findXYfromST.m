function [x,y] = fcn_RoadSeg_findXYfromST(geomType,x0,y0,h0,s0,s,t,varargin)


switch geomType
  case 'line'
    if nargin > 7
      warning('Ignoring extra arguments for line geometry')
    end
    
    % Add together the contribution to the x position of the initial x,y
    % coordinate, the travel down the road line, and the offset from the
    % centerline of the line (defined as the heading + pi/2) given the s,t
    % coordinate system
    x = (s(:)-s0).*cos(h0) + t(:).*cos(h0+pi/2) + x0;
    y = (s(:)-s0).*sin(h0) + t(:).*sin(h0+pi/2) + y0;
    
  case 'arc'
    if nargin < 8
      error('Not enough input arguments to define arc geometry')
    elseif nargin > 8
      warning('Ignoring extra arguments for arc geometry')
    else
      K0 = varargin{1};
    end
    
    [x,y] = fcn_RoadSeg_findXYfromXODRArc(s(:)-s0,h0,x0,y0,K0);

  case 'spiral'
    if nargin < 9
      error('Not enough input arguments to define spiral geometry')
    elseif nargin > 9
      warning('Ignoring extra arguments for spiral geometry')
    else
      K0 = varargin{1};
      KF = varargin{2};
      
      [x,y] = fcn_RoadSeg_findXYfromXODRSpiral(s(:)-s0,h0,x0,y0,K0,KF);
    end
end

end