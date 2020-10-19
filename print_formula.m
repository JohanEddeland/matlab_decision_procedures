function print_formula(expression, atoms)

disp('Formula:');

for row = 1:size(expression, 1)
    varsInRow = find(expression(row,:));
    clause = '(';
    for varCounter = 1:numel(varsInRow)-1
        thisVarIndex = varsInRow(varCounter);
        if expression(row, thisVarIndex) == -1
            clause = [clause '~(' atoms{thisVarIndex} ') v '];
        else
            clause = [clause atoms{thisVarIndex} ' v '];
        end
    end
    lastVarIndex = varsInRow(end);
    if expression(row, lastVarIndex) == -1
            clause = [clause '~(' atoms{lastVarIndex} '))'];
    else
        clause = [clause atoms{lastVarIndex} ')'];
    end
    if row < size(expression, 1)
        clause = [clause ' ^ '];
    end
    
    disp(clause);
end

end