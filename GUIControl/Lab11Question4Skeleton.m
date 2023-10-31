%% Robotics
% Lab 11 - Question 4 skeleton code
%Main Difference between question 2 and 4 is 4 uses end effector frame as reference to
%control arm.

%% setup teach pendant
close
pendant = VirtualTeachPendant;

%% Set up robot
mdl_puma560;                    % Load Puma560
robot = p560;                   % Create copy called 'robot'
robot.tool = transl(0.1,0,0);   % Define tool frame on end-effector


%% Start "real-time" simulation
q = qn;                 % Set initial robot configuration 'q'

HF = figure(1);         % Initialise figure to display robot
robot.plot(q);          % Plot robot in initial configuration
robot.delay = 0.001;    % Set smaller delay when animating
set(HF,'Position',[0.1 0.1 0.8 0.8]);
minManipMeasure = 0.3;  %Minimum manipulativity before DLS kicks in
dt = 0.15; %time step
while(1)
    
    % read joystick
    wrench = pendant.read;
    % -------------------------------------------------------------
    % YOUR CODE GOES HERE
    % 1 - turn joystick input into an end-effector force measurement command
        x = wrench(1:6)

        % 2 - use simple admittance scheme to convert force measurement into
        % velocity command
        Ka = diag([0.3 0.3 0.3 0.5 0.5 0.5]); % admittance gain matrix
        dx = Ka*x; % convert wrench into end-effector velocity command
        % 3 - use J inverse to calculate joint velocity
        J = robot.jacobe(q)
    
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
      

