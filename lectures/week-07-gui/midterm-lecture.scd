/****MORE PATTERNS*****/
//Load a synth
(
SynthDef.new(\pbind_test, {
	arg freq=400,atk=0.01,rel=1,amp=0.2,out=0;
	var sig, env;
	env = EnvGen.kr(Env.perc(atk,rel), doneAction:2);
	sig = Saw.ar([freq, freq * 0.2.midiratio]);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

//test
Synth(\pbind_test);

//Pbind test
(
p = Pbind(
	\instrument, \pbind_test,
	\dur, 1,
	\scale, Scale.minorPentatonic,
	\degree, Pxrand([0,1,2,3,4,5], inf),
	\amp, Pexprand(0.05, 0.3),
	\atk, 0.01,
	\rel, 0.3,
	\stretch, 60 / 60, // seconds divided by bpm
	\out, 0,
);

x = p.play;
)

//Add \stretch to control tempo (defaults to 1, smaller floats make the tempo faster by the ratio)




//Pdefn \degSaw \atkDef

(
p = Pbind(
	\instrument, \pbind_test,
	\dur, 1,
	\scale, Scale.minorPentatonic,
	\degree, Pdefn(\degSaw, Pxrand([0,1,2,3,4,5], inf)),
	\amp, Pexprand(0.05, 0.3),
	\atk, 0.01,
	\rel, 0.3,
	\stretch, 60 / 60, // seconds divided by bpm
	\out, 0,
);


//Pdefn tests
Pdefn(\degSaw, Pxrand([2,3,4,5,6,7], inf));

Pdefn(\atkDef, 0.1);



/*********MORE GUI INFO**********/
(
//w.close;
w = Window.new("Music Machine", Rect.new(1200,400,600,400));
w.front;
)



(
w.close;
w = Window.new("Music Machine", Rect.new(1200,400,600,400));
w.front;

//Composite Views (AKA, panels)
~leftPanel = CompositeView.new(w, Rect.new(0, 0, 300, 300))
.background_(Color.black);

~rightPanel = CompositeView.new(w, Rect.new(300, 300, 300, 300))
.background_(Color.blue);

//Static Text
~staticPan = StaticText.new(~leftPanel, Rect.new(130, 25, 40, 25))
.string_("Saw Stuff")
.background_(Color.new(0.5, 0.3, 0.7, 1.0));

//Pdefn in action with slider



//valueAction sends the value AND performs the action instead of just setting the GUI slider to 1, silently
)



//Adjust the SynthDef to add lev




//test
Synth(\pbind_test);

//new lev Pbind




//Syncing (quant)
(
p = Pbind(
	\instrument, \pbind_test,
	\dur, 0.2,
	\scale, Scale.minorPentatonic,
	\degree, Pxrand([0,1,2,3,4,5], inf),
	\amp, Pexprand(0.05, 0.3),
	\atk, 0.01,
	\rel, 0.3,
	\out, 0,
);

x = p.play;
)

x.stop;

(
r = Pbind(
	\instrument, \pbind_test,
	\dur, 0.2,
	\scale, Scale.minorPentatonic,
	\degree, Pxrand([0,1,2,3,4,5], inf),
	\amp, Pexprand(0.05, 0.3),
	\atk, 0.01,
	\rel, 0.3,
	\out, 0,
);

y = r.play;
)

y.stop;
