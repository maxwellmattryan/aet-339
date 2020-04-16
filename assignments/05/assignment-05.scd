//Advanced Patterns Assignment
//1.
//2.
//3.

//~grade = [,,].sum;

//Load these first
(
SynthDef(\tone,{
	arg freq=440, amp=0.3, atk=0.01, rel=0.1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.perc(atk,rel), doneAction: 2);
	sig = SinOsc.ar(freq!2);
	sig = sig * env * amp;
	Out.ar(out,sig);
}).add;
)

(
SynthDef(\noise,{
	arg amp=0.4, atk=0.01, rel=0.1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.perc(atk,rel), doneAction: 2);
	sig = PinkNoise.ar(amp!2);
	sig = sig * env * amp;
	Out.ar(out,sig);
}).add;
)

//Test
Synth(\tone);
Synth(\noise);



//QUESTION 1. Create a Pbind for each of the SynthDefs above incorporating the 'rest' notation learned in class.

//1a. \tone Pbind:
(
Pbind(
	\instrument, \tone,
	\dur, 0.2,
	\amp, 0.5,
	\scale, Scale.marva,
	\degree, Pseq([
		3, \, 7, 4,
		5, 1, \, 8,
	], inf),
).play();
Pbind(
	\instrument, \tone,
	\dur, 0.2,
	\amp, 0.5,
	\scale, Scale.marva,
	\degree, Pseq([
		7, 4, 5, 1,
		\, 8, 3, \
	], inf),
).play();

//1b. \noise Pbind:
Pbind(
	\instrument, \noise,
	\dur, 0.2,
	\amp, Pexprand(0.3, 0.5, inf)
).play();
)


//QUESTION 2. Convert the Pbinds to Pbindefs. Then, add a quantization value to quantize to every 4th beat for each Pbindef. Test that they synchronize properly.
(
t = TempoClock.new(120/60);
~postBeats = {t.beats.postln; 1};
t.schedAbs(0, {~postBeats.value});

{
	Pbindef(\tone).clear();
	Pbindef(\tone,
		\instrument, \tone,
		\amp, 0.4,
		\scale, Scale.minor,
		\degree, Pseq([
			Pseq([
				0, 4, \, 1,
				3, \, 5, 2
		    ], 2),
			Pseq([
				0, 4, \, 1,
				3, \, 7, 4,
				5, 1, \, 8,
				7, \, 2, 4
			], 1),
		], inf),
	).play(t, quant: 4);
}.defer(1);


//1b. \noise Pbind:
{
	Pbindef(\noise).clear();
	Pbindef(\noise,
		\instrument, \noise,
		\dur, Pseq([
			Pseq([
				0.5, 0, 0.25, 0.5
		], 18),
			Pseq([
				0.25, 0.25, 0.25, 0
			], 12)
		], inf),
		\amp, Pseq([
			\, 0.4, \, 0.6
		], inf)
	).play(t, quant: 4);
}.defer(1);
)

//QUESTION 3. Beginning with the custom clock below, create a scheduled sequence of TWO tempo and pattern changes (changing \degree, \dur, and \amp at a minimum) for each of your Pbindefs to occur on the beat numbers of your choice (i.e., beat 16 and 24 for example).
//Additionally, sections A. B. and C. below should all be encapsulated in parentheses and you should provide appropriate {}.defer() values to make your \tone and \noise instruments start at different times, and to run the t.schedAbs code section later after the custom clock and patterns have been started.
/*Lastly, make your mini-piece stop at the end using the following:
t.schedAbs(38, {
    ~postBeats = {}; //this changes the ~postBeats function to an empty, do-nothing function, which will stop t.schedAbs from posting the visual metronome.
    {t.stop}.defer(0.1); //I've encapsulated t.stop in a defer function to avoid an error from SC.
});
*/

//A. Start the Tempo Clock first:
(
t = TempoClock.new(92/60);
~postBeats = {t.beats.postln; 1};
t.schedAbs(0, {~postBeats.value});
 //<---erase this parenthesis after testing, to connect the code to parts B. and C. when finished

//B. Tone and noise Pbindefs should go here. Run them next:
{
	Pbindef(\tone).clear();
	Pbindef(\tone,
	\instrument, \tone,
	\dur, 0.25,
	\amp, 0.5,
	\scale, Scale.marva,
	\degree, Pseq([
		3, \, 7, 4,
		5, 1, \, 8,
	], inf),
	).play(t, quant: 4);
}.defer(1);

{
	Pbindef(\noise).clear();
	Pbindef(\noise,
		\instrument, \noise,
		\dur, Pseq([
			Pseq([
				0.5, 0, 0.25, 0.5
		], 18),
			Pseq([
				0.25, 0.25, 0.25, 0
			], 12)
		], inf),
		\amp, Pseq([
			\, 0.4, \, 0.6
		], inf)
	).play(t, quant: 4);
}.defer(4);

//C. Scheduled events ('t.schedAbs(beat, item)') go here:
t.schedAbs(16, {
	t.tempo_(108 / 60);
	Pbindef(\tone,
		\amp, Pexprand(0.3, 0.5),
		\dur, Pwrand([0.25, 0.5, 0.75], [0.7, 0.2, 0.1], inf),
		\degree, Pseq([
			[3, 1], \, [7, 8], [4, 3],
			[5, 0], [1, 7], \, [8, 5]
		], inf)
	);
	Pbindef(\noise,
		\amp, Pseq([0.4, \, 0.6, \], inf),
		\dur, Pseq([0.5, 0, 0.25, 0.5], inf)
	);
});

t.schedAbs(32, {
	t.tempo_(120 / 60);
	Pbindef(\tone,
		\amp, Pseq([0.1, 0.2, 0.4, 0.8] * 0.625, inf),
		\dur, Pseq([0.5, 0.25, 0.75, 0.5], inf),
		\scale, Scale.minorPentatonic
	);
	Pbindef(\noise,
		\dur, 0.25,
		\amp, Pwrand([0.2, 0.5], [0.8, 0.2], inf)
	);
});

t.schedAbs(64, {
	~postBeats = {};
	{t.stop}.defer(0.1);
});
)