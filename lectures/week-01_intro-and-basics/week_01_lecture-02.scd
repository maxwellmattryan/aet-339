/*
Class Problem for Review
1. Create a function that adds 3 cubed to 4.
2. Declare a local variable basicFunction and use this to store the result of your function.
3. Retrieve the value of the function and print the result when the full block of code is evaluated.
*/

//ANSWER:
(
var basicFunction;
basicFunction = {
	3.cubed + 4;
};
basicFunction.value;
)

//A more effective function:

(
var basicFunction;
basicFunction = {
	arg input; //declare an argument for input
	input.cubed + 4; //this replaces '3'
};
basicFunction.value(3);
)

//More flexibility:
(
var basicFunction;
basicFunction = {
	arg input, offset; //new offset argument
	input.cubed + offset; //this replaces '4' for maximum flexibility
};
basicFunction.value(3, 4);	//notice that you can input values for both the input and the offset separated by a comma
)




//Let's make some noise!

(
~noise = {
	PinkNoise.ar * 0.2;

};
)
~noise.play; //test; (Cmd+. to stop)


//Provide an argument for the amplitude multiplier

(
~noise = {
	arg amp=0.2; //amp is given an initialization value of 0.2
	PinkNoise.ar * amp;

};
)
~noise.play;


//More variables and more intuitive flow to the code
(
~noise = {
	arg amp=0.2;
	var sig; //variable sig declared
	sig = PinkNoise.ar; //set it equal to the UGen 'PinkNoise'
	sig = sig * amp; //now multiply by the amplitude
};
)
~noise.play(args:[\amp, 0.5]); //use this syntax to adjust arguments at play time

//More elegant stop
x = ~noise.play;
x.free; //use the 'free' method to stop the synth on server

//Some of the ways to view sound in SC
s.meter;
s.scope;
FreqScope.new;

//Very useful GUI: change server output volume, boot/quit server, record output, mute, view CPU info, etc.
s.makeGui;



//Back to PinkNoise. Let's put it in stereo:
(
~noise = {
	arg amp=0.2;
	var sig;
	sig = [PinkNoise.ar, PinkNoise.ar]; //SC interprets arrays of sound creation UGens as extra channels
	sig = sig * amp;
};
)
~noise.play(args:[\amp, 0.2]);

//This can also be accomplished using the 'dup' method
PinkNoise.ar.dup;

//Specifying a value to dup will give you more duplication:
PinkNoise.ar.dup(3);

//SuperCollider also has a shortcut for the dup method:
PinkNoise.ar!2; //!2 will accomplish the same goal

