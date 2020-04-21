// Monophonic "blip" synth using Dust.kr
(
SynthDef(\blip, {
	arg dens = 2, out = 0;
	var freq, trig, sig, pan = 0.0;

	freq = LFNoise0.kr(3).exprange(300, 1200).round(300);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(dens);

	sig = sig * EnvGen.kr(Env.perc(0.01, 0.2), trig);

	sig = Pan2.ar(sig, LFNoise1.kr(10));

	Out.ar(out, sig);
}).add();
)

Synth(\blip, [\dens, 0.5]);

// Reverb
(
SynthDef.new(\reverb, {
	arg in, out = 0;
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, mix: 0.5, room: 0.5, damp: 0.2);

	Out.ar(out, sig);
}).add();
)

// Supercollider calculates DSP from the top to the bottom of whatever elements are in the node tree. If a UGen uses input from somewhere else in the program / computer, then its signal needs to be calculated after the others. But you can take care of this with addAction = 'addToTail'

// make sure the out argument is outside the range of available hardware
x = Synth.new(\reverb, [\in, 6]);
y = Synth.new(\blip, [\out, 6]);

x.free();
y.free();

~reverbBus = Bus.audio(s, 2);
~reverbBus.index;

x = Synth.new(\reverb, [\in, ~reverbBus], s, addAction: 'addToTail');
y = Synth.new(\blip, [\out, ~reverbBus]);

// Groups
// Superclass: Node
// Subclasses:
// 1. Synth
// 2. Group

// Use groups to ensure that things get instantiated / loaded in the proper order
(
~synthGroup = Group.new();
~fxGroup = Group.new(s, addAction: 'addToHead');
)

x = Synth.new(\reverb, [\in, ~reverbBus], ~fxGroup);
y = Synth.new(\blip, [\out, ~reverbBus], ~synthGroup);

(
10.do {
	Synth.new(\blip, [\dens, 0.25, \out, ~reverbBus], ~synthGroup);
};
)

~synthGroup.set(\dens, 0.5);
~synthGroup.freeAll();