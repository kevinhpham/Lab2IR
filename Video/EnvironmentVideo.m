%% This class will be used to set-up the environment
% It is derived from the TestEnvironment '.m' file.
% This script populates the environment as shown in the video.

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
dobot = DobotMagician(dobotTable.base*transl(0,0,0));

% E05 Setup
mealConveyorLeft = ConveyorD(transl(0,0,0));
mealConveyorLeft.move((transl(1.3,-0.4,0))*(rpy2tr(0,0,pi/2)));
mealConveyorRight = ConveyorD(transl(0,0,0));
mealConveyorRight.move((transl(1.6,-0.4,0))*(rpy2tr(0,0,pi/2)));
e05Table = MealRobotTable(transl(1.45,-3.6,0));
worker = E05_worker(e05Table.base*transl(0,0,0));

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

% Insert Orange Juices
oJuice1 = JuiceBox(transl(-1.3, 2, 0.02), 'o');
oJuice2 = JuiceBox(transl(-1.3, 1.8, 0.02), 'o');
oJuice3 = JuiceBox(transl(-1.3, 1.6, 0.02), 'o');
oJuice4 = JuiceBox(transl(-1.3, 1.4, 0.02), 'o');
oJuice5 = JuiceBox(transl(-1.3, 1.2, 0.02), 'o');
oJuice6 = JuiceBox(transl(-1.3, 1.0, 0.02), 'o');
oJuice7 = JuiceBox(transl(-1.3, 0.8, 0.02), 'o');
oJuice8 = JuiceBox(transl(-1.3, 0.6, 0.02), 'o');
oJuice9 = JuiceBox(transl(-1.3, 0.4, 0.02), 'o');
oJuice10 = JuiceBox(transl(-1.3, 0.2, 0.02), 'o');
oJuice11 = JuiceBox(transl(-1.3, 0, 0.02), 'o');
oJuice12 = JuiceBox(transl(-1.3, -0.2, 0.02), 'o');
oJuice13 = JuiceBox(transl(-1.3, -0.4, 0.02), 'o');
oJuice14 = JuiceBox(transl(-1.3, -0.6, 0.02), 'o');
oJuice15 = JuiceBox(transl(-1.3, -0.8, 0.02), 'o');
oJuice16 = JuiceBox(transl(-1.3, -1, 0.02), 'o');
oJuice17 = JuiceBox(transl(-1.3, -1.2, 0.02), 'o');
oJuice18 = JuiceBox(transl(-1.3, -1.4, 0.02), 'o');
oJuice19 = JuiceBox(transl(-1.3, -1.6, 0.02), 'o');
oJuice20 = JuiceBox(transl(-1.3, -1.8, 0.02), 'o');
oJuice21 = JuiceBox(transl(-1.3, -2, 0.02), 'o');
oJuice22 = JuiceBox(transl(-1.3, -2.2, 0.02), 'o');
oJuice23 = JuiceBox(transl(-1.3, -2.4, 0.02), 'o');
oJuice24 = JuiceBox(transl(-1.3, -2.6, 0.02), 'o');
oJuice25 = JuiceBox(transl(-1.3, -2.8, 0.02), 'o');
oJuice26 = JuiceBox(transl(-1.3, -3, 0.02), 'o');
oJuice27 = JuiceBox(transl(-1.3, -3.2, 0.02), 'o');
oJuice28 = JuiceBox(transl(-1.3, -3.4, 0.02), 'o');
oJuice29 = JuiceBox(transl(-1.3, -3.6, 0.02), 'o');

