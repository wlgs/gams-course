* GAMS documentation: https://www.gams.com/32/docs/

Sets

* TIP: sets should be rather just one letter

g 'set of power generators' /G1, G2, G3, G4, G5/
    s(g) 'subset of photovoltaic generators' /G3, G5/
    
d 'set of power demand points' /D1, D2, D3/

t 'hours of the day' /1*24/;

Parameters

* TIP: start with 'p' to indicate it is a parameter

pPowerGen(g) 'the possible power generation of elements of the set g [MW]'
/
G1 100
G2 80
G3 50
G4 100
G5 40
/



pPowerDem(d) 'the power required for elements of the set d [MW]'
/
D1 50
D2 75
D3 150
/;

* TIP: other syntax pPowerDem('D3')=150;

display pPowerDem

Scalar
pUnitPriceElectr 'unit electricity price in Europe [EUR/MWh]' /285/;

Table pGenCF(t,g) 'hourly capacity factor of generators in a given hour'
    G2      G3
1   1.0     0.0
2   1.0     0.0
3   1.0     0.0
4   1.0     0.1
5   1.0     0.2
;


