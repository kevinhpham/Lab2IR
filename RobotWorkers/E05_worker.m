classdef E05_worker <handle
   %%This Class is currently under construction
   %Creates a E05 robot that moves trays and meals onto the conveyer
    properties
       robot; 
       gripper; 
       speed = 1; %control speed factor of robot
       closeGrip;
       openGrip;

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
            self.robot.model.delay = 0.01;
            self.robot.model.qlim = [
                              deg2rad([-180 150]);
                              deg2rad([10 90]);
                              deg2rad([10 90]);
                              deg2rad([-45 45]);
                              deg2rad([10 110]);
                              deg2rad([-360 360])]; %set up joint limits for arm

           %Set up Gripper
           self.gripper = RG6_Gripper(self.robot.model.fkineUTS(self.robot.model.getpos()));
           self.gripper.left.base = self.robot.model.fkineUTS(self.robot.model.getpos());
           self.gripper.right.base = self.robot.model.fkineUTS(self.robot.model.getpos())*rpy2tr(pi, 0, 0, 'xyz');
           self.gripper.right.plot([0 0 0]);
           self.gripper.left.plot([0 0 0]);
           self.gripper.left.delay = 0.0;
           self.gripper.right.delay = 0.0;
           self.closeGrip = jtraj([0 0 0],[0 deg2rad(30) -deg2rad(30)],ceil(20/self.speed)); 
           self.openGrip = jtraj([0 deg2rad(30) -deg2rad(30)],[0 0 0],ceil(10/self.speed)); 
        end

        %%Plots the workspace of the worker as a pointcloud and finds approximate volume
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

        function [qPath] = planPickupPath(self,item,steps)
            %Returns a path the robot can take to pick up an item.
            if nargin <= 2
                disp(['E05_Worker: Planning for default number of steps', item.plyFile])
                steps = 60;
            end
                %Add midway path
                q0 = self.robot.model.getpos();
                midPoint = self.searchPickupMid(item); %Finds midpoint position
                midPointPath = jtraj(q0,midPoint,steps/2);
                %Add pickup path
                q0 = midPoint;
                goal = self.searchPickup(item); %Place gripper onto item
                endPointPath = jtraj(q0,goal,steps/2);     
                qPath = [midPointPath;endPointPath];
                %disp(['E05_Worker: I was not designed to pick this up! ', item.plyFile]);
        end

        function animateArm(self,qq)
            %animate arm and gripper to move together.
            %To animate path smoothely, enter in jointsteps 1 by 1 with loop
            self.robot.model.animate(qq)
            self.gripper.left.base = self.robot.model.fkineUTS(self.robot.model.getpos());
            self.gripper.right.base = self.robot.model.fkineUTS(self.robot.model.getpos())*rpy2tr(pi, 0, 0, 'xyz');
            self.gripper.left.animate(self.gripper.left.getpos())
            self.gripper.right.animate(self.gripper.right.getpos())
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
            q = [0 self.gripper.left.qlim(2,2) self.gripper.left.qlim(3,1)]*scale;
            self.gripper.left.animate(q);
            self.gripper.right.animate(q);
        end



    end



    methods(Hidden)
            function target = searchPickupMid(self,item)
            %Finds an end effector joint position that will place robot
            %effector above item
            target =[];
            disp(['E05_Worker: Looking for midwaypoint to pick up ', item.plyFile]);
            verts = ([item.vertices,ones(size(item.vertices,1),1)])*item.base.'; %vertices of item in global frame
                while(isempty(target)) %repeat search until a valid target is found
                    [~,index] = max(verts(:,3)); %Look for highest point on item
                    targetPosition = transl(verts(index,1:3))*transl(0,0,self.gripper.height+0.3)*rpy2tr(pi,0,0); %Target endeffector position will be highest point on item + buffer height
                    target = self.robot.model.ikcon(targetPosition,self.robot.model.getpos()) ;%perform inverse kinematic to check if robot can reach target position
                    if(isempty(target))
                        verts(index,:) = [];     %remove position for list to check
                        disp('E05_Worker: Trying new location')
                    end
                end
            disp('E05_Worker: Found midwaypoint');
            disp('E05_Worker: Error for this point = ');
            error = targetPosition- self.robot.model.fkineUTS(target)
            
        end

        function target = searchPickup(self,item)
            %Finds an end effector joint position to place gripper onto item
            %Loops to checks vertices on the item to pick up until it find
            %a vertice that it can reach. Will try to pickup items from
            %above
            target =[];
            disp(['E05_Worker: Looking for path to pick up ',item.plyFile]);
            verts = ([item.vertices,ones(size(item.vertices,1),1)])*item.base.'; %vertices of item in global frame
                while(isempty(target)) %repeat search until a valid target is found
                    [~,index] = max(verts(:,3)); %Look for highest point on item
                    targetPosition = transl(verts(index,1:3))*transl(0,0,self.gripper.height)*rpy2tr(pi,0,0);
                    target = self.robot.model.ikcon(targetPosition,self.robot.model.getpos()); %perform inverse kinematic to check if robot can reach target position
                    if(isempty(target))
                        verts(index,:) = [] ;    %remove position for list to check
                        disp('E05_Worker: Trying new location to pick up')
                    end
                end
            disp('E05_Worker: Found target to pickup');
            disp('E05_Worker: Error for this pickup = ');
            error = targetPosition- self.robot.model.fkineUTS(target)
        end
    end
end