public class Utils {
    fun static float centsInt(float baseFreq, float cents) {
        return (baseFreq * Math.pow(2, (cents/1200.0)));
    }

    fun static float changeOctave(float freq, int octave) {
        return (freq * (Math.pow(2, octave)));
    }
}
