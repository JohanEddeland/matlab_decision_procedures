# matlab_decision_procedures
Implementations of different decision procedures in MATLAB. The scripts and functions are algorithms presented in "Decision Procedures" by Daniel Kroening and Ofer Strichman, and they will therefore refer to specific algorithm numberings as shown in the book. 

## Examples
A set of examples are created in the `loadExamples()` function. For each example, the expression is encoded using a matrix, where 1 means True, -1 means False, and 0 means unassigned. They are stated in CNF. As an example, the matrix
```
    [1 0 -1
    0 1 1]
```
corresponds to the formula 
```
(x1 or not(x3)) and
(x2 or x3) 
```

To run these examples for **Lazy-Basic** (Algorithm 3.3.1), run `example_lazy_basic`. 
For **Lazy-CDCL** (Algorithm 3.3.2), run `example_lazy_cdcl`. 
For **DPLL** (Algorithm 3.4.1), run `example_dpll`.

To add or alter examples, just modify the code in `loadExamples()`, e.g. by changing one of the matrices that exist in the functions `load1(), load2(), load3()`, or by creating your own `loadX()` function and making sure that it is called by the main `loadExamples()` function. 

## Brief overview
The different algorithms in the book are implemented as MATLAB classes. They are implemented for equality logic only, so to generalize to other logics would require changing of the atoms used (defined in `loadExamples()`) as well as the deduction functions (e.g. `@DPLL/deduction`). 

The other methods of each class are named similarly to the corresponding algorithms in the book. For example, the method `@CDCL/analyze_conflict` is essentially Algorithm 2.2.2 in the book. Note that there is some spaghetti code in place in this repo - for example, `@CDCL/analyze_conflict` is essentially copy-pasted to `@DPLL/analyze_conflict`, but there may be small inconsistencies. 

The functions and classes work for the included examples (see above for how to run the examples). However, I have not done extensive testing, so there might be special cases that cause the algorithms to crash. Feel free to contact me if you find such special cases. 

