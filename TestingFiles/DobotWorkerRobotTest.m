
%set up for dobot
clear
close
clc
    dobotConveyor(1) = ConveyorD(transl(-1.9,-0.8,-0.05)*rpy2tr(0,0,-pi/2));    %left conveyor
    dobotConveyor(2) = ConveyorD(transl(-1.65,-0.6,-0.05)*rpy2tr(0,0,-pi/2));   %middle
    dobotConveyor(3) = ConveyorD(transl(-1.4,-0.8,-0.05)*rpy2tr(0,0,-pi/2));    %right
    dobotTable = RobotTable(transl(-1.65,-3.7,-0.1));
    dobot = Dobot_Worker(dobotTable.base*transl(0,0,0.1));             %create dobot worker
    dobot.robot.model.teach(dobot.robot.model.getpos())
    axis equal
    
    %setup conveyor push distances
    steps = 30;
    dobotConveyor(1).setPushDistance(0.032*30/steps)
    dobotConveyor(2).setPushDistance(0.0317*30/steps)
    dobotConveyor(3).setPushDistance(0.032*30/steps)
    tray = Tray(dobot.robot.model.base.T*(transl(0,-0.3,0)*rpy2tr(0,0,-pi/2)))


for i = 1:1
    oJuiceBoxes{i} = JuiceBox(dobotConveyor(1).base,'o');    %creates orange juice boxes
    cutlery{i} = Cutlery(dobotConveyor(2).base);             %creates orange juice boxes

    for step = 1:steps*3
        dobotConveyor(1).push(oJuiceBoxes{i})
        dobotConveyor(2).push(cutlery{i})
        pause(0.02)
    end

     dobotqPath = dobot.planPickupPath(cutlery{i},steps);      %plan path for dobot to pickup cutlery
     for step = 1:length(dobotqPath)
         dobot.animateArm(dobotqPath(step,:)); 
         pause(0.02)
     end    
    
     dobotqPath = dobot.planDepositPath(cutlery{i},tray,steps);
      for step = 1:length(dobotqPath)
         dobot.animateArm(dobotqPath(step,:),cutlery{i});       %animate dobot arm
         pause(0.02)
      end
      
      q0 = dobot.GetPos();
      dobotqPath = dobot.planRetract(q0,0.1,steps/2);
      for step = 1:length(dobotqPath)
         dobot.animateArm(dobotqPath(step,:));       %animate dobot arm
         pause(0.02)
      end

      dobotqPath = dobot.planPickupPath(oJuiceBoxes{i},steps);
      for step = 1:length(dobotqPath)
         dobot.animateArm(dobotqPath(step,:));       %animate dobot arm
         pause(0.02)
      end
      
      dobotqPath = dobot.planDepositPath(oJuiceBoxes{i},tray,steps);
      for step = 1:length(dobotqPath)
         dobot.animateArm(dobotqPath(step,:),oJuiceBoxes{i});       %animate dobot arm
         pause(0.02)
      end
      
end