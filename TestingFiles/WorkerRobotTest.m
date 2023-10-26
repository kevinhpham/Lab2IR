clc
close
clear
hold on
camlight

 mealConveyor(1) = ConveyorD(transl(1.3,-0.4,0)*rpy2tr(0,0,-pi/2));
 mealConveyor(2) = ConveyorD(transl(1.6,-0.4,0)*rpy2tr(0,0,-pi/2));
 e05Table = MealRobotTable(transl(1.45,-3.6,0));
 worker = E05_worker(e05Table.base*transl(0,0,e05Table.hitBox(2,3))*rpy2tr(0,0,pi/2));
 trayStorage = TrayStorage(transl(1.95,-3.6,0)*rpy2tr(0,0,pi/2));
 trayConveyor = Conveyor2(transl(0,-4,0)*rpy2tr(0,0,0));

 steps = 20;
 mealConveyor(1).setPushDistance(0.03*30/steps)
 trayConveyor.setPushDistance(-0.050*30/steps)                             
 trays = num2cell(trayStorage.addTrays(6));
 pushables = {};
 pushables = horzcat(pushables,trays); %Fill rack up with trays
                                                 

%worker.plotWorkspace();
axis equal
%axis([-5, -0.5, -5, -3, -0.88, 3]) %Uncomment this for video 
for i = 1:length(trays)
    %Create joint planning path to move arm to tray
    meals{i} = MealBox(mealConveyor(1).base)    %create meals on conveyors
    q0 = worker.robot.model.getpos();
    qPath = worker.planPickupPath(trays{i},q0,steps);
    worker.animateGripper(1);                               %Close the gripper
    for step = 1:length(qPath)                              %Animate arm moving step by step
        worker.animateArm(qPath(step,:))
        mealConveyor(1).push(meals{i})
        pause(0)
    end
    %Plans Deposit path
     q0 = worker.robot.model.getpos();
     qPath = worker.planDepositPath(trays{i},trayConveyor,q0,steps);  %Plan path to move tray to the conveyor belt
     for step = 1:length(qPath)
         worker.animateArm(qPath(step,:),trays{i})              %Animate arm moving with tray
         pause(0)
     end

 q0 = worker.robot.model.getpos();
 qPath = worker.planRetract(q0,1,steps);
 for step = 1:length(qPath)
     worker.animateArm(qPath(step,:))
     pause(0)
 end

% %Create path planning path for mealbox
 q0 = worker.robot.model.getpos();
 qPath = worker.planPickupPath(meals{i},q0,steps);
 for step = 1:length(qPath)
     worker.animateArm(qPath(step,:))
     pause(0.0)
 end

%Plans Deposit path
q0 = worker.robot.model.getpos();
qPath = worker.planDepositPath(meals{i},trays{i},q0,steps);  %Plan path to move tray to the Conveyor belt
 for step = 1:length(qPath)
     worker.animateArm(qPath(step,:),meals{i})              %Animate arm moving with tray
     pause(0)
 end

 q0 = worker.robot.model.getpos();
 qPath = worker.planRetract(q0,1,steps);
 for step = 1:length(qPath)
     worker.animateArm(qPath(step,:))
     pause(0)
 end

pushables{end+1} = meals{i};
 for step = 1:70
     trayConveyor.push(pushables)
        pause(0.0)
 end
end
 worker.robot.model.teach(worker.robot.model.getpos())

