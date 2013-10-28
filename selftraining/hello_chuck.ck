/*
 * Author: Arnau Orriols
 *
 * Date: 26/10/2013
 */

<<< "Arnau Orriols - Hello Chuck!" >>>;

3 => int envTotalOsc;

Osc @ environment [envTotalOsc];
float envOscFreq [envTotalOsc];

new TriOsc @=> Osc @ melody;
new SawOsc @=> Osc @ effects;

0.2 => float maxEnvGain;

for ( 0 => int x; x < envTotalOsc; x++ ) {
    new SinOsc @=> environment[x];

    0 => environment[x].gain;
    440 + x * 50 => envOscFreq[x];
    environment[x] => dac;
}

0 => melody.gain;
0 => effects.gain;

melody => dac;
effects => dac;

while (calcTotalGain(environment) < maxEnvGain) {

    for (0 => int x; x < envTotalOsc; x++) {
        now + 3::second => time nextEntrance;
        while (now != nextEntrance) {
            environment[x].gain() + 0.0001 => environment[x].gain;
            setFreq(environment, envOscFreq);
            if (calcTotalGain(environment) > maxEnvGain){
                break;
            }
            10::ms => now;
        }
    }
}

[1.0, 1.25, 1.5, 2.0] @=> float MAJOR_CHORD[];
while ( true ) {
    0.15 => melody.gain;
    440 * MAJOR_CHORD[Math.random2(0, 3)] * Math.random2(1, 2) => melody.freq;
    for (0 => int x; x < 30; x++) {
        setFreq(environment, envOscFreq);
        if (Math.random2(0, 200) == 17) {
            0.1 => effects.gain;
            for (1500 => int x; x > 1000; 10 -=> x) {
                x => effects.freq;
                setFreq(environment, envOscFreq);
                10::ms => now;
            }
        } else {
            0 => effects.gain;
        }
        10::ms => now;
    }

}

fun float calcTotalGain(Osc osc[]){

    float totalGain;
    for (0 => int x; x < osc.cap(); x++) {
        osc[x].gain() +=> totalGain;
    }

    return totalGain;
}

fun float genFreqFluctuation(float baseFreq, int threshold) {
    Math.random2(-threshold, threshold) => int variation;
    baseFreq + variation => float finalFreq;
    if (finalFreq < 200 || finalFreq > 2000) {
        return baseFreq;
    } else {
        return baseFreq + variation;
    }
}

fun void setFreq(Osc osc[], float freq[]) {
    for(0 => int x; x < osc.cap(); x++) {
        genFreqFluctuation(freq[x], 10) => osc[x].freq;
        osc[x].freq() => freq[x];
    }
}

fun void setFreq(Osc osc[]) {
    for(0 => int x; x < osc.cap(); x++) {
        genFreqFluctuation(osc[x].freq(), 10) => osc[x].freq;
    }
}
