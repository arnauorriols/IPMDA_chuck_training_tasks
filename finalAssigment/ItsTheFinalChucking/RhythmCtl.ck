// Assignment_7_Chuck_Rameau

// Rhythm control class

public class RhythmCtl {

    // Member variables
    static int bpm;     // beats per minute
    60.0 / bpm => float spb;    // seconds per beat

    static dur half, quarter, eighth, sixteenth, thirtysecond;
    static dur measure, loop, section, composition;

    static int numSections, loopsPerSection, measuresPerLoop, beatsPerMeasure;

    static int beatAssign;    // 4 => quarter is beat, 8 eighth, 16 sixteenth...

    static time start;

    25 => int swingPercent; // Deprecate?

    /* CALLABLE */
    fun void setTempo(int bpm) {
        bpm => this.bpm;
        getBeatDuration(bpm, 60.0) => spb;
        updateRhythms(spb);
    }

    fun void setTempo(float spb) {
        spb => this.spb;
        Std.ftoi(60 / spb) => bpm;
        updateRhythms(spb);
    }

    /* CALLABLE
     * ATENTION: MUST BE CALLED BEFORE setTempo
     */
    fun void setMeter(int numBeats, int beatRhythm) {
        numBeats => beatsPerMeasure;
        changeBeatAssign(beatRhythm);
    }

    /* CALLABLE */
    fun void structureCtl(float totalSeconds, int numSections, int
    loopsPerSection, int measuresPerLoop) {
        totalSeconds::second => composition;
        composition / numSections => section;
        numSections => this.numSections;
        section / loopsPerSection => loop;
        loopsPerSection => this.loopsPerSection;
        loop / measuresPerLoop => measure;
        measuresPerLoop => this.measuresPerLoop;
    }

    fun void checkStructure() {
        if (spb::second * (beatsPerMeasure * measuresPerLoop * loopsPerSection *
            numSections) == composition) {
            <<<"Congrats, your structure is exact","">>>;
        } else {
            <<<"WARNING: your structure setup is not exact">>>;
        }
        composition / (spb::second) => float bpc;     // beats per composition
        composition / ((spb*beatsPerMeasure)::second) => float mpc;         // measures per composition
        composition / ((spb*beatsPerMeasure*measuresPerLoop)::second) => float lpc;         // loops per composition
        composition / ((spb*beatsPerMeasure*measuresPerLoop*loopsPerSection)::second) => float spc;         // sections per composition
        <<<"Total beats:", bpc, "total measures:", mpc>>>;
        <<<"Total loops:", lpc, "total sections:", spc>>>;
    }

    fun void changeBeatAssign(int newBeatAssign) {
        if (newBeatAssign == 2 || newBeatAssign == 4 || newBeatAssign == 8 ||
            newBeatAssign == 16 || newBeatAssign == 32) {
            newBeatAssign => beatAssign;
        } else {
            <<<"ERROR, beat must be assigned to 4, 8, 16 or 32">>>;
        }
    }

    fun float getBeatDuration(float numBeats, float timeLapse) {
        return (timeLapse / numBeats);
    }

    fun void updateRhythms(float spb) {
        spb * (beatAssign / 2.0)::second => half;
        half / 2 => quarter;
        quarter / 2 => eighth;
        eighth / 2 => sixteenth;
        sixteenth / 2 => thirtysecond;
    }
}



