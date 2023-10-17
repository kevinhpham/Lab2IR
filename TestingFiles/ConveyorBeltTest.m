clear
close
%%Creates a conveyer belt which pushes items around
convey(1) = LoadConveyor(transl(0,0,0)*rpy2tr(0,0,0));
convey(2) = LoadConveyor(convey(1).base*transl(3,0,0)*rpy2tr(0,0,pi/2));
convey(3) = LoadConveyor(convey(2).base*transl(3,0,0)*rpy2tr(0,0,pi/2));
convey(4) = LoadConveyor(convey(3).base*transl(3,0,0)*rpy2tr(0,0,pi/2));
for i = 1:length(convey)
    convey(i).speed = 0.5
end
camlight
axis equal
itemCount = 10; %change number of items to spawn
for j = 1:itemCount
    %Creates a cell of items on conveyor to push
    if mod(j,2)
        items{j} = MealBox(convey(1).base*transl(0.2,0.2,0.87));
    else
        items{j} = Tray(convey(1).base*transl(0.2,0.2,0.87));
    end

    for i = 1:50
        convey(1).push(items)
        convey(2).push(items)
        convey(3).push(items)
        convey(4).push(items)
        pause(0.02)
    end
end
disp("All done")