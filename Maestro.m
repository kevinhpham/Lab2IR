classdef Maestro <handle
    %MAESTRO will be in charge of organising all the robots, environment
    %and conveyerbelts to work altogether
    
    properties
        % Insert variables here
        environment;
    end
    
    methods
        function self = Maestro()
            self.SetupWorkspace();

        end

        function SetupWorkspace(self)
            Environment();
        end
        
        %function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            %outputArg = obj.Property1 + inputArg;
        %end
    end
end

