4 => int quartersMeasure;

.6::second => dur quarter;
quarter * quartersMeasure => dur measure;
quarter * 2 => dur half;
quarter / 2 => dur eighth;
eighth / 2 => dur sixteenth;
quarter + eighth => dur dQuarter;
eighth + sixteenth => dur dEighth;

sixteenth => dur beat;
1::ms => dur loopRate;

Std.ftoi(quarter/beat) => float quarterPerBeat;
Std.ftoi(eighth/beat) => float eighthPerBeat;
Std.ftoi(sixteenth/beat) => float sixteenthPerBeat;


/* Define some rhythm patters (for measure) 
 * 2D array: [[duration/beat], [play(1) or silence(0)]]
 */
[[[eighthPerBeat, eighthPerBeat, sixteenthPerBeat, eighthPerBeat,
sixteenthPerBeat, eighthPerBeat, sixteenthPerBeat, eighthPerBeat,
sixteenthPerBeat, eighthPerBeat], [0.0, 0.4, .0, 0.6, .0, 0.9, .0, 0.5, .0, 0.3]]]
@=> float
rhythmPatterns[][][];
fun float getFreq (int midiNote) {
    return Std.mtof(midiNote);
}

fun int btolr(int numBeats){
    return (numBeats * Std.ftoi(beat/loopRate));
}

fun int rtolr(dur aRhythm) {
    return Std.ftoi(aRhythm/loopRate);
}

fun int changeOctave(int midiNote, int octaveDistance) {
    return (midiNote + (12 * octaveDistance));
}

/* Returns 2D array:
 *      [[freq1, freq2, fre3, freqx], [gain1, gain2, gain3, gainx]]
 */
fun float[][] buildChord(int midiRoot, string mode, int numNotesChord) {
    float chord[numNotesChord][2];
    int midiChordRelatives[3];
    if (numNotesChord >= 3) {
        if (mode == "major" || mode == "M") {
            [0, 4, 7] @=> midiChordRelatives;
        } else if (mode == "minor" || mode == "m") {
            [0, 3, 7] @=> midiChordRelatives;
        } else {
            <<<"possible modes: 'major' (or 'M') or 'minor' (or 'm')">>>;
            return [[0.0, 0.0, 0.0], [0.0, 0.0, 0.0]]; //Return silence
        }

        // Root
        getFreq(midiRoot) => chord[0][0];

        // Third
        getFreq(midiRoot+midiChordRelatives[1]) => chord[1][0];

        // Fifth
        getFreq(midiRoot+midiChordRelatives[2]) => chord[2][0];

        for (3 => int x; x < numNotesChord; x++) {
            /* Add any possible note to the next chord components. Every 3
             * notes change to 1 octave higher.
             */
            getFreq(changeOctave(midiRoot, Std.ftoi(x/3))) => chord[x][0];
        }

        // Set standard relative gain to be shared by all notes:
        for (0 => int x; x < numNotesChord; x++) {
            1/numNotesChord => chord[x][1];
        }
        return chord;
    } else {
        <<<"Error. Chords should be of 3 or more notes.">>>;
        return [[0.0, 0.0, 0.0] , [0.0, 0.0, 0.0]];
    }
}

fun float[][][] setChords(int roots[], string mode[], int notesChord, dur rhythm[]){
    if (roots.cap() == mode.cap()){
        0 => int numSamples;
        /* Initiallize numSamples */
        for(0 => int x; x < rhythm.cap(); x++) {
            numSamples + rtolr(rhythm[x]) => numSamples;    // Rhythm to loopRate
        }
        float chords[numSamples][notesChord][2]; // 2, for frequency and gain
                                                 // for each sample, for each note in the chord
        float aChord[][]; // Temporal array
        0 => int currentSample;   // Tracking current index of chords array
        for (0 => int x; x < roots.cap(); x++) {
            rtolr(rhythm[x]) => int aRhythm;
            for (0 => int y; y < aRhythm; y++) {
             if (currentSample != chords.cap()){
            if (roots[x] > 0) {
                buildChord(roots[x], mode[x], notesChord) @=>
                chords[currentSample];    // Returns array with each note freq
            } else {
                /* if root note is 0, means silence */
                [[0.0, 0.0, 0.0],[0.0, 0.0, 0.0]] @=> chords[currentSample];
            }
                 } else {
                     <<<"Error filling chords array. Out of bounds!">>>;
                 }
                currentSample++;
            }
        }
        return chords;
    } else {
        <<<"Error setting chords: arrays must be of the same size">>>;
    }
}

