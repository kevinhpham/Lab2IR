%% GUIPanelDMTest
% Disclaimer: Code inspired by Lab 11 - Question 4 skeleton code

%% setup teach pendant
close
pendant = GUIPanelDM;

%% Set up robot
DobotMagician;                           % Load E05_L
robot = DobotMagician;                 %% Create copy called 'robot
%% Start "real-time" simulation
q = robot.defaultRealQ;              % Set initial robot configuration 'q'

HF = figure(1);                         % Initialise figure to display robot
robot.model.plot(q);                    % Plot robot in initial configuration
robot.model.delay = 0.001;              % Set smaller delay when animating
set(HF,'Position',[0.1 0.1 0.8 0.8]);
minManipMeasure = 0.3;                  %Minimum manipulativity before DLS kicks in
dt = 0.15;                              %time step
while(1)
    
    % % read joystick
    wrench = pendant.read
    % -------------------------------------------------------------
    % YOUR CODE GOES HERE
    % % 1 - turn joystick input into an end-effector force measurement command
         x = wrench(1:6)

        % 2 - use simple admittance scheme to convert force measurement into
        % velocity command
        Ka = diag([0.3 0.3 0.3 0.5 0.5 0.5]); % admittance gain matrix
        dx = Ka*x; % convert wrench into end-effector velocity command
        % 3 - use J inverse to calculate joint velocity
        J = robot.model.jacobe(q)
    
        m = sqrt(det(J*J'))                                 %Calculate current measure of manipulativity
           if m < minManipMeasure                           %if below threshhold manipulativity
                lambda = (1-(m/minManipMeasure)^2)*0.1;
                qdot = inv((J'*J+lambda*eye(5)))*J'*x       % Use dampled least squared
           else
           qdot = inv(J)*x                                  % Solve velocitities via RMRC
           end

    % 3 - apply joint velocity to step robot joint angles 
    % -------------------------------------------------------------
        q = robot.model.getpos + qdot.'*dt
    % Update plot
    robot.model.animate(q);  
    
    % wait until loop time elapsed
    pause(dt)
end