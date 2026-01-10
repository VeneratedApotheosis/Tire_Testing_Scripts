function circle_points = generateTractionCircle(lat_acc, long_acc, long_brake, res)
    degrees = linspace(0, 360, res);
    circle_points = zeros(res, 3);
    for i = 1:res
        t = degrees(i);
        x = lat_acc * cosd(t);
        if sind(t) >= 0
            y = long_acc * sind(t);
            r = sqrt((x/lat_acc)^2 + (y/long_acc)^2);
        else
            y = long_brake * sind(t);
            r = sqrt((x/lat_acc)^2 + (y/long_brake)^2);
        end
        x = x / r;
        y = y / r;
        circle_points(i, :) = [x, y, t];
    end
end