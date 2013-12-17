// BASS PART SCORE
OrganBass bass;
HarmCtl harmony;
harmony.buildScale(1);

[0,  2, 0, 0, 6, 0, 0, 4, 0, 3, 0, 0, 2, 0, 5, 6] @=> int notes[];

RhythmCtl.start => time start;
while( now < (start + RhythmCtl.composition) ) {
    for (0 => int note; note < notes.cap(); note++) {
        harmony.scale[notes[note]] => int midiNote;
        if (notes[note] >= 3) {
            12 -=> midiNote;
        }
        for (0 => int x; x < 2; x++) {
            bass.noteOn(Std.mtof(midiNote), RhythmCtl.sixteenth);
        }
        if (now == (start + RhythmCtl.composition - RhythmCtl.quarter)) {
            bass.organsEnv => Delay finalFeed => finalFeed => Pan2 feedpan => dac;
            feedpan => Pan2 feed2 => dac;
            bass.mainPan.pan() => feedpan.pan;
            bass.mainPan.gain() => feedpan.gain;
            bass.feedPan.pan() => feed2.pan;
            bass.feedPan.gain() => feed2.gain;
            0.2 => finalFeed.gain;
            RhythmCtl.quarter => finalFeed.max => finalFeed.delay;
        }
    }
}
RhythmCtl.measure => now;