/* Sets the envelope to a note in the samplesToEnvelope array.
 * samplesToEnvelope contains all the samples of the whole sound, the note is
 * extracted from this big array using positionInArray and duration.
 * positionInArray should specify the start position in this array, while
 * duration specifies the duration of the note to be played. 
 */
fun void setEnvelope (float samplesToEnvelope[][][], int positionInArray, int
duration, int attackTime, int releaseTime, float attackGain, float mantainGain) {
    1.0 / samplesToEnvelope[0].cap() => float sharedGain;
    btolr(duration) => int numSamples;    // Beats to loopRate
    Std.ftoi(numSamples * (attackTime/100.0)) => float attackSamples;
    Std.ftoi(numSamples * (releaseTime/100.0)) => float releaseSamples;
    attackGain * sharedGain => float attackGain;
    mantainGain * sharedGain => float mantainGain;
    <<<attackGain*5, mantainGain*5>>>;
    for (0 => int x; x < numSamples; x++) {
        positionInArray + x => int indexSamples;

        for (0 => int note; note < samplesToEnvelope[0].cap(); note++) {
            if (x < attackSamples) {
                (x/attackSamples) * attackGain =>
                samplesToEnvelope[indexSamples][note][1];
            } else if (x > (numSamples - releaseSamples)) {
                samplesToEnvelope[indexSamples-1][note][1] -
                (samplesToEnvelope[indexSamples-1][note][1]/(numSamples-x)) =>
                samplesToEnvelope[indexSamples][note][1];
            } else {

                if (samplesToEnvelope[indexSamples-1][note][1] > mantainGain)
                    {
                samplesToEnvelope[indexSamples-1][note][1] -
                (samplesToEnvelope[indexSamples-1][note][1] * 0.005) =>
                samplesToEnvelope[indexSamples][note][1];
                    } else {
                        mantainGain =>
                        samplesToEnvelope[indexSamples][note][1];
                    }
            }
        }
    }
}

/* samplesArray [number_of_simultaneous_notes][samples]
 * patternArray [duration_of_rhythm][sound_or_silence]
 *
 * Modifies the array of samples to create a rhythm pattern with the proper
 * envelope.
 */
fun void setRhythmPattern (float samplesArray[][][], float patternArray[][]) {
    0 => int positionCache;
    0 => int patternSamples;
    for (0 => int x; x < patternArray[0].cap(); x++) {
        patternSamples + btolr(Std.ftoi(patternArray[0][x])) =>
        patternSamples;
    }
    Std.ftoi(samplesArray.cap() / patternSamples) => int patternIterations;
    for (0 => int iteration; iteration < patternIterations; iteration++) {
        for (0 => int x; x < patternArray[1].cap(); x++) {
            /* Every note in the pattern array: */
            if (patternArray[1][x] < 1 && patternArray[1][x] > 0) {
                /* Set the envelope for the note. */
                setEnvelope(samplesArray, positionCache,
                Std.ftoi(patternArray[0][x]), 5,
                60,(patternArray[1][x] * 0.2), patternArray[1][x] *0.1);
            } else if (patternArray[1][x] == 0) {
                /* Delete the sound of those samples that are suposed to be silence
                 */
                for (0 => int note; note < samplesArray[0].cap(); note++) {
                    /* For every note (as in chords) */
                    for (0 => int duration; duration <
                        btolr(Std.ftoi(patternArray[0][x])); duration++) {
                        /* for every sample from positionCache to the duration of
                         * the rhythm x, set the gain to 0.
                         */
                        0.0 => samplesArray[positionCache+duration][note][1]; // 1 refears to gain
                    }
                }
            } else {
                <<<"patternArray[1][] should contain only 0 (silence) or 1
                (sound)">>>;
            }

            positionCache + btolr(Std.ftoi(patternArray[0][x])) => positionCache; // positionCache holds the position in samplesArray
        }
    }
}

