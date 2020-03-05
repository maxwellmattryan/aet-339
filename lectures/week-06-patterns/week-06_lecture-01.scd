// Basic patterns for data

(
p = Pseq(
	list: [1, 2, 3, 4],
	repeats: 3
);
)

// creates a routine as saves it as x
x = p.asStream();

// iterate through the pattern
x.next();

// telling the stream to reset (rather than the sequence)
x.reset();

// returns an array filled with the results of .next() being called N times (30 in this case)
x.nextN(30);

//===========================================================================================

// Pbind are creating collections or sequences of objects that are called events
(
p = Pbind(
	\freq, 1000.0,
	\dur, 1.0,
	\amp, 0.5,
	\sustain, 0.1
).play();
)

// **CAUTION** - This resumes from the same place that it was stopped
p.stop();
p.resume();

// automatically calls to the server's default Synth
p = Pbind().play();

// .class returns whatever things are in the class, in this case an Event
(freq: 261, amp: 0.6, sustain: 1.0).class();

// you do not have to do a .new for synth
Synth.new(\default);
Synth(\default);

(
x = Synth(\default);
x.set(\gate, 0.0);
)

(
p = Pbind(
	\freq, Pseq([100, 200, 300, 400, 500, 600], inf),
	\sustain, 0.1,
	\dur, 0.5
);
x = p.play();
)

// array shorthand
(
a = (1..20) * 100;
p = Pbind(
	\freq, Pseq(a, inf),
	\sustain, 0.1,
	\dur, 0.5
);
x = p.play();
)

// SCALES and DEGREES
(
p = Pbind(
	\scale, Scale.scriabin,
	\degree, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf),
	\sustain, 0.1,
	\dur, 0.01
);
x = p.play();
)

Scale.directory();

// NOTES
(
p = Pbind(
	\note, Pseq((0..11), inf),
	\sustain, 0.1,
	\dur, 0.3
);
)

// MIDI NOTES
(
p = Pbind(
	\midinote, Pseq([60, 62, 64, 67, 69] * 1.01, inf),
	\sustain, 0.1,
	\dur, 0.3
);
x = p.play();
)

// XRAND doesn't play two notes in a row
(
p = Pbind(
	\midinote, Pxrand([60, 62, 64, 67, 69] * 1.01, inf),
	\sustain, 0.1,
	\dur, 0.3
);
x = p.trace().play();
)

// WEIGHTED RANDOMNESS
(
p = Pwrand(
	list: [1, 2, 3],
	weights: [0.1, 0.1, 0.8],
	repeats: inf
);
x = p.asStream();
x.nextN(20);
)

// weighted randomness along an expotential curve like exprand()
(
p = Pexprand(0.1, 0.5, inf);
x = p.asStream();
x.nextN(50);
)

// evenly distribute randomness for patterns like rrand()
(
p = Pwhite(-1.0, 1.0, inf);
x = p.asStream();
x.nextN(50);
)

//===========================================================================================

// patterns with synth def
(
SynthDef.new(\PbindSaw, {
	arg freq = 400.0, atk = 0.1, rel = 1.0, amp = 0.4, out = 0.0;
	var env, sig;
	env = EnvGen.kr(Env.perc(atk, rel), doneAction: 2);
	sig = Saw.ar([freq, freq * 0.2.midiratio()], amp);
	sig = sig * env;
	Out.ar(out, sig);
}).add()
)

Synth(\PbindTest);

// use your own defined synth def
(
p = Pbind(
	\instrument, \PbindSaw,
	\dur, 0.6,
	\scale, Scale.minor(),
	\degree, Pxrand([0, 1, 2, 3, 4, 5, 6, 7, 8, 9], inf),
	\amp, Pexprand(0.1, 0.6),
	\atk, 0.01,
	\rel, 0.5,
	\out, 0
);
x = p.play();
)

x.stop();

//===========================================================================================

(
SynthDef.new(\PbindVarSaw, {
	arg freq = 400.0, atk = 0.1, rel = 1.0, amp = 0.4, out = 0;
	var env, sig;
	env = EnvGen.kr(Env.perc(atk, rel), doneAction: 2);
	sig = VarSaw.ar([freq, freq * 0.2.midiratio()], amp);
	sig = sig * env;
	Out.ar(out, sig);
}).add();
)

// use your own defined synth def
(
p = Pbind(
	\instrument, \PbindVarSaw,
	\dur, 0.2,
	\scale, Scale.locrian,
	\degree, Pxrand([0, 1, 2, 3, 4, 5], inf),
	\amp, Pexprand(0.1, 0.6),
	\atk, 0.01,
	\rel, 0.5,
	\width, Pseq([0.5, 0.6, 0.7, 0.8, 0.9], inf),
	\out, 0
);
x = p.play();
)

x.stop();