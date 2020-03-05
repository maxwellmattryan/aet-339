//make a basic window
(
w = Window.new;
w.front;
)

Window.closeAll;

(
w.close;
w = Window.new("Music Machine", Rect.new(1500,200,400,400));
w.front;
w.view.background_(Color.grey);
)


//add a slider
(
w.close;
w = Window.new("Music Machine", Rect.new(1500,200,400,400));
w.front;
w.view.background_(Color.grey);
~sl = Slider.new(w, Rect.new(50, 50, 50, 150));
)


(
w.close;
w = Window.new("Music Machine", Rect.new(1500,200,400,400));
w.front;
w.view.background_(Color.grey);
~sl = Slider.new(w, Rect.new(50, 50, 50, 150))
.action_({
	arg sl;
	sl.value.postln;
})
.value_(1)
.background_(Color.new255(176,48,96));
)



(
w.close;
w = Window.new("Music Machine", Rect.new(1500,200,400,400));
w.front;
w.view.background_(Color.grey);

~sl = Slider.new(w, Rect.new(50, 50, 50, 150))
.action_({
	arg sl;
	sl.value.postln;
})
.value_(1)
.background_(Color.new255(176,48,96));

~btn = Button.new(w, Rect.new(200,100,50,50))
.action_({
	arg btn;
	btn.value.postln;
})
.states_([
	["OFF",Color.black,Color.red],
	["ON",Color.black,Color.green]
]);
)

//Our SynthDef. We'll need this later...
(
SynthDef(\sine, {
	arg freq=440, amp=0.1, pan=0, atk=0.01, sus=0.5, rel=2, gate=1, out=0;
	var sig, env, freqOffset;
	freqOffset = LFNoise1.kr(1).range(1.001,1.05);
	env = EnvGen.kr(Env.asr(atk,sus,rel), gate);
	sig = SinOsc.ar([freq, (freq * freqOffset)]);
	sig = Pan2.ar(sig, pan);
	sig = Lag.ar(sig, 0.3);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)


~sine.release;
~sine = Synth(\sine, [\gate, 0,\amp, 0.05]);

(
~sine.free;
~sine = Synth(\sine, [\gate, 0,\amp, 0.05]);
//w.close;
w = Window.new("Music Machine", Rect.new(1500,200,400,400));
w.front;
w.view.background_(Color.grey);

~sl = Slider.new(w, Rect.new(50, 50, 50, 150))
.action_({
	arg sl;
	sl.value.postln;
	~sine.set(\amp, sl.value*0.1)
})
.valueAction_(1) //valueAction vs. value
.background_(Color.new255(176,48,96));

~btn = Button.new(w, Rect.new(200,100,50,50))
.action_({
	arg btn;
	//btn.value.postln;
	~sine.set(\gate, btn.value);
	//if (btn.value == 1) {~sine.set(\gate, 1)} {~sine.set(\gate, 0)};
})
.states_([
	["OFF",Color.black,Color.red],
	["ON",Color.black,Color.green]
]);
)
