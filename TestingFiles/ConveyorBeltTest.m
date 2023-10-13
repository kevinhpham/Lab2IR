clear
close
%%Creates a conveyer belt which pushes items around
convey = LoadConveyor(transl(2,0,0)*rpy2tr(0,0,pi/4));
convey.speed = 0.5; %change this value to speed or slow down conveyor
camlight
axis equal
itemCount = 10; %change number of items to spawn
for j = 1:itemCount
    %Creates a cell of items on conveyor to push
    if mod(j,2)
        items{j} = MealBox(convey.base*transl(0,0.2,0.87)*rpy2tr(0,0,pi/3),'m');
    else
        items{j} = Tray(convey.base*transl(0,0.2,0.87)*rpy2tr(0,0,pi/3));
    end

    for i = 1:50
        convey.push(items)
        %pause(0.05)
    end
end
disp("All done")