// sound chain
SinOsc mod => SinOsc car => ADSR env => dac;
( 0.5::second, 0.1::second, 0.6, 0.5::second ) => env.set;
100.0 => car.freq;      // change pitch
100.0 => mod.freq;      // vibrato frequency
1000 => mod.gain;        // vibrato gain
2 => car.sync;          // set sync mode to FM (2)



while( true )
{
    Math.random2f(100.0,1000.0) => car.freq;
    Math.random2f(100.0,1000.0) => mod.freq;
    1 => env.keyOn;
    0.2::second => now;
    1 => env.keyOff;
    0.2::second => now;
}
