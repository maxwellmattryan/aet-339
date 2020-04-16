{PinkNoise.ar([0.1,0].reverse)}.play;

(
SynthDef(\sine, {
	arg freq=440, amp=0.1, atk=0.01, dec=0.1, sus=1, rel=1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.new([0,1,0.5,0.5,0],[atk,dec,sus,rel],[0,3,0,-3]));
	sig = SinOsc.ar([freq,freq*1.01]);
	sig = sig * env * amp;
	Out.ar(out,sig);
}).add;
)

Env.new([0,1,0.5,0.5,0],[0.01,0.1,1,1],[0,3,0,-3]).plot;

Synth(\sine, [\amp, 0.5]);

(
~sinePatt = Pbind(
	\instrument, \sine,
	\freq, Pdefn(\freqPatt, Pseq([500,600,700,800,900],inf)),
	\amp, Pexprand(0.05,0.5,inf),
	\atk, Pdefn(\atkPatt, Prand([0.01, 0.5, 0.1],inf)),
	\rel, Pdef(\relPatt, Pseq([0.6, 0.2], inf))
);

~sineStream = ~sinePatt.play;
)

Pdefn(\freqPatt, Pseq([200, 300, 400],inf));
s.makeGui;

~sineStream.stop();

(
w.close;
w = Window.new("Music Stuff", Rect.new(200,200,400,600));
w.front;

~btn = Button.new(w, Rect.new(200,100,50,50))
.action_({
    arg btn;
	if (btn.value == 1) {
		Pdefn(\freqPatt, Pseq([300, 400, 500, 600, 700] * 1.1));
		~sineStream.start();
	} {
		~sineStream.stop();

	};
})
.states_([
    ["OFF", Color.black, Color.red],
    ["ON", Color.black, Color.green]
]);
)