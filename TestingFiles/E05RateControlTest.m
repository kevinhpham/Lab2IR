r= E05_L;
steps = 60;
    r.model.plot([pi/5,pi/2,pi/3,0,pi/4,0]); %random, non singular position
    currentTr = r.model.fkineUTS(r.model.getpos())
    goalTr = transl(0,0,0.3)*currentTr %move up z axis
    z1 = zeros(1,6)
    z2 = [0 0 1 0 0 0]
    % 3.7
    z = zeros(6,steps);
    s = lspb(0,1,steps);                                 % Create interpolation scalar
    for i = 1:steps
        z(:,i) = z1*(1-s(i)) + s(i)*z2;                 
    end
    
    % % 3.8
    qMatrix = nan(steps,6);
    % 
    % % 3.9
    q0 = r.model.getpos();
    qMatrix(1,:) = q0;     % Solve for joint angles
    % 
    % 3.10
    for i = 1:steps-1
       zdot = z(:,i+1)-z(:,i)                         % Calculate velocity at discrete time step
            J = r.model.jacob0(qMatrix(i,:))                  % Get the Jacobian at the current state                          % Take only first 2 rows
         qdot = inv(J)*zdot()                         % Solve velocitities via RMRC
         qMatrix(i+1,:) = qMatrix(i,:)+qdot.'        % Update next joint state
     end
    error = r.model.fkineUTS(qMatrix(steps,:)) - goalTr
     r.model.plot(qMatrix,'trail','r-');


