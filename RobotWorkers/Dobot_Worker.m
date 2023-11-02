classdef Dobot_Worker <handle
    %Creates a Dobot worker to pick and place cutlery and juiceboxes onto
    %trays.

    properties
       robot; 
       gripperHeight;
       collidables; %items to perform collision checking on
       power;          %on by default
    end

    methods 
        %%setups worker       
        function self = Dobot_Worker(basetr)
            if nargin < 1			
			    basetr = eye(4);				
            end
            %Sets up DobotMagician
            hold on
            self.robot = DobotMagician(basetr);
            % self.robot.model.offset = [0 pi/2 -pi/3 0 0 ];
            self.robot.model.delay = 0;
            self.robot.model.qlim = [
                              deg2rad([-180 180]);
                              deg2rad([5 80]);
                              deg2rad([-5 85]);
                              deg2rad([0 180]);
                              deg2rad([-85 85]);]; %set up joint limits for arm
            self.gripperHeight = 0.05;             %Gripper is built in DobotMagician model, so gripper height will be specified here.
            self.collidables = {};
            self.power = 1;                        %Turn on Dobot
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

        % Returns: qPath
        % Input: self, placement, q0, steps
        function [qPath] = planMidDepositPath(self,placement,q0,steps)
            %Plans a path to to reach the approach position for
            %dpeositing. "placement" is the tray that the dobot will
            %deposit items on
             disp(['Dobot_Worker: Looking for mid path to deposit onto ', placement.plyFile]);
            if nargin < 4
                steps = 60;
                disp(['Dobot_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 3
                    msg = 'q0 is not given. q0 is the starting position of the robot arm and is used for inverse kinematic calculations. q0 helps path planners to find the most optimal joint path.';
                    warning(msg);
                end
            end
            if(strncmpi(placement.plyFile,'Tray',4)) %midpath to place onto Tray
                qGoal = deg2rad([-90 45 30 45 0]);
                qPath = jtraj(q0,qGoal,steps);
            else
                msg= 'Dobot_Worker: no midpath avaliable for this item';
                warning(msg)
            end
        end

        % Returns: qPath
        % Input: self, item, q0, steps
        function [qPath] = planMidPickPath(self,item,q0,steps)
            %Plans a path to reach a midpoint to pick up "item". this
            %midpoint is a hard coded joint configuration
             disp(['Dobot_Worker: Looking for mid path to pickup ', item.plyFile]);
            if nargin < 4
                steps = 60;
                disp(['Dobot_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 3
                    msg = 'q0 is not given. q0 is the starting position of the robot arm and is used for inverse kinematic calculations. q0 helps path planners to find the most optimal joint path.';
                    warning(msg);
                end
            end
            %Check type item
            if(strncmpi(item.plyFile,'JuiceBoxBlackCurrant',20)) %midpath to pickup black currant juicebox
                qGoal = [0 pi/4 pi/3 pi/4 0];
                qPath = jtraj(q0,qGoal,steps);
            elseif (strncmpi(item.plyFile,'Cutlery.PLY',7)) %midpath to pickup cutlery
                qGoal = [pi/2 pi/4 pi/3 pi/4 0];
                qPath = jtraj(q0,qGoal,steps);
            elseif(strncmpi(item.plyFile,'JuiceBoxOrange',14)) %midpath to pickup orange juicebox
                qGoal = [-pi pi/4 pi/3 pi/4 0];
                qPath = jtraj(q0,qGoal,steps);
            else
                msg= 'Dobot_Worker: no midpath avaliable for this item';
                warning(msg)
            end

        end

        % Returns: qPath
        % Input: self, item, placement, steps
        function [qPath] = planDepositPath(self,item,placement,steps)
            %Plans the path from picking up item and placing it down on.
            %Does not include retraction.
            %"placement" is the object to place 'item' on, e.g if placing
            %down a cutlery on conveyorbelt, "placement" = conveyorbelt, 'item' = cutlery.
            disp(['Dobot_Worker: Looking for deposit path for ', item.plyFile]);
            if nargin < 4
                steps = 60;
                disp(['Dobot_Worker: Planning for default number of steps: ',num2str(steps)])
            end
            q0 = self.robot.model.getpos();
            qPath1 = self.planRetract(q0,0.2,steps); %Lift up whatever item is grasped
            q0 = qPath1(length(qPath1()),:);
            qPath2 = self.planMidDepositPath(placement,q0,steps);
            q0 = qPath2(length(qPath2()),:);
            qPath3 = self.searchDeposit(item,placement,q0,0,steps);    
            qPath = [qPath1;qPath2;qPath3];
        end

        %Return: qPath
        %Input: self, item, steps
        function [qPath] = planPickupPath(self,item,steps)
            %Returns a joint path the robot can take to pick up an item.
            disp(['Dobot_Worker: Planning pick up path for ', item.plyFile]);
            if nargin < 3
                steps = 60;
                disp(['Dobot_Worker: Planning for default number of steps: ',num2str(steps)])
            end
                %Add midway path
                q0 = self.robot.model.getpos();
                qPath1 = self.planMidPickPath(item,q0,steps);
                q0 = qPath1(length(qPath1),:);
                disp(['Dobot_Worker: Looking for 2nd midwaypoint to pick up ', item.plyFile]);
                qPath2 = self.searchPickup(item,q0,0.05,steps); %Finds midpoint position
                %Add pickup path
                disp(['Dobot_Worker: Looking for endpoint to pick up ', item.plyFile]);
                q0 = qPath2(length(qPath2),:);
                qPath3 = self.searchPickup(item,q0,0,steps); %Place gripper onto item    
                qPath = [qPath1;qPath2;qPath3];
        end

        % Return: collision
        % Input: self, qq, item
        function [collision] = animateArm(self,qq,item)
            %animate arm and item to move together. returns true
            %if any part of the arm or item will collides with items in
            %"collidables"
            %To animate path smoothely, enter in jointsteps 1 by 1 with loop
            if self.power == 1  %check if dobot is on
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
                        check(2) = CollisionDetection.itemsIsCollision(item,self.collidables,itemToGlobal);           %check if item will collide
                        collision = any(check);                                %collision will return true if anything is colliding
                    end
                    
                    if collision == 0                                          %If there is no collision, proceed to move
                        self.robot.model.animate(qq);                          %Move robot to new joint position
                        item.move(itemToGlobal);                               %Move item to new location
                    end
    
                else    %if there is no item
                    if 0 < size(self.collidables)
                        check(1) = CollisionDetection.robotIsCollision(self.robot.model,qq,self.collidables);           %check if arm will collide 
                        collision = any(check);                                                             %return true if there is a collision
                    end
    
                    if collision == 0  %No collision, move arm
                        self.robot.model.animate(qq);
                    end
                end
            else
                msg = 'Dobot_Worker arm was not moved. Dobot_Worker is not turned on.';
                disp(msg)
            end
        end

        % Return: jointPath
        % Input: self, q0, distance, steps
        function [jointPath] = planRetract(self,q0,distance,steps)
            %Returns path to retract end effector by "distance" meters
            disp('E05_Worker: Planning path to retract end effector')
            if nargin < 4
                steps = 30;
                disp(['E05_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 3
                    distance = 0.2;
                    disp(['E05_Worker: Distance value is set to default: ',num2str(distance), "m"])
                    if nargin <2
                        msg = 'q0 is not given. q0 is the starting position of the robot arm and is used for inverse kinematic calculations.  q0 helps path planners to find the most optimal joint path';
                        warning(msg);
                    end
                end
            end
            endPose = self.robot.model.fkineUTS(q0);                   %current end effector pose
            targetPosition = endPose*(transl(0,0,distance));          %translate end pose by distance
            targetJoints = self.robot.model.ikcon(targetPosition,q0); %perform inverse kinematic for joint positions
            jointPath= jtraj(q0,targetJoints,steps);                   %quintic polynomial trajectory 
        end

        % Return: nothing
        % Input: self, items
        function addCollidables(self,items)
            if iscell(items)    %if items are in a cell
                self.collidables = horzcat(self.collidables,items);
            end

            if isobject(items)  %if items in array
                self.collidables = horzcat(self.collidables,(num2cell(items)));
            end
        end
        function [q] = GetPos(self)
            q = self.robot.model.getpos();
        end
        function TurnOn(self)
            self.power = 1;
        end

        function TurnOff(self)
            self.power = 0;
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
                disp(['Dobot_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 4
                    buffer = 0;
                    disp(['Dobot_Worker: buffer value is set to default: ',num2str(buffer),'m'])
                    if nargin < 3
                        msg = 'q0 is not given. q0 is the starting position of the robot arm and is used for inverse kinematic calculations. q0 helps path planners to find the most optimal joint path';
                        warning(msg);
                    end
                end
            end
            %Find out what item is being picked up and the corresponding gripper
            %pose to pick up that item.
            if(strncmpi(item.plyFile,'JuiceBox',8))
                disp(['Dobot_Worker: Using gripper pose for ', item.plyFile])
                buffer = buffer + self.gripperHeight();
                gripTr = rpy2tr(0,0,pi/2)*transl(0,0,buffer);          %pose for picking up top face of juicebox
                x = 0;                                              %Center Juicebox
                y = 0;                                              %Center of Juicebox
                z = item.corners(2,3);                              %height of Juicebox
                pickUpPoint = [x y z];                              %point on juicebox to pickup
                targetPosition = item.base*transl(pickUpPoint)*gripTr;
            
            elseif(strncmpi(item.plyFile,'Cutlery.ply',4))
                disp('Dobot_Worker: Using gripper pose for cutlery')
                buffer = buffer + self.gripperHeight();  % distance between arm end link and pickup object = buffer + gripper height
                gripTr = rpy2tr(0,0,pi/2)*transl(0,0,buffer);                         %pose for picking up top face of cutlery
                x = 0;                                                             %Center Cutlery
                y = 0;                                                             %Center of Cutlery
                z = item.corners(2,3);                                             %height of cutlery
                pickUpPoint = [x y z];                                             %Point to pick up cutlery
                targetPosition = item.base*transl(pickUpPoint)*gripTr;             %get target pose to move gripper to in global frame. frame transformation = gripperTr > depositPoint > item > Global
            else
                msg = ["Robot wasn't design to pick up",item.plyFile];
                warning(msg);
            end
                targetJoints = self.robot.model.ikcon(targetPosition,q0); %perform inverse kinematic for joint positions
                disp('Dobot_Worker: Found target joint positions');
                disp('Dobot_Worker: Target End effector pose:')
                disp(targetPosition)
                disp('Dobot_Worker: Auctual End effector pose:')
                disp([self.robot.model.fkineUTS(targetJoints)])
                disp('Dobot_Worker: Error for this position = ');
                error = self.robot.model.fkineUTS(targetJoints)- targetPosition;
                disp(error);
                qPath = jtraj(q0,targetJoints,steps);
        end

        function [qPath] = searchDeposit(self,item,placement,q0,buffer,steps)
            %Finds an end effector joint position to place down an item
                        %%UNFINISHED, NEED TO ADD OTHER ITEMS BESIDE TRAY
            disp(['Dobot_Worker: Planning path to deposit ',item.plyFile,' onto ',placement.plyFile])
            if nargin < 6
                steps = 45;
                disp(['Dobot_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 5
                    buffer = 0;
                    disp(['Dobot_Worker: buffer value is set to default: ',num2str(buffer),'m'])
                    if nargin < 4
                        msg = 'q0 is not given. q0 is the starting position of the robot arm and is used for inverse kinematic calculations.  q0 helps path planners to find the most optimal joint path';
                        warning(msg);
                    end
                end
            end
            if(strncmpi(placement.plyFile,'Tray.PLY',8))
                if(strncmpi(item.plyFile,'Cutlery',7))
                    disp('Dobot_Worker: Using gripper pose for Cutlery.')
                    buffer = buffer+ self.gripperHeight()+item.corners(2,3);    %Distance of final robot link away from deposit point = buffer + gripperheight + cutlery height
                    gripTr = transl(0,0,buffer)*rpy2tr(0,0,pi/2);                %pose for placing cutlery down relative to deposit point
                    x =0;                                                       %center of tray
                    y =0;                                                       %Center of tray
                    z =0;                                                       %Top of tray
                    depositPoint = [x y z];                                     %Point to place cutlery in trays frame of reference
                    targetPosition = placement.base*transl(depositPoint)*gripTr;%get target pose to move gripper to in global frame. frame transformation = gripperTr > depositPoint > Placement > Global

                elseif(strncmpi(item.plyFile,'JuiceBox',8))
                    disp(['Dobot_Worker: Using gripper pose for ',item.plyFile])
                    buffer = buffer + self.gripperHeight() + item.corners(2,3); %Distance of final robot link away from deposit point = buffer + gripperheight + juicebox height
                    gripTr = transl(0,0,buffer)*rpy2tr(0,0,pi);          %gripper pose for placing juicebox relative to deposit point
                    x = -0.03;                                          %Offset from Center of Tray
                    y = -0.03;                                              %Offset from Center of Tray
                    z = 0;                                               %height of Tray
                    depositPoint = [x y z];                             %point to place juicebox on tray
                    targetPosition = placement.base*transl(depositPoint)*gripTr;%get target pose to move gripper to in global frame. frame transformation = gripperTr > depositPoint > Placement > Global
                else
                    msg = ["Dobot_Worker: I was not designed to place ",item.plyFile," onto ",placement.plyFile];
                    warning(msg);
                end
            end
                targetJoints = self.robot.model.ikcon(targetPosition,q0); %perform inverse kinematic for joint positions
                disp('Dobot_Worker: Found target joint positions');
                disp('Dobot_Worker: Target End effector pose:')
                disp(targetPosition)
                disp('Dobot_Worker: Auctual End effector pose:')
                disp([self.robot.model.fkineUTS(targetJoints)])
                disp('Dobot_Worker: Error for this position = ');
                error =self.robot.model.fkineUTS(targetJoints) - targetPosition;
                disp(error);
                qPath = jtraj(q0,targetJoints,steps);
        end
    end
end