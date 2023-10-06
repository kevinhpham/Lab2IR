%% Setting the Environment
clf

camlight

axis equal;

hold on 

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
conveyor = PlaceObject('Conveyor2.0.PLY',[0,0,0]);

% Holds the trays
trayStorage = PlaceObject('TrayStorage.PLY',[0.5,-3.5,-0.88]);
verts = [get(trayStorage,'Vertices'), ones(size(get(trayStorage,'Vertices'),1),1)] * trotz(pi/2);
set(trayStorage,'Vertices',verts(:,1:3))

% Offload bay for putting out stock - fresh cooked meals or juice/ cutlery
offloadBay = PlaceObject('OffloadBay.PLY',[-5,-5,-0.88]);
stockBox1 = PlaceObject('StockBox.PLY',[-4.7,-4.8,-0.88]);
stockBox2 = PlaceObject('StockBox.PLY',[-2.8,-4.8,-0.88]);
stockBox3 = PlaceObject('StockBox.PLY',[1.2,-4.8,-0.88]);
stockBox4 = PlaceObject('StockBox.PLY',[3.2,-4.8,-0.88]);

% Meal Robot (To make more accurate models)
stockTray1 = PlaceObject('FullStockTray.PLY',[-1.2,-5,-0.32]);
stockTray2 = PlaceObject('FullStockTray.PLY',[-2.0,-5,-0.32]);
stockTray3 = PlaceObject('FullStockTray.PLY',[-2.8,-5,-0.32]);
emptyStockTray1 = PlaceObject('EmptyStockTray.PLY',[-3.6,-4.8,0]);
emptyStockTray2 = PlaceObject('EmptyStockTray.PLY',[-4.4,-4.8,0]);

% Juice/Cutlery Robot (To make more accurate models)
stockTray4 = PlaceObject('FullStockTray.PLY',[1.2,-5,-0.32]);
stockTray5 = PlaceObject('FullStockTray.PLY',[2.0,-5,-0.32]);
stockTray6 = PlaceObject('FullStockTray.PLY',[2.8,-5,-0.32]);
emptyStockTray3 = PlaceObject('EmptyStockTray.PLY',[3.6,-4.8,0]);
emptyStockTray4 = PlaceObject('EmptyStockTray.PLY',[4.4,-4.8,0]);

% For Tray/ Meal Robot
robotTable1 = PlaceObject('RobotTable.PLY',[-2.7,-1.5,-0.88]);
loadConveyor1 = PlaceObject('LoadConveyor.PLY',[-3.6,-2.5,-0.88]);

% For Juice/Cutlery Robot
robotTable2 = PlaceObject('RobotTable.PLY',[0.5,-1.5,-0.88]);
loadConveyor2 = PlaceObject('LoadConveyor.PLY',[0.5,-2.5,-0.88]);

%Items to be placed by robot
tray1 = PlaceObject('Tray.PLY',[-2.6,-0.2,0]);
tray2 = PlaceObject('Tray.PLY',[-1.6,-0.2,0]);
tray3 = PlaceObject('Tray.PLY',[-0.6,-0.2,0]);
tray4 = PlaceObject('Tray.PLY',[0.4,-0.2,0]);
tray5 = PlaceObject('Tray.PLY',[1.4,-0.2,0]);
tray6 = PlaceObject('Tray.PLY',[2.4,-0.2,0]);

meal1 = PlaceObject('MealBoxVego.PLY',[-2,-2,0]);
meal2 = PlaceObject('MealBoxVego.PLY',[-2,-2.2,0]);
meal3 = PlaceObject('MealBoxVego.PLY',[-2,-2.4,0]);
meal4 = PlaceObject('MealBoxVego.PLY',[-1,-2,0]);
meal5 = PlaceObject('MealBoxVego.PLY',[-1,-2.2,0]);
meal6 = PlaceObject('MealBoxMeat.PLY',[-1,-2.4,0]);
meal7 = PlaceObject('MealBoxMeat.PLY',[-3,-2,0]);
meal8 = PlaceObject('MealBoxMeat.PLY',[-3,-2.2,0]);
meal9 = PlaceObject('MealBoxMeat.PLY',[-3,-2.4,0]);

juice1 = PlaceObject('JuiceBoxBlackcurrent.PLY',[2,-2,0]);
juice2 = PlaceObject('JuiceBoxBlackcurrent.PLY',[2,-2.2,0]);
juice3 = PlaceObject('JuiceBoxBlackcurrent.PLY',[2,-2.4,0]);
juice4 = PlaceObject('JuiceBoxOrange.PLY',[1,-2,0]);
juice5 = PlaceObject('JuiceBoxOrange.PLY',[1,-2.2,0]);
juice6 = PlaceObject('JuiceBoxOrange.PLY',[1,-2.4,0]);
cutlery1 = PlaceObject('Cutlery.PLY',[3,-2,0]);
cutlery2 = PlaceObject('Cutlery.PLY',[3,-2.3,0]);

