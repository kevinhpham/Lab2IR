classdef Maestro <Environment %Inherits from Environment
    % The Maestro class is the main class that controls: robots, environment
    % Used to get the program to function all together

    properties % Here, we track 3 main things: e05, dobot and conveyor
        % e05 tracking variables
        e05PlannedPath; % Where the robot wants to go
        e05ItemHold;    % What item the robot is holding
        e05ItemPlaced;  % What item the robot has placed already
        e05CurrentStep; % What stage in the process is the robot at

        % conveyor trackinf variables
        conveyorCurrentStep; % Where is the tray (1 - in progress, 2 - complete)
        conveyorMaxStep;     

        % dobot tracking variables
        dobotPlannedPath;
        dobotItemHold;
        dobotItemPlaced;
        dobotCurrentStep;

        % variables unique to the Maestro class
        procedure = 1;
        steps;
        eButton;
    end
    
    % The master code that runs all the main robot tasks
    methods
        function self = Maestro()
            self.TestFunction();
            self.SelectProcedure();
            self.CreatePathProcedure();
            self.AnimateProcedure();
        end

        function TestFunction(self) % Test if I can move a person
            self.chefPerson(1).move((transl(0,2.0,-0.9))*(rpy2tr(0,0,pi/2)));
        end

        function SelectProcedure(self)
            % Planned Path Procedure
            if self.procedure == 1
                for i = self.e05CurrentStep:length(self.e05PlannedPath)
                    if self.eButton == 0
                        e05_worker.animateArm(self.e05PlannedPath(i,:), self.e05ItemHold)
                        self.e05CurrentStep = i;
                    elseif i == length(self.e05PlannedPath)
                        self.procedure = 2;
                        self.e05CurrentStep = 1;
                    else 
                        break
                    end 
                end 
            elseif self.procedure == 2
                for i = 10
                    if i == 0
                        % do stuff
                    elseif i == 1
                        % do stuff
                    else 
                        break
                    end 
                end 
            elseif self.procedure == 3
                for i = 10
                    if i == 0
                        % do stuff
                    elseif i == 1
                        % do stuff
                    else 
                        break
                    end 
                end 
            elseif self.procedure == 4
                for i = 10
                    if i == 0
                        % do stuff
                    elseif i == 1
                        % do stuff
                    else 
                        break
                    end 
                end 
            elseif self.procedure == 5
                for i = 10
                    if i == 0
                        % do stuff
                    elseif i == 1
                        % do stuff
                    else 
                        break
                    end 
                end 
            elseif self.procedure == 6
                for i = 10
                    if i == 0
                        % do stuff
                    elseif i == 1
                        % do stuff
                    else 
                        break
                    end 
                end 
            elseif self.procedure == 7
                for i = 10
                    if i == 0
                        % do stuff
                    elseif i == 1
                        % do stuff
                    else 
                        break
                    end 
                end 
            elseif self.procedure == 8
                for i = 10
                    if i == 0
                        % do stuff
                    elseif i == 1
                        % do stuff
                    else 
                        break
                    end 
                end 
            elseif self.procedure == 9
                for i = 10
                    if i == 0
                        % do stuff
                    elseif i == 1
                        % do stuff
                    else 
                        break
                    end 
                end 
            else
                msg = 'Not possible. Bug in code.';
                warning(msg);
            end
        end

        function SelectPath(self)
            % Add info here.
            self.chefPerson(1).move((transl(0,2.0,-0.9))*(rpy2tr(0,0,pi/2)));
        end

        function AnimateProcedure(self)
            % Add info here. 
            self.chefPerson(1).move((transl(0,2.0,-0.9))*(rpy2tr(0,0,pi/2)));
        end

    end
end
