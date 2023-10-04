%Creates a movable 3d model of a LoadConveyer
classdef LoadConveyor < Item
    properties
    end 

    methods
        function item = LoadConveyor(baseTr)
            plyName = 'LoadConveyor.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end