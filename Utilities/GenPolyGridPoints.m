%%  Raster Polygon Grid Points Generation
%   By Long Wang, 2016/9/16
%   This func is modified from Copyright (c) 2013, Sulimon
%%  The following comments are from Sulimon's version
%   inPoints = getPolygonGrid(xv,yv,ppa) returns points that are within a
%   concave or convex polygon using the inpolygon function.

%   xv and yv are columns representing the vertices of the polygon, as used in
%   the Matlab function inpolygon

%   ppa refers to the points per unit area you would like inside the polygon.
%   Here unit area refers to a 1.0 X 1.0 square in the axes.
%%  This code change the original squence to be raster.
function [inPoints] = GenPolyGridPoints( xv,yv,ppa)
N = sqrt(ppa);
%Find the bounding rectangle
lower_x = min(xv);
higher_x = max(xv);
lower_y = min(yv);
higher_y = max(yv);
%Create a grid of points within the bounding rectangle
inc_x = 1/N;
inc_y = 1/N;
interval_x = lower_x:inc_x:higher_x;
interval_y = lower_y:inc_y:higher_y;
[bigGridX, bigGridY] = meshgrid(interval_x, interval_y);
Inverse_bigGridY = flip(bigGridY,1);
%Filter grid to get only points in polygon
in = inpolygon(bigGridX(:), bigGridY(:), xv, yv);
%Return the co-ordinates of the points that are in the polygon
inPoints = [bigGridX(in), bigGridY(in)];

end

