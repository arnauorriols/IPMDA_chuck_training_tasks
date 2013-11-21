// sound chain
SinOsc vib => SqrOsc viol => ADSR env => dac;
( 0.5::second, 0.1::second, 0.6, 0.5::second ) => env.set;
660.0 => viol.freq; // change pitch
6.0 => vib.freq; // vibrato frequency
2 => viol.sync; // set sync mode to FM (2)

5.0 => vib.gain;        // change vibrato

1 => env.keyOn; // turns envelope on

2.0::second => now;

1 => env.keyOff; // turns envelope off

2.0::second => now;
