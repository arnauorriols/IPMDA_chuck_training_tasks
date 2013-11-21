// sound chain
PulseOsc p => dac;

while( true )
{
    Math.random2f(0.01,0.5) => p.width;
    0.1::second => now;
    if( Math.random2(0,1) == 1 )
    {
        84 => p.freq;
    }
    else
    {
        100 => p.freq;
    }
}
