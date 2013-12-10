// Assignment_7_Chuck_Rameau

// Lead Pad score part

HarmCtl harmony;
RhythmCtl rhythm;

[5, 4, 1, 1, 1, 2, 3, 3, 5, 4, 1, 1, 1, 2, -1, -1] @=> int notes[];

harmony.buildScale(3);
LeadPad lp;
LeadPad lp2;
lp2.chuckIt(dac);
lp.chuckIt(dac);
0.5 => lp.pan.gain;
0.2 => lp2.pan.gain;

// Setup Delay
lp.filter.filter => Delay feedback => lp.filter.filter;
lp2.filter.filter => Delay feedback2 => lp2.filter.filter;
0.2 => feedback.gain;
0.3 => feedback2.gain;
rhythm.eighth => feedback.max => feedback.delay;
rhythm.eighth => feedback2.max => feedback2.delay;
now => time start;
while( true ) {
    if (now < start + rhythm.composition) {
        for (0 => int i; i < notes.cap(); i++) {
            if (notes[i] != -1) {
                Std.mtof(harmony.scale[notes[i]]) => float freq;
                Math.random2f(-0.4, 0.1) => lp.pan.pan;
                0.8 => lp2.pan.pan;
                spork ~ lp.playNote(freq, rhythm.thirtysecond);
                lp2.playNote(Utils.centsInt(freq, 40), rhythm.thirtysecond);
            } else {
                rhythm.thirtysecond => now;
            }
            rhythm.thirtysecond * 3 => now;
        }
    } else {
        0.4 => feedback.gain;
        0.45 => feedback2.gain;
        1::second => now;
    }
}
