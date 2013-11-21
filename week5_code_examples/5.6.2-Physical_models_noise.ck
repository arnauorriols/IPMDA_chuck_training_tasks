// sound chain
Noise nois => ADSR env => Delay d => dac;
d => d; // feedback loop
0.99 => d.gain;
(0.005::second, 0.001::second, 0.0, 0.001::second) => env.set;

0.005::second => d.delay;
1 => env.keyOn;

2::second => now;

