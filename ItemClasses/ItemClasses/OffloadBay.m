%Creates a movable 3d model of a OffloadBay
classdef OffloadBay < Item
    properties
    end 

    methods
        function item = OffloadBay(baseTr)
            plyName = 'OffloadBay.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end
