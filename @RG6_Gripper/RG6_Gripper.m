classdef RG6_Gripper <handle
%Two finger gripper for E05 L
%The Gripper robot is made up of two seperate serial link arms,
% 'left' and 'right' representing fingers
 properties(Access = private)
        left;
        right;
        height; %current height of gripper
 end

 methods
     function self = RG6_Gripper(baseTr) 
        self.CreateModel();
        if nargin < 1			
			baseTr = eye(4);				
        end
        self.left.base = self.left.base.T * baseTr;
        self.right.base = self.right.base.T * baseTr * rpy2tr(pi, 0, 0, 'xyz');
        tr = inv(self.left.base.T)*self.left.fkineUTS([0 0 0]);%transform of end effector in gripper base frame
        self.height = tr(3,4);
        end
             
     function CreateModel(self)   
        scale = 1; %changes size of the gripper
        links = [
                Revolute('d', 0.152*scale,'a',0.03*scale,'alpha',pi/2,'qlim',[deg2rad(0),deg2rad(0)]) %create base of gripper;doesn't move or rotate
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

    function animate(self,q)
        %animate gripper
        hold on
        self.left.animate(q)
        self.right.animate(q)
        self.updateHeight();
    end

    function plot(self,q)
        %plot both fingers of gripper
        hold on
        self.left.plot(q)
        self.right.plot(q)
    end

    function setDelay(self,t)
        self.left.delay = t;
        self.right.delay = t;
    end

    function [height]= getHeight(self)
        %Returns heigh of gripper
        height= self.height;
    end

    function [q] = getPos(self)
        %return joint positions of fingers,fingers have to be plotted first
        q = self.left.getpos();
    end

    function [qLims] = getQlim(self)
        qLims = self.left.qlim();
    end
 end

 methods(Hidden)
     function updateHeight(self)
         %Updates height parameter, requires robot to be plotted
         tr = inv(self.left.base.T)*self.left.fkineUTS(self.getPos());%transform of end effector in gripper base frame
         self.height = tr(3,4);
     end
 end
end

