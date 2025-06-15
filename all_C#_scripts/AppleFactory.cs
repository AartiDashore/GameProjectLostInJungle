using Godot;
using System;

public static class AppleFactory{
	private static PackedScene appleScene = (PackedScene)ResourceLoader.Load("res://scenes/Apple.tscn");

	public static Node3D CreateApple(Vector3 position)
	{
		var appleInstance = (Node3D)appleScene.Instantiate();
		appleInstance.GlobalPosition = position;
		return appleInstance;
	}
}
