using Godot;
using Godot.Collections;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

public class MeshTools : Reference
{

    public static MeshInstance Subdivide(MeshInstance geometry, bool smooth = false)
    {
        var mesh = new ArrayMesh();
        var surfTool = new SurfaceTool();
        surfTool.Begin(Mesh.PrimitiveType.Triangles);
        surfTool.AddSmoothGroup(smooth);
        var mdt = new MeshDataTool();

        foreach (int si in Enumerable.Range(0, geometry.Mesh.GetSurfaceCount()))
        {
            mdt.CreateFromSurface((ArrayMesh)geometry.Mesh, si);

            foreach (int vertexIndex in Enumerable.Range(0, mdt.GetVertexCount()))
            {
                surfTool.AddUv(mdt.GetVertexUv(vertexIndex));
                surfTool.AddVertex(mdt.GetVertex(vertexIndex));
            }

            var vertexCount = mdt.GetVertexCount();
            foreach (int faceIndex in Enumerable.Range(0, mdt.GetFaceCount()))
            {
                var v0 = mdt.GetFaceVertex(faceIndex, 0);
                var v1 = mdt.GetFaceVertex(faceIndex, 1);
                var v2 = mdt.GetFaceVertex(faceIndex, 2);

                surfTool.AddUv(getMiddleUV(mdt, v0, v1));
                surfTool.AddVertex(getMiddlePoint(mdt, v0, v1));

                surfTool.AddUv(getMiddleUV(mdt, v1, v2));
                surfTool.AddVertex(getMiddlePoint(mdt, v1, v2));

                surfTool.AddUv(getMiddleUV(mdt, v2, v0));
                surfTool.AddVertex(getMiddlePoint(mdt, v2, v0));

                var mv0 = vertexCount;
                var mv1 = vertexCount + 1;
                var mv2 = vertexCount + 2;

                triangulate(surfTool, v0, mv0, mv2);
                triangulate(surfTool, v1, mv1, mv0);
                triangulate(surfTool, v2, mv2, mv1);
                triangulate(surfTool, mv0, mv1, mv2);

                vertexCount += 3;
            }

            surfTool.GenerateNormals();
            surfTool.Commit(mesh);
        }

        var result = new MeshInstance();
        result.Mesh = mesh;
        return result;

    }

