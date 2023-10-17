classdef Item < handle
    properties
    obj;
    vertices; %vertices of item in item's base frame
    base;
    plyFile; %Name of ply file of item
    end 

    methods
        function self = Item(item,baseTr)
            %Place 'item' into environment at 'baseTR'
            %'baseTR' is relative to global frame of reference
            %item = '.ply'
            %baseTr = 4x4 homogenous transformation
            
            %try to use colored version of PLY file, If none exist use the
            %none colored version
            % filepath= append('PLYFILES\ColouredPlyFiles\',item);
            % if exist(filepath,"file") == 2
            % else
            %     msg = 'Cannot not find colored version, using default file instead.';
            %     warning(msg)
                 filepath= item;
            % end
            
            % If baseTr not provided, set to origin
            if nargin < 1
                baseTr = eye(4);
            end

            hold on
            self.obj = PlaceObject(filepath);
            self.vertices = get(self.obj,'Vertices');
            transformedVertices = [self.vertices,ones(size(self.vertices,1),1)] * baseTr.';
            set(self.obj,'Vertices',transformedVertices(:,1:3));
            self.base = baseTr;
            self.plyFile = item;
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