% Insert Blackcurrent Juice
bJuice1 = JuiceBox(transl(-2.0, 2, 0.02), 'b');
bJuice2 = JuiceBox(transl(-2.0, 1.8, 0.02), 'b');
bJuice3 = JuiceBox(transl(-2.0, 1.6, 0.02), 'b');
bJuice4 = JuiceBox(transl(-2.0, 1.4, 0.02), 'b');
bJuice5 = JuiceBox(transl(-2.0, 1.2, 0.02), 'b');
bJuice6 = JuiceBox(transl(-2.0, 1.0, 0.02), 'b');
bJuice7 = JuiceBox(transl(-2.0, 0.8, 0.02), 'b');
bJuice8 = JuiceBox(transl(-2.0, 0.6, 0.02), 'b');
bJuice9 = JuiceBox(transl(-2.0, 0.4, 0.02), 'b');
bJuice10 = JuiceBox(transl(-2.0, 0.2, 0.02), 'b');
bJuice11 = JuiceBox(transl(-2.0, 0, 0.02), 'b');
bJuice12 = JuiceBox(transl(-2.0, -0.2, 0.02), 'b');
bJuice13 = JuiceBox(transl(-2.0, -0.4, 0.02), 'b');
bJuice14 = JuiceBox(transl(-2.0, -0.6, 0.02), 'b');
bJuice15 = JuiceBox(transl(-2.0, -0.8, 0.02), 'b');
bJuice16 = JuiceBox(transl(-2.0, -1, 0.02), 'b');
bJuice17 = JuiceBox(transl(-2.0, -1.2, 0.02), 'b');
bJuice18 = JuiceBox(transl(-2.0, -1.4, 0.02), 'b');
bJuice19 = JuiceBox(transl(-2.0, -1.6, 0.02), 'b');
bJuice20 = JuiceBox(transl(-2.0, -1.8, 0.02), 'b');
bJuice21 = JuiceBox(transl(-2.0, -2, 0.02), 'b');
bJuice22 = JuiceBox(transl(-2.0, -2.2, 0.02), 'b');
bJuice23 = JuiceBox(transl(-2.0, -2.4, 0.02), 'b');
bJuice24 = JuiceBox(transl(-2.0, -2.6, 0.02), 'b');
bJuice25 = JuiceBox(transl(-2.0, -2.8, 0.02), 'b');
bJuice26 = JuiceBox(transl(-2.0, -3, 0.02), 'b');
bJuice27 = JuiceBox(transl(-2.0, -3.2, 0.02), 'b');
bJuice28 = JuiceBox(transl(-2.0, -3.4, 0.02), 'b');
bJuice29 = JuiceBox(transl(-2.0, -3.6, 0.02), 'b');

% Insert Cutlery
cutlery1 = Cutlery(transl(-1.65, 2.4, 0.02));
cutlery2 = Cutlery(transl(-1.65, 2.1, 0.02));
cutlery3 = Cutlery(transl(-1.65, 1.8, 0.02));
cutlery4 = Cutlery(transl(-1.65, 1.5, 0.02));
cutlery5 = Cutlery(transl(-1.65, 1.2, 0.02));
cutlery6 = Cutlery(transl(-1.65, 0.9, 0.02));
cutlery7 = Cutlery(transl(-1.65, 0.6, 0.02));
cutlery8 = Cutlery(transl(-1.65, 0.6, 0.02));
cutlery9 = Cutlery(transl(-1.65, 0.3, 0.02));
cutlery10 = Cutlery(transl(-1.65, 0, 0.02));
cutlery11 = Cutlery(transl(-1.65, -0.3, 0.02));
cutlery12 = Cutlery(transl(-1.65, -0.6, 0.02));
cutlery13 = Cutlery(transl(-1.65, -0.9, 0.02));
cutlery14 = Cutlery(transl(-1.65, -1.2, 0.02));
cutlery15 = Cutlery(transl(-1.65, -1.5, 0.02));
cutlery16 = Cutlery(transl(-1.65, -1.8, 0.02));
cutlery17 = Cutlery(transl(-1.65, -2.1, 0.02));
cutlery18 = Cutlery(transl(-1.65, -2.4, 0.02));
cutlery19 = Cutlery(transl(-1.65, -2.7, 0.02));
cutlery20 = Cutlery(transl(-1.65, -3.0, 0.02));
cutlery21 = Cutlery(transl(-1.65, -3.3, 0.02));
cutlery22 = Cutlery(transl(-1.65, -3.5, 0.02));

