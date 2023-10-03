%To test 'Item' sub-classes. Creates a 5x5 grid of 'FireExtinguisher'
%objects into the workspace
close
clear
hold on
camlight
fire = cell(10,10);
for j = 1:5
    for i = 1:5
        fire{j,i} = FireExtinguisher();
        fire{j,i}.move(transl(i,j,0));
    end
end

axis equal
