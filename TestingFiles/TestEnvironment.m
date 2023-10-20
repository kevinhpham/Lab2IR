%% Setting the Environment
% Clear the figures & set up the conditions for the environment
clf
camlight
axis equal;
hold on 

% Set the axis and view to isometric
axis([-5, 5, -5, 5, -0.88, 3])
view(3)

% Import the floor/ wallpapers
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

trayConveyor = Conveyor2(transl(0,-4,0));

% Dobot Setup
juiceConveyorLeft = ConveyorD(transl(0,0,0));
juiceConveyorLeft.move((transl(-2,-0.8,0))*(rpy2tr(0,0,pi/2)));
juiceConveyorCenter = ConveyorD(transl(0,0,0));
juiceConveyorCenter.move((transl(-1.65,-0.4,0))*(rpy2tr(0,0,pi/2)));
juiceConveyorRight = ConveyorD(transl(0,0,0));
juiceConveyorRight.move((transl(-1.3,-0.8,0))*(rpy2tr(0,0,pi/2)));
dobotTable = RobotTable(transl(-1.65,-3.6,0));

% E05 Setup
mealConveyorLeft = ConveyorD(transl(0,0,0));
mealConveyorLeft.move((transl(1.3,-0.4,0))*(rpy2tr(0,0,pi/2)));
mealConveyorRight = ConveyorD(transl(0,0,0));
mealConveyorRight.move((transl(1.6,-0.4,0))*(rpy2tr(0,0,pi/2)));
e05Table = MealRobotTable(transl(1.45,-3.6,0));
worker(1) = E05_worker(e05Table.base*transl(0,0,0.9))

% Area Dividers
barrierLeft1 = GlassBarrier(transl(-4,-1,-0.9));
barrierLeft2 = GlassBarrier(transl(-3.15,-1,-0.9));
barrierRight1 = GlassBarrier(transl(4,-1,-0.9));
barrierRight2 = GlassBarrier(transl(2.75,-1,-0.9));
barrierCenter1 = GlassBarrier(transl(-0.15,-1,-0.9));
barrierCenter2 = GlassBarrier(transl(0.15,-1,-0.9));

% Barrier Dividers
barrierDivider1 = GlassBarrier(transl(0,0,0));
barrierDivider1.move((transl(0,0,-0.9))*(rpy2tr(0,0,pi/2)));
barrierDivider2 = GlassBarrier(transl(0,0,0));
barrierDivider2.move((transl(0,2.0,-0.9))*(rpy2tr(0,0,pi/2)));
barrierDivider3 = GlassBarrier(transl(0,0,0));
barrierDivider3.move((transl(0,4.0,-0.9))*(rpy2tr(0,0,pi/2)));

%Tray Divider
barrierTray1 = GlassBarrier(transl(2.75,-3.2,-0.9));
barrierTray2 = GlassBarrier(transl(0,0,0));
barrierTray2.move((transl(3.7,-2.25,-0.9))*(rpy2tr(0,0,pi/2)));
barrierTray3 = GlassBarrier(transl(0,0,0));
barrierTray3.move((transl(3.7,-2.0,-0.9))*(rpy2tr(0,0,pi/2)));

%Tray Storage
trayStorage = TrayStorage(transl(0,0,0));
trayStorage.move((transl(1.95,-3.6,0))*(rpy2tr(0,0,pi/2)));
trayStorage2 = TrayStorage(transl(0,0,0));
trayStorage2.move((transl(3.85,-2.6,0))*(rpy2tr(0,0,pi/2)));
trayStorage3 = TrayStorage(transl(0,0,0));
trayStorage3.move((transl(3.85,-1.6,0))*(rpy2tr(0,0,pi/2)));

%Offload Bay
offloadBay1 = OffloadBay(transl(2.5,4,-0.88));
offloadBay2 = OffloadBay(transl(-10,4,-0.88));

%Safety Bay
safetyTable1 = MealRobotTable(transl(0,-2.0,0));
eStop1 = Estop(transl(0,-2.0,0.2));

safetyTable2 = MealRobotTable(transl(0,-2.6,0));
fireExtinguisher = FireExtinguisher(transl(0,-2.6,0));

safetyTable3 = MealRobotTable(transl(0,-3.2,0));
eStop2 = Estop(transl(0,-3.2,0.2));

% First Aid
firstAidJuice = FirstAidKit(transl(5,3.5,0));
firstAidMeal = FirstAidKit(transl(-5,3.5,0));

% OffloadBay
package1 = FullStockTray(transl(-4.6,4,-0.3));
package2 = FullStockTray(transl(-3.6,4,-0.3));
package3 = FullStockTray(transl(-2.6,4,-0.3));
package4 = FullStockTray(transl(-1.6,4,-0.3));

% Package Boxes
packageBox1 = StockBox(transl(-3.8,4,-0.88));
packageBox2 = StockBox(transl(-1.8,4,-0.88));

%% Idea
% Make a list of objects to be pushed vs not
% Cell
% Pass the cell into conveyor belt class
% 