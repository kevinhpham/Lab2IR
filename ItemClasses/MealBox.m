%Creates a movable 3d model of a MealBox
classdef MealBox < Item
    properties
    end 

    methods
        function item = MealBox(baseTr,flavour)
        %type is a string specifying which type of juice to create
        %If no arguement provided use default values
            if nargin <2
                flavour = 'none';
                if nargin < 1
                    baseTr = eye(4);
                end
            end
            
            %Check what type of flavour has been requested and
            %select appropriate Ply file
            flavourL = lower(flavour);
            switch(flavourL)
                case 'veg'
                    plyName = 'MealBoxVego.PLY';
                case 'v'
                    plyName = 'MealBoxVego.PLY';
                case'vego'
                    plyName = 'MealBoxVego.PLY';
                case'vegetable'
                    plyName = 'MealBoxVego.PLY';
                case'vegetarian'
                    plyName = 'MealBoxVego.PLY';
                case'meat'
                    plyName = 'MealBoxMeat.ply';
                case'm'
                    plyName = 'MealBoxMeat.ply';
                case 'none'
                    plyName = 'MealBox.ply';
                otherwise
                    plyName = 'MealBox.ply';
            end
            item = item@Item(plyName,baseTr)
        end
    end
end