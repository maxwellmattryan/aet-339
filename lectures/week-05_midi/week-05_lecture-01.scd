/******PART 1: MIDI BASICS******/

MIDIClient.init; //Optional

MIDIIn.connectAll; //Crucial: Turns on MIDI

MIDIFunc.trace(true); //Useful for general testing
MIDIFunc.trace(false); //Turns it off

MIDIdef //look up the help file (MIDIdef.new, func)
//MIDIdef uses the following args: val, num, chan, src

//It should look like this to post the note on data:
(
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
});
)


//Plays a tone with each MIDI key note on:
(
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	{
		var sig;
		sig = SinOsc.ar(1000);
		sig = sig * 0.1;
	}.play;
});
)
//Kind of useless, but it makes sound

//Give it an envelope and use the pitch num
(
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	{
		var sig, env;
		env = EnvGen.kr(Env.perc, doneAction:2);
		sig = SinOsc.ar(num.midicps);
		sig = sig * env * 0.1;
	}.play;
});
)

//Now let's make it sustain:
(
SynthDef.new(\tone, {
	arg freq=440, gate=1, amp=0.1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = SinOsc.ar(freq!2);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	Synth.new(\tone, [
		\freq, num.midicps,
		\amp, 0.1,
		\gate, 1,
	]);
});
)
//STUCK NOTE! (Cmd+.)

//We need to add a noteOff MIDIdef:
(
SynthDef.new(\tone, {
	arg freq=440, gate=1, amp=0.1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = SinOsc.ar(freq!2);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~notes = Synth.new(\tone, [
		\freq, num.midicps,
		\amp, 0.1,
		\gate, 1,
	]);
});

MIDIdef.noteOff(\off, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~notes.set(\gate, 0);
});
)
//~notes.set(\gate,0) doesn't work because it is replacing the synth every time a new pitch is added to a chord, and SC loses track of the previous synths in the server as a result.

//The solution is to make an array:
~notes = Array.fill(128, {nil}); //make an array for all 128 possible midi note numbers and fill it with "nil" at every index

~notes.postcs; //post the entire array (cs = 'complete script')



//Let's try it with the array:
(
SynthDef.new(\tone, {
	arg freq=440, gate=1, amp=0.1, out=0;
	var sig, env;
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = SinOsc.ar(freq!2);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~notes[num] = Synth.new(\tone, [ //will add the synth at the index pertaining to the note number
		\freq, num.midicps,
		\amp, 0.1,
		\gate, 1,
	]);
});

MIDIdef.noteOff(\off, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~notes[num].set(\gate, 0);
	~notes[num] = nil;
});
)

~notes; //check this while notes are on and off.

//You can see that the synths are removed from the array when they are removed from the server. (The interpreter side matches the server side.)





/*********PART 2: Adding complexity with continuous controllers**************/


//Adjust the SynthDef to add a VarSaw so that we can change the width using the mod wheel.
(
SynthDef.new(\tone, {
	arg freq=440, gate=1, amp=0.1, out=0, width=0.5;
	var sig, env;
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = VarSaw.ar(freq!2,width:width); //VarSaw with width argument
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~notes[num] = Synth.new(\tone, [
		\freq, num.midicps,
		\amp, val.linexp(0,127,0.1,0.3), //map amp to the velocity data. Scale it with linexp (linear to exponential)
		\gate, 1,
	]);
});

MIDIdef.noteOff(\off, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~notes[num].set(\gate, 0);
	~notes[num] = nil;
});

MIDIdef.cc(\mod, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~notes.do({
		arg synth;
		synth.set(\width, val.linexp(0, 127, 0.5, 0.99))
	});
}, 1);
)



//This won't work with notes that are already playing. We need to change the width value to a global variable so that SC is always aware of the value. Each instance of synth with know the current width value if it's global.


~width = 0; //initialize it

(
SynthDef.new(\tone, {
	arg freq=440, gate=1, amp=0.1, out=0, width=0.5;
	var sig, env;
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = VarSaw.ar(freq!2, width:width);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
MIDIdef.noteOn(\on, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~notes[num] = Synth.new(\tone, [
		\freq, num.midicps,
		\amp, val.linexp(0,127,0.1,0.3),
		\width, ~width, //add to noteOn so that every new synth is aware of the global width value
		\gate, 1,
	]);
});

MIDIdef.noteOff(\off, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~notes[num].set(\gate, 0);
	~notes[num] = nil;
});

MIDIdef.cc(\mod, {
	arg val, num, chan, src;
	[val, num, chan, src].postln;
	~width = val.linexp(0,127,0.5,0.99); //set global width equal to incoming values and map as before
	~notes.do({
		arg synth;
		synth.set(\width, ~width) //set the width for all synths iteratively
	});
}, 1);
)

