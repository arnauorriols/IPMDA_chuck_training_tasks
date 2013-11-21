// sound chain
Impulse imp => Delay d => dac;

d => d; // feedback loop
0.99 => d.gain;
0.005::second => d.delay;
1.0 => imp.next;

2.0::second => now;
