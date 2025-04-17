using Godot;
using System;

[Tool]
public partial class LazyShader2d : Node3D
{
	
	ShaderMaterial   InitMat;
	SubViewport      SubViewInst;
	ColorRect        ColorRectInst;
	MeshInstance3D   MeshInst;
	StandardMaterial3D   MeshMat;
	
	[Export]
	public ShaderMaterial ShaderMat {
		get {
			if (ColorRectInst is not null) {
				return ColorRectInst.GetMaterial() as ShaderMaterial;
			} else {
				return null;
			}
		}
		set {
			if (ColorRectInst is null) {
				InitMat = value;
			} else {
				GD.Print(ColorRectInst);
				ColorRectInst.SetMaterial(value.Duplicate() as ShaderMaterial);
				MeshMat = MeshInst.GetActiveMaterial(0).Duplicate() as StandardMaterial3D;
				MeshInst.SetSurfaceOverrideMaterial(0,MeshMat);
				MeshMat.AlbedoTexture = SubViewInst.GetTexture();
			}
		}
	}
	
	void Setup() {
		SubViewInst   = GetNode("SubViewport") as SubViewport;
		ColorRectInst = GetNode("SubViewport/ColorRect") as ColorRect;
		MeshInst      = GetNode("MeshInstance3D") as MeshInstance3D;
		ShaderMat = InitMat;
	}
	
	bool SetupRequired() {
		return (ShaderMat is null);
	}
	
	public override void _Ready() {
		if (SetupRequired()) {
			Setup();
		}
	}
	
	public override void _Process(double delta) {
		if (SetupRequired()) {
			Setup();
		}
	}
	
}
