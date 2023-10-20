close
hold on
axis equal
worker = E05_worker(transl(0,0,-1));
rack = TrayStorage(transl(-0,0.7,-1)*rpy2tr(0,0,0));
trays = rack.addTrays(8);
%worker.plotWorkspace(); %Turn on to see workspace of robot
steps = 60;
% %Create joint planning path to move arm to tray
qPath = worker.planPickupPath(trays(1),steps);
worker.animateGripper(1); %Close the gripper
for step = 1:length(qPath) %Animate arm moving step by step
    worker.animateArm(qPath(step,:))
    pause(0.02)
end

qPath = worker.liftUp(0.5,30);
for step = 1:length(qPath) %Animate arm moving step by step
    worker.animateArm(qPath(step,:))
    pause(0.01)
end

% % %Create path planning path for mealbox
meal = MealBox(transl(0.3,-0.6,-0.7)*rpy2tr(0,0,pi/6));
qPath = worker.planPickupPath(meal,steps);
for step = 1:length(qPath)
    worker.animateArm(qPath(step,:))
    pause(0.02)
end

worker.robot.model.teach(worker.robot.model.getpos())

