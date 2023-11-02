classdef MaestroTest <Environment
    %MAESTRO will be in charge of organising all the robots, environment
    %and conveyerbelts to work altogether

    properties      
        eButton = 0; % Button not pressed
        
    end
    
    %% The master code that runs all the main robot tasks
    methods
        function self = MaestroTest()
            self.CreateTrays();
            %self.SetupNonStaticWorkspace();

            switch(self.eButton)
                case eButton == 1;
                        % Action these functions
                case eButton == 0;
                        % Action these functions
                        CreateTrays(self);
                otherwise
                        %plyName ='JuiceBox.PLY';
            end
        end

        function CreateTrays(self)
            self.trayStorage;

            % The purpose of this statement is to check if button is
            % pressed or not
            if self.eButton == 1;
                % Button pressed
                self.chefPerson(1).move((transl(0,2.0,-0.9))*(rpy2tr(0,0,pi/2)));
            else
                % Button un-pressed
            end
        end

        function StopCreateTrays(self)
            % xyz
        end

    end
end