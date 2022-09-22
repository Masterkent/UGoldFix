class DMesh_SkyTown_Brush1845 extends DMeshBase;

#exec mesh import mesh=Mesh_SkyTown_Brush1845 anivfile=Models\Mesh_SkyTown_Brush1845_a.3d datafile=Models\Mesh_SkyTown_Brush1845_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_SkyTown_Brush1845 x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_SkyTown_Brush1845 seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_SkyTown_Brush1845 mesh=Mesh_SkyTown_Brush1845
#exec meshmap scale meshmap=Mesh_SkyTown_Brush1845 x=0.25000 y=0.25000 z=0.50000

defaultproperties
{
	Location=(X=-4288.000000,Y=-768.000000,Z=2224.000000)
	Mesh=Mesh'Mesh_SkyTown_Brush1845'
	CollisionRadius=48.50000
	CollisionHeight=64.00000
}
