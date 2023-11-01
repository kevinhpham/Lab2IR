classdef Maestro <Environment
    %MAESTRO will be in charge of organising all the robots, environment
    %and conveyerbelts to work altogether

    properties      % This sets up the constant properties of the workspace (static/non-static)
                    % Comment out the nonStatic Environment as needed.

        % staticEnvironment = StaticEnvironment();
        % nonStaticEnvironment = NonStaticEnvironment();
        % environment = Environment(); % Both static and non static
    end
    
    %% The master code that runs all the main robot tasks
    methods
        function self = Maestro()
            self.TestFunction();
            %self.SetupNonStaticWorkspace();
        end

        function TestFunction(self)
            self.trayStorage;
            self.chefPerson(1).move((transl(0,2.0,-0.9))*(rpy2tr(0,0,pi/2)));

            %self.chefPerson(1).setPushDistance(0.028*30/steps);
            %This creates an error as it's not a method in the
            %chefPersonClass
        end
        
    end
end

