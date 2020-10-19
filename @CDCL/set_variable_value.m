function set_variable_value(obj, variable, value, reason)
% This function sets a value to a specific variable, and also
% sets the decision level correctly.
% obj is the CDCL object
% variable is the index of the variable we want to set
% value is the value to set the variable to (either 1 for true,
%   or -1 for false).

obj.variable_values(variable) = value;
obj.decision_levels(variable) = obj.current_decision_level;
obj.assignment_order(variable) = obj.assignment_counter;
obj.assignment_counter = obj.assignment_counter + 1;

if obj.verbose
    if value == 1
        not_string = '';
    else
        not_string = '~';
    end
    disp(['Set ' not_string 'x' num2str(variable) ...
        '@' num2str(obj.current_decision_level) ...
        ' - ' reason]);
end
end