class DMesh_Harobed_Brush588 expands DMeshBase;

#exec mesh import mesh=Mesh_Harobed_Brush588 anivfile=Models\Mesh_Harobed_Brush588_a.3d datafile=Models\Mesh_Harobed_Brush588_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_Harobed_Brush588 x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_Harobed_Brush588 seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_Harobed_Brush588 mesh=Mesh_Harobed_Brush588
#exec meshmap scale meshmap=Mesh_Harobed_Brush588 x=0.26104 y=0.26104 z=0.52209

defaultproperties
{
	Location=(X=3963.466553,Y=-1905.866699,Z=-1565.166626)
	Mesh=Mesh'Mesh_Harobed_Brush588'
	CollisionRadius=132.70431
	CollisionHeight=66.82703
}
