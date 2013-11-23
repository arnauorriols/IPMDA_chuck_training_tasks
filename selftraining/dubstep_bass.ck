// sound chain
SqrOsc car;
SqrOsc detunedCar;
SawOsc car2;
SawOsc detunedCar2;

SinOsc subBass;

car => ADSR env =>  LPF filter => Gain bassGain => JCRev rev => Gain master => dac;
detunedCar => env;
car2 => ADSR env2 =>  LPF filter2 => bassGain;
0.5 => bassGain.gain;
detunedCar2 => env2;

subBass => bassGain;

0.08 => car.gain => detunedCar.gain;
0.15 => car2.gain => detunedCar2.gain;

0.04=> rev.mix;
0.6 => subBass.gain;
0.8 => master.gain;
SinOsc mod => ADSR filterEnv => blackhole;
SinOsc mod2 => ADSR filterEnv2 => blackhole;

1.714::second => dur measure;
measure / 2 => dur half;
half / 2 => dur quarter;
quarter / 2 => dur eighth;
eighth / 2 => dur sixteenth;
2::samp => dur beattime;
0 => int beat;

(measure * 0.08, measure * 0.5, 0.7, measure*0.4) => env.set;
(measure * 0.0001, measure * 0.7, 0.001, measure*0.0001) => env2.set;
(measure * 0.6, measure * 0.1, 1, measure*0.4) => filterEnv.set;
(measure * 0.2, measure * 0.7, 0.001, measure*0.0001) => filterEnv2.set;
12 / (measure/second) => mod.freq;
24 / (measure/second) => mod2.freq;
750 => mod.gain;
1000 => mod2.gain;

4 => filter.Q;
3 => filter2.Q;

SndBuf kick => LPF kickFilter => PitShift kickShift => Delay kickDelay => Gain drumsGain => rev;
SndBuf snare => Delay snareDelay => drumsGain;
SndBuf hihat => PitShift hiShift => Delay hiDelay => drumsGain;
SndBuf clap => JCRev clapRev => Delay clapDelay => drumsGain;

me.dir() + "/audio/kick_05.wav" => kick.read;
me.dir() + "/audio/snare_01.wav" => snare.read;
me.dir() + "/audio/hihat_03.wav" => hihat.read;
me.dir() + "/audio/clap_01.wav" => clap.read;
kick.samples() => kick.pos;
snare.samples() => snare.pos;
hihat.samples() => hihat.pos;
clap.samples() => clap.pos;
0.45 => kick.gain;
0.6 => drumsGain.gain;
1.4 => snare.gain;
.5 => snare.rate;
2.5 => hihat.gain;
2.0 => hihat.rate;
2.5 => hiShift.shift;
0.4 => clap.gain;
0.7 => clap.rate;
0.06 => clapRev.mix;
sixteenth/2 => snareDelay.delay;
sixteenth/2.5 => kickDelay.delay;
sixteenth/3 => hiDelay.delay;
sixteenth/1 => clapDelay.delay;
80 => kickFilter.freq;
 4 => kickFilter.Q;
1.2 => kickShift.shift;
2 => kick.rate;

[[1, 0, 0, 0,  0, 0, 0, 0,  0, 0, 1, 0,  0, 0, 0, 0],
 [0, 0, 0, 0,  0, 0, 0, 0,  1, 0, 0, 0,  0, 0, 0, 0],
 [0, 0, 0, 0,  0, 0, 1, 1,  0, 0, 0, 0,  0, 0, 1, 0],
 [0, 0, 1, 0,  0, 0, 0, 0,  0, 0, 0, 0,  1, 0, 0, 0]] @=> int drumsPattern[][];

fun void playDrums(int _beatInLoop, int pattern[][]){
    _beatInLoop % Std.ftoi(measure/beattime) => int beatInMeasure;
    if (beatInMeasure % Std.ftoi(sixteenth/beattime) == 0){
        (beatInMeasure % Std.ftoi(measure/beattime)) /
        Std.ftoi(sixteenth/beattime) => int sixteenthInMeasure;
        <<<sixteenthInMeasure, beatInMeasure>>>;
        if (pattern[0][sixteenthInMeasure] == 1) {
            0 => kick.pos;
            <<<"kick">>>;
        }
        if (pattern[1][sixteenthInMeasure] == 1) {
            0 => snare.pos;
            <<<"snare">>>;
        }
        if (pattern[3][sixteenthInMeasure] == 1) {
            0 => hihat.pos;
        }
        if (pattern[2][sixteenthInMeasure] == 1) {
            0 => clap.pos;
        }
    }
}
while( true )
{
    beat % Std.ftoi(4 *(measure/beattime)) => int beatInLoop;

    playDrums(beatInLoop, drumsPattern);

    if (beatInLoop == 0){
            Std.mtof(21*2) => car.freq;
            (car.freq() *2) * 0.9873727035533443  => detunedCar.freq; // -22 cents
            Std.mtof(21*2) => car2.freq;
            car2.freq() * 1.0168921424934556 => detunedCar2.freq;
            Std.mtof(21) => subBass.freq;
            1 => env.keyOn => env2.keyOn;
            1 => filterEnv.keyOn;
            1 => filterEnv2.keyOn;
    } else if (beatInLoop == Std.ftoi(measure/beattime)){
        Std.mtof(24*2) * 0.9715319411536059 => car.freq;
            (car.freq()*2) * 0.9873727035533443  => detunedCar.freq;
        Std.mtof(24*2) * 0.9715319411536059=> car2.freq;
            car2.freq() * 1.0168921424934556 => detunedCar2.freq;
            Std.mtof(24) * 0.9715319411536059 => subBass.freq;
        1 => env.keyOn => env2.keyOn;
        1 => filterEnv.keyOn;
        1 => filterEnv2.keyOn;
    } else if (beatInLoop ==  2* Std.ftoi(measure/beattime)){
        Std.mtof(23*2) => car.freq;
            (car.freq()*2) * 0.9873727035533443  => detunedCar.freq;
        Std.mtof(23*2) => car2.freq;
            car2.freq() * 1.0168921424934556 => detunedCar2.freq;
            Std.mtof(23) => subBass.freq;
        1 => env.keyOn => env2.keyOn;
        1 => filterEnv.keyOn;
        1 => filterEnv2.keyOn;
    } else if (beatInLoop == 3 * (measure/beattime)){
        Std.mtof(22*2) * 0.9493421209505192 => car.freq;
            (car.freq()*2) * 0.9873727035533443  => detunedCar.freq;
        Std.mtof(22*2) * 0.9493421209505192 => car2.freq;
            car2.freq() * 1.0168921424934556 => detunedCar2.freq;
            Std.mtof(22) * 0.9493421209505192 => subBass.freq;
        1 => env.keyOn => env2.keyOn;
        1 => filterEnv.keyOn;
        1 => filterEnv2.keyOn;

    } else if (beatInLoop % (measure/beattime) == (measure/beattime) -
    Std.ftoi(quarter/beattime)) 
    {
        1 => env.keyOff;
        1 => env2.keyOff;
        1 => filterEnv.keyOff;
        1 => filterEnv2.keyOff;
    }

    filterEnv.last() + 900   => filter.freq;
    filterEnv2.last() + 1400   => filter2.freq;
    if (Std.fabs(dac.last()) > 1.0 || Std.fabs(master.last()) > 1 ||
        Std.fabs(env.last()) > 1 || Std.fabs(env2.last()) > 1){
        <<<"Loud", env2.last()>>>;
    }
    beattime => now;
    beat++;
}
