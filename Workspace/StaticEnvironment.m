classdef StaticEnvironment <handle
    % The purpose of this class is to make the environment
    % The class differentiates between a static and non-static environment
    % This is achieved through two functions:
        % SetupStaticEnvironment()
        % SetupNonStaticEnvironment()
    
    properties % Defining variables
        trayStorage;
        trays;
        glassBarrier;
        offloadBay;
        packageBox;
        safetyTable;
        eStop;
        fireExtinguisher;
        firstAid;
        bJuiceStock;
        cutleryStock;
        oJuiceStock;
        vMealStock; 
        mMealStock;
    end
    
    methods
        function self = StaticEnvironment() % Defining functions
            self.SetupStaticEnvironment(); % Populates workspace with static items
        end

        function SetupStaticEnvironment(self) % The purpose of this function is to setup the static environment
            camlight; % Setup lighting
            hold on; % Maintain set-up

            axis([-5, 5, -5, 5, -0.88, 3]) % Setting axis of the workspace
            view(3) % Set to isometric view

            % Import in wallpaper and floor
            surf([-5,-5;5,5] ...
                  ,[-5,5;-5,5] ...
                  ,[-0.88,-0.88;-0.88,-0.88] ...
                  ,'CData',imread('Floor.jpg') ...
                  ,'FaceColor','texturemap');

            surf([-5,5;-5,5] ...
                  ,[5,5;5,5] ...
                  ,[3,3;-0.88,-0.88] ...
                  ,'CData',imread('WallPaperWords.jpg') ...
                  ,'FaceColor','texturemap');

            surf([5,5;5,5] ...
                  ,[5,-5;5,-5] ...
                  ,[3,3;-0.88,-0.88] ...
                  ,'CData',imread('WallPaper.jpg') ...
                  ,'FaceColor','texturemap');

            % Empty tray storage in the environment (x2)
            self.trayStorage = TrayStorage.empty; % Matlab thinks its an array of doubles
            self.trayStorage(1) = TrayStorage(transl(3.0,-1.3,0)); % Empty Rack 1
            self.trayStorage(2) = TrayStorage(transl(2.3,-1.3,0)); % Empty Rack 2

            % GlassBarriers in the environment
            self.glassBarrier = GlassBarrier.empty;
            self.glassBarrier(1) = GlassBarrier(transl(-4,-1,-0.9));
            self.glassBarrier(2) = GlassBarrier(transl(-3.15,-1,-0.9));
            self.glassBarrier(3) = GlassBarrier(transl(2.75,-1,-0.9));
            self.glassBarrier(4) = GlassBarrier(transl(-0.15,-1,-0.9));
            self.glassBarrier(5) = GlassBarrier(transl(0.15,-1,-0.9));
            self.glassBarrier(6) = GlassBarrier((transl(0,0,-0.9))*(rpy2tr(0,0,pi/2)));
            self.glassBarrier(7) = GlassBarrier((transl(0,2.0,-0.9))*(rpy2tr(0,0,pi/2)));
            self.glassBarrier(8) = GlassBarrier((transl(0,4.0,-0.9))*(rpy2tr(0,0,pi/2)));

            % Back Offload Bay
            self.offloadBay = OffloadBay.empty;
            self.offloadBay(1) = OffloadBay(transl(0.9,4,-0.88)); % Meal Offload Bay
            self.offloadBay(2) = OffloadBay(transl(-10.9,4,-0.88)); % Juice Offload Bay

            % Package Boxes underneath the offload bay
            self.packageBox = StockBox.empty;
            self.packageBox(1) = StockBox(transl(-4.75,4,-0.88)); % Juice Offload Box
            self.packageBox(2) = StockBox(transl(-2.75,4,-0.88)); % Juice Offload Box
            self.packageBox(3) = StockBox(transl(1.1,4,-0.88)); % Meal Offload Box
            self.packageBox(4) = StockBox(transl(3.1,4,-0.88)); % Meal Offload Box

            % Safety Equipment Tables
            self.safetyTable = MealRobotTable.empty;
            self.safetyTable(1) = MealRobotTable(transl(-3,0.5,0));
            self.safetyTable(2) = MealRobotTable(transl(-4,0.5,0));
            self.safetyTable(3) = MealRobotTable(transl(3,0.5,0));
            self.safetyTable(4) = MealRobotTable(transl(3,1.2,0));

            % Estop
            self.eStop = Estop.empty;
            self.eStop = Estop(transl(-3,0.5,0.1));
            self.eStop = Estop(transl(3,0.5,0.1));

            % Fire Extinguisher
            self.fireExtinguisher = FireExtinguisher.empty;
            self.fireExtinguisher(1) = FireExtinguisher(transl(-4,0.5,0));
            self.fireExtinguisher(2) = FireExtinguisher(transl(3,1.2,0));

            % First Aid
            self.firstAid = FirstAidKit.empty;
            self.firstAid(1) = FirstAidKit(transl(-5,3.5,0)); % First Aid Juice Section
            self.firstAid(2) = FirstAidKit(transl(5,3.5,0)); % First Aid Meal Section

            % Offload Bay Display Stock
            % Blackcurrent Juice Stock
            self.bJuiceStock = JuiceBox.empty;
            self.bJuiceStock(1) = JuiceBox(transl(-3.6,4.7,0.02), 'b');
            self.bJuiceStock(2) = JuiceBox  (transl(-3.8,4.7,0.02), 'b');
            self.bJuiceStock(3) = JuiceBox(transl(-4.0,4.7,0.02), 'b');
            self.bJuiceStock(4)= JuiceBox(transl(-4.2,4.7,0.02), 'b');
            self.bJuiceStock(5) = JuiceBox(transl(-4.4,4.7,0.02), 'b');
            self.bJuiceStock(6) = JuiceBox(transl(-4.4,4.5,0.02), 'b');
            self.bJuiceStock(7) = JuiceBox(transl(-4.2,4.5,0.02), 'b');
            self.bJuiceStock(8) = JuiceBox(transl(-4.0,4.5,0.02), 'b');
            self.bJuiceStock(9) = JuiceBox(transl(-3.8,4.5,0.02), 'b');
            self.bJuiceStock(10) = JuiceBox(transl(-3.6,4.5,0.02), 'b');
            self.bJuiceStock(11) = JuiceBox(transl(-4.4,4.3,0.02), 'b');
            self.bJuiceStock(12) = JuiceBox(transl(-4.2,4.3,0.02), 'b');
            self.bJuiceStock(13) = JuiceBox(transl(-4.0,4.3,0.02), 'b');
            self.bJuiceStock(14) = JuiceBox(transl(-3.8,4.3,0.02), 'b');
            self.bJuiceStock(15) = JuiceBox(transl(-3.6,4.3,0.02), 'b');

            % Cutlery Stock
            self.cutleryStock = Cutlery.empty;
            self.cutleryStock(1) = Cutlery(transl(-3.2, 4.7, 0.02));
            self.cutleryStock(2) = Cutlery(transl(-3.0, 4.7, 0.02));
            self.cutleryStock(3) = Cutlery(transl(-2.8, 4.7, 0.02));
            self.cutleryStock(4) = Cutlery(transl(-2.6, 4.7, 0.02));
            self.cutleryStock(5) = Cutlery(transl(-2.4, 4.7, 0.02));
            self.cutleryStock(6) = Cutlery(transl(-3.2, 4.4, 0.02));
            self.cutleryStock(7) = Cutlery(transl(-3.0, 4.4, 0.02));
            self.cutleryStock(8) = Cutlery(transl(-2.8, 4.4, 0.02));
            self.cutleryStock(9) = Cutlery(transl(-2.6, 4.4, 0.02));
            self.cutleryStock(10) = Cutlery(transl(-2.4, 4.4, 0.02));

            % Orange Juice Stock
            self.oJuiceStock = JuiceBox.empty;
            self.oJuiceStock(1) = JuiceBox(transl(-2.0,4.7,0.02), 'o');
            self.oJuiceStock(2) = JuiceBox(transl(-1.8,4.7,0.02), 'o');
            self.oJuiceStock(3) = JuiceBox(transl(-1.6,4.7,0.02), 'o');
            self.oJuiceStock(4) = JuiceBox(transl(-1.4,4.7,0.02), 'o');
            self.oJuiceStock(5) = JuiceBox(transl(-1.2,4.7,0.02), 'o');
            self.oJuiceStock(6) = JuiceBox(transl(-2.0,4.5,0.02), 'o');
            self.oJuiceStock(7) = JuiceBox(transl(-1.8,4.5,0.02), 'o');
            self.oJuiceStock(8) = JuiceBox(transl(-1.6,4.5,0.02), 'o');
            self.oJuiceStock(9) = JuiceBox(transl(-1.4,4.5,0.02), 'o');
            self.oJuiceStock(10) = JuiceBox(transl(-1.2,4.5,0.02), 'o');
            self.oJuiceStock(11) = JuiceBox(transl(-2.0,4.3,0.02), 'o');
            self.oJuiceStock(12) = JuiceBox(transl(-1.8,4.3,0.02), 'o');
            self.oJuiceStock(13) = JuiceBox(transl(-1.6,4.3,0.02), 'o');
            self.oJuiceStock(14) = JuiceBox(transl(-1.4,4.3,0.02), 'o');
            self.oJuiceStock(15) = JuiceBox(transl(-1.2,4.3,0.02), 'o');

            % Veg Meal Stock
            self.vMealStock = MealBox.empty;
            self.vMealStock(1) = MealBox(transl(1.2,4.7,0.02), 'v');
            self.vMealStock(2) = MealBox(transl(1.4,4.7,0.02), 'v');
            self.vMealStock(3) = MealBox(transl(1.6,4.7,0.02), 'v');
            self.vMealStock(4) = MealBox(transl(1.8,4.7,0.02), 'v');
            self.vMealStock(5) = MealBox(transl(2.0,4.7,0.02), 'v');
            self.vMealStock(6) = MealBox(transl(1.2,4.5,0.02), 'v');
            self.vMealStock(7) = MealBox(transl(1.4,4.5,0.02), 'v');
            self.vMealStock(8) = MealBox(transl(1.6,4.5,0.02), 'v');
            self.vMealStock(9) = MealBox(transl(1.8,4.5,0.02), 'v');
            self.vMealStock(10) = MealBox(transl(2.0,4.5,0.02), 'v');
            self.vMealStock(11) = MealBox(transl(1.2,4.3,0.02), 'v');
            self.vMealStock(12) = MealBox(transl(1.4,4.3,0.02), 'v');
            self.vMealStock(13) = MealBox(transl(1.6,4.3,0.02), 'v');
            self.vMealStock(14) = MealBox(transl(1.8,4.3,0.02), 'v');
            self.vMealStock(15) = MealBox(transl(2.0,4.3,0.02), 'v');

            % Meat Meal Stock
            self.mMealStock = MealBox.empty;
            self.mMealStock(1) = MealBox(transl(2.4,4.7,0.02), 'm');
            self.mMealStock(2) = MealBox(transl(2.6,4.7,0.02), 'm');
            self.mMealStock(3) = MealBox(transl(2.8,4.7,0.02), 'm');
            self.mMealStock(4) = MealBox(transl(3.0,4.7,0.02), 'm');
            self.mMealStock(5) = MealBox(transl(3.2,4.7,0.02), 'm');
            self.mMealStock(6) = MealBox(transl(2.4,4.5,0.02), 'm');
            self.mMealStock(7) = MealBox(transl(2.6,4.5,0.02), 'm');
            self.mMealStock(8) = MealBox(transl(2.8,4.5,0.02), 'm');
            self.mMealStock(9) = MealBox(transl(3.0,4.5,0.02), 'm');
            self.mMealStock(10) = MealBox(transl(3.2,4.5,0.02), 'm');
            self.mMealStock(11) = MealBox(transl(2.4,4.3,0.02), 'm');
            self.mMealStock(12) = MealBox(transl(2.6,4.3,0.02), 'm');
            self.mMealStock(13) = MealBox(transl(2.8,4.3,0.02), 'm');
            self.mMealStock(14) = MealBox(transl(3.0,4.3,0.02), 'm');
            self.mMealStock(15) = MealBox(transl(3.2,4.3,0.02), 'm');
        end 
    end
end