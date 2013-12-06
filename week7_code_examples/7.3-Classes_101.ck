class TestData
{
    // member variables
    1 => int myInt;
    0.0 => float myFrac;

    // member function that adds the data
    fun float sum()
    {
        return (myInt + myFloat);
    }
}

TestData d;

<<< d.myInt, d.myFrac, d.sum() >>>;

// advance time
1::second => now;

// change the data
3 => d.myInt;
0.14159 => d.myFrac;

<<< d.myInt, d.myFrac, d.sum() >>>;
