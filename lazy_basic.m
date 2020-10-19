function [sat_result, sol_result] = lazy_basic(expression, atoms)

% The expression is already encoded in CNF
% The atoms tells us how to interpret each column in the expression
sol_result = [];
while true
    % Johan's implementation of CDCL SAT solver
    obj = CDCL(expression);
    % For expressive output, set obj.verbose = 1
    % obj.verbose = 1; 
    sat = obj.check_sat();
    sol = obj.variable_values;
    
    if ~sat
        sat_result = 0;
        return
    end
    
    res = deduction_equality_logic(sol, atoms);
    
    if res
        sat_result = 1;
        sol_result = sol;
        return
    end
    
    % Conjoin the negation of sol to the expression, then loop again
    row_to_add = -sol;
    expression = [expression; row_to_add]; %#ok<*AGROW>
end

end


