%pendantDM = GUIPanelDM();

%pendantE05L = GUIPanelE05L();




%% Robotics
% Lab 11 - Question 2 skeleton code

%% setup joystick
% id = 1; % Note: may need to be changed if multiple joysticks present
% joy = vrjoystick(id);
% caps(joy) % display joystick information

%% setup teach pendant
close
pendant = GUIPanelDM;

%% Set up robot                    % Load Puma560
robot = DobotMagician;                   % Create copy called 'robot'
%robot.tool = transl(0.1,0,0);   % Define tool frame on end-effector


%% Start "real-time" simulation
q = robot.defaultRealQ;                 % Set initial robot configuration 'q'

HF = figure(1);         % Initialise figure to display robot
% robot.plot(q);          % Plot robot in initial configuration
robot.delay = 0.001;    % Set smaller delay when animating
set(HF,'Position',[0.1 0.1 0.8 0.8]);
minManipMeasure = 0.3;  %Minimum manipulativity before DLS kicks in
dt = 0.15; %time step
while(1)
    
    % read joystick
    wrench = pendant.read;
    % -------------------------------------------------------------
    % YOUR CODE GOES HERE
    % 1 - turn joystick input into an end-effector velocity command
        x = wrench(1:6)
    % 2 - use J inverse to calculate joint velocity
        J = robot.jacob0(robot.getpos)
    
        m = sqrt(det(J*J'))                         %Calculate current measure of manipulativity
           if m < minManipMeasure                      %if below threshhold manipulativity
                lambda = (1-(m/minManipMeasure)^2)*0.1;
                qdot = inv((J'*J+lambda*eye(6)))*J'*x   %Use dampled least squared
           else
           qdot = inv(J)*x                            % Solve velocitities via RMRC
           end

    % 3 - apply joint velocity to step robot joint angles 
    % -------------------------------------------------------------
        q = robot.getpos + qdot.'*dt
    % Update plot
    robot.animate(q);  
    
    % wait until loop time elapsed
    pause(dt)
end
      