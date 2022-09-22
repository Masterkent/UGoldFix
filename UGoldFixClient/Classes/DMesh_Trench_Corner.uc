class DMesh_Trench_Corner extends DMeshBase;

#exec mesh import mesh=Mesh_Trench_Corner anivfile=Models\Mesh_Trench_Corner_a.3d datafile=Models\Mesh_Trench_Corner_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_Trench_Corner x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_Trench_Corner seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_Trench_Corner mesh=Mesh_Trench_Corner
#exec meshmap scale meshmap=Mesh_Trench_Corner x=7.50000 y=7.50000 z=15.00000

defaultproperties
{
	Location=(X=17968.000000,Y=-4188.500000,Z=736.000000)
	Mesh=Mesh'Mesh_Trench_Corner'
	CollisionRadius=3200.000000
	CollisionHeight=1920.000000
}
