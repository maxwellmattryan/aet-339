/*******MIDTERM ASSIGNMENT********/

//BUILD A GENERATIVE PATTERN MACHINE

//PART 1. Design and test 2 SynthDefs using Blip.ar and VarSaw.ar

//Requirements:
//-Each SynthDef must have discernible pitch.
//-Each must be stereophonic. (Use a different method of multi-channel expansion for each.)
//-Each must have an envelope. (Use a different method for each.)
//-Each must have basic control of freq, amp, envelope parameters (atk, sus, rel, or similar, etc.), and pan at a minimum.
//-Blip should have control of nharm, and VarSaw should have control of width.
//-Both SynthDefs must utilize some sort of frequency offset variable. (Hint: Utilize some form of randomness,
//     like LFNoise1 or similar. Use a different method for each.)

//Boot the server
s.boot;

/********LOAD SYNTHDEFS**********/
(
SynthDef.new(\blipSynth, {
	arg
	freq = 440.0,
	atk = 0.1,
	rel = 1.0,
	amp = 0.4,
	lev = 1.0,
	out = 0,
	pan = 0.0,
	nharm = 1;

	var
	env,
	sig,
	offset;

	offset = LFNoise1.ar(2!4).range(-0.1, 0.1).midiratio();

	env = EnvGen.kr(Env.perc(atk, rel), doneAction: 2);

	sig = Blip.ar(freq: [freq, freq * offset], numharm: nharm);
	sig = sig * env * amp;

	sig = Pan2.ar(sig, pan);
	sig = sig * lev;

	Out.ar(out, sig);

}).add();
)

(
SynthDef.new(\varSawSynth, {
	arg
	freq = 440.0,
	atk = 0.1,
	rel = 1.0,
	amp = 0.4,
	out = 0,
	lev = 1.0,
	pan = 0.0,
	width = 0.5;

	var
	env,
	sig,
	offset;

	offset = LFNoise2.ar(2!4).range(-0.1, 0.1).midiratio();

	env = EnvGen.kr(Env.perc(atk, rel), doneAction: 2);

	sig = VarSaw.ar(freq: [freq * offset]!4, width: width);
	sig = sig * env * amp;
	sig = Splay.ar(sig);

	sig = Pan2.ar(sig, pan);
	sig = sig * lev;

	Out.ar(out, sig);

}).add();
)

//TEST
Synth(\blipSynth);
Synth(\varSawSynth);

//PART 2. Create Pbinds to control each SynthDef
//-Each Pbind must address all of the controllable parameters from PART 1.
//-Do not hardwire any parameters. Each should have some form of contrained randomness. (Use the various data patterns
//     you've learned to accomplish this: Pseq,Prand,Pxrand,Pwrand,Pexprand,and Pwhite.)
//-Use degree and scale for handling pitch in each of the Pbinds.
//-Create global variables to handle changing scales (Scale.major, Scale.minor, etc.). Save the scale possibilities in an array.
//-Wrap the degree parameter, scale parameter, and a 'lev' parameter into a 'Pdefn' for each Pbind. (The user should be able to
//     change scales, degree patterns, and the output level during performance. The output level will be controlled by a Slider
//     for each instrument in the GUI.)
//-Create numerous scale and pitch-degree pattern possibilities. (You must include at least FIVE. Each can be triggered by a
//     button in the GUI.)
//-You can create chords using arrays of pitches within your larger degree array... [[0,2,4],4,5,6,7] would add tonic triad
//     on the first degree of the scale being used.
//-Clearly comment all of your Pbinds and what you're attempting to do with each pattern parameter.
//-Remember to use the 'quant' message to ensure all of your Pbinds are synced.
//-It should look like this: ~blip.play(quant:1)

//LOAD ALL OF THIS FIRST

//scale global variable declarations go here:
Scale.directory();

