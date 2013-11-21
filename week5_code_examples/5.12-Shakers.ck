// sound chain
Shakers shak => dac;


for( 0 => int i; i < 23; i++ )
{
    i => shak.preset;
    1.0 => shak.noteOn;
    1.0::second => now;
}

1::second => now;

while( true )
{
    17 => shak.preset;
    Math.random2f(0.0, 128.0) => shak.objects;
    Math.random2f(0.1,1.0) => shak.decay;   // fast decay < 0.5 > slow decay
    1.0 => shak.energy;
    1.0::second => now;
}
