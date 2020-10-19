function sat = deduction_equality_logic(sol, atoms)
% sol is the solution provided by the SAT solver, e.g. [1 1 -1]
% atoms is a list of the atoms in the logic, e.g.
%   {{'x==y', {'y==z'}, {'x==z'}}

% The above two examples would assign
%   x==y -> TRUE
%   y==z -> TRUE
%   x==z -> FALSE

% First, we create the initial equivalence classes
equivClasses = {};
for k = 1:numel(sol)
    atomsInSol = regexp(atoms{k}, '[a-z]', 'match');
    if sol(k)==1
        equivClasses{end+1} = atomsInSol;
    elseif sol(k)==-1
        equivClasses{end+1} = atomsInSol(1);
        equivClasses{end+1} = atomsInSol(2);
    else
        error('Unhandled case');
    end
end

% Now, merge classes
equivClasses = mergeClasses(equivClasses);

% Finally, check if a disequality exists and the terms are in the same
% equivalence class
sat = 1;
for k = 1:numel(sol)
    if sol(k) == -1
        atomsInSol = regexp(atoms{k}, '[a-z]', 'match');
        for classCounter = 1:numel(equivClasses)
            thisClass = equivClasses{classCounter};
            if any(contains(thisClass, atomsInSol{1})) && any(contains(thisClass, atomsInSol{2}))
                % This equivalence class contains BOTH atoms
                % Thus, it is unsatisfiable. 
                sat = 0;
            end
        end
    end
end

end

function newEquivClass = mergeClasses(equivClasses)
newEquivClass = {};
% Check the first element against all others
firstEquivClass = equivClasses{1};
newEquivClass{end+1} = firstEquivClass;
for k = 2:numel(equivClasses)
    thisClass = equivClasses{k};
    containSameTerm = 0;
    for firstClassCounter = 1:numel(firstEquivClass)
        thisTerm = firstEquivClass{firstClassCounter};
        if any(contains(thisClass, thisTerm))
            % They should be merged!
            containSameTerm = 1;
            
        end
    end
    
    if containSameTerm
        newEquivClass{1} = unique([newEquivClass{1} thisClass]);
    else
        newEquivClass{end+1} = thisClass; %#ok<*AGROW>
    end
end

if isequal(equivClasses, newEquivClass)
    % End of iterations
else
    newEquivClass = mergeClasses(newEquivClass);
end
end