%%VegTrayClass

classdef VegTray < Item
    properties
    end 

    methods
        function item = VegTray(baseTr)
            tray = Tray(transl(0,0,0));
            oJuice = JuiceBox(transl(0.1,0.05,0), 'orange');
            vMeal = MealBox(transl(-0.09,-0.05,0), 'meat');
            cutlery = Cutlery(transl(0.03,0,0));

            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
    end
end
