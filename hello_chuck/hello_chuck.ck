/*
 * Author: Arnau Orriols
 *
 * Date: 26/10/2013
 */

<<< "Arnau Orriols - This is awesome!" >>>;

440 => int A;
0.5 => float midGain;
500::ms => dur quarter;


SinOsc baseRiff => dac;         // dac stands for Digital to Analog Converter

midGain - 0.1 => baseRiff.gain;
A * 3/4 => baseRiff.freq;
quarter => now;               // We pause 1 sec and execute all the code above

midGain => baseRiff.gain;
A => baseRiff.freq;
quarter * 2 => now;

midGain - 0.2 => baseRiff.gain;
A + (A/2) => baseRiff.freq;
quarter => now;






/*

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
*/
