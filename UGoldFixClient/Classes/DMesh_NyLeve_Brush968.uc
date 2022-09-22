class DMesh_NyLeve_Brush968 extends DMeshBase;

#exec mesh import mesh=Mesh_NyLeve_Brush968 anivfile=Models\Mesh_NyLeve_Brush968_a.3d datafile=Models\Mesh_NyLeve_Brush968_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_NyLeve_Brush968 x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_NyLeve_Brush968 seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_NyLeve_Brush968 mesh=Mesh_NyLeve_Brush968
#exec meshmap scale meshmap=Mesh_NyLeve_Brush968 x=2.50000 y=2.50000 z=5.00000

defaultproperties
{
	Location=(X=-4128.000000,Y=-5416.000000,Z=-6262.000000)
	Mesh=Mesh'Mesh_NyLeve_Brush968'
	CollisionRadius=32.00000
	CollisionHeight=640.00000
}
