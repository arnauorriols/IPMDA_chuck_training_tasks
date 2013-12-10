// Assignment_07_Chuck_Rameau

// version of initialize to record a wav

dac => WvOut2 w => blackhole;

"Chuck_Rameau.wav" => w.wavFilename;
1 => w.record;

me.dir() => string path;

// Rhythm and Harmony control classes
Machine.add(path + "/HarmCtl.ck") => int hctlID;
Machine.add(path + "/RhythmCtl.ck") => int rctlID;

// Utilities class
Machine.add(path + "/Utils.ck");
Machine.add(path + "/EnvelopedLPF.ck");

// Instruments class
Machine.add(path + "/LeadPad.ck");

// Score
Machine.add(path + "/score.ck") => int scoreID;
32::second => now;
0 => w.record;

