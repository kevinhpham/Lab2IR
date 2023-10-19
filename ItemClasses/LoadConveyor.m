%Creates a movable 3d model of a LoadConveyer
classdef LoadConveyor < ConveyorClass
    properties
    end 

        methods
            function conveyor = LoadConveyor(baseTr)
                plyName = 'LoadConveyor.PLY';
                if nargin < 1
                    baseTr = eye(4);
                end
                conveyor = conveyor@ConveyorClass(plyName,baseTr)
            end
        end
    end
