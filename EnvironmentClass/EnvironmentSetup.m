%% This script is used to show to setuup of static and non-static items

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
offloadBayM = OffloadBay(transl(0.9,4,-0.88));
offloadBayJ = OffloadBay(transl(-10.9,4,-0.88));

%Safety Bay
safetyTable1 = MealRobotTable(transl(-3,0.5,0));
eStop1 = Estop(transl(-3,0.5,0.2));

safetyTable2 = MealRobotTable(transl(-4,0.5,0));
fireExtinguisher2 = FireExtinguisher(transl(-4,0.5,0));

safetyTable3 = MealRobotTable(transl(3,0.5,0));
eStop2 = Estop(transl(3,0.5,0.2));

safetyTable4 = MealRobotTable(transl(4,0.5,0));
fireExtinguisher4 = FireExtinguisher(transl(4,0.5,0));

% First Aid
firstAidMeal = FirstAidKit(transl(5,3.5,0));
firstAidJuice = FirstAidKit(transl(-5,3.5,0));

% Package Boxes
packageBoxJ1 = StockBox(transl(-4.75,4,-0.88));
packageBoxJ2 = StockBox(transl(-2.75,4,-0.88));
packageBoxM1 = StockBox(transl(1.1,4,-0.88));
packageBoxM2 = StockBox(transl(3.1,4,-0.88));

% Offload Zone Juices
bJuiceStock1 = JuiceBox(transl(-3.6,4.7,0.02), 'b');
bJuiceStock2 = JuiceBox(transl(-3.8,4.7,0.02), 'b');
bJuiceStock3 = JuiceBox(transl(-4.0,4.7,0.02), 'b');
bJuiceStock4 = JuiceBox(transl(-4.2,4.7,0.02), 'b');
bJuiceStock5 = JuiceBox(transl(-4.4,4.7,0.02), 'b');
bJuiceStock6 = JuiceBox(transl(-4.4,4.5,0.02), 'b');
bJuiceStock7 = JuiceBox(transl(-4.2,4.5,0.02), 'b');
bJuiceStock8 = JuiceBox(transl(-4.0,4.5,0.02), 'b');
bJuiceStock9 = JuiceBox(transl(-3.8,4.5,0.02), 'b');
bJuiceStock10 = JuiceBox(transl(-3.6,4.5,0.02), 'b');
bJuiceStock11 = JuiceBox(transl(-4.4,4.3,0.02), 'b');
bJuiceStock12 = JuiceBox(transl(-4.2,4.3,0.02), 'b');
bJuiceStock13 = JuiceBox(transl(-4.0,4.3,0.02), 'b');
bJuiceStock14 = JuiceBox(transl(-3.8,4.3,0.02), 'b');
bJuiceStock15 = JuiceBox(transl(-3.6,4.3,0.02), 'b');

cutleryStock1 = Cutlery(transl(-3.2, 4.7, 0.02));
cutleryStock2 = Cutlery(transl(-3.0, 4.7, 0.02));
cutleryStock3 = Cutlery(transl(-2.8, 4.7, 0.02));
cutleryStock4 = Cutlery(transl(-2.6, 4.7, 0.02));
cutleryStock5 = Cutlery(transl(-2.4, 4.7, 0.02));
cutleryStock6 = Cutlery(transl(-3.2, 4.4, 0.02));
cutleryStock7 = Cutlery(transl(-3.0, 4.4, 0.02));
cutleryStock8 = Cutlery(transl(-2.8, 4.4, 0.02));
cutleryStock9 = Cutlery(transl(-2.6, 4.4, 0.02));
cutleryStock10 = Cutlery(transl(-2.4, 4.4, 0.02));

