% Creates a movable 3D model of c Conveyor 2
% Conveyor 2 is the main conveyor used to assemble meal trays.

classdef Conveyor2 < ConveyorClass

    methods
        function conveyor = Conveyor2(baseTr)
            plyName = 'Conveyor2.0.PLY'; % Corresponds to the PLY file for the object
            if nargin < 1
                baseTr = eye(4);
            end
            conveyor = conveyor@ConveyorClass(plyName,baseTr)
        end
    end
end