fun float [][][] buildArpeggiatoMelody (int arpeggioRoot[], string 
arpeggioMode[], dur rhythm[]) {
    if (arpeggioRoot.cap() == arpeggioMode.cap()){
        0 => int numSamples;
        /* Initiallize numSamples */
        for(0 => int x; x < rhythm.cap(); x++) {
            numSamples + rtolr(rhythm[x]) => numSamples;    // Rhythm to loopRate
        }
        float melody[numSamples][1][2]; // 2, for frequency and gain
                                                 // for each sample, for each note in the chord
        
        float aChord[][]; // Temporal array
        0 => int currentSample;   // Tracking current index of chords array
        Math.random2(0, 2) => int firstNote;
        (firstNote+1 % 3) => int secondNote;
        (secondNote+1 % 3) => int thirdNote;

        for (0 => int x; x < arpeggioRoot.cap(); x++) {
        Math.random2(0, 2) => int currentNote;
        0 => int octave;
        0 => int noteCounter;
            int arpNotes[];
            if (arpeggioMode[x] == "major" || arpeggioMode[x] == "M") {
                [0, 4, 7] @=> arpNotes;
            } else if (arpeggioMode[x] == "minor" || arpeggioMode[x] == "m") {
                [0, 3, 7] @=> arpNotes;
            }
        rtolr(rhythm[x]) => int aRhythm;
            for (0 => int y; y < aRhythm; y++) {
                (y+1) % rtolr(sixteenth) => int arpeggioRhythm;

             if (currentSample != melody.cap()){
                if (arpeggioRoot[x] > 0) {
                    getFreq(changeOctave(arpeggioRoot[x] +
                    arpNotes[currentNote], octave)) =>
                melody[currentSample][0][0];
                1.0 => melody[currentSample][0][1]; // Sets standard gain
            } else {
                /* if root note is 0, means silence */
                [[0.0, 0.0, 0.0],[0.0, 0.0, 0.0]] @=> melody[currentSample];
            }
                 } else {
                     <<<"Error filling chords array. Out of bounds!">>>;
                 }
            
            currentSample++;

             if (arpeggioRhythm == 0){
                 currentNote++;
                 noteCounter++;

                 if (currentNote == 3) {
                     0 => currentNote;
                     octave++;

                 }
                     if (noteCounter == 3) {
                         0 => noteCounter;
                         0 => octave;
                     }

             }

            }
        }
            0 => int currentSixteenth;
            0 => int sixteenthCounter;
        for (0 => int x; x < melody.cap(); x++) {
                if (x % rtolr(measure) == 0){
                    0 => sixteenthCounter;
                }


            if (x % rtolr(sixteenth) == 0) {
                <<<x % rtolr(rhythm[0]), sixteenthCounter>>>;
            float gain;
            if (sixteenthCounter % 3 == 0) {
                0.25 => gain;
            } else if (sixteenthCounter % 3 == 1) {
                0.35 => gain;
            } else if (sixteenthCounter % 3 == 2) {
                1 => gain;
            }
            setEnvelope(melody, rtolr(sixteenth*currentSixteenth),
            Std.ftoi(sixteenthPerBeat),
            15, 30, gain * 0.4, gain * 0.2);
                currentSixteenth++;
                sixteenthCounter++;

            }
        }
        return melody;
    } else {
        <<<"Error setting chords: arrays must be of the same size">>>;
    }
}



[50, 46, 53, 48] @=> int rootsA[];
["m", "M", "M", "M"] @=> string modesA[];
[measure, measure, measure, measure] @=> dur rhythmChordsA[];
5 => int numNotesChord;

TriOsc chordOsc[numNotesChord];
for (0 => int x; x < numNotesChord; x++) {
TriOsc o @=> chordOsc[x];
    o => dac;
    (1.0/numNotesChord) => o.gain;
}

SqrOsc melodyOsc => dac;

setChords(rootsA, modesA, numNotesChord, rhythmChordsA) @=> float
chordsSectionA[][][];
setRhythmPattern(chordsSectionA, rhythmPatterns[0]);

buildArpeggiatoMelody(rootsA, modesA, rhythmChordsA) @=> float
melodySectionA[][][];

    for (0 => int iteration; iteration < 4; iteration++) {
for (0 => int x; x < chordsSectionA.cap(); x++) {


        for (0 => int y; y < chordsSectionA[x].cap(); y++) {
            chordsSectionA[x][y][0] => chordOsc[y].freq;
            chordsSectionA[x][y][1] * 4=> chordOsc[y].gain;

        }
            melodySectionA[x][0][0] => melodyOsc.freq;
            melodySectionA[x][0][1]*0.15 => melodyOsc.gain;
            if (x % (rtolr(sixteenth)) == 50) {
            }
            loopRate => now;
    }
}
