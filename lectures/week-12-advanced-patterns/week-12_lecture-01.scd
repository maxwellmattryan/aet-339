(
SynthDef(\tone,{
	arg freq=440, amp=0.1, atk=0.01, rel=0.1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.perc(atk,rel),doneAction:2);
	sig = SinOsc.ar(freq!2);
	sig = sig * env * amp;
	Out.ar(out,sig)
}).add;
)

(
SynthDef(\noise,{
	arg amp=0.2, atk=0.01, rel=0.1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.perc(atk,rel),doneAction:2);
	sig = PinkNoise.ar(amp!2);
	sig = sig * env * amp;
	Out.ar(out,sig)
}).add;
)

Synth(\tone);
Synth(\noise);

(
~tonePatt = Pbindef(\pattern, [
	\instrument, \tone,
	\freq, Pseq([200,300,400,500],inf),
	\amp, 0.1,
	\dur, 1
);

~toneStream = ~tonePatt.play;
)

~toneStream.stop;

// Pbindef
(
Pbindef(\pattern,
	\instrument, \tone,
	\freq, Pseq([200,300,400,500],inf),
	\amp, 0.1,
	\dur, 1
).play(t, quant: 1);
)

Pbindef(\pattern).stop();


// Tempo Clock

TempoClock.default.tempo;
TempoClock.default.beats;

t = TempoClock.new(120 / 60);

t.tempo;
t.stop;

~postBeats = {t.beats.postln};
t.schedAbs(t.nextBar, {~postBeats.value});

// Tempo Clock Trick
~postBeats = {t.beats.postln; 1};
t.schedAbs(0, {~postBeats.value});

(
t = TempoClock.new(120 / 60);
~postBeats = {t.beats.postln; 1};
t.schedAbs(0, {~postBeats.value});
)
