function add_clause_to_expression(obj, clause)
obj.expression(end+1, :) = clause;

% Increase the score for each literal in the added clause
pos_lit_to_increase = find(clause == 1);
neg_lit_to_increase = find(clause == -1);

obj.literal_scores(1, pos_lit_to_increase) = ...
    obj.literal_scores(1, pos_lit_to_increase) + 1;
obj.literal_scores(2, neg_lit_to_increase) = ...
    obj.literal_scores(2, neg_lit_to_increase) + 1;

end