using Godot;
using System;

public partial class LazyInitializer : Node3D
{
	[Export] public Node3D ProtonScatter;
	[Export] public Node3D Temple;
	[Export] public CharacterBody3D Player;
	[Export] public float ActivationDistance = 25f;

	private bool _activated = false;

	public override void _Ready()
	{
		// Initial state: hide heavy nodes
		if (ProtonScatter != null) ProtonScatter.Visible = false;
		if (Temple != null) Temple.Visible = false;

		// Try to activate after 1 second (delayed to avoid frame stutter)
		GetTree().CreateTimer(1.0f).Timeout += () =>
		{
			TryActivate("time");
		};
	}

	public override void _Process(double delta)
	{
		if (_activated || Player == null || ProtonScatter == null) return;

		// Activate if player gets close
		float distance = Player.GlobalPosition.DistanceTo(ProtonScatter.GlobalPosition);
		if (distance < ActivationDistance)
		{
			TryActivate("proximity");
		}
	}

	private void TryActivate(string reason)
	{
		if (_activated) return;
		GD.Print($"[LazyInit] Activating heavy nodes due to: {reason}");

		if (ProtonScatter != null)
			ProtonScatter.Visible = true;

		if (Temple != null)
			Temple.Visible = true;

		_activated = true;
	}
}
