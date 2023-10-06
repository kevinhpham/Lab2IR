%Creates a juicebox 3d model of either orange or blackcurrant variation
classdef JuiceBox < Item
    properties
    end 

    methods
        function item = JuiceBox(baseTr,flavour)
        %type is a string specifying which type of juice to create
        %If no arguement provided use default values
        %make sure arguements entered in correct order
            if nargin <2
                flavour = 'none';
                if nargin < 1
                    baseTr = eye(4);
                end
            end
            %Check what type of juicebox flavour has been requested and
            %select appropriate Ply file
            flavourL = lower(flavour);
            switch(flavourL)
                case 'o'
                    plyName = 'JuiceBoxOrange.PLY';
                case 'orange'
                    plyName = 'JuiceBoxOrange.PLY';
                case'b'
                    plyName = 'JuiceBoxBlackCurrant.PLY';
                case'blackcurrant'
                    plyName = 'JuiceBoxBlackCurrant.PLY';
                case 'none'
                    plyName = 'JuiceBox.Ply';
                otherwise
                    plyName ='JuiceBox.PLY';
            end
            item = item@Item(plyName,baseTr);
        end
    end
end
