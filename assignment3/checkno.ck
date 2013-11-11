/* IPMDA Assignment 3: CHECKNO
 *
 * Date: 11-11-2013
 */

<<<"Assignment_3_CHECKNO">>>;


Pan2 master => dac;     // Master gain nob. It is a Pan2 object to keep the
                        // stereo configuration

/* All these Pan2 work both as gain nobs and pan nobs, as all Unit Generators
 * have a gain property.
 */
Pan2 drums => master;
Pan2 staticDrone => master;
Pan2 bass => master;
Pan2 riff => master;

/* Not a fan of randomness, but it's required, so here it is */
Math.random2f(0.3, 0.5) => drums.pan;
0 => staticDrone.pan;
Math.random2f(-0.5, -0.3) => bass.pan;
0 => riff.pan;

/* DRUMS SET: 2 different kicks, 1 snare and 2 hihats */
SndBuf kick => drums;
SndBuf kick2 => drums;
SndBuf snare => drums;
SndBuf hihat => drums;
SndBuf hihat2 => drums;

/* 2 Sinusoidal Oscillators works as an static drone that gives unity to the
 * composition.
 */
SinOsc sin1 => staticDrone;
SinOsc sin2 => staticDrone;
0.45 => sin1.gain;
0.45 => sin2.gain;

/* The bass line is wanted very distorted, so it's made of an Square and a Saw
 * Oscillators.
 */
SqrOsc b => bass;
SawOsc b2 => bass;
0.45 => b.gain;
0.45 => b2.gain;

/* The melodic riff that starts at measure 8 is made of a Triangle and a Saw
 * Oscillators.
 */
TriOsc r => riff;
SawOsc r2 => riff;
0.8 => r.gain;
0.2 => r2.gain;

/* The samples filename. Don't freak out! audio directory is added later to the
 * full path string.
 */
["kick_04.wav", "snare_03.wav", "hihat_01.wav"] @=> string filenames[];

me.sourceDir() + "/audio/" + filenames[0] => kick.read;
me.sourceDir() + "/audio/" + filenames[0] => kick2.read;
me.dir() + "/audio/" + filenames[1] => snare.read;
me.dir() + "/audio/" + filenames[2] => hihat.read;
me.dir() + "/audio/" + filenames[2] => hihat2.read;

/* Settings of the samples' rate and gain */
0.5 => float kickRate;
0.9 => float kickGain;
-1.6 => float snareRate;
0.4 => float snareGain;
1.7 => float hihatRate;
0.5 => float hihatGain;

/* Chucking the settings to the SndBuf */
kickRate => kick.rate;
/* kick2 rate and gain are relative to the standard kick ones */
kickRate + (kick.rate()*0.2) => kick2.rate;
kickGain - (kick.gain()*0.95) => kick2.gain;
snareRate => snare.rate;
snareGain => snare.gain;
hihatRate => hihat.rate;
hihatGain => hihat.gain;
hihatRate => hihat2.rate;
hihatGain - (hihat.gain()*0.6) => hihat2.gain;

/* Define Start points in the SndBuf array of samples. */
3000 => int snareArrayStart;
0 => int kickStart;
0 => int kick2Start;
snare.samples()-snareArrayStart => int snareStart;
0 => int hihatStart;
0 => int hihat2Start;

// SCALE DEFINITION:
[50, 52, 53, 55, 57, 59, 60] @=> int dorianScale[];
12 => int octave;    // multiply octave for the number of octaves up or down (negative)

// METER DEFINITION
8 => int quarterForBar;

// RHYTHM DURATIONS DEFINITION
30::second => dur maxDuration;
250::ms => dur quarter;
quarter * 2 => dur half;
quarter / 2 => dur eighth;
eighth / 2 => dur sixteenth;
sixteenth / 2 => dur thirtySecond;
quarter * quarterForBar => dur measure;

// TIMEFLOW CONTROL
now => time start;
thirtySecond => dur loopRate;   // speed of the loop. Timing clock of the
                                // composition.

// ABSOLUTE COUNTERS FOR THE DIFFERENT RHYTHM NOTES.
/* These will keep track of the absolute number of the corresponding rhythm
 * during the composition.
 */
-1 => int numQuarter;
-1 => int numEighth;
-1 => int numSixteenth;
-1 => int numHalf;
-1 => int numMeasure;

