%Creates a movable 3d model of a Conveyor2
classdef Conveyor2 < Item
    properties
    end 

    methods
        function item = Conveyor2(baseTr)
            plyName = 'Conveyor2.0.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end