// DRUMS PART SCORE

NRev rev => Pan2 pan => dac;
rev => Pan2 double => dac;

SndBuf kick => LPF kickFilt => rev;
SndBuf kick2 => PitShift kick2Shift => rev;
SndBuf hihat => rev;
SndBuf clap => rev;

0.01 => rev.mix;

0.4 => hihat.gain;
1.8 => hihat.rate;
0.9 => kick.gain;
0.8 => kick2.gain;
1.3 => kick2.rate;
-0.9 => kick2Shift.shift;
1.3 => kick.rate;
200 => kickFilt.freq;
1 => kickFilt.Q;
0.7 => clap.gain;
1.3 => clap.rate;



0.5 => pan.pan;
0.1 => pan.gain;
0.2 => double.gain;
-0.5 => double.pan;

me.dir(-1) + "/audio/kick_04.wav" => kick.read;
me.dir(-1) + "/audio/kick_01.wav" => kick2.read;
me.dir(-1) + "/audio/hihat_01.wav" => hihat.read;
me.dir(-1) + "/audio/clap_01.wav" => clap.read;

kick.samples() => kick.pos;
kick2.samples() => kick2.pos;
hihat.samples() => hihat.pos;
clap.samples() => clap.pos;


[1, 0, 0, 0,   1, 0, 0, 0,   1, 0, 0, 0,   1, 0, 0, 0] @=> int kickArray[];
[0, 0, 1, 0,   0, 0, 1, 0,   0, 0, 1, 0,   0, 0, 1, 0] @=> int hihatArray[];
[1, 0, 0, 0,   0, 0, 1, 0,   0, 0, 1, 1,   0, 1, 0, 1] @=> int clapArray[];

while(true) {
    for (0 => int x; x < kickArray.cap(); x++) {
        if (kickArray[x] == 1) {
            0 => kick.pos;
            0 => kick2.pos;
        }
        if (hihatArray[x] == 1) {
            0 => hihat.pos;
        }
        if (clapArray[x] == 1) {
            0 => clap.pos;
        }
    RhythmCtl.sixteenth => now;
    }

}
