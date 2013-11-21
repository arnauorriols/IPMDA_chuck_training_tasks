// sound chain
Clarinet c => dac;

220 => c.freq;


while( true )
{
    Math.random2f(0.1,1) => c.noteOn; // start blowing. amount of blow

    0.2::second => now;

    1 => c.noteOff;

    0.5::second => now;
}
