% Creates class for a LightCurtain
% The LightCurtain is a safety feature that detects if a ChefPerson has
% walked into a park of the workspace with robots (E05_L)

classdef LightCurtain < Item
    properties
    end 

    methods
        function item = LightCurtain(baseTr)
            plyName = 'LightCurtain.PLY'; % Ply file name
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end