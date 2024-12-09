Sets
i 'node index' /1*3/
;
alias(i,j);

Set
branch(i,j)
/
1.2
1.3
2.3
/;

*branch(j,i)$branch(i,j) = YES
set
branch1(j,i)
/
1.2
2.3
1.3
/
;
Parameter

pNetSupply(i) 'Net Supply in the node'
/ 1 20,  3 -20/;

Positive Variable

vFlow(i,j)
;

Free Variable
h;


* flow out of node - flow into node = net supply in node
Equations
eObj
eBalNode(i);
*Eq_1
*Eq_2
*Eq_3;

eObj.. h =E= 1;
eBalNode(i).. sum(j$branch(i,j),vFlow(i,j)) - sum(j$branch1(j,i), vFlow(j,i)) =E= pNetSupply(i);


*Eq_1.. vFlow('1', '2') + vFlow('1', '3') =E=  pNetSupply('1');

*Eq_2.. vFlow('2', '3') - vFlow('1', '2') =E= pNetSupply('2');

*Eq_3.. -vFlow('1', '3') - vFlow('2', '3') =E= pNetSupply('3');


Model GRID_3 /all/
Solve GRID_3 using LP minimizing h;