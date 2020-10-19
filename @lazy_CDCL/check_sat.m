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
        % deduction() used obj.variable_values and obj.atoms
        res = obj.deduction();
        if res
            if obj.verbose
                disp('SATISFIED! Solution:');
                disp(obj.variable_values);
            end
            sat = 1;
            return
        end
        obj.add_clause_to_expression(-obj.variable_values);
    end
    
end

end