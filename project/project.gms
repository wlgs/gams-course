option limRow=9999;


SCALAR 
    sGridSize / 3 / 
    sStartInstabilityCapacity / 100 / 
    sStartInstabilityGenerationRate / 0.1 /;

SETS 
    i Grid rows / 1*3 / 
    j Grid columns / 1*3 / 
    ElementType / Hourglass, Diamond, Square, Triangle /;

alias(i,k) 
alias(j,l)

SET Adjacent(i,j,k,l);

Adjacent(i,j,k,l) = ((abs(ord(i)-ord(k)) + abs(ord(j)-ord(l)) = 1) and (ord(i) ne ord(k) or ord(j) ne ord(l)));

PARAMETERS 
    pLineGeneration(ElementType) / Hourglass 5, Diamond 0, Square 0, Triangle 0 / 
    pInstabilityGeneration(ElementType) / Hourglass 3, Diamond 0, Square 0, Triangle 0 / 
    pLineGenerationBoost(ElementType) / Hourglass 0.4, Diamond 0, Square 0, Triangle 1 / 
    pInstabilityGenerationBoost(ElementType) / Hourglass 0.4, Diamond 0, Square 0, Triangle 0.67 /;

BINARY VARIABLE
x(i,j,ElementType) Binary placement of elements

VARIABLES
    vTotalLineGeneration Total line generation
    vTotalInstabilityGeneration Total instability generation;

FREE VARIABLE
vTotalLineGeneration;

EQUATIONS 
    eObjectiveFunction 
    eInstabilityCapacityConstraint 
    eElementPlacementConstraint
    eOneElementPerGridSpaceConstraint
    eInstabilityGenerationCalculation;

* Objective: Maximize total line generation
eObjectiveFunction.. 
    vTotalLineGeneration =E= SUM((i,j,ElementType), x(i,j,ElementType) * 
        ( pLineGeneration(ElementType) * (1 + SUM((k,l)$Adjacent(i,j,k,l), x(k,l,'Triangle') * pLineGenerationBoost(ElementType))) ));

* Constraint: Total placed elements cannot exceed grid size squared
eElementPlacementConstraint.. 
    SUM((i,j,ElementType), x(i,j,ElementType)) =L= sGridSize * sGridSize;

* Constraint: Only one element can be placed in each grid space
eOneElementPerGridSpaceConstraint(i,j)..
    SUM(ElementType, x(i,j,ElementType)) =E= 1;

* Constraint: Manage instability generation within capacity
eInstabilityCapacityConstraint.. 
    vTotalInstabilityGeneration =L= sStartInstabilityCapacity * sStartInstabilityGenerationRate;

* Calculate total instability generation with adjacent element effects
eInstabilityGenerationCalculation.. 
    vTotalInstabilityGeneration =E= SUM((i,j,ElementType), x(i,j,ElementType) * 
        ( pInstabilityGeneration(ElementType) * (1 + SUM((k,l)$Adjacent(i,j,k,l), x(k,l,'Hourglass') * pInstabilityGenerationBoost(ElementType))) ));

MODEL GridOptimization
/
eObjectiveFunction 
eInstabilityCapacityConstraint 
* eElementPlacementConstraint
eOneElementPerGridSpaceConstraint
eInstabilityGenerationCalculation

/;

SOLVE GridOptimization USING MINLP MAXIMIZING vTotalLineGeneration;

DISPLAY x.L, vTotalLineGeneration.L, vTotalInstabilityGeneration.L