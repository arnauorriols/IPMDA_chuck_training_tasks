SqrOsc clar => Envelope env => dac;
1.0::second => env.duration;

now => time start;
1 => env.keyOn; // from 0 to 1
<<<now-start>>>;
2.0::second => now;
<<<(now-start)/second>>>;
1 => env.keyOff;
<<<(now-start)/second>>>;
2.0::second => now;
<<<(now-start)/second>>>;
