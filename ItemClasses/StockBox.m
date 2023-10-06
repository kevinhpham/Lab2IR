%Creates a 3d model of an StockBox
classdef StockBox < Item
    properties
    end 

    methods
        %This function constructs 'StockBox' objects which inherits
        %functions and data fields from 'Item' class.
        function item = StockBox(baseTr) %change this to class name
            plyName = 'StockBox.PLY'; %change this to corresponding .ply file name
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end