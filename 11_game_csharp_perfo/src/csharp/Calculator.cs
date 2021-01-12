using Godot;
using System;

public class Calculator : Reference
{
    public String name = "Calculator";

    public void PrintNodeName(Node node) => GD.Print(node.Name);

    public static float Sum(float x, float y) => x + y;


}
