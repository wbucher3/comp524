# Why Object Oriented Programming Deserves Less 

Object oriented programming is the type of programming where all information is stored in objects and they are manipulated through methods declared in their respected class. Coding in this way has become very popular, however, the modern implementation of it has some major downfalls. 

## Too Many Layers 

In order to write good object orientated code, there is a lot of overhead learning you need to do first! Concepts like abstraction, inheritance, encapsulation, polymorphism, and tons of design patterns are all things object orientated developers need to know just to begin. There is so much to learn about getting started with it that UNC's computer science core requirements includes a class specifically for learning it all, COMP301 (formally COMP401). 

## Unneeded Complexity 

When using an object orientated programming language, it will required you to spread out your code over multiple files. For example, in Java, you need to create a project which has an SRC directory in it. Then within the SRC directory, you need to make packages. Then inside of the packages, you can create java files, but you may only have one class per file. If you are writing a simple program, this added complexity feels totally ridiculous. 

```
Project Folder
|-- src
	|-- packageName
			|-- main.java
			|-- OtherClass.java
			|-- AnotherClass.java
```

### Poor Readability
. Spreading the code out over multiple files makes the code much more difficult to read and will much longer to understand what is happening. 

### Harder to debug

have fun with that debugger, walking through your problem. unit testing is better

### Over-Engineered Solutions 
This can lead to over engineering of simple solutions because the developer will be so focused on object orientated concepts and filling these files out instead of just writing a solution to the problem.


## State Management

### Mutable State

### Hard to Test


### Concurrency 
With the state being everywhere, it is hard to write multithread programs without using complex things like locks. Functional programming pushes the developer to write pure functions which can be computed concurrently with other pure functions because they do not change the state of the program. 


Lastly, I will leave you with a quote from a pioneer in computer science that always knows the correct path to take.


> Object oriented programs are offered as alternatives to correct ones…
> 
>  ---Edsger W. Dijkstra

## Sources 

https://betterprogramming.pub/object-oriented-programming-the-trillion-dollar-disaster-92a4b666c7c7

