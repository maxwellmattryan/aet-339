//ADVANCED PATTERNS and CUSTOM CLOCKS

//Load these first
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

//Test
Synth(\tone);
Synth(\noise);

//Load a pattern
(
~tonePatt = Pbind(
	\instrument, \tone,
	\freq, Pseq([200,300,400,500],inf),
	\amp, 0.1,
	\dur, 1
);
)

//Test the pattern
~toneStream = ~tonePatt.play;
~toneStream.stop;



//Pbindef - This is like wrapping the whole Pbind in a Pdef ... You can now customize any parameter in real time, simply by reloading the Pbindef after changes. No need to stop and adjust.
(
Pbindef(\p).clear; //use this to clear the previous Pbindef when reloading the tempo clock (good practice if you experience sound not working after subsequent loads)
Pbindef(\p,
	\instrument, \tone,
	\freq, Pseq([200,300,400,500],inf),
	\amp, 0.1,
	\dur, 1
).play;
)

Pbindef(\p).stop;
Pbindef(\p).play(t);


//Tempo Clock
TempoClock.default.tempo;
TempoClock.default.beats;

t = TempoClock.new(108/60); //create a new tempo clock which runs at 108 beats per minute...
//IMPORTANT: A custom TempoClock does not survive Cmd+. ... So you must re-run the TempoClock each time you run the ~postBeats and t.schedAbs code lines below if you've stopped the clock with Cmd+.

t.beats;
t.beatsPerBar;

~postBeats = {t.beats.postln}; //define a function to post the beats
t.schedAbs(t.nextBar, {~postBeats.value}); //schedule it to run the post beats function on the next bar

//tempo clock trick
~postBeats = {t.beats.postln; 1}; //one clever trick with tempo clock is to schedule a function which returns a numeric value.
t.schedAbs(t.nextBar, {~postBeats.value}); //so, it will run this function again and again that many beats later (so we end up with a visual tempo clock).



//Clump it together (run this first):
(
t = TempoClock.new(108/60);
~postBeats = {t.beats.postln; 1};
t.schedAbs(0, {~postBeats.value}); //run it from the zeroth count
)

//(Then run this to see visually the tempo change in the post window)
//This can schedule tempo changes or other events like a DAW
(
t.schedAbs(20, {t.tempo_(180/60)}); //t.schedAbs(beat, item)
t.schedAbs(40, {t.tempo_(60/60)});
)




//Now...



//Run this first...
(
t = TempoClock.new(108/60);
~postBeats = {t.beats.postln; 1};
t.schedAbs(0, {~postBeats.value});
)


//Then this, next...
(
Pbindef(\tone).clear;
Pbindef(\tone,
	\instrument, \tone,
	\degree, Pseq([0,4,7,9],inf),
	\amp, 0.1,
	\dur, Pseq([0.75,0.25,0.5,0.5],inf)
).play(t, quant:8); //This will start the Pbindef playing on a multiple of 8 (quant:8)
)


//Then this, third...
(
Pbindef(\hh).clear;
Pbindef(\hh,
	\instrument, \noise,
	\amp, Pseq([0.2,0.2,0.2,0.2,0.2,0.2,0.7,0.2],inf),
	\dur, 0.25
).play(t, quant:8);
)

Pbindef(\hh).stop;
Pbindef(\tone).stop;



//Then this, fourth... This will schedule some changes to the tempo on the custom clock
(
t.schedAbs(20, { //changes the tempo to 180 bpm on count 20 in the post window
	t.tempo_(180/60);
	Pbindef(\tone,
		\degree, Pseq([0,4,7,9]-1,inf) //changes degree pattern by moving the array down one degree (-1)
	);
});
t.schedAbs(40, { //changes the tempo to 60 on count 40 in the post window
	t.tempo_(60/60);
	Pbindef(\tone,
		\degree, Pseq([0,4,7,9],inf) //moves the degree array back to its starting point
	);
});
)

