function backtrack_level = analyze_conflict(obj)
% Returns decision level which the solver should backtrack to.
% If a conflict at decision level 0 is detected, returns -1.
if obj.current_decision_level == 0
    backtrack_level = -1;
    return
end

% Initialize cl as the current conflicting clause
% To get this, we look in the node_struct for the failure node
% (the failure node is the last node)
cl_index = obj.node_struct(end).antecedent;
cl = obj.expression(cl_index, :);

% Display for verbose
if obj.verbose
    disp(' ');
    disp('*** analyze_conflict ***');
    fprintf('%s\t\t\t%s\t%s\t%s\n', 'cl', 'lit', 'var', 'ante');
end

% Get the first UIP of the implication graph
% This is used for the stopping condition of the while-loop.
% TODO: Implement this in a smarter way
% - Current: Extracts ALL PATHS from the graph, then finds
%   which ones contain both decision and conflict nodes
% - Smarter: Do BFS manually, store all paths we get from the
%   decision node.
first_uip = obj.get_first_uip();

while ~stop_criterion_met(obj, cl, first_uip)
    % lit := LAST-ASSIGNED-LITERAL(cl)
    % We find the last assigned literal in the following way
    % 1. Find which literals exist in the conflict clause cl
    literals_in_cl = find(cl ~= 0);
    % 2. Find the index of the literal with the highest
    % decision level (= most recently assigned)
    [~, lit_index] = max(obj.assignment_order(literals_in_cl));
    % 3. Find lit by using the lit_index
    lit = literals_in_cl(lit_index);
    
    % var := VARIABLE-OF-LITERAL(lit)
    % In this framework, var is actually equal to lit (the
    % value of the variable is stored in obj.variable_values)
    var = lit;
    
    % ante := ANTECEDENT(lit)
    % obj.node_struct contains information about the
    % implication graph for a given variable (literal).
    ante_index = obj.node_struct(lit).antecedent;
    ante = obj.expression(ante_index, :);
    
    if obj.verbose
        if obj.variable_values(lit) == 1
            not_string = '';
        else
            not_string = '~';
        end
        cl_string = get_clause_string(obj, cl);
        lit_string = [not_string 'x' num2str(lit)];
        var_string = ['x' num2str(var)];
        ante_string = ['c' num2str(ante_index)];
        fprintf('[%s]\t%s\t%s\t%s\n', cl_string, lit_string, var_string, ante_string);
    end
    
    % cl:= RESOLVE(cl, ante, var)
    cl = resolve(obj, cl, ante, var);
end

% add-clause-to-database(cl)
obj.add_clause_to_expression(cl);

% return clause-asserting-level(cl)
% We want to return the 2nd highest decision level in cl
backtrack_level = get_second_highest_dl(obj, cl);

end

function stop = stop_criterion_met(obj, cl, first_uip)
% Returns true only if the stop criterion is met in ANALYZE-CONFLICT
% We follow the advice in Kroening, Strichman p39:
% A good strategy is to return TRUE iff cl contains the negation of the
% first UIP as its single literal at the current decision level. 
value_assigned_at_uip = obj.variable_values(first_uip);
literals_assigned_at_this_level = ...
    find(obj.decision_levels == obj.current_decision_level);

% For all literals assigned at this level, we check cl such that
% - If it's the first UIP, it is negated
% - If it is any other literal, it is unassigned
% As soon as one of these criteria is not fulfilled, return false
for lit = literals_assigned_at_this_level
    if lit == first_uip
        % First UIP
        if cl(lit) == 0 || cl(lit) == obj.variable_values(lit)
            % Unassigned or same value as in uip
            stop = false;
            return
        end
    else
        % Any other literal
        if cl(lit) ~= 0
            stop = false;
            return
        end
    end
end

% If we reached here, we passed all the checks of the for loop
stop = true;
end

function clause_string = get_clause_string(obj, clause)
clause_string = '';
for var_counter = 1:numel(clause)
    if clause(var_counter) == 1
        clause_string = [clause_string 'x' num2str(var_counter) ' v '];
    elseif clause(var_counter) == -1
        clause_string = [clause_string '~x' num2str(var_counter) ' v '];
    end
end

% Remove the last 'v '
clause_string = clause_string(1:end-2);
5;
end

function new_clause = resolve(obj, clause1, clause2, var)
assert(clause1(var) == -clause2(var));

% Generate the new clause
new_clause = inf(size(clause1));
for k = 1:numel(clause1)
    if clause1(k) == clause2(k)
        new_clause(k) = clause1(k);
    elseif clause1(k) == 0
        new_clause(k) = clause2(k);
    elseif clause2(k) == 0
        new_clause(k) = clause1(k);
    else
        assert(k == var);
        new_clause(k) = 0;
    end
end
end

function backtrack_level = get_second_highest_dl(obj, cl)
assigned_vars = find(cl ~= 0);

if numel(assigned_vars < 2)
    backtrack_level = 0;
else
    levels_of_assigned_vars = obj.decision_levels(assigned_vars);
    sorted_levels = sort(levels_of_assigned_vars, 'descend');
    backtrack_level = sorted_levels(2);
end
end