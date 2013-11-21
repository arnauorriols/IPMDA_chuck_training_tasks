SinOsc SinWave1 => dac;
SinOsc SinWave2 => dac;
SinOsc SinWave3 => dac;
SqrOsc SqrWave1 => dac;
SqrOsc SqrWave2 => dac;
SqrOsc SqrWave3 => dac;


// this generates an error
[SinWave1, SinWave2, SinWave3] @=> SinOsc Waves[];

// this works fine
[SqrWave1, SinWave2, SinWave3] @=> Osc Waves2[];
