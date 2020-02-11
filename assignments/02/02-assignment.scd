//1. Convert the following function to a SynthDef and test it using Synth:

(
f = {
	arg freq=440, amp=0.1, width=0.5;
	var sig;
	sig = Pulse.ar(freq, width);
}.play;
)

(
SynthDef.new("SynthDefTest", {
	// argument declarations
	arg freq=440.0, gain=0.5, width=0.5;

	// variable declarations
	var sig;
	sig = Pulse.ar(freq: freq, width: width, mul: gain);
	sig = Splay.ar(sig);
}).add();
)

Synth.new("SynthDefTest", [\freq, 220.0, \gain, 0.5, \width, 0.4]);

//Your converted version below:





//2. Fix the errors below:
(
SynthDef.new(sine, {
	// argument
	arg freq;
	var sig;
	sig = SinOsc.ar(freq!2);
	sig = sig * amp;
}).play;
)

Synth.new();



//3. Create a new SynthDef and test it with Synth.

//Include the following:
//-Envelopes controlling env shape and brightness of the sound. (The synths should remove themselves from the server after finishing their envelopes.)
//-Some sort of subtle pitch randomness with multi-channel expansion
//-Stereo signal in the end.







//4. Using your new Synth from question 3, create a Routine that performs your synth as a short chorale (20-30s) using wait times and iteration (do/collect). The iteration used should instantiate multiple synths as chords. Your chord should be stored in an array.





