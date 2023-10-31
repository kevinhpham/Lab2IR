classdef Maestro <handle
    %MAESTRO will be in charge of organising all the robots, environment
    %and conveyerbelts to work altogether

    properties      % This sets up the constant properties of the workspace (static/non-static)
                    % Comment out the nonStatic Environment as needed.

        % staticEnvironment = StaticEnvironment();
        % nonStaticEnvironment = NonStaticEnvironment();
        environment = Environment(); % Both static and non static
    end
    
    %% The master code that runs all the main robot tasks
    methods
        function self = Maestro()
            self.CreateMeal();
        end

        function CreateMeal(self)
            mealConveyor(1).setPushDistance(0.028*30/steps)    %distances set up to be inversely porpotional the number of steps in animation, so system will still work regardless of the number of steps of the animation
            mealConveyor(1).setPushDistance(0.028*30/steps)    %distances set up to be inversely porpotional the number of steps in animation, so system will still work regardless of the number of steps of the animation
            mealConveyor(2).setPushDistance(0.028*30/steps)
            dobotConveyor(1).setPushDistance(0.032*30/steps)
            dobotConveyor(2).setPushDistance(0.0317*30/steps)
            dobotConveyor(3).setPushDistance(0.032*30/steps)
            trayConveyor.setPushDistance(-0.029*30/steps) 
        end
        
    end
end

