% This class creates a suction gripper for E05 L
% The Gripper is made up of 4 seperate serial link arms

classdef VG10_Gripper <handle

 % Instantiating the four arms to create the suction gripper
 properties(Access = public)              
        a1;
        a2;
        b1;
        b2;
    end

 methods
     function self = VG10_Gripper(baseTr) 
        self.CreateModel();
        if nargin < 1			
			baseTr = eye(4);				
        end

        self.a1.base = self.a1.base.T * baseTr * rpy2tr(0, 0, 0, 'xyz');
        self.a2.base = self.a2.base.T * baseTr * rpy2tr(2*pi/4, 0, 0, 'xyz');
        self.b1.base = self.b1.base.T * baseTr * rpy2tr(4*pi/4, 0, 0, 'xyz');
        self.b2.base = self.b2.base.T * baseTr * rpy2tr(6*pi/4, 0, 0, 'xyz');
        end
     
     % Function: Creates a suction gripper based on links & DH parameters
     % using revolute joints
     function CreateModel(self)   
        links = [
                Revolute('d', 0.105,'a',0.073,'alpha',0,'qlim',[deg2rad(0),deg2rad(0)]) % Creates base of gripper; deg set to 0 to prevent translation/rotation
                Revolute('d', 0,'a', 0.12, 'alpha', 0,'offset',-deg2rad(120),'qlim',[0,deg2rad(180)])
        ];

        % Naming each of the links of the suction gripper
        % Name corresponds to properties name 'a1,a2,b1,b2'
        self.a1 =  SerialLink(links, 'name', 'A1');
        self.a2 = SerialLink(links, 'name', 'A2');
        self.b1=  SerialLink(links, 'name', 'B1');
        self.b2=  SerialLink(links, 'name', 'B2');
     end
    
    % Function: Supports control of multiple links simultaneously
    function moveBase(self,baseTr) 
        self.a1.base = self.a1.base.T * baseTr;
        self.a2.base = self.a2.base.T * baseTr;
        self.b1.base = self.b1.base.T * baseTr;
        self.b2.base = self.b2.base.T * baseTr;
    end

    % Function: Animates/ supports movement of each of the links
    function animateAll(self,q)
        hold on
        self.a1.animate(q)
        self.a2.animate(q)
        self.b1.animate(q)
        self.b2.animate(q)
    end

    % Function: Plots each of the links so they are populated visually
    function plotAll(self,q)
        hold on
        self.a1.plot(q)
        self.a2.plot(q)
        self.b1.plot(q)
        self.b2.plot(q)
    end

    % Function: Sets a delay to support simulateneous motion of all the links.
    function setDelay(self,t)
        self.a1.delay = t;
        self.a2.delay = t;
        self.b1.delay = t;
        self.b2.delay = t;
    end
 end
end

