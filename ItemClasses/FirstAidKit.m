%Creates a movable 3d model of a first aid kit
classdef FirstAidKit < Item
    properties
    end 

    methods
        function item = FirstAidKit(baseTr)
            plyName = 'FirstAidKit.ply';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end
