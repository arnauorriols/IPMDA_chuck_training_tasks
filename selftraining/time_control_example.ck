SinOsc foo => dac;

30::second => dur fullComposition;
fullComposition / 2 => dur section;
section / 4 => dur measure;
measure / 3 => dur quarter;
quarter / 2 => dur eighthNote;

/* We have a full composition of 2 sections, each with 4 measures, each with 3
 * quarter notes, that will last 30 seconds exactly. How you compose the notes
 * and rhythm is up to you, but you know you will end up using 24 quarter
 * notes, or 48 eighth notes, etc...
 */

now => time startTime;       // To test the time at the end

0.5 => foo.gain;

for(0 => int x; x < 24; x++) {
    440 + Math.random2(-100, 100) => foo.freq;
    /* Using random for testing, otherwise everything else has already
     * been explained in the first week videos.
     */
    quarter => now;
}

<<< (now - startTime) / second >>>; // 30.000000 :(float)
