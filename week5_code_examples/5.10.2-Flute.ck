// sound chain
Flute f => dac;

// Others: saxophone...

330 => f.freq;

while( true )
{
    Math.random2f(0.1,1.0) => f.noteOn; // start blowing
    Math.random2f(0.1,1.0) => f.jetDelay; // Models the propagation time of the jet

    0.2::second => now;

    1 => f.noteOff;

    0.5::second => now;
}
