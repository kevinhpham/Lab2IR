%Creates a movable 3d model of a MealBox
classdef MealBox < Item
    properties
    end 

    methods
        function item = MealBox(baseTr)
            plyName = 'MealBox.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end