/* DORITOS THEME
 * ==============
 * Date: 03/10/2013
 */

 /* OSCILLATORS DECLARATION
  * =======================
  * baseNote: Sinusoidal Oscillator, with 40 partials to build a complex wave.
  * melody: Saw Thooth Oscillator, plays main repetitive melody (mainSequence)
  * scale: Sinusoidal Oscillator, plays the dorian scale fastly during 8
  *        measures, with panning effect.
  * solo: Square Oscillator, plays random solo from measure 17
  */
SinOsc baseNote => dac;
40 => int numPartials;
SinOsc partials[numPartials];
for ( 0 => int x; x < numPartials; x++ ) {
    SinOsc p @=> partials[x];
    partials[x] => dac;
    (Math.sqrt(x)/(x*x)) * 0.1 => partials[x].gain;
            /* Setting the gain with a square root function. Summing up,
             * the first partial will have 0.1 gain, the others will gradually
             * have less gain, without never reaching 0
             */
}
SawOsc melody => dac;
SqrOsc solo => Pan2 soloPan => dac;
SinOsc scale => Pan2 panControl => dac;     // Panning scale on measures 9 - 16

// INITIAL GAINS
// -------------
0.3 => baseNote.gain;
0.10 => melody.gain;
0 => solo.gain;
0 => scale.gain;

/* METER DEFINITION
 * ================
 * As the requirements of this assigment were to make a 30 second composition
 * defining the quarter as 0.25::second, this makes 120 total quarters to use.
 * Therefore, this composition will be organized like this:
 *      MAIN part: 24 measures in 4/4 meter (96 quarters)
 *      CADENCE part: 4 measures in 6/4 meter (24 quarters)
 *
 * Here are some time control variables defined:
 */

// RHYTHM NOTES
// ------------
30::second => dur totalDuration;
0.25::second => dur quarter;
quarter / 2 => dur eighth;
eighth / 2 => dur sixteenth;
quarter * 2 => dur half;

4 => int quartersMeasure;          // Main in 4/4 meter
6 => int quartersMeasureCadence;   // Cadence in  6/4 meter

quarter * quartersMeasure => dur measure;
quarter * quartersMeasureCadence => dur measureCadence;


/* TIME CONTROL TECHNIQUE EXPLANATION
 * ----------------------------------
 * In this composition I've worked on a technique to control time seamlessly
 * when having multiple voices with different rhythms.
 *
 * It's based on defining the fastest rhythm this composition will have as the
 * beatRate, and setting this as the "unit" of all other rhythms. Then the main
 * loop executes every beat, and the other rhythms are handled using "timers".
 * Timers are just control integers that count the number of beats a particular
 * note should keep sounding. When a particular timer reaches 0, the frequency
 * related to it changes to the next one in the array, and the timer is set
 * again with the next corresponding rhythm. As everything is unified to the
 * beat, everything matches the time perfectly.
 */
sixteenth => dur beatRate;      // The sixteenth note is our fastest rhythm
Std.ftoi(totalDuration / beatRate) => int maxBeat;   // The composition will
                                                     // last 480 beats
Std.ftoi(measure / beatRate) => int beatsMeasure;    // Every main measure
                                                     // lasts 16 beats
Std.ftoi(measureCadence / beatRate) => int beatsMeasureCadence;
                                        // Every cadence measure lasts 24 beats
24 => int measuresMain;
4 => int measuresCadence;

// Main part lasts 384 beats, Cadence part lasts 96
measuresMain * Std.ftoi(measure/beatRate) => int beatsMain;
measuresCadence * Std.ftoi(measure/beatRate) => int beatsCadence;


