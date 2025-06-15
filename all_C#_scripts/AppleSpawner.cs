using Godot;
using System;

public partial class AppleSpawner : RigidBody3D
{
	[Export] public int appleCount = 10;
	[Export] public Vector3 forestMinBounds = new Vector3(-50, 0, -50);
	[Export] public Vector3 forestMaxBounds = new Vector3(50, 0, 50);

	public override void _Ready()
	{
		SpawnApples();
	}

	private void SpawnApples()
	{
		var random = new Random();
		for (int i = 0; i < appleCount; i++)
		{
			Vector3 randomPos = new Vector3(
				(float)(forestMinBounds.X + random.NextDouble() * (forestMaxBounds.X - forestMinBounds.X)),
				0, // or slightly above ground
				(float)(forestMinBounds.Z + random.NextDouble() * (forestMaxBounds.Z - forestMinBounds.Z))
			);

			var apple = AppleFactory.CreateApple(randomPos);
			AddChild(apple); // Attach to the scene
		}
	}
}
