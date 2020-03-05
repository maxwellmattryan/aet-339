(
SynthDef(\sine, {
	arg freq=440, amp=0.5, pan=0, atk=0.01, sus=0.5, rel=2, gate=1, out=0;
	var sig, env, freqOffset;
	freqOffset = LFNoise1.kr(1).range(1.001, 1.05);
	env = EnvGen.kr(Env.asr(atk, sus, rel), gate);
	sig = SinOsc.ar([freq, (freq * freqOffset)]);
	sig = Pan2.ar(sig, pan);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add();
)

// shorthand for setting gate to 0.0
~sine.release();

//============================================================================

// initialize and configure a new window from the Window class
(
~width = 540.0;
~height = 360.0;

~sine.free();
~sine = Synth(\sine, [\gate, 0.0, \amp, 0.5]);

w.close();

w = Window.new(
	name: "MusicMachine",
	bounds: Rect.new(0, 0, ~width, ~height),
	resizable: true
);

// lavender = (0.4683, 0.5079, 0.7778)
// blue = (0.3688, 0.50 22, 0.7317)
// light green = (0.6211, 0.8871, 0.6183)
~lavender = Color.new(0.4683, 0.5079, 0.7778, 1.0);
~blue = Color.new(0.3688, 0.5022, 0.7317, 1.0);
~lightGreen = Color.new(0.6211, 0.8871, 0.6183, 1.0);

w.front();
w.view.background_(~lightGreen);

~sl = Slider.new(w, Rect.new(50, 50, ~width / 8, ~height / 2))
.action_({
	arg sl;
	~sine.set(\amp, sl.value() * 0.5);
})
.value_(1.0)
.background_(~lavender);

~btn = Button.new(w, Rect.new(200, 50, 70, 70))
.action_({
	arg btn;
	~sine.set(\gate, btn.value());
})
.states_([
	["OFF", Color.black()],
	["ON", Color.black(), Color.green()]
]);
)

// shortcut for closing up a fuckton of windows
Window.closeAll();