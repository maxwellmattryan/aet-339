// Week 4 Take-Home Questions //

// BE SURE TO COMMENT YOUR WORK THOROUGHLY! :-) //

// GRADE:
// 1.
// 2.
// 3.
// 4.
// 5.


// [,,,,].sum;


// QUESTIONS:
// 1. Using a sample of your choice, load the sample using the following template:
~folderPath = PathName.new(thisProcess.nowExecutingPath).parentPath;
~glass = Buffer.read(s, ~folderPath ++ "sounds/glass.wav"); //Change the global variable to something meaningful, and change the name of the sound file in the path name at the end
// Lastly, test it using the .play method
~glass.play();

// 2. Create a SynthDef that plays back the file using PlayBuf.ar. Add variables to allow for greater flexibility (read
// question 3 below for more info that should be mirrored here in your SynthDef...).
(
SynthDef.new("Buffer", {
	arg gain, buf, rate = 1.0, startPos = 0, pan = 0.0;
	var sig;
	sig = PlayBuf.ar(
		numChannels: buf.numChannels(),
		bufnum: buf,
		rate: BufRateScale.kr(buf) * rate,
		startPos: startPos,
		doneAction: 2
	);

	// apply gain multiplier
	sig = sig * gain;

	// -1.0f <= pan <= 1.0f
	sig = Pan2.ar(in: sig, pos: pan);
	Out.ar(0, sig);

}).add();
)

// 3. Use Synth.new to instantiate your sound file player. You should be able to change the bufnum, rate, start position, and pan (hint: all arguments). Demonstrate!
(
Synth.new("Buffer", [
	\gain, 0.6,
	\buf, ~glass,
	\rate, 1.0,
	\startPos, 0,
	\pan, 0.0
]);
)

// 4. Create a Routine that incorporates a loop with random wait times. Use this to create a sonic texture out of your sample from above.
// Randomize other parameters as you see fit to make the loop more engaging (possible random panning, random start positions, random and/or
// negative rates, etc.).
(
Routine.new({
	{
		Synth.new(
			"Buffer",
			[
				\gain, 0.8,
				\buf, ~glass,
				\rate, rrand(0.5, 2),
				\startPos, 0,
				\pan, rrand(-1.0, 1.0)
			]);
		rrand(0.8, 3.2).wait();
	}.loop();
}).play();
)

// 5. Using a combination of multiple looping Routines, create a short sound design or musical piece that incorporates your looping sample
// Routine from question 4 with other sample Routines or synthesis Routines (using VarSaw, SinOsc, etc.). (You may need to change the sample
// or incorporate multiple samples that are randomly chosen and manipulated at runtime, depending on what you are going for sonically.)
// Make a Gui window:
s.makeGui;

// Record your output by hitting 'record >'
// In the post window, SC will provide the 'path:' to your recording. In Mac machines, this defaults to the "Music" folder creating a subfolder
// called "SuperCollider Recordings". Turn in this completed .scd file, your 'sounds' folder with any necessary samples, and your output
// recording from Question 5. in a SINGLE zipped folder.
~taiko = Buffer.read(s, ~folderPath ++ "sounds/taiko.wav");
~taiko.play();
~sticks = Buffer.read(s, ~folderPath ++ "sounds/stick-02.wav");
~sticks.play();
~rim = Buffer.read(s, ~folderPath ++ "sounds/stick-01.wav");
~rim.play();
(
Routine.new({
	{
		Synth.new(
			"Buffer",
			[
				\gain, 0.1,
				\buf, ~sticks,
				\rate, rrand(0.9, 1.1),
				\startPos, 0,
				\pan, rrand(-1.0, 1.0)
			]);
		[0.5, 1.0].choose().wait();
	}.loop();
}).play();
)

// ** CUE ON DOWNBEAT - my keyboard lagged so triggering about a 32nd early @ BPM = 60**
(
Routine.new({
	{
		Synth.new(
			"Buffer",
			[
				\gain, 0.8,
				\buf, ~rim,
				\rate, rrand(0.8, 2),
				\startPos, 0,
				\pan, rrand(-1.0, 1.0)
			]);
		[0.75, 1.5, 3.0].choose().wait();
	}.loop();
}).play();

Routine.new({
	{
		Synth.new(
			"Buffer",
			[
				\gain, 0.8,
				\buf, ~taiko,
				\rate, exprand(0.25, 2),
				\startPos, 0,
				\pan, 0.0
			]);
		[3.0, 4.5].choose().wait();
	}.loop();
}).play();
)

(
Routine.new({
	{
		Synth.new(
			"Buffer",
			[
				\gain, 0.06,
				\buf, ~glass,
				\rate, exprand(1.4, 2.6),
				\startPos, 0,
				\pan, [-1.0, -0.5, 0.5, 1.0].choose()
			]
		);
		[3.0, 4.5].choose().wait();
	}.loop();
}).play();
)