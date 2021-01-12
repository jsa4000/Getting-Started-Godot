using Godot;
using System;

public class Game : Spatial
{
 
	public override void _Ready()
	{
		string world = "World!";
		GD.PrintS("Hello", world);
	}

}