/* NOTES FREQUENCIES DEFINITION
 * ============================
 * Required: use only D dorian scale notes. The correlation of the notes of
 * this scale is defined in dorianScaleMidi array. Thus you could apply the
 * dorian scale to any note, which in this case have to be D. My aproximation
 * to setting the frequency is the following:
 *      TONIC(midi) + SCALE_CORRELATION + (OCTAVE * OCTAVE_MULTIPLIER)
 *
 * This will get you the desired midi note, which you can convert to frequency
 * and set it as an oscillator frequency.
 * As said, dorianScaleMidi array defines the notes available. Thus when creating a
 * melody, all it's needed is an array with the index that point to a position
 * of dorianScaleMidi array. Then, we'll set the frequency like this:
 *      TONIC + dorianScaleMidi[ARRAY_INDEX[x]].
 * x gets the content of the x position of the array, which in turn is the
 * index that tells the dorianScaleMidi array the position from which we want
 * to get the data.
 *
 * Alongside the melody notes, there should be provided the octave multiplier
 * when needed. As the octave is already defined as 12 (midi), all that is
 * needed is to create an array AS LONG AS the melody array, and set the octave
 * variation from the standard scale octave defined in dorianScaleMidi. If the
 * scale is standard, 0 is given, if the desired octave is one higher, 1 is
 * given, if 1 lower, -1 is given, etc.
 *      TONIC + dorianScaleMidi[ARRAY_INDEX[x]] + (octave * ARRAY_OCTAVES[x])
 */

50 => int midiTonic;
12 => int midiOctave;

[0, 2, 3, 5, 7, 9, 10, 12] @=> int dorianScaleMidi[];

// BASE ARRAY for the baseNote oscillator, to be played all the composition
[0, 2, 6, 3] @=> int baseNotes[];
[-1, -1, -2, -1] @=> int baseOctaves[];
measure => dur baseRhythm; // Change base note every measure
measureCadence => dur baseRhythmCadence;

// One sequence is one repetition of the full base array, which maches in time
// whith the melody array (mainSequence)
baseRhythm * 4 => dur sequence;
Std.ftoi(sequence / beatRate) => int beatsSequence;

// MELODY ARRAY for melody oscillator, to be played in the main part
[4, 4, 6, 7, 3, 3, 1, 6, 7, 3, 3, 1, 5, 6, 1, 1, 7, 6, 5, 4] @=> int mainSequence[];
[0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0] @=> int sequenceOctaves[];
// This array doesn't match the mainSequence capacity, but is exactly  a 1/4 of
// it. It will use it's own iterator (the index pointer).
[quarter, quarter, eighth, quarter, eighth] @=> dur mainSequenceRhythm[];

/* SOLO ARRAY for the solo oscillator, to be played in the main part. As the
 * solo plays random notes, the array only holds the subset of the possible notes
 * and rhythms to be played. The index to these arrays will be randomly
 * generated every time, thus generating the random melody.
 */
[0, 2, 3, 4, 6] @=> int soloNotes[];
[half+quarter, half, quarter] @=> dur soloRhythm[];

// MELODY ARRAY for the melody oscillator, to be played in the Cadence part.
[4, 2, 6, 4, 3, 1, 7, 7] @=> int mainSequenceCadence[];
[0, 1, 0, 0, 0, 1, 0, 0] @=> int sequenceOctavesCadence[];
quarter * 3 => dur mainSequenceCadenceRhythm;   // Dotted quarter every note

// SOLO ARRAY for the solo oscillator, to be played in the Cadence part.
[0, 2, 4, 7, 6, 4, 2, 1, 3, 6, 1, 7, 6, 5] @=> int soloCadence[];
[2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 2, 2, 2] @=> int soloOctavesCadence[];
[quarter*3, quarter, quarter, quarter, half, half, half, quarter*3, quarter,
quarter, quarter, quarter, quarter, quarter*4] @=> dur soloCadenceRhythm[];

now => time start;

0 => int currentBeat;   // Controls the beat being currently played. Control unit.

// TIMERS AND ITERATORS
0 => int baseNoteTimer;
0 => int baseNoteIndex;
0 => int sequenceTimer;
0 => int sequenceIndex;
0 => int sequenceRhythmIndex;
0 => int scaleIndex;
-3 => int scaleOctave;
0 => int soloTimer;
0 => int soloIndex;
0 => int soloRhythmIndex;

now + (2*sequence) => time scaleStart; // Required for the sin function (panning feature)

