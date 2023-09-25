classdef Item < handle
    properties
    obj;
    vertices;
    end 

    methods
        function self = Item(item,baseTr)
        %Place item(.ply file) into environment at baseTR
        self.obj = PlaceObject(item);
        self.vertices = get(self.obj,'Vertices');
        transformedVertices = [self.vertices,ones(size(self.vertices,1),1)] * baseTr.';
        set(self.obj,'Vertices',transformedVertices(:,1:3));
        end

        function move(self,tr)
        %Moves items relative to global frame of reference by tr

        transformedVertices = [self.vertices,ones(size(self.vertices,1),1)] * tr.';
        set(self.obj,'Vertices',transformedVertices(:,1:3));
        end
    end 
end 
