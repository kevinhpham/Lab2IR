%Creates a movable 3d model of a estop button
classdef Estop < Item
    properties
    end 

    methods
        function item = Estop(baseTr)
            plyName = 'estop.ply';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end
