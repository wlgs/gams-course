$ontext

A student participates in a beer drinking contest. The contest
lasts 1 hour. it Takes him 2 minutes to drink one bottle of light
beer and 3 minutes to drink a bottle of lager beer. He gets 4
points for each light beer and 5 points for each lager. How many * bottles of each beer type should a student drink to maximize the
chances to win the contest?

Indicate:
Objective function
Decision variables
Constraints
Write the problem in the following form: max -> f(x,y) = 

$offtext


Sets

b 'beer types' /light, lager/;
 

Parameters


pTimeCost(b) 'time it takes to drink whole beer in minutes'
/
light 2
lager 3
/

pPointsBeerMap(b) 'points acquired for each beer'
/
light 4
lager 5
/

pMaxTime 'Overall time[min]' /60/;


Free variable
vTotalPoints 'total points';

Positive Variables
* DECISION VARIABLE !!!
vBeers(b) 'number of beers of each type that we should drink';

* set a fixed value *
vBeers.fx('lager') = 12

Equations
eObj 'objective function'
eBalTime 'time balance - limit the time we have';


* eObj.. vTotalPoints =e= sum(b,
*         pPointsBeerMap('light') * vBeers('light')
*       + pPointsBeerMap('lager') * vBeers('lager')
* )

eObj.. vTotalPoints =e= sum(b, pPointsBeerMap(b) * vBeers(b));

eBalTime.. sum(b, pTimeCost(b) * vBeers(b)) =l= pMaxTime;

* Model BEER /all/;
* or choose which equations to *
Model BEER 
/
eObj
eBalTime
/;

Solve BEER using LP maximizing vTotalPoints;