/*****PBinds*****/
// Blip = higher, busier sound texture that fills in the upper part of the spectrum. Intended to provide some
// rhythm and groove.
(
~blipPatt = Pbind(
	\instrument, \blipSynth,
	\dur, Pseq([0.8, 0.2, 0.4, 0.6, 0.4], inf),
	\scale, Pdefn(\blipScale, Pseq([Scale.minor, Scale.minorPentatonic], inf)),
	\degree, Pdefn(\blipDegreePatt, Pxrand([0, 1, 2, 3, 4, 5, 6, 7], inf)),
	\atk, Pwrand([0.01, 0.1, 0.2], [0.6, 0.3, 0.1], inf),
	\rel, Pwrand([0.6, 0.3, 1.0], [0.3, 0.5, 0.2], inf),
	\lev, Pdefn(\blipLevPatt, Pxrand([0.1, 0.2, 0.3, 0.4, 0.5], inf)),
	\pan, Pwrand([-1.0, -0.4, 0.0, 0.4, 1.0], [0.3, 0.15, 0.1, 0.15, 0.3], inf),
	\nharm, Pexprand(1, 10)
);

~blipStream = ~blipPatt.play(quant: 0.2);

// VarSaw = lower tones to ground the key / tonic a bit more. It does have rhythm to give a sense of motion as well,
// but it leaves the rhythmic context sparse for the other pbind.
~varSawPatt = Pbind(
	\instrument, \varSawSynth,
	\dur, Pseq([0.4, 0.8, 0.4], inf),
	\scale, Pdef(\varSawScale, Pseq([Scale.minor, Scale.minorPentatonic], inf)),
	\degree, Pdefn(\varSawDegreePatt, Pseq([Pxrand([0, 2, 4, 5], 4), Pxrand([0, 2, 4] - 3, 2)], inf)),
	\atk, Pseq([0.1, 0.1, 0.3], inf),
	\sus, Pxrand([0.0, 0.3, 1.0], inf),
	\rel, Pseq([0.3, 0.3, 0.4], inf),
	\lev, Pdefn(\varSawLevPatt, Pxrand([0.1, 0.2, 0.3, 0.4, 0.5], inf)),
	\pan, Pwrand([-1.0, -0.4, 0.0, 0.4, 1.0], [0.05, 0.2, 0.5, 0.2, 0.05], inf),
	\width, Pwrand([0.0, 0.2, 0.3], [0.2, 0.3, 0.5], inf)
);

~varSawStream = ~varSawPatt.play(quant: 0.2);
)

~blipStream.stop();
~varSawStream.stop();

//PART 3. Create a GUI which can control the following:
//-Be able to start and stop each of the 2 Pbinds (I would recommend using an 'if' statement in this case.)
//-Be able to change the global pitch scale (at least 2 scale choices (major/minor would work))
//-Button(s) to change the pitch (degree) pattern within each Pbind
//-Be able to change the volume of each SynthDef (2 sliders, 'lev' argument in each SynthDef and their Pbinds)
//-Make your GUI clean, colorful, intuitive and inviting, and be sure to implement StaticText to label sections of your GUI with text.
//-Consider dividing sections of your GUI with panels (CompositeView.new)

/*****GUI CODE GOES HERE*****/
s.makeGui();
w = Window.new();

