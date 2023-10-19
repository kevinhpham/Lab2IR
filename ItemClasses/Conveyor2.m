%Creates a movable 3d model of a Conveyor2
classdef Conveyor2 < ConveyorClass
    properties
    end 

    methods
        function conveyor = Conveyor2(baseTr)
            plyName = 'Conveyor2.0.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            conveyor = conveyor@ConveyorClass(plyName,baseTr)
            conveyor.updateDetectionZone();
        end
    end
end