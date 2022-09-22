class DMesh_Velora_Brush440 extends DMeshBase;

#exec mesh import mesh=Mesh_Velora_Brush440 anivfile=Models\Mesh_Velora_Brush440_a.3d datafile=Models\Mesh_Velora_Brush440_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_Velora_Brush440 x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_Velora_Brush440 seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_Velora_Brush440 mesh=Mesh_Velora_Brush440
#exec meshmap scale meshmap=Mesh_Velora_Brush440 x=0.25000 y=0.25000 z=0.50000

defaultproperties
{
	Location=(X=-3264.000000,Y=-10496.000000,Z=-896.000000)
	Mesh=Mesh'Mesh_Velora_Brush440'
	CollisionRadius=128.00000
	CollisionHeight=64.00000
}
