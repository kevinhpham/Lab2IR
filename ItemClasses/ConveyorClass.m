%Represent 3D model of conveyorbelts with conveyorbelt functionalities
classdef ConveyorClass < Item
    properties(Access = private)
        detectionZone; %In reference frame of conveyor belt
        pushDistance = 0.05; %Controls how much the conveyorbelt pushes items in meters
    end 

    methods
        function item = ConveyorClass(plyName,baseTr)
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
            item.updateDetectionZone();
        end

        function push(self, items)  
            %Takes in multiple items and pushes them along the conveyer belt
            %if on the belt
            if iscell(items)
                cellfun(@self.pushIndividual, items);
            end

            if isobject(items)
                arrayfun(@self.pushIndividual,items)
            end

        end

        function pushIndividual(self, item)
            %Takes individuals items and pushes them along if they're on the belt
            verts = ([item.vertices,ones(size(item.vertices,1),1)])*item.base.'*inv(self.base).'; %Convert vertices of item into conveyerbelt's frame of reference. due to how the vertices array is structured, have to use the transpose of transformation matrices
            for i = 1:length(verts(:,1))
                if and((verts(i,1:3) < self.detectionZone(2,1:3)), (self.detectionZone(1,1:3) < verts(i,1:3))) %for loop checks vertices until it detects one within zone
                    rot = self.base(1:3,1:3); % rot = rotational matrix of conveybelt
                    translation = rot*[self.pushDistance,0,0].';%orientatates the "push" to the conveybelt's orientation. 
                    tr = transl(translation)*item.base;
                    item.move(tr);
                    break
                end
            end  
        end

    function [pushDistance] = getPushDistance(self)
        %returns push distance of conveyorbelt
        pushDistance = self.pushDistance;
    end

    function setPushDistance(self,x)
        %sets push distance of conveyorbelt in meters
        self.pushDistance = x;
    end

    function [detectionZone] = getDetectionZone(self)
        %returns detection zone of conveyorbelt
        detectionZone = self.detectionZone;
    end

    end

    methods(Access = private)
        function updateDetectionZone(self)
                %Updates the detection zone of the conveyor belt.
                %The detection zone is a rectangular prism on top of the
                %conveyerbelt."push" method checks if items are in this area before
                %pushing them. the detection zone is stored as two
                %homogenous vectors representing opposite corners of the
                %rectangular volume
                verts = self.vertices;      %the vertices of the conveyor
                mins = [min(verts(:,1)), min(verts(:,2)+0.05), max(verts(:,3)),1];%A homogenous vector representing bottom corner of the zone
                maxs = [max(verts(:,1)), max(verts(:,2)-0.05), max(verts(:,3))+0.1,1];%A homogenous vector representing the opposite top corner
                self.detectionZone = [mins ; maxs]; %In reference frame of conveyor belt
        end
    end

end