public class MasterCtl {
    HarmCtl harmony;
    RhythmCtl rhythm;

    static string name[];
    ["A Composition"] @=> name;

    fun void setName(string name) {
        name => this.name[0];
    }

    fun void printDetails() {
        <<<"","">>>;
        <<<name[0], "">>>;
        <<<"--------------------------------------", "">>>;
        //<<<"-" * name.length(), "">>>;
        <<<"","">>>;
        <<<"Fundamental:", harmony.fundamental, "mode:", harmony.mode[0]>>>;
        <<<"Tempo:", rhythm.bpm, "Meter:", rhythm.beatsPerMeasure + "/" +
        rhythm.beatAssign>>>;
        <<<"Total duration:", rhythm.composition/second, "sections:",
        rhythm.numSections, "loops per section:", rhythm.loopsPerSection>>>;
        <<<"Measures per loop:", rhythm.measuresPerLoop, "beats per measure:",
        rhythm.beatsPerMeasure>>>;
        rhythm.checkStructure();
    }
}

