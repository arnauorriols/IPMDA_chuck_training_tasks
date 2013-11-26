// sound chain
ModalBar modal => NRev reverb => dac.left;
ModalBar modal2 => NRev reverb2 => dac.right;

// set reverb mix
.1 => reverb.mix;
// modalbar params
7 => modal.preset;
.9 => modal.strikePosition;
// set reverb mix
.1 => reverb2.mix;
// modalbar params
7 => modal2.preset;
.9 => modal2.strikePosition;

spork ~ one();
spork ~ two();
spork ~ tune();

while( true ) 1::second => now;

fun void one()
{
    while( true )
    {
        // note!
        1 => modal.strike;
        // wait
        300::ms => now;
        // note!
        .7 => modal.strike;
        // wait
        300::ms => now;

        repeat( 6 )
        {
            // note!
            .5 => modal.strike;
            // wait
            100::ms => now;
        }
    }
}

fun void two()
{
    while( true )
    {
        // offset
        150::ms => now;

        // note!
        1 => modal2.strike;
        // wait
        300::ms => now;
        // note!
        .75 => modal2.strike;
        // wait
        300::ms => now;
        // note!
        .5 => modal2.strike;
        // wait
        300::ms => now;
        // note!
        .25 => modal2.strike;
        // wait
        300::ms => now;
    }
}


fun void tune()
{
    while( true )
    {
        // update frequency
        84 + Math.sin( now/second*Math.PI*.25 )*5 => Std.mtof => modal.freq;
        // advance time (update rate)
        5::ms => now;
    }
}

/*
 * WORKING WITH CONCURRENCY
 * ========================
 *
 *      - Shred: a ChucK process; a thread of logic
 *      - spork ~ a function to run it on a new shred
 *      - shreds do not necessarily need to know about each other
 *              - only need to deal with time locally
 *      - no limit on the number of shreds (spork away!)
 *      - parent shreds must be kept alive to keep child shreds running
 */
