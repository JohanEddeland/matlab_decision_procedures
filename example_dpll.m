% First, load all expressions and lists of atoms
[allExpressions, allAtomLists] = loadExamples();

% Now, solve them
for expressionCounter = 1:numel(allExpressions)
    expression = allExpressions{expressionCounter};
    atomList = allAtomLists{expressionCounter};
    
    disp('**********************************');
    fprintf('example_dpll, example %d\n', expressionCounter);
    disp('**********************************');
    
    % First, print the formula
    print_formula(expression, atomList);
    
    for atomCounter = 1:numel(atomList)
        disp(['atom ' num2str(atomCounter) ': ' ...
            atomList{atomCounter} ' - shorthand x' num2str(atomCounter)]);
    end
    
    obj = DPLL(expression, atomList);
    
    % For expressive output, set obj.verbose = 1
    obj.verbose = 1;
    sat = obj.check_sat();
    sol = obj.variable_values;
    
    if sat
        disp('Satisfiable!');
        for k = 1:numel(atomList)
            if sol(k) == 1
                status = 'TRUE';
            else
                status = 'FALSE';
            end
            disp([atomList{k} ': ' status]);
        end
    else
        disp('Unsatisfiable!');
    end
end
