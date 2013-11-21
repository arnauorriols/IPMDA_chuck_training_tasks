Impulse imp => ResonZ filt => dac;
800.0 => filt.freq;
100 => filt.Q;

while( true )
{
    200.0 => imp.next; // generate 1 for one sample
    Math.random2f(1000,3000) => filt.freq;
    Math.random2f(0.05,0.02)::second => now;
}
