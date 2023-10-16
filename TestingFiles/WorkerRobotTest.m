close
hold on
axis equal
worker(1) = E05_worker(transl(0,0,0));
rack(1) = TrayStorage(transl(-0.4,0.6,0));
trays1 = rack(1).addTrays(8);
worker(1).plotWorkspace()
worker(1).pickup(trays1(1))
worker(1).pickup(trays1(8))


%%Testing multi threading toolbox
%worker2 = E05_L(transl(2,0,2));
%worker2.model.plot(zeros(6))
%rack(2) = TrayStorage(transl(-0.4,0.6,1));
%trays2 = rack(2).addTrays(8);

% parfor i = 1:2
%     worker2.pickup(trays2(1))
%     worker2.pickup(trays2(8))
%     worker(1).pickup(trays1(1))
%     worker(1).pickup(trays1(8))
% end
