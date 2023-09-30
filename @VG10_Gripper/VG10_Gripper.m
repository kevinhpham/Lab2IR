classdef VG10_Gripper <handle
%Suction gripper for E05 L
%The Gripper is made up of 4 seperate serial link arms representing a
%sunction gripper
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
             
     function CreateModel(self)   
        links = [
                Revolute('d', 0.105,'a',0.073,'alpha',0,'qlim',[deg2rad(0),deg2rad(0)]) %create base of gripper;doesn't move or rotate
                Revolute('d', 0,'a', 0.12, 'alpha', 0,'offset',-deg2rad(120),'qlim',[0,deg2rad(180)])
        ];
        self.a1 =  SerialLink(links, 'name', 'A1');
        self.a2 = SerialLink(links, 'name', 'A2');
        self.b1=  SerialLink(links, 'name', 'B1');
        self.b2=  SerialLink(links, 'name', 'B2');
     end
    
    %Following function allow control of multiple links simultaneously
    function moveBase(self,baseTr) 
        self.a1.base = self.a1.base.T * baseTr;
        self.a2.base = self.a2.base.T * baseTr;
        self.b1.base = self.b1.base.T * baseTr;
        self.b2.base = self.b2.base.T * baseTr;
    end

    function animateAll(self,q)
        hold on
        self.a1.animate(q)
        self.a2.animate(q)
        self.b1.animate(q)
        self.b2.animate(q)
    end

    function plotAll(self,q)
        hold on
        self.a1.plot(q)
        self.a2.plot(q)
        self.b1.plot(q)
        self.b2.plot(q)
    end

    function setDelay(self,t)
        self.a1.delay = t;
        self.a2.delay = t;
        self.b1.delay = t;
        self.b2.delay = t;
    end

 end
end

