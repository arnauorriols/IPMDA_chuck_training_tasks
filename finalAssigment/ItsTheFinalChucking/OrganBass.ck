/* ORGAN BASS DEFINITION CLASS */
public class OrganBass {
    // OSCs
    BeeThree org1, org2;
    SinOsc sub;
    Noise n;

    // FILTERS
    EnvelopedLPF ef;
    ef.filter @=> LPF mainFilter;
    LPF organsFilter;
    LPF noiseFilter;

    // ADSRs
    ADSR organsEnv;
    ADSR subEnv;

    // REVERBS
    JCRev mainRev;

    // PAN CONTROLS
    Pan2 mainPan;
    Pan2 feedPan;
    Pan2 feedGain;

    // DELAYS
    Delay feedback;

    // SOUND CHAIN
    // Main
    mainFilter => mainRev => mainPan => dac;

    // Organs
    org1 => organsFilter;
    org2 => organsFilter;
    organsFilter => organsEnv => mainFilter;

    // Sub
    sub => subEnv => mainFilter;

    // Noise
    n => noiseFilter => mainFilter;

    // feedback
    mainPan => feedback => feedGain => feedback => feedPan => dac;

    // SETTINGS
    // Main
    -0.3 => mainPan.pan;
    0.01 => mainRev.mix;
    ef.setEnv(5000.0, 800.0); // mainFilter settings

    // Organs
    0.35 => org1.gain;
    0.65 => org2.gain;
    // organsEnv
    (0.002::second, 0.1::second, 0, 0::second) => organsEnv.set;
    /*
    0.0025 => float OEnvAtt;
    0.125 => float OEnvDel;
    0.0 => float OenvSus;
    0.0 => float OEnvRel;
    */
    // organsFilter
    1300 => organsFilter.freq;
    5 => organsFilter.Q;
    0.95 => organsFilter.gain;

    // Sub
    0.5 => sub.gain;
    // subEnv
    (0.001::second, 0.1::second, 1, 0.5::second) => subEnv.set;
    /*
    0.01 => float SEnvAtt;
    1.0 => float SEnvDel;
    1.0 => float SEnvSus;
    0.714 => float SEnvRel;
    */

    // Noise
    0.02 => float noiseGain;
    2000 => noiseFilter.freq;

    // Feedback
    0.3 => feedPan.gain;
    0.7 => feedPan.pan;
    0.75 => feedGain.gain;
    0.13::second => feedback.max => feedback.delay;

    fun void setFreqs(float freq) {
        freq => org1.freq;
        (freq + 0.5) / 2.0 => org2.freq;
        freq / 2.0 => sub.freq;
    }

    fun void noteOn(float freq, dur rhythm) {
        setFreqs(freq);
        1.2 => org1.noteOn => org2.noteOn;
        1 => organsEnv.keyOn => subEnv.keyOn;
        noiseGain => n.gain;
        ef.keyOn(0.04::second);
        if (rhythm > 0.1::second) {
            0.1::second => now;
            1 => org1.noteOff => org2.noteOff;
            1 => subEnv.keyOff;
            0 => n.gain;
            rhythm - 0.1::second => now;
        } else {
            rhythm => now;
            1 => org1.noteOff => org2.noteOff;
            1 => organsEnv.keyOff => subEnv.keyOff;
            0 => n.gain;
        }
    }
}



