function backtrack(obj, backtrack_level)
% Set the current level to backtrack_level and erase all assignments at
% higher levels than backtrack_level

obj.current_decision_level = backtrack_level;

% Clear all variables needed to erase assignments from history
vars_to_erase = find(obj.decision_levels > backtrack_level);

for var = vars_to_erase
    obj.variable_values(var) = 0;
    obj.decision_levels(var) = -1;
    obj.assignment_order(var) = -1;
    
    % Clear node_struct
    obj.node_struct(var).variable = [];
    obj.node_struct(var).decision_level = [];
    obj.node_struct(var).value = [];
    obj.node_struct(var).antecedent = [];
end

if obj.verbose
    disp(['Backtracked to level ' num2str(backtrack_level) '. ' ...
        'Variables cleared:']);
    disp(vars_to_erase);
end

end