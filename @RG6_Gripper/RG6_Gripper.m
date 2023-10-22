% This class creates a robot gripper for the E05_L
% The gripper is made up of two seperate serial link arms: left, right

classdef RG6_Gripper <handle

 % 'left' and 'right' represent fingers
 properties(Access = private)
        left;
        right;
        height; % Current height of gripper
 end

 methods
     function self = RG6_Gripper(baseTr) 
        self.CreateModel();
        if nargin < 1			
			baseTr = eye(4);				
        end

        % Fkine UTS is used as it is faster at calculating forward
        % kinematics
        self.left.base = self.left.base.T * baseTr;
        self.right.base = self.right.base.T * baseTr * rpy2tr(pi, 0, 0, 'xyz');
        tr = inv(self.left.base.T)*self.left.fkineUTS([0 0 0]); % Transform of end effector in gripper base frame
        self.height = tr(3,4);
        end
     
     % Creates a gripper based on links & DH parameters using revolute
     % joints.
     function CreateModel(self)   
        scale = 1; % Changes size of the gripper
        links = [
                Revolute('d', 0.152*scale,'a',0.03*scale,'alpha',pi/2,'qlim',[deg2rad(0),deg2rad(0)]) % Creates base of gripper; deg set to 0 to prevent translation/rotation
                Revolute('d', 0,'a', 0.08*scale, 'alpha', 0,'offset',deg2rad(35),'qlim',[deg2rad(0),deg2rad(60)])
                Revolute('d', 0, 'a', 0.054*scale, 'alpha',0,'offset',deg2rad(60),'qlim',[-deg2rad(60),deg2rad(0)])
        ];
        self.left =  SerialLink(links, 'name', 'Gripper_LEFT');
        self.right = SerialLink(links, 'name', 'Gripper_RIGHT');
     end

     function setBase(self,baseTr) 
        self.left.base = baseTr;
        self.right.base =baseTr*rpy2tr(0,0,pi);
     end

    % Function: Animate gripper
    function animate(self,q)
        hold on
        self.left.animate(q)
        self.right.animate(q)
        self.updateHeight();
    end

    % Function: Plots both fingers of the gripper
    % This supports the getPos function: retrieving joint positions.
    function plot(self,q)
        hold on
        self.left.plot(q)
        self.right.plot(q)
    end

    % Function: Adds a delay defined by 't' to support simultaneous motion
    % of the gripper fingers (left, right)
    function setDelay(self,t)
        self.left.delay = t;
        self.right.delay = t;
    end

    % Function: Returns the height of the gripper. 
    function [height]= getHeight(self)
        height= self.height;
    end

    % Function: Returns joint positions of fingers
    % Assumes symmetrical behaviour: left = right
    function [q] = getPos(self)
        q = self.left.getpos();
    end

    % Function: Returns the joint limits of fingers 
    % Assumes symmetrical behaviour: left = right 
    function [qLims] = getQlim(self)
        qLims = self.left.qlim();
    end
 end

 methods(Hidden)
     function updateHeight(self)
         % Updates height parameter, requires robot to be plotted
         tr = inv(self.left.base.T)*self.left.fkineUTS(self.getPos());% Transform of end effector in gripper base frame
         self.height = tr(3,4);
     end
 end
end

