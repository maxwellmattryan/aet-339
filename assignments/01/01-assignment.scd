/******Class and Take-home Problems******/

// 1. Create a function where LFNoise0 is used to control the center frequency of a
// band-pass filter (BPF.ar). Use stereo PinkNoise or WhiteNoise as your source
// sound to be filtered. Make LFNoise0 choose a different frequency every 2 seconds,
// and use the 'range' method to set a frequency range from 300 to 2000 Hz. I have
// begun each line of code for you:

(
f = {
	var sig, cF;
	cF = LFNoise0.ar();
	sig = PinkNoise.ar!2 * 0.8;
	sig = BPF.ar();
}.play;
)


// 2. Build a sound function with SinOsc as the sound source which utilizes MouseX
// and MouseY to control the frequencies in the left and right channels (hint: use
// an array).

(
a = {
	arg amp=0.2;
	var sig;
	sig = [SinOsc.ar(MouseX.kr(30, 1000)), SinOsc.ar(MouseY.kr(30, 1000))] * amp;
}.play(amp: 0.5);
)

// 3. Define a custom break point envelope ("e = Env.new()") with a complex shape
// to control the volume of a stereo Saw.ar within a sound function ("f = {}.play").
// Additionally, create a custom curvature to your envelope using positive and
// negative integers in an array (Hints: this will be the 'curve' argument. You
// will need to load this envelope into using the server-side unit generator,
// EnvGen.kr. To start, define your Env.new() statement and plot it to check the
// shape, then insert it into your function.)

(
b = {

}.play();
)

//4. Plot two cycles for the following waveforms:
{SinOsc.ar(200)}
{Saw.ar(100)}
{LFTri.ar(10)}
{Pulse.ar(500)}


// 5. Build a function using SinOsc with the appropriate variables and arguments
// to be able to change the amplitude and frequency arguments at run-time.
// Demonstrate this using the 'set' message. Provide two unique values for each
// argument using set (4 lines of code which can be loaded during run-time).






// 6. Build a function where a simple envelope (use "Env.new") is applied to a
// sound signal of your choice and which frees itself after completion (hint:
// 'doneAction:2').






// 7. Build a function using a sound UGen and apply an Env.adsr envelope to it.
// Demonstrate the use of the 'gate' argument to advance to the release phase of
// the adsr.







