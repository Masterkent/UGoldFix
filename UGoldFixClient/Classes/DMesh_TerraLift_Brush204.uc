class DMesh_TerraLift_Brush204 extends DMeshBase;

#exec mesh import mesh=Mesh_TerraLift_Brush204 anivfile=Models\Mesh_TerraLift_Brush204_a.3d datafile=Models\Mesh_TerraLift_Brush204_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_TerraLift_Brush204 x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_TerraLift_Brush204 seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_TerraLift_Brush204 mesh=Mesh_TerraLift_Brush204
#exec meshmap scale meshmap=Mesh_TerraLift_Brush204 x=0.50000 y=0.50000 z=1.00000

defaultproperties
{
	Location=(X=-752.000000,Y=-32.000000,Z=0.000000)
	Mesh=Mesh'Mesh_TerraLift_Brush204'
	CollisionRadius=128.00001
	CollisionHeight=128.00000
}
