// sound chain
Mandolin m => dac;

0.05 => m.stringDetune;
500 => m.freq;
0.5 => m.bodySize; // bigger < 0.5 > smaller
0.25 => m.pluckPos;

1.0 => m.noteOn;        // plucks strings

2::second => now;
