$ontext
A farmer produces energy crops i.e. miscanthus willow and poplar. He has 15 acres of land available for their cultivation. Each crop that is planted has certain requirements for labor and capital and brings net profits as depicted in Tab.

The farmer has 400 eur and he has 48 hours available for wokring these crops. How much of each crop he should plant to maximize the rofit

$offtext

Sets
p 'plant types' /miscanthus, willow, poplar/
u 'units' /
labor "labor [hr/acre]"
capital "capital [eur/acre]"
profit "net profit [eur/acre"
/ ;

Parameters

pArea 'Farm area [acres]' /15/
pMoney 'Total money [eur]' /400/ 
pTime 'Total time [hours]' /48/;

Table pCutout(p,u) 'Cutout method table'
                labor capital profit
    miscanthus  6      36      40
    willow      6      24      30
    poplar      2      18      20
    ;


Free variable
vTotalProfit 'maximized profit';


Positive variable
vPlants(p) 'plants that farmer should plant';


Equations

eObj 'objective function'
eBalCapital 'balance capital'
eBalTime 'balance time';

eObj.. vTotalProfit =e= sum(p, vPlants(p)*pCutout(p, 'profit'));

eBalCapital.. sum(p, vPlants(p)*pCutout(p, 'capital')) =l= pMoney;

eBalTime.. sum(p, vPlants(p)*pCutout(p, 'labor')) =l= pTime;

Model FARMER /all/;

Solve FARMER using LP maximizing vTotalProfit;







