function [allExpressions, allAtomLists] = loadExamples()

[expression1, atoms1] = load1();
allExpressions{1} = expression1;
allAtomLists{1} = atoms1;

[expression2, atoms2] = load2();
allExpressions{2} = expression2;
allAtomLists{2} = atoms2;

[expression3, atoms3] = load3();
allExpressions{3} = expression3;
allAtomLists{3} = atoms3;

end

function [expression1, atoms1] = load1()
% Simple example

%      xy yz xz
expression1 = [1  0  0; % x==y
      1  1  -1]; % y==z or not(x==z) 
atoms1 = {'x==y', 'y==z', 'x==z'};

end

function [expression2, atoms2] = load2()
% Equation (3.1) in the book (page 59)

%     x1x2 x1x3 x1x4
expression2 = [1    1    0;
       1    0    1;
       -1   0    0;
       0    -1   0;
       0    0    -1];
atoms2 = {'x1==x2', 'x1==x3', 'x1==x4'};

end

function [expression3, atoms3] = load3()
% MODIFIED Problem 2.4 in the book
% Instead of just ordinary atoms, we use equalities as atoms. This is to be
% able to check equality logic solvers. 

%      x1 x2 x3 x4 x5 x6
expression3 = [-1 0  1  0  1  0;
       -1 1  0  0  0  0;
       0  -1 0  1  0  0;
       0  0  -1 -1 0  0;
       1  0  0  0  -1 0;
       0  0  0  0  -1 -1;
       1  0  0  0  0  1];
atoms3 = {'x1==x2', 'x1==x3', 'x2==x3', 'x3==x4', 'x1==x4' ,'x4==x5'};

end