(
w.close();
w = Window.new("Music Machine", Rect.new(1080 - 360, 540 - 180, 720, 360))
.front
.view
.background_(Color.grey);

// BLIP SYNTH GUI
//================================================================
~blipView = CompositeView.new(w, Rect(0, 0, 240, 360));

StaticText.new(~blipView, Rect(60, 10, 360, 20))
.string_("Blip Boy");

~blipToggle = Button.new(~blipView, Rect.new(60, 45, 60, 60))
.action_({
	arg btn;
	if(btn.value == 1) {
		~blipStream.start();
	} {
		~blipStream.stop();
	};
})
.states_([
	["OFF", Color.black, Color.red],
    ["ON", Color.black, Color.green]
]);

~blipDegree = Button.new(~blipView, Rect.new(60, 120, 120, 60))
.action_({
	arg btn;
	if(btn.value == 0) {
		Pdefn(\blipDegreePatt, Pxrand([0, 1, 2, 3, 4, 5, 6, 7], inf));
	};
	if (btn.value == 1) {
		Pdefn(\blipDegreePatt, Pseq([0, 1, 2, 3, 4, 5, 6, 7], inf));
	};
	if(btn.value == 2) {
		Pdefn(\blipDegreePatt, Pseq([0, 1, 2, 3, 4, 5, 6, 7].reverse, inf));
	};
})
.states_([
	["Random", Color.black, Color.magenta],
	["Ascending", Color.black, Color.cyan],
	["Descending", Color.black, Color.yellow]
]);

~blipLev = Slider.new(~blipView, Rect.new(60, 195, 45, 90))
.action_({
	arg sl;
	Pdefn(\blipLevPatt, Pxrand([0.1, 0.2, 0.3, 0.4, 0.5] * sl.value, inf));
})
.value_(1.0)
.background_(Color.new(0.0, 0.2, 0.3, 1.0));

// DEAD GUI SPACE...
//================================================================
~middleView = CompositeView.new(w, Rect(240, 0, 240, 360));

StaticText.new(~middleView, Rect(60, 10, 240, 20))
.string_("Music Box");

~musicBoxToggle = Button.new(~middleView, Rect(60, 45, 60, 60))
.action_({
	arg btn;
	if(btn.value == 1) {
		~blipToggle.valueAction_(1);
		~varSawToggle.valueAction_(1);
	} {
		~blipToggle.valueAction_(0);
		~varSawToggle.valueAction_(0);
	}
})
.states_([
	["OFF", Color.black, Color.red],
    ["ON", Color.black, Color.green]
]);

~scaleToggle = Button.new(~middleView, Rect(60, 120, 60, 45))
.action_({
	arg btn;
	if (btn.value == 0) {
		Pdefn(\blipScale, Pseq([Scale.major, Scale.majorPentatonic], inf));
		Pdef(\varSawScale, Pseq([Scale.major, Scale.majorPentatonic], inf));
	} {
		Pdefn(\blipScale, Pseq([Scale.minor, Scale.minorPentatonic], inf));
		Pdef(\varSawScale, Pseq([Scale.minor, Scale.minorPentatonic], inf));
	}
})
.states_([
	["Minor", Color.white, Color.black],
	["Major", Color.black, Color.white]
]);

// VAR SAW GUI
//================================================================
~varSawView = CompositeView.new(w, Rect(480, 0, 240, 360));

StaticText.new(~varSawView, Rect(60, 10, 360, 20))
.string_("Saw Stack");

~varSawToggle = Button.new(~varSawView, Rect.new(60, 45, 60, 60))
.action_({
	arg btn;
	if(btn.value == 1) {
		~varSawStream.start();
	} {
		~varSawStream.stop();
	};
})
.states_([
	["OFF", Color.black, Color.red],
    ["ON", Color.black, Color.green]
]);

~varSawDegree = Button.new(~varSawView, Rect.new(60, 120, 120, 60))
.action_({
	arg btn;
	if(btn.value == 0) {
		Pdefn(\varSawDegreePatt, Pseq([
			Pxrand([0, 2, 4, 5], 4),
			Pxrand([0, 2, 4] - 3, 2)], inf));
	};
	if (btn.value == 1) {
		Pdefn(\varSawDegreePatt, Pseq([
			Pxrand([0, 2, 4, 5] + 3, 4),
			Pxrand([0, 2, 4], 2)], inf));
	};
	if(btn.value == 2) {
		Pdefn(\varSawDegreePatt, Pwrand([0, 2, 4], [0.6, 0.3, 0.1], inf));
	};
})
.states_([
	["Var 1", Color.black, Color.magenta],
	["Var 2", Color.black, Color.cyan],
	["Var 3", Color.black, Color.yellow]
]);

~varSawLev = Slider.new(~varSawView, Rect.new(60, 195, 45, 90))
.action_({
	arg sl;
	Pdefn(\varSawLevPatt, Pxrand([0.1, 0.2, 0.3, 0.4, 0.5] * sl.value, inf));
})
.value_(1.0)
.background_(Color.new(0.0, 0.2, 0.3, 1.0));
)

//PART 4. Create detailed instructions and comments for performing with your Pattern Machine.

// *** INSTRUCTIONS *** //
//
// Instrument Controls:
// 1. On / Off Button - start and stops the PBind event stream
// 2. (Scale) Degree Button - cycle through a few various patterns
// 3. Volume Slider - control the output level of the individual instruments
//
// Other Controls:
// 1. On / Off Button - start and stops BOTH Pbind events simultaneously
// 2. (Scale) Mode Button - alternate between minor and major scale modes