Rhodey piano[4];
Pan2 pianoPan[4];

Chorus c => Delay d => JCRev rev => Pan2 pan => dac;

0.5 => pan.gain;
0.4 => pan.pan;
0.15 => rev.mix;
0.03 => c.modDepth;
1.5=> c.modFreq;

for( 0 => int i; i < piano.cap(); i++) {
    piano[i] => c;
    (1.0 / piano.cap()) => pianoPan[i].gain;

    // piano setup
}

// Db Aeolian scale
[46, 48, 49, 51, 53, 54, 56, 58] @=> int midiScale[];

// Bass sequence
[7, 3, 6, 2, 5, 1, 4] @=> int seq[];

// chord
[0, 2, 4] @=> int triad[];

0.625::second => dur quarter;
quarter * 2 => dur half;
quarter / 2 => dur eighth;
eighth / 2 => dur sixteenth;

quarter + eighth => dur dQuarter;
eighth + sixteenth => dur dEighth;
quarter * 4 => dur measure;

// swing setup
sixteenth * 0.02 => dur swing;
sixteenth  => d.max;

fun void pianoOn(float velocity) {
    for(0 => int i; i < piano.cap(); i++) {
        Math.random2f(velocity-0.1, velocity+0.1) => piano[i].noteOn;
    }
}

fun void pianoOff() {
    for(0 => int i; i < piano.cap(); i++) {
        1 => piano[i].noteOff;
    }
}

fun int correctOctave(int baseNote, int currentNote) {
    if (currentNote < midiScale[baseNote]) 12 +=> currentNote;
    return currentNote;
}

fun void playChords(int base, int version) {
    quarter => now;
    for( 0 => int note; note < 3; note++) {
        midiScale[(base+triad[note]) % 7] => int midiNote;
        correctOctave(base, midiNote) => midiNote;
        Std.mtof(midiNote) => piano[note].freq;
    }
    if (version == 0) {
        midiScale[(base+6) % 7] => int melNote;
        correctOctave(base, melNote) => melNote;
        Std.mtof(melNote) => piano[3].freq;
        swing => d.delay;
        pianoOn(0.2);
        <<<piano[3].freq()>>>;
        dEighth => now;
        pianoOff();
        sixteenth => now;
        midiScale[(base+5) % 7] => melNote;
        correctOctave(base, melNote) => melNote;
        Std.mtof(melNote) => piano[3].freq;
        0::second => d.delay;
        pianoOn(0.15);
        <<<piano[3].freq()>>>;
        sixteenth => now;
        pianoOff();
        sixteenth => now;
        midiScale[(base+4) % 7] => melNote;
        correctOctave(base, melNote) => melNote;
        Std.mtof(melNote) => piano[3].freq;
        sixteenth * Math.random2f(0.4, 0.6) => d.delay;
        pianoOn(0.25);
        <<<piano[3].freq()>>>;
        quarter => now;
        pianoOff();
        eighth => now;
    } else {
    }
}



while(true) {
    for (0 => int n; n < seq.cap(); n++) {
        spork ~ playChords(seq[n], 0);
        measure => now;
    }
}
