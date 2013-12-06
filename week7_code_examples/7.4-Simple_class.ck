// Simple example of sound making class
class Simple
{
    // sound chain
    Impulse imp => ResonZ filt => dac;

    // some default settings
    100.0 => filt.Q => filt.gain;
    1000.0 => filt.freq;

    fun void freq(float f)
    {
        f => filt.freq;
    }

    fun void setQ(float Q)
    {
        Q => filt.Q => filt.gain;
    }

    fun void setGain(float g)
    {
        g => imp.gain;
    }

    fun void noteOn(float volume)
    {
        volume => imp.next;
    }
}

Simple s;

while( true )
{
    Math.random2f(1100.0, 1200.0) => s.freq;
    Math.random2f(1, 200) => s.setQ;
    Math.random2f(.2,.8) => s.setGain;
    // play note
    1 => s.noteOn;
    .1::second => now;
}
