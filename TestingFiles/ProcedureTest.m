properties
e05PlannedPath
e05ItemHold
e05ItemPlaced
e05CurrentStep
conveyorCurrentStep
conveyorMaxstep

procedure
steps
eButton
end



function 
end



function animateProcedure()
e05PlannedPath = self.e05PlannedPath 
e05ItemHold = self.e05ItemHold
e05CurrentStep = self.e05CurrentStep
procedure = self.procdure

        if procedure == 1
            for i = e05CurrentStep:length(eo5PlannedPath)
                if eButton == 0
                    e05_worker.animateArm(eo5PlannedPath(i,:),e05ItemHold)
                    self.e05CurrentStep = i;        %Update current step        
                elseif i == length(eo5PlannedPath)  %Once all planned steps have been iterated
                    self.procedure = 2;             %Update procedure to move to next procedure
                    self.e05CurrentStep = 1;        %Reset current step for next procedure
                else
                    break                           %If estop been pressed, break loop;
                end
            end
        %%yada yada yada last procedure for instance
        elseif procedure == 9
            for i = stepCurrentStep:
                 trayConveyor.push(pushables)
                 dobotConveyor(1).push(juiceBoxes)
                 dobotConveyor(2).push(cutlery)
                 dobotConveyor(3).push(juiceBoxes)
            elseif
                    self.procedure = 2;             %Update procedure to move to next procedure
                else
                    break                           %If estop been pressed, break loop;
            else
            end
        end
