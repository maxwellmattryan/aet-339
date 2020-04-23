////SUPERCOLLIDER FINAL PROJECT////

//GENERAL PARAMETERS
/*

Create a TWO to THREE MINUTE piece of MUSIC or ABSTRACT SOUND DESIGN which can be performed LIVE via Zoom. It should include the following at a minimum:

(1) Three sound-synthesis SynthDefs you have designed.
(2) One buffer-playing SynthDef you have designed, and at least THREE sound files loaded into buffers.
(3) One reverb effect SynthDef with stereo input.
(4) A Dictionary which contains at least 4 “events” (patterns) and 2 “one-shots” (patterns and/or iteration).
(5a) A GUI to perform/trigger your events and one-shots.
(5b) OR, you can perform your piece using a MIDI input device (MIDIdef) if you have the equipment.


***After seeking final approval from me, please consider submitting your work for demonstration at the AET Digital Showcase!!!

***We will perform all works during our last class on May 7th

*/




//REQUIRED ASPECTS FOR EACH AREA ABOVE:
/*

//Sound-producing synths
(1a) Your sound-synths must each use a unique sound UGEN (SinOsc, Blip, PinkNoise, Saw, VarSaw, etc.)
(1b) Your sound-synths must utilize some form of pitch randomness.
(1c) They should also use panning with Pan2 (if monophonic) or Balance2 (if multi-channel expanded) as appropriate.

//Buffer synth
(2a) Your buffer SynthDef must implement a panning feature.
(2b) It should have the ability to stretch or compress the length of sound files and the ability to change starting position.

***Both the sound synths and buffer synth should be grouped into a "synth group" at the head of the node tree when instantiated.

//Reverb synth
(3a) Your reverb fx synth must be built to accept the stereo signals from the sound-producing SynthDefs above.
(3b) Place your reverb into an fx group.

//Events and One-shots
(4a) Each pattern you create for your sound-producing synths should take advantage of the various types of constrained randomness we have discussed during our class in some way. Do not hardwire parameters, unless there is a strong justification.
(4b) Each event should contrast in terms of settings and sound, but the piece should flow logically from one event to the next. **Note: not all of your instruments have to be used for each event.
(4c) At least ONE of your "one-shots" should utilize some form of iteration (do loop, while loop, etc.)
(4d) Your final event should fade out your piece (Pseg)

***Choose either GUI or MIDI performance

For GUI performance:
(5a.1) Your GUI should be laid out intuitively for a live performance of your piece (static text; composite views; labeled buttons, knobs, sliders, etc.)
(5a.2) Your GUI should be clean and aesthetically pleasing.

For MIDI performance:
(5b.1) Use either MIDIdef.noteOn or MIDIdef.cc to trigger events or one-shots in your event dictionary, depending on the device you have.
(5b.2) Use a 'case' statement to test multiple circumstances:
case
{boolean} {trueFunc}
{boolean} {trueFunc}
{} {}
{} {}
... etc.

(This will be covered in our final classes)


***NOTE***
***Your project should prepare and load ALL required elements automatically before a performance by running a single block of code, based on what we discussed in our final classes.

*/
