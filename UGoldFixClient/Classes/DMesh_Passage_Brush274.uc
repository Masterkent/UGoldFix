class DMesh_Passage_Brush274 extends DMeshBase;

#exec mesh import mesh=Mesh_Passage_Brush274 anivfile=Models\Mesh_Passage_Brush274_a.3d datafile=Models\Mesh_Passage_Brush274_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_Passage_Brush274 x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_Passage_Brush274 seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_Passage_Brush274 mesh=Mesh_Passage_Brush274
#exec meshmap scale meshmap=Mesh_Passage_Brush274 x=0.50000 y=0.50000 z=1.00000

defaultproperties
{
	Location=(X=4512.000000,Y=4832.000000,Z=510.000000)
	Mesh=Mesh'Mesh_Passage_Brush274'
	CollisionRadius=64.00000
	CollisionHeight=128.00000
}
