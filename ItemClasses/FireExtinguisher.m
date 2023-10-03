%Creates a 3d model of an ugly fire exinguisher
classdef FireExtinguisher < Item
    properties
    end 

    methods
        %This function constructs an 'FireExtinguisher' objects which inherits
        %functions and data fields from 'Item' class.
        function item = FireExtinguisher(baseTr) %change this to class name
            plyName = 'FireExtinguisher.ply'; %change this to corresponding .ply file name
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end
