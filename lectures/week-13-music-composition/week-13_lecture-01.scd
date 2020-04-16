//Versatile SynthDef using a band-pass filtered Saw.ar
(
SynthDef(\bpfSaw, {
	arg freq=440, amp=0.5, rqLo=0.05, rqHi=0.1, cfLo=100, cfHi=5000, atk=2, dec=0.5, susT=1.5, rel=2, pan=0;
	var sig, env, rq, cf;
	//cf = SinOsc.ar(0.5).range(cfLo, cfHi); //Simple example of a BPF center frequency sweeping effect using SinOsc.ar
	cf = {LFNoise1.kr(LFNoise1.kr(0.5).range(0.2,1)).range(cfLo,cfHi)}!2; //Advanced version using nested LFNoise1 units to meander through the overtones of the Saw.ar with variable times (cfLo is the lowest possible frequency and cfHi is the highest)
	rq = {LFNoise1.kr(1).range(rqLo, rqHi)}!2; //rq is the 'reciprocal quality' value for the BPF below. It ranges from 0.0-1.0. Smaller values mean that more pitch will be heard. I'm using LFNoise1 to slightly alter the apparent pitch of the filter ranging from rqLo to rqHi. The lower this number the more prominent the sweeping center frequency
	env = EnvGen.kr(Env.new([0,1,0.5,0.5,0],[atk,dec,susT,rel]), doneAction:2); //Custom ADSR envelope (susT refers to the sustain time)
	sig = Saw.ar(freq * {LFNoise1.kr(0.5).range(1.001,1.008)}!4); //Using LFNoise1 to create a frequency offset to slightly detune
	sig = BPF.ar(sig, cf, rq); //band-pass filter to
	sig = Balance2.ar(sig[0] + sig[2], sig[1] + sig[3], pan); //like Balance2 balances previously expanded signal in left and right channel to allow for panning. This is the more appropriate choice than Pan2, since the signal is multi-channel expanded (!2) above.
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;
)

FreqScope.new; //Load the FreqScope to see what is happening

Synth(\bpfSaw, [\rqHi, 0.1]); //Try adjusting the rqHi value up toward 1.0 to hear (and see) the difference in the pitch sweep.

//Let's make some chords
(
Pbindef(\chords).clear;
Pbindef(\chords,
	\instrument, \bpfSaw,
	\dur, 8,
	\midinote, Pxrand([ //Pxrand never repeats a chord twice in a row
		[36,48,55,64,71], //nesting arrays (chords) within the Pxrand list array.
		[38,57,65],
		[29,38,57,60,64],
		[31,53,57,60,64]
	], inf),
	\amp, Pexprand(0.3, 0.5,inf), //slight amp changes
	\cfLo, 100,
	\cfHi, 600, //low value to create a darker quality of sound during the sweep. Higher cfHi value would create a brighter sound.
	\atk, 2,
	\rel, 8,
	\pan, Pwhite(-0.5,0.5,inf)
).play;
)

Pbindef(\chords).stop;

//Let's make a marimba
(
Pbindef(\marimba).clear();
Pbindef(\marimba,
	\instrument, \bpfSaw,
	\freq, Prand([1, 3/2, 2, 4], inf),
	\amp, 0.8,
	\rqLo, 0.005,
	\rqHi, 0.008,
	\cfLo, Prand((Scale.major.degrees + 60).midicps, inf) * Prand([0.5, 1], inf),
	\cfHi, Pkey(\cfLo, inf)
).play();
)

Pbindef(\marimba).stop();

// Creating an event dictionary
e = Dictionary.new();
(
e.add(\event1 -> { //event 1 starts the chords
    Pbindef(\chords,
        \instrument, \bpfSaw,
        \dur, 8,
        \midinote, Pxrand([
            [36,48,55,64,71],
            [38,57,65],
            [29,38,57,60,64],
            [31,53,57,60,64]
        ], inf),
        \amp, Pexprand(0.1,0.2,inf),
        \cfLo, 100,
        \cfHi, 600,
        \atk, 4,
        \rel, 6,
        \pan, Pwhite(-0.5,0.5,inf)
    ).play;
    "This is event 1 - Chords".postln //info seen in the post window
});

e.add(\event2 -> { //event 2 adds the marimba
    Pbindef(\marimba,
        \instrument, \bpfSaw,
        \freq, Prand([1,3/2],inf), //only quarter notes and triplets
        \amp, 0.5,
        \rqLo, 0.005,
        \rqHi, 0.008,
        \cfLo, Prand((Scale.major.degrees+60).midicps,inf) * Prand([0.5,1], inf), //one octave lower and at pitch (0.5 and 1)
        \cfHi, Pkey(\cfLo)
    ).play;
    "This is event 2 - Add Marimba".postln
});

e.add(\event3 -> { //the marimba gets busier
    Pbindef(\marimba,
        \freq, Prand([1,3/2,2,4],inf), //eighth notes and 16ths added in marimba
        \cfLo, Prand((Scale.major.degrees+60).midicps,inf) * Prand([0.5,1,2], inf) //added one octave up by multiply by 2
    ).play;
    Pbindef(\chords,
        \cfHi, 1000 //brightened the chords by allowing a higher sweep to 1000 Hz.
    ).play;
    "This is event 3 - Busier Marimba".postln
});

e.add(\event4 -> { //marimba is busier still and even brighter chords
    Pbindef(\marimba,
        \freq, Prand([1,2,4,8],inf), //32nd notes added
        \cfLo, Prand((Scale.major.degrees+60).midicps,inf) * Prand([0.5,1,2,4], inf)
    ).play;
    Pbindef(\chords,
        \cfHi, 1500 //higher cutoff for sweep in chords
    ).play;
    "This is event 4 - Bigger Synths".postln
});

e.add(\event5 -> {
    { //I set up a .fork (Routine) to stagger the marimba and chords endings.
        Pbindef(\marimba,
            \amp, Pseg(levels:[0.5,0],durs:10,curves:'lin', repeats:1) //Pseg is the data pattern for envelopes. It's great for performing fade-outs. In this case my fade-out last for 10 seconds, taking 0.5 amp to 0 amp.
        ).play;
        Pbindef(\chords,
            \midinote,[36,48,55,64,71], //end with only C Major 7 for a feeling of completion.
            \cfHi, 600 //darkened the chord back to 600 Hz for ending
        ).play;
        20.wait; //wait 20 seconds
        Pbindef(\chords).stop; //then, stop the chords
    }.fork;
});
)

// atmospheric chords
e[\event1].value;

// add marimba to texture
e[\event2].value;

// add busier marimba texture
e[\event3].value;

// add brighter marimba chords and also make synth bigger
e[\event4].value;

// end both textures in a staggered way
e[\event5].value;