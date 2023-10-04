%Creates a movable 3d model of a StockTray
classdef StockTray < Item
    properties
    end 

    methods
        function item = StockTray(baseTr)
            plyName = 'EmptyStockTray.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end