clear
close
%%Creates conveyer belts which pushes items around
convey(1) = LoadConveyor(transl(2,0,0)*rpy2tr(0,0,pi/4));
convey(2) = LoadConveyor(convey(1).base*transl(3.6,0,0)*rpy2tr(0,0,pi/2));
convey(3) = LoadConveyor(convey(2).base*transl(2.3,0.2,0)*rpy2tr(0,0,-pi/4));
convey(4) = LoadConveyor(convey(3).base*transl(3.5,0,0)*rpy2tr(0,0,pi/2));
table = RobotTable(convey(4).base*transl(3,0,0));
convey(1).speed = 0.8; %change this value to speed or slow down conveyor
camlight
axis equal
itemCount = 8; %change number of items to spawn
for j = 1:itemCount
    %Creates a cell of items on conveyor to push
    if mod(j,2)
        items{j} = MealBox(convey(1).base*transl(0,0.2,0.87)*rpy2tr(0,0,pi/3),'m');
    else
        items{j} = Tray(convey(1).base*transl(0,0.2,0.87)*rpy2tr(0,0,pi/3));
    end

    for i = 1:70
        convey(1).push(items)
        convey(2).push(items)
        convey(3).push(items)
        convey(4).push(items)
        pause(0.04)
    end
end
disp("All done")