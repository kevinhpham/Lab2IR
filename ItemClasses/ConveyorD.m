% Creates conveyors that deliver items to the robot

classdef ConveyorD < Item
    properties
    end 

    methods
        function item = ConveyorD(baseTr)
            plyName = 'Conveyor-D.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end