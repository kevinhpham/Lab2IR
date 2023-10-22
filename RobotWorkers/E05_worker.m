classdef E05_worker <handle
   %%This Class is currently under construction
   %Creates a E05 robot that moves trays and meals onto the conveyer
    properties
       robot; 
       gripper; 
       speed = 1; %control speed factor of robo
    end

    methods
        %%setups worker with gripper
        function self = E05_worker(basetr)
            if nargin < 1			
			    basetr = eye(4);				
            end
            %Sets up Linear UR3
            hold on
            self.robot = E05_L(basetr);
            self.robot.model.offset = [0 pi/2 -pi/3 0 0 0];
            self.robot.model.plot(zeros(6))
            self.robot.model.delay = 0;
            self.robot.model.qlim = [
                              deg2rad([-360 360]);
                              deg2rad([10 90]);
                              deg2rad([10 90]);
                              deg2rad([-90 90]);
                              deg2rad([-110 110]);
                              deg2rad([-720 720])]; %set up joint limits for arm

           %Set up Gripper
           self.gripper = RG6_Gripper(self.robot.model.fkineUTS(self.robot.model.getpos()));
           self.gripper.setBase(self.robot.model.fkineUTS(self.robot.model.getpos()));
           self.gripper.plot([0 0 0]);
           self.gripper.setDelay(0)
        end

        %%Plots the workspace of the arm as a pointcloud and finds approximate volume
        function plotWorkspace(self)
            qlim = self.robot.model.qlim;
            base = self.robot.model.base.T;
            qStep = pi/12;
            pointCloudSize = prod(floor((qlim(1:6,1)-qlim(1:6,2))/qStep + 1));
            pointCloud = zeros(pointCloudSize,3);
            counter = 1;

            for q1=qlim(1,1):qStep:qlim(1,2)
              for q2=qlim(2,1):qStep:qlim(2,2)
                for q3=qlim(3,1):qStep:qlim(3,2)
                    for q4=qlim(4,1):qStep:qlim(4,2)
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
            end
        plot3(pointCloud(:,1),pointCloud(:,2),pointCloud(:,3),'r.');
        volume = (max(pointCloud(:,1))-min(pointCloud(:,1))*(max(pointCloud(:,2))-min(pointCloud(:,2))))*(max(pointCloud(:,3))-min(pointCloud(:,3)));
        disp(['Aproximated volume of workspace given current joint limits is ', num2str(volume),'m^3']);
        end

        function [qPath] = planDepositPath(self,item,placement,q0,steps)
            %Plans the path for picking up item and placing it down on
            %another "placement" is the object to place 'item' on, e.g if placing
            %down a tray on conveyorbelt, "placement" = conveyorbelt, 'item' = tray.
            disp(['E05_Worker: Planning deposit path for ', item.plyFile]);
            if nargin < 6
                steps = 60;
                disp(['E05_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 5
                    msg = 'q0 is not given.Path planners will use current joint position as q0. q0 is the starting position of the robot arm and is used for inverse kinematic calculations. q0 helps path planners to find the most optimal joint path.';
                    warning(msg);
                    q0 = self.robot.model.getpos();
               end
            end
            qPath1 = self.searchLiftUp(q0,1.3,steps); 
            q0 = qPath1(length(qPath1()),:);
            disp(['E05_Worker: Planning for endpoint of deposit path'])
            qPath2 = self.searchDeposit(item,placement,q0,0.05,steps);    
            qPath = [qPath1;qPath2];
        end


        function [qPath] = planPickupPath(self,item,q0,steps)
            %Returns a joint path the robot can take to pick up an item.
            disp(['E05_Worker: Planning pick up path', item.plyFile]);
            if nargin < 5
                steps = 60;
                disp(['E05_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 4
                    msg = 'q0 is not given.Path planners will use current joint position as q0. q0 is the starting position of the robot arm and is used for inverse kinematic calculations. q0 helps path planners to find the most optimal joint path.';
                    warning(msg);
                    q0 = self.robot.model.getpos();
               end
            end
                %Add midway path
                disp(['E05_Worker: Looking for midwaypoint to pick up ', item.plyFile]);
                midPath = self.searchPickup(item,q0,0.5,steps); %Finds midpoint position
                %Add pickup path
                disp(['E05_Worker: Looking for endpoint to pick up ', item.plyFile]);
                q0 = midPath(length(midPath),:);
                endPath = self.searchPickup(item,q0,0,steps); %Place gripper onto item    
                qPath = [midPath;endPath];
        end

        function animateArm(self,qq,item)
            %animate arm, gripper and item to move together.
            %To animate path smoothely, enter in jointsteps 1 by 1 with loop
             if nargin < 3
                 item = uint8.empty;
             end

            if not(isempty(item)) %if there is an item
                itemToEnd = inv(self.robot.model.fkineUTS(self.robot.model.getpos()))*item.base;     %Find item's tf relative to end effector's frame
                self.robot.model.animate(qq);                                                       %Move robot to new joint position
                self.gripper.setBase(self.robot.model.fkineUTS(self.robot.model.getpos()));         %Update gripper base based on new end effector frame
                self.gripper.animate(self.gripper.getPos());                                        %Move gripper to new base
                itemToGlobal = self.robot.model.fkineUTS(qq)*itemToEnd;                             %Find item's new global tf base on endeffectors movement
                item.move(itemToGlobal);                                                            %Move item to new location
            else    %if no item specified
            self.robot.model.animate(qq);
            self.gripper.setBase(self.robot.model.fkineUTS(self.robot.model.getpos()));
            self.gripper.animate(self.gripper.getPos());
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

        function [jointPath] = searchLiftUp(self,q0,distance,steps)
            %Returns path to move end effector directely up by "distance" meters using resolved
            %motion control and damped least squares
            %Uses robot's current position for path planning
            disp('E05_Worker: Planning path to lift arm up')
            if nargin < 5
                steps = 30;
                disp(['E05_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 4
                    distance = 0.3;
                    disp(['E05_Worker: distance value is set to default: ',num2str(distance), "m"])
                    if nargin < 3
                        msg = 'q0 is not given. q0 is the starting position of the robot arm and is used for inverse kinematic calculations.  q0 helps path planners to find the most optimal joint path';
                        warning(msg);
                    end
                end
            end
            z1 = zeros(1,6);
            z2 = [0 0 distance 0 0 0];                          %x y z r p y, move up in z direction by 1m
            z = zeros(6,steps);
            s = lspb(0,1,steps);                                % Create interpolation scalar for trapezoidal velocity path
            minManipMeasure = 0.3;                              % Minimum measure of manipulativity before damping kicks in
            m = zeros(1,steps);
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
            
            disp('E05_Worker: Path to lift arm up found.')
            disp('E05_Worker: Here are the joint velocity errors:')
            display(errorValue.')
        end
    end

    methods(Hidden)
        function [qPath] = searchPickup(self,item,q0,buffer,steps)
            %Return path to place gripper above an item by buffer amount
            %buffer is the vertical distance between item and gripper, in meters.
            %Loops to checks vertices until it find a vertice that it can reach. 
            %Will try to pickup items from above
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
            verts = ([item.vertices,ones(size(item.vertices,1),1)]); %vertices of item
            if(strncmpi(item.plyFile,'MealBox.ply',7))
                disp(['E05_Worker: Using gripper pose for mealbox'])
                buffer = buffer-0.02;
                gripTr = transl(0.05,0,self.gripper.getHeight()+buffer)*rpy2tr(pi,0,pi/2); %pose for picking up mealboxes
                [~,index] = max(verts(:,3)); %Look for highest point in list of verticies, which is the handle of box
                targetPosition = item.base*transl(verts(index,1:3))*gripTr; %get target pose for final arm link to align gripper properly
            
            elseif(strncmpi(item.plyFile,'Tray.ply',4))
                disp(['E05_Worker: Using gripper pose for tray'])
                buffer = buffer + (max(verts(:,1)));
                gripTr = transl(-(self.gripper.getHeight()+buffer),0,0)*rpy2tr(0,pi/2,0); %pose for picking up top edge of tray
                targetPosition = item.base*gripTr; %get target pose for final arm link to align gripper properly
            else
                msg = ["Robot wasn't design to pick up",item.plyFile];
                warning(msg);
            end
                targetJoints = self.robot.model.ikcon(targetPosition,q0); %perform inverse kinematic for joint positions
                disp('E05_Worker: Found target joint positions');
                disp('E05_Worker: Error for this position = ');
                error = targetPosition- self.robot.model.fkineUTS(targetJoints);
                disp(error);
                qPath = jtraj(q0,targetJoints,steps);
        end

        function [qPath] = searchDeposit(self,item,placement,q0,buffer,steps)
            %Finds an end effector joint position to place down an item
            disp(['E05_Worker: Planning path to deposit ',item.plyFile,' onto ',placement.plyFile])
            if nargin < 7
                steps = 45;
                disp(['E05_Worker: Planning for default number of steps: ',num2str(steps)])
                if nargin < 6
                    buffer = 0;
                    disp(['E05_Worker: buffer value is set to default: ',num2str(buffer),'m'])
                    if nargin < 5
                        msg = 'q0 is not given. q0 is the starting position of the robot arm and is used for inverse kinematic calculations.  q0 helps path planners to find the most optimal joint path';
                        warning(msg);
                    end
                end
            end
            if(strncmpi(placement.plyFile,'Conveyor',8))
                buffer = buffer-0.02;
                gripTr = transl(0.05,0,self.gripper.getHeight()+buffer)*rpy2tr(pi,0,pi/2); %pose for picking up mealboxes
                temp= self.robot.model.base.T*inv(placement.base); %Calculate position of robot base in conveyors frame of reference
                x = temp(1,4);
                y = (placement.hitBox(1,2) + placement.hitBox(2,2))/2;
                z = placement.hitBox(1,3);
                depositPoint = [x y z];
                targetPosition = transl(depositPoint)*placement.base*gripTr; %get target pose for final arm link to align gripper properly
            % elseif(strncmpi(placement.plyFile,'Tray.ply',4))
            %     disp(['E05_Worker: Using gripper pose for tray.'])
            %     buffer = buffer + (max(verts(:,1)));
            %     gripTr = transl(-(self.gripper.getHeight()+buffer),0,0)*rpy2tr(0,pi/2,0); %pose for picking up top edge of tray
            %     targetPosition = item.base*gripTr; %get target pose for final arm link to align gripper properly
            else
                msg = ["E05_Worker: I was not designed to place ",item.plyFile," onto ",placement.plyFile];
                warning(msg);
            end
                targetJoints = self.robot.model.ikcon(targetPosition,q0); %perform inverse kinematic for joint positions
                disp('E05_Worker: Found target joint positions');
                disp('E05_Worker: Error for this position = ');
                error = targetPosition- self.robot.model.fkineUTS(targetJoints);
                disp(error);
                qPath = jtraj(q0,targetJoints,steps);
        end
    end
end