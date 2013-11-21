adc => Gain g => blackhole; // lets samples through

while( true )
{
    if( adc.last() > 0.9 )
    {
        <<< "Loud!!!", adc.last() >>>;
    }
    1::samp => now;
}
