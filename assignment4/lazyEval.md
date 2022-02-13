# Lazy Evaluation

The simplest way to explain lazy evaluation is when the compiler waits to evaluation expression until the value of the expression is needed. 

## Why should you care?

Lazy evaluation is huge in functional programming languages like Haskell but a couple of more popular languages use it too like Python and JavaScript. One area you have probably used lazy evaluation before without even knowing it is with the `open()` function in Python. 


## Is it useful?

The opposite implementation of this approach is called strict evaluation, where everything is evaluated immediately. There are a bunch of benefits of using lazy evaluation over strict evaluation.

The first benefit is that it is more efficient. With the compiler only evaluating things as they are used, it is able to save time and resources by skipping over things that will not be used. 

The second benefit is that you can work with infinite lists.

The third benefit is in short-circuiting `if` statements.

testing while something is broken?

## Where does it fall short?

OOP 



# sources 
https://medium.com/background-thread/what-is-lazy-evaluation-programming-word-of-the-day-8a6f4410053f

https://www.seas.upenn.edu/~cis194/fall16/lectures/07-laziness.html

https://en.wikipedia.org/wiki/Lazy_evaluation

https://towardsdatascience.com/what-is-lazy-evaluation-in-python-9efb1d3bfed0


