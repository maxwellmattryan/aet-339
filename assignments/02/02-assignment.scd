// 1. Convert the following function to a SynthDef and test it using Synth:

(
f = {
	arg freq=440, amp=0.1, width=0.5;
	var sig;
	sig = Pulse.ar(freq, width);
}.play;
)

// Your converted version below:

(
SynthDef.new("SynthRefactor", {
	// argument declarations
	arg freq = 440.0, ampl = 0.1, width = 0.5;

	// variable declarations
	var sig;
	sig = Pulse.ar(freq: freq, width: width, mul: ampl);
	sig = Splay.ar(sig);

	// send to output
	Out.ar(0, sig);

}).add();
)

Synth.new("SynthRefactor", [\freq, 220.0, \ampl, 0.5, \width, 0.4]);

//==============================================================================

// 2. Fix the errors below:

(
SynthDef.new("SinOsc", {
	arg freq = 440.0, amp = 0.5;
	var sig;
	sig = SinOsc.ar(freq: freq);
	sig = sig * amp;
	Out.ar(0, sig);
}).add();
)

Synth.new("SinOsc", [\freq, 230.0, \amp, 0.6]);

//==============================================================================

// 3. Create a new SynthDef and test it with Synth.

// Include the following:
// - Envelopes controlling amplitude and brightness (** MAKE SURE TO REMOVE FROM NODE TREE **)
// - Some sort of subtle pitch randomness with multi-channel expansion
// - Send to stereo output

(
SynthDef.new("IDK", {
	// argument and variable declarations
	arg freq = 440.0, amp = 0.5;
	var envAmpl, envWidth, freqOffset, sig;

	// initialize envelopes for amplitude and sawtooth width
	envAmpl = EnvGen.kr(Env.perc(attackTime: 0.01 , releaseTime: 2.4), doneAction: 2);
	envWidth = EnvGen.kr(Env.new([0.5, 1.0, 0.75, 0.5], [0.4, 0.2, 0.8], \lin));

	// implement multi-channel expansion to add subtle pitch discrepancies (multiply by random value close to 1.0)
	freq = freq * LFNoise1.ar(2!6).range(-0.1, 0.1).midiratio();

	// calculate signal values
	sig = VarSaw.ar(freq: freq, mul: amp, width: envWidth) * envAmpl;

	// distribute signal evenly amongst L/R and send to output
	sig = Splay.ar(sig);
	Out.ar(0, sig);

}).add();
)
Synth.new("IDK", [freq: rrand(110.0, 220.0), 0.4]);

//==============================================================================

// 4. Using your new Synth from question 3, create a Routine that performs your synth as a short chorale (20-30s)
// using wait times and iteration (do/collect). The iteration used should instantiate multiple synths as chords.
// Your chord should be stored in an array.

(
Routine.new(
{
	// b min9 chord with open voice (B, F#, D, A, C#)
	~pitches = [35, 42, 50, 57, 61];

	// iterate through and increment pitch values each time
	{
		// instantiate synths for each note in new pitch collection
		~pitches.do(
		{
				arg note;
				Synth.new(
					"IDK",
					[
						freq: note.midicps(),
						amp: 0.6
					]
				);

				// for arpeggiation effect
				rrand(0.08, 0.12).wait();
		});

		// just wait a damn second (after incrementing pitches)
		~pitches = ~pitches + 2;
		1.wait();

	}.loop();

}).play();
)