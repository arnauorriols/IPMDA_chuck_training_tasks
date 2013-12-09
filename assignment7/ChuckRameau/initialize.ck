// Assignment_07_Chuck_Rameau

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

while(true) {
    if (dac.last() > 1.0) <<<"ERROOOOR", dac.last()>>>;
    1::samp => now;
}


