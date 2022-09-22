class DMesh_Dig_Brush1259 extends DMeshBase;

#exec mesh import mesh=Mesh_Dig_Brush1259 anivfile=Models\Mesh_Dig_Brush1259_a.3d datafile=Models\Mesh_Dig_Brush1259_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_Dig_Brush1259 x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_Dig_Brush1259 seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_Dig_Brush1259 mesh=Mesh_Dig_Brush1259
#exec meshmap scale meshmap=Mesh_Dig_Brush1259 x=1.00000 y=1.00000 z=2.00000

defaultproperties
{
	Location=(X=-244.000000,Y=-656.000000,Z=-720.000000)
	Mesh=Mesh'Mesh_Dig_Brush1259'
	CollisionRadius=137.54005
	CollisionHeight=256.00000
}
