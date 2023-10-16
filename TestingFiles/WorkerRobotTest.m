close
hold on
axis equal
worker = E05_worker(transl(0,0,0));
worker.robot.model.offset = [0 pi/2 -pi/3 0 0 0]
rack = TrayStorage(transl(-0.4,0.6,-1.3));
worker.plotWorkspace()
 tray = rack.addTrays(15);
 worker.pickup(tray(1))
 worker.pickup(tray(15))
worker.robot.model.teach(worker.robot.model.getpos())
