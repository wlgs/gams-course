Sets
    i  nodes   / 1*3 /
    g  generators / G1, G2, G3 /
;

Parameters
    pDemand(i)  electricity demand at each node  / 1 50, 2 0, 3 150 /
    pPowerLimit(i,g)  power limit for each branch
    /
    1.G1 100, 2.G1 100, 3.G1 200,
    3.G2 50, 3.G3 50,
    1.G2 100, 1.G3 100
    /
    pGenCap(g)  generator capacity  / G1 100, G2 50, G3 100 /
    pGenAvail(g)  generator availability  / G1 1, G2 0.5, G3 0.75 /
    pGenCost(g)  generation cost  / G1 40, G2 5, G3 5 /
;

Variables
    vFlow(i,g)  power flow from generator g to node i
    vTotalCost       total system cost
;

Positive Variables vFlow;

Equations
    eBalLoad(i)  balance electricity demand and supply at each node
    eGenLimit(g)     limit power generation to available capacity
    eFlowLimit(i, g) limit flow
    eObj        minimize total system cost
;

eBalLoad(i)..  sum(g, vFlow(i,g)) =e= pDemand(i);
eGenLimit(g)..     sum(i, vFlow(i,g)) =l= pGenCap(g) * pGenAvail(g);
eFlowLimit(i,g)..   vFlow(i,g) =l= pPowerLimit(i,g);
eObj..        vTotalCost =e= sum((i,g), vFlow(i,g) * pGenCost(g));

Model power_system / all /;
Solve power_system using LP minimizing vTotalCost;

Display vFlow.l, vTotalCost.l;