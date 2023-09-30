classdef GripperRangeTest <handle
    properties
    end

    methods (Static)
        function RG6Test()
            hold on
            clear
            gripper = RG6_Gripper();
            q = [0 0 0];
            gripper.moveBase(transl(0,0,-0.2))
            gripper.plotAll(q)
            axis equal
            
            %Test range of motion
            qPath = jtraj(gripper.left.qlim(:,1).', gripper.left.qlim(:,2).', 50);
            gripper.setDelay(0.01)
            for i = 1:length(qPath)
                gripper.animateAll(qPath(i,:))
                drawnow();
                pause(0);
            end
        end

       function VG10Test()
            hold on
            clear
            gripper = VG10_Gripper();
            gripper.moveBase(transl(0,0,-0.2))
            q = [0 0];
            gripper.plotAll(q)
            axis equal
            
            %Test range of motion
            qPath = jtraj(gripper.a1.qlim(:,1).', gripper.a1.qlim(:,2).', 50);
            gripper.setDelay(0.01)
            for i = 1:length(qPath)
                gripper.animateAll(qPath(i,:))
                drawnow();
                pause(0);
            end
        end
    end
end
