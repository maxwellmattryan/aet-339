/*
Class Problem for Review
1. Create a function that adds 3 cubed to 4.
2. Declare a local variable basicFunction and use this to store the result of your function.
3. Retrieve the value of the function and print the result when the full block of code is evaluated.
*/

// hardcoded values
(
var basicFunction;
basicFunction = {
	3.cubed() + 4;
};
basicFunction.value();
)

// using arguments
(
var basicFunction;
basicFunction = {
	arg input;
	input.cubed() + 4;
};
basicFunction.value(4);
)

// using arguments but more effective
(
var basicFunction;
basicFunction = {
	arg toBeCubed, toBeAdded;
	toBeCubed.cubed() + toBeAdded;
};
basicFunction.value(6, 13);
)

// MONO

// making noise
(
~noise = {
	arg gain=1.0;
	var signal;
	signal = PinkNoise.ar();
	signal = signal * gain;
};
)
~noise.play(args: ['gain', 0.5]);

// use Ctrl + M to bring up the meter

// STEREO

// making noise
(
~noise = {
	arg gain=1.0;
	var signal;
	//signal = [PinkNoise.ar(), PinkNoise.ar()];
	//signal = PinkNoise.ar().dup(2);
	//signal = PinkNoise.ar()!2;
	signal = signal * gain;
};
)
~noise.play(args: ['gain', 0.5]);

