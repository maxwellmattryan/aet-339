//VarSaw vs. Triangle
{VarSaw.ar(220, width: 0.01) * 0.5}.plot;
{VarSaw.ar(220, width: 0.99) * 0.5}.play;
{LFTri.ar(220) * 0.5}.plot;
{LFTri.ar(220) * 0.5}.play;

FreqScope.new;


(
SynthDef.new(\varSaw, {
	arg freq=440, amp=0.1, rel=0.7, relW=0.85;
	var sig, env, envW;
	//Add an envelope to control the amplitude shape of the signal (use Env.new)
	env = EnvGen.kr(Env.new([0.0, 1.0, 0.5, 0.0], [0.1, 0.4, rel], \lin) doneAction: 2);
	//Add an envelope to control the width of the VarSaw (use Env.new; 0.01 is buzzier, 0.5 is less buzzy; 0.99 is also buzzy)
	envW = EnvGen.kr(Env.new([0.5, 0.75, 1.0], [0.35, relW], \lin) doneAction: 2);
	sig = VarSaw.ar(freq, width: envW)!2; //VarSaw in stereo
	sig = sig * amp * env;
	Out.ar(0, sig)
}).add;
)

//test the VarSaw
Synth.new(\varSaw, args:[\freq, 220, \amp, 0.1]);

// Routines

(
Routine.new({
	p = [36, 43, 51];

	(p).do({
		arg note;
		Synth.new(\varSaw, args:[
			\freq, note.midicps(),
			\amp, 0.1,
			\rel, 0.7,
			\relW: 0.85]
		);
		1.6.wait();
	});
}).play();
)