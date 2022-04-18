% question 1

member(_, []) :- false.
member(X, [X | _]).
member(X, [_ | Rest]) :- member(X, Rest).


% question 2

last([], _) :- false.
last([X | _], X).
last([_ | Rest], X) :- last(Rest, X).

% question 3

append(X, [], X).
append([], X, X).
append([X | RestX], Y, [Z | RestZ]) :- append(RestX, Y, RestZ).

% question 4

zip([], [], _).
zip([], _, []).
zip([(X, Y)], [X], [Y]).
zip([(X, Y) | Rest1], [X | RestX], [Y | RestY]) :- zip(Rest1, RestX, RestY).


% question 5

reverse([], X, X).
reverse([X], Y, Z) :- reverse([], Y, [X | Z]).
reverse([X | RestX], Y, Z) :- reverse(RestX, Y, [X | Z]).

reverse([], []).
reverse([_], []) :- false.
reverse([], [_]) :- false.
reverse([X], [X]).
reverse(X, Y) :- reverse(X, Y, []).

% question 6

type(plus(L, R), int) :-
    type(L, int),
    type(R, int).

type(minus(L, R), int) :-
    type(L, int),
    type(R, int).

type(times(L, R), int) :-
    type(L, int),
    type(R, int).

type(divide(L, R), int) :-
    type(L, int),
    type(R, int).

% question 7

type(zerop(X), bool) :-
       type(X, int).

type(lt(X, Y), bool) :-
       type(X, int),
       type(Y, int).


% question 8

type(nil, list(_)).

type(cons(Head, Tail), list(T)) :-
    type(Head, T),
    type(Tail, list(T)).

type(nilp(List), bool) :-
    type(List, list(_)).

type(head(List), T) :-
    type(List, list(T)).

type(tail(List), list(T)) :-
    type(List, list(T)).


% question 9 

type(pair(X, Y), tuple(A, B)) :-
       type(X, A),
       type(Y, B).

type(first(P), T) :-
       type(P, tuple(T, _)).

type(second(P), T) :-
       type(P, tuple(_, T)).

% question 10 

type(name(X), Env, T) :-
     in_env(binding(X, T), Env).

type(plus(L, R), Env, int) :-
    type(L, Env, int),
    type(R, Env, int).

type(minus(L, R), Env, int) :-
    type(L, Env, int),
    type(R, Env, int).

type(divide(L, R), Env, int) :-
    type(L, Env, int),
    type(R, Env, int).

type(times(L, R), Env, int) :-
    type(L, Env, int),
    type(R, Env, int).

type(zerop(X), Env, bool) :-
     type(X, Env, int).

type(lt(X, Y), Env, bool) :-
     type(X, Env, int),
     type(Y, Env, int).

type(nil, list(_)).

type(cons(Head, Tail), Env, list(T)) :-
    type(Head, Env, T),
    type(Tail, Env, list(T)).

type(nilp(List), Env, bool) :-
    type(List, Env, list(_)).

type(head(List), Env,  T) :-
    type(List, Env, list(T)).

type(tail(List), Env, list(T)) :-
    type(List, Env, list(T)).

type(pair(X, Y), Env, tuple(A, B)) :-
       type(X, Env, A),
       type(Y, Env, B).

type(first(P), Env, T) :-
       type(P, Env, tuple(T, _)).

type(second(P), Env, T) :-
       type(P, Env, tuple(_, T)).

% question 11

:- set_prolog_flag(occurs_check, true).

type(invoke(Proc, Arg), Env, Tresult) :-
        type(Proc, Env, func(Targ, Tresult)),
        type(Arg, Env, Targ).

type(proc(Param, Body), Env, func(Tin, Tout)) :-
        type(Body, [binding(Param, Tin) | Env], Tout).
