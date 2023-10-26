%Represent a 3d model of an item
classdef Item < handle
    properties
    obj;
    vertices;   %In local frame of item
    base;       %4x4 transform matrix of item frame to parent frame
    plyFile;    %Name of the plyfile of the item model
    hitBox;     %Corners of a rectangular prism that envelope the item's model. Main use for basic collision detection.
    corners;    %Corner points are relative to item's frame.
    end 

    methods
        function self = Item(item,baseTr)
            %Constructs and places 'Item' into 3d environment at 'baseTR'
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
            corner1 = [min(self.vertices(:,1)), min(self.vertices(:,2)), min(self.vertices(:,3))];  % A vector representing bottom corner of hitbox
            corner2 = [max(self.vertices(:,1)), max(self.vertices(:,2)), max(self.vertices(:,3))];  % A vector representing the opposite top corner of hitbox
            self.corners = [corner1 ; corner2];
            self.hitBox = Hitbox(corner1,corner2,self.base);
        end

        function move(self,tr)
            %Changes item's frame to 'tr'
            %tr = 4x4 homogenous transformation
            hold on
            transformedVertices = [self.vertices,ones(size(self.vertices,1),1)] * tr.';
            set(self.obj,'Vertices',transformedVertices(:,1:3));
            self.base = tr;
            self.hitBox.update(self.corners(1,:),self.corners(2,:),tr);
        end
    end 
end 
