// Assignment_6_Chillin'_out

Pan2 pan => dac;

SinOsc carr => ADSR env => Delay swing => Chorus chor => NRev rev => pan;
SinOsc mod => carr;


0.02 => rev.mix;
0.25 => chor.modFreq;
2 => carr.sync;
6400=> mod.gain;



0.05 => pan.gain;
0.9 => pan.pan;

NRev fRev => Pan2 feedPan => dac;
-0.7 => feedPan.pan;
0.05 => feedPan.gain;
chor => Delay feedback => Gain fDecay => feedback => fRev;

0.0005 => fRev.mix;
0.6 => fDecay.gain;
0.27::second => feedback.max =>  feedback.delay;

// Bb Aeolian scale
[46, 48, 49, 51, 53, 54, 56, 58] @=> int midiScale[];

0.625::second => dur quarter;
quarter * 2 => dur half;
quarter / 2 => dur eighth;
eighth / 2 => dur sixteenth;

quarter + eighth => dur dQuarter;
eighth + sixteenth => dur dEighth;
half / 3 => dur qTriplet;
quarter * 4 => dur measure;


[-1, 2, 1, 0, 2, 4, -7, 0, 3, 2, 1] @=> int melodyNotes[];
[quarter, (2*measure)-quarter, (2*measure)-half,
qTriplet, qTriplet, qTriplet, measure-eighth, eighth,
half+eighth, dQuarter, measure] @=> dur melodyRhythm[];

sixteenth * 0.3 => swing.max =>  swing.delay;
fun int arrayInterpret (int index) {
    0 => int octaves;
    if (index < (7-12)) {
        while (index < 0) {
            12 +=> index;
            octaves--;
        }
    } else if (index > 12) {
        while (index > 7) {
            12 -=> index;
            octaves++;
        }
    }

    return octaves;
}

while(true) {
    for (0 => int note; note < melodyNotes.cap(); note++) {
        melodyNotes[note] => int index;
        arrayInterpret(index) => int octave;
        index - (12 * octave) => index;
        if (index == -1) {
            0 => carr.freq;
            0 => carr.gain;
        } else {
            Std.mtof(midiScale[index]+(12*octave)+(12*3)) => carr.freq;
            1 => carr.gain;
            5 * carr.freq() => mod.freq;
            1 => env.keyOn;
        }
        (melodyRhythm[note] * (1.2/5.0), melodyRhythm[note] * (0.2/5.0), 0.9,
        melodyRhythm[note] * (2.0/5.0)) => env.set;
        melodyRhythm[note] * (2.0/5.0) => now;
        if (index != -1) {
            1 => env.keyOff;
        }
        melodyRhythm[note] * (3.0/5.0) => now;
    }
}
