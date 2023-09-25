classdef E05_L <handle
%The Gripper robot is made up of two seperate serial link arms,
% 'left' and 'right'. 
 properties(Access = public)              
        model;
    end

 methods

     function self = E05_L(baseTr) 
        self.CreateModel();
        if nargin < 1			
			baseTr = eye(4);				
        end
        self.model.base = self.model.base.T * baseTr;
        end
             
     function CreateModel(self)   
        links = [
                Revolute('d', 0.220,'a', 0, 'alpha',pi/2,'offset',0,'qlim',[-deg2rad(360),deg2rad(360)])
                Revolute('d', 0,'a', 0.455, 'alpha',0,'offset',pi/2,'qlim',[-deg2rad(360),deg2rad(360)])
                Revolute('d', 0,'a', 0, 'alpha',-pi/2,'offset',-pi/2,'qlim',[-deg2rad(360),deg2rad(360)])
                Revolute('d', 0.495,'a',0, 'alpha',pi/2,'offset',0,'qlim',[-deg2rad(360),deg2rad(360)])
                Revolute('d', 0,'a',0, 'alpha',-pi/2,'offset',0,'qlim',[-deg2rad(360),deg2rad(360)])
                Revolute('d', 0.155,'a', 0, 'alpha',0,'offset',0,'qlim',[-deg2rad(360),deg2rad(360)])

        ];
        self.model =  SerialLink(links, 'name', 'E05_L');
        end
    end
end

