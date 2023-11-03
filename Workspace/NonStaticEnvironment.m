classdef NonStaticEnvironment <handle
    % The purpose of this class is to make a non-static environment
    % Populates all the non-static items into the environment
    
    properties % Defining variables
        trayStorage;
        trays;
        trayConveyor;
        bJuiceConveyor;
        cutleryConveyor;
        oJuiceConveyor;
        vMealConveyor;
        mMealConveyor;
        chefPerson;
        dobot;
        e05Robot;
        dobotTable;
        e05Table;
        pushables;
        lightCurtain;
    end
    
    methods
        function self = NonStaticEnvironment() % Defining functions
            self.SetupNonStaticEnvironment(); % Populates workspace with non-static items
        end

        function SetupNonStaticEnvironment(self) % The purpose of this function is to setup the non-static (movable) items in the environment
            camlight;
            hold on;

            axis([-5, 5, -5, 5, -0.88, 3])
            view(3)

            % Main tray storage for robot to access to create trays
            self.trayStorage = TrayStorage.empty;
            self.trayStorage = TrayStorage((transl(1.95, -3.6, 0))*(rpy2tr(0,0,pi/2))); % Defines the position of the tray storage
            self.trays = self.trayStorage.AddTrays(8); % Creates and array of trays
            self.pushables = num2cell(self.trays); % Adds to a cell array called pushables
                                                   % Allows tray items to be pushed

            % Main conveyor for food
            self.trayConveyor = Conveyor2.empty;
            self.trayConveyor = Conveyor2(transl(0,-4,0)); 

            % Delivery Conveyors
            self.bJuiceConveyor = ConveyorD.empty;
            self.bJuiceConveyor = ConveyorD((transl(-2,-0.8,0))*(rpy2tr(0,0,pi/2)));
            self.cutleryConveyor = ConveyorD((transl(-1.65,-0.4,0))*(rpy2tr(0,0,pi/2)));
            self.oJuiceConveyor = ConveyorD((transl(-1.3,-0.8,0))*(rpy2tr(0,0,pi/2)));
            self.vMealConveyor = ConveyorD((transl(1.3,-0.4,0))*(rpy2tr(0,0,pi/2)));
            self.mMealConveyor = ConveyorD((transl(1.6,-0.4,0))*(rpy2tr(0,0,pi/2)));

            % Chef People
            self.chefPerson = ChefPerson.empty;
            self.chefPerson(1) = ChefPerson(transl(-2.3,2.5,-0.2));
            self.chefPerson(2) = ChefPerson(transl(-1.6,2.9,-0.2));
            self.chefPerson(3) = ChefPerson(transl(-1,2.5,-0.2));
            self.chefPerson(4) = ChefPerson(transl(1.1, 2.8,-0.2));
            self.chefPerson(5) = ChefPerson(transl(1.8, 2.8,-0.2));
            self.pushables = horzcat(self.pushables, num2cell(self.chefPerson)); % Adds chefPerson to pushables cell array
                                                                                 % Allows both trays and chefPeople to be 
                                                                                 % pushed at the same time.
            
            % LightCurtain in the Environment
            self.lightCurtain = LightCurtain.empty;
            self.lightCurtain(1) = LightCurtain(transl(4.35,-1,-0.85));
            % self.pushables = horzcat(self.pushables, num2cell(self.LightCurtain));

            % Robots + Tables
            self.dobotTable = RobotTable(transl(-1.65,-3.6,0)); % Table for Dobot
            self.dobot = DobotMagician(self.dobotTable.base*transl(0,0,0));

            self.e05Table = MealRobotTable(transl(1.45,-3.6,0)); % Table for e05
            self.e05Robot = E05_worker(self.e05Table.base*transl(0,0,0));

        end
    end
end