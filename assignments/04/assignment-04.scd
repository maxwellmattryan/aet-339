// Patterns Take-home Wk6

// Matthew Maxwell

// Grade:
// 1.
// 2.
// 3.
// 4.

~grade = [,,,].sum;

// 1. Create a SynthDef using Blip.ar as the main sound source. Be sure to include an envelope using Env.perc, and
// use Pan2 to pan your signal. You should be able to control the following parameters:
// -frequency (freq)
// -amplitude (amp)
// -number of harmonics (nharm)
// -attack and release times (atk, rel)
// -panning (pan)
// Finally, test it

(
~blippy = SynthDef.new("Blip", {
	arg freq = 261.0, amp = 0.5, nharm = 0, atk = 0.01, rel = 0.4, pan = 0.0;
	var env, sig;
	env = EnvGen.kr(Env.perc(atk, rel), doneAction: 2);
	sig = Blip.ar(freq, nharm, amp);
	sig = sig * env;
	Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add();
~blippy.play();
)

// 2. Using your SynthDef from question 1., design a Pbind to create synth events. Your Pbind should address all
// of the controllable parameters from question 1. ... Use a data pattern for each of the parameters (don't hardwire
// values!). For the frequency, nest three data patterns (either Pseq, Prand, or Pxrand) within a Pseq to create a
// sequence of "chord" changes. (Remember there are four ways to address the pitch, and all should still work.) Be
// sure to include a \dur value in your Pbind since this will create the rhythm (it defaults to a slow tick once per
// second). For \dur, use Pwrand to create a system of probabilities for a particular note length to occur.
~pitches = [36, 39, 43, 47, 50] + 5;
(
~randArp = Pbind(
	\instrument, \Gong,
	\dur, Pwrand([0.5, 1.0, 0.75] / 2, [0.6, 0.2, 0.2], inf),
	\midinote, Pseq([Prand(~pitches, 4), Prand(~pitches + 3, 2), Prand(~pitches - 5, 2)], inf),
	\amp, Prand([0.1, 0.3, 0.5, 0.7, 0.9], inf),
	\nharm, Pseq((0..3), inf),
	\rel, Pseq([0.1, 0.2, 0.4, 0.8, 1.6], inf),
	\pan, Pwhite(-1.0, 1.0, inf)
);
~randArp.play();
)

// Also, you might consider using an array of pitches (midi note numbers for instance) to save a bit of typing.
// (Hint: you can use array manipulation methods to change the ordering--like .reverse, .scramble, .mirror, etc.
// to add variety to the way the pitches are ordered. Plus, remember that you can offset the whole array through
// adding or subtracting a number of half-steps.)

// 3. Using the following buffers from the provided "sounds" folder, create a SynthDef to play the sound files.
// (Remember: these are stereo sound files.) Your SynthDef should have the ability to control the following:
// -buffer name (buf)
// -amplitude (amp)

(
~snareL = Buffer.read(s, PathName.new(thisProcess.nowExecutingPath).parentPath ++ "sounds/snare-l.wav");
~snareR = Buffer.read(s, PathName.new(thisProcess.nowExecutingPath).parentPath ++ "sounds/snare-r.wav");
~tomL = Buffer.read(s, PathName.new(thisProcess.nowExecutingPath).parentPath ++ "sounds/tom-l.wav");
~tomR = Buffer.read(s, PathName.new(thisProcess.nowExecutingPath).parentPath ++ "sounds/tom-r.wav");
~gongHard = Buffer.read(s, PathName.new(thisProcess.nowExecutingPath).parentPath ++ "sounds/metal-gong-hard.wav");
~gongSoft = Buffer.read(s, PathName.new(thisProcess.nowExecutingPath).parentPath ++ "sounds/metal-gong-soft.wav");
)

~snareL.play;
~snareR.play;
~tomL.play;
~tomR.play;
~gongHard.play;
~gongSoft.play;


(
SynthDef.new(\Buffer, {
	arg buf, amp = 0.5, rate = 1.0, startPos = 0, pan = 0.0;
	var sig;
	sig = PlayBuf.ar(
		numChannels: 1,
		bufnum: buf,
		rate: BufRateScale.kr(buf) * rate,
		startPos: startPos,
		doneAction: 2
	);
	sig = sig * amp;
	sig = Pan2.ar(in: sig, pos: pan);
	Out.ar(0, sig)
}).add();
)

(
r = Routine.new({
	{
	Synth.new(
	\Buffer,
	[
		\buf, ~gongSoft,
		\amp, exprand(0.5, 1.6),
		\rate, rrand(0.5, 2.0),
		\startPos, rrand(0.0, (~gongSoft.numFrames() * 0.2)),
		\pan, -1.0
	]
);
		[1.0, 1.0, 1.0, 1.0, 0.5, 0.5, 0.5, 0.25].choose().wait();
	}.loop();
}).play();
)

// 4. Create a Pbind to perform and manipulate the drum sounds in a cool pattern. Use a variety of data patterns
// to accomplish this, and make sure that you address each of the controllable parameters from question 3.

(
SynthDef.new(\Sample, {
	arg buf, amp = 0.5, rate = 1.0;
	var sig;
	sig = PlayBuf.ar(
		numChannels: 1,
		bufnum: buf,
		rate: BufRateScale.kr(buf) * rate,
		doneAction: 2
	);
	sig = sig * amp;
	Out.ar(0, sig);
}).add();
)

(
~snare = Pbind(
	\instrument, \Sample,
	\buf, ~snareL,
	\dur, Pseq([Pseq([0.25, 1.5, 0.25], 4), Pwrand([1, 0.5, 0.25], [0.3, 0.5, 0.4], 4)], inf),
	\amp, Pseq([0.2, 0.4, 0.6, 0.8], inf),
	\rate, rrand(0.95, 1.05)
);
~tom = Pbind(
	\instrument, \Sample,
	\buf, ~tomR,
	\dur, Pseq([Pseq([0.5, 0.25, 1.25], 4), Pwrand([1, 0.5, 0.25], [0.6, 0.4, 0.2], 4)], inf),
	\amp, Pseq([0.2, 0.4, 0.6, 0.8], inf),
	\rate, rrand(0.95, 1.05)
);
~snare.play();
~tom.play();
)