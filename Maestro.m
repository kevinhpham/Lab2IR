classdef Maestro
    %MAESTRO will be in charge of organising all the robots, environment
    %and conveyerbelts to work altogether
    
    properties
        Property1
    end
    
    methods
        function obj = Maestro(inputArg1,inputArg2)
            %MAESTRO Construct an instance of this class
            %   Detailed explanation goes here
            obj.Property1 = inputArg1 + inputArg2;
        end
        
        function outputArg = method1(obj,inputArg)
            %METHOD1 Summary of this method goes here
            %   Detailed explanation goes here
            outputArg = obj.Property1 + inputArg;
        end
    end
end

