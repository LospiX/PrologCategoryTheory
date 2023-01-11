
% Arrows = [arrow(X1, Y1, [morf1, morf2, ...]), 
%       arrow(X1, Y2, [morf1, morf2, morf3, ...]), 
%       arrow(X2, Y1, [morf1, morf2, morf3, ...]), 
% ]
%
%category([], []).
category(Objects, Arrows):-
    length(Objects, L), L>0,
    coppie(Objects, TutteLeCoppie), %[[X,Y], [X, Y2]]
    maplist(
        {Arrows}/[Coppia]>>(
            Coppia=[Obj1, Obj2],
            Y = arrow(Obj1, Obj2, Morfismi),
            length(Morfismi, _),
            member(Y, Arrows)
        ),
        TutteLeCoppie
    ), 
    maplist(
        {Arrows}/[Obj]>>(
            Y = arrow(Obj, Obj, Morfismi),
            member(Y, Arrows),
            member(morf(Obj, Obj, id), Morfismi)
        ), 
        Objects
    ).

coppie(Lista, Coppie):-
     findall(Elem, (Elem=[E1, E2], member(E1, Lista), member(E2,Lista)), Coppie).

arrow(X, Y, Morfismi):-
    length(Morfismi, L), L>=0,
    maplist({X,Y}/[Morf]>>(Morf = morf(X, Y, _)), Morfismi).

% Ogni morf è pensabile come ad una applicazione da dominio a codomio

    

%-%-%
% Come prima formalizzazzione si pensi che una composizione corrisponde
% ad una lista di morfismi
%-%-%
composizione(CatName, Dom, Cod, Comp):- 
	categoria(CatName, CT),
    CT = category(Objs, Arrows),
	member(Dom, Objs), member(Cod, Objs),
	componi(Arrows, Dom, Cod, Comp),
	length(Comp, L), L > 1.

% Nota: *al momento* per evitare di gestire loop infiniti ho escluso le identità
componi(Arrows, Dom, Cod, Comp):- 
    Dom \= Cod,
	member(arrow(Dom, Cod, Morfismi), Arrows),
    member(M, Morfismi), 
    Comp= [M].
componi(Arrows, Dom, Cod, [HMorfs| TMorfs]):-
    %sleep( 1 ), writef("Dom = %t\n", [Dom]),
	member(arrow(Dom, C2, Morfismi), Arrows),
    Dom \= C2,
    member(HMorfs, Morfismi),
	componi(Arrows, C2, Cod, TMorfs).

% Arrows = [arrow(X1, Y1, [morf1, morf2, ...]), 
%       arrow(X1, Y2, [morf1, morf2, morf3, ...]), 
%       arrow(X2, Y1, [morf1, morf2, morf3, ...]), 
% ]
oggettoIniziale(X, CatName):-
    categoria(CatName, Cat),
    Cat = category(Obj, Arrows),
    maplist(
        {Arrows, X, CatName}/[Ob]>>(
            (
                member(arrow(X, Ob, L), Arrows),
                length(L, Len), Len > 0
            ;
                composizione(CatName, X, Ob, _)
            )
        ), 
        Obj
    ).

% Creo una categoria per effettuare test
categoria(catTest, Cat):- 
    Cat = category(
        % Oggetti
        [numeri, parole, [0, 1]],          
        % Arrows 
        [
            arrow(numeri, numeri, [morf(numeri, numeri, id)]),
            arrow(parole, parole, [morf(parole, parole, id)]),
            arrow([0, 1], [0, 1], [morf([0, 1], [0, 1], id)]),
            arrow(numeri, parole, []), 
            arrow(parole, numeri, [morf(parole, numeri, h)]), 
            arrow(numeri, [0, 1], [morf(numeri, [0, 1], f), morf(numeri, [0, 1], g)]),
            arrow([0, 1], numeri,  []),
            arrow(parole, [0, 1], [morf(parole, [0, 1], k)]),
            arrow([0, 1], parole, [morf([0,1], parole, o)])
        ]
    ).


% Righe di test da shell : 
% - composizione(catTest, numeri, parole, Comp). 
% - composizione(catTest, X, Y, Z).
