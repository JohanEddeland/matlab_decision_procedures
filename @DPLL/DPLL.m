classdef DPLL < handle
    
    properties (SetAccess = public)
        atoms
        literal_scores
        expression
        variable_values
        decision_levels
        current_decision_level
        verbose
        implication_graph
        node_struct
        
        % Variables to keep track of the order of assignments of variables
        assignment_order
        assignment_counter
        
        % Keep track of latest decision variable
        latest_decision
    end
    
    methods
        function obj = DPLL(expression, atoms)
            obj.verbose = 0;
            obj.expression = expression;
            obj.atoms = atoms;
            obj.current_decision_level = 0;
            obj.latest_decision = 0;
            
            % Initialize variables values
            % Convention: -1 for false, 0 for unassigned, 1 for true
            n_variables = size(obj.expression, 2);
            obj.variable_values = zeros(1, n_variables);
            
            % Initialize assignment counter variables
            obj.assignment_order = zeros(1, n_variables);
            obj.assignment_counter = 1;
            
            % decision_levels explains for each variable that has an
            % assignment (is not zero) at which level that value was
            % assigned
            obj.decision_levels = -ones(1, n_variables);
            
            % As an example, consider partial assignment x1@5 and ~x3@7
            % This would give the following:
            % x1 x2 x3
            % --------
            % 1  0  -1  variable_values
            % 5  0  7   decision_levels
            
            % Initialize the list of literal scores
            % At first, it's just a count of how many times each literal
            % shows up in the expression
            % The list is a 2*n_variables matrix, where the first row is the
            % number of times each atom shows up, and the second row is the
            % number of times each negation of the corresponding atom shows
            % up.
            % For example, if the expression is
            %   x AND
            %   x OR y OR NOT(z))
            % , the literal_scores matrix is
            %   x     y     z
            %   -------------
            %   2     1     0
            %   0     0     1
            obj.literal_scores = zeros(2, n_variables);
            obj.literal_scores(1,:) = sum(obj.expression == 1);
            obj.literal_scores(2,:) = sum(obj.expression == -1);
            
            % The literal scores are used in decide() and updated in
            % add_clause_to_expression() (which is used by
            % analyze_conflict()). 
        end
        
    end
    
end