% Insert Veg Meal
vMeal1= MealBox(transl(1.3, 2.3, 0.02), 'v');
vMeal2= MealBox(transl(1.3, 2.1, 0.02), 'v');
vMeal3= MealBox(transl(1.3, 1.9, 0.02), 'v');
vMeal4= MealBox(transl(1.3, 1.7, 0.02), 'v');
vMeal5= MealBox(transl(1.3, 1.5, 0.02), 'v');
vMeal6= MealBox(transl(1.3, 1.3, 0.02), 'v');
vMeal7= MealBox(transl(1.3, 1.1, 0.02), 'v');
vMeal8= MealBox(transl(1.3, 0.9, 0.02), 'v');
vMeal9= MealBox(transl(1.3, 0.7, 0.02), 'v');
vMeal10= MealBox(transl(1.3, 0.5, 0.02), 'v');
vMeal11= MealBox(transl(1.3, 0.3, 0.02), 'v');
vMeal12= MealBox(transl(1.3, 0.1, 0.02), 'v');
vMeal13= MealBox(transl(1.3, -0.1, 0.02), 'v');
vMeal14= MealBox(transl(1.3, -0.3, 0.02), 'v');
vMeal15= MealBox(transl(1.3, -0.5, 0.02), 'v');
vMeal16= MealBox(transl(1.3, -0.7, 0.02), 'v');
vMeal17= MealBox(transl(1.3, -0.9, 0.02), 'v');
vMeal18= MealBox(transl(1.3, -1.1, 0.02), 'v');
vMeal19= MealBox(transl(1.3, -1.3, 0.02), 'v');
vMeal20= MealBox(transl(1.3, -1.5, 0.02), 'v');
vMeal21= MealBox(transl(1.3, -1.7, 0.02), 'v');
vMeal22= MealBox(transl(1.3, -1.9, 0.02), 'v');
vMeal23= MealBox(transl(1.3, -2.1, 0.02), 'v');
vMeal24= MealBox(transl(1.3, -2.3, 0.02), 'v');
vMeal25= MealBox(transl(1.3, -2.5, 0.02), 'v');
vMeal26= MealBox(transl(1.3, -2.7, 0.02), 'v');
vMeal27= MealBox(transl(1.3, -2.9, 0.02), 'v');
vMeal28= MealBox(transl(1.3, -3.1, 0.02), 'v');
vMeal29= MealBox(transl(1.3, -3.3, 0.02), 'v');

% Insert Meat Meal
mMeal1= MealBox(transl(1.6, 2.3, 0.02), 'm');
mMeal2= MealBox(transl(1.6, 2.1, 0.02), 'm');
mMeal3= MealBox(transl(1.6, 1.9, 0.02), 'm');
mMeal4= MealBox(transl(1.6, 1.7, 0.02), 'm');
mMeal5= MealBox(transl(1.6, 1.5, 0.02), 'm');
mMeal6= MealBox(transl(1.6, 1.3, 0.02), 'm');
mMeal7= MealBox(transl(1.6, 1.1, 0.02), 'm');
mMeal8= MealBox(transl(1.6, 0.9, 0.02), 'm');
mMeal9= MealBox(transl(1.6, 0.7, 0.02), 'm');
mMeal10= MealBox(transl(1.6, 0.5, 0.02), 'm');
mMeal11= MealBox(transl(1.6, 0.3, 0.02), 'm');
mMeal12= MealBox(transl(1.6, 0.1, 0.02), 'm');
mMeal13= MealBox(transl(1.6, -0.1, 0.02), 'm');
mMeal14= MealBox(transl(1.6, -0.3, 0.02), 'm');
mMeal15= MealBox(transl(1.6, -0.5, 0.02), 'm');
mMeal16= MealBox(transl(1.6, -0.7, 0.02), 'm');
mMeal17= MealBox(transl(1.6, -0.9, 0.02), 'm');
mMeal18= MealBox(transl(1.6, -1.1, 0.02), 'm');
mMeal19= MealBox(transl(1.6, -1.3, 0.02), 'm');
mMeal20= MealBox(transl(1.6, -1.5, 0.02), 'm');
mMeal21= MealBox(transl(1.6, -1.7, 0.02), 'm');
mMeal22= MealBox(transl(1.6, -1.9, 0.02), 'm');
mMeal23= MealBox(transl(1.6, -2.1, 0.02), 'm');
mMeal24= MealBox(transl(1.6, -2.3, 0.02), 'm');
mMeal25= MealBox(transl(1.6, -2.5, 0.02), 'm');
mMeal26= MealBox(transl(1.6, -2.7, 0.02), 'm');
mMeal27= MealBox(transl(1.6, -2.9, 0.02), 'm');
mMeal28= MealBox(transl(1.6, -3.1, 0.02), 'm');
mMeal29= MealBox(transl(1.6, -3.3, 0.02), 'm');

% OffloadBay
%package1 = FullStockTray(transl(-4.6,4,-0.3));
%package2 = FullStockTray(transl(-3.6,4,-0.3));
%package3 = FullStockTray(transl(-2.6,4,-0.3));
%package4 = FullStockTray(transl(-1.6,4,-0.3));

% Meal Prep Zone

%% Idea
% Make a list of objects to be pushed vs not
% Cell
% Pass the cell into conveyor belt class
% 