% Creates conveyors that deliver items to the robot

classdef ConveyorD < ConveyorClass
    properties
    end 

    methods
        function conveyor = ConveyorD(baseTr)
            plyName = 'Conveyor-D.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            conveyor = conveyor@ConveyorClass(plyName,baseTr)
        end
    end
end