%Creates a movable 3d model of a tray
classdef Tray < Item
    properties
    end 

    methods
        function item = Tray(baseTr)
            plyName = 'Tray.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end
