Mandolin bass => Delay d => NRev rev => Pan2 pan => dac;
0.05 => rev.mix;
0.9 => pan.gain;
-0.3 => pan.pan;



// Db Aeolian scale
[46, 48, 49, 51, 53, 54, 56, 58] @=> int midiScale[];

// Bass sequence
[0, 3, 6, 2, 5, 1, 4] @=> int seq[];

// Bass grace notes
[[0, 6, 5, 4], [0, 3, 0, 6]] @=> int graces[][];

0.625::second => dur quarter;
quarter * 2 => dur half;
quarter / 2 => dur eighth;
eighth / 2 => dur sixteenth;

quarter + eighth => dur dQuarter;
eighth + sixteenth => dur dEighth;
quarter * 4 => dur measure;

// Bass setup
0.2 => bass.stringDamping;
0.001 => bass.stringDetune;
0.01 => bass.bodySize;

// set Swing
sixteenth * 0.1 => dur swing;
2 * swing => d.max;

fun int changeOctave(int midiNote, int numOctaves) {
    return (midiNote + (12 * numOctaves));
}

fun void playFundamentals(int note) {
    0 => int octave;
    if (note == 56 || note == 54 || note == 53) {
        -2 => octave;
    } else {
        -1 => octave;
    }
    Std.mtof(changeOctave(note, octave)) => bass.freq;
    Math.random2f(0.4, 0.6) => bass.pluckPos;
    Math.random2f(0.1, 0.5) => float on;
    on => bass.noteOn;
    <<<"first", on>>>;
    swing => d.delay;
    eighth => now;
    0.0001 => bass.noteOff;
    quarter => now;
    Math.random2f(0.05, 0.3) => on;
    Math.random2f(1.4, 1.8) * swing => d.delay;
    on => bass.noteOn;
    <<<"Second", on>>>;
    eighth => now;
    0.0001 => bass.noteOff;
    quarter => now;
    Math.random2f(0.2, 0.6) => on;
    swing * 1.2 => d.delay;
    on => bass.noteOn;
    <<<"Third", on>>>;
    dEighth => now;
    0.001 => bass.noteOff;
    sixteenth => now;
}

fun void screamDac() {
    for(0::samp => dur i; i < measure; i + 1::samp => i){
        if (Std.fabs(dac.last()) > 1.0) <<<"ERROOOOOOR! Too loud!!!">>>;
        if ((now/second % 10) == 0.0) <<<"Dac is monitored, you are safe">>>;
        1::samp => now;
    }
}

while(true) {
    for(0 => int i; i < seq.cap(); i++){
        spork ~ playFundamentals(midiScale[seq[i]]);
  //      spork ~ screamDac();
        measure => now;
    }
}

