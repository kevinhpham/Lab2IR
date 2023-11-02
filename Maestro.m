classdef Maestro <Environment %Inherits from Environment
    % The Maestro class is the main class that controls: robots, environment
    % Used to get the program to function all together

    % States
    % e05 static = (0)
    % e05 tray = (1)
    % e05 meal = (2)

    % conveyor static = (0)
    % conveyor push = (1)

    % dobot static = (0)
    % dobot juice = (1)
    % dobot cutlery = (2)

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
        dobotPlannedPath;   % Where the robot wants to go
        dobotItemHold;      % What item the robot is holding
        dobotItemPlaced;    % What item the robot has placed already
        dobotCurrentStep;   % What stage in the process the robot at

        % variables unique to the Maestro class
        procedure = 1;      % The robot starts are procedure 1 to begin
        % steps;
        eButton;            % Called eButton as eStop is inherited from Environment Class
    end
    
    % The master code that runs all the main robot tasks
    methods
        function self = Maestro()
            self.TestFunction();
            self.SelectProcedure();
            self.SelectPath();
            self.AnimateProcedure();
        end

        function TestFunction(self) % Test if I can move a person
            self.chefPerson(1).move((transl(0,2.0,-0.9))*(rpy2tr(0,0,pi/2)));
        end

        function SelectProcedure(self)
            % e05 move2tray(1), conveyor static(0), dobot static(0)
            if self.procedure == 1
                for i = self.e05CurrentStep:length(self.e05PlannedPath)
                    if self.eButton == 0 % If estop not pressed
                        e05_worker.animateArm(self.e05PlannedPath(i,:), self.e05ItemHold) % Pickup the tray and put it down
                        % push the meal to the e05
                        % self.e05CurrentStep = i;
                    elseif i == length(self.e05PlannedPath)
                        self.procedure = 2;         % Move to procedure 2
                        self.e05CurrentStep = 1;    % Current Status is 1
                        self.dobotCurrentStep = 1;
                    else 
                        break % Estop pressed, stop action
                    end 
                end 
             
            % e05 move2meal(2), conveyor static(0), dobot static(0)
            elseif self.procedure == 2
                for i = self.e05CurrentStep:length(self.e05PlannedPath)
                    if self.eButton == 0
                        e05_worker.animateArm(self.e05PlannedPath(i,:), self.e05ItemHold) % Pickup the meal and put it down
                    elseif i == length(self.e05PlannedPath)
                        self.procedure = 3;         % Move to procedure 3
                        self.e05CurrentStep = 2;    % Current Status is 2
                        self.dobotCurrentStep = 2;
                    else 
                        break % Estop pressed, stop action
                    end 
                end 

            % e05 move2tray(1), conveyor push(1), dobot move2juice(1)
            elseif self.procedure == 3
                for i = self.e05CurrentStep:length(self.e05PlannedPath)
                    if self.eButton == 0
                        e05_worker.animateArm(self.e05PlannedPath(i,:), self.e05ItemHold); % move the e05 to the tray
                        % push the meal to the e05
                        % push the juice + cutlery to the dobot
                        if i > 1
                            dobot.animateArm(self.dobotPlannedPath(i,:), self.dobotItemHold); % move dobot to juice and deposit
                        end
                    elseif i == length(self.dobotPlannedPath)
                        % push the main conveyor
                        self.procedure = 4;         % Move to procedure 4
                        self.e05CurrentStep = 3;    % Current Status is 3
                        self.dobotCurrentStep = 3;
                    else 
                        break % Estop pressed, stop action
                    end 
                end 

            % e05 move2meal(2), conveyor static(0), dobot move2cutlery(2)
            elseif self.procedure == 4
                for i = self.e05CurrentStep:length(self.e05PlannedPath)
                    if self.eButton == 0
                        e05_worker.animateArm(self.e05PlannedPath(i,:), self.e05ItemHold); % move to the meal box and put down
                        if i > 1
                            dobot.animateArm(self.dobotPlannedPath(i,:), self.dobotItemHold); % move to cutlery and put down
                        end
                    elseif i == length(self.dobotPlannedPath)
                        self.procedure = 5;         % Move to procedure 5
                        self.e05CurrentStep = 4;    % Current Status is 4
                        self.dobotCurrentStep = 4;
                    else 
                        break % Estop pressed, stop action
                    end 
                end 

            % e05 static (0), conveyor push(1), dobot move2juice(1)
            elseif self.procedure == 5
                for i = self.dobotCurrentStep:length(self.dobotPlannedPath)
                    if self.eButton == 0
                        dobot.animateArm(self.dobotPlannedPath(i,:), self.dobotItemHold); % move the dobot to the juice and deposit
                    elseif i == length(self.dobotPlannedPath)
                        % push the main conveyor 
                        self.procedure = 6;         % Move to procedure 6
                        self.e05CurrentStep = 5;    % Current Status is 5
                        self.dobotCurrentStep = 5;
                    else 
                        break % Estop pressed, stop action
                    end 
                end 
            
            % e05 static(0), conveyor static(0), dobot move2cutlery(2)
            elseif self.procedure == 6
                for i = self.dobotCurrentStep:length(self.dobotPlannedPath)
                    if self.eButton == 0
                        dobot.animateArm(self.dobotPlannedPath(i,:), self.dobotItemHold); % move the dobot to the cutlery and deposit
                    elseif i == length(self.dobotPlannedPath)
                        self.procedure = 7;         % Move to procedure 7
                        self.e05CurrentStep = 6;    % Current Status is 6
                        self.dobotCurrentStep = 6;
                    else 
                        break % Estop pressed, stop action
                    end 
                end 

            % e05 static(0), conveyor push(1), dobot static(0)
            elseif self.procedure == 7
                for i = 10 % Some time/ default amount
                    if self.eButton == 0
                        trayConveyor.push(pushables)
                    elseif i == 1
                        self.procedure = 8;         % Move to procedure 8
                        self.e05CurrentStep = 7;    % Current Status is 7
                        self.dobotCurrentStep = 7;
                    else 
                        break % Estop pressed, stop action
                    end 
                end 
 
            elseif self.procedure == 8
                for i = stepCurrentStep
                    if self.eButton == 0
                        % Main conveyor
                        trayConveyor.push(pushables)

                        % Meal conveyor
                        mealConveyor(1).push(MealBox)
                        mealConveyor(2).push(MealBox)

                        % Dobot conveyor
                        dobotConveyor(1).push(juiceBoxes)
                        dobotConveyor(2).push(cutlery)
                        dobotConveyor(3).push(juiceBoxes)
                    else % Assume estop is pressed. 
                        break % Stop pushing items on all conveyors
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
