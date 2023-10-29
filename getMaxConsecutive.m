function maxConsecutive = getMaxConsecutive(sorted_vals)
    differences = diff(sorted_vals);
    streak = 1;
    maxConsecutive = 0;

    for i = 1:length(differences)
        if differences(i) == 1
            streak = streak + 1;
        else
            streak = 1;
        end
        maxConsecutive = max(maxConsecutive, streak);
    end
end