{ PinkNoise.ar([0.1, 0.2]) }.play();

(
SynthDef(\sine, {
	arg freq = 440.0, amp = 0.1, atk = 0.01, dec = 0.1, sus = 1.0, rel = 1.0, out = 0;

	var sig, env;
	env = EnvGen.kr(Env.new([0.0, 0.9, 0.6, 0.6, 0.0], [0.1, 0.3, 1.0, 0.5]));

	sig = SinOsc.ar([freq, freq * 1.01], mul: amp);
	sig = sig * env;

	Out.ar(out, sig);
}).add();
)

Synth(\sine);

(
p = Pbind(
	\instrument, \sine,
	\freq, Prand((36..48).midicps, inf),
	\amp, Pexprand(0.2, 0.6, inf),
	\atk, Prand([0.01, 0.1, 0.6], inf),
	\dur, Prand([0.5, 0.125, 0.75], inf)
);

x = p.play();
)

(
p = Pbind(
    \instrument, \sine,
//  \freq, Pseq([200,300,400],inf),
    \scale, Prand([Scale.minorPentatonic, Scale.majorPentatonic, Scale.prometheus],inf),
    \degree, Pxrand([[0,3],1,[2,5],3,[4,7],5], inf),
    \amp, Pexprand(0.01, 0.15, inf),
    \atk, Prand([0.01, 0.5, 0.1],inf),
    \dur,Prand([0.5,1,1.5],inf)
);

x = p.play;
)

(
p = Pbind(
    \instrument, \sine,
    \scale, Scale.minorPentatonic,
    \degree, Pxrand([0,1,2,3,4,5], inf),
    \amp, Pexprand(0.01, 0.15, inf),
    \atk, Prand([0.01, 0.5, 0.1],inf),
    \dur, Pseq([0.5,0.5,0.5,0.5,1],inf),
    \width, Pseq([0.5,0.8,0.3,0.9,1], inf)
);

x = p.play;
)

x.stop();

Scale.directory();