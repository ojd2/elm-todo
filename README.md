# FP Elm Todo MVC Application

The following source code has been built to be used for an comparative analysis of Elm, TypeScript and CoffeeScript in order to find alternatives to JavaScript for web development. JavaScript, although not by definition, is quickly becoming a flexible assembly language for the World Wide Web. To put it simply, the browser has evolved into a small sophisticated compiler, with the ability to execute commands from a language that is so popular, it's become universal. Essentially, JavaScript is being used everywhere and anywhere it can reside and function within. Subsequently, the World Wide Web provides a vast backdrop for the language to operate within at a very concise low-level. Although the language design of JavaScript has come into question a number of times over the past 10 years, the language has become stretched, shaped and detached from its beginnings and has been an important link in the chain for modern web applications and software. As time went by, web applications grew in complexity and both client side and server side slowly became obfuscated. As a result, the JavaScript ECMA library provided a head start for a number of organically grown languages to use JavaScript as its target language as well as its graphical layout. This opened the door for various languages to target JavaScript by compiling it from another entirely different language. 

Soon, a number of imperative and declarative programming paradigms were integrated into new languages that targeted JavaScript. It provided a way of concatenating, compiling and minifying applications together into one clean and optimised file that could be executed into JavaScript byte code. As a result, these evolutionary practices changed the processes and paradigms of modern web development. What is more, there are now over a 100 languages that target JavaScript. Each language has its own language constructs, all imposing both syntactical and semantic abstractions as well as various type systems all efficiently designed for multiple arrangement across large networks such as the World Wide Web. Many of these languages had a clear goal to try and address many of the weaknesses JavaScript imposes, and reduce paradigm complexity in order to enhance the language definition for a more universal system.

## Dissertation Topic:

With hundreds of new languages compiling to JavaScript and being used throughout various web frameworks and development paradigms, very little has actually been done on analysing and comparing the languages themselves. Therefore, the following dissertation aims to look over three of these languages and to compare and analyse them The dissertation will include a small suite of web applications built in the three languages, along with an evaluation of their strengths and weaknesses. 

Each language will be evaluated and graded using some dimensions. For example, how does the interoperability behave for the language or how easily can the language be learnt and implemented?  Besides this, other constructs of the language design will be evaluated. For example, how has the language type system been designed and expressed? How does the language perform and execute to JavaScript? How much scoping functionality does the language provide? 

The suite of web applications will contain small individual programs of a To Do List application built in the three languages. Reasons for building a To Do List application are because there is enough core functionality to express the languages design and performance without having to look at the explicit design of the languages themselves. It provides just enough for a critical evaluation.

### Chosen Languages:

1. Elm (Elm is a typed and purely functional programming language that compiles to JavaScript)
2. TypeScript (TypeScript is a strict superset of JavaScript that implements a universal type checking system)
3. CoffeeScript (CoffeeScript is an untyped purely functional programming language that compiles to JavaScript)

## Load Commands

Run the following terminal commands from the root of the src folder:                                         
```
elm-make Todo.elm --output elm.js
```