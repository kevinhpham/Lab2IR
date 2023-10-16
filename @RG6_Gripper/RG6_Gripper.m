classdef RG6_Gripper <handle
%Two finger gripper for E05 L
%The Gripper robot is made up of two seperate serial link arms,
% 'left' and 'right' representing fingers
 properties(Access = public)              
        left;
        right;
        height;
 end

 methods
     function self = RG6_Gripper(baseTr) 
        self.CreateModel();
        if nargin < 1			
			baseTr = eye(4);				
        end
        self.left.base = self.left.base.T * baseTr;
        self.right.base = self.right.base.T * baseTr * rpy2tr(pi, 0, 0, 'xyz');
     end
             
     function CreateModel(self)   
        scale = 1; %changes size of the gripper
        self.height = 0.16*scale;
        links = [
                Revolute('d', 0.152*scale,'a',0.03*scale,'alpha',pi/2,'qlim',[deg2rad(0),deg2rad(0)]) %create base of gripper;doesn't move or rotate
                Revolute('d', 0,'a', 0.08*scale, 'alpha', 0,'offset',deg2rad(35),'qlim',[deg2rad(0),deg2rad(60)])
                Revolute('d', 0, 'a', 0.054*scale, 'alpha',0,'offset',deg2rad(60),'qlim',[-deg2rad(60),deg2rad(0)])
        ];
        self.left =  SerialLink(links, 'name', 'Gripper_LEFT');
        self.right = SerialLink(links, 'name', 'Gripper_RIGHT');
     end

    %Following function allow control of multiple links simultaneously
     function moveBase(self,baseTr) 
        self.left.base = self.left.base.T * baseTr;
        self.right.base = self.right.base.T * baseTr;
     end

    function animateAll(self,q)
        hold on
        self.left.animate(q)
        self.right.animate(q)
    end

    function plotAll(self,q)
        hold on
        self.left.plot(q)
        self.right.plot(q)
    end

    function setDelay(self,t)
        self.left.delay = t;
        self.right.delay = t;
    end

    end
end

