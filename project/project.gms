$TITLE Line Generation Grid Optimization Model

* Parameters defining game rules and grid characteristics
SCALAR 
    GridSize / 5 / 
    StartInstabilityCapacity / 100 / 
    MaxInstabilityGenerationRate / 0.1 /;

* Sets for grid coordinates and element types
SETS 
    i Grid rows / 1*5 / 
    j Grid columns / 1*5 / 
    ElementType / Hourglass, Diamond, Square, Triangle /;

alias(i,k) 
alias(j,l)

* Adjacency set generation 
SET Adjacent(i,j,k,l);

* Define adjacency conditions 
Adjacent(i,j,k,l) = ((abs(ord(i)-ord(k)) + abs(ord(j)-ord(l)) = 1) and (ord(i) ne ord(k) or ord(j) ne ord(l)));

* Parameters for element characteristics
PARAMETERS 
    LineGeneration(ElementType) / Hourglass 5, Diamond 0, Square 0, Triangle 0 / 
    InstabilityGeneration(ElementType) / Hourglass 3, Diamond -2, Square 0, Triangle 0 / 
    LineGenerationBoost(ElementType) / Hourglass 0.4, Diamond 0, Square 0, Triangle 1.0 / 
    InstabilityGenerationBoost(ElementType) / Hourglass 0.4, Diamond -2, Square 0, Triangle 0.67 /;

BINARY VARIABLE
x(i,j,ElementType) Binary placement of elements

VARIABLES
    TotalLineGeneration Total line generation
    TotalInstabilityGeneration Total instability generation;

FREE VARIABLE
TotalLineGeneration;

* Equations
EQUATIONS 
    ObjectiveFunction 
    InstabilityCapacityConstraint 
    ElementPlacementConstraint
    OneElementPerGridSpaceConstraint
    InstabilityGenerationCalculation;

* Objective: Maximize total line generation
ObjectiveFunction.. 
    TotalLineGeneration =E= SUM((i,j,ElementType), x(i,j,ElementType) * 
        ( LineGeneration(ElementType) * (1 + SUM((k,l)$Adjacent(i,j,k,l), x(k,l,'Triangle') * LineGenerationBoost(ElementType))) ));

* Constraint: Total placed elements cannot exceed grid size squared
ElementPlacementConstraint.. 
    SUM((i,j,ElementType), x(i,j,ElementType)) =L= GridSize * GridSize;

* Constraint: Only one element can be placed in each grid space
OneElementPerGridSpaceConstraint(i,j)..
    SUM(ElementType, x(i,j,ElementType)) =L= 1;

* Constraint: Manage instability generation within capacity
InstabilityCapacityConstraint.. 
    TotalInstabilityGeneration =L= StartInstabilityCapacity * MaxInstabilityGenerationRate;

* Calculate total instability generation with adjacent element effects
InstabilityGenerationCalculation.. 
    TotalInstabilityGeneration =E= SUM((i,j,ElementType), x(i,j,ElementType) * 
        ( InstabilityGeneration(ElementType) * (1 + SUM((k,l)$Adjacent(i,j,k,l), x(k,l,'Hourglass') * InstabilityGenerationBoost(ElementType))) ));

* Model definition
MODEL GridOptimization /ALL/;

* Solve the optimization problem
SOLVE GridOptimization USING MINLP MAXIMIZING TotalLineGeneration;

* Display results
DISPLAY x.L, TotalLineGeneration.L, TotalInstabilityGeneration.L;