%% The purpose of this class is to make a stick version of the DoBot which can be used for testing

properties(Access = public)              
        plyFileNameStem = 'LinearUR3'; %It is fitting on the UR5 rails??
    end
    
    methods
%% Define robot Function 
        function self = LinearUR3(baseTr)
			self.CreateModel();
            if nargin < 1			
				baseTr = eye(4);				
            end
            self.model.base = self.model.base.T * baseTr * trotx(pi/2) * troty(pi/2);
            
            self.PlotAndColourRobot();         
        end

%% Create the robot model
        function CreateModel(self)   
            % Create the UR3 model mounted on a linear rail
            % d, a, alpha, offset, qlim
            % Didn't enter any negative values??
            % theta, something, a, alpha

            %link(1) = Link([pi     0        0          pi/2   1]); % PRISMATIC Link
            %link(2) = Link('d',0.1519,'a',0,'alpha',pi/2,'qlim',deg2rad([-360 360]), 'offset',0);
            %link(3) = Link('d',0,'a',-0.24365,'alpha',0,'qlim', deg2rad([-360 360]), 'offset',0);
            %link(4) = Link('d',0,'a',-0.21325,'alpha',0,'qlim', deg2rad([-360 360]), 'offset', 0);
            %link(5) = Link('d',0.11235,'a',0,'alpha',pi/2,'qlim',deg2rad([-360 360]),'offset', 0);
            %link(6) = Link('d',0.08535,'a',0,'alpha',-pi/2,'qlim',deg2rad([-360,360]), 'offset',0);
            %link(7) = Link('d',0.0819,'a',0,'alpha',0,'qlim',deg2rad([-360,360]), 'offset', 0);
            
            %Previous Syntax: Changed to calc workspace.
            link(1) = Link([pi     0        0          pi/2   1]); % PRISMATIC Link
            link(2) = Link([0      0.1519   0          pi/2   0]);
            link(3) = Link([0      0       -0.24365    0      0]); %joint 2
            link(4) = Link([0      0       -0.21325    0      0]); %joint 3
            link(5) = Link([0      0.11235  0          pi/2   0]); %joint 4
            link(6) = Link([0      0.08535  0         -pi/2	  0]); % joint 5
            link(7) = Link([0      0.0819   0          0      0]); % joint 6 

            % Incorporate joint limits
            link(1).qlim = [-0.8 -0.01]; %Changed to positive to use plot q function
            link(2).qlim = [-360 360]*pi/180;
            link(3).qlim = [-360 360]*pi/180;
            link(4).qlim = [-360 360]*pi/180;
            link(5).qlim = [-360 360]*pi/180;
            link(6).qlim = [-360 360]*pi/180;
            link(7).qlim = [-360 360]*pi/180;
        
            link(3).offset = -pi/2;
            link(5).offset = -pi/2;
            
            self.model = SerialLink(link,'name',self.name);
        end
     
    end
end