// RELATIVE COUNTERS FOR THE DIFFERENT RHYTHM NOTES.
/* These will keep track of the number of the corresponding rhythm inside each
 * measure.
 */
int sixteenthInBar;
int eighthInBar;
int quarterInBar;
int halfInBar;
int measureInBassLoop;

// BEAT EFFECT CONTROL FOR THE DRONE
0 => int droneModulation;

/* Not usefully complex way of silencing the samples. This is the same as
 * saying kick.samples() => kick.pos, kick2.samples() => kick2.pos,...
 * but with the advantage that you don't have to change it when you decide to
 * reverse the sample, it will set the position to the correct end of the array.
 */
kickStart + (Std.ftoi(Std.sgn(kickRate)) * kick.samples()) => kick.pos;
kick2Start + (Std.ftoi(Std.sgn(kick2.rate())) * kick2.samples()) => kick2.pos;
snareStart + (Std.ftoi(Std.sgn(snareRate)) * snareStart) => snare.pos;
hihatStart + (Std.ftoi(Std.sgn(hihatRate)) * hihat.samples()) => hihat.pos;
hihat2Start + (Std.ftoi(Std.sgn(hihat2.rate())) * hihat2.samples()) => hihat2.pos;

/* LOGIC EXPLANATION
 * =================
 *
 * loopRate is set to thirty-second notes, and there are 8 quarter notes per
 * bar (to comply with the 0.25::second requirement and still having an
 * appropiate bpm). loopRate is that low to have the capacity to modulate the
 * sound and a proper speed, like in the drone beat effect.
 *
 * Using nested if statements, the absolute and relative counters are updated
 * when required, and SndBufs and played when required. This layering approach
 * gives us a seamless way to control the SndBuf with different rhythms, instead
 * of counting everything at the layer of thirty-second notes.
 *
 * The structure of the composition is controled with numMeasure counter,
 * setting the different gains for each instrument group and definning the
 * oscillators notes, which doesn't require this special approach of the SndBuf.
 */
