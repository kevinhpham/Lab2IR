                                                

%worker.plotWorkspace();
axis equal
%axis([-5, -0.5, -5, -3, -0.88, 3]) %Uncomment this for video 
%axis equal
axis([0, 5, -5, 5, -0.88, 3]) %Uncomment this for video 

% Accessories
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

offloadBayM = OffloadBay(transl(0.9,4,-0.88));

safetyTable3 = MealRobotTable(transl(3,0.5,0));
eStop2 = Estop(transl(3,0.5,0.2));

safetyTable4 = MealRobotTable(transl(4,0.5,0));
fireExtinguisher4 = FireExtinguisher(transl(4,0.5,0));

firstAidMeal = FirstAidKit(transl(5,3.5,0));

chef4 = ChefPerson(transl(1.1, 2.8,-0.2));
chef5 = ChefPerson(transl(1.8, 2.8,-0.2));

packageBoxM1 = StockBox(transl(1.1,4,-0.88));
packageBoxM2 = StockBox(transl(3.1,4,-0.88));

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

%Tray Divider
barrierTray1 = GlassBarrier(transl(2.75,-3.2,-0.9));
barrierTray2 = GlassBarrier(transl(0,0,0));
barrierTray2.move((transl(3.7,-2.25,-0.9))*(rpy2tr(0,0,pi/2)));
barrierTray3 = GlassBarrier(transl(0,0,0));
barrierTray3.move((transl(3.7,-2.0,-0.9))*(rpy2tr(0,0,pi/2)));

barrierLeft1 = GlassBarrier(transl(-4,-1,-0.9));
barrierLeft2 = GlassBarrier(transl(-3.15,-1,-0.9));
barrierRight1 = GlassBarrier(transl(4,-1,-0.9));
barrierRight2 = GlassBarrier(transl(2.75,-1,-0.9));
barrierCenter1 = GlassBarrier(transl(-0.15,-1,-0.9));
barrierCenter2 = GlassBarrier(transl(0.15,-1,-0.9));

%Tray Storage
trayStorage = TrayStorage(transl(0,0,0));
trayStorage.move((transl(1.95,-3.6,0))*(rpy2tr(0,0,pi/2)));
trayStorage2 = TrayStorage(transl(0,0,0));
trayStorage2.move((transl(3.85,-2.6,0))*(rpy2tr(0,0,pi/2)));
trayStorage3 = TrayStorage(transl(0,0,0));
trayStorage3.move((transl(3.85,-1.6,0))*(rpy2tr(0,0,pi/2)));

% End of Accessories
