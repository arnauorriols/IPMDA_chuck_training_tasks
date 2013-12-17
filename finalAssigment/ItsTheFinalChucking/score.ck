// SCORE DEFINITION FILE

// HARMONY AND RHYTHM CONTROL CLASSES
MasterCtl control;

control.setName("It's the Final Chucking!");
control.harmony.setScale("D#2", "aeolian");
control.rhythm.setMeter(4, 4);
control.rhythm.setTempo(128);
control.rhythm.structureCtl(60, 2, 4, 4);
// 60 seconds, 2 sections, 2 loops per section, 8 measures per loop

control.printDetails();

// START OF COMPOSITION
now => RhythmCtl.start;
0.95 => dac.gain;
Machine.add(me.dir() + "/bass.ck") => int bassID;
RhythmCtl.loop => now;
Machine.add(me.dir() + "/lead.ck") => int leadID;
RhythmCtl.loop => now;
Machine.add(me.dir() + "/lead2.ck") => int lead2ID;
RhythmCtl.loop => now;
Machine.add(me.dir() + "/drums.ck") => int drumsID;
RhythmCtl.loop => now;
Machine.remove(bassID);
Machine.remove(leadID);
Machine.remove(lead2ID);
RhythmCtl.loop => now;
Machine.add(me.dir() + "/bass.ck") => bassID;
Machine.add(me.dir() + "/lead.ck") => leadID;
Machine.add(me.dir() + "/lead2.ck") => lead2ID;
RhythmCtl.loop * 2 => now;
Machine.remove(leadID);
Machine.remove(lead2ID);
RhythmCtl.loop / 2.0 => now;
Machine.remove(drumsID);
RhythmCtl.loop / 2.0 => now;
RhythmCtl.measure => now;
Machine.remove(bassID);




