// LEAD PART SCORE
LeadPad lead;
HarmCtl harmony;
harmony.buildScale();

[4, 5, 4, 3, 2, 3, 0, 2, 3] @=> int notes[];
[RhythmCtl.half, RhythmCtl.quarter, RhythmCtl.eighth, RhythmCtl.eighth,
RhythmCtl.quarter,
RhythmCtl.quarter, RhythmCtl.quarter, RhythmCtl.eighth,
RhythmCtl.eighth] @=>
dur rhythms[];

0.5 => lead.pan.gain;
0.3 => lead.pan.pan;
lead.chuckIt(dac);
while( true ) {
    for (0 => int note; note < notes.cap(); note++) {
        harmony.scale[notes[note]] => int midiNote;
        lead.playNote(Std.mtof(midiNote), RhythmCtl.sixteenth);
        rhythms[note] - RhythmCtl.sixteenth => now;
    }
}
