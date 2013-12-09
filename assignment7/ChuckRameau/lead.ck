HarmCtl harmony;
RhythmCtl rhythm;

[5, 4, 1, 1, 1, 2, 3, 3] @=> int notes[];

harmony.buildScale(3);
LeadPad lp;
lp.chuckIt(dac);
0.5 => lp.pan.gain;

while( true ) {
    for (0 => int i; i < notes.cap(); i++) {
        Std.mtof(harmony.scale[notes[i]]) => float freq;
        for (0 => int x; x < 1; x++) {
            Math.random2f(-0.4, 0.1) => lp.pan.pan;
            lp.playNote(freq, rhythm.thirtysecond);
            rhythm.thirtysecond * 3 => now;
        }
    }
}
