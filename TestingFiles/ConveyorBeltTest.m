function ConveyorBeltTest()
    loadConveyor();
    %conveyorTest(Conveyor2()) %change input to any other Conveyorbelt class e.g "Conveyor2() 
end

function loadConveyor()
    camlight
    axis equal
    %%Creates conveyer belts which pushes items around
    convey(1) = LoadConveyor(transl(2,0,0)*rpy2tr(0,0,pi/4));
    convey(2) = LoadConveyor(convey(1).base*transl(3.6,0,0)*rpy2tr(0,0,pi/2));
    convey(3) = LoadConveyor(convey(2).base*transl(2.3,0.2,0)*rpy2tr(0,0,-pi/4));
    convey(4) = LoadConveyor(convey(3).base*transl(3.5,0,0)*rpy2tr(0,0,pi/2));
    convey(1).setPushDistance(0.03) %change this value to speed or slow down conveyor 1
    itemCount = 8; %change number of items to spawn
    for j = 1:itemCount
        %Creates a cell of items on conveyor to push
        if mod(j,2)
            items{j} = MealBox(convey(1).base*transl(0,0.2,0.87)*rpy2tr(0,0,pi/3),'v');
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
end

function conveyorTest(conveyorType)
%Testing for every conveyor
    camlight
    axis equal
    convey = conveyorType;
    detectionZone = convey.getDetectionZone();
    convey.setPushDistance(0.01); %push distance in meters
    itemCount = 8; %change number of items to spawn
       for j = 1:itemCount
            %Creates a cell of items on conveyor to push
            if mod(j,2)
                items{j} = MealBox(convey.base*transl(detectionZone(1,1),detectionZone(2,2)/2,detectionZone(1,3))*rpy2tr(0,0,0));
            else
                items{j} = Tray(convey.base*transl(detectionZone(1,1),detectionZone(2,2)/2,detectionZone(1,3))*rpy2tr(0,0,0));
            end
            for i = 1:50
                convey(1).push(items)
                pause(0.03)
            end
       end
end