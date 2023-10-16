% Creates class for Glass Barrier

classdef GlassBarrier < Item
    properties
    end 

    methods
        function item = GlassBarrier(baseTr)
            plyName = 'GlassBarrier.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end