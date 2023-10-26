%% This script can be used to create visuals for the promotional video

%% Create a meal tray
clf

% Setting up the workspace
camlight
axis equal;
axis([-0.2, 0.2, -0.15, 0.15, 0, 0.2])
view(3)

% Importing tray and components
tray = Tray(transl(0,0,0));
oJuice = JuiceBox(transl(0.1,0.05,0), 'b');
vMeal = MealBox(transl(-0.09,-0.05,0), 'm');
cutlery = Cutlery(transl(0.03,0,0));

%% Make a tray storage

clf
camlight
axis equal 
view(3)

trayStorage = TrayStorage(transl(0,0,0));

%% Test tray making class

clf
camlight
axis equal;
view(3)

Veggie = VegTray(transl(0,0,0));

%% Create a conveyor with meal trays

clf
camlight
axis equal;
hold on 

axis([-5, 5, -1, 1, -0.88, 3])
view(3)

% Import the floor/ wallpapers
surf([-5,-5;5,5] ...
      ,[-5,5;-5,5] ...
      ,[-0.88,-0.88;-0.88,-0.88] ...
      ,'CData',imread('Floor.jpg') ...
      ,'FaceColor','texturemap');

surf([-5,5;-5,5] ...
      ,[1,1;1,1] ...
      ,[3,3;-0.88,-0.88] ...
      ,'CData',imread('WallPaperWords.jpg') ...
      ,'FaceColor','texturemap');

surf([5,5;5,5] ...
      ,[5,-5;5,-5] ...
      ,[3,3;-0.88,-0.88] ...
      ,'CData',imread('WallPaper.jpg') ...
      ,'FaceColor','texturemap');

chef1 = ChefPerson(transl(3.5,0.6,-0.3));
chef2 = ChefPerson(transl(2,0.6,-0.3));
chef3 = ChefPerson(transl(0.5,0.6,-0.3));
chef4 = ChefPerson(transl(-1,0.6,-0.3));
chef5 = ChefPerson(transl(-2.5,0.6,-0.3));
chef6 = ChefPerson(transl(-4,0.6,-0.3));

conveyor = Conveyor2(transl(0,0,0));

tray1 = Tray(transl(0,0,0));
tray1.move((transl(4,0,0.02))*(rpy2tr(0,0,pi/2)));

