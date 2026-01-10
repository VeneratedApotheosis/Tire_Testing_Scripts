function [innerSlip, outerSlip, slipDelta] = findSlipDelta(inner_Fz, outer_Fz, peakAngles, peakForces)
    innerSlip = interp1(peakForces, peakAngles, inner_Fz, 'linear', 'extrap');
    outerSlip = interp1(peakForces, peakAngles, outer_Fz, 'linear', 'extrap');
    slipDelta = innerSlip - outerSlip;
end