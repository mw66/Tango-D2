/******************************************************************************

        copyright:      Copyright (c) 2005 John Chapman. All rights reserved

        license:        BSD style: $(LICENSE)

        version:        mid 2005: Initial release
                        Apr 2007: heavily reshaped

        author:         John Chapman, Kris

******************************************************************************/

module tango.time.Time;

public import tango.time.TimeSpan;

/******************************************************************************

        Represents a point in time.

        Remarks: Time represents dates and times between 12:00:00 
        midnight on January 1, 10000 BC and 11:59:59 PM on December 31, 
        9999 AD.

        Time values are measured in 100-nanosecond intervals, or ticks. 
        A date value is the number of ticks that have elapsed since 
        12:00:00 midnight on January 1, 0001 AD in the Gregorian 
        calendar.
        
        Negative Time values are offsets from that same reference point, but
        backwards in history.  Time values are not specific to any calendar,
        but for an example, the beginning of December 31, 1 B.C. in the
        Gregorian calendar is Time.epoch - TimeSpan.day.


******************************************************************************/

struct Time 
{
        private long ticks_;

        /// Represents the smallest and largest Time value.
        public static const Time epoch = {0},
                                 max   = {(TimeSpan.DaysPer400Years * 25 - 366) * TimeSpan.TicksPerDay - 1},
                                 min   = {-((TimeSpan.DaysPer400Years * 25 - 366) * TimeSpan.TicksPerDay - 1)},
                                 epoch1601 = {TimeSpan.DaysPer400Years * 4 * TimeSpan.TicksPerDay},
                                 epoch1970 = {TimeSpan.DaysPer400Years * 4 * TimeSpan.TicksPerDay + TimeSpan.TicksPerSecond * 11644473600L};

        /**********************************************************************

                $(I Constructor.) Initializes a new instance of the 
                Time struct to the specified number of _ticks.         
                
                Params: ticks = A time expressed in units of 
                100 nanoseconds.

        **********************************************************************/

        static Time opCall (long ticks) 
        {
                Time d;
                d.ticks_ = ticks;
                return d;
        }

        /**********************************************************************

                $(I Property.) Retrieves the number of ticks for this Time

                Returns: A long represented by the time of this 
                         instance.

        **********************************************************************/

        long ticks ()
        {
                return ticks_;
        }

        /**********************************************************************

                Determines whether two Time values are equal.

                Params:  value = A Time _value.
                Returns: true if both instances are equal; otherwise, false

        **********************************************************************/

        int opEquals (Time t) 
        {
                return ticks_ is t.ticks;
        }

        /**********************************************************************

                Compares two Time values.

        **********************************************************************/

        int opCmp (Time t) 
        {
                if (ticks_ < t.ticks)
                    return -1;
                if (ticks_ > t.ticks)
                    return 1;
                return 0;
        }

        /**********************************************************************

                Adds the specified time span to the time, returning a new
                time.
                
                Params:  t = A TimeSpan value.
                Returns: A Time that is the sum of this instance and t.

        **********************************************************************/

        Time opAdd (TimeSpan t) 
        {
                return Time (ticks_ + t.ticks);
        }

        /**********************************************************************

                Adds the specified time span to the time, assigning 
                the result to this instance.

                Params:  t = A TimeSpan value.
                Returns: The current Time instance, with t added to the 
                         time.

        **********************************************************************/

        Time opAddAssign (TimeSpan t) 
        {
                ticks_ += t.ticks;
                return *this;
        }

        /**********************************************************************

                Subtracts the specified time span from the time, 
                returning a new time.

                Params:  t = A TimeSpan value.
                Returns: A Time whose value is the value of this instance 
                         minus the value of t.

        **********************************************************************/

        Time opSub (TimeSpan t) 
        {
                return Time (ticks_ - t.ticks);
        }

        /**********************************************************************

                Returns a time span which represents the difference in time
                between this and the given Time.

                Params:  t = A Time value.
                Returns: A TimeSpan which represents the difference between
                         this and t.

        **********************************************************************/

        TimeSpan opSub (Time t)
        {
                return TimeSpan(ticks_ - t.ticks);
        }

        /**********************************************************************

                Subtracts the specified time span from the time, 
                assigning the result to this instance.

                Params:  t = A TimeSpan value.
                Returns: The current Time instance, with t subtracted 
                         from the time.

        **********************************************************************/

        Time opSubAssign (TimeSpan t) 
        {
                ticks_ -= t.ticks;
                return *this;
        }

        /**********************************************************************

                $(I Property.) Retrieves the _hour component of the date.

                Returns: The _hour.

        **********************************************************************/

        int hour () 
        {
                return cast(int) ((ticks_ / TimeSpan.hour.ticks) % 24);
        }

        /**********************************************************************

                $(I Property.) Retrieves the _minute component of the date.

                Returns: The _minute.

        **********************************************************************/

        int minute () 
        {
                return cast(int) ((ticks_ / TimeSpan.minute.ticks) % 60);
        }

        /**********************************************************************

                $(I Property.) Retrieves the _second component of the date.

                Returns: The _second.

        **********************************************************************/

        int second () 
        {
                return cast(int) ((ticks_ / TimeSpan.second.ticks) % 60);
        }

        /**********************************************************************

                $(I Property.) Retrieves the _millisecond component of the 
                date.

                Returns: The _millisecond.

        **********************************************************************/

        int millisecond () 
        {
                return cast(int) ((ticks_ / TimeSpan.ms.ticks) % 1000);
        }

        /**********************************************************************

                $(I Property.) Retrieves the _microsecond component of the 
                date.

                Returns: The _microsecond.

        **********************************************************************/

        int microsecond () 
        {
                return cast(int) ((ticks_ / TimeSpan.us.ticks) % 1000);
        }

        /**********************************************************************

                $(I Property.) Retrieves the date component.

                Returns: A new Time instance with the same date as 
                         this instance.

        **********************************************************************/

        Time date () 
        {
                return *this - timeOfDay;
        }

        /**********************************************************************

                $(I Property.) Retrieves the time of day.

                Returns: A Time representing the fraction of the day elapsed since midnight.

        **********************************************************************/

        TimeSpan timeOfDay () 
        {
                return TimeSpan (ticks_ % TimeSpan.day.ticks);
        }
}



/*******************************************************************************

*******************************************************************************/

debug (Time)
{
        import tango.io.Stdout;

        Time foo() 
        {
                auto d = Time(10);
                auto e = TimeSpan(20);

                return d + e;
        }

        void main()
        {
                auto c = foo();
                Stdout (c.ticks).newline;
        }
}


