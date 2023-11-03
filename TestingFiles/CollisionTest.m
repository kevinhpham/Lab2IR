clear
close
clc

q = zeros(1,6);
worker = E05_worker;
worker.TurnOn
axis equal
steps = 60;
%setting up robot arm path
q0 = [0 pi/2 0 0 0 0];
qf = [pi pi/2 0 0 0 0];
qpath = jtraj(q0,qf,60);

%setting up chefs
chef = ChefPerson(transl(0,-0.9,0));
chef2 = ChefPerson(transl(2,-0.9,0)*rpy2tr(0,0,-pi/2));
worker.AddCollidables([chef chef2]);

%setting up environment
% Import the floor/ wallpapers
surf([-1.5,-1.5;3,3] ...
      ,[-3,2;-3,2] ...
      ,[-0.88,-0.88;-0.88,-0.88] ...
      ,'CData',imread('Floor.jpg') ...
      ,'FaceColor','texturemap');

surf([-1.5,3;-1.5,3] ...
      ,[2,2;2,2] ...
      ,[3,3;-0.88,-0.88] ...
      ,'CData',imread('WallPaper.jpg') ...
      ,'FaceColor','texturemap');

surf([3,3;3,3] ...
      ,[2,-3;2,-3] ...
      ,[3,3;-0.88,-0.88] ...
      ,'CData',imread('WallPaper.jpg') ...
      ,'FaceColor','texturemap');

e05Table = MealRobotTable(transl(0,0,-0.2));

%Moving arm with collision checking
for i = 1: steps
    result(i) = worker.AnimateArm(qpath(i,:));
    if(result(i)==1)
        disp('Robot Worker is about to collide, stopping arm.')
        break
    end
    pause(0)
end

%Moving chefs with collision checking
 for i = 1:steps
     move = chef2.base*transl(0,-0.05,0);
     if CollisionDetection.itemsIsCollision(chef2,chef,move)
         disp(['chef2: Who placed a ' chef.plyFile ' here!'])
         break
     end
     chef2.move(move)
     pause(0.1)
 end

%setting up  newrobot arm path
q0 = worker.robot.model.getpos();
qf = [-2*pi pi/2 0 0 0 0];
qpath = jtraj(q0,qf,60);

%Moving arm with collision checking
for i = 1: steps
    result(i) = worker.AnimateArm(qpath(i,:));
    if(result(i)==1)
        disp('Robot Worker is about to collide, stopping arm.')
        break
    end
    pause(0)
end
