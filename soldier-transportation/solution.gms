$ontext
Two battalions of 500 soldiers each stationing in one place are to be transported to the 5 conflicts zones i.e. A-E. They have to be taken all-together at once. There are 15 helicopter, 10 light transportation air-crafts and 5 heavy transportation air-crafts with the following number of soldiers that can be transported: 20, 40 and 80, respectively. Transportation time to the destination is similar for each transport option. The risk that the unit will be shot down is 1, 2 and 3 per soldier transported for helicopter, light and heavy transportation air-crafts, respectively. Because of the topography of the terrain and availability of landing sites the air-forces have to follow the possible connection options indicated in Table 1.1. The number of soldiers to be delivered to respective sites is also indicated in Table 1.1. How these transportation sources should be used to deliver soldiers to the conflict while minimizing the overall transportation risk?

Table 1.1: Acceptable routes and soldier demand
Soldier demands:

Zone A: 400 soldiers
Zone B: 100 soldiers
Zone C: 100 soldiers
Zone D: 300 soldiers
Zone E: 100 soldiers

Possible connections (1 = possible, 0 = not possible):
Helicopter connections:

Zone A: 1
Zone B: 1
Zone C: 1
Zone D: 1
Zone E: 1

Light aircraft connections:

Zone A: 1
Zone B: 1
Zone C: 0
Zone D: 1
Zone E: 0

Heavy aircraft connections:

Zone A: 1
Zone B: 0
Zone C: 0
Zone D: 1
Zone E: 0

$offtext

Sets
    i   "conflict zones"      / A, B, C, D, E /
    v   "vehicle types"       / helicopter, light, heavy /;

Parameters
    pCapacity(v)      "capacity of each vehicle type"
        / helicopter     20
          light         40
          heavy         80 /
    
    pRisk(v)         "risk per soldier for each vehicle type"
        / helicopter     1
          light         2
          heavy         3 /
    
    pVehiclesCapacity(v) "number of available vehicles"
        / helicopter     15
          light         10
          heavy         5 /

    pSoldierDemand(i) "number of soldiers needed at each zone";
    
Set demdata(*,*);

$call csv2gdx soldier-demand.csv output=demand.gdx id=demdata index=1 value=2 useHeader=y
$gdxIn demand.gdx
$load demdata
$gdxIn

pSoldierDemand(i) = sum(demdata$(demdata.te(i.te)), demdata.val);

Table possibleConnections(i,v) "possible connections for each vehicle type to each zone"
            helicopter   light   heavy
    A           1         1       1
    B           1         1       0
    C           1         0       0
    D           1         1       1
    E           1         0       0;

Variables
    X(i,v)     "number of vehicles of type v used for zone i"
    Z          "total risk (objective function)";

Integer Variable X;
Free Variable Z;

Equations
    eObj           "minimize total risk"
    eDemand(i)          "meet soldier demand at each zone"
    eVehicleLimit(v)   "respect vehicle availability";

eObj..
    Z =e= sum((i,v), X(i,v) * pCapacity(v) * pRisk(v));

eDemand(i)..
    sum(v, X(i,v) * pCapacity(v)) =e= pSoldierDemand(i);

eVehicleLimit(v)..
    sum(i, X(i,v)) =l= pVehiclesCapacity(v);

* Add connection restrictions
X.fx(i,v)$(not possibleConnections(i,v)) = 0;

Model military_transport /all/;

Solve military_transport using mip minimizing Z;