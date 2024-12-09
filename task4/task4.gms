Sets
    i 'nodes' / 1*5 /;
    alias(i,j);

Set
    edges(i,i) / 1.2, 1.3
                 2.3, 2.4, 2.5
                 3.4, 3.5
                 4.5
                 5.3 /;

Parameters
    supply(i) / 1 20
                2 0
                3 0
                4 -5
                5 -15 /;

Table capacity(i,i)
    2   3   4   5
1   15  8   0   0
2   0   inf 4   10
3   0   0   15  5
4   0   0   0   inf
5   0   4   0   0;

Table cost(i,i)
    2   3   4   5
1   40  40  0   0
2   0   20  20  60
3   0   0   10  30
4   0   0   0   20
5   0   10  0   0;

Positive Variable
    vFlow(i,i);

Free Variable
    z;

Equations
    eObj
    eBalNode(i)
    eCapLimit(i,j);



eObj.. z =e= sum((i,j)$edges(i,j), cost(i,j) * vFlow(i,j));

eBalNode(i).. sum(j$edges(j,i), vFlow(j,i)) - sum(j$edges(i,j), vFlow(i,j)) =e= supply(i);

eCapLimit(i,j)$edges(i,j).. vFlow(i,j) =l= capacity(i,j);

Model gas_network / all /;
Solve gas_network using lp minimizing z;