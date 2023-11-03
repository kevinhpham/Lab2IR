% This function will make 8 meals for the demo
% It features a populated/ complete Work Environment
% Syntax to action function I.e., : WorkerRobotDemo, MakeMeal(steps)

function WorkerRobotDemo()
hold on

clear
close
steps = 10;
MakeMeal(steps)

end

function MakeMeal(steps)
    %Import the environment
    Environment();
    axis([-5, 5, -5, 5, -0.88, 3]) % Setting axis of the workspace

    %Sets up environment for e05
     mealConveyor(1) = ConveyorD(transl(1.3,-0.4,0)*rpy2tr(0,0,-pi/2));
     mealConveyor(2) = ConveyorD(transl(1.6,-0.4,0)*rpy2tr(0,0,-pi/2));
     e05Table = MealRobotTable(transl(1.45,-3.6,0));
     trayStorage = TrayStorage(transl(1.95,-3.6,0)*rpy2tr(0,0,pi/2));
     trayConveyor = Conveyor2(transl(0,-4,0)*rpy2tr(0,0,0));
     worker = E05_worker(e05Table.base*transl(0,0,e05Table.corners(2,3))*rpy2tr(0,0,pi/2)); %create E05 worker
     worker.AnimateGripper(1);                               %Close the gripper
    
     %set up for dobot
    dobotConveyor(1) = ConveyorD(transl(-1.9,-0.8,-0.05)*rpy2tr(0,0,-pi/2));    %left conveyor
    dobotConveyor(2) = ConveyorD(transl(-1.65,-0.6,-0.05)*rpy2tr(0,0,-pi/2));   %middle
    dobotConveyor(3) = ConveyorD(transl(-1.4,-0.8,-0.05)*rpy2tr(0,0,-pi/2));    %right
    dobotTable = RobotTable(transl(-1.65,-3.7,-0.1));
    dobot = Dobot_Worker(dobotTable.base*transl(0,0,0.1));             %create dobot worker

    %set up conveyor belt pushing distance
     mealConveyor(1).setPushDistance(0.028*30/steps)    %distances set up to be iversely porpotional the number of steps in animation, so system will still work regardless of the number of steps of the animation
     mealConveyor(2).setPushDistance(0.028*30/steps)
     dobotConveyor(1).setPushDistance(0.032*30/steps)
     dobotConveyor(2).setPushDistance(0.0317*30/steps)
     dobotConveyor(3).setPushDistance(0.032*30/steps)
     trayConveyor.setPushDistance(-0.029*30/steps) 
    
     %Setup movable items
     trays = num2cell(trayStorage.AddTrays(8));
     pushables = {};
     pushables = horzcat(pushables,trays); %Fill rack up with trays
                                                     
    %worker.plotWorkspace();
    %axis equal
    for i = 1:length(trays)
            k= i-1; %item index that dobot will use, since dobot starts after first loop
            %Create joint planning path to pickup tray
            if mod(i,2) == 0    %alternate between types each iteration
                meals{i} = MealBox(mealConveyor(1).base,'m');    %creates orange juice boxes
            else
               meals{i} = MealBox(mealConveyor(2).base,'v');     %create black current
            end

             %start feeding dobot stock after first loop
            if mod(i,2) == 0    %alternate between juice types each iteration
                juiceBoxes{i} = JuiceBox(dobotConveyor(1).base,'o');    %creates orange juice boxes
            else
                juiceBoxes{i} = JuiceBox(dobotConveyor(3).base*rpy2tr(0,0,pi),'b');    %create black current
            end
            cutlery{i} = Cutlery(dobotConveyor(2).base);             %creates cutlery
            
            pushables{end+1} = meals{i};                             %add items to pusable so they can get pushed by main conveyor
            pushables{end+1} = juiceBoxes{i};
            pushables{end+1} = cutlery{i};

            %E05 Move to pickup trays + push meal stock down + Dobot move to
        %cutlery
        %MAKE SURE DOBOT AND E05 PATH PLAN USES THE SAME STEPS
            e05qPath = worker.planPickupPath(trays{i},steps);
            if i > 1    %check if first iteration has been made
                    dobotqPath = dobot.planPickupPath(cutlery{k},steps);      %plan path for dobot to pickup cutlery
            end

            for step = 1:length(e05qPath)
                %animate worker moving to tray
                worker.animateArm(e05qPath(step,:));
                %animate dobot moving to cutlery
                if i > 1
                    dobot.animateArm(dobotqPath(step,:));   %animate dobot arm
                end
                % push stock down conveyor
                mealConveyor(1).push(meals)
                mealConveyor(2).push(meals)
                pause(0)
            end

            %Plans Deposit path for tray and cutlery
            e05qPath = worker.planDepositPath(trays{i},trayConveyor,steps);  %Plan path to move tray to the conveyor belt
            if i > 1
                dobotqPath = dobot.planDepositPath(cutlery{k},trays{k},steps); %plan path for move cutlery to tray
            end

             for step = 1:length(e05qPath)
                    worker.animateArm(e05qPath(step,:),trays{i});        
                if i > 1
                    dobot.animateArm(dobotqPath(step,:),cutlery{k});
                end
                 pause(0)
             end
        
         % Retract e05 arm from tray and dobot from cutlery
         e05q0 = worker.GetPos();
         e05qPath = worker.planRetract(e05q0,1,steps);
         if i > 1
            dobotq0 = dobot.GetPos();
            dobotqPath = dobot.planRetract(dobotq0,0.1,steps);
         end

         for step = 1:length(e05qPath)
             if i > 1
                dobot.animateArm(dobotqPath(step,:));
             end
             worker.animateArm(e05qPath(step,:));
             pause(0)
         end
        
        % %Create pickup path planning path for mealbox and juicebox
         e05qPath = worker.planPickupPath(meals{i},steps);
          if i > 1
            dobotqPath = dobot.planPickupPath(juiceBoxes{k},steps);      %plan path for dobot to pickup juicebox
          end

         for step = 1:length(e05qPath)
             worker.animateArm(e05qPath(step,:));
             if i > 1
                dobot.animateArm(dobotqPath(step,:));            %animate dobot arm
             end
             pause(0.0)
         end
        
        %Plans Deposit path for meal and juicebox
        e05qPath = worker.planDepositPath(meals{i},trays{i},steps);  %Plan path to move tray to the Conveyor belt
        if i > 1
            dobotqPath = dobot.planDepositPath(juiceBoxes{k},trays{k},steps);   %plan path for dobot to pickup juicebox
        end

         for step = 1:length(e05qPath)
             if i > 1
                dobot.animateArm(dobotqPath(step,:),juiceBoxes{k});           
             end
             worker.animateArm(e05qPath(step,:),meals{i});              %Animate arm moving with tray
             pause(0)
         end
        
         %Retracts grippers from items
         e05q0 =  worker.GetPos();
         e05qPath = worker.planRetract(e05q0,1,steps);
         if i > 1
            dobotq0 =  dobot.GetPos();
            dobotqPath = dobot.planRetract(dobotq0,0.1,steps);      %plan path for dobot to pickup juicebox
          end
         for step = 1:length(e05qPath)
             if i > 1
                dobot.animateArm(dobotqPath(step,:));           
             end
             worker.animateArm(e05qPath(step,:));
             pause(0)
         end
        
        %Pushes items on conveyor belt
         for step = 1:3*steps
             trayConveyor.push(pushables)
             dobotConveyor(1).push(juiceBoxes)
             dobotConveyor(2).push(cutlery)
             dobotConveyor(3).push(juiceBoxes)
             pause(0.01)
        end
    end
end