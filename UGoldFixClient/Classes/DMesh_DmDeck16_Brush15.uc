class DMesh_DmDeck16_Brush15 extends DMeshBase;

#exec mesh import mesh=Mesh_DmDeck16_Brush15 anivfile=Models\Mesh_DmDeck16_Brush15_a.3d datafile=Models\Mesh_DmDeck16_Brush15_d.3d x=0 y=0 z=0 mlod=0
#exec mesh origin mesh=Mesh_DmDeck16_Brush15 x=0 y=0 z=0
#exec mesh sequence mesh=Mesh_DmDeck16_Brush15 seq=All startframe=0 numframes=1

#exec meshmap new meshmap=Mesh_DmDeck16_Brush15 mesh=Mesh_DmDeck16_Brush15
#exec meshmap scale meshmap=Mesh_DmDeck16_Brush15 x=0.25000 y=0.25000 z=0.50000

var() vector Location_Brush15;
var() vector Location_Brush16;
var() vector Location_Brush17;
var() vector Location_Brush18;

defaultproperties
{
	Location_Brush15=(X=1056.000000,Y=1088.000000,Z=-384.000000)
	Location_Brush16=(X=736.000000,Y=1088.000000,Z=-384.000000)
	Location_Brush17=(X=416.000000,Y=1088.000000,Z=-384.000000)
	Location_Brush18=(X=1376.000000,Y=1088.000000,Z=-384.000000)
	Mesh=Mesh'Mesh_DmDeck16_Brush15'
	CollisionRadius=32.00000
	CollisionHeight=64.00000
}
