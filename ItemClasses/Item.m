classdef Item < handle
    properties
    obj;
    vertices;
    base;
    end 

    methods
        function self = Item(item,baseTr)
            %Place 'item' into environment at 'baseTR'
            %'baseTR' is relative to global frame of reference
            %item = '.ply'
            %baseTr = 4x4 homogenous transformation
            
            %try to use colored version of PLY file, If none exist use the
            %none colored version
            try
                rmpath("PLYFILES\NoColored\")
                addpath("PLYFILES\Colored\")
                self.obj = PlaceObject(item);
            catch
                msg = "No colored file availiable. Proceeding to use none colored file.";
                warning(msg)
                addpath("PLYFILES\NoColored\")
            end
            if nargin < 2
                baseTr = eye(4);
            end
            hold on
            self.obj = PlaceObject(item);
            self.vertices = get(self.obj,'Vertices');
            transformedVertices = [self.vertices,ones(size(self.vertices,1),1)] * baseTr.';
            set(self.obj,'Vertices',transformedVertices(:,1:3));
            self.base = baseTr;
        end

        function move(self,tr)
            %Moves items by 'tr' relative to global frame of reference
            %tr = 4x4 homogenous transformation
            hold on
            transformedVertices = [self.vertices,ones(size(self.vertices,1),1)] * tr.';
            set(self.obj,'Vertices',transformedVertices(:,1:3));
            self.base = tr;
        end
    end 
end 
