/*
 * Author: Arnau Orriols
 *
 * Date: 26/10/2013
 */

<<< "Arnau Orriols - This is awesome!" >>>;

SinOsc baseRiff => dac;         // dac stands for Digital to Analog Converter

0.4 => baseRiff.gain;
330 => baseRiff.freq;
1::second => now;               // We pause 1 sec and execute all the code above

0.5 => baseRiff.gain;
440 => baseRiff.freq;
2::second => now;

0.3 => baseRiff.gain;
660 => baseRiff.freq;
1::second => now;


<<< "Square" >>>;
SqrOsc squareBackground => dac;

0.2 => squareBackground.gain;
110 => squareBackground.freq;
5::second => now;

<<< "Triangle" >>>;
TriOsc triangleMelody => dac;

0.7 => triangleMelody.gain;
880 => triangleMelody.freq;
0.5::second => now;

0.5::second => now;

1220 => triangleMelody.freq;
1::second => now;

<<< "Saw" >>>;
SawOsc sawDisturbiance => dac;

1 => sawDisturbiance.gain;
2000 => sawDisturbiance.freq;
500::ms => now;
