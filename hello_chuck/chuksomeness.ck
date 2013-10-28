// 26/10/2013
// Assignment 1 - IPMDA

<<< "Assignment_1_Goody_Woggy" >>>;

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

// Chords definition
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
now => time start;
start + composition => time end;
1 => int barNum;  // To control the number of the current bar.

// Other control variables
0 => float increment;    // Controls the gain increment for the second melody.
1 => int octaveMultiplier; // Controls the octave of the second melody
0 => int even; // Workaround to the modulo restriction: this will  work as a
               // boolean, 0 is false, 1 is true


// Comoposition logic:
//======================


// Harmonic base gain definition:
0.20 => base.gain;
0.15 => third.gain;
0.1 => fifth.gain;
0.1 => octave.gain;


while ( now < end ) {

    // Harmonic base definition
    if (!even && barNum != 15 || barNum == 16) {

        // if true, we are in an odd measure. Special tratement is used for
        // the 15th and the 16th measures, as those requires an authentic
        // candence, thus inverting this order.

        // Odd measures == Tonic chord: C MAJOR
        C4 / 2  => base.freq;  // Sets frequency to C3 for the base note.
        E4 / 2 => third.freq; // Does the same for the rest of the chord.
        G4 / 2 => fifth.freq;
        C4 => octave.freq;

    } else {

        // Even measures == Dominant chord: G MAJOR
        G4 / 2 => base.freq;
        B4 /2 => third.freq;
        D4 => fifth.freq;
        F4 => octave.freq;   // Not octave actually, but dominant seventh
    }
    <<< "Base: " + base.freq()>>>;


    // Definition of the first section (1 - 8 bars)
    if (now < (start + section)) {

        0.3 => firstMelody.gain;
        0.0 => secondMelody.gain;

        if (!even) {
            for (0 => int x; x < 2; x++) {
                G4 => firstMelody.freq;
                3 * steenth => now;
                C4 * 2 => firstMelody.freq; // i.e. C5
                3 * steenth => now;
                C4 => firstMelody.freq;
                eighth => now;
            }
        1 => even;   // Next bar even will be true
        } else {
            for (0 => int x; x < 2; x++) {
                G4 => firstMelody.freq;
                3 * steenth => now;
                B4 => firstMelody.freq; // i.e. C5
                3 * steenth => now;
                D4 * 2 => firstMelody.freq;
                eighth => now;
            }
        0 => even;    // Next bar even will be false
        }
    } else {    // Definition of the second section (9 - 16 bars)
        0.0 => firstMelody.gain;
        0.1 + increment => secondMelody.gain;

        if (!even && barNum != 15 && barNum != 16) {
            for (0 => int x; x <3; x++) {
                if ( x != 2 ) {
                    (Bb4 / 2) * octaveMultiplier => secondMelody.freq;
                    steenth => now;
                    (G4 / 2) * octaveMultiplier => secondMelody.freq;
                    steenth => now;
                    (F4 / 2) * octaveMultiplier => secondMelody.freq;
                    steenth => now;
                    (D4 / 2) * octaveMultiplier => secondMelody.freq;
                    steenth => now;
                    (C4 / 2) * octaveMultiplier => secondMelody.freq;
                    eighth => now;
                } else {
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
            if (barNum != 16){
                for (0 => int x; x <3; x++) {
                    if ( x != 2 ) {
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
                0.45 => base.gain;
                0.00 => octave.gain;
                2093.00 => secondMelody.freq; // C7
                measure => now;
            }

            0.05 +=> increment;
            2 *=> octaveMultiplier;

        }

            <<< "second melody: " + secondMelody.freq() >>>;
    }

    barNum ++; // new bar, keep with the loop.
}
<<< (now - start)/second >>>;  // Should print exactly 30
