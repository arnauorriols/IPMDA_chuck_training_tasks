BPM tempo;

tempo.tempo(150);

Machine.add(me.dir()+"/7.8-Kick.ck") => int kickID;
Machine.add(me.dir()+"/7.10-Cowbell.ck") => int cowID;

10::second => now;

tempo.tempo(300);

5::second => now;
Machine.remove(kickID);
Machine.remove(cowID);
<<<"end">>>;

