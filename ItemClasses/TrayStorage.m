%Creates a movable 3d model of a TrayStorage
classdef TrayStorage < Item
    properties
    end 

    methods
        function item = TrayStorage(baseTr)
            plyName = 'TrayStorage.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
        
        %Fills rack with 'count' amount of trays
        %Returns an array containing the trays
        function [TrayArray] = addTrays(self,count)
            if (0<=count & count<=8)
                base = self.base;
                spacing = 0.06;
                TrayArray = Tray.empty;
                    for i = 1:count
                        traytr = transl(0.06*i-0.265,0,0.15)*rpy2tr(0,90,0,'deg');
                        TrayArray(i) = Tray(base*traytr);
                    end
            else
                msg = 'Invalid number of trays. Must be between 0 and 8 trays.';
                error(msg)
            end

        

        end
    end
end
