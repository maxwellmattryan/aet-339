/*
Class Problem for Review
1. Create a function using PinkNoise in stereo
2. Declare a user-defined global variable called noise.
3. Declare a local argument ('amp') and a local variable ('sig') and use amp to scale the signal of the PinkNoise.
4. Play the function using the .play method, and define the amplitude as 0.05 at runtime.
*/

/*(
~noise = {
	arg amplitude=1.0;

	var signal;
	signal = [PinkNoise.ar(), PinkNoise.ar()];
	signal = signal * amplitude;
};
)*/

~noise.play(args: [\amplitude, 0.6]);

// WEEK 02 LECTURE 01 | 01-28-2019

s.meter();
s.scope();

{SinOsc.ar() * 0.5}.play();

(
~noise = {
	arg amplitude=0.2;

	var signal;
	signal = PinkNoise.ar().dup(2);
	signal = signal * amplitude;
}
)

x = ~noise.play(args: [\amplitude, 0.5]);
x.set(\amplitude, 0.5);
x.free(); // deletes object from node tree

(
~noise = {
	arg amplitude=0.2;

	var signal;
	signal = PinkNoise.ar(amplitude).dup(2);
}
)

// OTHER UGENS

SinOsc
Pulse
Saw
WhiteNoise
PinkNoise

(
~sound = {
	arg amplitude=0.2, freqLow=110, freqHi=880

	var signal;
	signal = SinOsc.ar(MouseX.kr(freqLow, freqHi), 0.0, MouseY.kr(0.0, 1.5)).dup(2);
};
)

~sound.play(args: [\amplitude, 0.6, \freqLow, 220, \freqHi, 22000]);

{SinOsc.ar(100)}.plot(1);
{SinOsc.ar(100)}.plot(0.01);

Window.closeAll();

// ENVELOPES defined with Env class

(
~sharp = Env.new(
	[0, 1, 0], // breaking points in x axis
	[1, 1],    // interval between corresponding breaking points
	\lin,
);
)

~sharp.plot();

(
~other = Env.new(
	[0, 1, 0.5, 0.1],
	[0.05, 1, 2],
	\lin
);
)

~other.plot();

(
x = {
	var sig, env;

	env = EnvGen.kr(Env.new([0, 1, 0.5, 0.1], [0.05, 1, 2], \lin));
	sig = PinkNoise.ar().dup();
	sig = BPF.ar(sig, 1000.0, 0.3, 1.0);
	sig = sig * env;
};
)

x.play();

