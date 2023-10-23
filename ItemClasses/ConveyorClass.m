% Creates a moveable 3D model of conveyorbelts with conveyorbelt functionalities

classdef ConveyorClass < Item
    properties(Access = public)
        detectionZone;          % Instantiates a detection zone within the reference frame of conveyor belt item
        pushDistance = 0.02;    % Controls how much the conveyorbelt pushes items in meters
                                % Value can be changed as needed (variable)
    end 

    % Setting out functions for the ConveyorClass
    methods
        function item = ConveyorClass(plyName,baseTr)
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)    % Format required to run code (input plyName and baseTr)
            item.updateDetectionZone();         % Based on the input, feed into 'updateDetectionZone() method
        end

        % Function: Takes in multiple items and pushes them along the conveyer belt
        function push(self, items)  
            if iscell(items)
                cellfun(@self.pushIndividual, items);
            end

            if isobject(items)
                arrayfun(@self.pushIndividual,items)
            end

        end

        % Takes individual items and pushes them along if they are on the belt
        function pushIndividual(self, item)
            %disp([self.plyFile ' is checking ' item.plyFile]);                 %For debuggin
            verts = ([item.vertices,ones(size(item.vertices,1),1)])*item.base.'*inv(self.base).' ;             % Converts vertices of item into conveyerbelt's frame of reference. due to how the vertices array is structured, have to use the transpose of transformation matrices
            for i = 1:length(verts(:,1))
                if and((verts(i,1:3) < self.detectionZone(2,1:3)), (self.detectionZone(1,1:3) < verts(i,1:3)))  % For loop checks vertices until it detects one within zone
                    rot = self.base(1:3,1:3);                                                                   % rot = rotational matrix of conveybelt
                    translation = rot*[self.pushDistance,0,0].';                                                % Orientatates the "push" to the conveybelt's orientation
                    tr = transl(translation)*item.base;
                    item.move(tr);
                    %disp([self.plyFile ' has pushed ' item.plyFile, ' by ', num2str(self.pushDistance),'m'])
                    break
                end
            end  
        end
    
    % Function: Returns push distance of conveyorbelt
    function [pushDistance] = getPushDistance(self)
        pushDistance = self.pushDistance;
    end

    % Function: Sets push distance of conveyorbelt in meters
    function setPushDistance(self,x)
        self.pushDistance = x;
    end

    % Function: Returns detection zone of conveyorbelt
    function [detectionZone] = getDetectionZone(self)
        detectionZone = self.detectionZone;
    end

    end

    methods(Access = private)

        % Function: Updates the detection zone of the conveyor belt.
        function updateDetectionZone(self)

        % NOTE
        % The detection zone is a rectangular prism on top of the
        % conveyerbelt.
        % The "push" method checks if items are in this area before
        % pushing them. 
        % The detection zone is stored as two homogenous vectors 
        % representing opposite corners of the rectangular volume.

                verts = self.vertices;                                                  % The vertices of the conveyor
                mins = [min(verts(:,1)), min(verts(:,2)), max(verts(:,3)),1];      % A homogenous vector representing bottom corner of the zone
                maxs = [max(verts(:,1)), max(verts(:,2)), max(verts(:,3))+0.1,1];  % A homogenous vector representing the opposite top corner
                self.detectionZone = [mins ; maxs];                                     % In reference frame of the conveyor belt
        end
    end
end