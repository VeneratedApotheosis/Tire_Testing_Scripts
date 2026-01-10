function ackDeltas = ackPlot(wheelbase, trackwidth, steerAngle, ackPercent)
    cornerRadius = wheelbase ./ tand(steerAngle);
    innerTireAngle = atand(wheelbase ./ (cornerRadius - (0.5 .* trackwidth)));
    outerTireAngle = atand(wheelbase ./ (cornerRadius + (0.5 .* trackwidth)));
    fullAck = innerTireAngle - outerTireAngle;
    ackPercent = ackPercent ./ 100;
    ackDeltas = fullAck .* ackPercent;
end