    public static MeshInstance Subdivide2(MeshInstance geometry, bool smooth = false)
    {
        var mesh = new ArrayMesh();
        var mdt = new MeshDataTool();

        foreach (int si in Enumerable.Range(0, geometry.Mesh.GetSurfaceCount()))
        {
            mdt.CreateFromSurface((ArrayMesh)geometry.Mesh, si);

            var totalVertices = (mdt.GetFaceCount() * 3) * 2; // Each triable doubles the number of vertices. A triangle has 3 vertices.
            var totalIndices = (mdt.GetFaceCount() * 4) * 3;  // Each triangle is divided by 4, 3 indices each one.

            var vertices = new Vector3[totalVertices];
            var uvs = new Vector2[totalVertices];
            var normals = new Vector3[totalVertices];
            var indices = new int[totalIndices];

            var vertexCount = 0;
            var vertexIndices = 0;
            foreach (int faceIndex in Enumerable.Range(0, mdt.GetFaceCount()))
            {
                var faceNormal = mdt.GetFaceNormal(faceIndex);

                var v0 = mdt.GetFaceVertex(faceIndex, 0);
                var v1 = mdt.GetFaceVertex(faceIndex, 1);
                var v2 = mdt.GetFaceVertex(faceIndex, 2);

                uvs[vertexCount] = mdt.GetVertexUv(v0);
                normals[vertexCount] = mdt.GetVertexNormal(v0);
                vertices[vertexCount] = mdt.GetVertex(v0);

                uvs[vertexCount + 1] = mdt.GetVertexUv(v1);
                normals[vertexCount + 1] = mdt.GetVertexNormal(v1);
                vertices[vertexCount + 1] = mdt.GetVertex(v1);

                uvs[vertexCount + 2] = mdt.GetVertexUv(v2);
                normals[vertexCount + 2] = mdt.GetVertexNormal(v2);
                vertices[vertexCount + 2] = mdt.GetVertex(v2);

                var mv0 = vertexCount + 3;
                var mv1 = vertexCount + 4;
                var mv2 = vertexCount + 5;

                uvs[mv0] = getMiddleUV(mdt, v0, v1);
                normals[mv0] = getMiddleNormal(mdt, v0, v1);
                vertices[mv0] = getMiddlePoint(mdt, v0, v1);

                uvs[mv1] = getMiddleUV(mdt, v1, v2);
                normals[mv1] = getMiddleNormal(mdt, v1, v2);
                vertices[mv1] = getMiddlePoint(mdt, v1, v2);

                uvs[mv2] = getMiddleUV(mdt, v2, v0);
                normals[mv2] = getMiddleNormal(mdt, v2, v0);
                vertices[mv2] = getMiddlePoint(mdt, v2, v0);

                indices[vertexIndices] = vertexCount; indices[vertexIndices + 1] = mv0; indices[vertexIndices + 2] = mv2;
                indices[vertexIndices + 3] = vertexCount + 1; indices[vertexIndices + 4] = mv1; indices[vertexIndices + 5] = mv0;
                indices[vertexIndices + 6] = vertexCount + 2; indices[vertexIndices + 7] = mv2; indices[vertexIndices + 8] = mv1;
                indices[vertexIndices + 9] = mv0; indices[vertexIndices + 10] = mv1; indices[vertexIndices + 11] = mv2;

                vertexCount += 6;
                vertexIndices += 12;
            }

            // Arrays must be here since vertices, uvs, pointers can change...
            var arrays = new Godot.Collections.Array();
            arrays.Resize((int)Mesh.ArrayType.Max);

            arrays[(int)Mesh.ArrayType.Vertex] = vertices;
            arrays[(int)Mesh.ArrayType.TexUv] = uvs;
            arrays[(int)Mesh.ArrayType.Normal] = normals;
            arrays[(int)Mesh.ArrayType.Index] = indices;

            mesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, arrays);
        }
        return new MeshInstance { Mesh = mesh };
    }


    public static MeshInstance ParallelLinqSubdivide(MeshInstance geometry, bool smooth = false)
    {
        var mesh = new ArrayMesh();
        var mdt = new MeshDataTool();

        foreach (int si in Enumerable.Range(0, geometry.Mesh.GetSurfaceCount()))
        {
            mdt.CreateFromSurface((ArrayMesh)geometry.Mesh, si);

            var totalVertices = (mdt.GetFaceCount() * 3) * 2; // Each triable doubles the number of vertices. A triangle has 3 vertices.
            var totalIndices = (mdt.GetFaceCount() * 4) * 3;  // Each triangle is divided by 4, 3 indices each one.

            var vertices = new Vector3[totalVertices];
            var uvs = new Vector2[totalVertices];
            var normals = new Vector3[totalVertices];
            var indices = new int[totalIndices];

            //foreach (int faceIndex in Enumerable.Range(0, mdt.GetFaceCount()))
            var parallel = Enumerable.Range(0, mdt.GetFaceCount()).AsParallel();
            parallel.ForAll(faceIndex =>
            {
                var vertexCount = faceIndex * 6;
                var vertexIndices = faceIndex * 12;
                var faceNormal = mdt.GetFaceNormal(faceIndex);

                var v0 = mdt.GetFaceVertex(faceIndex, 0);
                var v1 = mdt.GetFaceVertex(faceIndex, 1);
                var v2 = mdt.GetFaceVertex(faceIndex, 2);

                uvs[vertexCount] = mdt.GetVertexUv(v0);
                normals[vertexCount] = mdt.GetVertexNormal(v0);
                vertices[vertexCount] = mdt.GetVertex(v0);

                uvs[vertexCount + 1] = mdt.GetVertexUv(v1);
                normals[vertexCount + 1] = mdt.GetVertexNormal(v1);
                vertices[vertexCount + 1] = mdt.GetVertex(v1);

                uvs[vertexCount + 2] = mdt.GetVertexUv(v2);
                normals[vertexCount + 2] = mdt.GetVertexNormal(v2);
                vertices[vertexCount + 2] = mdt.GetVertex(v2);

                var mv0 = vertexCount + 3;
                var mv1 = vertexCount + 4;
                var mv2 = vertexCount + 5;

                uvs[mv0] = getMiddleUV(mdt, v0, v1);
                normals[mv0] = getMiddleNormal(mdt, v0, v1);
                vertices[mv0] = getMiddlePoint(mdt, v0, v1);

                uvs[mv1] = getMiddleUV(mdt, v1, v2);
                normals[mv1] = getMiddleNormal(mdt, v1, v2);
                vertices[mv1] = getMiddlePoint(mdt, v1, v2);

                uvs[mv2] = getMiddleUV(mdt, v2, v0);
                normals[mv2] = getMiddleNormal(mdt, v2, v0);
                vertices[mv2] = getMiddlePoint(mdt, v2, v0);

                indices[vertexIndices] = vertexCount; indices[vertexIndices + 1] = mv0; indices[vertexIndices + 2] = mv2;
                indices[vertexIndices + 3] = vertexCount + 1; indices[vertexIndices + 4] = mv1; indices[vertexIndices + 5] = mv0;
                indices[vertexIndices + 6] = vertexCount + 2; indices[vertexIndices + 7] = mv2; indices[vertexIndices + 8] = mv1;
                indices[vertexIndices + 9] = mv0; indices[vertexIndices + 10] = mv1; indices[vertexIndices + 11] = mv2;
            });

            // Arrays must be here since vertices, uvs, pointers can change...
            var arrays = new Godot.Collections.Array();
            arrays.Resize((int)Mesh.ArrayType.Max);

            arrays[(int)Mesh.ArrayType.Vertex] = vertices;
            arrays[(int)Mesh.ArrayType.TexUv] = uvs;
            arrays[(int)Mesh.ArrayType.Normal] = normals;
            arrays[(int)Mesh.ArrayType.Index] = indices;

            mesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, arrays);
        }
        return new MeshInstance { Mesh = mesh };
    }

    public static MeshInstance Smooth(MeshInstance geometry, float thresholdDegrees = 0.0f)
    {
        var mesh = new ArrayMesh();
        var mdt = new MeshDataTool();
        var mdt2 = new MeshDataTool();
        foreach (int si in Enumerable.Range(0, geometry.Mesh.GetSurfaceCount()))
        {
            mdt.CreateFromSurface((ArrayMesh)geometry.Mesh, si);
            mdt2.CreateFromSurface((ArrayMesh)geometry.Mesh, si);
            foreach (int vertexIndex in Enumerable.Range(0, mdt.GetVertexCount()))
            {
                var vertexNormal = Vector3.Zero;
                var neighbors = GetNearestNeighbors(mdt2, vertexIndex);
                foreach (int neighbor in neighbors)
                    vertexNormal += mdt2.GetVertexNormal(neighbor);
                vertexNormal = vertexNormal / (float)neighbors.Length;
                mdt.SetVertexNormal(vertexIndex, vertexNormal.Normalized());
            }
            mdt.CommitToSurface(mesh);
        }
        var result = new MeshInstance();
        result.Mesh = mesh;
        return result;
    }

    public static MeshInstance ParallelSmooth(MeshInstance geometry, float thresholdDegrees = 0.0f)
    {
        var mesh = new ArrayMesh();
        var mdt = new MeshDataTool();
        var mdt2 = new MeshDataTool();
        var options = new ParallelOptions { MaxDegreeOfParallelism = 6 };
        foreach (int si in Enumerable.Range(0, geometry.Mesh.GetSurfaceCount()))
        {
            mdt.CreateFromSurface((ArrayMesh)geometry.Mesh, si);
            mdt2.CreateFromSurface((ArrayMesh)geometry.Mesh, si);
            //  foreach (int vertexIndex in Enumerable.Range(0, mdt.GetVertexCount()))
            Parallel.ForEach(Enumerable.Range(0, mdt.GetVertexCount()), options, vertexIndex =>
            {
                var vertexNormal = Vector3.Zero;
                var neighbors = GetNearestNeighbors(mdt2, vertexIndex);
                foreach (int neighbor in neighbors)
                    vertexNormal += mdt2.GetVertexNormal(neighbor);
                vertexNormal = vertexNormal / (float)neighbors.Length;
                mdt.SetVertexNormal(vertexIndex, vertexNormal.Normalized());
            });
            mdt.CommitToSurface(mesh);
        }
        var result = new MeshInstance();
        result.Mesh = mesh;
        return result;
    }

    public static MeshInstance ParallelLinqSmooth(MeshInstance geometry, float thresholdDegrees = 0.0f)
    {
        var mesh = new ArrayMesh();
        var mdt = new MeshDataTool();
        var mdt2 = new MeshDataTool();
        var options = new ParallelOptions { MaxDegreeOfParallelism = 6 };
        foreach (int si in Enumerable.Range(0, geometry.Mesh.GetSurfaceCount()))
        {
            mdt.CreateFromSurface((ArrayMesh)geometry.Mesh, si);
            mdt2.CreateFromSurface((ArrayMesh)geometry.Mesh, si);
            //  foreach (int vertexIndex in Enumerable.Range(0, mdt.GetVertexCount()))
            //Parallel.ForEach(Enumerable.Range(0, mdt.GetVertexCount()), options, vertexIndex =>
            var parallel = Enumerable.Range(0, mdt.GetVertexCount()).AsParallel();
            parallel.ForAll(vertexIndex =>
            {
                var vertexNormal = Vector3.Zero;
                var neighbors = GetNearestNeighbors(mdt2, vertexIndex);
                foreach (int neighbor in neighbors)
                    vertexNormal += mdt2.GetVertexNormal(neighbor);
                vertexNormal = vertexNormal / (float)neighbors.Length;
                mdt.SetVertexNormal(vertexIndex, vertexNormal.Normalized());
            });
            mdt.CommitToSurface(mesh);
        }
        var result = new MeshInstance();
        result.Mesh = mesh;
        return result;
    }

    // Consider to perform first look up to get all the topology, so if a == c, when it takes the turn to look up for c is 
    // already in the lookup table, so if doesn't have to iterate for all vertices in the mesh.
    // https://answers.unity.com/questions/1615363/how-to-find-connecting-mesh-triangles.html
    public static int[] GetNearestNeighbors(MeshDataTool mdt, int vertexIndex, float distance = 0.0f)
    {
        var neighbors = new List<int>();
        foreach (int p in getNearestPoints(mdt, vertexIndex))
            foreach (int edgeIndex in mdt.GetVertexEdges(p))
                for (int i = 0; i < 2; i++)
                {
                    var ev = mdt.GetEdgeVertex(edgeIndex, i);
                    if (ev != p)
                        neighbors.Add(ev);
                }
        return neighbors.ToArray();
    }

    private static int[] getNearestPoints(MeshDataTool mdt, int vertexIndex, float threshold = 0.0f, bool excludeSource = false)
    {
        var result = new List<int>();
        var source = mdt.GetVertex(vertexIndex);
        foreach (int i in Enumerable.Range(0, mdt.GetVertexCount()))
        {
            if (i == vertexIndex && excludeSource)
                continue;
            var vector = source - mdt.GetVertex(i);
            if (Math.Abs(vector.Length()) <= threshold)
                result.Add(i);
        }
        return result.ToArray();
    }

    private static Vector2 getMiddleUV(MeshDataTool mdt, int vi1, int vi2)
    {
        var uv1 = mdt.GetVertexUv(vi1);
        var uv2 = mdt.GetVertexUv(vi2);
        return (uv1 + uv2) * 0.5f;
    }

    private static Vector3 getMiddlePoint(MeshDataTool mdt, int vi1, int vi2)
    {
        var v1 = mdt.GetVertex(vi1);
        var v2 = mdt.GetVertex(vi2);
        return (v1 + v2) * 0.5f;
    }

    private static Vector3 getMiddleNormal(MeshDataTool mdt, int vi1, int vi2)
    {
        var v1 = mdt.GetVertexNormal(vi1);
        var v2 = mdt.GetVertexNormal(vi2);
        return ((v1 + v2) * 0.5f).Normalized();
    }

    private static void triangulate(SurfaceTool surfaceTool, int i1, int i2, int i3)
    {
        surfaceTool.AddIndex(i1);
        surfaceTool.AddIndex(i2);
        surfaceTool.AddIndex(i3);
    }

    public static MeshInstance CreateQuad()
    {
        var vertices = new List<Vector3>();
        vertices.Add(new Vector3(0, 0, 0));
        vertices.Add(new Vector3(16, 0, 0));
        vertices.Add(new Vector3(16, 0, 16));
        vertices.Add(new Vector3(0, 0, 16));

        var colors = new List<Color>();
        colors.Add(new Color(1, 1, 1, 1));
        colors.Add(new Color(1, 1, 1, 1));
        colors.Add(new Color(1, 1, 1, 1));
        colors.Add(new Color(1, 1, 1, 1));

        var uvs = new List<Vector2>();
        uvs.Add(new Vector2(0, 0));
        uvs.Add(new Vector2(1, 0));
        uvs.Add(new Vector2(1, 1));
        uvs.Add(new Vector2(0, 1));

        var indices = new List<int> { 0, 2, 3, 0, 1, 2 };
        //var indices = new Array<int>() {0,2,3, 0,1,2};

        var array_mesh = new ArrayMesh();
        var arrays = new Godot.Collections.Array();
        arrays.Resize((int)ArrayMesh.ArrayType.Max);
        arrays[(int)ArrayMesh.ArrayType.Vertex] = vertices.ToArray();
        arrays[(int)ArrayMesh.ArrayType.TexUv] = uvs.ToArray();
        arrays[(int)ArrayMesh.ArrayType.Color] = colors.ToArray();
        arrays[(int)ArrayMesh.ArrayType.Index] = indices.ToArray();

        array_mesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, arrays);

        return new MeshInstance { Mesh = array_mesh };

    }

    public static MeshInstance CreateQuad2()
    {
        var vertices = new Vector3[4];
        vertices[0] = new Vector3(0, 0, 0); vertices[1] = new Vector3(16, 0, 0);
        vertices[2] = new Vector3(16, 0, 16); vertices[3] = new Vector3(0, 0, 16);

        var colors = new Color[4];
        colors[0] = new Color(1, 1, 1, 1); colors[1] = new Color(1, 1, 1, 1);
        colors[2] = new Color(1, 1, 1, 1); colors[3] = new Color(1, 1, 1, 1);

        var uvs = new Vector2[4];
        uvs[0] = new Vector2(0, 0); uvs[1] = new Vector2(1, 0);
        uvs[2] = new Vector2(1, 1); uvs[3] = new Vector2(0, 1);

        var indices = new int[] { 0, 2, 3, 0, 1, 2 };
        //var indices = new Array<int>() {0,2,3, 0,1,2};

        var array_mesh = new ArrayMesh();
        var arrays = new Godot.Collections.Array();
        arrays.Resize((int)ArrayMesh.ArrayType.Max);
        arrays[(int)ArrayMesh.ArrayType.Vertex] = vertices;
        arrays[(int)ArrayMesh.ArrayType.TexUv] = uvs;
        arrays[(int)ArrayMesh.ArrayType.Color] = colors;
        arrays[(int)ArrayMesh.ArrayType.Index] = indices;

        array_mesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, arrays);

        return new MeshInstance { Mesh = array_mesh };

    }

}
