function psi_t = matsuoka_torque(t, q)
% 
%   Function to compute the desired torque at each time step
%   using the equations for the matsuoka osccillator

    % Oscillator constants
    global t1;
    global t2;
    global beta;
    global eta;
    global sigma;
    global h_psi;
   
    % State variables of the oscillator
    % Implemented as global variables so that these persist between
    % invocations
    global psi_i;
    global psi_j;
    global phi_i;
    global phi_j;
    global u_i;
    global u_j;
    global time_now;
    global time_prev;
    global torque_list;
    global avg_position;
    global ut_list;
    
    % Mean position of oscillation of the joint angle
    global theta_star;
    
    % Change the amplitude
    u_i = u_i + 0.001;
    u_j = u_j + 0.001;
    
    % Calculate the time delta
    time_now = t;
    step_time = time_now - time_prev;
    time_prev = time_now;

    % Calculate the proprioceptive feedback
    ref = q - theta_star;
    
    % The oscillator differential equations
    dpsi_i = (-psi_i -(beta*phi_i) -eta*max([0,psi_j])  -sigma*max([0, -ref]) + u_i)*1/t1;
    dpsi_j = (-psi_j -(beta*phi_j) -eta*max([0,psi_i])  -sigma*max([0, ref])+ u_j)*1/t1;

    % Calculate next state
    psi_i = psi_i + dpsi_i* step_time;
    psi_j = psi_j + dpsi_j* step_time;

    % Calculate derivative of the state variable
    dphi_i = (-phi_i + max([0, psi_i]))*1/t2;
    dphi_j = (-phi_j + max([0, psi_j]))*1/t2;
    
    % Calculate the next state
    phi_i = phi_i + dphi_i*step_time;
    phi_j = phi_j + dphi_j*step_time;

    % Calculate the output torque
    psi_t = h_psi*(max([0, psi_i]) - max([0, psi_j]));
    
    % List used for plotting the torques
    torque_list = [torque_list psi_t];
    
    %List for average position
    avg_position = [avg_position theta_star];
    
    % List for ut
    ut_list = [ut_list u_i]; %u_i=u_j=u_t
    
end

