%% The purpose of this class is to make a stick version of the DoBot which can be used for testing

classdef Stick_Dobot <handle
 properties(Access = public)  % Set to public so can be accessed by other classes.     
        model;
        base;  % Add by Emma so that gui app can access
    end

 methods

     function self = Stick_Dobot(baseTr) 
        self.CreateModel();
        if nargin < 1			
			baseTr = eye(4);				
        end
        self.model.base = self.model.base.T * baseTr;
        end
             
        function CreateModel(self)   % DH parameters calculated based on manufacturer technical specificiations
        links = [
                Link('d',0.103+0.0362,    'a',0,      'alpha',-pi/2,  'offset',0, 'qlim',[deg2rad(-135),deg2rad(135)]);
                Link('d',0,        'a',0.135,  'alpha',0,      'offset',-pi/2, 'qlim',[deg2rad(5),deg2rad(80)]);
                Link('d',0,        'a',0.147,  'alpha',0,      'offset',0, 'qlim',[deg2rad(-5),deg2rad(85)]);
                Link('d',0,        'a',0.06,      'alpha',pi/2,  'offset',-pi/2, 'qlim',[deg2rad(-180),deg2rad(180)]);
                Link('d',-0.05,      'a',0,      'alpha',0,      'offset',pi, 'qlim',[deg2rad(-85),deg2rad(85)]);
        ];
        self.model =  SerialLink(links, 'name', 'Stick_Dobot'); % Sets the name of the robot to 'Stick_Dobot'
        end
    end
end