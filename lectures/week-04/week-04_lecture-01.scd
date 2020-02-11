// BUFFERS

// stereo file
c = Buffer.read(server: s, path: "C:/Users/Matt/Documents/School/2020/Spring/aet-339/lectures/week-04/sounds/bowl.wav");
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

b = Buffer.read(server: s, path: "C:/Users/Matt/Documents/School/2020/Spring/aet-339/lectures/week-04/sounds/glass.wav");

(
SynthDef.new("OneShot", {
	arg gain = 0.5, rate = 1.0, startPos = 0;
	var sig;
	sig = PlayBuf.ar(
		numChannels: 1,
		bufnum: b,
		rate: rate,
		startPos: startPos,
		doneAction: 2
	);
	sig = sig * gain;
	Out.ar(0, sig)
}).add();
)

(
Synth.new(
	"OneShot",
	[
		\gain, exprand(0.5, 1.6),
		\rate, rrand(0.5, 2.0),
		\startPos, rrand(0.0, (b.numFrames() * 0.2));

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