<<<"Hello pan!">>>;
//Pan2 panControl => dac;

SinOsc baseChor1 => dac;
40 => int numPartials;
SinOsc partials[numPartials];
for ( 0 => int x; x < numPartials; x++ ) {
    SinOsc p @=> partials[x];
    partials[x] => dac;
    //0.030 - (Math.tan(x * pi / 180)*0.12) => partials[x].gain;
    (Math.sqrt(x)/(x*x)) * 0.100 => partials[x].gain;
    if (partials[x].gain() < 0){
        0 => partials[x].gain;
    }
}

SawOsc melody => dac;
0.10 => melody.gain;

SinOsc scale => Pan2 panControl => dac;
0 => scale.gain;
4 => int quartersMeasure; // 4/4 meter

30::second => dur totalDuration;
0.25::second => dur quarter;
quarter / 2 => dur eighth;
eighth / 2 => dur sixteenth;
quarter * 2 => dur half;
quarter * quartersMeasure => dur measure;     // 6/4 meter

Std.ftoi(totalDuration / quarter) => int maxQuarters;   // 120 quarters

maxQuarters / quartersMeasure => int maxMeasure; // 30 Measures

/* 24 measures + cadence of 6 measures */

24 => int measuresMain;
6 => int measuresCadence;

measuresMain * quartersMeasure => int quartersMain;
measuresCadence * quartersMeasure => int quartersCadence;

[0, 2, 3, 5, 7, 9, 10, 12] @=> int dorianScaleMidi[];
50 => int midiTonic;
12 => int midiOctave;

[0, 2, 6, 3] @=> int baseIndexes[];
measure => dur baseRhythm;
baseRhythm * 4 => dur baseSequence;
Std.ftoi(baseSequence / baseRhythm) => int totalBaseSequence;
measuresMain / totalBaseSequence => int numBaseSequenceInMain;
Std.ftoi(baseSequence / quarter) => int quartersSequence;
quartersSequence / 4 => int sixteenthSequence;


[4, 4, 6, 7, 3, 3, 1, 6, 7, 3, 3, 1, 5, 6, 1, 1, 7, 6, 5, 4] @=> int standardSequence[];
[0, 0, 0, 0, 1, 1, 1, 0, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 0] @=> int octaveRelation[];
[quarter, quarter, eighth, quarter, eighth] @=> dur standardSequenceRhythm[];
0.3 => baseChor1.gain;
                0 => int scaleNote;
                -3 => int scaleOctave;

for( 0 => int x; x < numBaseSequenceInMain; x++){
    
    now => time sinStart;
    for(0 => int seqRhythmRepeat; seqRhythmRepeat < 4; seqRhythmRepeat++ ) {
        midiTonic + dorianScaleMidi[baseIndexes[seqRhythmRepeat]] => int midiNote;
        if( seqRhythmRepeat == 2 ) {
            midiOctave -=> midiNote;
        }
        midiOctave -=> midiNote;
        Std.mtof(midiNote) => baseChor1.freq;
        for (0 => int y; y < numPartials; y++) {
            baseChor1.freq()*(y+2) => partials[y].freq;
        }
        for( 0 => int note; note < standardSequenceRhythm.cap(); note++) {
            midiTonic +
            dorianScaleMidi[standardSequence[note+(seqRhythmRepeat*standardSequenceRhythm.cap())]]+(midiOctave*octaveRelation[note+(seqRhythmRepeat*standardSequenceRhythm.cap())])
            => int seqMidiNote;
            Std.mtof(seqMidiNote) => melody.freq;
            if (x == 2){
                0.25 => scale.gain;

                for(0*sixteenth => dur sixteenthScale; sixteenthScale <
                    standardSequenceRhythm[note]; sixteenth +=> sixteenthScale){
                    Std.mtof(midiTonic + dorianScaleMidi[scaleNote] +
                    (midiOctave * scaleOctave)) => scale.freq;
                    Math.sin(((now-sinStart)/(baseSequence*2) *
                    (2*pi))-(pi/2)) => panControl.pan;
                    <<<panControl.pan()>>>;
                    sixteenth => now;
                    if(scaleNote != 7){
                        scaleNote++;
                    }else{
                        1 => scaleNote;
                        scaleOctave++;
                    }
                }
            }
            else if (x == 3){
                0.25 => scale.gain;

                for(0*sixteenth => dur sixteenthScale; sixteenthScale <
                    standardSequenceRhythm[note]; sixteenth +=> sixteenthScale){
                    Std.mtof(midiTonic + dorianScaleMidi[scaleNote] +
                    (midiOctave * scaleOctave)) => scale.freq;
                    Math.sin(((now-sinStart)/(baseSequence*2) *
                    (2*pi))+(pi/2)) => panControl.pan;
                    <<<panControl.pan()>>>;
                    sixteenth => now;
                    if(scaleNote != 0){
                        scaleNote--;
                    }else{
                        6 => scaleNote;
                        scaleOctave--;
                    }
                }
            }else{
               0 =>  scale.gain;
            standardSequenceRhythm[note] => now;
            }
        }
        


    }
}




