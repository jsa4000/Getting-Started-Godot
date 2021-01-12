using Godot;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

public class Loop : Spatial
{

    public override void _Ready()
    {
        GD.PrintS("Starting C# Script Test");

        simpleLoopTest();

        /*
        Starting C# Script Test
        Fibonacci Test with counter 20000000 has finished in 334 ms
        Fibonacci Test with counter 20000000 has finished in 328 ms
        Fibonacci Test with counter 20000000 has finished in 326 ms
        Fibonacci Test with counter 20000000 has finished in 344 ms
        Fibonacci Test with counter 20000000 has finished in 339 ms
        Fibonacci Test with counter 20000000 has finished in 326 ms
        Fibonacci Test with counter 20000000 has finished in 327 ms
        Fibonacci Test with counter 20000000 has finished in 327 ms
        Fibonacci Test with counter 20000000 has finished in 326 ms
        Fibonacci Test with counter 20000000 has finished in 327 ms
        Fibonacci Test with counter 20000000 has finished in 326 ms
        Fibonacci Test with counter 20000000 has finished in 326 ms
        Fibonacci Test with counter 20000000 has finished in 326 ms
        Fibonacci Test with counter 20000000 has finished in 326 ms
        Fibonacci Test with counter 20000000 has finished in 328 ms
        Fibonacci Test with counter 20000000 has finished in 326 ms
        Fibonacci Test with counter 20000000 has finished in 346 ms
        Fibonacci Test with counter 20000000 has finished in 347 ms
        Fibonacci Test with counter 20000000 has finished in 326 ms
        Fibonacci Test with counter 20000000 has finished in 327 ms
        Simple Loop has been finished with an average of 330.4
        */

        GD.PrintS("C# has been finished");
    }

    private void simpleLoopTest()
    {
        var series = 20;
        var counter = 20000000;

        var executions = new List<long>();
        foreach (int i in Enumerable.Range(1, series))
        {
            executions.Add(simpleLoop(counter));
        }
        GD.Print($"Simple Loop has been finished with an average of {executions.Average()}");
    }

    private long simpleLoop(int number)
    {
        var watch = Stopwatch.StartNew();

        var counter = 0;
        foreach (int value in Enumerable.Range(1, number))
            counter++;

        watch.Stop();
        var elapsedMs = watch.ElapsedMilliseconds;
        GD.Print($"Fibonacci Test with counter {counter} has finished in {elapsedMs} ms");
        return elapsedMs;
    }

    private void fibonacciTest()
    {
        var watch = Stopwatch.StartNew();

        var counter = 0;
        foreach (int value in Enumerable.Range(1, 1000000))
        {
            //Console.Write(value + "  ");
            counter++;
        }

        watch.Stop();
        var elapsedMs = watch.ElapsedMilliseconds;
        GD.Print($"Fibonacci Test with counter {counter} has finished in {elapsedMs} ms");
    }



}