tray2 = Tray(transl(0,0,0));
tray2.move((transl(3,0,0.02))*(rpy2tr(0,0,pi/2)));
meal3 = MealBox(transl(0,0,0), 'v');
meal3.move((transl(3.05,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray3 = Tray(transl(0,0,0));
tray3.move((transl(2,0,0.02))*(rpy2tr(0,0,pi/2)));
meal3 = MealBox(transl(0,0,0), 'v');
meal3.move((transl(2.05,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray4 = Tray(transl(0,0,0));
tray4.move((transl(1,0,0.02))*(rpy2tr(0,0,pi/2)));
meal4 = MealBox(transl(0,0,0), 'v');
meal4.move((transl(1.05,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray5 = Tray(transl(0,0,0));
tray5.move((transl(0,0,0.02))*(rpy2tr(0,0,pi/2)));
meal5 = MealBox(transl(0,0,0), 'm');
meal5.move((transl(0.05,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray6 = Tray(transl(0,0,0));
tray6.move((transl(-1,0,0.02))*(rpy2tr(0,0,pi/2)));
juice6 = JuiceBox(transl(-1,0,0.02), 'a');
juice6.move((transl(-0.96,-0.09,0.02))*(rpy2tr(0,0,pi/2)));
meal6 = MealBox(transl(0,0,0), 'v');
meal6.move((transl(-0.94,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray7 = Tray(transl(0,0,0));
tray7.move((transl(-2,0,0.02))*(rpy2tr(0,0,pi/2)));
juice7 = JuiceBox(transl(-2,0,0.02), 'o');
juice7.move((transl(-1.96,-0.09,0.02))*(rpy2tr(0,0,pi/2)));
meal7 = MealBox(transl(0,0,0), 'm');
meal7.move((transl(-1.94,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray8 = Tray(transl(0,0,0));
tray8.move((transl(-3,0,0.02))*(rpy2tr(0,0,pi/2)));
juice8 = JuiceBox(transl(-3,0,0.02), 'a');
juice8.move((transl(-2.96,-0.09,0.02))*(rpy2tr(0,0,pi/2)));
cutlery8 = Cutlery(transl(-3.05,0,0.03));
meal8 = MealBox(transl(0,0,0), 'm');
meal8.move((transl(-2.94,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray9 = Tray(transl(0,0,0));
tray9.move((transl(-4,0,0.02))*(rpy2tr(0,0,pi/2)));
juice9 = JuiceBox(transl(-4,0,0.02), 'o');
juice9.move((transl(-3.96,-0.09,0.02))*(rpy2tr(0,0,pi/2)));
cutlery9 = Cutlery(transl(-4.05,0,0.03));
meal9 = MealBox(transl(0,0,0), 'v');
meal9.move((transl(-3.94,0.03,0.03))*(rpy2tr(0,0,pi/2)));


%% Zoomed in Conveyor

clf
camlight
axis equal;
hold on 

axis([-5, -0.5, -1, 1, -0.88, 3])
view(3)

% Import the floor/ wallpapers
surf([-5,-5;5,5] ...
      ,[-5,5;-5,5] ...
      ,[-0.88,-0.88;-0.88,-0.88] ...
      ,'CData',imread('Floor.jpg') ...
      ,'FaceColor','texturemap');

surf([-5,5;-5,5] ...
      ,[1,1;1,1] ...
      ,[3,3;-0.88,-0.88] ...
      ,'CData',imread('WallPaperWords.jpg') ...
      ,'FaceColor','texturemap');

surf([-0.5,-0.5;-0.5,-0.5] ...
      ,[5,-5;5,-5] ...
      ,[3,3;-0.88,-0.88] ...
      ,'CData',imread('WallPaper.jpg') ...
      ,'FaceColor','texturemap');

chef1 = ChefPerson(transl(3.5,0.6,-0.3));
chef2 = ChefPerson(transl(2,0.6,-0.3));
chef3 = ChefPerson(transl(0.5,0.6,-0.3));
chef4 = ChefPerson(transl(-1,0.6,-0.3));
chef5 = ChefPerson(transl(-2.5,0.6,-0.3));
chef6 = ChefPerson(transl(-4,0.6,-0.3));

conveyor = Conveyor2(transl(0,0,0));

tray1 = Tray(transl(0,0,0));
tray1.move((transl(4,0,0.02))*(rpy2tr(0,0,pi/2)));

tray2 = Tray(transl(0,0,0));
tray2.move((transl(3,0,0.02))*(rpy2tr(0,0,pi/2)));
meal3 = MealBox(transl(0,0,0), 'v');
meal3.move((transl(3.05,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray3 = Tray(transl(0,0,0));
tray3.move((transl(2,0,0.02))*(rpy2tr(0,0,pi/2)));
meal3 = MealBox(transl(0,0,0), 'v');
meal3.move((transl(2.05,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray4 = Tray(transl(0,0,0));
tray4.move((transl(1,0,0.02))*(rpy2tr(0,0,pi/2)));
meal4 = MealBox(transl(0,0,0), 'v');
meal4.move((transl(1.05,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray5 = Tray(transl(0,0,0));
tray5.move((transl(0,0,0.02))*(rpy2tr(0,0,pi/2)));
meal5 = MealBox(transl(0,0,0), 'm');
meal5.move((transl(0.05,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray6 = Tray(transl(0,0,0));
tray6.move((transl(-1,0,0.02))*(rpy2tr(0,0,pi/2)));
juice6 = JuiceBox(transl(-1,0,0.02), 'a');
juice6.move((transl(-0.96,-0.09,0.02))*(rpy2tr(0,0,pi/2)));
meal6 = MealBox(transl(0,0,0), 'v');
meal6.move((transl(-0.94,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray7 = Tray(transl(0,0,0));
tray7.move((transl(-2,0,0.02))*(rpy2tr(0,0,pi/2)));
juice7 = JuiceBox(transl(-2,0,0.02), 'o');
juice7.move((transl(-1.96,-0.09,0.02))*(rpy2tr(0,0,pi/2)));
meal7 = MealBox(transl(0,0,0), 'm');
meal7.move((transl(-1.94,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray8 = Tray(transl(0,0,0));
tray8.move((transl(-3,0,0.02))*(rpy2tr(0,0,pi/2)));
juice8 = JuiceBox(transl(-3,0,0.02), 'a');
juice8.move((transl(-2.96,-0.09,0.02))*(rpy2tr(0,0,pi/2)));
cutlery8 = Cutlery(transl(-3.05,0,0.03));
meal8 = MealBox(transl(0,0,0), 'm');
meal8.move((transl(-2.94,0.03,0.03))*(rpy2tr(0,0,pi/2)));

tray9 = Tray(transl(0,0,0));
tray9.move((transl(-4,0,0.02))*(rpy2tr(0,0,pi/2)));
juice9 = JuiceBox(transl(-4,0,0.02), 'o');
juice9.move((transl(-3.96,-0.09,0.02))*(rpy2tr(0,0,pi/2)));
cutlery9 = Cutlery(transl(-4.05,0,0.03));
meal9 = MealBox(transl(0,0,0), 'v');
meal9.move((transl(-3.94,0.03,0.03))*(rpy2tr(0,0,pi/2)));

%% Juice Box Scene

clf
camlight
axis equal;
hold on 

axis([-5, 0, 3, 5, -0.88, 3])
view(3)

% Import the floor/ wallpapers
surf([-5,-5;5,5] ...
      ,[-5,5;-5,5] ...
      ,[-0.88,-0.88;-0.88,-0.88] ...
      ,'CData',imread('Floor.jpg') ...
      ,'FaceColor','texturemap');

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

% OffloadBay
package1 = FullStockTray(transl(-4.6,4,-0.3));
package2 = FullStockTray(transl(-3.6,4,-0.3));
package3 = FullStockTray(transl(-2.6,4,-0.3));
package4 = FullStockTray(transl(-1.6,4,-0.3));

% Package Boxes
packageBox1 = StockBox(transl(-3.8,4,-0.88));
packageBox2 = StockBox(transl(-1.8,4,-0.88));

%% Robotics

clf
camlight
axis equal;
hold on 

% Set the axis and view to isometric
%axis([-3, 3, -1, -5, -0.88, 3])
view(3)

% Import the floor/ wallpapers

% Dobot Setup
%dobotTable = RobotTable(transl(-1.65,-3.6,0));
%dobot = DobotMagician(dobotTable.base*transl(0,0,0));

% E05 Setup
%e05Table = MealRobotTable(transl(1.45,-3.6,0));
worker = E05_worker;