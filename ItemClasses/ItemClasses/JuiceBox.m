%Creates a juicebox
classdef JuiceBox < Item
    properties
    end 

    methods
        function item = JuiceBox(baseTr)
            plyName = 'JuiceBox.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end
