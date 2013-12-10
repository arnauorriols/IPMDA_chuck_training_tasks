// Assignment_7_Chuck_Rameau

// Drums.ck

RhythmCtl rhythm;

Pan2 pan => dac;
0.3 => pan.pan;
0.5 => pan.gain;

SndBuf kick =>JCRev kickrev => Delay kickdelay => pan;
SndBuf kick2 => kickrev;
SndBuf snare => LPF snarefilt => NRev snarerev => Delay snaredelay => pan;
SndBuf clap => PitShift clapshift => Chorus clapchor => NRev claprev => pan;
SndBuf clap2 => clapshift;
SndBuf hihat => BPF hatfilt => JCRev hatrev => Delay hatdelay => pan;
SndBuf hi2 => NRev hirev => Delay hidelay => pan;

me.dir(-1) + "/audio/" => string p;

p + "kick_04.wav" => kick.read;
p + "kick_05.wav" => kick2.read;
p + "snare_02.wav" => snare.read;
p + "clap_01.wav" => clap.read;
p + "clap_01.wav" => clap2.read;
p + "hihat_04.wav" => hihat.read;
p + "hihat_01.wav" => hi2.read;
rhythm.thirtysecond * 0.1 => kickdelay.delay;

0.5 => kick.gain => kick2.gain;
0.6 => kick.rate;
1.4 => kick2.rate;
0.01 => kickrev.mix;

0.8 => snare.rate;
2000 => snarefilt.freq;
2 => snarefilt.Q;
0.01 => snarerev.mix;
rhythm.thirtysecond * 0.3 => snaredelay.delay;

1.2 => clap.rate;
0.8 => clap2.rate;
2 => clap.gain => clap2.gain;
1.8 => clapshift.shift;
0.7 => clapchor.modDepth;
0.1 => clapchor.modFreq;
0.01 => claprev.mix;

.8 => hihat.rate;
0.05 => hatrev.mix;
15000 => hatfilt.freq;
5 => hatfilt.Q;
rhythm.thirtysecond * 0.1 => hatdelay.delay;

0.7 => hi2.rate;
0.3 => hi2.gain;
0.008 => hirev.mix;
rhythm.thirtysecond * 0.25 => hidelay.delay;

kick.samples() => kick.pos;
kick2.samples() => kick2.pos;
snare.samples() => snare.pos;
clap.samples() => clap.pos;
clap2.samples() => clap2.pos;
hihat.samples() => hihat.pos;
hi2.samples() => hi2.pos;

fun void playKick() {
    while(true) {
        0 => kick.pos;
        0 => kick2.pos;
        500 => hihat.pos;
        rhythm.quarter => now;
    }
}

fun void playClap() {
    while (true) {
        0 => clap.pos;
        0 => clap2.pos;
        rhythm.quarter => now;
    }
}

fun void playSnare() {
    [0,0,1,0,  0,0,1,1,  0,1,1,0,  0,1,1,0] @=> int pattern[];
    while(true) {
        for (0 => int x; x < pattern.cap(); x++) {
            if (pattern[x] == 1) {
                0 => snare.pos;
            }
            rhythm.sixteenth => now;
        }
    }
}

fun void playHi() {
    while(true) {
        rhythm.sixteenth => now;
        1000 => hi2.pos;
        rhythm.eighth => now;
    }
}

    spork ~ playClap() @=> Shred clapSh;
    rhythm.measure * 2 + rhythm.quarter => now;
    spork ~ playKick() @=> Shred kickSh;
    rhythm.measure * 2 => now;
    spork ~ playHi() @=> Shred hiSh;
    spork ~ playSnare() @=> Shred snareSh;
    rhythm.loop - rhythm.quarter=> now;
    clapSh.exit();
    kickSh.exit();
    snareSh.exit();
    hiSh.exit();
    rhythm.composition => now;


