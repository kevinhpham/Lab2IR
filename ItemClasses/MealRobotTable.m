% Creates MealRobotTable (E05)

classdef MealRobotTable < Item
    properties
    end 

    methods
        function item = MealRobotTable(baseTr)
            plyName = 'MealRobotTable.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end