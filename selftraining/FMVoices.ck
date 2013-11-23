VoicForm v => Chorus vChorus => dac;

880 => v.freq;
0.0001 => v.pitchSweepRate;
1 => vChorus.modFreq;
0.5 => vChorus.modDepth;

while( true ){
    Math.random2f(330, 880) => v.freq;
    "aww" => v.phoneme;
    1 => v.speak;
    0.5::second => now;
    1 => v.quiet;
    0.4::second => now;
}
