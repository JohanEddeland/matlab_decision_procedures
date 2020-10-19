% Examples for Lazy-Basic (Algorithm 3.3.1)

% First, load all expressions and lists of atoms
[allExpressions, allAtomLists] = loadExamples();

% Now, solve them
for expressionCounter = 1:numel(allExpressions)
    expression = allExpressions{expressionCounter};
    atomList = allAtomLists{expressionCounter};
    
    disp('**********************************');
    fprintf('example_lazy_basic, example %d\n', expressionCounter);
    disp('**********************************');
    
    % First, print the formula
    print_formula(expression, atomList);
    
    % Solve satisfiability problem using lazy_basic (which uses the CDCL class)
    [sat, sol] = lazy_basic(expression, atomList);
    
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
