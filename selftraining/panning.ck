[new SawOsc, new SawOsc,new SawOsc,new SawOsc, new SawOsc, new SawOsc] @=> SawOsc panner[];

Pan2 panControllers[panner.cap()];

for(0 => int x; x < panner.cap(); x++ ) {
    new Pan2 @=> panControllers[x];
    panner[x] => panControllers[x] => dac;
    440 + x * 20 => panner[x].freq;
    0.2 => panner[x].gain;
}

while( true ) {
    for( 0 => int x; x < panner.cap(); x++) {
        Math.sin( now/1::second * 2 * pi) => panControllers[x].pan;
        500::ms => now;
    }
}
