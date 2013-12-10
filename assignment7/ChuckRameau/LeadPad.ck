// Assignment_7_Chuck_Rameau

// Lead Pad instrument class. Play note calling playNote()

public class LeadPad {

    // synths
    SawOsc s1, s2;
    SawOsc multi[5];

    // ADSR
    ADSR env;

    // Enveloped LPF
    EnvelopedLPF filter;

    // Panning object
    Pan2 pan;

    // Chorus
    Chorus chor;
    1 / 4.0 => chor.modDepth;

    // Reverb
    NRev rev;
    0.01 => rev.mix;

    // Control parameters
    // center freq
    440.0 => float freq;

    // Gain of every Osc
    1 / 3.0 => float sharedGain;

    // Master gain control
    0.99 => float masterGain;

    // Detuning (cents)
    50.0 => float mainDetune;
    120.0 => float multiDetune;

    // Envelope (time in fraction of total)
    0.01 => float attack;
    0.2 => float decay;
    0.9 => float sustain;
    0.7 => float release;

    // Enveloped filter settings
    .3 => float filtDecay;
    15000.0 => float filtStart;
    3500.0 => float filtCut;

    // pre-constructor
    // Main sound chain
    env => filter.filter => chor => rev => pan;
    s1 => env;
    s2 => env;
    for (0 => int i; i < multi.cap(); i++) {
        multi[i] => env;
    }
    updateOscs();
    filter.setEnv(filtStart, filtCut, filtDecay);
    masterGain => pan.gain;

    fun void updateOscs() {
        Utils.centsInt(freq, -(mainDetune/2.0)) => s1.freq;
        Utils.centsInt(freq, mainDetune/2.0) => s2.freq;
        sharedGain => s1.gain => s2.gain;
        multiDetune / multi.cap() => float sharedDetune;
        Utils.changeOctave(freq, -1) => float multiFreq;
        for (0 => int i; i < multi.cap(); i++) {
            Utils.centsInt(multiFreq, sharedDetune * (i-2)) => multi[i].freq;
            sharedGain / multi.cap() => multi[i].gain;
        }
    }

    fun void chuckIt(UGen object) {
        pan => object;
    }

    fun void unchuckIt(UGen object) {
        pan =< object;
    }

    fun void playNote(float freq, dur rhythm) {
        env.set(attack * rhythm, decay * rhythm, sustain, release * rhythm);
        filter.setEnv(filtStart, filtCut, filtDecay * (rhythm/second));
        freq => this.freq;
        updateOscs();
        1 => env.keyOn;
        filter.keyOn();
        rhythm => now;
        1 => env.keyOff;
    }
}

