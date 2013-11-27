// sound chain
Flute solo => JCRev rev => dac;
solo => Delay d => d => rev;

// sound parameters
0.1 => rev.mix;
0.5 => rev.gain;
0.8::second => d.max => d.delay;
0.5 => d.gain;

// scale
[41, 43, 48, 50, 51, 53, 60, 63] @=> int scale[];

// loop
while( true )
{
    (Math.random2(1, 5) * 0.2)::second => now;

    // play
    if( Math.random2(0, 3) > 1 )
    {
        Math.random2(0, scale.cap() - 1) => int note;
        Math.mtof(24 + scale[note]) => solo.freq;
        Math.random2f(0.3, 0.5) => solo.noteOn;
    }
    // rest
    else
    {
        1 => solo.noteOff;
    }
}