<<<"Assignment_2_DORITOS THEME">>>;
while (currentBeat < maxBeat ) {
    /* TIMERS & ITERATORS  EXPLANATION
     * ===============================
     * All timers and iterators (called <x>Index) are initialized at 0. The
     * while starts executing, and won't stop executing until we don't process
     * the last beat (0 to 479 beats). Every oscillator has its own if to
     * control the timer status. If the timer is 0, as for the beginning, a new
     * frequency is set to the oscillator, using the iterator (which in the
     * beginning is 0 as well). Then the timer is updated: extracting the
     * duration of this next note from the array, dividing it by beatRate we
     * know how many beats this note should last. Assigning this number to the
     * timer, now we have a countdown for the next note to be played. At each
     * execution the timer is reduced by one until eventually reaches 0 again.
     *
     * Once one note has been gotten from its array, the iterator is aumented
     * by one, to get the next note from the array once the timer reaches 0
     * again. If the arrays have to be played repeatedly, an if statement is
     * provided to reset the iterator to 0 when it is out of the bounds of the
     * array.
     */

    if (currentBeat < beatsMain){
        //MAIN part
        //---------

        // Timer control for BASE NOTE
        if (baseNoteTimer == 0) {
            midiTonic + dorianScaleMidi[baseNotes[baseNoteIndex]] +
            (midiOctave * baseOctaves[baseNoteIndex]) => int bMidiNote;
            Std.mtof(bMidiNote) => baseNote.freq;

            // Set the frequencies of all partials of the complexe wave. they
            // are the multiples of the base frequency.
            for (0 => int y; y < numPartials; y++) {
                baseNote.freq()*(y+2) => partials[y].freq; // y+2, cause y starts at 0
            }

            baseNoteIndex++;  // Iterator augmented to get the next note the next time
            if (baseNoteIndex == baseNotes.cap()){
                // When the iterator gets out of bounds, reset it to start over
                0 => baseNoteIndex;
            }
            Std.ftoi(baseRhythm / beatRate) => baseNoteTimer;   // Set the timer
            // As all base notes have the same rhythm, no array is needed
        }
        baseNoteTimer--;        // Each loop execution, the timer gets reduced by 1

        //Timer control for SEQUENCE
        if (sequenceTimer == 0) {
            midiTonic + dorianScaleMidi[mainSequence[sequenceIndex]] +
            (midiOctave * sequenceOctaves[sequenceIndex]) => int sMidiNote;
            Std.mtof(sMidiNote) => melody.freq;
            Std.ftoi(mainSequenceRhythm[sequenceRhythmIndex] / beatRate) => sequenceTimer;
            sequenceIndex++;
            sequenceRhythmIndex++;      // Requires a different iterator for
                                        // the rhythm, as the rhythm array is
                                        // not of the same length of the notes array
            if(sequenceIndex == mainSequence.cap()){
                0 => sequenceIndex;
            }
            if( sequenceRhythmIndex == mainSequenceRhythm.cap() ){
                0 => sequenceRhythmIndex;
            }
        }
        sequenceTimer--;

        // Control for SCALE
        if (currentBeat > (2 * beatsSequence) && currentBeat < 4 * beatsSequence) {
            0.25 => scale.gain;
            if (currentBeat < (3 * beatsSequence)) {

                // Third sequence repetition
                Std.mtof(midiTonic + dorianScaleMidi[scaleIndex] +
                (midiOctave * scaleOctave)) => scale.freq;
                Math.sin(((now-scaleStart)/(sequence*2) *
                (2*pi))-(pi/2)) => panControl.pan;
                // sin(x/t-offset)

                if(scaleIndex != 7){
                    scaleIndex++;
                }else{
                    1 => scaleIndex;
                    scaleOctave++;
                }
            } else {

                // fourth sequence repetition
                Std.mtof(midiTonic + dorianScaleMidi[scaleIndex] +
                (midiOctave * scaleOctave)) => scale.freq;
                Math.sin(((now-scaleStart)/(sequence*2) *
                (2*pi))-(pi/2)) => panControl.pan;
                if(scaleIndex != 0){
                    scaleIndex--;
                }else{
                    6 => scaleIndex;
                    scaleOctave--;
                }
            }
            solo.gain() + 0.0015 => solo.gain;
        }

        // Control for SOLO steady note
        if (currentBeat > (1 * beatsSequence) && currentBeat < (2 * beatsSequence)){
            0.02 => solo.gain;
            Std.mtof(midiTonic + dorianScaleMidi[4] + (midiOctave * 3)) => solo.freq;
        }

        // Control timer for SOLO
        if (currentBeat > (4 * beatsSequence)) {
            0.07 => solo.gain;

            if(soloTimer == 0) {
                Std.mtof(midiTonic + dorianScaleMidi[soloNotes[soloIndex]] +
                (midiOctave * Math.random2(2, 2))) => solo.freq;
                Math.random2f(-1, 1) => soloPan.pan;
                Std.ftoi(soloRhythm[soloRhythmIndex] / beatRate) => soloTimer;
                Math.random2(0, soloNotes.cap()-1) => soloIndex;
                Math.random2(0, soloRhythm.cap()-1) => soloRhythmIndex;
            }
            soloTimer--;
        }
    } else {

        // CADENCE part
        //-------------
        if (currentBeat == beatsMain){
            // Reset timers on the first beat of the cadence
            0 => baseNoteTimer;
            0 => baseNoteIndex;
            0 => sequenceTimer;
            0 => sequenceIndex;
            0 => soloTimer;
            0 => soloIndex;
        }
        // Timer control for base note
        if (baseNoteTimer == 0) {
            midiTonic + dorianScaleMidi[baseNotes[baseNoteIndex]] +
            (midiOctave * baseOctaves[baseNoteIndex]) => int bMidiNote;
            Std.mtof(bMidiNote) => baseNote.freq;
            for (0 => int y; y < numPartials; y++) {
                baseNote.freq()*(y+2) => partials[y].freq;
            }
            baseNoteIndex++;
            if (baseNoteIndex == baseNotes.cap()){
                0 => baseNoteIndex;
            }
            Std.ftoi(baseRhythmCadence / beatRate) => baseNoteTimer;
        }
        baseNoteTimer--;

        // Timer control for Sequence
        if (sequenceTimer == 0) {
            midiTonic + dorianScaleMidi[mainSequenceCadence[sequenceIndex]] +
            (midiOctave * sequenceOctavesCadence[sequenceIndex]) => int sMidiNote;
            Std.mtof(sMidiNote) => melody.freq;
            Std.ftoi(mainSequenceCadenceRhythm / beatRate) => sequenceTimer;
            sequenceIndex++;
            if(sequenceIndex == mainSequenceCadence.cap()){
                0 => sequenceIndex;
            }
        }
        sequenceTimer--;

        // Timer control for solo
        if(soloTimer == 0) {
            Std.mtof(midiTonic + dorianScaleMidi[soloCadence[soloIndex]] +
            (midiOctave * soloOctavesCadence[soloIndex])) => solo.freq;
            Math.random2f(-0.5, 0.5) => soloPan.pan;
            Std.ftoi(soloCadenceRhythm[soloIndex] / beatRate) => soloTimer;
            soloIndex++;
            if(soloIndex == soloCadence.cap()){
                0 => soloIndex;
            }
        }
        soloTimer--;
    }

    if (currentBeat > (maxBeat - (beatsMeasureCadence/4))) {

        // Fade out in the last quarter note of the composition
        solo.gain() + (-solo.gain()/(maxBeat-currentBeat)) => solo.gain;
        melody.gain() + (-melody.gain()/(maxBeat-currentBeat)) => melody.gain;
        baseNote.gain() + (-baseNote.gain()/(maxBeat-currentBeat)) => baseNote.gain;
        // MATH EXPLANATION: to be 0 in maxBeat

        for (0 => int x; x < numPartials; x ++) {
         0 => partials[x].gain;
        }
    }

    beatRate => now;    // Execute this loop every beat
    currentBeat++;      // Update the beat tracking variable
}
<<<"End. Duration: ", (now-start)/second>>>;
