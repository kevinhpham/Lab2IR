% This is a class that cann be used to create an instance of an E05_L.
% The E05 is used to pickup/place trays and meals. 

classdef E05_L <handle
 properties(Access = public)  % Set to public so can be accessed by other classes.     
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
             
        function CreateModel(self)   % DH parameters calculated based on manufacturer technical specificiations
        links = [
                Revolute('d', 0.220,'a', 0, 'alpha',pi/2,'offset',0,'qlim',[-deg2rad(360),deg2rad(360)])
                Revolute('d', 0,'a', 0.455, 'alpha',0,'offset',pi/2,'qlim',[-deg2rad(360),deg2rad(360)])
                Revolute('d', 0,'a', 0, 'alpha',-pi/2,'offset',-pi/2,'qlim',[-deg2rad(360),deg2rad(360)])
                Revolute('d', 0.495,'a',0, 'alpha',pi/2,'offset',0,'qlim',[-deg2rad(360),deg2rad(360)])
                Revolute('d', 0,'a',0, 'alpha',-pi/2,'offset',0,'qlim',[-deg2rad(360),deg2rad(360)])
                Revolute('d', 0.155,'a', 0, 'alpha',0,'offset',0,'qlim',[-deg2rad(360),deg2rad(360)])

        ];
        self.model =  SerialLink(links, 'name', 'E05_L'); % Sets the name of the robot to 'E05_L'
        end
    end
end

