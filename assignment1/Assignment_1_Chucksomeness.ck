// 26/10/2013
// Assignment 1 - Chucksomeness

/*
    * Some considerations:
 *       - This level of commenting is by no means the real word's good practice.
 *              Expert programmers: don't freak out, I'm just following the
 *                                  course guidelines, which actually make
 *                                  sense, since people in this course are not
 *                                  suposed to have any experience in
 *                                  programming, and will appreciate some extra
 *                                  explanation, if they have to evaluate and
 *                                  learn from other people's code.
 */


<<< "Assignment_1_Chucksomeness" >>>;

// DEFINITIONS:
//===============

// Declare the Oscilators
SinOsc base => dac;  // base note
SinOsc third => dac; // third of the chord
SinOsc fifth => dac; // fifth of the chord
SinOsc octave => dac; // octave of the chord
TriOsc firstMelody => dac;
SqrOsc secondMelody => dac;

// Notes lenght definition
468.75::ms => dur quarter; // to match 16 bars in 30 seconds.
quarter / 2 => dur eighth;
eighth / 2 => dur steenth;
quarter * 2 => dur half;
half * 2 => dur whole;

// Meter definition
quarter * 4 => dur measure; // 4 beats per measure (4/4 meter)
4 * measure => dur semiSection;
2 * semiSection => dur section;
2 * section => dur composition;

// Notes frequency definition
// C MAJOR
261.63 => float C4;
293.66 => float D4;
329.63 => float E4;
349.23 => float F4;
392.00 => float G4;
440.00 => float A4;
466.16 => float Bb4;
493.88 => float B4;

// time control variables
now => time start;  // stores the time of the loop start ("right now")
start + composition => time end;    // stores the time the loop should end
                                    // ("right now" + 30 secs).

1 => int barNum;  // Keeps track of the number of the current bar.

// Other control variables
0 => float increment;    // Controls the gain increment for the second melody.
1 => int octaveMultiplier; // Controls the octave of the second melody
0 => int even; // Workaround to the modulo restriction: this will  work as a
               // boolean, 0 is false, 1 is true


// Comoposition logic:
//======================

// Harmonic chord's gain definition:
0.20 => base.gain;
0.15 => third.gain;
0.1 => fifth.gain;
0.1 => octave.gain;


