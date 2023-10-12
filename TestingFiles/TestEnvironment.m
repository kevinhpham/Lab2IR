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

% Import the Conveyor
conveyor = Conveyor2(transl(0,-3.5,0));

% Offload bay for putting out stock - fresh cooked meals or juice/ cutlery
offloadBay = OffloadBay(transl(-5,1,-0.88));

% LHS Offload Bay
stockTray1 = FullStockTray(transl(-5,1,-0.32));
stockTray2 = FullStockTray(transl(-4,1,-0.32));
emptyTray1 = StockTray(transl(-2,1.1,0));
emptyTray2 = StockTray(transl(-1,1.1,0));
stockBox1 = StockBox(transl(-4.7,-4.8,-0.88));
stockBox1.move((transl(-4,-4.8,-0.88))*(rpy2tr(0,0,pi/2)));

% RHS Offload Bay
emptyTray3 = StockTray(transl(0,1.1,0));
stockTray4 = FullStockTray(transl(2,1,-0.32));
stockTray5 = FullStockTray(transl(3,1,-0.32));
stockTray6 = FullStockTray(transl(4,1,-0.32));

% Robot 1 
robotTable1 = RobotTable(transl(-2.9,-3,-0.88));
loadConveyor1 = LoadConveyor(transl(-1.8,-2.5,-0.88));
loadConveyor1.move((transl(-2.1,-2,-0.88))*(rpy2tr(0,0,pi/2)));

%tray = Item('MT.ply', transl(0,0,0));
%tray.move((transl(0,0,300))*(rpy2tr(30,10,5)));

% Robot 2
robotTable2 = RobotTable(transl(0.8,-3,-0.88));
loadConveyor2 = LoadConveyor(transl(0.5,-2.5,-0.88));
loadConveyor2.move((transl(1.6,-2,-0.88))*(rpy2tr(0,0,pi/2)));

% Tray Holder
trayStorage = TrayStorage(transl(0.5,-3.5,-0.88));
trayStorage.move((transl(0,0,300))*(rpy2tr(30,10,5)));

%% Food Items to be Places
%meal1 = PlaceObject('MealBoxVego.PLY',[-2,-2,0]);
%meal2 = PlaceObject('MealBoxMeat.PLY',[-1,-2.4,0]);

%juice1 = PlaceObject('JuiceBoxBlackcurrent.PLY',[2,-2,0]);
%juice5 = PlaceObject('JuiceBoxOrange.PLY',[1,-2.2,0]);

%cutlery1 = PlaceObject('Cutlery.PLY',[3,-2,0]);
%cutlery2 = PlaceObject('Cutlery.PLY',[3,-2.3,0]);

%% Non food Items to be places
%stockBox1 = StockBox(transl(-4.7,-4.8,-0.88));
%stockTray1 = FullStockTray(transl(-1.2,-5,-0.32));
%emptyStockTray1 = StockTray(transl(-3.6,-4.8,0));

