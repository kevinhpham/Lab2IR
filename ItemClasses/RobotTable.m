%Creates a movable 3d model of a RobotTable
classdef RobotTable < Item
    properties
    end 

    methods
        function item = RobotTable(baseTr)
            plyName = 'RobotTable.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end
