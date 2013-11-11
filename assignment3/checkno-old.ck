Gain master => dac;

Gain drums => master;
Gain staticBass => master;
Gain harmony => master;
Gain riff => master;

0.9 => master.gain;
0.7 => drums.gain;

SndBuf kick => drums;
SndBuf kick2 => drums;
SndBuf snare => drums;
SndBuf hihat => drums;
SndBuf hihat2 => drums;

SinOsc sin1 => staticBass;
SinOsc sin2 => staticBass;

TriOsc chords[3];

for (0 => int x; x <chords.cap(); x++) {
    TriOsc o @=> chords[x];
    1.0/chords.cap() => o.gain;
    o => harmony;
}

SqrOsc melody => riff;
SawOsc melody2 => riff;
1 => melody.gain;


["kick_04.wav", "snare_03.wav", "hihat_01.wav"] @=> string filenames[];

me.sourceDir() + "/audio/" + filenames[0] => kick.read;
me.sourceDir() + "/audio/" + filenames[0] => kick2.read;
me.dir() + "/audio/" + filenames[1] => snare.read;
me.dir() + "/audio/" + filenames[2] => hihat.read;
me.dir() + "/audio/" + filenames[2] => hihat2.read;



0.5 => float kickRate;
0.9 => float kickGain;
-1.6 => float snareRate;
0.4 => float snareGain;
1.7 => float hihatRate;
0.5 => float hihatGain;

kickRate => kick.rate;

kickRate + (kick.rate()*0.2) => kick2.rate;
kickGain - (kick.gain()*0.95) => kick2.gain;
snareRate => snare.rate;
snareGain => snare.gain;
hihatRate => hihat.rate;
hihatGain => hihat.gain;
hihatRate => hihat2.rate;
hihatGain - (hihat.gain()*0.4) => hihat2.gain;


3000 => int snareArrayStart;
0 => int kickStart;
0 => int kick2Start;
snare.samples()-snareArrayStart => int snareStart;
0 => int hihatStart;
0 => int hihat2Start;

// SCALE DEFINITION:
[50, 52, 53, 55, 57, 59, 60] @=> int dorianScale[];
12 => int octave;

[0, 4, 2] @=> int index4Dm7[]; // Indexes for D minor 7 chord
[-1, -1, 0] @=> int DM7Octaves[];

[3, 5, 0] @=> int index4Bdim7[]; // Indexes for B diminished with minor 7 chord
[-2, -1, 0] @=> int Bdim7Octaves[];


// REQUIREMENTS
30::second => dur maxDuration;
250::ms => dur quarter;
quarter * 2 => dur half;
quarter / 2 => dur eighth;
eighth / 2 => dur sixteenth;
sixteenth / 2 => dur thirtySecond;

// METER
8 => int quarterForBar;
quarter * quarterForBar => dur measure;

Std.ftoi(maxDuration / quarter) => int numQuarters;
Std.ftoi(numQuarters / quarterForBar) => int maxMeasures;

// TIMEFLOW CONTROL
now => time start;
start + maxDuration => time end;
thirtySecond => dur loopRate;

-1 => int numQuarter;
-1 => int numEighth;
-1 => int numSixteenth;
-1 => int numHalf;
-1 => int numMeasure;

int sixteenthInBar;
int eighthInBar;
int quarterInBar;
int halfInBar;
int measureInComposition;
int measureInHarmonyLoop;

/* EXPLANATION
* ===========
* numX accounts for the absolute number that x has occurred
* xInBar accounts for the position of x relative to the measure
*/

kickStart + (Std.ftoi(Std.sgn(kickRate)) * kick.samples()) => kick.pos;
kick2Start + (Std.ftoi(Std.sgn(kick2.rate())) * kick2.samples()) => kick2.pos;
snareStart + (Std.ftoi(Std.sgn(snareRate)) * (snare.samples()-snareArrayStart)) => snare.pos;
hihatStart + (Std.ftoi(Std.sgn(hihatRate)) * hihat.samples()) => hihat.pos;
hihat2Start + (Std.ftoi(Std.sgn(hihat2.rate())) * hihat2.samples()) => hihat2.pos;


for( 0 => int counter; counter::loopRate < maxDuration; counter++) {

    if (counter % (measure/loopRate) == 0) {
        numMeasure++;
        <<<numMeasure>>>;
    }
    /* MEASURE SCOPE SETTING */
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


                    /* HALF NOTES PLAYGROUND */
                    kickStart => kick.pos;
                    if (halfInBar == 1 || halfInBar == 3) {
                        snareStart => snare.pos;
                    }
                }
                /* QUARTER NOTES PLAYGROUND */
                if( quarterInBar == 3 || quarterInBar == 7 ) {
                    kickStart => kick2.pos;
                }
                if (quarterInBar % 2 != 0) {
                    hihatStart => hihat.pos;
                }

                }
            /* EIGHTH NOTES PLAYGROUND */
            if (eighthInBar == 7) {
                hihatStart => hihat2.pos;
            }

            if (eighthInBar == 0 || eighthInBar == 6) {
                0.4 => melody.gain;
                0.4 => melody2.gain;
                Std.mtof(dorianScale[0]+ (2 * octave)) => melody.freq;
                Std.mtof(dorianScale[0] + (2 * octave))+10 => melody2.freq;
            } else if (eighthInBar == 2 || (eighthInBar >= 7 && eighthInBar
            <=9)) {
                0.4 => melody.gain;
                0.4 => melody2.gain;
                Std.mtof(dorianScale[4] + (2 * octave)) => melody.freq;
                Std.mtof(dorianScale[4] + (2 * octave))+10 => melody2.freq;
            } else if (eighthInBar == 4 || eighthInBar == 11) {
                0.4 => melody.gain;
                0.4 => melody2.gain;
                Std.mtof(dorianScale[6] + (2 * octave)) => melody.freq;
                Std.mtof(dorianScale[6] + (2 * octave))-5 => melody2.freq;
            } else {
                0 => melody.gain;
                0 => melody2.gain;
            }


        }
        /* SIXTEENTH NOTES PLAYGROUND */
    }
    /* THIRTY-SECOND NOTES PLAYGROUND */

if (numMeasure < 2) {
    0 => drums.gain;
    0 => harmony.gain;
    0 => riff.gain;
    0.9 => staticBass.gain;
    0.3 => sin1.gain;
    0.3 => sin2.gain;
    60 => sin1.freq;
    sin1.freq() + counter/5.5 => sin2.freq;
} else if (numMeasure == 2) {
    1 => master.gain;
    0.5 => staticBass.gain;
    0.5 => drums.gain;
} else if (numMeasure > 2) {

    (numMeasure-3) % 4 => measureInHarmonyLoop;

    if (eighthInBar == 0
        || (eighthInBar == 7)){
        <<<"harmony plays!">>>;
        0.5 => harmony.gain;
        if (measureInHarmonyLoop == 0) {
            for (0 => int x; x < chords.cap(); x++) {
                Std.mtof(dorianScale[index4Dm7[x]] + (DM7Octaves[x] * octave)) => chords[x].freq;
                <<<chords[x].freq()>>>;
            }
        } else if (measureInHarmonyLoop == 2) {
            for (0 => int x; x < chords.cap(); x++) {
                Std.mtof(dorianScale[index4Bdim7[x]] + (Bdim7Octaves[x] * octave)) => chords[x].freq;
            }
        }
    } else {
    0 => harmony.gain;
    }
    0.04 => riff.gain;
    0.1 => staticBass.gain;
    0.4 => drums.gain;
}
loopRate => now;
}
