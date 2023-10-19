close
hold on
axis equal
worker = E05_worker(transl(0,0,-1));
rack = TrayStorage(transl(-0,0.7,-1));
trays = rack.addTrays(8);
%worker.plotWorkspace(); %Turn on to see workspace of robot
steps = 60;
qPath = worker.planPickupPath(trays(1),steps);
worker.animateGripper(1);
for step = 1:length(qPath)
    worker.animateArm(qPath(step,:))
    pause(0.02)
end
worker.robot.model.teach(worker.robot.model.getpos())

