Machine.add(me.dir() + "/bass.ck") => int bassID;
Machine.add(me.dir() + "/piano.ck") => int pianoID;

fun void screamDac() {
    if (Std.fabs(dac.last()) > 1.0) <<<"ERROOOOOOR! Too loud!!!">>>;
    if ((now/second % 10) == 0.0) <<<"Dac is monitored, you are safe">>>;
    10::samp => now;
}

while(true) screamDac();

