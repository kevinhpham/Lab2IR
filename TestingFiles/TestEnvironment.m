%% Setting the Environment
clf

camlight

axis equal;

hold on 

%table = PlaceObject('tableBrown2.1x1.4x0.5m.ply',[-0.5, -0.2,-0.5]);

% for Reference 

% Importing the floor
surf([-5,-5;5,5] ...
      ,[-5,5;-5,5] ...
      ,[-0.88,-0.88;-0.88,-0.88] ...
      ,'CData',imread('Floor.jpg') ...
      ,'FaceColor','texturemap');

% Setting the axis and view to isometric
axis([-5, 5, -5, 5, -0.88, 3])
view(3)

% Setting up the robot workspace
conveyor = Conveyor2(transl(0,0,0));

% Offload bay for putting out stock - fresh cooked meals or juice/ cutlery
offloadBay = OffloadBay(transl(-5,-5,-0.88));
stockBox1 = StockBox(transl(-4.7,-4.8,-0.88));
stockBox2 = StockBox(transl(-2.8,-4.8,-0.88));
stockBox3 = StockBox(transl(1.2,-4.8,-0.88));
stockBox4 = StockBox(transl(3.2,-4.8,-0.88));

% Meal Robot (To make more accurate models)
stockTray1 = FullStockTray(transl(-1.2,-5,-0.32));
stockTray2 = FullStockTray(transl(-2.0,-5,-0.32));
stockTray3 = FullStockTray(transl(-2.8,-5,-0.32));
emptyStockTray1 = StockTray(transl(-3.6,-4.8,0));
emptyStockTray2 = StockTray(transl(-4.4,-4.8,0));

% Juice/Cutlery Robot (To make more accurate models)
stockTray4 = FullStockTray(transl(1.2,-5,-0.32));
stockTray5 = FullStockTray(transl(2.0,-5,-0.32));
stockTray6 = FullStockTray(transl(2.8,-5,-0.32));
emptyStockTray3 = StockTray(transl(3.6,-4.8,0));
emptyStockTray4 = StockTray(transl(4.4,-4.8,0));

% For Tray/ Meal Robot
robotTable1 = RobotTable(transl(-2.7,-1.5,-0.88));
loadConveyor1 = LoadConveyor(transl(-3.6,-2.5,-0.88));

% For Juice/Cutlery Robot
robotTable2 = RobotTable(transl(0.5,-1.5,-0.88));
loadConveyor2 = LoadConveyor(transl(0.5,-2.5,-0.88));

%Items to be placed by robot
tray1 = Tray(transl(-2.6,-0.2,0));
tray2 = Tray(transl(-1.6,-0.2,0));
tray3 = Tray(transl(-0.6,-0.2,0));
tray4 = Tray(transl(0.4,-0.2,0));
tray5 = Tray(transl(1.4,-0.2,0));
tray6 = Tray(transl(2.4,-0.2,0));

%meal1 = PlaceObject('MealBoxVego.PLY',[-2,-2,0]);
%meal2 = PlaceObject('MealBoxVego.PLY',[-2,-2.2,0]);
%meal3 = PlaceObject('MealBoxVego.PLY',[-2,-2.4,0]);
%meal4 = PlaceObject('MealBoxVego.PLY',[-1,-2,0]);
%meal5 = PlaceObject('MealBoxVego.PLY',[-1,-2.2,0]);
%meal6 = PlaceObject('MealBoxMeat.PLY',[-1,-2.4,0]);
%meal7 = PlaceObject('MealBoxMeat.PLY',[-3,-2,0]);
%meal8 = PlaceObject('MealBoxMeat.PLY',[-3,-2.2,0]);
%meal9 = PlaceObject('MealBoxMeat.PLY',[-3,-2.4,0]);

%juice1 = PlaceObject('JuiceBoxBlackcurrent.PLY',[2,-2,0]);
%juice2 = PlaceObject('JuiceBoxBlackcurrent.PLY',[2,-2.2,0]);
%juice3 = PlaceObject('JuiceBoxBlackcurrent.PLY',[2,-2.4,0]);
%juice4 = PlaceObject('JuiceBoxOrange.PLY',[1,-2,0]);
%juice5 = PlaceObject('JuiceBoxOrange.PLY',[1,-2.2,0]);
%juice6 = PlaceObject('JuiceBoxOrange.PLY',[1,-2.4,0]);
%cutlery1 = PlaceObject('Cutlery.PLY',[3,-2,0]);
%cutlery2 = PlaceObject('Cutlery.PLY',[3,-2.3,0]);

% Holds the trays
trayStorage = PlaceObject('TrayStorage.PLY',[0.5,-3.5,-0.88]);
verts = [get(trayStorage,'Vertices'), ones(size(get(trayStorage,'Vertices'),1),1)] * trotz(pi/2);
set(trayStorage,'Vertices',verts(:,1:3))

