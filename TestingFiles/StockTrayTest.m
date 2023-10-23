clear
close
axis equal
camlight
item{1} = Cutlery(transl(0,0,0));
item{2} = MealBox(item{1}.base*transl(-0.1,0,0),'m');
item{3} = MealBox(item{2}.base*transl(-0.15,0,0),'v');
item{4} = JuiceBox(item{3}.base*transl(-0.1,0,0),'b');
item{5} = JuiceBox(item{4}.base*transl(-0.1,0,0),'o');
item{6} = Tray(item{5}.base*transl(0,0,-0.05));