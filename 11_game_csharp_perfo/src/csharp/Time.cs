using Godot;
using System;
using System.Diagnostics;

public class Time
{
    public static T TimeIt<T>(Func<T> action)
    {
        var watch = Stopwatch.StartNew();

        var result = action();

        watch.Stop();
        var elapsedMs = watch.ElapsedMilliseconds;
        GD.Print($"Actions has been finished in {elapsedMs} ms");
        
        return result;
    }
}
