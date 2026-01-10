function [FL, FR, RL, RR, aero] = calculateLoadTransfer(params, point)
    % Destructure parameters
    a = params.CG_x;
    b = params.wheelbase - a;
    W = params.W;
    track = params.trackwidth;
    H = (params.CG_z - ((params.Z_RR - params.Z_RF)/params.wheelbase)*a - params.Z_RF) / 12;

    % Longitudinal transfer
    LT_Long = params.CG_z * W * point(2) / params.wheelbase;

    % Lateral transfer
    Kphi_sum = params.Kphi_F + params.Kphi_R;
    LT_Lat_F = (point(1)*W/(track/12))*((H*params.Kphi_F/Kphi_sum)+(b*(params.Z_RF/12)/params.wheelbase));
    LT_Lat_R = (point(1)*W/(track/12))*((H*params.Kphi_R/Kphi_sum)+(a*(params.Z_RR/12)/params.wheelbase));
    FTLLTD = LT_Lat_F / (LT_Lat_F + LT_Lat_R);

    % Initial static load
    Fz_F = W*(b/params.wheelbase)/2;
    Fz_R = W*(a/params.wheelbase)/2;

    % Combine effects
    Fz_FL = Fz_F - LT_Long/2 + LT_Lat_F;
    Fz_FR = Fz_F - LT_Long/2 - LT_Lat_F;
    Fz_RL = Fz_R + LT_Long/2 + LT_Lat_R;
    Fz_RR = Fz_R + LT_Long/2 - LT_Lat_R;

    % Longitudinal forces
    Fx = zeros(1,4);
    if point(2) >= 0
        Fx(3:4) = point(2)*W/2;
    else
        Fx(1:2) = point(2)*W*params.brake_bias/2;
        Fx(3:4) = point(2)*W*(1-params.brake_bias)/2;
    end

    % Lateral forces (proportional to effects of lateral load transfer
    % on vertical loads)
    f_lat_prop = LT_Lat_F / Fz_F;
    r_lat_prop = LT_Lat_R / Fz_R;
    Fy_FL = W*point(1)*FTLLTD/2*(1 + f_lat_prop);
    Fy_FR = W*point(1)*FTLLTD/2*(1 - f_lat_prop);
    Fy_RL = W*point(1)*(1-FTLLTD)/2*(1 + r_lat_prop);
    Fy_RR = W*point(1)*(1-FTLLTD)/2*(1 - r_lat_prop);

    % Add aero drag/downforce
    q = 0.5 * params.rho * params.velocity^2;
    D = q * params.Cd * params.area;
    L = q * params.Cl * params.area;
    DF_F = L * params.CoP_bias;
    DF_R = L * (1 - params.CoP_bias);
    aero_drag = D;

    Fz_FL = Fz_FL + DF_F; Fx(1) = Fx(1) - aero_drag;
    Fz_FR = Fz_FR + DF_F; Fx(2) = Fx(2) - aero_drag;
    Fz_RL = Fz_RL + DF_R; Fx(3) = Fx(3) - aero_drag;
    Fz_RR = Fz_RR + DF_R; Fx(4) = Fx(4) - aero_drag;

    FL = [Fx(1), Fy_FL, Fz_FL];
    FR = [Fx(2), Fy_FR, Fz_FR];
    RL = [Fx(3), Fy_RL, Fz_RL];
    RR = [Fx(4), Fy_RR, Fz_RR];

    aero = [DF_F, DF_R, aero_drag];
end