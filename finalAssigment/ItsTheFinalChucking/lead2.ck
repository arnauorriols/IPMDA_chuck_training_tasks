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

0.2 => lead.pan.gain;
-0.6 => lead.pan.pan;
lead.chuckIt(dac);
while( true ) {
    for (0 => int note; note < notes.cap(); note++) {
        notes[note] + 2 => int third;
        int midiNote;
        if (third >= harmony.scale.cap()) {
            6 -=> third;
            harmony.scale[third] + 12 => midiNote;
        } else {
            harmony.scale[third] => midiNote;
        }

        lead.playNote(Std.mtof(midiNote), RhythmCtl.sixteenth);
        rhythms[note] - RhythmCtl.sixteenth => now;
    }
}
