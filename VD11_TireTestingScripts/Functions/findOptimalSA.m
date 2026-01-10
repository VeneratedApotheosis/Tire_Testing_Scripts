function optimal_SA = findOptimalSA(SA, Fy)
    % Ensure input data is sorted by SA (if not already)
    [SA, sortIdx] = sort(SA);
    Fy = Fy(sortIdx);

    % Find the index of the maximum Fy
    [~, maxIdx] = max(Fy);

    % Return the SA corresponding to the maximum Fy
    optimal_SA = SA(maxIdx);
end