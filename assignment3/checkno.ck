
Gain master => dac;
0.9 => master.gain;
SndBuf kick => master;
SndBuf snare => master;
SndBuf hihat => master;

["kick_04.wav", "snare_03.wav", "hihat_01.wav"] @=> string filenames[];

me.sourceDir() + "/audio/" + filenames[0] => kick.read;
me.dir() + "/audio/" + filenames[1] => snare.read;
me.dir() + "/audio/" + filenames[2] => hihat.read;



0.5 => float kickRate;
0.9 => float kickGain;
-1.6 => float snareRate;
0.4 => float snareGain;
1.7 => float hihatRate;
0.5 => float hihatGain;

2000 => int snareArrayStart;
0 => int kickStart;
snare.samples()-snareArrayStart => int snareStart;
0 => int hihatStart;

// REQUIREMENTS
30::second => dur maxDuration;
250::ms => dur quarter;
quarter * 2 => dur half;
quarter / 2 => dur eighth;
eighth / 2 => dur sixteenth;
sixteenth / 2 => dur thirtySecond;

// METER
8 => int quarterForBar;

Std.ftoi(maxDuration / quarter) => int numQuarters;
Std.ftoi(numQuarters / quarterForBar) => int numMeasures;

// TIMEFLOW CONTROL
now => time start;
start + maxDuration => time end;
thirtySecond => dur loopRate;

0 => int measure;
-1 => int numQuarter;
-1 => int numEighth;
-1 => int numSixteenth;
-1 => int numHalf;

/* EXPLANATION
 * ===========
 * numX accounts for the absolute number that x has occurred
 * xInBar accounts for the position of x relative to the measure
 */

kickStart + (Std.ftoi(Std.sgn(kickRate)) * kick.samples()) => kick.pos;
snareStart + (Std.ftoi(Std.sgn(snareRate)) * (snare.samples()-snareArrayStart)) => snare.pos;
hihatStart + (Std.ftoi(Std.sgn(hihatRate)) * hihat.samples()) => hihat.pos;

<<<snare.pos()>>>;

for( 0 => int counter; counter::loopRate < maxDuration; counter++) {

int sixteenthInBar;
int eighthInBar;
int quarterInBar;
int halfInBar;



    if (counter % (sixteenth/loopRate) == 0) {
        numSixteenth++;
        numSixteenth % Std.ftoi(quarterForBar * (quarter/sixteenth)) => sixteenthInBar;
        if (counter % (eighth/loopRate) == 0) {
            numEighth++;
            numEighth % Std.ftoi(quarterForBar * (quarter/eighth)) => eighthInBar;
            if (counter % (quarter/loopRate) == 0) {
                numQuarter++;
                numQuarter % quarterForBar=> quarterInBar;
                if (counter % (half/loopRate) == 0) {
                    numHalf++;
                    numHalf % Std.ftoi(quarterForBar * (quarter/half)) => halfInBar;
                    kickRate => kick.rate;
                    kickGain => kick.gain;
                    snareRate => snare.rate;
                    snareGain => snare.gain;
                    hihatRate => hihat.rate;
                    hihatGain => hihat.gain;
                    0 => kick.pos;
                    if (halfInBar == 1 || halfInBar == 3) {
                        snareStart=> snare.pos;
                    }
                }
                if( quarterInBar == 3 || quarterInBar == 7 ) {
                    kick.rate() + (kick.rate()*0.2) => kick.rate;
                    kick.gain() - (kick.gain()*0.95) => kick.gain;
                    0 => kick.pos;
                }
                if (quarterInBar % 2 != 0) {
                    0 => hihat.pos;
                }

            }

        }
    }

loopRate => now;
}
