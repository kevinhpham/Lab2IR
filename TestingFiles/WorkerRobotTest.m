close
hold on
axis equal
worker = E05_worker(transl(0,0,-1));
rack = TrayStorage(transl(-0,0.7,-1)*rpy2tr(0,0,0));
convey = ConveyorD(transl(0,-0.7,-0.9)*rpy2tr(0,0,0))
trays = rack.addTrays(8);
target = trays(1)
%worker.plotWorkspace(); %Turn on to see workspace of robot
steps = 60;
% %Create joint planning path to move arm to tray
qPath = worker.planPickupPath(target,steps);
worker.animateGripper(1); %Close the gripper
for step = 1:length(qPath) %Animate arm moving step by step
    worker.animateArm(qPath(step,:))
    pause(0.02)
end

 qPath = worker.planDepositPath(target,convey,steps);
 for step = 1:length(qPath) %Animate arm moving step by step
     worker.animateArm(qPath(step,:),target)
     pause(0.01)
end

%Create path planning path for mealbox
meal = MealBox(transl(0.3,-0.6,-0.7)*rpy2tr(0,0,pi/6));
qPath = worker.planPickupPath(meal,steps);
for step = 1:length(qPath)
    worker.animateArm(qPath(step,:))
    convey.push(trays)
    pause(0.02)
end

worker.robot.model.teach(worker.robot.model.getpos())

