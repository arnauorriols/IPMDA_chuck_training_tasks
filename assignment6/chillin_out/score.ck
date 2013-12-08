// Assignment_6_Chillin'_out

Machine.add(me.dir() + "/bass.ck") => int bassID;
Machine.add(me.dir() + "/piano.ck") => int pianoID;
Machine.add(me.dir() + "/melody.ck") => int melodyID;
Machine.add(me.dir() + "/drums.ck") => int drumsID;

/* Function to control the final output of dac, and if it's too loud and
 * distorting, print an error message and lower the dac's gain.
 */
fun void screamDac() {
    if (Std.fabs(dac.last()) > 1.0) {
        <<<"ERROOOOOOR! Too loud!!!. Lowering global gain...">>>;
        dac.gain() - 0.01 => dac.gain;
    }
    if ((now/second % 10) == 0.0) <<<"Dac is monitored, you are safe">>>;
    10::samp => now;
}

while(true) screamDac();

