%Creates a movable 3d model of a Full StockTray
classdef FullStockTray < Item
    properties
    end 

    methods
        function item = FullStockTray(baseTr)
            plyName = 'FullStockTray.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end