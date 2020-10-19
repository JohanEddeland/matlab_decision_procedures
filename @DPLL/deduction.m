function [t, sat] = deduction(obj)
% sol is the solution provided by the SAT solver, e.g. [1 1 -1]
% atoms is a list of the atoms in the logic, e.g.
%   {{'x==y', {'y==z'}, {'x==z'}}

% The above two examples would assign
%   x==y -> TRUE
%   y==z -> TRUE
%   x==z -> FALSE

% First, we create the initial equivalence classes
equivClasses = {};
sol = obj.variable_values; % Given solution
for k = 1:numel(sol)
    atomsInSol = regexp(obj.atoms{k}, '[a-z]', 'match');
    if sol(k)==1
        5;
        equivClasses{end+1} = atomsInSol;
    elseif sol(k)==-1
        equivClasses{end+1} = atomsInSol(1);
        equivClasses{end+1} = atomsInSol(2);
    else
        % error('Unhandled case');
    end
end

% Now, merge classes
if isempty(equivClasses)
    sat = Inf; % Not used
    t = true;
    return
else
    equivClasses = mergeClasses(equivClasses);
end

% Finally, check if a disequality exists and the terms are in the same
% equivalence class
sat = 1;
for k = 1:numel(sol)
    if sol(k) == -1
        atomsInSol = regexp(obj.atoms{k}, '[a-z]', 'match');
        for classCounter = 1:numel(equivClasses)
            thisClass = equivClasses{classCounter};
            if any(contains(thisClass, atomsInSol{1})) && any(contains(thisClass, atomsInSol{2}))
                % This equivalence class contains BOTH atoms
                % Thus, it is unsatisfiable. 
                sat = 0;
                t = -sol;
                return
            end
        end
    end
end

% If we reach here, sat is true (the assigned variables are satisfiable)
% TODO: Implement a function that checks what we can imply from the
% given assignment and returns those implications as t.
% Idea: For each atom with value 0 (unassigned), check which two
% variables it contains. Can we find those in the same equivClass? Then
% the atom should have value 1. Two different equivClasses? Should have
% value -1. One or both missing from equivClasses? Unknown!
5;
impliedClauses = getImpliedClauses(obj, equivClasses);

if isempty(impliedClauses)
    t = true;
else
    t = impliedClauses;
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

function impliedClauses = getImpliedClauses(obj, equivClasses)

% For each atom with value 0 (unassigned), check which two
% variables it contains. Can we find those in the same equivClass? Then
% the atom should have value 1. Two different equivClasses? Should have
% value -1. One or both missing from equivClasses? Unknown!
sol = obj.variable_values(); % Given solution
impliedClauses = [];

% Look at all variables with value 0 (unassigned)
for var = find(sol == 0)
    atomsInSol = regexp(obj.atoms{var}, '[a-z]', 'match');
    atom1 = atomsInSol{1};
    atom2 = atomsInSol{2};
    
    % Find the equivClass of each atom
    class1 = getEquivClassOfAtom(equivClasses, atom1);
    class2 = getEquivClassOfAtom(equivClasses, atom2);
    
    % If any class is 0 - one or both atoms are missing from equivalence
    % classes, we cannot assert anything.
    if class1 == 0 || class2 == 0
        % Do nothing
    else
        % Add to impliedClauses
        thisVarVal = (class1 == class2);
        thisImpliedClause = -obj.variable_values;
        
        
        if class1 == class2
            % If both atoms are in the same equivalence class, set this
            % variable's value to 1
            thisImpliedClause(var) = 1;
        else
            % Otherwise, set it to -1
            thisImpliedClause(var) = -1;
        end
        
        % Add this clause to impliedClauses
        impliedClauses(end+1, :) = thisImpliedClause;
        5;
    end
end

end

function equivClassIndex = getEquivClassOfAtom(equivClasses, atom)
% Returns the equivalence class in which the atom exists
% Returns 0 iff atom does not exist in any equivalence class

for classCounter = 1:numel(equivClasses)
    thisClass = equivClasses{classCounter};
    if any(contains(thisClass, atom))
        equivClassIndex = classCounter;
        return
    end
end

% We did not find any equivalence class for atom - return 0
equivClassIndex = 0;
return

end