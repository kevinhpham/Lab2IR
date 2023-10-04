%Creates a movable 3d model of a Cutlery
classdef Cutlery < Item
    properties
    end 

    methods
        function item = Cutlery(baseTr)
            plyName = 'Cutlery.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end