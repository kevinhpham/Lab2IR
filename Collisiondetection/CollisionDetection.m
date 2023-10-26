classdef CollisionDetection <handle
    %Contains static methods to perform collision checking between items
    %and a robot. Uses functions from week 5 tutorial

   
    methods(Static)    
        %% robotIsCollision
        % Given a serial link object/robot model,a trajectory (i.e. joint state vector) (qMatrix)
        % and an item/items, check if there is a collision.
        % Returns 1 if collision is found, otherwise return 0
        function result = robotIsCollision(robot,qMatrix,items,returnOnceFound)
            if nargin < 4
                returnOnceFound = true;             %If a collision is found along the path, immediately return by default
            end
            if not(iscell(items))                   %If items are not in a cell
                items = num2cell(items);             %convert items into cell
            end
            
            for j = 1:length(items)
                result = false;
                faces = items{j}.hitBox.faces;              %Extract parameters of item's hitbox
                vertex= items{j}.hitBox.vertexes;
                faceNormals = items{j}.hitBox.faceNormals;
                for qIndex = 1:size(qMatrix,1)
                    % Get the transform of every joint (i.e. start and end of every link)
                    tr = CollisionDetection.GetLinkPoses(qMatrix(qIndex,:), robot);
                
                    % Go through each link and also each triangle face
                    for i = 1 : size(tr,3)-1    
                        for faceIndex = 1:size(faces,1)
                            vertOnPlane = vertex(faces(faceIndex,1)',:);
                            [intersectP,check] = LinePlaneIntersection(faceNormals(faceIndex,:),vertOnPlane,tr(1:3,4,i)',tr(1:3,4,i+1)'); 
                            if check == 1 && CollisionDetection.IsIntersectionPointInsideTriangle(intersectP,vertex(faces(faceIndex,:)',:))
                                display(['CollisionDetection has detected upcoming collision between ', items{j}.plyFile,' and ', robot.name]);
                                result = true;
                                if returnOnceFound
                                    return
                                end
                            end
                        end    
                    end
                end
            end
        end
        
        %% itemIsCollision
        %checks if two item objects are/will collide with each other.
        %If a transform(tr) is entered, the function will check if there
        %would be a collisions if item1 was moved to that transform.
        % Returns 1 if collision is found, otherwise return 0
        function result = itemsIsCollision(item1,item2,tr)
            if nargin < 3
                tr = item1.base;
            end
            corners1 = ([item1.corners,ones(size(item1.corners,1),1)]); %convert corners into homogenous vectors
            corners2 = ([item2.corners,ones(size(item2.corners,1),1)]);
            for i =1:length(corners1(:,1))
                corners1(i,:) = corners1(i,:)*tr.';                     %converts corners to same frame
                corners2(i,:) = corners2(i,:)*item2.base.';             
            end
            
            %checks if corners are between eachother. If they are, that
            %means the items are intersecting eachother
            if and(corners1(1,1:3) <= corners2(2,1:3), corners2(1,1:3) <= corners1(1,1:3)) %if item1 lower corner is between item2 corners
                result = true;
            elseif and(corners1(2,1:3) <= corners2(2,1:3), corners2(1,1:3) <= corners1(2,1:3)) %if item1 upper corner is between item2 corners
                result = true;
            elseif and(corners2(1,1:3) <= corners1(2,1:3), corners1(1,1:3) <= corners2(1,1:3)) %if item2 lower corner is between item1 corners
                result = true;
            elseif and(corners2(2,1:3) <= corners1(2,1:3), corners1(1,1:3) <= corners2(2,1:3)) %if item2 upper corner is between item1 corners    
                result = true;
            else
                result = false;
            end
            if result == true
                display(['CollisionDetection has detected upcoming collision between ',item1.plyFile,' and ', item2.plyFile]);
            end
        end





        %% GetLinkPoses
        % q - robot joint angles
        % robot -  seriallink robot model
        % transforms - list of transforms as 3D matrix
        function [ transforms ] = GetLinkPoses(q, robot)
            
            links = robot.links;
            transforms = zeros(4, 4, length(links) + 1);
            transforms(:,:,1) = robot.base;
            
            for i = 1:length(links)
                L = links(1,i);
                
                current_transform = transforms(:,:, i);
                
                current_transform = current_transform * trotz(q(1,i) + L.offset) * ...
                transl(0,0, L.d) * transl(L.a,0,0) * trotx(L.alpha);
                transforms(:,:,i + 1) = current_transform;
            end
        end
        
        %% FineInterpolation
        % Use results from Q2.6 to keep calling jtraj until all step sizes are
        % smaller than a given max steps size
        function qMatrix = FineInterpolation(q1,q2,maxStepRadians)
            if nargin < 3
                maxStepRadians = deg2rad(1);
            end
                
            steps = 2;
            while ~isempty(find(maxStepRadians < abs(diff(jtraj(q1,q2,steps))),1))
                steps = steps + 1;
            end
            qMatrix = jtraj(q1,q2,steps);
        end
        
        %% InterpolateWaypointRadians
        % Given a set of waypoints, finely intepolate them
        function qMatrix = InterpolateWaypointRadians(waypointRadians,maxStepRadians)
            if nargin < 2
                maxStepRadians = deg2rad(1);
            end
            
            qMatrix = [];
            for i = 1: size(waypointRadians,1)-1
                qMatrix = [qMatrix ; FineInterpolation(waypointRadians(i,:),waypointRadians(i+1,:),maxStepRadians)]; %#ok<AGROW>
            end
        end

        %% IsIntersectionPointInsideTriangle
        % Given a point which is known to be on the same plane as the triangle
        % determine if the point is 
        % inside (result == 1) or 
        % outside a triangle (result ==0 )
        function result = IsIntersectionPointInsideTriangle(intersectP,triangleVerts)
        
        u = triangleVerts(2,:) - triangleVerts(1,:);
        v = triangleVerts(3,:) - triangleVerts(1,:);
        
        uu = dot(u,u);
        uv = dot(u,v);
        vv = dot(v,v);
        
        w = intersectP - triangleVerts(1,:);
        wu = dot(w,u);
        wv = dot(w,v);
        
        D = uv * uv - uu * vv;
        
        % Get and test parametric coords (s and t)
        s = (uv * wv - vv * wu) / D;
        if (s < 0.0 || s > 1.0)        % intersectP is outside Triangle
            result = 0;
            return;
        end
        
        t = (uv * wu - uu * wv) / D;
        if (t < 0.0 || (s + t) > 1.0)  % intersectP is outside Triangle
            result = 0;
            return;
        end
        
        result = 1;                      % intersectP is in Triangle
        end
    end
end

