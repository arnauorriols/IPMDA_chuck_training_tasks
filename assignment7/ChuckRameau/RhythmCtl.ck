public class RhythmCtl {

    // Member variables
    120 => int bpm;     // beats per minute
    60 / bpm => float spb;    // seconds per beat

    dur quarter, eighth, sixteenth, thirtysecond;
    dur measure, loop, section, composition;

    int numSections, loopsPerSection, measuresPerLoop, beatsPerMeasure;

    4 => int beatAssign;    // 4 => quarter is beat, 8 eighth, 16 sixteenth...

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

    /* CALLABLE */
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

    fun void changeBeatAssign(int newBeatAssign) {
        if (newBeatAssign == 4 || newBeatAssign == 8 ||
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
        spb * (beatAssign / 4.0)::second => quarter;
        quarter / 2 => eighth;
        eighth / 2 => sixteenth;
        sixteenth / 2 => thirtysecond;
    }
}



