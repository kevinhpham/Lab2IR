classdef Maestro <RobotWorkSpace %Inherits from Environment
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
        robotsCurrentStep;% What stage in the process the robot at
        robotsPathLength;

        e05PlannedPath; % Where the robot wants to go
        e05ItemHold;    % What item the robot is holding
        e05Placement;   % What item the robot will place grasped item on
        steps = 10;     % Number of steps animations take

        % conveyor trackinf variables
        conveyorCurrentPushCount; %how many times the conveyor has pushed during a procedure
        conveyorTotalPushCount;   %Total amount of time conveyor needs to push during a procedure, should always be 3x'steps'

        % dobot tracking variables
        dobotPlannedPath;   % Where the robot wants to go
        dobotItemHold;      % What item the robot is holding
        dobotPlacement;     % What item the robot will place grasped item on

        %
        totalMealCount;     %Total number of meals to make
        currentMealCount;   %current meal being made

        %Conveyor feed
        meals;
        cutlery;
        juiceBoxes;

        %planned conveyor feed type
        mealType;
        juiceType

        % variables unique to the Maestro class
        procedure;      % The robot starts are procedure 1 to begin, goes from 1 - 7
        % steps;
        eButton;            % Called eButton as eStop is inherited from Environment Class
        lightSensor;        % From light sensor
        controlPause;       %used by gui to pause the system. set to 1 if system is paused
    end

    % The master code that runs all the main robot tasks
    methods
        function self = Maestro()
            %update collision checking for robots
            %self.dobot.AddCollidables(self.chefPerson);
            %self.e05Robot.AddCollidables(self.chefPerson);
            self.eButton = 0;
            self.controlPause = 0;
            self.lightSensor = 0;
            self.UpdateConveyorPushDistance();
            self.Reset()
            disp('Maestro: System ready, lets make some meals!')
        end

        function MealOrders(self,mealType,juiceType,amount)
            self.Reset()
            self.trays = self.trayStorage.AddTrays(amount);
            self.mealType = mealType;
            self.juiceType = juiceType;
            self.totalMealCount = amount+1;
            self.ContinueOrder;
        end

        function ContinueOrder(self)
            while (self.eButton == 0 && self.lightSensor == 0 && self.controlPause == 0)
                self.PlanProcedure()
                self.ExecuteProcedure()
                if self.totalMealCount < self.currentMealCount
                    break
                end
            end
        end


        function ExecuteProcedure(self)
            if (self.eButton == 0 && self.lightSensor == 0 && self.e05Robot.power && self.dobot.power && self.controlPause == 0)    %if E-button has not been pushed
                if self.procedure == 1
                    disp('Maestro:Performing procedure 1, pushing items along conveyorbelts')
                    for i = self.conveyorCurrentPushCount:self.conveyorTotalPushCount
                        if self.currentMealCount < self.totalMealCount   %If not making the last meal tray
                            self.mMealConveyor.push(self.meals(self.currentMealCount));
                            self.vMealConveyor.push(self.meals(self.currentMealCount));
                        end

                        if 1 < self.currentMealCount                    %If not making the first meal tray
                            self.cutleryConveyor.push(self.cutlery(self.currentMealCount));
                            self.bJuiceConveyor.push(self.juiceBoxes(self.currentMealCount));
                            self.oJuiceConveyor.push(self.juiceBoxes(self.currentMealCount));
                            self.trayConveyor.push(self.pushables)
                        end
                        self.conveyorCurrentPushCount = i;
                        if (self.eButton == 1 || self.lightSensor == 1 || self.e05Robot.power==0 || self.dobot.power==0 || self.controlPause == 1)
                            self.conveyorCurrentPushCount = i;   %If procedure is canceled early, keep track of where it stopped
                            msg = ['System stop signal recieved, procedure 1 has been stopped at ',num2str(self.conveyorCurrentPushCount),'/',num2str(self.conveyorTotalPushCount)];
                            warning(msg)
                            break
                        end
                        pause(0.02)
                    end

                    if self.conveyorCurrentPushCount == self.conveyorTotalPushCount
                        disp(['Maestro: Finished procedure ',num2str(self.procedure),' moving to procedure ',num2str(self.procedure+1)]);
                        self.procedure = self.procedure+1;
                        self.conveyorCurrentPushCount = 1;
                        self.robotsCurrentStep = 1;
                    end

                elseif (self.procedure <= 7 && not(self.procedure == 1))
                    disp(['Maestro: Moving arms for procedure: ', num2str(self.procedure)])
                    for i = self.robotsCurrentStep:self.robotsPathLength
                        if self.currentMealCount < self.totalMealCount    %If not making the last meal tray
                            if (self.procedure == 2 || self.procedure == 4 || self.procedure == 5 || self.procedure == 7) %procedures where only robot need to be animated
                                check(1) = self.e05Robot.AnimateArm(self.e05PlannedPath(i,:));
                                if  (self.procedure == 2 && self.conveyorCurrentPushCount == self.conveyorTotalPushCount )
                                    disp('Maestro: Deploying worker to refill trays')

                                end
                            else
                                check(1) = self.e05Robot.AnimateArm(self.e05PlannedPath(i,:),self.e05ItemHold{1});
                            end
                        end

                        if 1 < self.currentMealCount                      %if not making the first meal tray
                            if (self.procedure == 2 || self.procedure == 4 || self.procedure == 5 || self.procedure == 7)
                                check(2) = self.dobot.AnimateArm(self.dobotPlannedPath(i,:));
                            else
                                check(2) = self.dobot.AnimateArm(self.dobotPlannedPath(i,:),self.dobotItemHold{1});
                            end
                        end
                        pause(0.00)
                        self.robotsCurrentStep = i;
                        if (self.eButton == 1 || self.lightSensor == 1 || self.e05Robot.power == 0 || self.dobot.power== 0 || any(check) || self.controlPause == 1)
                            self.robotsCurrentStep = i;   %If procedure is canceled early, keep track of where it stopped
                            msg = ['System stop signal recieved, procedure ',num2str(self.procedure) ' has been stopped at ',num2str(self.robotsCurrentStep),'/',num2str(self.robotsPathLength)];
                            warning(msg)
                            break
                        end
                    end
                    % if self.currentMealCount < self.totalMealCount  %control gripper on e05
                    %     if (self.procedure == 2 || self.procedure == 4 || self.procedure == 5 || self.procedure == 7)
                    %         self.e05Robot.AnimateGripper(0.75,15);%open gripper;
                    %     else
                    %         self.e05Robot.AnimateGripper(1,15);%close gripper
                    %     end
                    % end

                    if self.robotsCurrentStep == self.robotsPathLength
                        if self.procedure == 7
                            if self.currentMealCount == self.totalMealCount
                                disp('Maestro: Pushing last meal tray')
                                for i = self.conveyorCurrentPushCount:8*self.steps
                                    self.trayConveyor.push(self.pushables);
                                    pause(0.01)
                                end
                                self.Reset()
                            end
                            disp('Maestro: Finished procedure 7, returning to procedure 1');
                            self.procedure = 1;
                            self.currentMealCount = self.currentMealCount+1;
                        else
                            disp(['Maestro: Finished procedure ',num2str(self.procedure),' moving to procedure ',num2str(self.procedure+1)]);
                            self.robotsCurrentStep = 1;
                            self.procedure = self.procedure+1;
                        end
                    end
                else
                    msg = ['Maestro: Cannot find a procedure ' num2str(self.procedure), ' activating E-stop'];
                    warning(msg);
                    self.EStopOn;
                end
            end
        end


        function PlanProcedure(self)
            if self.eButton == 0 && self.lightSensor == 0 && self.e05Robot.power == 1 && self.dobot.power == 1 && self.controlPause == 0   %if system has not been stopped
                %Updates the planning path that the arms and conveyor belts
                disp(['Maestro: Planning Procedures for loop ', num2str(self.currentMealCount),'/',num2str(self.totalMealCount)])
                if self.procedure == 1  %Places feed onto conveyor
                    disp('Maestro: Planning for procedure 1')
                    self.conveyorTotalPushCount = 3*self.steps;
                    disp(['Maestro: Conveyor total push count updated to: ', num2str(self.conveyorTotalPushCount)])
                    if self.currentMealCount < self.totalMealCount    %If not making the last meal
                        self.meals(self.currentMealCount) = MealBox(transl(0,0,0),self.mealType);
                        self.pushables{end+1} = self.meals(self.currentMealCount);
                        self.pushables{end+1} = self.trays(self.currentMealCount);
                        if strncmpi(self.meals(self.currentMealCount).plyFile,'MealBoxMeat',11)
                            self.meals(self.currentMealCount).move(self.mMealConveyor.base);
                            disp('Maestro: Added meat meal to conveyor')
                        elseif strncmpi(self.meals(self.currentMealCount).plyFile,'MealBoxVego',11)
                            self.meals(self.currentMealCount).move(self.vMealConveyor.base);
                            disp('Maestro: Added vegetarian meal to conveyor')
                        end
                    end

                    if 1 < self.currentMealCount                      %if not making the first meal tray,
                        self.juiceBoxes(self.currentMealCount) = JuiceBox(transl(0,0,0),self.juiceType);
                        self.cutlery(self.currentMealCount) = Cutlery(self.cutleryConveyor.base);
                        self.pushables{end+1} = self.juiceBoxes(self.currentMealCount);
                        self.pushables{end+1} = self.cutlery(self.currentMealCount);
                        disp('Maestro: Added cutlery to conveyor')
                        if strncmpi(self.juiceBoxes(self.currentMealCount).plyFile,'JuiceBoxOrange',14)
                            self.juiceBoxes(self.currentMealCount).move(self.oJuiceConveyor.base);
                            disp('Maestro: Added orange juicebox to conveyor')
                        elseif strncmpi(self.juiceBoxes(self.currentMealCount).plyFile,'JuiceBoxBlackCurrant',20)
                            self.juiceBoxes(self.currentMealCount).move(self.bJuiceConveyor.base*rpy2tr(0,0,pi));
                            disp('Maestro: Added black currant juicebox to conveyor')
                        end
                    end

                elseif (self.procedure == 2 || self.procedure == 5) %Pick up procedures
                    if self.currentMealCount < self.totalMealCount    %If not making the last meal tray, plan path for e05 to pickup tray
                        if self.procedure == 2
                            disp('Maestro: Planning procedure 2 for E05, picking up tray')
                            self.e05ItemHold{1} = self.trays(self.currentMealCount);
                        elseif self.procedure == 5
                            disp('Maestro: Planning for procedure 5 for E05,picking up meals')
                            self.e05ItemHold{1} = self.meals(self.currentMealCount);
                        end
                        self.e05PlannedPath = self.e05Robot.PlanPickupPath(self.e05ItemHold{1},self.steps);
                    end

                    if 1 < self.currentMealCount                      %if not making the first meal tray, plan path for dobot to pickup cutlery
                        if self.procedure == 2
                            disp('Maestro: Planning for procedure 2 joint path for dobot, picking up cutlery')
                            self.dobotItemHold{1} = self.cutlery(self.currentMealCount);
                        elseif self.procedure == 5
                            disp('Maestro: Planning for procedure 5 joint path for dobot, picking up juice')
                            self.dobotItemHold{1} = self.juiceBoxes(self.currentMealCount);
                        end
                        self.dobotPlannedPath = self.dobot.PlanPickupPath(self.dobotItemHold{1},self.steps);
                    end
                    self.UpdateRobotPathLength()

                elseif (self.procedure == 3 || self.procedure == 6)  %E05 deposit tray onto conveyor, dobot deposits cutlery onto tray
                    if self.currentMealCount < self.totalMealCount
                        if self.procedure == 3
                            disp('Maestro: Planning for procedure 3 for E05, depositing trays')
                            self.e05Placement{1} = self.trayConveyor;  %place on conveyor
                        elseif self.procedure == 6
                            disp('Maestro: Planning for procedure 6 for E05, depositing meals')
                            self.e05Placement{1} = self.trays(self.currentMealCount);  %place on tray
                        end
                        self.e05PlannedPath = self.e05Robot.PlanDepositPath(self.e05ItemHold{1},self.e05Placement{1},self.steps);
                    end

                    if 1 < self.currentMealCount
                        disp(['Maestro: Planning for procedure ' num2str(self.procedure),' for dobot, depositing', self.dobotItemHold{1}.plyFile])
                        self.dobotPlacement{1} = self.trays(self.currentMealCount-1);      %dobot always place on trays, no need for if checks
                        self.dobotPlannedPath = self.dobot.PlanDepositPath(self.dobotItemHold{1},self.dobotPlacement{1},self.steps);
                    end
                    self.UpdateRobotPathLength()

                elseif (self.procedure == 4 || self.procedure == 7)  %Retract arms from deposited item
                    if self.currentMealCount < self.totalMealCount    %If not making the last meal tray
                        e05q0 = self.e05Robot.GetPos();
                        self.e05PlannedPath = self.e05Robot.PlanRetract(e05q0,0.4,self.steps);
                    end

                    if 1 < self.currentMealCount                      %if not making the first meal tray
                        dobotq0 = self.dobot.GetPos();
                        self.dobotPlannedPath = self.dobot.PlanRetract(dobotq0,0.1,self.steps);
                    end

                    self.UpdateRobotPathLength()
                else
                    msg = ['Maestro: Cannot find a procedure ' num2str(self.procedure),];
                    warning(msg);
                    self.EStopOn;
                end
            else
                msg = 'Maestro: System has been stopped, path planning canceled';
                warning(msg);
            end
        end

        function EStopOn(self)
            msg = 'Maestro: E-stop activated, turning off power to robots';
            warning(msg);
            self.eButton = 1;
            self.dobot.TurnOff()
            self.e05Robot.TurnOff()
        end

        function EStopOff(self)
            self.eButton = 0;
            msg = 'Maestro has deactivated E-stop, robots still need to be powered back on';
            warning(msg);
        end

        function RobotsOn(self)
            self.dobot.TurnOn()
            self.e05Robot.TurnOn()
            msg = 'Maestro has turned on robots';
            warning(msg);
        end

        function UpdateRobotPathLength(self)
            %Updates the variable "robotsPathLEngth" which stores the
            %number of joint steps in the robots planned path.
            %Function is necessary as sometimes the dobot or the e05 won't
            %have their path planned while the other robot will.
            if length(self.dobotPlannedPath) < length(self.e05PlannedPath)
                self.robotsPathLength= length(self.e05PlannedPath);
            else
                self.robotsPathLength= length(self.dobotPlannedPath);
            end
            disp(['Maestro: Robots joint path length updated to: ',num2str(self.robotsPathLength)])
        end

        function UpdateConveyorPushDistance(self)
            disp('Maestro: Updating push distances of conveyorbelts')
            %distances set up to be iversely porpotional the number of steps in animation, so system will still work regardless of the number of steps of the animation
            self.vMealConveyor.setPushDistance(0.028*30/self.steps);
            self.mMealConveyor.setPushDistance(0.028*30/self.steps);
            self.oJuiceConveyor.setPushDistance(0.032*30/self.steps);
            self.cutleryConveyor.setPushDistance(0.0317*30/self.steps);
            self.bJuiceConveyor.setPushDistance(0.032*30/self.steps);
            self.trayConveyor.setPushDistance(-0.029*30/self.steps);
        end
        
        function WrapUpOrder(self)
            %Makes the current meal tray the final meal tray of the order
            self.totalMealCount = self.currentMealCount + 1
        end

        function Reset(self)
            %used to reset system after an order of meals have been created
            self.robotsCurrentStep = 1;
            self.e05PlannedPath = 1;
            self.e05ItemHold = {1};
            self.e05Placement = {1};
            self.conveyorCurrentPushCount = 1;
            self.dobotPlannedPath = 1;
            self.dobotItemHold = {1};
            self.dobotPlacement = {1};
            self.robotsCurrentStep = 1;
            self.totalMealCount = 0;
            self.currentMealCount = 1;

            %Conveyor feed
            self.meals = MealBox.empty;
            self.cutlery = Cutlery.empty;
            self.juiceBoxes = JuiceBox.empty;

            %planned conveyor feed type
            self.mealType = [];
            self.juiceType = [];
            self.procedure = 1;      % The robot starts are procedure 1 to begin, goes from 1 - 7

            %sensors
        end
    end
end
