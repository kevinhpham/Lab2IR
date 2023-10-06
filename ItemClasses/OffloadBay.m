%Creates a 3d model of an OffloadBay
classdef OffloadBay < Item
    properties
    end 

    methods
        %This function constructs an 'FireExtinguisher' objects which inherits
        %functions and data fields from 'Item' class.
        function item = OffloadBay(baseTr) %change this to class name
            plyName = 'OffloadBay.PLY'; %change this to corresponding .ply file name
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end