%Creates a movable 3d model of a LoadConveyer
classdef LoadConveyor < Item
    properties
        detectionZone; %In reference frame of conveyor belt
        speed = 1;
    end 

    methods
        function item = LoadConveyor(baseTr)
            plyName = 'LoadConveyor.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
            item.updateDetectionZone();
        end
        
        function push(self, items)
            %Takes in multiple items and pushes them along conveyer belt by 5cm
            %at default speed
            if iscell(items)
                cellfun(@self.pushIndividual, items);
            end

            if isobject(items)
                arrayfun(@self.pushIndividual,items)
            end

        end

        function pushIndividual(self, item)
            %Takes individuals items and pushes them along conveyor belt
            verts = ([item.vertices,ones(size(item.vertices,1),1)])*item.base.'*inv(self.base).' %Convert vertices of item into conveyerbelt's frame of reference. due to how the vertices array is structured, have to use the transpose of transformation matrices
            for i = 1:length(verts(:,1))
                if and((verts(i,1:3) < self.detectionZone(2,1:3)), (self.detectionZone(1,1:3) < verts(i,1:3))) %for loop checks vertices until it detects one within zone
                    rot = self.base(1:3,1:3); % rot = rotational matrix of conveybelt
                    translation = rot*[0.05*self.speed,0,0].';%orientatates the "push" to the conveybelt's orientation. 
                    tr = transl(translation)*item.base;
                    item.move(tr);
                    break
                end
            end
        end
        
        function updateDetectionZone(self)
            %Updates the detection zone of the conveyor belt.
            %The detection zone is a rectangular volume on top of the
            %conveyerbelt."push" method checks if items are in this area before
            %pushing them. the detection zone is stored as two
            %homogenous vectors representing opposite corners of the
            %rectangular volume
            verts = self.vertices;      %the vertices of the conveyor
            mins = [min(verts(:,1)), min(verts(:,2)+0.1), max(verts(:,3)),1];%A homogenous vector representing bottom corner of the zone
            maxs = [max(verts(:,1)), max(verts(:,2)-0.1), max(verts(:,3))+0.1,1];%A homogenous vector representing the opposite top corner
            self.detectionZone = [mins ; maxs]; %In reference frame of conveyor belt
        end
    end
end