while ( now < end ) {   // loop while "right now" is below the end time

    // Harmonic chord frequencies definition.
    // Will play Tonic chord on odd bars, dominant chord on even bars
    if (!even && barNum != 15 || barNum == 16) {

        // if true, we are in an odd measure. Special tratement is used for
        // the 15th and the 16th measures, as those requires an authentic
        // candence, thus inverting this order.

        // Odd measures == Tonic chord: C MAJOR
        C4 / 2  => base.freq;  // Sets frequency to C3 for the base note.
        E4 / 2 => third.freq;  // Sets the corresponding notes for the rest of the chord.
        G4 / 2 => fifth.freq;
        C4 => octave.freq;

    } else {    // If the above is not true, then we are in an even bar (or at bar 15)

        // Even measures == Dominant chord: G MAJOR
        G4 / 2 => base.freq;
        B4 /2 => third.freq;
        D4 => fifth.freq;
        F4 => octave.freq;   // Not octave actually, but dominant seventh
    }


    // FIRST SECTION (1 - 8 bars)
    if (now < (start + section)) {

        // In the first section firstMelody will play (TriOsc)
        0.3 => firstMelody.gain;
        0.0 => secondMelody.gain;

        if (!even) {
            // On odd bars, plays some CMajor chord notes.
            for (0 => int x; x < 2; x++) {
                // Plays 2 times this sequences, which matches a measure
                G4 => firstMelody.freq;
                3 * steenth => now;  // Equals dotted eighth note
                C4 * 2 => firstMelody.freq; // Equals C5
                3 * steenth => now;     // Equals dotted eighth note
                C4 => firstMelody.freq;
                eighth => now;
            }
        1 => even;   // Next bar (ie, next loop execution) even will be true

        } else {
            // on even bars, plays some GMajor chord notes.
            for (0 => int x; x < 2; x++) {
                // Same rhythm as before
                G4 => firstMelody.freq;
                3 * steenth => now;
                B4 => firstMelody.freq; // i.e. C5
                3 * steenth => now;
                D4 * 2 => firstMelody.freq;
                eighth => now;
            }
        0 => even;    // Next bar even will be false
        }

    } else {    // SECOND SECTION (9 - 16 bars)

        // In the second section secondMelody takes the lead (SqrOsc)
        0.0 => firstMelody.gain;
        0.1 + increment => secondMelody.gain;   // secondMelody will play in crescendo:
                                                // In every loop execution, increment gets "incremented"

        if (!even && barNum != 15 && barNum != 16) {    // Same even/odd bars handling as before
            for (0 => int x; x <3; x++) {
                // This time the sequence is faster, gets played 3 times each bar
                if ( x != 2 ) {

                    // It doesn't match exactly one bar. in the 3rd repetition of the sequence
                    // the last note is ommited.
                    (Bb4 / 2) * octaveMultiplier => secondMelody.freq;
                    // Each time this sequence will play one octave higher,

                    // hence the octaveMultiplier
                    steenth => now;     // This sequence's rhythm is based on sixteenth notes.
                    (G4 / 2) * octaveMultiplier => secondMelody.freq;
                    steenth => now;
                    (F4 / 2) * octaveMultiplier => secondMelody.freq;
                    steenth => now;
                    (D4 / 2) * octaveMultiplier => secondMelody.freq;
                    steenth => now;
                    (C4 / 2) * octaveMultiplier => secondMelody.freq;
                    eighth => now;
                } else {

                    // In the 3rd repetition of the sequence, and for the sake
                    // of connection with the next one, the last eighth note is ommited
                    (Bb4 / 2) * octaveMultiplier => secondMelody.freq;
                    steenth => now;
                    (G4 / 2) * octaveMultiplier => secondMelody.freq;
                    steenth => now;
                    (F4 / 2) * octaveMultiplier => secondMelody.freq;
                    steenth => now;
                    (D4 / 2) * octaveMultiplier => secondMelody.freq;
                    steenth => now;
                }
            }
        1 => even;      // Next bar even will be true

        } else {
            // if the above condition is false, we are in an even bar (remember, GMajor)

            if (barNum != 16){  // bar 16th is the end, therefore won't play
                                // the sequence, but a final steady note

                for (0 => int x; x <3; x++) {
                    if ( x != 2 ) {

                        // Same as above, different notes to match the harmony (GMajor)
                        F4 * octaveMultiplier => secondMelody.freq;
                        steenth => now;
                        D4 * octaveMultiplier => secondMelody.freq;
                        steenth => now;
                        C4 * octaveMultiplier => secondMelody.freq;
                        steenth => now;
                        (Bb4 / 2) * octaveMultiplier => secondMelody.freq;
                        steenth => now;
                        (G4 / 2) * octaveMultiplier => secondMelody.freq;
                        eighth => now;
                    } else {
                        F4 * octaveMultiplier => secondMelody.freq;
                        steenth => now;
                        D4 * octaveMultiplier => secondMelody.freq;
                        steenth => now;
                        C4 * octaveMultiplier => secondMelody.freq;
                        steenth => now;
                        (Bb4 / 2) * octaveMultiplier => secondMelody.freq;
                        steenth => now;
                    }
                }
            0 => even;  // Next bar even will be false;

            } else {

                // Last bar (16th): melody plays an steady C7, and increases
                // the base note's gain a bit.
                0.45 => base.gain;
                0.00 => octave.gain;
                2093.00 => secondMelody.freq; // C7
                measure => now;     // Plays steady the entire measure.
                                    // measure variable has been defined before
            }

            // Control variables update at the end of the loop
            // (only after the even bars, i.e. every 2 bars (the complete
            // sequence (CMajor + GMajor)).
            0.05 +=> increment;     // The gain of the melody will be increased by 0.05
            2 *=> octaveMultiplier; // The melody will play 1 octave higher
                                    // (1 octave higher == current frequency * 2)
        }
    }
    barNum ++; // Update the control of the current bar number.

    // End of loop. If now is still not the calculated moment of
    // composition end, keep executing.
}

// Should print exactly 30 seconds
<<< "End of piece. Duration: " + (now - start)/second + " seconds">>>;

// END
