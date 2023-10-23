close
clear
hold on
axis equal
camlight
worker = E05_worker(transl(0,0,-1));
rack = TrayStorage(transl(-0,0.7,-1)*rpy2tr(0,0,0));
convey = ConveyorD(transl(-0.7,0,-0.6)*rpy2tr(0,0,-pi/2));
convey.setPushDistance(0.05);

pushables = {MealBox(convey.base,'v')};                         %Create cell array for all objects that will be pushed by conveyor belt
trays = num2cell(rack.addTrays(3));                         %Fill rack up with trays
pushables = horzcat(pushables,trays);                       %concatenate the trays to the end of cells array of pushables
%worker.plotWorkspace();                                    %Turn on to see workspace of robot
steps = 30;
for i = 1:length(trays)
    %Create joint planning path to move arm to tray
    q0 = worker.robot.model.getpos();
    qPath = worker.planPickupPath(trays{i},q0,steps);
    worker.animateGripper(1);                               %Close the gripper
    for step = 1:length(qPath)                              %Animate arm moving step by step
        worker.animateArm(qPath(step,:))
        convey.push(pushables)
        pause(0)
    end
    
    %Plans Deposit path
     q0 = worker.robot.model.getpos();
     qPath = worker.planDepositPath(trays{i},convey,q0,steps);  %Plan path to move tray to the conveyor belt
     for step = 1:length(qPath)
         worker.animateArm(qPath(step,:),trays{i})              %Animate arm moving with tray
         pause(0)
     end

     %Plans reset path
     q0 = worker.robot.model.getpos();
     qPath = worker.planResetPath(q0,steps);
     for step = 1:length(qPath)
         worker.animateArm(qPath(step,:))
         pause(0)
     end
end




%Create path planning path for mealbox
% meal = MealBox(transl(0.3,-0.6,-0.7)*rpy2tr(0,0,pi/6));
% qPath = worker.planPickupPath(meal,steps);
% for step = 1:length(qPath)
%     worker.animateArm(qPath(step,:))
%     convey.push(trays)
%     pause(0.02)
% end

worker.robot.model.teach(worker.robot.model.getpos())

