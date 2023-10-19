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
                              deg2rad([10 110]);
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

        function [qPath] = planPickupPath(self,item,steps)
            %Returns a joint path the robot can take to pick up an item.
            if nargin <= 2
                disp(['E05_Worker: Planning for default number of steps', item.plyFile])
                steps = 60;
            end
                %Add midway path
                q0 = self.robot.model.getpos();
                disp(['E05_Worker: Looking for midwaypoint to pick up ', item.plyFile]);
                midPointq = self.searchPickup(item,0.2); %Finds midpoint position
                midPointPath = jtraj(q0,midPointq,steps/2);
                %Add pickup path
                q0 = midPointq;
                disp(['E05_Worker: Looking for path to pick up ',item.plyFile]);
                goal = self.searchPickup(item,0); %Place gripper onto item
                endPointPath = jtraj(q0,goal,steps/2);     
                qPath = [midPointPath;endPointPath];
                %disp(['E05_Worker: I was not designed to pick this up! ', item.plyFile]);
        end

        function animateArm(self,qq)
            %animate arm and gripper to move together.
            %To animate path smoothely, enter in jointsteps 1 by 1 with loop
            self.robot.model.animate(qq)
            self.gripper.setBase(self.robot.model.fkineUTS(self.robot.model.getpos()));
            self.gripper.animate(self.gripper.getPos())
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



    end



    methods(Hidden)
        function targetJoints = searchPickup(self,item,buffer)
            %Finds an end effector joint position to place gripper above item
            %buffer is the vertical distance between item and gripper, in meters.
            %Loops to checks vertices until it find a vertice that it can reach. 
            %Will try to pickup items from above
            verts = ([item.vertices,ones(size(item.vertices,1),1)]); %vertices of item in global frame
            if(strncmpi(item.plyFile,'MealBox.ply',7))
                disp(['E05_Worker: Using gripper pose for mealbox.'])
                buffer = buffer-0.02;
                gripTr = transl(0.05,0,self.gripper.getHeight()+buffer)*rpy2tr(pi,0,pi/2); %pose for picking up mealboxes
                [~,index] = max(verts(:,3)); %Look for highest point in list of verticies, which is the handle of box
                targetPosition = item.base*transl(verts(index,1:3))*gripTr; %get target pose for final arm link to align gripper properly
            
            elseif(strncmpi(item.plyFile,'Tray.ply',4))
                disp(['E05_Worker: Using gripper pose for tray.'])
                buffer = buffer + (max(verts(:,1)));
                gripTr = transl(-(self.gripper.getHeight()+buffer),0,0)*rpy2tr(0,pi/2,0); %pose for picking up top edge of tray
                targetPosition = item.base*gripTr; %get target pose for final arm link to align gripper properly
            else
                msg = ["Robot wasn't design to pick up",item.plyFile];
                warning(msg);
            end
                targetJoints = self.robot.model.ikcon(targetPosition,self.robot.model.getpos()); %perform inverse kinematic for joint positions
                disp('E05_Worker: Found target joint positions');
                disp('E05_Worker: Error for this position = ');
                error = targetPosition- self.robot.model.fkineUTS(targetJoints);
                disp(error);
        end
    end
end