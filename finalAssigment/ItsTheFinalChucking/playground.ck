// PLAYGROUND FILE TO TEST DIFFERENT FEATURES

// LOOKING FOR A MASSIVE'S FLENDERS SUBSTITUTE
EnvelopedLPF ef;
ef.filter => JCRev rev => Pan2 mainpan => dac;
-0.3 => mainpan.pan;
mainpan => Delay feedback => Pan2 feedpan => feedback => Pan2 endpan => dac;
0.7 => endpan.pan;
0.3 => endpan.gain;
0.75 => feedpan.gain;
.13::second => feedback.max => feedback.delay;
ef.setEnv(5000, 800);
ADSR masterenv => ef.filter;
BeeThree test => LPF filter => masterenv;
0.01 => rev.mix;
BeeThree test2 => filter;
SinOsc sub => ADSR env => ef.filter;
Noise n => LPF nf => ef.filter;
2000 => nf.freq;
0.08 => n.gain;
(0.002::second, 0.1::second, 0, 0::second) => masterenv.set;
(0.001::second, 0.1::second, 1, 0.5::second) => env.set;
0.5 => sub.gain;
1300 => filter.freq;
5 => filter.Q;
0.95 => filter.gain;
0.35 => test.gain;
0.65 => test2.gain;
[40, 42, 43, 33, 36, 38] @=> int notes[];

while(true) {
    for (0 => int x; x < notes.cap(); x++) {
        Std.mtof(notes[x]) => test.freq;
        (test.freq() + 0.5) / 2 => test2.freq;
        test.freq() / 2 => sub.freq;
        1.2 => test2.noteOn;
        1.2 => test.noteOn;
        1 => masterenv.keyOn;
        1 => env.keyOn;
        0.02 => n.gain;
        ef.keyOn(0.04::second);
        0.1::second => now;
        1 => test2.noteOff;
        1 => test.noteOff;
        1 => env.keyOff;
        0 => n.gain;
        0.7::second => now;
    }
}

