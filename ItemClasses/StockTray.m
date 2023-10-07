%Creates a movable 3d model of a Empty StockTray
classdef StockTray < Item
    properties
    end 

    methods
        function item = StockTray(baseTr)
            plyName = 'EmptyStockTray.PLY';
            if nargin < 1
                baseTr = eye(4);
            end
            item = item@Item(plyName,baseTr)
        end
        
        %Fills trays with 'count' amount of juceboxes
        %Returns an array containing the juiceboxes
        function [juiceArray] = addJuice(self,count,flavour)
            if (0<=count & count<=9) %confirm appropriate number of juice boxes entered
                base = self.base;
                spacing = 0.23;      %spacing between each juice box
                juiceArray = JuiceBox.empty;
                
                coloumns = ceil((count)^0.5);
                rows = ceil(count/coloumns);
                counter = 1;
                for i = 1:rows
                    for j= 1:coloumns
                        if counter <= count
                            tr = transl((spacing*j-0.18) , (spacing*i-0.18) , 0.02)*rpy2tr(0,0,0,'deg');
                            juiceArray(counter) = JuiceBox(base*tr,flavour);
                            counter = counter +1;
                        end
                    end
                end
            else
                msg = 'Invalid number of juice boxes. Must be between 0 and 9 juices boxes.';
                error(msg)
            end
        end
    end
end