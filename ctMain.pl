




% Arrows = [morfs(X1, Y1, [morf1, morf2, ...]), morfs(X1, Y2, [morf1, morf2, morf3, ...])]
%category([], []).
category(Objects, Arrows):-
    length(Objects, L), L>=0,
    coppie(Objects, TutteLeCoppie), %[[X,Y], [X, Y2]]
    maplist(
        {Arrows}/[Coppia]>>(
            Coppia=[Obj1, Obj2],
            Y = arrow(Obj1, Obj2, Morfismi),
            member(Y, Arrows)
        ),
        TutteLeCoppie
    ), 
    maplist(
        {Arrows}/[Obj]>>(
            Y = arrow(Obj, Obj, Morfismi),
            member(Y, Arrows),
            member(Id, Morfismi),
            predIdentita(Obj, Id)
        ), 
        Objects
    ).
        %member(InsiemeMorfismi, Arrows),

predIdentita(Obj, Id):- true.

arrow(X, Y, Morfismi):-
    length(Morfismi, L), L>=0.
    % maplist( , Morfismi)

coppie(Lista, Coppie):-
     findall(Elem, (Elem=[E1, E2], member(E1, Lista), member(E2,Lista)), Coppie).


    
 :-category([1, c, d, [2,3]], [arrow(1, [2,3], [f, g], arrow([2,3], c, [s]).
 s o f 

 comp(M, s, f, sof).

equal(sof, z)

