// Assignment_6_Chillin'_out

NRev rev => Pan2 drumsPan => dac;

0.04=> rev.mix;
0.5 => drumsPan.pan;

SndBuf hihat => PitShift pith => rev;
SndBuf kick => rev;
SndBuf snare => rev;

me.dir(-1) + "/audio/hihat_03.wav" => hihat.read;
me.dir(-1) + "/audio/kick_03.wav" => kick.read;
me.dir(-1) + "/audio/snare_03.wav" => snare.read;

2.3 => hihat.rate;
0.2 => hihat.gain;
1.7 => pith.shift;

0.7 => kick.rate;
0.5 => kick.gain;

0.8 => snare.rate;
0.3 => snare.gain;

hihat.samples() => hihat.pos;
kick.samples() => kick.pos;
snare.samples() => snare.pos;

0.625::second => dur quarter;
quarter * 2 => dur half;
quarter / 2 => dur eighth;
eighth / 2 => dur sixteenth;

quarter + eighth => dur dQuarter;
eighth + sixteenth => dur dEighth;
quarter * 4 => dur measure;

[1, 0, 0, 0,   1, 0, 0, 1,   1, 0, 0, 0,   1, 0, 0, 1] @=> int hihatBeat[];
[0, 0, 0, 0,   1, 0, 0, 0,   0, 0, 0, 0,   1, 0, 0, 0] @=> int kickBeat[];
[0, 0, 0, 0,   0, 0, 0, 0,   1, 0, 0, 1,   0, 0, 0, 0] @=> int snareBeat[];

while (true) {
    for(0 => int beat; beat < hihatBeat.cap(); beat++) {
        if (hihatBeat[beat] == 1) {
            0 => hihat.pos;
        }
        if (kickBeat[beat] == 1) {
            0 => kick.pos;
        }
        if (snareBeat[beat] == 1) {
            0 => snare.pos;
        }

        sixteenth => now;
    }
}

1::second => now;
