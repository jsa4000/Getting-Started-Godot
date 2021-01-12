using Godot;
using System;
using System.Diagnostics;
using System.Linq;

public enum PrimitiveType
{
	CUBE, SPHERE, PLANE, CYLINDER, CAPSULE
}

[Tool]
public class Geometry : Spatial
{
	private PrimitiveType primitiveType;

	[Export(PropertyHint.Enum)]
	public PrimitiveType PrimitiveType
	{
		set
		{
			primitiveType = value;
			generate();
		}
		get => primitiveType;
	}

	private int subdivisions;

	[Export(PropertyHint.Range)]
	public int Subdivisions
	{
		set
		{
			subdivisions = value;
			generate();
		}
		get => subdivisions;
	}

	private bool computeSmooth = false;

	[Export]
	public bool ComputeSmooth
	{
		set
		{
			computeSmooth = value;
			generate();
		}
		get => computeSmooth;
	}

	private MeshInstance geometry = null;

	public override void _Ready() => generate();

	private void generate()
	{
		if (!IsInsideTree())
			return;

		var watch = Stopwatch.StartNew();

		removeGeometry(geometry);
		geometry = createPrimitive(primitiveType);
		foreach (int i in Enumerable.Range(0, subdivisions))
			//geometry = MeshTools.Subdivide(geometry, false);
			geometry = MeshTools.ParallelLinqSubdivide(geometry, false);
		if (computeSmooth)
			//geometry = Time.TimeIt(() => MeshTools.Smooth(geometry));
			//geometry = Time.TimeIt(() => MeshTools.ParallelSmooth(geometry));
			geometry = Time.TimeIt(() => MeshTools.ParallelLinqSmooth(geometry));
		AddChild(geometry);

		watch.Stop();
		var elapsedMs = watch.ElapsedMilliseconds;
		GD.Print($"CSharp Generation has been finished in {elapsedMs} ms");

		/** 

		SUBDIVISION

		With SurfaceTool

		Set ComputeSmooth ON
		CSharp Generation has been finished in 4 ms
		Set ComputeSmooth OFF
		Set Subdivisions 1
		CSharp Generation has been finished in 140 ms
		Set Subdivisions 2
		CSharp Generation has been finished in 679 ms
		Set Subdivisions 3
		CSharp Generation has been finished in 2935 ms
		Set Subdivisions 4
		CSharp Generation has been finished in 12606 ms
		Set Subdivisions 5
		CSharp Generation has been finished in 55325 ms  // 25.952.462

		With ArrayMesh

		Set Subdivisions 1
		CSharp Generation has been finished in 21 ms
		Set Subdivisions 2
		CSharp Generation has been finished in 89 ms
		Set Subdivisions 3
		CSharp Generation has been finished in 364 ms
		Set Subdivisions 4
		CSharp Generation has been finished in 1466 ms
		Set Subdivisions 5
		CSharp Generation has been finished in 6241 ms // 25.952.510

		Parallel With ArrayMesh
		Set Subdivisions 1
		CSharp Generation has been finished in 18 ms
		Set Subdivisions 2
		CSharp Generation has been finished in 70 ms
		Set Subdivisions 3
		CSharp Generation has been finished in 284 ms
		Set Subdivisions 4
		CSharp Generation has been finished in 1106 ms
		Set Subdivisions 5
		CSharp Generation has been finished in 4738 ms
		Set Subdivisions 6
		CSharp Generation has been finished in 22834 ms // 103.809.278

		SMOOTH

		No parallel
		Set ComputeSmooth 1 and  Set Subdivisions 1
		Actions has been finished in 131895 ms (Smooth)
		CSharp Generation has been finished in 132023 ms // 107.408

		Parallel (4 cores)
		Set ComputeSmooth 1 and  Set Subdivisions 1
		Actions has been finished in 35933 ms (ParallelSmooth)
		CSharp Generation has been finished in 36051 ms // 107.408

		Parallel (6 cores)
		Set ComputeSmooth 1 and  Set Subdivisions 1
		Actions has been finished in 26191 ms (ParallelSmooth)
		CSharp Generation has been finished in 26310 ms // 107.408


		Parallel Linq (max? cores) 
		CSharp Generation has been finished in 36051 ms
		Actions has been finished in 22282 ms (ParallelLinqSmooth)
		CSharp Generation has been finished in 22409 ms // 107.408

		*/

	}

	private void removeGeometry(MeshInstance geometry)
	{
		if (geometry is null)
			return;
		RemoveChild(geometry);
		geometry.QueueFree();
	}

	private MeshInstance createPrimitive(PrimitiveType primitiveType = PrimitiveType.CUBE)
	{
		var mesh = getPrimitiveMesh(primitiveType);
		var geometry = new MeshInstance();
		var arrayMesh = new ArrayMesh();
		arrayMesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, mesh.GetMeshArrays());
		geometry.Mesh = arrayMesh;
		return geometry;
	}

	private PrimitiveMesh getPrimitiveMesh(PrimitiveType primitiveType) => primitiveType switch
	{
		PrimitiveType.CUBE => new CubeMesh(),
		PrimitiveType.SPHERE => new SphereMesh(),
		PrimitiveType.PLANE => new PlaneMesh(),
		PrimitiveType.CYLINDER => new CylinderMesh(),
		PrimitiveType.CAPSULE => new CapsuleMesh(),
		_ => new CubeMesh()
	};

}
