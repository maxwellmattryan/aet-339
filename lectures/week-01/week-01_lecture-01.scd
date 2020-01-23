/* This is a comment */

//This is also a comment

/* Data Types in SuperCollider */



/***** Literals  - Browse the manual for Language/Literals *****/



//Integers (whole numbers with no fractional part)
5
-5
8192
100.class //this is not a decimal digit!

//Floats (number.number - i.e., must have decimal digits on both sides of the dot)
0.5
3.14159
-90.5
100.0.class //digits on both sides of the decimal point allows this

5.  //This will throw an error, because no trailing digit
.5  // ditto, because no leading digit



/* Some things you can do with Integers and Floats, besides simple arithmetic */

5.25.squared
7.reciprocal
15.neg  //flip the sign of this number
11.isPrime //True if this is a prime number, otherwise false+
113.indexOfPrime //this is the 29th prime number
112.prevPrime
114.nextPrime
20.even     //Test if even or odd
21.odd
65536.isPowerOfTwo //True or false
65537.nextPowerOfTwo
10.factorial //computes 10 factorial
150.factors //returns prime factors as an array
13.dup(10) //returns an array of 10 13s
13!10         //ditto

10.do({ arg i; i.postln;}) //do a function 10 times (more on this later)

//convenient conversion methods
60.midicps
440.cpsmidi
4.octcps
72.midicps.cpsoct.round
0.dbamp
0.5.ampdb
0.75.ampdb
-60.dbamp
0.ampdb

//quick random numbers
100.xrand  //return a random number between 0 and 99
100.xrand2 //return a random number between +/- 100

//a few methods for floats only
3.5.round  //rounds to next higher number
3.25.round //rounds to next lower number
3.25.roundUp //force SC to round up
pi.round
1.23456789.round(0.001)
45.1.ceil //next greater integer
45.1.floor //next smaller integer
0.5.coin  //returns true 50% of the time (Floats only)

//For many more, check out the manual for Integer, Float, and SimpleNumber

//Exponential notation is also supported
1.4e4 //moves the decimal point 4 places to the right
2e-2  //moves the decimal point 2 places to the left



//Characters (single letters & numbers preceded by a $)
$A.class  //What are you?
$b
$1

//special characters preceded by a \ (back slash)
$\t //tab
$\n //newline
$\r //return
$\\ //the slash character
$\t.post;$A.post;$\t.post;$B.post;$\n.post;$\t.post;$C.postln;



//Strings (character(s) contained within double quotes)
"Hello!".class  //explain yourself
"2" //not at all the same thing as 2 (an integer)
"Most characters are OK, but a \\ signifies \n something \t special!\n".post
"This
 is
 a
 multiline
 string" //Be sure to select all the lines, then evaluate
"He repeated, \"Madam, I'm Adam,\" only this time he had said it backward." //As in C and Java, backslash ('\') is the escape character. To put a double-quote in the middle of a string, the normal meaning of double-quote must be suspended ("escaped").



//Symbols (character(s) contained within single quotes)
'Hello!'.class  //explain yourself
\Hello.class    //symbols can also be indicated by a preceding backslash
                //but only if they do not contain spaces
\What about this? //throws an error
'What about this?' //OK
\My_Carrier_Frequency //OK
'2'             //not the same as "2" or 2, let alone 2.0
\2              //ditto



//Identifiers (methods and variables)
// ...must begin with a lower case alphabetic character (a-z),
// optionally followed by one or more alphanumric characters.
// The underscore character _ is OK, too.
var amp=1, mod_amp=0.5, sig200, theFundamental ; //all valid variable names



//Class Names (begin with a capital letter, optionally followed by
//one or more alphanumeric characters. Examples:

Synth //these just return themselves, if evaluated
Env
Array
Float
Pan2

// MEMORIZE THESE

// Ctrl + Shift + P = clear the post window
// Ctrl + B = boot the server
// Ctrl + D = help reference for objects
// Ctrl + . = instantaneously stop playback

Server.local.boot();
s.boot;
Server.local.quit();
s.quit;

5.squared();

// perform pink noise at audio rate (ar)
// 0.2 is a scalar (gain multiplier)
{PinkNoise.ar * 0.2}.play();

{5.squared}; // doesn't output 25
{5.squared}.value();

// lowercase variables, like 'x', are understood as 'interpreter variables' and can be
// accessed anywhere in the project (across different files even)
x = {5.squared()};
x.value();

f = 6;
f + 3;
f = f + 3;
f + 3;

// PERSISTENCY - think accessible global variables

myFunc = {5.squared()}; // throws ERROR because it's not defined

// global variables are declared with a '~'
~myFunc = {5.squared()};
~myFunc.value();

// 'var' keyword declares variables as local
var myFunc;
myFunc = {5.squared()};
myFunc.value();

// to initialize it all at once, use parenthesis (use Ctrl + Enter to compile)
(
var myFunc, result;
myFunc = {5.squared()};
result = myFunc.value();
)

// ** inside of a function definition, you can only have < 256 selectors
// 5.squared() > .squared() is a "selector"
// {5.squared()* Array*.kr()*} has 3 selectors indicated by *