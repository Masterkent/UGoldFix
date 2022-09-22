class DMesh_Harobed_Brush370 extends DMeshBase;

#exec mesh import mesh=Mesh_Harobed_Brush370 anivfile=Models\Mesh_Harobed_Brush370_a.3d datafile=Models\Mesh_Harobed_Brush370_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_Harobed_Brush370 x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_Harobed_Brush370 seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_Harobed_Brush370 mesh=Mesh_Harobed_Brush370
#exec meshmap scale meshmap=Mesh_Harobed_Brush370 x=0.18750 y=0.18750 z=0.37500

defaultproperties
{
	Location=(X=-3908.000000,Y=-1065.000000,Z=-816.000000)
	Mesh=Mesh'Mesh_Harobed_Brush370'
	CollisionRadius=60.214142
	CollisionHeight=48.000000
}
