function sat = check_sat(obj)
if obj.verbose
    disp('*** START check_sat ***');
end
while true
    while obj.BCP()
        backtrack_level = obj.analyze_conflict();
        if backtrack_level < 0
            sat = 0;
            return
        end
        obj.backtrack(backtrack_level);
    end
    
    if ~obj.decide()
        sat = 1;
        if obj.verbose
            disp('SATISFIED! Solution:');
            disp(obj.variable_values);
        end
        return
    end
    
end

% TODO: Implement
sat = 1;
end