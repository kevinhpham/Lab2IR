classdef Environment <handle
    % The purpose of this class is to make the environment
    % The class differentiates between a static and non-static environment
    % This is achieved through two methods. 
    
    properties
        trayStorage;
        pushables;
        chefPerson;
        trays;
    end
    
    methods
        function self = Environment()
            self.trayStorage
            self.SetupStaticEnvironment();
            self.SetupNonStaticEnvironment();
        end
        
        function CreateMeal(self)
            % get robot to make a singular meal tray
            % animate workflow
            % specify if it is meat/veg, orange or blackcurrent juice. 
        end

        function SetupStaticEnvironment(self)
            % This calls the static class
        end 

        function SetupNonStaticEnvironment(self)
            % Insert information here. 
            self.trayStorage = TrayStorage((transl(1.95, -3.6, 0))*(rpy2tr(0,0,pi/2))); % Defines the position of the tray storage
            self.trays = self.trayStorage.addTrays(8); % Creates and array of trays
        end

        %function outputArg = method1(obj,inputArg)
            % METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            % outputArg = obj.Property1 + inputArg;
        %end

    end
end