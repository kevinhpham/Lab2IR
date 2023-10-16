classdef E05_worker <handle
   %%This Class is currently under construction
   %Creates a E05 robot that moves trays and meals onto the conveyer
    properties
       robot; 
       grip; 
       speed = 1; %control speed factor of robot
       closeGrip;
       openGrip;

    end

    methods
        %%setups worker with gripper
        function self = E05_worker(basetr)
            if nargin < 1			
			    baseTr = eye(4);				
            end
            %Sets up Linear UR3
            hold on
            self.robot = E05_L(basetr);
            self.robot.model.plot([0 0 0 0 0 0])
            self.robot.model.animate([0 0 0 0 0 0]);
            self.robot.model.delay = 0.01;
            self.robot.model.qlim = [
                              deg2rad([-180 150]);
                              deg2rad([10 90]);
                              deg2rad([10 90]);
                              deg2rad([-45 45]);
                              deg2rad([10 110]);
                              deg2rad([-360 360])]; %set up joint limits for arm
           

           %Set up Gripper
           self.grip = RG6_Gripper(self.robot.model.fkineUTS(self.robot.model.getpos()));
           self.grip.right.plot([0 0 0]);
           self.grip.left.plot([0 0 0]);
           self.grip.left.delay = 0.0;
           self.grip.right.delay = 0.0;
           self.closeGrip = jtraj([0 0 0],[0 deg2rad(30) -deg2rad(30)],ceil(20/self.speed)); 
           self.openGrip = jtraj([0 deg2rad(30) -deg2rad(30)],[0 0 0],ceil(10/self.speed)); 
        end

        function pickup(self, item)
            if item.plyFile == "Tray.PLY"
                q0 = self.robot.model.getpos();
                %Move above item
                goal = self.searchPickupGoal(item);
                steps = 60/self.speed;
                qPath = jtraj(q0,goal,steps);
                disp(['E05_Worker: Moving to mid point position ',item.plyFile,'.']);
                for i = 1:length(qPath)
                   self.robot.model.animate(qPath(i,:));
                   self.grip.left.base = self.robot.model.fkineUTS(self.robot.model.getpos());
                   self.grip.right.base = self.robot.model.fkineUTS(self.robot.model.getpos())*rpy2tr(pi, 0, 0, 'xyz');
                   self.grip.right.animate(self.grip.right.getpos());
                   self.grip.left.animate(self.grip.left.getpos());
                    drawnow
                end

                q0 = self.robot.model.getpos();
                %Find target positions
                goal = self.searchPickup(item);
                steps = 60/self.speed;
                qPath = jtraj(q0,goal,steps);
                disp(['E05_Worker: Moving to pick up position',item.plyFile,'.']);
                for i = 1:length(qPath);
                   self.robot.model.animate(qPath(i,:));
                   self.grip.left.base = self.robot.model.fkineUTS(self.robot.model.getpos());
                   self.grip.right.base = self.robot.model.fkineUTS(self.robot.model.getpos())*rpy2tr(pi, 0, 0, 'xyz');
                   self.grip.right.animate(self.grip.right.getpos());
                   self.grip.left.animate(self.grip.left.getpos());
                    drawnow
                end


                
                disp(['E05_Worker: Done picking up ',item.plyFile,'.']);
            else
                disp(['E05_Worker: I was not designed to pick this up! ', item.plyFile]);
            end
        end



        function target = searchPickupGoal(self,item)
            %Finds an end effector joint position that the robot can reach
            %to pickup the item. Does not considered orientation of end
            %effector
            target =[];
            disp(['E05_Worker: Looking for target to pick up']);
            verts = ([item.vertices,ones(size(item.vertices,1),1)])*item.base.'; %vertices of item in global frame
                while(isempty(target)) %repeat search until a valid target is found
                    [value,index] = max(verts(:,3)) %Look for highest point on item
                    targetPosition = transl(verts(index,1:3))*transl(0,0,self.grip.height+0.2); %Target endeffector position will be highest point on item + gripper height
                    target = self.robot.model.ikine(targetPosition,'q0',self.robot.model.getpos(),'mask',[1 1 1 0 0 0]) ;%perform inverse kinematic to check if robot can reach target position
                    if(isempty(target))
                        verts(index,:) = [];     %remove position for list to check
                        disp(['E05_Worker: Trying new location to pick up'])
                    end
            end
            disp(['E05_Worker: Found target to pickup']);
            disp(['E05_Worker: Error for this pickup = ']);
            error = targetPosition- self.robot.model.fkineUTS(target)
            
        end

        function target = searchPickup(self,item)
            %Finds an end effector joint position that the robot can reach
            %to pickup the item. Does not considered orientation of end
            %effector
            target =[];
            disp(['E05_Worker: Looking for target to pick up']);
            verts = ([item.vertices,ones(size(item.vertices,1),1)])*item.base.'; %vertices of item in global frame
                while(isempty(target)) %repeat search until a valid target is found
                    [value,index] = max(verts(:,3)); %Look for highest point on item
                    targetPosition = transl(verts(index,1:3))*transl(0,0,self.grip.height)*rpy2tr(pi,0,0);
                    target = self.robot.model.ikcon(targetPosition,self.robot.model.getpos()); %perform inverse kinematic to check if robot can reach target position
                    if(isempty(target))
                        verts(index,:) = [] ;    %remove position for list to check
                        disp(['E05_Worker: Trying new location to pick up'])
                    end
            end
            disp(['E05_Worker: Found target to pickup']);
            disp(['E05_Worker: Error for this pickup = ']);
            error = targetPosition- self.robot.model.fkineUTS(target)
        end



        %%Plots the workspace of the worker as a pointcloud and finds approximate volume
        function plotWorkspace(self)
            qlim = self.robot.model.qlim;
            base = self.robot.model.base.T;
            qStep = pi/9;
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
    end
end