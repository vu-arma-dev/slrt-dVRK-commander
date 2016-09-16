function [ Pattern] = GenScanPattern( Points,shape,stepsize)
%%  Long Wang, 2014/9/24
%   This function will generate a scan pattern for an area defeined by either a triangle or rectangle 
%   Points: (3 X N)
%   shpae: "tri" for triangle; "quad" for quadrilateral
%   Pattern: (3 X N)
%   The triangle point index is like this:
%   The scan pattern will end at p3
%         p1*
%           *  *
%    side1  *    *  side2
%           *      *
%           *        *   
%         p2***********p3
%   
%   The quadrilateral point index is like this
%   The scan pattern will end at p3
%         p1***************** p4
%           *              *
%   side1   *             * side2
%           *            *
%           *           *        
%         p2***********p3
%%  Main function Section
%%   Parse input points
    p1 = Points(:,1);
    p2 = Points(:,2);
    p3 = Points(:,3);
    L_side1 = norm(p1-p2);
    if strcmp(shape,'quad')
        p4 = Points(:,4);
        L_side2 = norm(p4-p3);
    else
        L_side2 = norm(p1-p3);
    end
%%   Decide the point number based 
    if L_side1<L_side2
        NumPts = round(L_side1/stepsize) + 1;
    else
        NumPts = round(L_side2/stepsize) + 1;
    end
    if mod(NumPts,2)==0 % The points number must be odd
        NumPts = NumPts + 1;
    end
%%  Compelete the scan pattern
    side1X = linspace(p1(1),p2(1),NumPts);
    side1Y = linspace(p1(2),p2(2),NumPts);
    side1Z = linspace(p1(3),p2(3),NumPts);
    side1 = [side1X;side1Y;side1Z;];
switch shape
    case 'tri'
        side2X = linspace(p1(1),p3(1),NumPts);
        side2Y = linspace(p1(2),p3(2),NumPts);
        side2Z = linspace(p1(3),p3(3),NumPts);
        side2 = [side2X;side2Y;side2Z;];
        Pattern = zeros(3,2*NumPts-1);
        % The following sequence is a little bit interesting, draw it! you will see!
        Pattern(:,1:4:end) = side2(:,1:2:end);
        Pattern(:,2:4:end) = side2(:,2:2:end);
        Pattern(:,3:4:end) = side1(:,2:2:end);
        Pattern(:,4:4:end) = side1(:,3:2:end);
    case 'quad'
        side2X = linspace(p4(1),p3(1),NumPts);
        side2Y = linspace(p4(2),p3(2),NumPts);
        side2Z = linspace(p4(3),p3(3),NumPts);
        side2 = [side2X;side2Y;side2Z;];
        Pattern = zeros(3,2*NumPts);
        % The following sequence is a little bit interesting, draw it! you will see!
        Pattern(:,1:4:end) = side1(:,1:2:end);
        Pattern(:,2:4:end) = side2(:,1:2:end);
        Pattern(:,3:4:end) = side2(:,2:2:end);
        Pattern(:,4:4:end) = side1(:,2:2:end);
end
end

