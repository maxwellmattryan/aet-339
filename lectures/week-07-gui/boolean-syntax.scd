//BOOLEAN SYNTAX

//For SC help, see "Control Structures" in the help files

//Also, look at "Syntax Shortcuts" to see the various ways expression can be written.

//Logical Operators:
//number == number (equivalence)
//number > number (greater than)
//number < number (less than)
//number >= number (greater than or equal to)
//number <= number (Less than or equal to)
//boolean && boolean (logical AND)
//boolean || boolean (logical OR)


/******if*******/
//evaluate if the expression is true or false (boolean), and then evaluate either the true or false function in response.

//syntax 1: expr.if (trueFunc, falseFunc);
//AKA, "receiver syntax"
(

x = 0; //set x

(x >= 0).if({"true".postln},{"false".postln}) //test

)

//syntax 2: if (expr) {trueFunc} {falseFunc};
//AKA, "function call syntax"
(

x = 0; //set x

if (x == 0, {"true".postln}, {"false".postln}); //test

)

//syntax 3: if(expr, {trueFunc}, {falseFunc})
//AKA, "function call syntax, with trailing function args"
(

x = 0; //set x

if (x == 0) {"true".postln} {"false".postln}; //test

)




/*********while**********/

//'while' evaluates the body function while the test function is true


//syntax example 1: {testFunc}.while({bodyFunc});
//"receiver syntax"
(

i = 0; //initialize i to 0

{i < 5}.while({i = i + 1; i.postln}); //updates the iteration count (i+1) while i < 5, then returns 'nil'

)


//syntax example 2: while ({testFunc}, {bodyFunc});
//"function call syntax"
(

i = -2;

while ({i < 5}, {i = i + 1; i.postln});

)


//syntax example 3: while {testFunc} {bodyFunc}
//"function call syntax, with trailing function args"
(

i = 0;

while {i < 5} {i = i + 1; i.postln}; //eliminates the need for commas

)


/*********for***********/

//'for' implements iteration over an integer series from a starting value to an end value stepping by one each time. A function is evaluated each iteration and is passed the iterated numeric value as an argument.

//syntax example 1: startValue.for (endValue, {function});
//"receiver syntax"
3.for(7,{arg i; i.postln});

//syntax example 2: for (startValue, endValue, {function});
//"function call syntax"
for (3, 7, {arg i; i.postln});


