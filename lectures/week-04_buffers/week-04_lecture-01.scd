// BUFFERS

~folderPath = PathName.new(thisProcess.nowExecutingPath).parentPath;
c = Buffer.read(server: s, path: ~folderSounds ++ "sounds/bowl.wav");

// **CAUTION** : '++' operator is a concatenation operator where '+' will add a space between two strings
c.play();

// removes all instantiated buffers
Buffer.freeAll()

// buffer method
c.numChannels();
c.bufnum();
c.duration();
c.sampleRate();
c.numFrames();
c.numSamples();

// using u-gen to play a buffer
PlayBuf.ar(b.numChannels(), b.bufnum(), 1.0, doneAction: 2);

// ** CAUTION: Do not initialize / load buffer in the synth def declaration **

b = Buffer.read(server: s, path: ~folderPath ++ "sounds/glass.wav");

(
SynthDef.new("OneShot", {
	arg buf, gain = 0.5, rate = 1.0, startPos = 0, pan = 0.0;
	var sig;
	sig = PlayBuf.ar(
		numChannels: 1,
		bufnum: buf,
		rate: BufRateScale.kr(buf) * rate,
		startPos: startPos,
		doneAction: 2
	);

	// apply gain multiplier
	sig = sig * gain;

	// -1.0f <= pan <= 1.0f
	sig = Pan2.ar(in: sig, pos: pan);
	Out.ar(0, sig)
}).add();
)

(
Synth.new(
	"OneShot",
	[
		\buf, b,
		\gain, exprand(0.5, 1.6),
		\rate, rrand(0.5, 2.0),
		\startPos, rrand(0.0, (b.numFrames() * 0.2)),
		\pan, -1.0
	]
);
)

(
r = Routine.new({
	{
	Synth.new(
		"OneShot",
		[
			\gain, exprand(0.5, 1.6),
			\rate, rrand(0.5, 2.0),
			\startPos, rrand(0.0, (b.numFrames() * 0.2));
		]
	);
		1.wait();
	}.loop();
}).play();
)

(
r = {
	{
		Synth.new(
			"OneShot",
			[
				\gain, exprand(0.5, 1.6),
				\rate, [-12, -7, -5, -2, 0, 2, 5, 7].choose().midiratio(),
				\startPos, rrand(0.0, b.NumFrames() * 0.2)
			]
		);
		rrand(0.1, 0.8).wait();
	}.loop();
}.fork();
)

r.stop();