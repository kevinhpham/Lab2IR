% This class creates a 3D chef that can be imported into the workspace.
classdef ChefPerson < Item
    properties
    end 

    methods
        function item = ChefPerson(baseTr)
            plyName = 'ChefPerson.ply'; % Imports the ply file
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end