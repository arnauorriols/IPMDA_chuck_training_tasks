
HarmCtl harmony;
RhythmCtl rhythm;
Rhodey piano[3];
Delay swing => LPF filter => NRev rev => Pan2 pan => dac;
0.08 => rev.mix;
2750 => filter.freq;
1 => filter.Q;
rhythm.thirtysecond * 0.2 => swing.delay;
for (0 => int x; x < piano.cap(); x++) {
    piano[x] => swing;
    (1 / 3.0) => piano[x].gain;
}


harmony.buildScale(2);

[[3, 5, 0], [4, 6, 1], [5, 0, 2], [2, 4, 6], [1, 3, 5], [2, 4, 6], [4, 6, 1],
[5, 0, 2]] @=> int chords[][];

while( true ) {
    for(0 => int chord; chord < chords.cap(); chord++) {
        for(0 => int note; note < chords[0].cap(); note++) {
            harmony.scale[chords[chord][note]] => int midiNote;
            if (note > 0 && chords[chord][note] < chords[chord][0]) {
                midiNote + 12 => midiNote;
            }
            Std.mtof(midiNote) => piano[note].freq;
            Math.random2f(-0.1, 0.4) => pan.pan;
            1.5 => piano[note].noteOn;
        }
        rhythm.half => now;
    }
}


