s.quit;

(
//1. Server config
s = Server.local;

s.options.sampleRate_(44100);

ServerBoot.removeAll();
ServerQuit.removeAll();
ServerTree.removeAll();

//2. Initialize global variables
~out = 0;
~path = PathName(thisProcess.nowExecutingPath).parentPath;

//3. Define functions for the piece (for loading buffers, events, MIDIdef, GUI, etc.)
~createBuffers = {
	~glass = Buffer.read(s, ~path ++ "sounds/glass.wav");
	// define other buffers here...
};

~createBusses = {
	~reverbBus = Bus.audio(s, 2);
	// define other busses here...
};

~createNodes = {
	~synthGroup = Group.new();
	~fxGroup = Group.new(addAction: 'addToTail');

	~reverbSynth = Synth.new(\reverb, [
		\mix, 0.5,
		\room, 0.5,
		\damp, 0.2,
		\in, ~reverbBus,
		\out, ~out],
		~fxGroup
	);
};

~createEvents = {
	e = Dictionary.new;
	e.add(\event1 -> {
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
			\pan, Pwhite(-0.5,0.5,inf),
			\group, ~synthGrp,
			\out, ~reverbBus
		).play;

		~windChimes = {
			{
				Synth.new(\bufPlayer,
					[
						\buf, ~glass,
						\rate, [-12,-7,-6,-4,-1,0,1,4,6,7].choose.midiratio,
						\spos, rrand((~glass.numFrames * 0.001),(~glass.numFrames * 0.3)),
						\amp, exprand(0.1,0.5),
						\pan, rrand(-1,1),
						\out, ~reverbBus
					],
				~synthGrp
				);
				rrand(0.1,0.5).wait}.loop;
		}.fork;
		"This is event 1 - Chords".postln
	});

	e.add(\event2 -> {
		Pbindef(\marimba,
			\instrument, \bpfSaw,
			\freq, Prand([1,3/2],inf),
			\amp, 0.5,
			\rqLo, 0.005,
			\rqHi, 0.008,
			\cfLo, Prand((Scale.major.degrees+60).midicps,inf) * Prand([0.5,1], inf),
			\cfHi, Pkey(\cfLo),
			\group, ~synthGrp,
			\out, ~reverbBus
		).play;

		~windChimes.stop;
		"This is event 2 - Add Marimba".postln
	});

	e.add(\event3 -> {
		Pbindef(\marimba,
			\freq, Prand([1,3/2,2,4],inf),
			\cfLo, Prand((Scale.major.degrees+60).midicps,inf) * Prand([0.5,1,2], inf)
		).play;
		Pbindef(\chords,
			\cfHi, 1000
		).play;
		"This is event 3 - Busier Marimba".postln
	});

	e.add(\event4 -> { //marimba is busier still and even brighter chords
		Pbindef(\marimba,
			\freq, Prand([1,2,4,8],inf), //32nd notes added
			\cfLo, Prand((Scale.major.degrees+60).midicps,inf) * Prand([0.5,1,2,4], inf)
		).play;
		Pbindef(\chords,
			\cfHi, 1500
		).play;
		"This is event 4 - Bigger Synths".postln
	});

	e.add(\event5 -> {
		{
			Pbindef(\marimba,
				\amp, Pseg(levels:[0.5,0],durs:10,curves:'lin', repeats:1)
			).play;
			Pbindef(\chords,
				\midinote,[36,48,55,64,71],
				\cfHi, 600
			).play;
			20.wait;
			Pbindef(\chords).stop;
		}.fork;
	});
};

~cleanup = {
	s.newBusAllocators();

	ServerBoot.removeAll();
	ServerQuit.removeAll();
	ServerTree.removeAll();
};

//4. Register the functions with ServerBoot, ServerQuit, ServerTree
ServerBoot.add(~createBuffers);
ServerBoot.add(~createBusses);
ServerQuit.add(~cleanup);

//5. Boot the server and load remaining elements
s.waitForBoot({
	s.sync();

	SynthDef(\bpfSaw, {
		arg freq=440, amp=0.5, rqLo=0.05, rqHi=0.1, cfLo=100, cfHi=5000, atk=2, dec=0.5, susT=1.5, rel=2, pan=0;
		var sig, env, rq, cf;
		cf = {LFNoise1.kr(LFNoise1.kr(0.5).range(0.2,1)).range(cfLo,cfHi)}!2;
		rq = {LFNoise1.kr(1).range(rqLo, rqHi)}!2;
		env = EnvGen.kr(Env.new([0,1,0.5,0.5,0],[atk,dec,susT,rel]), doneAction:2);
		sig = Saw.ar(freq * {LFNoise1.kr(0.5).range(1.001,1.008)}!2);
		sig = BPF.ar(sig, cf, rq);
		sig = Balance2.ar(sig[0],sig[1],pan);
		sig = sig * env * amp;
		Out.ar(0, sig);
	}).add;

	SynthDef.new(\bufPlayer, {
		arg buf=0, rate=1, amp=1, spos=0, pan=0;
		var sig;
		sig = PlayBuf.ar(
			numChannels: 1,
			bufnum: buf,
			rate: BufRateScale.kr(buf) * rate,
			startPos: spos,
			doneAction: 2
		);
		sig = Pan2.ar(sig, pan);
		sig = sig * amp;
		Out.ar(0, sig);
	}).add;

	SynthDef.new(\reverb, {
		arg in, mix=0.5, room=0.5, damp=0.2, out=0;
		var sig;
		sig = In.ar(in, 2);
		sig = FreeVerb.ar(sig, mix, room, damp);
		Out.ar(out,sig);
	}).add;

	s.sync();

	ServerTree.add(~createNodes);
	ServerTree.add(~createEvents);

	s.freeAll();

	s.sync();

	"Server initialization complete.".postln();
});
)

//Test the loaded piece:
e[\event1].value; //Run event 1
e[\event2].value; //Run event 2
e[\event3].value; //and so on...
e[\event4].value;
e[\event5].value;


//Elements needed for this class:

//Buffers
~glass = Buffer.read(s, ~path ++ "sounds/glass.wav");
