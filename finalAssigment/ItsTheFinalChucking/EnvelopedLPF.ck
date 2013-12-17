// Assignment_7_Chuck_Rameau

// Enveloped Low Pass Filter

public class EnvelopedLPF {
    LPF filter;

    1.5 => filter.Q;
    22000.0 => float filterStart;
    440.0 => float filterCutoff;
    0.1::second => dur envDecay;

    fun void envdrive() {
        filterStart - filterCutoff => float filterDiff;
        filterDiff / (envDecay/samp) => float freqStep;
        filterStart => float currentFreq;
        filterStart => filter.freq;
        for (0 => int sample; sample::samp <= envDecay; sample++) {
            1::samp => now;
            currentFreq - freqStep => filter.freq;
            filter.freq() => currentFreq;
        }
    }

    /*
     * Configure envelope:
     *     - fstart: starting frequency
     *     - fco: end frequency
     *     - time: ramp down duration
     */
    fun void setEnv(float fstart, float fco) {
        fstart => filterStart;
        fco => filterCutoff;
    }

    fun void keyOn(dur time){
        time => envDecay;
        spork ~ envdrive();
    }
}

