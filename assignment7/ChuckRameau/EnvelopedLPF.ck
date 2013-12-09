public class EnvelopedLPF {
    LPF filter;

    1.5 => filter.Q;
    22000.0 => float filterStart;
    440.0 => float filterCutoff;
    0.1 => float envDecay;

    fun void envdrive() {
        filterStart - filterCutoff => float filterDiff;
        filterDiff / (envDecay::second/samp) => float freqStep;
        filterStart => float currentFreq;
        filterStart => filter.freq;
        for (0 => int sample; sample::samp <= envDecay::second; sample++) {
            1::samp => now;
            currentFreq - freqStep => filter.freq;
            filter.freq() => currentFreq;
        }
    }

    fun void setEnv(float fstart, float fco, float time) {
        fstart => filterStart;
        fco => filterCutoff;
        time => envDecay;
    }

    fun void keyOn(){
        spork ~ envdrive();
    }
}

