
Gain master => dac;

SndBuf kick => master;
SndBuf snare => master;
SndBuf hihat => master;

["kick_01.wav", "snare_01.wav", "hihat_01.wav"] @=> string filenames[];

me.sourceDir() + "/audio/" + filenames[0] => kick.read;
me.dir() + "/audio/" + filenames[1] => snare.read;
me.dir() + "/audio/" + filenames[2] => hihat.read;

kick.samples() => kick.pos;
snare.samples() => snare.pos;
hihat.samples() => hihat.pos;

0.7 => kick.rate;
0.6 => kick.gain;
0.4 => snare.gain;
0.5 => hihat.gain;

// REQUIREMENTS
30::second => dur maxDuration;
250::ms => dur quarter;
quarter / 2 => dur eighth;
eighth / 2 => dur sixteenth;
sixteenth / 2 => dur thirtySecond;

// METER
4 => int quarterForBar;

Std.ftoi(maxDuration / quarter) => int numQuarters;
Std.ftoi(numQuarters / quarterForBar) => int numMeasures;


// TIMEFLOW CONTROL
now => time start;
start + maxDuration => time end;
thirtySecond => dur loopRate;
0 => int measure;
-1 => int numQuarter;
-1 => int numEighth;
for( 0 => int counter; counter::loopRate < maxDuration; counter++) {

if (counter % (quarter/loopRate) == 0) {
    numQuarter++;
    numQuarter % quarterForBar=> int quarterInBar;
    0 => kick.pos;
    if (quarterInBar == 1 || quarterInBar == 3) {
        0 => snare.pos;
    }
}

if (counter % (eighth/loopRate) == 0) {
    numEighth++;
    <<<numEighth>>>;
    numEighth % (quarterForBar * Std.ftoi(quarter/eighth)) => int eighthInBar;
    if (eighthInBar % 2 != 0) {
        0 => hihat.pos;
    }
}
loopRate => now;


}
