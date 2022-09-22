class DMesh_SkyTown_Brush1020 extends DMeshBase;

#exec mesh import mesh=Mesh_SkyTown_Brush1020 anivfile=Models\Mesh_SkyTown_Brush1020_a.3d datafile=Models\Mesh_SkyTown_Brush1020_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_SkyTown_Brush1020 x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_SkyTown_Brush1020 seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_SkyTown_Brush1020 mesh=Mesh_SkyTown_Brush1020
#exec meshmap scale meshmap=Mesh_SkyTown_Brush1020 x=0.78125 y=0.78125 z=1.56250

defaultproperties
{
	Location=(X=-944.000000,Y=3904.000000,Z=2352.000000)
	Mesh=Mesh'Mesh_SkyTown_Brush1020'
	CollisionRadius=400.00000
	CollisionHeight=16.00000
}
