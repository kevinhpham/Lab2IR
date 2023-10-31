classdef E05_worker <handle
   % This Class Creates a E05 robot that moves trays and meals onto the conveyer
    properties
       robot; 
       gripper; 
       collidables; %items to perform collision checking on
    end

    methods
        %%setups worker with gripper
        function self = E05_worker(basetr)
            if nargin < 1			
			    basetr = eye(4);				
            end
            %Sets up a E05_L
            hold on
            self.robot = E05_L(basetr); %
            self.robot.model.offset = [0 pi/2 -pi/3 0 0 0];
            self.robot.model.plot(zeros(6))
            self.robot.model.delay = 0;
            self.robot.model.qlim = [
                              deg2rad([-360 360]);
                              deg2rad([-60 90]);
                              deg2rad([-30 120]);
                              deg2rad([-90 90]);
                              deg2rad([-10 150]);
                              deg2rad([-360 360])]; %set up joint limits for arm

           %Set up Gripper
           self.gripper = RG6_Gripper(self.robot.model.fkineUTS(self.robot.model.getpos()));
           self.gripper.setBase(self.robot.model.fkineUTS(self.robot.model.getpos()));
           self.gripper.plot([0 0 0]);
           self.gripper.setDelay(0)
           self.collidables = {};
        end

        %%Plots the workspace of the arm as a pointcloud and finds approximate volume
        function plotWorkspace(self)
            qlim = self.robot.model.qlim;
            base = self.robot.model.base.T;
            qStep = pi/6;
            pointCloudSize = prod(floor((qlim(1:6,1)-qlim(1:6,2))/qStep + 1));
            pointCloud = zeros(pointCloudSize,3);
            counter = 1;

            for q1=0:qStep:qlim(1,2)
              for q2=0:qStep:qlim(2,2)
                for q3=0:qStep:qlim(3,2)
                        q4 = 0;
                        q5 = 0;
                        q6 = 0;
                        q=[q1,q2,q3,q4,q5,q6];
                        tr = self.robot.model.fkineUTS(q);
                               % if (base(3,4)+0.01)< tr(3,4)
                                    pointCloud(counter,:) = (tr(1:3,4).');
                                    counter = counter +1;
                                %end
                end
              end
            end
        plot3(pointCloud(:,1),pointCloud(:,2),pointCloud(:,3),'r.');
        volume = (max(pointCloud(:,1))-min(pointCloud(:,1))*(max(pointCloud(:,2))-min(pointCloud(:,2))))*(max(pointCloud(:,3))-min(pointCloud(:,3)));
        disp(['Aproximated volume of workspace given current joint limits is ', num2str(volume),'m^3']);
        end

        function [qPath] = planMidDepositPath(self,placement,q0,steps)
            %Plans a path to reset the arm  joint position
             disp(['E05_Worker: Looking for mid path to deposit onto ', placement.plyFile]);
            if nargin < 4
                steps = 60;
                disp(['E05_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 3
                    msg = 'q0 is not given. q0 is the starting position of the robot arm and is used for inverse kinematic calculations. q0 helps path planners to find the most optimal joint path.';
                    warning(msg);
                end
            end
            if(strncmpi(placement.plyFile,'Conveyor',8)) %midpath to place onto conveyor
                qGoal = [-pi/2 0 pi/3 pi/2 pi/2 pi];
                qPath = jtraj(q0,qGoal,steps);
            elseif (strncmpi(placement.plyFile,'Tray',4)) %midpath to place onto tray
                qGoal = [-pi/2 0 pi/3 pi/2 pi/2 0];
                qPath = jtraj(q0,qGoal,steps);
            else
                msg= 'E05_Worker: no midpath avaliable for this item';
                warning(msg)
            end
        end

        function [qPath] = planMidPickPath(self,item,q0,steps)
            %Plans a path to reset the arm  joint position
             disp(['E05_Worker: Looking for mid path to pickup ', item.plyFile]);
            if nargin < 4
                steps = 60;
                disp(['E05_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 3
                    msg = 'q0 is not given. q0 is the starting position of the robot arm and is used for inverse kinematic calculations. q0 helps path planners to find the most optimal joint path.';
                    warning(msg);
                end
            end
            if(strncmpi(item.plyFile,'Mealbox',7)) %midpath to pickup mealbox
                qGoal = [-pi 0 pi/3 0 pi/4 0];
                qPath = jtraj(q0,qGoal,steps);
            elseif (strncmpi(item.plyFile,'Tray',4)) %midpath to pickup tray
                qGoal = [pi/2 -pi/12 pi/3 0 pi/2 0];
                qPath = jtraj(q0,qGoal,steps);
            else
                msg= 'E05_Worker: no midpath avaliable for this item';
                warning(msg)
            end

        end

        function [qPath] = planDepositPath(self,item,placement,steps)
            %Plans the path from picking up item and placing it down on.
            %Does not include retraction.
            %"placement" is the object to place 'item' on, e.g if placing
            %down a tray on conveyorbelt, "placement" = conveyorbelt, 'item' = tray.
            disp(['E05_Worker: Looking for deposit path for ', item.plyFile]);
            if nargin < 4
                steps = 60;
                disp(['E05_Worker: Planning for default number of steps: ',num2str(steps)])
            end
            q0 = self.robot.model.getpos();
            qPath1 = self.planRetract(q0,1,steps); %Lift up whatever item is grasped
            q0 = qPath1(length(qPath1()),:);
            qPath2 = self.planMidDepositPath(placement,q0,steps);
            q0 = qPath2(length(qPath2()),:);
            qPath3 = self.searchDeposit(item,placement,q0,0,steps);    
            qPath = [qPath1;qPath2;qPath3];
        end


        function [qPath] = planPickupPath(self,item,steps)
            %Returns a joint path the robot can take to pick up an item.
            disp(['E05_Worker: Planning pick up path for', item.plyFile]);
            if nargin < 3
                steps = 60;
                disp(['E05_Worker: Planning for default number of steps: ',num2str(steps)])
            end
                %Add midway paths
                q0 = self.robot.model.getpos();
                qPath1 = self.planMidPickPath(item,q0,steps);
                 %Add aapproach path
                q0 = qPath1(length(qPath1),:);
                disp(['E05_Worker: Looking for 2nd midwaypoint to pick up ', item.plyFile]);
                qPath2 = self.searchPickup(item,q0,0.3,steps); %Finds midpoint position
                %Add pickup path
                disp(['E05_Worker: Looking for endpoint to pick up ', item.plyFile]);
                q0 = qPath2(length(qPath2),:);
                qPath3 = self.searchPickup(item,q0,0,steps); %Place gripper onto item    
                qPath = [qPath1;qPath2;qPath3];
        end

        function [collision] = animateArm(self,qq,item)
            %animate arm, gripper and item to move together. returns true
            %if any part of the arm or item will collides with items in
            %"collidables"
            %To animate path smoothely, enter in jointsteps 1 by 1 with loop
             if nargin < 3
                 item = uint8.empty;
             end
            collision = 0;

            if not(isempty(item)) %if there is an item
                %check for collisions
                itemToEnd = inv(self.robot.model.fkineUTS(self.robot.model.getpos()))*item.base;    %Find item's tf relative to end effector's frame
                itemToGlobal = self.robot.model.fkineUTS(qq)*itemToEnd;                             %Find item's new global tf base on endeffectors movement
                size(self.collidables);

                if 0 < size(self.collidables)
                    check(1) = CollisionDetection.robotIsCollision(self.robot.model,qq,self.collidables);         %check if arm will collide
                    check(2) = self.gripper.isCollision(self.collidables,self.robot.model.fkineUTS(qq));          %check if gripper will collide once arm moves
                    check(3) = CollisionDetection.itemsIsCollision(item,self.collidables,itemToGlobal);           %check if item will collide
                    collision = any(check);                                %collision will return true if anything is colliding
                end
                
                if collision == 0                                          %If there is no collision, proceed to move
                    self.robot.model.animate(qq);                          %Move robot to new joint position
                    self.gripper.setBase(self.robot.model.fkineUTS(qq));   %Set new gripper base
                    self.gripper.animate(self.gripper.getPos());           %Move gripper to new base
                    item.move(itemToGlobal);                               %Move item to new location
                end

            else    %if there is no item
                if 0 < size(self.collidables)
                    check(1) = CollisionDetection.robotIsCollision(self.robot.model,qq,self.collidables);           %check if arm will collide
                    check(2) = self.gripper.isCollision(self.collidables,self.robot.model.fkineUTS(qq));            %check if gripper will collide once arm moves
                    collision = any(check);                                                             %return true if there is a collision
                end

                if collision == 0  %No collision, move arm
                    self.robot.model.animate(qq);
                    self.gripper.setBase(self.robot.model.fkineUTS(self.robot.model.getpos()));
                    self.gripper.animate(self.gripper.getPos());
                end
            end
        end

        function animateGripper(self, scale)
            %Opens and closes the gripper
            %To animate path smoothely, enter in scalesteps 1 by 1 with loop
            %scale = 0 = opened
            %scale = 1 = closed
            if or(1 < scale, scale < 0)
                msg = "An invalid gripper scale has been chosen. Choose a scale between 0 and 1";
                error(msg);
            end
            qlims = self.gripper.getQlim();
            q = [0 qlims(2,2) qlims(3,1)]*scale;
            self.gripper.animate(q);
        end

        function [jointPath] = planRetract(self,q0,distance,steps)
            %Returns path to retract end effector by "distance" meters using resolved
            %motion control and damped least squares
            %Uses robot's current position (q0) for path planning
            disp('E05_Worker: Planning path to retract end effector')
            if nargin < 4
                steps = 30;
                disp(['E05_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 3
                    distance = 0.5;
                    disp(['E05_Worker: Distance value is set to default: ',num2str(distance), "m"])
                    if nargin <2
                        msg = 'q0 is not given. q0 is the starting position of the robot arm and is used for inverse kinematic calculations.  q0 helps path planners to find the most optimal joint path';
                        warning(msg);
                    end
                end
            end
            endtr = self.robot.model.fkineUTS(q0);                       %get end effector frame
            Retractedtr = endtr*transl(0,0,-distance);                   %retracted end effector back in it's own z-axis
            z1 = [endtr(1:3,4).' zeros(1,3)];                            %starting translation of endeffector with orientation masked off (x y z r p y)
            z2 = [Retractedtr(1:3,4).' zeros(1,3)];                    %goal translation of endeffector with orientation masked off
            z = zeros(6,steps);                                         %empty matrix to store planned path for end effector
            s = lspb(0,1,steps);                                        % Create interpolation scalar for trapezoidal velocity path
            minManipMeasure = 0.3;                                      % Minimum measure of manipulativity before damping kicks in
            m = zeros(1,steps);                                         %empty matrix to store measure of manipulativity for each step
            errorValue= zeros(6,steps);
            for i = 1:steps
                z(:,i) = z1*(1-s(i)) + s(i)*z2;                 %creating straight line path for end effector to follow with trapezoidal velocity                
            end 
            jointPath = nan(steps,6);
            jointPath(1,:) = q0;                                %Start at q0 joint position
            for i = 1:steps-1
               zdot = z(:,i+1)-z(:,i);                          % Calculate velocity at discrete time step
               J = self.robot.model.jacob0(jointPath(i,:));     % Get the Jacobian at the current state                          % Take only first 2 rows
               m(:,i)= sqrt(det(J*J'));                         %Calculate current measure of manipulativity
               if m(:,i) < minManipMeasure                      %if below threshhold manipulativity
                    lambda = (1-(m(:,i)/minManipMeasure)^2)*0.3;
                    qdot = inv((J'*J+lambda*eye(6)))*J'*zdot;   %Use dampled least squared
               else
               qdot = inv(J)*zdot();                            % Solve velocitities via RMRC
               end
            errorValue(:,i) = zdot- J*qdot;
            jointPath(i+1,:) = jointPath(i,:)+qdot.';           %Update the next joint state
            end           
            disp('E05_Worker: Path to retract arm found.')
            disp('E05_Worker: Here are the joint velocity errors:')
            %display(errorValue.')
        end

        function addCollidables(self,items)
            if iscell(items)    %if items are in a cell
                self.collidables = horzcat(self.collidables,items);
            end

            if isobject(items)  %if items in array
                self.collidables = horzcat(self.collidables,(num2cell(items)));
            end
        end 

        function [q] = GetPos(self);
            q = self.robot.model.getpos();
        end
    end
    

    methods(Hidden)
        function [qPath] = searchPickup(self,item,q0,buffer,steps)
            %Return path to place gripper above an item by buffer amount
            %buffer is the vertical distance between item and gripper, in meters.
            %Loops to checks vertices until it find a vertice that it can reach. 
            %Will try to pickup items from above
            if nargin < 5
                steps = 45;
                disp(['E05_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 4
                    buffer = 0;
                    disp(['E05_Worker: buffer value is set to default: ',num2str(buffer),'m'])
                    if nargin < 3
                        msg = 'q0 is not given. q0 is the starting position of the robot arm and is used for inverse kinematic calculations. q0 helps path planners to find the most optimal joint path';
                        warning(msg);
                    end
                end
            end
            verts = ([item.vertices,ones(size(item.vertices,1),1)]); %vertices of item
            %Find out what item is being picked up and the corresponding gripper
            %pose to pick up that item.
            if(strncmpi(item.plyFile,'MealBox.ply',7))
                disp('E05_Worker: Using gripper pose for mealbox')
                buffer = buffer-0.02 + self.gripper.getHeight();
                gripTr = transl(0.05,0,buffer)*rpy2tr(pi,0,pi/2); %pose for picking up mealboxes
                [~,index] = max(verts(:,3)); %Look for highest point in list of verticies, which is the handle of box
                targetPosition = item.base*transl(verts(index,1:3))*gripTr; %get target pose for final arm link to align gripper properly
            
            elseif(strncmpi(item.plyFile,'Tray.ply',4))
                disp('E05_Worker: Using gripper pose for tray')
                buffer = buffer + (item.corners(2,1))*1.5 + self.gripper.getHeight();  % distance between arm end link and pickup =buffer + traylength + gripper height
                gripTr = rpy2tr(0,pi/2,0)*transl(0,0,-buffer);                      %pose for picking up top edge of tray
                x = item.corners(2,2);                                          %Top edge of Tray
                y = (item.corners(1,2) + item.corners(2,2))/2;              %Center of Tray
                z = (item.corners(2,3) - item.corners(1,3))/2;                %center of Tray
                pickUpPoint = [x y z];                                             %Point to place tray in conveyorbelts frame of reference
                targetPosition = item.base*transl(pickUpPoint)*gripTr;             %get target pose to move gripper to in global frame. frame transformation = gripperTr > depositPoint > item > Global
            else
                msg = ["Robot wasn't design to pick up",item.plyFile];
                warning(msg);
            end
                targetJoints = self.robot.model.ikcon(targetPosition,q0); %perform inverse kinematic for joint positions
                disp('E05_Worker: Found target joint positions');
                disp('E05_Worker: Target End effector pose:')
                disp(targetPosition)
                disp('E05_Worker: Auctual End effector pose:')
                disp([self.robot.model.fkineUTS(targetJoints)])
                disp('E05_Worker: Error for this position = ');
                error = self.robot.model.fkineUTS(targetJoints)- targetPosition;
                disp(error);
                qPath = jtraj(q0,targetJoints,steps);
        end

        function [qPath] = searchDeposit(self,item,placement,q0,buffer,steps)
            %Finds an end effector joint position to place down an item
                        %%UNFINISHED, NEED TO ADD OTHER ITEMS BESIDE TRAY
            disp(['E05_Worker: Planning path to deposit ',item.plyFile,' onto ',placement.plyFile])
            if nargin < 6
                steps = 45;
                disp(['E05_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 5
                    buffer = 0;
                    disp(['E05_Worker: buffer value is set to default: ',num2str(buffer),'m'])
                    if nargin < 4
                        msg = 'q0 is not given. q0 is the starting position of the robot arm and is used for inverse kinematic calculations.  q0 helps path planners to find the most optimal joint path';
                        warning(msg);
                    end
                end
            end
            if(strncmpi(placement.plyFile,'Conveyor',8))                
                if(strncmpi(item.plyFile,'Tray',4))
                    disp('E05_Worker: Using gripper pose for Tray.')
                    buffer = buffer + item.corners(2,1)/1.5 + self.gripper.getHeight();    %Distance of final robot link away from deposit point = buffer + tray length/1.5 + gripperheight
                    gripTr = rpy2tr(pi/2,pi/2,0)*transl(0,0,-(buffer));         %pose for placing tray down relative to deposit point
                    temp= inv(placement.base)*self.robot.model.base.T;          %Calculate position of robot base in conveyors frame
                    x = temp(1,4)-0.5;                                              %X position of robot base with -0.2 offset
                    y = (placement.corners(1,2) + placement.corners(2,2))/2;      %Center of conveyor belt
                    z = placement.corners(2,3)+0.01;                             %Top of conveyorbelt
                    depositPoint = [x y z];                                     %Point to place tray in conveyorbelts frame of reference
                    targetPosition = placement.base*transl(depositPoint)*gripTr;%get target pose to move gripper to in global frame. frame transformation = gripperTr > depositPoint > ConveyorBelt > Global
                end

            elseif(strncmpi(placement.plyFile,'Tray.ply',4))
                if(strncmpi(item.plyFile,'Mealbox',7))
                    disp('E05_Worker: Using gripper pose for Mealbox.')
                    buffer = buffer +item.corners(2,3) -0.02 +self.gripper.getHeight();         %Distance of final robot link away from deposit point = buffer + meal height + gripperheight
                    gripTr = rpy2tr(0,pi,0)*transl(0,0,-(buffer));                           %pose for placing meal down relative to deposit point
                    x = (placement.corners(1,2) + placement.corners(2,2)) + 0.1;  %Slightly offset from center aways from robot
                    y = (placement.corners(1,2) + placement.corners(2,2))/2;      %Center of tray
                    z = placement.corners(2,3);                                  %Top of tray
                    depositPoint = [x y z];                                     %Point to place meal in tray's frame of reference
                    targetPosition = placement.base*transl(depositPoint)*gripTr;%get target pose to move gripper to in global frame. frame transformation = gripperTr > depositPoint > Tray > Global
                end

            else
                msg = ["E05_Worker: I was not designed to place ",item.plyFile," onto ",placement.plyFile];
                warning(msg);
            end
                targetJoints = self.robot.model.ikcon(targetPosition,q0); %perform inverse kinematic for joint positions
                disp('E05_Worker: Found target joint positions');
                disp('E05_Worker: Target End effector pose:')
                disp(targetPosition)
                disp('E05_Worker: Auctual End effector pose:')
                disp([self.robot.model.fkineUTS(targetJoints)])
                disp('E05_Worker: Error for this position = ');
                error =self.robot.model.fkineUTS(targetJoints) - targetPosition;
                disp(error);
                qPath = jtraj(q0,targetJoints,steps);
        end
    end
end