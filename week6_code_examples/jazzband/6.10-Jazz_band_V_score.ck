// paths to chuck files
me.dir() + "/6.8-Jazz_band_III_piano.ck" => string pianoPath;
me.dir() + "/6.6-Jazz_band_I_bass.ck" => string bassPath;
me.dir() + "/6.7-Jazz_band_II_drums.ck" => string drumsPath;
me.dir() + "/6.9-Jazz_band_IV_flute.ck" => string flutePath;

// start piano
Machine.add(pianoPath) => int pianoID;
4.8::second => now;

// start drums
Machine.add(drumsPath) => int drumsID;
4.8::second => now;

// start bass
Machine.add(bassPath) => int baseID;
4.8::second => now;

// start flute
Machine.add(flutePath) => int fluteID;
4.8::second => now;

// remove drums
Machine.remove(drumsID);
4.8::second => now;

Machine.add(drumsPath) => drumsID;
4.8::second => now;
