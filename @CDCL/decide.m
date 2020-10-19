function vars_to_assign = decide(obj)
% Returns 0 iff there are no more variables to assign

% We increase the current decision level (note that dl is
% initialized to 0 in the CDCL object).
obj.current_decision_level = obj.current_decision_level + 1;

if ~any(obj.variable_values == 0)
    % No more variables to assign
    vars_to_assign = 0;
    return
else
    vars_to_assign = 1;
end

% We only select the literal scores of unassigned variables
% To do this, set scores of assigned variables to -1
scores_to_compare = obj.literal_scores;
scores_to_compare(:, obj.variable_values ~= 0) = -1;

% Update the literal scored by dividing them by 2
% TODO: Make the frequency of this a tunable parameter
obj.literal_scores = obj.literal_scores / 2;

[~, max_index] = max(scores_to_compare(:));
[idx_row, idx_col] = ind2sub(size(scores_to_compare), max_index);

% idx_row tells us whether to set to true (1) or false (2)
% idx_col tells us which variable to set
obj.latest_decision = idx_col;
reason = 'decision heuristic';
if idx_row == 1
    obj.set_variable_value(idx_col, 1, reason);
elseif idx_row == 2
    obj.set_variable_value(idx_col, -1, reason);
else
    error('Unexpected row index - literal_scores should only have 2 rows');
end


end