oJuiceStock1 = JuiceBox(transl(-2.0,4.7,0.02), 'o');
oJuiceStock2 = JuiceBox(transl(-1.8,4.7,0.02), 'o');
oJuiceStock3 = JuiceBox(transl(-1.6,4.7,0.02), 'o');
oJuiceStock4 = JuiceBox(transl(-1.4,4.7,0.02), 'o');
oJuiceStock5 = JuiceBox(transl(-1.2,4.7,0.02), 'o');
oJuiceStock6 = JuiceBox(transl(-2.0,4.5,0.02), 'o');
oJuiceStock7 = JuiceBox(transl(-1.8,4.5,0.02), 'o');
oJuiceStock8 = JuiceBox(transl(-1.6,4.5,0.02), 'o');
oJuiceStock9 = JuiceBox(transl(-1.4,4.5,0.02), 'o');
oJuiceStock10 = JuiceBox(transl(-1.2,4.5,0.02), 'o');
oJuiceStock11 = JuiceBox(transl(-2.0,4.3,0.02), 'o');
oJuiceStock12 = JuiceBox(transl(-1.8,4.3,0.02), 'o');
oJuiceStock13 = JuiceBox(transl(-1.6,4.3,0.02), 'o');
oJuiceStock14 = JuiceBox(transl(-1.4,4.3,0.02), 'o');
oJuiceStock15 = JuiceBox(transl(-1.2,4.3,0.02), 'o');

% Meal Stock
vMealStock1 = MealBox(transl(1.2,4.7,0.02), 'v');
vMealStock2 = MealBox(transl(1.4,4.7,0.02), 'v');
vMealStock3 = MealBox(transl(1.6,4.7,0.02), 'v');
vMealStock4 = MealBox(transl(1.8,4.7,0.02), 'v');
vMealStock5 = MealBox(transl(2.0,4.7,0.02), 'v');
vMealStock6 = MealBox(transl(1.2,4.5,0.02), 'v');
vMealStock7 = MealBox(transl(1.4,4.5,0.02), 'v');
vMealStock8 = MealBox(transl(1.6,4.5,0.02), 'v');
vMealStock9 = MealBox(transl(1.8,4.5,0.02), 'v');
vMealStock10 = MealBox(transl(2.0,4.5,0.02), 'v');
vMealStock11 = MealBox(transl(1.2,4.3,0.02), 'v');
vMealStock12 = MealBox(transl(1.4,4.3,0.02), 'v');
vMealStock13 = MealBox(transl(1.6,4.3,0.02), 'v');
vMealStock14 = MealBox(transl(1.8,4.3,0.02), 'v');
vMealStock15 = MealBox(transl(2.0,4.3,0.02), 'v');

mMealStock1 = MealBox(transl(2.4,4.7,0.02), 'm');
mMealStock2 = MealBox(transl(2.6,4.7,0.02), 'm');
mMealStock3 = MealBox(transl(2.8,4.7,0.02), 'm');
mMealStock4 = MealBox(transl(3.0,4.7,0.02), 'm');
mMealStock5 = MealBox(transl(3.2,4.7,0.02), 'm');
mMealStock6 = MealBox(transl(2.4,4.5,0.02), 'm');
mMealStock7 = MealBox(transl(2.6,4.5,0.02), 'm');
mMealStock8 = MealBox(transl(2.8,4.5,0.02), 'm');
mMealStock9 = MealBox(transl(3.0,4.5,0.02), 'm');
mMealStock10 = MealBox(transl(3.2,4.5,0.02), 'm');
mMealStock11 = MealBox(transl(2.4,4.3,0.02), 'm');
mMealStock12 = MealBox(transl(2.6,4.3,0.02), 'm');
mMealStock13 = MealBox(transl(2.8,4.3,0.02), 'm');
mMealStock14 = MealBox(transl(3.0,4.3,0.02), 'm');
mMealStock15 = MealBox(transl(3.2,4.3,0.02), 'm');

% Insert Chef
chef1 = ChefPerson(transl(-2.3,2.5,-0.2));
chef2 = ChefPerson(transl(-1.6,2.9,-0.2));
chef3 = ChefPerson(transl(-1,2.5,-0.2));
chef4 = ChefPerson(transl(1.1, 2.8,-0.2));
chef5 = ChefPerson(transl(1.8, 2.8,-0.2));
