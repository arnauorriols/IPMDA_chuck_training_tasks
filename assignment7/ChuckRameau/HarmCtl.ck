public class HarmCtl {

    // VARIABLES

    // scale mode
    static string mode[];
    ["dorian"] @=> mode;        // Hack to workaround the Chuck bug regarding
                                // static strings

    50 => static int fundamental;
    2 => static int globalOctave;// octave of the global fundamental
    2 => int localOctave;       // octave in the concret object
    2 => int lastOctave;        // last octave used
    [50, 52, 53, 55, 57, 59, 60] @=> int scale[]; // Default: Aeolian D

    /* Associative array, more convinient and readable */
    int modesRelatio[0][0];
    [0, 2, 3, 5, 7, 9, 10] @=> modesRelatio["dorian"];
    [0, 1, 3, 5, 7, 8, 10] @=> modesRelatio["phrygian"];
    [0, 2, 4, 6, 7, 9, 11] @=> modesRelatio["lydian"];
    [0, 2, 4, 5, 7, 9, 10] @=> modesRelatio["mixolydian"];
    [0, 2, 3, 5, 7, 8, 10] @=> modesRelatio["aeolian"];
    [0, 1, 3, 5, 6, 8, 10] @=> modesRelatio["locrian"];
    [0, 2, 3, 4, 7, 9, 11] @=> modesRelatio["ionian"];

    ["dorian", "phrygian", "lydian", "mixolydian", "aeolian", "locrian",
    "ionian"] @=> string modeIndexes[];

    int noteNames[0];
    48 => noteNames["C"];
    50 => noteNames["D"];
    52 => noteNames["E"];
    53 => noteNames["F"];
    55 => noteNames["G"];
    57 => noteNames["A"];
    59 => noteNames["B"];


    // METHODS

    /* CALLABLE
     * Sets a new global fundamental and mode.
     */
    fun void setScale(int fundamental, string mode) {
        0 => int proceed;
        for (0 => int modeIndex; modeIndex < modeIndexes.cap(); modeIndex++) {
            if (mode == modeIndexes[modeIndex]) {
                1 => proceed;
            }
        }
        if (proceed) {
            [mode] @=> this.mode;
            fundamental => this.fundamental;
        } else {
            <<<"ERROR, scale mode not recognized">>>;
        }
    }

    fun void setScale(string funName, string mode) {
        note(funName) => int fundamental;
        0 => int proceed;
        if (fundamental != 0) {
            for (0 => int modeIndex; modeIndex < modeIndexes.cap(); modeIndex++) {
                if (mode == modeIndexes[modeIndex]) {
                    1 => proceed;
                }
            }
        }
        if (proceed) {
            [mode] @=> this.mode;
            fundamental => this.fundamental;
            lastOctave => globalOctave;
        } else {
            <<<"ERROR, scale not recognized">>>;
        }
    }

    fun void constructScale(int fundamental, int modeRel[]) {
        for (0 => int note; note < scale.cap(); note++) {
            fundamental + modeRel[note] => scale[note];
        }
    }

    /* CALLABLE REQUIRED
     * Builds the scale array.
     */
    fun void buildScale() {
        constructScale(fundamental, modesRelatio[mode[0]]);
    }

    /* CALLABLE REQUIRED
     * Builds the scale array in a different octave than the global octave
     */
    fun void buildScale(int octave) {
        octave => localOctave;
        constructScale(changeOctave(fundamental, octave-globalOctave),
        modesRelatio[mode[0]]);
    }

    fun int note(string noteName) {
        noteName.substring(0, 1) => string name;
        "" => string deviation;
        if (noteName.length() >= 2) {
            noteName.substring(1, 1) => deviation;
            if (noteName.length() == 3) {
                Std.atoi(noteName.substring(2, 1)) => lastOctave;
            }
        }
        changeOctave(noteNames[name], lastOctave - 2) => int midiNote;
        if (midiNote != 0) {
            if (deviation == "#") {
                midiNote++;
            } else if (deviation == "b") {
                midiNote--;
            }
            return midiNote;
        } else {
            <<<"ERROR, note not from this planet! use english nomenclature">>>;
            return 0;
        }
    }

    fun int changeOctave(int midiNote, int octaveDeviation) {
        return (midiNote + (12 * octaveDeviation));
    }
}

HarmCtl h;

h.setScale("C#4", "mixolydian");
h.buildScale(2);

for (0 => int z; z < h.scale.cap(); z++) {
    <<<h.localOctave, h.globalOctave, h.scale[z]>>>;
}

<<<h.note("Db7"), h.lastOctave, h.localOctave, h.globalOctave>>>;
1::second => now;

