function conflict = BCP(obj)
% Returns 1 if conflict, zero otherwise

% Initialize the conflict flag to 0
conflict = 0;

% Create the implication graph
obj.implication_graph = digraph();

% We keep looping over all the clauses over and over again, as
% long as at least one new variable is assigned a value during
% each while() iteration.
% We do this by keeping track of the number of unassigned
% variables at the start of each iteration.
n_unassigned_variables = Inf;
while(n_unassigned_variables ~= sum(obj.variable_values == 0))
    n_unassigned_variables = sum(obj.variable_values == 0);
    for clause_counter = 1:size(obj.expression, 1)
        clause = obj.expression(clause_counter, :);
        
        % We only look at the variables AFFECTING the clause
        % A variable affects the clause iff it is part of the
        % clause
        vars_affecting_clause = find(clause ~= 0);
        
        % We extract the parts of the clause and the variable
        % values that affect the clause
        clause_affected = clause(vars_affecting_clause);
        var_values_affecting_clause = obj.variable_values(vars_affecting_clause);
        
        % First we check if any of these values are the same
        % That would mean that a variable has already been assigned
        % the value that this clause needs - this clause is
        % already fulfilled!
        if any(var_values_affecting_clause == clause_affected)
            continue;
        end
        
        % There is a conflict if there is no unassigned variable
        if ~any(var_values_affecting_clause == 0)
            % For each variable that affects the clause,
            % add an edge from that variable to the "failure"
            % node in G.
            % The "failure" node has index n+1, where n is the
            % number of variables in the expression.
            failure_node = size(obj.expression, 2) + 1;
            
            for edge_counter = 1:numel(vars_affecting_clause)
                obj.implication_graph = addedge(obj.implication_graph, ...
                    vars_affecting_clause(edge_counter), ...
                    failure_node);
            end
            
            % We add it to the implication graph
            obj.node_struct(failure_node).decision_level = obj.current_decision_level;
            obj.node_struct(failure_node).antecedent = clause_counter;
            
            if obj.verbose
                disp(['Conflict detected due to clause c' num2str(clause_counter) '!']);
            end
            
            % Set conflict to 1 and return
            conflict = 1;
            return
        end
        
        % If we have exactly ONE unassigned variable, we know what
        % we need to assign it to!
        if sum(var_values_affecting_clause == 0) == 1
            % Find the index of the variable we want to assign
            % a value to
            var_to_assign = vars_affecting_clause(var_values_affecting_clause ==0);
            
            % Find the value we need to assign to the variable
            % (it is found in the clause)
            value_to_assign = clause(var_to_assign);
            
            % Set the variable value and add its decision level
            reason = ['c' num2str(clause_counter) ' antecedent'];
            obj.set_variable_value(var_to_assign, value_to_assign, reason);
            
            % We add it to the implication graph
            obj.node_struct(var_to_assign).variable = var_to_assign;
            obj.node_struct(var_to_assign).decision_level = obj.current_decision_level;
            obj.node_struct(var_to_assign).value = value_to_assign;
            obj.node_struct(var_to_assign).antecedent = clause_counter;
            
            % For each OTHER variable that affects the clause,
            % add an edge from that variable to this variable
            % in the digraph G
            vars_to_add_edges_from = vars_affecting_clause(vars_affecting_clause ~= var_to_assign);
            for edge_counter = 1:numel(vars_to_add_edges_from)
                obj.implication_graph = addedge(obj.implication_graph, ...
                    vars_to_add_edges_from(edge_counter), ...
                    var_to_assign);
            end
        end
    end
end

% We have reached the end of the while loop
% This means that there are no more variables to assign by the
% unit clause rule, and it also means that there are no
% conflicts.
5;

end