for( 0 => int counter; counter::loopRate < maxDuration; counter++) {

    /* Keep track of the current measure. Every time counter fills a whole
     * measure, increase numMeasure
     */
    if (counter % (measure/loopRate) == 0) {
        numMeasure++;
        <<<numMeasure>>>;
    }

    /* UPDATE COUNTERS AND DEFINE DRUMS RHYTHM */
    if (counter % (sixteenth/loopRate) == 0) {
        numSixteenth++;         // Absolute number of sixteenth notes in the composition
        numSixteenth % Std.ftoi(
                quarterForBar *(quarter/sixteenth)) => sixteenthInBar;
        if (counter % (eighth/loopRate) == 0) {
            numEighth++;
            numEighth % Std.ftoi(
                    quarterForBar * (quarter/eighth)) => eighthInBar;
            if (counter % (quarter/loopRate) == 0) {
                numQuarter++;
                numQuarter % quarterForBar => quarterInBar;
                if (counter % (half/loopRate) == 0) {
                    numHalf++;
                    numHalf % Std.ftoi(
                            quarterForBar * (quarter/half)) => halfInBar;

                    /* Taking advantage of this layered approach, the if
                     * statements define the "playgrounds" for the different
                     * rhythms that can be played.
                     */

                    /* HALF NOTES PLAYGROUND */
                    kickStart => kick.pos;      // Play the kick every half note
                    if (halfInBar == 1 || halfInBar == 3) {
                        /* Play the snare on halves 1 and 3 (range 0 - 3)*/
                        snareStart => snare.pos;
                    }
                }

                /* QUARTER NOTES PLAYGROUND */
                if( quarterInBar == 3 || quarterInBar == 7 ) {
                    /* Play kick2 on quarters 3 and 7 (range 0 - 7) */
                    kickStart => kick2.pos;
                }
                <<<"quarter", quarterInBar>>>;
                if (quarterInBar % 2 != 0) {
                    /* Play hihat every odd quarter (1, 3, 5 - range (0 - 7)) */
                    hihatStart => hihat.pos;
                }
            }

            /* EIGHTH NOTES PLAYGROUND */
            if (eighthInBar == 7) {
                /* Play second hihat only in 7th eighth (range 0 - 16) */
                hihatStart  => hihat2.pos;
            }
        }
        /* SIXTEENTH NOTES PLAYGROUND */
    }
    /* THIRTY-SECOND NOTES PLAYGROUND */


    // STRUCTURE OF THE COMPOSITION's DEFINITION
    if (numMeasure < 2) {
        /* FIRST 2 MEASURES, play the beat effect of the drone as an entrance */
        0.95 => master.gain;
        0 => drums.gain;
        0 => bass.gain;
        0 => riff.gain;
        1 => staticDrone.gain;

        /* Beat effect: sin2 distances progressively from sin1 in frequency,
         * generating a beat that gets quicker as more distance is between the
         * frequencies.
         */
        Std.mtof(dorianScale[5] + (-2 * octave)) => sin1.freq;
        sin1.freq() + (droneModulation/5.5) => sin2.freq;
        droneModulation++;

    } else if (numMeasure == 2) {
        /* THIRD MEASURE, play only the drums groove. */
        0.5 => staticDrone.gain;
        0.5 => drums.gain;
    } else if (numMeasure > 2) {
        /* FOURTH MEASURE, reduce the drone gain to be barely perceptible,
         * and start the bass line
         */
        0.1 => staticDrone.gain;
        0.5 => drums.gain;

        /* The bass line loop lasts 2 measures, plays D - B in first measure,
         * and E - F in second measure.
         */
        (numMeasure-3) % 2 => measureInBassLoop;
        if (measureInBassLoop == 0) {
            if (eighthInBar == 3) {
                Std.mtof(dorianScale[0] + (-1 * octave)) => float note;

                /* To achieve some kind of distortion, the frequencies of the
                 * two oscillators that conform the bass are distantiated 5 Hz
                 */
                note => b.freq;
                note - 5 => b2.freq;
                0.3 => bass.gain;
            } else if (eighthInBar == 8 || eighthInBar == 15) {
                Std.mtof(dorianScale[5] + (-2 * octave)) => float note;
                note => b.freq;
                note - 5 => b2.freq;
                0.3 => bass.gain;
            } else {
                0 => bass.gain; // Mute the bass to make it sound only in the
                                // desired eighth notes
            }

        } else {
            if (eighthInBar == 3) {
                Std.mtof(dorianScale[1] + (-1 * octave)) => float note;
                note => b.freq;
                note - 5 => b2.freq;
                0.3 => bass.gain;
            } else if (eighthInBar == 8 || eighthInBar == 15) {
                Std.mtof(dorianScale[2] + (-1 * octave)) => float note;
                note => b.freq;
                note - 5 => b2.freq;
                0.3 => bass.gain;
            } else {
                0 => bass.gain;
            }
        }
    }

    if (numMeasure > 6 && numMeasure <= 13) {
        /* EIGHTH MEASURE, add the melodic riff. Note that is not a else if, as
         * this is adding a feature, while the rest keeps the same. */

        /* ((quarter/eighth) * quarterForBar) * 7 is the number of eighth notes
         * until the 7th measure.
         */
        (numEighth - (((quarter/eighth)*quarterForBar) * 7)) % 2 => float eighthInRiff;
        if (eighthInBar == 0) {
            Std.mtof(dorianScale[0] + (1 * octave)) => float noteRiff;
            noteRiff => r.freq;
            noteRiff + 10 => r2.freq;
            0.1 => riff.gain;
            Math.sin(2*pi*((now/second)/2)) => riff.pan;   // Set a waving pan
        } else if (eighthInBar == 1
                   || eighthInBar == 3
                   || eighthInBar == 7
                   || eighthInBar == 11
                   || eighthInBar == 15 ) {
            Std.mtof(dorianScale[5] + (0 * octave)) => float noteRiff;
            noteRiff => r.freq;
            noteRiff + 5 => r2.freq;
            0.1 => riff.gain;
            Math.sin(2*pi*((now/second)/2)) * 0.7 => riff.pan;
        } else {
            0 => riff.gain;
        }

    } else if (numMeasure > 13) {
        /* LAST MEASURE (14th), reverse the beat effect as a closure */
        0 => drums.gain;
        0 => bass.gain;
        0 => riff.gain;
        1 => staticDrone.gain;
        if (sin2.freq() > sin1.freq()){
        sin1.freq() + (droneModulation/5.5) => sin2.freq;
        droneModulation - 3 => droneModulation;
        }
    }
    loopRate => now; // Every loop execution, time advances loopRate (currently 32th note)
}
<<<"End. Total duration:", (now-start)/second, "seconds.">>>;
