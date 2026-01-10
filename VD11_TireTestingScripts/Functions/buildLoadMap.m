function [FL_loads, FR_loads, RL_loads, RR_loads] = buildLoadMap(params, circle_points)
    n = size(circle_points, 1);
    FL_loads = zeros(n, 7); FR_loads = FL_loads;
    RL_loads = FL_loads; RR_loads = FL_loads;

    for i = 1:n
        [FL, FR, RL, RR, ~] = calculateLoadTransfer(params, circle_points(i,:));
        FL_loads(i, 1:3) = circle_points(i,:);
        FR_loads(i, 1:3) = circle_points(i,:);
        RL_loads(i, 1:3) = circle_points(i,:);
        RR_loads(i, 1:3) = circle_points(i,:);
        FL_loads(i, 4:6) = FL; FR_loads(i, 4:6) = FR;
        RL_loads(i, 4:6) = RL; RR_loads(i, 4:6) = RR;

        FL_loads(i, 7) = sqrt(FL_loads(i, 4)^2+FL_loads(i, 5)^2+FL_loads(i, 6)^2);
        FR_loads(i, 7) = sqrt(FR_loads(i, 4)^2+FR_loads(i, 5)^2+FR_loads(i, 6)^2);
        RL_loads(i, 7) = sqrt(RL_loads(i, 4)^2+RL_loads(i, 5)^2+RL_loads(i, 6)^2);
        RR_loads(i, 7) = sqrt(RR_loads(i, 4)^2+RR_loads(i, 5)^2+RR_loads(i, 6)^2);
    end
end
