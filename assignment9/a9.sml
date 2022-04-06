(* question 1 *)

fun countdown num = 
    if num < 0 then []
    else num::countdown(num -1)



(* question 2 *)

fun zip(one, two) =
   if length one = 0
     orelse length two = 0
        then []
   else
     (hd one, hd two)::zip(tl one, tl two)


(* question 3 *)

fun append(one, two) =
   one @ two

(* question 4 *)

fun binaryToNatural(theList) = 
   let 
       fun base10Converter exp = 
          if exp = 0 then 1 else 2 * base10Converter(exp - 1)

       fun adder(currentList, number) =
          if length currentList = 0 then 0
          else
              if hd currentList = 1
                 then base10Converter number + adder(tl currentList, number + 1)
              else
                  adder(tl currentList, number + 1)

   in adder(theList, 0)
   end


(* question 5 *)

fun insertAfterEvery(afterThis, number, theList) = 
   if length theList = 0 then []
   else
      if hd theList = afterThis
          then hd theList::number::insertAfterEvery(afterThis, number, tl theList)
      else
          hd theList::insertAfterEvery(afterThis, number, tl theList)
   

(* PART 2 *)
(* question 6 *)

datatype aexp = Num of int
               | Plus of aexp * aexp
               | Minus of aexp * aexp
               | Times of aexp * aexp
               | Divide of aexp * aexp


(* question 7 (includes the answer to 6) *)
datatype aexp = Num of int
               | Plus of aexp * aexp
               | Minus of aexp * aexp
               | Times of aexp * aexp
               | Divide of aexp * aexp

fun eval_aexp (e): int =
  case e
    of Num n => n
     | Plus (e1, e2) => eval_aexp e1 + eval_aexp e2
     | Minus (e1, e2) => eval_aexp e1 - eval_aexp e2
     | Times (e1, e2) => eval_aexp e1 * eval_aexp e2
     | Divide (e1, e2) => eval_aexp e1 div eval_aexp e2


(* question 8 (includes the answer to 6) *)

datatype aexp = Num of int
               | Plus of aexp * aexp
               | Minus of aexp * aexp
               | Times of aexp * aexp
               | Divide of aexp * aexp

datatype str_exp = String of string
                     | StringConcat of str_exp * str_exp

datatype bool_exp = Not of bool_exp
                  | StringLessThan of str_exp * str_exp
                  | IntLessThan of aexp * aexp
                  | StringEqual of str_exp * str_exp
                  | IntEqual of aexp * aexp


(* question 9 *)

datatype aexp = Num of int
               | Plus of aexp * aexp
               | Minus of aexp * aexp
               | Times of aexp * aexp
               | Divide of aexp * aexp


datatype str_exp = String of string
                     | StringConcat of str_exp * str_exp

datatype bool_exp = Not of bool_exp
                  | StringLessThan of str_exp * str_exp
                  | IntLessThan of aexp * aexp
                  | StringEqual of str_exp * str_exp
                  | IntEqual of aexp * aexp

fun eval_aexp (e): int =
  case e
    of Num n => n
     | Plus (e1, e2) => eval_aexp e1 + eval_aexp e2
     | Minus (e1, e2) => eval_aexp e1 - eval_aexp e2
     | Times (e1, e2) => eval_aexp e1 * eval_aexp e2
     | Divide (e1, e2) => eval_aexp e1 div eval_aexp e2



fun eval_str_exp (exp) = 
                case exp of String s => s
                       | StringConcat(s1, s2) => eval_str_exp s1 ^ eval_str_exp s2


fun eval_bool_exp(exp) = 
   case exp 
          of Not n => not (eval_bool_exp n)
            | StringLessThan (n1, n2) => eval_str_exp n1 < eval_str_exp n2
            | StringEqual (n1, n2) => eval_str_exp n1 = eval_str_exp n2
            | IntLessThan (n1, n2) => eval_aexp n1 < eval_aexp n2
            | IntEqual (n1, n2) => eval_aexp n1 = eval_aexp n2

(* explicit type way is bad *)


(* question 10 *)

datatype dsexp = Num of int
               | Plus of dsexp * dsexp
               | Minus of dsexp * dsexp
               | Times of dsexp * dsexp
               | Divide of dsexp * dsexp
               | String of string
               | Not of dsexp
               | StringLessThan of dsexp * dsexp
               | IntLessThan of dsexp * dsexp
               | StringConcat of dsexp * dsexp
               | StringEqual of dsexp * dsexp
               | IntEqual of dsexp * dsexp



(* question 11 *)

datatype value = NumV of int
               | StringV of string
               | BoolV of bool
               | ErrorV

datatype dsexp = Num of int
               | Plus of dsexp * dsexp
               | Minus of dsexp * dsexp
               | Times of dsexp * dsexp
               | Divide of dsexp * dsexp
               | String of string
               | Not of dsexp
               | StringLessThan of dsexp * dsexp
               | IntLessThan of dsexp * dsexp
               | StringConcat of dsexp * dsexp
               | StringEqual of dsexp * dsexp
               | IntEqual of dsexp * dsexp



fun eval_dsexp e =
  case e
    of Num n => NumV n
     | Plus (d1, d2) => (case (eval_dsexp d1, eval_dsexp d2)
                           of (NumV n1, NumV n2) => NumV (n1 + n2)
                            | _ => ErrorV)
     | Minus (d1, d2) => (case (eval_dsexp d1, eval_dsexp d2)
                           of (NumV n1, NumV n2) => NumV (n1 - n2)
                            | _ => ErrorV)
     | Times (d1, d2) => (case (eval_dsexp d1, eval_dsexp d2)
                           of (NumV n1, NumV n2) => NumV (n1 * n2)
                            | _ => ErrorV)
     | Divide (d1, d2) => (case (eval_dsexp d1, eval_dsexp d2)
                           of (NumV n1, NumV n2) => NumV (n1 div n2)
                            | _ => ErrorV)



     | String s => StringV s

     | Not d => (case eval_dsexp d
                   of BoolV b => BoolV (not b)
                    | _ => ErrorV)

     | StringLessThan (d1, d2) =>
       (case (eval_dsexp d1, eval_dsexp d2)
         of (StringV s1, StringV s2) => BoolV (s1 < s2)
          | _ => ErrorV)


     | StringEqual (d1, d2) =>
       (case (eval_dsexp d1, eval_dsexp d2)
         of (StringV s1, StringV s2) => BoolV (s1 = s2)
          | _ => ErrorV)


     | StringConcat (d1, d2) =>
       (case (eval_dsexp d1, eval_dsexp d2)
         of (StringV s1, StringV s2) => StringV (s1 ^ s2)
          | _ => ErrorV)



     | IntLessThan (d1, d2) => (case (eval_dsexp d1, eval_dsexp d2)
                                  of (NumV n1, NumV n2) => BoolV (n1 < n2)
                                   | _ => ErrorV)

     | IntEqual (d1, d2) => (case (eval_dsexp d1, eval_dsexp d2)
                                  of (NumV n1, NumV n2) => BoolV (n1 = n2)
                                   | _ => ErrorV)

