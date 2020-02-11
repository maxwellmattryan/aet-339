(
x = {
	// argument declarations
	arg freq = 440.0, amp = 0.5;

	// declare variables
	var c_freq, sig;

	// modulate frequency with LFNoise1
	c_freq = freq + LFNoise1.ar(2!4).range(-10, 10);

	// continuously spits out numbers indicating our frequency
	c_freq.poll();

	// apply the frequency to a sawtooth u-gen
	sig = Saw.ar(c_freq, amp);

	// distribute signal evenly amongst signals
	sig = Splay.ar(sig);
}.play();
)



(
y = {
	// argument declarations
	arg freq = 440.0, amp = 0.5;

	// declare variables
	var c_freq, sig, offset;

	// initialize offset variable
	offset = LFNoise2.ar(1!6).range(-0.1, 0.1).midiratio();
	offset.poll();

	// modulate frequency with LFNoise1
	c_freq = freq * offset;
	c_freq.poll();

	// apply the frequency to a sawtooth u-gen
	sig = Saw.ar(c_freq, amp);

	// distribute signal evenly amongst signals
	sig = Splay.ar(sig);
}.play();
)

//=======================================================================================

// SYNTH DEF
(
SynthDef("SawSynth", {

	// argument declarations
	arg freq = 440.0, amp = 0.5;

	// declare variables
	var c_freq, sig, offset;

	// initialize offset variable
	offset = LFNoise1.ar(2!4).range(-0.1, 0.1).midiratio();
	offset.poll();

	// modulate frequency with LFNoise1
	c_freq = freq * offset;
	c_freq.poll();

	// apply the frequency to a sawtooth u-gen
	sig = Saw.ar(c_freq, amp);

	// distribute signal evenly amongst signals
	sig = Splay.ar(sig);

	// define synth def output
	Out.ar(0, sig);

}).add();
)

// SYNTH
Synth.new("SawSynth", [\amp, 0.4, \freq, [55, 110, 220, 550, 600, 700, 880].choose()]);

// ** 3 IMPORTANT THINGS ABOUT SYNTH DEF **
// 1. Provide a name (either symbol or string)
// 2. Add it to the server using .add()
// 3. Route it to the output with Out.ar(bufferIndex, signal)

(
SynthDef("SawSynth", {

	// argument declarations
	arg freq = 440.0, amp = 0.5, gate = 1.0;

	// declare variables
	var c_freq, sig, offset, env;

	// initialize the envelope value
	env = EnvGen.kr(Env.adsr(0.2, 1.2, 0.6, 4), gate, doneAction: 2);

	// initialize offset variable
	offset = LFNoise1.ar(2!4).range(-0.1, 0.1).midiratio();

	// modulate frequency with LFNoise1
	c_freq = freq * offset;

	// apply the frequency to a sawtooth u-gen
	sig = Saw.ar(c_freq, amp) * env;

	// distribute signal evenly amongst signals
	sig = Splay.ar(sig);

	// define synth def output
	Out.ar(0, sig);

}).add();
)

// SYNTH (see below for better iterative method)
(
Synth.new("SawSynth", [\amp, 0.4, \freq, 37.midicps()]);  // A
Synth.new("SawSynth", [\amp, 0.4, \freq, 49.midicps()]);  // A
Synth.new("SawSynth", [\amp, 0.4, \freq, 59.midicps()]);  // G
Synth.new("SawSynth", [\amp, 0.4, \freq, 63.midicps()]);  // B
Synth.new("SawSynth", [\amp, 0.4, \freq, 66.midicps()]);  // D
)

// BASIC ITERATION - do returns the receiver (returns array of midi notes)
(
[37, 49, 59, 63, 66].do({
	arg midiNum;
	Synth.new("SawSynth", [\amp, 0.5, \freq, midiNum.midicps()]);
});
)

// BASIC ITERATION - returns evaluation of last line of method (gives access to synths)
(
z = [37, 49, 59, 63, 66].collect({
	arg midiNum;
	Synth.new("SawSynth", [\amp, 0.5, \freq, midiNum.midicps()]);
});
)

(
z.do({
	arg synth;
	synth.set(\gate, 0.0)
});
)

//======================================================================================

// bass synthesizer
(
SynthDef("Bass", {
	// argument declarations
	arg freq, amp=0.8, gate = 1.0;

	// declare variables
	var sig, offset, env;

	// initialize the envelope value
	env = EnvGen.kr(Env.adsr(0.2, 1.2, 0.6, 4), gate, doneAction: 2);

	// apply the frequency to a sawtooth u-gen
	sig = SinOsc.ar(freq, mul: amp) + SinOsc.ar(freq * 2.0, mul: amp);

	// distribute signal evenly amongst signals
	sig = Splay.ar(sig);

	// define synth def output
	Out.ar(0, sig);
}).add();
)
Synth.new("Bass", [\freq, 37.midicps()]);  // A